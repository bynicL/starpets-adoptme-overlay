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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1017.19, ["Ride"] = 1312.5, ["Fly|Ride"] = 2088.13, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25057.34}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 454.68, ["Ride"] = 457.69, ["Fly|Ride"] = 531.44, ["Neon"] = 2088.13, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8976.8}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4829.99, ["Fly|Ride"] = 4868.71, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 68907.66}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.23, ["Ride"] = 165.67, ["Fly|Ride"] = 262.5, ["Neon"] = 682.5, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 789.45, ["Mega"] = 4037.38, ["Mega|Fly|Ride"] = 2628.94}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 555.41, ["Fly"] = 695.36, ["Ride"] = 539.44, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1893.71, ["Neon|Fly|Ride"] = 1534.32, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.5, ["Ride"] = 34.33, ["Fly|Ride"] = 139.93, ["Neon"] = 63.91, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 278.77, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.87, ["Fly"] = 39.38, ["Ride"] = 32.45, ["Fly|Ride"] = 59.07, ["Neon"] = 24.91, ["Neon|Fly"] = 112.27, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 105, ["Mega"] = 196.88, ["Mega|Fly"] = 274.59, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 89.25, ["Fly"] = 656.25, ["Ride"] = 164.06, ["Fly|Ride"] = 182.44, ["Neon"] = 378.66, ["Neon|Ride"] = 599.3, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2366.89}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.71, ["Fly"] = 53.82, ["Ride"] = 39.68, ["Fly|Ride"] = 94.67, ["Neon"] = 338.07, ["Neon|Ride"] = 182.73, ["Neon|Fly|Ride"] = 277.73, ["Mega"] = 1392.79, ["Mega|Ride"] = 1065.22, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.69, ["Fly"] = 32.9, ["Ride"] = 32.4, ["Fly|Ride"] = 65.63, ["Neon"] = 139.93, ["Neon|Ride"] = 166.02, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 1356.24, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.75, ["Fly"] = 124.26, ["Ride"] = 71.14, ["Fly|Ride"] = 130.41, ["Neon"] = 331.33, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 308.09, ["Mega|Fly|Ride"] = 1499.58}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 52.88}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 315.89, ["Fly"] = 332.85, ["Ride"] = 353.07, ["Fly|Ride"] = 374.99, ["Neon"] = 1283.63, ["Neon|Ride"] = 1420.29, ["Neon|Fly|Ride"] = 1194.23, ["Mega|Fly|Ride"] = 4859.05}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.69, ["Fly"] = 115.5, ["Ride"] = 112.17, ["Fly|Ride"] = 143.06, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2505.76}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 115.91, ["Ride"] = 50.19, ["Fly|Ride"] = 209.25, ["Neon"] = 28.88, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 189, ["Mega"] = 139.93, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 348.73}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 152.15, ["Fly"] = 182.06, ["Ride"] = 158.71, ["Fly|Ride"] = 206.28, ["Neon"] = 946.71, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 580.05, ["Mega|Fly|Ride"] = 1962.19}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.9, ["Fly"] = 27.15, ["Ride"] = 19.68, ["Fly|Ride"] = 47.44, ["Neon"] = 68.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 72.18, ["Fly"] = 139.93, ["Ride"] = 104.99, ["Fly|Ride"] = 187.94, ["Neon"] = 249.38, ["Neon|Fly"] = 473.37, ["Neon|Ride"] = 284.62, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 1385.95, ["Mega|Ride"] = 951.21, ["Mega|Fly|Ride"] = 1057.58}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 57.72}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 70.88, ["Ride"] = 105, ["Fly|Ride"] = 228.66, ["Neon"] = 835.26, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 3156.56}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.17, ["Fly"] = 374.07, ["Ride"] = 35.51, ["Fly|Ride"] = 118.34, ["Neon"] = 204.68, ["Neon|Ride"] = 146.21, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 696.4, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1670.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 35.06, ["Fly"] = 94.67, ["Ride"] = 64.32, ["Fly|Ride"] = 99.82, ["Neon"] = 224.83, ["Neon|Fly"] = 311.18, ["Neon|Ride"] = 221.38, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1656.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.38, ["Fly"] = 416.59, ["Ride"] = 155.76, ["Fly|Ride"] = 137.84, ["Neon"] = 204.75, ["Neon|Fly"] = 392.89, ["Neon|Ride"] = 208.82, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 1084.79, ["Mega|Ride"] = 1248.71, ["Mega|Fly|Ride"] = 1420.29}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 27.17, ["Fly"] = 63.91, ["Ride"] = 41.77, ["Fly|Ride"] = 83.39, ["Neon"] = 208.82, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2086.04, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 55.61, ["Fly"] = 593.6, ["Ride"] = 86.67, ["Fly|Ride"] = 154.53, ["Neon"] = 139.94, ["Neon|Ride"] = 309.75, ["Mega|Ride"] = 1044.07, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.9, ["Fly"] = 56.4, ["Ride"] = 20.99, ["Fly|Ride"] = 49.86, ["Neon"] = 27.01, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 75.02, ["Mega"] = 126, ["Mega|Fly"] = 25108.99, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 240.38}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 374.22, ["Ride"] = 382.58, ["Fly|Ride"] = 417.63, ["Neon"] = 1810.64, ["Neon|Ride"] = 1668.41, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 12528.68, ["Mega|Fly|Ride"] = 7308.4}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 8.42, ["Ride"] = 35.51, ["Fly|Ride"] = 105.18, ["Neon"] = 217.88, ["Mega|Fly|Ride"] = 902.08}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.15, ["Fly"] = 49.08, ["Ride"] = 24.9, ["Fly|Ride"] = 45.94, ["Neon"] = 41.78, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 91.77, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 131.25, ["Fly"] = 139.93, ["Ride"] = 140.11, ["Fly|Ride"] = 208.82, ["Neon|Ride"] = 728.44, ["Neon|Fly|Ride"] = 366.31, ["Mega"] = 2073.5, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1893.71}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.67, ["Fly"] = 33.43, ["Ride"] = 29.58, ["Fly|Ride"] = 61.62, ["Neon"] = 62.68, ["Neon|Ride"] = 137.3, ["Neon|Fly|Ride"] = 161.43, ["Mega"] = 710.15, ["Mega|Ride"] = 795.58, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 174.72, ["Fly"] = 352.9, ["Ride"] = 196.88, ["Fly|Ride"] = 287.94, ["Neon"] = 835.26, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6264.35, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2858.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 32.69}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.93, ["Fly"] = 32.82, ["Ride"] = 24.94, ["Fly|Ride"] = 82.49, ["Neon"] = 22.51, ["Neon|Fly"] = 4635.63, ["Neon|Ride"] = 48.04, ["Neon|Fly|Ride"] = 154.53, ["Mega"] = 144.38, ["Mega|Fly"] = 284.07, ["Mega|Ride"] = 236.73, ["Mega|Fly|Ride"] = 249.62}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1181.25, ["Ride"] = 1128.75, ["Fly|Ride"] = 1312.5, ["Neon"] = 6681.96, ["Neon|Ride"] = 5569.02, ["Neon|Fly|Ride"] = 5569.02, ["Mega|Ride"] = 53259.99, ["Mega|Fly|Ride"] = 17360.41}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.34, ["Fly"] = 68.93, ["Ride"] = 41.88, ["Fly|Ride"] = 90.85, ["Neon"] = 104.42, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 142.05, ["Mega"] = 511.88, ["Mega|Ride"] = 667.16, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 120.75, ["Ride"] = 131.25, ["Fly|Ride"] = 249.38, ["Neon"] = 927.14, ["Neon|Ride"] = 696.4, ["Neon|Fly|Ride"] = 842.44, ["Mega|Ride"] = 4013.37, ["Mega|Fly|Ride"] = 2768.14}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.82}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 13.85, ["Fly"] = 68.85, ["Ride"] = 64.32, ["Fly|Ride"] = 139.93, ["Neon"] = 92.66, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 552.74}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 127.84, ["Ride"] = 208.82, ["Fly|Ride"] = 223.12, ["Neon"] = 525, ["Neon|Ride"] = 480.29, ["Neon|Fly|Ride"] = 591.8, ["Mega|Fly|Ride"] = 2210.9}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.88, ["Ride"] = 158.89, ["Fly|Ride"] = 498.75, ["Neon"] = 460.44, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 1664.23, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1666.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.83}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.82, ["Fly"] = 87.57, ["Ride"] = 58.97, ["Fly|Ride"] = 64.31, ["Neon"] = 599.3, ["Neon|Ride"] = 402.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 4176.23, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.73, ["Ride"] = 39.38, ["Fly|Ride"] = 111.72, ["Neon"] = 39.24, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 232.84, ["Mega"] = 224.89, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 391.13, ["Fly"] = 423.94, ["Ride"] = 422.61, ["Fly|Ride"] = 485.22, ["Neon|Ride"] = 1407.4, ["Neon|Fly|Ride"] = 1302.11, ["Mega|Fly|Ride"] = 6125.44}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 84, ["Fly"] = 97.05, ["Ride"] = 107.63, ["Fly|Ride"] = 139.93, ["Neon"] = 492.28, ["Neon|Ride"] = 497.12, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 2228.03, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7099.59, ["Fly"] = 3609.38, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14615.74}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 37.77, ["Fly"] = 111.72, ["Ride"] = 53.47, ["Fly|Ride"] = 97.63, ["Neon"] = 393.75, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 314.25, ["Mega|Ride"] = 1622.48, ["Mega|Fly|Ride"] = 1390.7}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Fly"] = 81.45, ["Ride"] = 57.75, ["Fly|Ride"] = 203.61, ["Neon"] = 590.46, ["Neon|Ride"] = 334.11, ["Neon|Fly|Ride"] = 678.65, ["Mega"] = 6264.35, ["Mega|Fly|Ride"] = 1656.93}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.66, ["Fly"] = 57.75, ["Ride"] = 69.13, ["Fly|Ride"] = 124.04, ["Neon"] = 215.12, ["Neon|Fly"] = 473.37, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 2598.75, ["Mega|Ride"] = 680.74, ["Mega|Fly|Ride"] = 751.74}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.93, ["Ride"] = 56.4, ["Fly|Ride"] = 72.19, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 417.63, ["Mega|Fly|Ride"] = 1578.88}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.67}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 208.69, ["Ride"] = 782.01, ["Fly|Ride"] = 319.5, ["Neon|Ride"] = 1392.79, ["Neon|Fly|Ride"] = 2412.31}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 955.5, ["Fly|Ride"] = 945, ["Neon|Ride"] = 3271.35, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 15660.84}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.46}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.15, ["Fly"] = 52.48, ["Ride"] = 38.07, ["Fly|Ride"] = 65.61, ["Neon"] = 162.75, ["Neon|Fly"] = 189.36, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 204.65, ["Mega|Ride"] = 761.15, ["Mega|Fly|Ride"] = 765.7}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 12.39}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5272.04, ["Fly"] = 5819.58, ["Ride"] = 4659.38, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40083.48}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.45, ["Fly"] = 74.65, ["Ride"] = 26.25, ["Fly|Ride"] = 54.99, ["Neon"] = 52.5, ["Neon|Ride"] = 98.16, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 460.44, ["Mega|Ride"] = 689.1, ["Mega|Fly|Ride"] = 529.29}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.87, ["Fly"] = 191.66, ["Ride"] = 34.9, ["Fly|Ride"] = 117.16, ["Neon"] = 137.85, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.55, ["Mega"] = 1044.07, ["Mega|Ride"] = 654.65, ["Mega|Fly|Ride"] = 710.15}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 41.77, ["Fly"] = 210.73, ["Ride"] = 124.69, ["Fly|Ride"] = 103.69, ["Neon"] = 1392.79, ["Neon|Fly|Ride"] = 557.53, ["Mega"] = 4176.23}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.81, ["Ride"] = 29.4, ["Fly|Ride"] = 139.65, ["Neon"] = 73.37, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.36, ["Mega"] = 363.35, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1955.63, ["Fly"] = 2454.59, ["Ride"] = 2126.25, ["Fly|Ride"] = 2093.44, ["Neon|Fly|Ride"] = 4572.75, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30627.38, ["Fly"] = 35340.82, ["Ride"] = 34802.55, ["Fly|Ride"] = 23100, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 212961.84}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.75, ["Fly"] = 37.59, ["Ride"] = 41.99, ["Fly|Ride"] = 125.3, ["Neon"] = 263.82, ["Neon|Ride"] = 170.45, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 835.26, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1471.18}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 60.57, ["Ride"] = 49.08, ["Fly|Ride"] = 131.25, ["Neon"] = 24.03, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 118.13, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 354.99}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.5, ["Ride"] = 52.49, ["Fly|Ride"] = 111.57, ["Neon"] = 61.17, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 416.69, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 701.49, ["Fly"] = 766.35, ["Ride"] = 707.44, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2699.94, ["Neon|Fly|Ride"] = 2839.85, ["Mega|Fly|Ride"] = 11047.32}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 891.19, ["Fly"] = 900.38, ["Ride"] = 898.37, ["Fly|Ride"] = 983.07, ["Neon"] = 4176.23, ["Neon|Fly|Ride"] = 2877.05, ["Mega|Fly|Ride"] = 11250.75}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 18.81, ["Fly"] = 118.34, ["Ride"] = 45.01, ["Fly|Ride"] = 107.63, ["Neon"] = 106.31, ["Neon|Ride"] = 193.2, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 835.11, ["Mega|Ride"] = 682.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 59.37, ["Fly"] = 93.19, ["Ride"] = 74.82, ["Fly|Ride"] = 125.3, ["Neon|Ride"] = 343.24, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 2044.27, ["Mega|Fly|Ride"] = 1751.94}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 62.67, ["Ride"] = 59.07, ["Fly|Ride"] = 195.25, ["Neon"] = 450.19, ["Neon|Fly"] = 536.73, ["Neon|Ride"] = 632.04, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1751.94, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.15, ["Fly"] = 46.04, ["Ride"] = 22.52, ["Fly|Ride"] = 50.26, ["Neon"] = 39.37, ["Neon|Fly"] = 525, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 139.19, ["Mega"] = 177.19, ["Mega|Ride"] = 396.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 82.8, ["Fly"] = 90.04, ["Ride"] = 97.12, ["Fly|Ride"] = 157.5, ["Neon"] = 817.51, ["Neon|Ride"] = 355.08, ["Neon|Fly|Ride"] = 373.75, ["Mega|Fly|Ride"] = 1301.92}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.67, ["Ride"] = 37.59, ["Fly|Ride"] = 105, ["Neon"] = 26.25, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.66, ["Fly"] = 40.28, ["Ride"] = 32.82, ["Fly|Ride"] = 72.18, ["Neon"] = 139.93, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 738.17, ["Mega|Fly|Ride"] = 696.4}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 24.94, ["Ride"] = 63.91, ["Fly|Ride"] = 156.19, ["Neon"] = 237.57, ["Neon|Ride"] = 329.94, ["Mega"] = 694.25, ["Mega|Ride"] = 552.74, ["Mega|Fly|Ride"] = 871.68}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.07, ["Fly"] = 106.56, ["Ride"] = 24.94, ["Fly|Ride"] = 83.63, ["Neon"] = 103.69, ["Neon|Fly"] = 557.61, ["Neon|Ride"] = 139.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 831.08, ["Mega|Ride"] = 939.66, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5512.5, ["Ride"] = 7099.65, ["Fly|Ride"] = 5754, ["Neon"] = 34802.55, ["Neon|Fly|Ride"] = 22273.9}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 248.46, ["Fly"] = 265.2, ["Ride"] = 242.82, ["Fly|Ride"] = 278.77, ["Neon|Fly|Ride"] = 595.29, ["Mega|Fly|Ride"] = 1860.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.39, ["Fly"] = 127.39, ["Ride"] = 61.67, ["Fly|Ride"] = 134.78, ["Neon"] = 96.66, ["Neon|Fly"] = 191.72, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Fly"] = 557.53, ["Mega|Ride"] = 353.05, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.28, ["Fly"] = 21, ["Ride"] = 18.81, ["Fly|Ride"] = 98.16, ["Neon"] = 30.3, ["Neon|Ride"] = 56.27, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 174.37}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 35.37, ["Fly"] = 5285.82, ["Ride"] = 99.73, ["Fly|Ride"] = 192, ["Neon"] = 91.88, ["Neon|Fly"] = 332.06, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 435.75, ["Mega|Ride"] = 465.7, ["Mega|Fly|Ride"] = 584.7}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 11037.86, ["Fly|Ride"] = 10824.19, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 108164.14}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 170.63, ["Ride"] = 217.88, ["Fly|Ride"] = 249.38, ["Neon"] = 1426.37, ["Neon|Ride"] = 1531.64, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4663.81}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 43.32, ["Fly"] = 101.78, ["Ride"] = 69.55, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 378, ["Mega|Fly|Ride"] = 2052.3}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.34, ["Fly"] = 44.98, ["Ride"] = 23.67, ["Fly|Ride"] = 56.4, ["Neon"] = 92.31, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2505.76, ["Mega|Fly|Ride"] = 632.04}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 353.63, ["Fly"] = 835.26, ["Ride"] = 420, ["Fly|Ride"] = 468.02, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4936.32}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.55, ["Ride"] = 27.17, ["Fly|Ride"] = 98.44, ["Neon"] = 28.25, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 208.82, ["Mega|Ride"] = 261.58, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 258.95, ["Ride"] = 278.25, ["Fly|Ride"] = 308.01, ["Neon"] = 922.98, ["Neon|Ride"] = 937.57, ["Neon|Fly|Ride"] = 939.66, ["Mega|Fly|Ride"] = 3571.74}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.16, ["Fly"] = 20.97, ["Ride"] = 17.98, ["Fly|Ride"] = 39.36, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.6, ["Mega"] = 2505.76, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 13.02}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 59.57, ["Ride"] = 178.5, ["Fly|Ride"] = 315.95, ["Neon"] = 369.21, ["Neon|Fly"] = 1670.7, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega|Ride"] = 1420.29, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.82, ["Fly"] = 78.46, ["Ride"] = 41.99, ["Fly|Ride"] = 84.67, ["Neon"] = 65.63, ["Neon|Ride"] = 120.73, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 518.44, ["Mega|Ride"] = 549.75, ["Mega|Fly|Ride"] = 542.93}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.43}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 31.49, ["Fly"] = 111.57, ["Ride"] = 77.27, ["Fly|Ride"] = 105, ["Neon"] = 194.21, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 789.45, ["Mega|Ride"] = 917.75, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.28, ["Fly|Ride"] = 131.25, ["Neon"] = 29.64, ["Neon|Ride"] = 106.54, ["Neon|Fly|Ride"] = 132.61, ["Mega"] = 122.31, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.67, ["Fly"] = 69.98, ["Ride"] = 29.97, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 221.36, ["Mega|Ride"] = 529.35, ["Mega|Fly|Ride"] = 814.38}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 378.59, ["Ride"] = 378.66, ["Fly|Ride"] = 409.89, ["Neon|Fly|Ride"] = 2645.66, ["Mega|Fly|Ride"] = 8074.75}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 52.28, ["Fly"] = 104.43, ["Ride"] = 77.3, ["Fly|Ride"] = 87.93, ["Neon"] = 348.73, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 718.86, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 757.49}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.19, ["Fly"] = 91.98, ["Ride"] = 82.13, ["Neon"] = 235.97, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 355.08, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1246.62}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.67, ["Ride"] = 72.19, ["Fly|Ride"] = 147.62, ["Neon"] = 101.87, ["Neon|Ride"] = 139.93, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 375.88, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11065.97, ["Fly"] = 9948.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7218.75, ["Neon|Fly|Ride"] = 12665.63, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2099.89, ["Fly"] = 2083.95, ["Ride"] = 1837.5, ["Fly|Ride"] = 1836.19, ["Neon|Ride"] = 5366.26, ["Neon|Fly|Ride"] = 4950.44, ["Mega"] = 22271.81, ["Mega|Fly|Ride"] = 20709.89}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 393.75, ["Ride"] = 468.85, ["Fly|Ride"] = 513.7, ["Neon"] = 2088.13, ["Neon|Fly|Ride"] = 2088.13, ["Mega"] = 16704.91, ["Mega|Fly|Ride"] = 6751.91}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.82, ["Fly"] = 23.62, ["Ride"] = 20.98, ["Fly|Ride"] = 48.04, ["Neon"] = 108.78, ["Neon|Ride"] = 111.72, ["Neon|Fly|Ride"] = 78.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.17, ["Fly"] = 78.74, ["Ride"] = 41.43, ["Neon"] = 26.24, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 163.13, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 270.84}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.81, ["Fly"] = 74.81, ["Ride"] = 45.48, ["Fly|Ride"] = 97.31, ["Neon"] = 270.45, ["Neon|Ride"] = 135.72, ["Neon|Fly|Ride"] = 158.82, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.8, ["Fly"] = 27.23, ["Ride"] = 20.71, ["Fly|Ride"] = 45.94, ["Neon"] = 24.03, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 77.18, ["Mega"] = 472.5, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 262.5, ["Fly"] = 320.25, ["Ride"] = 307.18, ["Fly|Ride"] = 301.75, ["Neon"] = 1007.52, ["Neon|Ride"] = 1252.89, ["Neon|Fly|Ride"] = 1198.02, ["Mega|Fly|Ride"] = 6264.35}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.3, ["Fly"] = 59.17, ["Ride"] = 40.68, ["Fly|Ride"] = 71.01, ["Neon"] = 142.01, ["Neon|Fly"] = 167.08, ["Neon|Ride"] = 146.18, ["Neon|Fly|Ride"] = 158.62, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 609.75}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.48, ["Fly"] = 27.17, ["Ride"] = 25.08, ["Fly|Ride"] = 47.5, ["Neon"] = 35.58, ["Neon|Fly"] = 134.92, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.43, ["Fly"] = 787.5, ["Ride"] = 433.13, ["Fly|Ride"] = 529.35, ["Neon|Ride"] = 2714.56, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.65, ["Fly"] = 1419.68, ["Ride"] = 1283.83, ["Fly|Ride"] = 1312.5, ["Neon|Ride"] = 3472.56, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 20742.26}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 83.07, ["Fly"] = 125.3, ["Ride"] = 90.56, ["Fly|Ride"] = 120.75, ["Neon"] = 971.25, ["Neon|Ride"] = 1741.5, ["Neon|Fly|Ride"] = 474.02, ["Mega|Fly|Ride"] = 2609.12}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 143, ["Fly"] = 177.48, ["Ride"] = 178.49, ["Fly|Ride"] = 224.44, ["Neon"] = 556.5, ["Neon|Fly"] = 668.29, ["Neon|Ride"] = 737.51, ["Neon|Fly|Ride"] = 565.7, ["Mega"] = 5569.02, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.05, ["Ride"] = 47.44, ["Neon"] = 191.79, ["Neon|Fly"] = 417.68, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 362.31, ["Mega"] = 787.5, ["Mega|Ride"] = 2088.13, ["Mega|Fly|Ride"] = 897.9}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 208.82, ["Ride"] = 207.79, ["Fly|Ride"] = 278.77, ["Neon|Fly|Ride"] = 1325.6, ["Mega|Fly|Ride"] = 2989.67}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2248.23, ["Fly|Ride"] = 2645.66, ["Neon|Fly|Ride"] = 7097.5, ["Mega|Fly|Ride"] = 48026.56}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 81.45, ["Ride"] = 52.41, ["Fly|Ride"] = 196.87, ["Neon"] = 311.15, ["Neon|Fly"] = 355.04, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 2081.86, ["Mega|Ride"] = 2296.94, ["Mega|Fly|Ride"] = 1670.5}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.75, ["Fly"] = 808.12, ["Ride"] = 613.2, ["Fly|Ride"] = 581.44, ["Neon"] = 1495.1, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3100.02}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 49.08, ["Fly"] = 63.67, ["Ride"] = 54.91, ["Fly|Ride"] = 85.76, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 194.91, ["Mega|Fly|Ride"] = 988.74}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.66, ["Fly"] = 31.76, ["Ride"] = 20.99, ["Fly|Ride"] = 42.73, ["Neon"] = 35.51, ["Neon|Fly"] = 98.17, ["Neon|Ride"] = 38.19, ["Neon|Fly|Ride"] = 81.2, ["Mega"] = 161.41, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.55, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 118.34, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 557.53, ["Mega|Ride"] = 1392.79, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 630, ["Fly"] = 1404.56, ["Ride"] = 623.14, ["Fly|Ride"] = 717.48, ["Neon|Ride"] = 2148.68, ["Neon|Fly|Ride"] = 1606.5, ["Mega|Fly|Ride"] = 6681.96}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 525, ["Ride"] = 590.63, ["Fly|Ride"] = 780.97, ["Neon"] = 5220.29, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12625.01}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.42, ["Fly"] = 23.67, ["Ride"] = 23.07, ["Fly|Ride"] = 52.22, ["Neon"] = 208.82, ["Neon|Ride"] = 104.43, ["Neon|Fly|Ride"] = 110.07, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.67, ["Ride"] = 23.61, ["Fly|Ride"] = 62.66, ["Neon"] = 98.16, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 1670.5, ["Mega|Ride"] = 388.58, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.81, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 111.44, ["Neon"] = 36.57, ["Neon|Fly"] = 317.48, ["Neon|Ride"] = 52.82, ["Neon|Fly|Ride"] = 131.38, ["Mega"] = 249.54, ["Mega|Fly"] = 458.05, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.38, ["Fly"] = 78.75, ["Ride"] = 47.34, ["Fly|Ride"] = 90.85, ["Neon"] = 184.62, ["Neon|Fly"] = 184.63, ["Neon|Ride"] = 166.02, ["Neon|Fly|Ride"] = 213.93, ["Mega|Fly|Ride"] = 863.44}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 111.57, ["Fly|Ride"] = 449.61, ["Neon"] = 348.91, ["Neon|Ride"] = 456.26, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 1564.01, ["Mega|Ride"] = 1566.1, ["Mega|Fly|Ride"] = 1262.87}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.46, ["Fly"] = 59.07, ["Ride"] = 32.82, ["Fly|Ride"] = 84, ["Neon"] = 83.16, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 94.7, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 451.04}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.88, ["Fly"] = 65.06, ["Ride"] = 38.07, ["Fly|Ride"] = 93.45, ["Neon"] = 557.06, ["Neon|Ride"] = 234.36, ["Neon|Fly|Ride"] = 219.66, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1183.56}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.78, ["Fly"] = 28.21, ["Ride"] = 19.57, ["Fly|Ride"] = 65.62, ["Neon"] = 32.59, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 525, ["Mega|Ride"] = 278.77, ["Mega|Fly|Ride"] = 299.66}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.24, ["Fly"] = 30.54, ["Ride"] = 28.25, ["Fly|Ride"] = 315.95, ["Neon"] = 27.2, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 262.07, ["Mega|Fly"] = 474.02, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 522.04}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.36, ["Fly"] = 60.38, ["Ride"] = 47.25, ["Fly|Ride"] = 79.29, ["Neon"] = 410.65, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1863.74, ["Fly"] = 2362.5, ["Ride"] = 1837.5, ["Fly|Ride"] = 1666.88, ["Neon|Fly"] = 4970.11, ["Neon|Ride"] = 5741.28, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 20357.16}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 477.5, ["Fly"] = 542.93, ["Ride"] = 433.02, ["Fly|Ride"] = 525, ["Neon"] = 3156.03, ["Neon|Ride"] = 3063.26, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9712.86}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 237.79, ["Fly"] = 320.54, ["Ride"] = 313.23, ["Fly|Ride"] = 404.07, ["Neon"] = 1202.53, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1503.46, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.85, ["Ride"] = 38.84, ["Fly|Ride"] = 78.75, ["Neon"] = 328.75, ["Neon|Fly"] = 417.68, ["Neon|Ride"] = 305.62, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 808.12, ["Mega|Ride"] = 937.57, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33409.79, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 15750, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 467.78, ["Fly"] = 467.31, ["Ride"] = 501.38, ["Fly|Ride"] = 568.32, ["Neon"] = 1508.69, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 6264.35, ["Mega|Fly|Ride"] = 4464.85}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 259.1, ["Ride"] = 136.49, ["Fly|Ride"] = 155.38, ["Neon|Fly|Ride"] = 557.53, ["Mega|Fly|Ride"] = 4176.23}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Fly"] = 278.77, ["Ride"] = 123.38, ["Fly|Ride"] = 207.38, ["Neon"] = 707.62, ["Neon|Ride"] = 705.79, ["Neon|Fly|Ride"] = 557.53, ["Mega"] = 13921.45, ["Mega|Fly|Ride"] = 5220.29}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.11, ["Fly"] = 69.98, ["Ride"] = 33.43, ["Fly|Ride"] = 83.76, ["Neon"] = 274.3, ["Neon|Ride"] = 139.64, ["Neon|Fly|Ride"] = 194.21, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 632.04}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4655.45, ["Ride"] = 4733.76, ["Fly|Ride"] = 3937.49, ["Neon"] = 17323.69, ["Neon|Fly|Ride"] = 17540.14}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 23.63, ["Fly"] = 66.84, ["Ride"] = 31.23, ["Fly|Ride"] = 54.02, ["Neon"] = 333.94, ["Neon|Ride"] = 206.73, ["Neon|Fly|Ride"] = 180.23, ["Mega"] = 1044.07, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.75, ["Fly"] = 115.08, ["Ride"] = 56.4, ["Fly|Ride"] = 55.62, ["Neon|Fly"] = 1392.96, ["Neon|Ride"] = 278.77, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 1578.88, ["Mega|Fly|Ride"] = 1155.78}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 570.94, ["Fly"] = 905.21, ["Ride"] = 602.43, ["Fly|Ride"] = 682.5, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4734.23}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.91, ["Fly"] = 31.34, ["Ride"] = 25.9, ["Fly|Ride"] = 55.13, ["Neon"] = 106.31, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 98.16, ["Neon|Fly|Ride"] = 116.82, ["Mega|Ride"] = 600.08, ["Mega|Fly|Ride"] = 521.06}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.44, ["Fly"] = 74.13, ["Ride"] = 31.96, ["Fly|Ride"] = 492.81, ["Neon"] = 80.07, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 557.53}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.75, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 527.71, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 705.79, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.15, ["Fly"] = 139.93, ["Ride"] = 78.75, ["Fly|Ride"] = 141.75, ["Neon"] = 125.3, ["Neon|Fly"] = 208.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 220.89, ["Mega"] = 313.23, ["Mega|Ride"] = 557.53, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3543.75, ["Fly"] = 5114.85, ["Ride"] = 3543.75, ["Fly|Ride"] = 3609.37, ["Neon|Ride"] = 11660.02, ["Neon|Fly|Ride"] = 8531.25, ["Mega"] = 43665.54, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 47.22, ["Fly"] = 105, ["Ride"] = 59.07, ["Fly|Ride"] = 129.26, ["Neon"] = 131.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 414.25, ["Mega|Ride"] = 939.66, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7621.62, ["Fly|Ride"] = 6037.5, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 64453.72}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.47, ["Fly"] = 23.62, ["Ride"] = 18.38, ["Fly|Ride"] = 43.86, ["Neon"] = 23.39, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 459.38, ["Mega|Fly|Ride"] = 261.17}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.49, ["Fly"] = 26.16, ["Ride"] = 35.51, ["Fly|Ride"] = 49.88, ["Neon"] = 195.25, ["Neon|Ride"] = 166.02, ["Neon|Fly|Ride"] = 181.68, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 946.86}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.5, ["Ride"] = 41.43, ["Fly|Ride"] = 122.84, ["Neon|Ride"] = 152.44, ["Neon|Fly|Ride"] = 237.02, ["Mega"] = 834.21, ["Mega|Ride"] = 973.07, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.31, ["Fly"] = 262.5, ["Ride"] = 46.16, ["Fly|Ride"] = 196.88, ["Neon"] = 182.43, ["Neon|Ride"] = 145.51, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 840, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 16.25, ["Fly"] = 25.09, ["Ride"] = 17.75, ["Fly|Ride"] = 42.4, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 167.07, ["Mega"] = 656.25, ["Mega|Ride"] = 590.61, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8316.96}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2657.82}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 153.81, ["Fly"] = 348.73, ["Ride"] = 174.56, ["Fly|Ride"] = 223.13, ["Neon|Fly|Ride"] = 1105.46, ["Mega|Fly|Ride"] = 5523.67}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.38, ["Fly"] = 111.72, ["Ride"] = 65.62, ["Fly|Ride"] = 196.88, ["Neon"] = 123.21, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 275.65, ["Mega|Ride"] = 899.51, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.36}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.39, ["Ride"] = 26.25, ["Neon"] = 50.13, ["Neon|Ride"] = 98.16, ["Neon|Fly|Ride"] = 125.3, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 164.07, ["Fly"] = 208.82, ["Ride"] = 202.57, ["Fly|Ride"] = 415.54, ["Neon"] = 701.37, ["Neon|Ride"] = 599.3, ["Neon|Fly|Ride"] = 626.45, ["Mega|Ride"] = 3467.33, ["Mega|Fly|Ride"] = 3467.33}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 335.66, ["Ride"] = 395.22, ["Fly|Ride"] = 525, ["Neon"] = 675.68, ["Neon|Ride"] = 874.67, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2493.75, ["Mega|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 2401.34}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 178.46, ["Fly"] = 246.41, ["Ride"] = 170.47, ["Fly|Ride"] = 259.52, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 4593.86, ["Mega|Fly|Ride"] = 3481.94}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1508.07, ["Fly"] = 2505.76, ["Ride"] = 1312.49, ["Fly|Ride"] = 1312.5, ["Neon"] = 5049.39, ["Neon|Ride"] = 4589.68, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 27841.84}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 12.33, ["Fly"] = 47.34, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 127.31, ["Neon|Ride"] = 167.07, ["Neon|Fly|Ride"] = 316.02, ["Mega"] = 834.21, ["Mega|Ride"] = 620.18, ["Mega|Fly|Ride"] = 654.65}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 640.5, ["Fly"] = 2100, ["Ride"] = 696.4, ["Fly|Ride"] = 789.26, ["Neon|Fly|Ride"] = 3131.15}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 48.57}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.19, ["Ride"] = 36.67, ["Fly|Ride"] = 681.8, ["Neon"] = 78.56, ["Neon|Ride"] = 139.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 314.9, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.44, ["Fly"] = 257.28, ["Ride"] = 28.21, ["Fly|Ride"] = 94.79, ["Neon"] = 45.94, ["Neon|Ride"] = 87.71, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 486.54, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 91.81}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.09, ["Ride"] = 31.27, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 208.82, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.21, ["Fly"] = 75.18, ["Ride"] = 36.75, ["Fly|Ride"] = 60.75, ["Neon"] = 157.5, ["Neon|Ride"] = 415.54, ["Neon|Fly|Ride"] = 250.59, ["Mega"] = 955.14, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6237, ["Fly"] = 6292.53, ["Ride"] = 6960.73, ["Fly|Ride"] = 4987.5, ["Neon|Ride"] = 17401.28, ["Neon|Fly|Ride"] = 10058.76, ["Mega|Fly|Ride"] = 33929}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.36, ["Fly"] = 79.36, ["Ride"] = 32.96, ["Fly|Ride"] = 79.29, ["Neon"] = 47.23, ["Neon|Ride"] = 104.16, ["Mega"] = 530.24, ["Mega|Ride"] = 542.93, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.68}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 104.99, ["Fly"] = 369.62, ["Ride"] = 131.15, ["Fly|Ride"] = 210.92, ["Neon"] = 418.69, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 532.62, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 70.47, ["Fly"] = 96.48, ["Ride"] = 99.49, ["Fly|Ride"] = 158.58, ["Neon"] = 327.6, ["Neon|Ride"] = 359.17, ["Neon|Fly|Ride"] = 557.53, ["Mega"] = 2367.12, ["Mega|Ride"] = 2818.97}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.07, ["Fly"] = 65.63, ["Ride"] = 34.13, ["Fly|Ride"] = 76.13, ["Neon"] = 196.88, ["Neon|Ride"] = 158.62, ["Neon|Fly|Ride"] = 157.47, ["Mega|Ride"] = 682.83, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.17, ["Fly"] = 79.36, ["Ride"] = 31.96, ["Fly|Ride"] = 83.55, ["Neon"] = 23.69, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 171.25, ["Mega"] = 139.93, ["Mega|Fly"] = 6960.73, ["Mega|Ride"] = 173.77, ["Mega|Fly|Ride"] = 271.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.39, ["Ride"] = 31.34, ["Fly|Ride"] = 71.3, ["Neon"] = 91.89, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 181.68, ["Mega"] = 460.44, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.32, ["Fly"] = 32.82, ["Ride"] = 26.22, ["Fly|Ride"] = 56.35, ["Neon"] = 208.71, ["Neon|Ride"] = 158.62, ["Neon|Fly|Ride"] = 150.02, ["Mega|Fly|Ride"] = 803.94}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 194.25}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 22.32, ["Ride"] = 91.88, ["Neon"] = 144.38, ["Neon|Ride"] = 150.94, ["Mega"] = 511.88, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 943.84}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 151.28, ["Ride"] = 111.72, ["Fly|Ride"] = 262.49, ["Neon"] = 557.53, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 557.53}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.59, ["Fly"] = 212.01, ["Ride"] = 90.57, ["Fly|Ride"] = 216.57, ["Neon"] = 178.5, ["Neon|Fly"] = 300.59, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1115.63, ["Mega|Ride"] = 1100.46, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 858.38, ["Fly"] = 993.97, ["Ride"] = 787.49, ["Fly|Ride"] = 770.73, ["Neon|Fly"] = 2840.07, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2205, ["Mega|Fly|Ride"] = 10353}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 195.69, ["Fly"] = 418.89, ["Ride"] = 216.47, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1893.71, ["Neon|Fly|Ride"] = 1456.88, ["Mega"] = 8206.59, ["Mega|Fly|Ride"] = 4497.52}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 103.37}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 6.49, ["Fly"] = 35.44, ["Ride"] = 22.32, ["Fly|Ride"] = 47.34, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 104.43, ["Neon|Fly|Ride"] = 154.53, ["Mega"] = 437.26, ["Mega|Ride"] = 695.36, ["Mega|Fly|Ride"] = 460.44}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 283.48, ["Fly"] = 390.49, ["Ride"] = 316.31, ["Fly|Ride"] = 380.66, ["Neon"] = 1081.54, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 1068.08, ["Mega|Fly|Ride"] = 3728.33}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 20.96}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 124.69, ["Fly"] = 288.73, ["Ride"] = 157.48, ["Fly|Ride"] = 236.25, ["Neon"] = 525, ["Neon|Fly"] = 1670.7, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 743.07, ["Mega"] = 3063.26, ["Mega|Ride"] = 2257.05, ["Mega|Fly|Ride"] = 2199.85}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 138.7, ["Ride"] = 137.71, ["Fly|Ride"] = 196.88, ["Neon"] = 1114.02, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 1043.02}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.24, ["Ride"] = 24.94, ["Fly|Ride"] = 208.82, ["Neon"] = 37.96, ["Neon|Ride"] = 85.29, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 216.57, ["Mega|Ride"] = 234.93, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.59, ["Fly"] = 63, ["Ride"] = 22.5, ["Fly|Ride"] = 76.12, ["Neon"] = 103.07, ["Neon|Ride"] = 167.07, ["Neon|Fly|Ride"] = 139.93, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.61, ["Fly"] = 102.32, ["Ride"] = 34.73, ["Fly|Ride"] = 128.82, ["Neon"] = 139.93, ["Neon|Ride"] = 174.37, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 470.3, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 696.4}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.92, ["Fly"] = 115.9, ["Ride"] = 56.44, ["Fly|Ride"] = 132.61, ["Neon"] = 23.67, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 143.07, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 275.51}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.29, ["Fly"] = 918.75, ["Ride"] = 295.83, ["Fly|Ride"] = 359.31, ["Neon"] = 1392.79, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1390.33}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 114.19, ["Fly"] = 1050, ["Ride"] = 135.19, ["Fly|Ride"] = 196.87, ["Neon"] = 461.28, ["Neon|Ride"] = 459.27, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 1952.89, ["Mega|Ride"] = 2461.81, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 64.22, ["Fly"] = 167.45, ["Ride"] = 87.34, ["Fly|Ride"] = 128.63, ["Neon"] = 369.62, ["Neon|Ride"] = 387.36, ["Neon|Fly|Ride"] = 473.3, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 24.06, ["Ride"] = 57.75, ["Fly|Ride"] = 250.59, ["Neon|Ride"] = 601.26, ["Neon|Fly|Ride"] = 484.45, ["Mega|Ride"] = 615.57, ["Mega|Fly|Ride"] = 1662.15}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.43, ["Fly"] = 31.96, ["Ride"] = 55.62, ["Fly|Ride"] = 120.08, ["Neon"] = 91.88, ["Neon|Ride"] = 90.85, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 395.2, ["Mega|Fly"] = 525, ["Mega|Ride"] = 390.58, ["Mega|Fly|Ride"] = 448.87}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.82, ["Fly"] = 45.95, ["Ride"] = 20.85, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 122.91, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 271.47}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1060.53, ["Ride"] = 918.75, ["Fly|Ride"] = 973.87, ["Neon"] = 3017.58, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 10648.34}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 446.87, ["Ride"] = 417.63, ["Fly|Ride"] = 450.01, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2012.06, ["Mega"] = 10440.56, ["Mega|Fly|Ride"] = 7890.78}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 60.51, ["Fly"] = 128.63, ["Ride"] = 91.89, ["Fly|Ride"] = 157.5, ["Neon"] = 313.27, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 357, ["Mega|Ride"] = 1439.78, ["Mega|Fly|Ride"] = 1459.6}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 345.59, ["Ride"] = 296.87, ["Fly|Ride"] = 290.32, ["Neon"] = 1247.18, ["Neon|Ride"] = 1420.29, ["Neon|Fly|Ride"] = 1183.97, ["Mega"] = 10440.56, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 44.9, ["Fly"] = 139.93, ["Ride"] = 24.44, ["Fly|Ride"] = 65.63, ["Neon"] = 157.5, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 158.62, ["Mega|Ride"] = 662.99, ["Mega|Fly|Ride"] = 644.4}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.11, ["Ride"] = 259.17, ["Fly|Ride"] = 520.99, ["Neon"] = 1419.05, ["Neon|Ride"] = 1736.28, ["Neon|Fly|Ride"] = 1342.17, ["Mega"] = 4155.64, ["Mega|Fly|Ride"] = 4120.91}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 79.29, ["Ride"] = 65.63, ["Fly|Ride"] = 78.86, ["Neon"] = 278.77, ["Neon|Ride"] = 499.07}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1529.07, ["Ride"] = 1470.12, ["Fly|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 4176.23, ["Mega"] = 50114.67, ["Mega|Fly|Ride"] = 23665.62}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.58, ["Fly"] = 57.75, ["Ride"] = 43.3, ["Fly|Ride"] = 90.57, ["Neon"] = 60.38, ["Neon|Fly"] = 105, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 262.47, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.37, ["Fly"] = 78.75, ["Ride"] = 59.06, ["Fly|Ride"] = 159.48, ["Neon"] = 250.59, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 319.5, ["Mega|Ride"] = 1024.24, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 65.63, ["Fly"] = 91.88, ["Ride"] = 66.28, ["Fly|Ride"] = 75.62, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1338.75}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3758.62, ["Ride"] = 1230.63, ["Fly|Ride"] = 1128.74, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 475.61, ["Fly"] = 833.17, ["Ride"] = 520.99, ["Fly|Ride"] = 626.45, ["Neon|Fly|Ride"] = 2762.43, ["Mega|Fly|Ride"] = 14202.67}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 86.63, ["Fly"] = 315.95, ["Ride"] = 129.94, ["Fly|Ride"] = 218.29, ["Neon"] = 444.29, ["Neon|Fly"] = 557.61, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 4175.19, ["Mega|Ride"] = 2645.66, ["Mega|Fly|Ride"] = 2210.9}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.33, ["Fly"] = 39.38, ["Ride"] = 23.67, ["Fly|Ride"] = 69.57, ["Neon"] = 81.93, ["Neon|Ride"] = 89.8, ["Neon|Fly|Ride"] = 177.5, ["Mega"] = 656.25, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 668.21}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.77, ["Fly"] = 94.67, ["Ride"] = 47.34, ["Fly|Ride"] = 104.66, ["Neon"] = 204.75, ["Neon|Fly"] = 416.64, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 1810.4, ["Mega|Ride"] = 1073.5, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 760.22, ["Ride"] = 788.65, ["Fly|Ride"] = 840, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2450.44, ["Mega|Fly|Ride"] = 31561.88}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5067.86, ["Fly|Ride"] = 4038.57, ["Neon"] = 42000, ["Neon|Ride"] = 29923.68, ["Neon|Fly|Ride"] = 21856.27, ["Mega|Fly|Ride"] = 89093.43}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 180.08, ["Fly"] = 278.77, ["Ride"] = 271.47, ["Neon"] = 1301.61, ["Neon|Fly|Ride"] = 1392.79, ["Mega"] = 5845.69, ["Mega|Fly|Ride"] = 5986.62}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Fly"] = 278.77, ["Ride"] = 78.74, ["Fly|Ride"] = 336, ["Neon"] = 328.67, ["Neon|Ride"] = 488, ["Neon|Fly|Ride"] = 975.16, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.48, ["Fly"] = 131.25, ["Ride"] = 38.66, ["Fly|Ride"] = 104.99, ["Neon"] = 111.57, ["Neon|Ride"] = 85.03, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 696.4, ["Mega|Ride"] = 626.45, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.74, ["Fly"] = 38.07, ["Ride"] = 31.96, ["Fly|Ride"] = 52.4, ["Neon|Ride"] = 278.77, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.74, ["Fly"] = 278.77, ["Ride"] = 40.24, ["Fly|Ride"] = 111.24, ["Neon"] = 98.17, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 215.28, ["Mega"] = 549.94, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.49, ["Fly"] = 56.4, ["Ride"] = 22.3, ["Fly|Ride"] = 57.75, ["Neon"] = 32.81, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 178.5, ["Mega|Ride"] = 177.55, ["Mega|Fly|Ride"] = 308.01}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.66, ["Ride"] = 77.27, ["Fly|Ride"] = 183.75, ["Neon"] = 162.91, ["Neon|Fly"] = 835.35, ["Neon|Ride"] = 198.39, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 689.1, ["Mega|Ride"] = 710.15, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 308.3, ["Fly"] = 337.32, ["Ride"] = 306.42, ["Fly|Ride"] = 367.5, ["Neon"] = 1419.94, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6562.5, ["Mega|Ride"] = 3619.75, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.49, ["Fly"] = 22.98, ["Ride"] = 14.34, ["Fly|Ride"] = 32.81, ["Neon"] = 20.9, ["Neon|Ride"] = 34.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 290.27, ["Mega|Ride"] = 221.34, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.6, ["Fly"] = 104.63, ["Ride"] = 62.99, ["Fly|Ride"] = 118.12, ["Neon"] = 161.97, ["Neon|Fly"] = 278.81, ["Neon|Ride"] = 174.45, ["Neon|Fly|Ride"] = 253.49, ["Mega"] = 631.21, ["Mega|Fly"] = 835.26, ["Mega|Ride"] = 506.7, ["Mega|Fly|Ride"] = 569.91}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.88, ["Fly"] = 937.16, ["Ride"] = 630, ["Fly|Ride"] = 694.32, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 3971.18}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 36.9, ["Fly"] = 91.88, ["Ride"] = 42, ["Fly|Ride"] = 101.07, ["Neon"] = 189.33, ["Neon|Fly"] = 473.37, ["Neon|Ride"] = 224.89, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 738.17}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 341.42, ["Ride"] = 262.29, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 975.16, ["Neon|Fly|Ride"] = 1019.82, ["Mega"] = 5997.09, ["Mega|Fly|Ride"] = 6959.69}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.24, ["Fly"] = 139.02, ["Ride"] = 129.94, ["Fly|Ride"] = 157.5, ["Neon"] = 557.61, ["Neon|Ride"] = 682.83, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 551.25, ["Ride"] = 557.53, ["Fly|Ride"] = 689.07, ["Neon|Ride"] = 2294.85, ["Neon|Fly|Ride"] = 2248.77, ["Mega|Fly|Ride"] = 7934.83}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.81, ["Ride"] = 41.77, ["Fly|Ride"] = 96.07, ["Neon"] = 78.75, ["Neon|Fly"] = 284.03, ["Neon|Ride"] = 103.37, ["Neon|Fly|Ride"] = 189.38, ["Mega"] = 262.48, ["Mega|Ride"] = 369.62, ["Mega|Fly|Ride"] = 376.39}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3707.46, ["Fly"] = 4016.04, ["Ride"] = 3707.46, ["Fly|Ride"] = 2887.49, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 104.42, ["Fly"] = 125.3, ["Ride"] = 108.88, ["Fly|Ride"] = 149.63, ["Neon"] = 461.49, ["Neon|Ride"] = 461.61, ["Neon|Fly|Ride"] = 492.93, ["Mega|Fly|Ride"] = 1736.28}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.29, ["Fly"] = 26.1, ["Ride"] = 19.69, ["Fly|Ride"] = 40.69, ["Neon"] = 23.62, ["Neon|Fly"] = 82.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 170.61, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.88, ["Ride"] = 27.98, ["Neon"] = 20.96, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.44, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 278.77, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 77.33, ["Fly"] = 90.76, ["Ride"] = 39.38, ["Fly|Ride"] = 76.13, ["Neon"] = 276.9, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 265.2, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1035.71, ["Ride"] = 1160.8, ["Fly|Ride"] = 1050, ["Neon"] = 5707.86, ["Neon|Fly|Ride"] = 6250.78}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5511.19, ["Ride"] = 5916.38, ["Fly|Ride"] = 5250}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.07, ["Fly"] = 35.51, ["Ride"] = 24.19, ["Fly|Ride"] = 51.18, ["Neon"] = 261.86, ["Neon|Ride"] = 271.45, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.07, ["Fly"] = 46.1, ["Ride"] = 32.82, ["Fly|Ride"] = 74.04, ["Neon"] = 88.83, ["Neon|Ride"] = 89.45, ["Neon|Fly|Ride"] = 175.62, ["Mega"] = 642.48, ["Mega|Ride"] = 529.35, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 58.44, ["Fly"] = 157.5, ["Ride"] = 65.62, ["Fly|Ride"] = 101.07, ["Neon"] = 328.12, ["Neon|Ride"] = 348.73, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 1670.5, ["Mega|Ride"] = 1810.4, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 212.12, ["Fly"] = 315.95, ["Ride"] = 234.3, ["Fly|Ride"] = 249.37, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 872.86, ["Mega"] = 10440.56, ["Mega|Fly|Ride"] = 3598.88}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.97, ["Ride"] = 36.46, ["Fly|Ride"] = 86.63, ["Neon"] = 41.77, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 92.42, ["Mega"] = 154.88, ["Mega|Ride"] = 163.61, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.31, ["Fly"] = 255.55, ["Ride"] = 216.57, ["Fly|Ride"] = 325.76, ["Neon"] = 875.64, ["Neon|Ride"] = 875.84, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3698.06}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 19.85, ["Ride"] = 17.04, ["Fly|Ride"] = 39.38, ["Neon"] = 21.73, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 83.54, ["Mega"] = 276.96, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 239.48}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 261.03, ["Neon"] = 789.32, ["Neon|Ride"] = 814.38, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 10439.52, ["Mega|Ride"] = 4176.23, ["Mega|Fly|Ride"] = 4162.66}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.34, ["Fly"] = 75.89, ["Ride"] = 27.09, ["Fly|Ride"] = 56.27, ["Neon"] = 90.85, ["Neon|Fly"] = 300.59, ["Neon|Ride"] = 96.07, ["Neon|Fly|Ride"] = 273.41, ["Mega"] = 524.33, ["Mega|Ride"] = 584.68, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.43, ["Ride"] = 22.23, ["Fly|Ride"] = 86.63, ["Neon"] = 11.46, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 61.16, ["Neon|Fly|Ride"] = 137.84, ["Mega"] = 87.84, ["Mega|Ride"] = 99, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.62, ["Neon"] = 2.89, ["Mega"] = 20.9, ["Mega|Ride"] = 139.69}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.6, ["Ride"] = 313.23, ["Fly|Ride"] = 139.93, ["Neon"] = 7.13, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 77.44, ["Mega|Fly"] = 157808.17, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.52, ["Fly"] = 136.83, ["Ride"] = 115.12, ["Fly|Ride"] = 187.94, ["Neon"] = 301.79, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 359.33, ["Mega"] = 1085.83, ["Mega|Fly|Ride"] = 1281.04}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.71, ["Ride"] = 15.88, ["Neon"] = 12.53, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 110.9, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 27.57, ["Ride"] = 111.64, ["Fly|Ride"] = 186.97, ["Neon"] = 63, ["Neon|Ride"] = 96.07, ["Mega"] = 383.25, ["Mega|Ride"] = 620.18, ["Mega|Fly|Ride"] = 621.11}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.34, ["Neon"] = 2.1, ["Neon|Ride"] = 39.48, ["Neon|Fly|Ride"] = 254.16, ["Mega"] = 23.39, ["Mega|Ride"] = 60.37, ["Mega|Fly|Ride"] = 185.97}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.79, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 35.53, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 38.92, ["Mega"] = 15.72, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 60.29}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.67, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 56.76, ["Mega"] = 17.64, ["Mega|Fly"] = 94.99, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 125.3, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 78.64, ["Mega"] = 16.31, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 209.42}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 16.56, ["Fly|Ride"] = 107.62, ["Neon"] = 3.56, ["Neon|Fly"] = 137.84, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 32.39, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 73.57, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.67, ["Neon|Fly|Ride"] = 189.35, ["Mega"] = 27.95, ["Mega|Ride"] = 93.14}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 54.48, ["Ride"] = 17.07, ["Fly|Ride"] = 39.37, ["Neon"] = 8.44, ["Neon|Fly"] = 53.45, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 72.09, ["Mega"] = 58.97, ["Mega|Fly"] = 160.44, ["Mega|Ride"] = 77.01, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 44.65, ["Neon"] = 2.24, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 18.26, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 55.64, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.94, ["Fly|Ride"] = 524.99, ["Neon"] = 21.35, ["Mega"] = 279.51, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.84, ["Ride"] = 27.57, ["Neon"] = 20.9, ["Neon|Ride"] = 31.34, ["Mega"] = 98.16, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.52, ["Ride"] = 32.82, ["Neon"] = 5.24, ["Neon|Ride"] = 26.7, ["Neon|Fly|Ride"] = 111.72, ["Mega"] = 31.98, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 30.08, ["Neon"] = 2.1, ["Neon|Fly"] = 27.17, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 37.89, ["Mega"] = 15.72, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 28.42, ["Mega|Fly|Ride"] = 77.27}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 35.44, ["Neon|Ride"] = 41.77, ["Mega"] = 265.2}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 17.94, ["Fly|Ride"] = 78.74, ["Neon"] = 3.61, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 28.77, ["Mega|Ride"] = 139.55, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.99, ["Neon"] = 9.49, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 91.77, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.24, ["Ride"] = 32.81, ["Fly|Ride"] = 190.03, ["Neon"] = 27.23, ["Neon|Ride"] = 79.32, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 222.49, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 111.72}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.35, ["Ride"] = 12.77, ["Fly|Ride"] = 24.45, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 26.17, ["Mega"] = 14.23, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 20.88, ["Mega|Fly|Ride"] = 87.66}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 24.45, ["Ride"] = 19.65, ["Fly|Ride"] = 86.63, ["Neon"] = 15.37, ["Neon|Ride"] = 113.64, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 209.42}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 17.14, ["Fly|Ride"] = 58.46, ["Neon"] = 15.47, ["Neon|Ride"] = 111.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.2, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 390.47}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.67, ["Ride"] = 14.81, ["Fly|Ride"] = 36.66, ["Neon"] = 2.61, ["Neon|Fly"] = 19.22, ["Neon|Ride"] = 15.68, ["Neon|Fly|Ride"] = 39.04, ["Mega"] = 20.79, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 96.9}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.3, ["Fly"] = 174.37, ["Ride"] = 60.37, ["Fly|Ride"] = 63, ["Neon"] = 6.36, ["Neon|Fly"] = 77.27, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.37, ["Mega|Fly"] = 167.07, ["Mega|Ride"] = 82.87}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.51, ["Ride"] = 26.72, ["Fly|Ride"] = 58.48, ["Neon"] = 3.83, ["Neon|Fly"] = 108.94, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 32.81, ["Mega|Ride"] = 94.7, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.86, ["Neon"] = 2.1, ["Neon|Fly"] = 41.5, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 83.54, ["Mega"] = 18.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 175.93}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.16, ["Ride"] = 17.06, ["Fly|Ride"] = 42.02, ["Neon"] = 6.97, ["Neon|Fly"] = 45.95, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 67.11, ["Mega"] = 79.32, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 265.2}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 104.9, ["Neon"] = 3.55, ["Neon|Ride"] = 42.42, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 40.69, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 349.17}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 16.17, ["Fly|Ride"] = 43.32, ["Neon"] = 6.48, ["Neon|Fly"] = 69.91, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 89.21, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 4.73, ["Ride"] = 82.69, ["Neon"] = 36.16, ["Mega|Fly|Ride"] = 835.26}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 27.17, ["Ride"] = 15.22, ["Fly|Ride"] = 69.98, ["Neon"] = 12.93, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 157.5, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 320.54}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.91, ["Fly"] = 23.61, ["Ride"] = 34.2, ["Fly|Ride"] = 62.66, ["Neon"] = 14, ["Neon|Fly"] = 61.63, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 111.72, ["Mega"] = 105, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 96.3, ["Fly|Ride"] = 106.84, ["Neon"] = 19.59, ["Mega"] = 167.07, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.54, ["Ride"] = 131.25, ["Neon|Ride"] = 236.73, ["Mega"] = 934.44, ["Mega|Ride"] = 936.53, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 56.4, ["Neon"] = 41.11, ["Neon|Ride"] = 78.75, ["Mega"] = 225.53, ["Mega|Ride"] = 273.67, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.8, ["Ride"] = 43.32, ["Fly|Ride"] = 139.13, ["Neon"] = 74.17, ["Neon|Ride"] = 83.48, ["Mega"] = 473.44, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 64.99, ["Mega"] = 19.59, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.55, ["Fly"] = 20.82, ["Ride"] = 19.49, ["Fly|Ride"] = 42, ["Neon"] = 15.68, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 82.49, ["Mega"] = 282.18, ["Mega|Fly"] = 334.11, ["Mega|Ride"] = 276.24, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 65.63, ["Neon"] = 19, ["Neon|Ride"] = 26.55, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 27.57, ["Mega|Ride"] = 111.95, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.41, ["Ride"] = 36.71, ["Fly|Ride"] = 395.3, ["Neon"] = 5.25, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 406.66, ["Mega"] = 58.11, ["Mega|Ride"] = 69.51, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.29, ["Fly"] = 45.93, ["Ride"] = 18.65, ["Fly|Ride"] = 55.65, ["Neon"] = 11.17, ["Neon|Ride"] = 40.91, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 141.74, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.45, ["Ride"] = 32.01, ["Neon"] = 34.38, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 278.77, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 49.08, ["Mega"] = 20.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 277.73}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 19.85, ["Ride"] = 15.09, ["Fly|Ride"] = 278415.09, ["Neon"] = 5.15, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.1, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 38.68, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 65.39, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 19.71, ["Ride"] = 17.05, ["Fly|Ride"] = 32.76, ["Neon"] = 7.75, ["Neon|Fly"] = 69.98, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 47.83, ["Mega|Ride"] = 51.32, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 79.29, ["Neon"] = 3.81, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 107.82, ["Mega"] = 22.23, ["Mega|Fly"] = 104.43, ["Mega|Ride"] = 48.65, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 8.36, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 169.16, ["Mega"] = 35.49, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 79.8, ["Mega|Fly|Ride"] = 208.82}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 22.5, ["Fly|Ride"] = 34.13, ["Neon"] = 4.18, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 24.56, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 118.37}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 49.08, ["Neon"] = 2.1, ["Mega"] = 18.27, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.36, ["Neon|Ride"] = 158.62, ["Mega"] = 26.25, ["Mega|Fly"] = 118.37, ["Mega|Ride"] = 120.08}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.21, ["Ride"] = 16.05, ["Fly|Ride"] = 69.57, ["Neon"] = 3.89, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 125.91, ["Mega"] = 54.46, ["Mega|Ride"] = 41.77, ["Mega|Fly|Ride"] = 102.99}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 24.03, ["Ride"] = 137.76, ["Neon"] = 95.81, ["Neon|Ride"] = 236.7, ["Mega"] = 354.38, ["Mega|Ride"] = 450.19, ["Mega|Fly|Ride"] = 766.35}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.13, ["Fly"] = 6562.5, ["Ride"] = 68.24, ["Neon"] = 41.43, ["Neon|Ride"] = 206.73, ["Mega"] = 1590.1, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.62, ["Ride"] = 26.24, ["Fly|Ride"] = 417.63, ["Neon"] = 18.77, ["Mega"] = 274.32, ["Mega|Ride"] = 156.24, ["Mega|Fly|Ride"] = 265.6}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.76, ["Ride"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 13.12, ["Neon|Fly|Ride"] = 44.59, ["Mega"] = 103.95, ["Mega|Fly"] = 44.88, ["Mega|Ride"] = 25.08, ["Mega|Fly|Ride"] = 54.94}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 18.81, ["Fly|Ride"] = 69.98, ["Neon"] = 6.91, ["Neon|Fly"] = 91.9, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 696.4, ["Mega"] = 83.63, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 111.27}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 102.34, ["Mega"] = 16.96, ["Mega|Fly"] = 63.91, ["Mega|Ride"] = 58.97, ["Mega|Fly|Ride"] = 100.01}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.88, ["Mega"] = 23.69, ["Mega|Ride"] = 112.77, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 3.93, ["Fly"] = 20.75, ["Ride"] = 21, ["Fly|Ride"] = 45.95, ["Neon"] = 10.18, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 147.89, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 278.77}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 150.67, ["Ride"] = 157.49, ["Fly|Ride"] = 262.5, ["Neon"] = 1016.93, ["Neon|Ride"] = 973.88, ["Neon|Fly|Ride"] = 1114.02, ["Mega"] = 8352.46, ["Mega|Ride"] = 3132.18, ["Mega|Fly|Ride"] = 3327.42}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.52, ["Neon"] = 6.18, ["Neon|Fly"] = 56.4, ["Neon|Ride"] = 68.25, ["Mega"] = 87.71, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.82, ["Fly"] = 103.68, ["Ride"] = 31.96, ["Fly|Ride"] = 140.2, ["Neon"] = 15.65, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 157.67, ["Mega"] = 350.83, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1044.07}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.66, ["Fly|Ride"] = 38.06, ["Neon"] = 6.56, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 57.75, ["Mega|Fly"] = 94.7, ["Mega|Ride"] = 61.85, ["Mega|Fly|Ride"] = 139.93}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 17.95, ["Fly|Ride"] = 121.03, ["Neon"] = 7.11, ["Neon|Fly"] = 83.54, ["Neon|Ride"] = 103.37, ["Mega"] = 95.7, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 584.68}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 5.13, ["Fly"] = 26.24, ["Ride"] = 18.35, ["Fly|Ride"] = 39.37, ["Neon"] = 32.45, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 208.82, ["Mega|Ride"] = 278.77, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.84, ["Fly"] = 41.77, ["Ride"] = 41.77, ["Fly|Ride"] = 249.58, ["Neon"] = 27.57, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 620.18, ["Mega"] = 333.38, ["Mega|Ride"] = 352.72, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.94, ["Fly"] = 20.93, ["Ride"] = 16.71, ["Fly|Ride"] = 39.37, ["Neon"] = 17.76, ["Neon|Fly"] = 62.67, ["Neon|Ride"] = 30.79, ["Neon|Fly|Ride"] = 76.13, ["Mega|Fly"] = 207.79, ["Mega|Ride"] = 417.63, ["Mega|Fly|Ride"] = 212.98}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.09, ["Fly"] = 120.08, ["Ride"] = 98.44, ["Fly|Ride"] = 131.25, ["Neon"] = 454.39, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 479.07, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 208.82, ["Fly"] = 322.18, ["Ride"] = 234.3, ["Fly|Ride"] = 275.63, ["Neon"] = 911.14, ["Neon|Ride"] = 1461.69, ["Neon|Fly|Ride"] = 1204.54, ["Mega"] = 10440.56, ["Mega|Fly|Ride"] = 4023.81}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.42, ["Fly"] = 139.93, ["Ride"] = 78.75, ["Fly|Ride"] = 131.24, ["Neon"] = 383.09, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1252.89, ["Mega|Fly|Ride"] = 1207.89}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.57, ["Fly"] = 26.24, ["Ride"] = 31.34, ["Fly|Ride"] = 139.93, ["Neon"] = 26.25, ["Neon|Ride"] = 52.22, ["Neon|Fly|Ride"] = 125.71, ["Mega"] = 192.93, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 344.56}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 16.78, ["Fly"] = 68.4, ["Ride"] = 30.72, ["Fly|Ride"] = 85.32, ["Neon"] = 129.69, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 142.05, ["Mega"] = 351.75, ["Mega|Ride"] = 450.01, ["Mega|Fly|Ride"] = 571.11}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.09, ["Ride"] = 15.67, ["Fly|Ride"] = 41.77, ["Neon"] = 4.76, ["Neon|Fly"] = 23.45, ["Neon|Ride"] = 20.73, ["Neon|Fly|Ride"] = 41.77, ["Mega"] = 49.77, ["Mega|Fly"] = 210.7, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.81, ["Fly"] = 72.12, ["Ride"] = 21.94, ["Fly|Ride"] = 139.93, ["Neon"] = 48.56, ["Neon|Ride"] = 158.71, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 799.76, ["Mega|Ride"] = 626.45, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.63, ["Fly"] = 30.54, ["Ride"] = 18.81, ["Fly|Ride"] = 63.91, ["Neon"] = 9.51, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 94.58, ["Mega"] = 131.25, ["Mega|Ride"] = 158.62, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.71, ["Ride"] = 28.21, ["Fly|Ride"] = 126.62, ["Neon"] = 237.04, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 207.37, ["Mega|Ride"] = 207.79, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 15.64, ["Mega|Ride"] = 37.71, ["Mega|Fly|Ride"] = 223.47}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.84, ["Fly"] = 45.94, ["Ride"] = 20.92, ["Fly|Ride"] = 35.51, ["Neon"] = 13.12, ["Neon|Fly"] = 104.44, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 98, ["Mega"] = 108.94, ["Mega|Ride"] = 83.88, ["Mega|Fly|Ride"] = 194.07}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Fly"] = 24.93, ["Ride"] = 18.27, ["Fly|Ride"] = 45.85, ["Neon"] = 13.13, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 154.53, ["Mega|Fly|Ride"] = 226.08}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 161.43, ["Fly"] = 208.27, ["Ride"] = 227.06, ["Fly|Ride"] = 280.68, ["Neon"] = 700.88, ["Neon|Ride"] = 696.4, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.46, ["Ride"] = 240.92, ["Fly|Ride"] = 206.07, ["Neon"] = 66.94, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 208.82, ["Mega"] = 313.74, ["Mega|Ride"] = 417.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 19.58, ["Fly|Ride"] = 56.58, ["Neon"] = 27.2, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 199.5, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 274.61}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.36, ["Ride"] = 36.98, ["Fly|Ride"] = 178.5, ["Neon"] = 103.13, ["Neon|Ride"] = 138.14, ["Neon|Fly|Ride"] = 322.49, ["Mega"] = 494.25, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 682.83}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.16}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.35, ["Ride"] = 35.51, ["Neon"] = 39.64, ["Neon|Ride"] = 151.52, ["Neon|Fly|Ride"] = 626.45, ["Mega"] = 236.25, ["Mega|Ride"] = 360.82, ["Mega|Fly|Ride"] = 416.59}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.69, ["Fly"] = 77.67, ["Ride"] = 31.48, ["Fly|Ride"] = 44.62, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 158.62, ["Neon|Fly|Ride"] = 178.8, ["Mega"] = 522.04, ["Mega|Fly|Ride"] = 693.27}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Fly|Ride"] = 65.62, ["Neon"] = 3.34, ["Neon|Ride"] = 53.26, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 31.5, ["Mega|Fly"] = 413.45, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 158.62}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.56, ["Fly"] = 27.09, ["Ride"] = 28.21, ["Fly|Ride"] = 112.54, ["Neon|Ride"] = 236.73, ["Mega"] = 221.17, ["Mega|Fly"] = 395.32, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 3.19, ["Fly"] = 44.9, ["Ride"] = 21, ["Fly|Ride"] = 45.65, ["Neon"] = 13.41, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 124.69, ["Mega|Ride"] = 154.53, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 18.81, ["Neon"] = 3.9, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 31.34, ["Mega|Ride"] = 78.31, ["Mega|Fly|Ride"] = 158.62}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 25.99, ["Ride"] = 73.38, ["Neon"] = 175.27, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 824.95, ["Mega|Ride"] = 1013.14, ["Mega|Fly|Ride"] = 924.95}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.82, ["Ride"] = 52.5, ["Neon"] = 80.07, ["Neon|Ride"] = 83.54, ["Neon|Fly|Ride"] = 208.82, ["Mega"] = 277.73, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 19.69, ["Fly"] = 139.54, ["Ride"] = 131.25, ["Fly|Ride"] = 125.3, ["Neon"] = 51.96, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 57.99, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 278.77}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.66, ["Fly"] = 433.13, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 404.07, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 620.18, ["Mega"] = 1252.89, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.31, ["Fly"] = 39.38, ["Ride"] = 28.74, ["Fly|Ride"] = 56.4, ["Neon"] = 63, ["Neon|Ride"] = 57.84, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 249.6, ["Mega|Ride"] = 300.64, ["Mega|Fly|Ride"] = 334.11}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 80.56, ["Fly"] = 139.93, ["Ride"] = 71.01, ["Fly|Ride"] = 167.07, ["Neon"] = 203.44, ["Neon|Ride"] = 285.05, ["Neon|Fly|Ride"] = 315, ["Mega"] = 898.15, ["Mega|Ride"] = 1006.04, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.94, ["Fly"] = 69.98, ["Ride"] = 69.98, ["Fly|Ride"] = 173.25, ["Neon"] = 80.27, ["Neon|Ride"] = 125.3, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 261.19, ["Mega|Ride"] = 297.53, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.3, ["Fly"] = 69.51, ["Ride"] = 27.17, ["Fly|Ride"] = 41.77, ["Neon"] = 82.68, ["Neon|Ride"] = 58.95, ["Neon|Fly|Ride"] = 376.39, ["Mega"] = 208.82, ["Mega|Ride"] = 1044.07, ["Mega|Fly|Ride"] = 402.42}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 27.2, ["Ride"] = 69.98, ["Fly|Ride"] = 119.85, ["Neon"] = 85.31, ["Neon|Ride"] = 125.3, ["Neon|Fly|Ride"] = 278.5, ["Mega"] = 365.46, ["Mega|Fly"] = 504.3, ["Mega|Ride"] = 349.88, ["Mega|Fly|Ride"] = 475.79}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 11.82, ["Ride"] = 32.39, ["Fly|Ride"] = 135.61, ["Neon"] = 38.68, ["Neon|Ride"] = 96.07, ["Neon|Fly|Ride"] = 136.79, ["Mega"] = 300.64, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 54.31, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 100.25, ["Mega"] = 15.49, ["Mega|Fly"] = 139.93, ["Mega|Fly|Ride"] = 189.38}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.61, ["Ride"] = 20.9, ["Neon"] = 17.07, ["Neon|Fly"] = 125.31, ["Neon|Ride"] = 83.54, ["Mega"] = 112.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.52, ["Ride"] = 27.57, ["Neon"] = 23.61, ["Neon|Ride"] = 103.37, ["Mega"] = 196.23, ["Mega|Ride"] = 139.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.42, ["Ride"] = 31.5, ["Fly|Ride"] = 117.16, ["Neon"] = 14.44, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 271.47, ["Mega"] = 123.37, ["Mega|Ride"] = 158.62, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.34, ["Fly"] = 625.41, ["Ride"] = 568.32, ["Fly|Ride"] = 589.31, ["Neon|Ride"] = 1225.4, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.07, ["Fly"] = 27.75, ["Ride"] = 25.08, ["Fly|Ride"] = 53.86, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Mega|Ride"] = 348.73}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 10.45, ["Fly"] = 39.38, ["Ride"] = 26.65, ["Fly|Ride"] = 52.5, ["Neon"] = 52.49, ["Neon|Ride"] = 119.69, ["Mega"] = 263.11, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 328.11}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.15, ["Ride"] = 17.07, ["Fly|Ride"] = 313.23, ["Neon"] = 28.21, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 236.25, ["Mega|Ride"] = 632.04, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 54.12, ["Ride"] = 30.18, ["Fly|Ride"] = 90.57, ["Neon"] = 7.66, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 119.03, ["Mega"] = 57.18, ["Mega|Ride"] = 95.17, ["Mega|Fly|Ride"] = 213}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.98, ["Ride"] = 19.68, ["Neon"] = 3.93, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 74.13, ["Mega"] = 26.25, ["Mega|Ride"] = 54.76, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1506.59}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.45, ["Ride"] = 20.9, ["Fly|Ride"] = 68.81, ["Neon"] = 74.84, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 167.07, ["Mega|Ride"] = 835.26, ["Mega|Fly|Ride"] = 831.08}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 6.78, ["Neon|Ride"] = 40.69, ["Mega"] = 38.66, ["Mega|Ride"] = 144.09, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.09, ["Fly"] = 98.16, ["Ride"] = 24.01, ["Fly|Ride"] = 574.39, ["Neon"] = 10.49, ["Neon|Fly"] = 125.31, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 126.66, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 417.63, ["Ride"] = 418.69, ["Fly|Ride"] = 433.13, ["Neon|Ride"] = 1534.32, ["Neon|Fly|Ride"] = 1715.4, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.16, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 82.43, ["Mega"] = 390.93, ["Mega|Ride"] = 449.77}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly|Ride"] = 87.71, ["Neon"] = 4.49, ["Neon|Ride"] = 37.96, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 40.59, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 139.93}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 835.26, ["Neon"] = 2.62, ["Neon|Ride"] = 47.36, ["Neon|Fly|Ride"] = 265.2, ["Mega"] = 22.99, ["Mega|Ride"] = 108.3, ["Mega|Fly|Ride"] = 221.36}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.03, ["Fly"] = 56.4, ["Ride"] = 28.18, ["Fly|Ride"] = 174.37, ["Neon"] = 65.3, ["Neon|Ride"] = 111.72, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 417.63, ["Mega|Fly|Ride"] = 414.31}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.49, ["Ride"] = 111.72, ["Neon"] = 92.31, ["Neon|Ride"] = 111.72, ["Neon|Fly|Ride"] = 835.26, ["Mega"] = 393.75, ["Mega|Ride"] = 348.73, ["Mega|Fly|Ride"] = 1076.93}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.57, ["Ride"] = 31.19, ["Fly|Ride"] = 139.93, ["Neon"] = 105, ["Neon|Ride"] = 94.7, ["Mega"] = 626.45, ["Mega|Ride"] = 696.56, ["Mega|Fly|Ride"] = 1253.44}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 27.2, ["Ride"] = 52.07, ["Neon"] = 69.57, ["Neon|Ride"] = 181.91, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 459.38, ["Mega|Ride"] = 590.94, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 416.59, ["Fly|Ride"] = 616.88, ["Neon"] = 1211.12, ["Neon|Fly"] = 1199.93, ["Neon|Ride"] = 1531.64, ["Neon|Fly|Ride"] = 1278.25, ["Mega|Fly|Ride"] = 3340.99}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.35, ["Fly"] = 69.65, ["Ride"] = 23.62, ["Fly|Ride"] = 236.25, ["Neon"] = 89.88, ["Neon|Ride"] = 139.93, ["Neon|Fly|Ride"] = 160.8, ["Mega"] = 557.53, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 826.9}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 28.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 789.45}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 13.12, ["Ride"] = 73.49, ["Fly|Ride"] = 251.3, ["Neon"] = 48.16, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 158.62, ["Mega"] = 237.28, ["Mega|Fly"] = 417.63, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.51, ["Ride"] = 42, ["Fly|Ride"] = 125.3, ["Neon"] = 11.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 207.79, ["Mega"] = 55.64, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 81.45, ["Mega|Fly|Ride"] = 139.93}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 47.35, ["Ride"] = 131.25, ["Neon"] = 207.81, ["Neon|Ride"] = 245.31, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 1808.31, ["Mega|Ride"] = 1336.41, ["Mega|Fly|Ride"] = 1347.89}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.61, ["Fly"] = 52.5, ["Ride"] = 53.26, ["Neon"] = 9, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 52.22, ["Neon|Fly|Ride"] = 137.84, ["Mega"] = 85.32, ["Mega|Ride"] = 106.22, ["Mega|Fly|Ride"] = 213}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.77, ["Ride"] = 20.9, ["Fly|Ride"] = 91.88, ["Neon"] = 4.55, ["Neon|Fly"] = 417.68, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 34.13, ["Mega|Fly"] = 157.4, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 150.1}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 8.36, ["Ride"] = 38.07, ["Fly|Ride"] = 111.72, ["Neon"] = 98.16, ["Mega"] = 417.63, ["Mega|Fly|Ride"] = 766.35}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 52.41, ["Fly"] = 69.98, ["Ride"] = 65.63, ["Neon"] = 334.11, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 625.41, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.49, ["Ride"] = 309.74, ["Fly|Ride"] = 349.13, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 5846.72, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 15.71, ["Ride"] = 47.34, ["Fly|Ride"] = 77.44, ["Neon"] = 41.91, ["Neon|Ride"] = 62.66, ["Mega"] = 86.63, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Neon"] = 24.94, ["Neon|Ride"] = 59.99, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 79.32, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 155.57, ["Ride"] = 20.56, ["Fly|Ride"] = 177.51, ["Neon"] = 33.43, ["Mega"] = 519.1, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.78, ["Ride"] = 19.85, ["Fly|Ride"] = 87.71, ["Neon"] = 5.38, ["Neon|Ride"] = 35.33, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 43.61, ["Mega|Ride"] = 75.18, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.43, ["Ride"] = 33.43, ["Fly|Ride"] = 278.77, ["Neon"] = 8.27, ["Mega"] = 52.5, ["Mega|Fly"] = 139.93, ["Mega|Ride"] = 206.73, ["Mega|Fly|Ride"] = 274.61}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.72, ["Fly|Ride"] = 41.95, ["Neon"] = 3.9, ["Neon|Fly"] = 45.12, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 51.45, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 132.61}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.62, ["Fly"] = 90.36, ["Ride"] = 20.79, ["Fly|Ride"] = 56.4, ["Neon"] = 7.61, ["Neon|Fly"] = 87.59, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.89, ["Mega"] = 156.13, ["Mega|Ride"] = 208.82, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 40.68, ["Ride"] = 45.02, ["Mega"] = 420, ["Mega|Fly"] = 525, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 647.42}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 82.21, ["Fly"] = 582.75, ["Ride"] = 115.98, ["Fly|Ride"] = 160.13, ["Neon"] = 340.05, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 522.04, ["Mega"] = 3156.56, ["Mega|Ride"] = 1412.25, ["Mega|Fly|Ride"] = 1810.4}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 35.43, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 63.92, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 348.73}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 15.72, ["Fly|Ride"] = 35.42, ["Neon"] = 3.82, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 19.85, ["Neon|Fly|Ride"] = 69.81, ["Mega"] = 48.45, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.22, ["Ride"] = 51.19, ["Fly|Ride"] = 139.93, ["Neon"] = 65.63, ["Neon|Ride"] = 44.9, ["Neon|Fly|Ride"] = 167.07, ["Mega"] = 626.82, ["Mega|Ride"] = 404.07, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 367.5, ["Fly"] = 393.74, ["Ride"] = 417.63, ["Fly|Ride"] = 473.32, ["Neon|Ride"] = 1810.4, ["Mega|Fly|Ride"] = 6681.96}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 39.38, ["Fly"] = 128.31, ["Ride"] = 52.5, ["Neon"] = 249.38, ["Neon|Ride"] = 205.95, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 1183.97, ["Mega|Fly|Ride"] = 1183.56}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 2088.13, ["Fly|Ride"] = 78.75, ["Neon"] = 9.95, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 98.16, ["Mega"] = 72.19, ["Mega|Ride"] = 113.13, ["Mega|Fly|Ride"] = 244.32}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.62, ["Fly"] = 208.82, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 69.98, ["Neon|Ride"] = 167.07, ["Mega"] = 194.21, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.24, ["Fly"] = 76.89, ["Ride"] = 39.37, ["Fly|Ride"] = 65.62, ["Neon"] = 128.63, ["Neon|Ride"] = 237.58, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2505.76, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 975.16}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 128.63, ["Ride"] = 139.93, ["Fly|Ride"] = 140.21, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3063.26, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 227.07, ["Fly"] = 278.09, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 899.31, ["Neon|Ride"] = 870.76, ["Neon|Fly|Ride"] = 1040.93, ["Mega"] = 3178.12, ["Mega|Fly|Ride"] = 3192.74}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.44, ["Ride"] = 51.07, ["Fly|Ride"] = 59.07, ["Neon"] = 69.98, ["Neon|Ride"] = 126.66, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 355.6, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 475.07}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.21, ["Ride"] = 16.28, ["Fly|Ride"] = 40.24, ["Neon"] = 15.69, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 63.92, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.92, ["Fly"] = 17.76, ["Ride"] = 20.9, ["Fly|Ride"] = 639.77, ["Neon"] = 47.34, ["Neon|Fly"] = 146.21, ["Neon|Ride"] = 47.49, ["Neon|Fly|Ride"] = 104.43, ["Mega"] = 288.75, ["Mega|Ride"] = 255.46, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 309.74, ["Fly"] = 487.58, ["Ride"] = 348.73, ["Fly|Ride"] = 406.88, ["Neon"] = 1371.9, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1893.71, ["Mega|Ride"] = 4455, ["Mega|Fly|Ride"] = 4593.86}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 6.09, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 78.75, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 415.54}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.86, ["Ride"] = 18.38, ["Fly|Ride"] = 62.65, ["Neon"] = 40.81, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 159.01, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 29.63, ["Ride"] = 104.43, ["Neon"] = 105, ["Neon|Fly"] = 417.68, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 320.54, ["Mega"] = 471.19, ["Mega|Ride"] = 494.9, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 138.53, ["Fly"] = 277.73, ["Ride"] = 153.57, ["Fly|Ride"] = 236.66, ["Neon|Ride"] = 738.17, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.07, ["Fly"] = 46.04, ["Ride"] = 32.39, ["Fly|Ride"] = 50.94, ["Neon"] = 91.88, ["Neon|Ride"] = 102.34, ["Neon|Fly|Ride"] = 136.79, ["Mega"] = 626.45, ["Mega|Ride"] = 495.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.63, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 696.4, ["Mega"] = 21, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 3.89, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 27.57, ["Mega|Fly"] = 140.86, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.34, ["Fly"] = 417.63, ["Ride"] = 66.75, ["Fly|Ride"] = 137.31, ["Neon"] = 26.19, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 111.27, ["Mega"] = 150.94, ["Mega|Ride"] = 180.23, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1305.94, ["Ride"] = 1291.22, ["Fly|Ride"] = 1370.25, ["Neon"] = 4200, ["Neon|Ride"] = 6960.73, ["Neon|Fly|Ride"] = 4663.81, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 409.29, ["Ride"] = 420, ["Fly|Ride"] = 472.5, ["Neon"] = 1827.74, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1629.21, ["Mega"] = 16704.91, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 297.04, ["Fly"] = 404.07, ["Ride"] = 324.74, ["Fly|Ride"] = 443.63, ["Neon"] = 735, ["Neon|Fly"] = 1262.66, ["Neon|Ride"] = 617.67, ["Neon|Fly|Ride"] = 757.52, ["Mega|Fly|Ride"] = 3067.32}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 327.91, ["Fly"] = 415.54, ["Ride"] = 376.69, ["Fly|Ride"] = 473.32, ["Neon"] = 1197.7, ["Neon|Fly"] = 1392.96, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 4426.82}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 17.1, ["Fly|Ride"] = 45.94, ["Neon"] = 7.02, ["Neon|Ride"] = 33.08, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 60.02, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 458.06, ["Fly"] = 654.65, ["Ride"] = 511.88, ["Fly|Ride"] = 699.54, ["Neon"] = 1575, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1720.69, ["Mega"] = 6260.17, ["Mega|Fly|Ride"] = 5979.32}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.54, ["Fly"] = 183.75, ["Ride"] = 27.56, ["Fly|Ride"] = 63.39, ["Neon"] = 9.19, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 118.33, ["Mega"] = 57.75, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 209.32}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 25.08, ["Ride"] = 19.11, ["Fly|Ride"] = 39.38, ["Neon"] = 8.36, ["Neon|Ride"] = 49.09, ["Neon|Fly|Ride"] = 84.05, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 316.02}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Fly"] = 79.31, ["Neon|Ride"] = 39.37, ["Mega"] = 24.15, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 62.66, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 36.2, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 158.62, ["Mega"] = 2088.13, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 17.4, ["Fly|Ride"] = 55.17, ["Neon"] = 19.85, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 55.13, ["Neon"] = 3.93, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 57.43, ["Mega|Fly"] = 696.4, ["Mega|Ride"] = 111.09, ["Mega|Fly|Ride"] = 139.93}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 24.03, ["Fly|Ride"] = 57.37, ["Neon"] = 7.88, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 32.39, ["Neon|Fly|Ride"] = 69.91, ["Mega"] = 61.68, ["Mega|Fly"] = 174.37, ["Mega|Ride"] = 86.24, ["Mega|Fly|Ride"] = 154.86}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.2, ["Fly"] = 47.34, ["Ride"] = 18.81, ["Fly|Ride"] = 51.45, ["Neon"] = 111.72, ["Neon|Fly"] = 142.03, ["Neon|Ride"] = 139.93, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 278.77, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.74, ["Ride"] = 41.77, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 316.02, ["Mega"] = 189.38, ["Mega|Ride"] = 446.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.63, ["Ride"] = 41.77, ["Fly|Ride"] = 69.98, ["Neon"] = 28.21, ["Neon|Ride"] = 98.16, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 439.03, ["Mega|Ride"] = 525}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 38.75, ["Ride"] = 18.38, ["Fly|Ride"] = 55.62, ["Neon"] = 3.71, ["Neon|Fly"] = 28.21, ["Neon|Ride"] = 28.26, ["Mega"] = 43.32, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 313.23}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 189.31, ["Ride"] = 236.66, ["Fly|Ride"] = 353.95, ["Neon|Ride"] = 2610.16, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 8352.46, ["Mega|Fly|Ride"] = 5207.66}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.07, ["Fly|Ride"] = 32.96, ["Neon"] = 5.81, ["Neon|Fly"] = 25.1, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 49.79, ["Mega"] = 44.63, ["Mega|Ride"] = 49, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 15.75, ["Ride"] = 94.48, ["Fly|Ride"] = 183.72, ["Neon"] = 57.75, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 126.66, ["Mega"] = 433.3, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 464.35}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.07, ["Fly"] = 210, ["Ride"] = 124.69, ["Fly|Ride"] = 170.63, ["Neon"] = 262.5, ["Neon|Ride"] = 311.92, ["Mega"] = 834.21, ["Mega|Ride"] = 769.33, ["Mega|Fly|Ride"] = 884.13}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 193.23, ["Ride"] = 235.34, ["Fly|Ride"] = 308.44, ["Neon"] = 766.35, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 698.85, ["Mega|Ride"] = 3342.94, ["Mega|Fly|Ride"] = 2814.7}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 31.96, ["Fly|Ride"] = 140.83, ["Neon"] = 80.48, ["Neon|Ride"] = 278.77, ["Mega"] = 285.48, ["Mega|Ride"] = 231.8, ["Mega|Fly|Ride"] = 433.3}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 28.25, ["Ride"] = 417.63, ["Fly|Ride"] = 626.68, ["Neon"] = 112.01, ["Neon|Ride"] = 125.3, ["Neon|Fly|Ride"] = 835.26, ["Mega"] = 1670.5, ["Mega|Fly|Ride"] = 929.23}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1204.23, ["Ride"] = 1168.13, ["Fly|Ride"] = 1531.64, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4734.23, ["Mega|Fly|Ride"] = 17121.48}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.28, ["Fly"] = 26.25, ["Ride"] = 18.79, ["Fly|Ride"] = 58.48, ["Neon"] = 31.34, ["Neon|Fly"] = 82.37, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 201.36, ["Mega"] = 277.73, ["Mega|Ride"] = 228.66, ["Mega|Fly|Ride"] = 321.58}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.68, ["Fly"] = 65.63, ["Ride"] = 33, ["Fly|Ride"] = 86.63, ["Neon"] = 25.69, ["Neon|Ride"] = 98.16, ["Mega"] = 207.79, ["Mega|Ride"] = 189.92, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.63, ["Ride"] = 103.69, ["Fly|Ride"] = 942.37, ["Neon|Ride"] = 83.54, ["Mega"] = 542.93, ["Mega|Ride"] = 529.35, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.32, ["Fly"] = 41.77, ["Ride"] = 41.91, ["Fly|Ride"] = 65.63, ["Neon"] = 64.32, ["Neon|Ride"] = 99.04, ["Neon|Fly|Ride"] = 211.62, ["Mega"] = 449.77, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 532.48}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 4.11, ["Fly"] = 19.92, ["Ride"] = 19.76, ["Fly|Ride"] = 48.04, ["Neon"] = 22.29, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 67.48, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 404.07}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.62, ["Fly"] = 415.54, ["Ride"] = 36.57, ["Neon"] = 7.85, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 63.54, ["Neon|Fly|Ride"] = 835.26, ["Mega"] = 87.94, ["Mega|Ride"] = 137.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 285.5, ["Ride"] = 334.69, ["Fly|Ride"] = 522.04, ["Neon|Ride"] = 1515.99, ["Neon|Fly|Ride"] = 2088.13, ["Mega|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 6259.12}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.52, ["Fly"] = 30.3, ["Ride"] = 28.21, ["Fly|Ride"] = 65.62, ["Neon"] = 10.48, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 105, ["Mega|Ride"] = 123.11, ["Mega|Fly|Ride"] = 404.07}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.08, ["Ride"] = 15.75, ["Neon"] = 35.51, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 1043.02, ["Mega|Ride"] = 348.73, ["Mega|Fly|Ride"] = 586.77}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.2, ["Fly"] = 70.87, ["Ride"] = 30.3, ["Neon"] = 11.46, ["Neon|Ride"] = 69.98, ["Mega"] = 203.44, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 349.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 240.54, ["Fly"] = 354.9, ["Ride"] = 307.13, ["Fly|Ride"] = 682.83, ["Neon"] = 830.82, ["Neon|Ride"] = 881.3, ["Neon|Fly|Ride"] = 946.86, ["Mega|Ride"] = 3132.18, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 29.33, ["Fly"] = 55.62, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 123.64, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 590.94, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 725.82}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.69, ["Ride"] = 39.38, ["Fly|Ride"] = 119.98, ["Neon"] = 104.43, ["Neon|Fly"] = 79.31, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 506.13, ["Mega|Ride"] = 423.6, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 37.43, ["Mega"] = 31.87, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 66.93, ["Fly"] = 131.57, ["Ride"] = 107.63, ["Fly|Ride"] = 177.19, ["Neon"] = 318.94, ["Neon|Fly"] = 473.37, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1564.01}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.25, ["Neon"] = 6.51, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 588, ["Mega"] = 40.68, ["Mega|Ride"] = 208.82, ["Mega|Fly|Ride"] = 404.07}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 24.77, ["Fly"] = 126.6, ["Ride"] = 28.88, ["Fly|Ride"] = 71.99, ["Neon"] = 58.09, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 208.82, ["Mega"] = 382.05, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 400.94}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 59.06, ["Fly"] = 110.06, ["Ride"] = 90.45, ["Fly|Ride"] = 128.93, ["Neon"] = 308.01, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 347, ["Mega|Ride"] = 1335.36, ["Mega|Fly|Ride"] = 927.97}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.21, ["Ride"] = 15.67, ["Fly|Ride"] = 35.43, ["Neon"] = 2.63, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 18.96, ["Neon|Fly|Ride"] = 47.36, ["Mega"] = 85.23, ["Mega|Fly"] = 55.64, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.87, ["Ride"] = 33.49, ["Fly|Ride"] = 1346.59, ["Neon"] = 16.19, ["Neon|Ride"] = 49.91, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 279.36, ["Mega|Ride"] = 269.73, ["Mega|Fly|Ride"] = 158.62}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.69, ["Fly"] = 139.93, ["Ride"] = 111.24, ["Fly|Ride"] = 278.77, ["Neon"] = 150.29, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 632.04, ["Mega"] = 586.69, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 650.97}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 135.75, ["Mega"] = 26.16, ["Mega|Ride"] = 139.02, ["Mega|Fly|Ride"] = 208.82}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.43, ["Ride"] = 55.62, ["Fly|Ride"] = 120.75, ["Neon"] = 55.78, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 312.18, ["Mega"] = 380.63, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 304.88, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 16.8, ["Fly"] = 28.22, ["Ride"] = 20.86, ["Fly|Ride"] = 45.93, ["Neon"] = 205.49, ["Neon|Ride"] = 67.24, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 348.73, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.94, ["Ride"] = 71.01, ["Fly|Ride"] = 76.01, ["Neon"] = 32.82, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 129.94, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 274.61}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 14.3, ["Fly"] = 2088.13, ["Ride"] = 91.3, ["Neon"] = 221.31, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 506.58, ["Mega|Ride"] = 409.28, ["Mega|Fly|Ride"] = 971.92}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 128.17, ["Fly|Ride"] = 196.88, ["Neon"] = 6.18, ["Neon|Fly"] = 56.4, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 65.44, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.3, ["Mega|Fly|Ride"] = 517.88}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Ride"] = 81.41, ["Mega"] = 25.58, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.69}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 73.1, ["Fly"] = 102.38, ["Ride"] = 79.29, ["Fly|Ride"] = 86.63, ["Neon"] = 1050, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 557.53, ["Mega"] = 1239.32, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Mega"] = 25.54, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 458.07, ["Ride"] = 430.5, ["Fly|Ride"] = 584.68, ["Neon"] = 2028.6, ["Neon|Fly|Ride"] = 2065.59, ["Mega"] = 16704.91, ["Mega|Ride"] = 15647.26, ["Mega|Fly|Ride"] = 9311.04}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.15, ["Fly"] = 26.17, ["Ride"] = 47.34, ["Fly|Ride"] = 89.8, ["Neon"] = 13.13, ["Neon|Ride"] = 277.73, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 104.43, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 165.72}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 148.25, ["Ride"] = 22.32, ["Fly|Ride"] = 59.06, ["Neon"] = 19.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 131.57, ["Mega|Ride"] = 158.62, ["Mega|Fly|Ride"] = 278.77}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.69, ["Ride"] = 31.96, ["Fly|Ride"] = 522.04, ["Neon"] = 78.74, ["Neon|Ride"] = 182.28, ["Mega"] = 729.81, ["Mega|Ride"] = 529.35, ["Mega|Fly|Ride"] = 835.26}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.37, ["Fly"] = 131.25, ["Ride"] = 17.07, ["Neon|Ride"] = 118.12, ["Mega"] = 249.38}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.5, ["Fly"] = 43.14, ["Ride"] = 42.26, ["Fly|Ride"] = 157.49, ["Neon"] = 68.92, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 358.89, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 649.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.63, ["Fly"] = 104.99, ["Ride"] = 56.4, ["Fly|Ride"] = 187.94, ["Neon"] = 49.86, ["Neon|Ride"] = 98.07, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 183.38, ["Mega|Fly"] = 482.37, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 395.32}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 13.13, ["Fly|Ride"] = 62.97, ["Neon"] = 2.1, ["Neon|Fly"] = 59.54, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 20.9, ["Mega|Fly"] = 62.66, ["Mega|Ride"] = 31.48, ["Mega|Fly|Ride"] = 147.05}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.62, ["Ride"] = 27.56, ["Fly|Ride"] = 158.58, ["Neon"] = 28.21, ["Neon|Fly"] = 118.36, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 111.27, ["Mega"] = 194.25, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Fly"] = 307.67, ["Ride"] = 299.25, ["Fly|Ride"] = 375.38, ["Neon"] = 1114.16, ["Neon|Ride"] = 1152.8, ["Neon|Fly|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 4157.54}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.75, ["Ride"] = 137.27, ["Fly|Ride"] = 7656.07, ["Neon"] = 564.38, ["Neon|Ride"] = 570.3, ["Neon|Fly|Ride"] = 612.88, ["Mega"] = 4176.23, ["Mega|Ride"] = 2019.22, ["Mega|Fly|Ride"] = 1605.6}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 22.99, ["Ride"] = 19.85, ["Fly|Ride"] = 39.38, ["Neon"] = 8.36, ["Neon|Fly"] = 69.98, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 62.56, ["Mega|Fly"] = 207.79, ["Mega|Ride"] = 98.16, ["Mega|Fly|Ride"] = 154.53}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.55, ["Fly|Ride"] = 25.99, ["Neon"] = 6.46, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 76.98, ["Mega|Fly"] = 348.73, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 174.88}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.97, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 36.66, ["Mega"] = 139.93, ["Mega|Ride"] = 89.8, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 216.57, ["Ride"] = 262.5, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1239.32, ["Mega|Ride"] = 8352.46, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.62, ["Fly"] = 48.42, ["Ride"] = 16.02, ["Fly|Ride"] = 35.77, ["Neon"] = 19.66, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 108.93, ["Mega"] = 332.27, ["Mega|Ride"] = 268.68, ["Mega|Fly|Ride"] = 317.99}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.55, ["Fly"] = 158.58, ["Ride"] = 96.48, ["Fly|Ride"] = 208.82, ["Neon"] = 35.51, ["Neon|Ride"] = 139.13, ["Mega"] = 208.85, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 31.82, ["Mega"] = 49.64, ["Mega|Ride"] = 96.55, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.43, ["Ride"] = 24.86, ["Fly|Ride"] = 57.75, ["Neon"] = 78.3, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 728.34, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 554.4}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 59.06, ["Fly"] = 94.67, ["Ride"] = 108.6, ["Fly|Ride"] = 209.9, ["Neon"] = 156.08, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 472.5, ["Mega|Fly"] = 2192.53, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 589.17}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 19.85, ["Fly"] = 158.58, ["Ride"] = 45.94, ["Fly|Ride"] = 86.63, ["Neon"] = 112.34, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.73, ["Mega"] = 793.49, ["Mega|Ride"] = 624.36, ["Mega|Fly|Ride"] = 693.27}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.81, ["Ride"] = 14.86, ["Fly|Ride"] = 31.96, ["Neon"] = 2.1, ["Neon|Fly"] = 28.14, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 61.62, ["Mega"] = 35.51, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 31.89, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 227.07, ["Fly"] = 292.35, ["Ride"] = 275.63, ["Fly|Ride"] = 349.57, ["Neon"] = 1225.73, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 4314.06}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.58, ["Fly"] = 61.61, ["Ride"] = 46.22, ["Fly|Ride"] = 132.61, ["Neon"] = 105, ["Neon|Ride"] = 190.03, ["Neon|Fly|Ride"] = 321.56, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 29.21, ["Ride"] = 18.37, ["Fly|Ride"] = 39.38, ["Neon"] = 8.36, ["Neon|Ride"] = 19.37, ["Neon|Fly|Ride"] = 110.69, ["Mega"] = 59.14, ["Mega|Fly"] = 250.59, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 300.64}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.21, ["Ride"] = 18.24, ["Fly|Ride"] = 55.47, ["Neon"] = 3.83, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 18.8, ["Neon|Fly|Ride"] = 101.8, ["Mega"] = 27.17, ["Mega|Fly"] = 142.05, ["Mega|Ride"] = 48.7, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 24.75, ["Fly|Ride"] = 69.27, ["Neon"] = 12.5, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 79.32, ["Mega"] = 94.12, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 387.03}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.21, ["Fly"] = 38.68, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 44.63, ["Neon|Ride"] = 39.78, ["Neon|Fly|Ride"] = 111.72, ["Mega"] = 328.37, ["Mega|Ride"] = 299.85, ["Mega|Fly|Ride"] = 316.31}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.67, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 55.01, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 275.63, ["Mega|Ride"] = 359.17, ["Mega|Fly|Ride"] = 413.45}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 41.67, ["Mega"] = 33.42, ["Mega|Ride"] = 61.42}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.44, ["Ride"] = 24.92, ["Fly|Ride"] = 69.98, ["Neon"] = 20.79, ["Neon|Fly"] = 47.36, ["Neon|Ride"] = 69.97, ["Neon|Fly|Ride"] = 90.85, ["Mega"] = 150.94, ["Mega|Ride"] = 258.95, ["Mega|Fly|Ride"] = 300.64}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 101.22, ["Neon"] = 6.57, ["Neon|Fly"] = 98.17, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 40.62, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 228.66}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 30.65, ["Ride"] = 20.9, ["Fly|Ride"] = 118.13, ["Neon"] = 7.92, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 63.86, ["Mega"] = 50.02, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 667.95, ["Ride"] = 728.44, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 26.04, ["Ride"] = 15.65, ["Fly|Ride"] = 31.49, ["Neon"] = 28.21, ["Neon|Fly"] = 33.03, ["Neon|Ride"] = 40.73, ["Neon|Fly|Ride"] = 111.72, ["Mega"] = 186.9, ["Mega|Fly|Ride"] = 208.82}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.62, ["Ride"] = 34.04, ["Fly|Ride"] = 164.72, ["Neon"] = 6.34, ["Neon|Fly"] = 835.35, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 47.92, ["Mega|Fly"] = 158.62, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 158.22}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.56, ["Fly"] = 31.4, ["Ride"] = 23.67, ["Fly|Ride"] = 47.24, ["Neon"] = 38.55, ["Neon|Fly"] = 111.74, ["Neon|Ride"] = 41.97, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 358.32}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.73, ["Fly|Ride"] = 34.12, ["Neon"] = 6.7, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 51.1, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 208.82}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.49, ["Ride"] = 111.7, ["Fly|Ride"] = 207.79, ["Neon"] = 243.37, ["Neon|Ride"] = 257.44, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 896.44, ["Mega|Ride"] = 1112.55, ["Mega|Fly|Ride"] = 1183.97}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 6.2, ["Neon|Fly"] = 134.92, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 61.69, ["Mega|Ride"] = 110.92, ["Mega|Fly|Ride"] = 265.2}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.6, ["Fly"] = 73.5, ["Ride"] = 23.77, ["Fly|Ride"] = 65.63, ["Neon"] = 12.34, ["Neon|Ride"] = 62.66, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 98.44, ["Mega|Ride"] = 186.74, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 63.92, ["Neon|Ride"] = 111.27, ["Mega"] = 110.69, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Fly|Ride"] = 83.54, ["Neon"] = 3.92, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 54.31, ["Mega|Fly"] = 200.82, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 175.19}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.49, ["Fly"] = 26.25, ["Ride"] = 27.17, ["Fly|Ride"] = 40.69, ["Neon"] = 137.65, ["Neon|Ride"] = 101.88, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 835.26, ["Mega|Ride"] = 417.63, ["Mega|Fly|Ride"] = 433.3}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 735, ["Ride"] = 721.88, ["Fly|Ride"] = 826.88, ["Neon"] = 1771.88, ["Neon|Fly"] = 2425.89, ["Neon|Ride"] = 1947.77, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 7657.12, ["Mega|Ride"] = 7481.25, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.75, ["Fly|Ride"] = 56.4, ["Neon"] = 3.84, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 22.51, ["Neon|Fly|Ride"] = 60.33, ["Mega"] = 52.86, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 115.6}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.38, ["Ride"] = 38.66, ["Fly|Ride"] = 111.72, ["Neon"] = 32.15, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 258.36, ["Mega"] = 208.82, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 696.4}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 65.62, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon|Ride"] = 415.54, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.35, ["Fly"] = 131.25, ["Ride"] = 39.56, ["Fly|Ride"] = 102.79, ["Neon"] = 103.95, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 348.73, ["Mega"] = 591.8, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 682.83}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.86, ["Ride"] = 26.23, ["Fly|Ride"] = 123.58, ["Neon"] = 102.96, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 328.55, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 446.87}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 31.5, ["Ride"] = 94.67, ["Neon"] = 72.19, ["Neon|Ride"] = 363.37, ["Neon|Fly|Ride"] = 126.13, ["Mega"] = 278.77, ["Mega|Fly"] = 513.68, ["Mega|Ride"] = 380.04, ["Mega|Fly|Ride"] = 422.4}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.18, ["Ride"] = 91.47, ["Fly|Ride"] = 83.54, ["Neon"] = 177.19, ["Neon|Ride"] = 304.77, ["Neon|Fly|Ride"] = 378.75, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 769.33}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 39.11}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.94, ["Ride"] = 30.34, ["Fly|Ride"] = 65.1, ["Neon"] = 25.73, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 155.8, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 186.16, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 36.75, ["Neon|Ride"] = 43.32, ["Mega"] = 884.13}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 83.6, ["Fly"] = 417.63, ["Ride"] = 110.95, ["Fly|Ride"] = 104.99, ["Neon"] = 301.31, ["Neon|Ride"] = 348.73, ["Neon|Fly|Ride"] = 366.92, ["Mega|Ride"] = 1105.46, ["Mega|Fly|Ride"] = 1152.8}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 21.83, ["Ride"] = 18.37, ["Fly|Ride"] = 35.11, ["Neon"] = 19.69, ["Neon|Fly"] = 69.38, ["Neon|Ride"] = 34.75, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 262.5, ["Mega|Fly"] = 416.59, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 241.46}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.63, ["Fly"] = 83.54, ["Ride"] = 24.94, ["Fly|Ride"] = 69.98, ["Neon"] = 15.67, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 137.82, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 45.94, ["Mega"] = 79.32, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.87, ["Fly"] = 65.63, ["Ride"] = 52.5, ["Fly|Ride"] = 120.74, ["Neon"] = 139.93, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 1114.02, ["Mega|Ride"] = 828.5, ["Mega|Fly|Ride"] = 1292.55}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 5.24, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.63, ["Mega"] = 65.63, ["Mega|Ride"] = 114.53, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.7, ["Ride"] = 83.54, ["Neon"] = 65.63, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 303.09, ["Mega"] = 612.88, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 963.68}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 19.85, ["Ride"] = 17.07, ["Fly|Ride"] = 47.25, ["Neon"] = 16.27, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 56.4, ["Mega"] = 144.37, ["Mega|Ride"] = 261.85, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.92, ["Fly"] = 52.49, ["Ride"] = 20.43, ["Fly|Ride"] = 53.26, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 277.73, ["Mega|Ride"] = 278.77, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.25, ["Ride"] = 37.3, ["Neon"] = 36.23, ["Neon|Ride"] = 142.05, ["Mega"] = 250.38, ["Mega|Ride"] = 840.67, ["Mega|Fly|Ride"] = 217.18}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.06, ["Ride"] = 83.83, ["Neon"] = 140.23, ["Neon|Ride"] = 309.06, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 936.49, ["Mega|Ride"] = 1609.95, ["Mega|Fly|Ride"] = 1030.32}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.19, ["Ride"] = 78.48, ["Fly|Ride"] = 125.3, ["Neon"] = 95.51, ["Neon|Ride"] = 139.93, ["Mega"] = 411.69, ["Mega|Ride"] = 334.11, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 32.39, ["Ride"] = 105, ["Neon"] = 41.91, ["Mega"] = 626.45, ["Mega|Ride"] = 1002.49, ["Mega|Fly|Ride"] = 1044.07}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 16.24, ["Ride"] = 66.49, ["Fly|Ride"] = 530.08, ["Neon"] = 82.65, ["Neon|Ride"] = 111.39, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 769.33, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1108.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.25, ["Neon"] = 105, ["Neon|Ride"] = 278.77, ["Mega"] = 835.26, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 158.62}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.21, ["Fly|Ride"] = 42, ["Neon"] = 3.84, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 22.75, ["Neon|Fly|Ride"] = 73.1, ["Mega"] = 56.4, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 117.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.23, ["Fly"] = 56.4, ["Ride"] = 56.4, ["Fly|Ride"] = 354.38, ["Neon"] = 79.29, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 150.33, ["Mega"] = 191.63, ["Mega|Ride"] = 417.63, ["Mega|Fly|Ride"] = 397.57}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.7, ["Ride"] = 17.06, ["Fly|Ride"] = 47.34, ["Neon"] = 5.2, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.15, ["Mega"] = 37.97, ["Mega|Ride"] = 71.99, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Ride"] = 28.21, ["Fly|Ride"] = 110.35, ["Neon"] = 13.1, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 111.72, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.9, ["Ride"] = 32.62, ["Fly|Ride"] = 69.98, ["Neon"] = 33.49, ["Neon|Fly"] = 315, ["Neon|Ride"] = 103.37, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 383.18, ["Mega|Ride"] = 417.63, ["Mega|Fly|Ride"] = 1044.07}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.86, ["Fly"] = 131.25, ["Ride"] = 28.21, ["Fly|Ride"] = 41, ["Neon"] = 13.89, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 193.61, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.88, ["Fly"] = 34.41, ["Ride"] = 22.97, ["Fly|Ride"] = 39.38, ["Neon"] = 15.23, ["Neon|Fly"] = 83.54, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 68.93, ["Mega"] = 168, ["Mega|Ride"] = 230.75, ["Mega|Fly|Ride"] = 442.66}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.35, ["Fly"] = 301.87, ["Ride"] = 43.31, ["Fly|Ride"] = 105, ["Neon"] = 28.21, ["Neon|Fly"] = 122.95, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 196.5, ["Mega"] = 334.1, ["Mega|Ride"] = 396.76, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 8.36, ["Fly"] = 140.27, ["Ride"] = 98.44, ["Fly|Ride"] = 156.62, ["Neon"] = 85.21, ["Neon|Fly"] = 213.94, ["Neon|Ride"] = 217, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 392.44, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 480.29, ["Mega|Fly|Ride"] = 591.8}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.5, ["Ride"] = 97.12, ["Fly|Ride"] = 164.07, ["Neon"] = 249.38, ["Neon|Fly"] = 332.06, ["Neon|Ride"] = 263.81, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 1147.43, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1113.76}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51, ["Ride"] = 22.5, ["Fly|Ride"] = 65.54, ["Neon"] = 2.62, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 60.57, ["Mega"] = 26.25, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 117.18}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 29.91, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 911.54, ["Mega|Ride"] = 834.21, ["Mega|Fly|Ride"] = 1248.71}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 42.95, ["Ride"] = 78.48, ["Neon"] = 259.06, ["Neon|Ride"] = 250.62, ["Neon|Fly|Ride"] = 520.99, ["Mega"] = 1701.82, ["Mega|Ride"] = 1105.67, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.57, ["Fly"] = 190.32, ["Ride"] = 41.77, ["Fly|Ride"] = 125.99, ["Neon"] = 62.67, ["Neon|Ride"] = 52.5, ["Mega"] = 525, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.5, ["Ride"] = 110.44, ["Fly|Ride"] = 137.34, ["Neon"] = 4.45, ["Neon|Fly"] = 40.25, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 81.45, ["Mega"] = 43.28, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.52, ["Mega|Fly|Ride"] = 111.97}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.61, ["Fly"] = 29.17, ["Ride"] = 20.9, ["Fly|Ride"] = 41.77, ["Neon"] = 15.67, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 177.19, ["Mega|Fly"] = 348.73, ["Mega|Ride"] = 314.84, ["Mega|Fly|Ride"] = 221.34}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 17.06, ["Fly|Ride"] = 31.67, ["Neon"] = 2.51, ["Neon|Fly"] = 28.21, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 52.47, ["Mega"] = 32.06, ["Mega|Ride"] = 82.49, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.77, ["Ride"] = 18.38, ["Fly|Ride"] = 67.77, ["Neon"] = 5.13, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 83.54, ["Mega"] = 42.84, ["Mega|Fly"] = 168, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 158.58, ["Neon"] = 2.1, ["Neon|Ride"] = 123.24, ["Mega"] = 21, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.03, ["Ride"] = 35.51, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 206.73, ["Mega"] = 189.38, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 194.54}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.55, ["Ride"] = 37.59, ["Fly|Ride"] = 189.96, ["Neon"] = 57.29, ["Neon|Ride"] = 98.16, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 396.76, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.83, ["Fly"] = 19.69, ["Ride"] = 20.74, ["Fly|Ride"] = 51.42, ["Neon"] = 39.38, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 90.82, ["Mega"] = 301.88, ["Mega|Ride"] = 339.13, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 74.62, ["Ride"] = 78.75, ["Fly|Ride"] = 262.5, ["Neon"] = 278.77, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 413.45, ["Mega|Fly|Ride"] = 1810.4}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 14.44, ["Fly"] = 72.45, ["Ride"] = 32.71, ["Fly|Ride"] = 79.29, ["Neon"] = 41.43, ["Mega"] = 624.1, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.81, ["Ride"] = 18.81, ["Fly|Ride"] = 41.77, ["Neon"] = 3.93, ["Neon|Fly"] = 28.21, ["Neon|Ride"] = 23.69, ["Neon|Fly|Ride"] = 69.98, ["Mega"] = 40.73, ["Mega|Ride"] = 63.92, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.76, ["Ride"] = 13.96, ["Fly|Ride"] = 32.97, ["Neon"] = 4.18, ["Neon|Fly"] = 26.61, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 44.99, ["Mega"] = 70.11, ["Mega|Fly"] = 74.13, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 98.56}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 391.12, ["Ride"] = 404.41, ["Fly|Ride"] = 465.93, ["Neon|Ride"] = 1883.05, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 14.43, ["Fly"] = 77.27, ["Ride"] = 45.94, ["Fly|Ride"] = 242.38, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 696.4, ["Mega|Fly|Ride"] = 1252.89}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 33.8, ["Ride"] = 14.93, ["Fly|Ride"] = 39.38, ["Neon"] = 7.84, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 22.99, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 32.82, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 118.13, ["Ride"] = 158.58, ["Fly|Ride"] = 275.63, ["Neon"] = 236.25, ["Neon|Ride"] = 302.75, ["Neon|Fly|Ride"] = 1148.62, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1267.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.54, ["Ride"] = 17.75, ["Fly|Ride"] = 56.81, ["Neon"] = 10.45, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 77.59, ["Mega|Fly"] = 125.3, ["Mega|Ride"] = 96.39, ["Mega|Fly|Ride"] = 159.39}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.98, ["Ride"] = 30.09, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.43, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.12, ["Mega|Fly"] = 208.82, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.57}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 97.12, ["Fly"] = 130.81, ["Ride"] = 86.59, ["Fly|Ride"] = 124.69, ["Neon"] = 157.49, ["Neon|Ride"] = 316.02, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 654.94, ["Mega|Ride"] = 629.96, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 14.97, ["Fly|Ride"] = 52.5, ["Neon"] = 8.34, ["Neon|Ride"] = 26.25, ["Mega"] = 40.59, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 47.16, ["Ride"] = 77.35, ["Fly|Ride"] = 131.25, ["Neon"] = 155.03, ["Neon|Ride"] = 303.84, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1649.63, ["Mega|Ride"] = 1668.41, ["Mega|Fly|Ride"] = 901.65}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.84, ["Ride"] = 45.94, ["Fly|Ride"] = 158.71, ["Neon"] = 17.2, ["Neon|Ride"] = 302.02, ["Mega"] = 175.19, ["Mega|Ride"] = 158.62, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.92, ["Fly"] = 69.98, ["Ride"] = 18.84, ["Neon"] = 11.91, ["Neon|Fly"] = 78.32, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 35.44, ["Ride"] = 56.4, ["Fly|Ride"] = 196.88, ["Neon"] = 105, ["Neon|Ride"] = 207.79, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2073.5, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1112.97}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 158.62, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 4.76, ["Neon|Ride"] = 37.59, ["Neon|Fly|Ride"] = 160.8, ["Mega"] = 46.78, ["Mega|Fly"] = 192.09, ["Mega|Ride"] = 83.62, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.4, ["Ride"] = 22.3, ["Fly|Ride"] = 102.87, ["Neon"] = 7.88, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 98.17, ["Mega"] = 208.82, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.56, ["Fly"] = 35.6, ["Ride"] = 28.88, ["Fly|Ride"] = 92.31, ["Neon"] = 32.82, ["Neon|Ride"] = 91.88, ["Mega"] = 340.38, ["Mega|Ride"] = 313.68, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 32.26, ["Fly"] = 62.66, ["Ride"] = 98.36, ["Fly|Ride"] = 298.74, ["Neon"] = 181.68, ["Neon|Ride"] = 185.85, ["Neon|Fly|Ride"] = 487.58, ["Mega|Ride"] = 1252.89, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.69, ["Fly"] = 50.15, ["Ride"] = 26.17, ["Fly|Ride"] = 73.5, ["Neon"] = 104.14, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 156.62, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 55.13, ["Ride"] = 103.37, ["Fly|Ride"] = 210, ["Neon"] = 262.5, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 521.96, ["Mega"] = 1155, ["Mega|Ride"] = 1153, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.57, ["Ride"] = 37.38, ["Neon"] = 15.67, ["Neon|Ride"] = 68.93, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 200.82, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.92, ["Ride"] = 26.25, ["Fly|Ride"] = 78.74, ["Neon"] = 21, ["Neon|Ride"] = 50.13, ["Mega"] = 203.44, ["Mega|Ride"] = 208.82, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.82, ["Fly"] = 65.62, ["Ride"] = 45.1, ["Fly|Ride"] = 91.89, ["Neon"] = 118.51, ["Neon|Ride"] = 137.81, ["Mega"] = 515.82, ["Mega|Ride"] = 696.4, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.65, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 60.37, ["Mega"] = 17.07, ["Mega|Fly"] = 79.32, ["Mega|Ride"] = 26.17, ["Mega|Fly|Ride"] = 93.19}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 37.7, ["Fly"] = 220.5, ["Ride"] = 91.87, ["Fly|Ride"] = 277.37, ["Neon"] = 195.44, ["Neon|Fly"] = 2367.18, ["Neon|Ride"] = 288.75, ["Mega"] = 1250.8, ["Mega|Ride"] = 960.56, ["Mega|Fly|Ride"] = 837.35}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 17.12, ["Fly|Ride"] = 108.6, ["Neon"] = 4.74, ["Neon|Ride"] = 38.07, ["Mega"] = 55.64, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.2, ["Ride"] = 18.47, ["Fly|Ride"] = 40.68, ["Neon"] = 11.81, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 62.28, ["Mega"] = 183.75, ["Mega|Ride"] = 208.82, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Ride"] = 154.88, ["Fly|Ride"] = 162.75, ["Neon"] = 341.16, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1048.69, ["Mega|Ride"] = 1215.3, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.72, ["Neon|Ride"] = 52.41, ["Mega"] = 55.92, ["Mega|Ride"] = 126.66, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.65}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 140.96, ["Fly|Ride"] = 102.34, ["Neon"] = 6.2, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 52.22, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 213.28}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 127.32, ["Ride"] = 181.51, ["Fly|Ride"] = 271.47, ["Neon"] = 538.13, ["Neon|Ride"] = 722.51, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3629.98, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2366.89}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.92, ["Ride"] = 28.88, ["Neon"] = 29.74, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 104.43, ["Mega"] = 139.55, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 445.04}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 3.89, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.81, ["Mega|Ride"] = 137.6, ["Mega|Fly|Ride"] = 111.46}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.7, ["Ride"] = 27.17, ["Neon"] = 41.41, ["Neon|Ride"] = 111.72, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 458.43}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.45, ["Fly"] = 42, ["Ride"] = 26.67, ["Fly|Ride"] = 157.49, ["Neon"] = 65.52, ["Neon|Ride"] = 94.96, ["Neon|Fly|Ride"] = 111.72, ["Mega"] = 258.95, ["Mega|Ride"] = 265.2, ["Mega|Fly|Ride"] = 346.65}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 55.13, ["Ride"] = 127.33, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 583.69, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 128.12, ["Fly"] = 167.43, ["Ride"] = 155.59, ["Fly|Ride"] = 214.13, ["Neon"] = 615.32, ["Neon|Fly"] = 625.48, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 13.92, ["Fly"] = 23.63, ["Ride"] = 19.68, ["Fly|Ride"] = 44.76, ["Neon"] = 173.94, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 80.07, ["Mega|Ride"] = 626.45, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 5.7, ["Fly"] = 131.23, ["Ride"] = 44.98, ["Fly|Ride"] = 91.88, ["Neon"] = 14.04, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 99.75, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 348.73}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 15.28, ["Fly"] = 98.16, ["Ride"] = 48.18, ["Neon"] = 54.45, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 466.54, ["Mega|Ride"] = 491.19, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.18, ["Ride"] = 75.62, ["Fly|Ride"] = 137.82, ["Neon"] = 170.63, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 958.47, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1016.06}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.99, ["Ride"] = 85.25, ["Neon"] = 158.62, ["Neon|Ride"] = 238.26, ["Mega"] = 643.13, ["Mega|Ride"] = 751.74, ["Mega|Fly|Ride"] = 820.64}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 399.89, ["Fly|Ride"] = 680.74, ["Neon"] = 1189.59, ["Neon|Ride"] = 1114.02, ["Neon|Fly|Ride"] = 1460.65, ["Mega"] = 4656.5, ["Mega|Fly|Ride"] = 4656.5}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.43, ["Fly"] = 69.98, ["Ride"] = 39.38, ["Fly|Ride"] = 111.72, ["Neon"] = 167.07, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 840, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 994.3}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.66, ["Fly|Ride"] = 70.49, ["Neon"] = 2.62, ["Neon|Ride"] = 18.25, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 39.15, ["Mega|Fly"] = 104.76, ["Mega|Ride"] = 41.04, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Ride"] = 278.77, ["Neon"] = 15.68, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 158.61, ["Mega"] = 158.82, ["Mega|Ride"] = 175.19, ["Mega|Fly|Ride"] = 375.88}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.94, ["Fly|Ride"] = 144.16, ["Neon"] = 15.2, ["Neon|Ride"] = 68.93, ["Neon|Fly|Ride"] = 557.53, ["Mega"] = 105, ["Mega|Fly"] = 542.93, ["Mega|Ride"] = 136.79, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 631.88, ["Ride"] = 400.32, ["Fly|Ride"] = 521.84, ["Neon"] = 1387.72, ["Neon|Ride"] = 1609.65, ["Neon|Fly|Ride"] = 1370.93, ["Mega|Ride"] = 6128.61, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.61, ["Fly"] = 46.15, ["Ride"] = 17.07, ["Fly|Ride"] = 48.29, ["Neon"] = 17.42, ["Neon|Ride"] = 31.89, ["Neon|Fly|Ride"] = 63.76, ["Mega"] = 142.05, ["Mega|Ride"] = 271.24}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.67, ["Fly"] = 22.32, ["Ride"] = 22.99, ["Fly|Ride"] = 39.38, ["Neon"] = 19.85, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 129.61, ["Mega"] = 417.63, ["Mega|Ride"] = 696.4, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.66, ["Fly"] = 45.05, ["Ride"] = 28.21, ["Fly|Ride"] = 118.34, ["Neon"] = 15.67, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 48.04, ["Neon|Fly|Ride"] = 89.3, ["Mega"] = 183.77, ["Mega|Ride"] = 269.38, ["Mega|Fly|Ride"] = 278.77}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.29, ["Fly"] = 65.8, ["Ride"] = 83.54, ["Fly|Ride"] = 61.69, ["Neon"] = 99.83, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 210, ["Mega"] = 937.57, ["Mega|Ride"] = 834.21, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.36, ["Fly|Ride"] = 68.93, ["Neon"] = 7.2, ["Neon|Ride"] = 35.51, ["Mega"] = 158.86, ["Mega|Ride"] = 398.96, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.46, ["Fly"] = 104.43, ["Ride"] = 28.21, ["Fly|Ride"] = 85.31, ["Neon"] = 87.97, ["Neon|Ride"] = 154.88, ["Mega|Fly|Ride"] = 729.81}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.05, ["Neon"] = 6.41, ["Neon|Ride"] = 41.77, ["Mega"] = 38.66, ["Mega|Ride"] = 131.91, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.09, ["Ride"] = 98.16, ["Neon"] = 41.75, ["Neon|Ride"] = 103.28, ["Mega"] = 418.85}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.25, ["Ride"] = 69.98, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 308.01, ["Mega|Ride"] = 557.53, ["Mega|Fly|Ride"] = 490.72}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.64, ["Fly"] = 26.16, ["Ride"] = 25.44, ["Fly|Ride"] = 52.5, ["Neon"] = 47.16, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 105, ["Mega"] = 568.56, ["Mega|Ride"] = 557.53, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 192.31, ["Fly"] = 216.57, ["Ride"] = 230.99, ["Fly|Ride"] = 291.38, ["Neon"] = 789.32, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 3716.85}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 56.78, ["Neon"] = 15.49, ["Neon|Fly"] = 79.31, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.18, ["Ride"] = 36.2, ["Fly|Ride"] = 104.91, ["Neon"] = 30.24, ["Neon|Ride"] = 32.36, ["Neon|Fly|Ride"] = 158.62, ["Mega"] = 278.77, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 55.48, ["Fly"] = 139.93, ["Ride"] = 278.87, ["Fly|Ride"] = 417.63, ["Neon"] = 154.55, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 522.04, ["Mega"] = 417.63, ["Mega|Ride"] = 574.25, ["Mega|Fly|Ride"] = 766.35}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 101.34, ["Fly"] = 393.75, ["Ride"] = 164.98, ["Fly|Ride"] = 295.32, ["Neon"] = 580.13, ["Neon|Ride"] = 621.24, ["Neon|Fly|Ride"] = 619.5, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 2071.41}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 28.75, ["Ride"] = 82.41, ["Fly|Ride"] = 321.19, ["Neon"] = 98.05, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 317.61, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 501.16}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 16.48, ["Fly|Ride"] = 47.23, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 190.03, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 16.4, ["Ride"] = 48.56, ["Neon"] = 59.59, ["Neon|Ride"] = 108.6, ["Neon|Fly|Ride"] = 236.73, ["Mega"] = 226.2, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 407.15}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 76.13, ["Fly"] = 119.03, ["Ride"] = 125.3, ["Fly|Ride"] = 210, ["Neon"] = 221.38, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 398.85, ["Mega"] = 826.87, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Fly"] = 118.13, ["Ride"] = 102.38, ["Neon"] = 8.28, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 51.18, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.45, ["Ride"] = 388.13, ["Neon"] = 85.32, ["Neon|Ride"] = 626.45, ["Mega"] = 341.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 918.75, ["Fly"] = 2088.13, ["Ride"] = 1015.46, ["Fly|Ride"] = 939.47, ["Neon"] = 2965.07, ["Neon|Ride"] = 3472.56, ["Neon|Fly|Ride"] = 2429.2, ["Mega|Fly|Ride"] = 10440.56}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 37.48, ["Fly"] = 118.84, ["Ride"] = 107.66, ["Fly|Ride"] = 185.81, ["Neon"] = 315.95, ["Neon|Fly"] = 892.5, ["Mega"] = 972.03, ["Mega|Ride"] = 554.4, ["Mega|Fly|Ride"] = 665.67}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.71, ["Fly"] = 49.23, ["Ride"] = 28.21, ["Fly|Ride"] = 80.89, ["Neon"] = 15.67, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 83.86, ["Mega"] = 79.41, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 16.72, ["Ride"] = 131.22, ["Neon"] = 73.12, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 334.11, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 417.63, ["Neon"] = 2.62, ["Neon|Ride"] = 26.11, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 23.69, ["Mega|Fly"] = 125.3, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 158.62}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.52, ["Ride"] = 158.58, ["Fly|Ride"] = 255.94, ["Neon"] = 345.19, ["Neon|Ride"] = 346.5, ["Neon|Fly|Ride"] = 435.75, ["Mega"] = 1100.15, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.88, ["Fly"] = 174.57, ["Ride"] = 42, ["Fly|Ride"] = 65.63, ["Neon"] = 39.38, ["Neon|Ride"] = 48.04, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 223.13, ["Mega|Ride"] = 258.95, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.49, ["Ride"] = 28.21, ["Neon"] = 13.13, ["Neon|Ride"] = 65.62, ["Mega"] = 170.63, ["Mega|Ride"] = 208.82, ["Mega|Fly|Ride"] = 334.11}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 53.23, ["Ride"] = 81.37, ["Fly|Ride"] = 157.75, ["Neon"] = 203.63, ["Neon|Fly"] = 277.77, ["Neon|Ride"] = 160.8, ["Neon|Fly|Ride"] = 404.07, ["Mega"] = 531.3, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 598.2}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.13, ["Ride"] = 59.07, ["Fly|Ride"] = 195.25, ["Neon"] = 135.75, ["Neon|Ride"] = 244.32, ["Neon|Fly|Ride"] = 308.7, ["Mega"] = 427.23, ["Mega|Ride"] = 676.56, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.47, ["Ride"] = 65.63, ["Neon"] = 320.54, ["Neon|Ride"] = 694.76, ["Neon|Fly|Ride"] = 1313.18, ["Mega"] = 1225.73, ["Mega|Ride"] = 1670.5, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 12.58, ["Ride"] = 64.32, ["Neon"] = 19.89, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 102.99, ["Mega|Ride"] = 179.61, ["Mega|Fly|Ride"] = 267.72}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.59, ["Fly"] = 32.15, ["Ride"] = 21.53, ["Fly|Ride"] = 52.5, ["Neon"] = 49.9, ["Neon|Ride"] = 85.02, ["Neon|Fly|Ride"] = 126.35, ["Mega"] = 399, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 426.11}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 105, ["Ride"] = 157.96, ["Fly|Ride"] = 255.94, ["Neon"] = 440.5, ["Neon|Ride"] = 572.24, ["Neon|Fly|Ride"] = 484.32, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 2016}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 36.66, ["Ride"] = 18.25, ["Fly|Ride"] = 50.25, ["Neon"] = 14.44, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 57.04, ["Mega"] = 124.04, ["Mega|Ride"] = 148.67, ["Mega|Fly|Ride"] = 200.48}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 37.87, ["Ride"] = 24.52, ["Fly|Ride"] = 78.73, ["Neon"] = 41.43, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 53.72, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 299.66, ["Mega|Ride"] = 237.02, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 44.61, ["Mega"] = 20.9, ["Mega|Fly"] = 49.72, ["Mega|Ride"] = 35.51, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.31, ["Neon"] = 2.63, ["Neon|Ride"] = 39.68, ["Neon|Fly|Ride"] = 56.4, ["Mega"] = 22.32, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 139.81}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 130.93, ["Ride"] = 27.17, ["Fly|Ride"] = 45.94, ["Neon"] = 38.07, ["Neon|Ride"] = 47.16, ["Mega"] = 91.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.47, ["Ride"] = 84, ["Neon"] = 326.82, ["Neon|Ride"] = 370.65, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 667.16}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 18.27, ["Ride"] = 16.65, ["Fly|Ride"] = 26.24, ["Neon"] = 10.08, ["Neon|Fly"] = 31.98, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 50.42, ["Mega"] = 113.95, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 117.93, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.49, ["Fly"] = 25.08, ["Ride"] = 23.54, ["Fly|Ride"] = 59.64, ["Neon"] = 14.21, ["Neon|Fly"] = 36.62, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 169.31, ["Mega|Fly"] = 304.88, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 148.26}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.92, ["Fly"] = 19.58, ["Ride"] = 18.09, ["Fly|Ride"] = 113.39, ["Neon"] = 8.01, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.69, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 123.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.64, ["Ride"] = 34.9, ["Neon"] = 62.66, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 98.16, ["Mega"] = 207.81, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 221.73, ["Mega|Fly|Ride"] = 413.45}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.34, ["Fly"] = 162.1, ["Ride"] = 59.07, ["Neon"] = 76.38, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 1044.07}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.17, ["Fly"] = 48.57, ["Ride"] = 17.07, ["Fly|Ride"] = 63, ["Neon"] = 19.36, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 275.65, ["Mega|Ride"] = 189.33, ["Mega|Fly|Ride"] = 601.26}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 18.36, ["Fly|Ride"] = 52.49, ["Neon"] = 11.55, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 48.14, ["Mega"] = 154.53, ["Mega|Ride"] = 104.43, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 221.25, ["Fly"] = 393.75, ["Ride"] = 234.3, ["Fly|Ride"] = 278.77, ["Neon"] = 1197.55, ["Neon|Ride"] = 1088.89, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Fly|Ride"] = 3836.44}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.72, ["Ride"] = 39.12, ["Neon"] = 21, ["Neon|Fly|Ride"] = 278.77, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.62, ["Fly"] = 70.03, ["Ride"] = 19.62, ["Fly|Ride"] = 56.35, ["Neon"] = 20.9, ["Neon|Fly"] = 208.85, ["Neon|Ride"] = 37.59, ["Neon|Fly|Ride"] = 201.79, ["Mega"] = 187.11, ["Mega|Ride"] = 271.47, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 11.04, ["Ride"] = 24.94, ["Neon"] = 50.21, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 626.45, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 431.18}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 15.67, ["Fly|Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 19.47, ["Neon|Ride"] = 16.71, ["Neon|Fly|Ride"] = 40.73, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 41.77, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.03, ["Ride"] = 26.04, ["Fly|Ride"] = 58.7, ["Neon"] = 12.25, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 116.64, ["Mega|Ride"] = 133.3, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 56.4, ["Fly|Ride"] = 98.98, ["Neon"] = 9.87, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.07, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 293.54}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 62.36, ["Fly"] = 98.16, ["Ride"] = 91.87, ["Fly|Ride"] = 144.38, ["Neon"] = 658.81, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 345.61, ["Mega|Ride"] = 3481.94, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.36, ["Fly"] = 85.32, ["Ride"] = 33.43, ["Fly|Ride"] = 65.63, ["Neon"] = 28.21, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 136.12, ["Mega"] = 211.54, ["Mega|Ride"] = 262.49}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.34, ["Ride"] = 45.04, ["Fly|Ride"] = 118.13, ["Neon"] = 4.74, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 55.65, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 104.43, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 64.32, ["Fly"] = 210, ["Ride"] = 83.54, ["Fly|Ride"] = 194.24, ["Neon"] = 139.93, ["Neon|Ride"] = 202.12, ["Neon|Fly|Ride"] = 557.12, ["Mega"] = 451.5, ["Mega|Ride"] = 580.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 15.69, ["Fly|Ride"] = 28.25, ["Neon"] = 2.41, ["Neon|Fly"] = 24.03, ["Neon|Ride"] = 15.68, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 27.16, ["Mega|Fly"] = 38.68, ["Mega|Ride"] = 36.7, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 2.6, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 83.65, ["Mega"] = 37.32, ["Mega|Ride"] = 81.18, ["Mega|Fly|Ride"] = 212.83}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 58.48, ["Fly|Ride"] = 137.82, ["Neon"] = 8.54, ["Neon|Ride"] = 102.37, ["Neon|Fly|Ride"] = 183.77, ["Mega"] = 135.74, ["Mega|Ride"] = 209.25}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.65, ["Fly"] = 70.86, ["Ride"] = 65.63, ["Fly|Ride"] = 137.63, ["Neon"] = 26.25, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 315.36, ["Mega"] = 86.63, ["Mega|Fly"] = 187.69, ["Mega|Ride"] = 177.55, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.67, ["Ride"] = 15.67, ["Fly|Ride"] = 28.26, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 43.86, ["Mega"] = 26.25, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 139.93}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.54, ["Ride"] = 56.4, ["Neon"] = 114.6, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 487.16, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 680.74}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3077.82, ["Fly"] = 3150, ["Ride"] = 2772.05, ["Fly|Ride"] = 2732.61, ["Neon|Fly|Ride"] = 9745.22, ["Mega|Fly|Ride"] = 43328.31}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 17.04, ["Fly|Ride"] = 41.77, ["Neon"] = 6.29, ["Neon|Fly"] = 68.94, ["Neon|Ride"] = 22.89, ["Neon|Fly|Ride"] = 52.03, ["Mega"] = 74.82, ["Mega|Fly"] = 144.1, ["Mega|Ride"] = 79.36, ["Mega|Fly|Ride"] = 168.55}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.92, ["Neon"] = 10.26, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 626.45}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.75, ["Ride"] = 26.25, ["Fly|Ride"] = 122.27, ["Neon"] = 94.5, ["Neon|Ride"] = 104.43, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 328.13, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 547.11}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 48.15, ["Ride"] = 98.43, ["Neon"] = 155.04, ["Neon|Ride"] = 410.7, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 540.75, ["Mega|Ride"] = 605.57, ["Mega|Fly|Ride"] = 749.65}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 138.68, ["Fly"] = 1392.79, ["Ride"] = 196.88, ["Fly|Ride"] = 245.18, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6264.35, ["Mega|Fly|Ride"] = 2565.94}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.64, ["Fly"] = 28.21, ["Ride"] = 44.98, ["Fly|Ride"] = 675.94, ["Neon"] = 59.43, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 195.25, ["Mega|Fly"] = 208.82, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 237.02}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 3.94, ["Ride"] = 62.66, ["Neon"] = 14.04, ["Neon|Fly"] = 98.17, ["Neon|Fly|Ride"] = 522.04, ["Mega"] = 104.79, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 843.82}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.81, ["Fly"] = 101.99, ["Ride"] = 41.2, ["Fly|Ride"] = 196.88, ["Neon"] = 7.87, ["Neon|Ride"] = 47.36, ["Mega"] = 74.82, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 235.97}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.98, ["Ride"] = 98.44, ["Neon"] = 167.07, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 687.1}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.98, ["Neon"] = 2.1, ["Neon|Ride"] = 58.28, ["Mega"] = 16.75, ["Mega|Ride"] = 155.67, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Fly"] = 208.82, ["Ride"] = 98.43, ["Fly|Ride"] = 144.38, ["Neon"] = 355, ["Neon|Fly"] = 501.22, ["Neon|Ride"] = 412.42, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.07, ["Neon|Ride"] = 137.67, ["Mega"] = 52.5, ["Mega|Ride"] = 142.05}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 60.37, ["Fly"] = 221.28, ["Ride"] = 90.26, ["Fly|Ride"] = 139.93, ["Neon"] = 210, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 2625, ["Mega|Ride"] = 2683.13, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 69.98, ["Neon"] = 6.54, ["Neon|Fly"] = 120.09, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 52.5, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 130.39}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.24, ["Ride"] = 40.69, ["Neon"] = 10.91, ["Neon|Ride"] = 118.13, ["Mega"] = 104.22, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.5, ["Ride"] = 53.55, ["Fly|Ride"] = 139.93, ["Neon"] = 57.66, ["Neon|Ride"] = 158.59, ["Neon|Fly|Ride"] = 176.31, ["Mega"] = 236.25, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 367.95, ["Fly"] = 557.53, ["Ride"] = 416.94, ["Fly|Ride"] = 525, ["Neon"] = 1279.69, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1260, ["Mega|Ride"] = 4901.86, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.59, ["Ride"] = 44.09, ["Fly|Ride"] = 92.78, ["Neon"] = 236.66, ["Neon|Fly"] = 315.98, ["Neon|Ride"] = 236.63, ["Neon|Fly|Ride"] = 281.91, ["Mega|Ride"] = 828.99, ["Mega|Fly|Ride"] = 946.86}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 47.38, ["Ride"] = 17.06, ["Fly|Ride"] = 91.88, ["Neon"] = 9.13, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 83.54, ["Mega"] = 46.95, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 195.25}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.64, ["Fly"] = 366.35, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 51.01, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 195.11, ["Mega"] = 209.93, ["Mega|Fly"] = 389.34, ["Mega|Ride"] = 232.85, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.07, ["Ride"] = 23.12, ["Fly|Ride"] = 265.2, ["Neon"] = 126.02, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 316.02, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 516.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.27, ["Neon"] = 18.81, ["Mega"] = 59.06, ["Mega|Ride"] = 150.23, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 86.62, ["Ride"] = 17.14, ["Fly|Ride"] = 57.77, ["Neon"] = 26.25, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 552.74, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 115.5, ["Ride"] = 111.57, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 615.57, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 2923.36, ["Mega|Fly|Ride"] = 3478.8}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.88, ["Fly"] = 95.82, ["Ride"] = 115.62, ["Fly|Ride"] = 158.58, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 724.6, ["Mega|Ride"] = 731.46, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2349.37, ["Ride"] = 2533.13, ["Fly|Ride"] = 2362.5, ["Neon"] = 11136.96, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 110.24, ["Fly|Ride"] = 170.63, ["Neon"] = 15, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 195.25, ["Mega"] = 126, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 584.68}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.92, ["Ride"] = 43.86, ["Neon"] = 41.77, ["Neon|Ride"] = 100.46, ["Mega"] = 278.77, ["Mega|Ride"] = 412.55, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 840, ["Fly"] = 1448.11, ["Ride"] = 885.91, ["Fly|Ride"] = 984.38, ["Neon"] = 2278.33, ["Neon|Ride"] = 2968.8, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11415.71}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.5, ["Ride"] = 74.23, ["Neon"] = 237.59, ["Neon|Ride"] = 291.72, ["Mega"] = 720.42, ["Mega|Ride"] = 703.8, ["Mega|Fly|Ride"] = 688.26}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 4.38, ["Ride"] = 21.76, ["Fly|Ride"] = 128.15, ["Neon"] = 13.02, ["Neon|Ride"] = 473.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 91.88, ["Mega|Ride"] = 331.41, ["Mega|Fly|Ride"] = 345.59}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.57, ["Ride"] = 140.27, ["Neon"] = 3.68, ["Neon|Ride"] = 26.06, ["Neon|Fly|Ride"] = 55.64, ["Mega"] = 32.04, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 51.45, ["Ride"] = 126, ["Fly|Ride"] = 315.95, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2228.03, ["Mega|Fly|Ride"] = 2683.13}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.27, ["Neon"] = 27.36, ["Neon|Ride"] = 90.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 59.07, ["Ride"] = 97.64, ["Fly|Ride"] = 158.58, ["Neon"] = 341.25, ["Neon|Ride"] = 416.59, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1956.75}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3, ["Fly"] = 104.98, ["Neon"] = 33.44, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 72.19, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.26, ["Ride"] = 262.49, ["Fly|Ride"] = 324.19, ["Neon"] = 902.01, ["Neon|Ride"] = 761.25, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4175.19}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.62, ["Fly"] = 87.72, ["Ride"] = 28.21, ["Fly|Ride"] = 41.79, ["Neon"] = 53.82, ["Neon|Ride"] = 64.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1136.23, ["Mega|Ride"] = 249.54, ["Mega|Fly|Ride"] = 696.4}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 17.03, ["Fly|Ride"] = 39.37, ["Neon"] = 4.53, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 27.16, ["Neon|Fly|Ride"] = 48.56, ["Mega"] = 66.99, ["Mega|Fly"] = 120.08, ["Mega|Ride"] = 60.37, ["Mega|Fly|Ride"] = 139.93}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 866.25, ["Ride"] = 914.82, ["Fly|Ride"] = 1114.32, ["Neon|Ride"] = 7657.12, ["Neon|Fly|Ride"] = 4743.38, ["Mega"] = 26450.11, ["Mega|Fly|Ride"] = 27841.84}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.16, ["Fly"] = 975.16, ["Ride"] = 56.4, ["Neon"] = 47.16, ["Neon|Fly"] = 98.17, ["Neon|Ride"] = 69.98, ["Mega"] = 208.15, ["Mega|Ride"] = 268.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.97, ["Ride"] = 26.25, ["Fly|Ride"] = 78.31, ["Neon"] = 29.28, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 55.69, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 160.96, ["Mega|Ride"] = 236.73, ["Mega|Fly|Ride"] = 292.35}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.88, ["Fly"] = 35.35, ["Ride"] = 43.22, ["Fly|Ride"] = 66.94, ["Neon"] = 181.68, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 170.51, ["Mega"] = 2088.13, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.44, ["Fly"] = 78.31, ["Ride"] = 27.56, ["Fly|Ride"] = 87.94, ["Neon"] = 64.2, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 142.05, ["Mega"] = 367.5, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 417.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 19.57, ["Ride"] = 59.07, ["Fly|Ride"] = 110.69, ["Neon"] = 92.26, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 473.44, ["Mega"] = 480.29, ["Mega|Ride"] = 555.44, ["Mega|Fly|Ride"] = 691.18}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Fly|Ride"] = 236.66, ["Neon"] = 2.63, ["Neon|Ride"] = 28.21, ["Mega"] = 15.37, ["Mega|Fly"] = 85.23, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 89.07}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 43.31, ["Fly"] = 87.94, ["Ride"] = 58.77, ["Fly|Ride"] = 105, ["Neon"] = 270.43, ["Neon|Fly"] = 284.03, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 3340.99, ["Mega|Ride"] = 1152.65, ["Mega|Fly|Ride"] = 1056.12}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.86, ["Fly"] = 19.69, ["Ride"] = 27.17, ["Fly|Ride"] = 70.88, ["Neon"] = 31.5, ["Mega"] = 773.07, ["Mega|Ride"] = 306.6, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 20.88, ["Fly|Ride"] = 38.05, ["Neon"] = 15.75, ["Neon|Ride"] = 52.98, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.92, ["Ride"] = 103.69, ["Neon"] = 41.91, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 292.35, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 30.78, ["Fly"] = 262.39, ["Ride"] = 88.1, ["Fly|Ride"] = 236.25, ["Neon"] = 115.5, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 320.54, ["Mega"] = 820.63, ["Mega|Ride"] = 774.06, ["Mega|Fly|Ride"] = 670.69}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.33, ["Neon"] = 26.18, ["Neon|Ride"] = 73.06, ["Neon|Fly|Ride"] = 120.73, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 316.02}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.4, ["Neon|Ride"] = 111.72, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 17.06, ["Mega|Ride"] = 50.03, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 22.98, ["Fly|Ride"] = 81.99, ["Neon"] = 2.1, ["Neon|Ride"] = 32.71, ["Mega"] = 39.36, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 18.81, ["Ride"] = 72.16, ["Fly|Ride"] = 50.86, ["Neon"] = 11.5, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 54.31, ["Mega"] = 45.94, ["Mega|Ride"] = 278.77, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.72, ["Fly|Ride"] = 5324.74, ["Neon"] = 13.27, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.63, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 58.48, ["Neon"] = 13.81, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 397.04, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 79.28, ["Ride"] = 150.94, ["Neon"] = 236.66, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1044.07, ["Mega"] = 834.21, ["Mega|Ride"] = 865.19, ["Mega|Fly|Ride"] = 1114.02}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.88, ["Ride"] = 18.81, ["Fly|Ride"] = 44.62, ["Neon"] = 3.84, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 47.36, ["Mega"] = 27.6, ["Mega|Ride"] = 54.31, ["Mega|Fly|Ride"] = 90.57}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.87, ["Fly"] = 62.66, ["Ride"] = 47.49, ["Fly|Ride"] = 78.32, ["Neon"] = 58.48, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 107.52, ["Mega"] = 393.75, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 303.45}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 12.91, ["Fly"] = 39.38, ["Ride"] = 26.92, ["Fly|Ride"] = 78.73, ["Neon"] = 82.93, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 93.85, ["Neon|Fly|Ride"] = 156.85, ["Mega"] = 1125.51, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 468.4}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.84, ["Fly"] = 140.44, ["Ride"] = 47.34, ["Neon"] = 45.85, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 412.42}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 17.82, ["Fly|Ride"] = 39.38, ["Neon"] = 3.86, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 46.71, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 111.72}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.84, ["Fly"] = 63.95, ["Ride"] = 28.21, ["Neon"] = 12.54, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 277.73}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1225.73, ["Ride"] = 1034.25, ["Fly|Ride"] = 1062.03, ["Neon"] = 2767.8, ["Neon|Fly"] = 2713.86, ["Neon|Ride"] = 2165.63, ["Neon|Fly|Ride"] = 2182.69, ["Mega|Fly|Ride"] = 6928.69}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 52.5, ["Fly"] = 158.58, ["Ride"] = 114.93, ["Fly|Ride"] = 189.33, ["Neon"] = 358.12, ["Neon|Ride"] = 390.53, ["Neon|Fly|Ride"] = 471.93, ["Mega"] = 1810.4, ["Mega|Ride"] = 1767.6, ["Mega|Fly|Ride"] = 1016.93}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.6, ["Neon"] = 6.57, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 208.82, ["Mega"] = 76.56, ["Mega|Ride"] = 78.31, ["Mega|Fly|Ride"] = 181.68}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 45.94, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 157.5, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 355.08, ["Mega"] = 971.25, ["Mega|Ride"] = 968.18, ["Mega|Fly|Ride"] = 1006.44}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 10.45, ["Ride"] = 64.75, ["Fly|Ride"] = 156.19, ["Neon"] = 121.03, ["Neon|Ride"] = 213.06, ["Neon|Fly|Ride"] = 277.73, ["Mega"] = 268.55, ["Mega|Ride"] = 284.07, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 236.92, ["Fly"] = 417.63, ["Ride"] = 262.5, ["Fly|Ride"] = 312.4, ["Neon"] = 1131.9, ["Neon|Ride"] = 1110.88, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 4420.6}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.62, ["Fly"] = 100.33, ["Ride"] = 22.73, ["Fly|Ride"] = 202.64, ["Neon"] = 19.69, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 56.4, ["Mega"] = 412.42, ["Mega|Fly"] = 278.77}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 69.98, ["Mega"] = 334.11}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 60.42, ["Fly"] = 111.72, ["Ride"] = 95.03, ["Fly|Ride"] = 167.07, ["Neon"] = 444.78, ["Neon|Ride"] = 395.32, ["Neon|Fly|Ride"] = 236.73, ["Mega"] = 542, ["Mega|Ride"] = 554.4, ["Mega|Fly|Ride"] = 793.49}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 15.7, ["Mega"] = 158.62, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.67, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 23.69, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 62.99, ["Mega|Ride"] = 39.36, ["Mega|Fly|Ride"] = 104.16}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 3937.5, ["Fly|Ride"] = 4349.63, ["Neon"] = 31321.66, ["Neon|Fly|Ride"] = 22724.28, ["Mega|Fly|Ride"] = 62643.32}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.83, ["Ride"] = 56.43, ["Neon"] = 69.91, ["Neon|Ride"] = 106.32, ["Mega"] = 275.65, ["Mega|Ride"] = 293.54, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 3.94, ["Fly"] = 20.09, ["Ride"] = 20.9, ["Fly|Ride"] = 45.95, ["Neon"] = 13, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 30.61, ["Neon|Fly|Ride"] = 71.09, ["Mega"] = 144.38, ["Mega|Ride"] = 136.79, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 450.21, ["Fly"] = 840, ["Ride"] = 518.44, ["Fly|Ride"] = 525, ["Neon"] = 1371.57, ["Neon|Ride"] = 1460.42, ["Neon|Fly|Ride"] = 1234.4, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.94, ["Ride"] = 19.4, ["Neon"] = 17.06, ["Neon|Ride"] = 145.68, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.11, ["Fly"] = 139.93, ["Ride"] = 35.44, ["Neon"] = 19.85, ["Neon|Ride"] = 278.77, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 411.48, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.34, ["Ride"] = 18.27, ["Neon"] = 3.94, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 26.06, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 39.65, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 702.19, ["Fly"] = 821.69, ["Ride"] = 638.86, ["Fly|Ride"] = 706.57, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1745.01}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Ride"] = 57.75, ["Neon"] = 29.94, ["Neon|Ride"] = 74.81, ["Neon|Fly|Ride"] = 179.59, ["Mega"] = 98.44, ["Mega|Ride"] = 169.95, ["Mega|Fly|Ride"] = 255.93}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.45, ["Fly"] = 236.15, ["Ride"] = 53.66, ["Fly|Ride"] = 131.25, ["Neon"] = 49.14, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 69.98, ["Neon|Fly|Ride"] = 154.22, ["Mega"] = 253.3, ["Mega|Ride"] = 273.56, ["Mega|Fly|Ride"] = 327.85}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.5, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 12.48, ["Neon|Fly"] = 98.17, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 195.34, ["Mega|Fly"] = 139.93, ["Mega|Fly|Ride"] = 221.36}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21.15, ["Ride"] = 26.25, ["Neon"] = 118.13, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 136.79, ["Mega"] = 501.16, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 39.97, ["Mega|Ride"] = 97.48, ["Mega|Fly|Ride"] = 251.42}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 432.46, ["Ride"] = 472.5, ["Fly|Ride"] = 557.53, ["Neon"] = 2587.83, ["Neon|Ride"] = 2436.84, ["Neon|Fly|Ride"] = 2505.76, ["Mega"] = 9311.04, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 79.29, ["Neon"] = 11.79, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 69.57, ["Mega|Ride"] = 162.1, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 4.44, ["Neon|Fly"] = 139.94, ["Neon|Ride"] = 212.98, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 44.99, ["Mega|Fly"] = 98.16, ["Mega|Ride"] = 139.93, ["Mega|Fly|Ride"] = 208.82}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 22.28, ["Neon"] = 3.94, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 39.36, ["Mega|Fly"] = 154.53, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 6.57, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 47.36, ["Mega"] = 105, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 131.25, ["Ride"] = 316.64, ["Fly|Ride"] = 498.74, ["Neon"] = 215.37, ["Neon|Ride"] = 334.11, ["Neon|Fly|Ride"] = 2367.12, ["Mega"] = 1278.25, ["Mega|Ride"] = 2088.13, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 18.8, ["Fly"] = 69.04, ["Ride"] = 103, ["Fly|Ride"] = 91.87, ["Neon"] = 100.96, ["Neon|Ride"] = 152.66, ["Neon|Fly|Ride"] = 213.06, ["Mega"] = 463.31, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.75, ["Fly"] = 32.7, ["Ride"] = 18.81, ["Fly|Ride"] = 48.04, ["Neon"] = 20.9, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 89.8, ["Mega"] = 299.92, ["Mega|Ride"] = 319.5, ["Mega|Fly|Ride"] = 165.03}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.71, ["Ride"] = 64.32, ["Fly|Ride"] = 99.21, ["Neon"] = 89.25, ["Mega"] = 329.94, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 6.27, ["Fly"] = 129.94, ["Ride"] = 31.34, ["Fly|Ride"] = 60.61, ["Neon"] = 32.39, ["Neon|Ride"] = 68.93, ["Neon|Fly|Ride"] = 210.7, ["Mega"] = 177.45, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 473.44}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.57, ["Fly"] = 68.93, ["Ride"] = 26.25, ["Fly|Ride"] = 31.7, ["Neon"] = 228.74, ["Neon|Ride"] = 195.25, ["Neon|Fly|Ride"] = 322.23, ["Mega"] = 938.62, ["Mega|Ride"] = 946.86, ["Mega|Fly|Ride"] = 766.35}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 139.93, ["Neon|Ride"] = 552.74, ["Mega|Ride"] = 316.02}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 46.7, ["Fly"] = 115.5, ["Ride"] = 82.42, ["Fly|Ride"] = 124.69, ["Neon"] = 273, ["Neon|Fly"] = 348.77, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 1681.67, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 49.88, ["Fly"] = 71.31, ["Ride"] = 60.38, ["Neon"] = 156.18, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 208.82, ["Mega"] = 596.47, ["Mega|Ride"] = 647.42, ["Mega|Fly|Ride"] = 696.22}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.38, ["Fly"] = 57.75, ["Ride"] = 56.4, ["Neon"] = 137.84, ["Mega"] = 698.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.07, ["Fly"] = 32.82, ["Ride"] = 42.86, ["Fly|Ride"] = 110.42, ["Neon"] = 70.17, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 151.17, ["Mega"] = 349.49, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.72, ["Ride"] = 15.67, ["Fly|Ride"] = 41.77, ["Neon"] = 5.25, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 52.86, ["Mega|Fly"] = 208.82, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1737.75}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 25.47, ["Ride"] = 56.4, ["Fly|Ride"] = 167.07, ["Neon"] = 142.03, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 555.44, ["Mega"] = 504.3, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 529.35}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 16.71, ["Neon"] = 3.65, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 292.35, ["Mega"] = 30.19, ["Mega|Ride"] = 63}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 35.44, ["Fly"] = 118.34, ["Ride"] = 67.46, ["Neon"] = 393.75, ["Neon|Ride"] = 154.53, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 625.41, ["Mega|Ride"] = 720.85, ["Mega|Fly|Ride"] = 1221.94}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.5, ["Neon|Ride"] = 105, ["Mega"] = 27.57}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 47.36, ["Mega"] = 30.86, ["Mega|Fly"] = 139.93, ["Mega|Ride"] = 136.12, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 111.9, ["Fly"] = 329.94, ["Ride"] = 139.93, ["Fly|Ride"] = 224.83, ["Neon"] = 431.4, ["Neon|Ride"] = 484.45, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 2241.67, ["Mega|Fly|Ride"] = 2066.3}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 35.51, ["Fly|Ride"] = 73.1, ["Neon"] = 11.84, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 139.93, ["Mega"] = 90.15, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 557.53}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.91, ["Neon|Fly"] = 62.67, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 34.13, ["Mega|Ride"] = 117.18, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 37.43, ["Mega"] = 31.87, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 31.82, ["Mega"] = 49.64, ["Mega|Ride"] = 96.55, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 111.57, ["Fly|Ride"] = 449.61, ["Neon"] = 348.91, ["Neon|Ride"] = 456.26, ["Neon|Fly|Ride"] = 417.63, ["Mega"] = 1564.01, ["Mega|Ride"] = 1566.1, ["Mega|Fly|Ride"] = 1262.87}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.25, ["Ride"] = 37.3, ["Neon"] = 36.23, ["Neon|Ride"] = 142.05, ["Mega"] = 250.38, ["Mega|Ride"] = 840.67, ["Mega|Fly|Ride"] = 217.18}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 416.59, ["Fly|Ride"] = 616.88, ["Neon"] = 1211.12, ["Neon|Fly"] = 1199.93, ["Neon|Ride"] = 1531.64, ["Neon|Fly|Ride"] = 1278.25, ["Mega|Fly|Ride"] = 3340.99}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.43}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.63}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.47}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.23}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 185.32}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 34.9}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 27.92}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 16.75}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.51}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 11.39}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.35}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.22}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 7.54}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.57}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 696.4}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.5}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1531.64}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 43.32}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.42}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.99}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 48.04}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 52.39}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.75}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.57}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.29}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.74}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 157.5}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 39.68}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.92}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1785}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 26.55}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 298.75}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.27}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.94}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 13.07}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.48}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 144.38}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 31.99}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 31.89}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.19}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 10658.04}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 20.99}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 27.57}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.77}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 157.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.25}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 13.13}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.59}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 15.65}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 3.92}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 17.76}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 319.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.63}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 111.57}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 134.1}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.11}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 11.45}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 22.21}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 58.46}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 102.38}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22534.85}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.67}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 31.77}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 73.1}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 129.94}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 65.36}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 60.57}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 52.5}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 109.65}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 82.07}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.34}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 11.73}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.71}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.67}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.74}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 80.54}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.6}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.97}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.07}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 245.4}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 2073.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.33}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 524.99}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.88}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 32.16}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 93.2}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 100.05}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 42.99}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 55.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.62}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.4}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.4}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.78}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 33.11}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.25}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.62}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.19}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.44}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 131.25}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1043.02}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.22}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.95}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 158.54}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.36}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.56}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.44}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.5}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 32.24}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 132.46}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 71.47}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 45.94}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.7}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 17.06}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.94}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 15.67}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 70.93}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.13}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.62}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.86}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.62}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 34.13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.44}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.57}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.18}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.13}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.98}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.27}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.64}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 190.03}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 5.07}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.02}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 19.64}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 7.87}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.84}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2603.89}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.2}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.36}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 9.19}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.14}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 85.32}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.19}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.15}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.11}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 15.74}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 4.45}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.62}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 6.27}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.62}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 12.45}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.66}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 145.69}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.47}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 58.64}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.8}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 140.01}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 20.58}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.56}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.57}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 26.17}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 14.26}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.4}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 26.16}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.71}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.85}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 14.6}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 10.45}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.74}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.64}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 61.1}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 237.35}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.29}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.51}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 6.43}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 52.5}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.09}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.62}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 100.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.56}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.17}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 15.74}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 11.5}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.75}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 6.81}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 16.69}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.87}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 123.36}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.88}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 10.45}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 204.75}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 18.36}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 43.22}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.86}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 139.93}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.38}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.62}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 4.18}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 15.64}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 41.36}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.98}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.03}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.64}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.87}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.3}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 102.38}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.21}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.96}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 15.69}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 78.75}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 57.87}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 362.23}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.19}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 104.81}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 98.82}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.5}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.2}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.24}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.55}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 15.65}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.99}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 17.54}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 28.04}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 48.05}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.61}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.01}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 170.63}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 4.18}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1233.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.33}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.5}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 36.63}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 328.79}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.69}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.9}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 236.38}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.21}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.35}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.5}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 103.68}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 105}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 131.24}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.53}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2625}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 374.07}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.42}},
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