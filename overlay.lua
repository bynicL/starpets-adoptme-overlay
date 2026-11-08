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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1394.25, ["Ride"] = 1118.13, ["Fly|Ride"] = 1443.75, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25140.28}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 448.35, ["Fly"] = 622.51, ["Ride"] = 457.68, ["Fly|Ride"] = 524.74, ["Neon"] = 2095.04, ["Neon|Ride"] = 2199.79, ["Neon|Fly|Ride"] = 2072.43, ["Mega|Fly|Ride"] = 8659.79}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4200, ["Fly|Ride"] = 4329.94, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 68857.1}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 126.04, ["Ride"] = 183.75, ["Fly|Ride"] = 268.14, ["Neon"] = 831.73, ["Neon|Ride"] = 796.13, ["Neon|Fly|Ride"] = 782.51, ["Mega"] = 4050.74, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 549.94, ["Fly"] = 656.8, ["Ride"] = 539.43, ["Fly|Ride"] = 539.44, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1534.32, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.97, ["Ride"] = 36.57, ["Fly|Ride"] = 140.38, ["Neon"] = 52.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 275.13, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 414.84}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 32.48, ["Ride"] = 19.69, ["Fly|Ride"] = 62.75, ["Neon"] = 27.72, ["Neon|Fly"] = 110.01, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 112.42, ["Mega"] = 267.64, ["Mega|Fly"] = 273.53, ["Mega|Ride"] = 219.99, ["Mega|Fly|Ride"] = 290.73}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.8, ["Fly"] = 195.9, ["Ride"] = 160.13, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 522.73, ["Neon|Fly|Ride"] = 660.23, ["Mega"] = 1886.36, ["Mega|Fly|Ride"] = 2277.31}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 27.56, ["Fly"] = 141.43, ["Ride"] = 46.71, ["Fly|Ride"] = 77.44, ["Neon"] = 292.27, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1397.4, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.17, ["Fly"] = 39.38, ["Ride"] = 36.73, ["Fly|Ride"] = 69.56, ["Neon"] = 140.38, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 753.18, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.11, ["Fly"] = 124.67, ["Ride"] = 91.16, ["Fly|Ride"] = 127.31, ["Neon"] = 235.88, ["Neon|Ride"] = 250.38, ["Neon|Fly|Ride"] = 329.42, ["Mega|Fly|Ride"] = 1474.91}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 77.97}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 377.9, ["Fly"] = 399, ["Ride"] = 354.38, ["Fly|Ride"] = 398.91, ["Neon|Ride"] = 1676.04, ["Neon|Fly|Ride"] = 1357.59, ["Mega|Fly|Ride"] = 10475.12}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.02, ["Fly"] = 131.25, ["Ride"] = 111.57, ["Fly|Ride"] = 149.63, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 483, ["Mega|Fly|Ride"] = 2612.51}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.78, ["Fly"] = 115.91, ["Ride"] = 49.75, ["Fly|Ride"] = 209.52, ["Neon"] = 18.18, ["Neon|Ride"] = 63.68, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 136.45, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.89}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.4, ["Fly"] = 279.7, ["Ride"] = 124.69, ["Fly|Ride"] = 183.75, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1903}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.9, ["Fly"] = 27.13, ["Ride"] = 22.23, ["Fly|Ride"] = 35.44, ["Neon"] = 37.73, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 59.07, ["Fly"] = 262.5, ["Ride"] = 98.43, ["Fly|Ride"] = 237.8, ["Neon"] = 214.39, ["Neon|Ride"] = 240.94, ["Neon|Fly|Ride"] = 421.3, ["Mega"] = 1385.95, ["Mega|Ride"] = 943.59, ["Mega|Fly|Ride"] = 945.92}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.9}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 72.19, ["Ride"] = 140.38, ["Fly|Ride"] = 337.98, ["Neon"] = 525, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.82, ["Fly"] = 374.07, ["Ride"] = 32.36, ["Fly|Ride"] = 78.75, ["Neon"] = 142.48, ["Neon|Ride"] = 343.98, ["Neon|Fly|Ride"] = 195.9, ["Mega"] = 698.71, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1676.04}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.67, ["Fly"] = 64.3, ["Ride"] = 56.76, ["Fly|Ride"] = 122.07, ["Neon"] = 683, ["Neon|Fly"] = 312.17, ["Neon|Ride"] = 221.79, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1650.57, ["Mega|Fly|Ride"] = 766.1}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.37, ["Fly"] = 140.38, ["Ride"] = 155.76, ["Fly|Ride"] = 138.29, ["Neon"] = 204.74, ["Neon|Fly"] = 391.43, ["Neon|Ride"] = 184.3, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 823.35, ["Mega|Ride"] = 1252.84, ["Mega|Fly|Ride"] = 1101.18}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 41.92, ["Fly"] = 63.68, ["Ride"] = 56.49, ["Fly|Ride"] = 157.5, ["Neon"] = 141.49, ["Neon|Ride"] = 291.22, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2092.95, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.46, ["Fly"] = 587.66, ["Ride"] = 78.59, ["Fly|Ride"] = 135.19, ["Neon"] = 308.44, ["Neon|Ride"] = 309.72, ["Mega|Ride"] = 974.58, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.88, ["Fly"] = 31.49, ["Ride"] = 27.21, ["Fly|Ride"] = 57.75, ["Neon"] = 22.51, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 44.17, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 147, ["Mega|Fly"] = 172.64, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 341.01, ["Ride"] = 352.87, ["Fly|Ride"] = 362.24, ["Neon"] = 1475.25, ["Neon|Ride"] = 1676.04, ["Neon|Fly|Ride"] = 1627.5, ["Mega"] = 12570.14, ["Mega|Fly|Ride"] = 7332.59}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.21, ["Ride"] = 33.97, ["Fly|Ride"] = 105.18, ["Neon"] = 251.43, ["Neon|Ride"] = 406.45, ["Neon|Fly|Ride"] = 458.82, ["Mega"] = 824.4, ["Mega|Fly|Ride"] = 838.03}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.94, ["Fly"] = 17.07, ["Ride"] = 28.3, ["Fly|Ride"] = 44.63, ["Neon"] = 41.27, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 103.49, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 93.13, ["Fly"] = 133.05, ["Ride"] = 98.44, ["Fly|Ride"] = 181.13, ["Neon"] = 379.21, ["Neon|Ride"] = 462.17, ["Neon|Fly|Ride"] = 434.74, ["Mega"] = 1956.76, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1886.36}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.44, ["Fly"] = 32.49, ["Ride"] = 28.77, ["Fly|Ride"] = 115.5, ["Neon"] = 189, ["Neon|Ride"] = 79.01, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 707.4, ["Mega|Ride"] = 641.09, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.44, ["Fly"] = 354.08, ["Ride"] = 183.75, ["Fly|Ride"] = 248.07, ["Neon"] = 943.19, ["Neon|Ride"] = 838.03, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6285.08, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2858.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 29.88}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.99, ["Fly"] = 34.58, ["Ride"] = 27.24, ["Fly|Ride"] = 61.82, ["Neon"] = 22.35, ["Neon|Fly"] = 4725.71, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 154.46, ["Mega"] = 131.24, ["Mega|Fly"] = 282.96, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 284.82}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1240.32, ["Fly"] = 4593.75, ["Ride"] = 1246.88, ["Fly|Ride"] = 1509.38, ["Neon"] = 7021.88, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 6300, ["Mega"] = 26537.66, ["Mega|Ride"] = 53053.8, ["Mega|Fly|Ride"] = 19972.91}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.1, ["Fly"] = 69.15, ["Ride"] = 28.77, ["Fly|Ride"] = 87.94, ["Neon"] = 104.42, ["Neon|Ride"] = 138.29, ["Neon|Fly|Ride"] = 141.49, ["Mega"] = 511.88, ["Mega|Ride"] = 620.15, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 119.44, ["Ride"] = 140.37, ["Fly|Ride"] = 249.38, ["Neon"] = 656.25, ["Neon|Ride"] = 689.07, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2722.5, ["Mega|Fly|Ride"] = 2731.93}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 22.32, ["Fly"] = 68.85, ["Ride"] = 55.46, ["Fly|Ride"] = 94.33, ["Neon"] = 239.57, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 739.23}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 123.43, ["Ride"] = 220.48, ["Fly|Ride"] = 223.12, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2793.73, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 123.69, ["Ride"] = 160.74, ["Fly|Ride"] = 236.24, ["Neon"] = 426.36, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 39.84}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 62.23, ["Fly"] = 98.43, ["Ride"] = 68.16, ["Fly|Ride"] = 75.36, ["Neon"] = 601.29, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 4190.06, ["Mega|Fly|Ride"] = 1509.37}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.5, ["Ride"] = 39.38, ["Fly|Ride"] = 158.19, ["Neon"] = 39.25, ["Neon|Ride"] = 70.19, ["Neon|Fly|Ride"] = 233.61, ["Mega"] = 220.48, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 349.89}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 336.66, ["Fly"] = 393.75, ["Ride"] = 406.56, ["Fly|Ride"] = 411.46, ["Neon|Ride"] = 1568.73, ["Neon|Fly|Ride"] = 1253.72, ["Mega|Fly|Ride"] = 6020.44}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 78.75, ["Fly"] = 99.75, ["Ride"] = 108.96, ["Fly|Ride"] = 140.32, ["Neon"] = 392.83, ["Neon|Ride"] = 377.28, ["Neon|Fly|Ride"] = 369.03, ["Mega|Ride"] = 1885.53, ["Mega|Fly|Ride"] = 1952.82}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7123.09, ["Fly"] = 3543.75, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14664.12}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42, ["Fly"] = 112.1, ["Ride"] = 57.72, ["Fly|Ride"] = 110.83, ["Neon"] = 392.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 266.09, ["Mega|Ride"] = 1627.85, ["Mega|Fly|Ride"] = 1443.49}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 70.75, ["Ride"] = 57.75, ["Fly|Ride"] = 199.04, ["Neon"] = 656.25, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 6285.08, ["Mega|Fly|Ride"] = 2454.34}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 68.39, ["Ride"] = 62.77, ["Fly|Ride"] = 105.97, ["Neon"] = 181.63, ["Neon|Ride"] = 194.85, ["Neon|Fly|Ride"] = 227.29, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 782.51}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.86}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 59.72, ["Ride"] = 56.39, ["Fly|Ride"] = 72.17, ["Neon"] = 328.13, ["Neon|Ride"] = 480.82, ["Neon|Fly|Ride"] = 501.78, ["Mega|Fly|Ride"] = 1557.66}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 237.8, ["Fly"] = 321.6, ["Ride"] = 196.88, ["Fly|Ride"] = 341.92, ["Neon|Ride"] = 1369.1, ["Neon|Fly|Ride"] = 1694.25}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.74, ["Ride"] = 955.5, ["Fly|Ride"] = 945, ["Neon|Fly|Ride"] = 3806.24, ["Mega|Fly|Ride"] = 15335.57}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.45}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.99, ["Fly"] = 52.44, ["Ride"] = 44.63, ["Fly|Ride"] = 64.29, ["Neon"] = 162.75, ["Neon|Fly"] = 209.52, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 187.29, ["Mega|Ride"] = 879.81, ["Mega|Fly|Ride"] = 765.69}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.81}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4765.48, ["Fly"] = 6006.45, ["Ride"] = 6145.76, ["Fly|Ride"] = 4443.87, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 33520.36}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.76, ["Fly"] = 74.64, ["Ride"] = 25.02, ["Fly|Ride"] = 52.49, ["Neon"] = 70.2, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 525, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.53, ["Fly"] = 191.66, ["Ride"] = 31.04, ["Fly|Ride"] = 116.74, ["Neon"] = 105, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1047.53, ["Mega|Ride"] = 559.38, ["Mega|Fly|Ride"] = 939.64}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 131.15, ["Fly"] = 147.93, ["Ride"] = 118.13, ["Fly|Ride"] = 140.32, ["Neon"] = 1397.4, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 4190.06}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 14.13, ["Ride"] = 28.87, ["Fly|Ride"] = 139.64, ["Neon"] = 54.86, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.36, ["Mega"] = 364.55, ["Mega|Ride"] = 416.93, ["Mega|Fly|Ride"] = 475.58}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2165.63, ["Fly"] = 3073.41, ["Fly|Ride"] = 1900.5, ["Neon|Fly|Ride"] = 5065.77, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 31425.34, ["Fly"] = 35212.4, ["Ride"] = 34917.74, ["Fly|Ride"] = 22968.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195535.76}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.78, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 125.72, ["Neon"] = 170.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 768.89, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 838.03}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.93, ["Fly"] = 77.53, ["Ride"] = 31.5, ["Fly|Ride"] = 156.45, ["Neon"] = 20.9, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 158.03, ["Mega|Fly"] = 199.5, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.34, ["Ride"] = 52.49, ["Fly|Ride"] = 111.57, ["Neon"] = 61.68, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 415.75, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 787.5, ["Ride"] = 656.25, ["Fly|Ride"] = 733.69, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2737.88, ["Mega|Fly|Ride"] = 11004.55}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.49, ["Fly"] = 900.38, ["Ride"] = 862.31, ["Fly|Ride"] = 929.21, ["Neon"] = 4190.06, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3038, ["Mega|Fly|Ride"] = 10218.17}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 18.79, ["Fly"] = 111.57, ["Ride"] = 48.2, ["Fly|Ride"] = 104.77, ["Neon"] = 140.38, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 826.41, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 810.78}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 91.88, ["Fly"] = 111.56, ["Ride"] = 74.82, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 419.03, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1705.36, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 43.38, ["Ride"] = 83.83, ["Fly|Ride"] = 157.5, ["Neon"] = 450.19, ["Neon|Ride"] = 424.54, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1757.75, ["Mega|Fly|Ride"] = 1695.15}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.89, ["Fly"] = 32.8, ["Ride"] = 20.9, ["Fly|Ride"] = 54.25, ["Neon"] = 28.11, ["Neon|Fly"] = 314.81, ["Neon|Ride"] = 77.43, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 219.31, ["Mega|Ride"] = 398.07, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 78.72, ["Fly"] = 104.98, ["Ride"] = 91.88, ["Fly|Ride"] = 144.38, ["Neon"] = 810.78, ["Neon|Ride"] = 271.69, ["Neon|Fly|Ride"] = 308.44, ["Mega|Fly|Ride"] = 1141.35}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.75, ["Ride"] = 40.69, ["Fly|Ride"] = 122.07, ["Neon"] = 23.6, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 251.44, ["Mega"] = 206.07, ["Mega|Ride"] = 300.65, ["Mega|Fly|Ride"] = 392.41}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.78, ["Fly"] = 40.28, ["Ride"] = 29.28, ["Fly|Ride"] = 59.07, ["Neon"] = 78.75, ["Neon|Fly"] = 126.17, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 740.6, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.44, ["Ride"] = 63.68, ["Fly|Ride"] = 156.19, ["Neon"] = 217.88, ["Neon|Ride"] = 348.99, ["Mega"] = 694.25, ["Mega|Ride"] = 550.59, ["Mega|Fly|Ride"] = 871.68}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.06, ["Fly"] = 77.33, ["Ride"] = 22.42, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Fly"] = 559.38, ["Neon|Ride"] = 123.62, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1047.53, ["Mega|Ride"] = 933.35, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5118.75, ["Ride"] = 6864.38, ["Fly|Ride"] = 5630.62, ["Neon"] = 34917.74, ["Neon|Fly|Ride"] = 25978.29}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 229.69, ["Fly"] = 279.7, ["Ride"] = 236.25, ["Fly|Ride"] = 305.81, ["Neon"] = 681.47, ["Neon|Ride"] = 551.24, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1860.97}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 30.19, ["Fly"] = 125.72, ["Ride"] = 59.07, ["Fly|Ride"] = 125.34, ["Neon"] = 83.84, ["Neon|Fly"] = 158, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 317.56, ["Mega|Fly"] = 413.79, ["Mega|Ride"] = 330.35, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.6, ["Ride"] = 24.11, ["Fly|Ride"] = 91.16, ["Neon"] = 28.3, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 190.66, ["Mega"] = 158}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 43.32, ["Fly"] = 5285.81, ["Ride"] = 98.44, ["Fly|Ride"] = 154.49, ["Neon"] = 119.43, ["Neon|Fly"] = 324.74, ["Neon|Ride"] = 124.9, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 418.68, ["Mega|Ride"] = 449.05, ["Mega|Fly|Ride"] = 562.35}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 9684.87, ["Fly|Ride"] = 11156.24, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 90784.65}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 171.87, ["Ride"] = 210, ["Fly|Ride"] = 288.08, ["Neon"] = 1313.6, ["Neon|Ride"] = 1229.79, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4708.58}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 69.03, ["Fly"] = 414.58, ["Ride"] = 62.91, ["Fly|Ride"] = 111.32, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 363.5, ["Mega|Fly|Ride"] = 2025.91}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.44, ["Fly"] = 44.82, ["Ride"] = 20.97, ["Fly|Ride"] = 72.1, ["Neon"] = 91.97, ["Neon|Ride"] = 90.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2514.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.84, ["Fly"] = 838.03, ["Ride"] = 444.94, ["Fly|Ride"] = 456.75, ["Neon"] = 1571.28, ["Neon|Ride"] = 1311.18, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.09, ["Fly"] = 87.26, ["Ride"] = 26.25, ["Fly|Ride"] = 163.46, ["Neon"] = 26.24, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 154.55, ["Mega|Ride"] = 224.26, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 208.69, ["Fly"] = 393.75, ["Ride"] = 228.38, ["Fly|Ride"] = 323.57, ["Neon"] = 771.74, ["Neon|Ride"] = 777, ["Neon|Fly|Ride"] = 1019.82, ["Mega|Fly|Ride"] = 2973.9}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.81, ["Fly"] = 19.92, ["Ride"] = 19.49, ["Fly|Ride"] = 39.35, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 2514.04, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.8}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.49, ["Ride"] = 112.1, ["Fly|Ride"] = 525, ["Neon"] = 367.5, ["Neon|Fly"] = 1676.04, ["Neon|Ride"] = 417.98, ["Neon|Fly|Ride"] = 786.39, ["Mega"] = 1397.4, ["Mega|Ride"] = 1414.77, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.74, ["Ride"] = 39.37, ["Fly|Ride"] = 84, ["Neon"] = 74.82, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 476.63, ["Mega|Ride"] = 494.45, ["Mega|Fly|Ride"] = 611.77}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 28.38, ["Fly"] = 111.57, ["Ride"] = 73.97, ["Fly|Ride"] = 220.48, ["Neon"] = 192.31, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 313.22, ["Mega"] = 775.18, ["Mega|Ride"] = 823.35, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.81, ["Fly|Ride"] = 131.25, ["Neon"] = 22.86, ["Neon|Ride"] = 106.13, ["Neon|Fly|Ride"] = 129.91, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.04, ["Fly"] = 70.2, ["Ride"] = 31.44, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 136.19, ["Neon|Fly|Ride"] = 224.18, ["Mega|Ride"] = 489.2, ["Mega|Fly|Ride"] = 798.21}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 347.82, ["Fly"] = 502.83, ["Ride"] = 376.57, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2612.51, ["Mega|Fly|Ride"] = 7961.1}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.66, ["Fly"] = 104.77, ["Ride"] = 55.13, ["Fly|Ride"] = 87.93, ["Neon"] = 180.62, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 280.61, ["Mega"] = 718.86, ["Mega|Ride"] = 677.76, ["Mega|Fly|Ride"] = 628.52}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.17, ["Fly"] = 83.83, ["Ride"] = 62.3, ["Fly|Ride"] = 209.52, ["Neon"] = 188.65, ["Neon|Ride"] = 209.42, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 1257.98, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1240.26}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.59, ["Ride"] = 78.74, ["Fly|Ride"] = 133.88, ["Neon"] = 94.5, ["Neon|Ride"] = 165.53, ["Neon|Fly|Ride"] = 275.9, ["Mega"] = 367.5, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9948.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7743.75, ["Neon|Fly|Ride"] = 14306.25, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1867.72, ["Fly"] = 2514.04, ["Ride"] = 1741.88, ["Fly|Ride"] = 1783.84, ["Neon"] = 6130.67, ["Neon|Ride"] = 5307.75, ["Neon|Fly|Ride"] = 4790.63, ["Mega|Fly|Ride"] = 24442.64}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 392.43, ["Ride"] = 434.74, ["Fly|Ride"] = 459.38, ["Neon"] = 2094.94, ["Neon|Fly|Ride"] = 2068.85, ["Mega"] = 11789.74, ["Mega|Fly|Ride"] = 6690.47}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.19, ["Fly"] = 31.44, ["Ride"] = 18.88, ["Fly|Ride"] = 45.35, ["Neon"] = 108.78, ["Neon|Ride"] = 104.77, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 461.96}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.68, ["Fly"] = 52.5, ["Ride"] = 32.16, ["Fly|Ride"] = 124.66, ["Neon"] = 22.42, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 157.47, ["Mega"] = 140.44, ["Mega|Ride"] = 185.87, ["Mega|Fly|Ride"] = 270.9}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.13, ["Fly"] = 38.64, ["Ride"] = 45.93, ["Fly|Ride"] = 94.11, ["Neon|Ride"] = 148.89, ["Neon|Fly|Ride"] = 194.03, ["Mega"] = 628.52, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.81, ["Fly"] = 32.49, ["Ride"] = 19.69, ["Fly|Ride"] = 35.44, ["Neon"] = 35.63, ["Neon|Fly"] = 63.68, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 65.55, ["Mega"] = 393.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 338.38}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 262.49, ["Fly"] = 320.25, ["Ride"] = 321.42, ["Fly|Ride"] = 372.74, ["Neon"] = 1145.92, ["Neon|Ride"] = 1855.72, ["Neon|Fly|Ride"] = 1271.69, ["Mega|Fly|Ride"] = 7332.59}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.93, ["Fly"] = 48.19, ["Ride"] = 35.62, ["Fly|Ride"] = 72.19, ["Neon"] = 98.48, ["Neon|Fly"] = 167.63, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 571.95}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.82, ["Fly"] = 28.29, ["Ride"] = 18.38, ["Fly|Ride"] = 39.29, ["Neon"] = 140.38, ["Neon|Fly"] = 134.42, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 523.78, ["Mega|Ride"] = 577.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.43, ["Fly"] = 787.5, ["Ride"] = 328.13, ["Fly|Ride"] = 690.33, ["Neon|Ride"] = 2723.55, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1397.4, ["Ride"] = 1173.23, ["Fly|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17912.45}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84.78, ["Fly"] = 120.48, ["Ride"] = 101.07, ["Fly|Ride"] = 118.12, ["Neon"] = 971.25, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2571.65}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 153.57, ["Fly"] = 176.65, ["Ride"] = 183.75, ["Fly|Ride"] = 210, ["Neon"] = 656.25, ["Neon|Fly"] = 670.43, ["Neon|Ride"] = 668.5, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 5587.44, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.57, ["Fly"] = 131.25, ["Ride"] = 40.09, ["Fly|Ride"] = 279.7, ["Neon"] = 199.5, ["Neon|Fly"] = 419.03, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 363.5, ["Mega|Ride"] = 698.71, ["Mega|Fly|Ride"] = 895.63}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 174.57, ["Ride"] = 279.7, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1391.2, ["Mega|Fly|Ride"] = 2971.03}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2483.25, ["Fly|Ride"] = 2640.79, ["Neon|Fly|Ride"] = 7121, ["Mega|Fly|Ride"] = 48185.52}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 67.08, ["Ride"] = 52.39, ["Fly|Ride"] = 196.87, ["Neon"] = 313.22, ["Neon|Fly"] = 314.27, ["Neon|Ride"] = 559.38, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 2095.04, ["Mega|Ride"] = 2304.53, ["Mega|Fly|Ride"] = 1886.36}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 551.23, ["Fly"] = 675.94, ["Ride"] = 566.98, ["Fly|Ride"] = 551.25, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1237.05, ["Mega|Fly|Ride"] = 3077.71}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 34.13, ["Fly"] = 63, ["Ride"] = 61.69, ["Fly|Ride"] = 102.68, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 188.61, ["Mega|Fly|Ride"] = 1088.26}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.75, ["Fly"] = 32.49, ["Ride"] = 20.99, ["Fly|Ride"] = 52.66, ["Neon"] = 27.57, ["Neon|Fly"] = 158, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 90.67, ["Mega"] = 149.5, ["Mega|Fly"] = 249.33, ["Mega|Ride"] = 180.89, ["Mega|Fly|Ride"] = 234.83}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 42.33, ["Ride"] = 72.19, ["Fly|Ride"] = 158, ["Neon"] = 248.07, ["Neon|Ride"] = 262.71, ["Neon|Fly|Ride"] = 514.35, ["Mega|Ride"] = 1397.4, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 525, ["Fly"] = 899.07, ["Ride"] = 590.63, ["Fly|Ride"] = 649.04, ["Neon"] = 2374.73, ["Neon|Ride"] = 1929.38, ["Neon|Fly|Ride"] = 1548.73, ["Mega|Fly|Ride"] = 6563.72}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 511.88, ["Ride"] = 498.75, ["Fly|Ride"] = 643.18, ["Neon"] = 5237.56, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12576.12}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 17.06, ["Fly"] = 26.17, ["Ride"] = 21.24, ["Fly|Ride"] = 49.25, ["Neon"] = 209.52, ["Neon|Ride"] = 100.58, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 629.58}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.19, ["Ride"] = 21.53, ["Fly|Ride"] = 60.16, ["Neon"] = 56.58, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1676.04, ["Mega|Ride"] = 388.58, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.83, ["Ride"] = 23.59, ["Fly|Ride"] = 111.56, ["Neon"] = 24.11, ["Neon|Fly"] = 78.91, ["Neon|Ride"] = 67.06, ["Neon|Fly|Ride"] = 112.1, ["Mega"] = 203.23, ["Mega|Fly"] = 456.27, ["Mega|Ride"] = 225.73, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.32, ["Fly"] = 62.87, ["Ride"] = 49.69, ["Fly|Ride"] = 89.63, ["Neon"] = 293.32, ["Neon|Ride"] = 208.94, ["Neon|Fly|Ride"] = 181.92, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 43.22, ["Ride"] = 111.57, ["Fly|Ride"] = 1047.53, ["Neon"] = 140.38, ["Neon|Ride"] = 401.44, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1569.19, ["Mega|Ride"] = 1536.71, ["Mega|Fly|Ride"] = 1257.98}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.95, ["Fly"] = 65.63, ["Ride"] = 33.53, ["Fly|Ride"] = 83.99, ["Neon"] = 112.35, ["Neon|Fly"] = 149.73, ["Neon|Ride"] = 94.73, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.16, ["Fly"] = 65.05, ["Ride"] = 44.52, ["Fly|Ride"] = 89.22, ["Neon"] = 207.47, ["Neon|Ride"] = 221.82, ["Neon|Fly|Ride"] = 174.19, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1178.99}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.76, ["Fly"] = 28.2, ["Ride"] = 18.36, ["Fly|Ride"] = 32.49, ["Neon"] = 28.87, ["Neon|Ride"] = 36.31, ["Neon|Fly|Ride"] = 87.26, ["Mega"] = 262.5, ["Mega|Ride"] = 276.56, ["Mega|Fly|Ride"] = 366.83}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.3, ["Fly"] = 28.88, ["Ride"] = 27.08, ["Fly|Ride"] = 67.22, ["Neon"] = 26.82, ["Neon|Fly"] = 158, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 188.65, ["Mega"] = 161.33, ["Mega|Fly"] = 475.58, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 523.95}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 45.94, ["Fly"] = 60.37, ["Ride"] = 70.88, ["Fly|Ride"] = 68.25, ["Neon"] = 409.13, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2034.38, ["Fly"] = 2362.5, ["Ride"] = 1820.43, ["Fly|Ride"] = 1758.75, ["Neon|Ride"] = 5760.28, ["Neon|Fly|Ride"] = 3871.88, ["Mega|Fly|Ride"] = 17172.92}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 431.8, ["Fly"] = 559.38, ["Ride"] = 522.73, ["Fly|Ride"] = 522.73, ["Neon"] = 3144.33, ["Neon|Ride"] = 3073.41, ["Neon|Fly|Ride"] = 2229.11, ["Mega|Fly|Ride"] = 9745}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 227.39, ["Fly"] = 262.5, ["Ride"] = 262.5, ["Fly|Ride"] = 380.63, ["Neon"] = 1155, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 7332.59, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.51}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.59, ["Ride"] = 51.8, ["Fly|Ride"] = 78.74, ["Neon"] = 250.38, ["Neon|Ride"] = 257.99, ["Neon|Fly|Ride"] = 279.7, ["Mega|Ride"] = 836.98, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33520.36, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 15750, ["Neon|Fly|Ride"] = 34917.74, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 336.57, ["Fly"] = 496.53, ["Ride"] = 409.5, ["Fly|Ride"] = 459.38, ["Neon"] = 1397.4, ["Neon|Fly"] = 1603.42, ["Neon|Ride"] = 1257.03, ["Neon|Fly|Ride"] = 1256.07, ["Mega"] = 6285.08, ["Mega|Ride"] = 6602.26, ["Mega|Fly|Ride"] = 4138.31}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Fly"] = 140.38, ["Ride"] = 136.49, ["Fly|Ride"] = 141.49, ["Neon|Fly|Ride"] = 377.12, ["Mega|Fly|Ride"] = 4190.06}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 104.98, ["Fly"] = 279.7, ["Ride"] = 125.03, ["Fly|Ride"] = 195.9, ["Neon"] = 705.05, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 479.77, ["Mega"] = 13967.52, ["Mega|Fly|Ride"] = 5237.56}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.99, ["Fly"] = 69.15, ["Ride"] = 28.31, ["Fly|Ride"] = 125.98, ["Neon"] = 266.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 194.86, ["Mega"] = 1968.75}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4646.33, ["Ride"] = 4747.33, ["Fly|Ride"] = 3937.37, ["Neon"] = 16760.2, ["Neon|Ride"] = 16760.2, ["Neon|Fly|Ride"] = 17458.88}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.18, ["Fly"] = 49.58, ["Ride"] = 31.49, ["Fly|Ride"] = 52.5, ["Neon"] = 333.94, ["Neon|Ride"] = 207.42, ["Neon|Fly|Ride"] = 204.24, ["Mega"] = 1047.53, ["Mega|Fly|Ride"] = 761.78}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.75, ["Fly"] = 115.24, ["Ride"] = 44.01, ["Fly|Ride"] = 111.09, ["Neon"] = 228.74, ["Neon|Fly"] = 1397.4, ["Neon|Ride"] = 276.56, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1572.77, ["Mega|Fly|Ride"] = 1117.71}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.38, ["Fly"] = 908.2, ["Ride"] = 578.79, ["Fly|Ride"] = 656.24, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 4766.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.36, ["Fly"] = 32.49, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 104.99, ["Neon|Fly"] = 158, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 521.06}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.46, ["Fly"] = 74.39, ["Ride"] = 77.53, ["Neon"] = 80.07, ["Neon|Ride"] = 192.19, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 504.61, ["Mega|Ride"] = 559.38}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.77, ["Fly"] = 471.6, ["Ride"] = 125.72, ["Fly|Ride"] = 245.44, ["Neon"] = 685.09, ["Neon|Ride"] = 488.15, ["Neon|Fly|Ride"] = 695.57, ["Mega|Fly|Ride"] = 2793.73}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.84, ["Fly"] = 94.32, ["Ride"] = 59.07, ["Fly|Ride"] = 125.06, ["Neon"] = 87.6, ["Neon|Fly"] = 188.57, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 292.69, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 294.68, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3404, ["Fly"] = 5131.77, ["Ride"] = 3478.13, ["Fly|Ride"] = 3377.05, ["Neon|Ride"] = 11619.01, ["Neon|Fly|Ride"] = 8445.93, ["Mega"] = 43810.07, ["Mega|Fly|Ride"] = 32823.77}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 41.56, ["Ride"] = 62.99, ["Fly|Ride"] = 119.22, ["Neon"] = 131.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 412.67, ["Mega|Ride"] = 878.88, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7701.31, ["Ride"] = 7544.85, ["Fly|Ride"] = 6168.75, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 62850.67}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.61, ["Fly"] = 23.5, ["Ride"] = 18.19, ["Fly|Ride"] = 44.01, ["Neon"] = 21, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.98, ["Mega"] = 419.03, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.62, ["Fly"] = 26.25, ["Ride"] = 31.49, ["Fly|Ride"] = 60.73, ["Neon"] = 195.9, ["Neon|Ride"] = 556.45, ["Neon|Fly|Ride"] = 155.05, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.68, ["Ride"] = 39.37, ["Fly|Ride"] = 122.84, ["Neon"] = 158, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 182.28, ["Mega"] = 1049.9, ["Mega|Ride"] = 978.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.03, ["Fly"] = 262.5, ["Ride"] = 34.13, ["Fly|Ride"] = 140.38, ["Neon"] = 155.05, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 205.33, ["Mega"] = 840, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.1, ["Fly"] = 26.99, ["Ride"] = 21.61, ["Fly|Ride"] = 41.14, ["Neon|Ride"] = 108.96, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2514.04, ["Mega|Ride"] = 588.33, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8338.21}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 17.76}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.91, ["Fly"] = 174.57, ["Ride"] = 170.63, ["Fly|Ride"] = 210, ["Neon|Fly|Ride"] = 1117.71, ["Mega|Fly|Ride"] = 5502.29}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.32, ["Fly"] = 132, ["Ride"] = 56.58, ["Fly|Ride"] = 314.81, ["Neon"] = 140.38, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 456.27, ["Mega"] = 698.71, ["Mega|Ride"] = 896.03, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.09}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.03, ["Ride"] = 26.25, ["Neon|Ride"] = 63.68, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2546.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 161.44, ["Ride"] = 223.13, ["Fly|Ride"] = 416.93, ["Neon"] = 701.37, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3478.8, ["Mega|Fly|Ride"] = 3478.8}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 128.12, ["Ride"] = 203.6, ["Fly|Ride"] = 485.63, ["Neon"] = 628.67, ["Neon|Ride"] = 1062.18, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 172.64, ["Fly"] = 231.51, ["Ride"] = 170.24, ["Fly|Ride"] = 258.88, ["Neon"] = 799.32, ["Neon|Ride"] = 838.23, ["Neon|Fly|Ride"] = 851.53, ["Mega"] = 4609.06, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1506.75, ["Fly"] = 2514.04, ["Ride"] = 1312.47, ["Fly|Ride"] = 1351.76, ["Neon"] = 5030.69, ["Neon|Ride"] = 4749.44, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 26537.66}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.48, ["Fly"] = 81.73, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 127.31, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 314.81, ["Mega"] = 836.98, ["Mega|Fly|Ride"] = 1075.8}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 630, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 818.23, ["Neon|Ride"] = 1446.62, ["Neon|Fly|Ride"] = 3045.13}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 48.44}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Ride"] = 43.32, ["Fly|Ride"] = 178.1, ["Neon"] = 68.18, ["Neon|Ride"] = 120.48, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.62, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 628.52}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.56, ["Fly"] = 83.83, ["Ride"] = 28.3, ["Fly|Ride"] = 94.49, ["Neon"] = 56.58, ["Neon|Ride"] = 88.02, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 81.73}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 15.6, ["Ride"] = 31.22, ["Fly|Ride"] = 72.19, ["Neon"] = 196.88, ["Neon|Ride"] = 195.9, ["Neon|Fly|Ride"] = 550.59, ["Mega"] = 590.63, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23.59, ["Fly"] = 46.11, ["Ride"] = 35.51, ["Fly|Ride"] = 63.68, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 951.45, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6146.44, ["Fly"] = 10500, ["Ride"] = 5495.44, ["Fly|Ride"] = 5079.38, ["Neon|Ride"] = 17458.88, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.36, ["Fly"] = 79.21, ["Ride"] = 32.44, ["Fly|Ride"] = 83.83, ["Neon"] = 56.58, ["Neon|Ride"] = 77.35, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 528.2, ["Mega|Ride"] = 448.35, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 370.83, ["Ride"] = 118.13, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 521.07, ["Mega|Ride"] = 4190.06, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 105.21, ["Ride"] = 140.41, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 432.69, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2357.96, ["Mega|Ride"] = 2828.31, ["Mega|Fly|Ride"] = 1345.32}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.68, ["Fly"] = 70.44, ["Ride"] = 32.34, ["Fly|Ride"] = 79.02, ["Neon"] = 196.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 217.88, ["Mega|Ride"] = 865.37, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.89, ["Fly"] = 72.55, ["Ride"] = 31.1, ["Fly|Ride"] = 78.75, ["Neon"] = 24.71, ["Neon|Fly"] = 182.28, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 131.23, ["Mega|Fly"] = 6983.76, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 271.68}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 16.02, ["Fly"] = 79.01, ["Ride"] = 28.3, ["Fly|Ride"] = 68.88, ["Neon"] = 91.16, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 417.98, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 448.35}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 17.07, ["Fly"] = 28.85, ["Ride"] = 27.46, ["Fly|Ride"] = 51.84, ["Neon"] = 208.71, ["Neon|Ride"] = 138.98, ["Neon|Fly|Ride"] = 140.27, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 209.97}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.57, ["Ride"] = 131.25, ["Fly|Ride"] = 105, ["Neon"] = 177.19, ["Mega"] = 1117.71, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1676.04}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 100.91, ["Ride"] = 140.38, ["Fly|Ride"] = 262.5, ["Neon"] = 559.38, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 419.03}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.42, ["Fly"] = 212.01, ["Ride"] = 104.99, ["Fly|Ride"] = 140.38, ["Neon"] = 314.81, ["Neon|Ride"] = 471.39, ["Neon|Fly|Ride"] = 420, ["Mega"] = 918.75, ["Mega|Ride"] = 2177.58, ["Mega|Fly|Ride"] = 1159.45}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 814.01, ["Fly"] = 984.38, ["Ride"] = 727.09, ["Fly|Ride"] = 806.91, ["Neon|Fly"] = 2829.54, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 9778.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 206.07, ["Fly"] = 417.37, ["Ride"] = 218.54, ["Fly|Ride"] = 287.03, ["Neon"] = 1181.25, ["Neon|Ride"] = 1886.36, ["Neon|Fly|Ride"] = 1298.93, ["Mega"] = 8275.36, ["Mega|Fly|Ride"] = 5642.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 83.79}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.82, ["Fly"] = 35.44, ["Ride"] = 26.21, ["Fly|Ride"] = 52.5, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 102.71, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 437.26, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 496.53}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 280.88, ["Ride"] = 308.44, ["Fly|Ride"] = 420, ["Neon"] = 1020.29, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4190.06}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.36}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 126, ["Fly"] = 590.63, ["Ride"] = 144.38, ["Fly|Ride"] = 262.5, ["Neon"] = 690.38, ["Neon|Fly"] = 1676.04, ["Neon|Ride"] = 704.45, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 2520, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1969.31}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 137.71, ["Fly|Ride"] = 196.88, ["Neon"] = 1117.71, ["Neon|Ride"] = 879.93, ["Neon|Fly|Ride"] = 1046.48}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.94, ["Ride"] = 27.2, ["Fly|Ride"] = 209.52, ["Neon"] = 32.81, ["Neon|Ride"] = 73.5, ["Mega"] = 210, ["Mega|Ride"] = 363.5, ["Mega|Fly|Ride"] = 460.92}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 16.78, ["Fly"] = 63, ["Ride"] = 21.24, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 157.99, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.99, ["Fly"] = 102.32, ["Ride"] = 60.77, ["Fly|Ride"] = 140.38, ["Neon"] = 99.75, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 134.1, ["Neon|Fly|Ride"] = 251.43, ["Mega"] = 464.66, ["Mega|Ride"] = 471.6, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 116.29, ["Ride"] = 56.39, ["Fly|Ride"] = 111.2, ["Neon"] = 23, ["Neon|Fly"] = 93.16, ["Neon|Ride"] = 54.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 142.42, ["Mega|Ride"] = 155.93, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.46, ["Fly"] = 419.03, ["Ride"] = 301.87, ["Fly|Ride"] = 381.95, ["Neon"] = 1536.71, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42, ["Mega|Fly|Ride"] = 5069.96}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 107.6, ["Fly"] = 1050, ["Ride"] = 172.81, ["Fly|Ride"] = 261.17, ["Neon"] = 460.69, ["Neon|Ride"] = 532.28, ["Neon|Fly|Ride"] = 681.03, ["Mega"] = 1903.12, ["Mega|Ride"] = 1990.12, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 84.79, ["Fly"] = 167.45, ["Ride"] = 88.24, ["Fly|Ride"] = 128.63, ["Neon"] = 360.94, ["Neon|Ride"] = 393.79, ["Neon|Fly|Ride"] = 460.68, ["Mega|Fly|Ride"] = 1886.36}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 32.49, ["Fly"] = 52.5, ["Ride"] = 58.24, ["Fly|Ride"] = 251.43, ["Neon|Ride"] = 598.92, ["Neon|Fly|Ride"] = 486.06, ["Mega|Fly|Ride"] = 1662.41}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.25, ["Fly"] = 75.62, ["Ride"] = 39.38, ["Fly|Ride"] = 118.12, ["Neon"] = 68.97, ["Neon|Fly"] = 195.9, ["Neon|Ride"] = 139.01, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 698.24, ["Mega|Fly"] = 525, ["Mega|Ride"] = 496.53, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.75, ["Fly"] = 45.82, ["Ride"] = 24.2, ["Fly|Ride"] = 56.44, ["Neon"] = 27.57, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 116.66, ["Mega|Ride"] = 195.9, ["Mega|Fly|Ride"] = 209.52}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 847.87, ["Fly"] = 1084.32, ["Ride"] = 990.68, ["Fly|Ride"] = 971.25, ["Neon"] = 3007.12, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2480.63, ["Mega|Fly|Ride"] = 10106.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 391.88, ["Ride"] = 353.84, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 10475.12, ["Mega|Fly|Ride"] = 6000.17}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 85.32, ["Fly"] = 140.38, ["Ride"] = 111.05, ["Fly|Ride"] = 158, ["Neon"] = 765.19, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 349.8, ["Mega|Ride"] = 1412.06, ["Mega|Fly|Ride"] = 1460.25}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 261.19, ["Fly"] = 335.23, ["Ride"] = 296.87, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1414.77, ["Neon|Fly|Ride"] = 1244.75, ["Mega"] = 10475.12, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 22.4, ["Fly"] = 140.38, ["Ride"] = 28.87, ["Fly|Ride"] = 78.75, ["Neon"] = 136.95, ["Neon|Ride"] = 124.92, ["Neon|Fly|Ride"] = 158, ["Mega|Ride"] = 665.19, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 293.32, ["Fly|Ride"] = 471.6, ["Neon"] = 1419.05, ["Neon|Ride"] = 1729.58, ["Neon|Fly|Ride"] = 1336.97, ["Mega"] = 4169.29, ["Mega|Fly|Ride"] = 4213.08}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.25, ["Fly"] = 126, ["Ride"] = 65.63, ["Fly|Ride"] = 83.82, ["Neon|Ride"] = 500.73, ["Neon|Fly|Ride"] = 559.38, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1588.09, ["Ride"] = 1387.44, ["Fly|Ride"] = 1355.87, ["Neon|Fly|Ride"] = 6838.06, ["Mega"] = 50280.55, ["Mega|Fly|Ride"] = 24302.28}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.84, ["Fly"] = 57.73, ["Ride"] = 37.4, ["Fly|Ride"] = 73.5, ["Neon"] = 52.4, ["Neon|Fly"] = 167.63, ["Neon|Ride"] = 90.11, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 259.88, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.88, ["Fly"] = 78.75, ["Ride"] = 51.9, ["Fly|Ride"] = 159.48, ["Neon"] = 237.83, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 417.98, ["Mega|Ride"] = 1084.68, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.44, ["Fly"] = 91.88, ["Ride"] = 62.98, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1368.47}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3771.06, ["Ride"] = 1141.88, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 461.96, ["Fly"] = 835.93, ["Ride"] = 586.63, ["Fly|Ride"] = 698.71, ["Neon|Fly|Ride"] = 2751.73, ["Mega|Fly|Ride"] = 14147.68}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 110.44, ["Fly"] = 314.81, ["Ride"] = 187.69, ["Fly|Ride"] = 207.71, ["Neon"] = 441.14, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 545.54, ["Mega"] = 4189.01, ["Mega|Ride"] = 2647.08, ["Mega|Fly|Ride"] = 2165.23}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.79, ["Fly"] = 39.37, ["Ride"] = 27.56, ["Fly|Ride"] = 61.69, ["Neon"] = 71.85, ["Neon|Ride"] = 118.38, ["Neon|Fly|Ride"] = 178.1, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1034.96}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 53.58, ["Fly"] = 83.83, ["Ride"] = 47.11, ["Fly|Ride"] = 103.77, ["Neon"] = 188.57, ["Neon|Fly"] = 417.98, ["Neon|Ride"] = 209.52, ["Neon|Fly|Ride"] = 276.56, ["Mega"] = 1816.4, ["Mega|Ride"] = 1069.35, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Ride"] = 874.13, ["Fly|Ride"] = 989.63, ["Neon"] = 3128.93, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3414.91, ["Mega|Fly|Ride"] = 15643.55}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.46}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5442.89, ["Fly|Ride"] = 4235.95, ["Neon"] = 42000, ["Neon|Ride"] = 30022.74, ["Neon|Fly|Ride"] = 21925.46, ["Mega|Fly|Ride"] = 89388.32}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 162.51, ["Fly"] = 276.17, ["Ride"] = 272.37, ["Neon"] = 1676.04, ["Neon|Ride"] = 1257.98, ["Neon|Fly|Ride"] = 1397.4, ["Mega"] = 5865.03, ["Mega|Fly|Ride"] = 6006.45}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 74.82, ["Fly"] = 279.7, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 331.99, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 978.38, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.58, ["Fly"] = 131.24, ["Ride"] = 30.08, ["Fly|Ride"] = 104.99, ["Neon"] = 105, ["Neon|Ride"] = 104.77, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 698.71, ["Mega|Ride"] = 628.52, ["Mega|Fly|Ride"] = 586.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 16.78, ["Fly"] = 31.82, ["Ride"] = 28.62, ["Fly|Ride"] = 52.64, ["Neon|Fly"] = 279.7, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2220.73}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.69, ["Fly"] = 131.25, ["Ride"] = 41.05, ["Fly|Ride"] = 110.23, ["Neon"] = 154.88, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 221.89, ["Mega"] = 549.94, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.8, ["Fly"] = 56.58, ["Ride"] = 22.32, ["Fly|Ride"] = 64.96, ["Neon"] = 35.63, ["Neon|Fly"] = 345.7, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 194.85, ["Mega|Fly|Ride"] = 293.32}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.77, ["Ride"] = 51.9, ["Fly|Ride"] = 183.74, ["Neon"] = 163.44, ["Neon|Fly"] = 838.03, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 245.93, ["Mega"] = 691.38, ["Mega|Ride"] = 739.23, ["Mega|Fly|Ride"] = 824.4}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 284.29, ["Fly"] = 365.5, ["Ride"] = 288.74, ["Fly|Ride"] = 353.59, ["Neon"] = 1414.77, ["Neon|Ride"] = 973.25, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6562.5, ["Mega|Ride"] = 3631.73, ["Mega|Fly|Ride"] = 3628.59}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.91, ["Fly"] = 22.97, ["Ride"] = 17.07, ["Fly|Ride"] = 36.68, ["Neon"] = 18.25, ["Neon|Ride"] = 29.65, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 835.93, ["Mega|Ride"] = 218.3, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.24, ["Fly"] = 78.75, ["Ride"] = 65.58, ["Fly|Ride"] = 118.13, ["Neon"] = 175.49, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 614.15, ["Mega|Fly"] = 838.03, ["Mega|Ride"] = 564.36, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 685.74, ["Fly"] = 998.6, ["Ride"] = 698.24, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1567.1, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.17, ["Fly"] = 91.88, ["Ride"] = 47.25, ["Fly|Ride"] = 85.31, ["Neon|Fly"] = 471.6, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 279.7, ["Ride"] = 260.98, ["Fly|Ride"] = 315, ["Neon"] = 908.2, ["Neon|Ride"] = 1255.98, ["Neon|Fly|Ride"] = 1021.12, ["Mega"] = 5973.87, ["Mega|Fly|Ride"] = 5817.07}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.24, ["Fly"] = 139.02, ["Ride"] = 129.93, ["Fly|Ride"] = 170.62, ["Neon|Ride"] = 559.38, ["Neon|Fly|Ride"] = 469.87, ["Mega|Fly|Ride"] = 2357.95}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 525, ["Fly|Ride"] = 564.38, ["Neon|Ride"] = 2572.5, ["Neon|Fly|Ride"] = 2235.4, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 55.13, ["Neon"] = 82.79, ["Neon|Fly"] = 282.96, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 262.48, ["Mega|Ride"] = 364.55, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4001.45, ["Fly"] = 3203.26, ["Ride"] = 3846.59, ["Fly|Ride"] = 2886.19, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 82.29, ["Fly"] = 121.53, ["Ride"] = 104.66, ["Fly|Ride"] = 160.13, ["Neon"] = 419.03, ["Neon|Ride"] = 448.35, ["Neon|Fly|Ride"] = 457.7, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.54, ["Fly"] = 20.97, ["Ride"] = 22.32, ["Fly|Ride"] = 83.83, ["Neon"] = 23.63, ["Neon|Fly"] = 45.06, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 131.25, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 235.91}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.4, ["Ride"] = 27.98, ["Neon"] = 18.71, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.43, ["Mega"] = 161.43, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 54.49, ["Fly"] = 52.39, ["Ride"] = 54.5, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 262.95, ["Mega|Fly|Ride"] = 1382.73}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 939.75, ["Ride"] = 1173.38, ["Fly|Ride"] = 1295.43, ["Neon"] = 5719.43}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4725, ["Ride"] = 5894.88, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21.7, ["Fly"] = 31.44, ["Ride"] = 31.47, ["Fly|Ride"] = 50.95, ["Neon"] = 261.86, ["Neon|Ride"] = 155.05, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 573}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.05, ["Fly"] = 49.25, ["Ride"] = 40.1, ["Fly|Ride"] = 93.16, ["Neon"] = 87.94, ["Neon|Ride"] = 88.53, ["Neon|Fly|Ride"] = 140.39, ["Mega"] = 933.52, ["Mega|Ride"] = 564.75, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 55.11, ["Fly"] = 157.5, ["Ride"] = 49.38, ["Fly|Ride"] = 98.44, ["Neon"] = 271.24, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 1127.14, ["Mega|Ride"] = 1179.51, ["Mega|Fly|Ride"] = 1004.07}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 212.63, ["Fly"] = 314.81, ["Ride"] = 216.57, ["Fly|Ride"] = 262.28, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 825.57, ["Mega"] = 10475.12, ["Mega|Fly|Ride"] = 3212.73}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.84, ["Ride"] = 28.3, ["Fly|Ride"] = 86.63, ["Neon"] = 22.42, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 245.24, ["Mega"] = 154.88, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 416.93}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 255.64, ["Ride"] = 204.4, ["Fly|Ride"] = 196.88, ["Neon"] = 786.39, ["Neon|Ride"] = 835.93, ["Neon|Fly|Ride"] = 836.07, ["Mega|Fly|Ride"] = 3909.32}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.44, ["Fly"] = 20.63, ["Ride"] = 18.27, ["Fly|Ride"] = 46.11, ["Neon"] = 19.69, ["Neon|Fly"] = 51.97, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 82.68, ["Mega"] = 275.94, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 260.56, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 218.39, ["Neon|Ride"] = 1296.89, ["Neon|Fly|Ride"] = 943.19, ["Mega"] = 10474.08, ["Mega|Ride"] = 4190.06, ["Mega|Fly|Ride"] = 3912.46}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.15, ["Fly"] = 26.25, ["Ride"] = 27.07, ["Fly|Ride"] = 56.27, ["Neon"] = 91.16, ["Neon|Fly"] = 299.46, ["Neon|Ride"] = 99.53, ["Neon|Fly|Ride"] = 272.36, ["Mega"] = 522.31, ["Mega|Ride"] = 559.38, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 6.57, ["Neon|Fly"] = 66.01, ["Neon|Ride"] = 59.93, ["Neon|Fly|Ride"] = 133.84, ["Mega"] = 77.18, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 70.2, ["Mega"] = 24.93, ["Mega|Ride"] = 139.14}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 235.72, ["Fly|Ride"] = 139.63, ["Neon"] = 7.46, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 140.38, ["Mega|Fly"] = 157197.17, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 159.85}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 64.84, ["Fly"] = 136.83, ["Ride"] = 110.51, ["Fly|Ride"] = 213.94, ["Neon"] = 237.57, ["Neon|Fly"] = 404.83, ["Neon|Ride"] = 260.69, ["Neon|Fly|Ride"] = 341.16, ["Mega|Fly|Ride"] = 1233.1}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.63, ["Neon"] = 91.86, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 98.06, ["Mega|Ride"] = 56.58, ["Mega|Fly|Ride"] = 104.77}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 12.32, ["Ride"] = 111.2, ["Fly|Ride"] = 194.85, ["Neon"] = 74.82, ["Neon|Ride"] = 111.57, ["Mega"] = 328.13, ["Mega|Ride"] = 622.13}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 18.54, ["Mega|Ride"] = 49.14, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.73, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21.19, ["Neon|Ride"] = 14.66, ["Neon|Fly|Ride"] = 32.22, ["Mega"] = 18.27, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 57.66}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 26.17, ["Neon"] = 3.93, ["Neon|Fly"] = 15.43, ["Neon|Ride"] = 23.06, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 28.03, ["Mega|Fly"] = 69.15, ["Mega|Ride"] = 58.69, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 58.96, ["Mega"] = 18.19, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 16.94, ["Fly|Ride"] = 107.62, ["Neon"] = 2.1, ["Neon|Fly"] = 135.07, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 64.12, ["Mega"] = 26.17, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.48, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 21.86, ["Mega|Fly"] = 100.58, ["Mega|Ride"] = 89.15}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 53.37, ["Ride"] = 19.92, ["Fly|Ride"] = 47.42, ["Neon"] = 2.63, ["Neon|Fly"] = 50.8, ["Neon|Ride"] = 23.49, ["Neon|Fly|Ride"] = 64.96, ["Mega"] = 54.03, ["Mega|Fly"] = 69.57, ["Mega|Ride"] = 72.75, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 18.33, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 62.95, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 14.44, ["Mega"] = 209.52, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 279.7}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Neon"] = 13.36, ["Mega"] = 105, ["Mega|Fly|Ride"] = 377.12}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 28.25, ["Mega|Ride"] = 60.77, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.66, ["Ride"] = 15.64, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.27, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 15.7, ["Mega|Ride"] = 26.59, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.13, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.82, ["Mega"] = 251.43, ["Mega|Ride"] = 274.55}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 4.34, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 158, ["Mega"] = 34, ["Mega|Ride"] = 91.76, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.61, ["Neon"] = 8.97, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 89.25, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 223.11}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 190.66, ["Neon"] = 6.57, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 103.84, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 15.54, ["Ride"] = 12.47, ["Fly|Ride"] = 35.63, ["Neon"] = 2.1, ["Neon|Fly"] = 14.23, ["Neon|Ride"] = 14.22, ["Neon|Fly|Ride"] = 31.39, ["Mega"] = 20.97, ["Mega|Fly"] = 31.44, ["Mega|Ride"] = 28.3, ["Mega|Fly|Ride"] = 58.47}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.96, ["Ride"] = 18.86, ["Fly|Ride"] = 72.19, ["Neon"] = 15.64, ["Neon|Ride"] = 113.21, ["Neon|Fly|Ride"] = 83.83, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 27.25, ["Neon"] = 90.11, ["Neon|Ride"] = 112.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 235.77, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.08, ["Ride"] = 15.74, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 16.47, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 158, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 70.2, ["Mega|Fly|Ride"] = 92.29}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.96, ["Neon"] = 15.64, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 125.62, ["Mega|Fly"] = 167.63, ["Mega|Ride"] = 82.78}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 12.59, ["Ride"] = 23.46, ["Neon"] = 2.1, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 32.71, ["Mega|Ride"] = 155.05, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 44.01, ["Neon"] = 2.1, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 83.74, ["Mega"] = 18.27, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 125.09}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.48, ["Ride"] = 16.59, ["Fly|Ride"] = 47.17, ["Neon"] = 11.7, ["Neon|Fly"] = 45.12, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 73.41, ["Mega"] = 63.2, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 261.9}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 91.25, ["Neon"] = 4.22, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 66.04, ["Mega|Ride"] = 94.29, ["Mega|Fly|Ride"] = 309.03}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 18.37, ["Fly|Ride"] = 140.38, ["Neon"] = 9.34, ["Neon|Fly"] = 69.86, ["Neon|Ride"] = 25.08, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 77.04, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.39}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.55, ["Ride"] = 82.69, ["Neon"] = 56.58, ["Mega|Fly|Ride"] = 838.03}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.22, ["Fly|Ride"] = 5423.29, ["Neon"] = 6.57, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 31.47, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.7, ["Fly|Ride"] = 177.68, ["Neon"] = 10.5, ["Neon|Fly"] = 39.82, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 111.05, ["Mega"] = 191.58, ["Mega|Fly"] = 116.29, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 81.93, ["Fly|Ride"] = 106.13, ["Neon"] = 23.06, ["Mega"] = 200.16, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.16, ["Ride"] = 131.24, ["Neon|Ride"] = 235.81, ["Mega"] = 937.54, ["Mega|Ride"] = 875.74, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 131.06, ["Neon"] = 37.97, ["Neon|Ride"] = 91.88, ["Mega"] = 253.32, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 2.52, ["Ride"] = 42.83, ["Fly|Ride"] = 140.38, ["Neon"] = 41.92, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 289.13, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 416.93}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 64.98, ["Mega"] = 18.59, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.3}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 55.53}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.53, ["Fly"] = 27.2, ["Ride"] = 22.23, ["Fly|Ride"] = 39.38, ["Neon"] = 36.05, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 47.12, ["Neon|Fly|Ride"] = 94.29, ["Mega"] = 283.5, ["Mega|Fly"] = 293.32, ["Mega|Ride"] = 275.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Fly|Ride"] = 730.98, ["Neon"] = 6.46, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 24.44, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 20.89, ["Fly|Ride"] = 393.64, ["Neon"] = 6.54, ["Neon|Ride"] = 36.67, ["Neon|Fly|Ride"] = 402.59, ["Mega"] = 57.66, ["Mega|Ride"] = 69.3, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.92, ["Fly|Ride"] = 77.53, ["Neon"] = 18.89, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 76.55, ["Mega"] = 140.43, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.52, ["Ride"] = 98.48, ["Neon"] = 58.97, ["Neon|Ride"] = 79.01, ["Neon|Fly|Ride"] = 154.97, ["Mega"] = 328.13, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 79.01, ["Mega"] = 32.82, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 47.79, ["Mega|Fly|Ride"] = 140.38}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.96, ["Fly|Ride"] = 279336.65, ["Neon"] = 3.82, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 69.45, ["Mega"] = 40.86, ["Mega|Fly"] = 200.44, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.47}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.89, ["Ride"] = 15.73, ["Fly|Ride"] = 32.22, ["Neon"] = 3.94, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 60.06, ["Mega|Ride"] = 51.32, ["Mega|Fly|Ride"] = 139.12}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 32.16, ["Fly|Ride"] = 77.83, ["Neon"] = 6.2, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 106.89, ["Mega"] = 23.49, ["Mega|Ride"] = 37.28, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 171.82, ["Mega"] = 18.8, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 97.86, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.67, ["Ride"] = 52.41, ["Fly|Ride"] = 77.43, ["Neon"] = 3.94, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.87, ["Mega"] = 36.14, ["Mega|Ride"] = 62.89, ["Mega|Fly|Ride"] = 115.45}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 49.25, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 18.38, ["Mega|Ride"] = 126.14, ["Mega|Fly|Ride"] = 261.84}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 158, ["Mega"] = 25.16, ["Mega|Fly"] = 117.91, ["Mega|Ride"] = 120.48, ["Mega|Fly|Ride"] = 349.89}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 24.99, ["Fly|Ride"] = 69.57, ["Neon"] = 6.3, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 124.64, ["Mega"] = 140.38, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.5, ["Ride"] = 78.75, ["Neon"] = 104.77, ["Neon|Ride"] = 235.81, ["Mega"] = 423.29, ["Mega|Ride"] = 511.21, ["Mega|Fly|Ride"] = 629.58}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 68.16, ["Neon"] = 41.19, ["Mega"] = 208.47, ["Mega|Ride"] = 348.48}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 419.03, ["Neon"] = 28.3, ["Mega"] = 251.43, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 324.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.49, ["Ride"] = 13, ["Fly|Ride"] = 39.8, ["Neon"] = 2.1, ["Neon|Fly"] = 17.03, ["Neon|Ride"] = 14.36, ["Neon|Fly|Ride"] = 26.81, ["Mega"] = 31.4, ["Mega|Fly"] = 27.19, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 32.45}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 55.12, ["Fly|Ride"] = 70.2, ["Neon"] = 4.87, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 698.71, ["Mega"] = 66.94, ["Mega|Ride"] = 98.48}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 20.97, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 78.59, ["Mega"] = 18.38, ["Mega|Fly"] = 53.8, ["Mega|Ride"] = 52.14, ["Mega|Fly|Ride"] = 99.39}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.87, ["Mega"] = 17.37, ["Mega|Ride"] = 106.77, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.75, ["Ride"] = 20.96, ["Fly|Ride"] = 54.49, ["Neon"] = 13.13, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 70.19, ["Mega"] = 128.7, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 323.05}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 154.88, ["Ride"] = 186.61, ["Fly|Ride"] = 262.5, ["Neon"] = 1005.63, ["Neon|Ride"] = 593.25, ["Neon|Fly|Ride"] = 978.38, ["Mega"] = 8380.11, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Fly"] = 56.58, ["Neon|Ride"] = 68.25, ["Mega"] = 87.71, ["Mega|Ride"] = 195.9, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.68, ["Ride"] = 25.97, ["Fly|Ride"] = 196.88, ["Neon"] = 20.97, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158.19, ["Mega"] = 419.03, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 1042.02}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 16.53, ["Fly|Ride"] = 36.66, ["Neon"] = 4.73, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 57.75, ["Mega|Fly"] = 94.33, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 20.97, ["Fly|Ride"] = 120.88, ["Neon"] = 20.69, ["Neon|Ride"] = 103.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 94.29, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 208.47}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.87, ["Fly"] = 28.87, ["Ride"] = 16.96, ["Fly|Ride"] = 35.43, ["Neon"] = 32.7, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 278.65, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 39.38, ["Fly|Ride"] = 247.08, ["Neon"] = 44.35, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 622.23, ["Mega"] = 327.48, ["Mega|Ride"] = 347.8, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.47, ["Fly"] = 20.92, ["Ride"] = 18.64, ["Fly|Ride"] = 37.4, ["Neon"] = 41.92, ["Neon|Fly"] = 56.58, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 54.69, ["Mega|Fly"] = 243.05, ["Mega|Ride"] = 353.71, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 74.82, ["Fly"] = 131.25, ["Ride"] = 81.08, ["Fly|Ride"] = 131.24, ["Neon"] = 324.84, ["Neon|Fly"] = 406.88, ["Neon|Ride"] = 387.18, ["Neon|Fly|Ride"] = 479.07, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 183.75, ["Fly|Ride"] = 279.7, ["Neon|Ride"] = 2618.79, ["Neon|Fly|Ride"] = 1572.77, ["Mega"] = 10475.12, ["Mega|Fly|Ride"] = 6841.31}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 78.6, ["Fly"] = 124.48, ["Ride"] = 77.41, ["Fly|Ride"] = 131.24, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 375.38, ["Mega|Fly|Ride"] = 1118.24}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.88, ["Ride"] = 30.35, ["Neon"] = 30.17, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 157.5, ["Mega|Ride"] = 193.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.11, ["Fly"] = 68.15, ["Ride"] = 35.44, ["Fly|Ride"] = 66.94, ["Neon"] = 113.74, ["Neon|Ride"] = 97.08, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 348.77, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 523.78}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 20.83, ["Fly|Ride"] = 42, ["Neon"] = 4.59, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 42, ["Mega"] = 49.26, ["Mega|Fly"] = 209.87, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.88, ["Fly"] = 58.7, ["Ride"] = 20.14, ["Fly|Ride"] = 139.83, ["Neon"] = 42.17, ["Neon|Ride"] = 157.95, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 796.13, ["Mega|Ride"] = 628.52, ["Mega|Fly|Ride"] = 559.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.53, ["Ride"] = 18.37, ["Fly|Ride"] = 51.9, ["Neon"] = 15.66, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 94.57, ["Mega"] = 131.25, ["Mega|Ride"] = 176.35, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 328.13, ["Neon"] = 41.92, ["Neon|Ride"] = 55.44, ["Neon|Fly|Ride"] = 235.81, ["Mega"] = 207.37, ["Mega|Ride"] = 235.81, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 25.16, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 224.18}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.92, ["Fly|Ride"] = 48.2, ["Neon"] = 13.13, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 81.36, ["Mega|Fly|Ride"] = 140.38}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.08, ["Fly|Ride"] = 45.66, ["Neon"] = 63.68, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 283.5, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 233.61}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 168.68, ["Fly"] = 217.9, ["Ride"] = 210, ["Fly|Ride"] = 262.5, ["Neon"] = 616.88, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2511.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.69, ["Ride"] = 240.91, ["Fly|Ride"] = 204.28, ["Neon"] = 50.3, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 307.47, ["Mega|Ride"] = 371.39, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 16.28, ["Fly|Ride"] = 41.92, ["Neon"] = 20.89, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 35.63, ["Mega"] = 136.43, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.69, ["Ride"] = 58.68, ["Fly|Ride"] = 178.5, ["Neon"] = 102.06, ["Neon|Ride"] = 119.75, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 552.57, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 543.67}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 9.19}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 27.56, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 628.52, ["Mega"] = 225.75, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.5, ["Fly"] = 26.25, ["Ride"] = 27.56, ["Fly|Ride"] = 57.74, ["Neon"] = 182.28, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 198.98, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 2095.04, ["Mega|Ride"] = 693.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 52.62, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 34.04, ["Mega|Fly"] = 413.79, ["Mega|Ride"] = 65.6, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.94, ["Fly"] = 26.88, ["Ride"] = 28.3, ["Fly|Ride"] = 62.26, ["Neon"] = 83.83, ["Neon|Ride"] = 235.81, ["Mega"] = 140.42, ["Mega|Fly"] = 393.79, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.06, ["Ride"] = 16.72, ["Fly|Ride"] = 45.65, ["Neon"] = 19.91, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 124.68, ["Mega|Ride"] = 140.39, ["Mega|Fly|Ride"] = 224.88}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23, ["Neon"] = 3.84, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 30.19, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 40.69, ["Fly"] = 125.72, ["Ride"] = 103.72, ["Fly|Ride"] = 167.63, ["Neon"] = 240.19, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 821.63, ["Mega|Ride"] = 920.78, ["Mega|Fly|Ride"] = 840.16}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 276.56, ["Neon"] = 80.07, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 209.52, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.88, ["Fly"] = 139.53, ["Ride"] = 52.41, ["Fly|Ride"] = 139, ["Neon"] = 57.74, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 102.67, ["Neon|Fly|Ride"] = 109.9, ["Mega"] = 619.1, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 48.56, ["Fly"] = 98.48, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 279.7, ["Neon|Ride"] = 349.89, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.39, ["Fly"] = 39.38, ["Ride"] = 26.92, ["Fly|Ride"] = 56.44, ["Neon"] = 61.08, ["Neon|Ride"] = 60.44, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 236.25, ["Mega|Ride"] = 279.7, ["Mega|Fly|Ride"] = 489.2}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 80.07, ["Fly"] = 145.69, ["Ride"] = 104.64, ["Fly|Ride"] = 196.88, ["Neon"] = 201.39, ["Neon|Ride"] = 268.8, ["Neon|Fly|Ride"] = 385.88, ["Mega"] = 2043.17, ["Mega|Ride"] = 1089.43, ["Mega|Fly|Ride"] = 812.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.99, ["Ride"] = 59.07, ["Fly|Ride"] = 173.25, ["Neon"] = 86.6, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 835.93, ["Mega"] = 417.98, ["Mega|Ride"] = 344.54, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 6.3, ["Fly"] = 69.5, ["Ride"] = 19.69, ["Fly|Ride"] = 300.65, ["Neon"] = 81.23, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 125.72, ["Mega"] = 605.07, ["Mega|Ride"] = 1047.53, ["Mega|Fly|Ride"] = 400.86}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.02, ["Ride"] = 78.75, ["Fly|Ride"] = 106.32, ["Neon"] = 72.19, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 365.45, ["Mega|Fly"] = 389.69, ["Mega|Ride"] = 357.96, ["Mega|Fly|Ride"] = 475.13}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.88, ["Ride"] = 34.13, ["Fly|Ride"] = 135.61, ["Neon"] = 44.1, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 138.33, ["Mega"] = 389.58, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 18.38, ["Mega|Fly"] = 140.38, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 182.28}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.9, ["Ride"] = 28.88, ["Fly|Ride"] = 434.74, ["Neon"] = 15.33, ["Neon|Fly"] = 125.72, ["Neon|Ride"] = 83.83, ["Mega"] = 133.54, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 471.6}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Ride"] = 37.73, ["Neon"] = 22.32, ["Neon|Ride"] = 103.72, ["Mega"] = 383.92, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 9.27, ["Ride"] = 31.44, ["Fly|Ride"] = 116.74, ["Neon"] = 15.75, ["Neon|Ride"] = 82.94, ["Neon|Fly|Ride"] = 272.37, ["Mega"] = 123.37, ["Mega|Ride"] = 155.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 482.89, ["Ride"] = 525, ["Fly|Ride"] = 534.91, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.96, ["Fly"] = 27.75, ["Ride"] = 23.97, ["Fly|Ride"] = 52.31, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 210, ["Mega"] = 279.7, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 346.75}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.5, ["Fly"] = 39.38, ["Ride"] = 18.8, ["Fly|Ride"] = 56.58, ["Neon"] = 45.94, ["Neon|Ride"] = 64.32, ["Mega"] = 471.6, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 310.56}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 23.63, ["Fly|Ride"] = 314.27, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 203.44, ["Mega|Ride"] = 629.58, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 54.12, ["Ride"] = 28.02, ["Fly|Ride"] = 41.92, ["Neon"] = 9.18, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 111.05, ["Mega"] = 59.07, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 216.08}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 27.25, ["Neon"] = 2.1, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 31.5, ["Mega|Fly"] = 182.28, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 220.48}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1545.09}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.88, ["Ride"] = 41.19, ["Neon"] = 79.01, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 83.72, ["Mega|Ride"] = 544.72, ["Mega|Fly|Ride"] = 768.89}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 5.06, ["Neon|Ride"] = 40.68, ["Mega"] = 131.25, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 98.38, ["Ride"] = 19.92, ["Fly|Ride"] = 574.38, ["Neon"] = 10.48, ["Neon|Fly"] = 125.72, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 125.72, ["Mega|Ride"] = 158, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 400.24, ["Ride"] = 418.69, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1534.32, ["Neon|Fly|Ride"] = 1604.8, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.55, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 82.43, ["Neon|Ride"] = 131.25, ["Mega"] = 313.69, ["Mega|Ride"] = 385.5, ["Mega|Fly|Ride"] = 489.2}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 40.87, ["Neon"] = 3.94, ["Neon|Ride"] = 34.73, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 40.09, ["Mega|Fly"] = 189, ["Mega|Ride"] = 87.65, ["Mega|Fly|Ride"] = 260.56}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 838.03, ["Neon"] = 2.63, ["Neon|Ride"] = 97.31, ["Neon|Fly|Ride"] = 266.09, ["Mega"] = 21, ["Mega|Ride"] = 146.67, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.82, ["Fly"] = 56.27, ["Ride"] = 66.08, ["Fly|Ride"] = 167.63, ["Neon"] = 62.88, ["Neon|Ride"] = 104.77, ["Neon|Fly|Ride"] = 279.64, ["Mega"] = 355.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 363.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 17.7, ["Ride"] = 112.1, ["Neon"] = 91.97, ["Neon|Ride"] = 112.1, ["Neon|Fly|Ride"] = 834.75, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 1112.36}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.13, ["Ride"] = 31.5, ["Fly|Ride"] = 367.06, ["Neon"] = 105, ["Neon|Ride"] = 200.82, ["Mega"] = 140.38, ["Mega|Ride"] = 557.19, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.19, ["Ride"] = 65.63, ["Fly|Ride"] = 262.5, ["Neon"] = 174.5, ["Neon|Ride"] = 180.05, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 459.38, ["Mega|Ride"] = 522.73, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 414.84, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.16, ["Neon|Fly"] = 1195.49, ["Neon|Ride"] = 1411.01, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3682.59}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.59, ["Fly"] = 69.65, ["Ride"] = 22.98, ["Fly|Ride"] = 112.1, ["Neon"] = 98.44, ["Neon|Ride"] = 139.64, ["Neon|Fly|Ride"] = 137.64, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 23.63, ["Ride"] = 117.8, ["Mega"] = 627.47, ["Mega|Fly|Ride"] = 1676.04}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 10.5, ["Ride"] = 60.37, ["Fly|Ride"] = 155.65, ["Neon"] = 48.55, ["Neon|Ride"] = 98.81, ["Neon|Fly|Ride"] = 251.43, ["Mega"] = 196.88, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 328.93}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 116.29, ["Neon"] = 14.43, ["Neon|Ride"] = 112.61, ["Neon|Fly|Ride"] = 208.47, ["Mega"] = 43.32, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 235.81}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 52.49, ["Ride"] = 127.81, ["Neon"] = 282.84, ["Neon|Ride"] = 235.51, ["Neon|Fly|Ride"] = 471.39, ["Mega"] = 1814.3, ["Mega|Ride"] = 1336.97, ["Mega|Fly|Ride"] = 1242.94}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 585.43, ["Ride"] = 42.46, ["Neon"] = 11.82, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 155.65, ["Mega"] = 78.75, ["Mega|Ride"] = 102.71, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.3, ["Fly|Ride"] = 98.48, ["Neon"] = 2.63, ["Neon|Fly"] = 67.22, ["Neon|Ride"] = 51.08, ["Neon|Fly|Ride"] = 138.99, ["Mega"] = 58.68, ["Mega|Fly"] = 55.02, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 9.19, ["Ride"] = 144.38, ["Fly|Ride"] = 111.51, ["Neon"] = 72.18, ["Neon|Fly|Ride"] = 698.25, ["Mega"] = 288.75, ["Mega|Fly"] = 419.03, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 627.47}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 79.01, ["Ride"] = 65.63, ["Fly|Ride"] = 314.81, ["Neon"] = 485.62, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 627.47, ["Mega|Fly|Ride"] = 1394.25}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 242.82, ["Ride"] = 309.74, ["Fly|Ride"] = 329.44, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 12570.14, ["Mega|Fly|Ride"] = 4329.94}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.87, ["Fly|Ride"] = 77.44, ["Neon"] = 27.46, ["Mega"] = 99.6, ["Mega|Fly"] = 209.52, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 504.61}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 7.77, ["Ride"] = 126.17, ["Neon"] = 45.91, ["Mega"] = 96.84, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.91, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Fly|Ride"] = 177.7, ["Neon"] = 32.82, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 20.97, ["Fly|Ride"] = 82.78, ["Neon"] = 4.87, ["Neon|Ride"] = 27.78, ["Neon|Fly|Ride"] = 90.46, ["Mega"] = 52.5, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 33.54, ["Fly|Ride"] = 276.97, ["Neon"] = 7.87, ["Neon|Ride"] = 27.13, ["Mega"] = 39.38, ["Mega|Ride"] = 204.28, ["Mega|Fly|Ride"] = 275.51}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.07, ["Fly|Ride"] = 41.93, ["Neon"] = 4.64, ["Neon|Fly"] = 47.17, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 39.38, ["Mega|Ride"] = 95.34, ["Mega|Fly|Ride"] = 108.96}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.36, ["Ride"] = 20.96, ["Fly|Ride"] = 62.87, ["Neon"] = 6.74, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.16, ["Mega"] = 170.63, ["Mega|Ride"] = 104.77, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 93.36, ["Ride"] = 47.17, ["Fly|Ride"] = 83.65, ["Mega"] = 406.88, ["Mega|Fly"] = 525, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 84, ["Fly"] = 582.75, ["Ride"] = 102.66, ["Fly|Ride"] = 209.52, ["Neon"] = 363.46, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 701.85, ["Mega"] = 1470, ["Mega|Ride"] = 2232.26, ["Mega|Fly|Ride"] = 1956.76}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 35.43, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 59.72, ["Mega|Ride"] = 91.35}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 17.07, ["Fly|Ride"] = 30.19, ["Neon"] = 4.6, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 44.54, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 15.73, ["Fly|Ride"] = 140.38, ["Neon"] = 251.43, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 626.82, ["Mega|Ride"] = 347.8, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 350.01, ["Fly"] = 393.74, ["Ride"] = 486.06, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1466.53, ["Neon|Fly|Ride"] = 1570.23, ["Mega"] = 7860.23, ["Mega|Fly|Ride"] = 5237.56}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 32.42, ["Fly"] = 140.38, ["Ride"] = 67.06, ["Fly|Ride"] = 120.27, ["Neon"] = 223.13, ["Neon|Ride"] = 220.48, ["Neon|Fly|Ride"] = 293.32, ["Mega"] = 1074.75, ["Mega|Ride"] = 1183.26, ["Mega|Fly|Ride"] = 996.1}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Fly|Ride"] = 77.53, ["Neon"] = 11.81, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 78.74, ["Mega|Ride"] = 107.84, ["Mega|Fly|Ride"] = 195.9}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.92, ["Fly"] = 209.52, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 71.25, ["Neon|Fly"] = 419.03, ["Neon|Ride"] = 200.09, ["Mega"] = 481.87, ["Mega|Fly|Ride"] = 559.38}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.17, ["Fly"] = 77.53, ["Ride"] = 57.74, ["Fly|Ride"] = 65.63, ["Neon|Fly"] = 313.22, ["Neon|Ride"] = 313.22, ["Neon|Fly|Ride"] = 448.35, ["Mega"] = 2514.04, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1101.18}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 119.18, ["Fly"] = 209.52, ["Ride"] = 98.74, ["Fly|Ride"] = 140.21, ["Neon"] = 414.87, ["Neon|Ride"] = 469.3, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3073.41, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 190.32, ["Fly"] = 277.07, ["Ride"] = 210, ["Fly|Ride"] = 353.71, ["Neon"] = 959.69, ["Neon|Ride"] = 838.03, ["Neon|Fly|Ride"] = 888.57, ["Mega|Fly|Ride"] = 3178.17}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.11, ["Fly"] = 68.79, ["Ride"] = 70.2, ["Fly|Ride"] = 213.71, ["Neon"] = 88.46, ["Neon|Ride"] = 157.14, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 387.45, ["Mega|Ride"] = 417.98, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 17.38, ["Fly|Ride"] = 40.04, ["Neon"] = 15.74, ["Neon|Ride"] = 21.74, ["Neon|Fly|Ride"] = 88.02, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 27.43, ["Ride"] = 23.99, ["Fly|Ride"] = 520.7, ["Neon"] = 52.39, ["Neon|Fly"] = 146.67, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 70.2, ["Mega"] = 258.48, ["Mega|Ride"] = 244.39, ["Mega|Fly|Ride"] = 363.5}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 288.64, ["Ride"] = 328.12, ["Fly|Ride"] = 406.88, ["Neon"] = 1464.29, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1778.69, ["Mega|Fly|Ride"] = 4888.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.63, ["Ride"] = 60.74, ["Neon"] = 6.57, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 48.56, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 416.93}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.57, ["Ride"] = 18.38, ["Fly|Ride"] = 62.65, ["Neon"] = 25.7, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 159, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 32.49, ["Ride"] = 87.94, ["Neon"] = 118.02, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 465.94, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 131.25, ["Fly"] = 278.65, ["Ride"] = 145.69, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2928.86}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 33.33, ["Fly"] = 45.93, ["Ride"] = 32.82, ["Fly|Ride"] = 52.5, ["Neon"] = 76.13, ["Neon|Ride"] = 94.61, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 417.98, ["Mega|Ride"] = 439.98, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Ride"] = 201.63, ["Neon|Fly|Ride"] = 698.71, ["Mega"] = 20.35, ["Mega|Ride"] = 102.67, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.7, ["Fly|Ride"] = 52.49, ["Neon"] = 2.1, ["Neon|Fly"] = 158, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 60.77, ["Mega"] = 28.31, ["Mega|Fly"] = 140.31, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 90.12}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.4, ["Fly"] = 419.03, ["Ride"] = 61.69, ["Fly|Ride"] = 128.24, ["Neon"] = 27.57, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 149.43, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 267.99}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1434.56, ["Ride"] = 1238.61, ["Fly|Ride"] = 1325.63, ["Neon|Ride"] = 6983.76, ["Neon|Fly|Ride"] = 4701.24, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 349.94, ["Ride"] = 459.24, ["Fly|Ride"] = 578.72, ["Neon"] = 1670.54, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1744.89, ["Mega"] = 16760.2, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 305.53, ["Fly"] = 376.69, ["Ride"] = 336.84, ["Fly|Ride"] = 393.75, ["Neon"] = 735, ["Neon|Fly"] = 1257.98, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 3045.13}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 325.5, ["Ride"] = 396.16, ["Fly|Ride"] = 444.94, ["Neon|Fly"] = 1117.71, ["Neon|Ride"] = 1115.62, ["Neon|Fly|Ride"] = 1153.92, ["Mega|Fly|Ride"] = 4121.97}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.1, ["Fly|Ride"] = 44.63, ["Neon"] = 5.39, ["Neon|Ride"] = 29.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 106.86, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 417.38, ["Ride"] = 472.5, ["Fly|Ride"] = 618.57, ["Neon"] = 1312.5, ["Neon|Ride"] = 1454.25, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 13093.89, ["Mega|Fly|Ride"] = 4813.33}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.68, ["Fly"] = 183.75, ["Ride"] = 27.24, ["Fly|Ride"] = 63.39, ["Neon"] = 10.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 69.92, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 209.22}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.25, ["Fly|Ride"] = 39.38, ["Neon"] = 15.73, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 58.93, ["Mega"] = 89.06, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 39.37, ["Mega"] = 24.93, ["Mega|Fly"] = 140.38, ["Mega|Ride"] = 59.72, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 70.2, ["Ride"] = 65.63, ["Fly|Ride"] = 459.37, ["Neon"] = 244.13, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 208.47, ["Mega"] = 2095.04, ["Mega|Fly|Ride"] = 1005.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 64.29, ["Ride"] = 17.07, ["Fly|Ride"] = 60.44, ["Neon"] = 106.13, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.1, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 698.71, ["Mega|Ride"] = 110.06, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 23.63, ["Fly|Ride"] = 41.5, ["Neon"] = 4.73, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 55.64, ["Mega"] = 61.67, ["Mega|Fly"] = 174.96, ["Mega|Ride"] = 83.25, ["Mega|Fly|Ride"] = 171.9}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.9, ["Fly"] = 47.17, ["Ride"] = 21.24, ["Fly|Ride"] = 51.45, ["Neon"] = 112.1, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 17.57, ["Ride"] = 52.49, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 311.27, ["Mega"] = 393.79, ["Mega|Ride"] = 448.35, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.24, ["Ride"] = 27.18, ["Fly|Ride"] = 70.2, ["Neon"] = 47.25, ["Neon|Ride"] = 97.96, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 559.38, ["Mega|Ride"] = 525}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 26.65, ["Ride"] = 18.37, ["Fly|Ride"] = 55.42, ["Neon"] = 2.1, ["Neon|Fly"] = 31.44, ["Neon|Ride"] = 26.25, ["Mega"] = 43.32, ["Mega|Ride"] = 83.83, ["Mega|Fly|Ride"] = 314.27}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 228.21, ["Ride"] = 258.57, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 2618.79, ["Neon|Fly|Ride"] = 1159.6, ["Mega"] = 8380.11, ["Mega|Fly|Ride"] = 5187.49}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.37, ["Fly|Ride"] = 35.38, ["Neon"] = 5.25, ["Neon|Fly"] = 24.05, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 54.02, ["Mega"] = 59.72, ["Mega|Ride"] = 111.3, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.7, ["Ride"] = 52.5, ["Fly|Ride"] = 182.28, ["Neon"] = 55.42, ["Neon|Ride"] = 78.77, ["Mega"] = 393.75, ["Mega|Ride"] = 448.35, ["Mega|Fly|Ride"] = 698.71}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.01, ["Fly"] = 131.25, ["Ride"] = 104.77, ["Fly|Ride"] = 170.63, ["Neon"] = 262.5, ["Neon|Ride"] = 313.62, ["Mega"] = 893.68, ["Mega|Ride"] = 768.39, ["Mega|Fly|Ride"] = 922.88}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 178.55, ["Ride"] = 183.75, ["Fly|Ride"] = 282.96, ["Neon"] = 732.22, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 3338.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 18.37, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 279.7, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 698.71}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 34.13, ["Ride"] = 418.97, ["Fly|Ride"] = 626.68, ["Neon"] = 167.63, ["Neon|Ride"] = 321.6, ["Neon|Fly|Ride"] = 838.03, ["Mega"] = 656.25, ["Mega|Ride"] = 838.03, ["Mega|Fly|Ride"] = 942.78}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1286.38, ["Fly"] = 1441.13, ["Ride"] = 1239.13, ["Fly|Ride"] = 1164.19, ["Neon|Ride"] = 5587.44, ["Neon|Fly|Ride"] = 4415.25, ["Mega|Fly|Ride"] = 16481.55}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.57, ["Fly"] = 28.3, ["Ride"] = 22.08, ["Fly|Ride"] = 53.44, ["Neon"] = 79.01, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 222.09, ["Mega|Ride"] = 228.37, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.34, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Neon"] = 37.73, ["Neon|Ride"] = 140.38, ["Mega"] = 346.5, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 11.68, ["Ride"] = 77.53, ["Fly|Ride"] = 524.99, ["Neon"] = 70.21, ["Mega"] = 525, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 627.47}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 21, ["Fly"] = 698.71, ["Ride"] = 78.59, ["Fly|Ride"] = 73.5, ["Neon"] = 87.94, ["Neon|Ride"] = 98.97, ["Neon|Fly|Ride"] = 211.62, ["Mega"] = 429.85, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 22.31, ["Fly|Ride"] = 262.5, ["Neon"] = 22.25, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.84, ["Fly"] = 413.79, ["Neon"] = 16.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 53.52, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 94.33, ["Mega|Ride"] = 134.97, ["Mega|Fly|Ride"] = 355.13}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 269.07, ["Ride"] = 328.12, ["Fly|Ride"] = 321.6, ["Neon|Ride"] = 1521, ["Neon|Fly|Ride"] = 1465.48, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4873.03}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 59.06, ["Neon"] = 10.36, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 99.65, ["Mega|Ride"] = 111.48, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 7.08, ["Ride"] = 66.95, ["Fly|Ride"] = 119.43, ["Neon"] = 131.24, ["Neon|Ride"] = 188.27, ["Mega"] = 276.56, ["Mega|Ride"] = 279.7}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 12.71, ["Fly"] = 60.26, ["Ride"] = 40.09, ["Neon"] = 26.24, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 140.38, ["Mega|Ride"] = 195.9, ["Mega|Fly|Ride"] = 330.37}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 208.68, ["Fly"] = 354.9, ["Ride"] = 262.5, ["Fly|Ride"] = 485.63, ["Neon"] = 774.37, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 1047.53, ["Mega"] = 3031.51, ["Mega|Ride"] = 3142.55, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.64, ["Fly"] = 47.55, ["Ride"] = 34.2, ["Fly|Ride"] = 158.82, ["Neon"] = 145.62, ["Neon|Ride"] = 161.33, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 670.43, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 715.32}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 115.75, ["Ride"] = 44.73, ["Fly|Ride"] = 78.75, ["Neon"] = 97.94, ["Neon|Ride"] = 203.23, ["Neon|Fly|Ride"] = 217.9, ["Mega"] = 489.14, ["Mega|Ride"] = 483.05, ["Mega|Fly|Ride"] = 733.27}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 35.54, ["Mega"] = 22.31, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 73.47, ["Fly"] = 105, ["Ride"] = 126, ["Fly|Ride"] = 170.63, ["Neon"] = 347.82, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1117.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.82, ["Neon"] = 5.25, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 588, ["Mega"] = 39.59, ["Mega|Ride"] = 209.52}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.31, ["Fly"] = 126.17, ["Ride"] = 25.15, ["Fly|Ride"] = 72.02, ["Neon"] = 63.74, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 389.82, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.63, ["Fly"] = 110.06, ["Ride"] = 93.03, ["Fly|Ride"] = 175.88, ["Neon"] = 195.3, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 346.98, ["Mega|Ride"] = 1214.08, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 20.75, ["Ride"] = 16.78, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 45.99, ["Mega"] = 24.11, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 37.7, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 33.48, ["Fly|Ride"] = 1346.59, ["Neon"] = 14.14, ["Neon|Ride"] = 78.59, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 270.8, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.4, ["Fly"] = 42.46, ["Ride"] = 56.44, ["Neon"] = 125.72, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 629.58, ["Mega"] = 586.69, ["Mega|Ride"] = 735.89, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 136.19, ["Mega"] = 20.96, ["Mega|Ride"] = 98.38}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 7.3, ["Ride"] = 55.5, ["Fly|Ride"] = 111.57, ["Neon"] = 78.67, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 313.22, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 553.1}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 22.32, ["Fly"] = 28.22, ["Ride"] = 28.87, ["Fly|Ride"] = 82.78, ["Neon"] = 159.25, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1214.08}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Fly|Ride"] = 76.01, ["Neon"] = 24.17, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.31, ["Mega"] = 147.24, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 317.41}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 23, ["Fly"] = 2095.04, ["Ride"] = 86.97, ["Neon"] = 129.91, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6287.48, ["Mega|Ride"] = 502.04, ["Mega|Fly|Ride"] = 1044.1}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.57, ["Fly|Ride"] = 196.88, ["Neon"] = 5.9, ["Neon|Fly"] = 56.58, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 65.35, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.72, ["Mega|Fly|Ride"] = 519.59}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 3.83, ["Mega"] = 27.42, ["Mega|Fly|Ride"] = 237.57}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 41.36}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 72.19, ["Fly"] = 102.38, ["Ride"] = 79.01, ["Fly|Ride"] = 90.04, ["Neon"] = 1050, ["Neon|Ride"] = 200.46, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 1117.71, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Neon"] = 3.15, ["Mega"] = 18.38, ["Mega|Fly"] = 137.81, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Fly"] = 796.13, ["Ride"] = 549.18, ["Fly|Ride"] = 518.44, ["Neon"] = 2035.34, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16760.2, ["Mega|Ride"] = 15699.07, ["Mega|Fly|Ride"] = 15503.17}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 25.81, ["Ride"] = 46.62, ["Fly|Ride"] = 82.78, ["Neon"] = 12.85, ["Neon|Fly"] = 698.71, ["Neon|Ride"] = 278.65, ["Mega"] = 106.32, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 559.38}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 130.04, ["Ride"] = 23.15, ["Fly|Ride"] = 57.75, ["Neon"] = 17.53, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 279.7, ["Mega|Ride"] = 217.9, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.87, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 64.96, ["Neon|Ride"] = 181.58, ["Mega"] = 510.16, ["Mega|Ride"] = 469.3, ["Mega|Fly|Ride"] = 471.6}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.73, ["Fly"] = 131.25, ["Ride"] = 31.5, ["Fly|Ride"] = 140.38, ["Neon"] = 36.68, ["Mega"] = 223.13}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.19, ["Ride"] = 39.38, ["Fly|Ride"] = 136.77, ["Neon"] = 78.66, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 349.86, ["Mega|Ride"] = 523.04, ["Mega|Fly|Ride"] = 740.6}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.14, ["Fly"] = 70.2, ["Ride"] = 31.5, ["Neon"] = 52.5, ["Neon|Ride"] = 97.99, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 189, ["Mega|Fly"] = 483.96, ["Mega|Ride"] = 347.82}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 55.9, ["Neon"] = 1.84, ["Neon|Ride"] = 16.78, ["Neon|Fly|Ride"] = 75.34, ["Mega"] = 22.28, ["Mega|Fly"] = 60.78, ["Mega|Ride"] = 31.48, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.69, ["Ride"] = 27.56, ["Fly|Ride"] = 158, ["Neon"] = 28.03, ["Neon|Fly"] = 117.91, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 314.27, ["Mega"] = 189, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 242.82, ["Ride"] = 335.3, ["Fly|Ride"] = 389.08, ["Neon"] = 1480.5, ["Neon|Ride"] = 1148.33, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 3802.49}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 82.67, ["Ride"] = 131.25, ["Fly|Ride"] = 7681.42, ["Neon"] = 601.29, ["Neon|Ride"] = 559.38, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4190.06, ["Mega|Ride"] = 1717.93, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 17.7, ["Fly|Ride"] = 39.37, ["Neon"] = 23.05, ["Neon|Fly"] = 48.2, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 98.48, ["Mega|Fly"] = 208.47, ["Mega|Ride"] = 98.48, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 13.54, ["Fly|Ride"] = 39.81, ["Neon"] = 6.23, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 56.43, ["Mega"] = 85.32, ["Mega|Fly"] = 349.89, ["Mega|Ride"] = 116.29, ["Mega|Fly|Ride"] = 183.28}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 22.19, ["Fly|Ride"] = 98.44, ["Neon"] = 28.3, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 140.38, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231.86, ["Ride"] = 237.57, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1239.21, ["Mega|Ride"] = 8380.11, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.38, ["Fly|Ride"] = 45.63, ["Neon"] = 33.54, ["Neon|Fly"] = 158, ["Neon|Ride"] = 40.87, ["Neon|Fly|Ride"] = 141.52, ["Mega"] = 300.65, ["Mega|Ride"] = 262.95, ["Mega|Fly|Ride"] = 278.91}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.56, ["Fly"] = 158, ["Ride"] = 96.48, ["Fly|Ride"] = 209.52, ["Neon"] = 22.31, ["Neon|Ride"] = 41.92, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 30.34, ["Mega"] = 47.16, ["Mega|Ride"] = 96.46, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 17.66, ["Ride"] = 20.98, ["Fly|Ride"] = 67.06, ["Neon"] = 70.2, ["Neon|Ride"] = 102.59, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 728.34, ["Mega|Ride"] = 417.98, ["Mega|Fly|Ride"] = 370.83}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 61.34, ["Ride"] = 97.01, ["Fly|Ride"] = 209.99, ["Neon"] = 172.22, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.8, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 479.06, ["Mega|Fly"] = 2199.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 19.69, ["Fly"] = 158, ["Ride"] = 51.33, ["Fly|Ride"] = 81.36, ["Neon"] = 123.43, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 116.29, ["Neon|Fly|Ride"] = 235.86, ["Mega"] = 796.13, ["Mega|Ride"] = 692.91, ["Mega|Fly|Ride"] = 739.55}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.09, ["Fly"] = 17.7, ["Ride"] = 15.73, ["Fly|Ride"] = 41.92, ["Neon"] = 2.1, ["Neon|Fly"] = 19.34, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 61.82, ["Mega"] = 22.42, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 196.88, ["Ride"] = 303.79, ["Fly|Ride"] = 262.5, ["Neon"] = 2646.57, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1186.5, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 18.63, ["Fly"] = 61.61, ["Ride"] = 45.94, ["Neon"] = 103.84, ["Neon|Ride"] = 92.25, ["Neon|Fly|Ride"] = 321.56, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 19.23, ["Ride"] = 18.37, ["Fly|Ride"] = 39.34, ["Neon"] = 2.1, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.05, ["Mega"] = 59.14, ["Mega|Fly"] = 179.15, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 299.46}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 16.89, ["Fly|Ride"] = 55.47, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.58, ["Neon|Fly|Ride"] = 97.97, ["Mega"] = 21, ["Mega|Fly"] = 141.49, ["Mega|Ride"] = 48.69, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.59, ["Fly|Ride"] = 91.16, ["Neon"] = 11.24, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 79.01, ["Mega"] = 93.08, ["Mega|Ride"] = 116.08, ["Mega|Fly|Ride"] = 385.54}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 19.44, ["Fly"] = 38.68, ["Ride"] = 31.5, ["Fly|Ride"] = 52.49, ["Neon"] = 63, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 257.25, ["Mega|Fly"] = 786.39, ["Mega|Ride"] = 284.02, ["Mega|Fly|Ride"] = 333.36}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.25, ["Ride"] = 26.22, ["Fly|Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 262.5, ["Mega|Ride"] = 321.6, ["Mega|Fly|Ride"] = 321.6}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 44.82, ["Neon"] = 3.94, ["Neon|Ride"] = 45.06, ["Mega"] = 31.75, ["Mega|Ride"] = 60.78}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.43, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 19.59, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 70.2, ["Mega"] = 157.5, ["Mega|Fly"] = 279.7, ["Mega|Ride"] = 259.81, ["Mega|Fly|Ride"] = 278.15}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 125.72, ["Neon"] = 5.25, ["Neon|Fly"] = 98.48, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158, ["Mega"] = 33.54, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 25.72, ["Ride"] = 24.69, ["Fly|Ride"] = 83.93, ["Neon"] = 6.01, ["Neon|Ride"] = 30.66, ["Neon|Fly|Ride"] = 61.82, ["Mega"] = 125.9, ["Mega|Ride"] = 84.26, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.96, ["Ride"] = 713.39, ["Fly|Ride"] = 761.19, ["Neon"] = 4172.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 15.54, ["Fly|Ride"] = 49.25, ["Neon"] = 27.64, ["Neon|Fly"] = 50.3, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 55.48, ["Mega"] = 187.52, ["Mega|Fly|Ride"] = 209.52}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 165.08, ["Neon"] = 10.5, ["Neon|Fly"] = 838.03, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 57.74, ["Mega|Ride"] = 103.36, ["Mega|Fly|Ride"] = 155.81}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.19, ["Fly"] = 24.94, ["Ride"] = 23.59, ["Fly|Ride"] = 53.82, ["Neon"] = 38.06, ["Neon|Fly"] = 112.1, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 309.03, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 27.25, ["Ride"] = 16.21, ["Fly|Ride"] = 33.08, ["Neon"] = 5.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 87.94, ["Mega|Fly"] = 349.89, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 167.63}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.5, ["Ride"] = 58.97, ["Fly|Ride"] = 208.47, ["Neon"] = 222.29, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 698.71, ["Mega|Ride"] = 664.13, ["Mega|Fly|Ride"] = 695.57}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.49, ["Neon"] = 7.79, ["Neon|Fly"] = 98.48, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 62.87, ["Mega|Ride"] = 138.29, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.61, ["Fly"] = 73.49, ["Ride"] = 23.49, ["Fly|Ride"] = 59.72, ["Neon"] = 11.81, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 43.54, ["Neon|Fly|Ride"] = 447.57, ["Mega"] = 140.38, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.73, ["Neon|Fly"] = 31.85, ["Neon|Ride"] = 110.83, ["Mega"] = 116.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.74, ["Fly|Ride"] = 83.83, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 39.69, ["Mega|Fly"] = 181.92, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 159.25}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.33, ["Fly"] = 20.96, ["Ride"] = 21.96, ["Fly|Ride"] = 26.25, ["Neon"] = 103.69, ["Neon|Ride"] = 79.68, ["Neon|Fly|Ride"] = 110.83, ["Mega"] = 838.03, ["Mega|Ride"] = 464.06, ["Mega|Fly|Ride"] = 404.41}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 702.19, ["Ride"] = 748.13, ["Fly|Ride"] = 879.38, ["Neon"] = 1938.57, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 2034.38, ["Mega|Ride"] = 6130.67, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.9, ["Ride"] = 17.7, ["Fly|Ride"] = 44.63, ["Neon"] = 2.63, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 74.39, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 261.71}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.06, ["Ride"] = 32.82, ["Fly|Ride"] = 92.21, ["Neon"] = 30.85, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 214.59, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 531.11}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 73.5, ["Ride"] = 85.32, ["Fly|Ride"] = 144.38, ["Neon"] = 417.98, ["Neon|Ride"] = 412.67, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2765.45, ["Mega|Fly|Ride"] = 2323.12}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 39.12, ["Fly"] = 140.38, ["Ride"] = 69.57, ["Fly|Ride"] = 102.79, ["Neon"] = 131.25, ["Neon|Ride"] = 167.63, ["Neon|Fly|Ride"] = 300.65, ["Mega"] = 1942.11, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 938.44}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 19.62, ["Ride"] = 43.3, ["Neon"] = 93.19, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 377.1, ["Mega|Ride"] = 367.69, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 31.85, ["Ride"] = 83.83, ["Neon"] = 72.18, ["Neon|Fly"] = 158, ["Neon|Ride"] = 361.96, ["Mega"] = 311.73, ["Mega|Fly"] = 511.69, ["Mega|Ride"] = 360.78, ["Mega|Fly|Ride"] = 578.17}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.47, ["Ride"] = 52.4, ["Fly|Ride"] = 83.83, ["Neon"] = 116.28, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 314.81, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 628.52}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 22.43}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.19, ["Ride"] = 30.34, ["Fly|Ride"] = 78.75, ["Neon"] = 31.85, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.66, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 349.89}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 36.75, ["Mega"] = 880.71}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 70.87, ["Fly"] = 110.83, ["Ride"] = 84.58, ["Fly|Ride"] = 124.93, ["Neon"] = 393.79, ["Neon|Ride"] = 225.75, ["Neon|Fly|Ride"] = 943.19, ["Mega|Ride"] = 943.69, ["Mega|Fly|Ride"] = 1146.48}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.93, ["Fly"] = 24.94, ["Ride"] = 18.19, ["Fly|Ride"] = 32.81, ["Neon"] = 26.5, ["Neon|Fly"] = 67.98, ["Neon|Ride"] = 30.4, ["Neon|Fly|Ride"] = 81.35, ["Mega"] = 262.5, ["Mega|Fly"] = 417.98, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.24, ["Fly"] = 83.83, ["Ride"] = 24.86, ["Fly|Ride"] = 77.44, ["Neon"] = 27.57, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 201.14, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.95, ["Neon|Ride"] = 92.21, ["Mega"] = 65.63, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 41.92, ["Fly"] = 65.63, ["Ride"] = 48.56, ["Fly|Ride"] = 99.74, ["Neon"] = 205.83, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1117.71, ["Mega|Ride"] = 13967.52, ["Mega|Fly|Ride"] = 1187.89}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 24.52, ["Neon"] = 12.98, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.92, ["Mega"] = 91.97, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.45, ["Ride"] = 73.5, ["Neon"] = 70.2, ["Neon|Ride"] = 138.15, ["Neon|Fly|Ride"] = 257.99, ["Mega"] = 288.75, ["Mega|Ride"] = 541.91, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 16.2, ["Fly|Ride"] = 32.82, ["Neon"] = 23.63, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 107.21, ["Mega"] = 144.37, ["Mega|Ride"] = 257.92, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 20.9, ["Fly|Ride"] = 36.64, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 278.65, ["Mega|Ride"] = 279.7, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.61, ["Ride"] = 36.53, ["Neon"] = 26.25, ["Neon|Ride"] = 110.83, ["Mega"] = 138.33, ["Mega|Ride"] = 836.73}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Ride"] = 105, ["Fly|Ride"] = 168, ["Neon"] = 167.43, ["Neon|Ride"] = 314.27, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 894.7, ["Mega|Ride"] = 1397.4, ["Mega|Fly|Ride"] = 1242.65}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.79, ["Ride"] = 140.38, ["Neon"] = 131.25, ["Mega"] = 391.13, ["Mega|Fly|Ride"] = 496.79}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 19.68, ["Ride"] = 104.89, ["Fly|Ride"] = 279.7, ["Neon"] = 167.62, ["Mega|Ride"] = 557.29, ["Mega|Fly|Ride"] = 279.7}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 105, ["Ride"] = 53.75, ["Fly|Ride"] = 529.37, ["Neon"] = 94.5, ["Neon|Ride"] = 111.38, ["Neon|Fly|Ride"] = 452.54, ["Mega"] = 629.58, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1044.39}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 63, ["Mega"] = 111.57, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.43, ["Fly|Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 91.32, ["Mega"] = 60.38, ["Mega|Ride"] = 83.37, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 13.02, ["Ride"] = 48.76, ["Neon"] = 65.63, ["Neon|Ride"] = 115.24, ["Neon|Fly|Ride"] = 121.21, ["Mega"] = 279.7, ["Mega|Ride"] = 471.6, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.68, ["Ride"] = 17.9, ["Fly|Ride"] = 55.95, ["Neon"] = 7.88, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 67.94, ["Mega"] = 54.25, ["Mega|Ride"] = 81.18, ["Mega|Fly|Ride"] = 196.35}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 47.14, ["Fly|Ride"] = 110.35, ["Neon"] = 39.38, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 112.1, ["Mega"] = 232.56, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 471.6}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.1, ["Ride"] = 32.49, ["Fly|Ride"] = 99.75, ["Neon"] = 314.81, ["Neon|Fly"] = 471.6, ["Neon|Ride"] = 96.39, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 1047.53}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 33.54, ["Fly|Ride"] = 40.69, ["Neon"] = 31.85, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 38.71, ["Neon|Fly|Ride"] = 108.96, ["Mega"] = 231.97, ["Mega|Ride"] = 249.48, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 20.97, ["Fly|Ride"] = 62.87, ["Neon"] = 21.24, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 104.77, ["Mega"] = 154.98, ["Mega|Ride"] = 208.47, ["Mega|Fly|Ride"] = 285.33}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.52, ["Fly"] = 301.88, ["Ride"] = 47.25, ["Fly|Ride"] = 179.82, ["Neon"] = 21.41, ["Neon|Fly"] = 122.94, ["Neon|Ride"] = 62.87, ["Mega"] = 132.08, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 410.81}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.73, ["Fly"] = 140.43, ["Ride"] = 104.97, ["Fly|Ride"] = 272.37, ["Neon"] = 85.32, ["Neon|Ride"] = 161.33, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 392.44, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 446.64, ["Mega|Fly|Ride"] = 583.58}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 77.04, ["Ride"] = 74.81, ["Fly|Ride"] = 131.25, ["Neon"] = 291.8, ["Neon|Ride"] = 263.81, ["Neon|Fly|Ride"] = 359.31, ["Mega"] = 1535.67, ["Mega|Ride"] = 982, ["Mega|Fly|Ride"] = 1054.9}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.91, ["Ride"] = 21.72, ["Fly|Ride"] = 65.54, ["Neon"] = 2.1, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 60.77, ["Mega"] = 28.09, ["Mega|Ride"] = 59.75, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 18.15, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 862.98, ["Mega|Ride"] = 589.5, ["Mega|Fly|Ride"] = 1252.84}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 49.87, ["Ride"] = 94.33, ["Neon"] = 276.73, ["Neon|Ride"] = 299.46, ["Mega"] = 1696.98, ["Mega|Ride"] = 1106.19, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.54, ["Fly"] = 190.32, ["Ride"] = 44.62, ["Fly|Ride"] = 125.99, ["Neon"] = 56.57, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 209.56, ["Mega"] = 232.56, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 73.62, ["Fly|Ride"] = 136.71, ["Neon"] = 5.84, ["Neon|Ride"] = 31.44, ["Mega"] = 32.51, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 61.6, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 17.06, ["Fly|Ride"] = 58.68, ["Neon"] = 15.67, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 81.8, ["Mega"] = 182.28, ["Mega|Fly"] = 349.89, ["Mega|Ride"] = 231.51, ["Mega|Fly|Ride"] = 220.87}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 18.87, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 49, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.92, ["Ride"] = 16.82, ["Fly|Ride"] = 93.18, ["Neon"] = 3.91, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 83.83, ["Mega"] = 44.6, ["Mega|Fly"] = 168, ["Mega|Ride"] = 112.1, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Fly|Ride"] = 158, ["Neon"] = 2.1, ["Neon|Ride"] = 123.24, ["Mega"] = 19.69, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.71, ["Ride"] = 31.42, ["Fly|Ride"] = 262.5, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 207.42, ["Mega"] = 188.65, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.5, ["Ride"] = 32.49, ["Fly|Ride"] = 83.83, ["Neon"] = 52.19, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 234.63, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.87, ["Fly"] = 28.09, ["Ride"] = 20.88, ["Fly|Ride"] = 48.2, ["Neon"] = 41.37, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 86.41, ["Mega"] = 393.75, ["Mega|Ride"] = 314.27, ["Mega|Fly|Ride"] = 293.76}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.63, ["Ride"] = 167.63, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1780.78}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.25, ["Fly"] = 71.72, ["Ride"] = 65.63, ["Fly|Ride"] = 79.01, ["Neon"] = 91.16, ["Mega"] = 628.04, ["Mega|Ride"] = 559.38, ["Mega|Fly|Ride"] = 1181.93}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 18.78, ["Fly|Ride"] = 37.66, ["Neon"] = 3.94, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 58.22, ["Mega"] = 36.69, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 18.8, ["Fly|Ride"] = 32.97, ["Neon"] = 4.19, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 41.91, ["Mega"] = 59.72, ["Mega|Ride"] = 66.01, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 383.28, ["Ride"] = 438.37, ["Fly|Ride"] = 431.81, ["Neon|Ride"] = 1780.78, ["Neon|Fly|Ride"] = 1509.37}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 17.55, ["Ride"] = 140.38, ["Fly|Ride"] = 241.78, ["Neon"] = 140.31, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 559.38, ["Mega|Fly|Ride"] = 1676.04}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 18.38, ["Fly|Ride"] = 32.48, ["Neon"] = 3.94, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 43.01, ["Mega"] = 29.31, ["Mega|Ride"] = 56.58, ["Mega|Fly|Ride"] = 89.78}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 67.96, ["Ride"] = 191.63, ["Fly|Ride"] = 223.12, ["Neon"] = 261.18, ["Neon|Ride"] = 292.48, ["Neon|Fly|Ride"] = 1117.71, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 934.49}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 15.85, ["Ride"] = 16.82, ["Fly|Ride"] = 55.13, ["Neon"] = 10.5, ["Neon|Fly"] = 41.39, ["Neon|Ride"] = 25.96, ["Neon|Fly|Ride"] = 54.58, ["Mega"] = 65.63, ["Mega|Fly"] = 133.05, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 36.68, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 92.21, ["Mega"] = 24.53, ["Mega|Fly"] = 195.9, ["Mega|Ride"] = 64.57, ["Mega|Fly|Ride"] = 207.27}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 76.67, ["Fly"] = 126.52, ["Ride"] = 131.25, ["Fly|Ride"] = 124.69, ["Neon"] = 245.19, ["Neon|Ride"] = 320.55, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 656.25, ["Mega|Ride"] = 599.82, ["Mega|Fly|Ride"] = 836.98}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 20.97, ["Fly|Ride"] = 52.5, ["Neon"] = 5.15, ["Neon|Ride"] = 41.28, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 118.13, ["Mega|Ride"] = 129.74, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.82, ["Ride"] = 77.05, ["Neon"] = 152.25, ["Neon|Ride"] = 200.09, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 1654.03, ["Mega|Ride"] = 1676.04, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.25, ["Ride"] = 41.46, ["Fly|Ride"] = 209.52, ["Neon"] = 14.89, ["Neon|Ride"] = 300.46, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 175.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 461.96}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 18.83, ["Fly|Ride"] = 65.63, ["Neon"] = 12.85, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 81.38, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.49, ["Ride"] = 56.58, ["Fly|Ride"] = 118.01, ["Neon"] = 146.44, ["Neon|Ride"] = 262.5, ["Mega|Ride"] = 2598.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 38.77, ["Fly|Ride"] = 908.98, ["Neon"] = 5.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 161.33, ["Mega"] = 65.63, ["Mega|Fly"] = 163.48, ["Mega|Ride"] = 121.53, ["Mega|Fly|Ride"] = 259.81}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.58, ["Ride"] = 17.07, ["Fly|Ride"] = 102.86, ["Neon"] = 6.74, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 166.58, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.17, ["Fly"] = 35.6, ["Ride"] = 29.95, ["Fly|Ride"] = 70.2, ["Neon"] = 44.54, ["Neon|Ride"] = 120.75, ["Mega"] = 328.13, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 388.49}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 31.5, ["Ride"] = 105.38, ["Fly|Ride"] = 153.51, ["Neon"] = 267.14, ["Neon|Ride"] = 188.65, ["Neon|Fly|Ride"] = 448.35, ["Mega"] = 895.63, ["Mega|Ride"] = 852.69, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 39.38, ["Fly"] = 50.15, ["Ride"] = 35.33, ["Fly|Ride"] = 73.49, ["Neon"] = 103.77, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 157.14, ["Mega"] = 620.57, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 346.75}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 54.57, ["Ride"] = 102.59, ["Fly|Ride"] = 196.84, ["Neon"] = 336, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1023.75, ["Mega|Ride"] = 1042.19, ["Mega|Fly|Ride"] = 1312.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.25, ["Ride"] = 35.44, ["Neon"] = 17.7, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 198.8, ["Mega|Ride"] = 303.79, ["Mega|Fly|Ride"] = 328.93}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.4, ["Ride"] = 26.16, ["Fly|Ride"] = 78.74, ["Neon"] = 18.38, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 203.43, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.11, ["Fly"] = 65.62, ["Ride"] = 44.01, ["Fly|Ride"] = 157.5, ["Neon"] = 49.06, ["Neon|Ride"] = 137.81, ["Neon|Fly|Ride"] = 301.84, ["Mega"] = 400.32, ["Mega|Ride"] = 349.89, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 14.03, ["Fly|Ride"] = 33.54, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.14, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 18.38, ["Mega|Fly"] = 70.2, ["Mega|Ride"] = 23.55, ["Mega|Fly|Ride"] = 83.73}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 62.36, ["Fly"] = 91.88, ["Ride"] = 91.74, ["Fly|Ride"] = 272.37, ["Neon"] = 215.8, ["Neon|Fly"] = 2256.27, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 471.6, ["Mega"] = 941.73, ["Mega|Ride"] = 1059.34, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 94.29, ["Fly|Ride"] = 108.96, ["Neon"] = 6.44, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 41.92, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 16, ["Fly|Ride"] = 53.44, ["Neon"] = 24.93, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 50.84, ["Mega"] = 110.07, ["Mega|Ride"] = 212.23, ["Mega|Fly|Ride"] = 419.03}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 77.44, ["Ride"] = 156.18, ["Fly|Ride"] = 235.81, ["Neon"] = 328.02, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 1022.44, ["Mega|Ride"] = 1351.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Neon"] = 6.08, ["Neon|Ride"] = 94.13, ["Mega"] = 65.62, ["Mega|Ride"] = 158, ["Mega|Fly|Ride"] = 786.39}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 19.25}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 141.43, ["Fly|Ride"] = 297.51, ["Neon"] = 5.25, ["Neon|Ride"] = 68.46, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 45.48, ["Mega|Ride"] = 118.7, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 144.38, ["Ride"] = 171.83, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 733.27, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3615.93, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.25, ["Ride"] = 25.6, ["Neon"] = 27.64, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 134.1, ["Mega"] = 139.21, ["Mega|Ride"] = 157.14, ["Mega|Fly|Ride"] = 464.06}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 124.39, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.88, ["Ride"] = 19.81, ["Neon"] = 51.1, ["Neon|Ride"] = 140.38, ["Mega|Ride"] = 628.52, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 16.09, ["Fly"] = 28.88, ["Ride"] = 26.62, ["Fly|Ride"] = 140.35, ["Neon"] = 74.74, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 146.22, ["Mega"] = 250.04, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 342.56}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 78.75, ["Fly|Ride"] = 174.5, ["Neon"] = 212.7, ["Neon|Ride"] = 252.32, ["Neon|Fly|Ride"] = 572.01, ["Mega"] = 853.13, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.25, ["Fly"] = 249.33, ["Ride"] = 177.19, ["Fly|Ride"] = 221.82, ["Neon"] = 511.77, ["Neon|Fly"] = 627.47, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2152.5}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 14.44, ["Fly"] = 23.62, ["Ride"] = 24.53, ["Fly|Ride"] = 52.5, ["Neon"] = 70.2, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 104.99, ["Mega|Ride"] = 628.52, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.07, ["Fly"] = 131.23, ["Ride"] = 30.66, ["Fly|Ride"] = 83.83, ["Neon"] = 14.04, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 95.82, ["Mega|Fly|Ride"] = 282.96}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.88, ["Fly"] = 98.48, ["Ride"] = 77.83, ["Neon"] = 110.13, ["Mega"] = 1263.31, ["Mega|Ride"] = 434.74, ["Mega|Fly|Ride"] = 622.51}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.96, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 207.42, ["Neon|Ride"] = 209.49, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 851.82, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 898.59}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.73, ["Ride"] = 81.86, ["Fly|Ride"] = 279.7, ["Neon"] = 91.88, ["Neon|Ride"] = 140.38, ["Mega"] = 577.5, ["Mega|Ride"] = 748.99, ["Mega|Fly|Ride"] = 822.29}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 360.94, ["Neon"] = 978.38, ["Neon|Ride"] = 1089.43, ["Neon|Fly|Ride"] = 1047.53, ["Mega"] = 4671.92, ["Mega|Fly|Ride"] = 4671.92}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 40.69, ["Ride"] = 42, ["Fly|Ride"] = 107.3, ["Neon"] = 178.5, ["Neon|Ride"] = 235.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 992, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 967.99}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.15, ["Ride"] = 15.63, ["Fly|Ride"] = 67.69, ["Neon"] = 2.1, ["Neon|Ride"] = 19.36, ["Neon|Fly|Ride"] = 42.47, ["Mega"] = 28.2, ["Mega|Fly"] = 70.2, ["Mega|Ride"] = 41.58, ["Mega|Fly|Ride"] = 123.68}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 209.52, ["Neon"] = 14.16, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 158.19, ["Mega|Ride"] = 136.77, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Fly|Ride"] = 144.16, ["Neon"] = 14.14, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 166.58, ["Mega"] = 105, ["Mega|Fly"] = 544.72, ["Mega|Ride"] = 155.05, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 372.65, ["Fly"] = 629.58, ["Ride"] = 367.5, ["Fly|Ride"] = 431.82, ["Neon"] = 2095.04, ["Neon|Ride"] = 1603.42, ["Neon|Fly|Ride"] = 1512.15, ["Mega|Ride"] = 6148.9, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 17.06, ["Fly|Ride"] = 52.49, ["Neon"] = 24.94, ["Neon|Ride"] = 42.46, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 105, ["Mega|Ride"] = 270.89}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.85, ["Fly"] = 22.31, ["Ride"] = 23.04, ["Fly|Ride"] = 39.38, ["Neon"] = 24.94, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 698.71, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.56, ["Fly"] = 42.26, ["Ride"] = 28.3, ["Fly|Ride"] = 65.63, ["Neon"] = 16.78, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 85.75, ["Mega"] = 111.08, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1886.36}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 56.58, ["Fly"] = 32.82, ["Fly|Ride"] = 61.69, ["Neon"] = 89.32, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega"] = 940.68, ["Mega|Ride"] = 836.98, ["Mega|Fly|Ride"] = 643.12}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 38.66, ["Fly|Ride"] = 61.82, ["Neon"] = 6.97, ["Neon|Ride"] = 35.63, ["Mega"] = 125.72, ["Mega|Ride"] = 349.89, ["Mega|Fly|Ride"] = 1313.18}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.92, ["Fly"] = 104.2, ["Ride"] = 32.82, ["Fly|Ride"] = 70, ["Neon"] = 81.13, ["Neon|Ride"] = 140.01, ["Mega|Fly|Ride"] = 732.22}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Fly|Ride"] = 40.92, ["Neon"] = 3.94, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.75, ["Mega"] = 36.66, ["Mega|Ride"] = 132.96, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 14.42, ["Ride"] = 78.75, ["Neon"] = 71.25, ["Neon|Ride"] = 103.18, ["Mega"] = 471.35, ["Mega|Fly|Ride"] = 838.03}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.71, ["Ride"] = 23.59, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 176.01, ["Mega"] = 307.44, ["Mega|Ride"] = 556.24, ["Mega|Fly|Ride"] = 461.96}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.53, ["Fly"] = 26.18, ["Ride"] = 23.63, ["Fly|Ride"] = 56.58, ["Neon"] = 36.57, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 50.73, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 341.01, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 363.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 181.13, ["Fly"] = 216.56, ["Ride"] = 231.51, ["Fly|Ride"] = 308.43, ["Neon"] = 698.06, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 957.44, ["Mega|Fly|Ride"] = 4189.01}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 17.62, ["Fly|Ride"] = 56.77, ["Neon"] = 13.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 220.5, ["Mega|Ride"] = 166.58, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 39.82, ["Ride"] = 25.95, ["Fly|Ride"] = 103.85, ["Neon"] = 25.86, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 158, ["Mega"] = 277.23, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 47.37, ["Ride"] = 85.32, ["Fly|Ride"] = 400.16, ["Neon"] = 152.81, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 697.66, ["Mega|Fly|Ride"] = 652.13}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 105, ["Fly"] = 262.5, ["Ride"] = 131.25, ["Fly|Ride"] = 131.25, ["Neon"] = 580.12, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1036.96, ["Mega"] = 2095.04, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1876.88}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.04, ["Ride"] = 90.96, ["Fly|Ride"] = 312.17, ["Neon"] = 97.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 228.74, ["Mega"] = 288.75, ["Mega|Ride"] = 375.37, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.13, ["Fly|Ride"] = 46.59, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 51.02, ["Mega|Ride"] = 190.66, ["Mega|Fly|Ride"] = 104.77}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.5, ["Neon"] = 77.53, ["Neon|Ride"] = 207.42, ["Mega"] = 193.71, ["Mega|Ride"] = 419.03, ["Mega|Fly|Ride"] = 683}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 80.07, ["Fly"] = 118.8, ["Ride"] = 120.49, ["Fly|Ride"] = 214.39, ["Neon"] = 209.55, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 838.03, ["Mega"] = 627.47, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly"] = 98.44, ["Ride"] = 87.94, ["Neon"] = 10.49, ["Neon|Ride"] = 104.77, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 62.87, ["Mega|Fly"] = 161.33, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.73, ["Ride"] = 377.28, ["Neon"] = 78.75, ["Neon|Ride"] = 629.58, ["Mega"] = 387.79, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 928.91, ["Fly"] = 1327.2, ["Ride"] = 958.13, ["Fly|Ride"] = 1060.49, ["Neon"] = 2680.16, ["Neon|Ride"] = 3459.12, ["Neon|Fly|Ride"] = 2606.63, ["Mega|Fly|Ride"] = 14619.27}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 37.67, ["Fly"] = 116.59, ["Ride"] = 124.99, ["Fly|Ride"] = 187.68, ["Neon"] = 183.75, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 279.7, ["Mega"] = 630}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.63, ["Fly"] = 49.19, ["Ride"] = 26.46, ["Fly|Ride"] = 80.89, ["Neon"] = 13.13, ["Neon|Fly"] = 174.96, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 69.62, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 209.52}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 23.03, ["Ride"] = 131.22, ["Neon"] = 110.86, ["Mega|Ride"] = 556.4, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 28.89, ["Fly|Ride"] = 419.03, ["Neon"] = 3.84, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 83.89, ["Mega"] = 21, ["Mega|Ride"] = 278.6, ["Mega|Fly|Ride"] = 557.29}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 93.45, ["Ride"] = 166.58, ["Fly|Ride"] = 255.94, ["Neon"] = 285.87, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 519.59, ["Mega"] = 1100.15, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1253.44}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.33, ["Fly"] = 174.57, ["Ride"] = 37.74, ["Fly|Ride"] = 65.63, ["Neon"] = 38.66, ["Neon|Ride"] = 47.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 414.84, ["Mega|Ride"] = 246.19, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 15.26, ["Neon|Ride"] = 65.62, ["Mega"] = 155.05, ["Mega|Ride"] = 235.81, ["Mega|Fly|Ride"] = 370.83}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 65.59, ["Ride"] = 91.88, ["Fly|Ride"] = 167.63, ["Neon"] = 209.52, ["Neon|Fly"] = 278.65, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 409.13, ["Mega"] = 1048.69, ["Mega|Ride"] = 695.57, ["Mega|Fly|Ride"] = 670.43}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 18.04, ["Ride"] = 68.25, ["Fly|Ride"] = 209.52, ["Neon"] = 105, ["Neon|Ride"] = 129.94, ["Mega"] = 958.13, ["Mega|Fly|Ride"] = 697.66}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 54.56, ["Neon"] = 779.63, ["Neon|Ride"] = 629.58, ["Neon|Fly|Ride"] = 1013.92, ["Mega"] = 1229.79, ["Mega|Ride"] = 2357.96, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.77, ["Ride"] = 86.97, ["Neon"] = 18.38, ["Neon|Ride"] = 112.1, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 115.64, ["Mega|Ride"] = 167.92, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.87, ["Fly"] = 32.15, ["Ride"] = 22.31, ["Fly|Ride"] = 63.68, ["Neon"] = 44.26, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 349.89, ["Mega"] = 399, ["Mega|Ride"] = 391.78, ["Mega|Fly|Ride"] = 559.38}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 132.16, ["Ride"] = 181.94, ["Fly|Ride"] = 248.79, ["Neon"] = 507.94, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1989.41}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 30.96, ["Ride"] = 18.27, ["Fly|Ride"] = 49.25, ["Neon"] = 11.8, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 26.54, ["Neon|Fly|Ride"] = 59.97, ["Mega"] = 124.69, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 565.91}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 3.89, ["Fly"] = 47.17, ["Ride"] = 30.02, ["Fly|Ride"] = 65.63, ["Neon"] = 44.62, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 59.35, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 235.7, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.86, ["Fly|Ride"] = 41.91, ["Neon"] = 2.1, ["Neon|Fly"] = 17.71, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 19.59, ["Mega|Ride"] = 40.87, ["Mega|Fly|Ride"] = 80.07}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Neon"] = 2.1, ["Neon|Ride"] = 39.82, ["Mega"] = 21, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.64}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 27.25, ["Fly|Ride"] = 45.94, ["Neon"] = 19.92, ["Neon|Ride"] = 31.65, ["Mega"] = 91.88, ["Mega|Ride"] = 152.3, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 40.43, ["Ride"] = 84, ["Neon"] = 279.7, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.62}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 19.91, ["Fly|Ride"] = 36.75, ["Neon"] = 14.15, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 102.52, ["Mega|Fly"] = 168.89, ["Mega|Ride"] = 126.17, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 23.55, ["Fly|Ride"] = 69.17, ["Neon"] = 10.5, ["Neon|Fly"] = 36.25, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 70.19, ["Mega"] = 147, ["Mega|Fly"] = 305.89, ["Mega|Ride"] = 131.8, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.83, ["Fly"] = 18.59, ["Ride"] = 18.09, ["Fly|Ride"] = 115.5, ["Neon"] = 9.06, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 28.19, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 103.39, ["Mega|Fly"] = 158, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 16.96, ["Fly"] = 279.7, ["Ride"] = 26.15, ["Neon"] = 52.39, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 207.81, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 367.49, ["Mega|Fly|Ride"] = 363.5}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.46, ["Fly"] = 160.71, ["Ride"] = 66.01, ["Neon"] = 74.07, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 349.89, ["Mega"] = 419.03, ["Mega|Ride"] = 419.03, ["Mega|Fly|Ride"] = 1047.53}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.83, ["Fly"] = 41.92, ["Ride"] = 20.9, ["Fly|Ride"] = 63, ["Neon"] = 27.46, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 105, ["Mega"] = 314.81, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 403.23}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 18.37, ["Fly|Ride"] = 52.5, ["Neon"] = 15.72, ["Neon|Fly"] = 66.28, ["Neon|Ride"] = 20.73, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 131.25, ["Mega|Ride"] = 234.63, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 188.28, ["Fly"] = 393.75, ["Ride"] = 224.18, ["Fly|Ride"] = 365.5, ["Neon"] = 978.38, ["Neon|Ride"] = 950.11, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Ride"] = 3493.46, ["Mega|Fly|Ride"] = 3772.72}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.3, ["Ride"] = 38.72, ["Neon"] = 14.44, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Ride"] = 19.69, ["Fly|Ride"] = 118.12, ["Neon"] = 23.63, ["Neon|Fly"] = 209.52, ["Neon|Ride"] = 34.54, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 185.24, ["Mega|Ride"] = 251.43, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.15, ["Ride"] = 24.94, ["Neon"] = 42, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 628.52, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.78, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 20.88, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.72, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.37, ["Ride"] = 28.3, ["Fly|Ride"] = 56.1, ["Neon"] = 24.82, ["Neon|Ride"] = 31.04, ["Neon|Fly|Ride"] = 67.06, ["Mega"] = 154.88, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 56.58, ["Neon"] = 15.49, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 58.92, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 279.7}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.13, ["Fly"] = 105, ["Ride"] = 95.82, ["Fly|Ride"] = 144.38, ["Neon"] = 519.94, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 429.9, ["Mega|Ride"] = 3493.46, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 85.32, ["Ride"] = 33.54, ["Fly|Ride"] = 65.62, ["Neon"] = 26.25, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 112.1, ["Mega"] = 199.5, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 471.6}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.44, ["Ride"] = 44.59, ["Fly|Ride"] = 118.13, ["Neon"] = 11.8, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 47.17, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 102.67, ["Mega|Fly|Ride"] = 209.52}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 60.25, ["Fly"] = 210, ["Ride"] = 114.18, ["Fly|Ride"] = 299.24, ["Neon"] = 157.5, ["Neon|Ride"] = 189.52, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 451.5, ["Mega|Ride"] = 573, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 15.64, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 30.87, ["Mega"] = 24.9, ["Mega|Fly"] = 39.47, ["Mega|Ride"] = 40.09, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 4.16, ["Neon|Ride"] = 60.29, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 32.38, ["Mega|Ride"] = 80.06, ["Mega|Fly|Ride"] = 154.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 137.82, ["Neon"] = 10.78, ["Neon|Fly|Ride"] = 188.57, ["Mega"] = 104.67}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.16, ["Fly"] = 98.44, ["Ride"] = 55.13, ["Fly|Ride"] = 137.63, ["Neon"] = 42.46, ["Neon|Fly"] = 85.3, ["Neon|Ride"] = 102.59, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 108.72, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 559.52}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.64, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 28.31, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 58.68, ["Mega"] = 24.85, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 134.1}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.38, ["Fly"] = 262.5, ["Ride"] = 44.01, ["Neon"] = 68.76, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 219.85, ["Mega"] = 448.35, ["Mega|Ride"] = 314.27, ["Mega|Fly|Ride"] = 664.13}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2887.5, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2701.13, ["Neon|Ride"] = 9777.49, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43471.73}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 22, ["Ride"] = 17.03, ["Fly|Ride"] = 39.82, ["Neon"] = 7.06, ["Neon|Fly"] = 68.79, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 74.81, ["Mega|Fly"] = 467.2, ["Mega|Ride"] = 105.93, ["Mega|Fly|Ride"] = 174.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.52, ["Neon"] = 11.69, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 628.52}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 31.84, ["Ride"] = 31.5, ["Fly|Ride"] = 121.04, ["Neon"] = 91.77, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 547.86, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 45.91, ["Ride"] = 98.43, ["Neon"] = 140.41, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 540.75, ["Mega|Ride"] = 543.67, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 168.33, ["Fly"] = 1397.4, ["Ride"] = 188.98, ["Fly|Ride"] = 264, ["Neon"] = 838.03, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 698.71, ["Neon|Fly|Ride"] = 817.14, ["Mega"] = 6285.08, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.34, ["Fly"] = 26.25, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 35.6, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 224.18, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 62.87, ["Neon"] = 14.1, ["Neon|Fly"] = 98.48, ["Neon|Fly|Ride"] = 523.78, ["Mega"] = 136.5, ["Mega|Ride"] = 261.91, ["Mega|Fly|Ride"] = 838.27}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.97, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 10.28, ["Neon|Ride"] = 39.38, ["Mega"] = 107.63, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.57, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon"] = 161.33, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 293.32, ["Mega"] = 374.06, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 649.04}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.2, ["Neon"] = 2.1, ["Neon|Ride"] = 24.82, ["Mega"] = 24.94, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Fly"] = 209.52, ["Ride"] = 91.88, ["Fly|Ride"] = 143.06, ["Neon"] = 522.73, ["Neon|Fly"] = 502.83, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 520.06, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1662.41}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.06, ["Neon|Ride"] = 140.38, ["Mega"] = 39.38, ["Mega|Ride"] = 141.1}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.92, ["Fly"] = 220.48, ["Ride"] = 79.43, ["Fly|Ride"] = 182.28, ["Neon"] = 283, ["Neon|Ride"] = 275.52, ["Neon|Fly|Ride"] = 437.06, ["Mega"] = 2625, ["Mega|Ride"] = 1571.28, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.05, ["Fly|Ride"] = 69.7, ["Neon"] = 5.21, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 52.49, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 109.72}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.28, ["Neon"] = 15.74, ["Neon|Ride"] = 113.21, ["Mega"] = 86.08, ["Mega|Ride"] = 188.65, ["Mega|Fly|Ride"] = 314.27}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 7.88, ["Fly|Ride"] = 208.47, ["Neon"] = 52.5, ["Neon|Ride"] = 116.29, ["Mega"] = 225.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 387.18, ["Ride"] = 441, ["Fly|Ride"] = 532.88, ["Neon"] = 1279.69, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1438.5, ["Mega"] = 4330.44, ["Mega|Ride"] = 4440.41, ["Mega|Fly|Ride"] = 4289.24}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.17, ["Fly"] = 56.58, ["Ride"] = 44.07, ["Fly|Ride"] = 75.54, ["Neon"] = 177.19, ["Neon|Fly"] = 314.81, ["Neon|Ride"] = 153.88, ["Neon|Fly|Ride"] = 270.38, ["Mega|Ride"] = 1046.48, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 22.95, ["Ride"] = 15.75, ["Fly|Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 90.11, ["Mega|Ride"] = 83.79, ["Mega|Fly|Ride"] = 629.58}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.1, ["Fly"] = 364.5, ["Ride"] = 39.38, ["Fly|Ride"] = 88.44, ["Neon"] = 49.23, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 216.57, ["Mega|Fly"] = 388.16, ["Mega|Ride"] = 278.65, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 16.7, ["Ride"] = 23.59, ["Fly|Ride"] = 265.13, ["Neon"] = 126, ["Neon|Ride"] = 65.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 471.39}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.15, ["Neon"] = 7.88, ["Mega"] = 62.99, ["Mega|Ride"] = 150.22, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 22.32, ["Fly|Ride"] = 51.9, ["Neon"] = 26.25, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 550.59, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 471.6}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 118.13, ["Ride"] = 131.25, ["Fly|Ride"] = 175.87, ["Neon"] = 559.38, ["Neon|Ride"] = 615.56, ["Neon|Fly|Ride"] = 838.03, ["Mega|Ride"] = 2933.05, ["Mega|Fly|Ride"] = 3070.27}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 35.63, ["Fly"] = 95.82, ["Ride"] = 99.75, ["Fly|Ride"] = 157.97, ["Neon"] = 192.94, ["Neon|Ride"] = 192.13, ["Mega"] = 836.98, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 755.24}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2467.5, ["Fly"] = 2349.37, ["Ride"] = 2152.5, ["Fly|Ride"] = 2336.25, ["Neon"] = 12570.14, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.92, ["Fly|Ride"] = 170.63, ["Neon"] = 13, ["Neon|Ride"] = 109.48, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 125.97, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 278.65}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 45.93, ["Ride"] = 89.25, ["Fly|Ride"] = 118.13, ["Neon"] = 815.06, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 249.38, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 559.38}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 984.38, ["Fly"] = 1397.4, ["Ride"] = 951.57, ["Fly|Ride"] = 994.88, ["Neon"] = 2445.65, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2408.43, ["Mega|Fly|Ride"] = 12046.39}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 43.29, ["Ride"] = 61.81, ["Fly|Ride"] = 210, ["Neon"] = 237.59, ["Neon|Ride"] = 279.72, ["Mega"] = 839.9, ["Mega|Ride"] = 616.87, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.91, ["Neon"] = 12.99, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 140.38, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.2, ["Ride"] = 19.92, ["Neon"] = 6.96, ["Neon|Ride"] = 22.91, ["Mega"] = 29.3, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.68, ["Ride"] = 126, ["Fly|Ride"] = 314.81, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 471.6, ["Mega"] = 2235.4, ["Mega|Fly|Ride"] = 2672.75}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.3, ["Neon"] = 32.17, ["Neon|Ride"] = 81.73}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.13, ["Ride"] = 97.62, ["Neon"] = 614.25, ["Neon|Ride"] = 315.28, ["Mega|Fly|Ride"] = 1673.94}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 10.39, ["Fly"] = 104.98, ["Neon"] = 33.15, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.19, ["Mega|Fly|Ride"] = 279.7}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 245.58, ["Ride"] = 262.5, ["Fly|Ride"] = 341.73, ["Neon"] = 978.38, ["Neon|Ride"] = 978.38, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4118.83}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 86.84, ["Ride"] = 28.88, ["Fly|Ride"] = 102.72, ["Neon"] = 27.57, ["Neon|Ride"] = 90.11, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 313.04, ["Mega|Ride"] = 261.9, ["Mega|Fly|Ride"] = 309.03}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 19.58, ["Fly|Ride"] = 37.73, ["Neon"] = 2.63, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 41.94, ["Mega"] = 62.45, ["Mega|Fly"] = 119.83, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 156.7}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 839.88, ["Fly"] = 1178.99, ["Ride"] = 903, ["Neon|Ride"] = 7682.47, ["Neon|Fly|Ride"] = 4743.38, ["Mega|Fly|Ride"] = 27933.98}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 3.94, ["Fly"] = 978.38, ["Ride"] = 210, ["Neon"] = 38.48, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 70.2, ["Mega"] = 179.54, ["Mega|Ride"] = 267.64, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.96, ["Fly"] = 70.2, ["Ride"] = 49.25, ["Fly|Ride"] = 91.88, ["Neon"] = 37.75, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 157.14, ["Mega"] = 187.69, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.32, ["Fly"] = 40.52, ["Ride"] = 34.82, ["Fly|Ride"] = 66.94, ["Neon"] = 233.61, ["Neon|Ride"] = 125.05, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2095.04, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 26.24, ["Fly"] = 72.19, ["Ride"] = 28.42, ["Fly|Ride"] = 65.63, ["Neon"] = 55.55, ["Neon|Ride"] = 98.48, ["Neon|Fly|Ride"] = 209.49, ["Mega"] = 288.75, ["Mega|Fly"] = 315, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.12}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.25, ["Ride"] = 262.49, ["Fly|Ride"] = 70.23, ["Neon"] = 85.75, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 456.27, ["Mega"] = 486.06, ["Mega|Ride"] = 518.54, ["Mega|Fly|Ride"] = 656.8}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 235.81, ["Neon"] = 2.1, ["Neon|Ride"] = 28.13, ["Mega"] = 27.25, ["Mega|Fly"] = 84.9, ["Mega|Ride"] = 41.62, ["Mega|Fly|Ride"] = 117.91}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 37.24, ["Fly"] = 74.82, ["Ride"] = 47.17, ["Fly|Ride"] = 103.69, ["Neon"] = 243.28, ["Neon|Fly"] = 276.56, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 250.69, ["Mega"] = 3352.06, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 84.96, ["Ride"] = 28.3, ["Fly|Ride"] = 52.5, ["Neon"] = 42.35, ["Neon|Ride"] = 140.38, ["Mega"] = 773.07, ["Mega|Ride"] = 276.56, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 27.92, ["Ride"] = 20.74, ["Fly|Ride"] = 50.71, ["Neon"] = 26.25, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 7.54, ["Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Ride"] = 838.03, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 293.32, ["Mega|Fly|Ride"] = 471.6}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 19.28, ["Fly"] = 262.38, ["Ride"] = 71.3, ["Fly|Ride"] = 144.38, ["Neon"] = 116.29, ["Neon|Fly"] = 309.03, ["Neon|Ride"] = 186.3, ["Neon|Fly|Ride"] = 233.61, ["Mega"] = 723.39, ["Mega|Ride"] = 763.53, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.15, ["Ride"] = 111.57, ["Neon"] = 24.86, ["Neon|Ride"] = 72.96, ["Neon|Fly|Ride"] = 112.1, ["Mega"] = 86.46, ["Mega|Fly"] = 698.71, ["Mega|Fly|Ride"] = 272.27}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.52, ["Neon|Ride"] = 41.92, ["Mega"] = 20.99, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 204.65}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 70.2, ["Ride"] = 27.24, ["Fly|Ride"] = 81.99, ["Neon"] = 2.1, ["Neon|Fly"] = 393.63, ["Neon|Ride"] = 30.92, ["Mega"] = 23, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.07, ["Fly|Ride"] = 51.35, ["Neon"] = 4.73, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 75.45, ["Mega"] = 92.19, ["Mega|Ride"] = 419.03, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Fly|Ride"] = 5305.39, ["Neon"] = 15.72, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 209.52}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.04, ["Fly|Ride"] = 41.43, ["Neon"] = 14.44, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 281.54, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 93.19, ["Ride"] = 140.38, ["Fly|Ride"] = 419.03, ["Neon"] = 262.94, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1047.53, ["Mega"] = 838.03, ["Mega|Ride"] = 786.39, ["Mega|Fly|Ride"] = 1079.99}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 19.69, ["Fly|Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 48.2, ["Mega"] = 27.57, ["Mega|Ride"] = 70.2, ["Mega|Fly|Ride"] = 102.03}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.19, ["Fly"] = 62.87, ["Ride"] = 35.44, ["Fly|Ride"] = 74.62, ["Neon"] = 43.32, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 838.03, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 16.02, ["Fly"] = 36.75, ["Ride"] = 23.35, ["Fly|Ride"] = 78.73, ["Neon"] = 81.29, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 156.85, ["Mega"] = 1257.03, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 529.6}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.88, ["Fly"] = 140.38, ["Ride"] = 47.17, ["Neon"] = 32.71, ["Neon|Ride"] = 70.2, ["Mega"] = 131.25, ["Mega|Ride"] = 181.92, ["Mega|Fly|Ride"] = 376.07}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 17.7, ["Fly|Ride"] = 39.82, ["Neon"] = 5.25, ["Neon|Fly"] = 40.87, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 45.66, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.81, ["Fly"] = 47.21, ["Ride"] = 26.1, ["Neon"] = 27.13, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.65}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 917.44, ["Fly"] = 1229.79, ["Ride"] = 920.19, ["Fly|Ride"] = 971.25, ["Neon"] = 2296.88, ["Neon|Fly"] = 2848.2, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2152.5, ["Mega|Fly|Ride"] = 6429.94}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 64.63, ["Fly"] = 158, ["Ride"] = 112.63, ["Fly|Ride"] = 196.95, ["Neon"] = 314.99, ["Neon|Ride"] = 347.91, ["Neon|Fly|Ride"] = 470.34, ["Mega"] = 1659.27, ["Mega|Ride"] = 1604.8, ["Mega|Fly|Ride"] = 1326.94}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 7.88, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 65.54, ["Mega|Ride"] = 91.32}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 39.09, ["Fly"] = 83.83, ["Ride"] = 78.75, ["Fly|Ride"] = 170.63, ["Neon"] = 190.32, ["Neon|Ride"] = 216.81, ["Neon|Fly|Ride"] = 321.6, ["Mega"] = 1023.75, ["Mega|Ride"] = 922.69, ["Mega|Fly|Ride"] = 836.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.94, ["Ride"] = 64.61, ["Fly|Ride"] = 65.63, ["Neon"] = 56.02, ["Neon|Ride"] = 279.68, ["Neon|Fly|Ride"] = 278.65, ["Mega"] = 274.32, ["Mega|Ride"] = 314.81, ["Mega|Fly|Ride"] = 473.49}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 216.57, ["Fly"] = 419.03, ["Ride"] = 262.4, ["Fly|Ride"] = 308.91, ["Neon"] = 847.42, ["Neon|Ride"] = 1112.47, ["Neon|Fly|Ride"] = 1178.99, ["Mega|Fly|Ride"] = 4588.12}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 85.36, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 54, ["Mega"] = 381.94, ["Mega|Fly"] = 279.7, ["Mega|Ride"] = 65.62}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Neon|Ride"] = 83.83, ["Mega"] = 335.23, ["Mega|Ride"] = 333.13}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 61.6, ["Ride"] = 102.38, ["Fly|Ride"] = 279.7, ["Neon"] = 341.25, ["Neon|Ride"] = 410.82, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 775.18}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 66.01, ["Neon"] = 13.56, ["Neon|Ride"] = 45.93, ["Mega"] = 279.7, ["Mega|Ride"] = 223.13}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 15.62, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 25.73, ["Mega|Fly"] = 70.2, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4349.63, ["Neon"] = 27933.98, ["Neon|Fly|Ride"] = 27933.98, ["Mega|Fly|Ride"] = 62850.67}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.19, ["Ride"] = 56.43, ["Neon"] = 135.09, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.97, ["Ride"] = 20.97, ["Fly|Ride"] = 60.36, ["Neon"] = 12.88, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 229.53, ["Mega|Ride"] = 118.25, ["Mega|Fly|Ride"] = 210.17}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 446.6, ["Fly"] = 527.63, ["Ride"] = 446.25, ["Fly|Ride"] = 531.57, ["Neon"] = 1365, ["Neon|Ride"] = 1327.2, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 5140.15}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.58, ["Ride"] = 28.3, ["Neon"] = 15.73, ["Neon|Ride"] = 145.68, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 338.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.15, ["Fly"] = 4106.08, ["Ride"] = 46.52, ["Neon"] = 17.07, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 13967.52, ["Mega"] = 415.42, ["Mega|Ride"] = 401.62}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.32, ["Ride"] = 18.88, ["Fly|Ride"] = 82.55, ["Neon"] = 6.01, ["Neon|Fly"] = 124.67, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.83, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 140.38}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 570.94, ["Fly"] = 754.23, ["Ride"] = 590.63, ["Fly|Ride"] = 654.94, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1968.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 63.78, ["Fly|Ride"] = 112.1, ["Neon"] = 28.44, ["Neon|Ride"] = 60, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 118.02, ["Mega|Ride"] = 261.9, ["Mega|Fly|Ride"] = 707.31}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.76, ["Fly"] = 235.85, ["Ride"] = 94.33, ["Fly|Ride"] = 149.63, ["Neon"] = 55.42, ["Neon|Ride"] = 101.4, ["Neon|Fly|Ride"] = 154.21, ["Mega"] = 235.3, ["Mega|Ride"] = 279.7, ["Mega|Fly|Ride"] = 393.79}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 18.4, ["Fly|Ride"] = 47.25, ["Neon"] = 12.46, ["Neon|Fly"] = 46.11, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 89.6, ["Mega"] = 171.34, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 28.88, ["Ride"] = 92.4, ["Neon"] = 98.44, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 314.81, ["Mega"] = 518.54, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 586.63}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 27.57, ["Mega|Ride"] = 84.46, ["Mega|Fly|Ride"] = 250.4}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 382.04, ["Ride"] = 456.88, ["Fly|Ride"] = 586.63, ["Neon"] = 2361.11, ["Neon|Ride"] = 2416.63, ["Neon|Fly|Ride"] = 1793.39, ["Mega"] = 7703.42, ["Mega|Fly|Ride"] = 7860.23}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Fly|Ride"] = 331.04, ["Neon"] = 13.13, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 247.59, ["Mega"] = 67.07, ["Mega|Ride"] = 209.52, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.19, ["Neon|Fly"] = 125.72, ["Neon|Ride"] = 209.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 39.38, ["Mega|Fly"] = 98.48, ["Mega|Ride"] = 98.48, ["Mega|Fly|Ride"] = 209.52}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21.57, ["Neon"] = 4.41, ["Neon|Ride"] = 40.87, ["Neon|Fly|Ride"] = 125.72, ["Mega"] = 41.92, ["Mega|Fly"] = 155.05, ["Mega|Ride"] = 72.19}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.48, ["Ride"] = 131.25, ["Neon"] = 16.78, ["Neon|Ride"] = 47.17, ["Mega"] = 229.42, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 72.19, ["Ride"] = 91.88, ["Fly|Ride"] = 419.03, ["Neon"] = 337.32, ["Neon|Ride"] = 1571.28, ["Neon|Fly|Ride"] = 2357.96, ["Mega"] = 1536.71, ["Mega|Ride"] = 1301.28, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.67, ["Fly"] = 69.47, ["Ride"] = 40.69, ["Fly|Ride"] = 125.72, ["Neon"] = 99.94, ["Neon|Ride"] = 139.36, ["Neon|Fly|Ride"] = 142.14, ["Mega"] = 463.31, ["Mega|Ride"] = 469.3, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 39.82, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 32.62, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 324.85, ["Mega|Ride"] = 237.8, ["Mega|Fly|Ride"] = 190.31}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.43, ["Ride"] = 64.31, ["Fly|Ride"] = 99.53, ["Neon"] = 266.09, ["Neon|Fly|Ride"] = 235.81, ["Mega"] = 331.04, ["Mega|Ride"] = 224.18, ["Mega|Fly|Ride"] = 978.38}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.94, ["Fly"] = 178.5, ["Ride"] = 94.5, ["Fly|Ride"] = 78.59, ["Neon"] = 32.82, ["Neon|Ride"] = 161.33, ["Mega"] = 137.82, ["Mega|Ride"] = 419.03, ["Mega|Fly|Ride"] = 501.78}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.58, ["Fly"] = 69.15, ["Ride"] = 25.16, ["Fly|Ride"] = 56.23, ["Neon"] = 228.74, ["Neon|Ride"] = 209.87, ["Neon|Fly|Ride"] = 244.79, ["Mega"] = 941.73, ["Mega|Ride"] = 943.19, ["Mega|Fly|Ride"] = 765.75}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 153.27, ["Neon|Ride"] = 279.7, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 56.33, ["Fly"] = 115.5, ["Ride"] = 82.69, ["Fly|Ride"] = 131.25, ["Neon"] = 251.87, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 276.93, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1152.27, ["Mega|Ride"] = 1336.86, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.5, ["Fly"] = 83.74, ["Ride"] = 91.88, ["Neon"] = 155.96, ["Neon|Ride"] = 282.96, ["Neon|Fly|Ride"] = 315, ["Mega"] = 532.6, ["Mega|Ride"] = 660.23, ["Mega|Fly|Ride"] = 653.61}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 48.57, ["Ride"] = 489.2, ["Neon"] = 124.01, ["Mega"] = 628.52, ["Mega|Ride"] = 401.92, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.48, ["Fly"] = 31.92, ["Ride"] = 32.34, ["Fly|Ride"] = 98.98, ["Neon"] = 50.4, ["Neon|Fly"] = 167.63, ["Neon|Ride"] = 91.84, ["Neon|Fly|Ride"] = 116.27, ["Mega"] = 237.8, ["Mega|Ride"] = 424.45, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 16.7, ["Fly|Ride"] = 41.92, ["Neon"] = 2.1, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 18.87, ["Neon|Fly|Ride"] = 62.87, ["Mega"] = 65.63, ["Mega|Fly"] = 209.52, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 24.85, ["Ride"] = 62.87, ["Fly|Ride"] = 138.29, ["Neon"] = 140.38, ["Neon|Fly"] = 249.33, ["Neon|Ride"] = 140.4, ["Neon|Fly|Ride"] = 457.77, ["Mega"] = 502.83, ["Mega|Ride"] = 551, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.02, ["Neon"] = 3.94, ["Neon|Ride"] = 40.87, ["Neon|Fly|Ride"] = 293.32, ["Mega"] = 48.47, ["Mega|Ride"] = 114.34}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.72, ["Fly"] = 110.83, ["Ride"] = 57.74, ["Neon"] = 139.11, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 262.85, ["Mega"] = 708.75, ["Mega|Ride"] = 973.85, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 6.46, ["Neon|Ride"] = 105, ["Mega"] = 32.38}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Neon|Ride"] = 47.17, ["Mega"] = 25.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 99.75, ["Fly|Ride"] = 196.88, ["Neon"] = 418.06, ["Neon|Ride"] = 466.2, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6484.37, ["Mega|Fly|Ride"] = 1976.15}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 26.12, ["Ride"] = 20.97, ["Fly|Ride"] = 70.75, ["Neon"] = 10.23, ["Neon|Fly"] = 62.87, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 90.15, ["Mega|Ride"] = 196.95, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 3.9, ["Neon|Fly"] = 62.87, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 38.07, ["Mega|Ride"] = 116.7, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 35.54, ["Mega"] = 22.31, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 30.34, ["Mega"] = 47.16, ["Mega|Ride"] = 96.46, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 43.22, ["Ride"] = 111.57, ["Fly|Ride"] = 1047.53, ["Neon"] = 140.38, ["Neon|Ride"] = 401.44, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1569.19, ["Mega|Ride"] = 1536.71, ["Mega|Fly|Ride"] = 1257.98}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.61, ["Ride"] = 36.53, ["Neon"] = 26.25, ["Neon|Ride"] = 110.83, ["Mega"] = 138.33, ["Mega|Ride"] = 836.73}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.84}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 414.84, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.16, ["Neon|Fly"] = 1195.49, ["Neon|Ride"] = 1411.01, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3682.59}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.84}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 77.44}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.32}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 21}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.56}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.24}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 9.85}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.55}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 238.07}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.84}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.69}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.78}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 217.9}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 1.84}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.93}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 9.03}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.29}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.56}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 13.53}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 394.77}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 656.8}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.49}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1500.19}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 559.38}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.77}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 12.99}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.97}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.75}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.18}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 698.71}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.42}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.69}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.03}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 60.38}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 26.25}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.71}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1771.88}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 45.06}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 299.24}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.25}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.84}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 181.92}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 16.79}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 13.79}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 7833.92}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 13.12}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 19.69}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 17.46}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 5.92}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 147}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.08}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.23}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.59}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 1.84}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 14.44}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.33}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.92}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 102.37}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 136.5}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 14.07}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 32.75}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.28}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 102.34}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.84}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22457.09}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.44}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 30.87}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 59.07}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 41.92}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 86.61}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 62.9}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 99.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 196.88}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 98.48}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 96.88}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.94}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.89}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 80.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 480.82}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.79}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.84}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.57}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.23}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.47}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 45.94}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.84}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.28}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 245.34}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1115.63}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.53}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 704.82}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 41.92}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 43.31}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.58}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.16}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 53.82}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.06}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.46}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.28}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.47}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 8.38}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 26.24}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.61}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.84}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.56}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 7.86}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.17}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 167.61}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.84}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.84}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1005.63}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 72.19}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.23}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 89.25}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 12.56}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 12.81}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 28.58}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 87.89}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 31.29}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.18}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.16}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 1.84}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 41.88}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.4}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.41}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 38.07}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 4.9}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.18}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.71}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 17.07}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.61}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.61}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 26.25}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.31}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.59}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 17.07}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 4.87}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.66}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2605.18}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 57.66}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.72}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.36}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.03}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 279.7}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.69}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.21}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.59}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 7.38}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 9.18}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.22}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.92}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.68}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 195.57}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.19}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 100.49}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.46}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.86}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.62}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 22.23}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 971.25}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 18.71}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.23}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.57}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.14}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 12.74}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 28.28}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 23.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 20.9}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.68}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 13.13}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.58}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.39}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 24.94}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.45}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.87}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.63}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 61.09}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.52}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.71}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.87}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.87}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.06}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 133.88}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 14.6}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.92}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.6}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 13.11}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.64}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.98}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 16.19}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 139.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 110.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1127.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 170.63}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 11.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.71}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 43.21}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.12}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 7.08}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 138.29}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.21}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 63}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 47.17}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.82}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.03}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.13}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 97.12}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 7.07}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 66.67}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.27}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.56}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 89.13}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.46}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 81.85}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 393.32}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 100.38}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 125.9}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.84}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 20.99}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.26}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 40.1}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.8}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.17}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 91.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 14.25}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 9.09}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.22}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 49.87}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.54}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 37.89}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 62.34}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 25.6}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1227.19}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.38}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 195.57}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.69}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 12.65}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.43}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.97}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 194.04}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 81.03}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.91}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 64.97}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 101.07}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.75}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 905.63}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 186.92}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.45}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1665.57}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
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