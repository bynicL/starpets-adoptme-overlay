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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 742.88, ["Ride"] = 945, ["Fly|Ride"] = 1550.24, ["Neon"] = 6690.49, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25143.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 366.71, ["Fly"] = 544.79, ["Ride"] = 396.38, ["Fly|Ride"] = 471.19, ["Neon|Ride"] = 2218.07, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8309.25}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4935, ["Fly|Ride"] = 4379.82, ["Neon"] = 26066.29, ["Neon|Fly|Ride"] = 21657.2, ["Mega|Fly|Ride"] = 66894.32}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 116.82, ["Ride"] = 143.39, ["Fly|Ride"] = 260.96, ["Neon"] = 839.05, ["Neon|Ride"] = 767.88, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3802.39, ["Mega|Fly|Ride"] = 2866.31}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Fly"] = 662.59, ["Ride"] = 526.01, ["Fly|Ride"] = 539.44, ["Neon|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 1527.75, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.18, ["Ride"] = 35.95, ["Fly|Ride"] = 141.62, ["Neon"] = 52.5, ["Neon|Fly"] = 126.82, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 275.13, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 418.27}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.89, ["Fly"] = 28.88, ["Ride"] = 24.68, ["Fly|Ride"] = 72.5, ["Neon"] = 24.86, ["Neon|Fly"] = 107.47, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 99.3, ["Mega"] = 188.4, ["Mega|Fly"] = 277.1, ["Mega|Ride"] = 168.62, ["Mega|Fly|Ride"] = 277.36}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 124.42, ["Fly"] = 197.63, ["Ride"] = 160.77, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 530.23, ["Neon|Fly|Ride"] = 605.52, ["Mega"] = 1910.88, ["Mega|Fly|Ride"] = 2042.74}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.49, ["Fly"] = 142.44, ["Ride"] = 43.32, ["Fly|Ride"] = 78.75, ["Neon"] = 223.13, ["Neon|Ride"] = 185.07, ["Neon|Fly|Ride"] = 239.77, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 15.74, ["Fly"] = 45.46, ["Ride"] = 27.04, ["Fly|Ride"] = 64.42, ["Neon"] = 139.5, ["Neon|Ride"] = 194.36, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 759.43, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 39.38, ["Fly"] = 287.44, ["Ride"] = 73.8, ["Fly|Ride"] = 120.74, ["Neon"] = 282.17, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 322.47, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 1478.71}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 70.88}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 376.59, ["Fly"] = 387.19, ["Ride"] = 392.44, ["Fly|Ride"] = 525, ["Neon"] = 1282.88, ["Neon|Ride"] = 1433.16, ["Neon|Fly|Ride"] = 2070.91, ["Mega|Fly|Ride"] = 8449.73}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 131.25, ["Ride"] = 112.18, ["Fly|Ride"] = 139.5, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 117.32, ["Ride"] = 24.05, ["Fly|Ride"] = 211.36, ["Neon"] = 24.31, ["Neon|Ride"] = 65.63, ["Mega"] = 118.13, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 157.5, ["Fly"] = 188.11, ["Ride"] = 137.82, ["Fly|Ride"] = 184.38, ["Neon"] = 704.85, ["Neon|Ride"] = 633.74, ["Neon|Fly|Ride"] = 584.07, ["Mega|Fly|Ride"] = 1903}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.49, ["Fly"] = 27.2, ["Ride"] = 19.59, ["Fly|Ride"] = 40.14, ["Neon"] = 27.49, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 65.56, ["Fly"] = 262.5, ["Ride"] = 98.44, ["Fly|Ride"] = 238.84, ["Neon"] = 190.32, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 1405.84, ["Mega|Ride"] = 866.2, ["Mega|Fly|Ride"] = 863.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.54}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 84, ["Ride"] = 118.13, ["Fly|Ride"] = 337.98, ["Neon"] = 830.82, ["Neon|Ride"] = 637.76, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1584.34}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.95, ["Fly"] = 374.07, ["Ride"] = 26.17, ["Fly|Ride"] = 99.36, ["Neon"] = 141.62, ["Neon|Ride"] = 340.54, ["Neon|Fly|Ride"] = 183.79, ["Mega"] = 704.51, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1689.96}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.66, ["Fly"] = 64.3, ["Ride"] = 41.13, ["Fly|Ride"] = 104, ["Neon"] = 336, ["Neon|Fly"] = 314.92, ["Neon|Ride"] = 179.37, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 53.91, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 139.5, ["Neon"] = 236.15, ["Neon|Fly"] = 396.66, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315.82, ["Mega"] = 1245.29, ["Mega|Ride"] = 1263.25, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 40.27, ["Fly"] = 64.53, ["Ride"] = 56.99, ["Fly|Ride"] = 105, ["Neon"] = 183.89, ["Neon|Ride"] = 282.02, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 73.68, ["Fly"] = 587.65, ["Ride"] = 70.82, ["Fly|Ride"] = 131.25, ["Neon"] = 238.96, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 217.88, ["Mega|Ride"] = 796.61, ["Mega|Fly|Ride"] = 825.98}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.22, ["Fly"] = 40.01, ["Ride"] = 19.57, ["Fly|Ride"] = 39.35, ["Neon"] = 28.54, ["Neon|Fly"] = 48.6, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 131.25, ["Mega|Fly"] = 191.09, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 238.95}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 341.25, ["Ride"] = 352.87, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1605.47, ["Neon|Fly|Ride"] = 1620.25, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 6619.32}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.74, ["Ride"] = 28.88, ["Fly|Ride"] = 136.49, ["Neon"] = 236.25, ["Mega"] = 831.25, ["Mega|Ride"] = 716.59, ["Mega|Fly|Ride"] = 827.03}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 2.63, ["Fly"] = 38.67, ["Ride"] = 20.9, ["Fly|Ride"] = 43.32, ["Neon"] = 44.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 99.7, ["Mega|Ride"] = 422.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 100.99, ["Fly"] = 127.86, ["Ride"] = 106.23, ["Fly|Ride"] = 157.5, ["Neon"] = 379.38, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1831.5, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1915.98}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.68, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 139.5, ["Neon|Ride"] = 113.03, ["Neon|Fly|Ride"] = 158.81, ["Mega"] = 716.59, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 357.18, ["Ride"] = 223.79, ["Fly|Ride"] = 269.07, ["Neon"] = 782, ["Neon|Ride"] = 823.87, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6337.31, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.17}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.96}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.29, ["Fly"] = 33.57, ["Ride"] = 21.52, ["Fly|Ride"] = 60.75, ["Neon"] = 19.81, ["Neon|Fly"] = 49.86, ["Neon|Ride"] = 47.7, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 131.23, ["Mega|Fly"] = 285.27, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 352.79}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1181.25, ["Fly"] = 4593.75, ["Ride"] = 1048.69, ["Fly|Ride"] = 1394.89, ["Neon"] = 5917.69, ["Neon|Ride"] = 5381.25, ["Neon|Fly|Ride"] = 4593.75, ["Mega"] = 16899.45, ["Mega|Ride"] = 53742.9, ["Mega|Fly|Ride"] = 18308.43}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.05, ["Fly"] = 28.49, ["Ride"] = 25.87, ["Fly|Ride"] = 87.94, ["Neon"] = 107.37, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 262.5, ["Mega|Ride"] = 621.08, ["Mega|Fly|Ride"] = 662.26}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 93.45, ["Ride"] = 143.89, ["Fly|Ride"] = 261.49, ["Neon"] = 656.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2745.11, ["Mega|Fly|Ride"] = 2745.11}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.49}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 28.5, ["Fly"] = 45.94, ["Ride"] = 55.13, ["Fly|Ride"] = 141.62, ["Neon"] = 97.5, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 748.83}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 124.69, ["Ride"] = 210, ["Fly|Ride"] = 264.06, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Ride"] = 133.62, ["Fly|Ride"] = 236.24, ["Neon"] = 328.02, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 507.01, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 42.95}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 70.88, ["Fly"] = 93.49, ["Ride"] = 59.07, ["Fly|Ride"] = 57.75, ["Neon"] = 359.3, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 4223.82, ["Mega|Fly|Ride"] = 1389.07}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.85, ["Ride"] = 30.19, ["Fly|Ride"] = 85.32, ["Neon"] = 31.85, ["Neon|Ride"] = 70.19, ["Neon|Fly|Ride"] = 235.56, ["Mega"] = 169.01, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 352.79}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 361.57, ["Fly"] = 420, ["Ride"] = 347.82, ["Fly|Ride"] = 352.96, ["Neon|Fly"] = 1409.69, ["Neon|Ride"] = 1801.95, ["Neon|Fly|Ride"] = 1273.58, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 64.97, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 132.57, ["Neon"] = 372.59, ["Neon|Ride"] = 379.2, ["Neon|Fly|Ride"] = 369.02, ["Mega"] = 2816.93, ["Mega|Ride"] = 1887.47, ["Mega|Fly|Ride"] = 1929.72}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3180.19, ["Ride"] = 3433.5, ["Fly|Ride"] = 3017.44, ["Neon|Fly|Ride"] = 14785.97}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 34.12, ["Fly"] = 113.08, ["Ride"] = 45.91, ["Fly|Ride"] = 95.82, ["Neon"] = 282.17, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 380.25, ["Mega"] = 1269.59, ["Mega|Ride"] = 1203.04, ["Mega|Fly|Ride"] = 2253.98}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 65.63, ["Ride"] = 90.9, ["Fly|Ride"] = 183.89, ["Neon"] = 422.7, ["Neon|Ride"] = 792.77, ["Neon|Fly|Ride"] = 564.03, ["Mega"] = 6337.31, ["Mega|Fly|Ride"] = 1825.16}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.75, ["Fly"] = 57.75, ["Ride"] = 67.15, ["Fly|Ride"] = 137.24, ["Neon"] = 237.96, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 222.32, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.56}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 54.74, ["Ride"] = 56.39, ["Fly|Ride"] = 116.52, ["Neon"] = 328.13, ["Neon|Ride"] = 352.79, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 1274.32}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 233.19, ["Fly"] = 311.75, ["Ride"] = 250.69, ["Fly|Ride"] = 338.17, ["Neon|Fly|Ride"] = 1594.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 938.39, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3379.9, ["Neon|Fly|Ride"] = 3661.88, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.91, ["Fly"] = 52.43, ["Ride"] = 45.76, ["Fly|Ride"] = 59.84, ["Neon"] = 162.75, ["Neon|Fly"] = 211.36, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 198.24, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.39}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4331.25, ["Fly"] = 6030.76, ["Ride"] = 6340.38, ["Fly|Ride"] = 4436.25, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 39375}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.38, ["Fly"] = 74.64, ["Ride"] = 26.25, ["Fly|Ride"] = 69.57, ["Neon"] = 84, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 483, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.17, ["Fly"] = 191.66, ["Ride"] = 32.82, ["Fly|Ride"] = 118.3, ["Neon"] = 65.63, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1056.23, ["Mega|Ride"] = 535.52, ["Mega|Fly|Ride"] = 947.44}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 57.75, ["Fly"] = 139.21, ["Ride"] = 94.96, ["Fly|Ride"] = 126.53, ["Neon"] = 1409.69, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4224.87}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.68, ["Ride"] = 32.76, ["Fly|Ride"] = 139.65, ["Neon"] = 60.25, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 366.52, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 493.27}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3100.44, ["Ride"] = 2521.37, ["Fly|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 4592.44, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 28742.98, ["Ride"] = 35047.34, ["Fly|Ride"] = 22916.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197160.46}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.77, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 99.36, ["Neon"] = 282.19, ["Neon|Ride"] = 127.8, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 844.98, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.49, ["Ride"] = 41.89, ["Fly|Ride"] = 105.69, ["Neon"] = 16.94, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 64.51, ["Neon|Fly|Ride"] = 153.59, ["Mega"] = 140.44, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.46}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 61.69, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 415.74, ["Mega|Ride"] = 477.73, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 787.5, ["Ride"] = 754.63, ["Fly|Ride"] = 780.94, ["Neon"] = 3027.45, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2567.25, ["Mega|Fly|Ride"] = 11147.48}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 979.33, ["Fly"] = 900.38, ["Ride"] = 909.33, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3071.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.92, ["Fly"] = 63, ["Ride"] = 53.91, ["Fly|Ride"] = 65.63, ["Neon"] = 141.62, ["Neon|Ride"] = 160.06, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 982.91, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.71}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 59.07, ["Fly"] = 78.75, ["Ride"] = 93.01, ["Fly|Ride"] = 146.9, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1719.54, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.31, ["Ride"] = 84, ["Fly|Ride"] = 131.25, ["Neon"] = 395.24, ["Neon|Fly"] = 392.93, ["Neon|Ride"] = 637.76, ["Neon|Fly|Ride"] = 507.01, ["Mega"] = 1625.53, ["Mega|Fly|Ride"] = 1668.83}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.92, ["Fly"] = 32.78, ["Ride"] = 19.48, ["Fly|Ride"] = 42.29, ["Neon"] = 28.88, ["Neon|Fly"] = 319.01, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 134.15, ["Mega"] = 236.25, ["Mega|Fly"] = 338, ["Mega|Ride"] = 401.38, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 83.21, ["Fly"] = 91.88, ["Ride"] = 87.05, ["Fly|Ride"] = 154.34, ["Neon"] = 815.81, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1030.32}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.89, ["Ride"] = 40.69, ["Fly|Ride"] = 127.85, ["Neon"] = 23.63, ["Neon|Ride"] = 99.12, ["Mega"] = 166.69, ["Mega|Fly"] = 986.52, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.01, ["Fly"] = 40.3, ["Ride"] = 32.82, ["Fly|Ride"] = 105.15, ["Neon"] = 72.19, ["Neon|Fly"] = 105.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 746.76, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.23, ["Ride"] = 69.6, ["Fly|Ride"] = 156.19, ["Neon"] = 215.64, ["Neon|Ride"] = 184.86, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.78, ["Fly"] = 73.45, ["Ride"] = 34.13, ["Fly|Ride"] = 82.69, ["Neon"] = 70.82, ["Neon|Fly"] = 564.03, ["Neon|Ride"] = 121.48, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1056.23, ["Mega|Ride"] = 930.55, ["Mega|Fly|Ride"] = 945.33}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6994.18, ["Ride"] = 6864.38, ["Fly|Ride"] = 5053.13, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 24292.95}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 245.58, ["Fly"] = 295.89, ["Ride"] = 254.28, ["Fly|Ride"] = 294, ["Neon"] = 662.59, ["Neon|Ride"] = 647.13, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.25, ["Fly"] = 70.82, ["Ride"] = 56.44, ["Fly|Ride"] = 112.32, ["Neon"] = 78.22, ["Neon|Fly"] = 160.11, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 315.81, ["Mega|Fly"] = 383.25, ["Mega|Ride"] = 303.18, ["Mega|Fly|Ride"] = 403.17}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.33, ["Fly"] = 42.29, ["Ride"] = 24.26, ["Fly|Ride"] = 90.9, ["Neon"] = 26.25, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 95.55, ["Mega"] = 175.35}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 36.57, ["Fly"] = 5415.83, ["Ride"] = 72.18, ["Fly|Ride"] = 124.71, ["Neon"] = 105, ["Neon|Fly"] = 312.81, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 418.69, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 12468.75, ["Fly|Ride"] = 11140.5, ["Neon|Fly|Ride"] = 23362.5, ["Mega|Fly|Ride"] = 90534.52}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 144.37, ["Ride"] = 201.06, ["Fly|Ride"] = 253.63, ["Neon"] = 1169.81, ["Neon|Ride"] = 1197.76, ["Neon|Fly|Ride"] = 1169.24, ["Mega|Fly|Ride"] = 7165.74}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.16, ["Fly"] = 436.41, ["Ride"] = 60.19, ["Fly|Ride"] = 86.62, ["Neon|Fly"] = 477.9, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 309.41, ["Mega|Fly|Ride"] = 2023.88}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.4, ["Fly"] = 45.41, ["Ride"] = 27.2, ["Fly|Ride"] = 65.54, ["Neon"] = 65.63, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2534.93, ["Mega|Fly|Ride"] = 396.33}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 389.82, ["Fly"] = 845.39, ["Ride"] = 420, ["Fly|Ride"] = 517.99, ["Neon"] = 1521.7, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 33.76, ["Neon"] = 27.56, ["Neon|Ride"] = 78.02, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 140.04, ["Mega|Ride"] = 203.83, ["Mega|Fly|Ride"] = 276.74}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 199.5, ["Fly"] = 393.75, ["Ride"] = 210, ["Fly|Ride"] = 279.49, ["Neon"] = 771.74, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3273.23, ["Mega|Ride"] = 3504.05, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.18, ["Fly"] = 21.15, ["Ride"] = 18.96, ["Fly|Ride"] = 28.02, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 91.9, ["Mega"] = 2534.93, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 70.82, ["Fly|Ride"] = 525, ["Neon"] = 253.63, ["Neon|Fly"] = 1690.78, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 796.61, ["Mega"] = 1406.89, ["Mega|Ride"] = 1433.16, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.18, ["Fly"] = 62.14, ["Ride"] = 36.75, ["Fly|Ride"] = 72.19, ["Neon"] = 96.15, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 480.59, ["Mega|Ride"] = 493.27, ["Mega|Fly|Ride"] = 604.17}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 16.8}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 26.88, ["Fly"] = 111.57, ["Ride"] = 73.5, ["Fly|Ride"] = 223.43, ["Neon"] = 173.15, ["Neon|Ride"] = 223.93, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 704.51, ["Mega|Ride"] = 775.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.89, ["Ride"] = 42.29, ["Fly|Ride"] = 131.25, ["Neon"] = 28.87, ["Neon|Ride"] = 107.5, ["Neon|Fly|Ride"] = 128.87, ["Mega"] = 126.28, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 70.82, ["Ride"] = 30.18, ["Fly|Ride"] = 74.82, ["Neon"] = 28.54, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 226.04, ["Mega"] = 703.45, ["Mega|Ride"] = 452.07, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 347.82, ["Fly"] = 507.25, ["Ride"] = 315, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8872.22}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 41.91, ["Ride"] = 55.44, ["Fly|Ride"] = 103.67, ["Neon"] = 182.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 255.59, ["Mega"] = 724.36, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 759.59}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.85, ["Fly"] = 83.91, ["Ride"] = 52.5, ["Fly|Ride"] = 169.1, ["Neon"] = 160.11, ["Neon|Ride"] = 209.27, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1274.32, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1155.52}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 32.27, ["Fly"] = 61.3, ["Ride"] = 74.8, ["Fly|Ride"] = 105, ["Neon"] = 70.82, ["Neon|Ride"] = 156.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 393.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 13671.46, ["Fly|Ride"] = 7612.5, ["Neon|Fly|Ride"] = 14417.82, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1620.94, ["Fly"] = 2100, ["Ride"] = 1706.25, ["Fly|Ride"] = 1706.25, ["Neon"] = 6212.59, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 23625}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 391.13, ["Ride"] = 464.16, ["Fly|Ride"] = 446.25, ["Neon"] = 2093.6, ["Neon|Fly|Ride"] = 2006.83, ["Mega"] = 11942.87, ["Mega|Fly|Ride"] = 6619.32}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.63, ["Fly"] = 30.56, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 126.82, ["Neon|Ride"] = 105.65, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.13, ["Fly"] = 39.38, ["Ride"] = 41.83, ["Fly|Ride"] = 111.56, ["Neon"] = 34.13, ["Neon|Ride"] = 62.12, ["Mega"] = 154.88, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 28.27, ["Fly"] = 53.55, ["Ride"] = 53.62, ["Fly|Ride"] = 78.75, ["Neon"] = 188.11, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 180.64, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.6, ["Fly"] = 27.2, ["Ride"] = 17.26, ["Fly|Ride"] = 39.37, ["Neon"] = 37, ["Neon|Fly"] = 63.68, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 393.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.51, ["Fly"] = 320.24, ["Ride"] = 313.74, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1791.44, ["Neon|Fly|Ride"] = 1689.96, ["Mega|Fly|Ride"] = 7393.52}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.94, ["Fly"] = 45.77, ["Ride"] = 40.69, ["Fly|Ride"] = 70.82, ["Neon"] = 139.5, ["Neon|Fly"] = 169.1, ["Neon|Ride"] = 138.37, ["Neon|Fly|Ride"] = 221.82, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 633.74}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.71, ["Fly"] = 21.15, ["Ride"] = 18.38, ["Fly|Ride"] = 43.32, ["Neon"] = 141.62, ["Neon|Fly"] = 136.21, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 528.12, ["Mega|Ride"] = 581.99, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 477.9, ["Neon|Ride"] = 2746.17, ["Mega|Fly|Ride"] = 9551.92}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1433.73, ["Ride"] = 1173.24, ["Fly|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17321.94}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 95.6, ["Fly"] = 126.82, ["Ride"] = 97.23, ["Fly|Ride"] = 118.22, ["Neon"] = 971.25, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 150.94, ["Fly"] = 228.21, ["Ride"] = 183.89, ["Fly|Ride"] = 223.13, ["Neon"] = 704.85, ["Neon|Fly"] = 676.32, ["Neon|Ride"] = 704.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 5633.86, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.94, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 282.17, ["Neon"] = 196.88, ["Neon|Fly"] = 422.5, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 366.52, ["Mega|Ride"] = 1831.5, ["Mega|Fly|Ride"] = 903.08}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 141.4, ["Ride"] = 211.36, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1409.27, ["Mega|Fly|Ride"] = 2989.31}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2483.25, ["Fly|Ride"] = 2635.48, ["Neon|Fly|Ride"] = 7180.17, ["Mega|Fly|Ride"] = 48585.9}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 62.27, ["Ride"] = 49.88, ["Fly|Ride"] = 196.88, ["Neon"] = 290.62, ["Neon|Fly"] = 295.89, ["Neon|Fly|Ride"] = 414.75, ["Mega"] = 2106.11, ["Mega|Ride"] = 2323.69, ["Mega|Fly|Ride"] = 1910.88}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.24, ["Fly"] = 675.94, ["Ride"] = 564.38, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1244.24, ["Mega|Fly|Ride"] = 3084.17}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.57, ["Fly"] = 52.5, ["Ride"] = 45.94, ["Fly|Ride"] = 104.85, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 233.63, ["Mega|Fly|Ride"] = 1179.3}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.29, ["Fly"] = 37.73, ["Ride"] = 20.89, ["Fly|Ride"] = 40.36, ["Neon"] = 26.25, ["Neon|Fly"] = 54.96, ["Neon|Ride"] = 45.05, ["Neon|Fly|Ride"] = 93.54, ["Mega"] = 136.5, ["Mega|Fly"] = 251.4, ["Mega|Ride"] = 162.67, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.86, ["Ride"] = 52.5, ["Fly|Ride"] = 137.82, ["Neon"] = 139.5, ["Neon|Ride"] = 262.71, ["Neon|Fly|Ride"] = 535.52, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 518.44, ["Fly"] = 899.07, ["Ride"] = 505.31, ["Fly|Ride"] = 616.45, ["Neon"] = 2113.48, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 6075.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 498.75, ["Ride"] = 577.5, ["Fly|Ride"] = 691.11, ["Neon"] = 5283.65, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12739.48}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 18.8, ["Fly"] = 26.17, ["Ride"] = 23.39, ["Fly|Ride"] = 46.76, ["Neon"] = 211.36, ["Neon|Ride"] = 101.41, ["Neon|Fly|Ride"] = 99.3, ["Mega|Fly|Ride"] = 637.76}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.27, ["Ride"] = 22.32, ["Fly|Ride"] = 53.17, ["Neon"] = 45.93, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 1687.84, ["Mega|Ride"] = 446.8, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.89, ["Ride"] = 38.26, ["Fly|Ride"] = 110.25, ["Neon"] = 19.66, ["Neon|Fly"] = 314.9, ["Neon|Ride"] = 64.32, ["Mega"] = 191.09, ["Mega|Fly"] = 447.57, ["Mega|Ride"] = 197.53, ["Mega|Fly|Ride"] = 324.28}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 45.94, ["Fly"] = 64.24, ["Ride"] = 42, ["Fly|Ride"] = 90.45, ["Neon"] = 238.96, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 178.5, ["Mega|Fly|Ride"] = 901.59}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.3, ["Ride"] = 111.57, ["Fly|Ride"] = 1056.75, ["Neon"] = 268.43, ["Neon|Ride"] = 408.77, ["Neon|Fly|Ride"] = 318.89, ["Mega"] = 1549.49, ["Mega|Ride"] = 1549.49, ["Mega|Fly|Ride"] = 1274.32}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 31.47, ["Fly|Ride"] = 72.19, ["Neon"] = 110.92, ["Neon|Ride"] = 108.89, ["Neon|Fly|Ride"] = 196.77, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 618.96}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.15, ["Fly"] = 65.05, ["Ride"] = 45.94, ["Fly|Ride"] = 89.18, ["Neon"] = 210, ["Neon|Ride"] = 195.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1194.3}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 31.49, ["Ride"] = 18.11, ["Fly|Ride"] = 39.38, ["Neon"] = 28.62, ["Neon|Ride"] = 37.72, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 380.25}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.92, ["Fly"] = 26.25, ["Ride"] = 25.62, ["Fly|Ride"] = 68.11, ["Neon"] = 26.17, ["Neon|Fly"] = 160.06, ["Neon|Ride"] = 40.06, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 251.4, ["Mega|Fly"] = 479.53, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 493.27}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.5, ["Fly"] = 60.38, ["Ride"] = 55.74, ["Fly|Ride"] = 78.75, ["Neon"] = 236.25, ["Neon|Ride"] = 263.95, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 918.88}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1968.75, ["Fly"] = 2100, ["Ride"] = 1745.63, ["Fly|Ride"] = 1798.13, ["Neon"] = 3281.25, ["Neon|Ride"] = 5280.03, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 14083.58}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 456.75, ["Fly"] = 704.85, ["Ride"] = 446.25, ["Fly|Ride"] = 590.63, ["Neon"] = 3186.35, ["Neon|Ride"] = 2253.98, ["Neon|Fly|Ride"] = 2253.98, ["Mega|Fly|Ride"] = 9702.4}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 247.89, ["Fly"] = 422.7, ["Ride"] = 272.99, ["Fly|Ride"] = 392.44, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1548.42, ["Mega"] = 7393.52, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.72, ["Fly"] = 65.63, ["Ride"] = 74.7, ["Fly|Ride"] = 112.88, ["Neon"] = 206.07, ["Neon|Ride"] = 352.14, ["Neon|Fly|Ride"] = 316.88, ["Mega|Ride"] = 840.77, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33815.28, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 14240.63, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 367.5, ["Fly"] = 420, ["Ride"] = 367.5, ["Fly|Ride"] = 503.53, ["Neon"] = 1195.69, ["Neon|Fly"] = 1624.85, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 6337.31, ["Mega|Ride"] = 6688.01, ["Mega|Fly|Ride"] = 4034.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 127.86, ["Fly"] = 141.62, ["Ride"] = 136.49, ["Fly|Ride"] = 143.39, ["Neon|Ride"] = 1028.76, ["Neon|Fly|Ride"] = 1056.23, ["Mega|Fly|Ride"] = 4224.87}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 90.96, ["Fly"] = 257.25, ["Ride"] = 122.07, ["Fly|Ride"] = 206.07, ["Neon"] = 714.47, ["Neon|Ride"] = 844.98, ["Neon|Fly|Ride"] = 802.74, ["Mega"] = 14083.58, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 16.89, ["Fly"] = 66.6, ["Ride"] = 32.27, ["Fly|Ride"] = 111.57, ["Neon"] = 266.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 264.31, ["Mega"] = 704.51}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5249, ["Ride"] = 4741.55, ["Fly|Ride"] = 4856.25, ["Neon|Ride"] = 16899.45, ["Neon|Fly|Ride"] = 17603.95, ["Mega|Fly|Ride"] = 71822.62}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.99, ["Fly"] = 35.44, ["Ride"] = 32.82, ["Fly|Ride"] = 49.88, ["Neon"] = 333.94, ["Neon|Ride"] = 210.2, ["Neon|Fly|Ride"] = 116.82, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37, ["Fly"] = 141.62, ["Ride"] = 44.01, ["Fly|Ride"] = 60.38, ["Neon|Fly"] = 1409.69, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 219.72, ["Mega"] = 1593.2, ["Mega|Fly|Ride"] = 1084.74}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.38, ["Fly"] = 603.75, ["Ride"] = 628.69, ["Fly|Ride"] = 656.24, ["Neon"] = 1706.25, ["Neon|Ride"] = 1681.32, ["Neon|Fly|Ride"] = 1462.13, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.69, ["Fly"] = 28.29, ["Ride"] = 28.88, ["Fly|Ride"] = 52.43, ["Neon"] = 98.44, ["Neon|Fly"] = 160.06, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 122.19, ["Mega"] = 775.27, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 17.07, ["Ride"] = 31.5, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 417.22, ["Mega|Ride"] = 573.27}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.77, ["Ride"] = 126.82, ["Fly|Ride"] = 245.44, ["Neon"] = 676.32, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 704.51, ["Mega|Fly|Ride"] = 2815.88}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 21, ["Fly"] = 106.21, ["Ride"] = 72.19, ["Fly|Ride"] = 152.38, ["Neon"] = 87.71, ["Neon|Fly"] = 319.01, ["Neon|Ride"] = 120.42, ["Neon|Fly|Ride"] = 241.2, ["Mega"] = 292.68, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 331.31, ["Mega|Fly|Ride"] = 499.53}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3478.13, ["Fly"] = 5176.92, ["Ride"] = 3583.12, ["Fly|Ride"] = 3353.44, ["Neon|Ride"] = 10987.45, ["Neon|Fly|Ride"] = 8373.75, ["Mega"] = 63372.89, ["Mega|Fly|Ride"] = 33096.51}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 41.98, ["Fly"] = 115.5, ["Ride"] = 72.19, ["Fly|Ride"] = 162.75, ["Neon"] = 282.17, ["Neon|Ride"] = 211.26, ["Neon|Fly|Ride"] = 418.01, ["Mega|Ride"] = 886.18, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6168.75, ["Fly"] = 7467.9, ["Ride"] = 7733.15, ["Fly|Ride"] = 6229.13, ["Neon|Fly|Ride"] = 17603.95, ["Mega|Fly|Ride"] = 63372.89}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.47, ["Fly"] = 20.06, ["Ride"] = 19.57, ["Fly|Ride"] = 32.82, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.96, ["Mega"] = 324.28, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 16.9, ["Fly"] = 26.25, ["Ride"] = 28.44, ["Fly|Ride"] = 48.56, ["Neon"] = 211.36, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 141.56, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.83}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.46, ["Ride"] = 39.38, ["Fly|Ride"] = 83.89, ["Neon"] = 158.49, ["Neon|Ride"] = 138.37, ["Mega"] = 1049.9, ["Mega|Ride"] = 984.41, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 262.5, ["Ride"] = 34.13, ["Fly|Ride"] = 141.62, ["Neon"] = 156.41, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 280.97, ["Mega"] = 840, ["Mega|Ride"] = 955.44, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.44, ["Fly"] = 26.17, ["Ride"] = 22.2, ["Fly|Ride"] = 34.91, ["Neon"] = 141.62, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 163.73, ["Mega"] = 2532.81, ["Mega|Ride"] = 595.96, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8398.31}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.69}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.54, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 183.89, ["Neon|Fly|Ride"] = 1126.99, ["Mega|Fly|Ride"] = 5573.74}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.32, ["Fly"] = 133.17, ["Ride"] = 39.38, ["Fly|Ride"] = 319.01, ["Neon"] = 103.72, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 264.07, ["Mega"] = 915.75, ["Mega|Ride"] = 907.68, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.4, ["Ride"] = 26.25, ["Neon|Ride"] = 70.79, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 186.35, ["Ride"] = 172.06, ["Fly|Ride"] = 430.12, ["Neon"] = 567, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3507.7, ["Mega|Fly|Ride"] = 3492.92}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 127.32, ["Ride"] = 174.57, ["Fly|Ride"] = 211.36, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 775.27, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.19, ["Fly"] = 211.36, ["Ride"] = 157.5, ["Fly|Ride"] = 210, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4647.37, ["Mega|Fly|Ride"] = 3493.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1506.75, ["Fly"] = 2536.15, ["Ride"] = 1089.37, ["Fly|Ride"] = 1296.67, ["Neon"] = 5354.45, ["Neon|Ride"] = 4856.25, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 26194.13}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.07, ["Fly"] = 82.1, ["Ride"] = 32.82, ["Fly|Ride"] = 86.63, ["Neon"] = 127.29, ["Neon|Ride"] = 300.98, ["Neon|Fly|Ride"] = 318.89, ["Mega"] = 843.93, ["Mega|Fly|Ride"] = 958}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 633.05, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 829.15, ["Neon|Fly|Ride"] = 2957.41}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 60.38}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.97, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 99.75, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.62, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 874.22}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.46, ["Fly"] = 131.25, ["Ride"] = 28.54, ["Fly|Ride"] = 94.5, ["Neon"] = 57.07, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 238.72, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 81.38}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 28.23, ["Fly|Ride"] = 70.82, ["Neon"] = 196.88, ["Neon|Ride"] = 158.45, ["Neon|Fly|Ride"] = 557.74, ["Mega"] = 818.58, ["Mega|Fly|Ride"] = 1445.75}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.09, ["Fly"] = 56.17, ["Ride"] = 31.17, ["Fly|Ride"] = 61.69, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6103.13, ["Fly"] = 11272.12, ["Ride"] = 5495.44, ["Fly|Ride"] = 4803.75, ["Neon|Ride"] = 17603.95, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.08, ["Fly"] = 34.13, ["Ride"] = 26.25, ["Fly|Ride"] = 82.69, ["Neon"] = 65.63, ["Neon|Ride"] = 99.3, ["Neon|Fly|Ride"] = 352.79, ["Mega"] = 535.05, ["Mega|Ride"] = 438.35, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 108.94, ["Fly"] = 374.09, ["Ride"] = 157.73, ["Fly|Ride"] = 211.36, ["Neon"] = 418.69, ["Neon|Ride"] = 477.73, ["Neon|Fly|Ride"] = 564.03, ["Mega|Ride"] = 4224.87, ["Mega|Fly|Ride"] = 2086.04}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 70.61, ["Ride"] = 90.57, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2851.79}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.76, ["Fly"] = 72.19, ["Ride"] = 28.3, ["Fly|Ride"] = 61.69, ["Neon"] = 196.88, ["Neon|Ride"] = 140.34, ["Neon|Fly|Ride"] = 190.73, ["Mega|Ride"] = 876.62, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 49.76, ["Ride"] = 32.27, ["Fly|Ride"] = 78.75, ["Neon"] = 23.61, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 165.37, ["Mega"] = 124.56, ["Mega|Fly"] = 7041.8, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.44, ["Fly"] = 70.88, ["Ride"] = 31.49, ["Fly|Ride"] = 52.5, ["Neon"] = 91.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 180.63, ["Mega"] = 380.25, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.69, ["Fly"] = 28.54, ["Ride"] = 24.94, ["Fly|Ride"] = 52.49, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 134.15, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.57}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 15.84, ["Ride"] = 111.57, ["Fly|Ride"] = 127.85, ["Neon"] = 189.67, ["Neon|Ride"] = 422.5, ["Mega"] = 1056.23, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1687.84}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 118.13, ["Ride"] = 140.44, ["Fly|Ride"] = 262.5, ["Neon"] = 564.31, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 33.78, ["Fly"] = 212.01, ["Ride"] = 103.69, ["Fly|Ride"] = 143.39, ["Neon"] = 314.92, ["Neon|Ride"] = 395.05, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1161.85, ["Mega|Ride"] = 2205.86, ["Mega|Fly|Ride"] = 1097.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 748.13, ["Ride"] = 727.13, ["Fly|Ride"] = 783.57, ["Neon|Fly"] = 2867.37, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.23, ["Mega|Ride"] = 8449.73, ["Mega|Fly|Ride"] = 9450}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 259.88, ["Ride"] = 282.17, ["Fly|Ride"] = 341.25, ["Neon"] = 1181.25, ["Neon|Ride"] = 1664.85, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 8309.25, ["Mega|Fly|Ride"] = 8264.48}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.63, ["Fly"] = 31.5, ["Ride"] = 26.21, ["Fly|Ride"] = 56.44, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 113.03, ["Mega"] = 591.49, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 315, ["Fly"] = 986.99, ["Ride"] = 353.07, ["Fly|Ride"] = 431.82, ["Neon"] = 969.52, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4156.22}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.84}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 125.46, ["Fly"] = 590.63, ["Ride"] = 193.71, ["Fly|Ride"] = 259.88, ["Neon"] = 630.67, ["Neon|Fly"] = 1690.78, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 2957.41, ["Mega|Ride"] = 2014.22, ["Mega|Fly|Ride"] = 1806.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 170.63, ["Fly|Ride"] = 291.38, ["Neon|Ride"] = 991.8}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.6, ["Ride"] = 28.54, ["Fly|Ride"] = 211.36, ["Neon"] = 42.29, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 214.39, ["Mega|Ride"] = 327.26, ["Mega|Fly|Ride"] = 420.39}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 18.27, ["Fly"] = 78.95, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 631.63, ["Mega|Fly|Ride"] = 574.6}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.98, ["Fly"] = 131.25, ["Ride"] = 61.82, ["Fly|Ride"] = 141.39, ["Neon"] = 99.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 418.78, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1017.19}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.35, ["Fly"] = 262.5, ["Ride"] = 32.27, ["Fly|Ride"] = 111.18, ["Neon"] = 21, ["Neon|Ride"] = 59.16, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 138.18, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Fly"] = 332.89, ["Ride"] = 301.88, ["Fly|Ride"] = 377.64, ["Neon"] = 1550.24, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42, ["Mega|Fly|Ride"] = 5112.1}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 96.03, ["Fly"] = 1050, ["Ride"] = 164.07, ["Fly|Ride"] = 253.25, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 1845.22, ["Mega|Ride"] = 1860.01, ["Mega|Fly|Ride"] = 1685.79}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 82.69, ["Fly"] = 167.45, ["Ride"] = 102.24, ["Fly|Ride"] = 128.63, ["Neon"] = 328.13, ["Neon|Ride"] = 403.49, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1813.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.48, ["Ride"] = 58.24, ["Fly|Ride"] = 282.17, ["Neon|Ride"] = 606.72, ["Neon|Fly|Ride"] = 490.1, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 17.98, ["Fly"] = 75.62, ["Ride"] = 30.65, ["Fly|Ride"] = 102.38, ["Neon"] = 91.88, ["Neon|Ride"] = 113.03, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 450.19, ["Mega|Fly"] = 525, ["Mega|Ride"] = 560.87, ["Mega|Fly|Ride"] = 418.95}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 19.67, ["Ride"] = 21, ["Fly|Ride"] = 56.44, ["Neon"] = 19.03, ["Neon|Ride"] = 48.6, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 112.92, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 274.63}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1023.74, ["Fly"] = 971.25, ["Ride"] = 938.44, ["Fly|Ride"] = 958.13, ["Neon"] = 3007.12, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2493.73, ["Mega|Fly|Ride"] = 9443.44}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 392.44, ["Ride"] = 431.7, ["Fly|Ride"] = 472.5, ["Neon"] = 1702.4, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 5573.74}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Ride"] = 135.28, ["Fly|Ride"] = 161.44, ["Neon"] = 282.19, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 348.87, ["Mega|Ride"] = 1423.79, ["Mega|Fly|Ride"] = 1436.47}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 275.63, ["Fly"] = 338.17, ["Ride"] = 299.25, ["Fly|Ride"] = 311.75, ["Neon|Ride"] = 1296, ["Neon|Fly|Ride"] = 1317.11, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.69, ["Fly"] = 141.62, ["Ride"] = 35.79, ["Fly|Ride"] = 84.21, ["Neon"] = 157.49, ["Neon|Ride"] = 132.58, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 1409.01, ["Mega|Ride"] = 796.61, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 258.93, ["Fly|Ride"] = 315.98, ["Neon"] = 1584.98, ["Neon|Ride"] = 1688.91, ["Neon|Fly|Ride"] = 2428.26, ["Mega"] = 4166.26, ["Mega|Fly|Ride"] = 4213.08}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 55.13, ["Fly"] = 126, ["Ride"] = 63, ["Fly|Ride"] = 106.42, ["Neon"] = 523.09, ["Neon|Ride"] = 504.89, ["Neon|Fly|Ride"] = 564.03, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1354.85, ["Fly|Ride"] = 1640.63, ["Neon"] = 5354.45, ["Neon|Fly|Ride"] = 7323.81, ["Mega"] = 50698.32, ["Mega|Fly|Ride"] = 24504.19}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.5, ["Fly"] = 81.81, ["Ride"] = 30.81, ["Fly|Ride"] = 85.32, ["Neon"] = 60.29, ["Neon|Fly"] = 169.1, ["Neon|Ride"] = 63.39, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 253.32, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.88, ["Fly"] = 78.75, ["Ride"] = 68.11, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 548.19, ["Mega"] = 945.33, ["Mega|Ride"] = 1148.13, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 71.46, ["Fly"] = 91.88, ["Ride"] = 68.25, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2110.14, ["Ride"] = 1049.99, ["Fly|Ride"] = 1113, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 843.28, ["Ride"] = 315, ["Fly|Ride"] = 704.85, ["Neon|Fly|Ride"] = 2787.47, ["Mega|Fly|Ride"] = 14331.45}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 95.47, ["Fly"] = 139.5, ["Ride"] = 131.25, ["Fly|Ride"] = 213.64, ["Neon"] = 446.8, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 511.5, ["Mega"] = 4224.87, ["Mega|Ride"] = 2676.47, ["Mega|Fly|Ride"] = 1752.03}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.24, ["Fly"] = 39.38, ["Ride"] = 21.08, ["Fly|Ride"] = 61.69, ["Neon"] = 87.94, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 179.58, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1026.66}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.97, ["Fly"] = 84.56, ["Ride"] = 47.12, ["Fly|Ride"] = 94.4, ["Neon"] = 190.22, ["Neon|Fly"] = 421.64, ["Neon|Ride"] = 224.55, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 1831.5, ["Mega|Ride"] = 1083.24, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 745.5, ["Ride"] = 874.13, ["Fly|Ride"] = 941.96, ["Neon"] = 2818.3, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 20613.39}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 892.91}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 4608.19, ["Fly|Ride"] = 3911.25, ["Neon|Ride"] = 30272.19, ["Neon|Fly|Ride"] = 21406.31, ["Mega|Fly|Ride"] = 90131.05}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 143.38, ["Fly"] = 276.17, ["Ride"] = 223.43, ["Neon"] = 1690.78, ["Neon|Ride"] = 1161.85, ["Neon|Fly|Ride"] = 1409.01, ["Mega"] = 5914.81, ["Mega|Fly|Ride"] = 6056.34}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 81.38, ["Fly"] = 282.17, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 984.84, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 986.52, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 9.19, ["Fly"] = 56.85, ["Ride"] = 26.13, ["Fly|Ride"] = 105, ["Neon"] = 102.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 703.45, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.73, ["Fly"] = 32.19, ["Ride"] = 28.51, ["Fly|Ride"] = 41.24, ["Neon|Ride"] = 197.53, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 839.7}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.42, ["Fly"] = 131.25, ["Ride"] = 47.8, ["Fly|Ride"] = 71.59, ["Neon"] = 126, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 561.92, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 57.07, ["Ride"] = 22.32, ["Fly|Ride"] = 39.29, ["Neon"] = 37, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 223.93, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.75, ["Ride"] = 94.4, ["Fly|Ride"] = 183.75, ["Neon"] = 164.87, ["Neon|Fly"] = 844.98, ["Neon|Ride"] = 160.06, ["Neon|Fly|Ride"] = 249.29, ["Mega"] = 697.11, ["Mega|Ride"] = 704.51}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 301.1, ["Fly"] = 355.69, ["Ride"] = 288.75, ["Fly|Ride"] = 350.43, ["Neon"] = 1433.69, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 902.77, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3504.05}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.51, ["Fly"] = 22.97, ["Ride"] = 16.93, ["Fly|Ride"] = 36.75, ["Neon"] = 26.3, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 210.2, ["Mega|Ride"] = 197.53, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.6, ["Fly"] = 70.82, ["Ride"] = 67.52, ["Fly|Ride"] = 114.12, ["Neon"] = 157.5, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 190.09, ["Neon|Fly|Ride"] = 254.87, ["Mega"] = 393.75, ["Mega|Fly"] = 844.98, ["Mega|Ride"] = 547.31, ["Mega|Fly|Ride"] = 570.66}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 702.19, ["Fly"] = 955.82, ["Ride"] = 763.23, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1526.47, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.54, ["Fly"] = 91.88, ["Ride"] = 47.2, ["Fly|Ride"] = 91.88, ["Neon|Fly"] = 477.9, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 248.37, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 602.43}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 229.69, ["Fly"] = 342.44, ["Ride"] = 242.71, ["Fly|Ride"] = 279.49, ["Neon"] = 1246.96, ["Neon|Ride"] = 958, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 162.75, ["Fly"] = 202.44, ["Ride"] = 138.56, ["Fly|Ride"] = 170.62, ["Neon"] = 634.06, ["Neon|Fly"] = 642.51, ["Neon|Ride"] = 527.07, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2233.76}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 615.75, ["Fly|Ride"] = 633.59, ["Neon|Fly|Ride"] = 2086.04, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.26, ["Ride"] = 45.94, ["Fly|Ride"] = 156.41, ["Neon"] = 63.27, ["Neon|Fly"] = 286.76, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 354.38, ["Mega|Ride"] = 422.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4048.89, ["Fly"] = 3909.91, ["Ride"] = 3936.19, ["Fly|Ride"] = 3143.43, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 71.46, ["Fly"] = 107.81, ["Ride"] = 90.9, ["Fly|Ride"] = 157.5, ["Neon"] = 460.69, ["Neon|Ride"] = 331.66, ["Neon|Fly|Ride"] = 422.5, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 33.75, ["Ride"] = 19.69, ["Fly|Ride"] = 84, ["Neon"] = 21, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 88.39, ["Mega"] = 139.1, ["Mega|Fly"] = 253.52, ["Mega|Ride"] = 222.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.92, ["Ride"] = 28.28, ["Fly|Ride"] = 63, ["Neon"] = 27.49, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.43, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 53.72, ["Fly"] = 82.85, ["Ride"] = 42, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 211.26, ["Neon|Fly|Ride"] = 291.41, ["Mega|Fly|Ride"] = 1394.22}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1122.59, ["Ride"] = 1174.69, ["Fly|Ride"] = 1295.44, ["Neon"] = 5706.35, ["Neon|Fly|Ride"] = 5275.8, ["Mega|Fly|Ride"] = 22533.3}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4725, ["Ride"] = 5973.64, ["Fly|Ride"] = 4331.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.92, ["Fly"] = 26.25, ["Ride"] = 28.33, ["Fly|Ride"] = 36.75, ["Neon"] = 104.63, ["Neon|Ride"] = 69.74, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 507.01}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.58, ["Fly"] = 47.8, ["Ride"] = 32.71, ["Fly|Ride"] = 59.07, ["Neon"] = 94.5, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 87.64, ["Neon|Fly|Ride"] = 175.61, ["Mega"] = 933.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 52.5, ["Fly"] = 157.49, ["Ride"] = 49.79, ["Fly|Ride"] = 72.19, ["Neon"] = 271.24, ["Neon|Ride"] = 282.02, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 1409.01, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.31, ["Fly"] = 319.02, ["Ride"] = 229.69, ["Fly|Ride"] = 258.98, ["Neon"] = 986.99, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.67, ["Ride"] = 32.65, ["Fly|Ride"] = 86.63, ["Neon"] = 27.24, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 248.42, ["Mega"] = 154.88, ["Mega|Ride"] = 253.52, ["Mega|Fly|Ride"] = 366.66}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 186.87, ["Fly"] = 238.96, ["Ride"] = 223.13, ["Fly|Ride"] = 312.81, ["Neon"] = 704.85, ["Neon|Ride"] = 826.18, ["Neon|Fly|Ride"] = 823.87, ["Mega|Fly|Ride"] = 3944.97}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.43, ["Fly"] = 24.12, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 210, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.65}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.77, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1313.73, ["Neon|Fly|Ride"] = 895.73, ["Mega"] = 10562.15, ["Mega|Ride"] = 6337.31, ["Mega|Fly|Ride"] = 7762.89}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.01, ["Fly"] = 26.25, ["Ride"] = 31.71, ["Fly|Ride"] = 63.41, ["Neon"] = 84.56, ["Neon|Fly"] = 303.48, ["Neon|Ride"] = 100.35, ["Neon|Fly|Ride"] = 275.42, ["Mega"] = 522.41, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.94, ["Ride"] = 19.69, ["Neon"] = 12.68, ["Neon|Fly"] = 66, ["Neon|Ride"] = 63.39, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 76.38, ["Mega|Ride"] = 104.26, ["Mega|Fly|Ride"] = 235.52}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.07, ["Neon|Ride"] = 70.79, ["Mega"] = 23, ["Mega|Ride"] = 156.33}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.71, ["Ride"] = 33.84, ["Fly|Ride"] = 141.27, ["Neon"] = 7.25, ["Neon|Ride"] = 50.66, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 103.98, ["Mega|Fly"] = 159238.98, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.92, ["Fly"] = 139.5, ["Ride"] = 111.57, ["Fly|Ride"] = 176.84, ["Neon"] = 266.32, ["Neon|Fly"] = 263.06, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1133.08}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.89, ["Fly|Ride"] = 43.32, ["Neon"] = 12.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.1, ["Mega|Ride"] = 99.3, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.31, ["Ride"] = 111.09, ["Fly|Ride"] = 196.56, ["Neon"] = 74.82, ["Neon|Ride"] = 127.8, ["Mega"] = 485.63, ["Mega|Ride"] = 523.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 17.07, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 15.69, ["Ride"] = 17.94, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 35.86, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 30.31, ["Mega"] = 15.36, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 25.36, ["Mega|Fly|Ride"] = 57.05}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.71, ["Neon"] = 3.67, ["Neon|Fly"] = 15.44, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 28.03, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 78.72}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 2.61, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 30.19, ["Mega|Ride"] = 146.96, ["Mega|Fly|Ride"] = 306.32}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 19.69, ["Fly|Ride"] = 105.52, ["Neon"] = 3.62, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 86.01, ["Mega"] = 41.5, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 166.9}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 6.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 27.38, ["Mega|Ride"] = 82.68}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 32.82, ["Fly|Ride"] = 47.42, ["Neon"] = 5.72, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 71.68, ["Mega"] = 52.39, ["Mega|Fly"] = 198.27, ["Mega|Ride"] = 84.45, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.25, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 17.05, ["Mega|Ride"] = 44.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 47.16, ["Mega"] = 209.14, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 13.27, ["Mega"] = 105, ["Mega|Fly|Ride"] = 380.25}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 24.86, ["Mega|Ride"] = 60.8, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.84, ["Fly|Ride"] = 28.6, ["Neon"] = 2.1, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 17.47, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 16.79, ["Mega|Fly"] = 53.89, ["Mega|Ride"] = 26.6, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.84, ["Fly"] = 72.19, ["Ride"] = 210, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.82, ["Mega"] = 253.52, ["Mega|Fly"] = 282.02, ["Mega|Ride"] = 274.55}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 42, ["Fly|Ride"] = 78.74, ["Neon"] = 5.92, ["Neon|Ride"] = 34.63, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.13, ["Mega|Ride"] = 51.18, ["Mega|Fly|Ride"] = 142.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 8.46, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 84.51, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.37, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 192.34, ["Neon"] = 117.17, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 92.63, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.48, ["Ride"] = 12.73, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 13.83, ["Neon|Ride"] = 15.81, ["Neon|Fly|Ride"] = 34.35, ["Mega"] = 19.69, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 31.7, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 18.69, ["Fly|Ride"] = 72.19, ["Neon"] = 15.65, ["Neon|Ride"] = 114.66, ["Neon|Fly|Ride"] = 75.01, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Fly|Ride"] = 141.62, ["Neon"] = 90.9, ["Neon|Ride"] = 113.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.2, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 14.49, ["Ride"] = 17.94, ["Fly|Ride"] = 26.17, ["Neon"] = 3.94, ["Neon|Fly"] = 19.22, ["Neon|Ride"] = 19.13, ["Neon|Fly|Ride"] = 49.66, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 125.09}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 176.49, ["Neon"] = 12.68, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 122.54, ["Mega|Fly"] = 169.01, ["Mega|Ride"] = 88.39}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 32.82, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 46.51, ["Neon"] = 2.1, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 15.74, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 124.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 99.12, ["Ride"] = 16.27, ["Fly|Ride"] = 47.8, ["Neon"] = 6.33, ["Neon|Fly"] = 45.1, ["Neon|Ride"] = 27.48, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 60.29, ["Mega|Ride"] = 91.02, ["Mega|Fly|Ride"] = 269.35}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.25, ["Neon"] = 6.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 90.85, ["Mega|Ride"] = 167.22, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.05, ["Fly"] = 32.48, ["Ride"] = 15.69, ["Fly|Ride"] = 140.38, ["Neon"] = 8.39, ["Neon|Fly"] = 108.5, ["Neon|Ride"] = 24.3, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.52, ["Ride"] = 82.69, ["Neon"] = 27.46, ["Mega"] = 282.02, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 5495.77, ["Neon"] = 10.5, ["Neon|Fly"] = 141.56, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 257.73, ["Mega|Ride"] = 133.1, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 29.64, ["Fly|Ride"] = 141.62, ["Neon"] = 35.44, ["Neon|Fly"] = 62.36, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 111.04, ["Mega"] = 196.88, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 23.05, ["Neon|Ride"] = 160.06, ["Mega"] = 200.16, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.12, ["Ride"] = 78.22, ["Neon"] = 141.62, ["Neon|Ride"] = 238.88, ["Mega"] = 656.25, ["Mega|Ride"] = 883, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 56.6, ["Neon"] = 87.26, ["Neon|Ride"] = 39.38, ["Mega"] = 318.89, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.94, ["Ride"] = 42.55, ["Neon"] = 87.94, ["Neon|Ride"] = 71.68, ["Mega"] = 477.73, ["Mega|Ride"] = 255.29, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 92.29, ["Mega"] = 21, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.92, ["Fly"] = 27.04, ["Ride"] = 20.9, ["Fly|Ride"] = 41.99, ["Neon"] = 52.38, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 97.19, ["Mega"] = 275.63, ["Mega|Ride"] = 401.38, ["Mega|Fly|Ride"] = 247.17}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 18.36, ["Fly|Ride"] = 740.75, ["Neon"] = 3.92, ["Neon|Ride"] = 28.25, ["Mega"] = 18.36, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 45.46, ["Fly|Ride"] = 140.28, ["Neon"] = 5.16, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 159.33, ["Mega"] = 51.19, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.69, ["Fly|Ride"] = 78.22, ["Neon"] = 18.4, ["Neon|Ride"] = 45.28, ["Neon|Fly|Ride"] = 78.11, ["Mega"] = 148.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.5, ["Ride"] = 99.36, ["Neon"] = 40.69, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 154.85, ["Mega"] = 328.13, ["Mega|Ride"] = 276.74, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 49.66, ["Neon|Fly|Ride"] = 80.04, ["Mega"] = 26.24, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 17.07, ["Fly|Ride"] = 281794.16, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 30.19, ["Mega|Fly"] = 203.04, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 140.95}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.05, ["Fly"] = 15.53, ["Ride"] = 18.38, ["Fly|Ride"] = 31.29, ["Neon"] = 5.16, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 47.25, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 31.05, ["Fly|Ride"] = 78.87, ["Neon"] = 3.46, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 21.91, ["Mega|Fly"] = 99.3, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 113.03}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 5.12, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 166.9, ["Mega"] = 18.35, ["Mega|Fly"] = 146.83, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 168.92}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.57, ["Fly|Ride"] = 77.44, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 35.94, ["Mega|Ride"] = 50.67, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 15.74, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 160.06, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.62, ["Mega|Fly"] = 119.44, ["Mega|Ride"] = 113.03, ["Mega|Fly|Ride"] = 342.23}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 24.76, ["Fly|Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 78.75, ["Mega|Ride"] = 62.33, ["Mega|Fly|Ride"] = 151.7}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.71, ["Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 238.88, ["Mega"] = 395.33, ["Mega|Ride"] = 422.5, ["Mega|Fly|Ride"] = 945.33}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 39.11, ["Neon"] = 41.18, ["Mega"] = 209.14, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 25.38, ["Fly|Ride"] = 422.7, ["Neon"] = 28.54, ["Mega"] = 127.8, ["Mega|Ride"] = 189.08, ["Mega|Fly|Ride"] = 296.87}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 11.22, ["Fly|Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Fly"] = 17.03, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 15.49, ["Mega|Fly"] = 27.56, ["Mega|Ride"] = 24.3, ["Mega|Fly|Ride"] = 45.93}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Fly|Ride"] = 70.82, ["Neon"] = 4.87, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 704.51, ["Mega"] = 66.55, ["Mega|Ride"] = 141.56}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.15, ["Mega"] = 18.25, ["Mega|Fly"] = 78.17, ["Mega|Ride"] = 51.79, ["Mega|Fly|Ride"] = 103.68}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.92, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 52.5, ["Mega"] = 14.44, ["Mega|Ride"] = 103.52, ["Mega|Fly|Ride"] = 210.2}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 19.92, ["Fly|Ride"] = 57.07, ["Neon"] = 12.37, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.65, ["Neon|Fly|Ride"] = 84.15, ["Mega"] = 141.56, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 288.27}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 197.31, ["Ride"] = 181.13, ["Fly|Ride"] = 262.5, ["Neon"] = 704.85, ["Neon|Ride"] = 1115.47, ["Neon|Fly|Ride"] = 1111.15, ["Mega"] = 8449.73, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 37.06, ["Neon"] = 5.84, ["Neon|Fly"] = 56.44, ["Neon|Ride"] = 68.25, ["Mega"] = 65.5, ["Mega|Ride"] = 197.53, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 26.23, ["Fly"] = 103.68, ["Ride"] = 28.88, ["Fly|Ride"] = 196.88, ["Neon"] = 33.84, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 418.27, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 631.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.94, ["Fly|Ride"] = 34.81, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 95.55, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 122.54}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 27.44, ["Fly|Ride"] = 120.89, ["Neon"] = 9.19, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 95.71, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210.2}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.54, ["Fly"] = 15.74, ["Ride"] = 18.38, ["Fly|Ride"] = 35.35, ["Neon"] = 28.88, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 280.97, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.93, ["Fly"] = 28.54, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 28.88, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 627.4, ["Mega"] = 327.48, ["Mega|Ride"] = 335.89, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.38, ["Fly|Ride"] = 39.8, ["Neon"] = 26.24, ["Neon|Fly"] = 83.46, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 64.32, ["Mega|Fly"] = 384.47, ["Mega|Ride"] = 237.68, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.1, ["Fly"] = 91.88, ["Ride"] = 94.35, ["Fly|Ride"] = 173.25, ["Neon"] = 459.38, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 420.39, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 227.75, ["Fly|Ride"] = 281.1, ["Neon"] = 912.78, ["Neon|Ride"] = 2640.54, ["Neon|Fly|Ride"] = 1259.28, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 6619.32}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 76.13, ["Fly"] = 200.08, ["Ride"] = 84.28, ["Fly|Ride"] = 137.39, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 353.53, ["Mega|Fly|Ride"] = 1722.18}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.3, ["Ride"] = 53.82, ["Fly|Ride"] = 141.62, ["Neon"] = 23.29, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.65, ["Fly"] = 68.14, ["Ride"] = 35.44, ["Fly|Ride"] = 66.94, ["Neon"] = 125.72, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 197.53, ["Mega"] = 351.75, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 17.67, ["Ride"] = 20.83, ["Fly|Ride"] = 56.6, ["Neon"] = 6.04, ["Neon|Fly"] = 26.94, ["Neon|Ride"] = 25.15, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 74.06, ["Mega|Fly"] = 212.6, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 194.36}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.91, ["Fly"] = 68.49, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 40.64, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 797.46, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 15.91, ["Fly|Ride"] = 48.57, ["Neon"] = 12.49, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 36.99, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 176.77, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 41.93, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 238.88, ["Mega"] = 207.37, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.84, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 30.18, ["Mega|Ride"] = 40.15, ["Mega|Fly|Ride"] = 226.04}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.34, ["Ride"] = 20.9, ["Fly|Ride"] = 48.62, ["Neon"] = 11.82, ["Neon|Fly"] = 105.69, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.06, ["Fly|Ride"] = 39.29, ["Neon"] = 19.04, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 207.82, ["Mega|Fly|Ride"] = 235.56}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 164.06, ["Fly"] = 200.82, ["Ride"] = 210, ["Fly|Ride"] = 271.69, ["Neon"] = 480.04, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 619.47, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2181.23}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.71, ["Ride"] = 41.89, ["Fly|Ride"] = 206.08, ["Neon"] = 51.19, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 307.47, ["Mega|Ride"] = 362.3, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 70.21, ["Neon"] = 28.23, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 131.25, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 28.67, ["Ride"] = 140.56, ["Fly|Ride"] = 178.5, ["Neon"] = 106.32, ["Neon|Ride"] = 119.75, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 477.73, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 535.52}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.65}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.93, ["Ride"] = 27.03, ["Neon"] = 32.71, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 283.5, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 545.31}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.86, ["Fly"] = 34.07, ["Ride"] = 31.38, ["Fly|Ride"] = 49.88, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 176.09, ["Neon|Fly|Ride"] = 194.71, ["Mega"] = 2112.45, ["Mega|Ride"] = 702.26, ["Mega|Fly|Ride"] = 637.76}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.82, ["Fly"] = 26.88, ["Ride"] = 28.29, ["Fly|Ride"] = 62.26, ["Neon"] = 84.56, ["Neon|Ride"] = 113.03, ["Mega"] = 140.42, ["Mega|Fly"] = 398.91, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 253.52}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.46, ["Ride"] = 16.78, ["Fly|Ride"] = 47.25, ["Neon"] = 15.74, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.48, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 124.68, ["Mega|Ride"] = 140.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 3.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.7, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 31.49, ["Mega|Ride"] = 78.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.39, ["Fly"] = 126.82, ["Ride"] = 59.07, ["Neon"] = 232.32, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 846.68, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 834.64}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.94, ["Ride"] = 39.38, ["Fly|Ride"] = 210, ["Neon"] = 69.76, ["Neon|Fly|Ride"] = 211.26, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 15.84, ["Fly"] = 57.07, ["Ride"] = 61.69, ["Fly|Ride"] = 134.79, ["Neon"] = 56.99, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 204.92, ["Mega"] = 347.81, ["Mega|Ride"] = 528.12, ["Mega|Fly|Ride"] = 631.63}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 45.85, ["Fly"] = 433.13, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 282.17, ["Neon|Ride"] = 316.88, ["Neon|Fly|Ride"] = 338, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 24.68, ["Fly"] = 39.38, ["Ride"] = 35.95, ["Fly|Ride"] = 63, ["Neon"] = 44.63, ["Neon|Ride"] = 83.46, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 322.88, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 511.17}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.63, ["Fly"] = 145.69, ["Ride"] = 119.44, ["Fly|Ride"] = 169.1, ["Neon"] = 203.43, ["Neon|Ride"] = 248.85, ["Neon|Fly|Ride"] = 361.26, ["Mega"] = 2069.71, ["Mega|Ride"] = 1029.83, ["Mega|Fly|Ride"] = 955.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 27.56, ["Ride"] = 71.7, ["Fly|Ride"] = 173.25, ["Neon"] = 101.3, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 293.48, ["Mega"] = 408.77, ["Mega|Ride"] = 335.89, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 69.5, ["Ride"] = 18.38, ["Fly|Ride"] = 303.3, ["Neon"] = 80.76, ["Neon|Ride"] = 84.92, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 105, ["Mega|Ride"] = 1056.23, ["Mega|Fly|Ride"] = 406.07}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 17.84, ["Ride"] = 78.75, ["Fly|Ride"] = 103.69, ["Neon"] = 90.46, ["Neon|Ride"] = 126.61, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 333.31, ["Mega|Fly"] = 392.93, ["Mega|Ride"] = 352.84, ["Mega|Fly|Ride"] = 533.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.57, ["Ride"] = 34.13, ["Fly|Ride"] = 138.87, ["Neon"] = 28.54, ["Neon|Ride"] = 94.37, ["Mega"] = 236.25, ["Mega|Ride"] = 422.5, ["Mega|Fly|Ride"] = 479.53}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 52.83, ["Neon|Ride"] = 55.95, ["Mega"] = 18.38, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 438.56, ["Neon"] = 14.48, ["Neon|Fly"] = 126.82, ["Neon|Ride"] = 83.83, ["Mega"] = 112.45, ["Mega|Ride"] = 233.44, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 104.57, ["Mega"] = 173.23, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.13, ["Ride"] = 31.44, ["Fly|Ride"] = 118.3, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 274.63, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.37, ["Fly"] = 598.12, ["Ride"] = 542.07, ["Fly|Ride"] = 588, ["Neon"] = 1752.69, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.76, ["Fly"] = 28.33, ["Ride"] = 25.18, ["Fly|Ride"] = 42.29, ["Neon"] = 52.5, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 282.02, ["Mega|Ride"] = 278.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.12, ["Fly"] = 39.38, ["Ride"] = 27.29, ["Fly|Ride"] = 84.56, ["Neon"] = 63.41, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.06, ["Mega"] = 215.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 295.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.93, ["Fly"] = 28.54, ["Ride"] = 23.63, ["Fly|Ride"] = 317.04, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.75, ["Mega|Ride"] = 637.76, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.08, ["Fly|Ride"] = 941.48, ["Neon"] = 10.4, ["Neon|Ride"] = 49.56, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 65.5, ["Mega|Ride"] = 85.09, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.82, ["Ride"] = 70.26, ["Neon"] = 2.1, ["Neon|Ride"] = 31.13, ["Mega"] = 27.36, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1550.85}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.56, ["Ride"] = 23.9, ["Neon"] = 56.6, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 70.79, ["Mega"] = 648.54, ["Mega|Ride"] = 493.27, ["Mega|Fly|Ride"] = 395.05}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 5.25, ["Neon|Ride"] = 40.68, ["Mega"] = 131.25, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 98.33, ["Ride"] = 25.38, ["Fly|Ride"] = 574.38, ["Neon"] = 13.05, ["Neon|Ride"] = 63.39, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.73, ["Mega|Ride"] = 160.06, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 458.07, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1435.42, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.94, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 91.95, ["Neon|Ride"] = 131.25, ["Mega"] = 279.8, ["Mega|Ride"] = 248.22, ["Mega|Fly|Ride"] = 395.32}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly|Ride"] = 129.04, ["Neon"] = 5.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 113.95, ["Mega"] = 49.88, ["Mega|Fly"] = 189, ["Mega|Ride"] = 79.8, ["Mega|Fly|Ride"] = 247.17}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 845.39, ["Neon"] = 3.94, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 268.29, ["Mega"] = 23.63, ["Mega|Ride"] = 147.88, ["Mega|Fly|Ride"] = 194.36}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.03, ["Fly"] = 56.27, ["Ride"] = 70.2, ["Fly|Ride"] = 156.41, ["Neon"] = 82.45, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 338, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 15.78, ["Ride"] = 113.08, ["Fly|Ride"] = 105.69, ["Neon"] = 104.63, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 564.03, ["Mega|Ride"] = 561.92, ["Mega|Fly|Ride"] = 1112.36}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.02, ["Ride"] = 26.25, ["Fly|Ride"] = 99.36, ["Neon"] = 140.99, ["Neon|Ride"] = 200.82, ["Mega"] = 626.07, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.69, ["Ride"] = 43.32, ["Fly|Ride"] = 262.5, ["Neon"] = 176.84, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 525, ["Mega|Ride"] = 401.38, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 375.61, ["Ride"] = 408.13, ["Fly|Ride"] = 616.88, ["Neon"] = 1409.69, ["Neon|Ride"] = 955.44, ["Neon|Fly|Ride"] = 1267.47, ["Mega|Ride"] = 3802.39, ["Mega|Fly|Ride"] = 3490.83}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.94, ["Fly"] = 28.3, ["Ride"] = 28.25, ["Fly|Ride"] = 84.69, ["Neon"] = 98.44, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 704.51, ["Mega|Ride"] = 538.59, ["Mega|Fly|Ride"] = 738.31}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 13.07, ["Ride"] = 116.75, ["Neon"] = 32.11, ["Mega"] = 1267.47, ["Mega|Fly|Ride"] = 1689.96}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 15.02, ["Ride"] = 60.37, ["Fly|Ride"] = 157.28, ["Neon"] = 47.24, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 210, ["Mega"] = 218.44, ["Mega|Ride"] = 222.23, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.51, ["Ride"] = 42, ["Fly|Ride"] = 117.32, ["Neon"] = 14.43, ["Neon|Ride"] = 45.14, ["Neon|Fly|Ride"] = 210.2, ["Mega"] = 44.6, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 56.09, ["Ride"] = 127.61, ["Neon"] = 393.75, ["Neon|Ride"] = 295.75, ["Neon|Fly|Ride"] = 475.32, ["Mega"] = 2534.93, ["Mega|Ride"] = 1351.97, ["Mega|Fly|Ride"] = 1263.25}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 597.39, ["Ride"] = 31.49, ["Neon"] = 10.4, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 157.05, ["Mega"] = 78.75, ["Mega|Ride"] = 95.16, ["Mega|Fly|Ride"] = 210.72}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.54, ["Fly|Ride"] = 99.36, ["Neon"] = 3.93, ["Neon|Fly"] = 422.7, ["Neon|Ride"] = 46.1, ["Neon|Fly|Ride"] = 91.83, ["Mega"] = 44.63, ["Mega|Ride"] = 105.45, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.93, ["Ride"] = 22.32, ["Fly|Ride"] = 111.51, ["Neon"] = 36.75, ["Neon|Ride"] = 66.55, ["Neon|Fly|Ride"] = 704.51, ["Mega"] = 209.14, ["Mega|Fly"] = 633.74, ["Mega|Ride"] = 242.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Fly"] = 99.36, ["Ride"] = 110.85, ["Fly|Ride"] = 319.01, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 239.52, ["Ride"] = 286.76, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 906.94, ["Mega"] = 12674.6, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.78, ["Neon"] = 40.01, ["Neon|Ride"] = 138.37, ["Mega"] = 99.74, ["Mega|Fly"] = 282.02, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 639.21}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 10.39, ["Ride"] = 37, ["Neon"] = 24.04, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 91.83, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 32.82, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 20.98, ["Fly|Ride"] = 80, ["Neon"] = 6.19, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 90.09, ["Mega"] = 51.19, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 251.4}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.8, ["Fly|Ride"] = 210.68, ["Neon"] = 7.87, ["Neon|Ride"] = 52.5, ["Mega"] = 36.53, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 205.97}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 4.22, ["Neon|Fly"] = 47.79, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.38, ["Mega|Ride"] = 96.12, ["Mega|Fly|Ride"] = 128.62}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 21.15, ["Fly|Ride"] = 63.41, ["Neon"] = 8.97, ["Neon|Fly"] = 73.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.9, ["Mega"] = 170.63, ["Mega|Ride"] = 201.75, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 22.23, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 205.02, ["Neon|Ride"] = 238.88, ["Mega"] = 393.75, ["Mega|Fly"] = 498.75, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 84.96, ["Fly"] = 582.75, ["Ride"] = 102.63, ["Fly|Ride"] = 422.7, ["Neon"] = 363.46, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 703.45, ["Mega|Ride"] = 2250.82, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 53.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.04, ["Fly|Ride"] = 30.15, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.3, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 44.38, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.29, ["Ride"] = 23.9, ["Fly|Ride"] = 141.62, ["Neon"] = 35.95, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 105, ["Mega"] = 626.82, ["Mega|Ride"] = 352.79, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 363.82, ["Fly"] = 393.75, ["Ride"] = 466.04, ["Fly|Ride"] = 395.24, ["Neon|Ride"] = 1478.71, ["Neon|Fly|Ride"] = 1583.28, ["Mega"] = 7962.32, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.54, ["Fly"] = 141.62, ["Ride"] = 65.09, ["Fly|Ride"] = 117.32, ["Neon"] = 196.88, ["Neon|Ride"] = 223.35, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1083.69, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1007.54}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 67.37, ["Neon"] = 10.5, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 99.3, ["Mega"] = 82.69, ["Mega|Ride"] = 116.84, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.36, ["Ride"] = 28.88, ["Fly|Ride"] = 142.7, ["Neon"] = 26.25, ["Neon|Ride"] = 169.01, ["Mega"] = 197.53}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30.19, ["Fly"] = 77.85, ["Ride"] = 49.88, ["Fly|Ride"] = 57.07, ["Neon|Fly"] = 315.98, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 2534.93, ["Mega|Ride"] = 950.61, ["Mega|Fly|Ride"] = 1274.32}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105.45, ["Ride"] = 98.74, ["Fly|Ride"] = 144.38, ["Neon"] = 414.86, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3098.95, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 246.65, ["Fly"] = 280.77, ["Ride"] = 246.75, ["Fly|Ride"] = 380.43, ["Neon"] = 986.99, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 930.57, ["Mega|Fly|Ride"] = 3028.17}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 19.69, ["Ride"] = 7397.11, ["Fly|Ride"] = 160.11, ["Neon"] = 141.62, ["Neon|Ride"] = 136.33, ["Neon|Fly|Ride"] = 296.2, ["Mega"] = 386.01, ["Mega|Ride"] = 408.77, ["Mega|Fly|Ride"] = 581.64}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 15.58, ["Fly|Ride"] = 40.05, ["Neon"] = 15.42, ["Neon|Ride"] = 27.48, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.99, ["Fly"] = 33.64, ["Ride"] = 25.87, ["Fly|Ride"] = 43.63, ["Neon"] = 37.89, ["Neon|Fly"] = 21.08, ["Neon|Ride"] = 45.44, ["Neon|Fly|Ride"] = 112.56, ["Mega"] = 236.25, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 362.3}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 315, ["Fly|Ride"] = 406.88, ["Neon"] = 1483.88, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4788.9}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.51, ["Neon"] = 8.39, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 41.99, ["Mega|Ride"] = 158.45, ["Mega|Fly|Ride"] = 280.97}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.23, ["Ride"] = 18.38, ["Fly|Ride"] = 66.63, ["Neon"] = 30.87, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 169.01, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 240.83, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 23.59, ["Ride"] = 112.12, ["Neon"] = 99.65, ["Neon|Fly"] = 422.5, ["Neon|Ride"] = 152.25, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 466.48, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 131.14, ["Fly"] = 281.1, ["Ride"] = 156.41, ["Fly|Ride"] = 137.82, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2953.19}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 24.05, ["Fly"] = 45.05, ["Ride"] = 32.82, ["Fly|Ride"] = 49.48, ["Neon"] = 76.13, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 152.11, ["Mega"] = 401.38, ["Mega|Ride"] = 422.79, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.89, ["Neon|Ride"] = 204.23, ["Neon|Fly|Ride"] = 704.51, ["Mega"] = 27.48, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.94, ["Fly|Ride"] = 72.19, ["Neon"] = 2.6, ["Neon|Fly"] = 160.11, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 22.32, ["Mega|Fly"] = 142.13, ["Mega|Ride"] = 53.89, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Fly"] = 418.69, ["Ride"] = 61.69, ["Fly|Ride"] = 156.41, ["Neon"] = 30.06, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 149.43, ["Mega|Fly"] = 282.02, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 279.72}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1407, ["Ride"] = 1311.19, ["Fly|Ride"] = 1295.32, ["Neon"] = 3345.25, ["Neon|Ride"] = 7041.8, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 406.88, ["Ride"] = 459.38, ["Fly|Ride"] = 618.19, ["Neon"] = 1774.95, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 2230.94, ["Mega"] = 14331.45, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 290.07, ["Fly"] = 371.44, ["Ride"] = 317.04, ["Fly|Ride"] = 360.94, ["Neon"] = 734.99, ["Neon|Fly"] = 1274.79, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 704.51, ["Mega|Fly|Ride"] = 2887.71}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 330.64, ["Ride"] = 367.5, ["Fly|Ride"] = 510.42, ["Neon"] = 1023.75, ["Neon|Fly"] = 3186.35, ["Neon|Ride"] = 1132.2, ["Neon|Fly|Ride"] = 1090.69, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 4042.15}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 17.04, ["Fly|Ride"] = 44.63, ["Neon"] = 6.57, ["Neon|Ride"] = 27.43, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 107.76, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 405.57, ["Fly"] = 796.91, ["Ride"] = 459.38, ["Fly|Ride"] = 601.42, ["Neon"] = 1181.25, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 13202.69, ["Mega|Ride"] = 4506.88, ["Mega|Fly|Ride"] = 4921.88}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.38, ["Neon"] = 6.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 207.8}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 21.15, ["Fly|Ride"] = 39.38, ["Neon"] = 14.25, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 105.52, ["Mega"] = 89.88, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.74}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 19.69, ["Neon"] = 3.78, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 39.37, ["Mega"] = 31.49, ["Mega|Fly"] = 84.51, ["Mega|Ride"] = 46.03, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 349.44, ["Mega"] = 1689.96, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 60.43, ["Neon"] = 107.54, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.93, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 704.51, ["Mega|Ride"] = 91.48, ["Mega|Fly|Ride"] = 309.07}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 23.99, ["Fly|Ride"] = 41.5, ["Neon"] = 7.9, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 70.24, ["Mega"] = 60.38, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 78.56, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.77, ["Fly"] = 47.8, ["Ride"] = 41.91, ["Fly|Ride"] = 51.45, ["Neon"] = 105.69, ["Neon|Fly"] = 143.39, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.38, ["Ride"] = 52.5, ["Neon"] = 59.19, ["Neon|Ride"] = 70.79, ["Mega"] = 352.79, ["Mega|Ride"] = 338, ["Mega|Fly|Ride"] = 352.79}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.93, ["Ride"] = 27.2, ["Fly|Ride"] = 70.82, ["Neon"] = 47.25, ["Neon|Ride"] = 79.95, ["Neon|Fly|Ride"] = 282.02, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 56.17, ["Neon"] = 3.93, ["Neon|Fly"] = 31.71, ["Neon|Ride"] = 26.25, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 183.89, ["Fly"] = 366.71, ["Ride"] = 246.75, ["Fly|Ride"] = 262.5, ["Neon"] = 986.99, ["Neon|Ride"] = 1146.71, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 4869.12}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 19, ["Fly|Ride"] = 34.67, ["Neon"] = 3.35, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 50.18, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 79.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 15.65, ["Ride"] = 94.5, ["Fly|Ride"] = 179.66, ["Neon"] = 62.36, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 160.06, ["Mega"] = 379.32, ["Mega|Ride"] = 438.35, ["Mega|Fly|Ride"] = 633.74}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.41, ["Fly"] = 131.25, ["Ride"] = 104.71, ["Fly|Ride"] = 170.63, ["Neon"] = 253.22, ["Neon|Ride"] = 295.75, ["Neon|Fly|Ride"] = 154.22, ["Mega"] = 840.77, ["Mega|Ride"] = 808.54, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.75, ["Ride"] = 225.75, ["Fly|Ride"] = 273, ["Neon"] = 796.9, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 3379.9, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.07, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 282.02, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 32.17, ["Ride"] = 422.7, ["Fly|Ride"] = 158.81, ["Neon"] = 290.97, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1441.13, ["Ride"] = 1155, ["Fly|Ride"] = 1076.25, ["Neon|Ride"] = 5069.85, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 17182.52}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.18, ["Fly"] = 27.44, ["Ride"] = 22.05, ["Fly|Ride"] = 53.47, ["Neon"] = 79.06, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 223.93, ["Mega|Ride"] = 230.27, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.92, ["Fly"] = 13769.7, ["Ride"] = 35.43, ["Neon"] = 42.29, ["Neon|Ride"] = 140.39, ["Mega"] = 212.63, ["Mega|Ride"] = 174.48, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.23, ["Ride"] = 32.27, ["Fly|Ride"] = 91.33, ["Neon"] = 45.94, ["Neon|Ride"] = 53.82, ["Mega"] = 245.44, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 631.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.43, ["Fly"] = 704.85, ["Ride"] = 39.38, ["Fly|Ride"] = 141.62, ["Neon"] = 87.94, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.62, ["Mega"] = 528.12, ["Mega|Ride"] = 428.21, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.9, ["Fly"] = 28.54, ["Ride"] = 24.31, ["Fly|Ride"] = 66.52, ["Neon"] = 21.82, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.57, ["Mega"] = 129.94, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 350.68}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.93, ["Neon"] = 138.41, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 234.49, ["Mega|Ride"] = 131.14}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 264.2, ["Ride"] = 334.69, ["Fly|Ride"] = 338.17, ["Neon|Ride"] = 1478.71, ["Neon|Fly|Ride"] = 1409.01, ["Mega|Ride"] = 4647.37, ["Mega|Fly|Ride"] = 4900.86}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 70.82, ["Ride"] = 28.3, ["Fly|Ride"] = 59.07, ["Neon"] = 10.5, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 878.79}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.56, ["Neon"] = 32.71, ["Neon|Ride"] = 188.27, ["Mega"] = 278.85, ["Mega|Ride"] = 268.29}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.83, ["Fly"] = 58.43, ["Ride"] = 40.11, ["Neon"] = 17.94, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 281.03, ["Mega"] = 141.56, ["Mega|Fly"] = 422.5, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 196.86, ["Fly"] = 338.17, ["Ride"] = 236.25, ["Fly|Ride"] = 664.13, ["Neon"] = 945.78, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 924.4, ["Mega|Ride"] = 2816.93, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.88, ["Fly"] = 61.88, ["Ride"] = 45.93, ["Fly|Ride"] = 158.82, ["Neon"] = 124.71, ["Neon|Ride"] = 162.67, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 542.92, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 715.32}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.69, ["Ride"] = 39.38, ["Fly|Ride"] = 1268.09, ["Neon"] = 107.63, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 489.14, ["Mega|Ride"] = 526.01, ["Mega|Fly|Ride"] = 873.05}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.82, ["Mega|Ride"] = 223.05, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 78.56, ["Fly"] = 126.67, ["Ride"] = 118.13, ["Fly|Ride"] = 196.88, ["Neon"] = 390.7, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 311.6, ["Neon|Fly|Ride"] = 391.06, ["Mega|Fly|Ride"] = 1207.29}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 5.25, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 588, ["Mega"] = 32.08, ["Mega|Ride"] = 211.26}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 24.77, ["Fly"] = 127.86, ["Ride"] = 28.88, ["Fly|Ride"] = 89.62, ["Neon"] = 87.05, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.74, ["Fly"] = 79.92, ["Ride"] = 39.38, ["Fly|Ride"] = 179.82, ["Neon"] = 177.19, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 318.89, ["Mega|Ride"] = 1224.17, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 16.78, ["Fly|Ride"] = 32.48, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 84, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 66.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.68, ["Ride"] = 32.18, ["Fly|Ride"] = 1346.59, ["Neon"] = 23.07, ["Neon|Ride"] = 95.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 210.4, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.69, ["Fly"] = 141.62, ["Ride"] = 56.44, ["Neon"] = 85.32, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 637.76, ["Mega"] = 586.69, ["Mega|Ride"] = 530.61, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.32, ["Mega"] = 23.59, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.62, ["Fly"] = 210, ["Ride"] = 41.89, ["Fly|Ride"] = 111.57, ["Neon"] = 73.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 223.93, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 268.4, ["Mega|Fly|Ride"] = 493.27}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 23.63, ["Fly"] = 41.88, ["Ride"] = 26.17, ["Fly|Ride"] = 169.1, ["Neon"] = 129.68, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 1115.77}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 58.98, ["Fly|Ride"] = 76.01, ["Neon"] = 25.7, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.3, ["Mega"] = 183.79, ["Mega|Ride"] = 192.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 12.99, ["Fly"] = 2113.48, ["Ride"] = 94.38, ["Neon"] = 64.32, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 6369.15, ["Mega"] = 704.51, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1149.11}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 50.74, ["Neon|Ride"] = 70.79, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 126.76}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Neon"] = 3.81, ["Mega"] = 24.83, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.47}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 35.35, ["Fly"] = 102.38, ["Ride"] = 78.75, ["Fly|Ride"] = 117.32, ["Neon"] = 1050, ["Neon|Ride"] = 282.02, ["Neon|Fly|Ride"] = 564.03, ["Mega"] = 1113.27, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 141.62, ["Neon"] = 3.29, ["Mega"] = 21, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 105.65, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 506.63, ["Fly"] = 803.13, ["Ride"] = 472.49, ["Fly|Ride"] = 393.75, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16899.45, ["Mega|Fly|Ride"] = 14083.58}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.61, ["Fly"] = 25.81, ["Ride"] = 19.69, ["Fly|Ride"] = 79.27, ["Neon"] = 12.85, ["Neon|Ride"] = 278.85, ["Mega"] = 75.01, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 160.11, ["Ride"] = 23.25, ["Fly|Ride"] = 55.13, ["Neon"] = 15.75, ["Neon|Ride"] = 35.85, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 279.57, ["Mega|Ride"] = 140.54, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.02, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 91.88, ["Neon|Ride"] = 181.13, ["Mega"] = 504.89, ["Mega|Ride"] = 382.18, ["Mega|Fly|Ride"] = 522.84}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.63, ["Fly"] = 131.25, ["Ride"] = 31.5, ["Fly|Ride"] = 141.62, ["Mega"] = 242.82, ["Mega|Ride"] = 280.97}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 17.07, ["Ride"] = 39.38, ["Fly|Ride"] = 157.47, ["Neon"] = 78.66, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 465.81, ["Mega|Ride"] = 467.92, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.45, ["Fly"] = 104.98, ["Ride"] = 48.62, ["Fly|Ride"] = 190.22, ["Neon"] = 49.83, ["Neon|Ride"] = 137.32, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 168, ["Mega|Fly"] = 490.1, ["Mega|Ride"] = 219.19}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 74.72, ["Mega"] = 19.41, ["Mega|Fly"] = 60.38, ["Mega|Ride"] = 21.1, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 10.5, ["Ride"] = 27.57, ["Fly|Ride"] = 160.11, ["Neon"] = 27.46, ["Neon|Fly"] = 119.44, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 316.88, ["Mega"] = 170.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 268.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 290.16, ["Ride"] = 315.42, ["Fly|Ride"] = 352.46, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1126.99, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 90.9, ["Fly"] = 156.41, ["Ride"] = 149.63, ["Fly|Ride"] = 238.96, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4224.87, ["Mega|Ride"] = 1732.2, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.05, ["Fly"] = 23.26, ["Ride"] = 18.94, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 42.16, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 99.3, ["Mega|Fly"] = 210.2, ["Mega|Ride"] = 91.9, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 15.65, ["Fly|Ride"] = 35.44, ["Neon"] = 6.56, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 57.05, ["Mega"] = 85.32, ["Mega|Fly"] = 352.79, ["Mega|Ride"] = 92.96, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 141.56, ["Mega|Ride"] = 210.2, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 237.57, ["Fly|Ride"] = 281.1, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1282.26, ["Mega|Ride"] = 8449.73, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 35.53, ["Ride"] = 18.25, ["Fly|Ride"] = 44.61, ["Neon"] = 33.84, ["Neon|Fly"] = 160.11, ["Neon|Ride"] = 41.21, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 282.02, ["Mega|Ride"] = 257.73, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.23, ["Fly"] = 160.11, ["Ride"] = 42.29, ["Fly|Ride"] = 211.36, ["Neon"] = 26.25, ["Neon|Ride"] = 74.84, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 30.31, ["Mega"] = 39.38, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 564.31, ["Ride"] = 27.57, ["Fly|Ride"] = 80.33, ["Neon"] = 113.51, ["Neon|Ride"] = 103.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 57.75, ["Fly"] = 114.19, ["Ride"] = 70.88, ["Fly|Ride"] = 210, ["Neon"] = 156.41, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 195.84, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 459.38, ["Mega|Fly"] = 2218.07, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 622.12}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 18.38, ["Fly"] = 47.8, ["Ride"] = 53.45, ["Fly|Ride"] = 81.25, ["Neon"] = 112.22, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 182.13, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 792.18, ["Mega|Ride"] = 796.61, ["Mega|Fly|Ride"] = 796.61}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.83, ["Fly|Ride"] = 34.61, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 24.94, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 197.63, ["Fly"] = 278.25, ["Ride"] = 253.63, ["Fly|Ride"] = 365.59, ["Neon"] = 1257.48, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1086.68, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.89, ["Fly"] = 140.39, ["Ride"] = 45.93, ["Neon"] = 105, ["Neon|Ride"] = 159.05, ["Neon|Fly|Ride"] = 321.56, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 8.48, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.97, ["Mega"] = 49.24, ["Mega|Fly"] = 180.63, ["Mega|Ride"] = 141.04, ["Mega|Fly|Ride"] = 303.37}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.05, ["Fly"] = 28.54, ["Ride"] = 17.07, ["Fly|Ride"] = 53.82, ["Neon"] = 3.13, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.3, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 27.48, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 54.94, ["Mega|Fly|Ride"] = 137.71}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.19, ["Fly|Ride"] = 91.95, ["Neon"] = 9.01, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 7041.8, ["Mega"] = 93.06, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 386.59}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.02, ["Fly"] = 53.44, ["Ride"] = 28.48, ["Fly|Ride"] = 50.76, ["Neon"] = 60.96, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 357.1, ["Mega|Fly"] = 796.61, ["Mega|Ride"] = 279.45, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 13.02, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 323.23, ["Mega|Fly|Ride"] = 344.34}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 44.63, ["Neon"] = 3.83, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 84, ["Mega"] = 31.48, ["Mega|Fly"] = 59.16, ["Mega|Ride"] = 79.24}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.24, ["Ride"] = 37, ["Fly|Ride"] = 57.07, ["Neon"] = 21, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 99.3, ["Mega"] = 157.5, ["Mega|Fly"] = 268.29, ["Mega|Ride"] = 219.72, ["Mega|Fly|Ride"] = 283.4}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.82, ["Fly|Ride"] = 99.36, ["Neon"] = 4.79, ["Neon|Fly"] = 84.51, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 160.06, ["Mega"] = 42.26, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.64, ["Ride"] = 17.63, ["Fly|Ride"] = 83.91, ["Neon"] = 4.77, ["Neon|Ride"] = 30.7, ["Neon|Fly|Ride"] = 78.17, ["Mega"] = 65.54, ["Mega|Ride"] = 71.24, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 665.44, ["Ride"] = 758.63, ["Fly|Ride"] = 763.3, ["Neon"] = 4208.96, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3357.48, ["Mega|Ride"] = 15492.58, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.4, ["Ride"] = 19.46, ["Fly|Ride"] = 49.69, ["Neon"] = 27.2, ["Neon|Fly"] = 50.74, ["Neon|Ride"] = 32.19, ["Neon|Fly|Ride"] = 99.12, ["Mega"] = 189.08, ["Mega|Fly|Ride"] = 197.53}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.29, ["Ride"] = 69.57, ["Fly|Ride"] = 105.69, ["Neon"] = 11.64, ["Neon|Fly"] = 845.39, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 49.88, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 155.81}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.23, ["Fly"] = 32.82, ["Ride"] = 31.61, ["Fly|Ride"] = 47.6, ["Neon"] = 35.44, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 99.3, ["Mega"] = 311.6, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.86, ["Fly|Ride"] = 35.44, ["Neon"] = 6.48, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 56.58, ["Mega"] = 77.44, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.41, ["Fly|Ride"] = 210.31, ["Neon"] = 160.11, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 684.45, ["Mega|Ride"] = 831.25, ["Mega|Fly|Ride"] = 772.71}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Fly|Ride"] = 88.78, ["Neon"] = 7.7, ["Neon|Fly"] = 136.21, ["Neon|Ride"] = 36.64, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.67, ["Mega|Ride"] = 139.44, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.42, ["Fly"] = 73.48, ["Ride"] = 23.4, ["Fly|Ride"] = 61.3, ["Neon"] = 11.82, ["Neon|Fly"] = 143.39, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 452.07, ["Mega"] = 91.88, ["Mega|Ride"] = 269.35, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 64.53, ["Mega"] = 116.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.96, ["Fly|Ride"] = 84.56, ["Neon"] = 4.75, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 94.31, ["Mega"] = 52.83, ["Mega|Fly"] = 179.58, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 171.99}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.43, ["Fly"] = 21.11, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 137.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 109.87, ["Mega"] = 844.98, ["Mega|Ride"] = 467.92, ["Mega|Fly|Ride"] = 403.72}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 735, ["Ride"] = 746.82, ["Fly|Ride"] = 813.75, ["Neon"] = 1938.56, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8293.15, ["Mega|Ride"] = 7464.28, ["Mega|Fly|Ride"] = 5903.63}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 19.11, ["Fly|Ride"] = 43.32, ["Neon"] = 5.25, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 63, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 127.8}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.73, ["Ride"] = 38.67, ["Fly|Ride"] = 92.18, ["Neon"] = 47.8, ["Neon|Fly"] = 104.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 535.52}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 58.59, ["Ride"] = 85.32, ["Fly|Ride"] = 141.62, ["Neon"] = 378.32, ["Neon|Ride"] = 318.89, ["Neon|Fly|Ride"] = 366.52, ["Mega"] = 1549.49, ["Mega|Ride"] = 1549.49, ["Mega|Fly|Ride"] = 1605.16}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 43.32, ["Ride"] = 59.68, ["Fly|Ride"] = 141.62, ["Neon"] = 200.8, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 1958.23, ["Mega|Ride"] = 844.98, ["Mega|Fly|Ride"] = 1028.76}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.97, ["Ride"] = 24.94, ["Neon"] = 84, ["Neon|Ride"] = 160.06, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 334.85, ["Mega|Ride"] = 366.52, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 28.3, ["Ride"] = 95.12, ["Neon"] = 72.19, ["Neon|Fly"] = 319.01, ["Neon|Ride"] = 366.66, ["Mega"] = 456.1, ["Mega|Fly"] = 518.34, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19, ["Fly"] = 63, ["Ride"] = 76.13, ["Neon"] = 157.5, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 1055.17}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 21}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.46, ["Fly"] = 131248.69, ["Ride"] = 31.42, ["Fly|Ride"] = 78.75, ["Neon"] = 35.86, ["Neon|Ride"] = 99.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 189, ["Mega|Fly"] = 238.88, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 47.8, ["Neon"] = 36.75, ["Mega"] = 348.92, ["Mega|Fly|Ride"] = 950.61}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.05, ["Fly"] = 393.75, ["Ride"] = 103.17, ["Fly|Ride"] = 117.47, ["Neon"] = 338.17, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 564.03, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 992.85}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.84, ["Fly"] = 27.57, ["Ride"] = 15.86, ["Fly|Ride"] = 36.75, ["Neon"] = 18.38, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 77.18, ["Mega"] = 262.5, ["Mega|Fly"] = 421.45, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 408.77}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 9.19, ["Fly"] = 84.56, ["Ride"] = 31.5, ["Fly|Ride"] = 72.19, ["Neon"] = 27.2, ["Neon|Ride"] = 53.89, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 155.16, ["Mega|Ride"] = 237.57, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.8, ["Neon|Ride"] = 90.85, ["Mega"] = 61.2, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 39.11, ["Fly"] = 65.63, ["Ride"] = 48.57, ["Fly|Ride"] = 78.74, ["Neon"] = 221.82, ["Neon|Ride"] = 211.26, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 1126.99, ["Mega|Ride"] = 838.03, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.58, ["Fly|Ride"] = 84.56, ["Neon"] = 9.19, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 70.79, ["Mega"] = 93.17, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 12.68, ["Ride"] = 53.91, ["Neon"] = 99.36, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 350.68, ["Mega"] = 288.75, ["Mega|Ride"] = 522.84, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 16.94, ["Fly|Ride"] = 28.54, ["Neon"] = 46.6, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.07, ["Mega"] = 207.82, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 82.45, ["Neon|Ride"] = 177.19, ["Mega"] = 276.74, ["Mega|Ride"] = 247.17, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.68, ["Ride"] = 36.53, ["Neon"] = 31.29, ["Neon|Ride"] = 91.9, ["Mega"] = 141.56, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.11, ["Ride"] = 105, ["Neon"] = 274.32, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 868.1, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.05, ["Ride"] = 141.62, ["Neon"] = 210, ["Neon|Fly|Ride"] = 253.52, ["Mega"] = 389.82, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.87, ["Ride"] = 104.89, ["Fly|Ride"] = 282.17, ["Neon"] = 168.42, ["Mega"] = 591.49, ["Mega|Ride"] = 556.64, ["Mega|Fly|Ride"] = 1689.96}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 26.25, ["Ride"] = 70, ["Fly|Ride"] = 422.03, ["Neon"] = 94.5, ["Neon|Ride"] = 111.39, ["Neon|Fly|Ride"] = 456.3, ["Mega"] = 682.34, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 4.19, ["Neon"] = 40.64, ["Neon|Ride"] = 282.02, ["Mega"] = 105, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 4.23, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 60.38, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 185.91}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.63, ["Ride"] = 44.62, ["Fly|Ride"] = 65.63, ["Neon"] = 26.18, ["Neon|Fly"] = 70.79, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 137.16, ["Mega"] = 207.82, ["Mega|Ride"] = 239.77, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 17.85, ["Fly|Ride"] = 55.13, ["Neon"] = 7.87, ["Neon|Ride"] = 25.36, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 44.51, ["Mega|Ride"] = 71.97, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Fly|Ride"] = 99.36, ["Neon"] = 39.38, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 113.03, ["Mega"] = 223.93, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.84, ["Ride"] = 23.9, ["Fly|Ride"] = 59.07, ["Neon"] = 44.4, ["Neon|Fly"] = 477.9, ["Neon|Ride"] = 98.59, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 7.85, ["Fly"] = 131.25, ["Ride"] = 28.54, ["Fly|Ride"] = 42, ["Neon"] = 19.67, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 107.6, ["Mega"] = 225.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.15, ["Fly"] = 34.07, ["Ride"] = 22.95, ["Fly|Ride"] = 63.41, ["Neon"] = 11.96, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 167.99, ["Mega|Ride"] = 210.2, ["Mega|Fly|Ride"] = 315.82}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 8.54, ["Fly"] = 23.63, ["Ride"] = 47.25, ["Fly|Ride"] = 108.94, ["Neon"] = 21.17, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 81.38, ["Mega"] = 116.82, ["Mega|Ride"] = 152.1, ["Mega|Fly|Ride"] = 405.85}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.07, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 191.17, ["Neon"] = 85.32, ["Neon|Ride"] = 185.42, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 387.99, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 571.79}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 63, ["Fly"] = 238.96, ["Ride"] = 97.13, ["Fly|Ride"] = 187.69, ["Neon"] = 308.44, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 371.18, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1029}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 25.18, ["Fly|Ride"] = 38.07, ["Neon"] = 3.29, ["Neon|Ride"] = 38.06, ["Mega"] = 26.25, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 130.62}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 16.96, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 862.98, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 40.68, ["Fly"] = 105, ["Ride"] = 110.97, ["Neon"] = 233.56, ["Neon|Ride"] = 303.37, ["Neon|Fly|Ride"] = 515.44, ["Mega"] = 1723.75, ["Mega|Ride"] = 1113.27, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 14.32, ["Fly"] = 190.32, ["Ride"] = 44.62, ["Fly|Ride"] = 126, ["Neon"] = 40.58, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 282.02, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 52.47, ["Fly|Ride"] = 136.6, ["Neon"] = 3.93, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 35.63, ["Mega"] = 22.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.09, ["Mega|Fly|Ride"] = 124.21}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 27.27, ["Ride"] = 21, ["Fly|Ride"] = 42.29, ["Neon"] = 15.81, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105.11, ["Mega"] = 296.2, ["Mega|Fly"] = 352.79, ["Mega|Ride"] = 233.44, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 20.08, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 42.29, ["Ride"] = 27.57, ["Fly|Ride"] = 65.7, ["Neon"] = 2.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 32.82, ["Mega|Fly"] = 168, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Fly|Ride"] = 160.11, ["Neon"] = 3.29, ["Neon|Ride"] = 126.27, ["Mega"] = 28.53, ["Mega|Ride"] = 105.65, ["Mega|Fly|Ride"] = 266.18}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.94, ["Ride"] = 31.43, ["Fly|Ride"] = 262.5, ["Neon"] = 71.7, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.14, ["Mega"] = 213.94, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.4, ["Ride"] = 30.19, ["Fly|Ride"] = 84.56, ["Neon"] = 52.19, ["Neon|Ride"] = 97.12, ["Neon|Fly|Ride"] = 237.68, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 640.16}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.12, ["Fly"] = 29.19, ["Ride"] = 20.9, ["Fly|Ride"] = 42, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 81.38, ["Ride"] = 167.62, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega"] = 3185.18, ["Mega|Fly|Ride"] = 1549.49}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.98, ["Fly"] = 72.44, ["Ride"] = 65.63, ["Fly|Ride"] = 72.19, ["Neon"] = 103.69, ["Mega"] = 628.04, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 1280.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 17.9, ["Fly|Ride"] = 18.38, ["Neon"] = 3.94, ["Neon|Fly"] = 28.53, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 42.26, ["Mega"] = 36.11, ["Mega|Ride"] = 113.03, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 19.04, ["Fly|Ride"] = 27.49, ["Neon"] = 4.15, ["Neon|Fly"] = 23.61, ["Neon|Ride"] = 20.08, ["Neon|Fly|Ride"] = 41.91, ["Mega"] = 67.34, ["Mega|Ride"] = 49.66, ["Mega|Fly|Ride"] = 104.64}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 434.44, ["Fly|Ride"] = 446.24, ["Neon|Ride"] = 1871.46, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.5, ["Ride"] = 140.41, ["Fly|Ride"] = 241.78, ["Neon"] = 105, ["Mega"] = 422.5, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.67, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 3.93, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.32, ["Mega"] = 38.97, ["Mega|Ride"] = 74.82}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 78.75, ["Ride"] = 98.44, ["Fly|Ride"] = 523.69, ["Neon"] = 261.19, ["Neon|Ride"] = 304.48, ["Neon|Fly|Ride"] = 462, ["Mega"] = 737.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 31.71, ["Ride"] = 18.96, ["Fly|Ride"] = 55.13, ["Neon"] = 11.38, ["Neon|Fly"] = 48.62, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 83.46, ["Mega"] = 77.84, ["Mega|Fly"] = 84.51, ["Mega|Ride"] = 105.84, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.82, ["Ride"] = 47.8, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.36, ["Neon|Fly|Ride"] = 92.96, ["Mega"] = 24.01, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 182.34}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 40.68, ["Fly"] = 133.17, ["Ride"] = 99.75, ["Fly|Ride"] = 243.74, ["Neon"] = 245.19, ["Neon|Ride"] = 279.47, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 790.97, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 817.52}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 4.67, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 98.54, ["Mega|Ride"] = 113.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Ride"] = 57.07, ["Neon"] = 152.24, ["Neon|Ride"] = 169.01, ["Neon|Fly|Ride"] = 369.69, ["Mega"] = 1667.78, ["Mega|Ride"] = 1689.96, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.84, ["Ride"] = 45.02, ["Fly|Ride"] = 211.36, ["Neon"] = 23.63, ["Neon|Ride"] = 300.57, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 70.82, ["Ride"] = 18.84, ["Neon"] = 12.84, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 79.24, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.23, ["Fly"] = 70.82, ["Ride"] = 54.96, ["Fly|Ride"] = 104.9, ["Neon"] = 146.44, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1126.99}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 54.96, ["Fly|Ride"] = 908.98, ["Neon"] = 5.24, ["Neon|Ride"] = 36.63, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 57.05, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 93.08, ["Mega|Fly|Ride"] = 229.43}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.07, ["Ride"] = 23.26, ["Fly|Ride"] = 102.85, ["Neon"] = 6.51, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 167.95, ["Mega|Ride"] = 180.63, ["Mega|Fly|Ride"] = 289.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.88, ["Fly"] = 35.6, ["Ride"] = 40.64, ["Fly|Ride"] = 93.2, ["Neon"] = 81.25, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 160.06, ["Mega"] = 262.5, ["Mega|Ride"] = 452.65, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 34.31, ["Ride"] = 66.61, ["Fly|Ride"] = 160.11, ["Neon"] = 241.4, ["Neon|Ride"] = 248.42, ["Neon|Fly|Ride"] = 477.73, ["Mega"] = 815.07, ["Mega|Ride"] = 1050.95, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 32.71, ["Fly"] = 30.19, ["Ride"] = 35.43, ["Fly|Ride"] = 77.44, ["Neon"] = 84.56, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.22, ["Ride"] = 120.48, ["Fly|Ride"] = 196.82, ["Neon"] = 341.25, ["Neon|Ride"] = 338, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1464.99, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.13, ["Ride"] = 35.44, ["Neon"] = 18.26, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 196.21, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.2, ["Ride"] = 24.86, ["Fly|Ride"] = 78.75, ["Neon"] = 24.31, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 203.44, ["Mega|Ride"] = 182.48, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.02, ["Fly"] = 28.33, ["Ride"] = 44.01, ["Fly|Ride"] = 98.95, ["Neon"] = 55.82, ["Neon|Ride"] = 136.5, ["Mega"] = 318.89, ["Mega|Ride"] = 352.79, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 13.96, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 19.67, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 63, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 303.01, ["Neon"] = 239.89, ["Neon|Fly"] = 2256.27, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 986.52, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 95.12, ["Fly|Ride"] = 109.92, ["Neon"] = 3.7, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 43.01, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 11.82, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 21.06, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 118.13, ["Mega|Ride"] = 414.24, ["Mega|Fly|Ride"] = 334.57}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 82.25, ["Ride"] = 118.13, ["Fly|Ride"] = 262.5, ["Neon"] = 311.75, ["Neon|Ride"] = 296.5, ["Neon|Fly|Ride"] = 376.02, ["Mega"] = 1010.63, ["Mega|Ride"] = 1208.82, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Ride"] = 43.22, ["Mega"] = 76.13, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.61}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.84, ["Fly|Ride"] = 67.65, ["Neon"] = 5.25, ["Neon|Ride"] = 71.3, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 45.93, ["Mega|Ride"] = 116.18, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 144.38, ["Ride"] = 185.22, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 718.25, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3662.89, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.46, ["Ride"] = 25.5, ["Neon"] = 11.54, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 120.42, ["Mega"] = 145.84, ["Mega|Ride"] = 211.26, ["Mega|Fly|Ride"] = 467.92}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Ride"] = 30.69, ["Neon"] = 51.1, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 169.01, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 28.88, ["Ride"] = 26.61, ["Fly|Ride"] = 157.5, ["Neon"] = 79.75, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 587.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 52.5, ["Fly|Ride"] = 211.36, ["Neon"] = 187.69, ["Neon|Ride"] = 314.04, ["Neon|Fly|Ride"] = 493.27, ["Mega"] = 682.5, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.67, ["Fly"] = 189.91, ["Ride"] = 199.5, ["Fly|Ride"] = 221.82, ["Neon"] = 477.9, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 507.01, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 9.87, ["Fly"] = 22.83, ["Ride"] = 19.67, ["Fly|Ride"] = 35.44, ["Neon"] = 117.32, ["Neon|Ride"] = 82.94, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.93, ["Fly"] = 131.23, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 14.04, ["Neon|Ride"] = 35.94, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 286.64}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.17, ["Fly"] = 99.36, ["Ride"] = 69.17, ["Neon"] = 129.93, ["Neon|Ride"] = 141.56, ["Mega"] = 1273.81, ["Mega|Ride"] = 421.45, ["Mega|Fly|Ride"] = 644.31}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42, ["Ride"] = 65.63, ["Fly|Ride"] = 105.68, ["Neon"] = 219.6, ["Neon|Ride"] = 247.17, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 887.23, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.67, ["Ride"] = 81.86, ["Neon"] = 91.88, ["Neon|Ride"] = 126.76, ["Mega"] = 767.88, ["Mega|Ride"] = 746.76, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 309.75, ["Ride"] = 401.58, ["Neon"] = 845.39, ["Neon|Ride"] = 1098.48, ["Neon|Fly|Ride"] = 1084.74, ["Mega|Fly|Ride"] = 4689.61}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.07, ["Fly"] = 70.82, ["Ride"] = 55.04, ["Fly|Ride"] = 168.41, ["Neon"] = 271.21, ["Neon|Ride"] = 271.11, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 984.38, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 893.4}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 17.09, ["Ride"] = 15.16, ["Fly|Ride"] = 67.68, ["Neon"] = 2.5, ["Neon|Fly"] = 19.14, ["Neon|Ride"] = 19.08, ["Neon|Fly|Ride"] = 56.88, ["Mega"] = 22.32, ["Mega|Fly"] = 107.76, ["Mega|Ride"] = 38.51, ["Mega|Fly|Ride"] = 99.3}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 211.36, ["Neon"] = 21.15, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 158.45, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Ride"] = 38.06, ["Fly|Ride"] = 144.16, ["Neon"] = 15.74, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 223.93, ["Mega"] = 120.62, ["Mega|Fly"] = 549.25, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 370.09, ["Fly"] = 638.02, ["Ride"] = 393.75, ["Fly|Ride"] = 431.82, ["Neon"] = 2094.01, ["Neon|Ride"] = 1624.24, ["Neon|Fly|Ride"] = 1495.51, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.54, ["Fly"] = 47.59, ["Ride"] = 16.88, ["Fly|Ride"] = 42.18, ["Neon"] = 24.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.35, ["Mega|Ride"] = 270.83, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.76, ["Fly"] = 31.71, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 27.49, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 99.3, ["Mega|Ride"] = 704.51, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.99, ["Fly"] = 84.56, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 19.04, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 105, ["Mega"] = 111.57, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 210, ["Ride"] = 70.26, ["Fly|Ride"] = 61.69, ["Neon"] = 118.27, ["Neon|Ride"] = 183.79, ["Neon|Fly|Ride"] = 210, ["Mega"] = 950.61, ["Mega|Ride"] = 843.93, ["Mega|Fly|Ride"] = 591.49}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 31.11, ["Fly|Ride"] = 62.36, ["Neon"] = 14.94, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.24, ["Mega|Ride"] = 197.53, ["Mega|Fly|Ride"] = 1313.18}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 10.39, ["Fly"] = 104.15, ["Ride"] = 28.5, ["Fly|Ride"] = 69.21, ["Neon"] = 81.15, ["Neon|Ride"] = 141.27, ["Mega|Ride"] = 611.56, ["Mega|Fly|Ride"] = 737.25}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.92, ["Neon"] = 3.94, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.75, ["Mega"] = 36.66, ["Mega|Ride"] = 132.86, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.78, ["Ride"] = 57.07, ["Neon"] = 59.07, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.44, ["Ride"] = 56.99, ["Neon"] = 86.45, ["Neon|Fly|Ride"] = 177.47, ["Mega"] = 328.13, ["Mega|Ride"] = 560.87, ["Mega|Fly|Ride"] = 465.81}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.64, ["Fly"] = 26.25, ["Ride"] = 27.36, ["Fly|Ride"] = 53.45, ["Neon"] = 51.19, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 62.16, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 591.49, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 372.92}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 181.13, ["Fly"] = 216.56, ["Ride"] = 209.9, ["Fly|Ride"] = 267.75, ["Neon"] = 864.1, ["Neon|Ride"] = 899.91, ["Neon|Fly|Ride"] = 915.75, ["Mega|Fly|Ride"] = 4210.1}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.49, ["Ride"] = 17.07, ["Fly|Ride"] = 48.51, ["Neon"] = 12.85, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 220.5, ["Mega|Ride"] = 164.78, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.82, ["Fly"] = 42.29, ["Ride"] = 36.2, ["Fly|Ride"] = 103.83, ["Neon"] = 15.65, ["Neon|Ride"] = 27.48, ["Neon|Fly|Ride"] = 160.06, ["Mega"] = 253.55, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 58.47, ["Ride"] = 236.24, ["Fly|Ride"] = 396.29, ["Neon"] = 144.38, ["Neon|Ride"] = 253.52, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 483.41, ["Mega|Ride"] = 539.2, ["Mega|Fly|Ride"] = 564.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 85.32, ["Fly"] = 168.83, ["Ride"] = 157.5, ["Fly|Ride"] = 261.18, ["Neon"] = 560.62, ["Neon|Ride"] = 465.81, ["Neon|Fly|Ride"] = 802.74, ["Mega"] = 1901.21, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1648.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 22.32, ["Ride"] = 77.44, ["Fly|Ride"] = 174.07, ["Neon"] = 91.88, ["Neon|Ride"] = 190.13, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 262.5, ["Mega|Ride"] = 337.32, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.23, ["Fly|Ride"] = 46.59, ["Neon"] = 10.18, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 65.5, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 7.77, ["Ride"] = 64.53, ["Neon"] = 78.32, ["Neon|Ride"] = 169.32, ["Mega"] = 295.75, ["Mega|Ride"] = 391.79, ["Mega|Fly|Ride"] = 418.27}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 81.36, ["Ride"] = 137.82, ["Fly|Ride"] = 126.82, ["Neon"] = 196.88, ["Neon|Ride"] = 280.97, ["Neon|Fly|Ride"] = 507.01, ["Mega"] = 557.24, ["Mega|Ride"] = 662.26, ["Mega|Fly|Ride"] = 671.76}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 8.39, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 60.38, ["Mega|Fly"] = 162.67, ["Mega|Ride"] = 108.35, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 8.46, ["Ride"] = 319.01, ["Neon"] = 84, ["Neon|Ride"] = 124.69, ["Mega"] = 421.76, ["Mega|Ride"] = 675.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1338.88, ["Ride"] = 956.82, ["Fly|Ride"] = 1069.69, ["Neon"] = 2362.5, ["Neon|Ride"] = 3591.15, ["Neon|Fly|Ride"] = 2901.44, ["Mega|Fly|Ride"] = 12534.38}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 31.38, ["Fly"] = 116.59, ["Ride"] = 111.56, ["Fly|Ride"] = 206.08, ["Neon"] = 177.19, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 528.12, ["Mega"] = 690.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 742.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.77, ["Fly"] = 49.18, ["Ride"] = 35.86, ["Fly|Ride"] = 105, ["Neon"] = 15.75, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 73.5, ["Mega|Ride"] = 106.94, ["Mega|Fly|Ride"] = 314.77}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 23.23, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Mega"] = 311.6, ["Mega|Ride"] = 553.88, ["Mega|Fly|Ride"] = 479.53}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 422.7, ["Neon"] = 3.84, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 105.45, ["Mega"] = 19.47, ["Mega|Fly"] = 37.05, ["Mega|Ride"] = 53.43, ["Mega|Fly|Ride"] = 549.25}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 86.73, ["Fly"] = 119.43, ["Ride"] = 140.44, ["Fly|Ride"] = 183.75, ["Neon"] = 282.17, ["Neon|Fly"] = 319.01, ["Neon|Ride"] = 383.61, ["Mega"] = 1210.64, ["Mega|Ride"] = 1150.52, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 3.94, ["Fly"] = 174.57, ["Ride"] = 37.7, ["Fly|Ride"] = 87.14, ["Neon"] = 35.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 352.79, ["Mega|Ride"] = 295.75, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 12.99, ["Neon|Ride"] = 90.76, ["Mega"] = 152.25, ["Mega|Ride"] = 239.77, ["Mega|Fly|Ride"] = 373.91}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 62.29, ["Ride"] = 90.57, ["Fly|Ride"] = 167.63, ["Neon"] = 196.88, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 1048.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 819.63}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.02, ["Ride"] = 52.5, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 315, ["Mega"] = 490.88, ["Mega|Ride"] = 583.05, ["Mega|Fly|Ride"] = 667.54}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 52.41, ["Neon"] = 779.63, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 1013.92, ["Mega"] = 2465.22, ["Mega|Ride"] = 1973.03, ["Mega|Fly|Ride"] = 1994.22}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.19, ["Neon"] = 24.09, ["Neon|Ride"] = 95.55, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 118.95, ["Mega|Ride"] = 157.75, ["Mega|Fly|Ride"] = 318.89}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.25, ["Fly"] = 32.15, ["Ride"] = 27.57, ["Fly|Ride"] = 57.07, ["Neon"] = 63.41, ["Neon|Ride"] = 97.19, ["Neon|Fly|Ride"] = 134.15, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 122.95, ["Ride"] = 176.49, ["Fly|Ride"] = 234.93, ["Neon"] = 573, ["Neon|Ride"] = 598.45, ["Neon|Fly|Ride"] = 704.51, ["Mega|Ride"] = 2304.83, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 18.27, ["Fly|Ride"] = 56.96, ["Neon"] = 14.32, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 59.99, ["Mega"] = 145.68, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 573.27}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 3.94, ["Fly"] = 87.94, ["Ride"] = 23.63, ["Fly|Ride"] = 78.59, ["Neon"] = 41.88, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 140.44, ["Mega|Ride"] = 207.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.8, ["Ride"] = 18.38, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 23.59, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 42.29, ["Neon"] = 3.94, ["Neon|Ride"] = 40.15, ["Mega"] = 22.05, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.44}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 27.49, ["Fly|Ride"] = 45.94, ["Neon"] = 22.71, ["Neon|Ride"] = 26.17, ["Mega"] = 141.56, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 44.54, ["Ride"] = 84, ["Neon"] = 522.38, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.63, ["Mega|Fly|Ride"] = 649.59}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 21.19, ["Ride"] = 19.58, ["Fly|Ride"] = 30.19, ["Neon"] = 12.53, ["Neon|Fly"] = 31.7, ["Neon|Ride"] = 25.02, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 91.68, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.29, ["Fly"] = 28.34, ["Ride"] = 22.32, ["Fly|Ride"] = 68.22, ["Neon"] = 16.31, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 147, ["Mega|Fly"] = 160.06, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 189.58}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.82, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 99.36, ["Neon"] = 9.19, ["Neon|Fly"] = 47.8, ["Neon|Ride"] = 23.9, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 103.39, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.75, ["Fly"] = 281.1, ["Ride"] = 24.86, ["Neon"] = 48.62, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.8, ["Mega"] = 224.21, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 350.68, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 10.5, ["Fly"] = 160.7, ["Ride"] = 66, ["Fly|Ride"] = 175.44, ["Neon"] = 98.59, ["Neon|Ride"] = 65.63, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 35.44, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 28.2, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 238.88, ["Mega|Ride"] = 282.02}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 16.77, ["Fly|Ride"] = 52.5, ["Neon"] = 15.73, ["Neon|Fly"] = 36.99, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 422.5, ["Mega|Ride"] = 80.04, ["Mega|Fly|Ride"] = 209.14}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 170.63, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 366.71, ["Neon"] = 980.65, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3522.49, ["Mega|Fly|Ride"] = 3504.05}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.09, ["Ride"] = 38.72, ["Neon"] = 34.67, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 123.38, ["Mega|Ride"] = 280.97}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Ride"] = 21.15, ["Fly|Ride"] = 118.13, ["Neon|Fly"] = 211.36, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 196.88, ["Mega|Ride"] = 273.58, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.65, ["Ride"] = 24.94, ["Neon"] = 47.25, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.78, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 20.88, ["Neon|Ride"] = 17.85, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 60.21, ["Mega|Fly|Ride"] = 84.51}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.93, ["Fly"] = 56.37, ["Ride"] = 26.25, ["Fly|Ride"] = 53.62, ["Neon"] = 19.04, ["Neon|Ride"] = 28.2, ["Neon|Fly|Ride"] = 69.54, ["Mega"] = 141.56, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 303.37}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 5.25, ["Ride"] = 57.07, ["Fly|Ride"] = 77.43, ["Neon"] = 10.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.11, ["Mega|Ride"] = 160.06, ["Mega|Fly|Ride"] = 303.37}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 62.34, ["Fly"] = 134.23, ["Ride"] = 84.56, ["Fly|Ride"] = 131.25, ["Neon"] = 493.5, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 352.33, ["Mega|Ride"] = 3522.49, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.98, ["Fly"] = 85.32, ["Ride"] = 25.2, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 137.37, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.71, ["Ride"] = 44.58, ["Fly|Ride"] = 118.13, ["Neon"] = 8.48, ["Neon|Ride"] = 126.76, ["Neon|Fly|Ride"] = 169.01, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 103.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 55.86, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 156.41, ["Neon"] = 220.5, ["Neon|Ride"] = 187.03, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 733.03, ["Mega|Ride"] = 580.94, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 17.85, ["Fly|Ride"] = 30.19, ["Neon"] = 2.63, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 50.71, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 60.29, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 27.38, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 190.13, ["Mega"] = 76.13, ["Mega|Ride"] = 137.32, ["Mega|Fly|Ride"] = 311.6}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.87, ["Fly"] = 141.62, ["Ride"] = 69.54, ["Fly|Ride"] = 132.57, ["Neon"] = 31.49, ["Neon|Fly"] = 135.19, ["Neon|Ride"] = 107.91, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 121.22, ["Mega|Fly"] = 211.26, ["Mega|Ride"] = 184.72, ["Mega|Fly|Ride"] = 312}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.63, ["Ride"] = 15.65, ["Fly|Ride"] = 33.69, ["Neon"] = 2.1, ["Neon|Fly"] = 28.69, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 24.81, ["Mega|Ride"] = 44.38, ["Mega|Fly|Ride"] = 129.92}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.91, ["Ride"] = 43.99, ["Fly|Ride"] = 235.81, ["Neon"] = 70.88, ["Neon|Ride"] = 166.9, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 422.5, ["Mega|Ride"] = 527.07, ["Mega|Fly|Ride"] = 662.26}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2887.5, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2441.25, ["Neon|Ride"] = 9858.73, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43832.93}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 40.17, ["Ride"] = 17.07, ["Fly|Ride"] = 62.36, ["Neon"] = 6.48, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 74.82, ["Mega|Fly"] = 471.09, ["Mega|Ride"] = 97.02, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 18.69, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 633.74}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.94, ["Ride"] = 35.44, ["Fly|Ride"] = 147.53, ["Neon"] = 85.97, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 552.42, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 55.13, ["Ride"] = 98.44, ["Neon"] = 187.69, ["Neon|Ride"] = 183.79, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 540.75, ["Mega|Ride"] = 739.28, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 178.5, ["Fly"] = 282.17, ["Ride"] = 189, ["Fly|Ride"] = 264.06, ["Neon"] = 591.78, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 704.51, ["Neon|Fly|Ride"] = 781.6, ["Mega"] = 6337.31, ["Mega|Ride"] = 3551.82, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.19, ["Fly"] = 28.54, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 18.38, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 224.44, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.32, ["Neon"] = 15.74, ["Neon|Fly"] = 98.44, ["Mega"] = 136.5, ["Mega|Ride"] = 261.24, ["Mega|Fly|Ride"] = 838.43}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 101.97, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 13.13, ["Neon|Ride"] = 90.85, ["Mega"] = 97.36, ["Mega|Ride"] = 123.94, ["Mega|Fly|Ride"] = 280.97}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 19.28, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 295.75, ["Mega"] = 374.06, ["Mega|Ride"] = 501.27, ["Mega|Fly|Ride"] = 647.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.82, ["Neon"] = 2.1, ["Neon|Ride"] = 38.22, ["Mega"] = 25.36, ["Mega|Ride"] = 64.51, ["Mega|Fly|Ride"] = 338}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.67, ["Ride"] = 91.88, ["Fly|Ride"] = 160.11, ["Neon"] = 295.89, ["Neon|Ride"] = 394.36, ["Neon|Fly|Ride"] = 507.01, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1662.49}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.41, ["Neon|Ride"] = 113.03, ["Mega"] = 39.38, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 55, ["Fly"] = 223.43, ["Ride"] = 79.68, ["Fly|Ride"] = 159.76, ["Neon"] = 295.32, ["Neon|Ride"] = 257.73, ["Neon|Fly|Ride"] = 561.75, ["Mega"] = 2625, ["Mega|Ride"] = 1705.46, ["Mega|Fly|Ride"] = 1256.07}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.5, ["Ride"] = 24.31, ["Fly|Ride"] = 49.88, ["Neon"] = 3.93, ["Neon|Fly"] = 121.54, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42.26, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.49}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.54, ["Neon"] = 12.5, ["Neon|Ride"] = 113.03, ["Mega"] = 82.69, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 7.5, ["Ride"] = 30.19, ["Fly|Ride"] = 141.62, ["Neon"] = 36.75, ["Mega"] = 229.17, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 413.44, ["Ride"] = 393.75, ["Fly|Ride"] = 509.25, ["Neon"] = 1232.44, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1429.32, ["Mega"] = 3944.97, ["Mega|Ride"] = 4140.62, ["Mega|Fly|Ride"] = 4082.95}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.43, ["Ride"] = 51.19, ["Fly|Ride"] = 64.32, ["Neon"] = 238.96, ["Neon|Fly"] = 319.01, ["Neon|Ride"] = 208.79, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 1055.17, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 26.84, ["Ride"] = 17.07, ["Fly|Ride"] = 91.88, ["Neon"] = 4.47, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 55.13, ["Mega|Ride"] = 75.01, ["Mega|Fly|Ride"] = 395.05}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.82, ["Fly"] = 72.1, ["Ride"] = 45.07, ["Fly|Ride"] = 119.44, ["Neon"] = 45.94, ["Neon|Fly"] = 282.02, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 229.69, ["Mega|Fly"] = 395.05, ["Mega|Ride"] = 285.71, ["Mega|Fly|Ride"] = 404.91}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.55, ["Ride"] = 27.57, ["Fly|Ride"] = 105.69, ["Neon"] = 125.99, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 389.69, ["Mega|Fly|Ride"] = 447.85}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.19, ["Neon"] = 15.39, ["Neon|Ride"] = 52.5, ["Mega"] = 49.88, ["Mega|Ride"] = 139.12, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.67, ["Fly|Ride"] = 52.59, ["Neon"] = 26.25, ["Neon|Ride"] = 46.19, ["Neon|Fly|Ride"] = 215.49, ["Mega"] = 557.74, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 115.14, ["Fly"] = 131.25, ["Ride"] = 131.25, ["Fly|Ride"] = 167.64, ["Neon|Ride"] = 541.98, ["Neon|Fly|Ride"] = 843.55, ["Mega"] = 2676.47, ["Mega|Ride"] = 2816.93, ["Mega|Fly|Ride"] = 3095.78}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.24, ["Fly"] = 95.82, ["Ride"] = 99.12, ["Fly|Ride"] = 159.7, ["Neon"] = 192.94, ["Neon|Ride"] = 204.92, ["Mega"] = 843.93, ["Mega|Ride"] = 718.25, ["Mega|Fly|Ride"] = 735.39}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2393.37, ["Fly"] = 2349.37, ["Ride"] = 2310, ["Fly|Ride"] = 2152.5, ["Neon"] = 12680.74, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 8.4, ["Neon|Ride"] = 109.47, ["Neon|Fly|Ride"] = 168, ["Mega"] = 125.97, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 12.47, ["Ride"] = 83.86, ["Fly|Ride"] = 156.41, ["Neon"] = 57.06, ["Neon|Ride"] = 111.97, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 255.94, ["Mega|Ride"] = 704.51, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 971.25, ["Fly"] = 1409.69, ["Ride"] = 940.5, ["Fly|Ride"] = 997.49, ["Neon"] = 2445.65, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2390.07, ["Mega|Fly|Ride"] = 9450}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 51.19, ["Ride"] = 74.82, ["Fly|Ride"] = 210, ["Neon"] = 282.17, ["Neon|Ride"] = 289.42, ["Mega"] = 837.31, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 994.96}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 14, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 135.21, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Ride"] = 23.26, ["Neon"] = 4.61, ["Neon|Ride"] = 56.44, ["Mega"] = 27.83, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 111.57, ["Ride"] = 125.99, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 1973.03, ["Mega|Fly|Ride"] = 2676.47}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.28, ["Neon"] = 21, ["Neon|Ride"] = 90.57, ["Mega|Ride"] = 169.02, ["Mega|Fly|Ride"] = 366.66}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76, ["Ride"] = 97.63, ["Fly|Ride"] = 219.81, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1831.5, ["Mega|Fly|Ride"] = 1669.57}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.64, ["Fly"] = 105, ["Fly|Ride"] = 113.08, ["Neon"] = 33.15, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 318.89, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 223.13, ["Ride"] = 291.37, ["Fly|Ride"] = 351.75, ["Neon"] = 989.1, ["Neon|Ride"] = 1012.92, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4084.4}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.7, ["Fly"] = 87.83, ["Ride"] = 28.88, ["Fly|Ride"] = 54.43, ["Neon"] = 21, ["Neon|Ride"] = 59.16, ["Neon|Fly|Ride"] = 104.96, ["Mega"] = 229.57, ["Mega|Ride"] = 296.2, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.51, ["Fly|Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Fly"] = 19.06, ["Neon|Ride"] = 26.14, ["Neon|Fly|Ride"] = 59.16, ["Mega"] = 61.03, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 62.87, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 836.75, ["Fly"] = 1194.77, ["Ride"] = 903, ["Fly|Ride"] = 1051.46, ["Neon|Ride"] = 5016.01, ["Neon|Fly|Ride"] = 4752.99, ["Mega"] = 28662.88, ["Mega|Fly|Ride"] = 28166.1}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.13, ["Fly"] = 986.99, ["Ride"] = 56.7, ["Neon"] = 35.17, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 70.2, ["Mega"] = 179.54, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.8, ["Fly"] = 35.44, ["Ride"] = 31.5, ["Fly|Ride"] = 112.32, ["Neon"] = 23.63, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.82, ["Fly"] = 40.51, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon"] = 165.38, ["Neon|Ride"] = 211.26, ["Neon|Fly|Ride"] = 183.79, ["Mega"] = 2112.45, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 79.27, ["Ride"] = 33.66, ["Fly|Ride"] = 63, ["Neon"] = 65.83, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 141.31, ["Mega"] = 288.75, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.12, ["Ride"] = 210, ["Fly|Ride"] = 341.34, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 486.18, ["Mega|Ride"] = 522.84, ["Mega|Fly|Ride"] = 612.63}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 238.6, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Mega"] = 21.1, ["Mega|Fly"] = 86.01, ["Mega|Ride"] = 41.62}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 35.37, ["Fly"] = 74.8, ["Ride"] = 47.2, ["Fly|Ride"] = 70.7, ["Neon"] = 300.98, ["Neon|Fly"] = 307.53, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 3379.9, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 25.83, ["Ride"] = 20.98, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 141.56, ["Mega"] = 773.07, ["Mega|Ride"] = 274.98, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 20.5, ["Fly|Ride"] = 36.75, ["Neon"] = 18.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.16, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 844.98, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 295.75, ["Mega|Fly|Ride"] = 477.73}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 26.45, ["Fly"] = 262.36, ["Ride"] = 87.28, ["Fly|Ride"] = 144.38, ["Neon"] = 118.13, ["Neon|Fly"] = 311.75, ["Neon|Ride"] = 194.36, ["Neon|Fly|Ride"] = 207.03, ["Mega"] = 656.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.16, ["Ride"] = 19.69, ["Neon"] = 24.86, ["Neon|Ride"] = 73.95, ["Neon|Fly|Ride"] = 128.87, ["Mega"] = 86.46, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 272.07}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.43, ["Neon"] = 2.63, ["Neon|Ride"] = 28.53, ["Mega"] = 20.94, ["Mega|Ride"] = 52.37, ["Mega|Fly|Ride"] = 204.65}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 70.82, ["Ride"] = 20.98, ["Neon"] = 3.94, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 21.11, ["Mega"] = 18.35, ["Mega|Fly"] = 73.95, ["Mega|Ride"] = 126.76, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.06, ["Fly|Ride"] = 49.69, ["Neon"] = 11.96, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.51, ["Neon|Fly|Ride"] = 76.06, ["Mega"] = 83.89, ["Mega|Ride"] = 160.06, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5376.28, ["Neon"] = 15.86, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 183.79}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.04, ["Fly|Ride"] = 41.32, ["Neon"] = 16.93, ["Neon|Fly"] = 52.83, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 281.54, ["Mega|Ride"] = 278.24, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 77.67, ["Ride"] = 131.25, ["Fly|Ride"] = 422.7, ["Neon"] = 241.5, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1056.23, ["Mega"] = 1094.86, ["Mega|Ride"] = 821.69, ["Mega|Fly|Ride"] = 1126.99}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 19.92, ["Fly|Ride"] = 28.54, ["Neon"] = 3.84, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 23.05, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 59.07, ["Mega|Ride"] = 65.5, ["Mega|Fly|Ride"] = 104.97}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 13.01, ["Fly"] = 62.91, ["Ride"] = 56.96, ["Fly|Ride"] = 99.36, ["Neon"] = 52.49, ["Neon|Fly"] = 83.66, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 103.91, ["Mega"] = 844.98, ["Mega|Ride"] = 268.68, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.37, ["Fly"] = 36.75, ["Ride"] = 27.57, ["Fly|Ride"] = 70.82, ["Neon"] = 72.19, ["Neon|Fly"] = 94.4, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1056.23, ["Mega|Ride"] = 420.39, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.63, ["Fly"] = 140.38, ["Ride"] = 21.15, ["Neon"] = 21, ["Neon|Ride"] = 70.79, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 379.2}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 43.29, ["Neon"] = 4.25, ["Neon|Fly"] = 41.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 45.92, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 105.34}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.63, ["Fly"] = 78.22, ["Ride"] = 28.25, ["Fly|Ride"] = 141.39, ["Neon"] = 23.9, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 69.74, ["Neon|Fly|Ride"] = 158.45, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.97}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 905.63, ["Fly"] = 1282.88, ["Ride"] = 968.63, ["Fly|Ride"] = 1023.75, ["Neon"] = 2625, ["Neon|Fly"] = 2873.26, ["Neon|Ride"] = 2745.11, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 7464.28}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.07, ["Fly"] = 160.11, ["Ride"] = 94.5, ["Neon"] = 262.5, ["Neon|Ride"] = 321.96, ["Neon|Fly|Ride"] = 462.63, ["Mega"] = 1673.06, ["Mega|Ride"] = 1570.61, ["Mega|Fly|Ride"] = 1338.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 12.9, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 197.53, ["Mega"] = 69.74}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 30.19, ["Ride"] = 68.25, ["Fly|Ride"] = 160.11, ["Neon"] = 186.38, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 253.52, ["Mega"] = 1023.75, ["Mega|Ride"] = 1515.94, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.11, ["Ride"] = 119.49, ["Fly|Ride"] = 156.19, ["Neon"] = 55.23, ["Neon|Ride"] = 280.93, ["Neon|Fly|Ride"] = 280.97, ["Mega"] = 479.53, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 261.1, ["Fly"] = 422.7, ["Ride"] = 288.75, ["Fly|Ride"] = 314.23, ["Neon|Ride"] = 1036.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5492.33}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 15.75, ["Neon|Ride"] = 53.9, ["Mega"] = 401.21, ["Mega|Fly"] = 282.02}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.9, ["Neon|Ride"] = 38.04, ["Mega"] = 338}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 53.45, ["Ride"] = 32.82, ["Fly|Ride"] = 282.17, ["Neon"] = 262.5, ["Neon|Ride"] = 327.45, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Neon"] = 13.55, ["Neon|Ride"] = 45.93, ["Mega"] = 282.02, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.93, ["Ride"] = 15.65, ["Fly|Ride"] = 32.48, ["Neon"] = 3.68, ["Neon|Fly"] = 32.27, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 32.26, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 42.26, ["Mega|Fly|Ride"] = 89.77}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 4332.56, ["Neon"] = 27474.91, ["Neon|Fly|Ride"] = 22533.3, ["Mega|Fly|Ride"] = 56332.17}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.6, ["Ride"] = 56.43, ["Neon"] = 56.44, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 126.76, ["Mega"] = 408.77, ["Mega|Ride"] = 376.02, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 22.32, ["Fly|Ride"] = 60.37, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 229.53, ["Mega|Ride"] = 166, ["Mega|Fly|Ride"] = 264.07}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 413.51, ["Fly"] = 519.92, ["Ride"] = 459.38, ["Fly|Ride"] = 510.56, ["Neon"] = 1312.5, ["Neon|Ride"] = 1338.25, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 5069.85}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.6, ["Ride"] = 28.54, ["Neon"] = 17.07, ["Neon|Ride"] = 145.68, ["Mega"] = 124.59, ["Mega|Fly|Ride"] = 342.77}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.81, ["Fly"] = 4106.07, ["Ride"] = 950.01, ["Neon"] = 141.62, ["Neon|Ride"] = 282.02, ["Neon|Fly|Ride"] = 14083.58, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.07, ["Fly|Ride"] = 82.55, ["Neon"] = 7.87, ["Neon|Fly"] = 124.67, ["Neon|Ride"] = 38.04, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 52.83, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 637.88, ["Ride"] = 608.88, ["Fly|Ride"] = 644.28, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 9154.22}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.22, ["Ride"] = 59.07, ["Neon"] = 25.99, ["Neon|Ride"] = 95.55, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 148.32, ["Mega|Ride"] = 201.24, ["Mega|Fly|Ride"] = 330.44}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.21, ["Fly"] = 235.55, ["Ride"] = 47.18, ["Neon"] = 47.99, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 243.64, ["Mega|Ride"] = 248.97}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 21.09, ["Fly|Ride"] = 127.85, ["Neon"] = 15.74, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 69.55, ["Mega"] = 289.43, ["Mega|Ride"] = 160.06, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.69, ["Ride"] = 92.4, ["Neon"] = 91.88, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 318.89, ["Mega"] = 522.84, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 527.07}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 34.92, ["Mega|Ride"] = 87.69, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 429.19, ["Ride"] = 450.8, ["Fly|Ride"] = 528.38, ["Neon"] = 1837.5, ["Neon|Ride"] = 2429.31, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9315.45, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.76, ["Fly|Ride"] = 333.95, ["Neon"] = 14.17, ["Neon|Ride"] = 86.88, ["Neon|Fly|Ride"] = 152.11, ["Mega"] = 61.28, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 308.43}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 5.12, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 209.85, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 46.23, ["Mega|Fly"] = 99.3, ["Mega|Ride"] = 99.3, ["Mega|Fly|Ride"] = 211.26}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 3.94, ["Neon|Ride"] = 45.91, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 41.13, ["Mega|Fly"] = 156.33, ["Mega|Ride"] = 90.57}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 25.38, ["Neon|Ride"] = 70.79, ["Mega"] = 231.33, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 70.82, ["Fly"] = 118.13, ["Ride"] = 116.82, ["Fly|Ride"] = 232.32, ["Neon"] = 248.07, ["Neon|Ride"] = 336, ["Neon|Fly|Ride"] = 1593.2, ["Mega"] = 950.61, ["Mega|Ride"] = 950.61, ["Mega|Fly|Ride"] = 897.46}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.69, ["Fly"] = 69.47, ["Ride"] = 65.55, ["Fly|Ride"] = 112.11, ["Neon"] = 115.5, ["Neon|Ride"] = 208.79, ["Mega"] = 463.31, ["Mega|Ride"] = 453, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.4, ["Fly"] = 40.17, ["Ride"] = 18.38, ["Fly|Ride"] = 49.87, ["Neon"] = 30.38, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 35.05, ["Neon|Fly|Ride"] = 76.57, ["Mega"] = 394.42, ["Mega|Ride"] = 183.79, ["Mega|Fly|Ride"] = 259.84}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.34, ["Ride"] = 64.32, ["Fly|Ride"] = 79.27, ["Neon"] = 141.62, ["Neon|Ride"] = 159.51, ["Mega"] = 333.78, ["Mega|Ride"] = 796.61, ["Mega|Fly|Ride"] = 984.41}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.62, ["Fly"] = 261.02, ["Ride"] = 28.49, ["Fly|Ride"] = 84.56, ["Neon"] = 30.98, ["Neon|Ride"] = 66.94, ["Mega"] = 168, ["Mega|Ride"] = 371.8, ["Mega|Fly|Ride"] = 502.78}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.61, ["Fly"] = 69.76, ["Ride"] = 30.18, ["Fly|Ride"] = 56.23, ["Neon"] = 228.74, ["Neon|Ride"] = 197.53, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 949.55, ["Mega|Ride"] = 955.44, ["Mega|Fly|Ride"] = 733.03}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 64.43, ["Fly"] = 874.13, ["Ride"] = 84.56, ["Neon|Ride"] = 477.73, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.14, ["Fly"] = 115.5, ["Ride"] = 82.69, ["Fly|Ride"] = 139.12, ["Neon"] = 236.25, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 359.14, ["Mega"] = 1161.85, ["Mega|Ride"] = 1140.87, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.5, ["Fly"] = 88.15, ["Ride"] = 81.38, ["Neon"] = 156.03, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 513.72, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 580.7}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.17, ["Ride"] = 57.07, ["Neon"] = 125.98, ["Mega"] = 559.13, ["Mega|Ride"] = 775.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 8.39, ["Fly"] = 31.28, ["Ride"] = 28.25, ["Fly|Ride"] = 78.75, ["Neon"] = 49.88, ["Neon|Fly"] = 169.1, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 387.64, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 16.96, ["Fly|Ride"] = 42, ["Neon"] = 4.99, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 59.05, ["Mega|Fly"] = 211.26, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 23.62, ["Ride"] = 70.5, ["Fly|Ride"] = 131.25, ["Neon"] = 139.13, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 299.98, ["Mega"] = 479.53, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.88, ["Neon"] = 3.93, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 295.75, ["Mega"] = 48.6, ["Mega|Ride"] = 89.94, ["Mega|Fly|Ride"] = 548.19}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.68, ["Fly"] = 112.32, ["Ride"] = 71.7, ["Neon"] = 208.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.75, ["Mega|Ride"] = 986.52, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 4.79, ["Neon|Ride"] = 105, ["Mega"] = 78.75}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.79, ["Neon|Ride"] = 160.06, ["Mega"] = 26.25, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 126.92, ["Ride"] = 196.88, ["Fly|Ride"] = 238.96, ["Neon"] = 426.57, ["Neon|Fly"] = 628.44, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6568.59, ["Mega|Fly|Ride"] = 1874.76}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 21.15, ["Fly|Ride"] = 71.46, ["Neon"] = 16.93, ["Neon|Fly"] = 63.41, ["Neon|Ride"] = 35.33, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 91.88, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 40.64, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 6.57, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 47.25, ["Mega|Ride"] = 105.65, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.82, ["Mega|Ride"] = 223.05, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 30.31, ["Mega"] = 39.38, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.3, ["Ride"] = 111.57, ["Fly|Ride"] = 1056.75, ["Neon"] = 268.43, ["Neon|Ride"] = 408.77, ["Neon|Fly|Ride"] = 318.89, ["Mega"] = 1549.49, ["Mega|Ride"] = 1549.49, ["Mega|Fly|Ride"] = 1274.32}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.68, ["Ride"] = 36.53, ["Neon"] = 31.29, ["Neon|Ride"] = 91.9, ["Mega"] = 141.56, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 375.61, ["Ride"] = 408.13, ["Fly|Ride"] = 616.88, ["Neon"] = 1409.69, ["Neon|Ride"] = 955.44, ["Neon|Fly|Ride"] = 1267.47, ["Mega|Ride"] = 3802.39, ["Mega|Fly|Ride"] = 3490.83}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.63}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.92}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 19.67}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.49}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 34.92}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 7.28}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.87}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.42}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 55.92}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.13}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 219.48}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.97}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.99}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.28}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.73}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 441.19}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.85}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1441.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 32.8}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.35}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.64}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 20.07}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.61}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 12.96}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.83}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.48}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.81}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 45.93}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.87}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1706.25}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 84.67}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.44}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.45}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 171.36}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.97}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.7}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 996.11}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 16.7}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.56}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.74}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.12}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 147}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.38}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.4}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.94}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.71}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 236.25}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 136.5}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.33}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.98}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 23.62}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.32}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 64.93}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22666.1}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.74}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 31.67}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 72.17}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 62.91}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 209.9}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 126.62}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 73.84}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.91}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 393.75}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.36}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.34}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 20.98}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 48.54}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 984.38}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.36}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 633.05}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 31.5}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.72}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 52.5}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 37.59}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 223.69}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.06}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.91}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.83}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.84}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 169.31}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1012.88}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.66}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.24}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 12.74}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 87.94}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 10.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.86}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.07}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 13.6}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 104.81}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 25.87}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.42}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.57}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.3}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 37.59}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.39}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.7}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.92}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.47}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.24}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.59}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 35.8}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.92}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.84}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2622.9}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.65}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.75}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.82}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 281.72}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.75}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 15.74}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.56}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 8.65}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.27}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.68}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.66}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 176.44}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.56}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.44}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 76.95}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.34}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.86}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 19.45}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 945}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 20.77}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 5.16}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.56}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.76}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.25}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.72}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 17.85}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 9.18}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 48.57}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.92}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.82}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63.4}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.52}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 3.98}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 24.46}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.9}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 13.84}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.29}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.05}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.25}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 11.43}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 105}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1127.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 141.4}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.35}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 39.38}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.82}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 72.19}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.43}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.99}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.93}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 4.9}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 37.41}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.5}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.91}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 94.49}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 66.94}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.99}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.82}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 70.7}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 91.88}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 177.19}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 354.38}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.25}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 252.17}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.73}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.63}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.29}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 37.7}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.8}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 14.05}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 7.33}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 7.67}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 32.31}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.01}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 29.19}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1637.48}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 4.64}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 78.75}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 258.09}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.44}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.06}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 162.08}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.38}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.56}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.75}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1643.9}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 172.08}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 4.99}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1312.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 393.75}},
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