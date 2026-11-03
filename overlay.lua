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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 945, ["Ride"] = 1179.94, ["Fly|Ride"] = 1671.12, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25066.55}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 501.35, ["Ride"] = 457.96, ["Fly|Ride"] = 535.5, ["Neon"] = 2088.89, ["Neon|Ride"] = 2088.89, ["Neon|Fly|Ride"] = 2073.75}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 4829.99, ["Fly|Ride"] = 4381.13, ["Neon|Fly|Ride"] = 19217.7, ["Mega|Fly|Ride"] = 69629.64}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 135.19, ["Ride"] = 183.75, ["Fly|Ride"] = 236.13, ["Neon"] = 787.45, ["Neon|Ride"] = 785.43, ["Neon|Fly|Ride"] = 787.44, ["Mega"] = 4177.77, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 561.23, ["Fly"] = 695.62, ["Ride"] = 524.96, ["Fly|Ride"] = 549.94, ["Neon|Ride"] = 1888.92, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.82, ["Ride"] = 34.26, ["Fly|Ride"] = 154.6, ["Neon"] = 72.19, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 285.27, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 472.25}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 31.79, ["Ride"] = 30.72, ["Fly|Ride"] = 82.53, ["Neon"] = 31.5, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 45.96, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 141.75, ["Mega|Fly"] = 268.01, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 89.24, ["Ride"] = 181.36, ["Fly|Ride"] = 182.44, ["Neon"] = 557.74, ["Neon|Ride"] = 603.7, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2609.03}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 29.8, ["Fly"] = 65.63, ["Ride"] = 45.94, ["Fly|Ride"] = 99.24, ["Neon"] = 340.5, ["Neon|Ride"] = 204.45, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1393.29, ["Mega|Ride"] = 1298.62, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.43, ["Fly"] = 39.52, ["Ride"] = 32.4, ["Fly|Ride"] = 65.63, ["Neon"] = 139.97, ["Neon|Ride"] = 165.04, ["Neon|Fly|Ride"] = 234.94, ["Mega|Ride"] = 1356.74, ["Mega|Fly|Ride"] = 931.76}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 49.48, ["Fly"] = 124.31, ["Ride"] = 56.32, ["Fly|Ride"] = 140.07, ["Neon"] = 362.44, ["Neon|Fly"] = 261.12, ["Neon|Ride"] = 292.45, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1532.21}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 56.41}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 383.24, ["Ride"] = 354.82, ["Fly|Ride"] = 367.5, ["Neon"] = 1282.59, ["Neon|Ride"] = 1259.69, ["Neon|Fly|Ride"] = 1223.22, ["Mega|Fly|Ride"] = 5013.32}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.69, ["Fly"] = 141.75, ["Ride"] = 112.18, ["Fly|Ride"] = 162.75, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2575.6}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.8, ["Fly"] = 115.13, ["Ride"] = 51.05, ["Fly|Ride"] = 208.9, ["Neon"] = 32.81, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 189, ["Mega"] = 142.96, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 152.34, ["Fly"] = 183.75, ["Ride"] = 158.82, ["Fly|Ride"] = 187.69, ["Neon"] = 944.47, ["Neon|Ride"] = 625.64, ["Neon|Fly|Ride"] = 589.22, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.94, ["Fly"] = 27.17, ["Ride"] = 19.67, ["Fly|Ride"] = 47.23, ["Neon"] = 26.17, ["Neon|Ride"] = 63.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 261.19, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 91.88, ["Fly"] = 262.5, ["Ride"] = 118.13, ["Fly|Ride"] = 190.99, ["Neon"] = 251.06, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 1385.95, ["Mega|Ride"] = 990.84, ["Mega|Fly|Ride"] = 1090.8}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 50.77}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 69.57, ["Ride"] = 105, ["Fly|Ride"] = 232.93, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 3011.69}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.51, ["Fly"] = 374.07, ["Ride"] = 40.16, ["Fly|Ride"] = 141.68, ["Neon"] = 206.82, ["Neon|Ride"] = 95.06, ["Neon|Fly|Ride"] = 139.97, ["Mega|Ride"] = 570.28, ["Mega|Fly|Ride"] = 1671.12}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 50.69, ["Fly"] = 70, ["Ride"] = 77.43, ["Fly|Ride"] = 141.49, ["Neon"] = 236.13, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1652.8, ["Mega|Fly|Ride"] = 808.54}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.31, ["Fly"] = 417.79, ["Ride"] = 85.65, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Fly"] = 391.96, ["Neon|Ride"] = 274.71, ["Neon|Fly|Ride"] = 299.77, ["Mega"] = 1085.19, ["Mega|Ride"] = 1249.17, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 41.78, ["Ride"] = 41.78, ["Fly|Ride"] = 83.39, ["Neon"] = 208.9, ["Neon|Ride"] = 104.46, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2086.81, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.5, ["Fly"] = 599.61, ["Ride"] = 77.95, ["Fly|Ride"] = 154.6, ["Neon"] = 182.79, ["Neon|Fly"] = 558.79, ["Neon|Ride"] = 167.12, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.76, ["Fly"] = 30.18, ["Ride"] = 29.12, ["Fly|Ride"] = 63.76, ["Neon"] = 27, ["Neon|Fly"] = 50.91, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.31, ["Mega"] = 145.69, ["Mega|Fly"] = 25108.99, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 381.92, ["Fly|Ride"] = 442.32, ["Neon"] = 1811.08, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 12533.28, ["Mega|Fly|Ride"] = 7311.08}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.29, ["Ride"] = 35.44, ["Fly|Ride"] = 105.18, ["Neon"] = 250.68, ["Neon|Fly|Ride"] = 426.15, ["Mega|Fly|Ride"] = 923.3}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 41.11, ["Ride"] = 19.59, ["Fly|Ride"] = 52.48, ["Neon"] = 48.57, ["Neon|Ride"] = 81.48, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 315.23, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 124.69, ["Fly"] = 125.34, ["Ride"] = 102.72, ["Fly|Ride"] = 139.97, ["Neon"] = 404.21, ["Neon|Fly"] = 416.74, ["Neon|Ride"] = 450.16, ["Neon|Fly|Ride"] = 382.35, ["Mega"] = 2075.32, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1969.24}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 10.77, ["Ride"] = 32.15, ["Fly|Ride"] = 75.22, ["Neon"] = 62.68, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 708.36, ["Mega|Ride"] = 795.87, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 201.91, ["Fly"] = 208.9, ["Ride"] = 229.48, ["Fly|Ride"] = 208.9, ["Neon"] = 835.56, ["Neon|Ride"] = 521.83, ["Neon|Fly|Ride"] = 834.52, ["Mega"] = 6266.65, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.17}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 35.55}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 6.27, ["Fly"] = 34.15, ["Ride"] = 22.99, ["Fly|Ride"] = 54.32, ["Neon"] = 19.69, ["Neon|Fly"] = 4635.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 135.78, ["Mega"] = 157.5, ["Mega|Fly"] = 283.35, ["Mega|Ride"] = 250.68, ["Mega|Fly|Ride"] = 249.63}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1443.75, ["Fly"] = 3281.25, ["Ride"] = 1312.5, ["Fly|Ride"] = 1573.69, ["Neon"] = 6684.43, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 6754.4, ["Mega|Ride"] = 53125.2, ["Mega|Fly|Ride"] = 19496.56}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.43, ["Fly"] = 68.95, ["Ride"] = 28.88, ["Fly|Ride"] = 94.5, ["Neon"] = 102.69, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 529.55, ["Mega|Ride"] = 668.46, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 131.25, ["Ride"] = 143.07, ["Fly|Ride"] = 249.38, ["Neon"] = 928.52, ["Neon|Ride"] = 623.34, ["Neon|Fly|Ride"] = 729.04, ["Mega|Ride"] = 4014.84, ["Mega|Fly|Ride"] = 2784.49}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.16}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.38, ["Fly"] = 68.84, ["Ride"] = 81.88, ["Fly|Ride"] = 139.97, ["Neon"] = 98.44, ["Neon|Ride"] = 118.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 708.37}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 115.5, ["Ride"] = 164.13, ["Fly|Ride"] = 223.12, ["Neon"] = 525, ["Neon|Ride"] = 501.35, ["Neon|Fly|Ride"] = 705.01, ["Mega|Fly|Ride"] = 2361.18}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 100.84, ["Ride"] = 202.64, ["Fly|Ride"] = 329.02, ["Neon"] = 422.66, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 1671.12, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1751.54}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 49.1}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 61.73, ["Fly"] = 45.94, ["Ride"] = 68.16, ["Fly|Ride"] = 63.67, ["Neon"] = 626.68, ["Neon|Ride"] = 373.92, ["Neon|Fly|Ride"] = 283.79, ["Mega"] = 4177.77, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 11.4, ["Ride"] = 40.16, ["Fly|Ride"] = 110.73, ["Neon"] = 44.88, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 232.93, ["Mega"] = 208.9, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 400.32, ["Fly"] = 423.94, ["Ride"] = 433.12, ["Fly|Ride"] = 459.38, ["Neon"] = 1356.74, ["Neon|Ride"] = 1407.92, ["Neon|Fly|Ride"] = 1370.32, ["Mega|Fly|Ride"] = 6234.38}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 83.56, ["Fly"] = 111.78, ["Ride"] = 99.18, ["Fly|Ride"] = 147.23, ["Neon"] = 446.25, ["Neon|Ride"] = 505.3, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 2367.77, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3148.69, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 14621.12}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 110.73, ["Ride"] = 55.13, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 277.4, ["Neon|Fly|Ride"] = 314.25, ["Mega|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 61.74, ["Fly"] = 83.56, ["Ride"] = 70, ["Neon"] = 589.13, ["Neon|Ride"] = 348.86, ["Neon|Fly|Ride"] = 696.65, ["Mega"] = 6266.65, ["Mega|Fly|Ride"] = 1657.55}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.07, ["Fly"] = 71.7, ["Ride"] = 65.63, ["Fly|Ride"] = 112.39, ["Neon"] = 262.5, ["Neon|Fly"] = 472.24, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 2625, ["Mega|Ride"] = 716.14, ["Mega|Fly|Ride"] = 644.34}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 14.18}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.93, ["Ride"] = 56.41, ["Fly|Ride"] = 95.82, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 417.79, ["Mega|Fly|Ride"] = 1574.92}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.7}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 202.64, ["Ride"] = 248.07, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1393.29, ["Neon|Fly|Ride"] = 2136.54}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1111.29, ["Ride"] = 889.88, ["Fly|Ride"] = 983.07, ["Neon|Ride"] = 3263.11, ["Neon|Fly|Ride"] = 3863.4, ["Mega|Fly|Ride"] = 15666.59}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 16.94}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.86, ["Fly"] = 61.07, ["Ride"] = 38.96, ["Fly|Ride"] = 65.62, ["Neon"] = 160.78, ["Neon|Ride"] = 157.21, ["Neon|Fly|Ride"] = 192.94, ["Mega|Ride"] = 877.34, ["Mega|Fly|Ride"] = 850.03}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5834.26, ["Fly"] = 5848.87, ["Ride"] = 5571.05, ["Fly|Ride"] = 4462.5, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40594.24}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.86, ["Fly"] = 74.66, ["Ride"] = 27.74, ["Fly|Ride"] = 57.88, ["Neon"] = 91.92, ["Neon|Ride"] = 98.19, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 624.75, ["Mega|Ride"] = 409.66, ["Mega|Fly|Ride"] = 565.97}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.53, ["Fly"] = 191.66, ["Ride"] = 35.44, ["Fly|Ride"] = 116.89, ["Neon"] = 137.88, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 248.6, ["Mega"] = 1050.72, ["Mega|Ride"] = 654.87, ["Mega|Fly|Ride"] = 975.53}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 98.19, ["Fly"] = 242.64, ["Ride"] = 113.06, ["Fly|Ride"] = 99.75, ["Neon"] = 1393.29, ["Neon|Fly|Ride"] = 1574.88, ["Mega"] = 4177.77}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 8.32, ["Ride"] = 35.43, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 363.48, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 2122.32, ["Ride"] = 2191.6, ["Fly|Ride"] = 2090.74, ["Neon|Fly|Ride"] = 6611.14, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 35262.3, ["Ride"] = 52500, ["Fly|Ride"] = 23917.48, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.65, ["Fly"] = 221.44, ["Ride"] = 48.84, ["Fly|Ride"] = 913.61, ["Neon"] = 139.97, ["Neon|Ride"] = 102.9, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 835.56, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 79.12, ["Ride"] = 46.31, ["Fly|Ride"] = 166.69, ["Neon"] = 22.58, ["Neon|Fly"] = 96.93, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 126.03, ["Mega"] = 153.08, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 17.72}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.23, ["Ride"] = 52.5, ["Fly|Ride"] = 111.57, ["Neon"] = 56.44, ["Neon|Ride"] = 107.45, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 416.74, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 762.71, ["Ride"] = 748.6, ["Fly|Ride"] = 779.62, ["Neon|Ride"] = 2604.86, ["Neon|Fly|Ride"] = 2833.36, ["Mega|Fly|Ride"] = 11019.6}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 900.38, ["Ride"] = 857.46, ["Fly|Ride"] = 984.38, ["Neon"] = 4177.77, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11254.89}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.86, ["Fly"] = 118.08, ["Ride"] = 38.19, ["Fly|Ride"] = 98.44, ["Neon"] = 106.31, ["Neon|Ride"] = 167.12, ["Neon|Fly|Ride"] = 202.64, ["Mega"] = 1026.81, ["Mega|Ride"] = 685.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.13}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 56.44, ["Fly"] = 93.19, ["Ride"] = 74.82, ["Fly|Ride"] = 115.96, ["Neon|Ride"] = 417.79, ["Neon|Fly|Ride"] = 350.95, ["Mega|Ride"] = 2045.03, ["Mega|Fly|Ride"] = 1808.99}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 52.5, ["Ride"] = 63, ["Fly|Ride"] = 231.89, ["Neon"] = 334.23, ["Neon|Fly"] = 536.85, ["Neon|Ride"] = 396.9, ["Neon|Fly|Ride"] = 280.72, ["Mega"] = 1754.68, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.57, ["Fly"] = 36.28, ["Ride"] = 22.92, ["Fly|Ride"] = 56.11, ["Neon"] = 37.62, ["Neon|Fly"] = 525, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 139.19, ["Mega"] = 190.32, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 89.25, ["Fly"] = 121.83, ["Ride"] = 114.38, ["Fly|Ride"] = 157.5, ["Neon"] = 460.61, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 382.04, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Ride"] = 31.38, ["Fly|Ride"] = 157.5, ["Neon"] = 61.63, ["Neon|Ride"] = 107.6, ["Mega"] = 236.25, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 497.17}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 40.28, ["Ride"] = 36.58, ["Fly|Ride"] = 99.24, ["Neon"] = 104.46, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 185.93, ["Mega"] = 738.43, ["Mega|Fly|Ride"] = 696.65}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.72, ["Ride"] = 63.76, ["Fly|Ride"] = 156.19, ["Neon"] = 245.44, ["Neon|Ride"] = 330.05, ["Mega"] = 694.25, ["Mega|Ride"] = 551.34, ["Mega|Fly|Ride"] = 871.07}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 19.69, ["Fly"] = 117.97, ["Ride"] = 26.25, ["Fly|Ride"] = 69.57, ["Neon"] = 91.88, ["Neon|Fly"] = 557.74, ["Neon|Ride"] = 144.15, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 940.02, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6963.29, ["Ride"] = 7141.32, ["Fly|Ride"] = 6049.32, ["Neon"] = 34815.35, ["Neon|Fly|Ride"] = 22282.08}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 244.58, ["Fly"] = 260.94, ["Ride"] = 240.19, ["Fly|Ride"] = 287.44, ["Neon"] = 672.94, ["Neon|Fly|Ride"] = 582.75, ["Mega|Fly|Ride"] = 1979.17}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 30.9, ["Fly"] = 104.99, ["Ride"] = 65.62, ["Fly|Ride"] = 133.91, ["Neon"] = 92.51, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 116.52, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 362.78, ["Mega|Fly"] = 557.74, ["Mega|Ride"] = 358.21, ["Mega|Fly|Ride"] = 447}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.82, ["Fly"] = 41.78, ["Ride"] = 20.55, ["Fly|Ride"] = 89.83, ["Neon"] = 31.5, ["Neon|Ride"] = 56.27, ["Mega"] = 131.25}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 35.43, ["Fly"] = 70, ["Ride"] = 111, ["Fly|Ride"] = 195.57, ["Neon"] = 139.97, ["Neon|Fly"] = 332.14, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 435.75, ["Mega|Ride"] = 486.45, ["Mega|Fly|Ride"] = 584.72}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14070, ["Ride"] = 12214.9, ["Fly|Ride"] = 11287.5, ["Neon|Fly|Ride"] = 26906.25, ["Mega|Fly|Ride"] = 108203.91}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 175.7, ["Ride"] = 217.88, ["Fly|Ride"] = 249.38, ["Neon"] = 1426.72, ["Neon|Ride"] = 1532.21, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4694.76}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 69.76, ["Fly"] = 107.15, ["Ride"] = 75.88, ["Fly|Ride"] = 103.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 378, ["Mega|Fly|Ride"] = 2088.89}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.49, ["Fly"] = 28.53, ["Ride"] = 22.32, ["Fly|Ride"] = 69.99, ["Neon"] = 82.65, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2506.67, ["Mega|Fly|Ride"] = 973.44}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 315, ["Fly"] = 835.56, ["Ride"] = 431.09, ["Fly|Ride"] = 483.31, ["Neon"] = 1639.32, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4936.32}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.47, ["Ride"] = 37.79, ["Fly|Ride"] = 98.19, ["Neon"] = 26.24, ["Neon|Ride"] = 63.76, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 135.56, ["Mega|Fly"] = 195.33, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 288.75, ["Ride"] = 337.32, ["Fly|Ride"] = 651.75, ["Neon"] = 975.53, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4109.88}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.99, ["Fly"] = 20.9, ["Ride"] = 17.58, ["Fly|Ride"] = 39.37, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.61, ["Mega"] = 2506.67, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.28}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.42, ["Ride"] = 178.5, ["Fly|Ride"] = 525, ["Neon"] = 456.89, ["Neon|Fly"] = 1671.12, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1114.43, ["Mega|Ride"] = 1253.35, ["Mega|Fly|Ride"] = 1180.59}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.9, ["Fly"] = 41.78, ["Ride"] = 47.58, ["Fly|Ride"] = 84.67, ["Neon"] = 72.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 517.01, ["Mega|Ride"] = 550.44, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.85, ["Fly"] = 111.57, ["Ride"] = 87.53, ["Fly|Ride"] = 244.39, ["Neon"] = 278.88, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1114.43, ["Mega|Ride"] = 934.79, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Fly|Ride"] = 132.19, ["Neon"] = 31.5, ["Neon|Ride"] = 106.26, ["Neon|Fly|Ride"] = 136.83, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 17.07, ["Fly"] = 70, ["Ride"] = 30.19, ["Fly|Ride"] = 76.12, ["Neon"] = 249.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 221.44, ["Mega|Ride"] = 505.3, ["Mega|Fly|Ride"] = 814.68}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 315.17, ["Ride"] = 380.38, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2646.62, ["Mega|Fly|Ride"] = 8355.53}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 55.13, ["Fly"] = 104.46, ["Ride"] = 77.31, ["Fly|Ride"] = 87.94, ["Neon"] = 223.13, ["Neon|Ride"] = 202.64, ["Neon|Fly|Ride"] = 210, ["Mega"] = 710.53, ["Mega|Ride"] = 654.87, ["Mega|Fly|Ride"] = 658.79}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 65.63, ["Fly"] = 52.5, ["Ride"] = 90.88, ["Neon"] = 236.07, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 362.45, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1239.76}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 31.88, ["Ride"] = 72.19, ["Fly|Ride"] = 160.86, ["Neon"] = 109.32, ["Neon|Fly"] = 315.23, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 241.28, ["Mega"] = 393.75, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 542.08}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8491.88, ["Ride"] = 9995.9, ["Fly|Ride"] = 8464.32, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1758.75, ["Ride"] = 1732.5, ["Fly|Ride"] = 1770.57, ["Neon|Ride"] = 5352.73, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 500.6, ["Ride"] = 500.26, ["Fly|Ride"] = 557.74, ["Neon"] = 2193.34, ["Neon|Fly|Ride"] = 2228.85, ["Mega"] = 16711.04, ["Mega|Fly|Ride"] = 6779.47}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.86, ["Fly"] = 23.62, ["Ride"] = 27.17, ["Fly|Ride"] = 48.56, ["Neon"] = 108.78, ["Neon|Ride"] = 110.73, ["Neon|Fly|Ride"] = 153.71, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.25, ["Fly"] = 78.74, ["Ride"] = 41.34, ["Neon"] = 29.58, ["Neon|Ride"] = 68.63, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 163.72, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 40.26, ["Fly"] = 53.69, ["Ride"] = 44.08, ["Fly|Ride"] = 83.56, ["Neon"] = 273.66, ["Neon|Ride"] = 156.63, ["Neon|Fly|Ride"] = 164.06, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 28.22, ["Ride"] = 20.72, ["Fly|Ride"] = 40.32, ["Neon"] = 23.16, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 94.06, ["Mega"] = 472.5, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 260.26}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 292.24, ["Fly"] = 320.25, ["Ride"] = 309.75, ["Fly|Ride"] = 383.24, ["Neon"] = 1060.56, ["Neon|Ride"] = 1166.82, ["Neon|Fly|Ride"] = 1019.82, ["Mega|Fly|Ride"] = 6266.65}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.62, ["Fly"] = 60.09, ["Ride"] = 40.16, ["Fly|Ride"] = 75.22, ["Neon"] = 106.55, ["Neon|Fly"] = 167.12, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 208.9, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 599.52}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 12.18, ["Fly"] = 27.17, ["Ride"] = 21.87, ["Fly|Ride"] = 44.63, ["Neon"] = 41.78, ["Neon|Fly"] = 134.59, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 409.89, ["Fly|Ride"] = 683.08, ["Neon|Ride"] = 2818.95, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.65, ["Fly"] = 1416.79, ["Ride"] = 1283.84, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 25064.47}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 83.08, ["Fly"] = 125.34, ["Ride"] = 97.13, ["Fly|Ride"] = 90.88, ["Neon"] = 971.25, ["Neon|Ride"] = 1742.14, ["Neon|Fly|Ride"] = 394.32, ["Mega|Fly|Ride"] = 3937.27}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 171.94, ["Fly"] = 212.12, ["Ride"] = 157.5, ["Fly|Ride"] = 229.67, ["Neon"] = 556.49, ["Neon|Fly"] = 668.46, ["Neon|Ride"] = 696.65, ["Neon|Fly|Ride"] = 580.65, ["Mega"] = 5571.05, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2640.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.85, ["Ride"] = 47.24, ["Fly|Ride"] = 278.88, ["Neon"] = 223.54, ["Neon|Fly"] = 417.79, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 376.01, ["Mega"] = 656.25, ["Mega|Ride"] = 2088.89, ["Mega|Fly|Ride"] = 898.24}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 278.88, ["Fly|Ride"] = 278.88, ["Neon|Fly|Ride"] = 1322.25, ["Mega|Fly|Ride"] = 4093.1}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1743.23, ["Ride"] = 2243.27, ["Fly|Ride"] = 1953.16, ["Neon|Fly|Ride"] = 7102.19, ["Mega|Fly|Ride"] = 48044.21}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 44.08, ["Ride"] = 52.5, ["Fly|Ride"] = 196.87, ["Neon"] = 312.31, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 2088.89, ["Mega|Ride"] = 2297.78, ["Mega|Fly|Ride"] = 1671.12}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 808.5, ["Ride"] = 633.35, ["Fly|Ride"] = 652.32, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 3103.96}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 47.25, ["Fly"] = 70, ["Ride"] = 57.75, ["Fly|Ride"] = 99.03, ["Neon"] = 334.23, ["Neon|Ride"] = 208.9, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1090.41}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.82, ["Fly"] = 35.53, ["Ride"] = 21, ["Fly|Ride"] = 47.52, ["Neon"] = 40.16, ["Neon|Fly"] = 96.09, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 161.28, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 188.65, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.86, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 208.9, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 626.68, ["Mega|Ride"] = 1393.29, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 669.38, ["Fly"] = 1575, ["Ride"] = 656.25, ["Fly|Ride"] = 734.35, ["Neon|Ride"] = 2465.05, ["Neon|Fly|Ride"] = 1732.5, ["Mega|Fly|Ride"] = 5848.87}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 525, ["Ride"] = 616.88, ["Fly|Ride"] = 835.56, ["Neon"] = 5222.2, ["Neon|Fly|Ride"] = 3064.4, ["Mega|Fly|Ride"] = 13926.56}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.57, ["Fly"] = 26.25, ["Ride"] = 25.99, ["Fly|Ride"] = 47.23, ["Neon"] = 208.9, ["Neon|Ride"] = 118.05, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 630.45}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.1, ["Ride"] = 21.89, ["Fly|Ride"] = 47.25, ["Neon"] = 98.19, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 975.53, ["Mega|Ride"] = 388.58, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.62, ["Ride"] = 36.58, ["Fly|Ride"] = 111.46, ["Neon"] = 23.63, ["Neon|Fly"] = 315.23, ["Neon|Ride"] = 49.7, ["Neon|Fly|Ride"] = 98.19, ["Mega"] = 189, ["Mega|Fly"] = 456.89, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.52, ["Fly"] = 68.6, ["Ride"] = 56.41, ["Fly|Ride"] = 102.1, ["Neon"] = 221.96, ["Neon|Ride"] = 208.9, ["Neon|Fly|Ride"] = 213.94, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 36.73, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 348.86, ["Neon|Ride"] = 479.25, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1566.67, ["Mega|Ride"] = 1566.67, ["Mega|Fly|Ride"] = 1566.67}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.12, ["Fly"] = 39.71, ["Ride"] = 27.57, ["Fly|Ride"] = 70, ["Neon"] = 91.23, ["Neon|Fly"] = 158.22, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 194.29, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 482.99}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.62, ["Fly"] = 70, ["Ride"] = 38.18, ["Fly|Ride"] = 96.1, ["Neon"] = 196.88, ["Neon|Ride"] = 263.21, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 28.22, ["Ride"] = 23.62, ["Fly|Ride"] = 55.51, ["Neon"] = 32.92, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 110.99, ["Mega"] = 525, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 346.77}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.52, ["Fly"] = 30.56, ["Ride"] = 31.17, ["Fly|Ride"] = 1312.49, ["Neon"] = 24.86, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 167.12, ["Mega"] = 307.13, ["Mega|Fly"] = 474.2, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 49.76, ["Fly"] = 65.59, ["Ride"] = 64.32, ["Fly|Ride"] = 89.25, ["Neon"] = 409.68, ["Neon|Ride"] = 277.83, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 2362.5, ["Ride"] = 1706.25, ["Fly|Ride"] = 1680, ["Neon|Fly"] = 5017.44, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 16372.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 521.19, ["Fly"] = 696.65, ["Ride"] = 380.63, ["Fly|Ride"] = 531.57, ["Neon"] = 3148.6, ["Neon|Ride"] = 2506.67, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9716.43}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 253.05, ["Ride"] = 326.82, ["Fly|Ride"] = 417.79, ["Neon"] = 1252.3, ["Neon|Ride"] = 1378.68, ["Neon|Fly|Ride"] = 1504.01, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 30.19, ["Ride"] = 40.24, ["Fly|Ride"] = 96.45, ["Neon"] = 328.75, ["Neon|Fly"] = 417.79, ["Neon|Ride"] = 308.13, ["Neon|Fly|Ride"] = 417.79, ["Mega|Ride"] = 940.02, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34815.35, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16283.04, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 460.61, ["Fly"] = 479.41, ["Ride"] = 446.25, ["Fly|Ride"] = 538.13, ["Neon|Ride"] = 2853.43, ["Neon|Fly|Ride"] = 1555.32, ["Mega"] = 6266.65, ["Mega|Fly|Ride"] = 4864.13}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 278.88, ["Ride"] = 123.4, ["Fly|Ride"] = 155.38, ["Neon|Fly|Ride"] = 696.65}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.58, ["Fly"] = 257.25, ["Ride"] = 125.03, ["Fly|Ride"] = 206.07, ["Neon"] = 706, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 598.56, ["Mega"] = 13926.56, ["Mega|Fly|Ride"] = 5222.2}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.03, ["Fly"] = 94.5, ["Ride"] = 35.44, ["Fly|Ride"] = 95.55, ["Neon"] = 181.75, ["Neon|Ride"] = 139.64, ["Neon|Fly|Ride"] = 204.37, ["Mega"] = 695.62}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4657.16, ["Ride"] = 4735.49, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 17395.14}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 35.52, ["Fly"] = 63.76, ["Ride"] = 37.76, ["Fly|Ride"] = 55.13, ["Neon"] = 333.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 180.14, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 51.19, ["Fly"] = 114.91, ["Ride"] = 48.57, ["Fly|Ride"] = 108.94, ["Neon|Fly"] = 1393.29, ["Neon|Ride"] = 275.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1574.88, ["Mega|Fly|Ride"] = 1160.39}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 590.63, ["Fly"] = 656.25, ["Ride"] = 616.11, ["Fly|Ride"] = 630, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1571.06, ["Mega"] = 5292.19, ["Mega|Ride"] = 5571.05, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.69, ["Fly"] = 26.25, ["Ride"] = 26.15, ["Fly|Ride"] = 53.81, ["Neon"] = 115.49, ["Neon|Fly"] = 157.73, ["Neon|Ride"] = 106.55, ["Neon|Fly|Ride"] = 141.49, ["Mega|Fly|Ride"] = 517.18}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 18.9, ["Fly"] = 74.18, ["Ride"] = 28.22, ["Fly|Ride"] = 493, ["Neon"] = 80.07, ["Neon|Ride"] = 192.45, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 529.55}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.75, ["Ride"] = 131.25, ["Fly|Ride"] = 183.75, ["Neon"] = 417.79, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 710.24, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.16, ["Fly"] = 104.46, ["Ride"] = 139.13, ["Fly|Ride"] = 139.97, ["Neon"] = 70, ["Neon|Fly"] = 194.29, ["Neon|Ride"] = 136.23, ["Neon|Fly|Ride"] = 246.21, ["Mega"] = 312.31, ["Mega|Ride"] = 417.79, ["Mega|Fly|Ride"] = 465.8}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Fly"] = 5116.72, ["Ride"] = 3583.12, ["Fly|Ride"] = 3609.37, ["Neon|Ride"] = 11664.32, ["Neon|Fly|Ride"] = 8531.25, ["Mega"] = 43681.6, ["Mega|Fly|Ride"] = 34632.47}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 46.3, ["Ride"] = 46.54, ["Fly|Ride"] = 135.95, ["Neon"] = 487.77, ["Neon|Ride"] = 208.9, ["Neon|Fly|Ride"] = 290.84, ["Mega|Ride"] = 975.53, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7624.42, ["Ride"] = 7624.42, ["Fly|Ride"] = 6234.38, ["Neon|Fly|Ride"] = 16015.44, ["Mega|Fly|Ride"] = 64755.24}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.55, ["Fly"] = 18.62, ["Ride"] = 20.9, ["Fly|Ride"] = 33.45, ["Neon"] = 36.58, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 456.89, ["Mega|Ride"] = 181.75, ["Mega|Fly|Ride"] = 261.17}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 28.88, ["Fly"] = 26.25, ["Ride"] = 35.44, ["Fly|Ride"] = 61.41, ["Neon"] = 195.33, ["Neon|Ride"] = 166.07, ["Neon|Fly|Ride"] = 181.75, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 944.48}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.21, ["Ride"] = 35.53, ["Fly|Ride"] = 65.63, ["Neon"] = 195.33, ["Neon|Ride"] = 139.97, ["Neon|Fly|Ride"] = 238.16, ["Mega"] = 834.52, ["Mega|Ride"] = 973.44, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.71, ["Fly"] = 262.5, ["Ride"] = 34.72, ["Fly|Ride"] = 196.88, ["Neon"] = 182.43, ["Neon|Ride"] = 153.18, ["Neon|Fly|Ride"] = 208.9, ["Mega"] = 840, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.75, ["Fly"] = 27.01, ["Ride"] = 23, ["Fly|Ride"] = 36.54, ["Neon"] = 83.56, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 2506.67, ["Mega|Ride"] = 589.12, ["Mega|Fly|Ride"] = 678.85}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8320.03}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.12, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1102.66}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.31, ["Fly"] = 111.78, ["Ride"] = 64.19, ["Fly|Ride"] = 315.26, ["Neon"] = 110.56, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 275.75, ["Mega|Ride"] = 944.47, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.11}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.34, ["Neon"] = 50.14, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 125.34, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 167.12, ["Ride"] = 147.56, ["Fly|Ride"] = 415.7, ["Neon"] = 701.37, ["Neon|Ride"] = 641.3, ["Mega|Ride"] = 3468.61, ["Mega|Fly|Ride"] = 3468.61}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 208.9, ["Ride"] = 393.75, ["Fly|Ride"] = 525, ["Neon"] = 675.68, ["Neon|Ride"] = 696.65, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2228.85, ["Mega|Ride"] = 3342.23, ["Mega|Fly|Ride"] = 2400.14}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 152.25, ["Fly"] = 246.51, ["Ride"] = 180.83, ["Fly|Ride"] = 262.5, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 4595.55, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1509.38, ["Fly"] = 2506.67, ["Ride"] = 1435.59, ["Fly|Ride"] = 1437.19, ["Neon"] = 5981.96, ["Neon|Ride"] = 4593.46, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 27852.07}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 19.46, ["Fly"] = 81.48, ["Ride"] = 39.38, ["Fly|Ride"] = 91.41, ["Neon"] = 127.31, ["Neon|Ride"] = 167.12, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 834.52, ["Mega|Ride"] = 905.55, ["Mega|Fly|Ride"] = 975.53}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 640.5, ["Fly"] = 2100, ["Ride"] = 662.19, ["Fly|Ride"] = 975.53, ["Neon|Fly|Ride"] = 3863.4}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 45.94}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Ride"] = 44.63, ["Fly|Ride"] = 681.8, ["Neon"] = 88.55, ["Neon|Ride"] = 120.14, ["Neon|Fly|Ride"] = 277.83, ["Mega"] = 393.65, ["Mega|Ride"] = 455.44, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 11.8, ["Fly"] = 257.28, ["Ride"] = 27.17, ["Fly|Ride"] = 94.79, ["Neon"] = 41.18, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 486.73, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 84.46}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.41, ["Fly"] = 108.92, ["Ride"] = 25.73, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 208.9, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 787.5, ["Mega|Ride"] = 787.44, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 31.35, ["Fly"] = 75.22, ["Ride"] = 36.75, ["Fly|Ride"] = 46.62, ["Neon"] = 236.25, ["Neon|Ride"] = 221.96, ["Neon|Fly|Ride"] = 250.68, ["Mega"] = 952.72, ["Mega|Ride"] = 1770.86, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6265.61, ["Fly"] = 10954, ["Ride"] = 4987.5, ["Fly|Ride"] = 4711.88, ["Neon|Ride"] = 16711.04, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.36, ["Fly"] = 41.78, ["Ride"] = 35.06, ["Fly|Ride"] = 94.46, ["Neon"] = 48.57, ["Neon|Ride"] = 103.69, ["Mega"] = 528.91, ["Mega|Ride"] = 543.12, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.89}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 105, ["Fly"] = 369.74, ["Ride"] = 131.25, ["Fly|Ride"] = 221.01, ["Neon"] = 418.69, ["Neon|Ride"] = 417.79, ["Neon|Fly|Ride"] = 598.5, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 72.16, ["Fly"] = 96.48, ["Ride"] = 118.13, ["Fly|Ride"] = 161.54, ["Neon"] = 294, ["Neon|Ride"] = 343.56, ["Neon|Fly|Ride"] = 557.74, ["Mega"] = 2361.13, ["Mega|Ride"] = 2820, ["Mega|Fly|Ride"] = 1253.35}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.06, ["Fly"] = 70.45, ["Ride"] = 35.44, ["Fly|Ride"] = 77.31, ["Neon"] = 196.88, ["Neon|Ride"] = 158.22, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 683.08, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.12, ["Fly"] = 40.42, ["Ride"] = 41.71, ["Fly|Ride"] = 83.55, ["Neon"] = 28.28, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 158.22, ["Mega"] = 137.82, ["Mega|Fly"] = 181.75, ["Mega|Ride"] = 196.11, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Ride"] = 31.34, ["Fly|Ride"] = 71.31, ["Neon"] = 94.01, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 183.84, ["Mega"] = 460.61, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.55, ["Fly"] = 29.71, ["Ride"] = 28.21, ["Fly|Ride"] = 55.42, ["Neon"] = 206.82, ["Neon|Ride"] = 261.21, ["Neon|Fly|Ride"] = 139.89, ["Mega|Fly|Ride"] = 766.64}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 216.83}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 22.32, ["Ride"] = 97.13, ["Neon"] = 157.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 299.88, ["Mega"] = 459.38, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 944.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 167.12, ["Fly"] = 220.8, ["Ride"] = 195.33, ["Fly|Ride"] = 262.5, ["Neon"] = 557.74, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 696.65}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 31.5, ["Fly"] = 212.01, ["Ride"] = 98.19, ["Fly|Ride"] = 245.58, ["Neon"] = 278.88, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1179.94, ["Mega|Ride"] = 1097.73, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 888.57, ["Fly"] = 1020.58, ["Ride"] = 853.1, ["Fly|Ride"] = 892.5, ["Neon|Fly"] = 2715.33, ["Neon|Ride"] = 2605.53, ["Neon|Fly|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 10368.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 227.07, ["Fly"] = 417.96, ["Ride"] = 236.25, ["Fly|Ride"] = 244.13, ["Neon"] = 1181.25, ["Neon|Ride"] = 1888.92, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 8206.59, ["Mega|Fly|Ride"] = 3483.22}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 70}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.99, ["Fly"] = 27.57, ["Ride"] = 27.57, ["Fly|Ride"] = 51.98, ["Neon"] = 52.5, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 98.19, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 437.26, ["Mega|Ride"] = 695.62, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 283.5, ["Fly"] = 762.36, ["Ride"] = 304.5, ["Fly|Ride"] = 406.88, ["Neon"] = 1086.75, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 1038.68, ["Mega|Fly|Ride"] = 4874.41}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.67}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 175.88, ["Fly"] = 264.08, ["Ride"] = 195.57, ["Fly|Ride"] = 293.81, ["Neon"] = 589.18, ["Neon|Fly"] = 1671.12, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 3203.31, ["Mega|Ride"] = 3483.22, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.13, ["Fly"] = 195.33, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 835.56, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 940.02}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.35, ["Ride"] = 27.17, ["Fly|Ride"] = 63.76, ["Neon"] = 39.36, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 225.36, ["Mega"] = 236.13, ["Mega|Ride"] = 334.23, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.54, ["Fly"] = 63, ["Ride"] = 32.4, ["Fly|Ride"] = 76.13, ["Neon"] = 108.44, ["Neon|Ride"] = 174.01, ["Neon|Fly|Ride"] = 158.22, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.49, ["Fly"] = 102.32, ["Ride"] = 44.6, ["Fly|Ride"] = 128.82, ["Neon"] = 125.15, ["Neon|Ride"] = 147, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 468.2, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 696.65}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.74, ["Fly"] = 125.34, ["Ride"] = 52.5, ["Fly|Ride"] = 139.97, ["Neon"] = 31.35, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 149.41, ["Mega|Fly"] = 278.88, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Fly"] = 918.75, ["Ride"] = 288.75, ["Fly|Ride"] = 367.84, ["Neon"] = 1532.21, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1389.94}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 129.94, ["Fly"] = 1050, ["Ride"] = 164.06, ["Fly|Ride"] = 282.19, ["Neon"] = 505.32, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 786.19, ["Mega"] = 9379.13, ["Mega|Ride"] = 2449.68, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 68.25, ["Fly"] = 167.45, ["Ride"] = 91.88, ["Fly|Ride"] = 128.63, ["Neon"] = 278.88, ["Neon|Ride"] = 439.19, ["Neon|Fly|Ride"] = 497.17, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 18.81, ["Ride"] = 57.75, ["Fly|Ride"] = 250.68, ["Neon|Ride"] = 599.75, ["Neon|Fly|Ride"] = 484.64, ["Mega|Ride"] = 615.57, ["Mega|Fly|Ride"] = 1662.76}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.28, ["Fly"] = 75.63, ["Ride"] = 49.88, ["Fly|Ride"] = 94.46, ["Neon"] = 72.63, ["Neon|Ride"] = 90.86, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 358.32, ["Mega|Fly"] = 525, ["Mega|Ride"] = 417.79, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.82, ["Fly"] = 45.96, ["Ride"] = 20.85, ["Fly|Ride"] = 88.55, ["Neon"] = 27.57, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 40.76, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 128.63, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1071.75, ["Fly"] = 1061.06, ["Ride"] = 968.63, ["Fly|Ride"] = 900.38, ["Neon"] = 3148.6, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2467.5, ["Mega|Fly|Ride"] = 10861.4}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 487.77, ["Ride"] = 446.25, ["Fly|Ride"] = 463.67, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2785.53, ["Mega"] = 10444.4, ["Mega|Fly|Ride"] = 7870.97}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 70.01, ["Fly"] = 139.97, ["Ride"] = 106.26, ["Fly|Ride"] = 181.13, ["Neon"] = 308.13, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 390.64, ["Mega"] = 1605.57, ["Mega|Ride"] = 1440.29, ["Mega|Fly|Ride"] = 1483.12}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 307.08, ["Fly"] = 249.38, ["Ride"] = 252.68, ["Fly|Ride"] = 346.77, ["Neon"] = 1338.78, ["Neon|Ride"] = 1416.7, ["Neon|Fly|Ride"] = 1288.86, ["Mega"] = 10444.4, ["Mega|Fly|Ride"] = 5959.62}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.25, ["Fly"] = 139.97, ["Ride"] = 27.26, ["Fly|Ride"] = 75.22, ["Neon"] = 139.97, ["Neon|Ride"] = 104.46, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 663.23, ["Mega|Fly|Ride"] = 677.9}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 210, ["Ride"] = 277.83, ["Fly|Ride"] = 557.74, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 2401.19, ["Mega"] = 4157.18, ["Mega|Fly|Ride"] = 3937.27}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 56.6, ["Fly"] = 63.76, ["Ride"] = 80.06, ["Fly|Ride"] = 97.81, ["Neon"] = 278.88, ["Neon|Ride"] = 499.26, ["Mega|Fly|Ride"] = 1136.63}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1443.75, ["Ride"] = 1502.19, ["Fly|Ride"] = 1547.26, ["Neon|Fly|Ride"] = 4944.39, ["Mega"] = 50133.09, ["Mega|Fly|Ride"] = 22003.22}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 17.07, ["Fly"] = 63, ["Ride"] = 43.83, ["Fly|Ride"] = 90.85, ["Neon"] = 43.52, ["Neon|Fly"] = 105, ["Neon|Ride"] = 56.41, ["Neon|Fly|Ride"] = 192.2, ["Mega"] = 306.18, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 429.8}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.88, ["Fly"] = 78.75, ["Ride"] = 69.84, ["Fly|Ride"] = 208.9, ["Neon"] = 277.83, ["Neon|Ride"] = 282.39, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1024.61, ["Mega|Fly|Ride"] = 1044.45}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 74.09, ["Fly"] = 91.88, ["Ride"] = 75.72, ["Fly|Ride"] = 75.63, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1418.99}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3480.08, ["Ride"] = 1435.07, ["Fly|Ride"] = 1155, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 505.34, ["Fly"] = 833.47, ["Ride"] = 521.19, ["Fly|Ride"] = 519.46, ["Neon"] = 1574.89, ["Neon|Fly|Ride"] = 2755.44, ["Mega|Fly|Ride"] = 14167.02}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 94.55, ["Fly"] = 315.26, ["Ride"] = 131.25, ["Fly|Ride"] = 206.07, ["Neon"] = 443.63, ["Neon|Fly"] = 557.74, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 571.78, ["Mega"] = 4177.77, ["Mega|Ride"] = 2646.62, ["Mega|Fly|Ride"] = 2284.21}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.8, ["Ride"] = 26.91, ["Fly|Ride"] = 91.58, ["Neon"] = 87.93, ["Neon|Ride"] = 77.31, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 787.5, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 668.46}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 54.32, ["Fly"] = 94.47, ["Ride"] = 48.43, ["Fly|Ride"] = 104.66, ["Neon"] = 204.75, ["Neon|Fly"] = 416.74, ["Neon|Ride"] = 208.9, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1070.78, ["Mega|Fly|Ride"] = 975.53}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 787.5, ["Ride"] = 805.69, ["Fly|Ride"] = 869.15, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 31482.67}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5083.31, ["Fly|Ride"] = 3937.5, ["Neon"] = 42000, ["Neon|Ride"] = 29934.69, ["Neon|Fly|Ride"] = 21864.31, ["Mega|Fly|Ride"] = 89126.19}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 210, ["Fly"] = 278.88, ["Ride"] = 208.9, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 1393.29, ["Mega"] = 5848.87, ["Mega|Fly|Ride"] = 5988.84}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.19, ["Fly"] = 278.88, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 278.88, ["Neon|Ride"] = 488, ["Neon|Fly|Ride"] = 975.53, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 45.94, ["Ride"] = 37.62, ["Fly|Ride"] = 79.11, ["Neon"] = 137.83, ["Neon|Ride"] = 85.04, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 696.65, ["Mega|Ride"] = 626.68, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 20.48, ["Fly"] = 38.07, ["Ride"] = 31.1, ["Fly|Ride"] = 52.64, ["Neon|Ride"] = 278.88, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.88, ["Fly"] = 278.88, ["Ride"] = 41.78, ["Fly|Ride"] = 126.34, ["Neon"] = 100.33, ["Neon|Ride"] = 139.97, ["Neon|Fly|Ride"] = 209.82, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.23, ["Fly"] = 56.41, ["Ride"] = 22.3, ["Fly|Ride"] = 56.41, ["Neon"] = 32.82, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 178.5, ["Mega|Ride"] = 192.2, ["Mega|Fly|Ride"] = 308.13}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 30.31, ["Ride"] = 45.94, ["Fly|Ride"] = 183.75, ["Neon"] = 165.04, ["Neon|Fly"] = 835.56, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 731.13, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 287.39, ["Fly"] = 341.25, ["Ride"] = 315, ["Fly|Ride"] = 380.63, ["Neon"] = 1416.7, ["Neon|Ride"] = 1039.23, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6562.5, ["Mega|Fly"] = 3967.84, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.92, ["Fly"] = 22.86, ["Ride"] = 17.06, ["Fly|Ride"] = 45.96, ["Neon"] = 23.41, ["Neon|Ride"] = 35.18, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 278.88, ["Mega|Ride"] = 220.78, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.67, ["Fly"] = 89.83, ["Ride"] = 64.32, ["Fly|Ride"] = 126.05, ["Neon"] = 171.06, ["Neon|Fly"] = 278.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 248.06, ["Mega"] = 523.69, ["Mega|Fly"] = 835.56, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 586.4}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.44, ["Fly"] = 968.15, ["Ride"] = 656.25, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1951.03, ["Neon|Fly|Ride"] = 1622.72, ["Mega|Fly|Ride"] = 3494.21}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 37.96, ["Fly"] = 91.88, ["Ride"] = 47.15, ["Fly|Ride"] = 97.76, ["Neon"] = 178.76, ["Neon|Fly"] = 472.24, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 244.39, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 328.13, ["Ride"] = 262.5, ["Fly|Ride"] = 321.57, ["Neon|Ride"] = 1114.43, ["Neon|Fly|Ride"] = 1021.13, ["Mega|Fly|Ride"] = 7242.16}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 154.6, ["Fly"] = 139.02, ["Ride"] = 133.87, ["Fly|Ride"] = 158.22, ["Neon|Ride"] = 683.08, ["Neon|Fly|Ride"] = 538.13, ["Mega|Fly|Ride"] = 2756.24}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 551.25, ["Ride"] = 652.93, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 2572.5, ["Neon|Fly|Ride"] = 2283.22, ["Mega|Fly|Ride"] = 8146.64}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.94, ["Ride"] = 47.22, ["Fly|Ride"] = 92.55, ["Neon"] = 104.46, ["Neon|Fly"] = 283.35, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 208.9, ["Mega"] = 291.92, ["Mega|Ride"] = 374.97, ["Mega|Fly|Ride"] = 387.51}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4038.87, ["Ride"] = 3704.65, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 105, ["Fly"] = 121.17, ["Ride"] = 114.18, ["Fly|Ride"] = 157.5, ["Neon"] = 315, ["Neon|Fly"] = 487.77, ["Neon|Ride"] = 460.61, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.91, ["Fly"] = 26.86, ["Ride"] = 19.68, ["Fly|Ride"] = 41.77, ["Neon"] = 22.32, ["Neon|Fly"] = 83.56, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 152.18, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 19.69, ["Fly|Ride"] = 82.69, ["Neon"] = 30.72, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.23, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 83.56, ["Fly"] = 133.18, ["Ride"] = 70.86, ["Fly|Ride"] = 55.2, ["Neon"] = 276.27, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 277.83, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1239.76, ["Ride"] = 1089.38, ["Fly|Ride"] = 1253.35, ["Neon"] = 6127.74, ["Neon|Fly|Ride"] = 5919.89}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6037.49, ["Ride"] = 6824.37, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 25.73, ["Fly"] = 26.25, ["Ride"] = 30.09, ["Fly|Ride"] = 56.41, ["Neon"] = 208.9, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 154.6, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 18.81, ["Ride"] = 31.54, ["Fly|Ride"] = 74.85, ["Neon"] = 89.75, ["Neon|Ride"] = 89.45, ["Neon|Fly|Ride"] = 175.62, ["Mega"] = 642.48, ["Mega|Ride"] = 529.55, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 51.45, ["Fly"] = 157.49, ["Ride"] = 61.07, ["Fly|Ride"] = 108.82, ["Neon"] = 328.13, ["Neon|Ride"] = 382.52, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 1671.12, ["Mega|Ride"] = 1811.08, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 196.87, ["Fly"] = 315.26, ["Ride"] = 223.13, ["Fly|Ride"] = 249.38, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 857.82, ["Mega"] = 10444.4, ["Mega|Fly|Ride"] = 3725.53}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.56, ["Ride"] = 36.48, ["Fly|Ride"] = 86.62, ["Neon"] = 22.99, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 245.57, ["Mega"] = 158.81, ["Mega|Ride"] = 163.61, ["Mega|Fly|Ride"] = 315.23}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 199.67, ["Fly"] = 274.71, ["Ride"] = 220.19, ["Fly|Ride"] = 292.45, ["Neon"] = 947.31, ["Neon|Ride"] = 843.92, ["Neon|Fly|Ride"] = 944.47, ["Mega|Fly|Ride"] = 3755.81}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.94, ["Fly"] = 20.65, ["Ride"] = 19.09, ["Fly|Ride"] = 49.1, ["Neon"] = 26.37, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 108.64, ["Mega"] = 196.88, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 239.48}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 268.82, ["Ride"] = 278.25, ["Fly|Ride"] = 250.68, ["Neon|Ride"] = 787.45, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 10444.4, ["Mega|Ride"] = 4177.77, ["Mega|Fly|Ride"] = 4177.77}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 14.43, ["Fly"] = 80.29, ["Ride"] = 27.09, ["Fly|Ride"] = 56.27, ["Neon"] = 81.38, ["Neon|Fly"] = 299.88, ["Neon|Ride"] = 96.1, ["Neon|Fly|Ride"] = 296.33, ["Mega"] = 523, ["Mega|Ride"] = 584.9, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.57, ["Ride"] = 22.44, ["Fly|Ride"] = 86.63, ["Neon"] = 15.37, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 77.41, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 92.61, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.93, ["Mega"] = 22.99, ["Mega|Ride"] = 139.32}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 6.3, ["Fly"] = 52.48, ["Ride"] = 313.35, ["Fly|Ride"] = 139.61, ["Neon"] = 15.54, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 109.32, ["Mega"] = 68.25, ["Mega|Fly"] = 157408.73, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.9, ["Fly"] = 136.83, ["Ride"] = 115.77, ["Fly|Ride"] = 159.21, ["Neon"] = 319.61, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 385.88, ["Mega|Fly|Ride"] = 1311.82}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 17.07, ["Neon"] = 12.54, ["Neon|Ride"] = 23.16, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 110.99, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.7, ["Ride"] = 116.25, ["Fly|Ride"] = 186.55, ["Neon"] = 65.61, ["Neon|Ride"] = 111.57, ["Mega"] = 554.61, ["Mega|Ride"] = 365.3, ["Mega|Fly|Ride"] = 621.11}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 40.71, ["Neon|Fly|Ride"] = 261.95, ["Mega"] = 22.49, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 14.12, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 12.95, ["Neon|Fly|Ride"] = 39.71, ["Mega"] = 14.97, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 24.01, ["Mega|Fly|Ride"] = 63.95}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 13.85, ["Fly|Ride"] = 27.34, ["Neon"] = 4.18, ["Neon|Fly"] = 33.09, ["Neon|Ride"] = 15.77, ["Neon|Fly|Ride"] = 59.55, ["Mega"] = 26.15, ["Mega|Fly"] = 155.31, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 97.12}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 125.34, ["Neon"] = 2.24, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 78.64, ["Mega"] = 16.68, ["Mega|Ride"] = 148.76, ["Mega|Fly|Ride"] = 557.74}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 16.74, ["Fly|Ride"] = 107.62, ["Neon"] = 3.72, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.17, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 75.84, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 195.17, ["Mega"] = 20.9, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 57.31, ["Ride"] = 17.07, ["Fly|Ride"] = 52.5, ["Neon"] = 10.32, ["Neon|Fly"] = 56.44, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 63, ["Mega"] = 63, ["Mega|Fly"] = 165.37, ["Mega|Ride"] = 84.82, ["Mega|Fly|Ride"] = 135.06}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 46.04, ["Neon"] = 2.1, ["Neon|Ride"] = 62.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 18.38, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 34.98, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 23.62, ["Mega"] = 278.88, ["Mega|Fly"] = 315, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 6.03, ["Neon|Ride"] = 31.35, ["Mega"] = 70.86, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.52, ["Ride"] = 32.82, ["Neon"] = 5.24, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 34.13, ["Mega|Ride"] = 175.92, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 29.48, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 13.11, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 14.44, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 27.46, ["Mega|Fly|Ride"] = 97.76}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 6.56, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 23.75, ["Neon|Ride"] = 140.95, ["Mega"] = 265.3}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 17.94, ["Fly|Ride"] = 78.75, ["Neon"] = 6.18, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 26.17, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 69.77, ["Mega|Fly|Ride"] = 141.16}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.93, ["Neon"] = 17.31, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 93.19, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.24, ["Ride"] = 32.81, ["Fly|Ride"] = 190.11, ["Neon"] = 15.68, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 222.49, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 118.05}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.36, ["Ride"] = 12.79, ["Fly|Ride"] = 25.74, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 11.8, ["Neon|Fly|Ride"] = 41.15, ["Mega"] = 20.48, ["Mega|Fly"] = 25.08, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 55.27}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 25.73, ["Ride"] = 19.65, ["Fly|Ride"] = 86.63, ["Neon"] = 21.59, ["Neon|Ride"] = 113.34, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 250.68}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.21, ["Fly"] = 41.78, ["Ride"] = 18.23, ["Fly|Ride"] = 58.46, ["Neon"] = 68.6, ["Neon|Ride"] = 121.17, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 211.14, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.68, ["Ride"] = 14.65, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 12.18, ["Neon|Fly|Ride"] = 49.61, ["Mega"] = 14.44, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 38.59, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.43, ["Ride"] = 41.82, ["Fly|Ride"] = 63, ["Neon"] = 7.82, ["Neon|Fly"] = 77.31, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 45.49, ["Mega|Fly"] = 164.39, ["Mega|Ride"] = 52.5}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.72, ["Neon"] = 4.54, ["Neon|Fly"] = 112.3, ["Neon|Ride"] = 35.53, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 32.15, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.87, ["Ride"] = 31.35, ["Neon"] = 2.1, ["Neon|Fly"] = 41.5, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 83.56, ["Mega"] = 16.85, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.19, ["Ride"] = 17.07, ["Fly|Ride"] = 42.02, ["Neon"] = 11.51, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 79.11, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 277.83}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 3.86, ["Neon|Ride"] = 42.42, ["Neon|Fly|Ride"] = 94.46, ["Mega"] = 27.72, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 334.23}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 16.17, ["Fly|Ride"] = 36.05, ["Neon"] = 4.54, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 16.2, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 89.22, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 15.75, ["Ride"] = 28.22, ["Neon"] = 36.16, ["Mega"] = 230.07, ["Mega|Fly|Ride"] = 835.55}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.54, ["Fly|Ride"] = 48.05, ["Neon"] = 14.95, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 157.5, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 278.88}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.73, ["Fly"] = 20.37, ["Ride"] = 18.38, ["Fly|Ride"] = 62.68, ["Neon"] = 14.53, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 104.46, ["Mega"] = 131.25, ["Mega|Fly"] = 416.74, ["Mega|Ride"] = 417.38, ["Mega|Fly|Ride"] = 182.19}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 109.81, ["Ride"] = 17.73, ["Fly|Ride"] = 137.7, ["Neon"] = 19.69, ["Mega"] = 123.3, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.5, ["Ride"] = 28.22, ["Neon|Ride"] = 174.74, ["Mega|Ride"] = 936.88, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.59, ["Ride"] = 262.49, ["Neon"] = 41.78, ["Neon|Ride"] = 91.88, ["Mega"] = 208.9, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.13, ["Ride"] = 26.25, ["Fly|Ride"] = 139.13, ["Neon"] = 56.41, ["Neon|Ride"] = 56.01, ["Mega"] = 248.07, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 353.72}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 64.99, ["Mega"] = 25.09, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 39.56}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 7.77, ["Fly"] = 20.85, ["Ride"] = 23.39, ["Fly|Ride"] = 123.87, ["Neon"] = 24.94, ["Neon|Ride"] = 28.12, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 273, ["Mega|Fly"] = 334.23, ["Mega|Ride"] = 276.24, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Fly|Ride"] = 65.63, ["Neon"] = 3.93, ["Mega"] = 28.22, ["Mega|Ride"] = 111.78, ["Mega|Fly|Ride"] = 169.21}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 36.62, ["Neon"] = 3.88, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 406.66, ["Mega"] = 58.5, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 18.8, ["Fly|Ride"] = 54.54, ["Neon"] = 11.37, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 101.63, ["Mega"] = 124.68, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 14.33, ["Ride"] = 33.75, ["Fly|Ride"] = 75.57, ["Neon"] = 43.89, ["Neon|Ride"] = 83.56, ["Neon|Fly|Ride"] = 188.91, ["Mega"] = 292.45, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 45.93, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 277.83}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 16.72, ["Fly|Ride"] = 278517.48, ["Neon"] = 3.42, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 27.57, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 128.46, ["Mega|Fly|Ride"] = 104.89}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 25.46, ["Ride"] = 17.06, ["Fly|Ride"] = 34.13, ["Neon"] = 5.1, ["Neon|Fly"] = 70, ["Neon|Ride"] = 22.99, ["Neon|Fly|Ride"] = 70, ["Mega"] = 47.83, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 139.19}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 94.46, ["Neon"] = 3.83, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 107.6, ["Mega"] = 26.66, ["Mega|Fly"] = 120.43, ["Mega|Ride"] = 59.85, ["Mega|Fly|Ride"] = 120.48}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 164.37, ["Neon|Fly|Ride"] = 173.39, ["Mega"] = 59.07, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 82.25, ["Mega|Fly|Ride"] = 200.91}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 28.04, ["Ride"] = 18.17, ["Fly|Ride"] = 73.62, ["Neon"] = 3.9, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 77.93, ["Mega"] = 26.17, ["Mega|Ride"] = 41.78, ["Mega|Fly|Ride"] = 107.6}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.24, ["Mega"] = 19.69, ["Mega|Ride"] = 104.81, ["Mega|Fly|Ride"] = 139.97}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 155.6, ["Mega"] = 31.88, ["Mega|Fly"] = 118.07, ["Mega|Ride"] = 49.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.22, ["Ride"] = 14.12, ["Fly|Ride"] = 69.56, ["Neon"] = 4.18, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 129.78, ["Mega"] = 139.97, ["Mega|Ride"] = 45.45, ["Mega|Fly|Ride"] = 151.13}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.76, ["Fly"] = 56.41, ["Ride"] = 137.76, ["Neon"] = 95.82, ["Neon|Ride"] = 315.23, ["Mega"] = 459.69, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 934.79}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 31.5, ["Neon|Ride"] = 206.82, ["Mega"] = 1590.7, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.23, ["Ride"] = 26.24, ["Fly|Ride"] = 410.87, ["Neon"] = 20.79, ["Mega"] = 274.32, ["Mega|Ride"] = 155.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.73, ["Ride"] = 12.18, ["Neon"] = 2.1, ["Neon|Fly"] = 17.52, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 39.56, ["Mega"] = 16.78, ["Mega|Fly"] = 36.58, ["Mega|Ride"] = 27.97, ["Mega|Fly|Ride"] = 62.37}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.9, ["Fly"] = 118.12, ["Ride"] = 20.9, ["Fly|Ride"] = 70, ["Neon"] = 10.4, ["Neon|Fly"] = 90.36, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 696.65, ["Mega"] = 116.08, ["Mega|Ride"] = 97.64}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.16, ["Mega"] = 15.65, ["Mega|Fly"] = 72.17, ["Mega|Ride"] = 74.87, ["Mega|Fly|Ride"] = 100.2}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 93.29, ["Neon"] = 3.94, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 103.32, ["Mega"] = 24.94, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.63, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 8.36, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 157.39, ["Mega|Ride"] = 190.12, ["Mega|Fly|Ride"] = 334.23}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 158.83, ["Ride"] = 211.31, ["Fly|Ride"] = 262.5, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Neon|Fly|Ride"] = 1114.43, ["Mega"] = 8355.53, ["Mega|Fly|Ride"] = 3335.96}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.2, ["Neon|Fly"] = 56.2, ["Neon|Ride"] = 68.25, ["Mega"] = 62.68, ["Mega|Ride"] = 83.56, ["Mega|Fly|Ride"] = 724.86}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.93, ["Fly"] = 103.68, ["Ride"] = 24.04, ["Fly|Ride"] = 139.97, ["Neon"] = 28.22, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 350.83, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1044.45}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 32.78, ["Neon"] = 5.19, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.08, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 131.25, ["Mega|Ride"] = 70.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 18.88, ["Fly|Ride"] = 52.5, ["Neon"] = 12.6, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.82, ["Mega|Ride"] = 98.19, ["Mega|Fly|Ride"] = 584.9}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 5.24, ["Fly"] = 26.24, ["Ride"] = 18, ["Fly|Ride"] = 34.13, ["Neon"] = 32.81, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 208.9, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.63, ["Fly"] = 41.78, ["Ride"] = 41.78, ["Fly|Ride"] = 249.58, ["Neon"] = 22.09, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 620.41, ["Mega"] = 315.23, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 16.56, ["Fly|Ride"] = 32.57, ["Neon"] = 17.06, ["Neon|Fly"] = 82.53, ["Neon|Ride"] = 35.53, ["Neon|Fly|Ride"] = 66.87, ["Mega|Fly"] = 207.85, ["Mega|Ride"] = 696.65, ["Mega|Fly|Ride"] = 228.93}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.13, ["Fly"] = 93.92, ["Ride"] = 101.07, ["Fly|Ride"] = 159.74, ["Neon"] = 453.35, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 348.86, ["Neon|Fly|Ride"] = 390.64, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 322.18, ["Ride"] = 246.45, ["Fly|Ride"] = 295.32, ["Neon"] = 932.67, ["Neon|Ride"] = 1462.23, ["Neon|Fly|Ride"] = 973.25, ["Mega"] = 10444.4, ["Mega|Fly|Ride"] = 4038.87}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 62.68, ["Fly"] = 139.97, ["Ride"] = 70, ["Fly|Ride"] = 106.76, ["Neon"] = 382.28, ["Neon|Ride"] = 277.57, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1266.19}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 28.88, ["Fly|Ride"] = 139.97, ["Neon"] = 18.68, ["Neon|Ride"] = 52.23, ["Neon|Fly|Ride"] = 125.72, ["Mega"] = 202.64, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 348.86}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 7.88, ["Fly"] = 68.72, ["Ride"] = 30.82, ["Fly|Ride"] = 86.7, ["Neon"] = 139.19, ["Neon|Ride"] = 97.08, ["Neon|Fly|Ride"] = 174.43, ["Mega"] = 351.75, ["Mega|Ride"] = 450.15, ["Mega|Fly|Ride"] = 626.68}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 26.93, ["Ride"] = 17.28, ["Fly|Ride"] = 36.57, ["Neon"] = 6.57, ["Neon|Fly"] = 23.45, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 66.85, ["Mega|Fly"] = 212.51, ["Mega|Ride"] = 106.55, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.88, ["Fly"] = 70, ["Ride"] = 22.19, ["Fly|Ride"] = 262.5, ["Neon"] = 50.27, ["Neon|Ride"] = 158.22, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 806.32, ["Mega|Ride"] = 593.25, ["Mega|Fly|Ride"] = 557.74}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.54, ["Ride"] = 17.07, ["Fly|Ride"] = 41.88, ["Neon"] = 11.1, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 35.53, ["Neon|Fly|Ride"] = 56.41, ["Mega"] = 131.25, ["Mega|Ride"] = 174.74, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.49, ["Ride"] = 20.46, ["Fly|Ride"] = 126.35, ["Neon"] = 52.98, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 207.37, ["Mega|Ride"] = 207.85, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 36.58, ["Neon"] = 2.1, ["Neon|Ride"] = 18.67, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 15.75, ["Mega|Ride"] = 37.71, ["Mega|Fly|Ride"] = 209664.94}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 45.94, ["Ride"] = 17.43, ["Fly|Ride"] = 55.13, ["Neon"] = 14.44, ["Neon|Fly"] = 104.46, ["Neon|Ride"] = 41.78, ["Neon|Fly|Ride"] = 98, ["Mega"] = 108.94, ["Mega|Ride"] = 132.65, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 18.48, ["Fly|Ride"] = 45.93, ["Neon"] = 45.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 283.5, ["Mega|Ride"] = 154.6, ["Mega|Fly|Ride"] = 225.51}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 175.88, ["Fly"] = 417.79, ["Ride"] = 225.75, ["Fly|Ride"] = 262.5, ["Neon"] = 700.88, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 735, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.53, ["Ride"] = 240.92, ["Fly|Ride"] = 206.07, ["Neon"] = 55.13, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 330.08, ["Mega|Ride"] = 460.61, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 43.32, ["Neon"] = 23.21, ["Neon|Ride"] = 34.95, ["Neon|Fly|Ride"] = 126.06, ["Mega"] = 137.82, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 275.75}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 26.25, ["Ride"] = 38.91, ["Fly|Ride"] = 178.5, ["Neon"] = 109.97, ["Neon|Ride"] = 145.34, ["Neon|Fly|Ride"] = 367.58, ["Mega"] = 509.4, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 695.62}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.15}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.94, ["Ride"] = 28.49, ["Neon"] = 68.24, ["Neon|Ride"] = 153.06, ["Neon|Fly|Ride"] = 626.68, ["Mega"] = 295.32, ["Mega|Ride"] = 360.82, ["Mega|Fly|Ride"] = 555.65}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.88, ["Fly"] = 77.67, ["Ride"] = 32.15, ["Fly|Ride"] = 55.02, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 143.83, ["Neon|Fly|Ride"] = 219.85, ["Mega"] = 2088.89, ["Mega|Fly|Ride"] = 787.47}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 78.75, ["Neon"] = 3.56, ["Neon|Ride"] = 53.28, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.94, ["Mega|Fly"] = 416.74, ["Mega|Ride"] = 77.13, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 10.48, ["Fly"] = 27.2, ["Ride"] = 28.22, ["Fly|Ride"] = 112.54, ["Neon"] = 57.48, ["Neon|Ride"] = 236.13, ["Mega"] = 221.17, ["Mega|Fly"] = 394.32, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 44.92, ["Ride"] = 17.06, ["Fly|Ride"] = 45.65, ["Neon"] = 14.15, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 43.87, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 124.69, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 234.7}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 25.08, ["Neon"] = 5.24, ["Neon|Ride"] = 31.1, ["Neon|Fly|Ride"] = 417.79, ["Mega"] = 29.58, ["Mega|Ride"] = 77.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.24, ["Ride"] = 70, ["Neon"] = 218.7, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 854.26, ["Mega|Ride"] = 1010.58, ["Mega|Fly|Ride"] = 962.49}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 5.8, ["Ride"] = 48.67, ["Neon"] = 80.07, ["Neon|Ride"] = 98.19, ["Mega"] = 277.83, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 8.8, ["Fly"] = 87.04, ["Ride"] = 62.68, ["Fly|Ride"] = 66.78, ["Neon"] = 64.34, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 47.23, ["Neon|Fly|Ride"] = 154.6, ["Mega"] = 343.94}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.75, ["Fly"] = 98.19, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 413.61, ["Neon|Ride"] = 417.79, ["Neon|Fly|Ride"] = 620.41, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1236.73}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.45, ["Fly"] = 39.38, ["Ride"] = 28.85, ["Fly|Ride"] = 56.44, ["Neon"] = 66.94, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 263.82, ["Mega|Ride"] = 256.1, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 77.44, ["Fly"] = 143.07, ["Ride"] = 110.25, ["Neon"] = 203.44, ["Neon|Ride"] = 218.67, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 911.91, ["Mega|Ride"] = 981.25, ["Mega|Fly|Ride"] = 843.94}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.1, ["Fly"] = 125.34, ["Ride"] = 82.32, ["Fly|Ride"] = 131.24, ["Neon"] = 86.18, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 342.57, ["Mega|Ride"] = 297.53, ["Mega|Fly|Ride"] = 478.37}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.81, ["Fly"] = 70, ["Ride"] = 28.22, ["Fly|Ride"] = 70, ["Neon"] = 82.68, ["Neon|Ride"] = 57.88, ["Neon|Fly|Ride"] = 375.43, ["Mega"] = 208.9, ["Mega|Ride"] = 1044.45, ["Mega|Fly|Ride"] = 401.42}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 27.08, ["Ride"] = 111.78, ["Fly|Ride"] = 137.11, ["Neon"] = 72.18, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 292.99, ["Mega"] = 255.18, ["Mega|Fly"] = 504.48, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.56, ["Ride"] = 34.13, ["Fly|Ride"] = 135.61, ["Neon"] = 31.5, ["Neon|Ride"] = 95.06, ["Neon|Fly|Ride"] = 136.83, ["Mega"] = 301.88, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 326.73}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 54.32, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 104.46, ["Mega"] = 15.31, ["Mega|Fly"] = 139.97, ["Mega|Ride"] = 70, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.84, ["Ride"] = 22.32, ["Fly|Ride"] = 433.46, ["Neon"] = 19.67, ["Neon|Fly"] = 125.34, ["Neon|Ride"] = 118.13, ["Mega"] = 148.76, ["Mega|Ride"] = 501.35, ["Mega|Fly|Ride"] = 472.25}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 17.73, ["Neon"] = 23.61, ["Neon|Ride"] = 208.9, ["Mega"] = 137.82, ["Mega|Ride"] = 139.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.45, ["Ride"] = 32.78, ["Fly|Ride"] = 116.89, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.37, ["Mega|Ride"] = 212.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.36, ["Ride"] = 551.25, ["Fly|Ride"] = 595.28, ["Neon|Ride"] = 1396.48, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.6, ["Fly"] = 27.75, ["Ride"] = 23.63, ["Fly|Ride"] = 56.4, ["Neon"] = 26.25, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 158.22, ["Mega|Ride"] = 390.64}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.09, ["Fly"] = 39.38, ["Ride"] = 28.3, ["Fly|Ride"] = 60.37, ["Neon"] = 62.68, ["Neon|Ride"] = 120.91, ["Neon|Fly|Ride"] = 202.64, ["Mega"] = 273.27, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Ride"] = 19.69, ["Fly|Ride"] = 313.35, ["Neon|Ride"] = 103.19, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 134.59, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 57.52, ["Ride"] = 30.19, ["Fly|Ride"] = 90.57, ["Neon"] = 10.5, ["Neon|Ride"] = 41.33, ["Neon|Fly|Ride"] = 125.34, ["Mega"] = 82.53, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 95.18, ["Mega|Fly|Ride"] = 225.07}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Ride"] = 31.7, ["Neon|Fly|Ride"] = 74.18, ["Mega"] = 23.16, ["Mega|Ride"] = 57.63, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.73}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.31, ["Ride"] = 28.13, ["Fly|Ride"] = 68.81, ["Neon"] = 52.5, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 173.45, ["Mega|Ride"] = 835.56, ["Mega|Fly|Ride"] = 835.56}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.13, ["Neon|Ride"] = 40.69, ["Mega"] = 38.66, ["Mega|Ride"] = 143.33, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 98.19, ["Ride"] = 40.73, ["Fly|Ride"] = 574.39, ["Neon"] = 11.44, ["Neon|Fly"] = 125.34, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 139.97, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 309.73}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 466.68, ["Fly|Ride"] = 437.07, ["Neon|Ride"] = 1531.17, ["Neon|Fly|Ride"] = 1365.1, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.45, ["Fly"] = 196.88, ["Ride"] = 98.19, ["Neon"] = 82.55, ["Neon|Ride"] = 115.96, ["Mega"] = 388.66, ["Mega|Ride"] = 390.64, ["Mega|Fly|Ride"] = 557.74}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.43, ["Fly"] = 111.2, ["Fly|Ride"] = 165.04, ["Neon"] = 5.09, ["Neon|Ride"] = 47.23, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 35.44, ["Mega|Fly"] = 189, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 196.8}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 835.56, ["Neon"] = 3.94, ["Neon|Ride"] = 103.39, ["Neon|Fly|Ride"] = 265.3, ["Mega"] = 21.65, ["Mega|Ride"] = 52.75, ["Mega|Fly|Ride"] = 191.15}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.59, ["Fly"] = 56.41, ["Ride"] = 41.56, ["Fly|Ride"] = 178.5, ["Neon"] = 65.54, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 292.45, ["Mega"] = 556.5, ["Mega|Fly|Ride"] = 555.65}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 30.07, ["Ride"] = 111.78, ["Neon"] = 92.11, ["Neon|Ride"] = 110.99, ["Neon|Fly|Ride"] = 203.07, ["Mega"] = 393.75, ["Mega|Ride"] = 478.41, ["Mega|Fly|Ride"] = 1076.93}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.83, ["Ride"] = 38.07, ["Fly|Ride"] = 139.97, ["Neon"] = 105, ["Neon|Ride"] = 94.46, ["Mega"] = 626.68, ["Mega|Ride"] = 692.72, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.01, ["Ride"] = 65.63, ["Neon"] = 199.5, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 459.38, ["Mega|Ride"] = 612.06, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 425.1, ["Fly|Ride"] = 616.88, ["Neon"] = 1669.03, ["Neon|Ride"] = 1670.08, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3483.22}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.62, ["Fly"] = 69.65, ["Ride"] = 22.82, ["Fly|Ride"] = 137.18, ["Neon"] = 92.66, ["Neon|Ride"] = 139.97, ["Neon|Fly|Ride"] = 134.92, ["Mega"] = 557.74, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 856.46}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 10.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.47}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.44, ["Ride"] = 39.38, ["Fly|Ride"] = 259.04, ["Neon"] = 52.39, ["Neon|Ride"] = 108.64, ["Neon|Fly|Ride"] = 221.44, ["Mega"] = 177.19, ["Mega|Fly"] = 417.79, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 318.62}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 42, ["Fly|Ride"] = 125.34, ["Neon"] = 15.66, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 44.62, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 62.68, ["Ride"] = 132.65, ["Neon"] = 259.04, ["Neon|Ride"] = 245.31, ["Neon|Fly|Ride"] = 470.02, ["Mega"] = 2506.67, ["Mega|Ride"] = 1347.33, ["Mega|Fly|Ride"] = 2060.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 585.43, ["Ride"] = 36.36, ["Neon"] = 12.48, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 52.23, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 85.32, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 178.11}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 35.53, ["Fly|Ride"] = 98.44, ["Neon"] = 11.82, ["Neon|Fly"] = 67.3, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 55.12, ["Mega|Fly|Ride"] = 157.01}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.63, ["Fly"] = 1519.88, ["Ride"] = 35.32, ["Fly|Ride"] = 111.78, ["Neon"] = 22.98, ["Neon|Fly|Ride"] = 237.11, ["Mega"] = 1253.35, ["Mega|Fly"] = 459.38, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 47.24, ["Fly"] = 70, ["Ride"] = 65.63, ["Neon"] = 334.23, ["Neon|Ride"] = 480.46, ["Neon|Fly|Ride"] = 625.64, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 274.32, ["Ride"] = 309.74, ["Fly|Ride"] = 366.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 12533.28, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.88, ["Ride"] = 47.24, ["Neon"] = 39.38, ["Neon|Ride"] = 142.4, ["Mega"] = 82.65, ["Mega|Fly|Ride"] = 403.47}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 7.86, ["Neon"] = 27.18, ["Neon|Ride"] = 56.41, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 106.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.94, ["Fly"] = 155.57, ["Ride"] = 20.56, ["Fly|Ride"] = 177.57, ["Neon"] = 36.75, ["Neon|Fly"] = 104.46, ["Mega"] = 519.1, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 55.43, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 6.34, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 44.96, ["Mega|Ride"] = 85.4, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.5, ["Ride"] = 65.54, ["Fly|Ride"] = 278.88, ["Neon"] = 8.28, ["Mega"] = 50.77, ["Mega|Fly"] = 139.97, ["Mega|Ride"] = 696.65, ["Mega|Fly|Ride"] = 274.71}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 17.05, ["Fly|Ride"] = 41.96, ["Neon"] = 5.17, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 59.07, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 136.83}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.93, ["Fly"] = 90.36, ["Ride"] = 20.79, ["Fly|Ride"] = 56.41, ["Neon"] = 8.67, ["Neon|Fly"] = 87.38, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 156.14, ["Mega|Ride"] = 235.02, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.25, ["Ride"] = 52.49, ["Fly|Ride"] = 82.56, ["Neon|Ride"] = 105, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 716.63}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 82.24, ["Fly"] = 582.75, ["Ride"] = 82.06, ["Fly|Ride"] = 160.13, ["Neon"] = 366.19, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1486.25, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1307.78}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 6.56, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 44.62, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 348.86}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.72, ["Fly|Ride"] = 35.41, ["Neon"] = 5.25, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 20.33, ["Neon|Fly|Ride"] = 69.82, ["Mega"] = 48.54, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.94, ["Fly"] = 28.22, ["Ride"] = 51.19, ["Fly|Ride"] = 131.25, ["Neon"] = 65.63, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 277.83, ["Mega"] = 626.82, ["Mega|Ride"] = 415.7, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 367.5, ["Fly"] = 393.74, ["Ride"] = 487.77, ["Fly|Ride"] = 472.24, ["Neon|Ride"] = 1811.08, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 6684.43}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 39.38, ["Fly"] = 87.47, ["Ride"] = 94.47, ["Neon"] = 250.11, ["Neon|Ride"] = 154.86, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 1253.35}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 41.78, ["Fly|Ride"] = 78.75, ["Neon"] = 9.98, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 87.94, ["Mega|Ride"] = 120.24, ["Mega|Fly|Ride"] = 250.68}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.34, ["Fly"] = 208.9, ["Ride"] = 65.62, ["Fly|Ride"] = 142.7, ["Neon"] = 131.15, ["Mega|Fly|Ride"] = 555.65}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 39.37, ["Fly"] = 76.89, ["Ride"] = 54.32, ["Fly|Ride"] = 68.83, ["Neon|Ride"] = 270.8, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2506.67, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1072.65}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 139.13, ["Ride"] = 77.31, ["Fly|Ride"] = 153.74, ["Neon"] = 422.29, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3064.4, ["Mega|Fly|Ride"] = 1900.89}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 221.26, ["Ride"] = 276.01, ["Fly|Ride"] = 301.87, ["Neon"] = 835.56, ["Neon|Ride"] = 877.34, ["Neon|Fly|Ride"] = 975.53, ["Mega|Fly|Ride"] = 3036.2}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.87, ["Fly"] = 71.04, ["Ride"] = 53.6, ["Fly|Ride"] = 213.08, ["Neon"] = 73.5, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 77.55, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 356.69, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 464.93}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.22, ["Ride"] = 17.15, ["Fly|Ride"] = 40.63, ["Neon"] = 7.27, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 63.58, ["Mega"] = 91.23, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.25, ["Fly"] = 31.58, ["Ride"] = 28.35, ["Fly|Ride"] = 639.87, ["Neon"] = 24.6, ["Neon|Fly"] = 146.24, ["Neon|Ride"] = 51.97, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 288.75, ["Mega|Ride"] = 268.74, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 344.61, ["Fly"] = 487.77, ["Ride"] = 388.42, ["Fly|Ride"] = 406.88, ["Neon"] = 1574.89, ["Neon|Ride"] = 1273.51, ["Neon|Fly|Ride"] = 1951.03, ["Mega|Ride"] = 5431.1, ["Mega|Fly|Ride"] = 5429.02}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 10.46, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 139.97, ["Mega|Ride"] = 232.92, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.56, ["Ride"] = 16.58, ["Fly|Ride"] = 41.09, ["Neon"] = 23.08, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 124.31, ["Mega"] = 178.61, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 186.37, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.01, ["Ride"] = 104.46, ["Neon"] = 98.44, ["Neon|Fly"] = 417.79, ["Neon|Ride"] = 121.87, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 471.19, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 156.19, ["Fly"] = 130.47, ["Ride"] = 121.17, ["Fly|Ride"] = 135.79, ["Neon|Ride"] = 738.43, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 33.33, ["Fly"] = 48.05, ["Ride"] = 32.4, ["Fly|Ride"] = 60.59, ["Neon"] = 91.88, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 626.68, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 106.26, ["Ride"] = 41.2, ["Neon"] = 2.63, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 696.65, ["Mega"] = 26.25, ["Mega|Ride"] = 277.83, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 2.99, ["Neon|Fly"] = 158.22, ["Neon|Ride"] = 22.99, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 31.24, ["Mega|Fly"] = 140.1, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 107.87}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.68, ["Fly"] = 417.79, ["Ride"] = 68.25, ["Fly|Ride"] = 147.08, ["Neon"] = 38.59, ["Neon|Ride"] = 99.18, ["Neon|Fly|Ride"] = 152.02, ["Mega"] = 147.92, ["Mega|Ride"] = 176.64, ["Mega|Fly|Ride"] = 272.08}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1443.75, ["Ride"] = 1312.49, ["Fly|Ride"] = 1399.13, ["Neon"] = 4200, ["Neon|Ride"] = 6963.29, ["Neon|Fly|Ride"] = 4917.24, ["Mega|Fly|Ride"] = 12533.28}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 405.21, ["Fly"] = 501.35, ["Ride"] = 459.37, ["Fly|Ride"] = 488, ["Neon"] = 1724.35, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1629.21, ["Mega"] = 16711.04, ["Mega|Fly|Ride"] = 7084.88}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 272.68, ["Fly"] = 465.94, ["Ride"] = 354.38, ["Fly|Ride"] = 429.91, ["Neon"] = 656.25, ["Neon|Fly"] = 1259.69, ["Neon|Ride"] = 617.66, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 3067.32}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 331.72, ["Fly"] = 471.79, ["Ride"] = 358.53, ["Fly|Ride"] = 517.13, ["Neon"] = 1393.29, ["Neon|Fly"] = 1393.29, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1000.51, ["Mega|Fly|Ride"] = 4457.18}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 17.74, ["Fly|Ride"] = 44.63, ["Neon"] = 5.59, ["Neon|Ride"] = 34.81, ["Neon|Fly|Ride"] = 82.29, ["Mega"] = 60.63, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 421.87, ["Ride"] = 525, ["Fly|Ride"] = 656.25, ["Neon"] = 1680, ["Neon|Fly"] = 2231.25, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1771.88, ["Mega"] = 8877.74, ["Mega|Fly|Ride"] = 7770}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.63, ["Fly"] = 183.75, ["Ride"] = 27.57, ["Neon"] = 7.56, ["Neon|Ride"] = 56.41, ["Neon|Fly|Ride"] = 155.36, ["Mega"] = 58.02, ["Mega|Ride"] = 120.43, ["Mega|Fly|Ride"] = 208.9}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 25.08, ["Ride"] = 19.71, ["Fly|Ride"] = 39.38, ["Neon"] = 10.45, ["Neon|Ride"] = 49.1, ["Neon|Fly|Ride"] = 96.83, ["Mega"] = 105, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 39.37, ["Mega"] = 32.82, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 62.68, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 43.19, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 348.86, ["Mega"] = 2088.89, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 8038.15, ["Ride"] = 18.89, ["Fly|Ride"] = 56.88, ["Neon"] = 22.08, ["Neon|Ride"] = 74.39, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.62, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 66.78, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 30.97, ["Mega|Fly"] = 696.65, ["Mega|Ride"] = 157.76, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 18.38, ["Fly|Ride"] = 58.55, ["Neon"] = 8.26, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 34.73, ["Neon|Fly|Ride"] = 74.36, ["Mega"] = 63.67, ["Mega|Fly"] = 174.43, ["Mega|Ride"] = 90.61, ["Mega|Fly|Ride"] = 176.61}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.42, ["Fly"] = 47.24, ["Ride"] = 18.68, ["Fly|Ride"] = 51.45, ["Neon"] = 154.6, ["Neon|Fly"] = 75.22, ["Neon|Ride"] = 139.97, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.05, ["Ride"] = 52.5, ["Neon"] = 56.44, ["Neon|Ride"] = 278.88, ["Neon|Fly|Ride"] = 260.92, ["Mega"] = 252.66, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.63, ["Ride"] = 27.17, ["Fly|Ride"] = 70, ["Neon"] = 36.61, ["Neon|Ride"] = 125.9, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 439.03, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.38, ["Fly|Ride"] = 55.51, ["Neon"] = 4.56, ["Neon|Fly"] = 28.22, ["Neon|Ride"] = 24.97, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 313.35}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 196.88, ["Ride"] = 258.57, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 1156.21, ["Mega"] = 8355.53, ["Mega|Fly|Ride"] = 5509.81}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 14.91, ["Ride"] = 15.75, ["Fly|Ride"] = 34.7, ["Neon"] = 6.56, ["Neon|Fly"] = 28.22, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 52.23, ["Mega"] = 35.53, ["Mega|Ride"] = 51.56, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 12.22, ["Ride"] = 94.48, ["Fly|Ride"] = 183.73, ["Neon"] = 59.06, ["Neon|Ride"] = 100.66, ["Mega"] = 376.01, ["Mega|Ride"] = 416.74, ["Mega|Fly|Ride"] = 464.35}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 36.38, ["Fly"] = 210, ["Ride"] = 124.69, ["Fly|Ride"] = 105, ["Neon"] = 236.25, ["Neon|Ride"] = 311.92, ["Neon|Fly|Ride"] = 208.9, ["Mega"] = 834.52, ["Mega|Ride"] = 863.77, ["Mega|Fly|Ride"] = 913.89}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 198.72, ["Fly"] = 308.13, ["Ride"] = 223.13, ["Fly|Ride"] = 249.38, ["Neon"] = 787.45, ["Neon|Ride"] = 699.57, ["Neon|Fly|Ride"] = 727.02, ["Mega|Ride"] = 3342.23, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.88, ["Fly"] = 168.88, ["Fly|Ride"] = 141.7, ["Neon"] = 65.63, ["Neon|Ride"] = 278.88, ["Mega"] = 285.48, ["Mega|Ride"] = 348.86, ["Mega|Fly|Ride"] = 433.46}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 47.24, ["Ride"] = 417.79, ["Fly|Ride"] = 626.68, ["Neon"] = 1462.23, ["Mega"] = 1671.12, ["Mega|Fly|Ride"] = 2088.89}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1312.5, ["Fly"] = 1465.36, ["Ride"] = 1168.13, ["Fly|Ride"] = 1266.57, ["Neon|Ride"] = 4431.51, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 17128.82}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.91, ["Fly"] = 21, ["Ride"] = 19.79, ["Fly|Ride"] = 63, ["Neon"] = 37.62, ["Neon|Fly"] = 92.99, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 98.19, ["Mega"] = 277.83, ["Mega|Ride"] = 228.75, ["Mega|Fly|Ride"] = 278.88}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.86, ["Fly"] = 13786.62, ["Ride"] = 34.73, ["Neon"] = 27.3, ["Neon|Ride"] = 104.46, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 217.26, ["Mega|Ride"] = 206.79, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 23.5, ["Fly"] = 82.53, ["Ride"] = 103.69, ["Fly|Ride"] = 82.55, ["Neon"] = 158.16, ["Mega"] = 1253.35, ["Mega|Ride"] = 1047.9, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.78, ["Fly"] = 696.65, ["Ride"] = 38.07, ["Fly|Ride"] = 77.44, ["Neon"] = 91.87, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 328.13, ["Mega|Ride"] = 356.48, ["Mega|Fly|Ride"] = 478.03}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 4.74, ["Fly"] = 20.55, ["Ride"] = 19.8, ["Fly|Ride"] = 45.02, ["Neon"] = 22.29, ["Neon|Fly"] = 79.11, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 62.35, ["Mega"] = 146.24, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 416.74, ["Ride"] = 22.44, ["Neon"] = 7.41, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 66.86, ["Neon|Fly|Ride"] = 835.56, ["Mega"] = 89.15, ["Mega|Fly"] = 139.97, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 272.92}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 348.86, ["Ride"] = 348.86, ["Fly|Ride"] = 598.57, ["Neon|Ride"] = 1259.69, ["Neon|Fly|Ride"] = 1362.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.94, ["Fly"] = 20.9, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 13.1, ["Neon|Fly"] = 83.56, ["Neon|Ride"] = 40.06, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 105, ["Mega|Ride"] = 207.85, ["Mega|Fly|Ride"] = 404.21}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.63, ["Ride"] = 22.22, ["Neon"] = 32.82, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 208.9, ["Mega|Fly|Ride"] = 586.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 26.16, ["Fly"] = 80.82, ["Ride"] = 32.22, ["Fly|Ride"] = 105, ["Neon"] = 12.24, ["Neon|Fly"] = 70, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 78.75, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 260.23, ["Ride"] = 328.13, ["Fly|Ride"] = 696.65, ["Neon"] = 892.5, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 4317.73, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.42, ["Fly"] = 55.62, ["Ride"] = 36.92, ["Fly|Ride"] = 65.63, ["Neon"] = 116.81, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 725.73, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 725.82}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.74, ["Ride"] = 41.78, ["Fly|Ride"] = 139.97, ["Neon"] = 120.75, ["Neon|Ride"] = 110.99, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 506.13, ["Mega|Ride"] = 429.17, ["Mega|Fly|Ride"] = 472.48}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.51, ["Neon|Ride"] = 40.71, ["Mega"] = 25.7, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 119.09, ["Fly"] = 111.78, ["Ride"] = 108.51, ["Fly|Ride"] = 211.85, ["Neon"] = 318.94, ["Neon|Fly"] = 472.24, ["Neon|Ride"] = 250.68, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 1389.11}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.25, ["Fly|Ride"] = 41.78, ["Neon"] = 6.55, ["Neon|Ride"] = 35.53, ["Neon|Fly|Ride"] = 588, ["Mega"] = 51.18, ["Mega|Fly|Ride"] = 416.74}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 26.24, ["Fly"] = 126.35, ["Ride"] = 31.35, ["Fly|Ride"] = 71.99, ["Neon"] = 56.02, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 382.05, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.1, ["Fly"] = 110.06, ["Ride"] = 98.19, ["Fly|Ride"] = 125.34, ["Neon"] = 209.9, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 354.09, ["Mega|Ride"] = 1335.86, ["Mega|Fly|Ride"] = 1057.58}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 27.65, ["Ride"] = 13.74, ["Fly|Ride"] = 31.4, ["Neon"] = 2.61, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 16.34, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 31.88, ["Mega|Fly"] = 55.51, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 85.12}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.93, ["Ride"] = 33.5, ["Fly|Ride"] = 1346.59, ["Neon"] = 25.19, ["Neon|Ride"] = 59.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 235.61, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.46, ["Fly"] = 139.97, ["Ride"] = 65.63, ["Fly|Ride"] = 278.88, ["Neon"] = 139.97, ["Neon|Ride"] = 126.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 586.69, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 825.12}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 135.79, ["Mega"] = 26.25, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 208.9}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 8.8, ["Ride"] = 53.27, ["Fly|Ride"] = 120.75, ["Neon"] = 58.5, ["Neon|Ride"] = 115.74, ["Neon|Fly|Ride"] = 417.79, ["Mega"] = 557.74, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 299.79, ["Mega|Fly|Ride"] = 402.19}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 17.07, ["Fly"] = 41.27, ["Ride"] = 20.86, ["Fly|Ride"] = 45.94, ["Neon"] = 205.49, ["Neon|Ride"] = 70.74, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 312.31, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.35, ["Ride"] = 52.49, ["Fly|Ride"] = 76.02, ["Neon"] = 61.69, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 129.94, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 323.79}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 22.18, ["Fly"] = 2088.89, ["Ride"] = 91.31, ["Fly|Ride"] = 104.46, ["Neon"] = 118.13, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 6295.94, ["Mega"] = 393.75, ["Mega|Ride"] = 484.98, ["Mega|Fly|Ride"] = 971.92}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 134.86, ["Fly|Ride"] = 196.87, ["Neon"] = 8.99, ["Neon|Fly"] = 56.41, ["Neon|Ride"] = 68.83, ["Mega"] = 68.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.34}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 83.92, ["Mega"] = 25.99, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 47.22}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["Fly"] = 102.38, ["Ride"] = 79.12, ["Fly|Ride"] = 90.04, ["Neon"] = 1050, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 557.74, ["Mega"] = 1244.99, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Mega"] = 27.57, ["Mega|Fly"] = 154.6, ["Mega|Ride"] = 167.12, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 433.13, ["Ride"] = 446.25, ["Fly|Ride"] = 592.22, ["Neon"] = 2032.5, ["Neon|Fly|Ride"] = 2084.73, ["Mega"] = 16711.04, ["Mega|Ride"] = 15653.03, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.33, ["Fly"] = 26.25, ["Ride"] = 39.37, ["Fly|Ride"] = 89.83, ["Neon"] = 13.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 67.08, ["Mega|Ride"] = 139.97, ["Mega|Fly|Ride"] = 165.3}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 4.85, ["Fly"] = 158.22, ["Ride"] = 23.16, ["Fly|Ride"] = 62.97, ["Neon"] = 22, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 139.97, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 291.41}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.84, ["Fly"] = 78.36, ["Ride"] = 76.13, ["Fly|Ride"] = 522.23, ["Neon"] = 78.75, ["Neon|Ride"] = 181.82, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 730.08, ["Mega|Ride"] = 542.08, ["Mega|Fly|Ride"] = 831.38}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 31.83, ["Neon"] = 54.32, ["Neon|Ride"] = 118.12, ["Mega"] = 249.38}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.88, ["Fly"] = 43.16, ["Ride"] = 76.97, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 359, ["Mega"] = 416.74, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 622.18}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 8.93, ["Fly"] = 104.99, ["Ride"] = 32.82, ["Fly|Ride"] = 188.02, ["Neon"] = 55.13, ["Neon|Ride"] = 66.09, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 211.32, ["Mega|Fly"] = 482.55, ["Mega|Ride"] = 221.82}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 12.5, ["Fly|Ride"] = 63.61, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.54, ["Neon|Fly|Ride"] = 72.01, ["Mega"] = 15.58, ["Mega|Fly"] = 59.25, ["Mega|Ride"] = 51.58, ["Mega|Fly|Ride"] = 147.05}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.87, ["Fly"] = 278.88, ["Ride"] = 27.57, ["Fly|Ride"] = 158.22, ["Neon"] = 40.63, ["Neon|Fly"] = 118.07, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 110.99, ["Mega"] = 144.38, ["Mega|Fly"] = 139.97, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.47, ["Fly"] = 334.23, ["Ride"] = 296.25, ["Fly|Ride"] = 379.32, ["Neon"] = 1474.76, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 4291.97}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.74, ["Ride"] = 137.27, ["Fly|Ride"] = 299.88, ["Neon"] = 420.31, ["Neon|Ride"] = 570.23, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4177.77, ["Mega|Ride"] = 2019.96, ["Mega|Fly|Ride"] = 1701}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 14.33, ["Fly|Ride"] = 39.38, ["Neon"] = 135.17, ["Neon|Fly"] = 70, ["Neon|Ride"] = 33.44, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 60.59, ["Mega|Fly"] = 207.85, ["Mega|Ride"] = 111.78, ["Mega|Fly|Ride"] = 167.12}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.73, ["Ride"] = 14.15, ["Fly|Ride"] = 31.96, ["Neon"] = 7.07, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.58, ["Mega"] = 81.03, ["Mega|Fly"] = 348.86, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.93, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 36.75, ["Neon|Fly|Ride"] = 417.79, ["Mega"] = 139.97, ["Mega|Ride"] = 139.97, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 229.55, ["Ride"] = 245.76, ["Fly|Ride"] = 308.13, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1327.5, ["Mega|Ride"] = 8355.53, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 48.42, ["Ride"] = 17.06, ["Fly|Ride"] = 40.99, ["Neon"] = 32.81, ["Neon|Fly"] = 181.82, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 224.44, ["Mega|Ride"] = 315.23, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.42, ["Fly"] = 158.22, ["Ride"] = 96.48, ["Fly|Ride"] = 208.9, ["Neon"] = 31.06, ["Neon|Ride"] = 139.13, ["Mega"] = 250.68, ["Mega|Ride"] = 259.87, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.9, ["Neon|Ride"] = 31.88, ["Mega"] = 49.88, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 26.92, ["Ride"] = 23.62, ["Fly|Ride"] = 56.69, ["Neon"] = 78.4, ["Neon|Ride"] = 90.36, ["Neon|Fly|Ride"] = 158.22, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 72.93, ["Fly"] = 114.19, ["Ride"] = 98.01, ["Fly|Ride"] = 209.99, ["Neon"] = 162.03, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 486.44, ["Mega|Fly"] = 2193.34, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 588.71}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.31, ["Fly"] = 68.25, ["Ride"] = 46.39, ["Fly|Ride"] = 89.81, ["Neon"] = 118.27, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 250.3, ["Mega|Ride"] = 692.91, ["Mega|Fly|Ride"] = 737.4}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.83, ["Ride"] = 11.82, ["Fly|Ride"] = 31.88, ["Neon"] = 2.63, ["Neon|Fly"] = 19.43, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 61.64, ["Mega"] = 24.11, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 39.78, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 228.01, ["Ride"] = 278.88, ["Fly|Ride"] = 390.64, ["Neon"] = 1249.17, ["Neon|Ride"] = 950.25, ["Neon|Fly|Ride"] = 1260, ["Mega|Fly|Ride"] = 4414.86}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.33, ["Fly"] = 61.61, ["Ride"] = 57.98, ["Fly|Ride"] = 132.65, ["Neon"] = 97.13, ["Neon|Ride"] = 197.07, ["Neon|Fly|Ride"] = 321.56, ["Mega"] = 508.66, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 29.21, ["Ride"] = 15.37, ["Fly|Ride"] = 39.38, ["Neon"] = 8.36, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 110.73, ["Mega"] = 59.14, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.22, ["Ride"] = 18.43, ["Fly|Ride"] = 55.47, ["Neon"] = 2.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 102.22, ["Mega"] = 24.93, ["Mega|Fly"] = 139.97, ["Mega|Ride"] = 48.7, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.62, ["Ride"] = 27.63, ["Fly|Ride"] = 69.27, ["Neon"] = 8.96, ["Neon|Ride"] = 41.78, ["Neon|Fly|Ride"] = 79.11, ["Mega"] = 111.78, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 376.01}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.46, ["Fly"] = 38.71, ["Ride"] = 23.3, ["Fly|Ride"] = 68.25, ["Neon"] = 58.35, ["Neon|Ride"] = 63.03, ["Neon|Fly|Ride"] = 113.19, ["Mega"] = 328.37, ["Mega|Ride"] = 312.38, ["Mega|Fly|Ride"] = 343.59}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.16, ["Fly"] = 56.41, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 57.88, ["Neon|Ride"] = 137.88, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 275.63, ["Mega|Ride"] = 365.99, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Neon|Ride"] = 38.52, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 32.3, ["Mega|Fly"] = 56.41, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.87, ["Ride"] = 24.93, ["Fly|Ride"] = 70, ["Neon"] = 28.85, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 295.59, ["Mega|Fly|Ride"] = 314.06}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 104.34, ["Neon"] = 4.74, ["Neon|Fly"] = 98.19, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 26.25, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 228.75}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 35.04, ["Ride"] = 20.9, ["Fly|Ride"] = 118.13, ["Neon"] = 6.18, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.85, ["Mega"] = 49.79, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 204}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Ride"] = 688.14, ["Fly|Ride"] = 721.88, ["Neon"] = 3364.64, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 11875.52}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.57, ["Ride"] = 14.94, ["Fly|Ride"] = 31.5, ["Neon"] = 15.68, ["Neon|Fly"] = 33.03, ["Neon|Ride"] = 40.76, ["Neon|Fly|Ride"] = 43.32, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3, ["Ride"] = 34.07, ["Fly|Ride"] = 164.74, ["Neon"] = 13.52, ["Neon|Fly"] = 835.56, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 58.94, ["Mega|Fly"] = 158.22, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 208.9}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 11.5, ["Fly"] = 31.5, ["Ride"] = 31.35, ["Fly|Ride"] = 59.17, ["Neon"] = 94.46, ["Neon|Fly"] = 123.22, ["Neon|Ride"] = 46.19, ["Neon|Fly|Ride"] = 103.67, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.37, ["Fly|Ride"] = 32.24, ["Neon"] = 10.17, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 68.16, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 237.11}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.63, ["Ride"] = 139.97, ["Fly|Ride"] = 207.85, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.44, ["Mega|Ride"] = 1109.74}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.28, ["Neon"] = 7.88, ["Neon|Fly"] = 134.59, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 118.23, ["Mega"] = 63.67, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 346.77}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.83, ["Fly"] = 73.5, ["Ride"] = 19.82, ["Fly|Ride"] = 65.63, ["Neon"] = 12.87, ["Neon|Ride"] = 62.68, ["Mega"] = 98.44, ["Mega|Ride"] = 219.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.5, ["Fly"] = 26.25, ["Neon"] = 14.68, ["Neon|Fly"] = 63.76, ["Neon|Ride"] = 110.99, ["Mega"] = 120.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.48, ["Ride"] = 20.9, ["Fly|Ride"] = 83.56, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 22.99, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 56.41, ["Mega|Fly"] = 200.55, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 174.75}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.65, ["Fly"] = 41.78, ["Ride"] = 23.62, ["Fly|Ride"] = 41.78, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 835.56, ["Mega|Ride"] = 534.76, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 682.5, ["Ride"] = 812.44, ["Fly|Ride"] = 904.32, ["Neon"] = 1837.5, ["Neon|Fly"] = 2278.52, ["Neon|Ride"] = 1947.77, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 8292.01, ["Mega|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 6247.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.72, ["Ride"] = 16.37, ["Fly|Ride"] = 50.78, ["Neon"] = 4.28, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 18.29, ["Neon|Fly|Ride"] = 60.34, ["Mega"] = 53.29, ["Mega|Ride"] = 81.48, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 2.63, ["Ride"] = 36.75, ["Fly|Ride"] = 118.07, ["Neon"] = 28.22, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 194.22, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 480.46}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.5, ["Ride"] = 78.7, ["Fly|Ride"] = 104.99, ["Neon"] = 413.61, ["Neon|Ride"] = 330.58, ["Neon|Fly|Ride"] = 465.84, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1612.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 53.28, ["Fly"] = 137.82, ["Ride"] = 78.46, ["Fly|Ride"] = 102.79, ["Neon"] = 103.94, ["Neon|Ride"] = 174.74, ["Mega"] = 975.53, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 1102.68}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.31, ["Ride"] = 32.4, ["Fly|Ride"] = 123.59, ["Neon"] = 62.68, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 336.37, ["Mega|Ride"] = 369.74, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.55, ["Ride"] = 69.57, ["Neon"] = 70.74, ["Neon|Ride"] = 362.45, ["Mega"] = 278.88, ["Mega|Fly"] = 512.37, ["Mega|Ride"] = 348.86, ["Mega|Fly|Ride"] = 451.39}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.33, ["Ride"] = 91.48, ["Neon"] = 177.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 304.77, ["Neon|Fly|Ride"] = 392.06, ["Mega"] = 525, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.88}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.8, ["Fly"] = 131248.69, ["Ride"] = 118.08, ["Fly|Ride"] = 78.75, ["Neon"] = 31.2, ["Neon|Ride"] = 118.05, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 165.63, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 210.11, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Neon"] = 38.07, ["Neon|Ride"] = 57.75, ["Mega"] = 881.9}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 65.63, ["Fly"] = 410.68, ["Ride"] = 98.19, ["Fly|Ride"] = 183.75, ["Neon"] = 388.55, ["Neon|Ride"] = 329.44, ["Neon|Fly|Ride"] = 362.45, ["Mega|Ride"] = 1670.08, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.89, ["Fly"] = 21.83, ["Ride"] = 19.95, ["Fly|Ride"] = 39.38, ["Neon"] = 21.87, ["Neon|Fly"] = 69.99, ["Neon|Ride"] = 34.76, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Fly"] = 416.74, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.78, ["Fly"] = 83.56, ["Ride"] = 26.24, ["Fly|Ride"] = 70, ["Neon"] = 28.22, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 139.97, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 277.36}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 199.55, ["Mega"] = 48.55, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 39.4, ["Fly"] = 65.63, ["Ride"] = 57.88, ["Fly|Ride"] = 120.74, ["Neon"] = 153.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 1114.43, ["Mega|Ride"] = 13926.56, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 7.87, ["Neon|Ride"] = 85.65, ["Mega"] = 78.75, ["Mega|Ride"] = 114.53, ["Mega|Fly|Ride"] = 309.65}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.93, ["Ride"] = 75.22, ["Fly|Ride"] = 275.75, ["Neon"] = 65.63, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 342, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 964.03}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 15.63, ["Fly|Ride"] = 61.69, ["Neon"] = 17.13, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 144.37, ["Mega|Ride"] = 267.39, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.01, ["Fly"] = 52.49, ["Ride"] = 20.67, ["Fly|Ride"] = 53.26, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 158.22, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.14, ["Ride"] = 47.24, ["Neon"] = 36.25, ["Neon|Ride"] = 141.68, ["Mega"] = 355.13, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.38, ["Ride"] = 83.56, ["Neon"] = 208.69, ["Neon|Ride"] = 521.19, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1050, ["Mega|Ride"] = 1610.54, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.25, ["Ride"] = 78.48, ["Fly|Ride"] = 125.34, ["Neon"] = 98.44, ["Mega"] = 411.69, ["Mega|Ride"] = 332.14, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 32.69, ["Fly"] = 65.63, ["Ride"] = 105, ["Fly|Ride"] = 278.88, ["Neon"] = 52.64, ["Mega"] = 661.13, ["Mega|Ride"] = 999.95, ["Mega|Fly|Ride"] = 1671.12}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21, ["Ride"] = 105, ["Fly|Ride"] = 528.34, ["Neon"] = 83.56, ["Neon|Ride"] = 104.46, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 835.56, ["Mega|Fly|Ride"] = 1156.21}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 102.9, ["Neon|Ride"] = 278.88, ["Mega"] = 158.78, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 315.23}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.09, ["Fly|Ride"] = 56.41, ["Neon"] = 6.18, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 25.73, ["Neon|Fly|Ride"] = 73.13, ["Mega"] = 49.29, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 119.09}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.45, ["Ride"] = 55.5, ["Fly|Ride"] = 77.88, ["Neon"] = 15.75, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 109.1, ["Mega"] = 139.89, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 397.57}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 17.72, ["Fly|Ride"] = 55.95, ["Neon"] = 6.3, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 68.36, ["Mega"] = 55, ["Mega|Ride"] = 70, ["Mega|Fly|Ride"] = 124.68}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.63, ["Ride"] = 28.22, ["Fly|Ride"] = 68.25, ["Neon"] = 18.38, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 472.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.84, ["Ride"] = 31.49, ["Fly|Ride"] = 70, ["Neon"] = 55.51, ["Neon|Fly"] = 315, ["Neon|Ride"] = 103.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 396.9, ["Mega|Ride"] = 415.7, ["Mega|Fly|Ride"] = 1044.45}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.89, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 41, ["Neon"] = 20.09, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 89.25, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 220.56}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 34.41, ["Ride"] = 22.99, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Fly"] = 83.56, ["Neon|Ride"] = 40.76, ["Neon|Fly|Ride"] = 104.46, ["Mega"] = 168, ["Mega|Ride"] = 230.84}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.71, ["Fly"] = 301.87, ["Ride"] = 43.32, ["Fly|Ride"] = 111.78, ["Neon"] = 15.75, ["Neon|Fly"] = 122.95, ["Neon|Ride"] = 56.41, ["Neon|Fly|Ride"] = 196.5, ["Mega"] = 119.66, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.06, ["Fly"] = 139.97, ["Ride"] = 102.36, ["Fly|Ride"] = 242.82, ["Neon"] = 77.44, ["Neon|Fly"] = 213.94, ["Neon|Ride"] = 272.72, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 367.5, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 497.99, ["Mega|Fly|Ride"] = 609}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 62.68, ["Ride"] = 97.13, ["Fly|Ride"] = 154.6, ["Neon"] = 236.25, ["Neon|Fly"] = 384.37, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1224.11, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 18.38, ["Fly|Ride"] = 65.63, ["Neon"] = 3.29, ["Neon|Ride"] = 41.78, ["Neon|Fly|Ride"] = 55.51, ["Mega"] = 23.72, ["Mega|Ride"] = 60.59, ["Mega|Fly|Ride"] = 130.73}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 30.75, ["Neon"] = 126.46, ["Mega"] = 835.56, ["Mega|Ride"] = 834.52, ["Mega|Fly|Ride"] = 1249.17}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.76, ["Fly"] = 105, ["Ride"] = 94.01, ["Neon"] = 293.97, ["Neon|Ride"] = 196.88, ["Mega"] = 1702.45, ["Mega|Ride"] = 1106.07, ["Mega|Fly|Ride"] = 1230.36}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.24, ["Fly"] = 190.32, ["Ride"] = 44.92, ["Fly|Ride"] = 126, ["Neon"] = 36.61, ["Neon|Ride"] = 65.63, ["Mega"] = 250.68, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.41, ["Ride"] = 110.44, ["Fly|Ride"] = 137.45, ["Neon"] = 5.07, ["Neon|Ride"] = 31.98, ["Mega"] = 45.93, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.84, ["Mega|Fly|Ride"] = 115.4}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 33.68, ["Ride"] = 12.54, ["Fly|Ride"] = 47.23, ["Neon"] = 19.69, ["Neon|Ride"] = 35.53, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 219.35, ["Mega|Fly"] = 348.86, ["Mega|Ride"] = 314.05}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.56, ["Fly|Ride"] = 31.68, ["Neon"] = 2.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.47, ["Mega"] = 31.88, ["Mega|Ride"] = 82.53, ["Mega|Fly|Ride"] = 209.88}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.78, ["Ride"] = 19.69, ["Fly|Ride"] = 69.87, ["Neon"] = 5.25, ["Neon|Ride"] = 20.64, ["Neon|Fly|Ride"] = 83.56, ["Mega"] = 43.84, ["Mega|Fly"] = 168, ["Mega|Ride"] = 105.45, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 158.22, ["Neon"] = 2.63, ["Neon|Ride"] = 40.16, ["Mega"] = 21.66, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.19, ["Ride"] = 44.92, ["Neon"] = 36.98, ["Neon|Fly|Ride"] = 206.82, ["Mega"] = 188.91, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 236.14}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.42, ["Ride"] = 37.62, ["Fly|Ride"] = 189.96, ["Neon"] = 61.42, ["Neon|Ride"] = 104.46, ["Neon|Fly|Ride"] = 141.68, ["Mega"] = 407.35, ["Mega|Ride"] = 302.9, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.95, ["Fly"] = 48.12, ["Ride"] = 20.94, ["Fly|Ride"] = 66.94, ["Neon"] = 34.91, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 91.75, ["Mega|Ride"] = 339.13, ["Mega|Fly|Ride"] = 353.72}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 86.63, ["Ride"] = 167.12, ["Fly|Ride"] = 262.5, ["Neon"] = 348.86, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 638.17, ["Mega|Fly|Ride"] = 2437.74}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.64, ["Fly"] = 71.73, ["Ride"] = 65.63, ["Fly|Ride"] = 158.23, ["Neon"] = 65.15, ["Mega"] = 624.1, ["Mega|Ride"] = 830.82}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.81, ["Ride"] = 16.27, ["Fly|Ride"] = 37.02, ["Neon"] = 3.94, ["Neon|Fly"] = 28, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 60.22, ["Mega"] = 39.71, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 31.17, ["Ride"] = 13.85, ["Fly|Ride"] = 31.23, ["Neon"] = 5.16, ["Neon|Fly"] = 25.2, ["Neon|Ride"] = 18.64, ["Neon|Fly|Ride"] = 50.13, ["Mega"] = 43.72, ["Mega|Fly"] = 74.18, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 100.37}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 391.13, ["Ride"] = 438.61, ["Fly|Ride"] = 469.87, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 11.75, ["Ride"] = 131.24, ["Fly|Ride"] = 278.88, ["Neon"] = 139.97, ["Neon|Ride"] = 104.14, ["Mega"] = 409.66, ["Mega|Fly|Ride"] = 1253.35}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 18.81, ["Ride"] = 15.68, ["Fly|Ride"] = 32.4, ["Neon"] = 4.35, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 39.38, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 115.96, ["Ride"] = 131.25, ["Fly|Ride"] = 278.88, ["Neon"] = 252.58, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 1146.8, ["Mega"] = 737.62, ["Mega|Ride"] = 802.46, ["Mega|Fly|Ride"] = 1267.97}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.57, ["Ride"] = 19.29, ["Fly|Ride"] = 32.81, ["Neon"] = 11.85, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 25.72, ["Neon|Fly|Ride"] = 56.23, ["Mega"] = 78.63, ["Mega|Fly"] = 132.65, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 169.61}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70, ["Ride"] = 18.83, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.44, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 70, ["Mega"] = 23.16, ["Mega|Fly"] = 250.68, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.68}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.88, ["Fly"] = 137.82, ["Ride"] = 65.63, ["Fly|Ride"] = 124.69, ["Neon"] = 179.81, ["Neon|Ride"] = 301.06, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 654.94, ["Mega|Ride"] = 629.98, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 8.36, ["Neon|Ride"] = 26.25, ["Mega"] = 40.59, ["Mega|Ride"] = 139.97, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 43.32, ["Ride"] = 60.8, ["Fly|Ride"] = 83.56, ["Neon"] = 328.13, ["Neon|Ride"] = 303.95, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1650.23, ["Mega|Ride"] = 1669.03, ["Mega|Fly|Ride"] = 1163.63}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.14, ["Ride"] = 48.35, ["Fly|Ride"] = 158.78, ["Neon"] = 18.67, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 417.79, ["Mega"] = 205.43, ["Mega|Ride"] = 208.9, ["Mega|Fly|Ride"] = 472.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70, ["Ride"] = 18.86, ["Neon"] = 12.48, ["Neon|Fly"] = 77.95, ["Neon|Ride"] = 52.23, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 28.22, ["Ride"] = 56.4, ["Fly|Ride"] = 393.74, ["Neon"] = 179.47, ["Neon|Ride"] = 207.85, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2074.28, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1113.38}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 179.03, ["Ride"] = 65.63, ["Fly|Ride"] = 59.07, ["Neon"] = 9.18, ["Neon|Ride"] = 69.99, ["Neon|Fly|Ride"] = 160.86, ["Mega"] = 45.82, ["Mega|Fly"] = 216.79, ["Mega|Ride"] = 90.09, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 19.69, ["Fly|Ride"] = 102.87, ["Neon"] = 9.19, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 98.19, ["Mega"] = 208.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.5, ["Fly"] = 39.71, ["Ride"] = 31.5, ["Fly|Ride"] = 82.53, ["Neon"] = 51.45, ["Neon|Ride"] = 154.6, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 345.19, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 393.72}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 30.72, ["Ride"] = 126.21, ["Fly|Ride"] = 301.88, ["Neon"] = 413.61, ["Neon|Fly|Ride"] = 975.53, ["Mega|Ride"] = 1855.88, ["Mega|Fly|Ride"] = 1416.72}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.13, ["Fly"] = 50.15, ["Ride"] = 28.86, ["Fly|Ride"] = 73.5, ["Neon"] = 84, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 158.22, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 56.43, ["Fly"] = 283.38, ["Ride"] = 119.44, ["Fly|Ride"] = 262.5, ["Neon"] = 294, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 703.5, ["Mega"] = 1476.85, ["Mega|Ride"] = 1275.96, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.08, ["Ride"] = 39.11, ["Neon"] = 20.9, ["Neon|Ride"] = 81.48, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 340.5}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.14, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 20.58, ["Neon|Ride"] = 51.19, ["Mega"] = 259.04, ["Mega|Ride"] = 213.08, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 68.15, ["Fly"] = 65.63, ["Ride"] = 47.24, ["Fly|Ride"] = 91.92, ["Neon"] = 129.52, ["Neon|Ride"] = 139.13, ["Mega"] = 515.82, ["Mega|Ride"] = 696.65, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.67, ["Fly|Ride"] = 32.4, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.52, ["Neon|Fly|Ride"] = 60.23, ["Mega"] = 7.35, ["Mega|Fly"] = 79.11, ["Mega|Ride"] = 30.35, ["Mega|Fly|Ride"] = 93.16}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 60.38, ["Fly"] = 220.5, ["Ride"] = 90.95, ["Fly|Ride"] = 277.37, ["Neon"] = 183.75, ["Neon|Fly"] = 2367.77, ["Neon|Ride"] = 288.27, ["Neon|Fly|Ride"] = 301.87, ["Mega"] = 1322.27, ["Mega|Ride"] = 1059.34, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 17.43, ["Fly|Ride"] = 108.64, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 41.78, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.65, ["Ride"] = 14.31, ["Fly|Ride"] = 38.29, ["Neon"] = 7.69, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 30.31, ["Neon|Fly|Ride"] = 78.11, ["Mega"] = 193.93, ["Mega|Ride"] = 202.71, ["Mega|Fly|Ride"] = 375.09}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 76.13, ["Ride"] = 156.19, ["Fly|Ride"] = 250.68, ["Neon"] = 328.13, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1115.63, ["Mega|Ride"] = 1203.21, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.52, ["Ride"] = 41.78, ["Neon"] = 6.14, ["Neon|Ride"] = 52.5, ["Mega"] = 52.5, ["Mega|Ride"] = 119.09, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.65}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.53, ["Fly|Ride"] = 102.37, ["Neon"] = 7.88, ["Neon|Ride"] = 71.04, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 78.75, ["Mega|Ride"] = 1056.99, ["Mega|Fly|Ride"] = 213.27}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 105, ["Ride"] = 181.52, ["Fly|Ride"] = 273.66, ["Neon"] = 538.13, ["Neon|Ride"] = 722.77, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3620.79, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2676.4}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 39.05, ["Neon"] = 31.88, ["Neon|Ride"] = 41.78, ["Neon|Fly|Ride"] = 196.38, ["Mega"] = 155.29, ["Mega|Ride"] = 125.06, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 28.22, ["Neon"] = 4.6, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.81, ["Mega|Ride"] = 137.6, ["Mega|Fly|Ride"] = 114.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.19, ["Ride"] = 27.17, ["Neon"] = 41.5, ["Neon|Ride"] = 139.97, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 457.48}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 52.5, ["Ride"] = 26.7, ["Fly|Ride"] = 157.49, ["Neon"] = 74.74, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 400.03, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 61.76, ["Ride"] = 106.55, ["Fly|Ride"] = 116.89, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 614.03, ["Mega"] = 656.25, ["Mega|Ride"] = 890.15, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 118.13, ["Fly"] = 298.89, ["Ride"] = 163.65, ["Fly|Ride"] = 217.64, ["Neon"] = 642.25, ["Neon|Fly"] = 766.64, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 578.29, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 22.15, ["Fly"] = 26.25, ["Ride"] = 28.88, ["Fly|Ride"] = 47.23, ["Neon"] = 141.75, ["Neon|Fly"] = 6252.05, ["Neon|Ride"] = 78.35, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 565.95}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 6.13, ["Fly"] = 131.23, ["Ride"] = 47.23, ["Fly|Ride"] = 91.88, ["Neon"] = 16.05, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 191, ["Mega"] = 99.74, ["Mega|Ride"] = 100.92, ["Mega|Fly|Ride"] = 348.86}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.57, ["Fly"] = 98.19, ["Ride"] = 65.63, ["Neon"] = 65.72, ["Neon|Ride"] = 91.88, ["Mega"] = 1259.62, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.45, ["Ride"] = 78.74, ["Fly|Ride"] = 131.25, ["Neon"] = 196.88, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 412.56, ["Mega"] = 1031.92, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1031.36}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.03, ["Ride"] = 85.25, ["Neon"] = 139.97, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 643.13, ["Mega|Ride"] = 752.01, ["Mega|Fly|Ride"] = 557.74}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 412.56, ["Neon"] = 1189.59, ["Neon|Ride"] = 1114.43, ["Neon|Fly|Ride"] = 1670.08, ["Mega"] = 4658.21, ["Mega|Fly|Ride"] = 4658.21}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 45.93, ["Ride"] = 61.06, ["Fly|Ride"] = 96.22, ["Neon"] = 278.88, ["Neon|Ride"] = 313.35, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1253.35}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.41, ["Fly|Ride"] = 78.73, ["Neon"] = 2.63, ["Neon|Ride"] = 19.24, ["Neon|Fly|Ride"] = 60.43, ["Mega"] = 22.31, ["Mega|Fly"] = 104.46, ["Mega|Ride"] = 41.05, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Ride"] = 24.04, ["Neon"] = 16.47, ["Neon|Ride"] = 92.64, ["Neon|Fly|Ride"] = 167.12, ["Mega"] = 158.22, ["Mega|Ride"] = 181.75, ["Mega|Fly|Ride"] = 396.9}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.82, ["Ride"] = 41.57, ["Fly|Ride"] = 144.16, ["Neon"] = 23.5, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 557.74, ["Mega"] = 105, ["Mega|Fly"] = 543.12, ["Mega|Ride"] = 166.76, ["Mega|Fly|Ride"] = 301.06}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 357, ["Fly"] = 630.48, ["Ride"] = 413.34, ["Fly|Ride"] = 564.38, ["Neon"] = 1514.45, ["Neon|Ride"] = 1704.54, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 6130.87, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.59, ["Fly"] = 64.23, ["Ride"] = 16.88, ["Fly|Ride"] = 48.29, ["Neon"] = 19.69, ["Neon|Ride"] = 41.33, ["Neon|Fly|Ride"] = 78.36, ["Mega"] = 168, ["Mega|Ride"] = 271.55, ["Mega|Fly|Ride"] = 188.91}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.01, ["Fly"] = 22.31, ["Ride"] = 20.9, ["Fly|Ride"] = 39.38, ["Neon"] = 23.56, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 136.35, ["Mega"] = 417.79, ["Mega|Ride"] = 696.65, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.25, ["Fly"] = 83.56, ["Ride"] = 26.25, ["Fly|Ride"] = 126.35, ["Neon"] = 19.69, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 90.2, ["Mega"] = 400.03, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 278.88}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 58.35, ["Fly"] = 65.82, ["Ride"] = 83.37, ["Fly|Ride"] = 98.19, ["Neon"] = 105, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 210, ["Mega"] = 937.93, ["Mega|Ride"] = 834.52, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.67, ["Fly|Ride"] = 70, ["Neon"] = 8.02, ["Neon|Ride"] = 35.53, ["Mega"] = 139.97, ["Mega|Ride"] = 398.96, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 9.08, ["Fly"] = 104.46, ["Ride"] = 30.72, ["Fly|Ride"] = 85.31, ["Neon"] = 92.54, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 208.9, ["Mega|Fly|Ride"] = 730.08}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.05, ["Neon"] = 6.04, ["Neon|Ride"] = 41.78, ["Mega"] = 40.76, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 279.84}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.1, ["Ride"] = 135.19, ["Neon"] = 83.56, ["Neon|Ride"] = 204.35, ["Mega"] = 208.9, ["Mega|Ride"] = 277.83}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.37, ["Ride"] = 78.06, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Mega"] = 308.13, ["Mega|Ride"] = 557.74, ["Mega|Fly|Ride"] = 490.91}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 12.54, ["Fly"] = 39.37, ["Ride"] = 27.27, ["Fly|Ride"] = 55.56, ["Neon"] = 58.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 62.68, ["Neon|Fly|Ride"] = 111, ["Mega"] = 584.9, ["Mega|Ride"] = 411.89, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 195.57, ["Fly"] = 216.57, ["Ride"] = 231.53, ["Fly|Ride"] = 334.23, ["Neon"] = 1043.41, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 4177.77}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.25, ["Fly|Ride"] = 56.79, ["Neon"] = 83.56, ["Neon|Fly"] = 79.11, ["Neon|Ride"] = 34.26, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 220.5, ["Mega|Ride"] = 166.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.6, ["Ride"] = 60.59, ["Fly|Ride"] = 108.12, ["Neon"] = 35.42, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 38.97, ["Ride"] = 123.26, ["Neon"] = 138.47, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 603.7, ["Mega"] = 518.44, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1114.43}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 102.38, ["Fly"] = 393.75, ["Ride"] = 139.97, ["Fly|Ride"] = 258.11, ["Neon"] = 582.75, ["Neon|Ride"] = 642.35, ["Neon|Fly|Ride"] = 619.5, ["Mega"] = 2088.89, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 2158.88}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 18.38, ["Ride"] = 65.98, ["Fly|Ride"] = 137.82, ["Neon"] = 106.75, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 416.74, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 490.91}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 16.49, ["Fly|Ride"] = 47.23, ["Neon"] = 9.21, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 190.11, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 15.01, ["Ride"] = 48.57, ["Neon"] = 63.76, ["Neon|Ride"] = 83.56, ["Mega"] = 346.77, ["Mega|Ride"] = 265.99, ["Mega|Fly|Ride"] = 696.65}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 90.76, ["Fly"] = 190.32, ["Ride"] = 123.74, ["Fly|Ride"] = 164.07, ["Neon"] = 208.9, ["Neon|Ride"] = 231.53, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 463.1, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 102.74, ["Fly|Ride"] = 56.41, ["Neon"] = 6.27, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 44.63, ["Mega|Fly"] = 167.12, ["Mega|Ride"] = 125.98, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 14.43, ["Ride"] = 362.44, ["Neon"] = 85.32, ["Neon|Ride"] = 626.45, ["Mega"] = 366.19, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 950.63, ["Fly"] = 1194.38, ["Ride"] = 1013.25, ["Fly|Ride"] = 1041.87, ["Neon"] = 3281.25, ["Neon|Ride"] = 3384.72, ["Neon|Fly|Ride"] = 2688.26, ["Mega|Fly|Ride"] = 10997.96}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 73.35, ["Fly"] = 118.08, ["Ride"] = 105.59, ["Fly|Ride"] = 187.69, ["Neon"] = 761.49, ["Neon|Fly"] = 892.5, ["Mega"] = 972.39, ["Mega|Fly|Ride"] = 703.53}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.24, ["Ride"] = 21.57, ["Fly|Ride"] = 80.89, ["Neon"] = 11.57, ["Neon|Ride"] = 40.97, ["Neon|Fly|Ride"] = 83.86, ["Mega"] = 87.94, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 147.92}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.01, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 334.23, ["Mega|Ride"] = 380.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 26.11, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 30.71, ["Mega|Fly"] = 125.34, ["Mega|Ride"] = 44.47, ["Mega|Fly|Ride"] = 165.8}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 88.2, ["Fly"] = 111, ["Ride"] = 115.5, ["Fly|Ride"] = 241.5, ["Neon"] = 273.29, ["Neon|Ride"] = 472.24, ["Neon|Fly|Ride"] = 455.02, ["Mega"] = 1100.15, ["Mega|Ride"] = 1089.38, ["Mega|Fly|Ride"] = 1170.75}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.03, ["Fly"] = 174.57, ["Ride"] = 37.79, ["Fly|Ride"] = 67.74, ["Neon"] = 44.71, ["Neon|Ride"] = 68.95, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 262.5, ["Mega|Ride"] = 207.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.89, ["Fly"] = 97.69, ["Ride"] = 28.22, ["Neon"] = 15.68, ["Neon|Ride"] = 65.63, ["Mega"] = 170.63, ["Mega|Ride"] = 208.9, ["Mega|Fly|Ride"] = 348.86}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 42.77, ["Ride"] = 75.57, ["Fly|Ride"] = 157.75, ["Neon"] = 203.68, ["Neon|Fly"] = 277.83, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 626.68, ["Mega"] = 544.3, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1001.63}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 17.07, ["Ride"] = 64.32, ["Neon"] = 47.23, ["Neon|Ride"] = 174.6, ["Neon|Fly|Ride"] = 308.7, ["Mega"] = 3148.57, ["Mega|Ride"] = 447.04, ["Mega|Fly|Ride"] = 630.45}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 53.26, ["Neon"] = 320.66, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 438.68, ["Mega"] = 1246.28, ["Mega|Ride"] = 1671.12, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.1, ["Neon"] = 28.22, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 97.09, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 267.73}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.39, ["Fly"] = 31.88, ["Ride"] = 20.9, ["Fly|Ride"] = 52.49, ["Neon"] = 52.5, ["Neon|Ride"] = 85.01, ["Neon|Fly|Ride"] = 126.35, ["Mega"] = 399, ["Mega|Ride"] = 381.94, ["Mega|Fly|Ride"] = 696.65}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 126, ["Ride"] = 154.63, ["Fly|Ride"] = 269.04, ["Neon"] = 472.5, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 595, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 17.91, ["Fly|Ride"] = 105000, ["Neon"] = 10.8, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.65, ["Neon|Fly|Ride"] = 74.87, ["Mega"] = 124.15, ["Mega|Ride"] = 140.34, ["Mega|Fly|Ride"] = 173.08}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 39.04, ["Ride"] = 27.95, ["Fly|Ride"] = 78.75, ["Neon"] = 52.49, ["Neon|Fly"] = 308, ["Neon|Ride"] = 64.64, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 370.8, ["Mega|Ride"] = 250.68, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.14, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 16.17, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 14.54, ["Mega|Fly"] = 35.53, ["Mega|Ride"] = 33.44, ["Mega|Fly|Ride"] = 99.24}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.32, ["Neon"] = 3.93, ["Neon|Ride"] = 39.71, ["Mega"] = 22.05, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 156.85}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 49.1, ["Ride"] = 19.59, ["Fly|Ride"] = 45.94, ["Neon"] = 22.44, ["Neon|Ride"] = 47.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 98.44, ["Mega|Ride"] = 139.97}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.37, ["Ride"] = 84, ["Neon"] = 312.31, ["Neon|Ride"] = 370.8, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 630.45}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.94, ["Fly"] = 19.86, ["Ride"] = 17.96, ["Fly|Ride"] = 44, ["Neon"] = 12.9, ["Neon|Fly"] = 27.17, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 114.18, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 114.14, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.57, ["Fly"] = 32.45, ["Ride"] = 25.73, ["Fly|Ride"] = 62.68, ["Neon"] = 20.67, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 87.18, ["Mega"] = 161.44, ["Mega|Fly"] = 304.99, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.94, ["Fly"] = 19.69, ["Ride"] = 18.09, ["Fly|Ride"] = 69.71, ["Neon"] = 8.57, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.69, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 125.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.8, ["Fly"] = 278.88, ["Ride"] = 45, ["Neon"] = 42.61, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 98.19, ["Mega"] = 207.81, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.86, ["Mega|Fly|Ride"] = 637.12}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 11.16, ["Fly"] = 161.9, ["Ride"] = 116.68, ["Fly|Ride"] = 220.34, ["Neon"] = 80.36, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 548.63, ["Mega|Fly|Ride"] = 696.65}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.51, ["Fly"] = 41.78, ["Ride"] = 16.7, ["Fly|Ride"] = 62.91, ["Neon"] = 23.94, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 309.17, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 578.63}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 16.84, ["Fly|Ride"] = 52.49, ["Neon"] = 15.35, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 61.27, ["Mega"] = 433.46, ["Mega|Ride"] = 236.13, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 180.28, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 278.88, ["Neon"] = 1197.98, ["Neon|Ride"] = 1133.36, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3281.25, ["Mega|Fly|Ride"] = 4038.87}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.15, ["Ride"] = 41.16, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Ride"] = 20.5, ["Fly|Ride"] = 76.01, ["Neon"] = 22.08, ["Neon|Fly"] = 208.9, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 187.11, ["Mega|Ride"] = 277.83, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 11.67, ["Ride"] = 24.94, ["Neon"] = 45.94, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 626.68, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 431.18}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.43, ["Fly|Ride"] = 31.17, ["Neon"] = 2.37, ["Neon|Fly"] = 19.67, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 16.26, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 41.78, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.02, ["Ride"] = 25.99, ["Fly|Ride"] = 58.69, ["Neon"] = 17.98, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 69.54, ["Mega"] = 118.07, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 390.64}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 56.41, ["Fly|Ride"] = 98.98, ["Neon"] = 16.73, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 61.69, ["Mega|Ride"] = 204.51, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.63, ["Fly"] = 125.34, ["Ride"] = 93.81, ["Fly|Ride"] = 111.78, ["Neon"] = 371.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 458.07, ["Mega|Ride"] = 3483.22, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.5, ["Fly"] = 85.32, ["Ride"] = 25.09, ["Fly|Ride"] = 65.62, ["Neon"] = 21.53, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 111.78, ["Mega"] = 183.75, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 433.29}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.63, ["Fly"] = 31.35, ["Ride"] = 45.5, ["Fly|Ride"] = 118.13, ["Neon"] = 5.25, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 60.38, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 123.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 63.76, ["Fly"] = 105, ["Ride"] = 78.63, ["Fly|Ride"] = 183.47, ["Neon"] = 128.62, ["Neon|Ride"] = 202.12, ["Neon|Fly|Ride"] = 557.74, ["Mega"] = 451.5, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 679.94}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.89, ["Fly|Ride"] = 31.02, ["Neon"] = 2.62, ["Neon|Fly"] = 24.03, ["Neon|Ride"] = 17.73, ["Neon|Fly|Ride"] = 39.86, ["Mega"] = 18.37, ["Mega|Fly"] = 43.7, ["Mega|Ride"] = 34.61, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 5.24, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 84.5, ["Mega"] = 39.25, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 232.93}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.62, ["Ride"] = 39.38, ["Fly|Ride"] = 137.82, ["Neon"] = 9.74, ["Neon|Ride"] = 126.34, ["Neon|Fly|Ride"] = 183.84, ["Mega"] = 139.97, ["Mega|Ride"] = 118.12}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.85, ["Fly"] = 70.86, ["Ride"] = 56.41, ["Fly|Ride"] = 141.68, ["Neon"] = 19.69, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 98.94, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 194.57, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.68, ["Ride"] = 12.49, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 20.33, ["Mega|Ride"] = 32.69, ["Mega|Fly|Ride"] = 154.6}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 25.99, ["Ride"] = 56.41, ["Fly|Ride"] = 102.72, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 208.9, ["Mega"] = 400.22, ["Mega|Ride"] = 313.35, ["Mega|Fly|Ride"] = 683.08}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2626.31, ["Fly"] = 2970.4, ["Ride"] = 2624.99, ["Fly|Ride"] = 2732.62, ["Neon|Fly|Ride"] = 13229.92, ["Mega|Fly|Ride"] = 43344.24}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.98, ["Ride"] = 22.53, ["Fly|Ride"] = 38.48, ["Neon"] = 7.47, ["Neon|Fly"] = 55.23, ["Neon|Ride"] = 23.9, ["Neon|Fly|Ride"] = 52.03, ["Mega"] = 78.75, ["Mega|Fly"] = 139.97, ["Mega|Ride"] = 113.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 11.02, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 626.68}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.9, ["Ride"] = 26.19, ["Fly|Ride"] = 69.57, ["Neon"] = 63.76, ["Neon|Ride"] = 111.78, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 328.02, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 34.55, ["Ride"] = 98.44, ["Neon"] = 155.06, ["Mega"] = 540.75, ["Mega|Ride"] = 680.99, ["Mega|Fly|Ride"] = 802.14}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 146, ["Fly"] = 1393.29, ["Ride"] = 208.62, ["Fly|Ride"] = 259.93, ["Neon"] = 730.08, ["Neon|Ride"] = 729.04, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6266.65, ["Mega|Fly|Ride"] = 2925.01}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.13, ["Fly"] = 28.22, ["Ride"] = 44.88, ["Fly|Ride"] = 675.94, ["Neon"] = 20.9, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 139.97, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.61, ["Ride"] = 52.5, ["Neon"] = 14.98, ["Neon|Fly"] = 98.19, ["Neon|Fly|Ride"] = 522.23, ["Mega"] = 108.01, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.81, ["Fly"] = 101.98, ["Ride"] = 41.2, ["Fly|Ride"] = 196.87, ["Neon"] = 9.18, ["Neon|Ride"] = 52.5, ["Mega"] = 75.72, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.01, ["Ride"] = 98.44, ["Neon"] = 167.12, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 687.1}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 80.93, ["Mega"] = 19.07, ["Mega|Ride"] = 156.18}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.87, ["Fly"] = 208.9, ["Ride"] = 98.44, ["Fly|Ride"] = 136.5, ["Neon"] = 309.32, ["Neon|Fly"] = 315.23, ["Neon|Ride"] = 188.91, ["Neon|Fly|Ride"] = 409.43, ["Mega"] = 1102.66, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.42, ["Neon|Ride"] = 137.67, ["Mega"] = 65.63, ["Mega|Ride"] = 158.22}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.93, ["Fly"] = 220.8, ["Ride"] = 74.8, ["Fly|Ride"] = 131.24, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 417.79, ["Mega"] = 2625, ["Mega|Ride"] = 2676.35, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.04, ["Fly|Ride"] = 49.77, ["Neon"] = 5.23, ["Neon|Fly"] = 120.14, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 98.44, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 147.16}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 40.69, ["Neon"] = 13.13, ["Neon|Ride"] = 118.13, ["Mega"] = 179.66, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.28, ["Ride"] = 63.76, ["Fly|Ride"] = 139.97, ["Neon"] = 72.1, ["Neon|Ride"] = 158.22, ["Neon|Fly|Ride"] = 178.1, ["Mega"] = 355.13, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 391.01, ["Fly"] = 557.74, ["Ride"] = 437.07, ["Fly|Ride"] = 571.12, ["Neon"] = 1028.98, ["Neon|Ride"] = 1080.19, ["Neon|Fly|Ride"] = 1286.25, ["Mega|Ride"] = 5153.28, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.37, ["Ride"] = 52.41, ["Fly|Ride"] = 126.24, ["Neon"] = 237.57, ["Neon|Ride"] = 244.42, ["Neon|Fly|Ride"] = 295.32, ["Mega|Ride"] = 1232.45, ["Mega|Fly|Ride"] = 835.56}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 17.06, ["Fly|Ride"] = 91.88, ["Neon"] = 9.17, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 98.19, ["Mega"] = 47.43, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.83, ["Fly"] = 365.57, ["Ride"] = 52.5, ["Fly|Ride"] = 139.97, ["Neon"] = 41.78, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 223.12, ["Mega|Fly"] = 388.55, ["Mega|Ride"] = 236.72, ["Mega|Fly|Ride"] = 328.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 10.49, ["Ride"] = 23.12, ["Fly|Ride"] = 265.13, ["Neon"] = 133.14, ["Neon|Ride"] = 68.24, ["Neon|Fly|Ride"] = 315.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 373.31}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Ride"] = 28.14, ["Neon"] = 14.97, ["Mega"] = 69.57, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.73, ["Fly"] = 39.38, ["Ride"] = 17.15, ["Fly|Ride"] = 48.57, ["Neon"] = 26.25, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 551.34, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 972.39}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.41, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 615.57, ["Neon|Fly|Ride"] = 834.52, ["Mega|Ride"] = 3064.4, ["Mega|Fly|Ride"] = 3483.22}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.88, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 231.91, ["Neon"] = 144.38, ["Neon|Ride"] = 192.14, ["Mega"] = 724.86, ["Mega|Ride"] = 729.61, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2165.63, ["Fly"] = 2349.37, ["Ride"] = 2229.93, ["Fly|Ride"] = 2375.63, ["Neon"] = 11141.04, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 11.17, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 195.33, ["Mega"] = 117.48, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 583.86}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 26.25, ["Ride"] = 96.83, ["Neon"] = 28.22, ["Mega"] = 312.31, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 505.98}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 845.53, ["Fly"] = 1448.65, ["Ride"] = 885.92, ["Fly|Ride"] = 945, ["Neon"] = 2546.78, ["Neon|Ride"] = 2968.8, ["Neon|Fly|Ride"] = 2618.44, ["Mega|Fly|Ride"] = 12278.1}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 43.99, ["Ride"] = 56.44, ["Fly|Ride"] = 91.88, ["Neon"] = 237.11, ["Neon|Ride"] = 291.72, ["Mega"] = 525, ["Mega|Ride"] = 766.64, ["Mega|Fly|Ride"] = 721.25}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.29, ["Ride"] = 22.89, ["Fly|Ride"] = 128.15, ["Neon"] = 14.78, ["Neon|Ride"] = 139.97, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131.25, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.57, ["Ride"] = 139.55, ["Neon"] = 6.21, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 79.11, ["Mega"] = 26.46, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 278.88}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 72.36, ["Ride"] = 126, ["Fly|Ride"] = 111.78, ["Neon"] = 416.74, ["Neon|Fly"] = 401.41, ["Neon|Ride"] = 354.18, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2785.53, ["Mega|Fly|Ride"] = 2676.4}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Neon"] = 36.75, ["Neon|Ride"] = 111.77, ["Mega|Ride"] = 208.9, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 84, ["Ride"] = 97.64, ["Fly|Ride"] = 167.12, ["Neon"] = 341.25, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 2012.68}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.86, ["Fly"] = 105, ["Fly|Ride"] = 111.78, ["Neon"] = 39.34, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 105, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.38, ["Ride"] = 286.13, ["Fly|Ride"] = 325.5, ["Neon"] = 1038.37, ["Neon|Ride"] = 863.63, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 4280.13}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 7.88, ["Fly"] = 87.92, ["Ride"] = 26.23, ["Fly|Ride"] = 41.62, ["Neon"] = 72.19, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega"] = 391.68, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 14.93, ["Fly|Ride"] = 35.44, ["Neon"] = 6.57, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 74.82, ["Mega|Fly"] = 101.22, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 179.22}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 866.25, ["Ride"] = 975.53, ["Fly|Ride"] = 1027.3, ["Neon|Ride"] = 7659.93, ["Neon|Fly|Ride"] = 4735.49, ["Mega|Fly|Ride"] = 27852.07}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.09, ["Fly"] = 975.53, ["Ride"] = 210, ["Neon"] = 55.12, ["Neon|Ride"] = 78.75, ["Mega"] = 208.16, ["Mega|Ride"] = 267.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.81, ["Ride"] = 62.68, ["Fly|Ride"] = 110.73, ["Neon"] = 32.81, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 173.8, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 40.2, ["Fly"] = 38.75, ["Ride"] = 41.54, ["Fly|Ride"] = 102.72, ["Neon"] = 174.43, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 183.64, ["Mega"] = 2088.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.9, ["Fly"] = 77.31, ["Ride"] = 42, ["Fly|Ride"] = 87.94, ["Neon"] = 63.76, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 367.5, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 447.04}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.17, ["Ride"] = 66.94, ["Fly|Ride"] = 110.49, ["Neon"] = 95.1, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 656.24, ["Mega"] = 484.32, ["Mega|Ride"] = 573.57, ["Mega|Fly|Ride"] = 729.04}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.03, ["Fly"] = 52.5, ["Ride"] = 116.6, ["Fly|Ride"] = 236.15, ["Neon"] = 2.63, ["Neon|Ride"] = 28.22, ["Neon|Fly|Ride"] = 69.12, ["Mega"] = 20.9, ["Mega|Fly"] = 85.01, ["Mega|Ride"] = 62.22, ["Mega|Fly|Ride"] = 91.83}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 36.66, ["Fly"] = 89.24, ["Ride"] = 66.75, ["Fly|Ride"] = 105, ["Neon"] = 345.73, ["Neon|Fly"] = 312.31, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 339.95, ["Mega"] = 1102.66, ["Mega|Ride"] = 1152.03, ["Mega|Fly|Ride"] = 1058.06}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.94, ["Fly"] = 84.28, ["Ride"] = 17.06, ["Fly|Ride"] = 105, ["Neon"] = 26.25, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 773.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 20.9, ["Fly|Ride"] = 38.04, ["Neon"] = 15.75, ["Neon|Ride"] = 52.98, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.63, ["Ride"] = 174.43, ["Neon"] = 104.9, ["Neon|Ride"] = 41.78, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 292.45, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 33.76, ["Fly"] = 262.39, ["Ride"] = 88.1, ["Fly|Ride"] = 183.75, ["Neon"] = 118.12, ["Neon|Ride"] = 211.31, ["Neon|Fly|Ride"] = 320.66, ["Mega"] = 813.09, ["Mega|Ride"] = 931.75, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.87, ["Ride"] = 696.65, ["Neon"] = 21.48, ["Neon|Fly"] = 41.78, ["Neon|Ride"] = 77.05, ["Neon|Fly|Ride"] = 118.07, ["Mega"] = 63.19, ["Mega|Fly|Ride"] = 315.23}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.52, ["Neon|Ride"] = 30.72, ["Mega"] = 19.86, ["Mega|Ride"] = 52.17, ["Mega|Fly|Ride"] = 182.79}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 24.84, ["Fly|Ride"] = 82.52, ["Neon"] = 2.62, ["Neon|Ride"] = 27.46, ["Mega"] = 32.82, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 26.71, ["Ride"] = 72.18, ["Fly|Ride"] = 50.75, ["Neon"] = 7.87, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 61.69, ["Mega|Ride"] = 139.97, ["Mega|Fly|Ride"] = 166.07}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.72, ["Fly|Ride"] = 111.78, ["Neon"] = 13.97, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.37, ["Fly|Ride"] = 58.28, ["Neon"] = 13.82, ["Neon|Ride"] = 25.08, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 397.04, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 81.75, ["Ride"] = 150.94, ["Neon"] = 196.87, ["Neon|Ride"] = 278.88, ["Neon|Fly|Ride"] = 1044.45, ["Mega"] = 834.52, ["Mega|Ride"] = 695.62, ["Mega|Fly|Ride"] = 960.9}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.98, ["Ride"] = 18.9, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 31.75, ["Mega|Ride"] = 59.05, ["Mega|Fly|Ride"] = 94.31}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.54, ["Fly"] = 62.68, ["Ride"] = 39.29, ["Fly|Ride"] = 80.49, ["Neon"] = 101.24, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 68.87, ["Neon|Fly|Ride"] = 111.87, ["Mega"] = 236.25, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 290.54}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.23, ["Fly"] = 36.58, ["Ride"] = 27.57, ["Fly|Ride"] = 125.16, ["Neon"] = 82.11, ["Neon|Ride"] = 93.98, ["Neon|Fly|Ride"] = 189, ["Mega"] = 1125.92, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 507.49}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.52, ["Fly"] = 140.44, ["Ride"] = 277.83, ["Neon"] = 51.93, ["Neon|Ride"] = 83.56, ["Mega"] = 131.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 412.56}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.68, ["Fly|Ride"] = 31.35, ["Neon"] = 6.57, ["Neon|Fly"] = 40.76, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 51.87, ["Mega"] = 49.22, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.63, ["Fly"] = 69.83, ["Ride"] = 28.22, ["Neon"] = 11.82, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 127.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.88}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Fly"] = 1235.58, ["Ride"] = 1008, ["Fly|Ride"] = 1089.38, ["Neon"] = 2296.88, ["Neon|Ride"] = 2165.63, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 7609.88}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.76, ["Fly"] = 158.22, ["Ride"] = 120.91, ["Fly|Ride"] = 188.91, ["Neon"] = 318.2, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 591.94, ["Mega"] = 2785.53, ["Mega|Ride"] = 1951.03, ["Mega|Fly|Ride"] = 1676.15}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 6.27, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.9, ["Mega"] = 72.1, ["Mega|Ride"] = 111.78, ["Mega|Fly|Ride"] = 181.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 45.94, ["Fly"] = 139.97, ["Ride"] = 84, ["Fly|Ride"] = 208.9, ["Neon"] = 208.45, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 1023.75, ["Mega|Ride"] = 1039.23, ["Mega|Fly|Ride"] = 944.48}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.57, ["Ride"] = 24.94, ["Fly|Ride"] = 156.19, ["Neon"] = 127.34, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 277.83, ["Mega"] = 268.55, ["Mega|Ride"] = 315.23, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 267.18, ["Fly"] = 417.79, ["Ride"] = 271.69, ["Fly|Ride"] = 341.25, ["Neon"] = 1253.35, ["Neon|Ride"] = 1225.13, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 7311.08}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 68.35, ["Ride"] = 25.97, ["Fly|Ride"] = 202.13, ["Neon"] = 27.87, ["Neon|Ride"] = 54, ["Mega"] = 406.81, ["Mega|Fly"] = 278.88}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 19.51, ["Neon|Ride"] = 41.78, ["Mega"] = 334.23}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 55.3, ["Ride"] = 96.54, ["Fly|Ride"] = 118.13, ["Neon"] = 260.93, ["Neon|Ride"] = 394.33, ["Mega"] = 542, ["Mega|Ride"] = 557.74, ["Mega|Fly|Ride"] = 808.41}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.55, ["Neon"] = 18.9, ["Mega"] = 78.75, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.68, ["Fly|Ride"] = 26.9, ["Neon"] = 3.3, ["Neon|Fly"] = 17.73, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 41.77, ["Mega"] = 27.45, ["Mega|Ride"] = 39.36, ["Mega|Fly|Ride"] = 103.9}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 3937.5, ["Fly|Ride"] = 4418.43, ["Neon"] = 31333.18, ["Neon|Fly|Ride"] = 23454.19, ["Mega|Fly|Ride"] = 86340.66}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.54, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 107.63, ["Neon|Ride"] = 106.32, ["Mega"] = 271.57, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.52, ["Fly"] = 20.09, ["Ride"] = 25.08, ["Fly|Ride"] = 56.41, ["Neon"] = 13, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 30.62, ["Neon|Fly|Ride"] = 74.85, ["Mega"] = 144.38, ["Mega|Ride"] = 154.6, ["Mega|Fly|Ride"] = 181.23}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 420, ["Fly"] = 840, ["Ride"] = 518.79, ["Fly|Ride"] = 527.34, ["Neon"] = 1372.81, ["Neon|Ride"] = 1532.21, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 4899.57}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 7.09, ["Ride"] = 21.73, ["Neon"] = 15.68, ["Neon|Ride"] = 145.69, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 626.68}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.13, ["Fly"] = 139.97, ["Ride"] = 328.13, ["Neon"] = 139.97, ["Neon|Ride"] = 278.88, ["Neon|Fly|Ride"] = 278.88, ["Mega"] = 416.74, ["Mega|Ride"] = 362.45}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 52.36, ["Ride"] = 23.55, ["Neon"] = 8.67, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 34.26, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 47.23, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 696.65, ["Fly"] = 780.21, ["Ride"] = 638.84, ["Fly|Ride"] = 717.94, ["Neon"] = 2100, ["Neon|Ride"] = 1880.18, ["Neon|Fly|Ride"] = 1853.51, ["Mega|Fly|Ride"] = 10861.4}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.22, ["Ride"] = 57.75, ["Neon"] = 29.94, ["Neon|Ride"] = 98.19, ["Neon|Fly|Ride"] = 211.34, ["Mega"] = 126, ["Mega|Ride"] = 172.16, ["Mega|Fly|Ride"] = 255.93}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 10.5, ["Fly"] = 236.15, ["Fly|Ride"] = 131.25, ["Neon"] = 36.94, ["Neon|Fly"] = 167.12, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 154.22, ["Mega"] = 203.4, ["Mega|Ride"] = 242.5, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 34.1, ["Ride"] = 18.84, ["Fly|Ride"] = 44.92, ["Neon"] = 13.17, ["Neon|Fly"] = 43.87, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 73.29, ["Mega"] = 105, ["Mega|Fly"] = 139.97, ["Mega|Fly|Ride"] = 179.03}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21.36, ["Ride"] = 41.57, ["Neon"] = 118.13, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.88, ["Mega"] = 517.01, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.22, ["Neon"] = 3.94, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 36.75, ["Mega|Ride"] = 101.05, ["Mega|Fly|Ride"] = 223.53}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 501.35, ["Ride"] = 472.5, ["Fly|Ride"] = 613.11, ["Neon"] = 2589.57, ["Neon|Ride"] = 2504.58, ["Neon|Fly|Ride"] = 2506.88, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.6, ["Ride"] = 51.19, ["Fly|Ride"] = 330.05, ["Neon"] = 9.19, ["Neon|Ride"] = 83.56, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 71.54, ["Mega|Ride"] = 205.43, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.25, ["Neon|Fly"] = 139.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 45.94, ["Mega|Fly"] = 98.19, ["Mega|Ride"] = 139.97, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 22.97, ["Neon"] = 4.73, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.59, ["Mega|Fly"] = 154.6, ["Mega|Ride"] = 72.18, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.62, ["Ride"] = 131.25, ["Neon"] = 18.5, ["Neon|Ride"] = 70, ["Mega"] = 228.75, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 139.97, ["Ride"] = 315.26, ["Fly|Ride"] = 262.77, ["Neon"] = 446.25, ["Neon|Ride"] = 1566.67, ["Neon|Fly|Ride"] = 417.79, ["Mega"] = 1532.21, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.85, ["Ride"] = 62.68, ["Fly|Ride"] = 139.97, ["Neon"] = 98.41, ["Neon|Ride"] = 206.82, ["Mega"] = 463.74, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.77, ["Fly"] = 15.75, ["Ride"] = 16.43, ["Fly|Ride"] = 35.27, ["Neon"] = 16.72, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 395.85, ["Mega|Ride"] = 139.97, ["Mega|Fly|Ride"] = 188.14}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.79, ["Ride"] = 64.32, ["Fly|Ride"] = 120.43, ["Neon"] = 89.25, ["Neon|Ride"] = 70, ["Mega"] = 205.43, ["Mega|Ride"] = 223.53, ["Mega|Fly|Ride"] = 975.53}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.37, ["Fly"] = 181.75, ["Ride"] = 28.22, ["Fly|Ride"] = 60.61, ["Neon"] = 25.08, ["Neon|Ride"] = 65.51, ["Neon|Fly|Ride"] = 210.15, ["Mega"] = 177.45, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 362.44}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.56, ["Fly"] = 60.23, ["Ride"] = 30.17, ["Fly|Ride"] = 154.88, ["Neon"] = 228.74, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 322.23, ["Mega"] = 938.96, ["Mega|Ride"] = 960.9, ["Mega|Fly|Ride"] = 557.74}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.1, ["Fly"] = 874.13, ["Neon"] = 278.88, ["Mega"] = 417.79, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 43.84, ["Fly"] = 115.5, ["Ride"] = 65.63, ["Fly|Ride"] = 159.06, ["Neon"] = 262.5, ["Neon|Fly"] = 438.68, ["Neon|Ride"] = 311.25, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1665.12, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.5, ["Fly"] = 75.18, ["Ride"] = 99.24, ["Fly|Ride"] = 224.33, ["Neon"] = 131.15, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 527.16, ["Mega|Ride"] = 696.65, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.04, ["Fly"] = 84, ["Ride"] = 78.36, ["Neon"] = 127.32, ["Mega"] = 695.63, ["Mega|Fly|Ride"] = 626.68}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.24, ["Fly"] = 410.34, ["Ride"] = 45.1, ["Fly|Ride"] = 112.18, ["Neon"] = 79.86, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 161.75, ["Mega"] = 457.46, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.72, ["Ride"] = 15.41, ["Fly|Ride"] = 41.78, ["Neon"] = 4.86, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 70, ["Mega"] = 52.86, ["Mega|Fly"] = 208.9, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1734.83}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 33.86, ["Ride"] = 70, ["Fly|Ride"] = 91.88, ["Neon"] = 179.66, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 557.74, ["Mega"] = 618.32, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 54.87, ["Neon"] = 3.82, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 292.45, ["Mega"] = 24.43, ["Mega|Ride"] = 42}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 36.52, ["Ride"] = 68.25, ["Neon"] = 165.3, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 711.38, ["Mega|Ride"] = 720.85, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 4.18, ["Neon|Ride"] = 105, ["Mega"] = 32.06}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Neon|Ride"] = 47.23, ["Mega"] = 38.07, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.88, ["Fly"] = 330.05, ["Ride"] = 127.35, ["Fly|Ride"] = 208.9, ["Neon"] = 458.25, ["Neon|Ride"] = 458.25, ["Neon|Fly|Ride"] = 578.19, ["Mega|Ride"] = 2236, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 6.57, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 90.15, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.92, ["Neon|Fly"] = 62.68, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 31.5, ["Mega|Ride"] = 122.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.51, ["Neon|Ride"] = 40.71, ["Mega"] = 25.7, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.9, ["Neon|Ride"] = 31.88, ["Mega"] = 49.88, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 36.73, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 348.86, ["Neon|Ride"] = 479.25, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1566.67, ["Mega|Ride"] = 1566.67, ["Mega|Fly|Ride"] = 1566.67}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.14, ["Ride"] = 47.24, ["Neon"] = 36.25, ["Neon|Ride"] = 141.68, ["Mega"] = 355.13, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 425.1, ["Fly|Ride"] = 616.88, ["Neon"] = 1669.03, ["Neon|Ride"] = 1670.08, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3483.22}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 74.82}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 40.74}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.17}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.47}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.71}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 10.39}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 240.53}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 40.97}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 158.22}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 16.7}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.11}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 16.21}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.13}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.99}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 507.68}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 799.43}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 16.37}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.51}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.44}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.4}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 52.74}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.38}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.29}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.69}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.57}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.77}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.52}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 157.5}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.5}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 8.36}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.5}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1823.07}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 28.76}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 298.75}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.24}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 13}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 926.1}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 183.74}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 17.73}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.5}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2084.73}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.5}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 8.29}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.62}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 18.18}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.58}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 8.27}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 156.19}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 36.67}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.8}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 18.75}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.5}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 319.61}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 5.88}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 39.38}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 111.57}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 179.94}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 15.63}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 37.62}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 15.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22488.93}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.9}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 33.45}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 174.75}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 91.88}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 60.59}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 104.46}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.25}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 82.07}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 328.21}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.09}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 18.81}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.33}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 82.65}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.12}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.27}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.75}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 2934.11}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.36}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 525}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 31.5}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 52.4}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 98.19}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 154.16}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 70}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 64.32}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 25.93}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.21}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.42}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.8}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.63}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 14.43}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 22.32}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.25}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.52}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 7.88}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 13.13}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 169.17}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 3.84}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1043.41}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.86}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.96}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 9.19}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.94}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 52.5}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 15.63}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.24}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 123.38}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 149.83}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 154.88}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 39.38}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 24.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.94}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 17.73}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.19}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 7.88}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.66}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.52}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 4.18}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 11.5}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.3}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.62}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 32.24}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.46}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.68}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 19.1}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 15.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.04}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.05}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.25}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.68}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 136.49}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 23.63}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.82}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 10.18}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3759.99}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 43.01}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 19.29}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 14.18}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 88.23}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.19}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.56}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.47}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.19}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 22.19}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.8}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 6.17}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.73}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.3}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 4.2}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.22}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 10.48}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.57}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 118.08}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.47}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 36.75}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.8}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 8.36}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.24}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 26.25}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.17}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 30.19}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 47.28}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 24.93}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.94}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 9.19}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.68}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 18.19}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.63}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.44}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 15.19}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 3.84}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 9.19}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.71}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7290.93}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.68}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 52.23}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 4.76}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 6.57}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.94}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 10.28}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 39.8}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.63}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.13}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 100.99}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.91}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 7.06}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 7.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.76}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 8.02}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 27.57}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.88}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 129.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 984.38}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 208.9}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 8.36}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 19.1}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.25}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.62}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.87}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 44.92}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.56}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.29}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.11}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 48.39}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.48}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 61.03}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.52}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 36.1}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 97.12}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.45}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 7.87}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 78.75}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.57}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 122.07}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 459.38}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.77}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 126.87}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.14}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 33.16}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 52.41}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.81}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 17.52}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.28}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 20.85}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.2}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 28.22}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 62.68}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.7}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 157.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1987.58}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.45}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.36}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 36.58}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 4.18}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 387.01}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.99}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.37}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 18.37}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 12.87}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 5.24}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 254.63}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 70}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 24.04}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.49}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 104.46}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 81.9}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 139.97}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.36}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2756.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 380.63}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.29}},
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