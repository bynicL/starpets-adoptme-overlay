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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1395.11, ["Ride"] = 1193.07, ["Fly|Ride"] = 1675.77, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25167.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 392.02, ["Fly"] = 545.05, ["Ride"] = 405.7, ["Fly|Ride"] = 523.78, ["Neon|Ride"] = 2202.21, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8389.33}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4935, ["Fly|Ride"] = 4724.99, ["Neon"] = 25867.38, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 66416.03}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 116.82, ["Ride"] = 175.07, ["Fly|Ride"] = 257.34, ["Neon"] = 832.65, ["Neon|Ride"] = 762.39, ["Neon|Fly|Ride"] = 755.14, ["Mega"] = 3775.67, ["Mega|Fly|Ride"] = 2848.13}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 549.94, ["Fly"] = 657.2, ["Ride"] = 538.63, ["Fly|Ride"] = 539.44, ["Neon|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 1530.38, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.49, ["Ride"] = 31.5, ["Fly|Ride"] = 140.54, ["Neon"] = 70.27, ["Neon|Fly"] = 125.86, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 275.13, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 414.24}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 28.88, ["Ride"] = 28.25, ["Fly|Ride"] = 73.34, ["Neon"] = 27.98, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 58.68, ["Neon|Fly|Ride"] = 110.17, ["Mega"] = 196.83, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 158.15, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 127.32, ["Fly"] = 196.02, ["Ride"] = 160, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 528.54, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 1888.07, ["Mega|Fly|Ride"] = 2223.19}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 37.22, ["Fly"] = 141.51, ["Ride"] = 56.62, ["Fly|Ride"] = 74.82, ["Neon"] = 223.13, ["Neon|Ride"] = 202.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 31.86, ["Fly"] = 35.4, ["Ride"] = 32.82, ["Fly|Ride"] = 76.13, ["Neon"] = 195.89, ["Neon|Ride"] = 315.07, ["Neon|Fly|Ride"] = 209.77, ["Mega|Ride"] = 754.09, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 66.92, ["Ride"] = 95.34, ["Fly|Ride"] = 127.32, ["Neon"] = 500.33, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 313.61, ["Mega|Fly|Ride"] = 1482.81}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 97.01}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 376.69, ["Ride"] = 393.75, ["Fly|Ride"] = 420, ["Neon|Fly|Ride"] = 1678.08, ["Mega|Fly|Ride"] = 8389.33}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 131.25, ["Ride"] = 112.18, ["Fly|Ride"] = 158.1, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2615.39}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.28, ["Fly"] = 116.37, ["Ride"] = 32.51, ["Fly|Ride"] = 209.67, ["Neon"] = 19.71, ["Neon|Ride"] = 63.73, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 129.94, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.4, ["Fly"] = 186.59, ["Ride"] = 167.74, ["Fly|Ride"] = 206.07, ["Neon"] = 699.48, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 589.32, ["Mega|Fly|Ride"] = 1903}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.68, ["Fly"] = 25.17, ["Ride"] = 19.69, ["Fly|Ride"] = 41.96, ["Neon"] = 39.38, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 293.64}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 65.62, ["Fly"] = 262.5, ["Ride"] = 98.34, ["Fly|Ride"] = 237.57, ["Neon"] = 157.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 414.75, ["Mega"] = 1395.3, ["Mega|Ride"] = 837.82, ["Mega|Fly|Ride"] = 879.84}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 72.19, ["Ride"] = 196.88, ["Fly|Ride"] = 337.98, ["Neon"] = 787.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 13.12, ["Fly"] = 374.07, ["Ride"] = 26.25, ["Fly|Ride"] = 104.88, ["Neon"] = 142.51, ["Neon|Ride"] = 343.98, ["Neon|Fly|Ride"] = 182.52, ["Mega"] = 699.57, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1677.88}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly"] = 64.32, ["Ride"] = 47.18, ["Fly|Ride"] = 122.07, ["Neon"] = 683.74, ["Neon|Fly"] = 312.53, ["Neon|Ride"] = 208.7, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1652.06, ["Mega|Fly|Ride"] = 750.98}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.38, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 138.38, ["Neon"] = 204.74, ["Neon|Fly"] = 391.77, ["Neon|Ride"] = 280.01, ["Neon|Fly|Ride"] = 314.65, ["Mega"] = 1236.54, ["Mega|Ride"] = 1254.38, ["Mega|Fly|Ride"] = 1258.57}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 40.87, ["Fly"] = 63.71, ["Ride"] = 57.75, ["Fly|Ride"] = 125.86, ["Neon"] = 192.96, ["Neon|Ride"] = 287.35, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 65.63, ["Fly"] = 587.65, ["Ride"] = 78.75, ["Fly|Ride"] = 135.19, ["Neon"] = 276.13, ["Neon|Ride"] = 309.69, ["Mega|Ride"] = 979.58, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.57, ["Fly"] = 31.5, ["Ride"] = 23.47, ["Fly|Ride"] = 51.19, ["Neon"] = 36.71, ["Neon|Fly"] = 58.74, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 135.19, ["Mega|Fly"] = 165.38, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 264.55}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 335.43, ["Ride"] = 352.87, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1608.86, ["Mega"] = 12585.5, ["Mega|Fly|Ride"] = 7319.68}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.78, ["Ride"] = 32.82, ["Fly|Ride"] = 105.18, ["Neon"] = 217.88, ["Neon|Ride"] = 406.9, ["Neon|Fly|Ride"] = 459.39, ["Mega"] = 825.41, ["Mega|Ride"] = 708.04, ["Mega|Fly|Ride"] = 829.52}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.83, ["Fly"] = 38.67, ["Ride"] = 27.23, ["Fly|Ride"] = 56.62, ["Neon"] = 52.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 108.94, ["Mega|Ride"] = 839.05, ["Mega|Fly|Ride"] = 409.48}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 100.99, ["Fly"] = 140.31, ["Ride"] = 121.53, ["Fly|Ride"] = 167.21, ["Neon"] = 472.01, ["Neon|Ride"] = 462.57, ["Neon|Fly|Ride"] = 440.91, ["Mega"] = 1936.08, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1915.93}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.15, ["Fly"] = 32.5, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 140.54, ["Neon|Ride"] = 133.2, ["Neon|Fly|Ride"] = 158.81, ["Mega"] = 708.04, ["Mega|Fly|Ride"] = 677.23}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 354.29, ["Ride"] = 209.67, ["Fly|Ride"] = 292.59, ["Neon"] = 944, ["Neon|Ride"] = 880.89, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6292.76, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.17}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 31.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.34, ["Fly"] = 33.55, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 22.32, ["Neon|Fly"] = 51.19, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 151.05, ["Mega"] = 131.23, ["Mega|Fly"] = 282.96, ["Mega|Ride"] = 203.48, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1240.32, ["Fly"] = 4593.75, ["Ride"] = 1181.25, ["Fly|Ride"] = 1443.75, ["Neon"] = 7021.88, ["Neon|Ride"] = 5643.75, ["Neon|Fly|Ride"] = 5250, ["Mega"] = 25171, ["Mega|Ride"] = 53101.39, ["Mega|Fly|Ride"] = 20973.27}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 4.73, ["Fly"] = 36.7, ["Ride"] = 27.57, ["Fly|Ride"] = 87.94, ["Neon"] = 108.03, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 511.88, ["Mega|Ride"] = 616.7, ["Mega|Fly|Ride"] = 657.53}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 119.44, ["Ride"] = 141.46, ["Fly|Ride"] = 259.81, ["Neon"] = 656.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2725.82, ["Mega|Fly|Ride"] = 2726.88}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.14}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 26.25, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 140.49, ["Neon"] = 210, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 739.77}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 106.32, ["Ride"] = 144.38, ["Fly|Ride"] = 209.53, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 629.29, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 118.12, ["Ride"] = 158.05, ["Fly|Ride"] = 196.88, ["Neon"] = 435.22, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 42}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 93.5, ["Ride"] = 59.07, ["Fly|Ride"] = 77.44, ["Neon"] = 356.56, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 4195.17, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.5, ["Ride"] = 26.13, ["Fly|Ride"] = 158.37, ["Neon"] = 52.5, ["Neon|Ride"] = 70.19, ["Neon|Fly|Ride"] = 233.89, ["Mega"] = 209.77, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.61, ["Fly"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 1801.95, ["Neon|Fly|Ride"] = 1276.52, ["Mega|Fly|Ride"] = 6011.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 78.75, ["Fly"] = 59.07, ["Ride"] = 103.8, ["Fly|Ride"] = 133.2, ["Neon"] = 367.5, ["Neon|Ride"] = 376.48, ["Neon|Fly|Ride"] = 369.02, ["Mega|Ride"] = 1874.2, ["Mega|Fly|Ride"] = 1915.93}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3185.44, ["Fly"] = 3543.75, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 14682.04}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42, ["Fly"] = 112.17, ["Ride"] = 56.58, ["Fly|Ride"] = 95.82, ["Neon"] = 392.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 251.72, ["Mega|Ride"] = 1629.84, ["Mega|Fly|Ride"] = 1399.11}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 65.63, ["Ride"] = 80.24, ["Fly|Ride"] = 189, ["Neon"] = 656.25, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 560.07, ["Mega"] = 6292.76, ["Mega|Fly|Ride"] = 2087.9}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 39.84, ["Fly"] = 56.62, ["Ride"] = 73.5, ["Fly|Ride"] = 137.24, ["Neon"] = 144.37, ["Neon|Ride"] = 194.85, ["Neon|Fly|Ride"] = 209.73, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.91}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 58.65, ["Ride"] = 56.39, ["Fly|Ride"] = 116.38, ["Neon"] = 328.13, ["Neon|Ride"] = 481.36, ["Neon|Fly|Ride"] = 502.39, ["Mega|Fly|Ride"] = 1559.37}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.91}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 167.72, ["Fly"] = 309.23, ["Ride"] = 231.68, ["Fly|Ride"] = 335.25, ["Neon|Ride"] = 1258.16, ["Neon|Fly|Ride"] = 1594.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 955.5, ["Fly|Ride"] = 918.75, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 13773.15}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.61, ["Fly"] = 52.43, ["Ride"] = 35.65, ["Fly|Ride"] = 63, ["Neon"] = 162.75, ["Neon|Fly"] = 125.86, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 208.69, ["Mega|Ride"] = 870.75, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.45}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4670.16, ["Fly"] = 5995.44, ["Ride"] = 6289.68, ["Fly|Ride"] = 4443.87, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 40535.03}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 14.44, ["Fly"] = 74.64, ["Ride"] = 26.25, ["Fly|Ride"] = 52.49, ["Neon"] = 69.57, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 137.55, ["Mega"] = 462.53, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 577.89}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.82, ["Fly"] = 191.66, ["Ride"] = 30.11, ["Fly|Ride"] = 116.81, ["Neon"] = 85.32, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1048.81, ["Mega|Ride"] = 557.97, ["Mega|Fly|Ride"] = 940.67}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 98.54, ["Fly"] = 139.21, ["Ride"] = 85.93, ["Fly|Ride"] = 125.86, ["Neon"] = 1398.93, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4195.17}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 14.13, ["Ride"] = 28.88, ["Fly|Ride"] = 139.65, ["Neon"] = 44.01, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 365.01, ["Mega|Ride"] = 417.43, ["Mega|Fly|Ride"] = 489.74}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2163, ["Fly"] = 3075.3, ["Ride"] = 2511.7, ["Fly|Ride"] = 1942.5, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 31444.54, ["Fly"] = 35227.07, ["Ride"] = 34608.11, ["Fly|Ride"] = 22916.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195750.79}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.36, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 110.93, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 839.05, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 817.97}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.82, ["Ride"] = 41.9, ["Fly|Ride"] = 104.85, ["Neon"] = 18.88, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.74, ["Mega"] = 158.82, ["Mega|Ride"] = 153.57, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.96}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 45.05, ["Fly|Ride"] = 111.57, ["Neon"] = 52.45, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 415.74, ["Mega|Ride"] = 472.03, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 787.5, ["Ride"] = 742.51, ["Fly|Ride"] = 780.94, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2629.33, ["Mega|Fly|Ride"] = 11012.55}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.49, ["Fly"] = 900.38, ["Ride"] = 840, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 11319.29}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.69, ["Fly"] = 72.19, ["Ride"] = 48.2, ["Fly|Ride"] = 78.75, ["Neon"] = 267.87, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 970.47, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 838.94}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 19.57}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 70.19, ["Fly"] = 162.78, ["Ride"] = 83.88, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 419.48, ["Neon|Fly|Ride"] = 412.13, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 56.62, ["Ride"] = 83.88, ["Fly|Ride"] = 131.25, ["Neon"] = 450.19, ["Neon|Ride"] = 630.11, ["Neon|Fly|Ride"] = 503.44, ["Mega"] = 2113.55, ["Mega|Fly|Ride"] = 1689.41}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.83, ["Fly"] = 32.79, ["Ride"] = 20.79, ["Fly|Ride"] = 53.82, ["Neon"] = 28.88, ["Neon|Fly"] = 315.07, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 236.25, ["Mega|Ride"] = 398.55, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 85.32, ["Fly"] = 98.34, ["Ride"] = 102.38, ["Fly|Ride"] = 157.58, ["Neon"] = 811.68, ["Neon|Ride"] = 284.81, ["Neon|Fly|Ride"] = 339.94, ["Mega|Fly|Ride"] = 1100.7}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.89, ["Ride"] = 45.47, ["Fly|Ride"] = 262.5, ["Neon"] = 23.63, ["Neon|Ride"] = 98.59, ["Mega"] = 190.32, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 20.97, ["Fly"] = 40.3, ["Ride"] = 32.82, ["Fly|Ride"] = 94.41, ["Neon"] = 72.19, ["Neon|Fly"] = 104.88, ["Neon|Ride"] = 125.86, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 741.51, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 24.66, ["Ride"] = 69.2, ["Fly|Ride"] = 156.19, ["Neon"] = 216.04, ["Neon|Ride"] = 183.53, ["Mega|Ride"] = 551.09, ["Mega|Fly|Ride"] = 874.6}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.05, ["Fly"] = 77.33, ["Ride"] = 39.84, ["Fly|Ride"] = 82.69, ["Neon"] = 70.27, ["Neon|Fly"] = 560, ["Neon|Ride"] = 120.62, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1048.81, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6288.93, ["Ride"] = 6864.38, ["Fly|Ride"] = 5250, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 24122.21}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 247.96, ["Fly"] = 263.1, ["Ride"] = 249.38, ["Fly|Ride"] = 308.31, ["Neon"] = 657.53, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 591.86, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.48, ["Fly"] = 117.96, ["Ride"] = 72.19, ["Fly|Ride"] = 124.21, ["Neon"] = 72.19, ["Neon|Fly"] = 158.13, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 302.91, ["Mega|Fly"] = 383.87, ["Mega|Ride"] = 322.49, ["Mega|Fly|Ride"] = 406.86}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.93, ["Fly"] = 41.94, ["Ride"] = 24.12, ["Fly|Ride"] = 91.25, ["Neon"] = 28.3, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 190.89, ["Mega"] = 158.15}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 36.67, ["Fly"] = 5285.8, ["Ride"] = 98.44, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Fly"] = 310.43, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 245.03, ["Mega"] = 418.68, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 12468.75, ["Fly|Ride"] = 11141.82, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 90884.49}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 126, ["Ride"] = 210, ["Fly|Ride"] = 280.01, ["Neon"] = 1312.94, ["Neon|Ride"] = 1189.2, ["Neon|Fly|Ride"] = 1253.33, ["Mega|Fly|Ride"] = 4754.65}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.16, ["Fly"] = 459.38, ["Ride"] = 60.29, ["Fly|Ride"] = 108.26, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 309.41, ["Mega|Fly|Ride"] = 2028.12}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.44, ["Fly"] = 44.83, ["Ride"] = 28.31, ["Fly|Ride"] = 69.57, ["Neon"] = 65.63, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 87.06, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2517.12, ["Mega|Fly|Ride"] = 531.68}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 391.13, ["Fly"] = 838.53, ["Ride"] = 444.94, ["Fly|Ride"] = 531.87, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1258.57, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.9, ["Fly"] = 87.3, ["Ride"] = 31.46, ["Neon"] = 27.56, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 148.31, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 207.52, ["Fly"] = 393.75, ["Ride"] = 216.57, ["Fly|Ride"] = 315, ["Neon"] = 771.74, ["Neon|Ride"] = 880.89, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 3250.22, ["Mega|Fly|Ride"] = 3149.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.28, ["Fly"] = 20.98, ["Ride"] = 20.9, ["Fly|Ride"] = 35.43, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 2517.12, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 112.19, ["Fly|Ride"] = 525, ["Neon"] = 356.56, ["Neon|Fly"] = 1677.88, ["Neon|Ride"] = 419.48, ["Neon|Fly|Ride"] = 486.66, ["Mega"] = 1399.11, ["Mega|Ride"] = 1416.06, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.72, ["Ride"] = 24.93, ["Fly|Ride"] = 75.51, ["Neon"] = 91.88, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 236.23, ["Mega"] = 477.21, ["Mega|Ride"] = 489.8, ["Mega|Fly|Ride"] = 603.07}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 28.25, ["Fly"] = 111.57, ["Ride"] = 62.91, ["Fly|Ride"] = 220.63, ["Neon"] = 182.2, ["Neon|Ride"] = 226.52, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 776.12, ["Mega|Ride"] = 769.82, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Fly|Ride"] = 131.25, ["Neon"] = 30.19, ["Neon|Ride"] = 106.21, ["Neon|Fly|Ride"] = 127.97, ["Mega"] = 126.75, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.04, ["Fly"] = 70.24, ["Ride"] = 31.42, ["Fly|Ride"] = 76.12, ["Neon|Ride"] = 136.34, ["Neon|Fly|Ride"] = 224.46, ["Mega|Ride"] = 476.16, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 347.82, ["Fly"] = 503.12, ["Ride"] = 354.38, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2629.33, ["Mega|Fly|Ride"] = 7900.65}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 59.76, ["Fly"] = 104.84, ["Ride"] = 55.44, ["Fly|Ride"] = 103.67, ["Neon"] = 182.44, ["Neon|Ride"] = 104.88, ["Neon|Fly|Ride"] = 252.55, ["Mega"] = 718.82, ["Mega|Ride"] = 678.59, ["Mega|Fly|Ride"] = 750.39}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 52.5, ["Fly"] = 83.83, ["Ride"] = 60.38, ["Neon"] = 188.68, ["Neon|Ride"] = 198.95, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 1259.1, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1147.26}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.31, ["Fly"] = 81.38, ["Ride"] = 78.73, ["Fly|Ride"] = 131.25, ["Neon"] = 93.19, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 393.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 13521.42, ["Fly|Ride"] = 7856.63, ["Neon|Fly|Ride"] = 14306.25, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.15, ["Fly"] = 2046.01, ["Ride"] = 1833.57, ["Fly|Ride"] = 1771.88, ["Neon"] = 6135.91, ["Neon|Ride"] = 5313.59, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 24433.87}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 392.44, ["Ride"] = 429.07, ["Fly|Ride"] = 459.38, ["Neon"] = 2094.94, ["Neon|Fly|Ride"] = 2071.38, ["Mega"] = 11800.31, ["Mega|Fly|Ride"] = 6696.78}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.7, ["Fly"] = 31.46, ["Ride"] = 22.31, ["Fly|Ride"] = 44.82, ["Neon"] = 111.57, ["Neon|Ride"] = 104.88, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.73, ["Fly"] = 45.94, ["Ride"] = 41.3, ["Fly|Ride"] = 124.64, ["Neon"] = 34.13, ["Neon|Ride"] = 61.38, ["Neon|Fly|Ride"] = 157.47, ["Mega"] = 154.88, ["Mega|Ride"] = 200.82}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.12, ["Fly"] = 34.13, ["Ride"] = 55.13, ["Fly|Ride"] = 97.95, ["Neon|Ride"] = 151.47, ["Neon|Fly|Ride"] = 182.46, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 32.5, ["Ride"] = 18.87, ["Fly|Ride"] = 44.6, ["Neon"] = 23.71, ["Neon|Fly"] = 63.7, ["Neon|Ride"] = 48.25, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 393.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 305.96, ["Fly"] = 320.25, ["Ride"] = 311.87, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1857.3, ["Neon|Fly|Ride"] = 1692.77, ["Mega|Fly|Ride"] = 7340.66}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 48.19, ["Ride"] = 35.62, ["Fly|Ride"] = 78.64, ["Neon"] = 98.48, ["Neon|Fly"] = 167.81, ["Neon|Ride"] = 156.95, ["Neon|Fly|Ride"] = 209.77, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 594.76}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.19, ["Fly"] = 27.26, ["Ride"] = 20.98, ["Fly|Ride"] = 47.15, ["Neon"] = 70.27, ["Neon|Fly"] = 134.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 524.42, ["Mega|Ride"] = 577.89, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 433.13, ["Fly|Ride"] = 471.92, ["Neon|Ride"] = 2726.54, ["Mega|Fly|Ride"] = 9436.29}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1049.99, ["Fly"] = 1398.25, ["Ride"] = 1173.24, ["Fly|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17617.56}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 110.88, ["Fly"] = 98.54, ["Ride"] = 98.56, ["Fly|Ride"] = 118.89, ["Neon"] = 971.25, ["Neon|Ride"] = 398.11, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2574.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 153.57, ["Fly"] = 225.29, ["Ride"] = 183.75, ["Fly|Ride"] = 224.44, ["Neon"] = 656.25, ["Neon|Fly"] = 671.16, ["Neon|Ride"] = 737.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 5594.27, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.94, ["Fly"] = 131.25, ["Ride"] = 42, ["Fly|Ride"] = 279.9, ["Neon"] = 199.5, ["Neon|Fly"] = 419.48, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 363.95, ["Mega|Ride"] = 1818.62, ["Mega|Fly|Ride"] = 896.63}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 139.13, ["Ride"] = 209.67, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1392.45, ["Mega|Fly|Ride"] = 2957.85}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2483.25, ["Fly|Ride"] = 2656.36, ["Neon|Fly|Ride"] = 7129.69, ["Mega|Fly|Ride"] = 48238.52}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 43.32, ["Ride"] = 51.48, ["Fly|Ride"] = 196.88, ["Neon"] = 288.4, ["Neon|Fly"] = 167.81, ["Neon|Fly|Ride"] = 415.34, ["Mega"] = 2091.3, ["Mega|Ride"] = 2307.36, ["Mega|Fly|Ride"] = 1887.75}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.24, ["Fly"] = 675.94, ["Ride"] = 603.75, ["Fly|Ride"] = 629.48, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1245.46, ["Mega|Fly|Ride"] = 3087.95}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 27.15, ["Fly"] = 60.38, ["Ride"] = 69.57, ["Fly|Ride"] = 104.88, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 196.14, ["Mega|Fly|Ride"] = 1180.05}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.92, ["Fly"] = 37.73, ["Ride"] = 23.07, ["Fly|Ride"] = 54.66, ["Neon"] = 30.19, ["Neon|Fly"] = 54.54, ["Neon|Ride"] = 45.11, ["Neon|Fly|Ride"] = 97.12, ["Mega"] = 144.38, ["Mega|Fly"] = 249.62, ["Mega|Ride"] = 180.89, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 42.31, ["Ride"] = 72.19, ["Fly|Ride"] = 137.82, ["Neon"] = 248.07, ["Neon|Ride"] = 262.71, ["Neon|Fly|Ride"] = 531.76, ["Mega|Ride"] = 1399.11, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 524.98, ["Fly"] = 899.07, ["Ride"] = 538.13, ["Fly|Ride"] = 625.97, ["Neon"] = 2377.33, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1442.44, ["Mega|Fly|Ride"] = 5594.27}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 498.75, ["Ride"] = 577.5, ["Fly|Ride"] = 627.94, ["Neon"] = 5243.33, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12585.26}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 18.38, ["Fly"] = 26.13, ["Ride"] = 23.6, ["Fly|Ride"] = 47.18, ["Neon"] = 209.75, ["Neon|Ride"] = 100.69, ["Neon|Fly|Ride"] = 112.24, ["Mega|Fly|Ride"] = 630.15}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.86, ["Ride"] = 22.32, ["Fly|Ride"] = 53.17, ["Neon"] = 56.58, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1678.08, ["Mega|Ride"] = 443.1, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.25, ["Ride"] = 39.37, ["Fly|Ride"] = 111.57, ["Neon"] = 20.98, ["Neon|Fly"] = 78.91, ["Neon|Ride"] = 65.03, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 158.15, ["Mega|Fly"] = 456.68, ["Mega|Ride"] = 225.73, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 50.33, ["Fly"] = 53.27, ["Ride"] = 45.94, ["Fly|Ride"] = 90.56, ["Neon"] = 236.01, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 178.5, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 44.62, ["Ride"] = 111.57, ["Fly|Ride"] = 1047.52, ["Neon"] = 276.17, ["Neon|Ride"] = 401.44, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1538.59, ["Mega|Ride"] = 1538.59, ["Mega|Fly|Ride"] = 1258.89}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 41.92, ["Fly|Ride"] = 84, ["Neon"] = 110.92, ["Neon|Fly"] = 149.87, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 65.05, ["Ride"] = 45.94, ["Fly|Ride"] = 89.2, ["Neon"] = 207.47, ["Neon|Ride"] = 195.92, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1180.05}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.92, ["Fly"] = 21, ["Ride"] = 18.35, ["Fly|Ride"] = 39.38, ["Neon"] = 28.75, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 262.5, ["Mega|Ride"] = 159.31, ["Mega|Fly|Ride"] = 405.85}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.16, ["Fly"] = 32.5, ["Ride"] = 27.08, ["Fly|Ride"] = 67.24, ["Neon"] = 26.17, ["Neon|Fly"] = 158.13, ["Neon|Ride"] = 49.24, ["Neon|Fly|Ride"] = 188.83, ["Mega"] = 131.25, ["Mega|Fly"] = 476.16, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 560}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 53.82, ["Fly"] = 60.37, ["Ride"] = 63.72, ["Fly|Ride"] = 98.48, ["Neon"] = 498.75, ["Neon|Ride"] = 246.45, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1995, ["Fly"] = 2200.09, ["Ride"] = 1820.43, ["Fly|Ride"] = 1862.44, ["Neon|Ride"] = 5766.62, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 14681.3}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 458.67, ["Fly"] = 545.05, ["Ride"] = 510.08, ["Fly|Ride"] = 629.22, ["Neon"] = 3147.02, ["Neon|Ride"] = 3076.79, ["Neon|Fly|Ride"] = 2223.45, ["Mega|Fly|Ride"] = 9647.72}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 242.82, ["Fly"] = 419.28, ["Ride"] = 236.25, ["Fly|Ride"] = 328.13, ["Neon"] = 1155, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1538.59, ["Mega"] = 7341.55, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 60.82, ["Fly|Ride"] = 112.19, ["Neon"] = 208.46, ["Neon|Ride"] = 250.31, ["Neon|Fly|Ride"] = 314.65, ["Mega|Ride"] = 838, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33540.85, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 14700, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 372.75, ["Fly"] = 435, ["Ride"] = 420, ["Fly|Ride"] = 441.08, ["Neon"] = 1384.25, ["Neon|Fly"] = 1603.41, ["Neon|Ride"] = 1105.31, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 6292.76, ["Mega|Ride"] = 6608.19, ["Mega|Fly|Ride"] = 4168.5}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Fly"] = 140.46, ["Ride"] = 136.49, ["Fly|Ride"] = 141.59, ["Mega|Fly|Ride"] = 4194.67}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Fly"] = 279.87, ["Ride"] = 122.07, ["Fly|Ride"] = 196.12, ["Neon"] = 705.65, ["Neon|Ride"] = 838.94, ["Neon|Fly|Ride"] = 484.56, ["Mega"] = 13984.6, ["Mega|Fly|Ride"] = 5243.33}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.1, ["Fly"] = 69.2, ["Ride"] = 40.13, ["Fly|Ride"] = 110.93, ["Neon"] = 266.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 264.31, ["Mega"] = 1968.75}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5000.26, ["Ride"] = 4703.65, ["Fly|Ride"] = 4033.87, ["Neon|Ride"] = 16778.62, ["Neon|Fly|Ride"] = 17480.22}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.33, ["Fly"] = 49.48, ["Ride"] = 35.62, ["Fly|Ride"] = 63.72, ["Neon"] = 333.94, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 204.24, ["Mega"] = 1048.81, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 38.06, ["Fly"] = 140.46, ["Ride"] = 43.32, ["Fly|Ride"] = 107.43, ["Neon"] = 228.93, ["Neon|Fly"] = 1398.93, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 218.17, ["Mega"] = 1574.18, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.37, ["Fly"] = 603.75, ["Ride"] = 626.07, ["Fly|Ride"] = 708.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1548.74, ["Mega|Fly|Ride"] = 5626.64}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.74, ["Fly"] = 28.31, ["Ride"] = 26.25, ["Fly|Ride"] = 54.3, ["Neon"] = 98.44, ["Neon|Fly"] = 158.13, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 137.62, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 18.38, ["Ride"] = 32.82, ["Neon"] = 91.88, ["Neon|Ride"] = 192.35, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 418.48, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 489.74}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.77, ["Ride"] = 131.25, ["Fly|Ride"] = 245.44, ["Neon"] = 671.16, ["Neon|Ride"] = 419.48, ["Neon|Fly|Ride"] = 657.6, ["Mega|Fly|Ride"] = 2792.94}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 28.25, ["Fly"] = 106.17, ["Ride"] = 77.35, ["Fly|Ride"] = 153.16, ["Neon"] = 87.6, ["Neon|Fly"] = 188.77, ["Neon|Ride"] = 140.57, ["Neon|Fly|Ride"] = 244.05, ["Mega"] = 292.69, ["Mega|Fly"] = 419.53, ["Mega|Ride"] = 356.58, ["Mega|Fly|Ride"] = 499.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3399.38, ["Fly"] = 5134.9, ["Ride"] = 3583.12, ["Fly|Ride"] = 3609.38, ["Neon|Ride"] = 11631.79, ["Neon|Fly|Ride"] = 8386.88, ["Mega"] = 62927.47, ["Mega|Fly|Ride"] = 32859.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.49, ["Fly"] = 115.5, ["Ride"] = 85.97, ["Fly|Ride"] = 140.34, ["Neon"] = 251.69, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 413.02, ["Mega|Ride"] = 879.95, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6300, ["Fly"] = 7407.29, ["Ride"] = 7688.09, ["Fly|Ride"] = 6231.75, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 62919.8}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.97, ["Ride"] = 19.69, ["Fly|Ride"] = 41.96, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.97, ["Mega"] = 419.53, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.07, ["Fly"] = 23.63, ["Ride"] = 31.49, ["Fly|Ride"] = 56.58, ["Neon"] = 209.75, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 140.55, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.42}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.81, ["Ride"] = 26.25, ["Fly|Ride"] = 83.83, ["Neon"] = 158.13, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 235.99, ["Mega"] = 1049.9, ["Mega|Ride"] = 977.49, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.02, ["Fly"] = 262.5, ["Ride"] = 52.5, ["Fly|Ride"] = 140.49, ["Neon"] = 155.23, ["Neon|Ride"] = 120.49, ["Neon|Fly|Ride"] = 278.99, ["Mega"] = 840, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.94, ["Fly"] = 26.17, ["Ride"] = 22.32, ["Fly|Ride"] = 39.12, ["Neon|Ride"] = 112.22, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 2517.12, ["Mega|Ride"] = 588.84, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8342.25}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.81, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 203.38, ["Neon|Fly|Ride"] = 1119.07, ["Mega|Fly|Ride"] = 5506.28}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.23, ["Fly"] = 132.08, ["Ride"] = 47.21, ["Fly|Ride"] = 315.02, ["Neon"] = 102.59, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 456.68, ["Mega"] = 909.32, ["Mega|Ride"] = 896.84, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.06}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.02, ["Ride"] = 26.25, ["Neon|Ride"] = 63.73, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 186.35, ["Ride"] = 223.13, ["Fly|Ride"] = 417.38, ["Neon"] = 748.13, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3483.05, ["Mega|Fly|Ride"] = 3479.48}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 123, ["Ride"] = 190.61, ["Fly|Ride"] = 485.63, ["Neon"] = 668.92, ["Neon|Ride"] = 419.48, ["Neon|Fly|Ride"] = 769.82, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 170.62, ["Fly"] = 209.65, ["Ride"] = 144.38, ["Fly|Ride"] = 203.44, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4614.7, ["Mega|Fly|Ride"] = 3493.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1506.75, ["Fly"] = 2515.58, ["Ride"] = 1102.5, ["Fly|Ride"] = 1327.22, ["Neon"] = 5313.59, ["Neon|Ride"] = 6152.52, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 25167.93}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.78, ["Fly"] = 81.77, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 127.3, ["Neon|Ride"] = 297.36, ["Neon|Fly|Ride"] = 315.06, ["Mega"] = 838, ["Mega|Fly|Ride"] = 994.14}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 590.63, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 699.21, ["Neon|Fly|Ride"] = 3048.85}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 45.94}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 10.5, ["Ride"] = 43.32, ["Fly|Ride"] = 131.25, ["Neon"] = 69.22, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.62, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 863.8}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.49, ["Fly"] = 131.25, ["Ride"] = 28.31, ["Fly|Ride"] = 94.5, ["Neon"] = 72.19, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 86.62}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Ride"] = 31.21, ["Fly|Ride"] = 70.25, ["Neon"] = 196.88, ["Neon|Ride"] = 158.37, ["Neon|Fly|Ride"] = 551.09, ["Mega|Fly|Ride"] = 1445.75}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 32.82, ["Fly"] = 46.13, ["Ride"] = 35.52, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 336, ["Mega"] = 952.3, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6142.5, ["Fly"] = 10500, ["Ride"] = 5495.44, ["Fly|Ride"] = 4803.75, ["Neon|Ride"] = 17478.07, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.16, ["Fly"] = 34.13, ["Ride"] = 26.25, ["Fly|Ride"] = 82.69, ["Neon"] = 47.21, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 315.08, ["Mega"] = 528.67, ["Mega|Ride"] = 446.8, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 108.94, ["Fly"] = 371.06, ["Ride"] = 125.81, ["Fly|Ride"] = 245.44, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 521.07, ["Mega|Ride"] = 4195.17, ["Mega|Fly|Ride"] = 2118.32}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 82.69, ["Ride"] = 116.82, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 419.48, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2360.08, ["Mega|Ride"] = 2831.75, ["Mega|Fly|Ride"] = 1818.62}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.92, ["Fly"] = 72.19, ["Ride"] = 32.22, ["Fly|Ride"] = 75.49, ["Neon"] = 196.88, ["Neon|Ride"] = 69.22, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 866.16, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 49.61, ["Ride"] = 30.19, ["Fly|Ride"] = 78.75, ["Neon"] = 23.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 165.73, ["Mega"] = 131.14, ["Mega|Fly"] = 6984.62, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.07, ["Fly"] = 74.82, ["Ride"] = 26.25, ["Fly|Ride"] = 83.88, ["Neon"] = 91.14, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 396.45, ["Mega|Ride"] = 466.73, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.07, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 57.75, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.88}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 33.57, ["Ride"] = 126.26, ["Neon"] = 189.67, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1186.2, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1675.77}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 125.73, ["Ride"] = 140.49, ["Fly|Ride"] = 262.5, ["Neon"] = 560, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 38.07, ["Fly"] = 212.01, ["Ride"] = 105, ["Fly|Ride"] = 246.45, ["Neon"] = 314.62, ["Neon|Ride"] = 309.37, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1183.88, ["Mega|Ride"] = 1189.35, ["Mega|Fly|Ride"] = 1104.3}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 813.9, ["Fly"] = 865.74, ["Ride"] = 656.25, ["Fly|Ride"] = 796.98, ["Neon|Fly"] = 2831.97, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 9581.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 219.19, ["Fly"] = 417.55, ["Ride"] = 249.38, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1538.4, ["Neon|Fly|Ride"] = 1259.1, ["Mega"] = 8250.85, ["Mega|Fly|Ride"] = 6572.79}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 70.24}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 15.61, ["Fly"] = 35.44, ["Ride"] = 26.21, ["Fly|Ride"] = 53.82, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 136.36, ["Mega"] = 437.26, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 494}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 287.44, ["Fly"] = 978.99, ["Ride"] = 328.13, ["Fly|Ride"] = 431.82, ["Neon"] = 1021.41, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4127}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 21}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 145.69, ["Fly"] = 590.63, ["Ride"] = 195.57, ["Fly|Ride"] = 236.25, ["Neon"] = 690.38, ["Neon|Fly"] = 1677.88, ["Neon|Ride"] = 673.44, ["Neon|Fly|Ride"] = 727.88, ["Mega"] = 2936.62, ["Mega|Ride"] = 2100.47, ["Mega|Fly|Ride"] = 1897.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Fly"] = 191.83, ["Ride"] = 170.63, ["Fly|Ride"] = 209.67, ["Neon"] = 1118.94, ["Neon|Ride"] = 817.97}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.73, ["Ride"] = 28.31, ["Fly|Ride"] = 209.75, ["Neon"] = 44.05, ["Neon|Ride"] = 73.5, ["Mega"] = 214.39, ["Mega|Ride"] = 517.65, ["Mega|Fly|Ride"] = 459.33}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 19.69, ["Fly"] = 63, ["Ride"] = 28.87, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 628.24, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.98, ["Fly"] = 131.25, ["Ride"] = 61.87, ["Fly|Ride"] = 140.39, ["Neon"] = 99.75, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 183.53, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 450.84, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1017.85}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.83, ["Fly"] = 262.5, ["Ride"] = 52.5, ["Fly|Ride"] = 111.19, ["Neon"] = 26.17, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 142.42, ["Mega|Ride"] = 162.75, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.04, ["Fly"] = 330.19, ["Ride"] = 301.88, ["Fly|Ride"] = 370.32, ["Neon"] = 1538.4, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42, ["Mega|Fly|Ride"] = 5075.55}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 129.94, ["Fly"] = 266.25, ["Ride"] = 175.88, ["Fly|Ride"] = 253.32, ["Neon"] = 456.75, ["Neon|Ride"] = 502.69, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 1887.84, ["Mega|Ride"] = 1887.84, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 83.87, ["Fly"] = 167.45, ["Ride"] = 106.95, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1659.14}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Ride"] = 58.24, ["Fly|Ride"] = 251.61, ["Neon|Ride"] = 599.45, ["Neon|Fly|Ride"] = 486.66, ["Mega|Fly|Ride"] = 1647.47}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.15, ["Fly"] = 75.62, ["Ride"] = 35.44, ["Fly|Ride"] = 118.13, ["Neon"] = 68.98, ["Neon|Fly"] = 196.12, ["Neon|Ride"] = 110.93, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 729.98, ["Mega|Fly"] = 525, ["Mega|Ride"] = 556.92, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.57, ["Fly"] = 45.82, ["Ride"] = 20.88, ["Fly|Ride"] = 56.44, ["Neon"] = 19.58, ["Neon|Ride"] = 41.96, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 111.76, ["Mega|Ride"] = 158.15, ["Mega|Fly|Ride"] = 272.7}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1071.95, ["Fly"] = 1084.32, ["Ride"] = 969.06, ["Fly|Ride"] = 984.38, ["Neon"] = 3007.12, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2493.73, ["Mega|Fly|Ride"] = 8111.37}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 392.44, ["Ride"] = 433.69, ["Fly|Ride"] = 481.69, ["Neon|Ride"] = 1538.4, ["Neon|Fly|Ride"] = 1771.88, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 5867.29}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 85.32, ["Ride"] = 135.69, ["Fly|Ride"] = 161.52, ["Neon"] = 765.19, ["Neon|Ride"] = 390.58, ["Neon|Fly|Ride"] = 388.05, ["Mega|Ride"] = 1413.79, ["Mega|Fly|Ride"] = 1463.07}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 236.25, ["Fly"] = 335.43, ["Ride"] = 300.57, ["Fly|Ride"] = 329.11, ["Neon|Ride"] = 1415.99, ["Neon|Fly|Ride"] = 1231.3, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.25, ["Fly"] = 140.46, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 132.86, ["Neon|Ride"] = 121.21, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 666, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 213.94, ["Fly|Ride"] = 472.01, ["Neon"] = 1584.98, ["Neon|Ride"] = 979.47, ["Neon|Fly|Ride"] = 2411.18, ["Mega"] = 4169.8, ["Mega|Fly|Ride"] = 4194.67}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 55.44, ["Fly"] = 126, ["Ride"] = 65.63, ["Fly|Ride"] = 106.42, ["Neon|Ride"] = 501.27, ["Neon|Fly|Ride"] = 560.07, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1588.13, ["Ride"] = 1367.09, ["Fly|Ride"] = 1363.93, ["Neon|Fly|Ride"] = 6844.19, ["Mega"] = 50341.99, ["Mega|Fly|Ride"] = 24329}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 83.87, ["Ride"] = 32.82, ["Fly|Ride"] = 98.59, ["Neon"] = 61.67, ["Neon|Fly"] = 167.81, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 255.94, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 418.51}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 56.62, ["Fly"] = 78.75, ["Ride"] = 59.05, ["Fly|Ride"] = 159.48, ["Neon"] = 237.83, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 544.34, ["Mega"] = 938.68, ["Mega|Ride"] = 1140.04, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.44, ["Fly"] = 91.88, ["Ride"] = 72.19, ["Fly|Ride"] = 98.58, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1151.93, ["Ride"] = 1089.37, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 5023.44, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 836.45, ["Ride"] = 587.05, ["Fly|Ride"] = 699.21, ["Neon|Fly|Ride"] = 2754.21, ["Mega|Fly|Ride"] = 14157.97}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 95.48, ["Fly"] = 314.94, ["Ride"] = 131.25, ["Fly|Ride"] = 218.03, ["Neon"] = 444.29, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 544.14, ["Mega"] = 4195.17, ["Mega|Ride"] = 2657.66, ["Mega|Fly|Ride"] = 2093.15}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 23.55, ["Fly|Ride"] = 59.07, ["Neon"] = 87.94, ["Neon|Ride"] = 125.86, ["Neon|Fly|Ride"] = 178.31, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1023.51}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 83.87, ["Ride"] = 47.12, ["Fly|Ride"] = 94.4, ["Neon"] = 188.77, ["Neon|Fly"] = 418.43, ["Neon|Ride"] = 209.56, ["Neon|Fly|Ride"] = 276.9, ["Mega"] = 1818.62, ["Mega|Ride"] = 1070.3, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 746.82, ["Ride"] = 874.13, ["Fly|Ride"] = 978.37, ["Neon"] = 3132.38, ["Neon|Ride"] = 2726.54, ["Neon|Fly|Ride"] = 2993.27, ["Mega|Fly|Ride"] = 13283.43}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.46}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5031.76, ["Fly|Ride"] = 3937.5, ["Neon|Ride"] = 30055.75, ["Neon|Fly|Ride"] = 21499.19, ["Mega|Fly|Ride"] = 89486.62}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 276.17, ["Ride"] = 235.97, ["Neon"] = 1677.88, ["Neon|Ride"] = 1259.06, ["Neon|Fly|Ride"] = 1399.11, ["Mega"] = 5873.24, ["Mega|Fly|Ride"] = 6013.05}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 81.38, ["Fly"] = 279.87, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 349.13, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 979.58, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.13, ["Fly"] = 47.25, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 102.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 699.57, ["Mega|Ride"] = 629.29, ["Mega|Fly|Ride"] = 585.38}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 16.75, ["Fly"] = 31.85, ["Ride"] = 28.32, ["Fly|Ride"] = 52.64, ["Neon|Ride"] = 196.12, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 833.7}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Fly"] = 130.02, ["Ride"] = 41.05, ["Fly|Ride"] = 102.6, ["Neon"] = 126.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 56.62, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 36.71, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 222.36, ["Mega|Fly|Ride"] = 293.64}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.75, ["Ride"] = 52.5, ["Fly|Ride"] = 183.75, ["Neon"] = 163.61, ["Neon|Fly"] = 838.94, ["Neon|Ride"] = 212.41, ["Neon|Fly|Ride"] = 247.23, ["Mega"] = 692.22, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 825.32}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 275.52, ["Fly"] = 366.19, ["Ride"] = 288.75, ["Fly|Ride"] = 353.17, ["Neon"] = 1415.99, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3559.18}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.14, ["Fly"] = 22.97, ["Ride"] = 17.07, ["Fly|Ride"] = 36.68, ["Neon"] = 20.98, ["Neon|Ride"] = 28.75, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 836.95, ["Mega|Ride"] = 220.68, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.48, ["Fly"] = 98.54, ["Ride"] = 65.54, ["Fly|Ride"] = 114.19, ["Neon"] = 192.94, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 187.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 564.38, ["Mega|Fly"] = 839.05, ["Mega|Ride"] = 557.82, ["Mega|Fly|Ride"] = 564.37}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.83, ["Fly"] = 941.26, ["Ride"] = 761.25, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1567.12, ["Mega|Fly|Ride"] = 4372.39}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.44, ["Fly"] = 78.63, ["Ride"] = 51.18, ["Fly|Ride"] = 96.5, ["Neon|Fly"] = 472.01, ["Neon|Ride"] = 164.04, ["Neon|Fly|Ride"] = 278.24, ["Mega"] = 1575, ["Mega|Ride"] = 1119.07, ["Mega|Fly|Ride"] = 629.29}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 342.44, ["Ride"] = 242.82, ["Fly|Ride"] = 288.75, ["Neon"] = 1237.44, ["Neon|Ride"] = 1257.37, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5034.36}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 158.06, ["Fly"] = 182.28, ["Ride"] = 129.93, ["Fly|Ride"] = 154.88, ["Neon"] = 629.22, ["Neon|Ride"] = 524.34, ["Neon|Fly|Ride"] = 469.87, ["Mega|Fly|Ride"] = 2237.86}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 612.84, ["Fly|Ride"] = 649.11, ["Neon|Fly|Ride"] = 2133.25, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 28.31, ["Ride"] = 47.21, ["Neon"] = 131.25, ["Neon|Fly"] = 283.22, ["Neon|Ride"] = 110.93, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 262.48, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4003.11, ["Fly"] = 3139.19, ["Ride"] = 3866.89, ["Fly|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 82.69, ["Fly"] = 121.61, ["Ride"] = 102.53, ["Fly|Ride"] = 164.07, ["Neon"] = 419.48, ["Neon|Ride"] = 414.24, ["Neon|Fly|Ride"] = 457.61, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.03, ["Fly"] = 28.31, ["Ride"] = 22.32, ["Fly|Ride"] = 84, ["Neon"] = 23.55, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 139.1, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 27.98, ["Neon"] = 30.34, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.43, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.24}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 53.82, ["Fly"] = 82.86, ["Ride"] = 41.94, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 417.43, ["Mega|Fly|Ride"] = 1384.25}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1172.72, ["Ride"] = 1174.69, ["Fly|Ride"] = 1295.44, ["Neon"] = 5719.42, ["Neon|Fly|Ride"] = 5238.73, ["Mega|Fly|Ride"] = 22372.2}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4725, ["Ride"] = 5898.78, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.61, ["Fly"] = 31.46, ["Ride"] = 28.3, ["Fly|Ride"] = 59.07, ["Neon"] = 261.86, ["Neon|Ride"] = 116.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 560}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.65, ["Ride"] = 36.75, ["Fly|Ride"] = 94.4, ["Neon"] = 94.5, ["Neon|Ride"] = 88.53, ["Neon|Fly|Ride"] = 140.39, ["Mega"] = 933.52, ["Mega|Ride"] = 414.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 55.11, ["Fly"] = 157.5, ["Ride"] = 52.5, ["Fly|Ride"] = 94.5, ["Neon"] = 271.24, ["Neon|Ride"] = 280.01, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 1399.11, ["Mega|Ride"] = 1180.96, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 212.63, ["Fly"] = 314.94, ["Ride"] = 236.25, ["Fly|Ride"] = 259.08, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 1045.52, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 3367.83}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 27.27, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 245.46, ["Mega"] = 154.88, ["Mega|Ride"] = 272.27, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 251.56, ["Ride"] = 231.68, ["Fly|Ride"] = 313.45, ["Neon"] = 787.05, ["Neon|Ride"] = 833.68, ["Neon|Fly|Ride"] = 828.19, ["Mega|Fly|Ride"] = 3917.25}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.56, ["Fly"] = 23.07, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 19.69, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 472.03, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 284.16}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 251.52, ["Fly"] = 268.82, ["Ride"] = 253.21, ["Fly|Ride"] = 225.1, ["Neon|Ride"] = 909.21, ["Neon|Fly|Ride"] = 951.26, ["Mega"] = 10487.92, ["Mega|Ride"] = 4195.17, ["Mega|Fly|Ride"] = 3916.78}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 16.78, ["Fly"] = 26.25, ["Ride"] = 27.06, ["Fly|Ride"] = 62.91, ["Neon"] = 83.91, ["Neon|Fly"] = 299.74, ["Neon|Ride"] = 99.64, ["Neon|Fly|Ride"] = 190.68, ["Mega"] = 522.77, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 20.97, ["Neon"] = 14.44, ["Neon|Fly"] = 66, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 76.39, ["Mega|Ride"] = 167.52, ["Mega|Fly|Ride"] = 224.46}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.41, ["Neon|Ride"] = 70.27, ["Mega"] = 27.46, ["Mega|Ride"] = 139.26}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 261.19, ["Fly|Ride"] = 139.63, ["Neon"] = 7.25, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 158.15, ["Mega|Fly"] = 157338.21, ["Mega|Ride"] = 140.55}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.86, ["Fly"] = 136.82, ["Ride"] = 111.57, ["Fly|Ride"] = 199.26, ["Neon"] = 300.57, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 260.78, ["Neon|Fly|Ride"] = 341.16, ["Mega|Fly|Ride"] = 1170.35}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.74, ["Fly|Ride"] = 43.32, ["Neon"] = 12.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.11, ["Mega|Ride"] = 56.58, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.4, ["Ride"] = 111.09, ["Fly|Ride"] = 195.07, ["Neon"] = 74.82, ["Neon|Ride"] = 72.19, ["Mega"] = 630.15, ["Mega|Ride"] = 523.59}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 22.31, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 157.31}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.71, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 21.19, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 32.21, ["Mega"] = 15.75, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 26.17, ["Mega|Fly|Ride"] = 31.4}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 15.44, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 22.32, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 18.38, ["Mega|Ride"] = 146.97, ["Mega|Fly|Ride"] = 309.37}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 19.69, ["Fly|Ride"] = 107.52, ["Neon"] = 3.94, ["Neon|Fly"] = 135.06, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 41.5, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 22.31, ["Mega|Fly"] = 100.7, ["Mega|Ride"] = 85.32}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 32.82, ["Fly|Ride"] = 47.41, ["Neon"] = 4.73, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 63.67, ["Mega"] = 52.41, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 71.99, ["Mega|Fly|Ride"] = 116.8}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 22.2, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 47.16, ["Mega"] = 209.77, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 280.04}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 13.36, ["Mega"] = 105, ["Mega|Fly|Ride"] = 377.53}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 1312.5, ["Neon"] = 5.25, ["Neon|Ride"] = 37.77, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 26.25, ["Mega|Ride"] = 60.84, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.68, ["Ride"] = 18.85, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 41.96, ["Neon|Ride"] = 17.69, ["Neon|Fly|Ride"] = 36.71, ["Mega"] = 17.07, ["Mega|Ride"] = 27.28, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.84, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.82, ["Mega"] = 266.41}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 42, ["Fly|Ride"] = 78.74, ["Neon"] = 5.25, ["Neon|Ride"] = 25.15, ["Neon|Fly|Ride"] = 158.15, ["Mega"] = 33.74, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 142.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.61, ["Neon"] = 8.86, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 89.25, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 190.81, ["Neon"] = 116.84, ["Neon|Ride"] = 70.27, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 95.45, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 15.39, ["Ride"] = 20.99, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 35.17, ["Mega"] = 17.71, ["Mega|Fly"] = 31.47, ["Mega|Ride"] = 31.47, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.87, ["Fly|Ride"] = 72.19, ["Neon"] = 15.64, ["Neon|Ride"] = 113.3, ["Neon|Fly|Ride"] = 74.48, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Fly|Ride"] = 140.54, ["Neon"] = 7.35, ["Neon|Ride"] = 112.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.61, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 14.99, ["Ride"] = 18.89, ["Fly|Ride"] = 26.17, ["Neon"] = 3.94, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 16.79, ["Neon|Fly|Ride"] = 36.71, ["Mega"] = 41.97, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 125.51}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 175.06, ["Ride"] = 26.25, ["Neon"] = 5.44, ["Neon|Fly"] = 77.54, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 125.87, ["Mega|Fly"] = 167.83, ["Mega|Ride"] = 89.71}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.82, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 156.28, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 30.19, ["Mega|Ride"] = 155.24, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 46.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.96, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 17.64, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 124.76}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.48, ["Ride"] = 16.49, ["Fly|Ride"] = 47.21, ["Neon"] = 11.7, ["Neon|Fly"] = 45.12, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 60.38, ["Mega|Ride"] = 138.28, ["Mega|Fly|Ride"] = 262.18}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.31, ["Neon"] = 7.87, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 131.25, ["Mega|Ride"] = 114.61, ["Mega|Fly|Ride"] = 330.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 18.38, ["Fly|Ride"] = 48.25, ["Neon"] = 4.6, ["Neon|Fly"] = 98.48, ["Neon|Ride"] = 25.08, ["Neon|Fly|Ride"] = 45.91, ["Mega"] = 72.16, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 82.69, ["Neon"] = 27.57, ["Mega|Fly|Ride"] = 838.11}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 18.1, ["Fly|Ride"] = 5427.93, ["Neon"] = 6.57, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 31.47, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 29.64, ["Fly|Ride"] = 28.88, ["Neon"] = 35.66, ["Neon|Fly"] = 41.96, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 83.74, ["Mega"] = 196.88, ["Mega|Fly"] = 116.44, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.21, ["Neon"] = 23.05, ["Neon|Ride"] = 158.13, ["Mega"] = 200.16, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 12.59, ["Ride"] = 131.24, ["Neon"] = 140.54, ["Neon|Ride"] = 236.01, ["Mega"] = 839.05, ["Mega|Ride"] = 876.8, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 56.58, ["Neon"] = 40.69, ["Neon|Ride"] = 91.88, ["Mega"] = 315.08, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.4, ["Ride"] = 42.66, ["Fly|Ride"] = 140.54, ["Neon"] = 94.24, ["Neon|Ride"] = 116.29, ["Mega"] = 472.03, ["Mega|Ride"] = 255.29, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 64.98, ["Mega"] = 22.32, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 56.25}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 27.09, ["Ride"] = 21, ["Fly|Ride"] = 52.49, ["Neon"] = 52.39, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 283.5, ["Mega|Ride"] = 275.82, ["Mega|Fly|Ride"] = 398.55}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 731.6, ["Neon"] = 4.73, ["Neon|Ride"] = 17.71, ["Mega"] = 23.68, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.62, ["Fly|Ride"] = 140.39, ["Neon"] = 5.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 158.15, ["Mega"] = 52.39, ["Mega|Ride"] = 69.51, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.7, ["Fly|Ride"] = 77.62, ["Neon"] = 18.69, ["Neon|Ride"] = 47.66, ["Neon|Fly|Ride"] = 74.26, ["Mega"] = 148.71, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Ride"] = 98.56, ["Neon"] = 42, ["Neon|Ride"] = 79.08, ["Neon|Fly|Ride"] = 155.24, ["Mega"] = 328.13, ["Mega|Ride"] = 272.7, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 49.3, ["Neon|Fly|Ride"] = 79.08, ["Mega"] = 31.87, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 49.31, ["Mega|Fly|Ride"] = 137.39}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 15.49, ["Fly|Ride"] = 279643.84, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 30.19, ["Mega|Fly"] = 200.63, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.27}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 18.38, ["Fly|Ride"] = 31.5, ["Neon"] = 7.16, ["Neon|Fly"] = 70.27, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 110.95, ["Mega"] = 47.25, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.74, ["Fly|Ride"] = 77.89, ["Neon"] = 3.84, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 94.41, ["Mega"] = 22.56, ["Mega|Ride"] = 34.75, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 172.02, ["Mega"] = 18.8, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 97.96, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.57, ["Ride"] = 19.59, ["Fly|Ride"] = 77.44, ["Neon"] = 2.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 38.05, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 15.75, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 261.84}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 158.13, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.93, ["Mega|Fly"] = 118.01, ["Mega|Fly|Ride"] = 339.78}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 24.77, ["Fly|Ride"] = 52.5, ["Neon"] = 3.93, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 17.71, ["Neon|Fly|Ride"] = 105, ["Mega"] = 62.94, ["Mega|Ride"] = 70.28, ["Mega|Fly|Ride"] = 167.83}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 14.43, ["Ride"] = 87.94, ["Neon"] = 131.25, ["Neon|Ride"] = 236.01, ["Mega"] = 414.91, ["Mega|Ride"] = 524.42, ["Mega|Fly|Ride"] = 938.57}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 39.38, ["Neon"] = 41.08, ["Mega"] = 208.72, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 419.32, ["Neon"] = 28.3, ["Mega"] = 233.89, ["Mega|Ride"] = 188.81, ["Mega|Fly|Ride"] = 336.67}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.49, ["Ride"] = 12.9, ["Fly|Ride"] = 35.66, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.59, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 16.44, ["Mega|Fly"] = 23.55, ["Mega|Ride"] = 26.1, ["Mega|Fly|Ride"] = 44.06}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 55.12, ["Fly|Ride"] = 70.27, ["Neon"] = 4.87, ["Neon|Fly"] = 83.91, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 699.57, ["Mega"] = 70.2, ["Mega|Ride"] = 70.28}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 20.97, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.59, ["Mega"] = 18.38, ["Mega|Fly"] = 52.71, ["Mega|Ride"] = 52.24, ["Mega|Fly|Ride"] = 99.28}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.87, ["Mega"] = 16.96, ["Mega|Ride"] = 102.79, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 20.98, ["Fly|Ride"] = 54.54, ["Neon"] = 12.37, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 141.39, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 298.64}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 196.02, ["Ride"] = 180.75, ["Fly|Ride"] = 262.5, ["Neon"] = 929.13, ["Neon|Ride"] = 1102.12, ["Neon|Fly|Ride"] = 769.82, ["Mega"] = 8390.34, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 70.82, ["Neon"] = 6.04, ["Neon|Fly"] = 56.64, ["Neon|Ride"] = 68.25, ["Mega"] = 67.13, ["Mega|Ride"] = 196.14, ["Mega|Fly|Ride"] = 720.45}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.29, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Fly|Ride"] = 196.88, ["Neon"] = 33.57, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158.39, ["Mega"] = 415.34, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 1042.02}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.69, ["Fly|Ride"] = 28.88, ["Neon"] = 5.81, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 94.42, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 125.85}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 27.57, ["Fly|Ride"] = 120.89, ["Neon"] = 11.82, ["Neon|Fly"] = 83.91, ["Neon|Ride"] = 103.83, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 83.92, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 208.7}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.63, ["Fly"] = 23.63, ["Ride"] = 16.95, ["Fly|Ride"] = 35.43, ["Neon"] = 30.19, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 209.77, ["Mega|Ride"] = 278.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 28.88, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 622.99, ["Mega"] = 327.48, ["Mega|Ride"] = 335.64, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 18.38, ["Fly|Ride"] = 41.96, ["Neon"] = 26.25, ["Neon|Fly"] = 82.86, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 67.99, ["Mega|Fly"] = 213.96, ["Mega|Ride"] = 354.02, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.13, ["Fly"] = 131.25, ["Ride"] = 98.56, ["Fly|Ride"] = 140.39, ["Neon"] = 324.84, ["Neon|Fly"] = 406.88, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 488.76, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 213.94, ["Fly|Ride"] = 279.9, ["Neon|Ride"] = 2621.68, ["Neon|Fly|Ride"] = 1258.08, ["Mega"] = 10487.92, ["Mega|Fly|Ride"] = 6707.26}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 83.87, ["Fly"] = 124.48, ["Ride"] = 98.38, ["Fly|Ride"] = 131.25, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 384.92, ["Mega|Fly|Ride"] = 1517.62}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.68, ["Ride"] = 53.48, ["Fly|Ride"] = 140.54, ["Neon"] = 23.5, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 157.5, ["Mega|Ride"] = 193.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.75, ["Fly"] = 68.14, ["Ride"] = 35.38, ["Fly|Ride"] = 66.94, ["Neon"] = 125.72, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 348.77, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 501.27}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 20.83, ["Fly|Ride"] = 42, ["Neon"] = 6.04, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 83.92, ["Mega|Fly"] = 210.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.24, ["Fly"] = 72.1, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 40.91, ["Neon|Ride"] = 157.9, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 791.85, ["Mega|Ride"] = 405.9, ["Mega|Fly|Ride"] = 560}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 18.8, ["Fly|Ride"] = 49.29, ["Neon"] = 14.58, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 181.74, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 37.77, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 236.02, ["Mega"] = 207.37, ["Mega|Ride"] = 236.02, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.55, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 25.15, ["Mega|Ride"] = 39.87, ["Mega|Fly|Ride"] = 224.43}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.34, ["Ride"] = 20.9, ["Fly|Ride"] = 48.24, ["Neon"] = 13.13, ["Neon|Fly"] = 104.88, ["Neon|Ride"] = 41.96, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 81.36, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.06, ["Fly|Ride"] = 39.38, ["Neon"] = 20.98, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 205.34, ["Mega|Fly|Ride"] = 233.87}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 183.75, ["Fly"] = 200.21, ["Ride"] = 212.63, ["Fly|Ride"] = 280.88, ["Neon"] = 700.87, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 628.69, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2181.51}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.69, ["Ride"] = 240.91, ["Fly|Ride"] = 204.5, ["Neon"] = 41.96, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 98.6, ["Mega"] = 307.47, ["Mega|Ride"] = 371.73, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Fly|Ride"] = 41.92, ["Neon"] = 28.23, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 131.25, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 59.06, ["Ride"] = 59, ["Fly|Ride"] = 178.5, ["Neon"] = 106.32, ["Neon|Ride"] = 119.75, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 489.8, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 531.68}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 28.48, ["Neon"] = 28.23, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 299.25, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 545.31}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.44, ["Fly"] = 36.7, ["Ride"] = 27.56, ["Fly|Ride"] = 59.06, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2097.59, ["Mega|Ride"] = 693.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 3.93, ["Neon|Ride"] = 52.07, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 46.15, ["Mega|Fly"] = 414.29, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.99, ["Fly"] = 26.88, ["Ride"] = 28.31, ["Fly|Ride"] = 62.26, ["Neon"] = 83.91, ["Neon|Ride"] = 49.3, ["Mega"] = 140.42, ["Mega|Fly"] = 394.15, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.08, ["Ride"] = 20.98, ["Fly|Ride"] = 45.65, ["Neon"] = 19.85, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 124.68, ["Mega|Ride"] = 125.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 3.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.07, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 31.5, ["Mega|Ride"] = 78.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 33.91, ["Fly"] = 125.79, ["Ride"] = 69.62, ["Fly|Ride"] = 167.74, ["Neon"] = 236.25, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 876.44, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 841.7}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.73, ["Ride"] = 52.5, ["Fly|Ride"] = 210, ["Neon"] = 41.96, ["Neon|Fly|Ride"] = 209.77, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.86, ["Fly"] = 131.25, ["Ride"] = 52.5, ["Fly|Ride"] = 134.86, ["Neon"] = 38.03, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 95.81, ["Neon|Fly|Ride"] = 182.52, ["Mega|Ride"] = 414.29, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 45.94, ["Fly"] = 98.54, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 280.01, ["Neon|Ride"] = 314.62, ["Neon|Fly|Ride"] = 335.64, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.28, ["Fly"] = 39.38, ["Ride"] = 24.94, ["Fly|Ride"] = 62.91, ["Neon"] = 44.05, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 263.82, ["Mega|Ride"] = 309.41, ["Mega|Fly|Ride"] = 356.61}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 78.75, ["Fly"] = 145.69, ["Ride"] = 122.26, ["Fly|Ride"] = 196.88, ["Neon"] = 203.43, ["Neon|Ride"] = 259.66, ["Neon|Fly|Ride"] = 373.14, ["Mega"] = 979.58, ["Mega|Ride"] = 1090.76, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 39.37, ["Ride"] = 82.69, ["Fly|Ride"] = 173.25, ["Neon"] = 97.01, ["Neon|Ride"] = 112.22, ["Neon|Fly|Ride"] = 309.41, ["Mega"] = 418.48, ["Mega|Ride"] = 355.04, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.99, ["Fly"] = 69.5, ["Ride"] = 27.27, ["Fly|Ride"] = 300.87, ["Neon"] = 80.76, ["Neon|Ride"] = 84.92, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 105, ["Mega|Ride"] = 1048.81, ["Mega|Fly|Ride"] = 401.16}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 21, ["Ride"] = 78.75, ["Fly|Ride"] = 103.69, ["Neon"] = 28.32, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 398.55, ["Mega"] = 326.54, ["Mega|Fly"] = 390.16, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 533.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.81, ["Ride"] = 42, ["Fly|Ride"] = 135.61, ["Neon"] = 63.73, ["Neon|Ride"] = 94.41, ["Mega"] = 471.69, ["Mega|Ride"] = 418.48, ["Mega|Fly|Ride"] = 476.16}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Fly"] = 41.96, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 95.45, ["Mega"] = 18.38, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 26.22, ["Fly|Ride"] = 435.05, ["Neon"] = 14.65, ["Neon|Fly"] = 125.86, ["Neon|Ride"] = 83.83, ["Mega"] = 133.55, ["Mega|Ride"] = 231.8, ["Mega|Fly|Ride"] = 471.69}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 103.83, ["Mega"] = 182.52, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.16, ["Ride"] = 31.44, ["Fly|Ride"] = 116.84, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 272.7, ["Mega"] = 123.38, ["Mega|Ride"] = 153.15, ["Mega|Fly|Ride"] = 158.1}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.29, ["Ride"] = 498.75, ["Fly|Ride"] = 607.72, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.13, ["Fly"] = 28.31, ["Ride"] = 25.17, ["Fly|Ride"] = 54.54, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 210, ["Mega"] = 280.04, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.5, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 83.88, ["Neon"] = 62.93, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.31, ["Mega"] = 472.03, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Fly"] = 28.31, ["Ride"] = 23.63, ["Fly|Ride"] = 314.62, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.75, ["Mega|Ride"] = 630.15, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.17, ["Fly|Ride"] = 140.54, ["Neon"] = 12.59, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 123.78, ["Mega"] = 81.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 209.51}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.24, ["Ride"] = 18.83, ["Neon"] = 2.88, ["Neon|Ride"] = 31.13, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 31.46, ["Mega|Fly"] = 182.52, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 220.64}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1546.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.74, ["Ride"] = 28.88, ["Neon"] = 55.13, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 88.02, ["Mega|Ride"] = 453.09, ["Mega|Fly|Ride"] = 615.58}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 8.4, ["Neon|Ride"] = 40.68, ["Mega"] = 131.25, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 98.39, ["Ride"] = 25.17, ["Fly|Ride"] = 574.38, ["Neon"] = 13.15, ["Neon|Fly"] = 125.86, ["Neon|Ride"] = 62.93, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 125.87, ["Mega|Ride"] = 158.15, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1398.93, ["Neon|Fly|Ride"] = 1524.96, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.45, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 28.3, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 448.43, ["Mega|Fly|Ride"] = 489.74}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.31, ["Neon"] = 5.93, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 113.29, ["Mega"] = 49.87, ["Mega|Fly"] = 189, ["Mega|Ride"] = 83.92, ["Mega|Fly|Ride"] = 260.51}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 838.64, ["Neon"] = 2.63, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 266.41, ["Mega"] = 21, ["Mega|Ride"] = 146.84, ["Mega|Fly|Ride"] = 192.96}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 9.18, ["Fly"] = 56.27, ["Ride"] = 70.2, ["Fly|Ride"] = 161.52, ["Neon"] = 94.41, ["Neon|Ride"] = 104.88, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 333.97, ["Mega|Fly|Ride"] = 362.9}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 26.24, ["Ride"] = 112.19, ["Neon"] = 106.21, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 834.75, ["Mega"] = 560.07, ["Mega|Fly|Ride"] = 1112.36}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.87, ["Ride"] = 31.49, ["Fly|Ride"] = 140.54, ["Neon"] = 105, ["Neon|Ride"] = 200.82, ["Mega"] = 645.01, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 23.29, ["Ride"] = 43.32, ["Fly|Ride"] = 262.5, ["Neon"] = 174.65, ["Neon|Ride"] = 155.04, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 525, ["Mega|Ride"] = 474.07, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 373.16, ["Ride"] = 415.86, ["Fly|Ride"] = 616.88, ["Neon"] = 1398.93, ["Neon|Ride"] = 944, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3593.08}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.25, ["Fly"] = 28.3, ["Ride"] = 22.98, ["Fly|Ride"] = 112.19, ["Neon"] = 98.44, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 137.64, ["Mega|Ride"] = 538.59, ["Mega|Fly|Ride"] = 738.27}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 23.5, ["Ride"] = 103.69, ["Mega"] = 1258.57, ["Mega|Fly|Ride"] = 1677.88}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.07, ["Ride"] = 60.37, ["Fly|Ride"] = 155.67, ["Neon"] = 47.24, ["Neon|Ride"] = 96, ["Neon|Fly|Ride"] = 205.34, ["Mega"] = 218.44, ["Mega|Ride"] = 222.92, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 116.38, ["Neon"] = 14.43, ["Neon|Ride"] = 112.61, ["Neon|Fly|Ride"] = 208.72, ["Mega"] = 44.01, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 236.02}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 39.38, ["Ride"] = 127.71, ["Neon"] = 284.21, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 471.97, ["Mega"] = 2517.12, ["Mega|Ride"] = 1338.18, ["Mega|Fly|Ride"] = 1256.47}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 585.43, ["Ride"] = 31.49, ["Neon"] = 11.8, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 42.49, ["Neon|Fly|Ride"] = 155.77, ["Mega"] = 78.49, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.31, ["Fly|Ride"] = 98.56, ["Neon"] = 4.73, ["Neon|Fly"] = 419.48, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.19, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 146.48}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 4.22, ["Ride"] = 61.69, ["Fly|Ride"] = 111.51, ["Neon"] = 17.71, ["Neon|Fly|Ride"] = 699.57, ["Mega"] = 255.94, ["Mega|Fly"] = 629.29, ["Mega|Ride"] = 241.23, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.49, ["Ride"] = 110.86, ["Fly|Ride"] = 315.02, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Ride"] = 263.13, ["Fly|Ride"] = 329.44, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 12585.5, ["Mega|Fly|Ride"] = 4719.33}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Fly|Ride"] = 77.44, ["Neon"] = 41.76, ["Mega"] = 99.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 471.97}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.57, ["Ride"] = 35.65, ["Neon"] = 20.9, ["Mega"] = 91.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 32.82, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 20.96, ["Fly|Ride"] = 79.72, ["Neon"] = 6.45, ["Neon|Ride"] = 35.38, ["Neon|Fly|Ride"] = 90.46, ["Mega"] = 51.19, ["Mega|Ride"] = 65.41, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.58, ["Fly|Ride"] = 276.97, ["Neon"] = 7.87, ["Neon|Ride"] = 52.5, ["Mega"] = 39.38, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 204.52, ["Mega|Fly|Ride"] = 280.01}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.71, ["Fly|Ride"] = 41.94, ["Neon"] = 5.25, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.38, ["Mega|Ride"] = 95.45, ["Mega|Fly|Ride"] = 112.11}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 20.96, ["Fly|Ride"] = 40.57, ["Neon"] = 6.51, ["Neon|Fly"] = 73.17, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.26, ["Mega"] = 170.63, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 35.63, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 225.39, ["Neon|Ride"] = 236.01, ["Mega"] = 393.75, ["Mega|Fly"] = 498.75, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 85.12, ["Fly"] = 582.75, ["Ride"] = 102.38, ["Fly|Ride"] = 419.32, ["Neon"] = 363.57, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 695.36, ["Mega"] = 1470, ["Mega|Ride"] = 2234.98, ["Mega|Fly|Ride"] = 2061.52}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 53.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 18.88, ["Fly|Ride"] = 30.17, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.13, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 42, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 7.88, ["Ride"] = 27.27, ["Fly|Ride"] = 140.49, ["Neon"] = 251.69, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 105, ["Mega"] = 626.82, ["Mega|Ride"] = 350.32, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 363.82, ["Fly"] = 393.74, ["Ride"] = 419.32, ["Fly|Ride"] = 489.74, ["Neon|Ride"] = 1468.15, ["Neon|Fly|Ride"] = 1572.15, ["Mega"] = 7867.29, ["Mega|Fly|Ride"] = 5243.33}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 39.38, ["Fly"] = 140.46, ["Ride"] = 67.05, ["Fly|Ride"] = 140.54, ["Neon"] = 223.13, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 1076.08, ["Mega|Ride"] = 1187.88, ["Mega|Fly|Ride"] = 1026.5}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 77.53, ["Neon"] = 10.5, ["Neon|Ride"] = 62.93, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 83.15, ["Mega|Ride"] = 120.43, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 209.65, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 71.32, ["Neon|Ride"] = 167.81, ["Mega"] = 196.14}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 36.75, ["Fly"] = 77.58, ["Ride"] = 56.62, ["Fly|Ride"] = 65.63, ["Neon|Fly"] = 313.57, ["Neon|Ride"] = 158.13, ["Neon|Fly|Ride"] = 448.9, ["Mega"] = 2517.12, ["Mega|Ride"] = 943.92, ["Mega|Fly|Ride"] = 1101.97}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 119.18, ["Fly"] = 209.65, ["Ride"] = 98.74, ["Fly|Ride"] = 159.21, ["Neon"] = 414.87, ["Neon|Ride"] = 280.01, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3077.17, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 235.91, ["Fly"] = 277.19, ["Ride"] = 249.38, ["Fly|Ride"] = 354.01, ["Neon"] = 960.51, ["Neon|Ride"] = 838.94, ["Neon|Fly|Ride"] = 888.57, ["Mega|Fly|Ride"] = 3170.51}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 17.69, ["Ride"] = 7337.96, ["Fly|Ride"] = 213.87, ["Neon"] = 149.63, ["Neon|Ride"] = 138.77, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 377.58, ["Mega|Ride"] = 417.43, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 17.18, ["Fly|Ride"] = 40.05, ["Neon"] = 15.75, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.3, ["Fly"] = 27.43, ["Ride"] = 28.3, ["Fly|Ride"] = 45.94, ["Neon"] = 37.77, ["Neon|Fly"] = 146.83, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 250.79, ["Mega|Ride"] = 244.39, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 288.64, ["Ride"] = 315, ["Fly|Ride"] = 406.88, ["Neon"] = 1465.55, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1441.06, ["Mega|Fly|Ride"] = 4754.65}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.13, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 48.49, ["Mega|Ride"] = 157.34, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.48, ["Ride"] = 18.38, ["Fly|Ride"] = 66.08, ["Neon"] = 41.64, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 140.55, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 174.97, ["Mega|Fly|Ride"] = 315.04}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 11.54, ["Ride"] = 116.81, ["Neon"] = 104.9, ["Neon|Fly"] = 419.48, ["Neon|Ride"] = 152.25, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 466.48, ["Mega|Fly"] = 419.53, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 129.94, ["Fly"] = 278.82, ["Ride"] = 146.89, ["Fly|Ride"] = 200.24, ["Neon"] = 708, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 643.19, ["Mega|Fly|Ride"] = 2932.08}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 30.4, ["Fly"] = 45.05, ["Ride"] = 28.88, ["Fly|Ride"] = 47.25, ["Neon"] = 76.13, ["Neon|Ride"] = 98.47, ["Neon|Fly|Ride"] = 146.68, ["Mega"] = 398.55, ["Mega|Ride"] = 417.75, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Ride"] = 201.79, ["Neon|Fly|Ride"] = 699.57, ["Mega"] = 26.25, ["Mega|Ride"] = 103.84, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.71, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 158.13, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 32.49, ["Mega|Fly"] = 140.44, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.85, ["Fly"] = 418.69, ["Ride"] = 61.69, ["Fly|Ride"] = 155.23, ["Neon"] = 39.87, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 149.43, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 279.72}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1434.46, ["Ride"] = 1277.88, ["Fly|Ride"] = 1310.4, ["Neon|Ride"] = 6991.45, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 393.65, ["Ride"] = 480.63, ["Fly|Ride"] = 618.19, ["Neon"] = 1903.11, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1399.11, ["Mega"] = 16780.67, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 308.63, ["Fly"] = 376.69, ["Ride"] = 343.5, ["Fly|Ride"] = 420, ["Neon"] = 735, ["Neon|Fly"] = 1259.06, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2932.08}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 332.06, ["Fly"] = 492.64, ["Ride"] = 393.75, ["Fly|Ride"] = 459.38, ["Neon"] = 1048.67, ["Neon|Fly"] = 3147.02, ["Neon|Ride"] = 1048.67, ["Neon|Fly|Ride"] = 1092, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 4097.64}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 17.07, ["Fly|Ride"] = 44.63, ["Neon"] = 6.91, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 106.99, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 405.57, ["Ride"] = 472.5, ["Fly|Ride"] = 611.2, ["Neon"] = 1312.5, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 13109.9, ["Mega|Fly|Ride"] = 4776.19}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.17, ["Neon"] = 10.49, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 67.96, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 207.8}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 20.98, ["Fly|Ride"] = 39.38, ["Neon"] = 15.73, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 107.31, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 315.04}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 19.69, ["Neon"] = 5.25, ["Neon|Fly"] = 40.14, ["Neon|Ride"] = 39.37, ["Mega"] = 32.81, ["Mega|Fly"] = 83.92, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 350.27, ["Neon|Fly|Ride"] = 208.72, ["Mega"] = 2097.59, ["Mega|Fly|Ride"] = 985.77}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.07, ["Fly|Ride"] = 60.44, ["Neon"] = 106.21, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.94, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 48.78, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 699.57, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 309.37}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 20.74, ["Fly|Ride"] = 41.5, ["Neon"] = 6.57, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 70.26, ["Mega"] = 61.67, ["Mega|Fly"] = 175.17, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 164.19}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.93, ["Fly"] = 47.2, ["Ride"] = 21.25, ["Fly|Ride"] = 51.45, ["Neon"] = 111.17, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 1296.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.7, ["Ride"] = 52.5, ["Neon|Ride"] = 280.01, ["Neon|Fly|Ride"] = 311.54, ["Mega"] = 394.15, ["Mega|Ride"] = 448.9, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 27.15, ["Fly|Ride"] = 70.27, ["Neon"] = 47.25, ["Neon|Ride"] = 97.96, ["Neon|Fly|Ride"] = 280.04, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 22.74, ["Ride"] = 19.69, ["Fly|Ride"] = 55.47, ["Neon"] = 3.93, ["Neon|Fly"] = 31.47, ["Neon|Ride"] = 26.25, ["Mega"] = 43.32, ["Mega|Ride"] = 83.92, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 228.22, ["Ride"] = 258.57, ["Fly|Ride"] = 354.38, ["Neon|Ride"] = 1139.92, ["Neon|Fly|Ride"] = 1105.44, ["Mega"] = 8390.34, ["Mega|Fly|Ride"] = 4886.79}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.55, ["Ride"] = 19.59, ["Fly|Ride"] = 37.75, ["Neon"] = 3.93, ["Neon|Fly"] = 20.98, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 59.73, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.18, ["Ride"] = 45.94, ["Fly|Ride"] = 182.48, ["Neon"] = 70.19, ["Neon|Ride"] = 98.44, ["Mega"] = 390.16, ["Mega|Ride"] = 448.9, ["Mega|Fly|Ride"] = 745.66}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 47.25, ["Fly"] = 131.25, ["Ride"] = 104.74, ["Fly|Ride"] = 170.63, ["Neon"] = 262.5, ["Neon|Ride"] = 188.77, ["Mega"] = 839.05, ["Mega|Ride"] = 808.64, ["Mega|Fly|Ride"] = 836.84}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 192.94, ["Ride"] = 227.07, ["Fly|Ride"] = 275.63, ["Neon"] = 787.05, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 3352.05, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 18.38, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 280.01, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 699.48}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 32.45, ["Ride"] = 419.32, ["Fly|Ride"] = 629.22, ["Neon"] = 304.91, ["Neon|Ride"] = 321.96, ["Neon|Fly|Ride"] = 839.05, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1115.63, ["Fly"] = 1441.13, ["Ride"] = 1181.25, ["Fly|Ride"] = 1164.19, ["Neon|Ride"] = 5593.59, ["Neon|Fly|Ride"] = 4415.25, ["Mega|Fly|Ride"] = 16499.67}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.8, ["Fly"] = 27.26, ["Ride"] = 22.08, ["Fly|Ride"] = 53.48, ["Neon"] = 79.07, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 59.03, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 222.36, ["Mega|Ride"] = 228.65, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.2, ["Fly"] = 39.38, ["Ride"] = 35.43, ["Neon"] = 37.77, ["Neon|Ride"] = 140.39, ["Mega"] = 212.63, ["Mega|Ride"] = 174.48, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 7.87, ["Ride"] = 31.86, ["Fly|Ride"] = 524.98, ["Neon"] = 61.88, ["Mega"] = 261.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 838.94}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 19.57, ["Fly"] = 699.13, ["Ride"] = 42, ["Fly|Ride"] = 140.54, ["Neon"] = 87.94, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.62, ["Mega|Ride"] = 430.32, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 17, ["Fly|Ride"] = 261.19, ["Neon"] = 21.92, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 414.04, ["Neon"] = 12.03, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 54.07, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 182.52, ["Mega|Ride"] = 134.97, ["Mega|Fly|Ride"] = 355.51}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 251.56, ["Ride"] = 314.5, ["Fly|Ride"] = 335.47, ["Neon|Ride"] = 1468.15, ["Neon|Fly|Ride"] = 1399.11, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4865.81}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.3, ["Fly|Ride"] = 59.07, ["Neon"] = 14.85, ["Neon|Fly"] = 83.91, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 98.85, ["Mega|Ride"] = 104.78, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.33, ["Ride"] = 66.95, ["Neon"] = 32.71, ["Neon|Ride"] = 188.27, ["Mega"] = 276.9, ["Mega|Ride"] = 280.04}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 6.57, ["Fly"] = 58.46, ["Ride"] = 40.11, ["Neon"] = 17.07, ["Neon|Fly"] = 70.27, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 165.73, ["Mega|Fly"] = 419.53, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 288.25}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 216.2, ["Fly"] = 354.9, ["Ride"] = 307.13, ["Fly|Ride"] = 420, ["Neon"] = 713.11, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 944.05, ["Mega"] = 3035.22, ["Mega|Ride"] = 3143.31, ["Mega|Fly|Ride"] = 2864.1}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 30.19, ["Fly"] = 40.74, ["Ride"] = 45.93, ["Fly|Ride"] = 158.82, ["Neon"] = 181.33, ["Neon|Ride"] = 159.42, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 741.51, ["Mega|Fly|Ride"] = 715.32}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.51, ["Ride"] = 40.89, ["Neon"] = 141.62, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 217.93, ["Mega"] = 417.38, ["Mega|Ride"] = 557.97, ["Mega|Fly|Ride"] = 560.07}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 30.83, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 84, ["Fly"] = 125.04, ["Ride"] = 122.07, ["Fly|Ride"] = 183.75, ["Neon"] = 347.82, ["Neon|Fly"] = 471.78, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1227.29}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.82, ["Neon"] = 5.25, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 588, ["Mega"] = 37.77, ["Mega|Ride"] = 209.77}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.07, ["Fly"] = 126.21, ["Ride"] = 28.88, ["Fly|Ride"] = 88.5, ["Neon"] = 83.91, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.62, ["Fly"] = 80.01, ["Ride"] = 90.04, ["Fly|Ride"] = 147, ["Neon"] = 199.29, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 346.98, ["Mega|Ride"] = 1215.57, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 16.79, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 18.88, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 25.18, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 53.5, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.59, ["Ride"] = 33.48, ["Fly|Ride"] = 112.88, ["Neon"] = 23.63, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 271.04, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 11.82, ["Fly"] = 42.48, ["Ride"] = 80.73, ["Neon"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 630.15, ["Mega"] = 586.69, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.77, ["Neon"] = 2.62, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 136.36, ["Mega"] = 24.13, ["Mega|Ride"] = 73.5}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 4.98, ["Fly"] = 210, ["Ride"] = 49.88, ["Fly|Ride"] = 111.57, ["Neon"] = 77.48, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 313.61, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 273.93, ["Mega|Fly|Ride"] = 657.53}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 17.69, ["Fly"] = 41.94, ["Ride"] = 23.63, ["Fly|Ride"] = 83.91, ["Neon"] = 136.5, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1117.89}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 58.95, ["Fly|Ride"] = 76.01, ["Neon"] = 18.38, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.31, ["Mega"] = 182.52, ["Mega|Ride"] = 197.33, ["Mega|Fly|Ride"] = 280.01}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 19.69, ["Fly"] = 2096.32, ["Ride"] = 94.4, ["Neon"] = 65.94, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6293.12, ["Mega|Ride"] = 1149.11, ["Mega|Fly|Ride"] = 1149.11}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 4.73, ["Neon|Fly"] = 50.35, ["Neon|Ride"] = 70.27, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.87, ["Mega|Fly|Ride"] = 520.15}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Mega"] = 26.24, ["Mega|Fly|Ride"] = 435.22}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 40.13}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 72.19, ["Fly"] = 102.38, ["Ride"] = 78.75, ["Fly|Ride"] = 116.41, ["Neon"] = 155.23, ["Neon|Ride"] = 200.46, ["Neon|Fly|Ride"] = 560.07, ["Mega"] = 1105.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 140.54, ["Neon"] = 3.29, ["Mega"] = 28.3, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Fly"] = 796.61, ["Ride"] = 493.76, ["Fly|Ride"] = 518.44, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16780.67, ["Mega|Fly|Ride"] = 13982.89}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 82.78, ["Neon"] = 12.85, ["Neon|Ride"] = 278.96, ["Mega"] = 78.59, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 560}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 158.05, ["Ride"] = 23.62, ["Fly|Ride"] = 55.13, ["Neon"] = 16.99, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 279.57, ["Mega|Ride"] = 155.24, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 30.19, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 91.88, ["Neon|Ride"] = 181.13, ["Mega"] = 507.63, ["Mega|Ride"] = 448.9, ["Mega|Fly|Ride"] = 541.19}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.59, ["Fly"] = 131.25, ["Ride"] = 31.5, ["Fly|Ride"] = 43.32, ["Mega"] = 223.13, ["Mega|Ride"] = 251.72}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.19, ["Ride"] = 65.63, ["Fly|Ride"] = 132.69, ["Neon"] = 78.66, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 519.17, ["Mega|Ride"] = 489.8, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.36, ["Fly"] = 70.2, ["Ride"] = 48.24, ["Fly|Ride"] = 188.77, ["Neon"] = 52.5, ["Neon|Ride"] = 155.3, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 189, ["Mega|Fly"] = 486.66, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Ride"] = 16.79, ["Neon|Fly|Ride"] = 74.72, ["Mega"] = 22.28, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 28.33, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.39, ["Ride"] = 27.57, ["Fly|Ride"] = 158.13, ["Neon"] = 27.57, ["Neon|Fly"] = 118.01, ["Neon|Ride"] = 70.27, ["Neon|Fly|Ride"] = 314.65, ["Mega"] = 189, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 301.88, ["Ride"] = 335.41, ["Fly|Ride"] = 393.75, ["Neon"] = 1480.5, ["Neon|Ride"] = 1148.61, ["Neon|Fly|Ride"] = 1363.45, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 83.91, ["Ride"] = 150.94, ["Fly|Ride"] = 235.97, ["Neon"] = 482.41, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4195.17, ["Mega|Ride"] = 1720.03, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.07, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 48.25, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 98.6, ["Mega|Fly"] = 208.72, ["Mega|Ride"] = 91.26, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.71, ["Fly|Ride"] = 41.92, ["Neon"] = 6.46, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70.82, ["Mega"] = 85.32, ["Mega|Fly"] = 350.32, ["Mega|Ride"] = 111.19, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 140.55, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231.66, ["Ride"] = 237.57, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1256.47, ["Mega|Ride"] = 8390.34, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 18.37, ["Fly|Ride"] = 45.63, ["Neon"] = 31.47, ["Neon|Fly"] = 158.13, ["Neon|Ride"] = 40.91, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 301.02, ["Mega|Ride"] = 255.91, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.56, ["Fly"] = 158.06, ["Ride"] = 96.48, ["Fly|Ride"] = 209.67, ["Neon"] = 33.57, ["Neon|Ride"] = 74.87, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 30.32, ["Mega"] = 46.73, ["Mega|Ride"] = 96.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 20.9, ["Ride"] = 27.57, ["Fly|Ride"] = 79.72, ["Neon"] = 78.3, ["Neon|Ride"] = 101.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 360.75}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.39, ["Ride"] = 91.88, ["Fly|Ride"] = 210, ["Neon"] = 105, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 140.17, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 477.75, ["Mega|Fly"] = 2202.47, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 589.42}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.44, ["Fly"] = 158.06, ["Ride"] = 51.33, ["Fly|Ride"] = 81.36, ["Neon"] = 123.42, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 182.31, ["Neon|Fly|Ride"] = 247.53, ["Mega"] = 786.61, ["Mega|Ride"] = 786.51, ["Mega|Fly|Ride"] = 944.05}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 15.73, ["Fly|Ride"] = 41.94, ["Neon"] = 2.1, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 61.89, ["Mega"] = 24.94, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 261.41, ["Ride"] = 288.29, ["Fly|Ride"] = 392.44, ["Neon"] = 2490.91, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1143.97, ["Mega|Fly|Ride"] = 4298.48}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.34, ["Fly"] = 140.39, ["Ride"] = 45.94, ["Neon"] = 103.84, ["Neon|Ride"] = 158.13, ["Neon|Fly|Ride"] = 321.56, ["Mega|Ride"] = 476.16, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 18.36, ["Fly|Ride"] = 39.32, ["Neon"] = 5.25, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.19, ["Mega"] = 49.24, ["Mega|Fly"] = 179.36, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 299.69}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 17.07, ["Fly|Ride"] = 56.58, ["Neon"] = 3.21, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.13, ["Neon|Fly|Ride"] = 97.76, ["Mega"] = 24.93, ["Mega|Fly"] = 141.63, ["Mega|Ride"] = 50.36, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.28, ["Fly|Ride"] = 91.14, ["Neon"] = 10.31, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 79.08, ["Mega"] = 93.08, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.12, ["Fly"] = 53.44, ["Ride"] = 27.57, ["Fly|Ride"] = 50.76, ["Neon"] = 63, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 249.38, ["Mega|Fly"] = 787.1, ["Mega|Ride"] = 278.99, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.54, ["Ride"] = 26.24, ["Fly|Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 262.5, ["Mega|Ride"] = 278.99, ["Mega|Fly|Ride"] = 309.41}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 44.63, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 84, ["Mega"] = 26.17, ["Mega|Ride"] = 60.78}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 11.82, ["Ride"] = 36.68, ["Fly|Ride"] = 83.91, ["Neon"] = 21, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 140.55, ["Mega|Fly"] = 266.41, ["Mega|Ride"] = 266.41, ["Mega|Fly|Ride"] = 283.29}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 125.81, ["Neon"] = 3.94, ["Neon|Fly"] = 98.59, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.15, ["Mega"] = 48.26, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 315.04}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.68, ["Ride"] = 23.39, ["Fly|Ride"] = 84, ["Neon"] = 3.93, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 83.83, ["Mega"] = 73.42, ["Mega|Ride"] = 81.54, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 665.34, ["Ride"] = 727.13, ["Fly|Ride"] = 735, ["Neon"] = 4176.84, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3321.67, ["Mega|Ride"] = 15383.68, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 16.96, ["Fly|Ride"] = 49.24, ["Neon"] = 27.44, ["Neon|Fly"] = 50.35, ["Neon|Ride"] = 36.6, ["Neon|Fly|Ride"] = 99.07, ["Mega"] = 187.76, ["Mega|Fly|Ride"] = 209.75}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 69.57, ["Fly|Ride"] = 104.85, ["Neon"] = 7.76, ["Neon|Fly"] = 838.94, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 52.45, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 103.37, ["Mega|Fly|Ride"] = 155.81}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 14.44, ["Fly"] = 32.82, ["Ride"] = 22.42, ["Fly|Ride"] = 70.81, ["Neon"] = 38.07, ["Neon|Fly"] = 112.22, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 182.44, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 17.07, ["Fly|Ride"] = 40.69, ["Neon"] = 6.57, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 70.28, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.5, ["Ride"] = 103.69, ["Fly|Ride"] = 208.62, ["Neon"] = 291.37, ["Neon|Ride"] = 266.37, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 699.57, ["Mega|Ride"] = 1399.11, ["Mega|Fly|Ride"] = 744.57}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 91.25, ["Neon"] = 7.77, ["Neon|Fly"] = 134.54, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 61.69, ["Mega|Ride"] = 138.46, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.48, ["Ride"] = 23.5, ["Fly|Ride"] = 59.79, ["Neon"] = 17.69, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 448.9, ["Mega"] = 140.55, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 152.13}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.85, ["Neon"] = 15.74, ["Neon|Fly"] = 63.73, ["Neon|Ride"] = 110.93, ["Mega"] = 116.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Fly|Ride"] = 83.91, ["Neon"] = 5.16, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 91.14, ["Mega"] = 52.5, ["Mega|Fly"] = 178.31, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 159.44}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.69, ["Fly"] = 37.75, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 103.69, ["Neon|Ride"] = 83.74, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 839.05, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 403.22}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 736.75, ["Ride"] = 746.82, ["Fly|Ride"] = 838.69, ["Neon"] = 1903.13, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8194.15, ["Mega|Ride"] = 6418.62, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 17.69, ["Fly|Ride"] = 43.32, ["Neon"] = 3.93, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 60.35, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 269.72}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 38.67, ["Fly|Ride"] = 92.19, ["Neon"] = 56.22, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.02, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 531.68}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 73.5, ["Ride"] = 85.32, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 362.85, ["Neon|Fly|Ride"] = 398.55, ["Mega"] = 1538.59, ["Mega|Fly|Ride"] = 1603.67}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 44.54, ["Ride"] = 66, ["Fly|Ride"] = 140.38, ["Neon"] = 131.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 1944.47, ["Mega|Ride"] = 839.05}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.57, ["Ride"] = 26.25, ["Neon"] = 93.09, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 335.64, ["Mega|Ride"] = 350.32, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 28.31, ["Ride"] = 94.4, ["Neon"] = 41.96, ["Neon|Fly"] = 362.28, ["Neon|Ride"] = 362.28, ["Mega"] = 456.1, ["Mega|Fly"] = 512.14, ["Mega|Ride"] = 361.1, ["Mega|Fly|Ride"] = 526.98}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.67, ["Fly"] = 63, ["Ride"] = 104.85, ["Neon"] = 83.91, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 314.89, ["Mega"] = 924, ["Mega|Ride"] = 728.44}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 11.82}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.29, ["Ride"] = 24.94, ["Fly|Ride"] = 78.75, ["Neon"] = 32.52, ["Neon|Ride"] = 104.77, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 204.75, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Ride"] = 47.21, ["Neon"] = 36.75, ["Mega"] = 880.9, ["Mega|Fly|Ride"] = 943.82}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 69.57, ["Fly"] = 393.75, ["Ride"] = 87.82, ["Fly|Ride"] = 123.67, ["Neon"] = 394.12, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 944.05, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1091.53}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.63, ["Fly"] = 27.57, ["Ride"] = 19.93, ["Fly|Ride"] = 43.32, ["Neon"] = 26.17, ["Neon|Fly"] = 41.96, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 77.26, ["Mega"] = 262.5, ["Mega|Fly"] = 418.48, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 237.04}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 10.5, ["Fly"] = 83.87, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 27.46, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 155.95, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.9, ["Neon|Ride"] = 92.3, ["Mega"] = 63.7, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 82.78, ["Fly"] = 65.63, ["Ride"] = 45.93, ["Fly|Ride"] = 91.87, ["Neon"] = 221.82, ["Neon|Ride"] = 293.64, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 1119.07, ["Mega|Ride"] = 839.05, ["Mega|Fly|Ride"] = 1046.71}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Neon"] = 12.99, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 86.01, ["Mega"] = 47.22, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.81, ["Ride"] = 73.5, ["Neon"] = 83.91, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 369.2, ["Mega"] = 288.75, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 17.05, ["Fly|Ride"] = 35.63, ["Neon"] = 23.63, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 77.55, ["Mega"] = 144.37, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 157.5, ["Neon|Ride"] = 177.19, ["Mega"] = 278.99, ["Mega|Ride"] = 251.72, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.7, ["Ride"] = 36.53, ["Neon"] = 26.25, ["Neon|Ride"] = 110.93, ["Mega"] = 140.55, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 49.34, ["Ride"] = 105, ["Neon"] = 186.67, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 868.1, ["Mega|Ride"] = 1399.11, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 23.63, ["Ride"] = 140.49, ["Neon"] = 210, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 389.82, ["Mega|Ride"] = 514.98, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 10.5, ["Ride"] = 104.89, ["Fly|Ride"] = 280.01, ["Neon"] = 167.83, ["Mega|Ride"] = 556.92, ["Mega|Fly|Ride"] = 167.81}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.63, ["Ride"] = 53.75, ["Fly|Ride"] = 529.51, ["Neon"] = 94.5, ["Neon|Ride"] = 111.39, ["Neon|Fly|Ride"] = 453.09, ["Mega"] = 945, ["Mega|Ride"] = 727.88, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 6.04, ["Neon"] = 62.99, ["Neon|Ride"] = 280.01, ["Mega"] = 131.25, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 253.79}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 6.17, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 40.14, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 60.38, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 7.35, ["Ride"] = 47.25, ["Neon"] = 32.82, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 125.87, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 17.85, ["Fly|Ride"] = 56.44, ["Neon"] = 4.73, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 60.37, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 196.35}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 110.35, ["Neon"] = 39.38, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 112.24, ["Mega"] = 232.85, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.17, ["Ride"] = 31.86, ["Fly|Ride"] = 99.75, ["Neon"] = 45.11, ["Neon|Fly"] = 472.01, ["Neon|Ride"] = 96.49, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 1048.67}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 32.51, ["Fly|Ride"] = 42, ["Neon"] = 40.14, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 37.54, ["Neon|Fly|Ride"] = 107.39, ["Mega"] = 225.07, ["Mega|Ride"] = 249.48, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 19.59, ["Fly|Ride"] = 39.38, ["Neon"] = 17.71, ["Neon|Fly"] = 83.91, ["Neon|Ride"] = 70.27, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 150.36, ["Mega|Ride"] = 208.72, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.83, ["Fly"] = 301.88, ["Ride"] = 47.25, ["Fly|Ride"] = 108.94, ["Neon"] = 52.5, ["Neon|Fly"] = 123.76, ["Neon|Ride"] = 81.38, ["Mega"] = 105, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 419.53}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.75, ["Fly"] = 118.13, ["Ride"] = 116.36, ["Fly|Ride"] = 131.25, ["Neon"] = 85.32, ["Neon|Ride"] = 185.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 389.67, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 439.63, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 74.46, ["Ride"] = 100.66, ["Fly|Ride"] = 188.99, ["Neon"] = 308.44, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 1537.54, ["Mega|Ride"] = 981.3, ["Mega|Fly|Ride"] = 1042.86}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.91, ["Ride"] = 21.51, ["Fly|Ride"] = 38.07, ["Neon"] = 3.82, ["Neon|Ride"] = 38.06, ["Mega"] = 31.43, ["Mega|Ride"] = 59.09, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 17.54, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 862.98, ["Mega|Ride"] = 590.03, ["Mega|Fly|Ride"] = 1254.22}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.75, ["Ride"] = 116.82, ["Neon"] = 276.73, ["Neon|Ride"] = 299.74, ["Neon|Fly|Ride"] = 511.82, ["Mega"] = 839.05, ["Mega|Ride"] = 1105.44, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.88, ["Fly"] = 190.32, ["Ride"] = 44.62, ["Fly|Ride"] = 126, ["Neon"] = 56.57, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 210, ["Mega"] = 280.04, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 62.85, ["Fly|Ride"] = 136.71, ["Neon"] = 3.93, ["Neon|Ride"] = 35.64, ["Mega"] = 26.17, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.09, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 27.26, ["Ride"] = 17.05, ["Fly|Ride"] = 58.72, ["Neon"] = 17.69, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 258.44, ["Mega|Fly"] = 350.32, ["Mega|Ride"] = 231.8, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 18.38, ["Fly|Ride"] = 35.66, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 52.45, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.94, ["Ride"] = 19.69, ["Fly|Ride"] = 65.71, ["Neon"] = 4.73, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 39.37, ["Mega|Fly"] = 168, ["Mega|Ride"] = 75.53, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Fly|Ride"] = 158.13, ["Neon"] = 2.63, ["Neon|Ride"] = 125.85, ["Mega"] = 26.25, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 266.37}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.29, ["Ride"] = 31.43, ["Fly|Ride"] = 262.5, ["Neon"] = 72.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 207.67, ["Mega"] = 188.83, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.5, ["Ride"] = 30.19, ["Fly|Ride"] = 83.88, ["Neon"] = 52.19, ["Neon|Ride"] = 70.27, ["Neon|Fly|Ride"] = 234.85, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.87, ["Fly"] = 28.3, ["Ride"] = 27.23, ["Fly|Ride"] = 48.21, ["Neon"] = 39.38, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 312.56, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 81.38, ["Ride"] = 167.63, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 419.53, ["Mega|Fly|Ride"] = 1778.55}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.24, ["Fly"] = 71.72, ["Ride"] = 65.63, ["Fly|Ride"] = 79.07, ["Neon"] = 103.69, ["Mega"] = 628.04, ["Mega|Ride"] = 557.17, ["Mega|Fly|Ride"] = 1280.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 19.69, ["Fly|Ride"] = 37.66, ["Neon"] = 3.94, ["Neon|Fly"] = 28.32, ["Neon|Ride"] = 24.13, ["Neon|Fly|Ride"] = 58.47, ["Mega"] = 36.69, ["Mega|Ride"] = 112.24, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 4.19, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 41.91, ["Mega"] = 47.16, ["Mega|Ride"] = 55.49, ["Mega|Fly|Ride"] = 106.46}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 438.37, ["Fly|Ride"] = 446.24, ["Neon|Ride"] = 1782.74, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 11.47, ["Fly"] = 77.58, ["Ride"] = 140.38, ["Fly|Ride"] = 241.77, ["Neon"] = 105, ["Mega"] = 699.57, ["Mega|Fly|Ride"] = 1314.35}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 70.27, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 38.97, ["Mega|Ride"] = 70.28, ["Mega|Fly|Ride"] = 116.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 78.75, ["Ride"] = 175.07, ["Fly|Ride"] = 223.12, ["Neon"] = 261.19, ["Neon|Ride"] = 304.49, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 934.49}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 31.46, ["Ride"] = 19.57, ["Fly|Ride"] = 45.94, ["Neon"] = 10.4, ["Neon|Fly"] = 42, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 77.84, ["Mega|Fly"] = 83.92, ["Mega|Ride"] = 119.36, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.24, ["Ride"] = 18.88, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.7, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 92.31, ["Mega"] = 24.83, ["Mega|Fly"] = 140.55, ["Mega|Ride"] = 62.64, ["Mega|Fly|Ride"] = 182.34}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 70.88, ["Fly"] = 140.21, ["Ride"] = 131.25, ["Fly|Ride"] = 240.74, ["Neon"] = 219.19, ["Neon|Ride"] = 350.27, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 791.85, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 839.05}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 4.87, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 103.84, ["Mega|Ride"] = 129.74, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.38, ["Ride"] = 76.56, ["Neon"] = 152.24, ["Neon|Ride"] = 167.81, ["Neon|Fly|Ride"] = 367.08, ["Mega"] = 1656.06, ["Mega|Ride"] = 1678.08, ["Mega|Fly|Ride"] = 1099.89}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.63, ["Ride"] = 45.02, ["Fly|Ride"] = 209.67, ["Neon"] = 14.89, ["Neon|Ride"] = 300.57, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 175.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.24, ["Ride"] = 27.27, ["Neon"] = 12.85, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 79.08, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.48, ["Ride"] = 56.62, ["Fly|Ride"] = 105, ["Neon"] = 146.44, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1399.11}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 42, ["Fly|Ride"] = 908.98, ["Neon"] = 6.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 137.16, ["Mega"] = 65.62, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 235.98}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.62, ["Ride"] = 23.07, ["Fly|Ride"] = 102.85, ["Neon"] = 6.62, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 41.96, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 166.78, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.08, ["Fly"] = 35.6, ["Ride"] = 40.03, ["Fly|Ride"] = 45.94, ["Neon"] = 103.69, ["Neon|Ride"] = 105, ["Mega"] = 262.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 388.49}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 38.06, ["Ride"] = 105.37, ["Fly|Ride"] = 78.66, ["Neon"] = 242.82, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 418.48, ["Mega"] = 816.37, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 35.63, ["Fly"] = 50.15, ["Ride"] = 40.13, ["Fly|Ride"] = 81.78, ["Neon"] = 103.85, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 157.34, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 55.13, ["Ride"] = 111.14, ["Fly|Ride"] = 196.84, ["Neon"] = 338.66, ["Neon|Ride"] = 347.11, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 1520.76, ["Mega|Fly|Ride"] = 1253.44}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.24, ["Ride"] = 35.44, ["Neon"] = 19.04, ["Neon|Ride"] = 58.74, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 195.57, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.2, ["Ride"] = 24.94, ["Fly|Ride"] = 78.75, ["Neon"] = 18.27, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 203.44, ["Mega|Ride"] = 182.49, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 26.25, ["Fly"] = 28.31, ["Ride"] = 39.38, ["Fly|Ride"] = 157.5, ["Neon"] = 49.07, ["Neon|Ride"] = 137.39, ["Neon|Fly|Ride"] = 301.83, ["Mega"] = 400.32, ["Mega|Ride"] = 350.32, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.01, ["Fly|Ride"] = 33.57, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 19.67, ["Mega|Fly"] = 70.28, ["Mega|Ride"] = 23.55, ["Mega|Fly|Ride"] = 83.74}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 84, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 266.11, ["Neon"] = 299.74, ["Neon|Fly"] = 2256.27, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 472.03, ["Mega"] = 1119.07, ["Mega|Ride"] = 1258.57, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 94.37, ["Fly|Ride"] = 109.07, ["Neon"] = 3.9, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 188.83, ["Mega"] = 55.49, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.09, ["Ride"] = 15.74, ["Fly|Ride"] = 46.1, ["Neon"] = 24.93, ["Neon|Fly"] = 140.54, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 49.31, ["Mega"] = 107.87, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 335.58}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Ride"] = 138.87, ["Fly|Ride"] = 787.5, ["Neon"] = 328.13, ["Neon|Ride"] = 335.58, ["Neon|Fly|Ride"] = 377.58, ["Mega"] = 1022.44, ["Mega|Ride"] = 1208.82, ["Mega|Fly|Ride"] = 1153.69}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 6.08, ["Neon|Ride"] = 43.32, ["Mega"] = 72.19, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 280.04}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.73}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 141.43, ["Fly|Ride"] = 67.11, ["Neon"] = 4.73, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 46.16, ["Mega|Ride"] = 120.26, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.94, ["Ride"] = 185.22, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 723.59, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3619.17, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.73, ["Ride"] = 25.5, ["Neon"] = 11.54, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 132.16, ["Mega"] = 145.85, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 464.57}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.76, ["Ride"] = 30.7, ["Neon"] = 47.25, ["Neon|Ride"] = 140.54, ["Mega|Ride"] = 629.29, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 13.13, ["Fly"] = 28.88, ["Ride"] = 26.62, ["Fly|Ride"] = 140.49, ["Neon"] = 82.69, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 146.33, ["Mega"] = 587.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 52.41, ["Ride"] = 169.91, ["Fly|Ride"] = 154.6, ["Neon"] = 212.7, ["Neon|Ride"] = 252.35, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 750.95, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 152.25, ["Fly"] = 249.47, ["Ride"] = 200.05, ["Fly|Ride"] = 221.82, ["Neon"] = 538.12, ["Neon|Fly"] = 628.17, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 576.19, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 14.06, ["Fly"] = 23.63, ["Ride"] = 24.41, ["Fly|Ride"] = 44.76, ["Neon"] = 39.37, ["Neon|Ride"] = 77.62, ["Neon|Fly|Ride"] = 91.87, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 37.77, ["Fly|Ride"] = 91.88, ["Neon"] = 13.84, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 87.92, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 99.75, ["Mega|Ride"] = 158.15, ["Mega|Fly|Ride"] = 280.01}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.74, ["Fly"] = 98.54, ["Neon"] = 129.93, ["Mega"] = 1264.86, ["Mega|Ride"] = 418.48, ["Mega|Fly|Ride"] = 648.09}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 49.87, ["Ride"] = 78.75, ["Fly|Ride"] = 118.12, ["Neon"] = 157.38, ["Neon|Ride"] = 226.57, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 881, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.05, ["Ride"] = 81.86, ["Fly|Ride"] = 280.01, ["Neon"] = 91.88, ["Neon|Ride"] = 140.38, ["Mega"] = 797.09, ["Mega|Ride"] = 748.85, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 360.29, ["Neon"] = 908.32, ["Neon|Ride"] = 1090.62, ["Neon|Fly|Ride"] = 1048.81, ["Mega|Fly|Ride"] = 4677.05}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 39.38, ["Ride"] = 56.44, ["Fly|Ride"] = 171.99, ["Neon"] = 178.5, ["Neon|Ride"] = 228.79, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 984.38, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 938.44}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 18.4, ["Ride"] = 15.63, ["Fly|Ride"] = 64.32, ["Neon"] = 2.1, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 28.33, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 126.67}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.83, ["Ride"] = 209.67, ["Neon"] = 30.7, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 158.39, ["Mega|Ride"] = 136.9, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 4.87, ["Ride"] = 41.94, ["Fly|Ride"] = 144.16, ["Neon"] = 15.74, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 166.78, ["Mega"] = 120.62, ["Mega|Fly"] = 545.39, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 315.04}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 380.64, ["Fly"] = 629.86, ["Ride"] = 393.75, ["Fly|Ride"] = 431.82, ["Neon"] = 2097.34, ["Neon|Ride"] = 1818.39, ["Neon|Fly|Ride"] = 1119.07, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 19.46, ["Fly|Ride"] = 52.5, ["Neon"] = 24.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.33, ["Mega|Ride"] = 270.86}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 12.99, ["Fly"] = 31.46, ["Ride"] = 23.62, ["Fly|Ride"] = 39.38, ["Neon"] = 140.54, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 208.72, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 8.4, ["Fly"] = 83.87, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 19.94, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 119.58, ["Mega"] = 111.57, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 131.25, ["Fly"] = 210, ["Fly|Ride"] = 61.69, ["Neon"] = 118.27, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega"] = 943.92, ["Mega|Ride"] = 838, ["Mega|Fly|Ride"] = 643.12}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 31.4, ["Fly|Ride"] = 61.88, ["Neon"] = 16.78, ["Neon|Ride"] = 35.66, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.24, ["Mega|Ride"] = 335.25, ["Mega|Fly|Ride"] = 1313.18}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 12.99, ["Fly"] = 104.16, ["Ride"] = 31.5, ["Fly|Ride"] = 69.6, ["Neon"] = 78.75, ["Neon|Ride"] = 140.52, ["Mega|Ride"] = 629.29, ["Mega|Fly|Ride"] = 731.98}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.46, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.65, ["Mega"] = 36.75, ["Mega|Ride"] = 132.96, ["Mega|Fly|Ride"] = 283.18}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.6, ["Ride"] = 69.57, ["Neon"] = 89.25, ["Mega"] = 216.57, ["Mega|Fly|Ride"] = 838.94}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.72, ["Ride"] = 56.62, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 176.21, ["Mega"] = 328.13, ["Mega|Ride"] = 556.92, ["Mega|Fly|Ride"] = 462.47}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.18, ["Fly"] = 26.18, ["Ride"] = 27.46, ["Fly|Ride"] = 56.59, ["Neon"] = 51.19, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 56.64, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 373.38, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 384.57}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 170.62, ["Fly"] = 216.56, ["Ride"] = 209.9, ["Fly|Ride"] = 341.2, ["Neon"] = 922.99, ["Neon|Ride"] = 896.63, ["Neon|Fly|Ride"] = 924, ["Mega|Fly|Ride"] = 4055.19}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 17.62, ["Fly|Ride"] = 48.24, ["Neon"] = 12.95, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.83, ["Fly"] = 39.84, ["Ride"] = 36.2, ["Fly|Ride"] = 103.84, ["Neon"] = 16.86, ["Neon|Ride"] = 27.16, ["Neon|Fly|Ride"] = 158.15, ["Mega"] = 277.23, ["Mega|Ride"] = 389.81, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 39.38, ["Ride"] = 236.25, ["Fly|Ride"] = 400.45, ["Neon"] = 144.38, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 462, ["Mega|Ride"] = 699.57, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 108.81, ["Fly"] = 262.5, ["Ride"] = 183.75, ["Fly|Ride"] = 261.18, ["Neon"] = 576.78, ["Neon|Ride"] = 587.27, ["Neon|Fly|Ride"] = 979.58, ["Mega"] = 2097.59, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1863.75}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 27.45, ["Ride"] = 85.31, ["Fly|Ride"] = 174.09, ["Neon"] = 91.88, ["Neon|Ride"] = 188.77, ["Neon|Fly|Ride"] = 280.04, ["Mega"] = 288.75, ["Mega|Ride"] = 338.62, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.23, ["Fly|Ride"] = 46.59, ["Neon"] = 10.28, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 65.63, ["Mega|Ride"] = 188.81, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.5, ["Neon"] = 63.73, ["Neon|Ride"] = 167.81, ["Mega"] = 182.44, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 440.46}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 81.36, ["Ride"] = 111.57, ["Fly|Ride"] = 216.57, ["Neon"] = 175.88, ["Neon|Ride"] = 366.19, ["Neon|Fly|Ride"] = 435.26, ["Mega"] = 569.98, ["Mega|Ride"] = 677.25, ["Mega|Fly|Ride"] = 685.93}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 10.39, ["Neon|Ride"] = 104.88, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 61.69, ["Mega|Fly"] = 161.53, ["Mega|Ride"] = 110.79, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.74, ["Ride"] = 330.35, ["Neon"] = 85.32, ["Neon|Ride"] = 131.25, ["Mega"] = 377.82, ["Mega|Ride"] = 671.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1328.01, ["Ride"] = 958.13, ["Fly|Ride"] = 1107.09, ["Neon"] = 2626.55, ["Neon|Ride"] = 3639.92, ["Neon|Fly|Ride"] = 2607.6, ["Mega|Fly|Ride"] = 12534.38}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 30.18, ["Ride"] = 525, ["Fly|Ride"] = 204.5, ["Neon"] = 177.19, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 531.57, ["Mega"] = 826.88, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.19, ["Ride"] = 28.3, ["Fly|Ride"] = 104.88, ["Neon"] = 11.46, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 37.43, ["Neon|Fly|Ride"] = 104.77, ["Mega"] = 75.34, ["Mega|Ride"] = 107.18, ["Mega|Fly|Ride"] = 191.31}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 24.1, ["Ride"] = 131.22, ["Neon"] = 73.42, ["Mega"] = 309.41, ["Mega|Ride"] = 555.09, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.4, ["Fly|Ride"] = 419.48, ["Neon"] = 3.68, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 104.78, ["Mega"] = 23.62, ["Mega|Fly"] = 54.3, ["Mega|Ride"] = 52.45, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 70.79, ["Ride"] = 138.42, ["Fly|Ride"] = 210, ["Neon"] = 346.53, ["Neon|Fly"] = 560.51, ["Neon|Ride"] = 376.65, ["Neon|Fly|Ride"] = 481.95, ["Mega"] = 1238.47, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1147.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.03, ["Fly"] = 174.57, ["Ride"] = 37.77, ["Fly|Ride"] = 65.63, ["Neon"] = 38.66, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 415.34, ["Mega|Ride"] = 246.48, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 28.31, ["Fly|Ride"] = 45.94, ["Neon"] = 12.99, ["Neon|Ride"] = 65.62, ["Mega"] = 154.88, ["Mega|Ride"] = 238.09, ["Mega|Fly|Ride"] = 371.24}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 41.91, ["Ride"] = 90.57, ["Fly|Ride"] = 167.63, ["Neon"] = 196.88, ["Neon|Fly"] = 278.67, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 1048.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 19.56, ["Ride"] = 52.5, ["Neon"] = 94.5, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 839.05, ["Mega|Ride"] = 581.04, ["Mega|Fly|Ride"] = 699.48}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 54.51, ["Neon"] = 779.63, ["Neon|Ride"] = 630.12, ["Neon|Fly|Ride"] = 1013.92, ["Mega"] = 1231.3, ["Mega|Ride"] = 1959.16, ["Mega|Fly|Ride"] = 1995.11}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.36, ["Neon"] = 15.74, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 117.94, ["Mega|Ride"] = 167.14, ["Mega|Fly|Ride"] = 285.56}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.46, ["Fly"] = 23.63, ["Ride"] = 23.63, ["Fly|Ride"] = 63.72, ["Neon"] = 63.73, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 349.89, ["Mega"] = 399, ["Mega|Ride"] = 377.58, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 139.12, ["Ride"] = 181.71, ["Fly|Ride"] = 236.24, ["Neon"] = 577.83, ["Neon|Ride"] = 596.08, ["Neon|Fly|Ride"] = 567.74, ["Mega|Ride"] = 2304.83, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 30.85, ["Ride"] = 18.27, ["Fly|Ride"] = 104999.99, ["Neon"] = 14.44, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.99, ["Mega"] = 145.68, ["Mega|Ride"] = 137.16, ["Mega|Fly|Ride"] = 566.44}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 3.93, ["Fly"] = 47.2, ["Ride"] = 30.07, ["Fly|Ride"] = 78.59, ["Neon"] = 17.07, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 232.98, ["Mega|Ride"] = 208.72, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.8, ["Ride"] = 18.38, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Fly"] = 17.75, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 47.18, ["Mega"] = 23.63, ["Mega|Ride"] = 40.14, ["Mega|Fly|Ride"] = 80.07}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 3.94, ["Neon|Ride"] = 39.87, ["Mega"] = 22.32, ["Mega|Fly"] = 56.65, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 140.54}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 27.27, ["Fly|Ride"] = 45.94, ["Neon"] = 15.73, ["Neon|Ride"] = 26.25, ["Mega"] = 91.88, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 40.66, ["Ride"] = 84, ["Neon"] = 280.01, ["Neon|Ride"] = 419.48, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.63, ["Mega|Fly|Ride"] = 644.95}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 18.38, ["Ride"] = 19.93, ["Fly|Ride"] = 47.18, ["Neon"] = 14.13, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 78.75, ["Mega|Fly"] = 163.85, ["Mega|Ride"] = 115.56, ["Mega|Fly|Ride"] = 171.15}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.94, ["Fly"] = 31.49, ["Ride"] = 22.37, ["Fly|Ride"] = 68.24, ["Neon"] = 20.47, ["Neon|Fly"] = 36.6, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 147, ["Mega|Fly"] = 104.89, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 189.6}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.21, ["Fly|Ride"] = 115.5, ["Neon"] = 4.73, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 27.16, ["Neon|Fly|Ride"] = 110.85, ["Mega"] = 102.38, ["Mega|Fly"] = 158.15, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.5, ["Fly"] = 279.87, ["Ride"] = 26.14, ["Neon"] = 280.01, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 224.21, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 346.07}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.72, ["Fly"] = 160.71, ["Ride"] = 66, ["Fly|Ride"] = 174.09, ["Neon"] = 74.08, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 350.32, ["Mega"] = 441.35, ["Mega|Ride"] = 419.53, ["Mega|Fly|Ride"] = 1048.67}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 41.94, ["Ride"] = 20.79, ["Fly|Ride"] = 59.03, ["Neon"] = 28.3, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 105, ["Mega"] = 280.04, ["Mega|Ride"] = 266.41}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.07, ["Fly|Ride"] = 52.49, ["Neon"] = 15.73, ["Neon|Fly"] = 66.28, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 131.25, ["Mega|Ride"] = 205.34, ["Mega|Fly|Ride"] = 209.53}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 222.23, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 384.74, ["Neon"] = 976.33, ["Neon|Ride"] = 964.79, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Ride"] = 3497.74, ["Mega|Fly|Ride"] = 3775.48}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.18, ["Ride"] = 38.72, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 116.94, ["Mega|Ride"] = 280.04}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 27.27, ["Fly|Ride"] = 118.13, ["Neon"] = 23.63, ["Neon|Fly"] = 209.75, ["Neon|Ride"] = 33.48, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 185.24, ["Mega|Ride"] = 271.65, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.93, ["Neon"] = 32.82, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 629.29, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.78, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 20.88, ["Neon|Ride"] = 17.71, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.79, ["Mega|Fly|Ride"] = 95.55}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.37, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 24.29, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 47.2, ["Mega"] = 153.57, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.62, ["Ride"] = 56.62, ["Neon"] = 10.39, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 57.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 280.01}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.69, ["Fly"] = 140.46, ["Ride"] = 104.85, ["Fly|Ride"] = 131.25, ["Neon"] = 520.38, ["Neon|Ride"] = 448.85, ["Neon|Fly|Ride"] = 429.87, ["Mega|Ride"] = 3497.74, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.81, ["Fly"] = 85.32, ["Ride"] = 25.2, ["Fly|Ride"] = 65.63, ["Neon"] = 28.09, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 135.72, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.46, ["Ride"] = 44.58, ["Fly|Ride"] = 118.13, ["Neon"] = 10.39, ["Neon|Ride"] = 125.86, ["Neon|Fly|Ride"] = 167.52, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 102.79, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 65.54, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 299.25, ["Neon"] = 157.5, ["Neon|Ride"] = 189.52, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 557.97, ["Mega|Ride"] = 570.55, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 18.86, ["Fly|Ride"] = 28.88, ["Neon"] = 2.63, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 34.25, ["Mega"] = 19.59, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 40.11, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.39, ["Neon|Ride"] = 60.29, ["Neon|Fly|Ride"] = 71.12, ["Mega"] = 32.81, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 13.79, ["Neon|Fly|Ride"] = 188.81, ["Mega"] = 78.66, ["Mega|Fly|Ride"] = 296.15}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.4, ["Fly"] = 98.44, ["Ride"] = 69.55, ["Fly|Ride"] = 132.57, ["Neon"] = 41.92, ["Neon|Fly"] = 135.19, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 177.17, ["Mega"] = 108.94, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 188.62, ["Mega|Fly|Ride"] = 318.45}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.63, ["Mega"] = 24.82, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 130.05}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.53, ["Ride"] = 43.99, ["Fly|Ride"] = 235.81, ["Neon"] = 70.88, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 448.9, ["Mega|Fly|Ride"] = 664.88}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2887.5, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2441.25, ["Neon|Ride"] = 9788.23, ["Neon|Fly|Ride"] = 9440.26, ["Mega|Fly|Ride"] = 43519.53}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 20.9, ["Fly|Ride"] = 43.32, ["Neon"] = 4.73, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 30.85, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 74.82, ["Mega|Fly"] = 467.77, ["Mega|Ride"] = 107.26, ["Mega|Fly|Ride"] = 188.14}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 629.22}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 24.13, ["Ride"] = 26.25, ["Fly|Ride"] = 146.67, ["Neon"] = 91.69, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 548.52, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 68.42, ["Ride"] = 98.44, ["Neon"] = 140.41, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 419.53, ["Mega"] = 540.75, ["Mega|Ride"] = 560.07, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 140.28, ["Fly"] = 1398.25, ["Ride"] = 189, ["Fly|Ride"] = 266.44, ["Neon"] = 699.48, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 786.37, ["Mega"] = 6292.76, ["Mega|Ride"] = 3509.43, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.09, ["Fly"] = 28.31, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 18.89, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 224.46, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 62.91, ["Neon"] = 14.11, ["Neon|Fly"] = 98.59, ["Neon|Fly|Ride"] = 524.42, ["Mega"] = 136.5, ["Mega|Ride"] = 261.35, ["Mega|Fly|Ride"] = 838.43}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.97, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 4.73, ["Neon|Ride"] = 90.2, ["Mega"] = 107.63, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 39.38, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1165.81, ["Neon|Fly|Ride"] = 293.67, ["Mega"] = 374.06, ["Mega|Ride"] = 501.33, ["Mega|Fly|Ride"] = 647.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.25, ["Neon"] = 2.1, ["Neon|Ride"] = 37.78, ["Mega"] = 26.25, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 350.27}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Fly"] = 209.65, ["Ride"] = 91.88, ["Fly|Ride"] = 178.19, ["Neon"] = 313.57, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 514.98, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1398.93}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.41, ["Neon|Ride"] = 112.22, ["Mega"] = 39.38, ["Mega|Ride"] = 141.63}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 55.9, ["Fly"] = 220.57, ["Ride"] = 79.68, ["Fly|Ride"] = 155.14, ["Neon"] = 257.99, ["Neon|Ride"] = 250.65, ["Neon|Fly|Ride"] = 437.06, ["Mega"] = 2625, ["Mega|Ride"] = 1573.2, ["Mega|Fly|Ride"] = 1309.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.12, ["Fly|Ride"] = 49.88, ["Neon"] = 4.73, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 41.96, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 50.29, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.52}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.42, ["Neon"] = 13.02, ["Neon|Ride"] = 113.3, ["Mega"] = 78.73, ["Mega|Ride"] = 188.83, ["Mega|Fly|Ride"] = 524.34}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.86, ["Ride"] = 68.25, ["Fly|Ride"] = 208.7, ["Neon"] = 39.38, ["Neon|Ride"] = 116.41, ["Neon|Fly|Ride"] = 158.15, ["Mega"] = 233.55, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 430.5, ["Ride"] = 433.13, ["Fly|Ride"] = 532.87, ["Neon"] = 1232.44, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1438.5, ["Mega"] = 4475.21, ["Mega|Ride"] = 4410, ["Mega|Fly|Ride"] = 4128.63}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 38.06, ["Ride"] = 51.19, ["Fly|Ride"] = 78.75, ["Neon"] = 167.81, ["Neon|Fly"] = 315.07, ["Neon|Ride"] = 207.65, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1047.76, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 17.07, ["Fly|Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 70.28, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 786.96}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.48, ["Fly"] = 72.19, ["Ride"] = 45.1, ["Fly|Ride"] = 130.05, ["Neon"] = 49.23, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 96.49, ["Neon|Fly|Ride"] = 161.53, ["Mega"] = 234.94, ["Mega|Fly"] = 392.26, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 406.75}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.88, ["Ride"] = 27.57, ["Fly|Ride"] = 104.88, ["Neon"] = 28.3, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 188.83, ["Mega|Ride"] = 389.69, ["Mega|Fly|Ride"] = 448.85}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.2, ["Neon"] = 14.44, ["Neon|Ride"] = 52.5, ["Mega"] = 62.99, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 20.97, ["Fly|Ride"] = 51.93, ["Neon"] = 26.25, ["Neon|Ride"] = 46.16, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 551.09, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 118.11, ["Ride"] = 158.03, ["Fly|Ride"] = 167.64, ["Neon"] = 560, ["Neon|Ride"] = 559.92, ["Neon|Fly|Ride"] = 838.85, ["Mega"] = 2657.66, ["Mega|Ride"] = 2797.15, ["Mega|Fly|Ride"] = 3073.65}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.5, ["Fly"] = 95.82, ["Ride"] = 78.75, ["Fly|Ride"] = 158.05, ["Neon"] = 192.94, ["Neon|Ride"] = 282.19, ["Mega"] = 769.82, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 758.09}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2467.4, ["Fly"] = 2349.37, ["Ride"] = 2310, ["Fly|Ride"] = 2332.32, ["Neon"] = 12583.97, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.91, ["Fly|Ride"] = 170.63, ["Neon"] = 9.19, ["Neon|Ride"] = 109.47, ["Neon|Fly|Ride"] = 167.83, ["Mega"] = 125.97, ["Mega|Ride"] = 168.67, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.09, ["Ride"] = 83.88, ["Neon"] = 56.64, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 255.94, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 984.38, ["Fly"] = 1398.25, ["Ride"] = 969.94, ["Fly|Ride"] = 997.49, ["Neon"] = 2445.65, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2401.88, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 39.37, ["Ride"] = 78.75, ["Fly|Ride"] = 210, ["Neon"] = 280.01, ["Neon|Ride"] = 289.42, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.78, ["Ride"] = 23, ["Neon"] = 14.15, ["Neon|Ride"] = 140.54, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 140.55, ["Mega|Ride"] = 155.24, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 4.73, ["Neon|Ride"] = 20.69, ["Mega"] = 28.04, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 111.57, ["Ride"] = 125.99, ["Fly|Ride"] = 315.02, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 472.03, ["Mega"] = 2238.13, ["Mega|Fly|Ride"] = 2674.69}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.28, ["Neon"] = 31.49, ["Neon|Ride"] = 90.57, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 362.22}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 44.03, ["Ride"] = 97.63, ["Neon"] = 614.25, ["Neon|Ride"] = 315.28, ["Mega"] = 1818.62, ["Mega|Fly|Ride"] = 1670.79}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 10.07, ["Fly"] = 104.99, ["Fly|Ride"] = 112.19, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.36, ["Mega|Fly|Ride"] = 280.01}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 223.02, ["Ride"] = 291.37, ["Fly|Ride"] = 335.55, ["Neon"] = 984.72, ["Neon|Ride"] = 1005.68, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4123.35}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 7.1, ["Fly"] = 86.63, ["Ride"] = 28.3, ["Fly|Ride"] = 54.52, ["Neon"] = 18.38, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 277.6, ["Mega|Ride"] = 262.22, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 4.22, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 58.74, ["Mega"] = 62.44, ["Mega|Fly"] = 104.89, ["Mega|Ride"] = 62.87, ["Mega|Fly|Ride"] = 154.83}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 837.38, ["Fly"] = 1179.48, ["Ride"] = 903, ["Fly|Ride"] = 1048.67, ["Neon|Ride"] = 4955.93, ["Neon|Fly|Ride"] = 4743.38, ["Mega|Fly|Ride"] = 27964.71}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.25, ["Fly"] = 978.99, ["Ride"] = 56.62, ["Neon"] = 37.16, ["Neon|Fly"] = 70.27, ["Neon|Ride"] = 70.2, ["Mega"] = 179.54, ["Mega|Ride"] = 236.02, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 10.4, ["Fly"] = 70.24, ["Ride"] = 50.75, ["Fly|Ride"] = 112.22, ["Neon"] = 36.75, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 140.55, ["Mega"] = 178.31, ["Mega|Ride"] = 224.46, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 41.91, ["Fly"] = 40.52, ["Ride"] = 45.93, ["Fly|Ride"] = 69.57, ["Neon"] = 165.38, ["Neon|Fly"] = 182.48, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2097.59, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 24.1, ["Fly"] = 72.19, ["Ride"] = 32.82, ["Fly|Ride"] = 62.99, ["Neon"] = 66.94, ["Neon|Ride"] = 126.28, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 288.75, ["Mega|Fly"] = 315, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.66}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.25, ["Ride"] = 210, ["Fly|Ride"] = 338.61, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 456.39, ["Mega"] = 486.18, ["Mega|Ride"] = 519.17, ["Mega|Fly|Ride"] = 641.8}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 235.87, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Mega"] = 20.9, ["Mega|Fly"] = 84.98, ["Mega|Ride"] = 41.62, ["Mega|Fly|Ride"] = 117.99}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 38.06, ["Fly"] = 74.82, ["Ride"] = 53.72, ["Fly|Ride"] = 103.68, ["Neon"] = 190.32, ["Neon|Fly"] = 276.87, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 3356.15, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 27.2, ["Ride"] = 48.12, ["Fly|Ride"] = 70.87, ["Neon"] = 27.57, ["Neon|Ride"] = 140.54, ["Mega"] = 773.07, ["Mega|Ride"] = 274.8, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.65, ["Fly|Ride"] = 50.75, ["Neon"] = 18.89, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.25, ["Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Ride"] = 838.94, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 293.67, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.98, ["Fly"] = 262.37, ["Ride"] = 71.29, ["Fly|Ride"] = 144.38, ["Neon"] = 116.41, ["Neon|Fly"] = 309.37, ["Neon|Ride"] = 187.72, ["Neon|Fly|Ride"] = 233.89, ["Mega"] = 824.37, ["Mega|Ride"] = 763.53, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.16, ["Ride"] = 111.57, ["Neon"] = 24.94, ["Neon|Ride"] = 73.42, ["Neon|Fly|Ride"] = 112.24, ["Mega"] = 86.46, ["Mega|Fly"] = 78.75, ["Mega|Fly|Ride"] = 272.27}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.1, ["Neon|Ride"] = 41.96, ["Mega"] = 21, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 204.65}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 70.24, ["Ride"] = 21, ["Fly|Ride"] = 81.9, ["Neon"] = 4.12, ["Neon|Fly"] = 393.62, ["Neon|Ride"] = 30.35, ["Mega"] = 19.28, ["Mega|Ride"] = 134.26, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.07, ["Fly|Ride"] = 49.79, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 75.53, ["Mega"] = 83.92, ["Mega|Ride"] = 167.83, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5306.87, ["Neon"] = 15.74, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.76, ["Mega|Fly|Ride"] = 209.75}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.04, ["Fly|Ride"] = 41.43, ["Neon"] = 30.7, ["Neon|Fly"] = 52.45, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 281.54, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 93.18, ["Ride"] = 120.75, ["Fly|Ride"] = 419.48, ["Neon"] = 251.69, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1048.81, ["Mega"] = 839.05, ["Mega|Ride"] = 811.78, ["Mega|Fly|Ride"] = 1072.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 19.92, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 49.31, ["Mega"] = 54.55, ["Mega|Ride"] = 67.13, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.18, ["Fly"] = 62.87, ["Ride"] = 61.69, ["Fly|Ride"] = 100.69, ["Neon"] = 43.32, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 58.97, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 351.36, ["Mega|Ride"] = 279, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 20.89, ["Fly"] = 36.75, ["Ride"] = 34.13, ["Fly|Ride"] = 63.73, ["Neon"] = 79.54, ["Neon|Fly"] = 140.41, ["Neon|Ride"] = 94.41, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1048.81, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.97, ["Fly"] = 140.38, ["Ride"] = 28.31, ["Neon"] = 28.77, ["Neon|Ride"] = 70.27, ["Mega"] = 131.25, ["Mega|Ride"] = 181.92, ["Mega|Fly|Ride"] = 376.48}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 28.31, ["Ride"] = 18.38, ["Fly|Ride"] = 43.29, ["Neon"] = 5.87, ["Neon|Fly"] = 40.91, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 39.38, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 174.66}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Fly"] = 77.54, ["Ride"] = 25.31, ["Neon"] = 27.27, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 99.53, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.96}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 969.94, ["Fly"] = 1230.55, ["Ride"] = 969.94, ["Fly|Ride"] = 1035.57, ["Neon"] = 2625, ["Neon|Fly"] = 2851.33, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 7609.88}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 70.88, ["Fly"] = 158.06, ["Ride"] = 98.44, ["Neon"] = 267.65, ["Neon|Ride"] = 321.99, ["Neon|Fly|Ride"] = 478.27, ["Mega"] = 1661.3, ["Mega|Ride"] = 1559.57, ["Mega|Fly|Ride"] = 1344}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 12.99, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 70.28}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 36.75, ["Ride"] = 70.25, ["Fly|Ride"] = 170.63, ["Neon"] = 188.57, ["Neon|Ride"] = 182.2, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 1023.75, ["Mega|Ride"] = 1168.37, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.16, ["Ride"] = 39.38, ["Fly|Ride"] = 156.19, ["Neon"] = 55.34, ["Neon|Ride"] = 62.93, ["Neon|Fly|Ride"] = 278.99, ["Mega"] = 274.32, ["Mega|Fly|Ride"] = 474.02}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 261.19, ["Fly"] = 419.28, ["Ride"] = 262.08, ["Fly|Ride"] = 283.22, ["Neon"] = 830.46, ["Neon|Ride"] = 1090.62, ["Neon|Fly|Ride"] = 1088.66, ["Mega|Fly|Ride"] = 14053.81}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 81.98, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 53.9, ["Mega"] = 401.21, ["Mega|Fly"] = 280.04}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.9, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 335.64}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 53.81, ["Ride"] = 102.38, ["Fly|Ride"] = 280.01, ["Neon"] = 341.25, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 794.73}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 53.48, ["Neon"] = 13.55, ["Neon|Ride"] = 45.93, ["Mega"] = 280.04, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 280.01}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.61, ["Neon|Fly"] = 31.85, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.15, ["Mega|Fly"] = 70.28, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 3937.5, ["Neon"] = 27265.25, ["Neon|Fly|Ride"] = 27963.93, ["Mega|Fly|Ride"] = 62919.8}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.81, ["Ride"] = 56.43, ["Neon"] = 95.82, ["Mega"] = 418.69, ["Mega|Ride"] = 392.26, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 22.43, ["Fly|Ride"] = 60.37, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 229.53, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 545.39}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 419.06, ["Fly"] = 527.63, ["Ride"] = 485.63, ["Fly|Ride"] = 525, ["Neon"] = 1362.22, ["Neon|Ride"] = 1328.67, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 5145.8}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.83, ["Ride"] = 28.31, ["Neon"] = 15.74, ["Neon|Ride"] = 145.68, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.63, ["Fly"] = 4106.07, ["Ride"] = 942.41, ["Neon"] = 27.27, ["Neon|Ride"] = 280.01, ["Neon|Fly|Ride"] = 13984.6, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 19.36, ["Fly|Ride"] = 82.55, ["Neon"] = 5.71, ["Neon|Fly"] = 124.67, ["Neon|Ride"] = 37.77, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 46.16, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 140.54}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 637.88, ["Fly"] = 754.68, ["Ride"] = 623.44, ["Fly|Ride"] = 656.25, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1967.44}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.28, ["Ride"] = 79.07, ["Neon"] = 27.57, ["Neon|Ride"] = 79.08, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 118.13, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 768.79}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.57, ["Fly"] = 235.85, ["Ride"] = 65.63, ["Neon"] = 47.99, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 236.25, ["Mega|Ride"] = 280.04, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 20.98, ["Fly|Ride"] = 62.93, ["Neon"] = 18.38, ["Neon|Fly"] = 46.16, ["Neon|Ride"] = 35.66, ["Neon|Fly|Ride"] = 58.74, ["Mega"] = 207.5, ["Mega|Ride"] = 158.15, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 22.32, ["Ride"] = 92.4, ["Neon"] = 91.88, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 315.08, ["Mega"] = 519.17, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 524.34}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 4.73, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 36.75, ["Mega|Ride"] = 77.63, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 538.13, ["Ride"] = 456.88, ["Fly|Ride"] = 545.31, ["Neon"] = 1837.5, ["Neon|Ride"] = 2411.94, ["Neon|Fly|Ride"] = 1793.39, ["Mega|Fly|Ride"] = 7865.94}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.8, ["Fly|Ride"] = 331.4, ["Neon"] = 12.48, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.37, ["Mega|Ride"] = 272.7, ["Mega|Fly|Ride"] = 343.82}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 6.46, ["Neon|Fly"] = 125.86, ["Neon|Ride"] = 209.86, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 45.94, ["Mega|Fly"] = 98.6, ["Mega|Ride"] = 98.6, ["Mega|Fly|Ride"] = 209.75}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21.56, ["Neon"] = 4.47, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 125.87, ["Mega"] = 47.19, ["Mega|Fly"] = 155.24, ["Mega|Ride"] = 72.19}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 28.32, ["Neon|Ride"] = 47.21, ["Mega"] = 229.7, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 71.31, ["Ride"] = 150.94, ["Fly|Ride"] = 209.67, ["Neon"] = 254.89, ["Neon|Ride"] = 1259.06, ["Neon|Fly|Ride"] = 1574.18, ["Mega"] = 979.58, ["Mega|Ride"] = 943.92, ["Mega|Fly|Ride"] = 915.48}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 30.69, ["Fly"] = 69.47, ["Ride"] = 65.62, ["Fly|Ride"] = 112.11, ["Neon"] = 99.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 208.72, ["Mega"] = 463.31, ["Mega|Ride"] = 440.95, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 39.84, ["Ride"] = 18.38, ["Fly|Ride"] = 49.88, ["Neon"] = 32.62, ["Neon|Fly"] = 70.27, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 394.42, ["Mega|Ride"] = 235.99, ["Mega|Fly|Ride"] = 262.18}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.09, ["Ride"] = 64.32, ["Fly|Ride"] = 78.64, ["Neon"] = 266.37, ["Neon|Ride"] = 158.37, ["Mega"] = 331.44, ["Mega|Ride"] = 787.1, ["Mega|Fly|Ride"] = 979.47}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 4.22, ["Fly"] = 225.37, ["Ride"] = 31.5, ["Fly|Ride"] = 83.91, ["Neon"] = 32.71, ["Neon|Ride"] = 66.94, ["Mega"] = 195.57, ["Mega|Ride"] = 375.48, ["Mega|Fly|Ride"] = 499.17}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 40.13, ["Fly"] = 69.2, ["Ride"] = 30.07, ["Fly|Ride"] = 56.23, ["Neon"] = 228.74, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 244.79, ["Mega"] = 942.87, ["Mega|Ride"] = 944.05, ["Mega|Fly|Ride"] = 741.41}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon|Ride"] = 472.01, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 55, ["Fly"] = 115.5, ["Ride"] = 82.69, ["Fly|Ride"] = 79.08, ["Neon"] = 236.25, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1153.69, ["Mega|Ride"] = 1143.95, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 63, ["Fly"] = 92.79, ["Ride"] = 91.88, ["Neon"] = 155.96, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 531.25, ["Mega|Ride"] = 646.07, ["Mega|Fly|Ride"] = 628.6}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.25, ["Ride"] = 91.88, ["Neon"] = 135.19, ["Mega"] = 587.33, ["Mega|Ride"] = 401.92, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.88, ["Fly"] = 31.71, ["Ride"] = 31.42, ["Fly|Ride"] = 84, ["Neon"] = 50.4, ["Neon|Fly"] = 167.81, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 417.43, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 41.94, ["Neon"] = 5.25, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.94, ["Mega"] = 65.63, ["Mega|Fly"] = 209.77, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 156.85}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 28.66, ["Ride"] = 62.91, ["Fly|Ride"] = 136.34, ["Neon"] = 139.13, ["Neon|Fly"] = 278.96, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 296.83, ["Mega"] = 503.44, ["Mega|Ride"] = 524.42, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.02, ["Neon"] = 3.94, ["Neon|Ride"] = 40.87, ["Neon|Fly|Ride"] = 293.67, ["Mega"] = 39.37, ["Mega|Ride"] = 90.21}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Fly"] = 110.88, ["Ride"] = 57.74, ["Neon"] = 208.7, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.75, ["Mega|Ride"] = 975.9, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 6.36, ["Neon|Ride"] = 105, ["Mega"] = 32.82}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.6, ["Mega"] = 25.92, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 119.44, ["Ride"] = 190.32, ["Neon"] = 426.57, ["Neon|Fly"] = 620.69, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6490.19, ["Mega|Fly|Ride"] = 1915.77}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 20.98, ["Fly|Ride"] = 70.82, ["Neon"] = 10.24, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 90.15, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 40.13, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 6.57, ["Neon|Fly"] = 62.93, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 38.06, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 30.83, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 30.32, ["Mega"] = 46.73, ["Mega|Ride"] = 96.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 44.62, ["Ride"] = 111.57, ["Fly|Ride"] = 1047.52, ["Neon"] = 276.17, ["Neon|Ride"] = 401.44, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1538.59, ["Mega|Ride"] = 1538.59, ["Mega|Fly|Ride"] = 1258.89}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.7, ["Ride"] = 36.53, ["Neon"] = 26.25, ["Neon|Ride"] = 110.93, ["Mega"] = 140.55, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 373.16, ["Ride"] = 415.86, ["Fly|Ride"] = 616.88, ["Neon"] = 1398.93, ["Neon|Ride"] = 944, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3593.08}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.32}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.78}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.56}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.24}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.31}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.83}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 223.13}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 77.58}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 217.9}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.01}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.28}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.3}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.61}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 429.12}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.02}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1498.88}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 32.82}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.65}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.93}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 39.38}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 13.12}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.19}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 699.13}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.59}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.82}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 60.38}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 17.71}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 14.16}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1771.88}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 64.32}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.44}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 11.54}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 171.77}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 16.69}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 13.13}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1047.12}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.69}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.88}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.68}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 5.07}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.73}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 147}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 11.82}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.32}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.97}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 38.07}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 136.5}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 165.1}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 10.49}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.32}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 66}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22466.46}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.42}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 41.29}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 62.91}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 55.13}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 209.9}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 84}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 91.88}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.94}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 80.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.38}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.4}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 20.98}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 51.19}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.73}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1081.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.46}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 657.2}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 35.43}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 42.95}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 37.97}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 85.32}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.16}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.93}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 4.19}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.14}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 169.31}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1006.24}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.65}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 13.13}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 87.83}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 12.58}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.38}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.02}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 15.65}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 105}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 25.99}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.52}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.3}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.3}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.38}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 38.06}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.73}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.5}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 15.73}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.19}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.59}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 133.88}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 38.06}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.3}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.84}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.66}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2605.73}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.87}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 56.44}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.18}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 278.25}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 5.23}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.9}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 9.17}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.29}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.7}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 185.78}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.19}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 77.26}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.46}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.86}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.62}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 19.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 945}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 20.97}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.65}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 8.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 12.39}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.25}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.96}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 21}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 9.56}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 49.21}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 13.07}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63.6}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.52}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.73}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.66}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 17.22}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.83}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 129.94}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 13.86}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.81}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 18.88}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.98}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 11.81}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 139.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 123.38}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1127.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 152.25}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 9.19}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 39.37}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.04}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.85}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 125.79}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.58}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.21}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.29}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.16}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 56.62}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 7.86}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 66.94}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.43}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 95.71}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 66.67}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.99}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 70.24}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 70.82}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 93.19}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 177.19}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 360.94}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.59}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 182.2}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.84}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.74}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 4.22}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 38.66}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.17}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 87.28}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 14.16}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 8.07}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 19.69}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 51.18}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.07}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 34.04}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.37}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 61.69}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 41.99}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1626.74}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 4.73}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 188.68}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.68}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 12.64}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 182.01}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 61.48}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.46}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 118.11}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 102.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 112.06}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 787.5}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 145.69}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.45}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1411.88}},
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