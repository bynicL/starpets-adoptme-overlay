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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1497.21, ["Ride"] = 1312.5, ["Fly|Ride"] = 1673.99, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 454.68, ["Fly"] = 623.75, ["Ride"] = 457.68, ["Fly|Ride"] = 525, ["Neon"] = 2094.52, ["Neon|Fly|Ride"] = 2072.43, ["Mega|Fly|Ride"] = 9002.22}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.24, ["Ride"] = 4829.99, ["Fly|Ride"] = 4800, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 68840.28}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 128.63, ["Ride"] = 182.06, ["Fly|Ride"] = 265.76, ["Neon"] = 787.85, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 788.37, ["Mega"] = 4049.75, ["Mega|Fly|Ride"] = 2639.1}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 555.41, ["Fly"] = 698.9, ["Ride"] = 539.44, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1522.5, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.5, ["Ride"] = 27.57, ["Fly|Ride"] = 140.21, ["Neon"] = 73.38, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 275.13, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.16, ["Fly"] = 35.44, ["Ride"] = 31.49, ["Fly|Ride"] = 52.33, ["Neon"] = 40.17, ["Neon|Fly"] = 110.02, ["Neon|Ride"] = 62.85, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 173.25, ["Mega|Fly"] = 274.18, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.83, ["Fly"] = 195.66, ["Ride"] = 161.14, ["Fly|Ride"] = 182.44, ["Neon"] = 556.7, ["Neon|Ride"] = 599.05, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2303.98}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.04, ["Fly"] = 53.82, ["Ride"] = 54.42, ["Fly|Ride"] = 94.5, ["Neon"] = 338.28, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 277.09, ["Mega"] = 1397.05, ["Mega|Ride"] = 1063.59, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.69, ["Fly"] = 31.25, ["Ride"] = 36.63, ["Fly|Ride"] = 78.75, ["Neon"] = 140.21, ["Neon|Ride"] = 165.71, ["Neon|Fly|Ride"] = 229.68, ["Mega|Ride"] = 752.99, ["Mega|Fly|Ride"] = 788.24}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 47.9, ["Fly"] = 124.51, ["Ride"] = 73.5, ["Fly|Ride"] = 118.13, ["Neon"] = 315.59, ["Neon|Ride"] = 250.31, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1418.11}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 56.41}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 300.95, ["Ride"] = 314.99, ["Fly|Ride"] = 372.75, ["Neon"] = 1450.24, ["Neon|Ride"] = 1418.32, ["Neon|Fly|Ride"] = 1202.28, ["Mega|Fly|Ride"] = 5026.85}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 131.14, ["Ride"] = 112.18, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 483, ["Mega|Fly|Ride"] = 2513.43}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 115.91, ["Ride"] = 49.98, ["Fly|Ride"] = 209.26, ["Neon"] = 32.44, ["Neon|Ride"] = 65.62, ["Mega"] = 131.25, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 152.23, ["Fly"] = 196.88, ["Ride"] = 157.5, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 575.33, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 27.19, ["Ride"] = 20.93, ["Fly|Ride"] = 47.44, ["Neon"] = 32.82, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 56.43, ["Fly"] = 140.21, ["Ride"] = 98.44, ["Fly|Ride"] = 240.84, ["Neon"] = 249.38, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 1385.95, ["Mega|Ride"] = 945.41, ["Mega|Fly|Ride"] = 1041.24}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 103.69, ["Ride"] = 459.38, ["Fly|Ride"] = 228.1, ["Neon"] = 837.82, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 3151.73}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.82, ["Fly"] = 374.07, ["Ride"] = 32.36, ["Fly|Ride"] = 78.92, ["Neon"] = 144.38, ["Neon|Ride"] = 344.01, ["Neon|Fly|Ride"] = 192.71, ["Mega"] = 698.54, ["Mega|Ride"] = 564.5, ["Mega|Fly|Ride"] = 1675.63}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 30.19, ["Fly"] = 94.53, ["Ride"] = 49.88, ["Fly|Ride"] = 125.99, ["Neon"] = 682.16, ["Neon|Fly"] = 312.1, ["Neon|Ride"] = 221.37, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 1654.46, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 37.05, ["Fly"] = 416.51, ["Ride"] = 155.76, ["Fly|Ride"] = 138.12, ["Neon"] = 204.75, ["Neon|Fly"] = 392.41, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 346.5, ["Mega"] = 1234.73, ["Mega|Ride"] = 1252.54, ["Mega|Fly|Ride"] = 1103.76}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 45.94, ["Ride"] = 57.75, ["Fly|Ride"] = 129.29, ["Neon"] = 141.75, ["Neon|Ride"] = 289.69, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 61.46, ["Fly"] = 593.6, ["Ride"] = 80.33, ["Fly|Ride"] = 158.29, ["Neon"] = 434.62, ["Neon|Ride"] = 309.74, ["Mega|Ride"] = 974.58, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.9, ["Fly"] = 36.63, ["Ride"] = 22.45, ["Fly|Ride"] = 52.5, ["Neon"] = 35.44, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 137.82, ["Mega|Fly"] = 223.13, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 355.04, ["Ride"] = 381.09, ["Fly|Ride"] = 437.06, ["Neon|Ride"] = 1671.43, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 12567.08, ["Mega|Fly|Ride"] = 7330.8}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.7, ["Ride"] = 34.33, ["Fly|Ride"] = 105.18, ["Neon"] = 251.11, ["Neon|Fly|Ride"] = 427.29, ["Mega|Fly|Ride"] = 904.85}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.56, ["Fly"] = 49.19, ["Ride"] = 23.62, ["Fly|Ride"] = 45.94, ["Neon"] = 41.7, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 91.25, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 125.28, ["Fly"] = 140.21, ["Ride"] = 138.12, ["Fly|Ride"] = 158.29, ["Neon|Ride"] = 728.44, ["Neon|Fly|Ride"] = 434.62, ["Mega"] = 2077.77, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1890.81}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 18.84, ["Fly"] = 33.49, ["Ride"] = 28.26, ["Fly|Ride"] = 118.13, ["Neon"] = 189, ["Neon|Ride"] = 126.49, ["Neon|Fly|Ride"] = 159.81, ["Mega"] = 709.07, ["Mega|Ride"] = 638.84, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 174.71, ["Fly"] = 353.63, ["Ride"] = 183.75, ["Fly|Ride"] = 265.76, ["Neon"] = 786.78, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6283.55, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2858.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.53, ["Fly"] = 33.8, ["Ride"] = 24.94, ["Fly|Ride"] = 54.42, ["Neon"] = 26.17, ["Neon|Fly"] = 4635.62, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 155.01, ["Mega"] = 144.38, ["Mega|Fly"] = 283.64, ["Mega|Ride"] = 235.66, ["Mega|Fly|Ride"] = 284.82}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1397.82, ["Fly"] = 4528.13, ["Ride"] = 1706.25, ["Fly|Ride"] = 1430.63, ["Neon"] = 6702.45, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 53178.44, ["Mega|Fly|Ride"] = 31416.62}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.49, ["Fly"] = 69.06, ["Ride"] = 41.25, ["Fly|Ride"] = 89.99, ["Neon"] = 104.42, ["Neon|Ride"] = 140.35, ["Neon|Fly|Ride"] = 141.84, ["Mega"] = 511.88, ["Mega|Ride"] = 627.32, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 104.9, ["Fly"] = 140.21, ["Ride"] = 105, ["Fly|Ride"] = 249.38, ["Neon"] = 929.98, ["Neon|Ride"] = 689.07, ["Neon|Fly|Ride"] = 1030.52, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2764.77}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.2}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 22.32, ["Fly"] = 68.85, ["Ride"] = 64.32, ["Fly|Ride"] = 139.64, ["Neon"] = 137.82, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 689.87, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 709.07}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 124.69, ["Ride"] = 140.21, ["Fly|Ride"] = 205.54, ["Neon"] = 525, ["Neon|Ride"] = 586.48, ["Mega|Fly|Ride"] = 2207.51}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.23, ["Ride"] = 150.94, ["Fly|Ride"] = 236.25, ["Neon"] = 448.25, ["Neon|Ride"] = 366.19, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 1654.68, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1658.87}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 64.32, ["Fly"] = 87.43, ["Ride"] = 65.63, ["Fly|Ride"] = 65.63, ["Neon"] = 601.14, ["Neon|Ride"] = 401.86, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 4189.03, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.19, ["Ride"] = 39.38, ["Fly|Ride"] = 70.11, ["Neon"] = 37.68, ["Neon|Ride"] = 70.18, ["Neon|Fly|Ride"] = 233.56, ["Mega"] = 224.55, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 391, ["Fly"] = 406.88, ["Ride"] = 418.11, ["Fly|Ride"] = 437.07, ["Neon|Ride"] = 1568.73, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 6121.5}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 83.99, ["Fly"] = 119.28, ["Ride"] = 91.88, ["Fly|Ride"] = 140.16, ["Neon"] = 460.36, ["Neon|Ride"] = 457.43, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 1885.07, ["Mega|Fly|Ride"] = 1956.29}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7116.14, ["Fly"] = 3543.75, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14660.55}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 35.44, ["Fly"] = 111.96, ["Ride"] = 57.75, ["Fly|Ride"] = 103.59, ["Neon"] = 393.75, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 314.25, ["Mega|Ride"] = 1627.45, ["Mega|Fly|Ride"] = 1439.99}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Ride"] = 57.74, ["Fly|Ride"] = 202.99, ["Neon"] = 656.25, ["Neon|Ride"] = 326.75, ["Neon|Fly|Ride"] = 698.54, ["Mega"] = 6283.55, ["Mega|Fly|Ride"] = 1662.01}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.73, ["Fly"] = 81.29, ["Ride"] = 70.11, ["Fly|Ride"] = 140.21, ["Neon"] = 249.04, ["Neon|Fly"] = 472.78, ["Neon|Ride"] = 182.23, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 2598.75, ["Mega|Ride"] = 680.74, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.39}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.92, ["Ride"] = 56.39, ["Fly|Ride"] = 72.18, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 501.65, ["Mega|Fly|Ride"] = 1569.86}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 22.46}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 282.85, ["Ride"] = 783.64, ["Fly|Ride"] = 320.17, ["Neon|Ride"] = 1397.05, ["Neon|Fly|Ride"] = 2513.43}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 955.5, ["Fly|Ride"] = 945, ["Neon|Ride"] = 3543.75, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 15708.83}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.81, ["Fly"] = 52.47, ["Ride"] = 38.94, ["Fly|Ride"] = 64.32, ["Neon"] = 162.75, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 761.15, ["Mega|Fly|Ride"] = 765.7}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 12.47}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5272.04, ["Ride"] = 4659.38, ["Fly|Ride"] = 4723.68, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 39376.8}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 17.06, ["Fly"] = 74.65, ["Ride"] = 24.07, ["Fly|Ride"] = 54.99, ["Neon"] = 52.5, ["Neon|Ride"] = 98.12, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 446.15, ["Mega|Ride"] = 631.07, ["Mega|Fly|Ride"] = 524.85}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.53, ["Fly"] = 191.66, ["Ride"] = 34.9, ["Fly|Ride"] = 116.95, ["Neon"] = 140.21, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 179.09, ["Mega"] = 1047.27, ["Mega|Ride"] = 626.28, ["Mega|Fly|Ride"] = 709.07}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 223.13, ["Ride"] = 124.68, ["Fly|Ride"] = 98.09, ["Neon"] = 1397.05, ["Neon|Fly|Ride"] = 559.26, ["Mega"] = 4189.03}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 14.2, ["Ride"] = 28.88, ["Fly|Ride"] = 139.65, ["Neon"] = 56.57, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 364.46, ["Mega|Ride"] = 510.03, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 2459.7, ["Ride"] = 1903.13, ["Fly|Ride"] = 2085.57, ["Neon|Fly|Ride"] = 4566.18, ["Mega|Fly|Ride"] = 15091.13}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30698.72, ["Fly"] = 35281.67, ["Ride"] = 34875.08, ["Fly|Ride"] = 22312.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 212556.54}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 14.44, ["Fly"] = 37.68, ["Ride"] = 39.38, ["Fly|Ride"] = 125.56, ["Neon"] = 140.21, ["Neon|Ride"] = 170.21, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 833.62, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1468.92}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.29, ["Fly"] = 59.85, ["Ride"] = 48.57, ["Fly|Ride"] = 108.83, ["Neon"] = 22.32, ["Neon|Fly"] = 98.45, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 139.63, ["Mega"] = 186.37, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 339.33}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.49, ["Ride"] = 52.49, ["Fly|Ride"] = 45, ["Neon"] = 60.38, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 415.75, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 667.08, ["Ride"] = 656.25, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2827.6, ["Mega|Fly|Ride"] = 11030.4}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 900.38, ["Ride"] = 820.32, ["Fly|Ride"] = 976.5, ["Neon"] = 4189.03, ["Neon|Fly|Ride"] = 2771.81, ["Mega|Fly|Ride"] = 9775.1}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 32.82, ["Fly"] = 118.14, ["Ride"] = 40.82, ["Fly|Ride"] = 97.13, ["Neon"] = 145.69, ["Neon|Ride"] = 274.32, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 835.11, ["Mega|Ride"] = 682.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.85}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 59.37, ["Fly"] = 111.57, ["Ride"] = 74.82, ["Fly|Ride"] = 119.44, ["Neon"] = 418.91, ["Neon|Ride"] = 355.04, ["Neon|Fly|Ride"] = 367.36, ["Mega|Fly|Ride"] = 1801.3}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 58.93, ["Ride"] = 64.31, ["Fly|Ride"] = 190.43, ["Neon"] = 450.19, ["Neon|Ride"] = 631.16, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1757.31, ["Mega|Fly|Ride"] = 1695.15}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.92, ["Fly"] = 32.8, ["Ride"] = 22.32, ["Fly|Ride"] = 52.86, ["Neon"] = 28.16, ["Neon|Fly"] = 525, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 139.19, ["Mega"] = 157.5, ["Mega|Ride"] = 397.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 74.82, ["Fly"] = 90.03, ["Ride"] = 97.13, ["Fly|Ride"] = 140.7, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.67, ["Ride"] = 46.05, ["Fly|Ride"] = 105, ["Neon"] = 23.63, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 229.69, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 394.72}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 16.76, ["Fly"] = 40.28, ["Ride"] = 31.96, ["Fly|Ride"] = 65.63, ["Neon"] = 140.35, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 740.42, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 24.94, ["Ride"] = 63.8, ["Fly|Ride"] = 156.19, ["Neon"] = 158.4, ["Neon|Ride"] = 698.54, ["Mega"] = 694.25, ["Mega|Ride"] = 551.88, ["Mega|Fly|Ride"] = 871.68}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.07, ["Fly"] = 101.3, ["Ride"] = 35.78, ["Fly|Ride"] = 83.48, ["Neon"] = 103.69, ["Neon|Fly"] = 559.26, ["Neon|Ride"] = 125.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1047.27, ["Mega|Ride"] = 991.76, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5250, ["Ride"] = 7087.77, ["Fly|Ride"] = 5701.49, ["Neon"] = 34909.22, ["Neon|Fly|Ride"] = 22200.77}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 196.88, ["Fly"] = 272.9, ["Ride"] = 235.6, ["Fly|Ride"] = 262.48, ["Neon|Ride"] = 694.99, ["Neon|Fly|Ride"] = 579.5, ["Mega|Fly|Ride"] = 1860.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 34.15, ["Fly"] = 127.65, ["Ride"] = 62.32, ["Fly|Ride"] = 131.27, ["Neon"] = 91.88, ["Neon|Fly"] = 193.65, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 339.8, ["Mega|Fly"] = 559.26, ["Mega|Ride"] = 346.55, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.94, ["Ride"] = 24.07, ["Fly|Ride"] = 91.04, ["Neon"] = 30.35, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 94.57, ["Mega"] = 173.86, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 35.36, ["Fly"] = 5285.82, ["Ride"] = 99.73, ["Fly|Ride"] = 174.83, ["Neon"] = 123.47, ["Neon|Fly"] = 324.68, ["Neon|Ride"] = 137.21, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 435.75, ["Mega|Ride"] = 449.07, ["Mega|Fly|Ride"] = 583.54}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 11037.86, ["Fly|Ride"] = 11149.69, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 90762.47}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 179.81, ["Ride"] = 231.24, ["Fly|Ride"] = 300.28, ["Neon"] = 1448.37, ["Neon|Ride"] = 1536.33, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4678.1}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 69.04, ["Fly"] = 158.31, ["Ride"] = 76.13, ["Fly|Ride"] = 85.31, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 372.92, ["Mega|Fly|Ride"] = 2050.54}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 13.01, ["Fly"] = 44.9, ["Ride"] = 27.21, ["Fly|Ride"] = 56.51, ["Neon"] = 75.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2513.43, ["Mega|Fly|Ride"] = 631.07}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 353.63, ["Fly"] = 837, ["Ride"] = 430.96, ["Fly|Ride"] = 446.25, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.56, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 28.09, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 315, ["Mega"] = 182.23, ["Mega|Ride"] = 274.4, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 249.37, ["Fly"] = 300.06, ["Ride"] = 255.94, ["Fly|Ride"] = 315, ["Neon"] = 922.98, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 795.94, ["Mega|Fly|Ride"] = 3347.05}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 20.97, ["Ride"] = 18.38, ["Fly|Ride"] = 38.07, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.6, ["Mega"] = 2513.43, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 13.72}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 167.42, ["Fly|Ride"] = 158.29, ["Neon"] = 368.78, ["Neon|Fly"] = 1675.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 788.37, ["Mega|Ride"] = 1418.11, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.01, ["Fly"] = 78.75, ["Ride"] = 39.38, ["Fly|Ride"] = 85.32, ["Neon"] = 65.63, ["Neon|Ride"] = 63.83, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 418.91, ["Mega|Ride"] = 551.93, ["Mega|Fly|Ride"] = 544.59}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 29.8, ["Fly"] = 111.57, ["Ride"] = 77.43, ["Fly|Ride"] = 105, ["Neon"] = 194.8, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 788.24, ["Mega|Ride"] = 920.55, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.56, ["Fly|Ride"] = 131.25, ["Neon"] = 30.09, ["Neon|Ride"] = 106.39, ["Neon|Fly|Ride"] = 133.02, ["Mega"] = 131.24, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 70.11, ["Ride"] = 26.17, ["Fly|Ride"] = 60.38, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 222.04, ["Mega|Ride"] = 527.83}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 377.1, ["Ride"] = 380.38, ["Fly|Ride"] = 376.65, ["Neon|Fly|Ride"] = 2653.75, ["Mega|Fly|Ride"] = 8063.88}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 52.5, ["Fly"] = 104.64, ["Ride"] = 111.96, ["Fly|Ride"] = 103.67, ["Neon"] = 349.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 718.86, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 756.33}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 56.52, ["Fly"] = 91.68, ["Ride"] = 79.16, ["Fly|Ride"] = 154.86, ["Neon"] = 205.54, ["Neon|Ride"] = 212.76, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1250.44}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.68, ["Fly"] = 70.11, ["Ride"] = 87.9, ["Fly|Ride"] = 148.84, ["Neon"] = 106.04, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 283.67, ["Mega"] = 393.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11196.39, ["Fly"] = 9948.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7182, ["Neon|Fly|Ride"] = 12665.62, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1968.75, ["Ride"] = 1836.19, ["Fly|Ride"] = 1613.07, ["Neon"] = 6146.01, ["Neon|Ride"] = 5725.36, ["Neon|Fly|Ride"] = 4847.32, ["Mega"] = 22340.07}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 392.44, ["Ride"] = 464.16, ["Fly|Ride"] = 494.82, ["Neon"] = 2092.48, ["Neon|Fly|Ride"] = 2068.35, ["Mega"] = 16756.1, ["Mega|Fly|Ride"] = 6701.41}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.13, ["Fly"] = 30.73, ["Ride"] = 22.32, ["Fly|Ride"] = 45.82, ["Neon"] = 108.78, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 140.35, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.23, ["Fly"] = 78.74, ["Ride"] = 150.04, ["Fly|Ride"] = 124.69, ["Neon"] = 24.94, ["Neon|Ride"] = 69.14, ["Neon|Fly|Ride"] = 157.47, ["Mega"] = 168, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 270.84}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.74, ["Fly"] = 60.25, ["Ride"] = 47.29, ["Fly|Ride"] = 85.31, ["Neon"] = 531.88, ["Neon|Ride"] = 151.48, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.66, ["Fly"] = 31.4, ["Ride"] = 19.9, ["Fly|Ride"] = 41.86, ["Neon"] = 25.11, ["Neon|Fly"] = 278.25, ["Neon|Ride"] = 52.02, ["Neon|Fly|Ride"] = 103.7, ["Mega"] = 459.38, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 262.5, ["Fly"] = 320.25, ["Ride"] = 307.81, ["Fly|Ride"] = 376.65, ["Neon|Ride"] = 1252.85, ["Neon|Fly|Ride"] = 1186.04, ["Mega|Fly|Ride"] = 6283.55}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.37, ["Fly"] = 56.23, ["Ride"] = 39.86, ["Fly|Ride"] = 70.11, ["Neon"] = 125.69, ["Neon|Fly"] = 167.57, ["Neon|Ride"] = 146.64, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 628.37}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.82, ["Fly"] = 28.26, ["Ride"] = 23.64, ["Fly|Ride"] = 47.25, ["Neon"] = 52.5, ["Neon|Fly"] = 134.75, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 433.13, ["Fly|Ride"] = 767.94, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1117.36, ["Fly"] = 1418.04, ["Ride"] = 1255.5, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 20805.84}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 78.75, ["Fly"] = 125.56, ["Ride"] = 78.75, ["Fly|Ride"] = 120.75, ["Neon"] = 971.25, ["Neon|Ride"] = 559.26, ["Neon|Fly|Ride"] = 477.51, ["Mega|Fly|Ride"] = 2604.54}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 141.57, ["Fly"] = 176.65, ["Ride"] = 152.25, ["Fly|Ride"] = 209.26, ["Neon"] = 556.5, ["Neon|Fly"] = 670.26, ["Neon|Ride"] = 737.51, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 5586.08, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 19.69, ["Ride"] = 66.97, ["Fly|Ride"] = 279.37, ["Neon"] = 199.5, ["Neon|Fly"] = 418.91, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 363.42, ["Mega|Ride"] = 2094.52, ["Mega|Fly|Ride"] = 1045.17}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 209.32, ["Ride"] = 208.22, ["Fly|Ride"] = 279.37, ["Neon|Fly|Ride"] = 1323.77, ["Mega|Fly|Ride"] = 2985.09}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2244.47, ["Fly|Ride"] = 2651.16, ["Neon|Fly|Ride"] = 7119.26, ["Mega|Fly|Ride"] = 48173.75}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 44.08, ["Ride"] = 52.41, ["Fly|Ride"] = 196.87, ["Neon"] = 311.8, ["Neon|Ride"] = 559.26, ["Neon|Fly|Ride"] = 237.75, ["Mega"] = 2088.24, ["Mega|Ride"] = 2303.98, ["Mega|Fly|Ride"] = 1675.63}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 524.99, ["Fly"] = 806.53, ["Ride"] = 544.69, ["Fly|Ride"] = 623.44, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 3097.49}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 40.69, ["Fly"] = 51.89, ["Ride"] = 52.19, ["Fly|Ride"] = 98.44, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 192.43, ["Mega|Fly|Ride"] = 1041.13}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.72, ["Fly"] = 28.28, ["Ride"] = 18.69, ["Fly|Ride"] = 52.33, ["Neon"] = 32.82, ["Neon|Fly"] = 99.5, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 90.07, ["Mega"] = 110.25, ["Mega|Fly"] = 251.36, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.91, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 259.87, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 559.26, ["Mega|Ride"] = 1397.05, ["Mega|Fly|Ride"] = 1103.76}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 616.88, ["Fly"] = 1402.21, ["Ride"] = 622.13, ["Fly|Ride"] = 692.99, ["Neon"] = 2513.43, ["Neon|Ride"] = 2153.18, ["Neon|Fly|Ride"] = 1548.74, ["Mega|Fly|Ride"] = 6701.41}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 506.76, ["Ride"] = 577.5, ["Fly|Ride"] = 530.45, ["Neon"] = 5231.17, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 13964.12}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.68, ["Fly"] = 27.46, ["Ride"] = 22.32, ["Fly|Ride"] = 38.68, ["Neon"] = 209.26, ["Neon|Ride"] = 111.12, ["Neon|Fly|Ride"] = 118.12, ["Mega|Fly|Ride"] = 631.07}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.42, ["Ride"] = 23.6, ["Fly|Ride"] = 55.13, ["Neon"] = 92.17, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 1675.63, ["Mega|Ride"] = 349.8, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.03, ["Ride"] = 31.91, ["Fly|Ride"] = 111.44, ["Neon"] = 30.35, ["Neon|Fly"] = 315.59, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 126.49, ["Mega"] = 224.14, ["Mega|Fly"] = 457.35, ["Mega|Ride"] = 231.29, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 31.5, ["Fly"] = 83.88, ["Ride"] = 52.5, ["Fly|Ride"] = 95.79, ["Neon"] = 224.14, ["Neon|Ride"] = 171.76, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 56.2, ["Ride"] = 111.57, ["Fly|Ride"] = 450.19, ["Neon"] = 276.17, ["Neon|Ride"] = 405.3, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1568.81, ["Mega|Ride"] = 1570.9, ["Mega|Fly|Ride"] = 1260.93}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.26, ["Fly"] = 65.63, ["Ride"] = 27.21, ["Fly|Ride"] = 84, ["Neon"] = 90.57, ["Neon|Fly"] = 154.85, ["Neon|Ride"] = 94.73, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 371.79, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.17, ["Fly"] = 41.75, ["Ride"] = 48.57, ["Fly|Ride"] = 93.43, ["Neon"] = 556.52, ["Neon|Ride"] = 234.04, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1181.76}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.64, ["Fly"] = 28.14, ["Ride"] = 19.44, ["Fly|Ride"] = 41.86, ["Neon"] = 32.55, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 525, ["Mega|Ride"] = 278.58, ["Mega|Fly|Ride"] = 368.65}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.39, ["Fly"] = 26.25, ["Ride"] = 28.25, ["Fly|Ride"] = 315.38, ["Neon"] = 27.2, ["Neon|Fly"] = 158.4, ["Neon|Ride"] = 63.94, ["Neon|Fly|Ride"] = 189.13, ["Mega"] = 261.83, ["Mega|Fly"] = 475.48, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 523.64}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 38.07, ["Fly"] = 60.38, ["Ride"] = 48.56, ["Fly|Ride"] = 78.66, ["Neon"] = 410.15, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1863.74, ["Fly"] = 2362.5, ["Ride"] = 1787.63, ["Fly|Ride"] = 1837.5, ["Neon|Fly"] = 4964.09, ["Neon|Ride"] = 5231.05, ["Neon|Fly|Ride"] = 3806.24, ["Mega|Fly|Ride"] = 16388.43}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 380.63, ["Fly"] = 697.85, ["Ride"] = 456.93, ["Fly|Ride"] = 525, ["Neon"] = 3152.21, ["Neon|Ride"] = 3072.66, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9742.63}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 240.86, ["Fly"] = 308.74, ["Ride"] = 312.61, ["Fly|Ride"] = 391.31, ["Neon"] = 1202.53, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1508.07, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.24, ["Ride"] = 49.19, ["Fly|Ride"] = 78.75, ["Neon"] = 328.75, ["Neon|Ride"] = 279.63, ["Neon|Fly|Ride"] = 418.91, ["Mega"] = 810.59, ["Mega|Ride"] = 698.54, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33487.6, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16143.75, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 467.78, ["Fly"] = 551.25, ["Ride"] = 501.38, ["Fly|Ride"] = 498.75, ["Neon"] = 1534.84, ["Neon|Ride"] = 1502.82, ["Neon|Fly|Ride"] = 1364.99, ["Mega"] = 6283.55, ["Mega|Fly|Ride"] = 4331.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 258.8, ["Fly"] = 140.21, ["Ride"] = 136.49, ["Fly|Ride"] = 167.42, ["Neon|Fly|Ride"] = 559.26, ["Mega|Fly|Ride"] = 4189.03}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Fly"] = 279.37, ["Ride"] = 125.03, ["Fly|Ride"] = 207.38, ["Neon"] = 706.81, ["Neon|Ride"] = 837.82, ["Neon|Fly|Ride"] = 489.08, ["Mega"] = 13964.12, ["Mega|Fly|Ride"] = 5236.28}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 19.69, ["Fly"] = 70.11, ["Ride"] = 31.33, ["Fly|Ride"] = 126, ["Neon"] = 274.3, ["Neon|Ride"] = 137.21, ["Neon|Fly|Ride"] = 194.8, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 627.53}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4666.3, ["Ride"] = 4743.62, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 18153.13}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.31, ["Fly"] = 58.61, ["Ride"] = 31.23, ["Fly|Ride"] = 41.86, ["Neon"] = 333.94, ["Neon|Ride"] = 224.58, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 1047.27, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.74, ["Fly"] = 114.63, ["Ride"] = 59.64, ["Fly|Ride"] = 111.96, ["Neon|Fly"] = 1397.05, ["Neon|Ride"] = 276.49, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 1576.46, ["Mega|Fly|Ride"] = 1150.95}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 577.5, ["Fly"] = 914.34, ["Ride"] = 593.25, ["Fly|Ride"] = 654.94, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 4659.38}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.52, ["Fly"] = 31.92, ["Ride"] = 24.94, ["Fly|Ride"] = 47.29, ["Neon"] = 106.31, ["Neon|Fly"] = 158.4, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 126.49, ["Mega|Ride"] = 599.16, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.12, ["Fly"] = 74.29, ["Ride"] = 31.91, ["Fly|Ride"] = 493.84, ["Neon"] = 80.07, ["Neon|Ride"] = 192.67, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 559.26}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Ride"] = 103.69, ["Fly|Ride"] = 157.5, ["Neon"] = 527.71, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 695.4, ["Mega|Fly|Ride"] = 4726.99}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.68, ["Fly"] = 77.98, ["Ride"] = 137.71, ["Fly|Ride"] = 125.56, ["Neon"] = 111.96, ["Neon|Fly"] = 194.8, ["Neon|Ride"] = 190.61, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 312.63, ["Mega|Ride"] = 559.26, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3543.75, ["Ride"] = 3478.13, ["Fly|Ride"] = 3476.82, ["Neon|Ride"] = 17803.35, ["Neon|Fly|Ride"] = 8531.25, ["Mega"] = 62835.31, ["Mega|Fly|Ride"] = 34317.83}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 55.52, ["Ride"] = 59.07, ["Fly|Ride"] = 121.65, ["Neon"] = 131.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 413.63, ["Mega|Ride"] = 879.71, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7637.51, ["Fly|Ride"] = 5685.75, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 64651.27}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.44, ["Fly"] = 23.62, ["Ride"] = 18.37, ["Fly|Ride"] = 35.58, ["Neon"] = 41.35, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 75.66, ["Mega"] = 418.91, ["Mega|Fly|Ride"] = 261.17}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.09, ["Fly"] = 35.58, ["Ride"] = 35.45, ["Fly|Ride"] = 49.87, ["Neon"] = 195.66, ["Neon|Ride"] = 559.26, ["Neon|Fly|Ride"] = 182.23, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 945.41}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.8, ["Fly"] = 40.19, ["Ride"] = 41.36, ["Fly|Ride"] = 122.84, ["Neon"] = 158.4, ["Neon|Ride"] = 146.64, ["Neon|Fly|Ride"] = 208.42, ["Mega"] = 1050, ["Mega|Ride"] = 976.05, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.29, ["Fly"] = 262.5, ["Ride"] = 50.81, ["Fly|Ride"] = 196.88, ["Neon"] = 182.43, ["Neon|Ride"] = 209.46, ["Neon|Fly|Ride"] = 126.32, ["Mega"] = 840, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.85, ["Fly"] = 28.04, ["Ride"] = 22.32, ["Fly|Ride"] = 37.16, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 195.85, ["Mega"] = 656.25, ["Mega|Ride"] = 589.71, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8336.33}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2657.82}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 153.57, ["Fly"] = 174.57, ["Ride"] = 174.56, ["Fly|Ride"] = 210, ["Neon|Fly|Ride"] = 1103.93, ["Mega|Fly|Ride"] = 5515.2}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.35, ["Fly"] = 125.56, ["Ride"] = 42, ["Fly|Ride"] = 315.38, ["Neon"] = 122.93, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 208.42, ["Mega|Ride"] = 898.13, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.28, ["Ride"] = 26.25, ["Neon"] = 54.47, ["Neon|Ride"] = 98.45, ["Neon|Fly|Ride"] = 125.69, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 157.5, ["Fly"] = 209.26, ["Ride"] = 202.99, ["Fly|Ride"] = 416.41, ["Neon"] = 701.37, ["Neon|Ride"] = 593.66, ["Mega|Ride"] = 3477.95, ["Mega|Fly|Ride"] = 3477.95}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 142.01, ["Ride"] = 309.25, ["Fly|Ride"] = 485.63, ["Neon"] = 668.92, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 178.26, ["Fly"] = 237.51, ["Ride"] = 170.46, ["Fly|Ride"] = 254.63, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 856.01, ["Mega"] = 4607.94, ["Mega|Fly|Ride"] = 3455.96}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1508.06, ["Fly"] = 2510.97, ["Ride"] = 1312.49, ["Fly|Ride"] = 1311.19, ["Neon|Ride"] = 6144.27, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 27788.93}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.76, ["Fly"] = 81.3, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 127.31, ["Neon|Ride"] = 167.57, ["Neon|Fly|Ride"] = 315.21, ["Mega"] = 836.77, ["Mega|Ride"] = 622.09, ["Mega|Fly|Ride"] = 656.64}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 576.93, ["Fly"] = 2100, ["Ride"] = 627.76, ["Fly|Ride"] = 787.85, ["Neon|Fly|Ride"] = 3140.73}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 70.13}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.74, ["Ride"] = 32.82, ["Fly|Ride"] = 681.8, ["Neon"] = 79.35, ["Neon|Ride"] = 140.35, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.65, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 522.59}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.49, ["Fly"] = 257.28, ["Ride"] = 28.26, ["Fly|Ride"] = 94.5, ["Neon"] = 46.05, ["Neon|Ride"] = 87.98, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 488.03, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 66.93}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.31, ["Ride"] = 31.23, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 209.46, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 83.74, ["Fly"] = 75.34, ["Ride"] = 36.75, ["Fly|Ride"] = 66.97, ["Neon|Ride"] = 279.63, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 953.68, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6000.58, ["Fly"] = 10954, ["Ride"] = 7321.54, ["Fly|Ride"] = 5092.49, ["Neon|Ride"] = 17454.62, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.17, ["Fly"] = 79.52, ["Ride"] = 32.82, ["Fly|Ride"] = 97.85, ["Neon"] = 47.23, ["Neon|Ride"] = 77.44, ["Mega"] = 529.44, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 370.38, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 418.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 521.24, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 78.75, ["Fly"] = 96.48, ["Ride"] = 115.79, ["Fly|Ride"] = 158.2, ["Neon"] = 327.6, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 559.26, ["Mega"] = 2363.5, ["Mega|Ride"] = 2827.6, ["Mega|Fly|Ride"] = 1397.05}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.78, ["Fly"] = 65.62, ["Ride"] = 31.91, ["Fly|Ride"] = 72.19, ["Neon"] = 196.88, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 693.7, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.11, ["Fly"] = 79.52, ["Ride"] = 31.97, ["Fly|Ride"] = 78.75, ["Neon"] = 26.17, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 73.33, ["Neon|Fly|Ride"] = 170.1, ["Mega"] = 135.81, ["Mega|Fly"] = 6982.06, ["Mega|Ride"] = 163.47, ["Mega|Fly|Ride"] = 271.41}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.79, ["Fly"] = 31.91, ["Ride"] = 31.35, ["Fly|Ride"] = 69.06, ["Neon"] = 94.17, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 182.23, ["Mega"] = 460.81, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 414.72}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.19, ["Fly"] = 35.44, ["Ride"] = 26.22, ["Fly|Ride"] = 45.85, ["Neon"] = 208.71, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 139.54, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.98}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 22.32, ["Ride"] = 111.04, ["Neon"] = 177.19, ["Mega"] = 1352.03, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1675.63}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 135.36, ["Ride"] = 98.36, ["Fly|Ride"] = 262.5, ["Neon"] = 559.26, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 559.26}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.67, ["Fly"] = 212.01, ["Ride"] = 105, ["Fly|Ride"] = 216.57, ["Neon"] = 301.88, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1183.88, ["Mega|Ride"] = 2182.7, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 857.07, ["Fly"] = 992.3, ["Ride"] = 727.1, ["Fly|Ride"] = 761.25, ["Neon|Fly"] = 2836.63, ["Neon|Ride"] = 2827.6, ["Neon|Fly|Ride"] = 2205, ["Mega|Fly|Ride"] = 9778.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 206.07, ["Fly"] = 472.53, ["Ride"] = 218.67, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1891.1, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8273.33, ["Mega|Fly|Ride"] = 5022.66}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 87.46}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.28}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.56, ["Fly"] = 28.48, ["Ride"] = 27.8, ["Fly|Ride"] = 52.5, ["Neon"] = 77.95, ["Neon|Ride"] = 87.98, ["Neon|Fly|Ride"] = 155.01, ["Mega"] = 437.26, ["Mega|Ride"] = 559.26, ["Mega|Fly|Ride"] = 418.91}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 283.5, ["Fly"] = 1033.69, ["Ride"] = 345.36, ["Fly|Ride"] = 424.46, ["Neon"] = 1080.3, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.32}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 98.39, ["Fly"] = 288.25, ["Ride"] = 194.38, ["Fly|Ride"] = 266.44, ["Neon"] = 416.75, ["Neon|Fly"] = 1675.63, ["Neon|Ride"] = 505.88, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 3072.66, ["Mega|Ride"] = 2234.87, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 138.69, ["Ride"] = 137.71, ["Fly|Ride"] = 196.88, ["Neon"] = 1117.45, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 1046.22}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.56, ["Ride"] = 31.5, ["Fly|Ride"] = 209.26, ["Neon"] = 32.82, ["Neon|Ride"] = 85.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 214.39, ["Mega|Ride"] = 259.73, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.91, ["Fly"] = 63, ["Ride"] = 35.45, ["Fly|Ride"] = 69.63, ["Neon"] = 103.07, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 26, ["Fly"] = 102.32, ["Ride"] = 61.74, ["Fly|Ride"] = 128.82, ["Neon"] = 99.75, ["Neon|Ride"] = 174.9, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 469.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.23, ["Fly"] = 116.15, ["Ride"] = 69.06, ["Fly|Ride"] = 132.55, ["Neon"] = 30.19, ["Neon|Ride"] = 55.11, ["Neon|Fly|Ride"] = 150.93, ["Mega"] = 143.07, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 274.21}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.44, ["Fly"] = 229.69, ["Ride"] = 295.34, ["Fly|Ride"] = 334.68, ["Neon"] = 1395.69, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 110.14, ["Fly"] = 1050, ["Ride"] = 174.57, ["Fly|Ride"] = 265.13, ["Neon"] = 460.69, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 1575, ["Mega|Ride"] = 1994.79, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 73.85, ["Fly|Ride"] = 128.63, ["Neon"] = 363.05, ["Neon|Ride"] = 390.06, ["Neon|Fly|Ride"] = 471.09, ["Mega|Fly|Ride"] = 1971.16}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.93, ["Fly"] = 145.69, ["Ride"] = 57.75, ["Fly|Ride"] = 251.11, ["Neon|Ride"] = 600.44, ["Neon|Fly|Ride"] = 485.94, ["Mega|Ride"] = 615.57, ["Mega|Fly|Ride"] = 1662.01}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.08, ["Fly"] = 75.62, ["Ride"] = 39.38, ["Fly|Ride"] = 69.57, ["Neon"] = 102.55, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 347.43, ["Mega|Fly"] = 525, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 444.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.94, ["Fly"] = 45.95, ["Ride"] = 24.86, ["Fly|Ride"] = 59.07, ["Neon"] = 17.74, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.81, ["Neon|Fly|Ride"] = 108.06, ["Mega"] = 124.37, ["Mega|Fly"] = 174.91, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.49, ["Fly"] = 1060.53, ["Ride"] = 853.13, ["Fly|Ride"] = 944.95, ["Neon"] = 3307.28, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2493.72, ["Mega|Fly|Ride"] = 10194}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 475.13, ["Ride"] = 418.5, ["Fly|Ride"] = 485.63, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2597.21, ["Mega"] = 10472.56, ["Mega|Fly|Ride"] = 6702.45}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 73.5, ["Fly"] = 140.21, ["Ride"] = 89.99, ["Fly|Ride"] = 157.5, ["Neon"] = 308.66, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 349.8, ["Mega|Ride"] = 1444.17, ["Mega|Fly|Ride"] = 1478.74}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 251.16, ["Fly"] = 322.26, ["Ride"] = 296.87, ["Fly|Ride"] = 315, ["Neon"] = 1151.2, ["Neon|Ride"] = 1418.32, ["Neon|Fly|Ride"] = 1117.45, ["Mega"] = 10472.56, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 32.46, ["Fly"] = 140.21, ["Ride"] = 24.44, ["Fly|Ride"] = 67.72, ["Neon"] = 157.5, ["Neon|Ride"] = 107.89, ["Neon|Fly|Ride"] = 158.38, ["Mega|Ride"] = 788.24, ["Mega|Fly|Ride"] = 644.4}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.11, ["Ride"] = 280.74, ["Fly|Ride"] = 512.65, ["Neon"] = 1419.05, ["Neon|Ride"] = 1733.89, ["Neon|Fly|Ride"] = 1323.77, ["Mega"] = 4168.38, ["Mega|Fly|Ride"] = 4217.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 79.16, ["Ride"] = 65.63, ["Fly|Ride"] = 71.99, ["Neon|Ride"] = 500.6, ["Neon|Fly|Ride"] = 559.26, ["Mega|Fly|Ride"] = 1397.05}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1529.07, ["Ride"] = 1438.4, ["Fly|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 4189.03, ["Mega"] = 50268.26, ["Mega|Fly|Ride"] = 24296.33}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.75, ["Fly"] = 57.75, ["Ride"] = 32.16, ["Fly|Ride"] = 90.57, ["Neon"] = 61.57, ["Neon|Fly"] = 112.08, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 262.47, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.26, ["Fly"] = 78.75, ["Ride"] = 59.07, ["Fly|Ride"] = 159.48, ["Neon"] = 320.25, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 279.63, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 76.13, ["Fly"] = 70.13, ["Ride"] = 63, ["Fly|Ride"] = 72.17, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1376.66}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3767.37, ["Ride"] = 1228.42, ["Fly|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 488.72, ["Fly"] = 834.91, ["Ride"] = 522.09, ["Fly|Ride"] = 697.85, ["Neon|Fly|Ride"] = 2758.63, ["Mega|Fly|Ride"] = 14180.93}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 122.07, ["Fly"] = 315.42, ["Ride"] = 135.19, ["Fly|Ride"] = 219.75, ["Neon"] = 444.29, ["Neon|Fly"] = 559.26, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 4187.99, ["Mega|Ride"] = 2653.75, ["Mega|Fly|Ride"] = 2159.06}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.14, ["Fly"] = 39.38, ["Ride"] = 23.68, ["Fly|Ride"] = 69.57, ["Neon"] = 87.93, ["Neon|Ride"] = 94.57, ["Neon|Fly|Ride"] = 178.04, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 619.99}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 37.79, ["Fly"] = 94.53, ["Ride"] = 47.12, ["Fly|Ride"] = 103.97, ["Neon"] = 204.75, ["Neon|Fly"] = 417.86, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 276.49, ["Mega"] = 1815.96, ["Mega|Ride"] = 1071.86, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 759.45, ["Ride"] = 826.88, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 31513.55}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.48}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5439.37, ["Fly|Ride"] = 4051.69, ["Neon"] = 42000, ["Neon|Ride"] = 30015.39, ["Neon|Fly|Ride"] = 21920.11, ["Mega|Fly|Ride"] = 89366.48}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 180.08, ["Fly"] = 276.17, ["Ride"] = 272.04, ["Neon"] = 1299.3, ["Neon|Fly|Ride"] = 1397.05, ["Mega"] = 5863.59, ["Mega|Fly|Ride"] = 6004.98}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Fly"] = 279.42, ["Ride"] = 78.74, ["Fly|Ride"] = 336, ["Neon"] = 349.13, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 978.15, ["Mega|Fly|Ride"] = 2901.96}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.82, ["Fly"] = 131.24, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 111.57, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 628.37, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 22.32, ["Fly"] = 31.82, ["Ride"] = 30.19, ["Fly|Ride"] = 48.01, ["Neon|Fly"] = 279.63, ["Neon|Ride"] = 279.63, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.74, ["Fly"] = 279.42, ["Ride"] = 39.6, ["Fly|Ride"] = 111.04, ["Neon"] = 154.88, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 231.47, ["Mega"] = 549.94, ["Mega|Ride"] = 577.05, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.18, ["Fly"] = 56.51, ["Ride"] = 17.52, ["Fly|Ride"] = 39.38, ["Neon"] = 32.81, ["Neon|Fly"] = 345.61, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 176.72, ["Mega|Ride"] = 177.29, ["Mega|Fly|Ride"] = 308.96}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 34.29, ["Ride"] = 77.43, ["Fly|Ride"] = 183.75, ["Neon"] = 163.38, ["Neon|Fly"] = 837.82, ["Neon|Ride"] = 198.99, ["Neon|Fly|Ride"] = 245.93, ["Mega"] = 691.21, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 302.4, ["Fly"] = 366.22, ["Ride"] = 288.75, ["Fly|Ride"] = 373.98, ["Neon"] = 1417.41, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 917.43, ["Mega"] = 6562.5, ["Mega|Ride"] = 3630.85, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.19, ["Fly"] = 22.98, ["Ride"] = 13.13, ["Fly|Ride"] = 32.82, ["Neon"] = 19.69, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 53.43, ["Mega"] = 835.72, ["Mega|Ride"] = 221.01, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.69, ["Fly"] = 85.32, ["Ride"] = 78.75, ["Fly|Ride"] = 127.78, ["Neon"] = 161.44, ["Neon|Fly"] = 237.75, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 631.11, ["Mega|Fly"] = 837.82, ["Mega|Ride"] = 506.7, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.87, ["Fly"] = 1000.57, ["Ride"] = 721.88, ["Fly|Ride"] = 758.63, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1555.32, ["Mega|Fly|Ride"] = 3832.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.14, ["Fly"] = 79.16, ["Ride"] = 44.51, ["Fly|Ride"] = 101.06, ["Neon|Fly"] = 472.78, ["Neon|Ride"] = 223.55, ["Neon|Fly|Ride"] = 278.58, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 740.42}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 237.58, ["Fly"] = 261.19, ["Ride"] = 261.19, ["Fly|Ride"] = 349.77, ["Neon"] = 942.55, ["Neon|Ride"] = 978.15, ["Neon|Fly|Ride"] = 1019.82, ["Mega"] = 6303.44, ["Mega|Fly|Ride"] = 6597.72}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.25, ["Fly"] = 139.02, ["Ride"] = 129.93, ["Fly|Ride"] = 171.78, ["Neon|Ride"] = 418.69, ["Neon|Fly|Ride"] = 569.63, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 577.5, ["Ride"] = 590.63, ["Fly|Ride"] = 678.57, ["Neon|Ride"] = 2572.5, ["Neon|Fly|Ride"] = 2245.67, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.32, ["Ride"] = 41.86, ["Fly|Ride"] = 111.56, ["Neon"] = 103.59, ["Neon|Fly"] = 283.67, ["Neon|Ride"] = 98.45, ["Neon|Fly|Ride"] = 189.13, ["Mega"] = 262.48, ["Mega|Ride"] = 360.27, ["Mega|Fly|Ride"] = 375.81}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3716.09, ["Fly"] = 3543.75, ["Ride"] = 3898.28, ["Fly|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 5414.07, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 103.61, ["Fly"] = 118.14, ["Ride"] = 105, ["Fly|Ride"] = 141.35, ["Neon"] = 418.5, ["Neon|Ride"] = 489.08, ["Neon|Fly|Ride"] = 485.17, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.61, ["Fly"] = 19.9, ["Ride"] = 19.69, ["Fly|Ride"] = 78.48, ["Neon"] = 23.62, ["Neon|Fly"] = 82.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 112.08, ["Mega"] = 139.13, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 235.67}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.65, ["Ride"] = 27.98, ["Neon"] = 28.29, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 279.63, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 39.38, ["Fly"] = 84.55, ["Ride"] = 39.37, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 257.64, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 997.5, ["Ride"] = 1158.86, ["Fly|Ride"] = 1181.25, ["Neon"] = 5718.03}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.38, ["Ride"] = 6168.6, ["Fly|Ride"] = 5249.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.11, ["Fly"] = 35.38, ["Ride"] = 30.19, ["Fly|Ride"] = 51.1, ["Neon"] = 261.86, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 124.78, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 607.42}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.44, ["Fly"] = 51.14, ["Ride"] = 32.71, ["Fly|Ride"] = 68.25, ["Neon"] = 88.83, ["Neon|Ride"] = 89.45, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 933.52, ["Mega|Ride"] = 566.07, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 58.42, ["Fly"] = 157.5, ["Ride"] = 65.61, ["Fly|Ride"] = 100.96, ["Neon"] = 328.12, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 1675.63, ["Mega|Ride"] = 1147.81, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 209.99, ["Fly"] = 315.42, ["Ride"] = 229.69, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 883.28, ["Mega"] = 10472.56, ["Mega|Fly|Ride"] = 3351.24}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.44, ["Fly|Ride"] = 86.63, ["Neon"] = 30.19, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 245.85, ["Mega"] = 131.24, ["Mega|Ride"] = 163.61, ["Mega|Fly|Ride"] = 418.91}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 255.64, ["Ride"] = 216.57, ["Fly|Ride"] = 249.38, ["Neon"] = 837.82, ["Neon|Ride"] = 874.63, ["Neon|Fly|Ride"] = 837.82, ["Mega|Fly|Ride"] = 3706.25}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.53, ["Fly"] = 20.64, ["Ride"] = 19.29, ["Fly|Ride"] = 46.05, ["Neon"] = 22.67, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 94.57, ["Mega"] = 276.54, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 268.82, ["Ride"] = 236.24, ["Fly|Ride"] = 251.11, ["Neon"] = 788.37, ["Neon|Ride"] = 816.87, ["Neon|Fly|Ride"] = 886.46, ["Mega"] = 10471.52, ["Mega|Ride"] = 4189.03, ["Mega|Fly|Ride"] = 3911.52}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 14.44, ["Fly"] = 75.89, ["Ride"] = 27.08, ["Fly|Ride"] = 56.27, ["Neon"] = 91.04, ["Neon|Fly"] = 300.23, ["Neon|Ride"] = 99.5, ["Neon|Fly|Ride"] = 273, ["Mega"] = 523.53, ["Mega|Ride"] = 586.48, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.14, ["Ride"] = 18.84, ["Fly|Ride"] = 86.63, ["Neon"] = 10.27, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 61.16, ["Neon|Fly|Ride"] = 136.16, ["Mega"] = 87.84, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 205.64}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 20.9, ["Mega|Ride"] = 139.47}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.69, ["Ride"] = 27.43, ["Fly|Ride"] = 140.21, ["Neon"] = 7.46, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 118.36, ["Mega|Fly"] = 157566.51, ["Mega|Ride"] = 90.45, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 64.18, ["Fly"] = 136.83, ["Ride"] = 114.97, ["Fly|Ride"] = 209.26, ["Neon"] = 286.69, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 357, ["Mega|Fly|Ride"] = 1244.52}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.88, ["Neon"] = 8.39, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 109.69, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 13.55, ["Ride"] = 111.64, ["Fly|Ride"] = 186.64, ["Neon"] = 65.61, ["Neon|Ride"] = 97.13, ["Mega"] = 328.13, ["Mega|Ride"] = 622.09, ["Mega|Fly|Ride"] = 621.11}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.13, ["Neon"] = 2.62, ["Neon|Ride"] = 39.48, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 19.69, ["Mega|Ride"] = 53.43, ["Mega|Fly|Ride"] = 174.77}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.9, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 35.47, ["Neon|Ride"] = 14.68, ["Neon|Fly|Ride"] = 36.58, ["Mega"] = 18.87, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 20.96, ["Mega|Fly|Ride"] = 59.76}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.7, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 20.96, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 47.3, ["Mega"] = 20.96, ["Mega|Fly"] = 94.56, ["Mega|Ride"] = 79.2, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Fly|Ride"] = 125.56, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 59.12, ["Mega"] = 17.07, ["Mega|Ride"] = 148.31, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 16.56, ["Fly|Ride"] = 107.62, ["Neon"] = 3.55, ["Neon|Fly"] = 137.84, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 41.41, ["Mega|Fly"] = 91.12, ["Mega|Ride"] = 54.57, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.17, ["Neon|Fly|Ride"] = 207.37, ["Mega"] = 21, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 54.47, ["Ride"] = 17.07, ["Fly|Ride"] = 48.4, ["Neon"] = 8.54, ["Neon|Fly"] = 53.13, ["Neon|Ride"] = 22.2, ["Neon|Fly|Ride"] = 69.88, ["Mega"] = 44.63, ["Mega|Fly"] = 160.44, ["Mega|Ride"] = 80.63, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.14, ["Neon"] = 2.1, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 18.36, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 63.82, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 19.69, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 8.22, ["Ride"] = 27.57, ["Neon"] = 22.32, ["Neon|Ride"] = 31.43, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.49, ["Ride"] = 32.82, ["Neon"] = 5.24, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 98.45, ["Mega"] = 28.38, ["Mega|Ride"] = 60.76, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 30.08, ["Neon"] = 2.1, ["Neon|Fly"] = 27.24, ["Neon|Ride"] = 14.42, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 15.73, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 28.13, ["Mega|Fly|Ride"] = 70.18}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.83, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 41.7, ["Mega"] = 279.63, ["Mega|Ride"] = 274.4}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 17.93, ["Fly|Ride"] = 78.74, ["Neon"] = 4.74, ["Neon|Ride"] = 39.71, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 33.27, ["Mega|Ride"] = 139.02, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.05, ["Neon"] = 15.75, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 89.25, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.61, ["Fly"] = 656.24, ["Ride"] = 32.81, ["Fly|Ride"] = 190.43, ["Neon"] = 12.79, ["Neon|Ride"] = 79.21, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 103.84, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 111.03}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.34, ["Ride"] = 12.48, ["Fly|Ride"] = 20.93, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 14.05, ["Neon|Fly|Ride"] = 30.35, ["Mega"] = 16.77, ["Mega|Fly"] = 20.96, ["Mega|Ride"] = 20.9, ["Mega|Fly|Ride"] = 58.59}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 18.87, ["Fly|Ride"] = 86.63, ["Neon"] = 15.7, ["Neon|Ride"] = 113.48, ["Neon|Fly|Ride"] = 83.79, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.94, ["Fly"] = 41.86, ["Ride"] = 13.12, ["Fly|Ride"] = 58.46, ["Neon"] = 15.47, ["Neon|Ride"] = 112.08, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.63, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 390.47}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.28, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 18.25, ["Neon|Ride"] = 17.46, ["Neon|Fly|Ride"] = 38.66, ["Mega"] = 28.04, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 94.45}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 174.74, ["Ride"] = 26.25, ["Neon"] = 5.53, ["Neon|Fly"] = 77.27, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.37, ["Mega|Fly"] = 167.57, ["Mega|Ride"] = 82.73}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Fly"] = 140.21, ["Ride"] = 25.99, ["Fly|Ride"] = 56.51, ["Neon"] = 4.87, ["Neon|Fly"] = 108.94, ["Neon|Ride"] = 35.62, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.96, ["Ride"] = 16.73, ["Neon"] = 2.1, ["Neon|Fly"] = 41.91, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 83.79, ["Mega"] = 14.01, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 124.85}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.36, ["Ride"] = 17.06, ["Fly|Ride"] = 42.02, ["Neon"] = 6.97, ["Neon|Fly"] = 46.05, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 79.2, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 263.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 5.16, ["Neon|Ride"] = 42.42, ["Neon|Fly|Ride"] = 94.56, ["Mega"] = 131.25, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 340.35}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 16.17, ["Fly|Ride"] = 140.21, ["Neon"] = 7.77, ["Neon|Fly"] = 69.86, ["Neon|Ride"] = 25.08, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 88.31, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 4.6, ["Ride"] = 82.69, ["Neon"] = 38.07, ["Mega|Fly|Ride"] = 837.82}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 27.21, ["Ride"] = 15.75, ["Fly|Ride"] = 41.86, ["Neon"] = 12.28, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 157.5, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 321.51}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.63, ["Fly"] = 23.6, ["Ride"] = 32.17, ["Fly|Ride"] = 62.78, ["Neon"] = 14.11, ["Neon|Fly"] = 61.81, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 111.03, ["Mega"] = 209.46, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 91.56, ["Fly|Ride"] = 106.32, ["Neon"] = 19.69, ["Mega"] = 202.06, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.19, ["Ride"] = 131.25, ["Neon"] = 209.46, ["Neon|Ride"] = 236.4, ["Mega"] = 937.31, ["Mega|Ride"] = 875.52, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 11.83, ["Ride"] = 131.06, ["Neon"] = 38.66, ["Neon|Ride"] = 52.5, ["Mega"] = 253.32, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.46, ["Ride"] = 43.31, ["Fly|Ride"] = 139.13, ["Neon"] = 62.85, ["Neon|Ride"] = 69.83, ["Mega"] = 289.06, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 64.98, ["Mega"] = 23.06, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.82, ["Fly"] = 20.9, ["Ride"] = 22.32, ["Fly|Ride"] = 83.71, ["Neon"] = 39.37, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 283.5, ["Mega|Ride"] = 276.54, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 36.75, ["Neon"] = 10.5, ["Neon|Ride"] = 26.55, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.81, ["Mega|Ride"] = 111.95, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.39, ["Ride"] = 36.63, ["Fly|Ride"] = 394.52, ["Neon"] = 5.25, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 402.59, ["Mega"] = 58.1, ["Mega|Ride"] = 69.48, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.62, ["Fly"] = 45.93, ["Ride"] = 19.27, ["Fly|Ride"] = 55.65, ["Neon"] = 23.65, ["Neon|Ride"] = 34.75, ["Neon|Fly|Ride"] = 84.72, ["Mega"] = 184.37, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.6, ["Ride"] = 98.36, ["Neon"] = 35.44, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 238.73, ["Mega|Ride"] = 315.73, ["Mega|Fly|Ride"] = 414.81}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 48.9, ["Mega"] = 32.82, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 208.42}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 16.76, ["Ride"] = 15.09, ["Fly|Ride"] = 278995.34, ["Neon"] = 5.2, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.1, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 52.5, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 82.73, ["Mega|Fly|Ride"] = 124.66}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 18.71, ["Ride"] = 17.05, ["Fly|Ride"] = 32.76, ["Neon"] = 7.76, ["Neon|Fly"] = 70.18, ["Neon|Ride"] = 23.65, ["Neon|Fly|Ride"] = 40.2, ["Mega"] = 63.82, ["Mega|Ride"] = 51.32, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 79.15, ["Neon"] = 3.94, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 107.89, ["Mega"] = 25.34, ["Mega|Fly"] = 104.73, ["Mega|Ride"] = 46.69, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 169.67, ["Mega"] = 25.23, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 203.18}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 27.72, ["Ride"] = 22.45, ["Fly|Ride"] = 34.13, ["Neon"] = 5.25, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.85, ["Mega"] = 38.05, ["Mega|Ride"] = 63.82, ["Mega|Fly|Ride"] = 118.19}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 49.19, ["Neon"] = 2.61, ["Mega"] = 19.69, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 6.45, ["Neon|Ride"] = 158.4, ["Mega"] = 31.92, ["Mega|Fly"] = 118.19, ["Mega|Ride"] = 120.45, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 25.91, ["Fly|Ride"] = 69.57, ["Neon"] = 3.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 125.91, ["Mega"] = 41.91, ["Mega|Ride"] = 41.56, ["Mega|Fly|Ride"] = 158.38}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 20.98, ["Ride"] = 78.75, ["Neon"] = 95.81, ["Neon|Ride"] = 236.4, ["Mega"] = 436.46, ["Mega|Ride"] = 3151.73, ["Mega|Fly|Ride"] = 631.07}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 41.25, ["Neon|Ride"] = 207.37, ["Mega"] = 208.42, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.93, ["Ride"] = 26.24, ["Fly|Ride"] = 418.5, ["Neon"] = 13.13, ["Mega"] = 274.32, ["Mega|Ride"] = 241.08, ["Mega|Fly|Ride"] = 249.93}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 13.13, ["Fly|Ride"] = 28.26, ["Neon"] = 2.1, ["Neon|Fly"] = 17.74, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 44.59, ["Mega"] = 20.86, ["Mega|Fly"] = 44.62, ["Mega|Ride"] = 20.96, ["Mega|Fly|Ride"] = 52.39}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 55.13, ["Fly|Ride"] = 70.11, ["Neon"] = 6.6, ["Neon|Fly"] = 83.79, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 698.54, ["Mega"] = 116.09, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 111.09}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 25.03, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 14.2, ["Mega|Fly"] = 60.14, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 100.01}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.88, ["Mega"] = 22.26, ["Mega|Ride"] = 108.92, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.75, ["Ride"] = 21, ["Fly|Ride"] = 45.92, ["Neon"] = 15.7, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 85.46, ["Mega"] = 143.24, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 323.81}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 150.66, ["Ride"] = 157.49, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 1101.73, ["Mega"] = 8378.06, ["Mega|Fly|Ride"] = 3337.61}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Neon|Fly"] = 56.17, ["Neon|Ride"] = 68.25, ["Mega"] = 87.98, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.36, ["Fly"] = 103.68, ["Ride"] = 23.04, ["Fly|Ride"] = 140.21, ["Neon"] = 15.54, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158.16, ["Mega"] = 464.4, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1047.27}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.68, ["Fly|Ride"] = 37.17, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 57.75, ["Mega|Ride"] = 59.98, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 17.95, ["Fly|Ride"] = 120.89, ["Neon"] = 21.26, ["Neon|Ride"] = 103.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 95.7, ["Mega|Ride"] = 136.5}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.52, ["Fly"] = 26.24, ["Ride"] = 17.99, ["Fly|Ride"] = 39.36, ["Neon"] = 32.45, ["Neon|Ride"] = 45.86, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 278.58, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 7.88, ["Fly"] = 41.86, ["Ride"] = 41.86, ["Fly|Ride"] = 249.58, ["Neon"] = 65.63, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 622.09, ["Mega"] = 330.04, ["Mega|Ride"] = 352.17, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.14, ["Fly"] = 20.93, ["Ride"] = 16.56, ["Fly|Ride"] = 46.05, ["Neon"] = 43.96, ["Neon|Fly"] = 56.57, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 70.92, ["Mega|Fly"] = 242.99, ["Mega|Ride"] = 698.54, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.09, ["Fly"] = 120.33, ["Ride"] = 98.42, ["Fly|Ride"] = 131.24, ["Neon"] = 328.13, ["Neon|Fly"] = 406.88, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 455.11, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.57, ["Fly"] = 322.18, ["Ride"] = 233.91, ["Fly|Ride"] = 262.5, ["Neon"] = 910.1, ["Neon|Ride"] = 1466.17, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 10472.56, ["Mega|Fly|Ride"] = 4887.56}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 79.55, ["Fly"] = 140.21, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1397.05, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Fly"] = 19.69, ["Ride"] = 31.27, ["Fly|Ride"] = 140.21, ["Neon"] = 28.26, ["Neon|Ride"] = 53.43, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 188.45, ["Mega|Ride"] = 314.19, ["Mega|Fly|Ride"] = 330.95}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.64, ["Fly"] = 68.16, ["Ride"] = 28.26, ["Fly|Ride"] = 82.66, ["Neon"] = 167.42, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 174.9, ["Mega"] = 351.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 556.12}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.09, ["Ride"] = 20.93, ["Fly|Ride"] = 28.26, ["Neon"] = 4.54, ["Neon|Fly"] = 23.46, ["Neon|Ride"] = 20.73, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 49.58, ["Mega|Fly"] = 210.37, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 9.47, ["Fly"] = 72.11, ["Ride"] = 21.93, ["Fly|Ride"] = 140.21, ["Neon"] = 45.05, ["Neon|Ride"] = 158.3, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 795.94, ["Mega|Ride"] = 628.37, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 17.79, ["Ride"] = 18.69, ["Fly|Ride"] = 63.8, ["Neon"] = 15.7, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 35.62, ["Neon|Fly|Ride"] = 94.58, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.17, ["Ride"] = 28.14, ["Fly|Ride"] = 328.13, ["Neon"] = 53.37, ["Neon|Ride"] = 55.44, ["Neon|Fly|Ride"] = 236.4, ["Mega"] = 207.37, ["Mega|Ride"] = 208.42, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 131.24, ["Neon"] = 2.63, ["Neon|Ride"] = 18.48, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 15.75, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 224.14}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.38, ["Fly"] = 17.57, ["Ride"] = 20.91, ["Fly|Ride"] = 45.94, ["Neon"] = 13.12, ["Neon|Fly"] = 104.73, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 63.8, ["Mega"] = 108.94, ["Mega|Ride"] = 78.93, ["Mega|Fly|Ride"] = 191.75}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 4.17, ["Ride"] = 18.27, ["Fly|Ride"] = 45.75, ["Neon"] = 45.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 125.69, ["Mega|Fly|Ride"] = 225.72}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 162.63, ["Fly"] = 267.85, ["Ride"] = 268.17, ["Fly|Ride"] = 315.16, ["Neon"] = 700.87, ["Neon|Ride"] = 724.71, ["Neon|Fly|Ride"] = 678.57, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2690.63}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.3, ["Ride"] = 240.91, ["Fly|Ride"] = 204.03, ["Neon"] = 39.38, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 313.74, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.6, ["Ride"] = 19.16, ["Fly|Ride"] = 56.58, ["Neon"] = 25.18, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 64.96, ["Mega"] = 189, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 17.75, ["Ride"] = 36.98, ["Fly|Ride"] = 178.5, ["Neon"] = 103.13, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 300.54, ["Mega"] = 556.12, ["Mega|Ride"] = 559.26, ["Mega|Fly|Ride"] = 682.83}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.91}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.28, ["Ride"] = 33.48, ["Neon"] = 39.64, ["Neon|Ride"] = 151.52, ["Neon|Fly|Ride"] = 628.37, ["Mega"] = 236.25, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.57, ["Fly"] = 26.25, ["Ride"] = 31.45, ["Fly|Ride"] = 52.5, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 198.99, ["Neon|Fly|Ride"] = 168.15, ["Mega"] = 523.64, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Fly|Ride"] = 78.74, ["Neon"] = 3.31, ["Neon|Ride"] = 53.17, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 31.49, ["Mega|Fly"] = 414.72, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 158.38}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.28, ["Fly"] = 26.99, ["Ride"] = 28.26, ["Fly|Ride"] = 112.54, ["Neon"] = 112.08, ["Neon|Ride"] = 236.4, ["Mega"] = 221.17, ["Mega|Fly"] = 394.72, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.51, ["Fly"] = 45, ["Ride"] = 16.72, ["Fly|Ride"] = 45.65, ["Neon"] = 14.97, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 124.69, ["Mega|Ride"] = 145.9, ["Mega|Fly|Ride"] = 224.88}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 22.99, ["Neon"] = 3.86, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 31.5, ["Mega|Ride"] = 70.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 28.88, ["Ride"] = 128.63, ["Neon"] = 167.9, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 1024.58, ["Mega|Ride"] = 1000.96, ["Mega|Fly|Ride"] = 914.48}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.7, ["Ride"] = 52.5, ["Neon"] = 80.07, ["Neon|Ride"] = 75.42, ["Neon|Fly|Ride"] = 209.46, ["Mega"] = 278.58, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.87, ["Fly"] = 139.54, ["Ride"] = 28.26, ["Neon"] = 95.82, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 44.92, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1020.05}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 54.51, ["Fly"] = 98.39, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 405.3, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 622.09, ["Mega"] = 1256.73, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 12.44, ["Fly"] = 39.38, ["Ride"] = 28.74, ["Fly|Ride"] = 56.17, ["Neon"] = 63, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 125.69, ["Mega"] = 249.38, ["Mega|Ride"] = 276.54, ["Mega|Fly|Ride"] = 283.64}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 75.04, ["Fly"] = 140.21, ["Ride"] = 124.69, ["Neon"] = 203.44, ["Neon|Ride"] = 285.77, ["Neon|Fly|Ride"] = 315, ["Mega"] = 869.89, ["Mega|Ride"] = 1117.45, ["Mega|Fly|Ride"] = 812.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.15, ["Fly"] = 70.11, ["Ride"] = 69.98, ["Fly|Ride"] = 173.25, ["Neon"] = 86.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 354.55, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 11.83, ["Fly"] = 70.11, ["Ride"] = 19.69, ["Fly|Ride"] = 56.51, ["Neon"] = 82.68, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 125.69, ["Mega"] = 625.19, ["Mega|Ride"] = 1047.27, ["Mega|Fly|Ride"] = 401.81}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 24.93, ["Ride"] = 69.83, ["Fly|Ride"] = 112.42, ["Neon"] = 85.3, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 278.5, ["Mega"] = 365.46, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 475.79}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 11.79, ["Ride"] = 32.44, ["Fly|Ride"] = 138.12, ["Neon"] = 44.63, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 125.69, ["Mega"] = 389.58, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 41.91, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 100.56, ["Mega"] = 15.75, ["Mega|Fly"] = 140.35, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.39, ["Ride"] = 20.9, ["Fly|Ride"] = 434.2, ["Neon"] = 19.67, ["Neon|Fly"] = 125.69, ["Neon|Ride"] = 83.79, ["Mega"] = 155.01, ["Mega|Ride"] = 289.06, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 3.28, ["Neon"] = 23.61, ["Neon|Ride"] = 103.7, ["Mega"] = 196.23, ["Mega|Ride"] = 191.66, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.25, ["Ride"] = 31.5, ["Fly|Ride"] = 116.95, ["Neon"] = 14.44, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 272.3, ["Mega"] = 123.38, ["Mega|Ride"] = 158.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 540.75, ["Fly"] = 626.7, ["Ride"] = 525, ["Fly|Ride"] = 586.68, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.47, ["Fly"] = 27.75, ["Ride"] = 25.12, ["Fly|Ride"] = 54.42, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 279.63}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 12.51, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 39.38, ["Neon"] = 45.94, ["Neon|Ride"] = 104.73, ["Mega"] = 273.27, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.94, ["Fly"] = 28.26, ["Ride"] = 17.07, ["Fly|Ride"] = 313.89, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 223.13, ["Mega|Ride"] = 631.07, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 54.12, ["Ride"] = 30.19, ["Fly|Ride"] = 90.57, ["Neon"] = 7.74, ["Neon|Ride"] = 38.85, ["Neon|Fly|Ride"] = 119.41, ["Mega"] = 70.17, ["Mega|Ride"] = 94.75, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.11, ["Ride"] = 19.68, ["Neon"] = 3.89, ["Neon|Ride"] = 30.24, ["Mega"] = 26.24, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 54.76, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1510.09}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 11.46, ["Ride"] = 28.13, ["Fly|Ride"] = 68.81, ["Neon"] = 140.21, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 173.45, ["Mega|Ride"] = 544.59, ["Mega|Fly|Ride"] = 833.63}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 6.62, ["Neon|Ride"] = 40.69, ["Mega"] = 38.07, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.82, ["Fly"] = 98.36, ["Ride"] = 23.04, ["Fly|Ride"] = 574.39, ["Neon"] = 14.98, ["Neon|Fly"] = 125.69, ["Neon|Ride"] = 62.53, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 140.35, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 418.69, ["Ride"] = 418.69, ["Fly|Ride"] = 431.82, ["Neon|Ride"] = 1340.51, ["Neon|Fly|Ride"] = 1675.63, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.06, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 82.43, ["Neon|Ride"] = 131.25, ["Mega"] = 390.2, ["Mega|Ride"] = 449.08}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 37.57, ["Neon|Fly|Ride"] = 94.45, ["Mega"] = 43.3, ["Mega|Fly"] = 189, ["Mega|Ride"] = 108.84, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 2.63, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 266.02, ["Mega"] = 22.98, ["Mega|Ride"] = 146.64, ["Mega|Fly|Ride"] = 222.04}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 17.68, ["Fly"] = 56.27, ["Ride"] = 27.57, ["Fly|Ride"] = 174.74, ["Neon"] = 65.62, ["Neon|Ride"] = 104.73, ["Neon|Fly|Ride"] = 279.66, ["Mega"] = 346.66, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 381.22}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.19, ["Ride"] = 111.96, ["Neon"] = 89.84, ["Neon|Ride"] = 112.08, ["Neon|Fly|Ride"] = 837.82, ["Mega"] = 393.75, ["Mega|Ride"] = 349.8, ["Mega|Fly|Ride"] = 1076.93}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.25, ["Ride"] = 31.5, ["Fly|Ride"] = 382.22, ["Neon"] = 105, ["Neon|Ride"] = 94.57, ["Mega"] = 628.37, ["Mega|Ride"] = 557.19, ["Mega|Fly|Ride"] = 1256.73}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 25.82, ["Ride"] = 28.26, ["Neon|Ride"] = 180.07, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 459.38, ["Mega|Ride"] = 586.48, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 279.42, ["Ride"] = 393.75, ["Fly|Ride"] = 616.88, ["Neon"] = 1789.48, ["Neon|Ride"] = 1438.94, ["Neon|Fly|Ride"] = 1229.5, ["Mega|Ride"] = 3492.61, ["Mega|Fly|Ride"] = 3465}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.72, ["Fly"] = 69.65, ["Ride"] = 23.62, ["Fly|Ride"] = 140.21, ["Neon"] = 97.44, ["Neon|Ride"] = 140.35, ["Neon|Fly|Ride"] = 137.67, ["Mega"] = 559.26, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 820.01}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 28.11, ["Mega"] = 1256.73, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1675.63}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 12.13, ["Ride"] = 65.63, ["Fly|Ride"] = 217.64, ["Neon"] = 47.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 235.6, ["Mega|Fly"] = 279.63, ["Mega|Ride"] = 224.32, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.61, ["Ride"] = 42, ["Fly|Ride"] = 116.15, ["Neon"] = 15.7, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 208.42, ["Mega"] = 55.49, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 81.69, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 49.88, ["Ride"] = 131.25, ["Neon"] = 250.07, ["Neon|Ride"] = 235.51, ["Neon|Fly|Ride"] = 418.91, ["Mega"] = 1813.86, ["Mega|Ride"] = 1340.51, ["Mega|Fly|Ride"] = 1397.05}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.6, ["Fly"] = 55.13, ["Ride"] = 181.22, ["Neon"] = 11.82, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 62.85, ["Neon|Fly|Ride"] = 112.08, ["Mega"] = 65.63, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Fly"] = 68.57, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 51.19, ["Mega|Fly"] = 156.09, ["Mega|Fly|Ride"] = 148.42}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 4.74, ["Ride"] = 70.11, ["Fly|Ride"] = 111.43, ["Neon"] = 94.83, ["Neon|Fly|Ride"] = 698.54, ["Mega"] = 417.86, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.94, ["Ride"] = 63.68, ["Fly|Ride"] = 315.38, ["Neon"] = 437.07, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 627.32, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 237.58, ["Ride"] = 223.91, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 5864.64, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 19.66, ["Neon"] = 25.89, ["Mega"] = 86.63, ["Mega|Ride"] = 192.71, ["Mega|Fly|Ride"] = 541.26}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 15.7, ["Neon"] = 45.93, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 106.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.92, ["Fly"] = 155.57, ["Ride"] = 20.56, ["Fly|Ride"] = 177.16, ["Neon"] = 33.53, ["Mega"] = 519.1, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 25.32, ["Fly|Ride"] = 85.46, ["Neon"] = 6.2, ["Neon|Ride"] = 23.65, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 45.93, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 33.49, ["Fly|Ride"] = 279.37, ["Neon"] = 8.17, ["Mega"] = 52.49, ["Mega|Ride"] = 207.37, ["Mega|Fly|Ride"] = 275.44}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.06, ["Fly|Ride"] = 41.95, ["Neon"] = 5.25, ["Neon|Fly"] = 42.46, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.29, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 120.45}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.59, ["Fly"] = 90.36, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 7.25, ["Neon|Fly"] = 70.18, ["Neon|Ride"] = 11.83, ["Neon|Fly|Ride"] = 91.12, ["Mega"] = 156.13, ["Mega|Ride"] = 209.46, ["Mega|Fly|Ride"] = 418.91}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 42.56, ["Ride"] = 39.38, ["Mega"] = 420, ["Mega|Fly"] = 525, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 643.02}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 90.57, ["Fly"] = 582.75, ["Ride"] = 74.82, ["Fly|Ride"] = 160.13, ["Neon"] = 340.04, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 706.92, ["Mega"] = 1470, ["Mega|Fly|Ride"] = 1857.72}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 35.43, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 63.82, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 167.57}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.76, ["Ride"] = 15.7, ["Fly|Ride"] = 35.41, ["Neon"] = 3.84, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 20.96, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 45.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 7.75, ["Ride"] = 51.19, ["Fly|Ride"] = 140.21, ["Neon"] = 65.63, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 167.57, ["Mega"] = 626.82, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 349.55, ["Fly"] = 393.74, ["Ride"] = 349.46, ["Fly|Ride"] = 496.98, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1569.86, ["Mega|Fly|Ride"] = 5586.08}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 65.63, ["Fly"] = 140.21, ["Ride"] = 69.06, ["Neon"] = 246.88, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 301.63, ["Mega|Ride"] = 1187.6, ["Mega|Fly|Ride"] = 1117.45}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 139.64, ["Neon"] = 12.56, ["Neon|Ride"] = 49.24, ["Neon|Fly|Ride"] = 98.45, ["Mega"] = 78.75, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 189.09}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.62, ["Fly"] = 209.26, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 71.23, ["Neon|Fly|Ride"] = 112.08, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 21, ["Fly"] = 76.89, ["Ride"] = 39.37, ["Fly|Ride"] = 65.62, ["Neon|Ride"] = 314.19, ["Mega"] = 2513.43, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 975}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 128.51, ["Ride"] = 98.75, ["Fly|Ride"] = 140.21, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3072.66, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 196.88, ["Fly"] = 277.61, ["Ride"] = 249.38, ["Fly|Ride"] = 278.23, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 907.99, ["Mega|Fly|Ride"] = 3204.62}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.16, ["Fly"] = 69.07, ["Ride"] = 51.33, ["Fly|Ride"] = 217.34, ["Neon"] = 144.39, ["Neon|Ride"] = 137.38, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 388.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 452.12}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 16.27, ["Fly|Ride"] = 40.05, ["Neon"] = 10.48, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 87.98, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.21, ["Fly"] = 30.62, ["Ride"] = 20.35, ["Fly|Ride"] = 639.68, ["Neon"] = 36.63, ["Neon|Fly"] = 146.64, ["Neon|Ride"] = 47.35, ["Neon|Fly|Ride"] = 99.5, ["Mega"] = 283, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 308.44, ["Fly"] = 488.72, ["Ride"] = 315.38, ["Fly|Ride"] = 406.88, ["Neon"] = 1467.02, ["Neon|Ride"] = 1340.51, ["Neon|Fly|Ride"] = 1891.1, ["Mega|Fly|Ride"] = 4607.94}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 60.38, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 416.82}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.67, ["Ride"] = 16.68, ["Fly|Ride"] = 62.65, ["Neon"] = 28.26, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 158.99, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.33, ["Ride"] = 98.44, ["Neon"] = 140.21, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 466.48, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 158.82, ["Fly"] = 278.32, ["Ride"] = 152.77, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 788.37, ["Neon|Fly|Ride"] = 643.19, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.63, ["Fly"] = 45.93, ["Ride"] = 26.25, ["Fly|Ride"] = 47.25, ["Neon"] = 91.88, ["Neon|Ride"] = 102.64, ["Neon|Fly|Ride"] = 157.11, ["Mega"] = 628.37, ["Mega|Ride"] = 439.87, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Ride"] = 25.15, ["Neon|Fly|Ride"] = 698.54, ["Mega"] = 21, ["Mega|Ride"] = 103.7, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Fly"] = 158.4, ["Neon|Ride"] = 23.65, ["Neon|Fly|Ride"] = 69.88, ["Mega"] = 27.57, ["Mega|Fly"] = 140.65, ["Mega|Ride"] = 60.76, ["Mega|Fly|Ride"] = 83.79}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.84, ["Fly"] = 418.5, ["Ride"] = 65.63, ["Fly|Ride"] = 134.92, ["Neon"] = 31.5, ["Neon|Ride"] = 70.01, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 131.25, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1036.88, ["Ride"] = 1036.88, ["Fly|Ride"] = 1337.44, ["Neon|Ride"] = 6982.06, ["Neon|Fly|Ride"] = 6074.1, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.19, ["Ride"] = 379.32, ["Fly|Ride"] = 474.02, ["Neon"] = 1827.74, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1629.21, ["Mega"] = 16756.1, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 275.63, ["Fly"] = 401.63, ["Ride"] = 318.94, ["Fly|Ride"] = 420, ["Neon"] = 735, ["Neon|Fly"] = 1261.12, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 709.17, ["Mega|Fly|Ride"] = 3072.55}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 262.5, ["Fly"] = 447.8, ["Ride"] = 418.5, ["Fly|Ride"] = 459.38, ["Neon"] = 1098.56, ["Neon|Fly"] = 1117.45, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1249.5, ["Mega|Fly|Ride"] = 4329.36}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 15.75, ["Fly|Ride"] = 45.94, ["Neon"] = 6.25, ["Neon|Ride"] = 33.08, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 60.02, ["Mega|Ride"] = 53.81, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 439.3, ["Fly"] = 558.84, ["Ride"] = 459.38, ["Fly|Ride"] = 682.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 13090.7, ["Mega|Fly|Ride"] = 5801.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.29, ["Fly"] = 183.75, ["Ride"] = 27.56, ["Neon"] = 10.29, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 117.83, ["Mega"] = 57.1, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 25.12, ["Ride"] = 16.94, ["Fly|Ride"] = 28.26, ["Neon"] = 8.39, ["Neon|Ride"] = 49.21, ["Neon|Fly|Ride"] = 107.58, ["Mega"] = 91.88, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 315.54}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Mega"] = 24.94, ["Mega|Fly"] = 167.57, ["Mega|Ride"] = 59.71, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 32.45, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 279.63, ["Mega"] = 2094.52, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 64.31, ["Ride"] = 17.07, ["Fly|Ride"] = 60.44, ["Neon"] = 32.82, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.83, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 55.63, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.43, ["Mega|Fly"] = 698.54, ["Mega|Ride"] = 111.09, ["Mega|Fly|Ride"] = 315.54}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.22, ["Ride"] = 24.01, ["Fly|Ride"] = 57.36, ["Neon"] = 9.09, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 56.21, ["Mega"] = 61.68, ["Mega|Fly"] = 174.9, ["Mega|Ride"] = 99.98, ["Mega|Fly|Ride"] = 154.86}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.16, ["Fly"] = 47.28, ["Ride"] = 18.81, ["Fly|Ride"] = 51.45, ["Neon"] = 112.08, ["Neon|Fly"] = 141.84, ["Neon|Ride"] = 140.35, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 279.63, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 18.96, ["Ride"] = 52.5, ["Neon"] = 56.44, ["Neon|Ride"] = 279.63, ["Neon|Fly|Ride"] = 315.54, ["Mega"] = 377.03, ["Mega|Ride"] = 448.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.94, ["Ride"] = 27.21, ["Fly|Ride"] = 70.11, ["Neon"] = 48.14, ["Neon|Ride"] = 98.45, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 439.03, ["Mega|Ride"] = 525}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.88, ["Ride"] = 18.38, ["Fly|Ride"] = 55.53, ["Neon"] = 3.94, ["Neon|Fly"] = 28.29, ["Neon|Ride"] = 28.27, ["Mega"] = 43.32, ["Mega|Ride"] = 83.79, ["Mega|Fly|Ride"] = 314.19}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 236.35, ["Ride"] = 258.57, ["Fly|Ride"] = 353.64, ["Neon|Ride"] = 2618.15, ["Neon|Fly|Ride"] = 1101.73, ["Mega"] = 8378.06, ["Mega|Fly|Ride"] = 5199.69}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.33, ["Ride"] = 12.56, ["Fly|Ride"] = 37.68, ["Neon"] = 5.23, ["Neon|Fly"] = 25.15, ["Neon|Ride"] = 23.5, ["Neon|Fly|Ride"] = 49.79, ["Mega"] = 44.63, ["Mega|Ride"] = 63.82, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.59, ["Ride"] = 94.48, ["Fly|Ride"] = 183.73, ["Neon"] = 45.94, ["Neon|Ride"] = 98.44, ["Mega"] = 442.67, ["Mega|Ride"] = 457.67, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.88, ["Fly"] = 210, ["Ride"] = 124.68, ["Fly|Ride"] = 170.63, ["Neon"] = 157.5, ["Neon|Ride"] = 311.92, ["Mega"] = 837.82, ["Mega|Ride"] = 768.15, ["Mega|Fly|Ride"] = 929.98}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 187.97, ["Ride"] = 236.25, ["Fly|Ride"] = 333.38, ["Neon"] = 766.34, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 704.82, ["Mega|Ride"] = 3351.24, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 30.74, ["Fly|Ride"] = 140.58, ["Neon"] = 82.74, ["Neon|Ride"] = 279.63, ["Mega"] = 285.48, ["Mega|Ride"] = 237.75, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 41.57, ["Ride"] = 418.5, ["Fly|Ride"] = 627.76, ["Neon"] = 627.76, ["Neon|Ride"] = 268.31, ["Neon|Fly|Ride"] = 837.82, ["Mega"] = 1675.63, ["Mega|Fly|Ride"] = 922.65}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1142.42, ["Ride"] = 1273.13, ["Fly|Ride"] = 1252.13, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4796.44, ["Mega|Fly|Ride"] = 17147.76}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.94, ["Fly"] = 28.06, ["Ride"] = 22.32, ["Fly|Ride"] = 56.51, ["Neon"] = 174.11, ["Neon|Fly"] = 76.59, ["Neon|Ride"] = 35.62, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 222.04, ["Mega|Ride"] = 228.32, ["Mega|Fly|Ride"] = 316.29}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.57, ["Fly"] = 65.63, ["Ride"] = 33, ["Fly|Ride"] = 86.63, ["Neon"] = 25.69, ["Neon|Ride"] = 48.19, ["Mega"] = 348.63, ["Mega|Ride"] = 187.55, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 12.33, ["Ride"] = 103.69, ["Fly|Ride"] = 942.36, ["Neon"] = 124.58, ["Mega"] = 542.07, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 627.32}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.12, ["Fly"] = 41.86, ["Ride"] = 41.98, ["Fly|Ride"] = 72.19, ["Neon"] = 60.38, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.62, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 5.1, ["Fly"] = 19.68, ["Ride"] = 18.76, ["Fly|Ride"] = 48.14, ["Neon"] = 22.28, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 59.12, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 405.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.3, ["Fly"] = 414.42, ["Ride"] = 22.45, ["Neon"] = 7.07, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 837.82, ["Mega"] = 87.94, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 387.22, ["Ride"] = 328.13, ["Fly|Ride"] = 418.5, ["Neon|Ride"] = 1520.63, ["Neon|Fly|Ride"] = 1465.13, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4189.03}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.61, ["Fly"] = 39.38, ["Ride"] = 28.03, ["Fly|Ride"] = 60.69, ["Neon"] = 10.26, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 99.74, ["Mega|Ride"] = 111.49, ["Mega|Fly|Ride"] = 417.86}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.57, ["Ride"] = 21.83, ["Neon"] = 131.24, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 349.8}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 17.07, ["Fly"] = 67.36, ["Ride"] = 41.86, ["Neon"] = 10.29, ["Neon|Fly"] = 70.18, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 166.52, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 356.08}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 240.53, ["Fly"] = 354.9, ["Ride"] = 307.13, ["Fly|Ride"] = 681.19, ["Neon"] = 829.5, ["Neon|Ride"] = 826.88, ["Neon|Fly|Ride"] = 946.32, ["Mega|Ride"] = 3141.78, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.13, ["Fly"] = 55.48, ["Ride"] = 45.94, ["Fly|Ride"] = 65.63, ["Neon"] = 111.12, ["Neon|Ride"] = 209.46, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 631.07, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.99, ["Ride"] = 39.37, ["Fly|Ride"] = 78.75, ["Neon"] = 97.96, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 489.14, ["Mega|Ride"] = 423.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 37.43, ["Mega"] = 26.25, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 81.09, ["Fly"] = 115.5, ["Ride"] = 163.23, ["Fly|Ride"] = 187.69, ["Neon"] = 347.82, ["Neon|Fly"] = 472.78, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2513.43}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.25, ["Neon"] = 5.25, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 588, ["Mega"] = 39.81, ["Mega|Ride"] = 209.46, ["Mega|Fly|Ride"] = 393.79}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.32, ["Fly"] = 126.46, ["Ride"] = 28.88, ["Fly|Ride"] = 75.78, ["Neon"] = 63.8, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 389.82, ["Mega|Ride"] = 409.49, ["Mega|Fly|Ride"] = 388.55}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 42.45, ["Fly"] = 110.06, ["Ride"] = 90.02, ["Fly|Ride"] = 175.79, ["Neon"] = 320.48, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 346.99, ["Mega|Ride"] = 1340.12, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.2, ["Fly|Ride"] = 32.82, ["Neon"] = 2.62, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 19.91, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 85.11, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.83, ["Ride"] = 33.5, ["Fly|Ride"] = 58.61, ["Neon"] = 16.19, ["Neon|Ride"] = 60.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 235.49, ["Mega|Ride"] = 269.73, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 24.71, ["Fly"] = 41.86, ["Ride"] = 111.05, ["Fly|Ride"] = 209.26, ["Neon"] = 104.64, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 631.16, ["Mega"] = 586.69, ["Mega|Ride"] = 448.27, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 136.16, ["Mega"] = 20.86, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.4, ["Ride"] = 55.53, ["Fly|Ride"] = 120.75, ["Neon"] = 79.15, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 313.15, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 293.83, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.75, ["Fly"] = 28.22, ["Ride"] = 20.86, ["Fly|Ride"] = 45.94, ["Neon"] = 79.21, ["Neon|Ride"] = 67.24, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 4.41, ["Ride"] = 41.86, ["Fly|Ride"] = 76.01, ["Neon"] = 17.75, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.35, ["Mega"] = 129.94, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 275.44}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 18.2, ["Fly"] = 2092.48, ["Ride"] = 96.88, ["Fly|Ride"] = 167.42, ["Neon"] = 237.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 6303.22, ["Mega|Ride"] = 416.07}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 3.87, ["Fly"] = 32.82, ["Ride"] = 128.16, ["Fly|Ride"] = 196.88, ["Neon"] = 6.07, ["Neon|Fly"] = 56.57, ["Neon|Ride"] = 68.83, ["Mega"] = 65.35, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.69, ["Mega|Fly|Ride"] = 519.45}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 3.91, ["Mega"] = 24.84, ["Mega|Ride"] = 106.2, ["Mega|Fly|Ride"] = 237.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.81}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.69, ["Fly"] = 58.61, ["Ride"] = 79.15, ["Fly|Ride"] = 86.63, ["Neon"] = 1050, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 559.26, ["Mega"] = 1243.11, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 3.83, ["Mega"] = 23.63, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 518.02, ["Fly"] = 795.15, ["Ride"] = 577.5, ["Fly|Ride"] = 575.45, ["Neon"] = 2034.94, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16756.1, ["Mega|Ride"] = 15695.23, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.28, ["Fly"] = 26.17, ["Ride"] = 22.74, ["Fly|Ride"] = 89.63, ["Neon"] = 13.12, ["Neon|Fly"] = 698.54, ["Neon|Ride"] = 278.58, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 111.03, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 5.23, ["Fly"] = 158.31, ["Ride"] = 20.89, ["Fly|Ride"] = 59.05, ["Neon"] = 19.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 346.5, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.43, ["Ride"] = 76.13, ["Fly|Ride"] = 522.22, ["Neon"] = 78.74, ["Neon|Ride"] = 182.03, ["Mega"] = 522.59, ["Mega|Ride"] = 510.03, ["Mega|Fly|Ride"] = 643.02}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.63, ["Fly"] = 131.25, ["Ride"] = 31.83, ["Fly|Ride"] = 140.21, ["Neon"] = 36.67, ["Mega"] = 223.13}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.37, ["Ride"] = 65.63, ["Fly|Ride"] = 149.76, ["Neon"] = 47.3, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 358.8, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 649.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.54, ["Fly"] = 104.99, ["Ride"] = 56.51, ["Neon"] = 49.86, ["Neon|Ride"] = 97.85, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 216.57, ["Mega|Fly"] = 485.94, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 378.17}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.54, ["Fly|Ride"] = 62.97, ["Neon"] = 2.1, ["Neon|Fly"] = 59.71, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 77.01, ["Mega"] = 20.9, ["Mega|Fly"] = 62.43, ["Mega|Ride"] = 31.48, ["Mega|Fly|Ride"] = 147.05}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.57, ["Ride"] = 27.56, ["Fly|Ride"] = 158.29, ["Neon"] = 28.14, ["Neon|Fly"] = 118.21, ["Neon|Ride"] = 69.83, ["Neon|Fly|Ride"] = 314.19, ["Mega"] = 194.25, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 418.91}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 246.86, ["Fly"] = 307.15, ["Ride"] = 287.44, ["Fly|Ride"] = 355.73, ["Neon"] = 1114.29, ["Neon|Ride"] = 1151.2, ["Neon|Fly|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 4023.11}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.75, ["Ride"] = 141.75, ["Fly|Ride"] = 209.88, ["Neon"] = 564.38, ["Neon|Ride"] = 570.3, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4189.03, ["Mega|Ride"] = 1772.64, ["Mega|Fly|Ride"] = 1555.18}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.04, ["Ride"] = 19.9, ["Fly|Ride"] = 39.38, ["Neon"] = 23.06, ["Neon|Fly"] = 70.18, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega|Fly"] = 208.42, ["Mega|Ride"] = 98.45, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.07, ["Fly|Ride"] = 31.5, ["Neon"] = 6.46, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 51.1, ["Mega"] = 71.29, ["Mega|Fly"] = 349.8, ["Mega|Ride"] = 120.45, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 418.91, ["Mega"] = 140.35, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231.87, ["Ride"] = 251.11, ["Fly|Ride"] = 321.2, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1201.22, ["Mega|Ride"] = 8378.06, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.63, ["Fly"] = 37.41, ["Ride"] = 17.07, ["Fly|Ride"] = 41.46, ["Neon"] = 19.68, ["Neon|Fly"] = 158.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.03, ["Mega"] = 312.79, ["Mega|Ride"] = 268.27, ["Mega|Fly|Ride"] = 311.64}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Fly"] = 158.31, ["Ride"] = 96.48, ["Fly|Ride"] = 209.26, ["Neon"] = 22.32, ["Neon|Ride"] = 139.12, ["Mega"] = 252, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.74, ["Neon|Ride"] = 31.11, ["Mega"] = 47.29, ["Mega|Ride"] = 96.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.32, ["Ride"] = 23.64, ["Fly|Ride"] = 57.74, ["Neon"] = 78.3, ["Neon|Fly"] = 75.66, ["Neon|Ride"] = 106.39, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 481.76}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 57.75, ["Fly"] = 114.19, ["Ride"] = 107.78, ["Fly|Ride"] = 209.9, ["Neon"] = 175.95, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 397.69, ["Mega"] = 459.38, ["Mega|Fly"] = 2199.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 31.27, ["Fly"] = 158.31, ["Ride"] = 42, ["Fly|Ride"] = 83.71, ["Neon"] = 138.12, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.4, ["Mega"] = 795.94, ["Mega|Ride"] = 624.18, ["Mega|Fly|Ride"] = 689.11}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.78, ["Ride"] = 13.13, ["Fly|Ride"] = 31.91, ["Neon"] = 2.1, ["Neon|Fly"] = 27.83, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 61.81, ["Mega"] = 20.96, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 227.07, ["Fly"] = 292.37, ["Ride"] = 273, ["Fly|Ride"] = 349.57, ["Neon"] = 1229.5, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1097.25, ["Mega|Fly|Ride"] = 4325.18}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 19.69, ["Fly"] = 61.61, ["Ride"] = 46.2, ["Fly|Ride"] = 132.88, ["Neon"] = 103.84, ["Neon|Ride"] = 92.25, ["Neon|Fly|Ride"] = 321.56, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 26.34, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Fly"] = 33.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.03, ["Mega"] = 59.15, ["Mega|Fly"] = 104.73, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 300.18}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 18.24, ["Fly|Ride"] = 55.47, ["Neon"] = 2.52, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 18.8, ["Neon|Fly|Ride"] = 101.51, ["Mega"] = 26.25, ["Mega|Fly"] = 141.83, ["Mega|Ride"] = 48.7, ["Mega|Fly|Ride"] = 98.45}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 24.45, ["Fly|Ride"] = 69.27, ["Neon"] = 11.71, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 79.21, ["Mega"] = 94.12, ["Mega|Ride"] = 122.19, ["Mega|Fly|Ride"] = 386.45}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.13, ["Fly"] = 38.68, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 62.85, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 111.03, ["Mega"] = 322.84, ["Mega|Ride"] = 294.51, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.77, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 55.01, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 275.63, ["Mega|Ride"] = 312.1, ["Mega|Fly|Ride"] = 391.69}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.6, ["Neon"] = 6.57, ["Neon|Ride"] = 39.38, ["Mega"] = 31.53, ["Mega|Ride"] = 68.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 4.74, ["Ride"] = 24.92, ["Fly|Ride"] = 83.71, ["Neon"] = 19.22, ["Neon|Fly"] = 47.3, ["Neon|Ride"] = 69.92, ["Neon|Fly|Ride"] = 87.54, ["Mega"] = 150.94, ["Mega|Ride"] = 258.44, ["Mega|Fly|Ride"] = 300.18}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 125.56, ["Neon"] = 6.57, ["Neon|Fly"] = 98.45, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 35.62, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 167.57}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 28.83, ["Ride"] = 20.92, ["Fly|Ride"] = 118.13, ["Neon"] = 7.91, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 61.82, ["Mega"] = 77.04, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.99, ["Ride"] = 727.13, ["Fly|Ride"] = 721.88, ["Neon"] = 4171.23, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12567.08}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 15.75, ["Fly|Ride"] = 31.49, ["Neon"] = 28.13, ["Neon|Fly"] = 42, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 104.73, ["Mega"] = 187.47, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 34.04, ["Fly|Ride"] = 164.72, ["Neon"] = 10.5, ["Neon|Fly"] = 837.82, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 59.07, ["Mega|Fly"] = 158.38, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 5.87, ["Fly"] = 31.5, ["Ride"] = 23.65, ["Fly|Ride"] = 47.25, ["Neon"] = 38.48, ["Neon|Fly"] = 112.08, ["Neon|Ride"] = 54.52, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 308.96, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 350.79}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.76, ["Fly|Ride"] = 33.77, ["Neon"] = 5.08, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 23.52, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 51, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 155.01}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 83.74, ["Ride"] = 110.91, ["Fly|Ride"] = 208.22, ["Neon"] = 229.1, ["Neon|Ride"] = 251.36, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 887.48, ["Mega|Ride"] = 1110.85, ["Mega|Fly|Ride"] = 1156.19}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Neon"] = 3.94, ["Neon|Fly"] = 134.75, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 63.67, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 155.01}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.68, ["Fly"] = 73.49, ["Ride"] = 22.38, ["Fly|Ride"] = 65.63, ["Neon"] = 11.82, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 98.44, ["Mega|Ride"] = 182.23, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.85, ["Neon"] = 15.7, ["Neon|Fly"] = 31.92, ["Neon|Ride"] = 111.12, ["Mega"] = 111.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.86, ["Fly|Ride"] = 83.71, ["Neon"] = 6.54, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 52.38, ["Mega|Fly"] = 181.92, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 24.43, ["Fly"] = 26.24, ["Ride"] = 27.08, ["Fly|Ride"] = 41.86, ["Neon"] = 103.7, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 837.82, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 426.08}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 734.99, ["Ride"] = 714.94, ["Fly|Ride"] = 853.13, ["Neon"] = 1767.94, ["Neon|Fly"] = 2422.95, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 1929.38, ["Mega"] = 7680.58, ["Mega|Ride"] = 7481.25, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.37, ["Fly|Ride"] = 56.27, ["Neon"] = 3.78, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 18.01, ["Neon|Fly|Ride"] = 60.32, ["Mega"] = 52.75, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 67.04, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.14, ["Ride"] = 32.82, ["Fly|Ride"] = 111.77, ["Neon"] = 29.61, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 258.36, ["Mega"] = 233.56, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 59.06, ["Fly"] = 126.41, ["Ride"] = 78.75, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 553.16, ["Neon|Fly|Ride"] = 423.94, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 23.63, ["Fly"] = 131.25, ["Ride"] = 39.56, ["Fly|Ride"] = 83.71, ["Neon"] = 131.25, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 349.8, ["Mega"] = 978.15, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 788.24}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.14, ["Ride"] = 36.63, ["Neon"] = 102.78, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 315.19, ["Mega|Ride"] = 349.8, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 31.49, ["Ride"] = 94.53, ["Neon"] = 72.19, ["Neon|Ride"] = 362.86, ["Mega"] = 279.63, ["Mega|Fly"] = 512.9, ["Mega|Ride"] = 381.22, ["Mega|Fly|Ride"] = 335.14}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 21, ["Ride"] = 63, ["Fly|Ride"] = 83.71, ["Neon"] = 177.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 304.77, ["Neon|Fly|Ride"] = 377.14, ["Mega"] = 837.82, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 768.15}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 11.53}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.94, ["Fly"] = 131248.69, ["Ride"] = 30.34, ["Fly|Ride"] = 65.1, ["Neon"] = 25.73, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 153.96, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 175.23, ["Mega|Fly|Ride"] = 308.96}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 5.24, ["Ride"] = 39.77, ["Neon"] = 36.75, ["Neon|Ride"] = 43.32, ["Mega"] = 125.69}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 83.58, ["Fly"] = 416.75, ["Ride"] = 105.48, ["Fly|Ride"] = 124.94, ["Neon"] = 266.89, ["Neon|Ride"] = 260.59, ["Neon|Fly|Ride"] = 385.41, ["Mega|Ride"] = 1159.33, ["Mega|Fly|Ride"] = 1111.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.22, ["Fly"] = 30.73, ["Ride"] = 18.37, ["Fly|Ride"] = 35.02, ["Neon"] = 28.98, ["Neon|Fly"] = 70.18, ["Neon|Ride"] = 34.76, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 262.5, ["Mega|Fly"] = 417.86, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.25, ["Fly"] = 83.74, ["Ride"] = 24.93, ["Fly|Ride"] = 77.43, ["Neon"] = 27.55, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 152.92, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 45.94, ["Mega"] = 79.2, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.8, ["Fly"] = 65.63, ["Ride"] = 52.49, ["Fly|Ride"] = 99.75, ["Neon"] = 119.78, ["Neon|Ride"] = 195.85, ["Neon|Fly|Ride"] = 251.36, ["Mega"] = 1117.45, ["Mega|Ride"] = 871.33, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 7.88, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.88, ["Mega"] = 91.12, ["Mega|Ride"] = 114.53}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.57, ["Ride"] = 73.5, ["Neon"] = 61.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 285.32, ["Mega"] = 418.91, ["Mega|Ride"] = 544.59, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 19.9, ["Ride"] = 16.17, ["Fly|Ride"] = 47.24, ["Neon"] = 16.27, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 70.18, ["Mega"] = 144.37, ["Mega|Ride"] = 262.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.86, ["Fly"] = 52.49, ["Ride"] = 17.39, ["Fly|Ride"] = 47.38, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 278.58, ["Mega|Ride"] = 279.63, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.8, ["Ride"] = 37.3, ["Neon"] = 36.21, ["Neon|Ride"] = 111.12, ["Mega"] = 179.96, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 31.92, ["Ride"] = 83.82, ["Fly|Ride"] = 183.1, ["Neon"] = 157.5, ["Neon|Ride"] = 314.19, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 978.15, ["Mega|Ride"] = 1614.88, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.44, ["Ride"] = 78.48, ["Fly|Ride"] = 125.56, ["Neon"] = 131.25, ["Neon|Ride"] = 140.35, ["Mega"] = 411.69, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 14.19, ["Ride"] = 104.99, ["Fly|Ride"] = 279.37, ["Neon"] = 140.2, ["Mega"] = 628.37, ["Mega|Ride"] = 1057.67, ["Mega|Fly|Ride"] = 1047.27}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 17.27, ["Ride"] = 66.49, ["Fly|Ride"] = 530.36, ["Neon"] = 82.65, ["Neon|Ride"] = 111.39, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 837.82, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1112.21}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 6.41, ["Neon"] = 105, ["Mega"] = 147, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 315.54}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.21, ["Fly|Ride"] = 41.98, ["Neon"] = 3.75, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 62.85, ["Mega|Ride"] = 83.39, ["Mega|Fly|Ride"] = 117.14}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.11, ["Ride"] = 55.79, ["Neon"] = 78.75, ["Neon|Ride"] = 115.22, ["Neon|Fly|Ride"] = 134.9, ["Mega"] = 418.91, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.7, ["Ride"] = 17.06, ["Fly|Ride"] = 55.95, ["Neon"] = 5.24, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 43, ["Mega|Ride"] = 81.29, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.36, ["Ride"] = 47.14, ["Fly|Ride"] = 110.35, ["Neon"] = 18.38, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 112.08, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.23, ["Ride"] = 35.44, ["Fly|Ride"] = 70.11, ["Neon"] = 33.53, ["Neon|Fly"] = 472.78, ["Neon|Ride"] = 103.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 381.22, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 1047.27}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.13, ["Fly"] = 131.25, ["Ride"] = 22.3, ["Fly|Ride"] = 42, ["Neon"] = 22.5, ["Neon|Fly"] = 104.73, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 104.9, ["Mega|Ride"] = 249.48, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.14, ["Fly"] = 17.74, ["Ride"] = 22.94, ["Fly|Ride"] = 39.38, ["Neon"] = 15.39, ["Neon|Fly"] = 83.79, ["Neon|Ride"] = 70.18, ["Neon|Fly|Ride"] = 69.14, ["Mega"] = 168, ["Mega|Ride"] = 208.42, ["Mega|Fly|Ride"] = 285.99}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 12.52, ["Fly"] = 301.87, ["Ride"] = 28.26, ["Fly|Ride"] = 105, ["Neon"] = 22.54, ["Neon|Fly"] = 122.94, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 154.88, ["Mega|Ride"] = 397.98, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.63, ["Fly"] = 139.55, ["Ride"] = 98.43, ["Fly|Ride"] = 156.68, ["Neon"] = 80.07, ["Neon|Fly"] = 213.94, ["Neon|Ride"] = 217, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 387.19, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 459.31, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 81.72, ["Ride"] = 97.13, ["Fly|Ride"] = 164.07, ["Neon"] = 249.38, ["Neon|Fly"] = 333.03, ["Neon|Ride"] = 263.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1152, ["Mega|Ride"] = 1005.57, ["Mega|Fly|Ride"] = 1079.08}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.91, ["Ride"] = 22.45, ["Fly|Ride"] = 65.54, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Neon|Fly|Ride"] = 60.76, ["Mega"] = 31.5, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 117.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 4.74, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 911.54, ["Mega|Ride"] = 590.89, ["Mega|Fly|Ride"] = 1252.54}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 41.91, ["Fly"] = 105, ["Ride"] = 78.48, ["Neon"] = 255.14, ["Neon|Ride"] = 267.06, ["Neon|Fly|Ride"] = 522.59, ["Mega"] = 1082.87, ["Mega|Ride"] = 1108.01, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.08, ["Fly"] = 190.32, ["Ride"] = 44.63, ["Fly|Ride"] = 125.99, ["Neon"] = 62.52, ["Neon|Ride"] = 52.5, ["Mega"] = 238.8, ["Mega|Ride"] = 236.37, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 110.44, ["Fly|Ride"] = 137.24, ["Neon"] = 7.88, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 37.43, ["Mega"] = 24.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.42, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 19.49, ["Ride"] = 14.91, ["Fly|Ride"] = 41.7, ["Neon"] = 15.67, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 84.31, ["Mega"] = 158.38, ["Mega|Fly"] = 349.8, ["Mega|Ride"] = 314.35, ["Mega|Fly|Ride"] = 220.87}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 49, ["Mega"] = 34.13, ["Mega|Ride"] = 82.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 16.7, ["Fly|Ride"] = 67.76, ["Neon"] = 5.25, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 83.79, ["Mega"] = 58.66, ["Mega|Fly"] = 168, ["Mega|Ride"] = 112.08, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 158.29, ["Neon"] = 2.1, ["Neon|Ride"] = 123.24, ["Mega"] = 21, ["Mega|Fly|Ride"] = 276.49}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 8.12, ["Ride"] = 40.17, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 207.37, ["Mega"] = 189.09, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.89, ["Ride"] = 83.71, ["Fly|Ride"] = 189.96, ["Neon"] = 57.29, ["Neon|Ride"] = 98.45, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 400.07, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.17, ["Fly"] = 30.73, ["Ride"] = 18.38, ["Fly|Ride"] = 51.44, ["Neon"] = 47.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 55.57, ["Neon|Fly|Ride"] = 90.82, ["Mega"] = 393.75, ["Mega|Ride"] = 335.74, ["Mega|Fly|Ride"] = 309.23}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 52.5, ["Ride"] = 78.75, ["Fly|Ride"] = 262.5, ["Neon"] = 349.46, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 414.72, ["Mega|Fly|Ride"] = 1815.96}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.61, ["Fly"] = 72.44, ["Ride"] = 32.82, ["Fly|Ride"] = 79.15, ["Neon"] = 61.91, ["Mega"] = 624.1, ["Mega|Ride"] = 698.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.84, ["Ride"] = 18.78, ["Fly|Ride"] = 41.86, ["Neon"] = 2.62, ["Neon|Fly"] = 28.29, ["Neon|Ride"] = 23.65, ["Neon|Fly|Ride"] = 70.18, ["Mega"] = 40.51, ["Mega|Ride"] = 59.11, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.74, ["Fly|Ride"] = 32.97, ["Neon"] = 3.94, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 69.57, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 383.27, ["Ride"] = 438.61, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6641.71}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 14.32, ["Ride"] = 140.21, ["Fly|Ride"] = 242.26, ["Neon"] = 89.25, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1256.73}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 33.8, ["Ride"] = 14.93, ["Fly|Ride"] = 32.44, ["Neon"] = 4.11, ["Neon|Fly"] = 70.18, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 43.45, ["Mega"] = 32.81, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 82.68, ["Fly|Ride"] = 223.13, ["Neon"] = 261.19, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 523.64, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1298.61}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 17.41, ["Ride"] = 17.07, ["Fly|Ride"] = 45, ["Neon"] = 10.49, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 77.57, ["Mega|Fly"] = 125.69, ["Mega|Ride"] = 96.36, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.11, ["Ride"] = 25.12, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 92.17, ["Mega"] = 21, ["Mega|Fly"] = 195.85, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.36}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 60.72, ["Fly"] = 139.55, ["Ride"] = 85.72, ["Fly|Ride"] = 124.69, ["Neon"] = 208.22, ["Neon|Ride"] = 236.4, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 654.94, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 754.69}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 16.76, ["Fly|Ride"] = 52.5, ["Neon"] = 7.84, ["Neon|Ride"] = 26.25, ["Mega"] = 122.97, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.12, ["Ride"] = 75.51, ["Neon"] = 154.85, ["Neon|Ride"] = 215.76, ["Neon|Fly|Ride"] = 444.06, ["Mega|Ride"] = 1673.54, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.24, ["Ride"] = 45.94, ["Neon"] = 16.17, ["Neon|Ride"] = 299.77, ["Neon|Fly|Ride"] = 418.91, ["Mega"] = 175.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.81, ["Fly"] = 70.11, ["Ride"] = 18.83, ["Fly|Ride"] = 65.63, ["Neon"] = 11.49, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 32.8, ["Ride"] = 56.51, ["Fly|Ride"] = 196.77, ["Neon"] = 179.67, ["Neon|Ride"] = 208.42, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 2598.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.57, ["Fly"] = 147.78, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 5.64, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 46.78, ["Mega|Fly"] = 180.83, ["Mega|Ride"] = 81.9, ["Mega|Fly|Ride"] = 266.02}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.51, ["Ride"] = 17.07, ["Fly|Ride"] = 102.87, ["Neon"] = 7.48, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 126.49, ["Mega"] = 167.57, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.5, ["Fly"] = 35.6, ["Ride"] = 35.44, ["Fly|Ride"] = 92.14, ["Neon"] = 32.71, ["Neon|Ride"] = 141.84, ["Mega"] = 330.9, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 388.49}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 49.23, ["Ride"] = 63.8, ["Fly|Ride"] = 279.37, ["Neon"] = 216.57, ["Neon|Ride"] = 169.67, ["Neon|Fly|Ride"] = 401.34, ["Mega|Ride"] = 1256.73, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.5, ["Fly"] = 50.15, ["Ride"] = 30.18, ["Fly|Ride"] = 73.5, ["Neon"] = 103.97, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.11, ["Mega"] = 620.57, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 414.72}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 53.82, ["Ride"] = 104.45, ["Fly|Ride"] = 196.88, ["Neon"] = 315, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 521.24, ["Mega"] = 1050, ["Mega|Ride"] = 1153, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.73, ["Ride"] = 35.44, ["Neon"] = 15.37, ["Neon|Ride"] = 62.85, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.2, ["Ride"] = 26.16, ["Fly|Ride"] = 78.74, ["Neon"] = 26.25, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 203.44, ["Mega|Ride"] = 209.46, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.13, ["Fly"] = 65.62, ["Ride"] = 44.78, ["Fly|Ride"] = 98.36, ["Neon"] = 50.59, ["Neon|Ride"] = 138.26, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 514.5, ["Mega|Ride"] = 434.62, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.19, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 60.29, ["Mega"] = 18.38, ["Mega|Fly"] = 79.2, ["Mega|Ride"] = 26.17, ["Mega|Fly|Ride"] = 83.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 65.01, ["Fly"] = 220.5, ["Ride"] = 91.74, ["Fly|Ride"] = 272.04, ["Neon"] = 195.44, ["Neon|Fly"] = 2374.15, ["Neon|Ride"] = 283.67, ["Neon|Fly|Ride"] = 472.78, ["Mega"] = 1187.6, ["Mega|Ride"] = 945.69, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 17.12, ["Fly|Ride"] = 108.83, ["Neon"] = 6.45, ["Neon|Ride"] = 38.07, ["Mega"] = 41.91, ["Mega|Ride"] = 51.27, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.99, ["Ride"] = 16, ["Fly|Ride"] = 40.67, ["Neon"] = 11.81, ["Neon|Fly"] = 79.61, ["Neon|Ride"] = 31.97, ["Neon|Fly|Ride"] = 58.38, ["Mega"] = 166.32, ["Mega|Ride"] = 418.91, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 85.32, ["Ride"] = 137.82, ["Fly|Ride"] = 301.21, ["Neon"] = 328.13, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1036.9, ["Mega|Ride"] = 1256.73, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Neon"] = 5.57, ["Neon|Ride"] = 52.41, ["Mega"] = 73.5, ["Mega|Ride"] = 118.36, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.47}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 102.55, ["Neon"] = 9.19, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 44.6, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 146.54, ["Ride"] = 174.83, ["Fly|Ride"] = 251.11, ["Neon"] = 538.13, ["Neon|Ride"] = 709.17, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3624.42, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2676.41}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 8.33, ["Ride"] = 26.25, ["Neon"] = 29.73, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 206.85, ["Mega"] = 139.44, ["Mega|Ride"] = 207.37, ["Mega|Fly|Ride"] = 444.34}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 3.59, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 137.6, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.9, ["Ride"] = 28.26, ["Neon"] = 38.75, ["Neon|Ride"] = 112.08, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.43, ["Fly"] = 42, ["Ride"] = 26.65, ["Fly|Ride"] = 140.21, ["Neon"] = 74.74, ["Neon|Ride"] = 94.83, ["Neon|Fly|Ride"] = 98.45, ["Mega"] = 251.36, ["Mega|Ride"] = 263.82, ["Mega|Fly|Ride"] = 347.71}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 103.93, ["Fly|Ride"] = 196.88, ["Neon"] = 730.28, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 583.69, ["Mega|Ride"] = 1246.75, ["Mega|Fly|Ride"] = 1256.73}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 130.79, ["Fly"] = 167.43, ["Ride"] = 155.7, ["Fly|Ride"] = 225.75, ["Neon"] = 620.95, ["Neon|Fly"] = 627.32, ["Neon|Ride"] = 473, ["Neon|Fly|Ride"] = 519.75, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 11.43, ["Fly"] = 23.14, ["Ride"] = 28.85, ["Fly|Ride"] = 43.95, ["Neon"] = 173.92, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 110.21, ["Mega|Ride"] = 628.37, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 4.45, ["Fly"] = 131.23, ["Ride"] = 31.26, ["Fly|Ride"] = 83.71, ["Neon"] = 14.04, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 99.74, ["Mega|Ride"] = 181.33, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 11.45, ["Fly"] = 98.36, ["Ride"] = 48.18, ["Fly|Ride"] = 98.36, ["Neon"] = 94.5, ["Mega"] = 394.72, ["Mega|Ride"] = 434.62, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 40.69, ["Ride"] = 60.45, ["Fly|Ride"] = 163.23, ["Neon"] = 241.37, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 851.82, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 945.41}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.95, ["Ride"] = 82.69, ["Fly|Ride"] = 279.37, ["Neon"] = 158.29, ["Neon|Ride"] = 158.05, ["Mega"] = 577.5, ["Mega|Ride"] = 754.04, ["Mega|Fly|Ride"] = 810.59}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 312.38, ["Ride"] = 400.72, ["Neon"] = 1189.59, ["Neon|Ride"] = 1117.45, ["Neon|Fly|Ride"] = 1465.13, ["Mega"] = 4670.77, ["Mega|Fly|Ride"] = 4670.77}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 26.23, ["Ride"] = 39.37, ["Fly|Ride"] = 96.27, ["Neon"] = 251.36, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 840, ["Mega|Ride"] = 891.37, ["Mega|Fly|Ride"] = 977.42}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.65, ["Fly|Ride"] = 70.49, ["Neon"] = 2.62, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 60.37, ["Mega"] = 25.8, ["Mega|Fly"] = 104.73, ["Mega|Ride"] = 49.65, ["Mega|Fly|Ride"] = 156.85}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 278.87, ["Neon"] = 13.02, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 104.73, ["Mega"] = 157.11, ["Mega|Ride"] = 154.83, ["Mega|Fly|Ride"] = 374.94}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.28, ["Fly|Ride"] = 144.16, ["Neon"] = 11.55, ["Neon|Ride"] = 69.14, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 123.38, ["Mega|Fly"] = 544.59, ["Mega|Ride"] = 138.26, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 372.75, ["Fly"] = 630.83, ["Ride"] = 378, ["Fly|Ride"] = 437.07, ["Neon"] = 1387.72, ["Neon|Ride"] = 1453.61, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 46.15, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 24.94, ["Neon|Ride"] = 42.56, ["Neon|Fly|Ride"] = 63.76, ["Mega"] = 126.46, ["Mega|Ride"] = 270.93, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.87, ["Fly"] = 22.31, ["Ride"] = 23.04, ["Fly|Ride"] = 39.38, ["Neon"] = 28.29, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 698.54, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.55, ["Fly"] = 44.71, ["Ride"] = 28.26, ["Fly|Ride"] = 94.5, ["Neon"] = 15.7, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 48.19, ["Neon|Fly|Ride"] = 89.3, ["Mega"] = 181.33, ["Mega|Ride"] = 270.21, ["Mega|Fly|Ride"] = 295.45}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 50.08, ["Fly"] = 65.92, ["Ride"] = 83.71, ["Fly|Ride"] = 61.69, ["Neon"] = 104.9, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 836.77, ["Mega|Fly|Ride"] = 643.12}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 40.05, ["Fly|Ride"] = 69.06, ["Neon"] = 6.75, ["Neon|Ride"] = 35.62, ["Mega"] = 157.25, ["Mega|Ride"] = 395.88, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.97, ["Fly"] = 104.45, ["Ride"] = 19.9, ["Fly|Ride"] = 85.31, ["Neon"] = 82.8, ["Neon|Ride"] = 154.88, ["Mega|Fly|Ride"] = 732.04}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Fly|Ride"] = 40.69, ["Neon"] = 4.64, ["Neon|Ride"] = 41.91, ["Mega"] = 38.75, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 31.92, ["Ride"] = 78.75, ["Neon"] = 36.75, ["Neon|Ride"] = 103.18, ["Mega"] = 416.75}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.74, ["Ride"] = 28.26, ["Neon"] = 68.61, ["Neon|Ride"] = 96.94, ["Mega"] = 308.96, ["Mega|Ride"] = 556.46, ["Mega|Fly|Ride"] = 492.22}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.79, ["Fly"] = 26.17, ["Ride"] = 26.24, ["Fly|Ride"] = 41.86, ["Neon"] = 47.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 586.48, ["Mega|Ride"] = 417.86, ["Mega|Fly|Ride"] = 406}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 192.94, ["Fly"] = 216.56, ["Ride"] = 230.9, ["Fly|Ride"] = 262.5, ["Neon"] = 949.88, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 3351.24}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.44, ["Fly|Ride"] = 56.78, ["Neon"] = 15.54, ["Neon|Fly"] = 79.21, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 220.5, ["Mega|Ride"] = 166.52, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.49, ["Ride"] = 36.2, ["Fly|Ride"] = 104.91, ["Neon"] = 27.76, ["Neon|Ride"] = 32.32, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 278.58, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 55.22, ["Ride"] = 259.88, ["Fly|Ride"] = 416.89, ["Neon"] = 152.81, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 556.5, ["Mega"] = 517.13, ["Mega|Ride"] = 573.14, ["Mega|Fly|Ride"] = 939.41}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 101.07, ["Fly"] = 279.42, ["Ride"] = 189, ["Fly|Ride"] = 295.32, ["Neon"] = 556.61, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 619.5, ["Mega"] = 2094.52, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 2040.07}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 25.99, ["Ride"] = 84.45, ["Fly|Ride"] = 319.91, ["Neon"] = 93.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 317.63, ["Mega|Ride"] = 341.24, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.48, ["Fly|Ride"] = 47.23, ["Neon"] = 15.54, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 197.36, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 23.62, ["Neon"] = 58.7, ["Neon|Ride"] = 222.22, ["Neon|Fly|Ride"] = 201.94, ["Mega"] = 221.67, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 698.54}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 72.19, ["Fly"] = 112, ["Ride"] = 120.75, ["Fly|Ride"] = 210, ["Neon"] = 262.5, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 631.16, ["Mega"] = 826.88, ["Mega|Ride"] = 787.05, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Fly"] = 118.13, ["Ride"] = 102.38, ["Neon"] = 11.54, ["Neon|Ride"] = 104.73, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 49.14, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 18.38, ["Ride"] = 385.07, ["Neon"] = 85.31, ["Neon|Ride"] = 626.45, ["Mega"] = 368.83, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 971.25, ["Fly"] = 1336.91, ["Ride"] = 1015.88, ["Fly|Ride"] = 1034.25, ["Neon"] = 2965.07, ["Neon|Ride"] = 3330.28, ["Neon|Fly|Ride"] = 2429.2, ["Mega|Fly|Ride"] = 10877.86}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 39.35, ["Ride"] = 68.29, ["Fly|Ride"] = 187.69, ["Neon"] = 276.41, ["Neon|Fly"] = 892.5, ["Mega"] = 975, ["Mega|Ride"] = 556.12, ["Mega|Fly|Ride"] = 654.02}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.67, ["Fly"] = 49.22, ["Ride"] = 30.35, ["Fly|Ride"] = 80.89, ["Neon"] = 15.75, ["Neon|Fly"] = 174.9, ["Neon|Ride"] = 37.04, ["Neon|Fly|Ride"] = 83.86, ["Mega"] = 77.42, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 180.14}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.98, ["Ride"] = 131.22, ["Neon"] = 131.2, ["Neon|Fly|Ride"] = 140.35, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.35, ["Fly|Ride"] = 418.5, ["Neon"] = 2.5, ["Neon|Ride"] = 26.1, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 18.03, ["Mega|Fly"] = 125.69, ["Mega|Ride"] = 35.62, ["Mega|Fly|Ride"] = 788.24}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 83.74, ["Ride"] = 134.67, ["Fly|Ride"] = 328.13, ["Neon"] = 305.52, ["Neon|Ride"] = 403.2, ["Neon|Fly|Ride"] = 530.97, ["Mega"] = 1100.15, ["Mega|Ride"] = 1089.78, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 13.13, ["Fly"] = 174.57, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 39.38, ["Neon|Ride"] = 48.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 393.75, ["Mega|Ride"] = 259.73, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.63, ["Ride"] = 28.26, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Mega"] = 170.63, ["Mega|Ride"] = 209.46, ["Mega|Fly|Ride"] = 335.14}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 45.39, ["Ride"] = 82.68, ["Fly|Ride"] = 157.75, ["Neon"] = 236.4, ["Neon|Fly"] = 278.58, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 410.15, ["Mega"] = 1048.69, ["Mega|Ride"] = 945.41, ["Mega|Fly|Ride"] = 597.97}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 24.93, ["Ride"] = 84.68, ["Fly|Ride"] = 195.66, ["Neon"] = 138.5, ["Neon|Ride"] = 245.07, ["Neon|Fly|Ride"] = 308.7, ["Mega"] = 631.07, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 64.32, ["Neon"] = 335.14, ["Neon|Ride"] = 693.8, ["Neon|Fly|Ride"] = 1313.18, ["Mega"] = 1229.5, ["Mega|Ride"] = 2363.5, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.79, ["Ride"] = 63.8, ["Neon"] = 23.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 105, ["Mega|Ride"] = 179.61, ["Mega|Fly|Ride"] = 236.37}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.21, ["Fly"] = 32.15, ["Ride"] = 17.93, ["Fly|Ride"] = 52.5, ["Neon"] = 56.17, ["Neon|Ride"] = 85.02, ["Neon|Fly|Ride"] = 125.34, ["Mega"] = 399, ["Mega|Ride"] = 397.98, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 119.52, ["Ride"] = 147.91, ["Fly|Ride"] = 254.63, ["Neon"] = 507.94, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.62, ["Fly"] = 34.55, ["Ride"] = 17.95, ["Fly|Ride"] = 45.33, ["Neon"] = 9.09, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 52.59, ["Mega"] = 124.04, ["Mega|Ride"] = 145.37, ["Mega|Fly|Ride"] = 215.09}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.13, ["Fly"] = 41.86, ["Ride"] = 24.3, ["Fly|Ride"] = 65.63, ["Neon"] = 47.25, ["Neon|Fly"] = 158.4, ["Neon|Ride"] = 64.61, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 235.66, ["Mega|Ride"] = 235.66, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 39.17, ["Neon"] = 2.63, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 41.7, ["Mega"] = 20.78, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 79.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.42, ["Neon"] = 3.93, ["Neon|Ride"] = 39.81, ["Neon|Fly|Ride"] = 63.83, ["Mega"] = 21.17, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.64}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.61, ["Fly"] = 131.2, ["Ride"] = 27.21, ["Fly|Ride"] = 45.94, ["Neon"] = 38.07, ["Neon|Ride"] = 40.57, ["Mega"] = 91.88, ["Mega|Fly|Ride"] = 293.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.04, ["Ride"] = 84, ["Neon"] = 437.07, ["Neon|Ride"] = 371.79, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.63, ["Mega|Ride"] = 392.44}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.61, ["Fly"] = 17.07, ["Ride"] = 15.7, ["Fly|Ride"] = 32.44, ["Neon"] = 9.63, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 111.09, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 104.73, ["Mega|Fly|Ride"] = 171.15}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.06, ["Fly"] = 25.59, ["Ride"] = 23.52, ["Fly|Ride"] = 59.07, ["Neon"] = 13.13, ["Neon|Fly"] = 36.62, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 169.31, ["Mega|Fly"] = 305.81, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.9, ["Fly"] = 19.47, ["Ride"] = 18.09, ["Fly|Ride"] = 115.71, ["Neon"] = 7.88, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 56.57, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 122.73, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 17.74, ["Ride"] = 26.24, ["Neon"] = 59.64, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 205.27, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 207.4, ["Mega|Fly|Ride"] = 391.69}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 9.18, ["Fly"] = 162.18, ["Ride"] = 59.07, ["Neon"] = 75.62, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 390, ["Mega|Fly|Ride"] = 1047.27}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.92, ["Fly"] = 48.57, ["Ride"] = 17.07, ["Fly|Ride"] = 63, ["Neon"] = 20.48, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 36.71, ["Neon|Fly|Ride"] = 105, ["Mega"] = 315.54, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 321.51}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.56, ["Fly"] = 20.88, ["Ride"] = 18.36, ["Fly|Ride"] = 52.49, ["Neon"] = 11.55, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 20.86, ["Neon|Fly|Ride"] = 62.85, ["Mega"] = 418.91, ["Mega|Ride"] = 235.18, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 216.57, ["Fly"] = 393.75, ["Ride"] = 223.91, ["Fly|Ride"] = 223.91, ["Neon"] = 1201.22, ["Neon|Ride"] = 978.15, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Fly|Ride"] = 3839.26}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.85, ["Ride"] = 39.12, ["Neon"] = 14.44, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.52, ["Ride"] = 19.62, ["Fly|Ride"] = 56.31, ["Neon"] = 21.3, ["Neon|Fly"] = 209.46, ["Neon|Ride"] = 37.54, ["Neon|Fly|Ride"] = 201.79, ["Mega"] = 187.11, ["Mega|Ride"] = 271.25, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Ride"] = 24.94, ["Neon"] = 50.29, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 628.37, ["Mega"] = 471.53, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 431.18}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.7, ["Fly|Ride"] = 31.2, ["Neon"] = 2.63, ["Neon|Fly"] = 20.96, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 41.97, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.3, ["Fly"] = 44.63, ["Ride"] = 19.68, ["Fly|Ride"] = 58.97, ["Neon"] = 18.94, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 51.77, ["Mega"] = 115.48, ["Mega|Ride"] = 137.4, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.62, ["Ride"] = 46.09, ["Neon"] = 15.7, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 58.95, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 286.96}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 63, ["Fly"] = 140.21, ["Ride"] = 91.88, ["Fly|Ride"] = 200.89, ["Neon"] = 521.24, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 429.9, ["Mega|Ride"] = 3492.61, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.39, ["Fly"] = 85.32, ["Ride"] = 33.49, ["Fly|Ride"] = 65.63, ["Neon"] = 28.26, ["Neon|Ride"] = 55.57, ["Neon|Fly|Ride"] = 112.08, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 45.04, ["Fly|Ride"] = 118.13, ["Neon"] = 4.74, ["Neon|Ride"] = 125.69, ["Neon|Fly|Ride"] = 167.57, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 104.73, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 55.3, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 194.25, ["Neon"] = 154.88, ["Neon|Ride"] = 192.01, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 559.26, ["Mega|Ride"] = 530.97, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 14.82, ["Fly|Ride"] = 28.88, ["Neon"] = 2.62, ["Neon|Fly"] = 24.1, ["Neon|Ride"] = 15.63, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 27.16, ["Mega|Fly"] = 36.02, ["Mega|Ride"] = 56.57, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.91, ["Neon|Ride"] = 69.14, ["Neon|Fly|Ride"] = 83.65, ["Mega"] = 35.44, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 279.63}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.19, ["Ride"] = 58.36, ["Fly|Ride"] = 137.82, ["Neon"] = 12.56, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 187.47, ["Mega"] = 65.6, ["Mega|Ride"] = 209.25}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.43, ["Fly"] = 70.88, ["Ride"] = 59.07, ["Fly|Ride"] = 137.63, ["Neon"] = 40.65, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 93.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 108.94, ["Mega|Fly"] = 183.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 15.65, ["Fly|Ride"] = 36.63, ["Neon"] = 2.1, ["Neon|Fly"] = 22.46, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 26.17, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.12, ["Ride"] = 56.51, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 489.08, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 670.26}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2624.99, ["Fly"] = 3150, ["Ride"] = 2780.21, ["Fly|Ride"] = 2690.63, ["Neon|Ride"] = 9775.1, ["Neon|Fly|Ride"] = 9775.1, ["Mega|Fly|Ride"] = 43461.1}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 11.54, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 22.88, ["Neon|Fly|Ride"] = 52.03, ["Mega"] = 74.82, ["Mega|Fly"] = 467.1, ["Mega|Ride"] = 113.75, ["Mega|Fly|Ride"] = 279.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.81, ["Neon"] = 11.71, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 628.37}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.69, ["Ride"] = 26.25, ["Fly|Ride"] = 122.27, ["Neon"] = 94.5, ["Neon|Ride"] = 102.84, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 311.72, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 542.49}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 43.32, ["Ride"] = 98.44, ["Neon"] = 155.04, ["Neon|Ride"] = 167.57, ["Neon|Fly|Ride"] = 418.91, ["Mega"] = 540.75, ["Mega|Ride"] = 590.67, ["Mega|Fly|Ride"] = 556.12}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 162.75, ["Fly"] = 1395.69, ["Ride"] = 196.88, ["Fly|Ride"] = 244.88, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6283.55, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.88, ["Fly"] = 26.25, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 23.64, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 224.14, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 237.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.51, ["Ride"] = 62.78, ["Neon"] = 14.01, ["Neon|Fly"] = 98.45, ["Neon|Fly|Ride"] = 523.64, ["Mega"] = 136.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 840.24}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.51, ["Fly"] = 101.98, ["Ride"] = 40.16, ["Fly|Ride"] = 131.25, ["Neon"] = 11.53, ["Neon|Ride"] = 44.92, ["Mega"] = 94.56, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 231.47}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.94, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon"] = 167.57, ["Neon|Ride"] = 1165.81, ["Mega"] = 374.06, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 687.1}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.11, ["Neon"] = 2.1, ["Neon|Ride"] = 51.19, ["Mega"] = 16.86, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 418.91}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 91.88, ["Fly|Ride"] = 143.07, ["Neon"] = 522.59, ["Neon|Fly"] = 502.7, ["Neon|Ride"] = 413.68, ["Neon|Fly|Ride"] = 416.81, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1675.63}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.06, ["Neon|Ride"] = 137.67, ["Mega"] = 52.5, ["Mega|Ride"] = 141.83}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 59.52, ["Fly"] = 220.92, ["Ride"] = 86.37, ["Fly|Ride"] = 140.21, ["Neon"] = 295.32, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 437.06, ["Mega"] = 2625, ["Mega|Ride"] = 2679.03, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.07, ["Fly|Ride"] = 69.72, ["Neon"] = 5.22, ["Neon|Fly"] = 120.45, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 52.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 122.73}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Neon"] = 19.69, ["Neon|Ride"] = 118.13, ["Mega"] = 104.22, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.48, ["Ride"] = 53.55, ["Fly|Ride"] = 140.21, ["Neon"] = 47.25, ["Neon|Ride"] = 158.4, ["Neon|Fly|Ride"] = 176.31, ["Mega"] = 229.69, ["Mega|Ride"] = 343.88, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 348.55, ["Fly"] = 459.38, ["Ride"] = 433.13, ["Fly|Ride"] = 538.82, ["Neon"] = 1279.69, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1207.5, ["Mega|Ride"] = 4886.51, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.57, ["Ride"] = 43.18, ["Fly|Ride"] = 92.69, ["Neon"] = 177.19, ["Neon|Fly"] = 315.59, ["Neon|Ride"] = 196.17, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 831.53, ["Mega|Fly|Ride"] = 1024.58}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.57, ["Fly"] = 47.38, ["Ride"] = 16.95, ["Fly|Ride"] = 91.88, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 83.79, ["Mega"] = 46.95, ["Mega|Ride"] = 83.79, ["Mega|Fly|Ride"] = 155.01}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.69, ["Fly"] = 364.62, ["Ride"] = 41.86, ["Fly|Ride"] = 78.74, ["Neon"] = 55.09, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 181.33, ["Mega"] = 209.94, ["Mega|Fly"] = 389.6, ["Mega|Ride"] = 259.4, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.25, ["Ride"] = 23.12, ["Fly|Ride"] = 265.76, ["Neon"] = 126.02, ["Neon|Ride"] = 91.88, ["Mega|Ride"] = 448.25, ["Mega|Fly|Ride"] = 510.03}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.17, ["Neon"] = 18.38, ["Mega"] = 59.05, ["Mega|Ride"] = 150.83, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.61, ["Fly"] = 86.62, ["Ride"] = 19.69, ["Fly|Ride"] = 51.99, ["Neon"] = 26.25, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 551.88, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 131.25, ["Ride"] = 118.13, ["Fly|Ride"] = 174.12, ["Neon"] = 559.26, ["Neon|Ride"] = 615.57, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 2932.33, ["Mega|Fly|Ride"] = 3488.42}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 32.81, ["Fly"] = 95.82, ["Ride"] = 115.41, ["Fly|Ride"] = 157.97, ["Neon"] = 183.75, ["Neon|Ride"] = 192.14, ["Mega"] = 837.82, ["Mega|Ride"] = 788.24, ["Mega|Fly|Ride"] = 785.46}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2349.37, ["Ride"] = 2533.13, ["Fly|Ride"] = 2362.48, ["Neon"] = 11160.16, ["Neon|Fly|Ride"] = 7121.35, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.36, ["Fly"] = 65625, ["Ride"] = 110.24, ["Fly|Ride"] = 170.63, ["Neon"] = 15.54, ["Neon|Ride"] = 36.67, ["Neon|Fly|Ride"] = 167.57, ["Mega"] = 125.97, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 32.43, ["Ride"] = 54.42, ["Fly|Ride"] = 140.21, ["Neon"] = 815.06, ["Neon|Ride"] = 115.84, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 273, ["Mega|Ride"] = 308.96, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.79, ["Fly"] = 1451.14, ["Ride"] = 853.13, ["Fly|Ride"] = 1006.69, ["Neon"] = 2278.33, ["Neon|Ride"] = 4189.03, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 11450.71}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 49.65, ["Ride"] = 61.74, ["Neon"] = 237.59, ["Neon|Ride"] = 291.72, ["Mega"] = 722.63, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 4.2, ["Ride"] = 21.76, ["Fly|Ride"] = 128.15, ["Neon"] = 13.01, ["Neon|Ride"] = 140.35, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 91.88, ["Mega|Ride"] = 346.66, ["Mega|Fly|Ride"] = 330.95}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 54.32, ["Ride"] = 19.9, ["Neon"] = 7.1, ["Neon|Ride"] = 24.9, ["Mega"] = 31.96, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 75.35, ["Ride"] = 111.05, ["Fly|Ride"] = 315.38, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2234.87, ["Mega|Fly|Ride"] = 2679.03}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 11.42, ["Ride"] = 28.26, ["Neon"] = 24.94, ["Neon|Ride"] = 90.57, ["Mega"] = 157.11}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 59.07, ["Ride"] = 97.63, ["Fly|Ride"] = 126.4, ["Neon"] = 341.25, ["Neon|Ride"] = 415.77, ["Mega|Fly|Ride"] = 1792.47}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 2.63, ["Fly"] = 104.98, ["Neon"] = 33.27, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.16, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 229.69, ["Ride"] = 262.5, ["Fly|Ride"] = 334.69, ["Neon"] = 1103.93, ["Neon|Ride"] = 1111.02, ["Neon|Fly|Ride"] = 813.74, ["Mega|Fly|Ride"] = 4184.84}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.63, ["Fly"] = 87.62, ["Ride"] = 28.26, ["Fly|Ride"] = 41.79, ["Neon"] = 39.81, ["Neon|Ride"] = 64.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 315.54, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 312.1}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 17.01, ["Fly|Ride"] = 39.38, ["Neon"] = 4.53, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 40.2, ["Neon|Fly|Ride"] = 42.95, ["Mega"] = 62.85, ["Mega|Fly"] = 120.45, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 866.25, ["Fly"] = 1297.34, ["Ride"] = 903, ["Fly|Ride"] = 1114.32, ["Neon|Ride"] = 7680.58, ["Neon|Fly|Ride"] = 4743.38, ["Mega"] = 26531.17, ["Mega|Fly|Ride"] = 27927.17}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.29, ["Fly"] = 977.19, ["Ride"] = 210, ["Neon"] = 44.72, ["Neon|Ride"] = 41.91, ["Mega"] = 197.73, ["Mega|Ride"] = 268.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.54, ["Ride"] = 26.24, ["Fly|Ride"] = 78.17, ["Neon"] = 27.21, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 67.38, ["Neon|Fly|Ride"] = 158.4, ["Mega"] = 154.94, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.64, ["Fly"] = 35.14, ["Ride"] = 43.32, ["Fly|Ride"] = 66.94, ["Neon|Ride"] = 124.95, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2094.52, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 27.56, ["Fly"] = 72.19, ["Ride"] = 32.82, ["Fly|Ride"] = 87.94, ["Neon"] = 61.03, ["Neon|Ride"] = 112.08, ["Neon|Fly|Ride"] = 141.84, ["Mega"] = 367.5, ["Mega|Fly"] = 315, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.25}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 18.25, ["Ride"] = 262.5, ["Fly|Ride"] = 111.96, ["Neon"] = 90.95, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 268.36, ["Mega"] = 488.03, ["Mega|Ride"] = 544.59, ["Mega|Fly|Ride"] = 684.92}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 28.2, ["Fly|Ride"] = 236.24, ["Neon"] = 2.51, ["Neon|Ride"] = 28.14, ["Mega"] = 20.85, ["Mega|Fly"] = 85.11, ["Mega|Ride"] = 37.54, ["Mega|Fly|Ride"] = 89.07}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 35.44, ["Fly"] = 87.94, ["Ride"] = 51.18, ["Fly|Ride"] = 104.99, ["Neon"] = 266.02, ["Neon|Fly"] = 276.49, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 3351.24, ["Mega|Fly|Ride"] = 1058.99}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.19, ["Fly"] = 19.69, ["Ride"] = 28.26, ["Fly|Ride"] = 70.88, ["Neon"] = 31.4, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 773.07, ["Mega|Ride"] = 303.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.04, ["Ride"] = 20.86, ["Fly|Ride"] = 51.19, ["Neon"] = 15.75, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.2, ["Ride"] = 103.69, ["Neon"] = 41.62, ["Neon|Ride"] = 837.82, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 293.25, ["Mega|Fly|Ride"] = 472.71}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 32.82, ["Fly"] = 262.4, ["Ride"] = 88.1, ["Fly|Ride"] = 236.25, ["Neon"] = 118.12, ["Neon|Fly"] = 308.96, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 293.25, ["Mega"] = 723.39, ["Mega|Ride"] = 772.87, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.31, ["Neon"] = 24.61, ["Neon|Ride"] = 72.96, ["Neon|Fly|Ride"] = 79.21, ["Mega"] = 59.07, ["Mega|Fly"] = 698.54, ["Mega|Fly|Ride"] = 315.54}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.6, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 17.07, ["Mega|Ride"] = 48.77, ["Mega|Fly|Ride"] = 200.04}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.82, ["Ride"] = 22.98, ["Fly|Ride"] = 81.99, ["Neon"] = 2.63, ["Neon|Ride"] = 32.7, ["Mega"] = 20.56, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.07, ["Fly|Ride"] = 51.24, ["Neon"] = 7.88, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.73, ["Neon|Fly|Ride"] = 52.38, ["Mega"] = 92.19, ["Mega|Ride"] = 140.35, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.72, ["Fly|Ride"] = 4799.83, ["Neon"] = 15.7, ["Neon|Ride"] = 1312.5, ["Mega"] = 162.35, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.06, ["Fly|Ride"] = 52.33, ["Neon"] = 13.81, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 397.04, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 140.25, ["Ride"] = 150.94, ["Fly|Ride"] = 627.76, ["Neon"] = 243.33, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1047.27, ["Mega"] = 824.2, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 1117.45}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 18.84, ["Ride"] = 19.69, ["Fly|Ride"] = 43.32, ["Neon"] = 3.03, ["Neon|Fly"] = 25.15, ["Neon|Ride"] = 25.02, ["Neon|Fly|Ride"] = 47.13, ["Mega"] = 27.57, ["Mega|Ride"] = 56.57, ["Mega|Fly|Ride"] = 94.11}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.76, ["Fly"] = 62.78, ["Ride"] = 41.49, ["Fly|Ride"] = 77.6, ["Neon"] = 48.49, ["Neon|Fly"] = 91.71, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 107.52, ["Mega"] = 628.37, ["Mega|Ride"] = 239.09, ["Mega|Fly|Ride"] = 303.45}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.07, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 78.75, ["Neon"] = 99.75, ["Neon|Fly"] = 139.63, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 156.85, ["Mega"] = 1128.96, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 456.19}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.91, ["Fly"] = 140.21, ["Ride"] = 47.25, ["Neon"] = 42, ["Neon|Ride"] = 70.18, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.75, ["Fly|Ride"] = 39.77, ["Neon"] = 5.24, ["Neon|Fly"] = 40.86, ["Neon|Ride"] = 20.86, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 46.1, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 111.54}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 47.28, ["Ride"] = 28.26, ["Neon"] = 23.64, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 969.94, ["Fly"] = 1228.29, ["Ride"] = 943.69, ["Fly|Ride"] = 984.37, ["Neon"] = 2776.29, ["Neon|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 6928.69}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 68.25, ["Fly"] = 158.31, ["Ride"] = 114.93, ["Fly|Ride"] = 196.88, ["Neon"] = 337.13, ["Neon|Ride"] = 377.03, ["Neon|Fly|Ride"] = 470.24, ["Mega"] = 1765.68, ["Mega|Ride"] = 1732.18, ["Mega|Fly|Ride"] = 1117.45}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.5, ["Neon"] = 7.88, ["Neon|Ride"] = 70.18, ["Neon|Fly|Ride"] = 209.46, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 182.23}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 34.13, ["Ride"] = 85.03, ["Fly|Ride"] = 157.5, ["Neon"] = 199.85, ["Neon|Ride"] = 189.13, ["Neon|Fly|Ride"] = 328.84, ["Mega"] = 918.75, ["Mega|Ride"] = 954.61, ["Mega|Fly|Ride"] = 970.89}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.03, ["Ride"] = 26.25, ["Fly|Ride"] = 156.19, ["Neon"] = 121.03, ["Neon|Ride"] = 212.76, ["Neon|Fly|Ride"] = 278.58, ["Mega"] = 271.57, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.13, ["Fly"] = 418.5, ["Ride"] = 262.5, ["Fly|Ride"] = 311.84, ["Neon"] = 1131.9, ["Neon|Ride"] = 1114.29, ["Neon|Fly|Ride"] = 944.99, ["Mega|Fly|Ride"] = 4607.94}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.62, ["Fly"] = 94.44, ["Ride"] = 21.37, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 49.66, ["Mega"] = 406.81, ["Mega|Fly"] = 279.63}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 24.1, ["Mega"] = 335.14}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 64.31, ["Ride"] = 138.12, ["Fly|Ride"] = 167.42, ["Neon"] = 349.46, ["Neon|Ride"] = 394.77, ["Mega"] = 590.63, ["Mega|Ride"] = 559.26, ["Mega|Fly|Ride"] = 795.94}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 111.96, ["Neon"] = 14.44, ["Neon|Ride"] = 35.62, ["Mega"] = 279.63, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.7, ["Fly|Ride"] = 32.82, ["Neon"] = 3.29, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 41.77, ["Mega"] = 37.72, ["Mega|Fly"] = 70.18, ["Mega|Ride"] = 39.36, ["Mega|Fly|Ride"] = 104.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4349.63, ["Neon"] = 27899.87, ["Neon|Fly|Ride"] = 22062.99, ["Mega|Fly|Ride"] = 62835.31}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.18, ["Ride"] = 48.14, ["Neon"] = 69.91, ["Neon|Ride"] = 106.32, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 20.85, ["Fly|Ride"] = 35.58, ["Neon"] = 15.54, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 56.57, ["Mega"] = 229.53, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 251.36}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 450.17, ["Fly"] = 529.24, ["Ride"] = 485.62, ["Fly|Ride"] = 511.88, ["Neon"] = 1371.57, ["Neon|Ride"] = 1397.05, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.55, ["Ride"] = 19.4, ["Neon"] = 14.68, ["Neon|Ride"] = 145.69, ["Mega"] = 127.34, ["Mega|Fly|Ride"] = 321.51}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.11, ["Fly"] = 65.63, ["Ride"] = 35.44, ["Neon"] = 19.91, ["Neon|Ride"] = 279.63, ["Neon|Fly|Ride"] = 279.63, ["Mega"] = 411.48, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.34, ["Ride"] = 18.38, ["Neon"] = 3.93, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 38.85, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 182.23}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 698.01, ["Fly"] = 823.4, ["Ride"] = 638.86, ["Fly|Ride"] = 664, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1968.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.92, ["Ride"] = 38.06, ["Neon"] = 21, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 179.65, ["Mega"] = 123.27, ["Mega|Ride"] = 169.09, ["Mega|Fly|Ride"] = 291.04}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 8.6, ["Fly"] = 236.15, ["Ride"] = 123.38, ["Fly|Ride"] = 131.25, ["Neon"] = 84.96, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 151.59, ["Mega|Fly|Ride"] = 293.25}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 12.46, ["Neon|Fly"] = 98.45, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 79.21, ["Mega"] = 207.5, ["Mega|Fly"] = 140.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21.13, ["Ride"] = 47.25, ["Neon"] = 115.5, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 56.57, ["Mega"] = 441.99, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 39.53, ["Mega|Ride"] = 93.81, ["Mega|Fly|Ride"] = 250.4}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 406.88, ["Ride"] = 471.19, ["Fly|Ride"] = 584.87, ["Neon"] = 2520.61, ["Neon|Ride"] = 2444.3, ["Neon|Fly|Ride"] = 1793.39, ["Mega"] = 8351.39, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.35, ["Ride"] = 69.83, ["Neon"] = 9.47, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 64.61, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Fly"] = 140.35, ["Neon|Ride"] = 211.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.05, ["Mega|Fly"] = 98.45, ["Mega|Ride"] = 125.69, ["Mega|Fly|Ride"] = 209.46}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21.81, ["Neon"] = 4.6, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 41.91, ["Mega|Fly"] = 155.01, ["Mega|Ride"] = 72.18}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 4.74, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 47.3, ["Mega"] = 105, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 114.35, ["Ride"] = 124.69, ["Fly|Ride"] = 498.73, ["Neon"] = 392.44, ["Neon|Ride"] = 335.14, ["Neon|Fly|Ride"] = 2363.86, ["Mega"] = 1047.27, ["Mega|Ride"] = 2094.52, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.56, ["Fly"] = 68.72, ["Ride"] = 78.2, ["Fly|Ride"] = 125.56, ["Neon"] = 98.44, ["Neon|Ride"] = 143.59, ["Mega"] = 463.31, ["Mega|Ride"] = 284.57, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.62, ["Fly"] = 83.71, ["Ride"] = 18.38, ["Fly|Ride"] = 48.14, ["Neon"] = 32.63, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 69.14, ["Mega"] = 299.92, ["Mega|Ride"] = 260.65, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.48, ["Ride"] = 64.32, ["Fly|Ride"] = 99.41, ["Neon"] = 279.63, ["Mega|Fly|Ride"] = 978.15}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 6.57, ["Fly"] = 178.92, ["Ride"] = 41.86, ["Fly|Ride"] = 111.57, ["Neon"] = 139.55, ["Neon|Ride"] = 98.45, ["Mega"] = 240.03, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 522.59}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.07, ["Fly"] = 69.06, ["Ride"] = 30.17, ["Fly|Ride"] = 56.44, ["Neon"] = 228.74, ["Neon|Ride"] = 203.18, ["Neon|Fly|Ride"] = 322.23, ["Mega"] = 941.5, ["Mega|Ride"] = 963.48, ["Mega|Fly|Ride"] = 768.7}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 158.82, ["Neon|Ride"] = 551.97, ["Mega|Ride"] = 288.36}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 43.53, ["Fly"] = 115.5, ["Ride"] = 82.69, ["Fly|Ride"] = 124.69, ["Neon"] = 273, ["Neon|Fly"] = 349.8, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 1671, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 51.85, ["Fly"] = 92.79, ["Ride"] = 115.5, ["Fly|Ride"] = 144.38, ["Neon"] = 156.17, ["Neon|Ride"] = 283.67, ["Neon|Fly|Ride"] = 205.67, ["Mega"] = 585.94, ["Mega|Ride"] = 631.07, ["Mega|Fly|Ride"] = 697.49}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 14.97, ["Ride"] = 68.25, ["Neon"] = 124.64, ["Mega"] = 628.37, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 11.61, ["Fly"] = 52.5, ["Ride"] = 41.91, ["Fly|Ride"] = 83.71, ["Neon"] = 70.88, ["Neon|Ride"] = 91.85, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 349.49, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 375.98}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.72, ["Ride"] = 14.41, ["Fly|Ride"] = 41.86, ["Neon"] = 5.25, ["Neon|Fly"] = 25.15, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 62.85, ["Mega"] = 52.86, ["Mega|Fly"] = 209.46, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 20.99, ["Ride"] = 56.44, ["Fly|Ride"] = 166.37, ["Neon"] = 158.4, ["Neon|Fly"] = 249.26, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 457.67, ["Mega"] = 500.6, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 16.69, ["Neon"] = 3.64, ["Neon|Ride"] = 40.86, ["Neon|Fly|Ride"] = 293.25, ["Mega"] = 31.5, ["Mega|Ride"] = 83.79}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 39.79, ["Fly"] = 118.14, ["Ride"] = 65.62, ["Neon"] = 158.82, ["Neon|Ride"] = 140.35, ["Neon|Fly|Ride"] = 275.44, ["Mega"] = 627.32, ["Mega|Ride"] = 720.85, ["Mega|Fly|Ride"] = 1046.22}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 105, ["Mega"] = 32.39}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 47.3, ["Mega"] = 26.25, ["Mega|Fly"] = 140.35, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 116.71, ["Fly"] = 178.96, ["Ride"] = 131.25, ["Fly|Ride"] = 224.43, ["Neon"] = 426.57, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 2238.23, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 35.58, ["Fly|Ride"] = 70.89, ["Neon"] = 11.83, ["Neon|Fly"] = 56.57, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 140.35, ["Mega"] = 90.15, ["Mega|Ride"] = 101.34, ["Mega|Fly|Ride"] = 559.26}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.25, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.45, ["Mega"] = 47.25, ["Mega|Ride"] = 117.01, ["Mega|Fly|Ride"] = 170.18}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.56, ["Neon|Ride"] = 37.43, ["Mega"] = 26.25, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.74, ["Neon|Ride"] = 31.11, ["Mega"] = 47.29, ["Mega|Ride"] = 96.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 56.2, ["Ride"] = 111.57, ["Fly|Ride"] = 450.19, ["Neon"] = 276.17, ["Neon|Ride"] = 405.3, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1568.81, ["Mega|Ride"] = 1570.9, ["Mega|Fly|Ride"] = 1260.93}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.8, ["Ride"] = 37.3, ["Neon"] = 36.21, ["Neon|Ride"] = 111.12, ["Mega"] = 179.96, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.95}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 279.42, ["Ride"] = 393.75, ["Fly|Ride"] = 616.88, ["Neon"] = 1789.48, ["Neon|Ride"] = 1438.94, ["Neon|Fly|Ride"] = 1229.5, ["Mega|Ride"] = 3492.61, ["Mega|Fly|Ride"] = 3465}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.95}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 77.44}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.55}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.32}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 45.26}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.25}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.3}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.88}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 227.08}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.7}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.95}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 16.71}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.16}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.58}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.8}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.3}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 7.14}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 393.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.62}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 695.03}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 15.85}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1501.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.57}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.98}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 164.29}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.94}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.37}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 15.7}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 8.89}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 5.24}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 36.75}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.92}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1783.69}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 24.94}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 299.25}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.28}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.62}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 11.53}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 131.25}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 31.4}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 31.39}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 10124.63}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 30.19}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.88}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 157.49}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.16}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 13.13}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 16.64}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.61}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 5.19}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 135.45}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.5}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 10.87}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 21.76}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 58.46}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 102.36}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22508.81}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.68}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 35.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 126}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 64.04}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 60.68}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 45.93}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 114.19}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 82.05}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.04}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.1}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 26.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 21}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 74.22}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.48}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.48}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 245.34}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1967.44}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 524.99}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 21}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.62}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.36}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.26}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 55.7}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 53.82}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 57.27}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.29}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.62}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.78}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 26.25}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 6.57}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.5}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 20.85}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 131.25}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.95}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.59}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.45}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.91}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 129.94}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.25}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 89.63}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 13.13}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 28.88}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 47.29}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 87.91}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 36.75}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.97}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 15.65}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.84}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 5.25}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 15.7}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 70.73}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.09}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.67}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.62}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.85}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.62}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 48.57}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.45}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 11.53}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.56}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.02}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.92}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 1.95}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.63}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 190.49}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 35.6}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.98}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.16}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 19.62}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 7.87}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2609.96}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.46}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 8.71}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.03}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.3}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.95}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.62}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.8}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.12}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 12.56}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 19.49}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.41}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 12.45}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11.32}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.36}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 8.39}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.15}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.6}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 6.55}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 12.45}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.45}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 145.69}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.46}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 58.63}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.64}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 27.23}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 16.75}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.61}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.95}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.48}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 19.69}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 4.88}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 25.86}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.93}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 14.16}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 23.63}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.57}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 5.25}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.67}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.38}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 14.28}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 21.92}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.54}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.64}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 70.13}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.2}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 5.99}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.09}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.2}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 158.37}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.46}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 17.06}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 6.55}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.6}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.74}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.46}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 4.75}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 16.66}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 146.53}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.62}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 120.75}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.88}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 166.4}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 203.44}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 18.32}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 43.19}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.24}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.86}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 138.14}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.78}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.59}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 4.08}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 19.69}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.13}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 51.18}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.61}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 58.37}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.77}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 35.44}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 78.75}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.17}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 65.63}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.39}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 15.65}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 107.35}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 65.62}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 279.42}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 409.5}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 104.81}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.9}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.81}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.62}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 25.55}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 43.32}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.79}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 13.07}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.44}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 17.52}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 10.4}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 43.89}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.17}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.3}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.54}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 64.3}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 34.88}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 28.86}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1227.19}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.91}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.5}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.6}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 324.19}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 19.24}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.48}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 234.92}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.19}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.79}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 102.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 65.63}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 917.44}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 159.88}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.89}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2127.05}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.62}},
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