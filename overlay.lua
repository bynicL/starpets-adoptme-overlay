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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1286.87, ["Ride"] = 1236.11, ["Fly|Ride"] = 1771, ["Neon"] = 7187.73, ["Neon|Fly|Ride"] = 5305.7, ["Mega"] = 22695.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 575.36, ["Ride"] = 555.5, ["Fly|Ride"] = 618.75, ["Neon|Fly|Ride"] = 1993.75, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 8504.13}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5087.5, ["Ride"] = 4812.49, ["Fly|Ride"] = 4934.88, ["Neon|Fly|Ride"] = 18700, ["Mega|Fly|Ride"] = 75652.96}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 222.75, ["Fly"] = 247.5, ["Ride"] = 250.8, ["Fly|Ride"] = 513.42, ["Neon"] = 921.25, ["Neon|Ride"] = 1210.83, ["Neon|Fly|Ride"] = 962.5, ["Mega|Fly|Ride"] = 5129.26}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 662.74, ["Fly"] = 907.85, ["Ride"] = 585.51, ["Fly|Ride"] = 646.25, ["Neon|Fly|Ride"] = 2014.27, ["Mega|Fly|Ride"] = 6737.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 14.14, ["Ride"] = 61.87, ["Fly|Ride"] = 136.13, ["Neon"] = 84.51, ["Neon|Fly"] = 303, ["Neon|Ride"] = 109.99, ["Neon|Fly|Ride"] = 340.44, ["Mega"] = 370.59, ["Mega|Ride"] = 547.25, ["Mega|Fly|Ride"] = 634.35}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.11, ["Fly"] = 61.3, ["Ride"] = 34.06, ["Fly|Ride"] = 82.49, ["Neon"] = 37.13, ["Neon|Fly"] = 138.88, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 193.87, ["Mega|Ride"] = 226.88, ["Mega|Fly|Ride"] = 439.99}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 119.63, ["Fly"] = 226.98, ["Ride"] = 148.5, ["Fly|Ride"] = 194.72, ["Neon"] = 453.93, ["Neon|Ride"] = 515.63, ["Neon|Fly|Ride"] = 1237.5, ["Mega"] = 1662.38, ["Mega|Ride"] = 2611.13, ["Mega|Fly|Ride"] = 2269.6}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 39.78, ["Fly"] = 102.41, ["Ride"] = 49.39, ["Fly|Ride"] = 108.42, ["Neon"] = 288.74, ["Neon|Ride"] = 254.38, ["Neon|Fly|Ride"] = 323.13, ["Mega"] = 2200, ["Mega|Ride"] = 1270.98, ["Mega|Fly|Ride"] = 870.38}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.67, ["Fly"] = 51.35, ["Ride"] = 30.94, ["Fly|Ride"] = 74.87, ["Neon"] = 161.7, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 218.63, ["Mega"] = 680.88, ["Mega|Fly|Ride"] = 856.06}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 66.7, ["Fly"] = 226.88, ["Ride"] = 96.24, ["Fly|Ride"] = 205.39, ["Neon"] = 342.38, ["Neon|Ride"] = 332.45, ["Neon|Fly|Ride"] = 434.1, ["Mega|Fly|Ride"] = 1361.76}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 412.5, ["Fly"] = 499.71, ["Ride"] = 275, ["Fly|Ride"] = 412.5, ["Neon|Ride"] = 1544.1, ["Neon|Fly|Ride"] = 1237.5, ["Mega|Fly|Ride"] = 5432.24}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 116.49, ["Fly"] = 179.32, ["Ride"] = 138.75, ["Fly|Ride"] = 185.63, ["Neon|Fly"] = 718.78, ["Neon|Fly|Ride"] = 562.38, ["Mega"] = 4517.99, ["Mega|Fly|Ride"] = 2585}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.85, ["Fly"] = 82.79, ["Ride"] = 68.75, ["Fly|Ride"] = 137.5, ["Neon"] = 24.49, ["Neon|Ride"] = 60.5, ["Neon|Fly|Ride"] = 273.21, ["Mega"] = 166.38, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 342.72, ["Mega|Fly|Ride"] = 393.79}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 243.26, ["Fly"] = 298.38, ["Ride"] = 244.75, ["Fly|Ride"] = 275, ["Neon|Ride"] = 1465.69, ["Neon|Fly|Ride"] = 770, ["Mega|Fly|Ride"] = 2882}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 4.12, ["Fly"] = 28.45, ["Ride"] = 22, ["Fly|Ride"] = 42.67, ["Neon"] = 24.75, ["Neon|Fly"] = 86.01, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 171.88, ["Mega|Ride"] = 323.45, ["Mega|Fly|Ride"] = 420.61}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 137.39, ["Ride"] = 158.13, ["Fly|Ride"] = 343.75, ["Neon"] = 490.25, ["Neon|Ride"] = 515.21, ["Neon|Fly|Ride"] = 596.91, ["Mega"] = 1882.8, ["Mega|Ride"] = 1650, ["Mega|Fly|Ride"] = 1883.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 42.6}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 85.25, ["Ride"] = 193.88, ["Fly|Ride"] = 256, ["Neon"] = 605, ["Neon|Fly|Ride"] = 825, ["Mega|Fly|Ride"] = 1540.13}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 33, ["Fly"] = 412.5, ["Ride"] = 48.13, ["Fly|Ride"] = 453.93, ["Neon"] = 275, ["Neon|Ride"] = 367.68, ["Neon|Fly|Ride"] = 375.62, ["Mega"] = 1057.38, ["Mega|Ride"] = 1115.51, ["Mega|Fly|Ride"] = 1375}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.25, ["Fly"] = 115.77, ["Ride"] = 66.11, ["Fly|Ride"] = 119.9, ["Neon"] = 226.87, ["Neon|Ride"] = 204.88, ["Neon|Fly|Ride"] = 275, ["Mega"] = 1796.81, ["Mega|Fly|Ride"] = 938.67}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 47.19, ["Fly"] = 258.88, ["Ride"] = 89.38, ["Fly|Ride"] = 206.25, ["Neon"] = 167.96, ["Neon|Ride"] = 406.21, ["Neon|Fly|Ride"] = 330, ["Mega"] = 2061.13, ["Mega|Ride"] = 1815.68, ["Mega|Fly|Ride"] = 1632.98}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 52.23, ["Ride"] = 50.78, ["Fly|Ride"] = 117.57, ["Neon"] = 220, ["Neon|Ride"] = 313.7, ["Neon|Fly|Ride"] = 272.36, ["Mega"] = 1265.44, ["Mega|Fly|Ride"] = 1072.5}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 47.05, ["Fly"] = 152.08, ["Ride"] = 76.05, ["Fly|Ride"] = 136.13, ["Neon"] = 247.5, ["Neon|Ride"] = 245.03, ["Neon|Fly|Ride"] = 338.25, ["Mega|Ride"] = 1198.74, ["Mega|Fly|Ride"] = 1089.41}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.25, ["Fly"] = 36.03, ["Ride"] = 34.63, ["Fly|Ride"] = 64.52, ["Neon"] = 48.13, ["Neon|Fly"] = 285.99, ["Neon|Ride"] = 42.63, ["Neon|Fly|Ride"] = 105.85, ["Mega"] = 170.49, ["Mega|Fly"] = 28689.84, ["Mega|Ride"] = 236.49, ["Mega|Fly|Ride"] = 316.23}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 409.73, ["Ride"] = 435.6, ["Fly|Ride"] = 481.25, ["Neon|Ride"] = 1924.89, ["Neon|Fly|Ride"] = 1511.13, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 10182.72}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.24, ["Ride"] = 34.38, ["Fly|Ride"] = 133.45, ["Neon"] = 229.62, ["Mega|Ride"] = 862.46, ["Mega|Fly|Ride"] = 703.64}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.49, ["Fly"] = 45.38, ["Ride"] = 25.99, ["Fly|Ride"] = 48.12, ["Neon"] = 66, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 109.98, ["Mega|Ride"] = 348.39, ["Mega|Fly|Ride"] = 439.18}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 88.35, ["Fly"] = 125.29, ["Ride"] = 81.13, ["Fly|Ride"] = 118.03, ["Neon"] = 366.29, ["Neon|Fly"] = 410.74, ["Neon|Ride"] = 394.06, ["Neon|Fly|Ride"] = 419.67, ["Mega"] = 6800.89, ["Mega|Ride"] = 6110.5, ["Mega|Fly|Ride"] = 1856.25}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 16.98, ["Ride"] = 38.53, ["Fly|Ride"] = 80.88, ["Neon"] = 81.13, ["Neon|Ride"] = 120.56, ["Neon|Fly|Ride"] = 272.36, ["Mega"] = 754.88, ["Mega|Ride"] = 770.07, ["Mega|Fly|Ride"] = 566.27}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 233.75, ["Fly"] = 302.5, ["Ride"] = 262.63, ["Fly|Ride"] = 347.23, ["Neon"] = 762.43, ["Neon|Ride"] = 550, ["Neon|Fly|Ride"] = 756.93, ["Mega"] = 3630.2, ["Mega|Ride"] = 2895.12, ["Mega|Fly|Ride"] = 3252.22}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.91}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.01, ["Fly"] = 27.5, ["Ride"] = 26.13, ["Fly|Ride"] = 70.37, ["Neon"] = 23.52, ["Neon|Fly"] = 152.08, ["Neon|Ride"] = 46.74, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 156.35, ["Mega|Fly"] = 513.39, ["Mega|Ride"] = 549.99, ["Mega|Fly|Ride"] = 299.6}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 962.5, ["Fly"] = 2750, ["Ride"] = 893.75, ["Fly|Ride"] = 948.75, ["Neon"] = 5372.11, ["Neon|Ride"] = 5749.99, ["Neon|Fly|Ride"] = 5296.08, ["Mega|Ride"] = 57754.18, ["Mega|Fly|Ride"] = 19670.45}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.75, ["Fly"] = 58.04, ["Ride"] = 54.42, ["Fly|Ride"] = 111.23, ["Neon"] = 197.47, ["Neon|Ride"] = 288.25, ["Neon|Fly|Ride"] = 224.7, ["Mega"] = 1086.25, ["Mega|Ride"] = 1165.44, ["Mega|Fly|Ride"] = 1193.81}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 225, ["Fly"] = 385.09, ["Ride"] = 247.47, ["Fly|Ride"] = 343.75, ["Neon"] = 961.13, ["Neon|Ride"] = 935, ["Neon|Fly|Ride"] = 1079.37, ["Mega|Ride"] = 6363.5, ["Mega|Fly|Ride"] = 4085.25}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.38}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.02, ["Fly"] = 151.54, ["Ride"] = 125.13, ["Fly|Ride"] = 152.08, ["Neon"] = 68.75, ["Neon|Ride"] = 134.74, ["Neon|Fly|Ride"] = 495, ["Mega"] = 485.71, ["Mega|Ride"] = 603.56, ["Mega|Fly|Ride"] = 635.32}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 96.14, ["Fly"] = 169.97, ["Ride"] = 151.25, ["Fly|Ride"] = 229.63, ["Neon"] = 680.88, ["Neon|Ride"] = 423.5, ["Neon|Fly|Ride"] = 603.72, ["Mega"] = 2495.41, ["Mega|Ride"] = 2397.45, ["Mega|Fly|Ride"] = 1894.74}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 104.5, ["Fly"] = 164.99, ["Ride"] = 168.36, ["Fly|Ride"] = 250.86, ["Neon"] = 391.91, ["Neon|Fly"] = 605.99, ["Neon|Ride"] = 379.04, ["Neon|Fly|Ride"] = 511.8, ["Mega|Ride"] = 1581.25, ["Mega|Fly|Ride"] = 1574.38}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 37.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.73, ["Fly"] = 65.99, ["Ride"] = 57.73, ["Fly|Ride"] = 89.38, ["Neon|Ride"] = 416.49, ["Neon|Fly|Ride"] = 371.25, ["Mega"] = 4539.18, ["Mega|Fly|Ride"] = 1597.4}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.86, ["Ride"] = 52.22, ["Fly|Ride"] = 165, ["Neon"] = 44.27, ["Neon|Fly"] = 233.75, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 255.34, ["Mega"] = 195.25, ["Mega|Ride"] = 240.01, ["Mega|Fly|Ride"] = 453.93}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 625.63, ["Fly"] = 787.56, ["Ride"] = 586.95, ["Fly|Ride"] = 550, ["Neon|Fly"] = 4085.25, ["Neon|Ride"] = 4069.91, ["Neon|Fly|Ride"] = 2068.03, ["Mega|Ride"] = 15887.05, ["Mega|Fly|Ride"] = 7837.5}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 126.7, ["Fly"] = 178.75, ["Ride"] = 139.13, ["Fly|Ride"] = 231.05, ["Neon"] = 522.5, ["Neon|Ride"] = 605.99, ["Neon|Fly|Ride"] = 550, ["Mega"] = 2723.51, ["Mega|Ride"] = 2723.51, ["Mega|Fly|Ride"] = 2406.25}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4262.5, ["Ride"] = 4070, ["Fly|Ride"] = 4125, ["Neon|Fly|Ride"] = 15885.92}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 63.96, ["Fly"] = 121.43, ["Ride"] = 103.12, ["Fly|Ride"] = 167.96, ["Neon"] = 344.99, ["Neon|Ride"] = 379.04, ["Neon|Fly|Ride"] = 529.38, ["Mega"] = 2269.6, ["Mega|Ride"] = 2122.07, ["Mega|Fly|Ride"] = 2103.92}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 77.52, ["Ride"] = 75.63, ["Fly|Ride"] = 137.91, ["Neon"] = 603.17, ["Neon|Ride"] = 448.25, ["Neon|Fly|Ride"] = 451.66, ["Mega"] = 6657.82, ["Mega|Ride"] = 2502.5, ["Mega|Fly|Ride"] = 2268.68}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.19, ["Fly"] = 70.13, ["Ride"] = 50.6, ["Fly|Ride"] = 110, ["Neon"] = 159.49, ["Neon|Fly"] = 165, ["Neon|Ride"] = 152.08, ["Neon|Fly|Ride"] = 213.76, ["Mega"] = 2750, ["Mega|Ride"] = 947.57, ["Mega|Fly|Ride"] = 604.99}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 60.5, ["Fly"] = 412.5, ["Ride"] = 67.72, ["Fly|Ride"] = 137.35, ["Neon|Ride"] = 342.69, ["Neon|Fly|Ride"] = 635.5, ["Mega|Ride"] = 1369.44, ["Mega|Fly|Ride"] = 1433.25}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.37}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 229.09, ["Ride"] = 220, ["Fly|Ride"] = 295.63, ["Neon"] = 1210.83, ["Neon|Ride"] = 1210.83, ["Neon|Fly|Ride"] = 1359.49, ["Mega|Fly|Ride"] = 5133.73}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 749.27, ["Fly"] = 851.1, ["Ride"] = 752.12, ["Fly|Ride"] = 837.35, ["Neon"] = 2750, ["Neon|Fly|Ride"] = 2750, ["Mega|Fly|Ride"] = 11801.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 8.08}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 37.21, ["Fly"] = 59.06, ["Ride"] = 41.25, ["Fly|Ride"] = 67.36, ["Neon"] = 258.5, ["Neon|Fly"] = 285.99, ["Neon|Ride"] = 204.88, ["Neon|Fly|Ride"] = 219.45, ["Mega"] = 2269.6, ["Mega|Ride"] = 1229.02, ["Mega|Fly|Ride"] = 753.5}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.63}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5500, ["Ride"] = 8322.56, ["Fly|Ride"] = 5500, ["Neon|Ride"] = 18826.71, ["Neon|Fly|Ride"] = 11343.2, ["Mega|Fly|Ride"] = 43121.97}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11, ["Fly"] = 152.08, ["Ride"] = 27.42, ["Fly|Ride"] = 83.88, ["Neon"] = 92.13, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 211.08, ["Mega"] = 588.5, ["Mega|Ride"] = 514.25, ["Mega|Fly|Ride"] = 543.13}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.75, ["Fly"] = 148.67, ["Ride"] = 41.25, ["Fly|Ride"] = 127.08, ["Neon"] = 96.25, ["Neon|Ride"] = 133.92, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 907.85, ["Mega|Ride"] = 536.25, ["Mega|Fly|Ride"] = 1134.81}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 78.59, ["Ride"] = 96.25, ["Fly|Ride"] = 89.38, ["Neon|Ride"] = 424.43, ["Neon|Fly|Ride"] = 508.95, ["Mega"] = 4539.18, ["Mega|Fly|Ride"] = 1882.8}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.96, ["Fly"] = 76.05, ["Ride"] = 38.48, ["Fly|Ride"] = 82.5, ["Neon"] = 97.52, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 330, ["Mega"] = 581.02, ["Mega|Ride"] = 804.73, ["Mega|Fly|Ride"] = 838.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1650, ["Fly"] = 2099.38, ["Ride"] = 1940.4, ["Fly|Ride"] = 1746.24, ["Neon|Fly|Ride"] = 3437.5, ["Mega|Fly|Ride"] = 13062.5}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 28875, ["Fly"] = 36313.25, ["Ride"] = 35558.62, ["Fly|Ride"] = 29376.88, ["Neon|Ride"] = 68750, ["Neon|Fly|Ride"] = 66000, ["Mega|Fly|Ride"] = 192498.63}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.14, ["Fly"] = 412.5, ["Ride"] = 57.11, ["Fly|Ride"] = 126.49, ["Neon"] = 225.01, ["Neon|Ride"] = 218.63, ["Neon|Fly|Ride"] = 620.75, ["Mega"] = 793.23, ["Mega|Ride"] = 1369.44, ["Mega|Fly|Ride"] = 1609.44}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.39, ["Fly"] = 108.95, ["Ride"] = 54.99, ["Fly|Ride"] = 171.88, ["Neon"] = 23.38, ["Neon|Fly"] = 152.08, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 178.75, ["Mega"] = 165, ["Mega|Fly"] = 410.72, ["Mega|Ride"] = 244.75, ["Mega|Fly|Ride"] = 316.25}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.24}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.13, ["Ride"] = 63.25, ["Fly|Ride"] = 137.5, ["Neon"] = 59.13, ["Neon|Ride"] = 121.43, ["Neon|Fly|Ride"] = 290.29, ["Mega"] = 435.78, ["Mega|Ride"] = 423.5, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 840.68, ["Ride"] = 705.12, ["Fly|Ride"] = 759, ["Neon"] = 3252.46, ["Neon|Ride"] = 2475, ["Neon|Fly|Ride"] = 2750, ["Mega|Fly|Ride"] = 10866.79}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 984.28, ["Fly"] = 1127.39, ["Ride"] = 974.88, ["Fly|Ride"] = 1045, ["Neon|Ride"] = 3423.17, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 14374.39}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13.75, ["Fly"] = 128.37, ["Ride"] = 36.18, ["Fly|Ride"] = 95.34, ["Neon"] = 92.13, ["Neon|Ride"] = 82.48, ["Neon|Fly|Ride"] = 170.5, ["Mega"] = 520.17, ["Mega|Ride"] = 504.85, ["Mega|Fly|Ride"] = 481.25}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.58}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 83.59, ["Fly"] = 95.34, ["Ride"] = 95.72, ["Fly|Ride"] = 151.25, ["Neon"] = 394.92, ["Neon|Ride"] = 374.66, ["Neon|Fly|Ride"] = 431.25, ["Mega"] = 20625, ["Mega|Ride"] = 2119.79, ["Mega|Fly|Ride"] = 12834.27}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 107.25, ["Ride"] = 127.88, ["Fly|Ride"] = 137.5, ["Neon"] = 471.63, ["Neon|Ride"] = 443.99, ["Neon|Fly|Ride"] = 580.14, ["Mega"] = 1476.81, ["Mega|Ride"] = 2042.63, ["Mega|Fly|Ride"] = 2254.85}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.5, ["Fly"] = 34.67, ["Ride"] = 26.67, ["Fly|Ride"] = 55, ["Neon"] = 52.25, ["Neon|Fly"] = 511.96, ["Neon|Ride"] = 104.43, ["Neon|Fly|Ride"] = 116.2, ["Mega|Ride"] = 711.54, ["Mega|Fly|Ride"] = 702.05}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 166.38, ["Fly"] = 202.13, ["Ride"] = 202.27, ["Fly|Ride"] = 281.88, ["Neon|Ride"] = 508.75, ["Neon|Fly|Ride"] = 618.75, ["Mega"] = 5447, ["Mega|Ride"] = 3936.29, ["Mega|Fly|Ride"] = 2748.62}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.82, ["Ride"] = 50.87, ["Fly|Ride"] = 148.5, ["Neon"] = 41.24, ["Neon|Ride"] = 165, ["Mega"] = 261.25, ["Mega|Fly"] = 1192.13, ["Mega|Ride"] = 358.31, ["Mega|Fly|Ride"] = 499.13}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.75, ["Ride"] = 41.16, ["Fly|Ride"] = 68.4, ["Neon"] = 132, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 151.12, ["Mega|Fly|Ride"] = 828.4}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.88, ["Ride"] = 60.5, ["Fly|Ride"] = 155.45, ["Neon"] = 237.29, ["Neon|Ride"] = 220.41, ["Mega"] = 1045, ["Mega|Ride"] = 893.75, ["Mega|Fly|Ride"] = 1060.03}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.98, ["Fly"] = 61.3, ["Ride"] = 39.1, ["Fly|Ride"] = 83.26, ["Neon"] = 137.5, ["Neon|Ride"] = 147.54, ["Neon|Fly|Ride"] = 343.86, ["Mega"] = 1323.17, ["Mega|Fly|Ride"] = 1168.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7107.38, ["Ride"] = 5912.5, ["Fly|Ride"] = 5933.13, ["Neon"] = 37827.05, ["Neon|Ride"] = 30250, ["Neon|Fly|Ride"] = 31623.17}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 220, ["Fly"] = 261.25, ["Ride"] = 255.75, ["Fly|Ride"] = 328.62, ["Neon"] = 679.76, ["Neon|Fly"] = 726.28, ["Neon|Fly|Ride"] = 674.01, ["Mega|Fly|Ride"] = 2062.5}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 68.64, ["Fly"] = 178.64, ["Ride"] = 116.6, ["Fly|Ride"] = 237.88, ["Neon"] = 203.5, ["Neon|Ride"] = 262.63, ["Neon|Fly|Ride"] = 364.38, ["Mega"] = 508.53, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 669.63}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.2, ["Fly"] = 95, ["Ride"] = 23.75, ["Fly|Ride"] = 85.24, ["Neon"] = 20.63, ["Neon|Fly"] = 90.8, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 103.13, ["Mega"] = 523.6, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 273.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 68.72, ["Fly"] = 225.59, ["Ride"] = 152.08, ["Fly|Ride"] = 295.06, ["Neon"] = 209, ["Neon|Ride"] = 273.63, ["Neon|Fly|Ride"] = 407, ["Mega"] = 527.4, ["Mega|Fly"] = 771.68, ["Mega|Ride"] = 467.5, ["Mega|Fly|Ride"] = 755.78}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 17400.87, ["Ride"] = 14053.88, ["Fly|Ride"] = 12370.88, ["Neon|Fly|Ride"] = 25946.25, ["Mega|Fly|Ride"] = 98348.73}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 298.38, ["Ride"] = 357.5, ["Fly|Ride"] = 583, ["Neon|Ride"] = 2269.6, ["Neon|Fly|Ride"] = 1740.78, ["Mega|Fly|Ride"] = 9078.32}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 53.63, ["Fly"] = 85.12, ["Ride"] = 67.25, ["Fly|Ride"] = 116.88, ["Neon"] = 312.09, ["Neon|Ride"] = 343.73, ["Neon|Fly|Ride"] = 404.28, ["Mega|Fly|Ride"] = 2117.53}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.28, ["Ride"] = 29.31, ["Fly|Ride"] = 64.63, ["Neon"] = 61.87, ["Neon|Fly"] = 342.71, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 165, ["Mega"] = 515.63, ["Mega|Ride"] = 770.07, ["Mega|Fly|Ride"] = 511.8}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 411.13, ["Ride"] = 440, ["Fly|Ride"] = 494.99, ["Neon"] = 1802.07, ["Neon|Ride"] = 1511.13, ["Neon|Fly|Ride"] = 1374.99, ["Mega|Fly|Ride"] = 4764.38}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.78, ["Ride"] = 61.78, ["Fly|Ride"] = 212.23, ["Neon"] = 31.63, ["Neon|Ride"] = 97.61, ["Neon|Fly|Ride"] = 171.88, ["Mega"] = 166.38, ["Mega|Fly"] = 326, ["Mega|Ride"] = 237.88, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 106.95, ["Fly"] = 175.91, ["Ride"] = 165.35, ["Fly|Ride"] = 209, ["Neon"] = 630.22, ["Neon|Fly"] = 550, ["Neon|Ride"] = 481.25, ["Neon|Fly|Ride"] = 547.25, ["Mega|Fly|Ride"] = 2421.65}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.23, ["Fly"] = 23.38, ["Ride"] = 20.16, ["Fly|Ride"] = 38.49, ["Neon"] = 121.43, ["Neon|Ride"] = 206.24, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 2723.51, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.25}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 82.5, ["Ride"] = 92.13, ["Fly|Ride"] = 137.5, ["Neon"] = 342.71, ["Neon|Fly"] = 566.27, ["Neon|Ride"] = 426.25, ["Neon|Fly|Ride"] = 452.79, ["Mega|Ride"] = 2117.53, ["Mega|Fly|Ride"] = 1814.77}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.13, ["Fly"] = 83.88, ["Ride"] = 34.38, ["Fly|Ride"] = 109.99, ["Neon"] = 96.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 181.5, ["Mega"] = 611.66, ["Mega|Ride"] = 605, ["Mega|Fly|Ride"] = 943.34}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 34.38}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 79.74, ["Fly"] = 152.08, ["Ride"] = 123.75, ["Fly|Ride"] = 453.93, ["Neon"] = 273.63, ["Neon|Ride"] = 416.49, ["Neon|Fly|Ride"] = 566.27, ["Mega|Fly|Ride"] = 2156.11}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.13, ["Ride"] = 30.63, ["Fly|Ride"] = 144.38, ["Neon"] = 22.88, ["Neon|Ride"] = 148.67, ["Neon|Fly|Ride"] = 303, ["Mega"] = 136.18, ["Mega|Ride"] = 165, ["Mega|Fly|Ride"] = 338.95}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.38, ["Fly"] = 59.13, ["Ride"] = 35.19, ["Fly|Ride"] = 75.63, ["Neon"] = 137.5, ["Neon|Ride"] = 136.13, ["Neon|Fly|Ride"] = 225.83, ["Mega|Ride"] = 440, ["Mega|Fly|Ride"] = 566.27}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 563.58, ["Fly"] = 567.42, ["Ride"] = 521.13, ["Fly|Ride"] = 522.48, ["Neon|Fly|Ride"] = 2949.34, ["Mega|Fly|Ride"] = 16500}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 45.78, ["Fly"] = 113.49, ["Ride"] = 69.71, ["Fly|Ride"] = 103.82, ["Neon"] = 204.88, ["Neon|Ride"] = 193.8, ["Neon|Fly|Ride"] = 261.25, ["Mega"] = 813.4, ["Mega|Ride"] = 713.9, ["Mega|Fly|Ride"] = 753.52}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.69, ["Fly"] = 151.34, ["Ride"] = 67.38, ["Fly|Ride"] = 151.14, ["Neon"] = 247.5, ["Neon|Ride"] = 169.42, ["Neon|Fly|Ride"] = 338.84, ["Mega|Ride"] = 1116.65, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 22.62, ["Ride"] = 89.38, ["Fly|Ride"] = 130.63, ["Neon"] = 110.82, ["Neon|Ride"] = 150.03, ["Neon|Fly|Ride"] = 308.04, ["Mega"] = 424.43, ["Mega|Fly"] = 550, ["Mega|Ride"] = 552.67, ["Mega|Fly|Ride"] = 602.25}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11825, ["Fly"] = 11000, ["Ride"] = 9284, ["Fly|Ride"] = 8662.5, ["Neon|Fly|Ride"] = 16335, ["Mega|Fly|Ride"] = 40700}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1578.5, ["Fly"] = 1573.37, ["Ride"] = 1429.89, ["Fly|Ride"] = 1430, ["Neon|Fly|Ride"] = 4262.5, ["Mega|Fly|Ride"] = 25722.26}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 561, ["Ride"] = 412.5, ["Fly|Ride"] = 756.02, ["Neon"] = 2360.89, ["Neon|Fly|Ride"] = 3231.25, ["Mega"] = 22695.78, ["Mega|Fly|Ride"] = 10450}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.59, ["Fly"] = 30.66, ["Ride"] = 21.99, ["Fly|Ride"] = 41.76, ["Neon"] = 95, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 127.08, ["Mega|Fly|Ride"] = 605}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.03, ["Fly"] = 82.49, ["Ride"] = 39.62, ["Fly|Ride"] = 208.83, ["Neon"] = 20.63, ["Neon|Ride"] = 55, ["Mega"] = 151.25, ["Mega|Ride"] = 212.08, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.62, ["Fly"] = 44.21, ["Ride"] = 57.2, ["Fly|Ride"] = 104.41, ["Neon"] = 250.8, ["Neon|Ride"] = 142.87, ["Neon|Fly|Ride"] = 185.63, ["Mega|Ride"] = 905.57, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.75, ["Fly"] = 27.5, ["Ride"] = 22.38, ["Fly|Ride"] = 40.81, ["Neon"] = 37.13, ["Neon|Fly"] = 90.75, ["Neon|Ride"] = 49.96, ["Neon|Fly|Ride"] = 119.63, ["Mega"] = 295.06, ["Mega|Ride"] = 220.17, ["Mega|Fly|Ride"] = 257.12}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 303, ["Fly"] = 451, ["Ride"] = 323.02, ["Fly|Ride"] = 402.92, ["Neon"] = 1712.24, ["Neon|Ride"] = 1210.83, ["Neon|Fly|Ride"] = 1100, ["Mega|Fly|Ride"] = 4647.35}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 17.88, ["Fly"] = 63.49, ["Ride"] = 44.2, ["Fly|Ride"] = 68.75, ["Neon"] = 151.24, ["Neon|Fly"] = 426.68, ["Neon|Ride"] = 167.27, ["Neon|Fly|Ride"] = 238.57, ["Mega"] = 907.85, ["Mega|Fly"] = 958.74, ["Mega|Ride"] = 687.5, ["Mega|Fly|Ride"] = 753.03}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.88, ["Fly"] = 23.37, ["Ride"] = 26.87, ["Fly|Ride"] = 48.09, ["Neon"] = 88.53, ["Neon|Fly"] = 128.24, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 1650, ["Mega|Ride"] = 646.87, ["Mega|Fly|Ride"] = 444.13}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 462.24, ["Fly"] = 1098.63, ["Ride"] = 605.99, ["Fly|Ride"] = 907.85, ["Mega|Fly|Ride"] = 10445.88}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1279.8, ["Fly"] = 1513.82, ["Ride"] = 1210, ["Fly|Ride"] = 1237.49, ["Neon"] = 5507.61, ["Neon|Fly|Ride"] = 3740, ["Mega|Fly|Ride"] = 14373.24}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 152.08, ["Fly"] = 152.08, ["Ride"] = 103.95, ["Fly|Ride"] = 114.24, ["Neon"] = 1017.5, ["Neon|Ride"] = 624.14, ["Neon|Fly|Ride"] = 515.63, ["Mega|Fly|Ride"] = 2986.55}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 185.63, ["Fly"] = 275, ["Ride"] = 220.41, ["Fly|Ride"] = 225.5, ["Neon|Ride"] = 770.13, ["Neon|Fly|Ride"] = 620.13, ["Mega|Ride"] = 9625, ["Mega|Fly|Ride"] = 2723.51}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 30.66, ["Fly"] = 130.52, ["Ride"] = 55, ["Fly|Ride"] = 108.95, ["Neon"] = 253.57, ["Neon|Ride"] = 252.01, ["Mega|Ride"] = 2269.6, ["Mega|Fly|Ride"] = 1148.68}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 412.5, ["Ride"] = 451.69, ["Fly|Ride"] = 515.21, ["Neon"] = 1278.75, ["Neon|Fly|Ride"] = 1361.76, ["Mega|Fly|Ride"] = 6052.99}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2062.5, ["Fly"] = 2572.57, ["Ride"] = 2062.39, ["Fly|Ride"] = 2139.83, ["Neon|Fly|Ride"] = 11347.89, ["Mega|Fly|Ride"] = 39189.43}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 39.19, ["Fly"] = 226.98, ["Ride"] = 54.91, ["Fly|Ride"] = 206.25, ["Neon"] = 302.5, ["Neon|Ride"] = 247.5, ["Neon|Fly|Ride"] = 360.25, ["Mega|Ride"] = 2496.55, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.38, ["Fly"] = 907.85, ["Ride"] = 648.96, ["Fly|Ride"] = 698.47, ["Neon"] = 1677.58, ["Neon|Ride"] = 1570.25, ["Neon|Fly|Ride"] = 1194.88, ["Mega|Fly|Ride"] = 3162.39}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48, ["Fly"] = 66.54, ["Ride"] = 57.75, ["Fly|Ride"] = 106.68, ["Neon|Ride"] = 350.63, ["Neon|Fly|Ride"] = 302.5, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.2, ["Fly"] = 43.99, ["Ride"] = 25.4, ["Fly|Ride"] = 60.5, ["Neon"] = 29.59, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 52.24, ["Neon|Fly|Ride"] = 110, ["Mega"] = 174.62, ["Mega|Fly"] = 261.25, ["Mega|Ride"] = 196.3, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 66.03, ["Ride"] = 88.53, ["Fly|Ride"] = 165, ["Neon"] = 206.14, ["Neon|Ride"] = 504.4, ["Neon|Fly|Ride"] = 453.93, ["Mega"] = 1661.35, ["Mega|Ride"] = 1815.68, ["Mega|Fly|Ride"] = 1800.92}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1038.13, ["Fly"] = 1247.15, ["Ride"] = 1017.5, ["Fly|Ride"] = 1086.25, ["Neon|Ride"] = 3631.35, ["Neon|Fly|Ride"] = 3231.25, ["Mega|Fly|Ride"] = 13919.34}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 756.25, ["Ride"] = 848.38, ["Fly|Ride"] = 952.1, ["Neon|Fly|Ride"] = 4538.03, ["Mega|Fly|Ride"] = 18156.63}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.74, ["Fly"] = 27.49, ["Ride"] = 23.19, ["Fly|Ride"] = 50.88, ["Neon"] = 96.25, ["Neon|Ride"] = 120.26, ["Neon|Fly|Ride"] = 179.21, ["Mega|Fly|Ride"] = 756.93}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 21.2, ["Ride"] = 43.12, ["Fly|Ride"] = 135.06, ["Neon"] = 149.81, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 149.81, ["Mega"] = 1815.68, ["Mega|Ride"] = 1053.1, ["Mega|Fly|Ride"] = 660}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.55, ["Fly"] = 74.25, ["Ride"] = 38.49, ["Fly|Ride"] = 151.25, ["Neon"] = 25.68, ["Neon|Fly"] = 341.59, ["Neon|Ride"] = 71.89, ["Neon|Fly|Ride"] = 211.08, ["Mega"] = 206.25, ["Mega|Fly"] = 599.38, ["Mega|Ride"] = 220, ["Mega|Fly|Ride"] = 504.63}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 50.88, ["Fly"] = 70.37, ["Ride"] = 53.9, ["Fly|Ride"] = 133.41, ["Neon"] = 212.23, ["Neon|Ride"] = 225.92, ["Neon|Fly|Ride"] = 230.38, ["Mega|Ride"] = 946.43, ["Mega|Fly|Ride"] = 1375}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 87.12, ["Ride"] = 855.88, ["Fly|Ride"] = 379.04, ["Neon"] = 433.13, ["Neon|Ride"] = 641.78, ["Neon|Fly|Ride"] = 728.75, ["Mega|Fly|Ride"] = 3011.75}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.5, ["Fly"] = 60.7, ["Ride"] = 37.71, ["Fly|Ride"] = 110, ["Neon"] = 89.38, ["Neon|Ride"] = 103.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 450.16, ["Mega|Ride"] = 380.14, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.01, ["Fly"] = 66, ["Ride"] = 44.83, ["Fly|Ride"] = 81.03, ["Neon"] = 225.83, ["Neon|Ride"] = 224.95, ["Neon|Fly|Ride"] = 225.97, ["Mega"] = 2156.11, ["Mega|Fly|Ride"] = 1455.41}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.13, ["Fly"] = 50.6, ["Ride"] = 20.44, ["Fly|Ride"] = 41.4, ["Neon"] = 30.11, ["Neon|Ride"] = 65.83, ["Neon|Fly|Ride"] = 104.43, ["Mega"] = 455.44, ["Mega|Ride"] = 513.39, ["Mega|Fly|Ride"] = 386.38}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.75, ["Fly"] = 57.75, ["Ride"] = 38.5, ["Fly|Ride"] = 34676.66, ["Neon"] = 52.16, ["Neon|Fly"] = 121.04, ["Neon|Ride"] = 77, ["Neon|Fly|Ride"] = 215.73, ["Mega"] = 385, ["Mega|Ride"] = 462.05, ["Mega|Fly|Ride"] = 591.25}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 53.53, ["Fly"] = 75.62, ["Ride"] = 55.99, ["Fly|Ride"] = 103.82, ["Neon"] = 152.08, ["Neon|Ride"] = 378.65, ["Neon|Fly|Ride"] = 285.52, ["Mega"] = 1574.79, ["Mega|Fly|Ride"] = 1126.11}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1466.23, ["Fly"] = 1906.47, ["Ride"] = 1430.07, ["Fly|Ride"] = 1486.38, ["Neon|Ride"] = 5134.1, ["Neon|Fly|Ride"] = 3643.75, ["Mega|Fly|Ride"] = 13175.24}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 506.83, ["Fly"] = 550, ["Ride"] = 501.88, ["Fly|Ride"] = 550, ["Neon|Ride"] = 2567.06, ["Neon|Fly|Ride"] = 2475, ["Mega"] = 15887.05, ["Mega|Fly|Ride"] = 10592.14}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.75, ["Ride"] = 343.75, ["Fly|Ride"] = 440, ["Neon"] = 1650, ["Neon|Ride"] = 1538.63, ["Neon|Fly|Ride"] = 1718.75, ["Mega|Fly|Ride"] = 8170.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42.62}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 50.82, ["Ride"] = 58.57, ["Fly|Ride"] = 115.49, ["Neon"] = 340.44, ["Neon|Fly"] = 303, ["Neon|Ride"] = 261.01, ["Neon|Fly|Ride"] = 2062.5, ["Mega|Ride"] = 1248.28, ["Mega|Fly|Ride"] = 1021.32}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 74250, ["Fly"] = 28748.76, ["Ride"] = 39363.77, ["Fly|Ride"] = 17457, ["Neon|Fly|Ride"] = 39598.63, ["Mega"] = 226957.7, ["Mega|Fly|Ride"] = 93500}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 250.25, ["Fly"] = 298.27, ["Ride"] = 268.13, ["Fly|Ride"] = 327.24, ["Neon"] = 824.99, ["Neon|Fly"] = 893.75, ["Neon|Ride"] = 962.39, ["Neon|Fly|Ride"] = 962.49, ["Mega"] = 6808.74, ["Mega|Fly|Ride"] = 3437.5}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 123.75, ["Fly"] = 550, ["Ride"] = 303, ["Fly|Ride"] = 274.99}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 121.43, ["Fly"] = 169.13, ["Ride"] = 116.88, ["Fly|Ride"] = 188.29, ["Neon|Ride"] = 753.49, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 3177.42}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.68, ["Fly"] = 68.11, ["Ride"] = 36.33, ["Fly|Ride"] = 79.45, ["Neon"] = 86.01, ["Neon|Ride"] = 163.42, ["Neon|Fly|Ride"] = 181.59, ["Mega"] = 767.51, ["Mega|Ride"] = 756.93, ["Mega|Fly|Ride"] = 923.74}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5288.12, ["Ride"] = 4125, ["Fly|Ride"] = 4400, ["Neon"] = 22695.78, ["Neon|Fly|Ride"] = 16500, ["Mega|Fly|Ride"] = 85562.18}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 31.16, ["Fly"] = 46.44, ["Ride"] = 35.17, ["Fly|Ride"] = 64.28, ["Neon"] = 137.5, ["Neon|Ride"] = 225.83, ["Neon|Fly|Ride"] = 177.05, ["Mega|Ride"] = 1513.82, ["Mega|Fly|Ride"] = 825}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.8, ["Ride"] = 60.41, ["Fly|Ride"] = 89.36, ["Neon"] = 301.13, ["Neon|Fly"] = 272.36, ["Neon|Ride"] = 212.45, ["Neon|Fly|Ride"] = 327.25, ["Mega|Fly|Ride"] = 1508.38}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 398.75, ["Fly"] = 589.87, ["Ride"] = 475.9, ["Fly|Ride"] = 548.62, ["Neon"] = 1210, ["Neon|Ride"] = 1237.5, ["Neon|Fly|Ride"] = 1507, ["Mega|Fly|Ride"] = 4507.42}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.34, ["Fly"] = 32.1, ["Ride"] = 26.03, ["Fly|Ride"] = 60.34, ["Neon"] = 137.5, ["Neon|Ride"] = 116.47, ["Neon|Fly|Ride"] = 165, ["Mega|Ride"] = 825, ["Mega|Fly|Ride"] = 640.33}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.28, ["Fly"] = 303, ["Ride"] = 36.21, ["Fly|Ride"] = 86.01, ["Neon"] = 96.25, ["Neon|Ride"] = 137.39, ["Neon|Fly|Ride"] = 221.27, ["Mega|Ride"] = 398.75, ["Mega|Fly|Ride"] = 770.07}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 106.68, ["Ride"] = 110.7, ["Fly|Ride"] = 257.13, ["Neon"] = 770.13, ["Neon|Ride"] = 536.25, ["Neon|Fly|Ride"] = 773.93, ["Mega|Fly|Ride"] = 2738.85}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 17.88, ["Fly"] = 565.01, ["Ride"] = 78.28, ["Fly|Ride"] = 151.24, ["Neon"] = 89.01, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 296.77, ["Mega"] = 329.1, ["Mega|Fly"] = 787.56, ["Mega|Ride"] = 339.63, ["Mega|Fly|Ride"] = 515.63}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4468.75, ["Fly"] = 6845.96, ["Ride"] = 4124.99, ["Fly|Ride"] = 4214.65, ["Neon"] = 20625, ["Neon|Ride"] = 12925, ["Neon|Fly|Ride"] = 10972.5, ["Mega"] = 51444.52, ["Mega|Fly|Ride"] = 39752.63}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 35.74, ["Fly"] = 152.08, ["Ride"] = 54.45, ["Fly|Ride"] = 173.29, ["Neon"] = 233.75, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 270.88, ["Neon|Fly|Ride"] = 261.25, ["Mega"] = 907.85, ["Mega|Ride"] = 1882.8, ["Mega|Fly|Ride"] = 822.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7562.5, ["Fly"] = 8397.45, ["Ride"] = 7184.38, ["Fly|Ride"] = 6359.38, ["Neon"] = 23959.52, ["Neon|Fly|Ride"] = 15867.5, ["Mega|Fly|Ride"] = 49156.25}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.73, ["Fly"] = 23.27, ["Ride"] = 18.65, ["Fly|Ride"] = 38.97, ["Neon"] = 27.01, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 206.25, ["Mega|Ride"] = 220.17, ["Mega|Fly|Ride"] = 334.78}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.88, ["Fly"] = 35.61, ["Ride"] = 34.38, ["Fly|Ride"] = 60.88, ["Neon"] = 197.47, ["Neon|Fly"] = 250.8, ["Neon|Ride"] = 148.67, ["Neon|Fly|Ride"] = 151.54, ["Mega|Ride"] = 1052.57, ["Mega|Fly|Ride"] = 770}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.55}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.73, ["Fly"] = 34.38, ["Ride"] = 29.12, ["Fly|Ride"] = 91.16, ["Neon"] = 82.49, ["Neon|Ride"] = 144.79, ["Mega"] = 1099.89, ["Mega|Ride"] = 1205.16, ["Mega|Fly|Ride"] = 907.85}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 23.68, ["Fly"] = 199.43, ["Ride"] = 51.35, ["Fly|Ride"] = 123.75, ["Neon"] = 152.08, ["Neon|Ride"] = 163.35, ["Neon|Fly|Ride"] = 261.25, ["Mega|Ride"] = 907.85, ["Mega|Fly|Ride"] = 1152.25}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.09, ["Fly"] = 30.25, ["Ride"] = 19.24, ["Fly|Ride"] = 45.38, ["Neon|Fly"] = 1131.4, ["Neon|Ride"] = 106.68, ["Neon|Fly|Ride"] = 127.08, ["Mega"] = 2723.51, ["Mega|Ride"] = 449.39, ["Mega|Fly|Ride"] = 658.19}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 9069.25}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3007}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21.99}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 255.5, ["Ride"] = 209, ["Fly|Ride"] = 339.32, ["Neon|Fly|Ride"] = 1268.04}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.87, ["Fly"] = 102.7, ["Ride"] = 34.36, ["Fly|Ride"] = 145.27, ["Neon"] = 124.22, ["Neon|Ride"] = 122.38, ["Neon|Fly|Ride"] = 277.75, ["Mega|Ride"] = 2140.77, ["Mega|Fly|Ride"] = 557.19}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.79}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.09, ["Ride"] = 27.49, ["Fly|Ride"] = 90.8, ["Neon"] = 163.42, ["Neon|Ride"] = 261.25, ["Neon|Fly|Ride"] = 192.93}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2475}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 233.75, ["Fly"] = 453.93, ["Ride"] = 275, ["Fly|Ride"] = 385, ["Neon"] = 832.95, ["Neon|Ride"] = 906.71, ["Neon|Fly|Ride"] = 1133.66, ["Mega|Ride"] = 4388.25, ["Mega|Fly|Ride"] = 4123.9}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 63.25, ["Fly"] = 499.33, ["Ride"] = 61.3, ["Fly|Ride"] = 256.71, ["Neon"] = 412.5, ["Neon|Ride"] = 358.8, ["Neon|Fly|Ride"] = 379.04, ["Mega|Fly|Ride"] = 2103.92}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 199.38, ["Fly"] = 274.71, ["Ride"] = 219.65, ["Fly|Ride"] = 256.71, ["Neon"] = 794.37, ["Neon|Ride"] = 829.55, ["Neon|Fly|Ride"] = 899.25, ["Mega|Fly|Ride"] = 4052.35}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2609.75, ["Fly"] = 3480.42, ["Ride"] = 2849, ["Fly|Ride"] = 3093.74, ["Neon"] = 15939.25, ["Neon|Ride"] = 10268.2, ["Neon|Fly|Ride"] = 9281.25, ["Mega|Fly|Ride"] = 31774.09}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.13, ["Fly"] = 111.23, ["Ride"] = 56.46, ["Fly|Ride"] = 118.03, ["Neon"] = 133.38, ["Neon|Ride"] = 164.3, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1020.2, ["Mega|Ride"] = 1059.9, ["Mega|Fly|Ride"] = 1100}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 905.57, ["Fly"] = 2200, ["Ride"] = 880.55, ["Fly|Ride"] = 907.85, ["Neon|Fly|Ride"] = 4449.66}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 25.96}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 19.11, ["Ride"] = 45.38, ["Fly|Ride"] = 165, ["Neon"] = 110, ["Neon|Ride"] = 143, ["Neon|Fly|Ride"] = 276.91, ["Mega"] = 466.13, ["Mega|Fly"] = 1026.76, ["Mega|Ride"] = 453.93, ["Mega|Fly|Ride"] = 508.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.25, ["Fly"] = 38.6, ["Ride"] = 31.63, ["Fly|Ride"] = 134.75, ["Neon"] = 75.52, ["Neon|Fly"] = 330, ["Neon|Ride"] = 105.59, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 480.01, ["Mega|Ride"] = 303, ["Mega|Fly|Ride"] = 415.84}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 61.88}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.62, ["Ride"] = 27.37, ["Fly|Ride"] = 86.01, ["Neon|Ride"] = 245.16, ["Neon|Fly|Ride"] = 266.75, ["Mega|Ride"] = 1286.87, ["Mega|Fly|Ride"] = 2269.6}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.67, ["Fly"] = 48.13, ["Ride"] = 44, ["Fly|Ride"] = 63.56, ["Neon|Fly"] = 250.8, ["Neon|Ride"] = 233.75, ["Neon|Fly|Ride"] = 225.83, ["Mega"] = 1513.82, ["Mega|Ride"] = 1925.15, ["Mega|Fly|Ride"] = 907.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7092.45, ["Fly"] = 5156.25, ["Ride"] = 7252.45, ["Fly|Ride"] = 5444.98, ["Neon|Fly|Ride"] = 11050.63, ["Mega|Fly|Ride"] = 36313.25}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.89, ["Fly"] = 48.1, ["Ride"] = 35.66, ["Fly|Ride"] = 85.73, ["Neon"] = 57.75, ["Neon|Ride"] = 91.82, ["Neon|Fly|Ride"] = 245.15, ["Mega"] = 371.25, ["Mega|Ride"] = 302.5, ["Mega|Fly|Ride"] = 572.42}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 18.67}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 86.63, ["Fly"] = 401.74, ["Ride"] = 123.75, ["Fly|Ride"] = 209.4, ["Neon"] = 512.99, ["Neon|Ride"] = 507.9, ["Neon|Fly|Ride"] = 561, ["Mega"] = 3016.71, ["Mega|Fly|Ride"] = 2119.79}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 53.53, ["Fly"] = 200.02, ["Ride"] = 96.13, ["Fly|Ride"] = 175.12, ["Neon"] = 247.5, ["Neon|Fly"] = 410.74, ["Neon|Ride"] = 347.26, ["Neon|Fly|Ride"] = 481.25, ["Mega"] = 2566.88, ["Mega|Ride"] = 3063.94, ["Mega|Fly|Ride"] = 1095.88}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.15, ["Fly"] = 34.67, ["Ride"] = 34.38, ["Fly|Ride"] = 75.63, ["Neon"] = 182.88, ["Neon|Fly"] = 245.13, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 191.13, ["Mega"] = 1064.6, ["Mega|Ride"] = 756.25, ["Mega|Fly|Ride"] = 842.03}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 8.25, ["Fly"] = 82.49, ["Ride"] = 30.94, ["Fly|Ride"] = 110, ["Neon"] = 27.49, ["Neon|Ride"] = 81.95, ["Neon|Fly|Ride"] = 181.59, ["Mega"] = 170.5, ["Mega|Fly"] = 7565.65, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 365.75}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.75, ["Fly"] = 68.75, ["Ride"] = 31.63, ["Fly|Ride"] = 102.7, ["Neon"] = 82.5, ["Neon|Ride"] = 121.43, ["Neon|Fly|Ride"] = 220, ["Mega"] = 398.75, ["Mega|Ride"] = 756.93, ["Mega|Fly|Ride"] = 566.27}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.19, ["Fly"] = 34.36, ["Ride"] = 29.58, ["Fly|Ride"] = 59.45, ["Neon"] = 291.5, ["Neon|Fly"] = 151.25, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 147.54, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.13}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.24, ["Ride"] = 147.13, ["Fly|Ride"] = 303, ["Neon"] = 178.75, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 385.04, ["Mega"] = 832.95, ["Mega|Ride"] = 807.99, ["Mega|Fly|Ride"] = 822.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 256.7, ["Ride"] = 1513.82, ["Fly|Ride"] = 453.93, ["Neon|Fly|Ride"] = 30261.41}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 57.75, ["Fly"] = 209.11, ["Ride"] = 90.28, ["Fly|Ride"] = 231, ["Neon"] = 220, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 330, ["Mega"] = 1201.75, ["Mega|Ride"] = 1237.5, ["Mega|Fly|Ride"] = 1068.38}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1167.38, ["Fly"] = 1306.25, ["Ride"] = 1100, ["Fly|Ride"] = 1230.63, ["Neon|Fly"] = 4941.58, ["Neon|Ride"] = 3162.5, ["Neon|Fly|Ride"] = 3817.46, ["Mega|Fly|Ride"] = 13750}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 412.39, ["Fly"] = 756.93, ["Ride"] = 438.63, ["Fly|Ride"] = 562.38, ["Neon"] = 2887.5, ["Neon|Ride"] = 3329.48, ["Neon|Fly|Ride"] = 2103.75, ["Mega"] = 13617.48, ["Mega|Fly|Ride"] = 10173.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 56.57}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.62}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.01, ["Fly"] = 34.34, ["Ride"] = 26.02, ["Fly|Ride"] = 55, ["Neon"] = 83.6, ["Neon|Fly"] = 152.63, ["Neon|Ride"] = 89.31, ["Neon|Fly|Ride"] = 149.87, ["Mega"] = 458.08, ["Mega|Ride"] = 756.93, ["Mega|Fly|Ride"] = 600.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 246.05, ["Fly"] = 369.73, ["Ride"] = 302.38, ["Fly|Ride"] = 371.25, ["Neon"] = 687.5, ["Neon|Ride"] = 825, ["Neon|Fly|Ride"] = 996.88, ["Mega|Fly|Ride"] = 3331.05}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.12}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 121, ["Ride"] = 151.25, ["Fly|Ride"] = 316.01, ["Neon"] = 481.25, ["Neon|Fly"] = 639.38, ["Neon|Ride"] = 611.87, ["Neon|Fly|Ride"] = 687.5, ["Mega"] = 2942.79, ["Mega|Ride"] = 2566.88, ["Mega|Fly|Ride"] = 2406.14}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 110, ["Fly"] = 326.06, ["Ride"] = 151.58, ["Fly|Ride"] = 265.56, ["Neon"] = 756.93, ["Neon|Ride"] = 1082.13, ["Neon|Fly|Ride"] = 976.25, ["Mega|Fly|Ride"] = 4262.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.49, ["Ride"] = 26.59, ["Fly|Ride"] = 184.99, ["Neon"] = 33.96, ["Neon|Ride"] = 66, ["Neon|Fly|Ride"] = 250.95, ["Mega"] = 236.04, ["Mega|Ride"] = 199.27, ["Mega|Fly|Ride"] = 308.04}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.73, ["Fly"] = 53.89, ["Ride"] = 28.88, ["Fly|Ride"] = 75.53, ["Neon"] = 185.63, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 342.69, ["Mega|Fly|Ride"] = 646.25}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.64, ["Fly"] = 107.23, ["Ride"] = 35.75, ["Fly|Ride"] = 123.74, ["Neon"] = 85.03, ["Neon|Ride"] = 105.87, ["Neon|Fly|Ride"] = 281.88, ["Mega"] = 522.5, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.5, ["Fly"] = 137.49, ["Ride"] = 40.83, ["Fly|Ride"] = 165, ["Neon"] = 30.13, ["Neon|Ride"] = 79.75, ["Neon|Fly|Ride"] = 210.34, ["Mega"] = 185.63, ["Mega|Ride"] = 181.39, ["Mega|Fly|Ride"] = 331.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 274.99, ["Ride"] = 324.39, ["Fly|Ride"] = 364.37, ["Neon"] = 1513.82, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1462.18, ["Mega|Fly|Ride"] = 6922.23}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 98.89, ["Fly"] = 181.59, ["Ride"] = 132, ["Fly|Ride"] = 201.52, ["Neon"] = 449.63, ["Neon|Ride"] = 515.63, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2722.38, ["Mega|Ride"] = 2119.79, ["Mega|Fly|Ride"] = 1965.46}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 66.03, ["Fly"] = 175.42, ["Ride"] = 90.2, ["Fly|Ride"] = 121.64, ["Neon"] = 330, ["Neon|Ride"] = 357.47, ["Neon|Fly|Ride"] = 435.6, ["Mega|Ride"] = 1882.8, ["Mega|Fly|Ride"] = 1438.25}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 22, ["Ride"] = 56.75, ["Fly|Ride"] = 303, ["Neon|Ride"] = 652.04, ["Neon|Fly|Ride"] = 529.95}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.42, ["Ride"] = 30.64, ["Fly|Ride"] = 59.13, ["Neon"] = 82.49, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 129.38, ["Mega"] = 453.93, ["Mega|Ride"] = 513.39, ["Mega|Fly|Ride"] = 646.87}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.2, ["Fly"] = 44, ["Ride"] = 20.55, ["Fly|Ride"] = 55, ["Neon"] = 20.63, ["Neon|Fly"] = 89.28, ["Neon|Ride"] = 43.44, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 224.7, ["Mega|Ride"] = 189.63, ["Mega|Fly|Ride"] = 296.18}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 921.02, ["Fly"] = 1150.69, ["Ride"] = 948.75, ["Fly|Ride"] = 976.25, ["Neon"] = 3177.42, ["Neon|Fly"] = 3484.78, ["Neon|Fly|Ride"] = 2461.25, ["Mega|Fly|Ride"] = 8470}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 329.99, ["Fly"] = 351.81, ["Ride"] = 313.56, ["Fly|Ride"] = 330, ["Neon|Ride"] = 1513.82, ["Neon|Fly|Ride"] = 1333.75, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 5305.7}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 96.25, ["Fly"] = 181.59, ["Ride"] = 127.88, ["Fly|Ride"] = 181.5, ["Neon"] = 442.75, ["Neon|Ride"] = 431.27, ["Neon|Fly|Ride"] = 575.36, ["Mega"] = 1375, ["Mega|Ride"] = 1831.57, ["Mega|Fly|Ride"] = 1967.74}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 198.6, ["Fly"] = 297, ["Ride"] = 197.89, ["Fly|Ride"] = 242.86, ["Neon"] = 962.5, ["Neon|Ride"] = 1045, ["Neon|Fly|Ride"] = 962.5, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 6875}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21.97, ["Fly"] = 61.3, ["Ride"] = 35.35, ["Fly|Ride"] = 85.25, ["Neon"] = 177.38, ["Neon|Ride"] = 241.3, ["Neon|Fly|Ride"] = 223.85, ["Mega|Ride"] = 791.48, ["Mega|Fly|Ride"] = 1000.91}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 214.5, ["Ride"] = 295.63, ["Fly|Ride"] = 379.04, ["Neon"] = 999.76, ["Neon|Ride"] = 987.25, ["Neon|Fly|Ride"] = 1100, ["Mega"] = 3391.15, ["Mega|Fly|Ride"] = 4449.66}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 81.03, ["Fly"] = 131.99, ["Ride"] = 85.25, ["Fly|Ride"] = 135.72, ["Neon|Ride"] = 605.99, ["Neon|Fly|Ride"] = 907.85, ["Mega|Ride"] = 2421.65, ["Mega|Fly|Ride"] = 1908.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 3118.42, ["Ride"] = 3025, ["Fly|Ride"] = 2590.5, ["Neon|Ride"] = 11979.51, ["Neon|Fly|Ride"] = 6913.14, ["Mega"] = 54469.86, ["Mega|Fly|Ride"] = 30802.24}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11, ["Fly"] = 75.67, ["Ride"] = 46.74, ["Fly|Ride"] = 113.49, ["Neon"] = 60.5, ["Neon|Fly"] = 181.28, ["Neon|Ride"] = 70.4, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 281.88, ["Mega|Ride"] = 363.16, ["Mega|Fly|Ride"] = 438.63}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.22, ["Ride"] = 61.87, ["Fly|Ride"] = 156.75, ["Neon"] = 232.38, ["Neon|Ride"] = 235.03, ["Neon|Fly|Ride"] = 240.01, ["Mega|Ride"] = 976.25, ["Mega|Fly|Ride"] = 1134.81}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 81.1, ["Fly"] = 91.06, ["Ride"] = 68.75, ["Fly|Ride"] = 91.5, ["Neon"] = 550, ["Neon|Fly|Ride"] = 430.38, ["Mega|Fly|Ride"] = 2119.79}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2308.63, ["Fly"] = 1712.15, ["Ride"] = 1120.63, ["Fly|Ride"] = 1044.99, ["Neon|Ride"] = 5990.22, ["Neon|Fly|Ride"] = 4124.99, ["Mega"] = 38885.82, ["Mega|Fly|Ride"] = 16500}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 440, ["Fly"] = 905.57, ["Ride"] = 794.37, ["Fly|Ride"] = 559.63}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 79.75, ["Fly"] = 110, ["Ride"] = 128.09, ["Fly|Ride"] = 266.7, ["Neon"] = 392.65, ["Neon|Ride"] = 358.68, ["Neon|Fly|Ride"] = 567.42, ["Mega"] = 2269.6, ["Mega|Ride"] = 2738.85, ["Mega|Fly|Ride"] = 1838.47}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.24, ["Fly"] = 34.38, ["Ride"] = 24.85, ["Fly|Ride"] = 90.8, ["Neon"] = 90.75, ["Neon|Ride"] = 102.7, ["Neon|Fly|Ride"] = 196.63, ["Mega"] = 580.25, ["Mega|Ride"] = 854.53}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 38.49, ["Fly"] = 65.65, ["Ride"] = 48.13, ["Fly|Ride"] = 72.88, ["Neon"] = 222.75, ["Neon|Fly"] = 379.04, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 363.16, ["Mega|Ride"] = 1244.38, ["Mega|Fly|Ride"] = 1099.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 754.88, ["Fly"] = 1180.8, ["Ride"] = 934.89, ["Fly|Ride"] = 935, ["Neon|Ride"] = 2750, ["Neon|Fly|Ride"] = 2200, ["Mega|Fly|Ride"] = 10182.72}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 646.25}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 12834.55, ["Ride"] = 5500, ["Fly|Ride"] = 5361.13, ["Neon"] = 44000, ["Neon|Ride"] = 32524.19, ["Neon|Fly|Ride"] = 28029.3, ["Mega|Fly|Ride"] = 113478.85}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 275, ["Fly"] = 425.55, ["Ride"] = 357.5, ["Fly|Ride"] = 446.7, ["Neon"] = 1815.68, ["Neon|Fly|Ride"] = 2269.6, ["Mega"] = 6807.61, ["Mega|Fly|Ride"] = 6808.74}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 89.87, ["Ride"] = 164.88, ["Fly|Ride"] = 303, ["Neon"] = 1205.16, ["Neon|Ride"] = 602.6, ["Neon|Fly|Ride"] = 513.39, ["Mega|Fly|Ride"] = 2738.85}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 19.25, ["Fly"] = 76.05, ["Ride"] = 42.02, ["Fly|Ride"] = 86.01, ["Neon"] = 148.5, ["Neon|Ride"] = 181.59, ["Neon|Fly|Ride"] = 272.25, ["Mega|Ride"] = 907.85, ["Mega|Fly|Ride"] = 838.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.17, ["Fly"] = 30.25, ["Ride"] = 26, ["Fly|Ride"] = 53.63, ["Neon"] = 153.48, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 185.63, ["Mega"] = 1375, ["Mega|Ride"] = 398.75, ["Mega|Fly|Ride"] = 1134.81}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.75, ["Ride"] = 28.85, ["Fly|Ride"] = 112.07, ["Neon"] = 123.75, ["Neon|Ride"] = 132.91, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 676.67, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 671.82}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.09, ["Fly"] = 30.66, ["Ride"] = 23.38, ["Fly|Ride"] = 51.35, ["Neon"] = 39.88, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 135.47, ["Mega"] = 700.07, ["Mega|Ride"] = 246.13, ["Mega|Fly|Ride"] = 246.13}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 17.88, ["Ride"] = 41.25, ["Fly|Ride"] = 137.15, ["Neon"] = 164.04, ["Neon|Fly"] = 907.85, ["Neon|Ride"] = 245.13, ["Neon|Fly|Ride"] = 342.69, ["Mega"] = 660, ["Mega|Ride"] = 756.93}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 591.25, ["Fly"] = 563.75, ["Ride"] = 481.25, ["Fly|Ride"] = 640.75, ["Neon"] = 1951.86, ["Neon|Ride"] = 1882.8, ["Neon|Fly|Ride"] = 1691.25, ["Mega"] = 9625, ["Mega|Fly|Ride"] = 6600}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.58, ["Fly"] = 20.63, ["Ride"] = 17.03, ["Fly|Ride"] = 39.86, ["Neon"] = 22.84, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 74.25, ["Mega"] = 178.75, ["Mega|Ride"] = 645.7, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 46.48, ["Fly"] = 122.37, ["Ride"] = 87.32, ["Fly|Ride"] = 146.72, ["Neon"] = 219.75, ["Neon|Fly"] = 378.8, ["Neon|Ride"] = 225.5, ["Neon|Fly|Ride"] = 275, ["Mega"] = 591.25, ["Mega|Fly"] = 907.85, ["Mega|Ride"] = 548.52, ["Mega|Fly|Ride"] = 622.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 776.23, ["Ride"] = 845.63, ["Fly|Ride"] = 852.5, ["Neon"] = 1982.49, ["Neon|Ride"] = 2225.63, ["Neon|Fly|Ride"] = 1718.75, ["Mega|Fly|Ride"] = 4492}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.88, ["Fly"] = 94.87, ["Ride"] = 48.11, ["Fly|Ride"] = 98.99, ["Neon"] = 256.48, ["Neon|Ride"] = 197.89, ["Neon|Fly|Ride"] = 263.99, ["Mega"] = 1369.44, ["Mega|Fly|Ride"] = 922.63}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 296.26, ["Fly"] = 344.71, ["Ride"] = 309.38, ["Fly|Ride"] = 330, ["Neon"] = 1702.19, ["Neon|Ride"] = 1474.1, ["Neon|Fly|Ride"] = 1353}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 258.64, ["Fly"] = 312.09, ["Ride"] = 274.99, ["Fly|Ride"] = 316.24, ["Neon"] = 935, ["Neon|Ride"] = 962.5, ["Neon|Fly|Ride"] = 917.13, ["Mega"] = 5294.93, ["Mega|Fly|Ride"] = 4796.76}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 780.36, ["Ride"] = 731.39, ["Fly|Ride"] = 735.08, ["Neon|Ride"] = 3784.53, ["Neon|Fly|Ride"] = 2406.25, ["Mega|Fly|Ride"] = 11043.77}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.88, ["Fly"] = 65.83, ["Ride"] = 49.49, ["Fly|Ride"] = 112.59, ["Neon"] = 83.88, ["Neon|Fly"] = 308.06, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 172.65, ["Mega"] = 275, ["Mega|Ride"] = 453.93, ["Mega|Fly|Ride"] = 473}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4388.25, ["Fly"] = 3712.5, ["Ride"] = 3506.25, ["Fly|Ride"] = 3366, ["Neon|Fly|Ride"] = 8402.63, ["Mega|Fly|Ride"] = 19797.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 151.25, ["Fly"] = 186.99, ["Ride"] = 178.74, ["Fly|Ride"] = 220, ["Neon"] = 561, ["Neon|Ride"] = 686.13, ["Neon|Fly|Ride"] = 605, ["Mega|Ride"] = 3358.99, ["Mega|Fly|Ride"] = 3397.57}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.2, ["Fly"] = 34.06, ["Ride"] = 20.2, ["Fly|Ride"] = 45.37, ["Neon"] = 13.63, ["Neon|Fly"] = 106.68, ["Neon|Ride"] = 38.28, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 213.35, ["Mega|Fly"] = 467.5, ["Mega|Ride"] = 260.06, ["Mega|Fly|Ride"] = 256.48}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 4.13, ["Ride"] = 29.31, ["Fly|Ride"] = 68.74, ["Neon"] = 23.67, ["Neon|Fly"] = 125.8, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 187.68, ["Mega|Ride"] = 285.99, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 41.13, ["Fly"] = 43.12, ["Ride"] = 44, ["Fly|Ride"] = 51.22, ["Neon"] = 308.06, ["Neon|Fly|Ride"] = 284.34, ["Mega|Fly|Ride"] = 1282.33}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 933.9, ["Fly"] = 1283.46, ["Ride"] = 962.48, ["Fly|Ride"] = 1065.63, ["Neon"] = 4425.69, ["Neon|Ride"] = 4793.97, ["Neon|Fly|Ride"] = 4993.09}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 8170.5, ["Fly|Ride"] = 8470.08}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.72, ["Fly"] = 45.38, ["Ride"] = 28.84, ["Fly|Ride"] = 61.88, ["Neon"] = 473.66, ["Neon|Ride"] = 143, ["Neon|Fly|Ride"] = 170.39, ["Mega"] = 2640, ["Mega|Ride"] = 907.39, ["Mega|Fly|Ride"] = 756.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.38, ["Fly"] = 45.38, ["Ride"] = 27.5, ["Fly|Ride"] = 50.88, ["Neon"] = 107.25, ["Neon|Fly"] = 116.88, ["Neon|Ride"] = 81.06, ["Neon|Fly|Ride"] = 158.13, ["Mega"] = 700.72, ["Mega|Ride"] = 554.13, ["Mega|Fly|Ride"] = 525.25}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 136.13, ["Ride"] = 106.24, ["Fly|Ride"] = 173.3, ["Neon|Ride"] = 410.72, ["Neon|Fly|Ride"] = 550, ["Mega|Fly|Ride"] = 2723.51}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 247.39, ["Fly"] = 247.5, ["Ride"] = 206.25, ["Fly|Ride"] = 274.67, ["Neon"] = 1347.5, ["Neon|Ride"] = 1239.26, ["Neon|Fly|Ride"] = 796.13, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 4539.18}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.77, ["Ride"] = 31.63, ["Fly|Ride"] = 74.91, ["Neon"] = 16.5, ["Neon|Fly"] = 687.5, ["Neon|Ride"] = 45.41, ["Mega"] = 145.75, ["Mega|Fly"] = 253.07, ["Mega|Ride"] = 163.63, ["Mega|Fly|Ride"] = 309.38}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 201.58, ["Fly"] = 269.49, ["Ride"] = 206.25, ["Fly|Ride"] = 303, ["Neon"] = 756.25, ["Neon|Fly"] = 872.81, ["Neon|Ride"] = 749.38, ["Neon|Fly|Ride"] = 818.13, ["Mega|Fly|Ride"] = 3207.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.2, ["Fly"] = 27.41, ["Ride"] = 18.07, ["Fly|Ride"] = 51.51, ["Neon"] = 24.33, ["Neon|Fly"] = 136.18, ["Neon|Ride"] = 46.01, ["Neon|Fly|Ride"] = 135.06, ["Mega"] = 192.5, ["Mega|Ride"] = 229.63, ["Mega|Fly|Ride"] = 226.88}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 220, ["Fly"] = 279.17, ["Ride"] = 285.99, ["Fly|Ride"] = 329.99, ["Neon|Ride"] = 1302.13, ["Neon|Fly|Ride"] = 1237.5, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 5133.73}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.5, ["Fly"] = 109.98, ["Ride"] = 29.85, ["Fly|Ride"] = 71.5, ["Neon"] = 94.86, ["Neon|Fly"] = 326.02, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 165, ["Mega"] = 605.99, ["Mega|Ride"] = 467.55, ["Mega|Fly|Ride"] = 693.07}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4, ["Ride"] = 23.38, ["Fly|Ride"] = 102.7, ["Neon"] = 6.76, ["Neon|Fly"] = 178.58, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 204.87, ["Mega"] = 90.57, ["Mega|Ride"] = 142.61, ["Mega|Fly|Ride"] = 313.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.2, ["Neon"] = 3.89, ["Mega"] = 24.47, ["Mega|Ride"] = 152.08, ["Mega|Fly|Ride"] = 144.13}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.2, ["Ride"] = 71.37, ["Fly|Ride"] = 121, ["Neon"] = 8.51, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 63.56, ["Mega|Fly"] = 200850.21, ["Mega|Ride"] = 89.38, ["Mega|Fly|Ride"] = 272.36}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 77.58, ["Fly"] = 137.36, ["Ride"] = 102.39, ["Fly|Ride"] = 181.33, ["Neon"] = 302.5, ["Neon|Ride"] = 291.6, ["Neon|Fly|Ride"] = 432.93, ["Mega|Fly|Ride"] = 1701.07}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.2, ["Fly"] = 39.8, ["Ride"] = 17.34, ["Fly|Ride"] = 88.53, ["Neon"] = 11.86, ["Neon|Ride"] = 29.42, ["Neon|Fly|Ride"] = 54.8, ["Mega"] = 96.25, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.25, ["Ride"] = 77, ["Neon"] = 55, ["Neon|Fly"] = 342.71, ["Neon|Ride"] = 222.69, ["Mega"] = 342.38, ["Mega|Ride"] = 603.72, ["Mega|Fly|Ride"] = 566.01}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 29.52, ["Neon"] = 2.2, ["Neon|Ride"] = 59.09, ["Neon|Fly|Ride"] = 208.83, ["Mega"] = 13.75, ["Mega|Ride"] = 44, ["Mega|Fly|Ride"] = 272.36}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.2, ["Fly"] = 89.61, ["Ride"] = 12.38, ["Fly|Ride"] = 52.22, ["Neon"] = 2.2, ["Neon|Fly"] = 42.61, ["Neon|Ride"] = 13.35, ["Neon|Fly|Ride"] = 34.27, ["Mega"] = 15, ["Mega|Fly"] = 37.89, ["Mega|Ride"] = 19.02, ["Mega|Fly|Ride"] = 52.07}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.2, ["Fly"] = 30.66, ["Ride"] = 13.75, ["Fly|Ride"] = 84.9, ["Neon"] = 2.2, ["Neon|Fly"] = 23.38, ["Neon|Ride"] = 17.55, ["Neon|Fly|Ride"] = 38.28, ["Mega"] = 19.2, ["Mega|Fly"] = 172, ["Mega|Ride"] = 33.93, ["Mega|Fly|Ride"] = 94.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.2, ["Neon"] = 2.2, ["Neon|Ride"] = 95.34, ["Mega"] = 17.87, ["Mega|Ride"] = 137.34, ["Mega|Fly|Ride"] = 453.93}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.2, ["Fly"] = 34.06, ["Ride"] = 22, ["Fly|Ride"] = 55, ["Neon"] = 3.5, ["Neon|Fly"] = 129.39, ["Neon|Ride"] = 26.12, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 43.47, ["Mega|Fly"] = 96.25, ["Mega|Ride"] = 44, ["Mega|Fly|Ride"] = 150.57}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.2, ["Neon"] = 2.2, ["Neon|Ride"] = 86, ["Neon|Fly|Ride"] = 453.93, ["Mega"] = 19.25, ["Mega|Ride"] = 65.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.85, ["Fly"] = 58.01, ["Ride"] = 68.74, ["Fly|Ride"] = 158.13, ["Neon"] = 43.64, ["Neon|Fly"] = 139.64, ["Neon|Ride"] = 74.91, ["Neon|Fly|Ride"] = 170.81, ["Mega"] = 213.13, ["Mega|Fly"] = 419.7, ["Mega|Ride"] = 175.09, ["Mega|Fly|Ride"] = 297}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.2, ["Ride"] = 85.85, ["Neon"] = 2.2, ["Neon|Fly"] = 27.5, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 342.49, ["Mega"] = 22, ["Mega|Fly"] = 151.25, ["Mega|Ride"] = 69.32, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.2, ["Fly"] = 68.75, ["Ride"] = 153.21, ["Fly|Ride"] = 152.08, ["Neon"] = 20.63, ["Mega"] = 116.87, ["Mega|Fly"] = 330, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.2, ["Ride"] = 27.49, ["Neon"] = 21.99, ["Mega"] = 137.5, ["Mega|Ride"] = 181.59, ["Mega|Fly|Ride"] = 605.99}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.2, ["Fly"] = 152.08, ["Ride"] = 34.38, ["Neon"] = 2.74, ["Neon|Ride"] = 28.42, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 23.34, ["Mega|Ride"] = 46.75, ["Mega|Fly|Ride"] = 102.69}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.2, ["Fly"] = 20.55, ["Ride"] = 13.75, ["Fly|Ride"] = 42.19, ["Neon"] = 2.2, ["Neon|Fly"] = 36.89, ["Neon|Ride"] = 15.87, ["Neon|Fly|Ride"] = 41.25, ["Mega"] = 15.95, ["Mega|Fly"] = 34.38, ["Mega|Ride"] = 21.99, ["Mega|Fly|Ride"] = 53.62}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 4, ["Fly"] = 75.63, ["Ride"] = 56.86, ["Fly|Ride"] = 123.73, ["Neon"] = 38.5, ["Neon|Ride"] = 76.05, ["Mega"] = 212.24, ["Mega|Ride"] = 253}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.2, ["Ride"] = 34.38, ["Neon"] = 3.35, ["Neon|Fly"] = 41.25, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 103.13, ["Mega"] = 17.03, ["Mega|Ride"] = 63.56, ["Mega|Fly|Ride"] = 116.88}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.2, ["Neon"] = 16.55, ["Neon|Ride"] = 204.4, ["Mega"] = 106.33, ["Mega|Ride"] = 187.61, ["Mega|Fly|Ride"] = 325.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.75, ["Fly"] = 83.53, ["Ride"] = 30.24, ["Fly|Ride"] = 48.13, ["Neon"] = 12.27, ["Neon|Ride"] = 53.35, ["Neon|Fly|Ride"] = 151.25, ["Mega"] = 136.13, ["Mega|Ride"] = 171.19, ["Mega|Fly|Ride"] = 206.24}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.2, ["Fly"] = 13.19, ["Ride"] = 12.36, ["Fly|Ride"] = 32.99, ["Neon"] = 2.2, ["Neon|Fly"] = 20.83, ["Neon|Ride"] = 15.12, ["Neon|Fly|Ride"] = 34.38, ["Mega"] = 14.69, ["Mega|Fly"] = 28.89, ["Mega|Ride"] = 21.85, ["Mega|Fly|Ride"] = 49.5}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.2, ["Fly"] = 30.64, ["Ride"] = 28.73, ["Fly|Ride"] = 151.25, ["Neon"] = 13.58, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 205.92, ["Mega"] = 135.82, ["Mega|Ride"] = 168.44, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.12, ["Fly"] = 123.75, ["Ride"] = 25.69, ["Fly|Ride"] = 61.88, ["Neon"] = 51.35, ["Neon|Ride"] = 75.74, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 330, ["Mega|Ride"] = 311.68, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.2, ["Fly"] = 61.3, ["Ride"] = 15.1, ["Fly|Ride"] = 43.38, ["Neon"] = 2.2, ["Neon|Fly"] = 20.63, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 42.56, ["Mega"] = 22, ["Mega|Fly"] = 53.35, ["Mega|Ride"] = 34.38, ["Mega|Fly|Ride"] = 81.13}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 4.13, ["Fly"] = 189.53, ["Ride"] = 48.1, ["Neon"] = 7.41, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 158.13, ["Mega"] = 53.63, ["Mega|Fly"] = 181.59, ["Mega|Ride"] = 123.75, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.2, ["Fly"] = 29.7, ["Ride"] = 37.13, ["Fly|Ride"] = 137.5, ["Neon"] = 3.74, ["Neon|Fly"] = 123.75, ["Neon|Ride"] = 54.99, ["Neon|Fly|Ride"] = 303, ["Mega"] = 33.26, ["Mega|Fly"] = 121.26, ["Mega|Ride"] = 66, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.2, ["Ride"] = 28.88, ["Neon"] = 2.2, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 303, ["Mega"] = 14.98, ["Mega|Fly"] = 265.91, ["Mega|Ride"] = 69.77, ["Mega|Fly|Ride"] = 163.63}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.2, ["Fly"] = 24.99, ["Ride"] = 20.5, ["Fly|Ride"] = 55.17, ["Neon"] = 6.77, ["Neon|Fly"] = 61.08, ["Neon|Ride"] = 34.92, ["Neon|Fly|Ride"] = 78.36, ["Mega"] = 110.22, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.2, ["Ride"] = 23.68, ["Neon"] = 4.13, ["Neon|Ride"] = 17.88, ["Mega"] = 57.25, ["Mega|Fly"] = 342.69, ["Mega|Ride"] = 119.63, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.2, ["Fly"] = 20.44, ["Ride"] = 18.03, ["Fly|Ride"] = 75.63, ["Neon"] = 4.12, ["Neon|Fly"] = 86.01, ["Neon|Ride"] = 27.17, ["Neon|Fly|Ride"] = 87.98, ["Mega"] = 119.63, ["Mega|Fly"] = 121.28, ["Mega|Ride"] = 90.64, ["Mega|Fly|Ride"] = 196.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.58, ["Ride"] = 38.8, ["Neon"] = 16.5, ["Neon|Fly"] = 197.87, ["Neon|Fly|Ride"] = 340.44, ["Mega"] = 109.99, ["Mega|Fly"] = 385, ["Mega|Ride"] = 178.75}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.2, ["Fly"] = 27, ["Ride"] = 19.23, ["Fly|Ride"] = 49.49, ["Neon"] = 9.43, ["Neon|Fly"] = 51.35, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 107.83, ["Mega"] = 144.13, ["Mega|Fly"] = 440, ["Mega|Ride"] = 84.75, ["Mega|Fly|Ride"] = 180.67}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.2, ["Fly"] = 14.79, ["Ride"] = 17.33, ["Fly|Ride"] = 67.83, ["Neon"] = 16.03, ["Neon|Fly"] = 30.25, ["Neon|Ride"] = 31.63, ["Neon|Fly|Ride"] = 41.16, ["Mega"] = 110, ["Mega|Fly"] = 123.75, ["Mega|Ride"] = 141.81, ["Mega|Fly|Ride"] = 233.75}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 4.13, ["Fly"] = 120.3, ["Neon"] = 106.59, ["Neon|Ride"] = 91.14, ["Neon|Fly|Ride"] = 2750, ["Mega"] = 269.53, ["Mega|Ride"] = 340.44}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.5, ["Ride"] = 68.75, ["Neon"] = 75.78, ["Neon|Ride"] = 178.75, ["Mega"] = 707, ["Mega|Ride"] = 763.13, ["Mega|Fly|Ride"] = 1026.76}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.2, ["Ride"] = 43.12, ["Neon"] = 48.13, ["Neon|Ride"] = 113.49, ["Mega"] = 233.75, ["Mega|Ride"] = 265.56}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.4, ["Ride"] = 49.5, ["Fly|Ride"] = 136.18, ["Neon"] = 50.6, ["Neon|Ride"] = 72.78, ["Neon|Fly|Ride"] = 129.39, ["Mega"] = 236.42, ["Mega|Ride"] = 431.24, ["Mega|Fly|Ride"] = 468.2}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.2, ["Neon"] = 4.07, ["Mega"] = 16.5, ["Mega|Fly"] = 152.08, ["Mega|Ride"] = 133.92, ["Mega|Fly|Ride"] = 247.41}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.65}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.33, ["Fly"] = 24.49, ["Ride"] = 23.36, ["Fly|Ride"] = 65.83, ["Neon"] = 41.14, ["Neon|Fly"] = 196.64, ["Neon|Ride"] = 47.9, ["Neon|Fly|Ride"] = 123.74, ["Mega"] = 483.44, ["Mega|Ride"] = 218.62, ["Mega|Fly|Ride"] = 331.38}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.2, ["Fly"] = 74.25, ["Ride"] = 21.25, ["Neon"] = 4.71, ["Neon|Fly"] = 55.32, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 28.88, ["Mega|Fly"] = 152.08, ["Mega|Ride"] = 59.02, ["Mega|Fly|Ride"] = 135.71}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.2, ["Ride"] = 27.42, ["Neon"] = 4.44, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 75.62, ["Mega"] = 33.54, ["Mega|Ride"] = 41.24, ["Mega|Fly|Ride"] = 141.63}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.2, ["Fly"] = 47.33, ["Ride"] = 16.9, ["Fly|Ride"] = 47.43, ["Neon"] = 13.36, ["Neon|Ride"] = 25.25, ["Neon|Fly|Ride"] = 68.57, ["Mega"] = 170.04, ["Mega|Ride"] = 123.75, ["Mega|Fly|Ride"] = 164.56}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.05, ["Fly"] = 106.68, ["Ride"] = 28.52, ["Fly|Ride"] = 86.01, ["Neon"] = 46.35, ["Neon|Ride"] = 218.05, ["Neon|Fly|Ride"] = 151.24, ["Mega"] = 343.75, ["Mega|Ride"] = 361.9, ["Mega|Fly|Ride"] = 342.69}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.2, ["Ride"] = 35.75, ["Neon"] = 2.2, ["Neon|Fly|Ride"] = 107.83, ["Mega"] = 19.01, ["Mega|Fly"] = 123.75, ["Mega|Ride"] = 56.26, ["Mega|Fly|Ride"] = 152.08}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.2, ["Fly"] = 29.03, ["Ride"] = 23.37, ["Fly|Ride"] = 61.88, ["Neon"] = 2.75, ["Neon|Fly"] = 120.53, ["Neon|Ride"] = 17.37, ["Neon|Fly|Ride"] = 102.68, ["Mega"] = 33, ["Mega|Fly"] = 152.08, ["Mega|Ride"] = 54.43, ["Mega|Fly|Ride"] = 145.27}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 19.19, ["Fly|Ride"] = 27.38, ["Neon"] = 4.82, ["Neon|Fly"] = 96.4, ["Neon|Ride"] = 16.39, ["Neon|Fly|Ride"] = 64.24, ["Mega"] = 88.53, ["Mega|Fly"] = 152.08, ["Mega|Ride"] = 110, ["Mega|Fly|Ride"] = 125.98}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.2, ["Fly"] = 96.25, ["Ride"] = 52.22, ["Fly|Ride"] = 151.25, ["Neon"] = 9.89, ["Neon|Ride"] = 67.37, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 83.87, ["Mega|Ride"] = 152.88, ["Mega|Fly|Ride"] = 301.13}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.2, ["Ride"] = 27.5, ["Neon"] = 3.66, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 165304, ["Mega"] = 16.48, ["Mega|Fly"] = 120.3, ["Mega|Ride"] = 50.88, ["Mega|Fly|Ride"] = 137.39}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.2, ["Fly"] = 48.1, ["Ride"] = 20.61, ["Fly|Ride"] = 53.63, ["Neon"] = 2.73, ["Neon|Fly"] = 29.54, ["Neon|Ride"] = 25.35, ["Neon|Fly|Ride"] = 94.95, ["Mega"] = 19.69, ["Mega|Fly"] = 34.38, ["Mega|Ride"] = 39.88, ["Mega|Fly|Ride"] = 82.5}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.2, ["Neon"] = 2.2, ["Mega"] = 14.85, ["Mega|Ride"] = 136.13, ["Mega|Fly|Ride"] = 218.63}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.2, ["Neon"] = 6.46, ["Neon|Fly|Ride"] = 440, ["Mega"] = 22.9, ["Mega|Ride"] = 216.76, ["Mega|Fly|Ride"] = 154.03}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.2, ["Fly"] = 27.49, ["Ride"] = 17.03, ["Fly|Ride"] = 72.88, ["Neon"] = 6.71, ["Neon|Fly"] = 41.24, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 50.68, ["Mega"] = 39.87, ["Mega|Ride"] = 38.5, ["Mega|Fly|Ride"] = 80.32}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.63, ["Ride"] = 82.5, ["Fly|Ride"] = 226.98, ["Neon"] = 76.23, ["Neon|Ride"] = 82.5, ["Mega"] = 408.37, ["Mega|Ride"] = 506.14, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.2, ["Fly"] = 6875, ["Ride"] = 30.25, ["Neon"] = 27.5, ["Neon|Ride"] = 165, ["Mega"] = 221.29, ["Mega|Fly|Ride"] = 659.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.2, ["Ride"] = 34.67, ["Fly|Ride"] = 137.5, ["Neon"] = 49.5, ["Neon|Fly|Ride"] = 303, ["Mega"] = 340.44, ["Mega|Ride"] = 312.09, ["Mega|Fly|Ride"] = 406.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.2, ["Fly"] = 14.88, ["Ride"] = 13.6, ["Fly|Ride"] = 26.46, ["Neon"] = 2.2, ["Neon|Fly"] = 20.28, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 32.89, ["Mega"] = 15.11, ["Mega|Fly"] = 22.72, ["Mega|Ride"] = 23.32, ["Mega|Fly|Ride"] = 94.99}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.2, ["Fly"] = 123.75, ["Ride"] = 63.25, ["Neon"] = 9.89, ["Neon|Fly"] = 71.86, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 756.93, ["Mega"] = 123.74, ["Mega|Ride"] = 68.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.2, ["Fly"] = 76.05, ["Ride"] = 33, ["Neon"] = 2.2, ["Neon|Fly"] = 33.9, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 90.8, ["Mega"] = 14.95, ["Mega|Fly"] = 152.08, ["Mega|Fly|Ride"] = 189.53}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.2, ["Neon"] = 2.38, ["Neon|Fly"] = 63.8, ["Neon|Ride"] = 133.38, ["Mega"] = 21.89, ["Mega|Fly"] = 226.98, ["Mega|Fly|Ride"] = 384.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.2, ["Fly"] = 151.44, ["Ride"] = 21.53, ["Fly|Ride"] = 46.46, ["Neon"] = 10.61, ["Neon|Fly"] = 61.87, ["Neon|Ride"] = 33.38, ["Neon|Fly|Ride"] = 82.41, ["Mega"] = 181.5, ["Mega|Ride"] = 167.75, ["Mega|Fly|Ride"] = 256.7}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 202.02, ["Ride"] = 233.23, ["Fly|Ride"] = 836.46, ["Neon|Ride"] = 847.7, ["Neon|Fly|Ride"] = 999.81, ["Mega"] = 9078.32, ["Mega|Fly|Ride"] = 3435.02}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.2, ["Ride"] = 29.52, ["Neon"] = 7.62, ["Neon|Ride"] = 67.37, ["Mega"] = 68.75, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.95, ["Fly"] = 108.62, ["Ride"] = 25.87, ["Fly|Ride"] = 68.75, ["Neon"] = 45.41, ["Neon|Ride"] = 61.87, ["Neon|Fly|Ride"] = 181.59, ["Mega"] = 405.63, ["Mega|Ride"] = 240.01, ["Mega|Fly|Ride"] = 684.97}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.2, ["Fly"] = 16.49, ["Ride"] = 16.24, ["Fly|Ride"] = 34.26, ["Neon"] = 6.19, ["Neon|Fly"] = 35.19, ["Neon|Ride"] = 31.63, ["Neon|Fly|Ride"] = 55, ["Mega"] = 52.05, ["Mega|Ride"] = 88, ["Mega|Fly|Ride"] = 152.08}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.2, ["Fly"] = 76.05, ["Ride"] = 20.63, ["Fly|Ride"] = 137.65, ["Neon"] = 9.33, ["Neon|Ride"] = 83.88, ["Neon|Fly|Ride"] = 275, ["Mega"] = 89.1, ["Mega|Fly|Ride"] = 439.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.25, ["Fly"] = 29.29, ["Ride"] = 17.56, ["Fly|Ride"] = 31.63, ["Neon"] = 33, ["Neon|Fly"] = 106.07, ["Neon|Ride"] = 45.37, ["Neon|Fly|Ride"] = 88.94, ["Mega|Ride"] = 907.85, ["Mega|Fly|Ride"] = 297}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.35, ["Ride"] = 36.33, ["Fly|Ride"] = 229.22, ["Neon"] = 53.08, ["Neon|Ride"] = 71.89, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 269.5, ["Mega|Ride"] = 334.78, ["Mega|Fly|Ride"] = 405.62}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.2, ["Fly"] = 19.25, ["Ride"] = 17.48, ["Fly|Ride"] = 34.1, ["Neon"] = 33, ["Neon|Fly"] = 99.69, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 101.73, ["Mega"] = 275, ["Mega|Ride"] = 393.79, ["Mega|Fly|Ride"] = 204.09}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 58.69, ["Ride"] = 98, ["Fly|Ride"] = 151.25, ["Neon"] = 348.39, ["Neon|Fly"] = 471.63, ["Neon|Ride"] = 397.19, ["Neon|Fly|Ride"] = 464.75, ["Mega"] = 2119.79, ["Mega|Fly|Ride"] = 1538.63}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 259.49, ["Fly"] = 453.93, ["Ride"] = 252.69, ["Fly|Ride"] = 316.24, ["Neon|Ride"] = 1182.5, ["Neon|Fly|Ride"] = 1168.75, ["Mega|Fly|Ride"] = 4842.16}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 66, ["Fly"] = 114.72, ["Ride"] = 74.06, ["Fly|Ride"] = 123.75, ["Neon"] = 513.42, ["Neon|Fly"] = 384.71, ["Neon|Ride"] = 307.26, ["Neon|Fly|Ride"] = 449.39, ["Mega|Fly|Ride"] = 1967.74}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.69, ["Fly"] = 301.92, ["Ride"] = 29.95, ["Neon"] = 30.66, ["Neon|Ride"] = 104.04, ["Mega"] = 275, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 342.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.42, ["Ride"] = 25.69, ["Fly|Ride"] = 95, ["Neon"] = 65.99, ["Neon|Ride"] = 93.06, ["Neon|Fly|Ride"] = 151.68, ["Mega"] = 315.57, ["Mega|Ride"] = 343.75, ["Mega|Fly|Ride"] = 397.25}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.2, ["Fly"] = 36.17, ["Ride"] = 16.94, ["Fly|Ride"] = 41.4, ["Neon"] = 3.84, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 66, ["Mega"] = 38.5, ["Mega|Fly"] = 156.59, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 572.42}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.7, ["Fly"] = 72.65, ["Ride"] = 34.36, ["Fly|Ride"] = 69.19, ["Neon"] = 103.5, ["Neon|Fly"] = 303, ["Neon|Ride"] = 121.43, ["Neon|Fly|Ride"] = 303, ["Mega"] = 544.71, ["Mega|Ride"] = 582.7, ["Mega|Fly|Ride"] = 635.5}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.2, ["Fly"] = 44, ["Ride"] = 16.5, ["Fly|Ride"] = 44, ["Neon"] = 17.77, ["Neon|Fly"] = 54.48, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 89.85, ["Mega"] = 151.09, ["Mega|Ride"] = 108.62, ["Mega|Fly|Ride"] = 304.91}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.2, ["Ride"] = 29.31, ["Fly|Ride"] = 343.75, ["Neon"] = 30.66, ["Neon|Ride"] = 90.8, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 217.25, ["Mega|Fly"] = 275, ["Mega|Ride"] = 242.86, ["Mega|Fly|Ride"] = 325.34}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.2, ["Fly"] = 28.99, ["Ride"] = 20.3, ["Neon"] = 2.2, ["Neon|Ride"] = 20.44, ["Neon|Fly|Ride"] = 60.49, ["Mega"] = 15.18, ["Mega|Ride"] = 45.41, ["Mega|Fly|Ride"] = 82.5}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.2, ["Fly"] = 26.12, ["Ride"] = 20, ["Fly|Ride"] = 45.41, ["Neon"] = 26.68, ["Neon|Fly"] = 113.49, ["Neon|Ride"] = 38.52, ["Neon|Fly|Ride"] = 146.34, ["Mega"] = 82.47, ["Mega|Fly|Ride"] = 237.2}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.2, ["Fly"] = 58.72, ["Ride"] = 19.99, ["Fly|Ride"] = 74.5, ["Neon"] = 20.63, ["Neon|Ride"] = 49.5, ["Mega"] = 149.88, ["Mega|Ride"] = 279.13, ["Mega|Fly|Ride"] = 281.45}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 109.99, ["Fly"] = 171.93, ["Ride"] = 154.05, ["Fly|Ride"] = 247.5, ["Neon"] = 450.88, ["Neon|Ride"] = 485.13, ["Neon|Fly|Ride"] = 577.17, ["Mega"] = 4106.99, ["Mega|Fly|Ride"] = 3626.8}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 4.13, ["Ride"] = 136.18, ["Fly|Ride"] = 137.5, ["Neon"] = 31.63, ["Neon|Ride"] = 103.11, ["Neon|Fly|Ride"] = 226.88, ["Mega"] = 294.25, ["Mega|Ride"] = 298.37, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.2, ["Fly"] = 46.11, ["Ride"] = 24.75, ["Fly|Ride"] = 59.06, ["Neon"] = 34.38, ["Neon|Ride"] = 65.97, ["Neon|Fly|Ride"] = 128.13, ["Mega"] = 220, ["Mega|Ride"] = 194.65, ["Mega|Fly|Ride"] = 331.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.13, ["Ride"] = 30.14, ["Fly|Ride"] = 166.58, ["Neon"] = 76.06, ["Neon|Ride"] = 169.02, ["Neon|Fly|Ride"] = 275, ["Mega"] = 524.91, ["Mega|Fly"] = 907.85, ["Mega|Fly|Ride"] = 872.74}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.13}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.13, ["Ride"] = 38.6, ["Fly|Ride"] = 135.06, ["Neon"] = 41.24, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 275, ["Mega"] = 305.43, ["Mega|Ride"] = 627, ["Mega|Fly|Ride"] = 906.78}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.38, ["Fly"] = 34.97, ["Ride"] = 28.88, ["Fly|Ride"] = 74.25, ["Neon"] = 93.5, ["Neon|Fly"] = 106666.66, ["Neon|Ride"] = 170.39, ["Neon|Fly|Ride"] = 151.24, ["Mega"] = 1465.03, ["Mega|Fly|Ride"] = 632.72}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.2, ["Ride"] = 55, ["Neon"] = 3.44, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 144.13, ["Mega"] = 41.25, ["Mega|Fly"] = 198, ["Mega|Ride"] = 45.41, ["Mega|Fly|Ride"] = 243.92}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.13, ["Fly"] = 16.48, ["Ride"] = 29.35, ["Fly|Ride"] = 68.66, ["Neon"] = 68.11, ["Neon|Ride"] = 172.01, ["Mega"] = 302.06, ["Mega|Fly"] = 428.69, ["Mega|Ride"] = 342.72, ["Mega|Fly|Ride"] = 544.71}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.2, ["Fly"] = 30.34, ["Ride"] = 19.66, ["Fly|Ride"] = 50.87, ["Neon"] = 15.13, ["Neon|Fly"] = 195.8, ["Neon|Ride"] = 39.47, ["Neon|Fly|Ride"] = 77.88, ["Mega"] = 103.13, ["Mega|Ride"] = 222.44, ["Mega|Fly|Ride"] = 236.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.2, ["Ride"] = 41.24, ["Neon"] = 3.73, ["Neon|Fly"] = 288.25, ["Neon|Ride"] = 43.63, ["Mega"] = 40.32, ["Mega|Ride"] = 68.75, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.28, ["Fly"] = 94.33, ["Ride"] = 90.26, ["Fly|Ride"] = 143, ["Neon"] = 226.98, ["Neon|Ride"] = 181.59, ["Neon|Fly|Ride"] = 603.63, ["Mega"] = 876.08, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 795.21}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 15.88, ["Fly"] = 30.66, ["Ride"] = 50.88, ["Fly|Ride"] = 220, ["Neon"] = 98.4, ["Mega|Ride"] = 340.44, ["Mega|Fly|Ride"] = 342.69}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.2, ["Fly"] = 24.74, ["Ride"] = 22.37, ["Fly|Ride"] = 66.69, ["Neon"] = 36.33, ["Neon|Fly"] = 90.8, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 68.75, ["Mega"] = 205.57, ["Mega|Ride"] = 143.09, ["Mega|Fly|Ride"] = 294.25}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 67.38, ["Fly"] = 453.74, ["Ride"] = 136.18, ["Neon"] = 607.14, ["Neon|Ride"] = 618.75, ["Neon|Fly|Ride"] = 560.34, ["Mega"] = 4793.62, ["Mega|Ride"] = 1650, ["Mega|Fly|Ride"] = 3850}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.86, ["Fly"] = 48.03, ["Ride"] = 26.02, ["Fly|Ride"] = 51.52, ["Neon"] = 37.13, ["Neon|Ride"] = 50.88, ["Neon|Fly|Ride"] = 126.5, ["Mega"] = 257.98, ["Mega|Ride"] = 289.39, ["Mega|Fly|Ride"] = 378.62}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 75.63, ["Fly"] = 137.49, ["Ride"] = 123.88, ["Fly|Ride"] = 215.88, ["Neon"] = 262.71, ["Neon|Ride"] = 215.6, ["Neon|Fly|Ride"] = 369.51, ["Mega"] = 1067, ["Mega|Ride"] = 1130.72, ["Mega|Fly|Ride"] = 1076.86}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 13.75, ["Ride"] = 63.25, ["Fly|Ride"] = 177.38, ["Neon"] = 75.62, ["Neon|Ride"] = 92.61, ["Neon|Fly|Ride"] = 222.78, ["Mega"] = 343.75, ["Mega|Ride"] = 412.5, ["Mega|Fly|Ride"] = 467.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 18.56, ["Fly"] = 41.25, ["Ride"] = 27.24, ["Fly|Ride"] = 75.87, ["Neon"] = 101.75, ["Neon|Fly|Ride"] = 408.15, ["Mega"] = 599.38, ["Mega|Ride"] = 603.72, ["Mega|Fly|Ride"] = 665.01}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.13, ["Fly"] = 105.25, ["Ride"] = 68.75, ["Fly|Ride"] = 87.11, ["Neon"] = 61.75, ["Neon|Ride"] = 122.58, ["Neon|Fly|Ride"] = 248.34, ["Mega"] = 326, ["Mega|Fly"] = 552.67, ["Mega|Ride"] = 343.75, ["Mega|Fly|Ride"] = 418.17}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.5, ["Ride"] = 31.62, ["Neon"] = 50.88, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 103.5, ["Mega"] = 290.02, ["Mega|Ride"] = 363, ["Mega|Fly|Ride"] = 451.15}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.2, ["Neon"] = 2.2, ["Neon|Fly"] = 101.23, ["Neon|Ride"] = 188.39, ["Mega"] = 20.44, ["Mega|Fly|Ride"] = 605.99}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 6.71, ["Ride"] = 136.12, ["Fly|Ride"] = 341.42, ["Neon"] = 38.01, ["Neon|Ride"] = 217.89, ["Neon|Fly|Ride"] = 211.14, ["Mega"] = 247.5, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 771.68}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.2, ["Fly"] = 135.06, ["Ride"] = 30.66, ["Neon"] = 30.25, ["Neon|Fly"] = 122.51, ["Neon|Ride"] = 103.13, ["Neon|Fly|Ride"] = 242.86, ["Mega"] = 222.06, ["Mega|Ride"] = 342.69, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.36, ["Ride"] = 34.37, ["Neon"] = 14.7, ["Neon|Ride"] = 89.37, ["Neon|Fly|Ride"] = 275, ["Mega"] = 136.18, ["Mega|Ride"] = 303, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 522.39, ["Fly"] = 742.17, ["Ride"] = 605, ["Fly|Ride"] = 659.99, ["Neon"] = 2269.6, ["Neon|Ride"] = 1856.25, ["Neon|Fly|Ride"] = 1733.49, ["Mega|Fly|Ride"] = 6187.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.24, ["Fly"] = 47.63, ["Ride"] = 24.4, ["Fly|Ride"] = 64.68, ["Neon"] = 44.27, ["Neon|Ride"] = 45.38, ["Neon|Fly|Ride"] = 342.38, ["Mega"] = 152.08, ["Mega|Ride"] = 394.04, ["Mega|Fly|Ride"] = 376.77}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 17.87, ["Fly"] = 70.13, ["Ride"] = 21.95, ["Fly|Ride"] = 57.84, ["Neon"] = 99.77, ["Neon|Fly"] = 330, ["Neon|Ride"] = 101.75, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 347.67, ["Mega|Ride"] = 242.86, ["Mega|Fly|Ride"] = 713.9}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.2, ["Fly"] = 26.12, ["Ride"] = 17.88, ["Fly|Ride"] = 53, ["Neon"] = 13.75, ["Neon|Ride"] = 43.99, ["Neon|Fly|Ride"] = 137.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.2, ["Fly"] = 45.25, ["Ride"] = 34.38, ["Fly|Ride"] = 94.88, ["Neon"] = 6.76, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 129.25, ["Mega"] = 75.53, ["Mega|Ride"] = 152.08, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.2, ["Ride"] = 23.37, ["Neon"] = 2.64, ["Neon|Ride"] = 33.18, ["Neon|Fly|Ride"] = 136.03, ["Mega"] = 43.14, ["Mega|Ride"] = 113.49, ["Mega|Fly|Ride"] = 242.86}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1443.74}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.07, ["Ride"] = 45.41, ["Fly|Ride"] = 191.47, ["Neon"] = 72.78, ["Neon|Ride"] = 112.96, ["Mega"] = 428.69, ["Mega|Ride"] = 393.79, ["Mega|Fly|Ride"] = 427.63}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.2, ["Ride"] = 20.17, ["Neon"] = 5.49, ["Neon|Ride"] = 29.52, ["Neon|Fly|Ride"] = 1055.53, ["Mega"] = 34.67, ["Mega|Ride"] = 133.73, ["Mega|Fly|Ride"] = 191.82}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.64, ["Fly"] = 340.66, ["Ride"] = 85.07, ["Fly|Ride"] = 121.95, ["Neon"] = 27.5, ["Neon|Ride"] = 178.64, ["Neon|Fly|Ride"] = 247.5, ["Mega"] = 273.82, ["Mega|Fly"] = 566.27, ["Mega|Ride"] = 369.96, ["Mega|Fly|Ride"] = 1134.81}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 426.91, ["Ride"] = 467.49, ["Fly|Ride"] = 536.25, ["Neon"] = 1771.28, ["Neon|Ride"] = 1789.25, ["Neon|Fly|Ride"] = 1430, ["Mega"] = 8510.92, ["Mega|Fly|Ride"] = 6458.38}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.26, ["Fly"] = 206.25, ["Ride"] = 61.3, ["Fly|Ride"] = 136.18, ["Neon"] = 75.71, ["Neon|Ride"] = 81.13, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 321.17, ["Mega|Ride"] = 380.04, ["Mega|Fly|Ride"] = 544.71}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.2, ["Fly"] = 100.13, ["Ride"] = 34.67, ["Fly|Ride"] = 123.73, ["Neon"] = 2.73, ["Neon|Fly"] = 48.13, ["Neon|Ride"] = 43.99, ["Neon|Fly|Ride"] = 93.14, ["Mega"] = 30.66, ["Mega|Fly"] = 151.44, ["Mega|Ride"] = 91.14, ["Mega|Fly|Ride"] = 215.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.2, ["Ride"] = 55, ["Neon"] = 4.05, ["Neon|Ride"] = 151.33, ["Neon|Fly|Ride"] = 303, ["Mega"] = 34.26, ["Mega|Ride"] = 68.66, ["Mega|Fly|Ride"] = 438.63}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 40.87, ["Fly"] = 113.05, ["Ride"] = 63.25, ["Fly|Ride"] = 126.5, ["Neon"] = 148.5, ["Neon|Ride"] = 240.63, ["Neon|Fly|Ride"] = 349.21, ["Mega"] = 742.17, ["Mega|Ride"] = 605.99, ["Mega|Fly|Ride"] = 701.25}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 11.37, ["Neon|Ride"] = 305.25, ["Neon|Fly|Ride"] = 907.85, ["Mega"] = 599.38, ["Mega|Ride"] = 508.75, ["Mega|Fly|Ride"] = 893.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 8.06, ["Ride"] = 79.75, ["Neon"] = 126.5, ["Neon|Ride"] = 181.59, ["Mega"] = 696.77, ["Mega|Ride"] = 680.88, ["Mega|Fly|Ride"] = 1361.76}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 17.69, ["Ride"] = 30.24, ["Fly|Ride"] = 228.21, ["Neon"] = 151.25, ["Neon|Ride"] = 171.45, ["Neon|Fly|Ride"] = 253, ["Mega"] = 673.75, ["Mega|Ride"] = 817.06, ["Mega|Fly|Ride"] = 635.32}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 384.99, ["Ride"] = 447.68, ["Fly|Ride"] = 771.68, ["Neon"] = 1120.63, ["Neon|Ride"] = 1100, ["Neon|Fly|Ride"] = 1100, ["Mega|Fly|Ride"] = 3506.24}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 8.25, ["Fly"] = 43.88, ["Ride"] = 35.75, ["Fly|Ride"] = 139.02, ["Neon"] = 102.7, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 150.79, ["Mega|Fly"] = 618.75, ["Mega|Ride"] = 587.82, ["Mega|Fly|Ride"] = 907.85}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.61, ["Ride"] = 29.04, ["Fly|Ride"] = 133.38, ["Neon"] = 79.2, ["Neon|Ride"] = 152.08, ["Mega"] = 178.75, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 659.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 27.5, ["Fly"] = 363.16, ["Ride"] = 96.25, ["Neon"] = 134.64, ["Neon|Ride"] = 205.39, ["Neon|Fly|Ride"] = 513.39, ["Mega"] = 378.13, ["Mega|Ride"] = 474.38, ["Mega|Fly|Ride"] = 544.49}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.75, ["Ride"] = 45.41, ["Fly|Ride"] = 226.98, ["Neon"] = 8.25, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 293.94, ["Mega"] = 56.37, ["Mega|Ride"] = 181.59, ["Mega|Fly|Ride"] = 294.44}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 61.03, ["Ride"] = 82.6, ["Neon"] = 274.99, ["Neon|Ride"] = 376.75, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 1732.65, ["Mega|Ride"] = 1664.74, ["Mega|Fly|Ride"] = 1375}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.2, ["Fly"] = 59.13, ["Ride"] = 29.89, ["Neon"] = 11.83, ["Neon|Fly"] = 197.47, ["Neon|Ride"] = 38.49, ["Neon|Fly|Ride"] = 154.03, ["Mega"] = 68.46, ["Mega|Ride"] = 98.14, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.2, ["Fly"] = 30.66, ["Ride"] = 30.25, ["Fly|Ride"] = 102.13, ["Neon"] = 4.12, ["Neon|Fly"] = 66.76, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 144.13, ["Mega"] = 34.37, ["Mega|Fly"] = 118.25, ["Mega|Ride"] = 80.8, ["Mega|Fly|Ride"] = 256.7}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.2, ["Ride"] = 39.88, ["Fly|Ride"] = 274.89, ["Neon"] = 12.38, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 185.63, ["Mega"] = 75.63, ["Mega|Ride"] = 151.25, ["Mega|Fly|Ride"] = 172}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 56.38, ["Fly"] = 68.75, ["Ride"] = 64.52, ["Fly|Ride"] = 258.76, ["Neon"] = 259.88, ["Neon|Ride"] = 457.88, ["Neon|Fly|Ride"] = 513.39, ["Mega|Ride"] = 1210.83, ["Mega|Fly|Ride"] = 1168.75}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2269.6}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 8.08, ["Neon"] = 22.07, ["Neon|Fly"] = 367.13, ["Neon|Ride"] = 77, ["Mega"] = 274.99, ["Mega|Ride"] = 275}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.2, ["Ride"] = 20.65, ["Fly|Ride"] = 82.5, ["Neon"] = 6.74, ["Neon|Ride"] = 75.63, ["Mega"] = 49.78, ["Mega|Fly"] = 220, ["Mega|Ride"] = 96.25, ["Mega|Fly|Ride"] = 252.89}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.73, ["Fly"] = 113.49, ["Ride"] = 34.38, ["Fly|Ride"] = 103.13, ["Neon"] = 34.38, ["Mega"] = 331.47, ["Mega|Ride"] = 368.3, ["Mega|Fly|Ride"] = 418}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.6, ["Ride"] = 48.42, ["Fly|Ride"] = 137.5, ["Neon"] = 28.48, ["Neon|Ride"] = 86.01, ["Neon|Fly|Ride"] = 150.57, ["Mega"] = 187.46, ["Mega|Ride"] = 207.64, ["Mega|Fly|Ride"] = 376.05}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.2, ["Ride"] = 75.01, ["Neon"] = 6.87, ["Neon|Ride"] = 98.74, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 81.13, ["Mega|Fly|Ride"] = 911.26}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.2, ["Fly"] = 55, ["Ride"] = 20.63, ["Fly|Ride"] = 62.58, ["Neon"] = 4.18, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 104.55, ["Mega"] = 43.99, ["Mega|Ride"] = 104.43, ["Mega|Fly|Ride"] = 247.23}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.2, ["Fly"] = 28.81, ["Ride"] = 21.05, ["Fly|Ride"] = 60.5, ["Neon"] = 18.72, ["Neon|Fly"] = 107.83, ["Neon|Ride"] = 42.63, ["Neon|Fly|Ride"] = 121.43, ["Mega"] = 163.6, ["Mega|Ride"] = 148.5, ["Mega|Fly|Ride"] = 255.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 30.66, ["Fly"] = 76.05, ["Ride"] = 28.2, ["Fly|Ride"] = 82.5, ["Neon"] = 151.22, ["Neon|Ride"] = 102.7, ["Mega"] = 481.25, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 685.36}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.87, ["Ride"] = 77, ["Fly|Ride"] = 67.38, ["Neon"] = 377.23, ["Neon|Fly"] = 451.15, ["Neon|Ride"] = 385, ["Neon|Fly|Ride"] = 485.71, ["Mega"] = 2254.85, ["Mega|Ride"] = 1702.19, ["Mega|Fly|Ride"] = 1534.6}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.2, ["Ride"] = 20.33, ["Fly|Ride"] = 151.25, ["Neon"] = 4.13, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 34.76, ["Mega|Fly"] = 704, ["Mega|Ride"] = 96.82, ["Mega|Fly|Ride"] = 239.25}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.2, ["Fly"] = 18.13, ["Ride"] = 16.39, ["Fly|Ride"] = 44.99, ["Neon"] = 5.47, ["Neon|Fly"] = 38.6, ["Neon|Ride"] = 21.88, ["Neon|Fly|Ride"] = 64.63, ["Mega"] = 42.63, ["Mega|Fly"] = 137.45, ["Mega|Ride"] = 52.24, ["Mega|Fly|Ride"] = 82.5}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.2, ["Fly"] = 45.41, ["Ride"] = 39.84, ["Fly|Ride"] = 68.74, ["Neon"] = 42.61, ["Neon|Ride"] = 172.01, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 575.36, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 358.88}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 495, ["Ride"] = 520.13, ["Fly|Ride"] = 467.5, ["Neon"] = 4539.18, ["Neon|Fly|Ride"] = 1856.25, ["Mega|Fly|Ride"] = 6187.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.44, ["Fly"] = 104.49, ["Ride"] = 55, ["Fly|Ride"] = 120.66, ["Neon"] = 228.11, ["Neon|Ride"] = 171.88, ["Neon|Fly|Ride"] = 181.59, ["Mega"] = 908.88, ["Mega|Ride"] = 1198.74, ["Mega|Fly|Ride"] = 906.71}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.2, ["Ride"] = 26.99, ["Fly|Ride"] = 301.51, ["Neon"] = 11.37, ["Neon|Ride"] = 51.75, ["Neon|Fly|Ride"] = 55, ["Mega"] = 76.05, ["Mega|Ride"] = 132, ["Mega|Fly|Ride"] = 866.8}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.2, ["Fly"] = 88.73, ["Ride"] = 57.26, ["Fly|Ride"] = 274.45, ["Neon"] = 151.89, ["Mega"] = 137.5, ["Mega|Fly|Ride"] = 605.99}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.41, ["Fly"] = 177.37, ["Ride"] = 34.98, ["Fly|Ride"] = 106.3, ["Neon"] = 203.5, ["Neon|Ride"] = 229.9, ["Neon|Fly|Ride"] = 299.6, ["Mega|Ride"] = 1361.76, ["Mega|Fly|Ride"] = 1050.5}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 113.19, ["Fly"] = 197.47, ["Ride"] = 134.74, ["Fly|Ride"] = 183.84, ["Neon"] = 450.58, ["Neon|Fly"] = 862.46, ["Neon|Ride"] = 537.9, ["Neon|Fly|Ride"] = 639.38, ["Mega"] = 3329.48, ["Mega|Fly|Ride"] = 6808.74}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 253.46, ["Ride"] = 318.99, ["Fly|Ride"] = 566.27, ["Neon"] = 808.5, ["Neon|Ride"] = 825, ["Neon|Fly|Ride"] = 1084.88, ["Mega|Fly|Ride"] = 3004.38}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.28, ["Ride"] = 57.66, ["Fly|Ride"] = 75.63, ["Neon"] = 103.13, ["Neon|Ride"] = 92.12, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 904.62, ["Mega|Ride"] = 240.63, ["Mega|Fly|Ride"] = 481.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.2, ["Fly"] = 30.35, ["Ride"] = 17.19, ["Fly|Ride"] = 39.88, ["Neon"] = 9.02, ["Neon|Ride"] = 24.67, ["Neon|Fly|Ride"] = 61.3, ["Mega"] = 84.74, ["Mega|Ride"] = 109.99, ["Mega|Fly|Ride"] = 166.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.2, ["Fly"] = 45.38, ["Ride"] = 20.44, ["Fly|Ride"] = 65.99, ["Neon"] = 32.93, ["Neon|Fly"] = 123.75, ["Neon|Ride"] = 45.1, ["Neon|Fly|Ride"] = 136.18, ["Mega"] = 288.25, ["Mega|Ride"] = 279.13, ["Mega|Fly|Ride"] = 303}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 364.38, ["Ride"] = 367.13, ["Fly|Ride"] = 756.25, ["Neon"] = 1418.51, ["Neon|Ride"] = 2164.06, ["Neon|Fly|Ride"] = 2119.79, ["Mega"] = 11347.89, ["Mega|Fly|Ride"] = 5560.48}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.2, ["Ride"] = 35.06, ["Neon"] = 4.82, ["Neon|Ride"] = 146.05, ["Neon|Fly|Ride"] = 123750, ["Mega"] = 35.66, ["Mega|Ride"] = 96.25}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.3, ["Ride"] = 17.12, ["Fly|Ride"] = 44.72, ["Neon"] = 23.38, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 221.29, ["Mega|Fly"] = 303, ["Mega|Ride"] = 154, ["Mega|Fly|Ride"] = 239.25}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.73, ["Fly"] = 6875, ["Ride"] = 61.3, ["Neon"] = 110, ["Neon|Fly"] = 192.5, ["Neon|Ride"] = 109.99, ["Neon|Fly|Ride"] = 316.96, ["Mega"] = 577.5, ["Mega|Ride"] = 680.63, ["Mega|Fly|Ride"] = 756.93}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 119.7, ["Fly"] = 165, ["Ride"] = 135.74, ["Fly|Ride"] = 130.62, ["Neon|Ride"] = 856.12, ["Neon|Fly|Ride"] = 687.5, ["Mega|Fly|Ride"] = 3059.38}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.86, ["Fly"] = 40.32, ["Ride"] = 29.84, ["Fly|Ride"] = 61.78, ["Neon"] = 133.38, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 120.17, ["Mega"] = 917.13, ["Mega|Ride"] = 442.75, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.2, ["Ride"] = 65.41, ["Neon"] = 2.2, ["Neon|Ride"] = 85.12, ["Mega"] = 27.33, ["Mega|Ride"] = 130.52, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.2, ["Ride"] = 17.88, ["Fly|Ride"] = 90.69, ["Neon"] = 2.75, ["Neon|Fly"] = 39.88, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 92, ["Mega"] = 25.85, ["Mega|Fly"] = 106.68, ["Mega|Ride"] = 41.25, ["Mega|Fly|Ride"] = 149.77}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 16.5, ["Ride"] = 75.63, ["Fly|Ride"] = 325.69, ["Neon"] = 27.49, ["Neon|Ride"] = 111.38, ["Neon|Fly|Ride"] = 239.25, ["Mega"] = 173.13, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 360.66}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1210, ["Fly"] = 1601.93, ["Ride"] = 1375, ["Fly|Ride"] = 1375, ["Neon"] = 3437.5, ["Neon|Ride"] = 4539.18, ["Neon|Fly|Ride"] = 4208.54, ["Mega|Fly|Ride"] = 12925}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 433, ["Ride"] = 481.25, ["Fly|Ride"] = 605, ["Neon"] = 1760, ["Neon|Ride"] = 1512.49, ["Neon|Fly|Ride"] = 1581.25, ["Mega|Fly|Ride"] = 6808.74}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 330, ["Fly"] = 433.87, ["Ride"] = 380.88, ["Fly|Ride"] = 459.25, ["Neon"] = 825, ["Neon|Fly"] = 1198.83, ["Neon|Ride"] = 742.5, ["Neon|Fly|Ride"] = 856.06, ["Mega|Ride"] = 3631.35, ["Mega|Fly|Ride"] = 3055.11}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 254.28, ["Fly"] = 325.69, ["Ride"] = 288.75, ["Fly|Ride"] = 389.13, ["Neon"] = 677.88, ["Neon|Ride"] = 715, ["Neon|Fly|Ride"] = 673.75, ["Mega|Fly|Ride"] = 3458.84}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.2, ["Fly"] = 22.72, ["Ride"] = 17.87, ["Fly|Ride"] = 40.84, ["Neon"] = 5.5, ["Neon|Ride"] = 36.41, ["Neon|Fly|Ride"] = 110, ["Mega"] = 68.11, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 165}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 275, ["Fly"] = 487.78, ["Ride"] = 316.25, ["Fly|Ride"] = 378.13, ["Neon"] = 1306.25, ["Neon|Ride"] = 1237.5, ["Neon|Fly|Ride"] = 1732.65, ["Mega"] = 22998.77, ["Mega|Ride"] = 5296.08, ["Mega|Fly|Ride"] = 4812.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.15, ["Fly"] = 151.25, ["Ride"] = 55, ["Neon"] = 27.5, ["Neon|Ride"] = 147.14, ["Neon|Fly|Ride"] = 305.16, ["Mega"] = 178.75, ["Mega|Ride"] = 363.16, ["Mega|Fly|Ride"] = 753.52}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.2, ["Fly"] = 20.63, ["Ride"] = 17.25, ["Fly|Ride"] = 41.25, ["Neon"] = 6.52, ["Neon|Ride"] = 57.9, ["Neon|Fly|Ride"] = 56.37, ["Mega"] = 123.45, ["Mega|Ride"] = 201.47, ["Mega|Fly|Ride"] = 166.7}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.2, ["Fly"] = 60.5, ["Neon"] = 3.94, ["Mega"] = 22.91, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 186.08}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.63, ["Ride"] = 96.25, ["Fly|Ride"] = 481.25, ["Neon"] = 257.13, ["Neon|Ride"] = 376.86, ["Mega"] = 1100, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 809.88}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.2, ["Fly"] = 8556.79, ["Ride"] = 20.63, ["Fly|Ride"] = 71.5, ["Neon"] = 24.74, ["Mega"] = 376.77, ["Mega|Ride"] = 242.86, ["Mega|Fly|Ride"] = 438.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.2, ["Ride"] = 57.75, ["Neon"] = 2.71, ["Neon|Ride"] = 59.13, ["Neon|Fly|Ride"] = 148.69, ["Mega"] = 23.38, ["Mega|Ride"] = 172, ["Mega|Fly|Ride"] = 100.96}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.64, ["Fly"] = 90.09, ["Ride"] = 42.68, ["Fly|Ride"] = 92.13, ["Neon"] = 23.38, ["Neon|Fly"] = 121.43, ["Neon|Ride"] = 57.11, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 165, ["Mega|Ride"] = 204.88, ["Mega|Fly|Ride"] = 330.33}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.85, ["Fly"] = 33.97, ["Ride"] = 23.37, ["Fly|Ride"] = 49.1, ["Neon"] = 30.25, ["Neon|Fly"] = 154.04, ["Neon|Ride"] = 152.08, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 250.22, ["Mega|Ride"] = 263.03, ["Mega|Fly|Ride"] = 1384.63}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 18.98, ["Ride"] = 39.87, ["Fly|Ride"] = 154.04, ["Neon"] = 28.88, ["Neon|Ride"] = 181.59, ["Neon|Fly|Ride"] = 342.69, ["Mega|Ride"] = 849.97}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.2, ["Fly"] = 6846.67, ["Ride"] = 17.88, ["Fly|Ride"] = 137.49, ["Neon"] = 62.07, ["Neon|Ride"] = 225.67, ["Neon|Fly|Ride"] = 770.07, ["Mega"] = 383.63, ["Mega|Ride"] = 529.95, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.2, ["Fly"] = 71.65, ["Ride"] = 17.13, ["Fly|Ride"] = 48.13, ["Neon"] = 5.49, ["Neon|Fly"] = 85.54, ["Neon|Ride"] = 29.52, ["Mega"] = 48.13, ["Mega|Fly|Ride"] = 172}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 168.45, ["Fly"] = 276.91, ["Ride"] = 178.75, ["Fly|Ride"] = 298.38, ["Neon"] = 907.85, ["Neon|Ride"] = 906.71, ["Neon|Fly|Ride"] = 999.76, ["Mega"] = 9078.32, ["Mega|Fly|Ride"] = 4620.35}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.2, ["Fly"] = 24.07, ["Ride"] = 18.08, ["Fly|Ride"] = 38.63, ["Neon"] = 4.02, ["Neon|Fly"] = 38.52, ["Neon|Ride"] = 21.32, ["Neon|Fly|Ride"] = 50.88, ["Mega"] = 52.99, ["Mega|Fly"] = 116.6, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 110}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.73, ["Ride"] = 76.05, ["Fly|Ride"] = 241.89, ["Neon"] = 68.08, ["Neon|Fly|Ride"] = 821.41, ["Mega"] = 366.4, ["Mega|Ride"] = 318.32, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.89, ["Ride"] = 106.68, ["Fly|Ride"] = 192.5, ["Neon"] = 198, ["Neon|Ride"] = 317.39, ["Neon|Fly|Ride"] = 433.95, ["Mega"] = 823.63, ["Mega|Ride"] = 962.49, ["Mega|Fly|Ride"] = 989.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 191.93, ["Fly"] = 233.75, ["Ride"] = 251.93, ["Fly|Ride"] = 316.25, ["Neon"] = 851.09, ["Neon|Ride"] = 735.63, ["Neon|Fly|Ride"] = 891.96, ["Mega|Fly|Ride"] = 3162.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.2, ["Fly"] = 137.35, ["Ride"] = 157.21, ["Neon"] = 153.59, ["Neon|Ride"] = 185.06, ["Neon|Fly|Ride"] = 453.93, ["Mega"] = 277.66, ["Mega|Ride"] = 426.25, ["Mega|Fly|Ride"] = 625.05}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 25.07, ["Ride"] = 60.49, ["Fly|Ride"] = 154.94, ["Neon"] = 152.08, ["Neon|Fly"] = 172.01, ["Neon|Ride"] = 212.23, ["Neon|Fly|Ride"] = 226.98, ["Mega"] = 1815.68, ["Mega|Ride"] = 1513.82, ["Mega|Fly|Ride"] = 753.52}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 989.89, ["Fly"] = 1283.61, ["Ride"] = 1065.51, ["Fly|Ride"] = 1077.99, ["Neon|Ride"] = 6187.5, ["Neon|Fly|Ride"] = 5356.22, ["Mega|Fly|Ride"] = 18141.88}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.09, ["Fly"] = 27.49, ["Ride"] = 17.88, ["Fly|Ride"] = 48.12, ["Neon"] = 48.02, ["Neon|Fly"] = 71.85, ["Neon|Ride"] = 51.47, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 242.86, ["Mega|Ride"] = 303, ["Mega|Fly|Ride"] = 316.69}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.75, ["Fly"] = 82.5, ["Ride"] = 52.24, ["Fly|Ride"] = 141.63, ["Neon"] = 24.75, ["Neon|Ride"] = 113.49, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 222.44, ["Mega|Fly"] = 1320, ["Mega|Ride"] = 347.88, ["Mega|Fly|Ride"] = 357.48}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.2, ["Fly"] = 81.13, ["Ride"] = 22.72, ["Fly|Ride"] = 110, ["Neon"] = 9.68, ["Neon|Ride"] = 50.08, ["Neon|Fly|Ride"] = 178.75, ["Mega"] = 96.25, ["Mega|Ride"] = 377.5, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.13, ["Ride"] = 37.01, ["Fly|Ride"] = 125.79, ["Neon"] = 70.12, ["Neon|Fly"] = 197.33, ["Neon|Ride"] = 103.12, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 467.49, ["Mega|Ride"] = 443.36, ["Mega|Fly|Ride"] = 455.2}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.75, ["Fly"] = 25.19, ["Ride"] = 17.87, ["Fly|Ride"] = 61.3, ["Neon"] = 14.54, ["Neon|Fly"] = 42.97, ["Neon|Ride"] = 33.28, ["Neon|Fly|Ride"] = 81.13, ["Mega"] = 201.43, ["Mega|Fly"] = 294.36, ["Mega|Ride"] = 177.38, ["Mega|Fly|Ride"] = 183.64}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.2, ["Ride"] = 27.39, ["Fly|Ride"] = 137.49, ["Neon"] = 15.89, ["Neon|Fly"] = 13750, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 137.39, ["Mega|Ride"] = 225.5, ["Mega|Fly|Ride"] = 288.73}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 272.25, ["Ride"] = 274.99, ["Fly|Ride"] = 453.93, ["Neon"] = 983.88, ["Neon|Fly|Ride"] = 1239.34, ["Mega|Fly|Ride"] = 4121.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.2, ["Fly"] = 34.38, ["Ride"] = 27.42, ["Fly|Ride"] = 152.08, ["Neon"] = 8.25, ["Neon|Ride"] = 61.78, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 68.97, ["Mega|Ride"] = 112.35, ["Mega|Fly|Ride"] = 351.67}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.13, ["Ride"] = 19.25, ["Fly|Ride"] = 93.09, ["Neon"] = 29.52, ["Neon|Fly"] = 206.25, ["Neon|Ride"] = 197.23, ["Mega"] = 204.88, ["Mega|Ride"] = 363.16}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.3, ["Fly"] = 99.27, ["Ride"] = 35.04, ["Neon"] = 16.17, ["Neon|Ride"] = 50.19, ["Mega"] = 98.99, ["Mega|Ride"] = 126.3, ["Mega|Fly|Ride"] = 528.21}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 86.78, ["Ride"] = 137.5, ["Fly|Ride"] = 261.25, ["Neon"] = 452.79, ["Neon|Ride"] = 467.5, ["Neon|Fly|Ride"] = 574.75, ["Mega"] = 2723.51, ["Mega|Ride"] = 4539.18, ["Mega|Fly|Ride"] = 1643.2}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.6, ["Fly"] = 92.27, ["Ride"] = 66.83, ["Fly|Ride"] = 282.75, ["Neon"] = 133.35, ["Neon|Ride"] = 438.56, ["Neon|Fly|Ride"] = 358.21, ["Mega"] = 687.5, ["Mega|Ride"] = 618.75, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 21.34, ["Fly"] = 254.47, ["Ride"] = 55, ["Fly|Ride"] = 120.3, ["Neon"] = 82.5, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 275, ["Mega"] = 638, ["Mega|Ride"] = 456.5, ["Mega|Fly|Ride"] = 604.48}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 4.13, ["Ride"] = 74.99, ["Neon"] = 16.39, ["Neon|Fly"] = 275, ["Neon|Ride"] = 257.61, ["Mega"] = 137.5, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 34.24, ["Fly"] = 66.69, ["Ride"] = 74.67, ["Fly|Ride"] = 129.24, ["Neon"] = 263.28, ["Neon|Fly"] = 275, ["Neon|Ride"] = 240.63, ["Neon|Fly|Ride"] = 275, ["Mega|Fly|Ride"] = 1059.9}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.2, ["Ride"] = 22, ["Fly|Ride"] = 82.5, ["Neon"] = 5.74, ["Neon|Fly|Ride"] = 135.06, ["Mega"] = 96.25, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 328.63}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.24, ["Fly"] = 41.25, ["Ride"] = 39.8, ["Fly|Ride"] = 97.56, ["Neon"] = 67.61, ["Neon|Fly"] = 88, ["Neon|Ride"] = 86.01, ["Neon|Fly|Ride"] = 213.13, ["Mega"] = 377.88, ["Mega|Fly"] = 1017.5, ["Mega|Ride"] = 453.93, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 52.22, ["Fly"] = 213.13, ["Ride"] = 85.25, ["Fly|Ride"] = 137.5, ["Neon"] = 275, ["Neon|Fly"] = 453.93, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 376.74, ["Mega|Ride"] = 1552.4, ["Mega|Fly|Ride"] = 1314.5}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.2, ["Fly"] = 20.39, ["Ride"] = 17.03, ["Fly|Ride"] = 43.2, ["Neon"] = 2.2, ["Neon|Fly"] = 29.52, ["Neon|Ride"] = 17.74, ["Neon|Fly|Ride"] = 44, ["Mega"] = 25.49, ["Mega|Ride"] = 42.76, ["Mega|Fly|Ride"] = 87.42}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.05, ["Fly"] = 110, ["Ride"] = 25.82, ["Fly|Ride"] = 67.37, ["Neon"] = 19.82, ["Neon|Ride"] = 68.73, ["Neon|Fly|Ride"] = 165, ["Mega"] = 301.4, ["Mega|Ride"] = 315.74, ["Mega|Fly|Ride"] = 397.87}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.62, ["Fly"] = 152.08, ["Ride"] = 43.55, ["Fly|Ride"] = 122.38, ["Neon"] = 116.37, ["Neon|Ride"] = 160.9, ["Neon|Fly|Ride"] = 284.3, ["Mega"] = 742.17, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 605.99}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.2, ["Ride"] = 22.39, ["Neon"] = 2.2, ["Neon|Fly"] = 34.37, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 22, ["Mega|Ride"] = 147.54, ["Mega|Fly|Ride"] = 451.77}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 31.27, ["Fly"] = 220, ["Ride"] = 55, ["Fly|Ride"] = 225.71, ["Neon"] = 152.82, ["Neon|Ride"] = 176.07, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 685.36, ["Mega|Fly"] = 825, ["Mega|Ride"] = 676.35, ["Mega|Fly|Ride"] = 680.88}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 16.5, ["Fly"] = 45.41, ["Ride"] = 27.72, ["Fly|Ride"] = 99.88, ["Neon"] = 69.33, ["Neon|Ride"] = 128.9, ["Neon|Fly|Ride"] = 174.77, ["Mega|Ride"] = 412.5, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.78, ["Ride"] = 59.9, ["Neon"] = 45.41, ["Neon|Fly"] = 732.88, ["Neon|Ride"] = 85.97, ["Neon|Fly|Ride"] = 756.93, ["Mega"] = 247.48, ["Mega|Ride"] = 355.04, ["Mega|Fly|Ride"] = 513.39}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.02, ["Fly"] = 75.63, ["Ride"] = 71.41, ["Fly|Ride"] = 253.72, ["Neon"] = 41.25, ["Neon|Ride"] = 116.33, ["Neon|Fly|Ride"] = 199.37, ["Mega"] = 264.15, ["Mega|Ride"] = 463.38, ["Mega|Fly|Ride"] = 467.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.2, ["Ride"] = 38.5, ["Fly|Ride"] = 206.25, ["Neon"] = 11.15, ["Neon|Fly"] = 220, ["Neon|Ride"] = 39.21, ["Mega"] = 72.88, ["Mega|Fly"] = 226.98, ["Mega|Ride"] = 111.37, ["Mega|Fly|Ride"] = 303}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.2, ["Ride"] = 61.63, ["Neon"] = 4.06, ["Neon|Ride"] = 45.27, ["Mega"] = 48.49, ["Mega|Ride"] = 122.38, ["Mega|Fly|Ride"] = 229.63}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.25, ["Fly"] = 105.88, ["Ride"] = 74.11, ["Fly|Ride"] = 96.23, ["Neon"] = 191.13, ["Neon|Ride"] = 226.98, ["Neon|Fly|Ride"] = 327.25, ["Mega"] = 1942.66, ["Mega|Ride"] = 825, ["Mega|Fly|Ride"] = 894.23}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.2, ["Fly|Ride"] = 113.49, ["Neon"] = 2.75, ["Neon|Ride"] = 120.15, ["Mega"] = 24.75, ["Mega|Ride"] = 120.65, ["Mega|Fly|Ride"] = 340.44}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 550, ["Ride"] = 550, ["Fly|Ride"] = 705.95, ["Neon"] = 3026.5, ["Neon|Ride"] = 2836.99, ["Neon|Fly|Ride"] = 2836.99, ["Mega|Fly|Ride"] = 11000}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 8.07, ["Fly"] = 51.19, ["Ride"] = 35.34, ["Fly|Ride"] = 69.28, ["Neon"] = 48.71, ["Neon|Fly"] = 192.5, ["Neon|Ride"] = 121.42, ["Mega"] = 342.69, ["Mega|Ride"] = 206.24, ["Mega|Fly|Ride"] = 666.13}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.74, ["Fly"] = 26.55, ["Ride"] = 24.73, ["Fly|Ride"] = 49.5, ["Neon"] = 55, ["Neon|Ride"] = 45.38, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 147.54, ["Mega|Fly"] = 303, ["Mega|Ride"] = 184.25, ["Mega|Fly|Ride"] = 240.59}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.09, ["Ride"] = 39.88, ["Neon"] = 118.25, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 328.63, ["Mega"] = 510.67, ["Mega|Ride"] = 407, ["Mega|Fly|Ride"] = 513.39}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.62, ["Fly"] = 61.3, ["Ride"] = 40.41, ["Fly|Ride"] = 76.05, ["Neon"] = 41.12, ["Neon|Fly"] = 76.05, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 411.13, ["Mega"] = 295.63, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 529.95}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 34.38, ["Ride"] = 65.31, ["Fly|Ride"] = 206.25, ["Neon"] = 90.8, ["Neon|Ride"] = 98.99, ["Neon|Fly|Ride"] = 149.81, ["Mega"] = 561.73, ["Mega|Ride"] = 435.6, ["Mega|Fly|Ride"] = 524}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.66, ["Ride"] = 30.25, ["Fly|Ride"] = 106.68, ["Neon"] = 31.63, ["Neon|Ride"] = 101.89, ["Neon|Fly|Ride"] = 292.79, ["Mega"] = 243.27, ["Mega|Ride"] = 296.78, ["Mega|Fly|Ride"] = 365.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.2, ["Fly"] = 49.83, ["Ride"] = 13.75, ["Fly|Ride"] = 35.75, ["Neon"] = 2.2, ["Neon|Fly"] = 43.99, ["Neon|Ride"] = 21.58, ["Neon|Fly|Ride"] = 48.13, ["Mega"] = 15.13, ["Mega|Fly"] = 69.32, ["Mega|Ride"] = 51.35, ["Mega|Fly|Ride"] = 102.45}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.5, ["Fly"] = 52.25, ["Ride"] = 59.13, ["Fly|Ride"] = 113.49, ["Neon"] = 46.81, ["Neon|Fly"] = 128.37, ["Neon|Ride"] = 82.49, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 222.27, ["Mega|Ride"] = 288.25, ["Mega|Fly|Ride"] = 424.43}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 270.88, ["Ride"] = 302.5, ["Fly|Ride"] = 402.12, ["Neon"] = 1210.83, ["Neon|Ride"] = 1093.13, ["Neon|Fly|Ride"] = 1100, ["Mega|Ride"] = 9959.4, ["Mega|Fly|Ride"] = 4536.13}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 103.28, ["Ride"] = 145.27, ["Fly|Ride"] = 270.1, ["Neon"] = 479.88, ["Neon|Fly"] = 971.39, ["Neon|Ride"] = 440, ["Neon|Fly|Ride"] = 549.99, ["Mega"] = 2421.65, ["Mega|Ride"] = 1925, ["Mega|Fly|Ride"] = 2225.47}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.2, ["Fly"] = 16.79, ["Ride"] = 16.99, ["Fly|Ride"] = 38.5, ["Neon"] = 7.68, ["Neon|Fly"] = 106.68, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 84.73, ["Mega"] = 152.08, ["Mega|Fly"] = 225.83, ["Mega|Ride"] = 120.16, ["Mega|Fly|Ride"] = 272.95}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.2, ["Fly"] = 24.84, ["Ride"] = 15.13, ["Fly|Ride"] = 34.37, ["Neon"] = 9.62, ["Neon|Fly"] = 34.01, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 53.35, ["Mega|Fly"] = 303, ["Mega|Ride"] = 93.92, ["Mega|Fly|Ride"] = 151.21}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.2, ["Fly"] = 106.68, ["Ride"] = 23.37, ["Fly|Ride"] = 103.13, ["Neon"] = 110, ["Neon|Ride"] = 44.93, ["Neon|Fly|Ride"] = 165, ["Mega|Ride"] = 347.86, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 220, ["Ride"] = 246.13, ["Fly|Ride"] = 342.4, ["Neon"] = 1248.28, ["Neon|Ride"] = 1168.75, ["Neon|Fly|Ride"] = 1020.2, ["Mega|Ride"] = 9078.32, ["Mega|Fly|Ride"] = 3934.32}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.2, ["Fly"] = 33.16, ["Ride"] = 17.88, ["Fly|Ride"] = 56.75, ["Neon"] = 15.8, ["Neon|Fly"] = 109.97, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 275, ["Mega|Ride"] = 343.75, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.93, ["Ride"] = 80.04, ["Fly|Ride"] = 226.3, ["Neon"] = 25.63, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 303, ["Mega"] = 274.66, ["Mega|Ride"] = 317.63, ["Mega|Fly|Ride"] = 453.93}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.2, ["Ride"] = 137.5, ["Neon"] = 12.38, ["Neon|Ride"] = 144.38, ["Mega"] = 108.9}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.09, ["Fly"] = 52.54, ["Ride"] = 27.5, ["Fly|Ride"] = 62.35, ["Neon"] = 68.75, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 199.37, ["Mega"] = 371.25, ["Mega|Ride"] = 525.25, ["Mega|Fly|Ride"] = 685.36}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.89, ["Ride"] = 89.9, ["Fly|Ride"] = 306.79, ["Neon"] = 96.25, ["Neon|Fly"] = 687.19, ["Neon|Ride"] = 186.54, ["Neon|Fly|Ride"] = 247.49, ["Mega"] = 412.49, ["Mega|Fly"] = 2383.07, ["Mega|Ride"] = 508.75, ["Mega|Fly|Ride"] = 756.93}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 25.06, ["Fly"] = 27.5, ["Ride"] = 53.07, ["Fly|Ride"] = 96.25, ["Neon"] = 163.01, ["Neon|Fly"] = 300.07, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 233.74, ["Mega"] = 907.85, ["Mega|Ride"] = 734.25, ["Mega|Fly|Ride"] = 880}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.2, ["Fly"] = 16.56, ["Ride"] = 14.4, ["Fly|Ride"] = 45.41, ["Neon"] = 2.2, ["Neon|Fly"] = 34.18, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 48.11, ["Mega"] = 20.79, ["Mega|Fly"] = 45.27, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 94.6}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 243.67, ["Ride"] = 258.5, ["Fly|Ride"] = 320.5, ["Neon"] = 3593.87, ["Neon|Ride"] = 1241.48, ["Neon|Fly|Ride"] = 1361.76, ["Mega|Fly|Ride"] = 4993.09}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.63, ["Fly"] = 106, ["Ride"] = 24.22, ["Fly|Ride"] = 97.37, ["Neon"] = 106.68, ["Neon|Ride"] = 69.33, ["Neon|Fly|Ride"] = 453.93, ["Mega"] = 396, ["Mega|Ride"] = 605.99, ["Mega|Fly|Ride"] = 440}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.2, ["Fly"] = 38.08, ["Ride"] = 19.66, ["Fly|Ride"] = 53.12, ["Neon"] = 4.13, ["Neon|Fly"] = 38.81, ["Neon|Ride"] = 30.66, ["Neon|Fly|Ride"] = 103.13, ["Mega"] = 65.48, ["Mega|Fly"] = 242.86, ["Mega|Ride"] = 90.8, ["Mega|Fly|Ride"] = 211}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.2, ["Fly"] = 34.06, ["Ride"] = 26.13, ["Fly|Ride"] = 85.96, ["Neon"] = 2.2, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 61.3, ["Mega"] = 29.96, ["Mega|Fly"] = 151.25, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 171.36}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.2, ["Ride"] = 20.63, ["Fly|Ride"] = 75.62, ["Neon"] = 12.98, ["Neon|Fly"] = 770.13, ["Neon|Ride"] = 55.86, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 162.95, ["Mega|Ride"] = 146.76, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.76, ["Fly"] = 28.25, ["Ride"] = 34.05, ["Fly|Ride"] = 74.25, ["Neon"] = 67.37, ["Neon|Fly"] = 257.61, ["Neon|Ride"] = 49.41, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 299.93, ["Mega|Ride"] = 309.38, ["Mega|Fly|Ride"] = 391.88}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 57.73, ["Ride"] = 34.37, ["Neon"] = 136.13, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 272.36, ["Mega|Ride"] = 342.38, ["Mega|Fly|Ride"] = 439.18}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.2, ["Ride"] = 60.5, ["Neon"] = 2.69, ["Neon|Ride"] = 52.25, ["Neon|Fly|Ride"] = 113.5, ["Mega"] = 20.07, ["Mega|Fly|Ride"] = 177.37}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.12, ["Fly"] = 87.99, ["Ride"] = 34.38, ["Fly|Ride"] = 107.83, ["Neon"] = 40.15, ["Neon|Fly"] = 107.82, ["Neon|Ride"] = 53.63, ["Neon|Fly|Ride"] = 453.93, ["Mega"] = 136.18, ["Mega|Ride"] = 334.82, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.2, ["Ride"] = 32.99, ["Neon"] = 3.79, ["Neon|Fly"] = 121.43, ["Neon|Ride"] = 30.66, ["Neon|Fly|Ride"] = 110, ["Mega"] = 27.42, ["Mega|Ride"] = 128.24, ["Mega|Fly|Ride"] = 212.23}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.2, ["Fly"] = 53.63, ["Ride"] = 18.1, ["Fly|Ride"] = 69.33, ["Neon"] = 3.77, ["Neon|Ride"] = 26.11, ["Neon|Fly|Ride"] = 137.26, ["Mega"] = 48.11, ["Mega|Ride"] = 137.38, ["Mega|Fly|Ride"] = 216.76}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 564.92, ["Ride"] = 653.13, ["Fly|Ride"] = 808.5, ["Neon"] = 2750, ["Neon|Ride"] = 3593.87, ["Neon|Fly|Ride"] = 3300, ["Mega|Fly|Ride"] = 10078.75}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.2, ["Fly"] = 17.15, ["Ride"] = 19.12, ["Fly|Ride"] = 35.75, ["Neon"] = 19.27, ["Neon|Fly"] = 45.19, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 89.37}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.6, ["Ride"] = 60.49, ["Neon"] = 8.25, ["Neon|Fly"] = 794.37, ["Neon|Ride"] = 90.75, ["Neon|Fly|Ride"] = 165, ["Mega"] = 78.69, ["Mega|Ride"] = 158.88, ["Mega|Fly|Ride"] = 286}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.02, ["Fly"] = 24.75, ["Ride"] = 24.31, ["Fly|Ride"] = 50.78, ["Neon"] = 37.13, ["Neon|Fly"] = 204.14, ["Neon|Ride"] = 50.88, ["Neon|Fly|Ride"] = 110, ["Mega"] = 425.55, ["Mega|Ride"] = 323.12, ["Mega|Fly|Ride"] = 339.32}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.2, ["Fly"] = 22.72, ["Ride"] = 16.49, ["Fly|Ride"] = 38.5, ["Neon"] = 9.42, ["Neon|Fly"] = 54.98, ["Neon|Ride"] = 23.13, ["Neon|Fly|Ride"] = 48.13, ["Mega"] = 68.73, ["Mega|Ride"] = 99.05, ["Mega|Fly|Ride"] = 164.8}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 38.5, ["Ride"] = 61.88, ["Fly|Ride"] = 339.32, ["Neon"] = 247.5, ["Neon|Ride"] = 301.87, ["Mega"] = 787.56, ["Mega|Ride"] = 817.06, ["Mega|Fly|Ride"] = 817.06}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.2, ["Ride"] = 26.11, ["Fly|Ride"] = 88, ["Neon"] = 9.62, ["Neon|Fly"] = 146.34, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 49.48, ["Mega|Ride"] = 111.38, ["Mega|Fly|Ride"] = 292.88}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 22.16, ["Fly|Ride"] = 82.66, ["Neon"] = 13.73, ["Neon|Ride"] = 71.5, ["Mega"] = 119.32, ["Mega|Ride"] = 208.05, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.2, ["Ride"] = 45.41, ["Fly|Ride"] = 68.96, ["Neon"] = 12.26, ["Mega"] = 101.75, ["Mega|Ride"] = 96.77, ["Mega|Fly|Ride"] = 618.75}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.2, ["Fly"] = 45.41, ["Ride"] = 17.68, ["Fly|Ride"] = 72.51, ["Neon"] = 4.92, ["Neon|Fly"] = 75.68, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 113.3, ["Mega"] = 51.35, ["Mega|Fly"] = 240.63, ["Mega|Ride"] = 121.43, ["Mega|Fly|Ride"] = 140.73}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.37, ["Fly"] = 22.4, ["Ride"] = 20.81, ["Fly|Ride"] = 41.77, ["Neon"] = 123.75, ["Neon|Fly"] = 206.25, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 147.54, ["Mega|Ride"] = 453.93, ["Mega|Fly|Ride"] = 480.32}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 680.63, ["Fly"] = 1134.81, ["Ride"] = 811.25, ["Fly|Ride"] = 818.13, ["Neon"] = 1659.63, ["Neon|Ride"] = 1870, ["Neon|Fly|Ride"] = 2268.75, ["Mega"] = 8937.5, ["Mega|Ride"] = 5969, ["Mega|Fly|Ride"] = 4730}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.2, ["Fly"] = 19.14, ["Ride"] = 17.33, ["Fly|Ride"] = 49.48, ["Neon"] = 4, ["Neon|Fly"] = 53.35, ["Neon|Ride"] = 20.41, ["Neon|Fly|Ride"] = 73.18, ["Mega"] = 38.5, ["Mega|Ride"] = 90.8, ["Mega|Fly|Ride"] = 309.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 9.62, ["Ride"] = 38.49, ["Fly|Ride"] = 61.88, ["Neon|Ride"] = 226.98, ["Neon|Fly|Ride"] = 247.5, ["Mega"] = 453.6, ["Mega|Ride"] = 412.5, ["Mega|Fly|Ride"] = 453.93}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 53.48, ["Fly"] = 87.29, ["Ride"] = 67.37, ["Fly|Ride"] = 103.13, ["Neon"] = 275, ["Neon|Ride"] = 307.54, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 2556.01, ["Mega|Fly|Ride"] = 2748.63}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 33.69, ["Fly"] = 153.85, ["Ride"] = 54.8, ["Fly|Ride"] = 107.25, ["Neon"] = 242.86, ["Neon|Ride"] = 135.37, ["Mega"] = 1540.13, ["Mega|Ride"] = 982.73, ["Mega|Fly|Ride"] = 763.13}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.85, ["Fly"] = 100.13, ["Ride"] = 27.5, ["Neon"] = 61.88, ["Neon|Ride"] = 132, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 319.9, ["Mega|Ride"] = 452.79, ["Mega|Fly|Ride"] = 484}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.45, ["Ride"] = 61.88, ["Fly|Ride"] = 152.08, ["Neon"] = 110, ["Neon|Ride"] = 111.38, ["Neon|Fly|Ride"] = 159.5, ["Mega"] = 355.45, ["Mega|Ride"] = 412.5, ["Mega|Fly|Ride"] = 416.63}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 24.07, ["Ride"] = 42.63, ["Neon"] = 153.54, ["Neon|Ride"] = 206.25, ["Neon|Fly|Ride"] = 550, ["Mega"] = 561.73, ["Mega|Fly"] = 594, ["Mega|Ride"] = 499.13, ["Mega|Fly|Ride"] = 825}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.17}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.88, ["Ride"] = 30.25, ["Fly|Ride"] = 82.5, ["Neon"] = 33, ["Neon|Ride"] = 82.41, ["Neon|Fly|Ride"] = 224.16, ["Mega"] = 220, ["Mega|Fly"] = 480.09, ["Mega|Ride"] = 247.5, ["Mega|Fly|Ride"] = 267.82}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.2, ["Neon"] = 19.03, ["Mega"] = 145.95, ["Mega|Fly|Ride"] = 440}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 34.37, ["Fly"] = 65.99, ["Ride"] = 46.19, ["Fly|Ride"] = 87.25, ["Neon"] = 231, ["Neon|Fly"] = 303, ["Neon|Ride"] = 242, ["Neon|Fly|Ride"] = 247.5, ["Mega|Ride"] = 756.93, ["Mega|Fly|Ride"] = 710.88}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.8, ["Fly"] = 18.8, ["Ride"] = 19.07, ["Fly|Ride"] = 45.38, ["Neon"] = 30.25, ["Neon|Fly"] = 72.88, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 74.25, ["Mega"] = 245.13, ["Mega|Fly"] = 452.79, ["Mega|Ride"] = 192.5, ["Mega|Fly|Ride"] = 207.61}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.79, ["Fly"] = 33.38, ["Ride"] = 27.41, ["Fly|Ride"] = 57.9, ["Neon"] = 22.44, ["Neon|Ride"] = 59.13, ["Neon|Fly|Ride"] = 134.75, ["Mega"] = 230.64, ["Mega|Ride"] = 153.89, ["Mega|Fly|Ride"] = 258.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.2, ["Neon"] = 8.25, ["Mega"] = 42.63, ["Mega|Ride"] = 213.13, ["Mega|Fly|Ride"] = 270.88}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 27.21, ["Ride"] = 55.93, ["Fly|Ride"] = 152.08, ["Neon"] = 171.41, ["Neon|Ride"] = 303, ["Neon|Fly|Ride"] = 475.75, ["Mega|Ride"] = 898.77, ["Mega|Fly|Ride"] = 880}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.2, ["Ride"] = 33.86, ["Fly|Ride"] = 61.21, ["Neon"] = 8.01, ["Neon|Fly"] = 213.13, ["Neon|Ride"] = 43.98, ["Neon|Fly|Ride"] = 110, ["Mega"] = 82.49, ["Mega|Ride"] = 146.6}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.25, ["Ride"] = 92.13, ["Fly|Ride"] = 301.87, ["Neon"] = 61.88, ["Neon|Ride"] = 178.75, ["Neon|Fly|Ride"] = 340.44, ["Mega"] = 262.63, ["Mega|Fly"] = 605.99, ["Mega|Ride"] = 419.85, ["Mega|Fly|Ride"] = 561.73}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.2, ["Fly"] = 48.12, ["Ride"] = 12.5, ["Fly|Ride"] = 46.75, ["Neon"] = 18.97, ["Neon|Ride"] = 25.34, ["Neon|Fly|Ride"] = 104.49, ["Mega"] = 203.5, ["Mega|Ride"] = 212.45, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.2, ["Fly"] = 54.99, ["Ride"] = 19.05, ["Fly|Ride"] = 49.56, ["Neon"] = 52.01, ["Neon|Ride"] = 136.13, ["Neon|Fly|Ride"] = 178.75, ["Mega"] = 641.73, ["Mega|Ride"] = 452.79, ["Mega|Fly|Ride"] = 328.63}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 13.42, ["Ride"] = 36.33, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 437.97, ["Mega|Ride"] = 383.63, ["Mega|Fly|Ride"] = 676.49}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 48.11, ["Ride"] = 110, ["Neon"] = 493.65, ["Neon|Ride"] = 509.54, ["Neon|Fly|Ride"] = 905.57, ["Mega|Fly|Ride"] = 2042.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.13, ["Ride"] = 82.5, ["Fly|Ride"] = 168.96, ["Neon"] = 112.74, ["Neon|Fly|Ride"] = 213.13, ["Mega"] = 441.37, ["Mega|Ride"] = 438.63, ["Mega|Fly|Ride"] = 750.07}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.89, ["Ride"] = 118.32, ["Neon"] = 97.61, ["Neon|Fly"] = 226.98, ["Neon|Ride"] = 178.75, ["Mega|Ride"] = 537.9}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 25.71, ["Ride"] = 110, ["Fly|Ride"] = 384.98, ["Neon"] = 140.55, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 711.54, ["Mega|Fly"] = 2269.6, ["Mega|Ride"] = 669.54, ["Mega|Fly|Ride"] = 851.1}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.2, ["Neon"] = 20.88, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 192.93, ["Mega|Ride"] = 266.96, ["Mega|Fly|Ride"] = 342.69}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.2, ["Fly"] = 137.5, ["Ride"] = 20.5, ["Fly|Ride"] = 45.41, ["Neon"] = 3.79, ["Neon|Fly"] = 45.07, ["Neon|Ride"] = 34.53, ["Neon|Fly|Ride"] = 68.19, ["Mega"] = 61.05, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 151.25}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.83, ["Fly"] = 48.13, ["Ride"] = 25.69, ["Fly|Ride"] = 81.55, ["Neon"] = 15.29, ["Neon|Ride"] = 52.25, ["Neon|Fly|Ride"] = 171.87, ["Mega"] = 93.5, ["Mega|Ride"] = 109.98, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.2, ["Fly"] = 152.08, ["Ride"] = 23.38, ["Fly|Ride"] = 75.44, ["Neon"] = 6.65, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 96.57, ["Mega"] = 45.28, ["Mega|Ride"] = 93.12, ["Mega|Fly|Ride"] = 175.75}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.9, ["Fly"] = 68.75, ["Ride"] = 19.9, ["Fly|Ride"] = 76.05, ["Neon"] = 19.45, ["Neon|Ride"] = 113.49, ["Neon|Fly|Ride"] = 226.98, ["Mega"] = 343.75, ["Mega|Ride"] = 347.26, ["Mega|Fly|Ride"] = 379.5}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.33, ["Fly"] = 60.57, ["Ride"] = 25.69, ["Fly|Ride"] = 453.93, ["Neon"] = 31.63, ["Neon|Fly"] = 330, ["Neon|Ride"] = 92.13, ["Mega"] = 322.29, ["Mega|Ride"] = 301.16, ["Mega|Fly|Ride"] = 1134.81}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.37, ["Fly"] = 137.5, ["Ride"] = 23.38, ["Fly|Ride"] = 59.98, ["Neon"] = 30.25, ["Neon|Fly"] = 136.18, ["Neon|Ride"] = 57.52, ["Neon|Fly|Ride"] = 86.63, ["Mega|Ride"] = 291.35, ["Mega|Fly|Ride"] = 488.81}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.74, ["Fly"] = 37.18, ["Ride"] = 23.38, ["Fly|Ride"] = 54.91, ["Neon"] = 27.5, ["Neon|Ride"] = 72.37, ["Neon|Fly|Ride"] = 113.49, ["Mega"] = 288.07, ["Mega|Ride"] = 330.7, ["Mega|Fly|Ride"] = 195.05}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.43, ["Fly"] = 302.47, ["Ride"] = 49.48, ["Fly|Ride"] = 137.5, ["Neon"] = 14.66, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 113.18, ["Mega"] = 123.75, ["Mega|Fly"] = 226.88, ["Mega|Ride"] = 137.49, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.5, ["Fly"] = 119.17, ["Ride"] = 122.5, ["Fly|Ride"] = 346.5, ["Neon"] = 169.13, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 253, ["Mega"] = 870.18, ["Mega|Ride"] = 828.88, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.98, ["Fly"] = 171.88, ["Ride"] = 90.8, ["Fly|Ride"] = 189.97, ["Neon"] = 252.37, ["Neon|Ride"] = 247.5, ["Neon|Fly|Ride"] = 352, ["Mega"] = 1663.61, ["Mega|Ride"] = 1100, ["Mega|Fly|Ride"] = 1511.56}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.2, ["Ride"] = 22.61, ["Fly|Ride"] = 54.48, ["Neon"] = 3.78, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 28.85, ["Mega|Ride"] = 74.42, ["Mega|Fly|Ride"] = 112.75}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.73, ["Neon"] = 110.98, ["Mega"] = 719.25, ["Mega|Fly|Ride"] = 1196.08}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.75, ["Ride"] = 96.29, ["Neon"] = 261.24, ["Neon|Ride"] = 360.77, ["Neon|Fly|Ride"] = 906.71, ["Mega"] = 1870.15, ["Mega|Fly|Ride"] = 1527.63}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.99, ["Fly"] = 199.38, ["Ride"] = 28.48, ["Fly|Ride"] = 140.25, ["Neon"] = 41.25, ["Neon|Fly"] = 137.35, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 133.92, ["Mega"] = 280.2, ["Mega|Fly"] = 775.2, ["Mega|Ride"] = 256.03, ["Mega|Fly|Ride"] = 284.63}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.41, ["Neon"] = 8.25, ["Mega"] = 106.68, ["Mega|Fly"] = 295.61, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 278.1}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.2, ["Fly"] = 35.66, ["Ride"] = 20.35, ["Fly|Ride"] = 49.8, ["Neon"] = 15.66, ["Neon|Fly"] = 48.13, ["Neon|Ride"] = 38.99, ["Neon|Fly|Ride"] = 97.07, ["Mega"] = 181.5, ["Mega|Fly"] = 206.24, ["Mega|Ride"] = 137.39}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.2, ["Fly"] = 17.92, ["Ride"] = 16.98, ["Fly|Ride"] = 54.8, ["Neon"] = 2.57, ["Neon|Fly"] = 136.18, ["Neon|Ride"] = 33, ["Neon|Fly|Ride"] = 54.91, ["Mega"] = 24.74, ["Mega|Ride"] = 77.03, ["Mega|Fly|Ride"] = 162.17}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.2, ["Ride"] = 21.58, ["Fly|Ride"] = 97.52, ["Neon"] = 5.25, ["Neon|Ride"] = 26.12, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 76.05, ["Mega|Fly"] = 108.06, ["Mega|Ride"] = 90.8, ["Mega|Fly|Ride"] = 181.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.2, ["Ride"] = 44.27, ["Neon"] = 2.2, ["Neon|Ride"] = 151.99, ["Mega"] = 26.13, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.26, ["Ride"] = 165, ["Neon"] = 42.63, ["Neon|Ride"] = 88, ["Neon|Fly|Ride"] = 148.5, ["Mega"] = 428.69, ["Mega|Ride"] = 302.5, ["Mega|Fly|Ride"] = 448.95}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.16, ["Ride"] = 31.63, ["Fly|Ride"] = 225.91, ["Neon"] = 64.63, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 242, ["Mega"] = 299.07, ["Mega|Ride"] = 233.75, ["Mega|Fly|Ride"] = 350.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 10.98, ["Fly"] = 28.47, ["Ride"] = 19.25, ["Fly|Ride"] = 52.11, ["Neon"] = 34.38, ["Neon|Fly"] = 121.43, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 369.96, ["Mega|Ride"] = 326.2, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.49, ["Ride"] = 100.38, ["Fly|Ride"] = 130.63, ["Neon"] = 412.5, ["Neon|Ride"] = 500.46, ["Neon|Fly|Ride"] = 756.93, ["Mega"] = 2566.88, ["Mega|Ride"] = 1710.14, ["Mega|Fly|Ride"] = 1618.38}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.39, ["Fly"] = 86.63, ["Ride"] = 61.49, ["Fly|Ride"] = 121.43, ["Neon"] = 61.3, ["Neon|Fly|Ride"] = 660, ["Mega"] = 486.75, ["Mega|Ride"] = 921.25, ["Mega|Fly|Ride"] = 1086.95}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.2, ["Fly"] = 20.63, ["Ride"] = 16.7, ["Fly|Ride"] = 43.54, ["Neon"] = 2.73, ["Neon|Fly"] = 45.41, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 59.13, ["Mega"] = 19.25, ["Mega|Ride"] = 98.49, ["Mega|Fly|Ride"] = 340.44}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.2, ["Fly"] = 16.5, ["Ride"] = 16.28, ["Fly|Ride"] = 36.82, ["Neon"] = 5.39, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 19.25, ["Neon|Fly|Ride"] = 48.13, ["Mega"] = 57.75, ["Mega|Ride"] = 51.72, ["Mega|Fly|Ride"] = 94.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 426.25, ["Fly"] = 603.3, ["Ride"] = 426.78, ["Fly|Ride"] = 543.13, ["Neon|Ride"] = 2131.25, ["Neon|Fly|Ride"] = 2197.25, ["Mega|Fly|Ride"] = 7187.77}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.3, ["Ride"] = 44, ["Neon"] = 42.19, ["Neon|Ride"] = 94.88, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 422.71, ["Mega|Ride"] = 755.78, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.2, ["Fly"] = 16.47, ["Ride"] = 16.5, ["Fly|Ride"] = 52.22, ["Neon"] = 4.03, ["Neon|Fly"] = 20.42, ["Neon|Ride"] = 21.58, ["Neon|Fly|Ride"] = 59.11, ["Mega"] = 41.16, ["Mega|Ride"] = 45.38, ["Mega|Fly|Ride"] = 120.65}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 45.38, ["Ride"] = 122.46, ["Fly|Ride"] = 299.6, ["Neon"] = 158.13, ["Neon|Ride"] = 272.14, ["Neon|Fly|Ride"] = 459.25, ["Mega"] = 734.23, ["Mega|Ride"] = 715, ["Mega|Fly|Ride"] = 756.25}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.2, ["Fly"] = 26.05, ["Ride"] = 22.3, ["Fly|Ride"] = 128.37, ["Neon"] = 25.71, ["Neon|Fly"] = 127.88, ["Neon|Ride"] = 31.13, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 170.23, ["Mega|Ride"] = 136.11, ["Mega|Fly|Ride"] = 233.75}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.2, ["Ride"] = 56.75, ["Fly|Ride"] = 206.25, ["Neon"] = 2.2, ["Neon|Fly"] = 106.68, ["Neon|Ride"] = 50.88, ["Neon|Fly|Ride"] = 116.87, ["Mega"] = 18.57, ["Mega|Ride"] = 60.34, ["Mega|Fly|Ride"] = 242.86}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 33, ["Fly"] = 136.13, ["Ride"] = 81.13, ["Fly|Ride"] = 225.5, ["Neon"] = 137.5, ["Neon|Ride"] = 169.13, ["Neon|Fly|Ride"] = 302.49, ["Mega"] = 742.17, ["Mega|Ride"] = 677.86, ["Mega|Fly|Ride"] = 715}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.2, ["Fly"] = 26.13, ["Ride"] = 24.75, ["Fly|Ride"] = 153.99, ["Neon"] = 5.53, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 90.8, ["Mega"] = 65.83, ["Mega|Ride"] = 170.09, ["Mega|Fly|Ride"] = 264}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 30.24, ["Ride"] = 64.44, ["Fly|Ride"] = 109.99, ["Neon"] = 296.72, ["Neon|Ride"] = 330, ["Neon|Fly|Ride"] = 342.69, ["Mega"] = 1237.5, ["Mega|Ride"] = 1361.76, ["Mega|Fly|Ride"] = 1397.35}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.09, ["Fly"] = 76.05, ["Ride"] = 137.5, ["Fly|Ride"] = 453.93, ["Neon"] = 18.64, ["Neon|Ride"] = 242, ["Neon|Fly|Ride"] = 172, ["Mega"] = 177.38, ["Mega|Ride"] = 250.8, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.2, ["Fly"] = 76.05, ["Ride"] = 83.49, ["Fly|Ride"] = 61.3, ["Neon"] = 9.99, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 462.05, ["Mega"] = 123.2, ["Mega|Ride"] = 130.63, ["Mega|Fly|Ride"] = 232.38}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 60.17, ["Fly"] = 197.47, ["Ride"] = 116.88, ["Fly|Ride"] = 171.01, ["Neon"] = 368.01, ["Neon|Ride"] = 439.07, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2119.79}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.2, ["Fly"] = 615.45, ["Ride"] = 30.8, ["Neon"] = 9.52, ["Neon|Ride"] = 60.34, ["Neon|Fly|Ride"] = 121.43, ["Mega"] = 49.48, ["Mega|Fly"] = 226.98, ["Mega|Ride"] = 90.59, ["Mega|Fly|Ride"] = 290.51}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.2, ["Fly"] = 21.91, ["Ride"] = 20.42, ["Fly|Ride"] = 38.6, ["Neon"] = 5.35, ["Neon|Fly"] = 44, ["Neon|Ride"] = 27.14, ["Neon|Fly|Ride"] = 76.82, ["Mega"] = 61.95, ["Mega|Fly"] = 157.88, ["Mega|Ride"] = 85.24, ["Mega|Fly|Ride"] = 229.88}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.34, ["Fly"] = 60.67, ["Ride"] = 16.5, ["Fly|Ride"] = 205.39, ["Neon"] = 84.03, ["Neon|Ride"] = 59.13, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 220, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 379.04}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.88, ["Fly"] = 45.41, ["Ride"] = 33.81, ["Fly|Ride"] = 82.5, ["Neon"] = 54.91, ["Neon|Ride"] = 65.6, ["Neon|Fly|Ride"] = 146.37, ["Mega"] = 371.25, ["Mega|Ride"] = 481.25, ["Mega|Fly|Ride"] = 440.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.75, ["Fly"] = 53.63, ["Ride"] = 29.52, ["Fly|Ride"] = 69.33, ["Neon"] = 95.33, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 158.67, ["Mega"] = 424.43, ["Mega|Ride"] = 343.04, ["Mega|Fly|Ride"] = 379.04}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 74.01, ["Ride"] = 121, ["Fly|Ride"] = 203.49, ["Neon"] = 269.5, ["Neon|Ride"] = 308, ["Neon|Fly|Ride"] = 467.5, ["Mega"] = 1650, ["Mega|Ride"] = 1724.9, ["Mega|Fly|Ride"] = 1722.63}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 10.55, ["Ride"] = 120.89, ["Fly|Ride"] = 106.68, ["Neon"] = 64.68, ["Neon|Ride"] = 121, ["Neon|Fly|Ride"] = 313.5, ["Mega"] = 253, ["Mega|Fly"] = 603.72, ["Mega|Ride"] = 423.5, ["Mega|Fly|Ride"] = 650.71}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.82, ["Ride"] = 26.79, ["Fly|Ride"] = 82.48, ["Neon"] = 25.69, ["Neon|Ride"] = 46.75, ["Mega"] = 359.37, ["Mega|Ride"] = 171.36, ["Mega|Fly|Ride"] = 513.39}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.59, ["Fly"] = 141.63, ["Ride"] = 38.12, ["Fly|Ride"] = 121, ["Neon"] = 66.76, ["Neon|Ride"] = 114.43, ["Neon|Fly|Ride"] = 183.44, ["Mega"] = 332.75, ["Mega|Ride"] = 398.34, ["Mega|Fly|Ride"] = 521.13}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.2, ["Fly"] = 16.5, ["Ride"] = 13.07, ["Fly|Ride"] = 43.47, ["Neon"] = 2.2, ["Neon|Fly"] = 41.25, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 61.3, ["Mega"] = 15.13, ["Mega|Fly"] = 44, ["Mega|Ride"] = 29.37, ["Mega|Fly|Ride"] = 120.99}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 50.88, ["Fly"] = 171.88, ["Ride"] = 107.25, ["Neon"] = 247.39, ["Neon|Fly"] = 2572.57, ["Neon|Ride"] = 308, ["Neon|Fly|Ride"] = 510.67, ["Mega"] = 1134.81, ["Mega|Ride"] = 1148.68, ["Mega|Fly|Ride"] = 893.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.2, ["Ride"] = 25.18, ["Fly|Ride"] = 152.08, ["Neon"] = 8.09, ["Neon|Ride"] = 46.75, ["Neon|Fly|Ride"] = 136.12, ["Mega"] = 33, ["Mega|Ride"] = 91.14, ["Mega|Fly|Ride"] = 328.63}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.2, ["Fly"] = 30.54, ["Ride"] = 18.43, ["Fly|Ride"] = 48.13, ["Neon"] = 19.12, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 67.38, ["Mega"] = 269.5, ["Mega|Ride"] = 206.24, ["Mega|Fly|Ride"] = 239.25}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 61.88, ["Fly"] = 113.49, ["Ride"] = 94.87, ["Fly|Ride"] = 178.75, ["Neon"] = 206.25, ["Neon|Ride"] = 273.63, ["Neon|Fly|Ride"] = 330, ["Mega"] = 875.96, ["Mega|Ride"] = 1189.38, ["Mega|Fly|Ride"] = 1072.5}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.2, ["Ride"] = 75.63, ["Neon"] = 9.63, ["Neon|Ride"] = 1513.82, ["Mega"] = 44.99, ["Mega|Fly"] = 166.86, ["Mega|Ride"] = 122.37, ["Mega|Fly|Ride"] = 439.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.38}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.2, ["Ride"] = 16.5, ["Fly|Ride"] = 74.94, ["Neon"] = 8.23, ["Neon|Ride"] = 22.72, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 108.52, ["Mega|Fly"] = 197.47, ["Mega|Ride"] = 109.89, ["Mega|Fly|Ride"] = 219.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 137.38, ["Ride"] = 205.4, ["Fly|Ride"] = 356.34, ["Neon"] = 635.5, ["Neon|Ride"] = 608.57, ["Neon|Fly|Ride"] = 710.88, ["Mega"] = 6808.74, ["Mega|Ride"] = 3422.91, ["Mega|Fly|Ride"] = 2772.31}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.37, ["Ride"] = 38.6, ["Fly|Ride"] = 128.37, ["Neon"] = 24.46, ["Neon|Fly"] = 152.08, ["Neon|Ride"] = 108.4, ["Neon|Fly|Ride"] = 229.88, ["Mega"] = 186.98, ["Mega|Ride"] = 234.3, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.2, ["Fly"] = 27.5, ["Ride"] = 104.7, ["Neon"] = 3.96, ["Neon|Ride"] = 22.33, ["Mega"] = 39.73, ["Mega|Fly"] = 68.75, ["Mega|Ride"] = 74.45, ["Mega|Fly|Ride"] = 363.16}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.03, ["Ride"] = 34.38, ["Fly|Ride"] = 137.5, ["Neon"] = 68.66, ["Neon|Ride"] = 93.9, ["Neon|Fly|Ride"] = 167.96, ["Mega"] = 283.72, ["Mega|Ride"] = 439.18, ["Mega|Fly|Ride"] = 702.45}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.53, ["Fly"] = 44.16, ["Ride"] = 23.38, ["Fly|Ride"] = 65.83, ["Neon"] = 105.84, ["Neon|Ride"] = 166.86, ["Neon|Fly|Ride"] = 206.95, ["Mega"] = 664.29, ["Mega|Ride"] = 452.79, ["Mega|Fly|Ride"] = 515.63}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22, ["Ride"] = 59.42, ["Fly|Ride"] = 180.71, ["Neon"] = 134.75, ["Neon|Ride"] = 197.47, ["Neon|Fly|Ride"] = 344.99, ["Mega"] = 587.83, ["Mega|Ride"] = 412.5, ["Mega|Fly|Ride"] = 481.25}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 151.25, ["Fly"] = 206.03, ["Ride"] = 200.75, ["Fly|Ride"] = 261.14, ["Neon"] = 605, ["Neon|Fly"] = 856.12, ["Neon|Ride"] = 593.99, ["Neon|Fly|Ride"] = 673.64, ["Mega|Fly|Ride"] = 2269.6}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.99, ["Fly"] = 24.51, ["Ride"] = 24.22, ["Fly|Ride"] = 45.6, ["Neon"] = 52.06, ["Neon|Fly"] = 61.3, ["Neon|Ride"] = 55.06, ["Neon|Fly|Ride"] = 67.38, ["Mega"] = 340.44, ["Mega|Fly|Ride"] = 431.24}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.2, ["Fly"] = 137.48, ["Ride"] = 29.09, ["Fly|Ride"] = 68.75, ["Neon"] = 15.13, ["Neon|Ride"] = 41.21, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 147.04, ["Mega|Ride"] = 197.47, ["Mega|Fly|Ride"] = 298.38}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 2.2, ["Fly"] = 43.89, ["Ride"] = 39.49, ["Fly|Ride"] = 94.88, ["Neon"] = 30.25, ["Neon|Fly"] = 76.05, ["Neon|Ride"] = 53.89, ["Neon|Fly|Ride"] = 181.59, ["Mega"] = 479.88, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1368.58}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44, ["Fly"] = 121.43, ["Ride"] = 68.05, ["Fly|Ride"] = 139.59, ["Neon"] = 220, ["Neon|Fly"] = 178.75, ["Neon|Ride"] = 258.88, ["Neon|Fly|Ride"] = 269.53, ["Mega"] = 1015.66, ["Mega|Ride"] = 969.38, ["Mega|Fly|Ride"] = 1003.75}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.03, ["Fly"] = 60.5, ["Ride"] = 273.49, ["Neon"] = 206.25, ["Neon|Ride"] = 272.36, ["Neon|Fly|Ride"] = 500.46, ["Mega"] = 1100, ["Mega|Ride"] = 2024, ["Mega|Fly|Ride"] = 862.46}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 302.5, ["Ride"] = 367.13, ["Neon"] = 1712.24, ["Neon|Ride"] = 3422.91, ["Mega|Fly|Ride"] = 5447}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 20.63, ["Fly"] = 61.43, ["Ride"] = 35.64, ["Fly|Ride"] = 72.76, ["Neon"] = 225.91, ["Neon|Ride"] = 136.18, ["Neon|Fly|Ride"] = 212.08, ["Mega"] = 797.5, ["Mega|Ride"] = 789.2, ["Mega|Fly|Ride"] = 885.15}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.2, ["Fly"] = 45.41, ["Ride"] = 14.98, ["Fly|Ride"] = 73.51, ["Neon"] = 2.64, ["Neon|Ride"] = 16.48, ["Neon|Fly|Ride"] = 90.79, ["Mega"] = 22, ["Mega|Fly"] = 120.3, ["Mega|Ride"] = 52.68, ["Mega|Fly|Ride"] = 123.07}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 4.13, ["Ride"] = 30.66, ["Neon"] = 16.17, ["Neon|Ride"] = 549.98, ["Neon|Fly|Ride"] = 172, ["Mega"] = 116.88, ["Mega|Ride"] = 172, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.75, ["Ride"] = 34.37, ["Fly|Ride"] = 151.07, ["Neon"] = 26.12, ["Neon|Ride"] = 79.75, ["Neon|Fly|Ride"] = 1237.5, ["Mega"] = 139.98, ["Mega|Fly"] = 602.39, ["Mega|Ride"] = 397.19, ["Mega|Fly|Ride"] = 358.2}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 374, ["Fly"] = 529.38, ["Ride"] = 438.41, ["Fly|Ride"] = 539.04, ["Neon"] = 1988.89, ["Neon|Ride"] = 2101.64, ["Neon|Fly|Ride"] = 1650, ["Mega|Fly|Ride"] = 5900.92}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 17.03, ["Fly|Ride"] = 59.06, ["Neon"] = 27.42, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 116.42, ["Mega"] = 232.16, ["Mega|Ride"] = 165, ["Mega|Fly|Ride"] = 242}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.13, ["Fly"] = 23.38, ["Ride"] = 20.46, ["Fly|Ride"] = 44.94, ["Neon"] = 45.31, ["Neon|Fly"] = 163.9, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 145.75, ["Mega"] = 189.96, ["Mega|Ride"] = 303, ["Mega|Fly|Ride"] = 316.96}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.09, ["Fly"] = 48, ["Ride"] = 27.5, ["Fly|Ride"] = 57.37, ["Neon"] = 15.13, ["Neon|Fly"] = 98.98, ["Neon|Ride"] = 44.27, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 99, ["Mega|Ride"] = 136.13, ["Mega|Fly|Ride"] = 226.87}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.66, ["Fly"] = 60.34, ["Ride"] = 34.38, ["Fly|Ride"] = 82.5, ["Neon"] = 230.89, ["Neon|Ride"] = 219.99, ["Neon|Fly|Ride"] = 339.32, ["Mega"] = 1361.76, ["Mega|Ride"] = 903.38, ["Mega|Fly|Ride"] = 673.75}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 53.63, ["Fly|Ride"] = 54.32, ["Neon"] = 12.38, ["Neon|Ride"] = 69.33, ["Neon|Fly|Ride"] = 220, ["Mega"] = 173.28, ["Mega|Ride"] = 479.59, ["Mega|Fly|Ride"] = 1031.95}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.25, ["Fly"] = 97.55, ["Ride"] = 42.56, ["Neon"] = 226.98, ["Neon|Fly|Ride"] = 271.57, ["Mega"] = 783.75, ["Mega|Ride"] = 453.93, ["Mega|Fly|Ride"] = 828.4}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.2, ["Ride"] = 32.89, ["Neon"] = 5.5, ["Neon|Ride"] = 29.31, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 57.73, ["Mega|Ride"] = 152.08, ["Mega|Fly|Ride"] = 261.25}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.5, ["Ride"] = 25.41, ["Neon"] = 56.21, ["Mega"] = 142.5, ["Mega|Ride"] = 342.69, ["Mega|Fly|Ride"] = 798.2}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 4.33, ["Ride"] = 38.5, ["Neon"] = 75.63, ["Neon|Ride"] = 303, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 334.78, ["Mega|Ride"] = 587.92, ["Mega|Fly|Ride"] = 485.38}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.28, ["Fly"] = 31.63, ["Ride"] = 33.92, ["Fly|Ride"] = 59.07, ["Neon"] = 57.64, ["Neon|Fly"] = 44, ["Neon|Ride"] = 59.13, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 566.27, ["Mega|Ride"] = 342.38, ["Mega|Fly|Ride"] = 489.11}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 481.25, ["Fly"] = 635.4, ["Ride"] = 461.43, ["Fly|Ride"] = 537.63, ["Neon"] = 1738, ["Neon|Fly"] = 2171.6, ["Neon|Ride"] = 3740, ["Neon|Fly|Ride"] = 1718.75, ["Mega|Fly|Ride"] = 7807.36}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.2, ["Ride"] = 18.18, ["Fly|Ride"] = 41.24, ["Neon"] = 30.83, ["Neon|Fly"] = 86.01, ["Neon|Ride"] = 33.83, ["Neon|Fly|Ride"] = 172.57, ["Mega"] = 257.61, ["Mega|Ride"] = 206.14, ["Mega|Fly|Ride"] = 322.15}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.41, ["Fly"] = 74.91, ["Ride"] = 81.77, ["Fly|Ride"] = 197.47, ["Neon"] = 67.38, ["Neon|Ride"] = 133.3, ["Neon|Fly|Ride"] = 412.49, ["Mega"] = 412.5, ["Mega|Fly"] = 756.93, ["Mega|Ride"] = 595.26, ["Mega|Fly|Ride"] = 616.06}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 22, ["Fly"] = 91.85, ["Ride"] = 95.92, ["Fly|Ride"] = 253.26, ["Neon"] = 89.28, ["Neon|Ride"] = 224.13, ["Neon|Fly|Ride"] = 367.13, ["Mega"] = 385.04, ["Mega|Ride"] = 453.93, ["Mega|Fly|Ride"] = 508.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 59.27, ["Fly"] = 163.53, ["Ride"] = 101.74, ["Fly|Ride"] = 130.63, ["Neon"] = 358.04, ["Neon|Ride"] = 329.99, ["Neon|Fly|Ride"] = 398.75, ["Mega"] = 2637.13, ["Mega|Fly|Ride"] = 1934.15}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.99, ["Ride"] = 54.99, ["Fly|Ride"] = 199.38, ["Neon"] = 38.41, ["Neon|Ride"] = 82.67, ["Neon|Fly|Ride"] = 207.63, ["Mega"] = 173.13, ["Mega|Ride"] = 203.39, ["Mega|Fly|Ride"] = 344.85}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.2, ["Fly"] = 30.25, ["Ride"] = 17.88, ["Fly|Ride"] = 60.63, ["Neon"] = 19.11, ["Neon|Ride"] = 35.13, ["Neon|Fly|Ride"] = 211.75, ["Mega"] = 107.25, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.12, ["Ride"] = 47.87, ["Neon"] = 24.79, ["Neon|Ride"] = 129.39, ["Neon|Fly|Ride"] = 182.2, ["Mega"] = 112.09, ["Mega|Fly"] = 257.61, ["Mega|Ride"] = 159.58, ["Mega|Fly|Ride"] = 277.88}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 48.12, ["Fly"] = 90.8, ["Ride"] = 106.68, ["Fly|Ride"] = 207.16, ["Neon"] = 122.27, ["Neon|Ride"] = 170.49, ["Neon|Fly|Ride"] = 275, ["Mega"] = 407, ["Mega|Ride"] = 467.6, ["Mega|Fly|Ride"] = 510.06}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.48, ["Ride"] = 89.34, ["Neon"] = 9.51, ["Neon|Ride"] = 106.68, ["Neon|Fly|Ride"] = 242.86, ["Mega"] = 54.99, ["Mega|Ride"] = 247.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 22.71, ["Ride"] = 96.25, ["Neon"] = 123.75, ["Neon|Ride"] = 391.88, ["Mega"] = 687.5, ["Mega|Fly|Ride"] = 846.58}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 866.25, ["Fly"] = 1251.25, ["Ride"] = 1057.38, ["Fly|Ride"] = 1065.63, ["Neon"] = 3784.53, ["Neon|Ride"] = 2750, ["Neon|Fly|Ride"] = 2996.13, ["Mega|Fly|Ride"] = 9625}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 17.48, ["Fly"] = 121.28, ["Ride"] = 46.27, ["Fly|Ride"] = 187.63, ["Neon"] = 68.74, ["Neon|Fly"] = 755.78, ["Neon|Ride"] = 186.01, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 272.25, ["Mega|Ride"] = 371.25, ["Mega|Fly|Ride"] = 756.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.2, ["Fly"] = 52.24, ["Ride"] = 22.64, ["Fly|Ride"] = 101.06, ["Neon"] = 11.65, ["Neon|Ride"] = 34.21, ["Neon|Fly|Ride"] = 94.2, ["Mega"] = 67.38, ["Mega|Ride"] = 98.21, ["Mega|Fly|Ride"] = 178.75}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 12.35, ["Ride"] = 137.5, ["Fly|Ride"] = 152.08, ["Neon"] = 66, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 404.27, ["Mega"] = 302.48, ["Mega|Ride"] = 451.11, ["Mega|Fly|Ride"] = 968}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.2, ["Ride"] = 24.75, ["Fly|Ride"] = 196.64, ["Neon"] = 2.2, ["Neon|Ride"] = 27.96, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 24.99, ["Mega|Ride"] = 55, ["Mega|Fly|Ride"] = 123.74}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.21, ["Fly"] = 136.18, ["Ride"] = 104.25, ["Fly|Ride"] = 279.13, ["Neon"] = 172.01, ["Neon|Fly"] = 371.25, ["Neon|Ride"] = 281.88, ["Neon|Fly|Ride"] = 403.06, ["Mega"] = 987.96, ["Mega|Ride"] = 930.88, ["Mega|Fly|Ride"] = 979}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.99, ["Ride"] = 65.88, ["Fly|Ride"] = 292.95, ["Neon"] = 175.91, ["Neon|Ride"] = 343.75, ["Neon|Fly|Ride"] = 275, ["Mega"] = 515.21, ["Mega|Ride"] = 893.09, ["Mega|Fly|Ride"] = 856.06}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.2, ["Ride"] = 24.3, ["Neon"] = 9.63, ["Neon|Ride"] = 42.94, ["Neon|Fly|Ride"] = 129.39, ["Mega"] = 102.69, ["Mega|Ride"] = 165, ["Mega|Fly|Ride"] = 439.18}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.5, ["Fly"] = 167.96, ["Ride"] = 42.6, ["Fly|Ride"] = 110.91, ["Neon"] = 85.25, ["Neon|Ride"] = 100.25, ["Neon|Fly|Ride"] = 197.47, ["Mega"] = 428.69, ["Mega|Ride"] = 440, ["Mega|Fly|Ride"] = 513.39}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 7.72, ["Fly"] = 102.15, ["Ride"] = 28.65, ["Fly|Ride"] = 89.86, ["Neon"] = 29.51, ["Neon|Fly"] = 137.35, ["Neon|Ride"] = 60.5, ["Neon|Fly|Ride"] = 151.06, ["Mega"] = 240.63, ["Mega|Ride"] = 412.5, ["Mega|Fly|Ride"] = 451}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 35.39, ["Ride"] = 96.25, ["Neon"] = 272.36, ["Neon|Ride"] = 272.36, ["Neon|Fly|Ride"] = 605.99, ["Mega"] = 2648.62, ["Mega|Ride"] = 2566.88, ["Mega|Fly|Ride"] = 2269.6}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.12, ["Ride"] = 51.64, ["Fly|Ride"] = 202.13, ["Neon"] = 11.88, ["Neon|Ride"] = 61.88, ["Neon|Fly|Ride"] = 682, ["Mega"] = 72.65, ["Mega|Ride"] = 120.27, ["Mega|Fly|Ride"] = 268.98}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.09, ["Ride"] = 19.25, ["Fly|Ride"] = 94.88, ["Neon"] = 41.16, ["Neon|Fly"] = 197.47, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 156.64, ["Mega"] = 314.47, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 304.67}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 114.88, ["Fly"] = 412.5, ["Ride"] = 164.99, ["Fly|Ride"] = 247.5, ["Neon"] = 481.25, ["Neon|Ride"] = 572.72, ["Neon|Fly|Ride"] = 565.13, ["Mega|Ride"] = 1922.34, ["Mega|Fly|Ride"] = 2225.47}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.2, ["Fly"] = 26.64, ["Ride"] = 19.14, ["Fly|Ride"] = 41.25, ["Neon"] = 26.71, ["Neon|Fly"] = 60.16, ["Neon|Ride"] = 33.09, ["Neon|Fly|Ride"] = 74.79, ["Mega"] = 137.5, ["Mega|Ride"] = 172, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 22.59, ["Fly"] = 89.38, ["Ride"] = 63.86, ["Fly|Ride"] = 163.35, ["Neon"] = 167.23, ["Neon|Ride"] = 188.27, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 678.96, ["Mega|Ride"] = 536.25, ["Mega|Fly|Ride"] = 742.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.2, ["Fly"] = 19.25, ["Ride"] = 16.48, ["Fly|Ride"] = 60.5, ["Neon"] = 2.2, ["Neon|Fly"] = 30.41, ["Neon|Ride"] = 17.87, ["Neon|Fly|Ride"] = 45.38, ["Mega"] = 15.11, ["Mega|Fly"] = 50.07, ["Mega|Ride"] = 34.38, ["Mega|Fly|Ride"] = 74.03}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.2, ["Ride"] = 61.3, ["Neon"] = 3.39, ["Neon|Fly|Ride"] = 140.73, ["Mega"] = 21.73, ["Mega|Fly"] = 123.75, ["Mega|Ride"] = 68.75, ["Mega|Fly|Ride"] = 167.01}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.2, ["Fly"] = 38.6, ["Ride"] = 28.58, ["Fly|Ride"] = 181.61, ["Neon"] = 15.71, ["Neon|Ride"] = 61.63, ["Neon|Fly|Ride"] = 143, ["Mega"] = 110, ["Mega|Ride"] = 301.25, ["Mega|Fly|Ride"] = 257.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 35.07, ["Fly|Ride"] = 137.5, ["Neon"] = 138.87, ["Neon|Ride"] = 363.16, ["Neon|Fly|Ride"] = 418.39, ["Mega"] = 536.25, ["Mega|Ride"] = 539.04, ["Mega|Fly|Ride"] = 907.85}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.2, ["Fly"] = 23.38, ["Ride"] = 15.13, ["Fly|Ride"] = 44.7, ["Neon"] = 13.75, ["Neon|Fly"] = 37.47, ["Neon|Ride"] = 30.33, ["Neon|Fly|Ride"] = 60.64, ["Mega"] = 127.77, ["Mega|Fly"] = 279.95, ["Mega|Ride"] = 132, ["Mega|Fly|Ride"] = 179.23}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 8.21, ["Fly"] = 55.52, ["Ride"] = 40.58, ["Fly|Ride"] = 96.24, ["Neon"] = 60.1, ["Neon|Fly"] = 113.49, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 112.75, ["Mega"] = 357.5, ["Mega|Fly"] = 462.05, ["Mega|Ride"] = 274.98, ["Mega|Fly|Ride"] = 364.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.2, ["Fly"] = 26.91, ["Ride"] = 19.24, ["Fly|Ride"] = 71.88, ["Neon"] = 8.33, ["Neon|Fly"] = 103.11, ["Neon|Ride"] = 33.39, ["Neon|Fly|Ride"] = 93.49, ["Mega"] = 36.39, ["Mega|Fly"] = 231, ["Mega|Ride"] = 66.02, ["Mega|Fly|Ride"] = 151.1}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 12.37, ["Fly"] = 171.36, ["Ride"] = 26.13, ["Fly|Ride"] = 227.54, ["Neon"] = 39.69, ["Neon|Ride"] = 102.7, ["Neon|Fly|Ride"] = 303, ["Mega"] = 339.32, ["Mega|Ride"] = 424.43, ["Mega|Fly|Ride"] = 513.39}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.87, ["Ride"] = 54.48, ["Fly|Ride"] = 68.75, ["Neon"] = 48.13, ["Neon|Ride"] = 77, ["Mega"] = 247.5, ["Mega|Ride"] = 317.63, ["Mega|Fly|Ride"] = 495}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.34, ["Fly"] = 44, ["Ride"] = 22.31, ["Fly|Ride"] = 58, ["Neon"] = 30.24, ["Neon|Fly"] = 206.25, ["Neon|Ride"] = 41.33, ["Neon|Fly|Ride"] = 151.06, ["Mega"] = 243.38, ["Mega|Fly"] = 275, ["Mega|Ride"] = 242.86}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.2, ["Fly"] = 19.97, ["Ride"] = 16.37, ["Fly|Ride"] = 55.06, ["Neon"] = 20.44, ["Neon|Fly"] = 73.87, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 88.53, ["Mega"] = 172, ["Mega|Ride"] = 107.25, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 226.88, ["Fly"] = 412.5, ["Ride"] = 286, ["Fly|Ride"] = 412.5, ["Neon"] = 1316.36, ["Neon|Ride"] = 1347.01, ["Neon|Fly|Ride"] = 1230.63, ["Mega"] = 4449.66, ["Mega|Fly|Ride"] = 4255.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.26, ["Ride"] = 110, ["Neon"] = 37.42, ["Neon|Ride"] = 152.08, ["Mega"] = 129.25, ["Mega|Ride"] = 685.36, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.74, ["Fly"] = 113.49, ["Ride"] = 21.58, ["Fly|Ride"] = 90.8, ["Neon"] = 32.89, ["Neon|Fly"] = 257.61, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 154.03, ["Mega"] = 255.64, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.91, ["Fly|Ride"] = 756.93, ["Neon"] = 48.02, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 632.49, ["Mega"] = 213.82, ["Mega|Ride"] = 428.69, ["Mega|Fly|Ride"] = 436.57}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.2, ["Fly"] = 17.03, ["Ride"] = 17.02, ["Fly|Ride"] = 29.34, ["Neon"] = 2.2, ["Neon|Fly"] = 22.72, ["Neon|Ride"] = 16.14, ["Neon|Fly|Ride"] = 37.59, ["Mega"] = 27.5, ["Mega|Fly"] = 85.12, ["Mega|Ride"] = 30.24, ["Mega|Fly|Ride"] = 75.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.2, ["Fly"] = 47.03, ["Ride"] = 20.63, ["Fly|Ride"] = 108.56, ["Neon"] = 20, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 52.24, ["Mega"] = 181.59, ["Mega|Ride"] = 172, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.13, ["Ride"] = 125.56, ["Neon"] = 10.73, ["Neon|Ride"] = 303, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 55, ["Mega|Ride"] = 178.75, ["Mega|Fly|Ride"] = 290.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.5, ["Fly"] = 110, ["Ride"] = 93.14, ["Fly|Ride"] = 160.32, ["Neon"] = 330, ["Neon|Fly"] = 753.44, ["Neon|Ride"] = 386.38, ["Neon|Fly|Ride"] = 453.93, ["Mega|Ride"] = 3784.53, ["Mega|Fly|Ride"] = 1787.5}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.81, ["Fly"] = 76.05, ["Ride"] = 30.25, ["Fly|Ride"] = 74.83, ["Neon"] = 23.38, ["Neon|Ride"] = 71.41, ["Mega"] = 177.36, ["Mega|Ride"] = 223.34}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.2, ["Fly"] = 52.22, ["Ride"] = 45.38, ["Neon"] = 9.51, ["Neon|Ride"] = 185.49, ["Neon|Fly|Ride"] = 576.28, ["Mega"] = 59.03, ["Mega|Fly"] = 329.99, ["Mega|Ride"] = 134.75, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 41.25, ["Fly"] = 89.38, ["Ride"] = 90.34, ["Fly|Ride"] = 182.88, ["Neon"] = 149.87, ["Neon|Ride"] = 185.01, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 603.63, ["Mega|Ride"] = 635.5, ["Mega|Fly|Ride"] = 862.46}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.2, ["Fly"] = 16.5, ["Ride"] = 13.57, ["Fly|Ride"] = 30.67, ["Neon"] = 2.2, ["Neon|Fly"] = 23.36, ["Neon|Ride"] = 16.57, ["Neon|Fly|Ride"] = 38.5, ["Mega"] = 17.49, ["Mega|Fly"] = 52.25, ["Mega|Ride"] = 35.35, ["Mega|Fly|Ride"] = 53.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.2, ["Ride"] = 52.22, ["Fly|Ride"] = 102.15, ["Neon"] = 2.41, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 303, ["Mega"] = 27.5, ["Mega|Fly"] = 136.18, ["Mega|Ride"] = 81.71, ["Mega|Fly|Ride"] = 301.13}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.16, ["Ride"] = 110, ["Fly|Ride"] = 169.02, ["Neon"] = 8.07, ["Neon|Ride"] = 96.14, ["Neon|Fly|Ride"] = 301.83, ["Mega"] = 65.34, ["Mega|Fly"] = 197.47, ["Mega|Ride"] = 131.51, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.99, ["Fly"] = 75.63, ["Ride"] = 29.95, ["Fly|Ride"] = 152.08, ["Neon"] = 20.63, ["Neon|Fly"] = 106.68, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 165, ["Mega"] = 112.74, ["Mega|Fly"] = 348.39, ["Mega|Ride"] = 763.13, ["Mega|Fly|Ride"] = 276.37}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.2, ["Fly"] = 19.68, ["Ride"] = 14.25, ["Fly|Ride"] = 45.4, ["Neon"] = 2.2, ["Neon|Fly"] = 26.12, ["Neon|Ride"] = 24.46, ["Neon|Fly|Ride"] = 61.75, ["Mega"] = 20.63, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 123.63}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 21.49, ["Fly"] = 137.5, ["Ride"] = 55.81, ["Neon"] = 136.02, ["Neon|Ride"] = 212.23, ["Neon|Fly|Ride"] = 453.93, ["Mega|Fly|Ride"] = 856.06}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2103.75, ["Fly"] = 3300, ["Ride"] = 2357.16, ["Fly|Ride"] = 2220.63, ["Neon|Fly|Ride"] = 7768.75, ["Mega|Fly|Ride"] = 47093.73}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.2, ["Fly"] = 48.12, ["Ride"] = 16.66, ["Fly|Ride"] = 55.97, ["Neon"] = 8.13, ["Neon|Fly"] = 35.75, ["Neon|Ride"] = 29.42, ["Neon|Fly|Ride"] = 68.11, ["Mega"] = 79.51, ["Mega|Fly"] = 453.93, ["Mega|Ride"] = 93.49, ["Mega|Fly|Ride"] = 159.49}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.2, ["Ride"] = 29.52, ["Neon"] = 9.63, ["Mega"] = 103.36, ["Mega|Fly"] = 462, ["Mega|Ride"] = 130.51, ["Mega|Fly|Ride"] = 513.39}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.12, ["Fly"] = 110, ["Ride"] = 30.66, ["Fly|Ride"] = 165, ["Neon"] = 61.99, ["Neon|Fly"] = 107.83, ["Neon|Ride"] = 126.5, ["Neon|Fly|Ride"] = 290.26, ["Mega"] = 452.38, ["Mega|Ride"] = 452.38, ["Mega|Fly|Ride"] = 718.73}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.86, ["Fly"] = 113.49, ["Ride"] = 72.98, ["Neon"] = 147.13, ["Neon|Ride"] = 206.25, ["Neon|Fly|Ride"] = 256.7, ["Mega"] = 680.88, ["Mega|Ride"] = 725.15, ["Mega|Fly|Ride"] = 685.36}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 154.94, ["Fly"] = 1513.82, ["Ride"] = 198, ["Fly|Ride"] = 254.38, ["Neon"] = 677.88, ["Neon|Ride"] = 795.1, ["Neon|Fly|Ride"] = 683.38, ["Mega|Fly|Ride"] = 4380.3}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.63, ["Ride"] = 68.66, ["Fly|Ride"] = 708.13, ["Neon"] = 16.49, ["Neon|Ride"] = 76.05, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 151.33, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 398.34}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.2, ["Ride"] = 38.6, ["Neon"] = 16.17, ["Neon|Ride"] = 120.32, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 188.38, ["Mega|Fly|Ride"] = 279.81}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.2, ["Fly"] = 106.68, ["Ride"] = 29.18, ["Fly|Ride"] = 79.45, ["Neon"] = 12.37, ["Neon|Fly"] = 133.92, ["Neon|Ride"] = 34.36, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 68.06, ["Mega|Ride"] = 151.25, ["Mega|Fly|Ride"] = 240.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.75, ["Ride"] = 74.11, ["Fly|Ride"] = 137.5, ["Neon"] = 136.13, ["Neon|Ride"] = 189.97, ["Neon|Fly|Ride"] = 382.25, ["Mega"] = 284.85, ["Mega|Ride"] = 499.31, ["Mega|Fly|Ride"] = 598.82}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.2, ["Ride"] = 29.54, ["Neon"] = 2.2, ["Neon|Ride"] = 21.34, ["Mega"] = 26.13, ["Mega|Fly"] = 128.35, ["Mega|Ride"] = 84.94, ["Mega|Fly|Ride"] = 189.86}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 95.59, ["Fly"] = 212.23, ["Ride"] = 133.38, ["Fly|Ride"] = 158.02, ["Neon"] = 326.7, ["Neon|Fly"] = 398.34, ["Neon|Ride"] = 398.34, ["Neon|Fly|Ride"] = 379.04, ["Mega"] = 3404.37, ["Mega|Ride"] = 2601.5, ["Mega|Fly|Ride"] = 1411.7}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.2, ["Fly"] = 43.65, ["Ride"] = 96.22, ["Neon"] = 11.51, ["Neon|Ride"] = 151.54, ["Neon|Fly|Ride"] = 226.98, ["Mega"] = 66.43, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.99, ["Fly"] = 110, ["Ride"] = 77, ["Fly|Ride"] = 178.74, ["Neon"] = 242, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 411.13, ["Mega"] = 2750}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.2, ["Fly"] = 66.96, ["Ride"] = 19.25, ["Fly|Ride"] = 42.59, ["Neon"] = 4.4, ["Neon|Fly"] = 89.86, ["Neon|Ride"] = 76.05, ["Neon|Fly|Ride"] = 121.43, ["Mega"] = 44, ["Mega|Fly"] = 154.03, ["Mega|Ride"] = 108.63, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.2, ["Neon"] = 5.49, ["Neon|Ride"] = 120.95, ["Mega"] = 256.7, ["Mega|Ride"] = 247.41, ["Mega|Fly|Ride"] = 405.63}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.82, ["Fly"] = 81.13, ["Ride"] = 34.06, ["Fly|Ride"] = 94.88, ["Neon"] = 19.78, ["Neon|Ride"] = 71.5, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 148.49, ["Mega|Ride"] = 342.69, ["Mega|Fly|Ride"] = 605.99}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 357.49, ["Fly"] = 522.44, ["Ride"] = 453.75, ["Fly|Ride"] = 616, ["Neon"] = 809.88, ["Neon|Ride"] = 962.5, ["Neon|Fly|Ride"] = 1168.75, ["Mega"] = 3275.02, ["Mega|Ride"] = 3279.38, ["Mega|Fly|Ride"] = 2200}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.22, ["Fly"] = 66.7, ["Ride"] = 49.5, ["Fly|Ride"] = 99.88, ["Neon"] = 168.56, ["Neon|Ride"] = 197.47, ["Neon|Fly|Ride"] = 206.25, ["Mega|Ride"] = 1815.68, ["Mega|Fly|Ride"] = 1118.91}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.2, ["Fly"] = 64.63, ["Ride"] = 34.36, ["Fly|Ride"] = 121.71, ["Neon"] = 23.02, ["Neon|Fly"] = 147.54, ["Neon|Ride"] = 68.11, ["Neon|Fly|Ride"] = 137.3, ["Mega"] = 118.99, ["Mega|Ride"] = 274.98, ["Mega|Fly|Ride"] = 296.22}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 25.18, ["Fly"] = 226.73, ["Ride"] = 60.3, ["Fly|Ride"] = 156.75, ["Neon"] = 79.63, ["Neon|Fly"] = 412.5, ["Neon|Ride"] = 135.06, ["Neon|Fly|Ride"] = 277.75, ["Mega"] = 303, ["Mega|Fly"] = 1056.27, ["Mega|Ride"] = 343.75, ["Mega|Fly|Ride"] = 537.63}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 19.12, ["Ride"] = 24.73, ["Neon"] = 106.19, ["Neon|Ride"] = 127.08, ["Neon|Fly|Ride"] = 513.39, ["Mega"] = 685.36, ["Mega|Ride"] = 725.15, ["Mega|Fly|Ride"] = 325.88}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.13, ["Neon"] = 26.12, ["Neon|Ride"] = 165, ["Mega"] = 96.25, ["Mega|Ride"] = 354.07}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 4.6, ["Fly"] = 76.05, ["Ride"] = 26.12, ["Fly|Ride"] = 29.52, ["Neon"] = 19.27, ["Neon|Fly"] = 98.74, ["Neon|Ride"] = 76.05, ["Neon|Fly|Ride"] = 222.24, ["Mega"] = 261.25, ["Mega|Ride"] = 510.13, ["Mega|Fly|Ride"] = 1375}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 82.5, ["Fly"] = 256.7, ["Ride"] = 125.36, ["Fly|Ride"] = 206.25, ["Neon"] = 510.67, ["Neon|Ride"] = 548.62, ["Neon|Fly|Ride"] = 549.99, ["Mega"] = 3025, ["Mega|Ride"] = 2750, ["Mega|Fly|Ride"] = 3422.91}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 30.25, ["Ride"] = 58.21, ["Fly|Ride"] = 151.52, ["Neon"] = 123.74, ["Neon|Ride"] = 179.32, ["Neon|Fly|Ride"] = 203.5, ["Mega"] = 534.88, ["Mega|Ride"] = 601.45}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1978.63, ["Fly"] = 2421.65, ["Ride"] = 2062.5, ["Fly|Ride"] = 2057, ["Neon"] = 12104.81, ["Neon|Fly|Ride"] = 6808.74, ["Mega|Fly|Ride"] = 25850}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 6.64, ["Fly"] = 137500, ["Ride"] = 20.44, ["Fly|Ride"] = 206.24, ["Neon"] = 20.39, ["Neon|Ride"] = 65.19, ["Mega"] = 137.5, ["Mega|Fly"] = 823.63, ["Mega|Ride"] = 219.32, ["Mega|Fly|Ride"] = 540.18}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.13, ["Fly"] = 76.05, ["Ride"] = 61.3, ["Fly|Ride"] = 156.61, ["Neon"] = 26.83, ["Neon|Ride"] = 94.49, ["Mega"] = 151.25, ["Mega|Ride"] = 297.25, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 893.86, ["Ride"] = 1024.38, ["Fly|Ride"] = 1058.64, ["Neon"] = 2910.88, ["Neon|Ride"] = 2695.27, ["Neon|Fly|Ride"] = 3029.12, ["Mega|Ride"] = 14546.37, ["Mega|Fly|Ride"] = 11347.89}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.49, ["Ride"] = 55, ["Fly|Ride"] = 181.6, ["Neon"] = 242.86, ["Neon|Ride"] = 197.47, ["Mega"] = 894.85, ["Mega|Ride"] = 1026.76, ["Mega|Fly|Ride"] = 875.2}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.68, ["Ride"] = 22.83, ["Fly|Ride"] = 134.25, ["Neon"] = 11.14, ["Neon|Ride"] = 67.93, ["Neon|Fly|Ride"] = 225.83, ["Mega"] = 165, ["Mega|Fly|Ride"] = 369.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.2, ["Fly"] = 55, ["Ride"] = 152.08, ["Neon"] = 2.56, ["Neon|Fly"] = 165, ["Neon|Ride"] = 51.67, ["Neon|Fly|Ride"] = 118.03, ["Mega"] = 24.33, ["Mega|Ride"] = 64.23, ["Mega|Fly|Ride"] = 137.34}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 96.22, ["Ride"] = 126.25, ["Fly|Ride"] = 178.75, ["Neon"] = 481.25, ["Neon|Ride"] = 481.25, ["Neon|Fly|Ride"] = 671, ["Mega"] = 2566.88, ["Mega|Fly|Ride"] = 2421.65}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.2, ["Ride"] = 36.33, ["Fly|Ride"] = 79.45, ["Neon"] = 18.18, ["Neon|Ride"] = 66.6, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 94.88, ["Mega|Ride"] = 127.88, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 79.91, ["Fly"] = 158.88, ["Ride"] = 132, ["Fly|Ride"] = 303, ["Neon"] = 677.88, ["Neon|Ride"] = 756.25, ["Mega"] = 1587.58, ["Mega|Fly|Ride"] = 1850.72}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 2.41, ["Fly"] = 110, ["Fly|Ride"] = 136.18, ["Neon"] = 61.87, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 281.87, ["Mega"] = 343.64, ["Mega|Ride"] = 334.78}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 247.5, ["Fly"] = 298.38, ["Ride"] = 272.25, ["Fly|Ride"] = 336.87, ["Neon"] = 1203.53, ["Neon|Ride"] = 1207.43, ["Neon|Fly|Ride"] = 921.25, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.48, ["Fly"] = 61.88, ["Ride"] = 25.99, ["Fly|Ride"] = 120.89, ["Neon"] = 35.19, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 145.27, ["Mega|Ride"] = 264.06, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.2, ["Fly"] = 24.31, ["Ride"] = 17.46, ["Fly|Ride"] = 48.81, ["Neon"] = 6.78, ["Neon|Fly"] = 39.84, ["Neon|Ride"] = 22.99, ["Neon|Fly|Ride"] = 60.41, ["Mega"] = 44, ["Mega|Ride"] = 87.99, ["Mega|Fly|Ride"] = 167.96}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1418.51, ["Ride"] = 1100, ["Fly|Ride"] = 1314.5, ["Neon|Ride"] = 8322.56, ["Neon|Fly|Ride"] = 7376.13, ["Mega"] = 25668.53, ["Mega|Fly|Ride"] = 20426.2}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 11, ["Ride"] = 74.93, ["Fly|Ride"] = 212.23, ["Neon"] = 100.17, ["Neon|Ride"] = 329.98, ["Mega"] = 357.5, ["Mega|Ride"] = 455.56, ["Mega|Fly|Ride"] = 591.14}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.33, ["Fly"] = 50.1, ["Ride"] = 45.38, ["Fly|Ride"] = 84.61, ["Neon"] = 33, ["Neon|Fly"] = 107.83, ["Neon|Ride"] = 54.98, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 440, ["Mega|Ride"] = 169.82, ["Mega|Fly|Ride"] = 273.63}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.3, ["Fly"] = 34.67, ["Ride"] = 41.69, ["Fly|Ride"] = 78.38, ["Neon"] = 257.61, ["Neon|Ride"] = 203.5, ["Neon|Fly|Ride"] = 198.09, ["Mega"] = 2572.57, ["Mega|Ride"] = 876.08, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.75, ["Fly"] = 74.91, ["Ride"] = 28.77, ["Fly|Ride"] = 90.8, ["Neon"] = 50.87, ["Neon|Ride"] = 80.72, ["Neon|Fly|Ride"] = 275, ["Mega"] = 385, ["Mega|Ride"] = 295.63, ["Mega|Fly|Ride"] = 452.27}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 82.46, ["Ride"] = 165, ["Fly|Ride"] = 674.68, ["Neon"] = 389.25, ["Neon|Fly"] = 605.99, ["Neon|Ride"] = 453.93, ["Neon|Fly|Ride"] = 605.99, ["Mega"] = 2053.5, ["Mega|Ride"] = 1131.4, ["Mega|Fly|Ride"] = 1012}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.2, ["Ride"] = 122.16, ["Neon"] = 2.2, ["Neon|Fly"] = 57.31, ["Neon|Ride"] = 104.8, ["Neon|Fly|Ride"] = 113.49, ["Mega"] = 17.88, ["Mega|Ride"] = 151.35, ["Mega|Fly|Ride"] = 213.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 102.92, ["Fly"] = 135.84, ["Ride"] = 123.75, ["Fly|Ride"] = 192.49, ["Neon"] = 619.91, ["Neon|Fly"] = 514.25, ["Neon|Ride"] = 550, ["Neon|Fly|Ride"] = 673.75, ["Mega"] = 2269.6, ["Mega|Fly|Ride"] = 2200}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.07, ["Fly"] = 151.25, ["Ride"] = 23.13, ["Fly|Ride"] = 70.57, ["Neon"] = 231.09, ["Neon|Ride"] = 75.62, ["Mega"] = 810.55, ["Mega|Ride"] = 458.57, ["Mega|Fly|Ride"] = 514.25}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.75, ["Fly"] = 34.38, ["Ride"] = 19.25, ["Fly|Ride"] = 41.21, ["Neon"] = 25.69, ["Neon|Fly"] = 86.01, ["Neon|Ride"] = 76.05, ["Neon|Fly|Ride"] = 128.7, ["Mega|Ride"] = 288.17, ["Mega|Fly|Ride"] = 281.88}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.2, ["Ride"] = 132, ["Neon"] = 106.68, ["Neon|Fly"] = 149.81, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 224.99, ["Mega"] = 90.55}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 87.97, ["Fly"] = 259.34, ["Ride"] = 233.75, ["Fly|Ride"] = 303, ["Neon"] = 302.5, ["Neon|Ride"] = 569.67, ["Neon|Fly|Ride"] = 825, ["Mega"] = 1967.74, ["Mega|Ride"] = 1760, ["Mega|Fly|Ride"] = 1842.5}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.73, ["Fly|Ride"] = 453.93, ["Neon"] = 22.5, ["Neon|Ride"] = 61.88, ["Mega"] = 145.27, ["Mega|Ride"] = 165.7, ["Mega|Fly|Ride"] = 342.69}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.2, ["Ride"] = 40.83, ["Neon"] = 2.2, ["Neon|Ride"] = 106.68, ["Mega"] = 18.7, ["Mega|Ride"] = 226.08, ["Mega|Fly|Ride"] = 206}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.2, ["Fly"] = 107.83, ["Ride"] = 27.5, ["Fly|Ride"] = 151.34, ["Neon"] = 2.2, ["Neon|Fly"] = 90.3, ["Neon|Ride"] = 27.5, ["Mega"] = 19.27, ["Mega|Fly"] = 59.13, ["Mega|Ride"] = 47.92, ["Mega|Fly|Ride"] = 135.18}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.2, ["Fly"] = 38.49, ["Ride"] = 24.39, ["Fly|Ride"] = 54.97, ["Neon"] = 4.39, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 34.47, ["Neon|Fly|Ride"] = 55, ["Mega"] = 66, ["Mega|Ride"] = 137.49, ["Mega|Fly|Ride"] = 110}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.2, ["Ride"] = 30.25, ["Fly|Ride"] = 120.99, ["Neon"] = 25.52, ["Neon|Ride"] = 137.35, ["Mega"] = 123.75, ["Mega|Ride"] = 136.18, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 17.88, ["Fly|Ride"] = 39.54, ["Neon"] = 17.08, ["Neon|Fly"] = 90.8, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 86, ["Mega"] = 233.75, ["Mega|Ride"] = 148.67, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 55.79, ["Ride"] = 151.25, ["Neon"] = 242.86, ["Neon|Ride"] = 412.5, ["Neon|Fly|Ride"] = 659.89, ["Mega"] = 673.75, ["Mega|Ride"] = 749.38, ["Mega|Fly|Ride"] = 905.57}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.2, ["Fly"] = 17.77, ["Ride"] = 19.24, ["Fly|Ride"] = 45.21, ["Neon"] = 2.2, ["Neon|Fly"] = 34.24, ["Neon|Ride"] = 21.45, ["Neon|Fly|Ride"] = 45.38, ["Mega"] = 20.63, ["Mega|Fly"] = 76.05, ["Mega|Ride"] = 163.42, ["Mega|Fly|Ride"] = 103.75}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.98, ["Fly"] = 30.58, ["Ride"] = 31.72, ["Fly|Ride"] = 45.41, ["Neon"] = 34.37, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 68.67, ["Neon|Fly|Ride"] = 139.25, ["Mega"] = 316.25, ["Mega|Fly"] = 605.99, ["Mega|Ride"] = 343.75, ["Mega|Fly|Ride"] = 327.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 26.11, ["Fly"] = 61.88, ["Ride"] = 54.91, ["Fly|Ride"] = 119.79, ["Neon"] = 108.62, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 130.52, ["Neon|Fly|Ride"] = 213.12, ["Mega"] = 1361.76, ["Mega|Ride"] = 907.85, ["Mega|Fly|Ride"] = 591.25}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.8, ["Fly"] = 206.25, ["Fly|Ride"] = 70.37, ["Neon"] = 89.37, ["Neon|Ride"] = 108.63, ["Mega"] = 576.13, ["Mega|Ride"] = 733.09, ["Mega|Fly|Ride"] = 753.52}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.2, ["Fly"] = 19.31, ["Ride"] = 11, ["Fly|Ride"] = 34.5, ["Neon"] = 4.13, ["Neon|Fly"] = 29.45, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 72.88, ["Mega"] = 42.63, ["Mega|Fly"] = 93.5, ["Mega|Ride"] = 61.88, ["Mega|Fly|Ride"] = 127.88}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 9.61, ["Ride"] = 34.38, ["Neon"] = 80.85, ["Neon|Ride"] = 147.02, ["Neon|Fly|Ride"] = 275, ["Mega"] = 343.75, ["Mega|Fly"] = 561.73, ["Mega|Ride"] = 398.34, ["Mega|Fly|Ride"] = 598.05}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 934.99, ["Fly"] = 1316.36, ["Ride"] = 1051.87, ["Fly|Ride"] = 1135.75, ["Neon"] = 2609.75, ["Neon|Fly"] = 3062.81, ["Neon|Ride"] = 2875.12, ["Neon|Fly|Ride"] = 2535.97, ["Mega|Fly|Ride"] = 8456.25}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 178.75, ["Ride"] = 328.63, ["Fly|Ride"] = 550, ["Neon"] = 673.75, ["Neon|Ride"] = 943.41, ["Neon|Fly|Ride"] = 1084.87, ["Mega"] = 3630.2, ["Mega|Ride"] = 3934.32, ["Mega|Fly|Ride"] = 3676.73}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.2, ["Fly|Ride"] = 411.13, ["Neon"] = 4.02, ["Neon|Ride"] = 116.87, ["Neon|Fly|Ride"] = 271.22, ["Mega"] = 90.8, ["Mega|Fly|Ride"] = 1210.83}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 134.73, ["Ride"] = 206.03, ["Fly|Ride"] = 379.04, ["Neon"] = 673.75, ["Neon|Ride"] = 550, ["Neon|Fly|Ride"] = 830.36, ["Mega|Ride"] = 2686.75, ["Mega|Fly|Ride"] = 1923.63}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.34, ["Fly"] = 43.14, ["Ride"] = 20.89, ["Fly|Ride"] = 98.74, ["Neon"] = 15.9, ["Neon|Fly"] = 55, ["Neon|Ride"] = 40.73, ["Neon|Fly|Ride"] = 303, ["Mega"] = 121.48, ["Mega|Ride"] = 513.39, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 239.25, ["Fly"] = 1026.79, ["Ride"] = 329.99, ["Fly|Ride"] = 448.27, ["Neon"] = 1514.57, ["Neon|Ride"] = 1513.82, ["Neon|Fly|Ride"] = 1437.79, ["Mega|Fly|Ride"] = 5132.43}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.2, ["Fly"] = 80.85, ["Ride"] = 20.63, ["Fly|Ride"] = 236.24, ["Neon"] = 35.04, ["Neon|Ride"] = 53.63, ["Mega"] = 412.49, ["Mega|Fly"] = 380.16, ["Mega|Ride"] = 165}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.2, ["Fly"] = 30.66, ["Ride"] = 27.5, ["Neon"] = 45.73, ["Neon|Ride"] = 56.49, ["Mega"] = 261.25, ["Mega|Ride"] = 275}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 25.82, ["Fly"] = 55, ["Ride"] = 71.36, ["Fly|Ride"] = 149.81, ["Neon"] = 116.88, ["Neon|Fly"] = 453.93, ["Neon|Ride"] = 130.63, ["Neon|Fly|Ride"] = 275, ["Mega"] = 879.23, ["Mega|Ride"] = 624.25, ["Mega|Fly|Ride"] = 1100}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.2, ["Ride"] = 52.13, ["Neon"] = 22.72, ["Neon|Ride"] = 206.25, ["Mega"] = 256.7, ["Mega|Ride"] = 269.44, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.2, ["Fly"] = 16.83, ["Ride"] = 15.51, ["Fly|Ride"] = 41.24, ["Neon"] = 2.69, ["Neon|Fly"] = 21.67, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 48.13, ["Mega"] = 26.13, ["Mega|Ride"] = 40.87, ["Mega|Fly|Ride"] = 97.61}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5749.99, ["Ride"] = 4673.63, ["Fly|Ride"] = 4730, ["Neon"] = 34043.66, ["Neon|Fly|Ride"] = 20502.24, ["Mega|Fly|Ride"] = 55000}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 5.63, ["Fly"] = 90.8, ["Ride"] = 43.91, ["Neon"] = 90.49, ["Neon|Fly"] = 404, ["Neon|Ride"] = 111.37, ["Neon|Fly|Ride"] = 165, ["Mega"] = 220, ["Mega|Ride"] = 225.39, ["Mega|Fly|Ride"] = 451.66}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.2, ["Fly"] = 25.88, ["Ride"] = 20.63, ["Fly|Ride"] = 48.11, ["Neon"] = 19.56, ["Neon|Fly"] = 48.12, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 88, ["Mega"] = 137.5, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 253.71}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 479.11, ["Fly"] = 573.85, ["Ride"] = 544.5, ["Fly|Ride"] = 605, ["Neon"] = 1718.08, ["Neon|Ride"] = 1354.37, ["Neon|Fly|Ride"] = 1463, ["Mega|Fly|Ride"] = 5105.38}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.85, ["Ride"] = 51.35, ["Neon"] = 14.51, ["Neon|Ride"] = 305.25, ["Mega"] = 151.35, ["Mega|Fly|Ride"] = 726}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.65, ["Fly"] = 152.63, ["Ride"] = 137.5, ["Neon"] = 34.38, ["Neon|Ride"] = 52.22, ["Neon|Fly|Ride"] = 240.63, ["Mega"] = 453.93, ["Mega|Ride"] = 420.74}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.2, ["Fly"] = 76.05, ["Ride"] = 20.46, ["Fly|Ride"] = 68.74, ["Neon"] = 2.75, ["Neon|Fly"] = 130.63, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 96.11, ["Mega"] = 59.03, ["Mega|Ride"] = 93.04, ["Mega|Fly|Ride"] = 250.8}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 670.99, ["Fly"] = 923.74, ["Ride"] = 797.5, ["Fly|Ride"] = 797.5, ["Neon|Ride"] = 2227.5, ["Neon|Fly|Ride"] = 2199.99, ["Mega|Fly|Ride"] = 9305.29}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.23, ["Fly"] = 106.68, ["Ride"] = 89.37, ["Fly|Ride"] = 327.33, ["Neon"] = 39.87, ["Neon|Fly"] = 343.74, ["Neon|Ride"] = 126.49, ["Neon|Fly|Ride"] = 197.47, ["Mega"] = 281.45, ["Mega|Fly"] = 453.93, ["Mega|Ride"] = 255.57, ["Mega|Fly|Ride"] = 413.09}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 2.2, ["Fly"] = 247.5, ["Ride"] = 37.13, ["Fly|Ride"] = 136.18, ["Neon"] = 20.63, ["Neon|Ride"] = 61.87, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 177.38, ["Mega|Fly"] = 856.06, ["Mega|Ride"] = 193.88, ["Mega|Fly|Ride"] = 360.88}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.2, ["Fly"] = 36.01, ["Ride"] = 21.38, ["Fly|Ride"] = 44.42, ["Neon"] = 18.17, ["Neon|Fly"] = 209, ["Neon|Ride"] = 33.33, ["Neon|Fly|Ride"] = 86.9, ["Mega"] = 173.25, ["Mega|Ride"] = 136.13, ["Mega|Fly|Ride"] = 251.19}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 24.73, ["Fly"] = 41.25, ["Ride"] = 43.14, ["Fly|Ride"] = 68.75, ["Neon"] = 123.24, ["Neon|Ride"] = 119.62, ["Mega"] = 907.85, ["Mega|Ride"] = 641.73, ["Mega|Fly|Ride"] = 1760}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.2, ["Ride"] = 45.37, ["Fly|Ride"] = 86.01, ["Neon"] = 4.13, ["Neon|Ride"] = 149.81, ["Neon|Fly|Ride"] = 218.63, ["Mega"] = 33.99, ["Mega|Fly"] = 154.03, ["Mega|Ride"] = 96.24, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 603.29, ["Fly"] = 711.54, ["Ride"] = 660.21, ["Fly|Ride"] = 825, ["Neon"] = 2712.88, ["Neon|Ride"] = 2421.65, ["Neon|Fly|Ride"] = 2505.25, ["Mega|Ride"] = 10010.74, ["Mega|Fly|Ride"] = 8236.25}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.2, ["Ride"] = 68.75, ["Fly|Ride"] = 275, ["Neon"] = 11.7, ["Neon|Ride"] = 74.25, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 57.75, ["Mega|Ride"] = 215.63, ["Mega|Fly|Ride"] = 333.49}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.2, ["Ride"] = 51.92, ["Neon"] = 5.5, ["Neon|Fly"] = 303, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 275, ["Mega"] = 44, ["Mega|Fly|Ride"] = 303}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.2, ["Ride"] = 63.32, ["Neon"] = 5.5, ["Neon|Ride"] = 58.84, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 64.71, ["Mega|Fly"] = 167.96, ["Mega|Ride"] = 133.27, ["Mega|Fly|Ride"] = 152.08}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.98, ["Ride"] = 27.5, ["Neon"] = 15.13, ["Neon|Ride"] = 51.01, ["Mega"] = 248.53, ["Mega|Ride"] = 343.75}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 22, ["Fly"] = 75.63, ["Ride"] = 62.81, ["Fly|Ride"] = 224.64, ["Neon"] = 108.88, ["Neon|Fly"] = 291.37, ["Neon|Ride"] = 233.75, ["Neon|Fly|Ride"] = 412.49, ["Mega"] = 536.25, ["Mega|Ride"] = 539.04, ["Mega|Fly|Ride"] = 603.04}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 10.98, ["Ride"] = 68.66, ["Fly|Ride"] = 163.42, ["Neon"] = 90.52, ["Neon|Ride"] = 120.3, ["Neon|Fly|Ride"] = 297, ["Mega"] = 577.5, ["Mega|Ride"] = 481.25, ["Mega|Fly|Ride"] = 660}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.2, ["Fly"] = 21.33, ["Ride"] = 17.87, ["Fly|Ride"] = 50.08, ["Neon"] = 53.68, ["Neon|Ride"] = 37.57, ["Neon|Fly|Ride"] = 90.73, ["Mega"] = 312.82, ["Mega|Ride"] = 384.71, ["Mega|Fly|Ride"] = 256.48}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.75, ["Ride"] = 82.49, ["Fly|Ride"] = 154.04, ["Neon"] = 39.87, ["Neon|Ride"] = 96.25}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.2, ["Ride"] = 27.42, ["Fly|Ride"] = 114.71, ["Neon"] = 10.65, ["Neon|Ride"] = 54.48, ["Neon|Fly|Ride"] = 133.4, ["Mega"] = 93.13, ["Mega|Ride"] = 127.88, ["Mega|Fly|Ride"] = 266.7}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.27, ["Fly"] = 120.66, ["Ride"] = 24.83, ["Fly|Ride"] = 61.3, ["Neon"] = 121.27, ["Neon|Ride"] = 151.25, ["Neon|Fly|Ride"] = 222.44, ["Mega"] = 948.47, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.68, ["Fly"] = 915.75, ["Neon"] = 123.75, ["Mega"] = 347.88, ["Mega|Ride"] = 618.75, ["Mega|Fly|Ride"] = 756.95}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 41.25, ["Fly"] = 90.75, ["Ride"] = 75.42, ["Fly|Ride"] = 152.08, ["Neon"] = 284.63, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 457.66, ["Mega"] = 2052.22, ["Mega|Fly|Ride"] = 1361.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33, ["Fly"] = 152.08, ["Ride"] = 80.38, ["Fly|Ride"] = 233.75, ["Neon"] = 123.75, ["Neon|Ride"] = 176, ["Neon|Fly|Ride"] = 216.76, ["Mega"] = 532.13, ["Mega|Ride"] = 2123, ["Mega|Fly|Ride"] = 983.88}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 20.61, ["Ride"] = 43.14, ["Neon"] = 146.44, ["Neon|Ride"] = 233.74, ["Mega"] = 1100, ["Mega|Ride"] = 605, ["Mega|Fly|Ride"] = 857.92}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 22, ["Fly"] = 85.63, ["Ride"] = 103.12, ["Fly|Ride"] = 151.25, ["Neon"] = 206.25, ["Neon|Fly"] = 334.78, ["Neon|Ride"] = 206.25, ["Neon|Fly|Ride"] = 503.91, ["Mega"] = 756.11, ["Mega|Ride"] = 528.31, ["Mega|Fly|Ride"] = 788.31}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.2, ["Fly"] = 19.79, ["Ride"] = 16.39, ["Fly|Ride"] = 34.36, ["Neon"] = 4.38, ["Neon|Fly"] = 34.38, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 60.92, ["Mega"] = 47.16, ["Mega|Fly"] = 342.69, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 151.95}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1021.32}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 93.5, ["Ride"] = 212.23, ["Fly|Ride"] = 206.25, ["Neon"] = 526.55, ["Neon|Ride"] = 562.87, ["Neon|Fly|Ride"] = 792.1, ["Mega"] = 1709.13, ["Mega|Ride"] = 1699.93, ["Mega|Fly|Ride"] = 1773.75}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 80.23, ["Neon"] = 3.72, ["Neon|Fly"] = 106.68, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 317.75, ["Mega"] = 38.41, ["Mega|Ride"] = 69.32, ["Mega|Fly|Ride"] = 148.5}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.25, ["Ride"] = 78.04, ["Fly|Ride"] = 226.98, ["Neon"] = 123.75, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 570.63, ["Mega"] = 620.12, ["Mega|Ride"] = 554.67, ["Mega|Fly|Ride"] = 684.74}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.2, ["Neon"] = 4.12, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 23.38}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.2, ["Ride"] = 78.38, ["Neon"] = 4.01, ["Mega"] = 23.38, ["Mega|Ride"] = 106.68, ["Mega|Fly|Ride"] = 286}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 90.75, ["Fly"] = 1375, ["Ride"] = 150.31, ["Fly|Ride"] = 110, ["Neon"] = 685.41, ["Neon|Ride"] = 481.25, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 7058.86, ["Mega|Fly|Ride"] = 2194.92}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.2, ["Fly"] = 94.88, ["Ride"] = 22.72, ["Fly|Ride"] = 105.6, ["Neon"] = 5.49, ["Neon|Fly"] = 45.41, ["Neon|Ride"] = 33.14, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 96.25, ["Mega|Ride"] = 123.73, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.2, ["Fly"] = 39.88, ["Fly|Ride"] = 67.38, ["Neon"] = 4.77, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 439.89, ["Mega"] = 34.38, ["Mega|Ride"] = 135.3, ["Mega|Fly|Ride"] = 228.24}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 4.13, ["Ride"] = 74.99, ["Neon"] = 16.39, ["Neon|Fly"] = 275, ["Neon|Ride"] = 257.61, ["Mega"] = 137.5, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.2, ["Ride"] = 137.5, ["Neon"] = 12.38, ["Neon|Ride"] = 144.38, ["Mega"] = 108.9}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 87.12, ["Ride"] = 855.88, ["Fly|Ride"] = 379.04, ["Neon"] = 433.13, ["Neon|Ride"] = 641.78, ["Neon|Fly|Ride"] = 728.75, ["Mega|Fly|Ride"] = 3011.75}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 13.42, ["Ride"] = 36.33, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 437.97, ["Mega|Ride"] = 383.63, ["Mega|Fly|Ride"] = 676.49}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 384.99, ["Ride"] = 447.68, ["Fly|Ride"] = 771.68, ["Neon"] = 1120.63, ["Neon|Ride"] = 1100, ["Neon|Fly|Ride"] = 1100, ["Mega|Fly|Ride"] = 3506.24}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 82.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 57.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 33.96}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 24.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 53.32}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 122.35}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 16.39}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 8.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 199.36}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 19.45}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 111.38}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.12}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 5.05}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 989.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.2}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.64}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 21.5}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 33.38}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.88}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 32.69}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 591.25}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.2}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.2}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 412.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 15.13}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1457.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 54.89}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.8}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.2}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 97.9}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.2}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.2}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 27.22}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 27.5}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 61.38}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 21.23}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.95}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.76}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 27.42}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.2}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.43}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 206.25}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.27}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.88}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.2}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3267}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.2}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 89.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 259.33}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.07}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.8}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.53}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 25.67}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 225.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 31.22}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.21}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.2}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 155.29}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 54.99}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.12}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.75}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 32.98}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.74}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.88}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 14.82}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.2}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.2}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.13}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.2}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.69}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.88}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 30}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.2}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 97.63}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 272.24}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.02}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.75}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 13.15}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 25.5}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 96.25}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21.55}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.2}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.2}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 25540.75}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 130.52}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.03}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 54.23}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 61.66}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 30.25}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 41.25}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 95.95}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 96.14}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.67}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 108.63}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 452.34}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 46.55}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 48.16}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.2}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 253.58}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 17.03}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 68.75}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.2}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.02}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.13}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 152.31}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.74}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.2}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.2}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 16.34}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 20.63}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 206.25}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.2}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 870.37}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 12.63}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 646.23}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.31}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.2}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.2}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.2}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 242}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.2}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 41.06}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 104.38}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.62}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.99}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 68.48}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.13}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.32}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 9.59}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.2}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.2}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.2}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.75}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.5}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.21}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.38}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.2}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.56}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.75}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.88}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.13}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 191.46}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.2}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 54.59}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.2}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.2}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.2}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.2}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.2}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.2}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 187.59}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 28.12}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 27.59}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 74.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.89}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 25.14}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.38}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.55}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 9.02}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.02}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 45.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 18.39}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.2}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.73}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.75}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.2}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 48.13}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.23}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 9.62}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.2}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.55}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.2}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.48}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.2}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8250}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.36}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 20.63}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.39}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.7}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.55}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.55}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 17.88}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 19.27}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.57}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.12}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.2}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.63}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 42.11}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.88}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 4.13}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.92}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 4.12}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4125}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 9.4}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.2}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 42.3}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.2}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.58}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 79.96}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.48}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.88}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 136.13}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.2}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.2}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 9.09}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 4.13}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.2}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.8}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.87}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.3}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.63}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.75}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 16.49}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.2}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.88}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.9}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 302610.65}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.2}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.03}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.2}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 20.27}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.64}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6.11}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.2}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.53}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 109.78}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 136.13}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 12.38}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1373.52}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 68.51}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.2}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.2}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 24.66}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.2}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 38.27}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.75}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.2}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 9.16}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.2}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.13}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 20.61}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.13}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.2}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.2}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.2}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.2}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.45}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.99}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.12}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.45}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.24}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.2}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 5.5}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.2}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.88}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 78.01}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.2}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.2}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 13.75}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 4.77}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 441.38}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 113.85}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 14.61}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.75}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.2}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 26.29}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.37}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.75}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.2}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.14}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.68}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.79}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.2}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.22}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 131.89}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.2}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.2}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 169.13}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 12.27}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1064.24}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.55}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 202.13}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.75}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.2}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.2}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.2}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.2}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 45.8}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.2}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.75}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.2}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.12}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 3.66}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.2}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 85.25}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.24}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 4.13}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.2}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.2}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 4.12}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.2}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.2}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.75}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.2}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 9.62}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.88}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 112.75}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 54.99}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.74}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.2}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.61}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.79}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 16.39}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 119.63}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.75}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.11}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.2}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 90.52}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.2}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 10.21}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.2}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.2}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 54.91}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.2}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.2}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 56.38}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 136.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.49}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 60.41}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 226.98}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 16.98}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.2}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 5.31}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.2}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 41.25}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 64.51}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.78}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 30.25}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.5}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.42}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.68}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.2}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 16.33}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 226.98}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.88}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 13.2}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 41.25}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 30.23}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 30.24}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 94.77}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 74.25}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.5}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2089.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 4.12}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.02}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.5}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 276.24}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.98}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.63}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.98}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.48}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 12.36}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 285.42}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 74.25}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.24}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.13}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 53.89}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 163.28}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.2}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 83.73}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1011.87}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 191.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.2}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1720.62}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 597.58}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.13}},
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