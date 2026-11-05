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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1017.19, ["Ride"] = 1312.49, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25109.56}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 454.68, ["Fly"] = 502.21, ["Ride"] = 457.94, ["Fly|Ride"] = 531.44, ["Neon"] = 2092.73, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8997.6}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4829.99, ["Fly|Ride"] = 4959.82, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 68354.48}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 183.74, ["Fly|Ride"] = 262.5, ["Neon"] = 682.5, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 793.61, ["Mega"] = 4045.79, ["Mega|Fly|Ride"] = 2651.16}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 555.41, ["Fly"] = 696.81, ["Ride"] = 539.44, ["Fly|Ride"] = 569.63, ["Neon|Ride"] = 1903.73, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.73, ["Ride"] = 34.52, ["Fly|Ride"] = 140.22, ["Neon"] = 73.38, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 279.37, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 42, ["Ride"] = 32.81, ["Fly|Ride"] = 58.97, ["Neon"] = 24.93, ["Neon|Fly"] = 115.75, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 104.64, ["Mega"] = 317.69, ["Mega|Fly"] = 276.04, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 89.25, ["Fly"] = 656.25, ["Ride"] = 164.06, ["Fly|Ride"] = 182.44, ["Neon"] = 565.05, ["Neon|Ride"] = 600.62, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2613.5}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.42, ["Fly"] = 53.82, ["Ride"] = 41.86, ["Fly|Ride"] = 95.19, ["Neon"] = 338.07, ["Neon|Ride"] = 204.45, ["Neon|Fly|Ride"] = 278.32, ["Mega"] = 1395.69, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 22.82, ["Fly"] = 33.92, ["Ride"] = 32.4, ["Fly|Ride"] = 65.63, ["Neon"] = 140.22, ["Neon|Ride"] = 166.39, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 1359.07, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 62.78, ["Fly"] = 124.51, ["Ride"] = 71.08, ["Fly|Ride"] = 111.57, ["Neon"] = 333.17, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 308.09, ["Mega|Fly|Ride"] = 1507.49}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 53.96}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 360.14, ["Fly"] = 343.06, ["Ride"] = 353.07, ["Fly|Ride"] = 374.99, ["Neon"] = 1283.63, ["Neon|Ride"] = 1427.81, ["Neon|Fly|Ride"] = 1216.66, ["Mega|Fly|Ride"] = 4869.18}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.69, ["Fly"] = 141.75, ["Ride"] = 112.18, ["Fly|Ride"] = 143.06, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2510.97}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 115.91, ["Ride"] = 50.3, ["Fly|Ride"] = 209.26, ["Neon"] = 27.57, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 189, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 152.24, ["Fly"] = 188.33, ["Ride"] = 157.5, ["Fly|Ride"] = 205.99, ["Neon"] = 951.87, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 580.05, ["Mega|Fly|Ride"] = 1962.19}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.92, ["Fly"] = 27.21, ["Ride"] = 19.68, ["Fly|Ride"] = 47.44, ["Neon"] = 68.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 140.21, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 72.19, ["Fly"] = 140.21, ["Ride"] = 104.99, ["Fly|Ride"] = 209.26, ["Neon"] = 251.05, ["Neon|Fly"] = 475.95, ["Neon|Ride"] = 284.62, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 1385.95, ["Mega|Ride"] = 990.84, ["Mega|Fly|Ride"] = 1069.74}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 57.75}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 71.46, ["Ride"] = 105, ["Fly|Ride"] = 231.17, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 3173.2}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.7, ["Fly"] = 374.07, ["Ride"] = 40.82, ["Fly|Ride"] = 118.73, ["Neon"] = 205.06, ["Neon|Ride"] = 237.38, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 697.85, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1673.99}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 35.06, ["Fly"] = 95.19, ["Ride"] = 65.62, ["Fly|Ride"] = 102.92, ["Neon"] = 238.92, ["Neon|Fly"] = 311.83, ["Neon|Ride"] = 159.45, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1665.74, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.02, ["Fly"] = 71.39, ["Ride"] = 155.76, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Fly"] = 395.04, ["Neon|Ride"] = 209.28, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 1087.05, ["Mega|Ride"] = 1251.31, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 27.21, ["Fly"] = 64.24, ["Ride"] = 56.51, ["Fly|Ride"] = 83.39, ["Neon"] = 209.28, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2090.39, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 78.53, ["Fly"] = 593.6, ["Ride"] = 81.62, ["Fly|Ride"] = 154.87, ["Neon"] = 182.43, ["Neon|Ride"] = 309.73, ["Mega|Ride"] = 1066.12, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.16, ["Fly"] = 59.49, ["Ride"] = 21.95, ["Fly|Ride"] = 49.87, ["Neon"] = 27.01, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 83.62, ["Mega"] = 131.25, ["Mega|Fly"] = 25108.99, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 266.01}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 385.91, ["Ride"] = 382.58, ["Fly|Ride"] = 441, ["Neon"] = 1814.39, ["Neon|Ride"] = 1674.19, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 12554.78, ["Mega|Fly|Ride"] = 7323.63}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 8.71, ["Ride"] = 35.58, ["Fly|Ride"] = 105.18, ["Neon"] = 217.88, ["Mega|Fly|Ride"] = 919.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.8, ["Fly"] = 49.19, ["Ride"] = 26.11, ["Fly|Ride"] = 48.09, ["Neon"] = 41.77, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 98.12, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 109.31, ["Fly"] = 140.21, ["Ride"] = 103.68, ["Fly|Ride"] = 140.22, ["Neon|Ride"] = 728.44, ["Neon|Fly|Ride"] = 476.05, ["Mega"] = 2077.83, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1976.26}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.7, ["Ride"] = 29.58, ["Fly|Ride"] = 61.74, ["Neon"] = 62.68, ["Neon|Ride"] = 138.04, ["Neon|Fly|Ride"] = 161.43, ["Mega"] = 713.9, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 180.09, ["Fly"] = 353.63, ["Ride"] = 210, ["Fly|Ride"] = 287.94, ["Neon"] = 837.1, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6277.41, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2858.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.98}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.24, ["Fly"] = 33.5, ["Ride"] = 24.93, ["Fly|Ride"] = 82.66, ["Neon"] = 26.25, ["Neon|Fly"] = 4635.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 154.86, ["Mega"] = 144.38, ["Mega|Fly"] = 285.57, ["Mega|Ride"] = 237.47, ["Mega|Fly|Ride"] = 249.61}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1246.1, ["Fly"] = 3281.25, ["Ride"] = 1312.5, ["Fly|Ride"] = 1427.81, ["Neon"] = 5581.29, ["Neon|Ride"] = 5581.29, ["Neon|Fly|Ride"] = 5381.25, ["Mega|Ride"] = 53540.7, ["Mega|Fly|Ride"] = 17451.9}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.14, ["Fly"] = 69.06, ["Ride"] = 41.86, ["Fly|Ride"] = 94.5, ["Neon"] = 104.42, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 142.43, ["Mega"] = 517.9, ["Mega|Ride"] = 668.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 104.94, ["Fly"] = 251.11, ["Ride"] = 131.25, ["Fly|Ride"] = 249.38, ["Neon"] = 930.23, ["Neon|Ride"] = 697.93, ["Neon|Fly|Ride"] = 941.61, ["Mega|Ride"] = 4021.74, ["Mega|Fly|Ride"] = 2776.72}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 41.86}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.44, ["Fly"] = 68.85, ["Ride"] = 64.32, ["Fly|Ride"] = 140.19, ["Neon"] = 95.51, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 555.65}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 127.85, ["Ride"] = 209.26, ["Fly|Ride"] = 223.12, ["Neon"] = 525, ["Neon|Ride"] = 517.97, ["Mega|Fly|Ride"] = 2222.55}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.87, ["Ride"] = 158.89, ["Fly|Ride"] = 498.75, ["Neon"] = 417.52, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 1673.99, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1673.99}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 44.29}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 64.32, ["Fly"] = 88.05, ["Ride"] = 59.07, ["Fly|Ride"] = 64.32, ["Neon"] = 600.62, ["Neon|Ride"] = 404.56, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 4184.94, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.75, ["Fly"] = 41.86, ["Ride"] = 39.38, ["Fly|Ride"] = 111.98, ["Neon"] = 39.25, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 233.33, ["Mega"] = 226.08, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 392.44, ["Fly"] = 423.94, ["Ride"] = 422.38, ["Fly|Ride"] = 485.52, ["Neon|Ride"] = 1568.73, ["Neon|Fly|Ride"] = 1307.31, ["Mega|Fly|Ride"] = 6125.44}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.88, ["Fly"] = 125.56, ["Ride"] = 105, ["Fly|Ride"] = 149.63, ["Neon"] = 492.28, ["Neon|Ride"] = 509.27, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 2232.67, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7114.38, ["Fly"] = 3609.38, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14646.2}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 38.57, ["Fly"] = 111.96, ["Ride"] = 51.17, ["Fly|Ride"] = 97.63, ["Neon"] = 393.75, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 314.25, ["Mega|Ride"] = 1625.86, ["Mega|Fly|Ride"] = 1255.5}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Fly"] = 83.71, ["Ride"] = 57.75, ["Neon"] = 593.74, ["Neon|Ride"] = 334.85, ["Neon|Fly|Ride"] = 680.06, ["Mega"] = 6277.41, ["Mega|Fly|Ride"] = 1660.38}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.4, ["Fly"] = 64.18, ["Ride"] = 73.24, ["Fly|Ride"] = 119.95, ["Neon"] = 215.56, ["Neon|Fly"] = 475.95, ["Neon|Ride"] = 176.11, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 2598.75, ["Mega|Ride"] = 680.74, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 14.58}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.94, ["Ride"] = 56.4, ["Fly|Ride"] = 72.19, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 418.5, ["Mega|Fly|Ride"] = 1587.2}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.67}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 208.69, ["Ride"] = 783.64, ["Fly|Ride"] = 320.17, ["Neon|Ride"] = 1395.85, ["Neon|Fly|Ride"] = 2486.16}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 955.5, ["Fly|Ride"] = 945, ["Neon|Ride"] = 3288.69, ["Neon|Fly|Ride"] = 3444.21, ["Mega|Fly|Ride"] = 15693.47}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.46}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.47, ["Fly"] = 52.49, ["Ride"] = 38.96, ["Fly|Ride"] = 65.61, ["Neon"] = 120.75, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 192.94, ["Mega|Ride"] = 761.15, ["Mega|Fly|Ride"] = 823.4}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.71}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5379.64, ["Fly"] = 5831.7, ["Ride"] = 4659.38, ["Fly|Ride"] = 4723.68, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40294.74}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.48, ["Fly"] = 74.65, ["Ride"] = 26.25, ["Fly|Ride"] = 55, ["Neon"] = 81.37, ["Neon|Ride"] = 98.37, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 461.41, ["Mega|Ride"] = 690.53, ["Mega|Fly|Ride"] = 542.48}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.25, ["Fly"] = 191.66, ["Ride"] = 35.44, ["Fly|Ride"] = 117.79, ["Neon"] = 138.13, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.91, ["Mega"] = 1046.25, ["Mega|Ride"] = 656.01, ["Mega|Fly|Ride"] = 938.49}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 103.16, ["Fly"] = 217.19, ["Ride"] = 124.68, ["Fly|Ride"] = 116.62, ["Neon"] = 1395.85, ["Neon|Fly|Ride"] = 558.71, ["Mega"] = 4184.94}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Ride"] = 30.33, ["Fly|Ride"] = 139.64, ["Neon"] = 75.64, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.36, ["Mega"] = 364.1, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1967.44, ["Fly"] = 2459.7, ["Ride"] = 2191.6, ["Fly|Ride"] = 2168.25, ["Neon|Fly|Ride"] = 4703.88, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30691.21, ["Fly"] = 35529.95, ["Ride"] = 34875.08, ["Fly|Ride"] = 23231.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 214084.26}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.97, ["Fly"] = 221.82, ["Ride"] = 41.99, ["Fly|Ride"] = 125.57, ["Neon"] = 263.82, ["Neon|Ride"] = 171.35, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 837, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1478.93}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.03, ["Fly"] = 32.82, ["Ride"] = 41.87, ["Fly|Ride"] = 157.5, ["Neon"] = 24.86, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 126.03, ["Mega"] = 122.13, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 237.98}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.5, ["Ride"] = 52.5, ["Fly|Ride"] = 111.57, ["Neon"] = 61.69, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 416.69, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 722.97, ["Fly"] = 767.94, ["Ride"] = 707.44, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2609.63, ["Neon|Fly|Ride"] = 2840.54, ["Mega|Fly|Ride"] = 11105.54}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 900.46, ["Fly"] = 900.38, ["Ride"] = 898.37, ["Fly|Ride"] = 983.07, ["Neon"] = 4185.44, ["Neon|Fly|Ride"] = 2877.05, ["Mega|Fly|Ride"] = 11274.21}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 24.92, ["Fly"] = 118.97, ["Ride"] = 45, ["Fly|Ride"] = 107.63, ["Neon"] = 106.31, ["Neon|Ride"] = 193.2, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 835.11, ["Mega|Ride"] = 685.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.32}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 58.35, ["Fly"] = 52.5, ["Ride"] = 74.81, ["Fly|Ride"] = 116.15, ["Neon|Ride"] = 418.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 2048.53, ["Mega|Fly|Ride"] = 1759.77}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 64.73, ["Ride"] = 59.07, ["Fly|Ride"] = 217.66, ["Neon"] = 450.19, ["Neon|Fly"] = 537.85, ["Neon|Ride"] = 635.38, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1755.59, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 46.04, ["Ride"] = 15.7, ["Fly|Ride"] = 51.81, ["Neon"] = 39.37, ["Neon|Fly"] = 525, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 139.19, ["Mega"] = 177.19, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 81.99, ["Fly"] = 90.04, ["Ride"] = 98.43, ["Fly|Ride"] = 146.71, ["Neon"] = 819.31, ["Neon|Ride"] = 310.58, ["Neon|Fly|Ride"] = 378.86, ["Mega|Fly|Ride"] = 1308.57}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.77, ["Ride"] = 37.68, ["Fly|Ride"] = 105, ["Neon"] = 26.25, ["Neon|Ride"] = 107.76, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 207.38, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 454.08}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.65, ["Fly"] = 40.28, ["Ride"] = 32.82, ["Fly|Ride"] = 72.18, ["Neon"] = 140.19, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 739.7, ["Mega|Fly|Ride"] = 697.85}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 24.94, ["Ride"] = 64.26, ["Fly|Ride"] = 156.19, ["Neon"] = 237.57, ["Neon|Ride"] = 330.66, ["Mega"] = 694.25, ["Mega|Ride"] = 555.65, ["Mega|Fly|Ride"] = 871.68}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.37, ["Fly"] = 109.83, ["Ride"] = 24.94, ["Fly|Ride"] = 83.7, ["Neon"] = 103.69, ["Neon|Fly"] = 558.77, ["Neon|Ride"] = 144.41, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 832.81, ["Mega|Ride"] = 941.61, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5512.5, ["Ride"] = 6695.9, ["Fly|Ride"] = 5755.29, ["Neon"] = 34879.35, ["Neon|Fly|Ride"] = 22320.31}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 233.61, ["Fly"] = 272.9, ["Ride"] = 242.62, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 595.29, ["Mega|Fly|Ride"] = 1860.97}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 30.35, ["Fly"] = 138.12, ["Ride"] = 60.25, ["Fly|Ride"] = 134.7, ["Neon"] = 97.04, ["Neon|Fly"] = 192.76, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Fly"] = 558.71, ["Mega|Ride"] = 353.49, ["Mega|Fly|Ride"] = 430.73}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.84, ["Fly|Ride"] = 98.37, ["Neon"] = 30.35, ["Neon|Ride"] = 56.27, ["Mega"] = 174.74}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 35.37, ["Fly"] = 70.01, ["Ride"] = 100.23, ["Fly|Ride"] = 191.75, ["Neon"] = 131.25, ["Neon|Fly"] = 332.76, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 435.75, ["Mega|Ride"] = 536.41, ["Mega|Fly|Ride"] = 584.7}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 11263.12, ["Fly|Ride"] = 10692.94, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 108389.55}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 170.63, ["Ride"] = 217.88, ["Fly|Ride"] = 249.38, ["Neon"] = 1429.34, ["Neon|Ride"] = 1535.02, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4673.53}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 65.63, ["Fly"] = 101.78, ["Ride"] = 69.56, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 378, ["Mega|Fly|Ride"] = 2063.12}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.74, ["Fly"] = 45.22, ["Ride"] = 22.32, ["Fly|Ride"] = 56.52, ["Neon"] = 83.3, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2510.97, ["Mega|Fly|Ride"] = 635.36}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 371.9, ["Fly"] = 837, ["Ride"] = 420, ["Fly|Ride"] = 467.36, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4936.32}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.4, ["Ride"] = 32.15, ["Fly|Ride"] = 94.17, ["Neon"] = 29.3, ["Neon|Ride"] = 47.61, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 157.4, ["Mega|Ride"] = 127.33, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 209.08, ["Ride"] = 337.32, ["Fly|Ride"] = 656.24, ["Neon"] = 922.98, ["Neon|Ride"] = 939.65, ["Neon|Fly|Ride"] = 962.54, ["Mega|Fly|Ride"] = 3736.11}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.51, ["Fly"] = 20.97, ["Ride"] = 17.99, ["Fly|Ride"] = 32.48, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.6, ["Mega"] = 2510.97, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 59.57, ["Ride"] = 178.5, ["Fly|Ride"] = 317.65, ["Neon"] = 371.24, ["Neon|Fly"] = 1674.19, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1088.1, ["Mega|Ride"] = 1356.38, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.09, ["Fly"] = 78.46, ["Ride"] = 42.86, ["Fly|Ride"] = 84.67, ["Neon"] = 65.63, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 517.9, ["Mega|Ride"] = 551.38, ["Mega|Fly|Ride"] = 626.7}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 16.8}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.87, ["Fly"] = 111.57, ["Ride"] = 77.43, ["Fly|Ride"] = 105, ["Neon"] = 208.24, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 793.61, ["Mega|Ride"] = 919.66, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.15, ["Fly|Ride"] = 131.25, ["Neon"] = 30.56, ["Neon|Ride"] = 107.1, ["Neon|Fly|Ride"] = 136.02, ["Mega"] = 126.07, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.48, ["Fly"] = 70.11, ["Ride"] = 30.08, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 221.82, ["Mega|Ride"] = 530.45, ["Mega|Fly|Ride"] = 816.08}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 389.53, ["Ride"] = 380.38, ["Fly|Ride"] = 409.89, ["Neon|Fly|Ride"] = 2651.16, ["Mega|Fly|Ride"] = 8160.63}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 52.28, ["Fly"] = 104.64, ["Ride"] = 77.3, ["Fly|Ride"] = 103.67, ["Neon"] = 182.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 718.86, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 761.49}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 59.07, ["Fly"] = 92.19, ["Ride"] = 78.75, ["Neon"] = 236.5, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 365.28, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1249.22}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 31.31, ["Fly"] = 65.63, ["Ride"] = 72.19, ["Fly|Ride"] = 149.93, ["Neon"] = 104.98, ["Neon|Ride"] = 166.39, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 383.98, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11228.17, ["Fly"] = 9948.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7743.75, ["Neon|Fly|Ride"] = 12928.13, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2099.89, ["Ride"] = 1732.5, ["Fly|Ride"] = 1964.82, ["Neon|Ride"] = 5394.67, ["Neon|Fly|Ride"] = 4950.44, ["Mega"] = 22318.22, ["Mega|Fly|Ride"] = 20753.06}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 393.75, ["Ride"] = 468.85, ["Fly|Ride"] = 502.2, ["Neon"] = 2092.73, ["Neon|Fly|Ride"] = 2092.48, ["Mega"] = 16739.71, ["Mega|Fly|Ride"] = 6765.99}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.13, ["Fly"] = 23.62, ["Ride"] = 22.31, ["Fly|Ride"] = 36.14, ["Neon"] = 111.57, ["Neon|Ride"] = 111.98, ["Neon|Fly|Ride"] = 131.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.5, ["Fly"] = 78.74, ["Ride"] = 36.63, ["Neon"] = 26.24, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 162.87, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 270.84}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.43, ["Fly"] = 74.81, ["Ride"] = 51.33, ["Fly|Ride"] = 97.44, ["Neon"] = 272.07, ["Neon|Ride"] = 132.88, ["Neon|Fly|Ride"] = 128.62, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.9, ["Fly"] = 28.26, ["Ride"] = 17.81, ["Fly|Ride"] = 40.46, ["Neon"] = 25.11, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 472.5, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 262.49, ["Fly"] = 320.25, ["Ride"] = 308.43, ["Fly|Ride"] = 301.75, ["Neon"] = 1007.52, ["Neon|Ride"] = 1255.64, ["Neon|Fly|Ride"] = 1198.02, ["Mega|Fly|Ride"] = 6277.41}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.24, ["Fly"] = 59.33, ["Ride"] = 35.58, ["Fly|Ride"] = 71.4, ["Neon"] = 142.32, ["Neon|Fly"] = 167.43, ["Neon|Ride"] = 142.79, ["Neon|Fly|Ride"] = 140.21, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 614.16}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.43, ["Fly"] = 21.86, ["Ride"] = 18.37, ["Fly|Ride"] = 39.38, ["Neon"] = 35.58, ["Neon|Fly"] = 135.66, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.43, ["Fly"] = 787.5, ["Ride"] = 391.31, ["Fly|Ride"] = 530.45, ["Neon|Ride"] = 2720.54, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.65, ["Fly"] = 1427.54, ["Ride"] = 1283.83, ["Fly|Ride"] = 1312.5, ["Neon|Ride"] = 3490.95, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 20785.49}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 83.08, ["Fly"] = 105, ["Ride"] = 90.57, ["Fly|Ride"] = 120.33, ["Neon"] = 971.25, ["Neon|Ride"] = 1742.13, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 2614.55}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 147.49, ["Fly"] = 212.1, ["Ride"] = 157.5, ["Fly|Ride"] = 224.44, ["Neon"] = 556.5, ["Neon|Fly"] = 669.68, ["Neon|Ride"] = 739.79, ["Neon|Fly|Ride"] = 573.57, ["Mega"] = 5580.62, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.29, ["Ride"] = 47.45, ["Neon"] = 197.68, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 376.65, ["Mega"] = 787.5, ["Mega|Ride"] = 2092.48, ["Mega|Fly|Ride"] = 899.78}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 209.26, ["Ride"] = 279.37, ["Fly|Ride"] = 279.39, ["Neon|Fly|Ride"] = 1332.58, ["Mega|Fly|Ride"] = 3005.43}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.75, ["Ride"] = 2260.35, ["Fly|Ride"] = 2651.16, ["Neon|Fly|Ride"] = 7112.3, ["Mega|Fly|Ride"] = 48126.65}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 43.31, ["Ride"] = 52.41, ["Fly|Ride"] = 196.87, ["Neon"] = 311.83, ["Neon|Fly"] = 363.11, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 2086.2, ["Mega|Ride"] = 2301.72, ["Mega|Fly|Ride"] = 1673.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 611.28, ["Fly"] = 808.5, ["Ride"] = 631.31, ["Fly|Ride"] = 616.76, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3102.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 49.08, ["Fly"] = 64.32, ["Ride"] = 57.75, ["Fly|Ride"] = 94.02, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 990.8}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.8, ["Fly"] = 40.69, ["Ride"] = 21, ["Fly|Ride"] = 44.16, ["Neon"] = 28.26, ["Neon|Fly"] = 96.28, ["Neon|Ride"] = 38.19, ["Neon|Fly|Ride"] = 85.13, ["Mega"] = 161.28, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 243.72}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.55, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 156.97, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 558.71, ["Mega|Ride"] = 1395.69, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 630, ["Fly"] = 1412.08, ["Ride"] = 624.64, ["Fly|Ride"] = 720.35, ["Neon|Ride"] = 2159.7, ["Neon|Fly|Ride"] = 1607.78, ["Mega|Fly|Ride"] = 5858.91}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 525, ["Ride"] = 551.25, ["Fly|Ride"] = 847.17, ["Neon"] = 5231.81, ["Neon|Fly|Ride"] = 2790.32, ["Mega|Fly|Ride"] = 13950.46}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.45, ["Fly"] = 23.81, ["Ride"] = 17.07, ["Fly|Ride"] = 52.32, ["Neon"] = 209.28, ["Neon|Ride"] = 104.65, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.15, ["Ride"] = 23.61, ["Fly|Ride"] = 45.94, ["Neon"] = 98.35, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 1673.99, ["Mega|Ride"] = 388.58, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.94, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 111.44, ["Neon"] = 30.27, ["Neon|Fly"] = 317.7, ["Neon|Ride"] = 52.82, ["Neon|Fly|Ride"] = 131.64, ["Mega"] = 237.98, ["Mega|Fly"] = 460.46, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.88, ["Fly"] = 78.75, ["Ride"] = 47.25, ["Fly|Ride"] = 95.82, ["Neon"] = 223.94, ["Neon|Ride"] = 174.76, ["Neon|Fly|Ride"] = 213.94, ["Mega|Fly|Ride"] = 865.25}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 50.23, ["Ride"] = 111.57, ["Fly|Ride"] = 449.61, ["Neon"] = 348.91, ["Neon|Ride"] = 457.28, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1567.28, ["Mega|Ride"] = 1569.37, ["Mega|Fly|Ride"] = 1269.53}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.64, ["Fly"] = 59.07, ["Ride"] = 32.82, ["Fly|Ride"] = 84, ["Neon"] = 85.72, ["Neon|Fly"] = 159.45, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 451.99}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.06, ["Fly"] = 65.06, ["Ride"] = 38.06, ["Fly|Ride"] = 93.45, ["Neon"] = 558.77, ["Neon|Ride"] = 237.99, ["Neon|Fly|Ride"] = 228.69, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1274.32}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.83, ["Fly"] = 28.25, ["Ride"] = 19.57, ["Fly|Ride"] = 65.62, ["Neon"] = 32.59, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 525, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 300.27}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.88, ["Fly"] = 30.54, ["Ride"] = 28.25, ["Fly|Ride"] = 317.65, ["Neon"] = 27.2, ["Neon|Fly"] = 159.45, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 167.42, ["Mega"] = 262.62, ["Mega|Fly"] = 475, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 48.55, ["Fly"] = 60.38, ["Ride"] = 54.03, ["Fly|Ride"] = 79.72, ["Neon"] = 412.88, ["Neon|Ride"] = 278.35, ["Neon|Fly|Ride"] = 272.98, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1863.74, ["Fly"] = 2362.5, ["Ride"] = 1837.5, ["Fly|Ride"] = 1837.5, ["Neon|Ride"] = 5753.94, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 20623.89}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 492.14, ["Fly"] = 558.71, ["Ride"] = 433.13, ["Fly|Ride"] = 525, ["Neon"] = 3173.27, ["Neon|Ride"] = 3070.03, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9733.1}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 237.79, ["Fly"] = 321.2, ["Ride"] = 301.87, ["Fly|Ride"] = 404.91, ["Neon"] = 1202.53, ["Neon|Ride"] = 1391.25, ["Neon|Fly|Ride"] = 1395.69, ["Mega|Fly|Ride"] = 6277.41}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 51.98}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.69, ["Ride"] = 41.85, ["Fly|Ride"] = 78.74, ["Neon"] = 328.75, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 305.62, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 822.35, ["Mega|Ride"] = 939.53, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34875.08, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 15750, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 420, ["Fly"] = 496.39, ["Ride"] = 501.67, ["Fly|Ride"] = 519.73, ["Neon"] = 1517.04, ["Neon|Ride"] = 1508.07, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 6277.41, ["Mega|Fly|Ride"] = 4438.6}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 260.54, ["Ride"] = 136.49, ["Fly|Ride"] = 155.38, ["Neon|Fly|Ride"] = 558.71, ["Mega|Fly|Ride"] = 4184.94}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Fly"] = 279.37, ["Ride"] = 123.38, ["Fly|Ride"] = 207.24, ["Neon"] = 711.53, ["Neon|Ride"] = 837.1, ["Neon|Fly|Ride"] = 558.71, ["Mega"] = 13950.46, ["Mega|Fly|Ride"] = 5231.17}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 70.11, ["Ride"] = 33.48, ["Fly|Ride"] = 86.35, ["Neon"] = 274.3, ["Neon|Ride"] = 139.64, ["Neon|Fly|Ride"] = 204.37, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 635.36}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4656.61, ["Ride"] = 4743.62, ["Fly|Ride"] = 3937.49, ["Neon"] = 17323.69, ["Neon|Fly|Ride"] = 17576.69}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.24, ["Fly"] = 66.97, ["Ride"] = 31.25, ["Fly|Ride"] = 54.02, ["Neon"] = 333.94, ["Neon|Ride"] = 207.19, ["Neon|Fly|Ride"] = 180.23, ["Mega"] = 1046.25, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.7, ["Fly"] = 115.08, ["Ride"] = 60.25, ["Fly|Ride"] = 97.13, ["Neon|Fly"] = 1395.85, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 1587.2, ["Mega|Fly|Ride"] = 1169.69}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 575.7, ["Fly"] = 907.1, ["Ride"] = 602.44, ["Fly|Ride"] = 713.94, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1522.5, ["Mega|Ride"] = 5615.84, ["Mega|Fly|Ride"] = 4852.32}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.95, ["Fly"] = 26.25, ["Ride"] = 23.51, ["Fly|Ride"] = 48.56, ["Neon"] = 106.31, ["Neon|Fly"] = 159.45, ["Neon|Ride"] = 98.37, ["Neon|Fly|Ride"] = 103.69, ["Mega|Ride"] = 603.24, ["Mega|Fly|Ride"] = 514.89}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.85, ["Fly"] = 74.29, ["Ride"] = 32.15, ["Fly|Ride"] = 493.9, ["Neon"] = 80.07, ["Neon|Ride"] = 193.46, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 558.71}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.75, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 527.71, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 707.26, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.85, ["Fly"] = 104.64, ["Ride"] = 104.64, ["Fly|Ride"] = 183.33, ["Neon"] = 102.38, ["Neon|Fly"] = 209.28, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 220.89, ["Mega"] = 308.66, ["Mega|Ride"] = 558.71, ["Mega|Fly|Ride"] = 690.53}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3543.75, ["Fly"] = 5125.5, ["Ride"] = 3543.75, ["Fly|Ride"] = 3543.75, ["Neon|Ride"] = 11685.76, ["Neon|Fly|Ride"] = 8531.25, ["Mega"] = 43756.54, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 42.29, ["Fly"] = 105, ["Ride"] = 59.07, ["Fly|Ride"] = 133.23, ["Neon"] = 488.66, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 418.5, ["Mega|Ride"] = 941.61, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7637.51, ["Fly|Ride"] = 6227.55, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 64866.34}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.51, ["Fly"] = 23.62, ["Ride"] = 18.37, ["Fly|Ride"] = 27.57, ["Neon"] = 36.62, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 459.38, ["Mega|Fly|Ride"] = 261.17}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 22.58, ["Fly"] = 26.16, ["Ride"] = 30.95, ["Fly|Ride"] = 49.88, ["Neon"] = 195.68, ["Neon|Ride"] = 166.39, ["Neon|Fly|Ride"] = 182.06, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 951.85}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.63}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.7, ["Ride"] = 41.55, ["Fly|Ride"] = 122.84, ["Neon|Ride"] = 153.56, ["Mega"] = 835.95, ["Mega|Ride"] = 975.1, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.31, ["Fly"] = 262.5, ["Ride"] = 34.71, ["Fly|Ride"] = 196.88, ["Neon"] = 182.43, ["Neon|Ride"] = 145.5, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 840, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 16.76, ["Fly"] = 25.09, ["Ride"] = 19.68, ["Fly|Ride"] = 43.72, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 167.42, ["Mega"] = 2510.97, ["Mega|Ride"] = 593.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8334.3}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.57}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 18.88}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 158.97, ["Fly"] = 349.46, ["Ride"] = 174.56, ["Fly|Ride"] = 223.13, ["Neon|Fly|Ride"] = 1111.28, ["Mega|Fly|Ride"] = 5552.78}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.57, ["Fly"] = 111.96, ["Ride"] = 61.73, ["Fly|Ride"] = 196.88, ["Neon"] = 123.48, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 276.23, ["Mega|Ride"] = 904.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.17}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.5, ["Neon"] = 50.24, ["Neon|Ride"] = 98.37, ["Neon|Fly|Ride"] = 125.56, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 165.38, ["Fly"] = 209.26, ["Ride"] = 202.13, ["Fly|Ride"] = 416.47, ["Neon"] = 701.37, ["Neon|Ride"] = 600.62, ["Neon|Fly|Ride"] = 627.76, ["Mega|Ride"] = 3474.56, ["Mega|Fly|Ride"] = 3474.56}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 342.48, ["Ride"] = 393.75, ["Fly|Ride"] = 525, ["Neon"] = 675.68, ["Neon|Ride"] = 558.77, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2493.75, ["Mega|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 3278.9}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 131.25, ["Fly"] = 246.93, ["Ride"] = 170.47, ["Fly|Ride"] = 262.5, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 735, ["Mega"] = 4603.44, ["Mega|Fly|Ride"] = 3489.2}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1508.07, ["Fly"] = 2510.97, ["Ride"] = 1312.49, ["Fly|Ride"] = 1404.38, ["Neon"] = 5077, ["Neon|Ride"] = 4599.81, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 27899.87}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 12.72, ["Fly"] = 81.6, ["Ride"] = 39.38, ["Fly|Ride"] = 91.4, ["Neon"] = 127.31, ["Neon|Ride"] = 167.43, ["Neon|Fly|Ride"] = 317.69, ["Mega"] = 835.95, ["Mega|Ride"] = 621.48, ["Mega|Fly|Ride"] = 656.01}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 640.5, ["Ride"] = 697.85, ["Fly|Ride"] = 793.63}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 65.54}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.03, ["Ride"] = 37.8, ["Fly|Ride"] = 681.8, ["Neon"] = 92.66, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 207.17, ["Mega"] = 315, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.75, ["Fly"] = 257.28, ["Ride"] = 28.88, ["Fly|Ride"] = 94.79, ["Neon"] = 40.31, ["Neon|Ride"] = 87.91, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 487.56, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 91.04}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.31, ["Ride"] = 31.27, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 209.28, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 656.25, ["Mega|Ride"] = 793.61, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 31.4, ["Fly"] = 75.34, ["Ride"] = 36.75, ["Fly|Ride"] = 47.58, ["Neon"] = 157.5, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 251.11, ["Mega"] = 960.18, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6237, ["Fly"] = 6305.64, ["Ride"] = 6975.24, ["Fly|Ride"] = 4987.5, ["Neon|Ride"] = 17439.68, ["Neon|Fly|Ride"] = 9996.09, ["Mega|Fly|Ride"] = 34107.82}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 5.25, ["Fly"] = 79.52, ["Ride"] = 32.96, ["Fly|Ride"] = 95.2, ["Neon"] = 47.23, ["Neon|Ride"] = 104.35, ["Mega"] = 533.05, ["Mega|Ride"] = 544.06, ["Mega|Fly|Ride"] = 418.66}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.17}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 93.09, ["Fly"] = 370.38, ["Ride"] = 118.13, ["Fly|Ride"] = 212.08, ["Neon"] = 418.69, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 598.5, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 70.59, ["Fly"] = 96.48, ["Ride"] = 98.44, ["Fly|Ride"] = 159.43, ["Neon"] = 327.6, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 478.85, ["Mega"] = 2379.61, ["Mega|Ride"] = 2824.83}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.25, ["Fly"] = 65.63, ["Ride"] = 26.23, ["Fly|Ride"] = 76.13, ["Neon"] = 196.88, ["Neon|Ride"] = 159.45, ["Neon|Fly|Ride"] = 157.47, ["Mega|Ride"] = 684.25, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.2, ["Fly"] = 79.52, ["Ride"] = 23.67, ["Fly|Ride"] = 83.55, ["Neon"] = 26.4, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 67.83, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 143.07, ["Mega|Fly"] = 6975.24, ["Mega|Ride"] = 179.1, ["Mega|Fly|Ride"] = 271.97}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.4, ["Ride"] = 31.36, ["Fly|Ride"] = 71.3, ["Neon"] = 94.18, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 182.06, ["Mega"] = 461.41, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23, ["Fly"] = 32.8, ["Ride"] = 26.22, ["Fly|Ride"] = 46.52, ["Neon"] = 140.22, ["Neon|Ride"] = 265.79, ["Neon|Fly|Ride"] = 150.02, ["Mega|Fly|Ride"] = 809.8}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 211.21}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 10.48, ["Ride"] = 97.13, ["Neon"] = 83.72, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 302.23, ["Mega"] = 511.88, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 945.81}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 155.93, ["Ride"] = 140.21, ["Fly|Ride"] = 262.5, ["Neon"] = 558.77, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 558.71}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.68, ["Fly"] = 212.01, ["Ride"] = 96.27, ["Fly|Ride"] = 216.57, ["Neon"] = 179.71, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1115.63, ["Mega|Ride"] = 1099.61, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 858.27, ["Fly"] = 1020.58, ["Ride"] = 866.25, ["Fly|Ride"] = 794.33, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 10368.74}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 201.71, ["Fly"] = 421.14, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1903.73, ["Neon|Fly|Ride"] = 1456.88, ["Mega"] = 8206.59, ["Mega|Fly|Ride"] = 5021.93}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 99.39}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.82}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.74, ["Fly"] = 28.48, ["Ride"] = 22.32, ["Fly|Ride"] = 46.52, ["Neon"] = 78.73, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 104.65, ["Neon|Fly|Ride"] = 154.86, ["Mega"] = 437.26, ["Mega|Ride"] = 544.06, ["Mega|Fly|Ride"] = 524.72}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 267.74, ["Fly"] = 1033.69, ["Ride"] = 301.87, ["Fly|Ride"] = 392.34, ["Neon"] = 1086.75, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 1070.31, ["Mega|Fly|Ride"] = 3569.4}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 28.48}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 131.23, ["Fly"] = 290.28, ["Ride"] = 188.99, ["Fly|Ride"] = 262.49, ["Neon"] = 563.54, ["Neon|Fly"] = 1674.19, ["Neon|Ride"] = 693.75, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 3069.66, ["Mega|Ride"] = 3347.96, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 138.7, ["Fly"] = 195.66, ["Ride"] = 137.71, ["Fly|Ride"] = 196.88, ["Neon"] = 1116.48, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 1045.2}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.26, ["Ride"] = 24.94, ["Fly|Ride"] = 209.28, ["Neon"] = 37.96, ["Neon|Ride"] = 85.29, ["Neon|Fly|Ride"] = 225.36, ["Mega"] = 216.57, ["Mega|Ride"] = 236.46, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.31, ["Fly"] = 63, ["Ride"] = 32.43, ["Fly|Ride"] = 76.12, ["Neon"] = 103.07, ["Neon|Ride"] = 167.43, ["Neon|Fly|Ride"] = 140.21, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.4, ["Fly"] = 102.32, ["Ride"] = 34.73, ["Fly|Ride"] = 128.82, ["Neon"] = 140.2, ["Neon|Ride"] = 154.86, ["Neon|Fly|Ride"] = 237.51, ["Mega"] = 498.65, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 697.85}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.16, ["Fly"] = 116.15, ["Ride"] = 47.45, ["Fly|Ride"] = 118.12, ["Neon"] = 27.86, ["Neon|Ride"] = 61.66, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.38, ["Mega|Ride"] = 178.39, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.4, ["Fly"] = 918.75, ["Ride"] = 301.88, ["Fly|Ride"] = 359.31, ["Neon"] = 1395.85, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1371.57}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 124.58, ["Fly"] = 1050, ["Ride"] = 137.82, ["Fly|Ride"] = 301.88, ["Neon"] = 475.7, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 1968.75, ["Mega|Ride"] = 2468.84, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 64.23, ["Fly"] = 167.45, ["Ride"] = 91.88, ["Fly|Ride"] = 128.63, ["Neon"] = 380.89, ["Neon|Ride"] = 418.56, ["Neon|Fly|Ride"] = 488.54, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 24.06, ["Ride"] = 57.75, ["Fly|Ride"] = 251.11, ["Neon|Ride"] = 604.45, ["Neon|Fly|Ride"] = 485.47, ["Mega|Ride"] = 615.57, ["Mega|Fly|Ride"] = 1665.61}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.42, ["Fly"] = 32.12, ["Ride"] = 60.38, ["Fly|Ride"] = 120.35, ["Neon"] = 91.88, ["Neon|Ride"] = 90.86, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 396.02, ["Mega|Fly"] = 525, ["Mega|Ride"] = 418.5, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.93, ["Fly"] = 46.05, ["Ride"] = 20.85, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 126.39, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 220.49}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 807.18, ["Fly"] = 1060.53, ["Ride"] = 950.45, ["Fly|Ride"] = 1017.18, ["Neon"] = 3331.52, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 10946.12}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 393.74, ["Ride"] = 418.5, ["Fly|Ride"] = 447.86, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2772.53, ["Mega"] = 10462.32, ["Mega|Fly|Ride"] = 7932.37}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 61.74, ["Fly"] = 131.25, ["Ride"] = 98.36, ["Fly|Ride"] = 157.5, ["Neon"] = 313.92, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 357, ["Mega|Ride"] = 1442.77, ["Mega|Fly|Ride"] = 1464.74}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 346.32, ["Ride"] = 275.62, ["Fly|Ride"] = 315, ["Neon"] = 1261.23, ["Neon|Ride"] = 1427.81, ["Neon|Fly|Ride"] = 1186.44, ["Mega"] = 10462.32, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21, ["Fly"] = 140.21, ["Ride"] = 24.44, ["Fly|Ride"] = 78.75, ["Neon"] = 157.5, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 159.45, ["Mega|Ride"] = 664.37, ["Mega|Fly|Ride"] = 644.4}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 267.11, ["Fly|Ride"] = 523.2, ["Neon"] = 1419.05, ["Neon|Ride"] = 1745.48, ["Neon|Fly|Ride"] = 1349.24, ["Mega"] = 4164.3, ["Mega|Fly|Ride"] = 4129.49}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 79.72, ["Ride"] = 66.94, ["Fly|Ride"] = 81.29, ["Neon"] = 279.39, ["Neon|Ride"] = 500.18}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1529.07, ["Ride"] = 1478.43, ["Fly|Ride"] = 1497.51, ["Neon|Fly|Ride"] = 5580.62, ["Mega"] = 50219.11, ["Mega|Fly|Ride"] = 23714.94}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.6, ["Fly"] = 60.38, ["Ride"] = 43.31, ["Fly|Ride"] = 89.03, ["Neon"] = 61.68, ["Neon|Fly"] = 104.81, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 262.47, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 417.81}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 48.51, ["Fly"] = 78.75, ["Ride"] = 59.07, ["Fly|Ride"] = 159.48, ["Neon"] = 265.79, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 321.2, ["Mega|Ride"] = 1026.37, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 76.13, ["Fly"] = 91.88, ["Ride"] = 68.04, ["Fly|Ride"] = 75.63, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1338.75}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3766.44, ["Ride"] = 1437.54, ["Fly|Ride"] = 1128.74, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 498.75, ["Fly"] = 834.91, ["Ride"] = 522.09, ["Fly|Ride"] = 627.76, ["Neon"] = 1427.81, ["Neon|Fly|Ride"] = 2776.99, ["Mega|Fly|Ride"] = 14277.54}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 90.57, ["Fly"] = 317.64, ["Ride"] = 131.24, ["Fly|Ride"] = 218.29, ["Neon"] = 446.8, ["Neon|Fly"] = 558.77, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 4183.89, ["Mega|Ride"] = 2651.16, ["Mega|Fly|Ride"] = 2222.55}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.56, ["Fly"] = 39.38, ["Ride"] = 27.55, ["Fly|Ride"] = 91.58, ["Neon"] = 84.45, ["Neon|Ride"] = 92.09, ["Neon|Fly|Ride"] = 179.96, ["Mega"] = 656.25, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 523.14}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.02, ["Fly"] = 95.19, ["Ride"] = 48.57, ["Fly|Ride"] = 104.66, ["Neon"] = 204.75, ["Neon|Fly"] = 417.52, ["Neon|Ride"] = 234.94, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 1814.18, ["Mega|Ride"] = 1079.15, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 763.88, ["Ride"] = 702.19, ["Fly|Ride"] = 840, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 31728.23}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5078.41, ["Fly|Ride"] = 4121.24, ["Neon"] = 42000, ["Neon|Ride"] = 29989.71, ["Neon|Fly|Ride"] = 21898.68, ["Mega|Fly|Ride"] = 89279.11}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 180.08, ["Fly"] = 279.37, ["Ride"] = 272.04, ["Neon"] = 1308.82, ["Neon|Fly|Ride"] = 1395.69, ["Mega"] = 5857.86, ["Mega|Fly|Ride"] = 5999.1}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.19, ["Fly"] = 279.37, ["Ride"] = 78.74, ["Fly|Ride"] = 336, ["Neon"] = 338.75, ["Neon|Ride"] = 488, ["Neon|Fly|Ride"] = 977.19, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.64, ["Fly"] = 98.36, ["Ride"] = 37.68, ["Fly|Ride"] = 104.99, ["Neon"] = 112.88, ["Neon|Ride"] = 85.03, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 697.85, ["Mega|Ride"] = 627.76, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.77, ["Fly"] = 38.07, ["Ride"] = 32.05, ["Fly|Ride"] = 52.4, ["Neon|Ride"] = 279.39, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.74, ["Fly"] = 279.37, ["Ride"] = 42, ["Fly|Ride"] = 111.85, ["Neon"] = 137.82, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 231, ["Mega"] = 549.94, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.57, ["Fly"] = 56.51, ["Ride"] = 22.3, ["Fly|Ride"] = 57.66, ["Neon"] = 32.81, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 178.5, ["Mega|Ride"] = 167.42, ["Mega|Fly|Ride"] = 308.66}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.66, ["Ride"] = 67.82, ["Fly|Ride"] = 183.75, ["Neon"] = 165.34, ["Neon|Fly"] = 837.1, ["Neon|Ride"] = 198.82, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 690.53, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 308.52, ["Fly"] = 337.32, ["Ride"] = 306.42, ["Fly|Ride"] = 376.69, ["Neon"] = 1427.81, ["Neon|Ride"] = 977.31, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6562.5, ["Mega|Ride"] = 3627.3, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.52, ["Fly"] = 22.98, ["Ride"] = 16.73, ["Fly|Ride"] = 32.81, ["Neon"] = 22.32, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 64.31, ["Mega"] = 290.88, ["Mega|Ride"] = 221.93, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.05, ["Fly"] = 104.63, ["Ride"] = 62.99, ["Fly|Ride"] = 99.16, ["Neon"] = 162.06, ["Neon|Fly"] = 279.39, ["Neon|Ride"] = 181.79, ["Neon|Fly|Ride"] = 243.1, ["Mega"] = 498.65, ["Mega|Fly"] = 837, ["Mega|Ride"] = 506.7, ["Mega|Fly|Ride"] = 581.43}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 748.86, ["Ride"] = 721.88, ["Fly|Ride"] = 714.55, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1483.02, ["Mega|Fly|Ride"] = 3499.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 37.67, ["Fly"] = 91.88, ["Ride"] = 45.47, ["Fly|Ride"] = 78.74, ["Neon"] = 190.38, ["Neon|Fly"] = 475.95, ["Neon|Ride"] = 214.18, ["Neon|Fly|Ride"] = 285.89, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 755.99}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 342.13, ["Ride"] = 262.5, ["Fly|Ride"] = 348.9, ["Neon|Ride"] = 977.31, ["Neon|Fly|Ride"] = 1019.82, ["Mega"] = 6028.7, ["Mega|Fly|Ride"] = 6974.19}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.25, ["Fly"] = 139.02, ["Ride"] = 131.24, ["Fly|Ride"] = 157.5, ["Neon|Ride"] = 684.33, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 551.25, ["Ride"] = 558.71, ["Fly|Ride"] = 525, ["Neon|Ride"] = 2300.96, ["Neon|Fly|Ride"] = 2379.61, ["Mega|Fly|Ride"] = 7951.37}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.13, ["Ride"] = 41.86, ["Fly|Ride"] = 96.28, ["Neon"] = 78.75, ["Neon|Fly"] = 285.57, ["Neon|Ride"] = 103.6, ["Neon|Fly|Ride"] = 276.04, ["Mega"] = 262.48, ["Mega|Ride"] = 370.38, ["Mega|Fly|Ride"] = 383.13}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3715.19, ["Fly"] = 4037.54, ["Ride"] = 3715.19, ["Fly|Ride"] = 2872.96, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 104.53, ["Fly"] = 125.56, ["Ride"] = 111.57, ["Fly|Ride"] = 149.63, ["Neon"] = 475.95, ["Neon|Ride"] = 488.66, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1745.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.8, ["Fly"] = 26.1, ["Ride"] = 17.07, ["Fly|Ride"] = 40.69, ["Neon"] = 23.62, ["Neon|Fly"] = 82.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 152.18, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 237.78}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 27.98, ["Neon"] = 30.35, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.44, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 279.37, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 79.74, ["Fly"] = 93.56, ["Ride"] = 82.69, ["Fly|Ride"] = 78.75, ["Neon"] = 278.43, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 279.37, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1100.65, ["Ride"] = 1174.69, ["Fly|Ride"] = 1050, ["Neon"] = 5720.46, ["Neon|Fly|Ride"] = 6263.81}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5250, ["Ride"] = 6802.61, ["Fly|Ride"] = 6276.35}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.35, ["Fly"] = 35.58, ["Ride"] = 24.05, ["Fly|Ride"] = 52.78, ["Neon|Ride"] = 271.45, ["Neon|Fly|Ride"] = 154.86, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 18.8, ["Fly"] = 45.94, ["Ride"] = 35.44, ["Fly|Ride"] = 74.04, ["Neon"] = 88.83, ["Neon|Ride"] = 89.45, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 642.48, ["Mega|Ride"] = 530.45, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 58.44, ["Fly"] = 157.5, ["Ride"] = 59.06, ["Fly|Ride"] = 106.01, ["Neon"] = 328.12, ["Neon|Ride"] = 349.5, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 1673.99, ["Mega|Ride"] = 1814.18, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 218.66, ["Fly"] = 317.64, ["Ride"] = 183.75, ["Fly|Ride"] = 249.37, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 906.56, ["Mega"] = 10462.32, ["Mega|Fly|Ride"] = 3606.38}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.98, ["Ride"] = 36.47, ["Fly|Ride"] = 86.63, ["Neon"] = 31.4, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 92.42, ["Mega"] = 154.88, ["Mega|Ride"] = 163.7, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 188.28, ["Fly"] = 265.13, ["Ride"] = 216.57, ["Fly|Ride"] = 326.45, ["Neon"] = 936.51, ["Neon|Ride"] = 962.67, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3702.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.56, ["Fly"] = 20.64, ["Ride"] = 16.69, ["Fly|Ride"] = 44.63, ["Neon"] = 22.68, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 57.88, ["Neon|Fly|Ride"] = 108.83, ["Mega"] = 278.42, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 239.48}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 261.58, ["Neon"] = 793.63, ["Neon|Ride"] = 816.17, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 10461.28, ["Mega|Ride"] = 4184.94, ["Mega|Fly|Ride"] = 4171.34}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.83, ["Fly"] = 75.89, ["Ride"] = 27.08, ["Fly|Ride"] = 56.27, ["Neon"] = 91.04, ["Neon|Fly"] = 302.24, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 274.86, ["Mega"] = 527.09, ["Mega|Ride"] = 585.9, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.57, ["Ride"] = 22.55, ["Fly|Ride"] = 86.63, ["Neon"] = 11.6, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 61.16, ["Neon|Fly|Ride"] = 162.16, ["Mega"] = 91.67, ["Mega|Ride"] = 99.1, ["Mega|Fly|Ride"] = 207.03}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.62, ["Neon"] = 2.89, ["Mega"] = 22.23, ["Mega|Ride"] = 140.41}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.71, ["Ride"] = 28.88, ["Fly|Ride"] = 140.21, ["Neon"] = 7.13, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 78.74, ["Mega|Fly"] = 158639.91, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.2, ["Fly"] = 136.82, ["Ride"] = 115.28, ["Fly|Ride"] = 85.32, ["Neon"] = 301.79, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 359.33, ["Mega"] = 1088.1, ["Mega|Fly|Ride"] = 1273.9}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.71, ["Ride"] = 15.88, ["Neon"] = 12.53, ["Neon|Ride"] = 22, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 110.9, ["Mega|Ride"] = 104.64, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 85.28, ["Ride"] = 111.64, ["Fly|Ride"] = 188.01, ["Neon"] = 63, ["Neon|Ride"] = 97.13, ["Mega"] = 459.38, ["Mega|Ride"] = 621.48, ["Mega|Fly|Ride"] = 621.11}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 119, ["Neon"] = 2.1, ["Neon|Ride"] = 39.48, ["Neon|Fly|Ride"] = 254.16, ["Mega"] = 26.75, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 191.73}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.11, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 35.72, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 38.92, ["Mega"] = 15.69, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 23.04, ["Mega|Fly|Ride"] = 60.84}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 14.99, ["Fly|Ride"] = 35.59, ["Neon"] = 2.1, ["Neon|Fly"] = 27.69, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 56.76, ["Mega"] = 17.87, ["Mega|Fly"] = 94.99, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 94.39}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 125.57, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 78.64, ["Mega"] = 16.42, ["Mega|Ride"] = 148.31, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 16.56, ["Fly|Ride"] = 107.62, ["Neon"] = 3.67, ["Neon|Fly"] = 137.84, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 28.56, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 73.57, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.96, ["Neon|Fly|Ride"] = 189.35, ["Mega"] = 34.91, ["Mega|Ride"] = 93.71, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 54.48, ["Ride"] = 17.07, ["Fly|Ride"] = 48.4, ["Neon"] = 8.74, ["Neon|Fly"] = 53.62, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 72.24, ["Mega"] = 56.44, ["Mega|Fly"] = 160.44, ["Mega|Ride"] = 79.38, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 44.65, ["Neon"] = 2.1, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 18.38, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 55.94, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 21.35, ["Mega"] = 279.37, ["Mega|Fly"] = 315, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 8.39, ["Ride"] = 27.57, ["Neon"] = 9.83, ["Neon|Ride"] = 31.4, ["Mega"] = 98.36, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 5.24, ["Neon|Ride"] = 26.7, ["Neon|Fly|Ride"] = 111.96, ["Mega"] = 35.72, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 30.08, ["Neon"] = 2.1, ["Neon|Fly"] = 27.23, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 38.1, ["Mega"] = 14.15, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 30.84, ["Mega|Fly|Ride"] = 81.44}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 4.19, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 35.44, ["Neon|Ride"] = 140.95, ["Mega"] = 265.76}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 17.94, ["Fly|Ride"] = 78.75, ["Neon"] = 4.11, ["Neon|Ride"] = 44.12, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 26.17, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 139.64, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.1, ["Neon"] = 9.54, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 91.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.24, ["Ride"] = 32.81, ["Fly|Ride"] = 190.43, ["Neon"] = 27.39, ["Neon|Ride"] = 79.73, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 222.49, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 111.96}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.35, ["Ride"] = 12.77, ["Fly|Ride"] = 24.45, ["Neon"] = 2.1, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 30.54, ["Mega"] = 17.64, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 21.29, ["Mega|Fly|Ride"] = 87.75}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 24.45, ["Ride"] = 19.65, ["Fly|Ride"] = 86.63, ["Neon"] = 15.37, ["Neon|Ride"] = 114.23, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 17.14, ["Fly|Ride"] = 58.46, ["Neon"] = 66.54, ["Neon|Ride"] = 121.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.37, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 390.47}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 14.8, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 19.22, ["Neon|Ride"] = 15.68, ["Neon|Fly|Ride"] = 46.33, ["Mega"] = 14.34, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 28.3, ["Mega|Fly|Ride"] = 97.12}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.74, ["Ride"] = 60.37, ["Fly|Ride"] = 63, ["Neon"] = 7.25, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.37, ["Mega|Fly"] = 167.42, ["Mega|Ride"] = 98.36}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.38, ["Ride"] = 26.72, ["Fly|Ride"] = 58.61, ["Neon"] = 3.93, ["Neon|Fly"] = 108.94, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 32.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.96, ["Neon"] = 2.1, ["Neon|Fly"] = 41.5, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 83.71, ["Mega"] = 18.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 148.58}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.36, ["Ride"] = 17.06, ["Fly|Ride"] = 42.02, ["Neon"] = 6.97, ["Neon|Fly"] = 46.05, ["Neon|Ride"] = 26.19, ["Neon|Fly|Ride"] = 67.11, ["Mega"] = 79.73, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 270.99}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 3.45, ["Neon|Ride"] = 42.42, ["Neon|Fly|Ride"] = 95.2, ["Mega"] = 40.69, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 351.01}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 16.17, ["Fly|Ride"] = 43.32, ["Neon"] = 6.48, ["Neon|Fly"] = 70.11, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 89.21, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.39, ["Ride"] = 30.95, ["Neon"] = 36.16, ["Mega|Fly|Ride"] = 836.07}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 27.21, ["Ride"] = 15.22, ["Fly|Ride"] = 70.11, ["Neon"] = 12.94, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 32.15, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 157.5, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 321.2}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.92, ["Fly"] = 35.52, ["Ride"] = 35.65, ["Fly|Ride"] = 52.5, ["Neon"] = 14.2, ["Neon|Fly"] = 61.74, ["Neon|Ride"] = 43.96, ["Neon|Fly|Ride"] = 111.96, ["Mega"] = 105, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 216.36}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 99.26, ["Ride"] = 17.85, ["Fly|Ride"] = 106.84, ["Neon"] = 19.69, ["Mega"] = 167.42, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.17, ["Ride"] = 27.21, ["Neon|Ride"] = 237.99, ["Mega|Ride"] = 938.49, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.41, ["Ride"] = 56.51, ["Neon"] = 41.85, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 47.61, ["Mega"] = 226.01, ["Mega|Ride"] = 367.49, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.19, ["Ride"] = 43.96, ["Fly|Ride"] = 139.13, ["Neon"] = 69.07, ["Neon|Ride"] = 104.64, ["Mega"] = 475.94, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 496.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 64.99, ["Mega"] = 19.69, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 65.62}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.74, ["Fly"] = 20.83, ["Ride"] = 21.1, ["Fly|Ride"] = 42, ["Neon"] = 52.41, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 282.18, ["Mega|Fly"] = 334.82, ["Mega|Ride"] = 276.24, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 65.63, ["Neon"] = 9.54, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 27.57, ["Mega|Ride"] = 111.96, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 36.71, ["Fly|Ride"] = 397.42, ["Neon"] = 5.25, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 406.66, ["Mega"] = 58.22, ["Mega|Ride"] = 69.51, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.3, ["Fly"] = 45.93, ["Ride"] = 18.65, ["Fly|Ride"] = 55.65, ["Neon"] = 11.17, ["Neon|Ride"] = 43.49, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 141.74, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Ride"] = 32.15, ["Neon"] = 34.38, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 279.37, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 417.46}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 49.19, ["Mega"] = 16.96, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 278.32}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 19.9, ["Ride"] = 14.79, ["Fly|Ride"] = 279029.46, ["Neon"] = 4.11, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.05, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.56, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 67.43, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 20.33, ["Ride"] = 17.05, ["Fly|Ride"] = 32.76, ["Neon"] = 7.75, ["Neon|Fly"] = 70.11, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 47.83, ["Mega|Ride"] = 51.32, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 79.73, ["Neon"] = 3.81, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 107.78, ["Mega"] = 25.86, ["Mega|Ride"] = 48.86, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 6.28, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 171.6, ["Mega"] = 38.07, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 79.8, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 28.04, ["Ride"] = 22.61, ["Fly|Ride"] = 34.13, ["Neon"] = 3.56, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 24.69, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 118.96}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 49.19, ["Neon"] = 2.1, ["Mega"] = 18.38, ["Mega|Ride"] = 104.79, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 159.45, ["Mega"] = 26.25, ["Mega|Fly"] = 119, ["Mega|Ride"] = 120.33}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 16.05, ["Fly|Ride"] = 65.63, ["Neon"] = 4.1, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 125.91, ["Mega"] = 54.74, ["Mega|Ride"] = 43.13, ["Mega|Fly|Ride"] = 120.33}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 14.91, ["Ride"] = 137.76, ["Neon"] = 95.81, ["Neon|Ride"] = 237.99, ["Mega"] = 354.38, ["Mega|Ride"] = 450.19, ["Mega|Fly|Ride"] = 767.94}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.93, ["Fly"] = 6562.5, ["Ride"] = 68.24, ["Neon"] = 41.47, ["Neon|Ride"] = 207.19, ["Mega"] = 1593.42, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.94, ["Ride"] = 26.24, ["Fly|Ride"] = 418.5, ["Neon"] = 18.77, ["Mega"] = 274.32, ["Mega|Ride"] = 157.07, ["Mega|Fly|Ride"] = 273.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.85, ["Ride"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 15.44, ["Neon|Ride"] = 12.56, ["Neon|Fly|Ride"] = 45, ["Mega"] = 17.87, ["Mega|Fly"] = 44.98, ["Mega|Ride"] = 26.11, ["Mega|Fly|Ride"] = 55.82}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 28.26, ["Fly|Ride"] = 70.11, ["Neon"] = 7.11, ["Neon|Fly"] = 92.09, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 697.85, ["Mega"] = 83.68, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 111.86}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.16, ["Mega"] = 15.1, ["Mega|Fly"] = 65.88, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 100.11}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.88, ["Mega"] = 24.44, ["Mega|Ride"] = 113.01, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 3.94, ["Fly"] = 20.93, ["Ride"] = 20.93, ["Fly|Ride"] = 46.05, ["Neon"] = 13.84, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 150.92, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 278.32}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 150.67, ["Ride"] = 159.43, ["Fly|Ride"] = 262.5, ["Neon"] = 1019.17, ["Neon|Ride"] = 973.88, ["Neon|Fly|Ride"] = 1116.34, ["Mega"] = 8369.87, ["Mega|Ride"] = 3138.72, ["Mega|Fly|Ride"] = 3252.9}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Fly"] = 56.52, ["Neon|Ride"] = 68.25, ["Mega"] = 87.9, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.82, ["Fly"] = 103.68, ["Ride"] = 32.15, ["Fly|Ride"] = 140.22, ["Neon"] = 28.25, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158, ["Mega"] = 350.83, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 1046.25}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.66, ["Fly|Ride"] = 45.94, ["Neon"] = 6.57, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 57.75, ["Mega|Fly"] = 95.2, ["Mega|Ride"] = 63.79, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 17.95, ["Fly|Ride"] = 121.12, ["Neon"] = 12.6, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 103.6, ["Mega"] = 95.7, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 585.9}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.45, ["Fly"] = 26.24, ["Ride"] = 18.35, ["Fly|Ride"] = 39.38, ["Neon"] = 32.69, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 209.26, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.67, ["Fly"] = 41.86, ["Ride"] = 41.86, ["Fly|Ride"] = 249.58, ["Neon"] = 21.4, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 621.48, ["Mega"] = 333.38, ["Mega|Ride"] = 354.58, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.84, ["Fly"] = 20.94, ["Ride"] = 17.59, ["Fly|Ride"] = 39.37, ["Neon"] = 30.5, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 34.8, ["Neon|Fly|Ride"] = 78.74, ["Mega|Ride"] = 697.85, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76, ["Fly"] = 120.33, ["Ride"] = 99.73, ["Fly|Ride"] = 131.25, ["Neon"] = 456.9, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 349.44, ["Neon|Fly|Ride"] = 479.07, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 322.17, ["Ride"] = 249.04, ["Fly|Ride"] = 237.99, ["Neon"] = 920.94, ["Neon|Ride"] = 1464.91, ["Neon|Fly|Ride"] = 1203.19, ["Mega"] = 10462.32, ["Mega|Fly|Ride"] = 4032.19}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.49, ["Fly"] = 140.21, ["Ride"] = 78.66, ["Fly|Ride"] = 131.25, ["Neon"] = 383.09, ["Neon|Ride"] = 277.57, ["Neon|Fly|Ride"] = 363.25, ["Mega|Ride"] = 1255.5, ["Mega|Fly|Ride"] = 1189.81}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.62, ["Fly"] = 26.24, ["Ride"] = 31.4, ["Fly|Ride"] = 140.22, ["Neon"] = 30.08, ["Neon|Ride"] = 52.22, ["Neon|Fly|Ride"] = 125.71, ["Mega"] = 193.95, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 345.27}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 16.4, ["Fly"] = 68.51, ["Ride"] = 30.82, ["Fly|Ride"] = 85.32, ["Neon"] = 132.34, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 142.79, ["Mega"] = 351.75, ["Mega|Ride"] = 450.94, ["Mega|Fly|Ride"] = 576.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.09, ["Ride"] = 16.56, ["Fly|Ride"] = 41.86, ["Neon"] = 4.76, ["Neon|Fly"] = 23.45, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 66.75, ["Mega|Fly"] = 211.79, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 154.86}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.6, ["Fly"] = 72.12, ["Ride"] = 21.94, ["Fly|Ride"] = 140.22, ["Neon"] = 48.66, ["Neon|Ride"] = 158.81, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 807.71, ["Mega|Ride"] = 627.76, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.63, ["Fly"] = 30.54, ["Ride"] = 18.81, ["Fly|Ride"] = 46.39, ["Neon"] = 9.51, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 94.58, ["Mega"] = 131.25, ["Mega|Ride"] = 176.35, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 6.13, ["Ride"] = 28.25, ["Fly|Ride"] = 127.31, ["Neon"] = 237.54, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 207.37, ["Mega|Ride"] = 208.22, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 131.23, ["Neon"] = 2.1, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 15.64, ["Mega|Ride"] = 37.71, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 6.07, ["Fly"] = 45.94, ["Ride"] = 20.92, ["Fly|Ride"] = 32.15, ["Neon"] = 13.11, ["Neon|Fly"] = 104.65, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 98, ["Mega"] = 104.64, ["Mega|Ride"] = 86.46, ["Mega|Fly|Ride"] = 195.66}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Fly"] = 24.93, ["Ride"] = 18.46, ["Fly|Ride"] = 45.85, ["Neon"] = 17.07, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 154.86, ["Mega|Fly|Ride"] = 227.26}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 158.09, ["Fly"] = 279.37, ["Ride"] = 231.02, ["Fly|Ride"] = 271.69, ["Neon"] = 700.88, ["Neon|Ride"] = 753.39, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.47, ["Ride"] = 240.92, ["Fly|Ride"] = 206.07, ["Neon"] = 91.88, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 313.74, ["Mega|Ride"] = 391.31, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 56.52, ["Neon"] = 27.2, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 199.5, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 275.18}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21, ["Ride"] = 36.98, ["Fly|Ride"] = 178.5, ["Neon"] = 103.14, ["Neon|Ride"] = 138.14, ["Neon|Fly|Ride"] = 332.38, ["Mega"] = 494.25, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 690.53}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 9.17}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.89, ["Ride"] = 35.58, ["Neon"] = 39.53, ["Neon|Ride"] = 151.52, ["Neon|Fly|Ride"] = 627.76, ["Mega"] = 236.25, ["Mega|Ride"] = 360.82, ["Mega|Fly|Ride"] = 417.4}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.72, ["Fly"] = 77.67, ["Ride"] = 31.49, ["Fly|Ride"] = 44.63, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 143.83, ["Neon|Fly|Ride"] = 188.05, ["Mega"] = 2092.48, ["Mega|Fly|Ride"] = 697.85}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Fly|Ride"] = 65.62, ["Neon"] = 3.44, ["Neon|Ride"] = 53.34, ["Neon|Fly|Ride"] = 80.62, ["Mega"] = 24.94, ["Mega|Fly"] = 416.41, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 162.73}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.56, ["Fly"] = 27.09, ["Ride"] = 28.26, ["Fly|Ride"] = 112.54, ["Neon|Ride"] = 237.99, ["Mega"] = 221.17, ["Mega|Fly"] = 397.41, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 3.19, ["Fly"] = 45, ["Ride"] = 21, ["Fly|Ride"] = 45.65, ["Neon"] = 13.41, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 124.69, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 22.99, ["Neon"] = 3.91, ["Neon|Ride"] = 28.27, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 31.4, ["Mega|Ride"] = 83.71, ["Mega|Fly|Ride"] = 159.45}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.92, ["Ride"] = 128.63, ["Neon"] = 181.61, ["Neon|Ride"] = 200.82, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 852.55, ["Mega|Ride"] = 1018.47, ["Mega|Fly|Ride"] = 951.68}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.92, ["Ride"] = 52.5, ["Neon"] = 80.07, ["Neon|Ride"] = 83.72, ["Neon|Fly|Ride"] = 209.26, ["Mega"] = 278.32, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 31.4, ["Fly"] = 139.54, ["Ride"] = 144.25, ["Fly|Ride"] = 125.57, ["Neon"] = 52.17, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 59.77, ["Neon|Fly|Ride"] = 420}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.66, ["Fly"] = 433.13, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 404.96, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 621.48, ["Mega"] = 1255.5, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.12, ["Fly"] = 39.38, ["Ride"] = 28.74, ["Fly|Ride"] = 56.43, ["Neon"] = 64.32, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 249.6, ["Mega|Ride"] = 332.26, ["Mega|Fly|Ride"] = 349.46}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 80.56, ["Fly"] = 140.21, ["Ride"] = 124.69, ["Fly|Ride"] = 167.43, ["Neon"] = 203.44, ["Neon|Ride"] = 293.44, ["Neon|Fly|Ride"] = 315, ["Mega"] = 898.15, ["Mega|Ride"] = 1139.22, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.26, ["Fly"] = 125.56, ["Ride"] = 71.15, ["Fly|Ride"] = 173.25, ["Neon"] = 80.27, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 287.43, ["Mega"] = 341.25, ["Mega|Ride"] = 297.53, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 69.51, ["Ride"] = 27.2, ["Fly|Ride"] = 62.78, ["Neon"] = 82.68, ["Neon|Ride"] = 58.95, ["Neon|Fly|Ride"] = 378.37, ["Mega"] = 154.86, ["Mega|Ride"] = 1046.25, ["Mega|Fly|Ride"] = 404.55}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.93, ["Ride"] = 83.71, ["Fly|Ride"] = 123.55, ["Neon"] = 85.31, ["Neon|Ride"] = 125.54, ["Neon|Fly|Ride"] = 278.5, ["Mega"] = 365.45, ["Mega|Fly"] = 505.35, ["Mega|Ride"] = 349.46, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.57, ["Ride"] = 34.12, ["Fly|Ride"] = 135.61, ["Neon"] = 39.87, ["Neon|Ride"] = 90, ["Neon|Fly|Ride"] = 137.07, ["Mega"] = 302.23, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 54.44, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 102.55, ["Mega"] = 15.48, ["Mega|Fly"] = 140.21, ["Mega|Fly|Ride"] = 190.38}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.73, ["Ride"] = 22.31, ["Neon"] = 19.67, ["Neon|Fly"] = 125.57, ["Neon|Ride"] = 118.13, ["Mega"] = 112.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 23.61, ["Neon|Ride"] = 103.6, ["Mega"] = 137.82, ["Mega|Ride"] = 139.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.43, ["Ride"] = 31.5, ["Fly|Ride"] = 117.81, ["Neon"] = 15.7, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 272.04, ["Mega"] = 123.37, ["Mega|Ride"] = 159.45, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.35, ["Fly"] = 626.7, ["Ride"] = 485.63, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1262.91, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.57, ["Fly"] = 27.75, ["Ride"] = 25.12, ["Fly|Ride"] = 53.86, ["Neon"] = 52.5, ["Neon|Ride"] = 97.13, ["Mega|Ride"] = 376.65}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 15.63, ["Fly"] = 39.38, ["Ride"] = 26.65, ["Fly|Ride"] = 59.76, ["Neon"] = 52.49, ["Neon|Ride"] = 119.69, ["Mega"] = 265.76, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 7.88, ["Ride"] = 19.67, ["Fly|Ride"] = 313.92, ["Neon|Ride"] = 103.6, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 236.25, ["Mega|Ride"] = 635.36, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 54.12, ["Ride"] = 30.18, ["Fly|Ride"] = 90.57, ["Neon"] = 6.57, ["Neon|Fly"] = 279.39, ["Neon|Ride"] = 38.85, ["Neon|Fly|Ride"] = 119.28, ["Mega"] = 74.87, ["Mega|Ride"] = 95.17, ["Mega|Fly|Ride"] = 177.87}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.11, ["Ride"] = 19.68, ["Neon"] = 3.93, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 74.29, ["Mega"] = 26.25, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 54.77, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1543.21}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.76, ["Ride"] = 28.03, ["Fly|Ride"] = 68.81, ["Neon"] = 73.76, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 167.42, ["Mega|Ride"] = 837, ["Mega|Fly|Ride"] = 832.81}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.63, ["Ride"] = 28.26, ["Neon"] = 8.39, ["Neon|Ride"] = 40.69, ["Mega"] = 38.66, ["Mega|Ride"] = 144.09, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.21, ["Fly"] = 98.36, ["Ride"] = 25.12, ["Fly|Ride"] = 574.39, ["Neon"] = 10.49, ["Neon|Fly"] = 125.57, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 127.33, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 418.5, ["Ride"] = 420, ["Fly|Ride"] = 433.13, ["Neon|Ride"] = 1534.32, ["Neon|Fly|Ride"] = 1718.97, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.08, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 78.75, ["Mega"] = 391.21, ["Mega|Ride"] = 452.13}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 111.2, ["Ride"] = 23.81, ["Fly|Ride"] = 87.91, ["Neon"] = 5.09, ["Neon|Ride"] = 37.96, ["Neon|Fly|Ride"] = 95.2, ["Mega"] = 40.49, ["Mega|Fly"] = 189, ["Mega|Ride"] = 108.84, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 837, ["Neon"] = 2.63, ["Neon|Ride"] = 47.61, ["Neon|Fly|Ride"] = 265.76, ["Mega"] = 23, ["Mega|Ride"] = 108.3, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.05, ["Fly"] = 56.51, ["Ride"] = 28.24, ["Fly|Ride"] = 178.5, ["Neon"] = 65.41, ["Neon|Ride"] = 111.98, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 418.5, ["Mega|Fly|Ride"] = 414.32}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.35, ["Ride"] = 111.96, ["Neon"] = 92.81, ["Neon|Fly|Ride"] = 837, ["Mega"] = 393.75, ["Mega|Ride"] = 349.46, ["Mega|Fly|Ride"] = 1076.93}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 8.22, ["Ride"] = 32.82, ["Fly|Ride"] = 140.22, ["Neon"] = 105, ["Neon|Ride"] = 95.2, ["Mega"] = 627.76, ["Mega|Ride"] = 696.56, ["Mega|Fly|Ride"] = 1253.44}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 27.2, ["Ride"] = 52.36, ["Neon"] = 209.28, ["Neon|Ride"] = 181.91, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 459.38, ["Mega|Ride"] = 598.46, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 328.12, ["Fly|Ride"] = 523.2, ["Neon"] = 1215.89, ["Neon|Ride"] = 1535.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3459.75}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.65, ["Fly"] = 69.65, ["Ride"] = 23.62, ["Fly|Ride"] = 236.25, ["Neon"] = 89.88, ["Neon|Ride"] = 140.18, ["Neon|Fly|Ride"] = 137.67, ["Mega"] = 558.71, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 831.77}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.94, ["Mega|Ride"] = 835.69, ["Mega|Fly|Ride"] = 793.61}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 12.37, ["Ride"] = 73.48, ["Fly|Ride"] = 251.3, ["Neon"] = 48.15, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 159.45, ["Mega"] = 237.8, ["Mega|Fly"] = 418.5, ["Mega|Ride"] = 242.88, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Ride"] = 42, ["Fly|Ride"] = 125.56, ["Neon"] = 15.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 208.22, ["Mega"] = 47.01, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 81.62, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 39.38, ["Ride"] = 140.21, ["Neon"] = 251.14, ["Neon|Ride"] = 245.31, ["Neon|Fly|Ride"] = 470.81, ["Mega"] = 1812.09, ["Mega|Ride"] = 1339.19, ["Mega|Fly|Ride"] = 1350.69}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 15.7, ["Neon"] = 9, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 52.33, ["Neon|Fly|Ride"] = 138.12, ["Mega"] = 94.95, ["Mega|Ride"] = 106.23, ["Mega|Fly|Ride"] = 213.45}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 28.26, ["Fly|Ride"] = 98.44, ["Neon"] = 7.01, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 43.73, ["Mega|Fly"] = 157.4, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 18.16, ["Ride"] = 26.25, ["Fly|Ride"] = 111.98, ["Neon"] = 79.73, ["Mega"] = 1146.69, ["Mega|Fly|Ride"] = 1534.84}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.93, ["Fly"] = 70.11, ["Ride"] = 65.63, ["Neon"] = 334.85, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 626.7, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.49, ["Ride"] = 309.74, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 6277.41, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 15.71, ["Ride"] = 47.54, ["Fly|Ride"] = 77.44, ["Neon"] = 36.75, ["Mega"] = 86.5, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 24.55, ["Ride"] = 23.81, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 79.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 155.57, ["Ride"] = 20.56, ["Fly|Ride"] = 177.54, ["Neon"] = 36.75, ["Neon|Fly"] = 70.11, ["Mega"] = 519.1, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.78, ["Ride"] = 27.19, ["Fly|Ride"] = 89.98, ["Neon"] = 4.2, ["Neon|Ride"] = 27.6, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 43.61, ["Mega|Ride"] = 78.48, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 33.49, ["Fly|Ride"] = 279.39, ["Neon"] = 8.26, ["Mega"] = 52.5, ["Mega|Fly"] = 140.21, ["Mega|Ride"] = 207.17, ["Mega|Fly|Ride"] = 275.18}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 17.06, ["Fly|Ride"] = 41.96, ["Neon"] = 4.07, ["Neon|Fly"] = 46.52, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 51.45, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 137.07}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.36, ["Ride"] = 20.79, ["Fly|Ride"] = 56.51, ["Neon"] = 7.71, ["Neon|Fly"] = 88.06, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 92.08, ["Mega"] = 156.13, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.02, ["Ride"] = 45.02, ["Fly|Ride"] = 82.56, ["Neon|Ride"] = 317.7, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 722.22}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 82.22, ["Fly"] = 582.75, ["Ride"] = 116.61, ["Fly|Ride"] = 160.13, ["Neon"] = 350.47, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 523.14, ["Mega"] = 3173.2, ["Mega|Ride"] = 1412.25, ["Mega|Fly|Ride"] = 1814.18}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 35.43, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 5.16, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 64.26, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 349.46}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 15.7, ["Fly|Ride"] = 35.42, ["Neon"] = 3.9, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 19.9, ["Neon|Fly|Ride"] = 69.81, ["Mega"] = 48.44, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 8.39, ["Fly"] = 31.4, ["Ride"] = 51.19, ["Fly|Ride"] = 140.21, ["Neon"] = 65.63, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 278.32, ["Mega"] = 626.82, ["Mega|Ride"] = 405.96, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 367.49, ["Fly"] = 393.74, ["Ride"] = 461.41, ["Fly|Ride"] = 475.88, ["Neon|Ride"] = 1814.39, ["Mega|Fly|Ride"] = 6695.9}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.88, ["Fly"] = 132.25, ["Ride"] = 74.06, ["Neon"] = 103.19, ["Neon|Ride"] = 205.37, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 1253.44, ["Mega|Fly|Ride"] = 1140.41}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 40.17, ["Fly|Ride"] = 78.75, ["Neon"] = 7.88, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 105, ["Mega"] = 77.44, ["Mega|Ride"] = 112.83, ["Mega|Fly|Ride"] = 246.88}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.33, ["Fly"] = 209.26, ["Ride"] = 65.62, ["Fly|Ride"] = 142.7, ["Neon"] = 71.16, ["Neon|Ride"] = 167.43, ["Mega"] = 194.61, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.6, ["Fly"] = 76.89, ["Ride"] = 39.37, ["Fly|Ride"] = 65.62, ["Neon"] = 128.63, ["Neon|Ride"] = 244.86, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2510.97, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 977.19}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 128.63, ["Ride"] = 140.21, ["Fly|Ride"] = 140.21, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3069.66, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 227.07, ["Ride"] = 249.38, ["Fly|Ride"] = 393.75, ["Neon"] = 904.29, ["Neon|Ride"] = 877.91, ["Neon|Fly|Ride"] = 1043.11, ["Mega"] = 3184.74, ["Mega|Fly|Ride"] = 3203.58}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.19, ["Ride"] = 40.69, ["Fly|Ride"] = 59.07, ["Neon"] = 82.68, ["Neon|Ride"] = 127.33, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 388.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 488.6}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 16.28, ["Fly|Ride"] = 40.39, ["Neon"] = 15.69, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 91.22, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.93, ["Fly"] = 17.85, ["Ride"] = 30.24, ["Fly|Ride"] = 639.77, ["Neon"] = 47.61, ["Neon|Fly"] = 146.5, ["Neon|Ride"] = 41.65, ["Neon|Fly|Ride"] = 104.64, ["Mega"] = 288.75, ["Mega|Ride"] = 255.46, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 309.74, ["Fly"] = 488.6, ["Ride"] = 365.86, ["Fly|Ride"] = 406.88, ["Neon"] = 1374.93, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1954.37, ["Mega|Ride"] = 4882.78, ["Mega|Fly|Ride"] = 5013.54}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 6.09, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 95.2, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 416.41}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.25, ["Ride"] = 18.38, ["Fly|Ride"] = 43.32, ["Neon"] = 23.31, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 159.01, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 75.51, ["Ride"] = 104.64, ["Neon"] = 78.74, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 188.35, ["Neon|Fly|Ride"] = 349.46, ["Mega"] = 471.19, ["Mega|Ride"] = 475.94, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 153.07, ["Fly"] = 278.32, ["Ride"] = 153.57, ["Fly|Ride"] = 237.99, ["Neon|Ride"] = 739.79, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.75, ["Fly"] = 46.04, ["Ride"] = 32.38, ["Fly|Ride"] = 50.94, ["Neon"] = 91.88, ["Neon|Ride"] = 102.56, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 627.76, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 697.85, ["Mega"] = 20.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 3.89, ["Neon|Fly"] = 159.45, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 27.57, ["Mega|Fly"] = 140.1, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.71, ["Fly"] = 418.5, ["Ride"] = 66.85, ["Fly|Ride"] = 137.31, ["Neon"] = 29.86, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 104.64, ["Mega"] = 151.31, ["Mega|Ride"] = 149.93, ["Mega|Fly|Ride"] = 264.11}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1312.49, ["Ride"] = 1312.49, ["Fly|Ride"] = 1370.25, ["Neon"] = 4200, ["Neon|Ride"] = 6976.09, ["Neon|Fly|Ride"] = 4673.53, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 409.29, ["Ride"] = 440.84, ["Fly|Ride"] = 481.35, ["Neon"] = 1865.05, ["Neon|Ride"] = 1572.38, ["Neon|Fly|Ride"] = 1629.21, ["Mega"] = 16739.71, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 306.66, ["Fly"] = 404.91, ["Ride"] = 324.84, ["Fly|Ride"] = 443.42, ["Neon"] = 656.25, ["Neon|Fly"] = 1269.55, ["Neon|Ride"] = 617.67, ["Neon|Fly|Ride"] = 757.4, ["Mega|Fly|Ride"] = 3067.32}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 328.01, ["Fly"] = 416.41, ["Ride"] = 358.32, ["Fly|Ride"] = 472.49, ["Neon"] = 1200.2, ["Neon|Fly"] = 1395.85, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 4447.54}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 16.75, ["Fly|Ride"] = 45.94, ["Neon"] = 7.02, ["Neon|Ride"] = 33.08, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 59.64, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 470.3, ["Fly"] = 656.01, ["Ride"] = 446.25, ["Fly|Ride"] = 697.93, ["Neon"] = 1674.19, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1720.69, ["Mega"] = 6273.21, ["Mega|Fly|Ride"] = 6137.21}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.68, ["Fly"] = 183.75, ["Ride"] = 27.57, ["Neon"] = 7.75, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 118.78, ["Mega"] = 57.75, ["Mega|Ride"] = 108.83, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 25.12, ["Ride"] = 19.11, ["Fly|Ride"] = 32.44, ["Neon"] = 4.2, ["Neon|Ride"] = 49.18, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 91.88, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 317.69}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Fly"] = 79.73, ["Neon|Ride"] = 39.37, ["Mega"] = 24.15, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 41.37, ["Ride"] = 65.63, ["Fly|Ride"] = 459.37, ["Neon"] = 244.13, ["Neon|Ride"] = 159.45, ["Mega"] = 2092.48, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 17.4, ["Fly|Ride"] = 55.17, ["Neon"] = 26.25, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.93, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 60.97, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 28.26, ["Mega|Fly"] = 697.85, ["Mega|Ride"] = 111.45, ["Mega|Fly|Ride"] = 140.21}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 24.07, ["Fly|Ride"] = 57.38, ["Neon"] = 7.7, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 32.46, ["Neon|Fly|Ride"] = 72.12, ["Mega"] = 61.69, ["Mega|Fly"] = 174.74, ["Mega|Ride"] = 86.24, ["Mega|Fly|Ride"] = 154.86}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.23, ["Fly"] = 47.6, ["Ride"] = 18.81, ["Fly|Ride"] = 51.45, ["Neon"] = 154.87, ["Neon|Fly"] = 142.79, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.75, ["Ride"] = 52.5, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 317.69, ["Mega"] = 190.38, ["Mega|Ride"] = 265.76, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.62, ["Ride"] = 41.86, ["Fly|Ride"] = 70.11, ["Neon"] = 36.9, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 439.03, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39, ["Ride"] = 18.38, ["Fly|Ride"] = 55.94, ["Neon"] = 3.75, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 28.27, ["Mega"] = 43.32, ["Mega|Ride"] = 83.71, ["Mega|Fly|Ride"] = 313.89}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 219.75, ["Ride"] = 251.11, ["Fly|Ride"] = 355.73, ["Neon|Ride"] = 2615.91, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 8369.87, ["Mega|Fly|Ride"] = 5235.11}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.7, ["Fly|Ride"] = 32.96, ["Neon"] = 6.02, ["Neon|Fly"] = 25.1, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 49.79, ["Mega"] = 44.63, ["Mega|Ride"] = 50.52, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.42, ["Ride"] = 94.48, ["Fly|Ride"] = 183.72, ["Neon"] = 57.75, ["Neon|Ride"] = 100.66, ["Mega"] = 393.75, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 464.35}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.07, ["Fly"] = 210, ["Ride"] = 124.69, ["Fly|Ride"] = 104.99, ["Neon"] = 262.5, ["Neon|Ride"] = 311.92, ["Mega"] = 835.95, ["Mega|Ride"] = 866.17, ["Mega|Fly|Ride"] = 951.85}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 193.23, ["Ride"] = 235.41, ["Fly|Ride"] = 308.44, ["Neon"] = 768.04, ["Neon|Ride"] = 671.98, ["Neon|Fly|Ride"] = 698.85, ["Mega|Ride"] = 3342.94, ["Mega|Fly|Ride"] = 2929.46}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 12.85, ["Fly|Ride"] = 141.59, ["Neon"] = 17.07, ["Neon|Ride"] = 279.39, ["Mega"] = 285.48, ["Mega|Ride"] = 232.29, ["Mega|Fly|Ride"] = 434.2}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 58.94, ["Ride"] = 418.5, ["Fly|Ride"] = 626.68, ["Neon"] = 397.42, ["Neon|Ride"] = 397.42, ["Neon|Fly|Ride"] = 837, ["Mega"] = 1673.99, ["Mega|Fly|Ride"] = 933.26}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1241.13, ["Ride"] = 1312.49, ["Fly|Ride"] = 1576.88, ["Neon|Ride"] = 5222.4, ["Neon|Fly|Ride"] = 4759.19, ["Mega|Fly|Ride"] = 17157.16}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.29, ["Fly"] = 26.25, ["Ride"] = 19.79, ["Fly|Ride"] = 58.61, ["Neon"] = 174.11, ["Neon|Fly"] = 84.91, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 201.36, ["Mega"] = 278.32, ["Mega|Ride"] = 229.15, ["Mega|Fly|Ride"] = 324.34}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.15, ["Fly"] = 13810.28, ["Ride"] = 33, ["Neon"] = 25.69, ["Neon|Ride"] = 98.37, ["Mega"] = 208.22, ["Mega|Ride"] = 189.92, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 14.3, ["Ride"] = 103.68, ["Fly|Ride"] = 942.36, ["Mega"] = 1046.11, ["Mega|Ride"] = 1546.75, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.81, ["Fly"] = 41.86, ["Ride"] = 37.89, ["Fly|Ride"] = 65.63, ["Neon"] = 72.02, ["Neon|Ride"] = 99.04, ["Neon|Fly|Ride"] = 211.62, ["Mega"] = 476.05, ["Mega|Ride"] = 398.99, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 4.8, ["Fly"] = 19.92, ["Ride"] = 19.76, ["Fly|Ride"] = 48.16, ["Neon"] = 22.29, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 154.69, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 416.41, ["Ride"] = 36.63, ["Neon"] = 7.85, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 63.54, ["Neon|Fly|Ride"] = 837, ["Mega"] = 87.94, ["Mega|Ride"] = 137.73}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 294.26, ["Ride"] = 348.9, ["Fly|Ride"] = 523.14, ["Neon|Ride"] = 1535.02, ["Neon|Fly|Ride"] = 2092.48, ["Mega|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 6972.1}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 30.35, ["Fly|Ride"] = 65.62, ["Neon"] = 11.76, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 104.99, ["Mega|Ride"] = 123.76, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.51, ["Ride"] = 22.22, ["Neon"] = 131.25, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 1045.2, ["Mega|Ride"] = 977.19, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.11, ["Fly"] = 73.05, ["Ride"] = 32.22, ["Neon"] = 14.19, ["Neon|Ride"] = 70.11, ["Mega"] = 203.44, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 350.07}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 255.04, ["Fly"] = 354.9, ["Ride"] = 315, ["Fly|Ride"] = 684.33, ["Neon"] = 836.06, ["Neon|Ride"] = 886.28, ["Neon|Fly|Ride"] = 984.38, ["Mega|Ride"] = 3138.72, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 29.34, ["Fly"] = 55.62, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 116.81, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 593.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 725.82}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 31.4, ["Ride"] = 39.38, ["Fly|Ride"] = 120.33, ["Neon"] = 124.69, ["Neon|Fly"] = 79.73, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 506.13, ["Mega|Ride"] = 423.6, ["Mega|Fly|Ride"] = 472.47}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 37.53, ["Mega"] = 32.71, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 67.38, ["Fly"] = 5948.03, ["Ride"] = 107.63, ["Fly|Ride"] = 157.4, ["Neon"] = 318.94, ["Neon|Fly"] = 474.69, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1492.02}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.25, ["Neon"] = 6.51, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 588, ["Mega"] = 40.68, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 417.46}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 24.78, ["Fly"] = 127.31, ["Ride"] = 28.88, ["Fly|Ride"] = 71.99, ["Neon"] = 57.28, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 209.26, ["Mega"] = 382.05, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 66.05, ["Fly"] = 110.06, ["Ride"] = 90.45, ["Fly|Ride"] = 132.9, ["Neon"] = 308.69, ["Neon|Ride"] = 279.39, ["Neon|Fly|Ride"] = 347, ["Mega|Ride"] = 1338.15, ["Mega|Fly|Ride"] = 956.39}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 15.7, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 16.35, ["Neon|Fly|Ride"] = 47.61, ["Mega"] = 32.05, ["Mega|Fly"] = 55.94, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.88, ["Ride"] = 33.49, ["Fly|Ride"] = 1346.59, ["Neon"] = 16.35, ["Neon|Ride"] = 49.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 279.37, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.82, ["Fly"] = 140.21, ["Ride"] = 111.85, ["Fly|Ride"] = 279.39, ["Neon"] = 150.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 586.69, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 826.54}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 136.02, ["Mega"] = 20.69, ["Mega|Ride"] = 139.02, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 6.18, ["Ride"] = 53.37, ["Fly|Ride"] = 120.74, ["Neon"] = 52.5, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 312.84, ["Mega"] = 380.63, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 304.88, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 16.7, ["Fly"] = 28.22, ["Ride"] = 20.86, ["Fly|Ride"] = 45.94, ["Neon"] = 126.98, ["Neon|Ride"] = 67.24, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 349.46, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.04, ["Ride"] = 71.39, ["Fly|Ride"] = 76.01, ["Neon"] = 32.82, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 129.94, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 275.18}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 21.46, ["Fly"] = 2092.48, ["Ride"] = 82.51, ["Neon"] = 64.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 357, ["Mega|Ride"] = 413.27, ["Mega|Fly|Ride"] = 971.92}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 128.17, ["Fly|Ride"] = 196.88, ["Neon"] = 6.34, ["Neon|Fly"] = 56.52, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 99.63, ["Mega"] = 65.54, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.56}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 25.6, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 28.14}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.41, ["Fly"] = 102.38, ["Ride"] = 79.72, ["Fly|Ride"] = 90.04, ["Neon"] = 1050, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 558.71, ["Mega"] = 1241.89, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Mega"] = 26.54, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 433.13, ["Ride"] = 430.5, ["Fly|Ride"] = 627.76, ["Neon"] = 2036.23, ["Neon|Fly|Ride"] = 2065.59, ["Mega"] = 16739.71, ["Mega|Ride"] = 15679.88, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.24, ["Fly"] = 26.17, ["Ride"] = 39.37, ["Fly|Ride"] = 89.99, ["Neon"] = 13.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 110.92, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 166.59}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.69, ["Fly"] = 159.43, ["Ride"] = 23.13, ["Fly|Ride"] = 62.97, ["Neon"] = 19.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 97.76, ["Mega"] = 140.21, ["Mega|Ride"] = 159.45, ["Mega|Fly|Ride"] = 279.37}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.58, ["Ride"] = 32.15, ["Fly|Ride"] = 522.1, ["Neon"] = 78.74, ["Neon|Ride"] = 183.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 731.33, ["Mega|Ride"] = 543.01, ["Mega|Fly|Ride"] = 837}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.38, ["Fly"] = 131.25, ["Ride"] = 17.07, ["Neon|Ride"] = 118.12, ["Mega"] = 249.38}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.49, ["Ride"] = 42.35, ["Fly|Ride"] = 157.49, ["Neon"] = 67.53, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 358.89, ["Mega"] = 333.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 977.19}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 8.42, ["Fly"] = 104.99, ["Ride"] = 56.51, ["Fly|Ride"] = 188.35, ["Neon"] = 49.88, ["Neon|Ride"] = 98.14, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 185.24, ["Mega|Fly"] = 483.37, ["Mega|Ride"] = 208.69}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 13.13, ["Fly|Ride"] = 62.97, ["Neon"] = 2.1, ["Neon|Fly"] = 59.66, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 69.78, ["Mega"] = 21.29, ["Mega|Fly"] = 62.69, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 147.05}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.62, ["Ride"] = 27.56, ["Fly|Ride"] = 159.45, ["Neon"] = 28.26, ["Neon|Fly"] = 119, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 111.86, ["Mega"] = 194.24, ["Mega|Fly"] = 140.21, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.47, ["Fly"] = 334.82, ["Ride"] = 288.75, ["Fly|Ride"] = 375.38, ["Neon"] = 1116.48, ["Neon|Ride"] = 1372.84, ["Neon|Fly|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 4179.46}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 82.69, ["Ride"] = 137.27, ["Fly|Ride"] = 7672.97, ["Neon"] = 564.38, ["Neon|Ride"] = 570.3, ["Neon|Fly|Ride"] = 622.53, ["Mega"] = 4184.94, ["Mega|Ride"] = 2023.43, ["Mega|Fly|Ride"] = 1627.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.04, ["Ride"] = 19.89, ["Fly|Ride"] = 39.38, ["Neon"] = 135.17, ["Neon|Fly"] = 70.11, ["Neon|Ride"] = 33.49, ["Neon|Fly|Ride"] = 62.56, ["Mega|Fly"] = 208.22, ["Mega|Ride"] = 98.36, ["Mega|Fly|Ride"] = 154.86}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.4, ["Ride"] = 17.07, ["Fly|Ride"] = 26.25, ["Neon"] = 6.45, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 23.45, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 76.98, ["Mega|Fly"] = 349.46, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 132.88}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.17, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 36.75, ["Mega"] = 140.21, ["Mega|Ride"] = 89.99, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 191.02, ["Ride"] = 262.5, ["Fly|Ride"] = 279.37, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1395.69, ["Mega|Ride"] = 8369.87, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.62, ["Fly"] = 48.42, ["Ride"] = 13.13, ["Fly|Ride"] = 35.77, ["Neon"] = 19.68, ["Neon|Fly"] = 159.45, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 342.45, ["Mega|Ride"] = 270.11, ["Mega|Fly|Ride"] = 327.76}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.55, ["Fly"] = 159.43, ["Ride"] = 96.48, ["Fly|Ride"] = 209.26, ["Neon"] = 36.63, ["Neon|Ride"] = 139.13, ["Mega"] = 209.26, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.54, ["Neon|Ride"] = 32.03, ["Mega"] = 49.68, ["Mega|Ride"] = 96.55, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 17.48, ["Ride"] = 24.86, ["Fly|Ride"] = 69.06, ["Neon"] = 78.3, ["Neon|Ride"] = 90.35, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 556.61}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 50.67, ["Fly"] = 95.19, ["Ride"] = 77.43, ["Fly|Ride"] = 209.9, ["Neon"] = 156.35, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 472.5, ["Mega|Fly"] = 2197.11, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 607.64}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.17, ["Fly"] = 159.43, ["Ride"] = 46.38, ["Fly|Ride"] = 86.79, ["Neon"] = 112.34, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 246.93, ["Mega"] = 795.15, ["Mega|Ride"] = 627.76, ["Mega|Fly|Ride"] = 697.85}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.81, ["Ride"] = 14.86, ["Fly|Ride"] = 32.15, ["Neon"] = 2.1, ["Neon|Fly"] = 28.25, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 24.61, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 32.16, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 227.06, ["Fly"] = 295.05, ["Ride"] = 275.63, ["Fly|Ride"] = 334.85, ["Neon"] = 1228.43, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1111.28, ["Mega|Fly|Ride"] = 4398.38}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.58, ["Fly"] = 61.61, ["Ride"] = 46.22, ["Fly|Ride"] = 132.9, ["Neon"] = 105, ["Neon|Ride"] = 159.06, ["Neon|Fly|Ride"] = 321.56, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 29.21, ["Ride"] = 18.37, ["Fly|Ride"] = 39.38, ["Neon"] = 9.19, ["Neon|Ride"] = 19.37, ["Neon|Fly|Ride"] = 110.9, ["Mega"] = 59.14, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 302.23}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Ride"] = 18.24, ["Fly|Ride"] = 55.47, ["Neon"] = 3.83, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 102.01, ["Mega"] = 28.56, ["Mega|Fly"] = 142.79, ["Mega|Ride"] = 48.7, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 24.95, ["Fly|Ride"] = 69.27, ["Neon"] = 12.77, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 79.73, ["Mega"] = 94.12, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 397.41}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 15.65, ["Fly"] = 38.68, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 44.63, ["Neon|Ride"] = 41.02, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 328.37, ["Mega|Ride"] = 309.65, ["Mega|Fly|Ride"] = 316.31}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 8.66, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 55.01, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 275.63, ["Mega|Ride"] = 359.91, ["Mega|Fly|Ride"] = 414.32}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 38.52, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 69.55, ["Mega|Ride"] = 61.43}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.25, ["Ride"] = 24.92, ["Fly|Ride"] = 70.11, ["Neon"] = 24.32, ["Neon|Fly"] = 47.61, ["Neon|Ride"] = 69.97, ["Neon|Fly|Ride"] = 91.04, ["Mega"] = 150.94, ["Mega|Ride"] = 259.45, ["Mega|Fly|Ride"] = 301.43}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 101.22, ["Neon"] = 6.28, ["Neon|Fly"] = 98.37, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 57.87, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 229.15}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 31.62, ["Ride"] = 20.91, ["Fly|Ride"] = 118.13, ["Neon"] = 6.17, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 63.86, ["Mega"] = 50.02, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 199.85}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 649.69, ["Ride"] = 728.44, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 11968.15}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 15.65, ["Fly|Ride"] = 31.49, ["Neon"] = 28.96, ["Neon|Fly"] = 33.03, ["Neon|Ride"] = 40.82, ["Neon|Fly|Ride"] = 111.96, ["Mega"] = 187.29, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 34.13, ["Fly|Ride"] = 164.74, ["Neon"] = 6.34, ["Neon|Fly"] = 837.1, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 57.66, ["Mega|Fly"] = 159.45, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 246.64}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.93, ["Fly"] = 31.4, ["Ride"] = 26.81, ["Fly|Ride"] = 47.24, ["Neon"] = 38.57, ["Neon|Fly"] = 111.98, ["Neon|Ride"] = 45.26, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 358.79}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 34.12, ["Neon"] = 8.11, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 48.37, ["Mega"] = 51.19, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 190.38}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 62.39, ["Ride"] = 87.2, ["Fly|Ride"] = 208.22, ["Neon"] = 250.84, ["Neon|Ride"] = 257.44, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 896.44, ["Mega|Ride"] = 1118.42}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.84, ["Neon"] = 6.86, ["Neon|Fly"] = 135.66, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 61.69, ["Mega|Ride"] = 110.92, ["Mega|Fly|Ride"] = 265.76}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 23.81, ["Fly|Ride"] = 65.63, ["Neon"] = 12.33, ["Neon|Ride"] = 62.79, ["Mega"] = 98.44, ["Mega|Ride"] = 187.29, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.85, ["Neon"] = 15.75, ["Neon|Fly"] = 64.26, ["Neon|Ride"] = 111.86, ["Mega"] = 110.92, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.92, ["Fly|Ride"] = 83.72, ["Neon"] = 3.93, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 56.4, ["Mega|Fly"] = 200.82, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 176.1}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 20.91, ["Fly"] = 26.24, ["Ride"] = 27.17, ["Fly|Ride"] = 39.38, ["Neon"] = 137.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 837, ["Mega|Ride"] = 418.5, ["Mega|Fly|Ride"] = 445.15}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 736.75, ["Ride"] = 787.5, ["Fly|Ride"] = 813.75, ["Neon"] = 1837.5, ["Neon|Ride"] = 1947.77, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 7393.73, ["Mega|Ride"] = 7481.25, ["Mega|Fly|Ride"] = 6247.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 56.51, ["Neon"] = 3.94, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 60.33, ["Mega"] = 53.18, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 119.16}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.53, ["Ride"] = 38.66, ["Fly|Ride"] = 111.98, ["Neon"] = 33.83, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 100.46, ["Neon|Fly|Ride"] = 258.35, ["Mega"] = 209.26, ["Mega|Ride"] = 351.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 58.97, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 423.94, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 32.11, ["Fly"] = 131.25, ["Ride"] = 39.56, ["Fly|Ride"] = 102.79, ["Neon"] = 103.95, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 349.46, ["Mega"] = 977.19, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 684.25}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.96, ["Ride"] = 26.23, ["Fly|Ride"] = 123.58, ["Neon"] = 103.52, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 328.55, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 447.74}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.1, ["Ride"] = 95.19, ["Neon"] = 65.21, ["Neon|Ride"] = 365.29, ["Mega"] = 290.33, ["Mega|Fly"] = 516.38, ["Mega|Ride"] = 380.84, ["Mega|Fly|Ride"] = 422.4}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.29, ["Ride"] = 91.47, ["Fly|Ride"] = 83.72, ["Neon"] = 177.19, ["Neon|Ride"] = 304.77, ["Neon|Fly|Ride"] = 392.06, ["Mega"] = 924, ["Mega|Ride"] = 728.44}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 39.29}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.28, ["Ride"] = 30.34, ["Fly|Ride"] = 78.75, ["Neon"] = 25.73, ["Neon|Ride"] = 118.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 157.68, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 191.87, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.67, ["Neon"] = 15.7, ["Neon|Ride"] = 43.32, ["Mega"] = 886.58}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 86.19, ["Fly"] = 418.5, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 310.54, ["Neon|Ride"] = 193.96, ["Neon|Fly|Ride"] = 380.75, ["Mega|Ride"] = 1111.28, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.81, ["Fly"] = 21.82, ["Ride"] = 19.66, ["Fly|Ride"] = 35.13, ["Neon"] = 24.94, ["Neon|Fly"] = 69.39, ["Neon|Ride"] = 34.75, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 262.5, ["Mega|Fly"] = 417.46, ["Mega|Ride"] = 199.49, ["Mega|Fly|Ride"] = 228.1}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.64, ["Fly"] = 83.71, ["Ride"] = 24.94, ["Fly|Ride"] = 70.11, ["Neon"] = 28.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 137.82, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 267.89}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 45.94, ["Mega"] = 79.73, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 35.49, ["Fly"] = 65.63, ["Ride"] = 52.5, ["Fly|Ride"] = 120.74, ["Neon"] = 127.33, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 1116.34, ["Mega|Ride"] = 13950.46, ["Mega|Fly|Ride"] = 1305.71}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 3.93, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.81, ["Mega"] = 65.63, ["Mega|Ride"] = 114.53, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.7, ["Ride"] = 83.71, ["Neon"] = 69.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 711.45, ["Mega|Ride"] = 874.12, ["Mega|Fly|Ride"] = 963.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 17.62, ["Fly|Ride"] = 61.6, ["Neon"] = 16.27, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 56.51, ["Mega"] = 144.37, ["Mega|Ride"] = 267.85, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.13, ["Fly"] = 52.49, ["Ride"] = 20.43, ["Fly|Ride"] = 53.26, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 278.32, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.13, ["Ride"] = 37.3, ["Neon"] = 36.23, ["Neon|Ride"] = 142.79, ["Mega"] = 251.11, ["Mega|Ride"] = 840.67, ["Mega|Fly|Ride"] = 217.64}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.16, ["Ride"] = 69.58, ["Neon"] = 140.22, ["Neon|Ride"] = 279.39, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 966, ["Mega|Ride"] = 1613.3, ["Mega|Fly|Ride"] = 1030.32}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.65, ["Ride"] = 78.48, ["Fly|Ride"] = 125.56, ["Neon"] = 95.51, ["Neon|Ride"] = 140.22, ["Mega"] = 411.69, ["Mega|Ride"] = 334.82, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.19, ["Ride"] = 104.99, ["Neon"] = 53.72, ["Mega"] = 627.76, ["Mega|Ride"] = 1007.76, ["Mega|Fly|Ride"] = 1046.25}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 16.74, ["Ride"] = 66.49, ["Fly|Ride"] = 530.08, ["Neon"] = 82.65, ["Neon|Ride"] = 98.37, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 837, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1115.29}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.25, ["Neon"] = 104.99, ["Neon|Ride"] = 279.39, ["Mega"] = 837, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 159.45}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.21, ["Fly|Ride"] = 56.49, ["Neon"] = 3.94, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 23.46, ["Neon|Fly|Ride"] = 73.25, ["Mega"] = 69.06, ["Mega|Ride"] = 83.7, ["Mega|Fly|Ride"] = 119.43}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.34, ["Fly"] = 56.51, ["Ride"] = 56.51, ["Fly|Ride"] = 70.11, ["Neon"] = 31.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.1, ["Mega"] = 191.52, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 397.57}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.7, ["Ride"] = 17.71, ["Fly|Ride"] = 47.61, ["Neon"] = 5.24, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.36, ["Mega"] = 45.02, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.57, ["Ride"] = 28.26, ["Fly|Ride"] = 110.35, ["Neon"] = 17.87, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 111.96, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Ride"] = 32.62, ["Fly|Ride"] = 70.11, ["Neon"] = 37.24, ["Neon|Fly"] = 315, ["Neon|Ride"] = 103.57, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 388.17, ["Mega|Ride"] = 418.5, ["Mega|Fly|Ride"] = 1046.25}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.85, ["Fly"] = 131.25, ["Ride"] = 28.24, ["Fly|Ride"] = 41, ["Neon"] = 13.99, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 104.9, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.41, ["Ride"] = 23.04, ["Fly|Ride"] = 39.38, ["Neon"] = 16.2, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 69.06, ["Mega"] = 168, ["Mega|Ride"] = 231.24, ["Mega|Fly|Ride"] = 444.99}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.02, ["Fly"] = 301.87, ["Ride"] = 43.31, ["Fly|Ride"] = 111.57, ["Neon"] = 15.7, ["Neon|Fly"] = 122.94, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 196.5, ["Mega"] = 79.73, ["Mega|Ride"] = 397.58, ["Mega|Fly|Ride"] = 410.81}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.48, ["Fly"] = 140.14, ["Ride"] = 102.35, ["Fly|Ride"] = 242.81, ["Neon"] = 85.32, ["Neon|Fly"] = 213.94, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 367.5, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 480.29, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.16, ["Ride"] = 97.13, ["Fly|Ride"] = 196.88, ["Neon"] = 249.38, ["Neon|Ride"] = 263.81, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 1150.87, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1113.76}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51, ["Ride"] = 22.61, ["Fly|Ride"] = 65.54, ["Neon"] = 3.2, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 60.69, ["Mega"] = 28.87, ["Mega|Ride"] = 59.64, ["Mega|Fly|Ride"] = 117.8}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 30.31, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 911.54, ["Mega|Ride"] = 835.95, ["Mega|Fly|Ride"] = 1255.5}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 43.32, ["Ride"] = 78.48, ["Neon"] = 282.37, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 522.09, ["Mega"] = 1705.37, ["Mega|Ride"] = 1107.98, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.57, ["Fly"] = 190.32, ["Ride"] = 41.86, ["Fly|Ride"] = 126, ["Neon"] = 64.26, ["Neon|Ride"] = 52.5, ["Mega"] = 525, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.6, ["Ride"] = 110.44, ["Fly|Ride"] = 137.34, ["Neon"] = 4.66, ["Neon|Fly"] = 40.47, ["Neon|Ride"] = 31.97, ["Neon|Fly|Ride"] = 81.62, ["Mega"] = 42.84, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.74, ["Mega|Fly|Ride"] = 109.72}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 30.09, ["Ride"] = 15.75, ["Fly|Ride"] = 41.86, ["Neon"] = 17.79, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 177.19, ["Mega|Fly"] = 349.46, ["Mega|Ride"] = 316.5, ["Mega|Fly|Ride"] = 222.5}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 17.06, ["Fly|Ride"] = 31.67, ["Neon"] = 3.94, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 52.47, ["Mega"] = 32.06, ["Mega|Ride"] = 82.66, ["Mega|Fly|Ride"] = 209.88}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 18.38, ["Fly|Ride"] = 67.77, ["Neon"] = 5.15, ["Neon|Ride"] = 20.77, ["Neon|Fly|Ride"] = 79.73, ["Mega"] = 42.86, ["Mega|Fly"] = 168, ["Mega|Ride"] = 67.83, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 159.45, ["Neon"] = 2.1, ["Neon|Ride"] = 40.47, ["Mega"] = 21, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.05, ["Ride"] = 44.79, ["Neon"] = 36.98, ["Neon|Fly|Ride"] = 207.17, ["Mega"] = 190.38, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 200.51}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.13, ["Ride"] = 37.68, ["Fly|Ride"] = 189.96, ["Neon"] = 9.54, ["Neon|Ride"] = 98.37, ["Neon|Fly|Ride"] = 142.79, ["Mega"] = 397.58, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.84, ["Fly"] = 19.69, ["Ride"] = 21.05, ["Fly|Ride"] = 51.43, ["Neon"] = 32.82, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 90.92, ["Mega"] = 301.88, ["Mega|Ride"] = 339.13, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 76.92, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 334.85, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 414.32, ["Mega|Fly|Ride"] = 1814.18}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.61, ["Fly"] = 72.45, ["Ride"] = 32.82, ["Fly|Ride"] = 79.72, ["Neon"] = 61.91, ["Mega"] = 624.1, ["Mega|Ride"] = 830.82}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.84, ["Ride"] = 18.81, ["Fly|Ride"] = 41.88, ["Neon"] = 2.1, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 23.81, ["Neon|Fly|Ride"] = 57.23, ["Mega"] = 40.82, ["Mega|Ride"] = 64.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.85, ["Ride"] = 15.73, ["Fly|Ride"] = 32.97, ["Neon"] = 4.18, ["Neon|Fly"] = 26.61, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 50.52, ["Mega"] = 41.86, ["Mega|Fly"] = 74.29, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 98.56}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 391.12, ["Ride"] = 404.41, ["Fly|Ride"] = 465.93, ["Neon|Ride"] = 1897.77, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.31, ["Fly"] = 77.43, ["Ride"] = 61.68, ["Fly|Ride"] = 242.37, ["Neon"] = 125.89, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 278995.34}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 33.8, ["Ride"] = 14.93, ["Fly|Ride"] = 39.38, ["Neon"] = 7.84, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 22.79, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 38.96, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 91.87, ["Ride"] = 131.25, ["Fly|Ride"] = 275.63, ["Neon"] = 261.19, ["Neon|Ride"] = 302.74, ["Neon|Fly|Ride"] = 1150.57, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1269.98}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.54, ["Ride"] = 15.64, ["Fly|Ride"] = 57.12, ["Neon"] = 10.56, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 26.02, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 77.59, ["Mega|Fly"] = 125.56, ["Mega|Ride"] = 96.39, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.11, ["Ride"] = 30.09, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.17, ["Mega|Fly"] = 209.26, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 65.63, ["Fly"] = 130.81, ["Ride"] = 86.59, ["Fly|Ride"] = 124.69, ["Neon"] = 157.5, ["Neon|Ride"] = 317.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 654.94, ["Mega|Ride"] = 629.96, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.63, ["Ride"] = 14.97, ["Fly|Ride"] = 52.5, ["Neon"] = 8.34, ["Neon|Ride"] = 26.24, ["Mega"] = 40.59, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 47.46, ["Ride"] = 78.66, ["Fly|Ride"] = 56.44, ["Neon"] = 155.89, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1653.06, ["Mega|Ride"] = 1671.89, ["Mega|Fly|Ride"] = 901.65}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.93, ["Ride"] = 45.94, ["Fly|Ride"] = 159.06, ["Neon"] = 17.2, ["Neon|Ride"] = 278.15, ["Mega"] = 176.1, ["Mega|Ride"] = 159.45, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 70.11, ["Ride"] = 18.84, ["Neon"] = 11.91, ["Neon|Fly"] = 78.49, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 32.16, ["Ride"] = 56.44, ["Fly|Ride"] = 328.02, ["Neon"] = 105, ["Neon|Ride"] = 208.24, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2077.83, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1115.29}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 163.49, ["Ride"] = 65.63, ["Fly|Ride"] = 908.98, ["Neon"] = 5.03, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 161.14, ["Mega"] = 39.38, ["Mega|Fly"] = 197.98, ["Mega|Ride"] = 86.2, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 22.3, ["Fly|Ride"] = 102.87, ["Neon"] = 9.18, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 98.17, ["Mega"] = 209.26, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.13, ["Fly"] = 35.6, ["Ride"] = 28.88, ["Fly|Ride"] = 92.81, ["Neon"] = 48.78, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 341.1, ["Mega|Ride"] = 313.68, ["Mega|Fly|Ride"] = 391.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 39.19, ["Fly"] = 41.27, ["Ride"] = 98.36, ["Fly|Ride"] = 93.19, ["Neon"] = 237.99, ["Neon|Ride"] = 222.52, ["Neon|Fly|Ride"] = 488.6, ["Mega|Ride"] = 1395.69, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 38.36, ["Fly"] = 50.15, ["Ride"] = 28.88, ["Fly|Ride"] = 73.5, ["Neon"] = 104.72, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 156.95, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 52.5, ["Ride"] = 87.93, ["Fly|Ride"] = 210, ["Neon"] = 261.19, ["Neon|Ride"] = 296.4, ["Neon|Fly|Ride"] = 523.14, ["Mega"] = 1155, ["Mega|Ride"] = 1176.53, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.57, ["Fly"] = 140.21, ["Ride"] = 37.49, ["Neon"] = 27.23, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 201.41, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 341.1}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.92, ["Ride"] = 26.36, ["Fly|Ride"] = 78.74, ["Neon"] = 20.58, ["Neon|Ride"] = 50.24, ["Mega"] = 203.43, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.07, ["Fly"] = 65.62, ["Ride"] = 45.05, ["Fly|Ride"] = 98.37, ["Neon"] = 124.64, ["Neon|Ride"] = 137.81, ["Mega"] = 515.82, ["Mega|Ride"] = 697.85, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.65, ["Fly|Ride"] = 32.46, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 60.69, ["Mega"] = 14.94, ["Mega|Fly"] = 79.73, ["Mega|Ride"] = 28.71, ["Mega|Fly|Ride"] = 93.16}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 37.7, ["Fly"] = 220.5, ["Ride"] = 91.87, ["Fly|Ride"] = 277.37, ["Neon"] = 195.44, ["Neon|Fly"] = 2372.11, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1253.39, ["Mega|Ride"] = 975.1, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 17.12, ["Fly|Ride"] = 108.84, ["Neon"] = 4.76, ["Neon|Ride"] = 38.07, ["Mega"] = 55.94, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.44, ["Ride"] = 18.55, ["Fly|Ride"] = 37.13, ["Neon"] = 7.85, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 32.15, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 183.75, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 517.9}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 73.63, ["Ride"] = 154.88, ["Fly|Ride"] = 183.75, ["Neon"] = 341.25, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1048.69, ["Mega|Ride"] = 1217.84, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.73, ["Neon|Ride"] = 52.41, ["Mega"] = 51.17, ["Mega|Ride"] = 1116.34, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 26.1}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 141.25, ["Fly|Ride"] = 102.56, ["Neon"] = 6.2, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 139.97, ["Mega"] = 45.94, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 213.28}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 121.89, ["Ride"] = 181.51, ["Fly|Ride"] = 275.21, ["Neon"] = 538.13, ["Neon|Ride"] = 724.1, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3649.11, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2371.82}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.92, ["Ride"] = 32.82, ["Fly|Ride"] = 54.74, ["Neon"] = 29.74, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 104.64, ["Mega"] = 139.85, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 3.89, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.81, ["Mega|Ride"] = 137.6, ["Mega|Fly|Ride"] = 111.46}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.2, ["Ride"] = 27.2, ["Neon"] = 41.41, ["Neon|Ride"] = 140.22, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 458.27}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.19, ["Fly"] = 42, ["Ride"] = 26.67, ["Fly|Ride"] = 157.49, ["Neon"] = 67.55, ["Neon|Ride"] = 95.16, ["Neon|Fly|Ride"] = 111.96, ["Mega"] = 259.48, ["Mega|Ride"] = 265.76, ["Mega|Fly|Ride"] = 349.46}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 47.6, ["Ride"] = 127.33, ["Fly|Ride"] = 196.88, ["Neon"] = 157.36, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 583.69, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 128.1, ["Fly"] = 167.44, ["Ride"] = 160.5, ["Fly|Ride"] = 210, ["Neon"] = 627.82, ["Neon|Fly"] = 626.79, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 13.94, ["Fly"] = 23.63, ["Ride"] = 26.17, ["Fly|Ride"] = 44.85, ["Neon"] = 173.96, ["Neon|Ride"] = 104.65, ["Neon|Fly|Ride"] = 138.13, ["Mega|Ride"] = 627.76, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.6, ["Fly"] = 131.23, ["Ride"] = 45.14, ["Fly|Ride"] = 90.44, ["Neon"] = 14.04, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 99.74, ["Mega|Ride"] = 182.05, ["Mega|Fly|Ride"] = 349.46}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.57, ["Fly"] = 98.36, ["Ride"] = 48.18, ["Neon"] = 95.2, ["Mega"] = 466.54, ["Mega|Ride"] = 493.78, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42, ["Ride"] = 78.73, ["Fly|Ride"] = 137.82, ["Neon"] = 170.63, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 383.13, ["Mega"] = 962.54, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1014.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.99, ["Ride"] = 85.25, ["Neon"] = 158.9, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 195.66, ["Mega"] = 643.13, ["Mega|Ride"] = 753.3, ["Mega|Fly|Ride"] = 822.35}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 400.72, ["Fly|Ride"] = 682.24, ["Neon"] = 1189.59, ["Neon|Ride"] = 1116.48, ["Mega"] = 4666.22, ["Mega|Fly|Ride"] = 4666.22}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 40.87, ["Ride"] = 39.38, ["Fly|Ride"] = 83.72, ["Neon"] = 167.43, ["Neon|Ride"] = 311.83, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 840, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1023.56}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.69, ["Fly|Ride"] = 70.49, ["Neon"] = 2.63, ["Neon|Ride"] = 18.25, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 39.15, ["Mega|Fly"] = 104.64, ["Mega|Ride"] = 41.04, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.84, ["Ride"] = 279.37, ["Neon"] = 16.47, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 159.45, ["Mega"] = 158.82, ["Mega|Ride"] = 176.1, ["Mega|Fly|Ride"] = 376.65}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.91, ["Fly|Ride"] = 144.16, ["Neon"] = 16.59, ["Neon|Ride"] = 69.07, ["Neon|Fly|Ride"] = 558.71, ["Mega"] = 105, ["Mega|Fly"] = 544.06, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 635.27, ["Ride"] = 400.32, ["Fly|Ride"] = 564.38, ["Neon"] = 1387.72, ["Neon|Ride"] = 1674.19, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 6141.39, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 46.16, ["Ride"] = 17.07, ["Fly|Ride"] = 48.29, ["Neon"] = 17.6, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 63.76, ["Mega"] = 167.99, ["Mega|Ride"] = 271.55, ["Mega|Fly|Ride"] = 191.47}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.96, ["Fly"] = 22.31, ["Ride"] = 23.04, ["Fly|Ride"] = 39.38, ["Neon"] = 28.26, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 129.61, ["Mega"] = 418.5, ["Mega|Ride"] = 697.85, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.95, ["Fly"] = 45, ["Ride"] = 28.26, ["Fly|Ride"] = 119, ["Neon"] = 15.74, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 48.16, ["Neon|Fly|Ride"] = 89.3, ["Mega"] = 195.66, ["Mega|Ride"] = 269.95, ["Mega|Fly|Ride"] = 279.37}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 50.08, ["Fly"] = 65.92, ["Ride"] = 83.71, ["Fly|Ride"] = 61.69, ["Neon"] = 101.88, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 210, ["Mega"] = 939.53, ["Mega|Ride"] = 835.95, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.63, ["Fly"] = 31.43, ["Ride"] = 40.57, ["Fly|Ride"] = 70.11, ["Neon"] = 7.43, ["Neon|Ride"] = 35.6, ["Mega"] = 158.85, ["Mega|Ride"] = 398.96, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.16, ["Fly"] = 104.64, ["Ride"] = 28.26, ["Fly|Ride"] = 85.31, ["Neon"] = 90.68, ["Neon|Ride"] = 154.88, ["Mega|Fly|Ride"] = 731.33}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.05, ["Neon"] = 6.51, ["Neon|Ride"] = 41.85, ["Mega"] = 38.98, ["Mega|Ride"] = 131.84, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.73, ["Ride"] = 98.36, ["Neon"] = 41.88, ["Neon|Ride"] = 103.6, ["Mega"] = 418.46}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.45, ["Ride"] = 78.06, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 308.6, ["Mega|Ride"] = 558.64, ["Mega|Fly|Ride"] = 491.74}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.88, ["Fly"] = 26.16, ["Ride"] = 25.97, ["Fly|Ride"] = 54.18, ["Neon"] = 48.47, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 56.51, ["Neon|Fly|Ride"] = 105, ["Mega"] = 564.96, ["Mega|Ride"] = 411.89, ["Mega|Fly|Ride"] = 409.58}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 192.31, ["Fly"] = 216.57, ["Ride"] = 231.52, ["Fly|Ride"] = 301.88, ["Neon"] = 793.63, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 3766.44}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 56.78, ["Neon"] = 79.65, ["Neon|Fly"] = 79.73, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.61, ["Ride"] = 36.2, ["Fly|Ride"] = 104.91, ["Neon"] = 31.4, ["Neon|Ride"] = 35.31, ["Neon|Fly|Ride"] = 159.45, ["Mega"] = 279.37, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 55.49, ["Fly"] = 140.21, ["Ride"] = 77.44, ["Fly|Ride"] = 418.45, ["Neon"] = 159.02, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 523.14, ["Mega"] = 519.75, ["Mega|Ride"] = 575.45, ["Mega|Fly|Ride"] = 774.22}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 100.22, ["Fly"] = 393.75, ["Ride"] = 268.82, ["Fly|Ride"] = 242.54, ["Neon"] = 580.13, ["Neon|Ride"] = 543.51, ["Neon|Fly|Ride"] = 619.49, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 2086.2}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 31.4, ["Ride"] = 124.68, ["Fly|Ride"] = 321.19, ["Neon"] = 103.6, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 627.76, ["Mega"] = 376.65, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 502.21}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 16.49, ["Fly|Ride"] = 47.23, ["Neon"] = 15.22, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 198.72, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 9.16, ["Ride"] = 48.56, ["Neon"] = 61.85, ["Neon|Ride"] = 237.54, ["Neon|Fly|Ride"] = 237.98, ["Mega"] = 233.14, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 697.85}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 80.27, ["Fly"] = 119.28, ["Ride"] = 104.98, ["Fly|Ride"] = 210, ["Neon"] = 140.44, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 399.68, ["Mega"] = 826.88, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 102.38, ["Neon"] = 8.28, ["Neon|Ride"] = 32.15, ["Neon|Fly|Ride"] = 142.3, ["Mega"] = 44.08, ["Mega|Fly"] = 167.42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 12.56, ["Neon"] = 85.32, ["Neon|Ride"] = 635.38, ["Mega"] = 341.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 918.75, ["Fly"] = 2092.48, ["Ride"] = 1043.43, ["Fly|Ride"] = 958.64, ["Neon"] = 3025.58, ["Neon|Ride"] = 3490.95, ["Neon|Fly|Ride"] = 2478.78, ["Mega|Fly|Ride"] = 10462.32}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 38.27, ["Fly"] = 118.97, ["Ride"] = 107.75, ["Fly|Ride"] = 185.81, ["Neon"] = 231.26, ["Neon|Fly"] = 892.5, ["Mega"] = 974.05, ["Mega|Ride"] = 555.57, ["Mega|Fly|Ride"] = 665.67}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.23, ["Ride"] = 27.21, ["Fly|Ride"] = 80.89, ["Neon"] = 13.01, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.86, ["Mega"] = 80.21, ["Mega|Ride"] = 97.11, ["Mega|Fly|Ride"] = 217.74}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.02, ["Ride"] = 131.22, ["Neon"] = 73.25, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 334.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly|Ride"] = 418.56, ["Neon"] = 2.1, ["Neon|Ride"] = 26.11, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 20.55, ["Mega|Fly"] = 125.56, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 159.45}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 81.25, ["Ride"] = 159.43, ["Fly|Ride"] = 255.94, ["Neon"] = 380.63, ["Neon|Ride"] = 346.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 1100.15, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.02, ["Fly"] = 174.57, ["Ride"] = 28.26, ["Fly|Ride"] = 65.63, ["Neon"] = 23.81, ["Neon|Ride"] = 48.16, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 223.13, ["Mega|Ride"] = 259.48, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 4.29, ["Ride"] = 23.72, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Mega"] = 148.32, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 334.82}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 54.98, ["Ride"] = 81.37, ["Fly|Ride"] = 157.75, ["Neon"] = 204.05, ["Neon|Fly"] = 278.35, ["Neon|Ride"] = 321.25, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 525.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 615.8}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 17.07, ["Ride"] = 58.97, ["Fly|Ride"] = 195.66, ["Neon"] = 222.52, ["Neon|Ride"] = 209.23, ["Neon|Fly|Ride"] = 308.7, ["Mega"] = 553.11, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 64.32, ["Ride"] = 65.63, ["Neon"] = 321.25, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 1313.18, ["Mega"] = 1228.29, ["Mega|Ride"] = 1673.99, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 18.14, ["Ride"] = 64.32, ["Neon"] = 27.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 127.6, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 267.72}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.62, ["Fly"] = 32.05, ["Ride"] = 22.2, ["Fly|Ride"] = 52.5, ["Neon"] = 50.93, ["Neon|Ride"] = 85.02, ["Neon|Fly|Ride"] = 126.35, ["Mega"] = 399, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 128.4, ["Ride"] = 157.96, ["Fly|Ride"] = 256.05, ["Neon"] = 507.94, ["Neon|Ride"] = 572.24, ["Neon|Fly|Ride"] = 510.57, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 36.66, ["Ride"] = 18.25, ["Fly|Ride"] = 50.25, ["Neon"] = 15.74, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 47.61, ["Mega"] = 124.04, ["Mega|Ride"] = 140.15, ["Mega|Fly|Ride"] = 202.99}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.02, ["Fly"] = 37.87, ["Ride"] = 24.83, ["Fly|Ride"] = 78.74, ["Neon"] = 52.41, ["Neon|Fly"] = 292.78, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 300.28, ["Mega|Ride"] = 269.95, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 13.83, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 23.81, ["Mega"] = 20.99, ["Mega|Fly"] = 49.98, ["Mega|Ride"] = 40.47, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.42, ["Neon"] = 3.15, ["Neon|Ride"] = 39.77, ["Neon|Fly|Ride"] = 56.51, ["Mega"] = 22.32, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 140.21}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.2, ["Ride"] = 27.21, ["Fly|Ride"] = 45.94, ["Neon"] = 38.7, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 98.44, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 56.51, ["Ride"] = 84, ["Neon"] = 326.82, ["Neon|Ride"] = 371.47, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 635.36}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.28, ["Fly"] = 18.89, ["Ride"] = 16.67, ["Fly|Ride"] = 32.82, ["Neon"] = 10.4, ["Neon|Fly"] = 36.71, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 51.44, ["Mega"] = 114.07, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 117.93, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.97, ["Fly"] = 25.08, ["Ride"] = 23.44, ["Fly|Ride"] = 59.63, ["Neon"] = 14.33, ["Neon|Fly"] = 36.63, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 82.88, ["Mega"] = 169.31, ["Mega|Fly"] = 305.52, ["Mega|Ride"] = 140.05, ["Mega|Fly|Ride"] = 194.23}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.92, ["Fly"] = 19.68, ["Ride"] = 18.09, ["Fly|Ride"] = 62.79, ["Neon"] = 8.01, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.68, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 123.47, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.65, ["Ride"] = 34.9, ["Neon"] = 62.79, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 98.36, ["Mega"] = 207.81, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 221.73, ["Mega|Fly|Ride"] = 414.32}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.09, ["Fly"] = 162.1, ["Ride"] = 28.26, ["Neon"] = 76.38, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 837}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.24, ["Fly"] = 48.57, ["Ride"] = 20.93, ["Fly|Ride"] = 63, ["Neon"] = 19.56, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 276.23, ["Mega|Ride"] = 190.38, ["Mega|Fly|Ride"] = 604.44}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 18.36, ["Fly|Ride"] = 52.49, ["Neon"] = 11.55, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 48.14, ["Mega"] = 418.5, ["Mega|Ride"] = 237.98, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 234.77, ["Fly"] = 393.75, ["Ride"] = 288.75, ["Fly|Ride"] = 349.5, ["Neon"] = 1200.2, ["Neon|Ride"] = 1113, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Fly|Ride"] = 3836.55}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.72, ["Ride"] = 39.12, ["Neon"] = 21, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.72, ["Ride"] = 19.62, ["Fly|Ride"] = 56.49, ["Neon"] = 22.13, ["Neon|Fly"] = 209.28, ["Neon|Ride"] = 40.82, ["Neon|Fly|Ride"] = 201.79, ["Mega"] = 187.11, ["Mega|Ride"] = 272.04, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 11.04, ["Ride"] = 24.94, ["Neon"] = 45.02, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 627.76, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 431.18}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 15.7, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 19.47, ["Neon|Ride"] = 16.76, ["Neon|Fly|Ride"] = 42, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 41.86, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.13, ["Ride"] = 26.15, ["Fly|Ride"] = 58.7, ["Neon"] = 12.64, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 60.59, ["Mega"] = 116.64, ["Mega|Ride"] = 137.4, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 56.51, ["Fly|Ride"] = 98.98, ["Neon"] = 9.87, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 60.38, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 295.09}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 63.66, ["Fly"] = 98.36, ["Ride"] = 91.88, ["Fly|Ride"] = 144.38, ["Neon"] = 660.27, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 445.1, ["Mega|Ride"] = 3489.2, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.39, ["Fly"] = 85.32, ["Ride"] = 33.49, ["Fly|Ride"] = 65.63, ["Neon"] = 28.26, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 136.84, ["Mega"] = 183.75, ["Mega|Ride"] = 262.49}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 45.04, ["Fly|Ride"] = 118.13, ["Neon"] = 8.36, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 56.44, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 36.75, ["Fly"] = 210, ["Ride"] = 85.32, ["Fly|Ride"] = 194.25, ["Neon"] = 119.81, ["Neon|Ride"] = 202.12, ["Neon|Fly|Ride"] = 313.89, ["Mega"] = 451.5, ["Mega|Ride"] = 583.82, ["Mega|Fly|Ride"] = 700.98}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 15.69, ["Fly|Ride"] = 28.25, ["Neon"] = 2.51, ["Neon|Fly"] = 24.03, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 17.87, ["Mega|Fly"] = 39.87, ["Mega|Ride"] = 32.07, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 60.69, ["Neon|Fly|Ride"] = 83.66, ["Mega"] = 39.76, ["Mega|Ride"] = 81.18, ["Mega|Fly|Ride"] = 219.35}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 58.61, ["Fly|Ride"] = 137.82, ["Neon"] = 8.74, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 184.15, ["Mega"] = 90.55, ["Mega|Ride"] = 209.26}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.75, ["Fly"] = 70.86, ["Ride"] = 65.61, ["Fly|Ride"] = 137.63, ["Neon"] = 26.23, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 101.33, ["Neon|Fly|Ride"] = 235.34, ["Mega"] = 105, ["Mega|Fly"] = 209.22, ["Mega|Ride"] = 246.93, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 15.68, ["Fly|Ride"] = 28.26, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 20.24, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 136.02}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 9.19, ["Ride"] = 56.51, ["Neon"] = 113.45, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 488.6, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 684.25}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2626.32, ["Fly"] = 3150, ["Ride"] = 2800.88, ["Fly|Ride"] = 2625, ["Neon|Fly|Ride"] = 9765.53, ["Mega|Fly|Ride"] = 43418.61}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.98, ["Ride"] = 17.04, ["Fly|Ride"] = 47.38, ["Neon"] = 9.19, ["Neon|Fly"] = 55.23, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 52.02, ["Mega"] = 74.82, ["Mega|Fly"] = 144.39, ["Mega|Ride"] = 98.36, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.92, ["Neon"] = 10.36, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 627.76}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 17.88, ["Ride"] = 26.25, ["Fly|Ride"] = 122.27, ["Neon"] = 94.5, ["Neon|Ride"] = 104.65, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 328.13, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 548.24}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 48.14, ["Ride"] = 98.43, ["Neon"] = 155.06, ["Neon|Ride"] = 412.88, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 540.75, ["Mega|Ride"] = 606.83, ["Mega|Fly|Ride"] = 776.32}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 138.68, ["Fly"] = 1395.69, ["Ride"] = 159.43, ["Fly|Ride"] = 253.25, ["Neon"] = 731.41, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6277.41, ["Mega|Fly|Ride"] = 2644.85}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.64, ["Fly"] = 28.26, ["Ride"] = 45.22, ["Fly|Ride"] = 675.94, ["Neon"] = 59.54, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 195.66, ["Mega|Fly"] = 334.82, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 237.51}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 3.94, ["Ride"] = 62.78, ["Neon"] = 14.96, ["Neon|Fly"] = 98.37, ["Neon|Fly|Ride"] = 523.14, ["Mega"] = 104.79, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 843.82}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.81, ["Fly"] = 101.98, ["Ride"] = 41.2, ["Fly|Ride"] = 196.88, ["Neon"] = 11.82, ["Neon|Ride"] = 102.92, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 73.41, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 237.51}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.98, ["Ride"] = 98.44, ["Neon"] = 167.43, ["Neon|Ride"] = 91.88, ["Mega"] = 374.06, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 687.1}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.11, ["Neon"] = 2.1, ["Neon|Ride"] = 76.12, ["Mega"] = 16.86, ["Mega|Ride"] = 156.18}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 79.42, ["Fly"] = 209.26, ["Ride"] = 98.43, ["Fly|Ride"] = 144.38, ["Neon"] = 522.15, ["Neon|Fly"] = 502.27, ["Neon|Ride"] = 413.33, ["Neon|Fly|Ride"] = 418.46, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 46.05, ["Neon"] = 6.07, ["Neon|Ride"] = 137.67, ["Mega"] = 52.5, ["Mega|Ride"] = 142.79}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 104.41, ["Fly"] = 222.47, ["Ride"] = 90.07, ["Fly|Ride"] = 111.96, ["Neon"] = 210, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 418.5, ["Mega"] = 2625, ["Mega|Ride"] = 2697.28, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.93, ["Fly|Ride"] = 70.03, ["Neon"] = 6.54, ["Neon|Fly"] = 120.35, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 52.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 134.39}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Ride"] = 40.69, ["Neon"] = 10.9, ["Neon|Ride"] = 118.13, ["Mega"] = 56.51, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.9, ["Ride"] = 53.55, ["Fly|Ride"] = 140.21, ["Neon"] = 57.65, ["Neon|Ride"] = 159.45, ["Neon|Fly|Ride"] = 176.31, ["Mega"] = 236.25, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 367.95, ["Fly"] = 558.71, ["Ride"] = 429.43, ["Fly|Ride"] = 544.69, ["Neon"] = 1282.32, ["Neon|Ride"] = 1323, ["Neon|Fly|Ride"] = 1260, ["Mega|Ride"] = 4913.12, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.97, ["Ride"] = 45.92, ["Fly|Ride"] = 104.65, ["Neon"] = 237.57, ["Neon|Fly"] = 317.7, ["Neon|Ride"] = 244.82, ["Neon|Fly|Ride"] = 295.32, ["Mega|Ride"] = 830.72, ["Mega|Fly|Ride"] = 837}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 17.06, ["Fly|Ride"] = 91.88, ["Neon"] = 4.2, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 18.84, ["Neon|Fly|Ride"] = 83.71, ["Mega"] = 46.01, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 195.66}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.47, ["Fly"] = 366.14, ["Ride"] = 52.5, ["Fly|Ride"] = 78.74, ["Neon"] = 51.01, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 198.01, ["Mega"] = 209.93, ["Mega|Fly"] = 389.21, ["Mega|Ride"] = 270.75, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.08, ["Ride"] = 23.12, ["Fly|Ride"] = 265.79, ["Neon"] = 126, ["Neon|Ride"] = 68.24, ["Neon|Fly|Ride"] = 317.69, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 517.9}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.28, ["Neon"] = 14.8, ["Mega"] = 69.56, ["Mega|Ride"] = 150.67, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 86.62, ["Ride"] = 17.14, ["Fly|Ride"] = 57.77, ["Neon"] = 24.95, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 555.65, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 108.23, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 615.57, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 2929.46, ["Mega|Fly|Ride"] = 3486.06}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.66, ["Fly"] = 95.82, ["Ride"] = 115.62, ["Fly|Ride"] = 158.91, ["Neon"] = 144.38, ["Neon|Ride"] = 192.14, ["Mega"] = 722.96, ["Mega|Ride"] = 735.31, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2349.37, ["Ride"] = 2362.5, ["Fly|Ride"] = 2362.5, ["Neon"] = 11161.53, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.51, ["Fly"] = 65625, ["Ride"] = 110.23, ["Fly|Ride"] = 170.63, ["Neon"] = 15, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 195.66, ["Mega"] = 126, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 585.9}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.92, ["Ride"] = 43.96, ["Neon"] = 52.4, ["Neon|Ride"] = 102.56, ["Mega"] = 223.91, ["Mega|Ride"] = 412.55, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.67, ["Fly"] = 1451.14, ["Ride"] = 885.91, ["Fly|Ride"] = 984.38, ["Neon"] = 2324.83, ["Neon|Ride"] = 2968.8, ["Neon|Fly|Ride"] = 2613.19, ["Mega|Fly|Ride"] = 11717.81}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.91, ["Ride"] = 74.23, ["Fly|Ride"] = 91.88, ["Neon"] = 237.54, ["Neon|Ride"] = 291.72, ["Mega"] = 721.91, ["Mega|Ride"] = 722.96, ["Mega|Fly|Ride"] = 685.01}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.07, ["Ride"] = 21.98, ["Fly|Ride"] = 128.15, ["Neon"] = 13.05, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 105, ["Mega|Ride"] = 333.16, ["Mega|Fly|Ride"] = 346.32}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.57, ["Ride"] = 140.21, ["Neon"] = 3.68, ["Neon|Ride"] = 26.19, ["Neon|Fly|Ride"] = 79.73, ["Mega"] = 32.04, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 70.91, ["Ride"] = 126, ["Fly|Ride"] = 317.65, ["Neon"] = 417.52, ["Neon|Fly"] = 404.56, ["Neon|Ride"] = 356.96, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2232.67, ["Mega|Fly|Ride"] = 2697.28}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.91, ["Neon"] = 35.38, ["Neon|Ride"] = 83.72, ["Mega"] = 159.45, ["Mega|Ride"] = 140.21}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.12, ["Ride"] = 97.64, ["Fly|Ride"] = 159.45, ["Neon"] = 341.25, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1986}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.25, ["Fly"] = 104.98, ["Neon"] = 39.29, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 91.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.26, ["Ride"] = 262.5, ["Fly|Ride"] = 324.19, ["Neon"] = 929.63, ["Neon|Ride"] = 761.25, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4183.89}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.61, ["Fly"] = 87.92, ["Ride"] = 28.25, ["Fly|Ride"] = 41.79, ["Neon"] = 53.81, ["Neon|Ride"] = 48.16, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1142.22, ["Mega|Ride"] = 656.24, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 17.03, ["Fly|Ride"] = 39.37, ["Neon"] = 4.58, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 25.45, ["Neon|Fly|Ride"] = 48.56, ["Mega"] = 67.1, ["Mega|Fly"] = 120.33, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 159.45}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 866.25, ["Ride"] = 936.39, ["Fly|Ride"] = 1114.32, ["Neon|Ride"] = 7674.01, ["Neon|Fly|Ride"] = 4743.38, ["Mega"] = 26505.24, ["Mega|Fly|Ride"] = 27899.87}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.74, ["Fly"] = 977.19, ["Ride"] = 56.51, ["Neon"] = 52.31, ["Neon|Ride"] = 78.74, ["Mega"] = 208.16, ["Mega|Ride"] = 270.11, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.16, ["Ride"] = 39.38, ["Fly|Ride"] = 119.3, ["Neon"] = 31.4, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 55.69, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 161.81, ["Mega|Ride"] = 237.35, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.97, ["Fly"] = 35.43, ["Ride"] = 43.22, ["Fly|Ride"] = 66.94, ["Neon"] = 162.17, ["Neon|Ride"] = 157.48, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 2092.48, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 16.7, ["Fly"] = 78.48, ["Ride"] = 27.56, ["Fly|Ride"] = 87.94, ["Neon"] = 64.2, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 367.5, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 434.2}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 24.01, ["Ride"] = 59.07, ["Fly|Ride"] = 110.9, ["Neon"] = 92.26, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 656.24, ["Mega"] = 481.28, ["Mega|Ride"] = 558.71, ["Mega|Fly|Ride"] = 726.1}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Fly|Ride"] = 236.98, ["Neon"] = 3.94, ["Neon|Ride"] = 28.26, ["Mega"] = 15.38, ["Mega|Fly"] = 85.68, ["Mega|Ride"] = 52.33, ["Mega|Fly|Ride"] = 89.07}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 43.71, ["Fly"] = 87.94, ["Ride"] = 58.77, ["Fly|Ride"] = 98.44, ["Neon"] = 339.35, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 308.7, ["Mega"] = 3347.96, ["Mega|Ride"] = 1155.06, ["Mega|Fly|Ride"] = 1055.43}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.26, ["Fly"] = 26.25, ["Ride"] = 27.21, ["Fly|Ride"] = 70.88, ["Neon"] = 28.25, ["Mega"] = 773.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.62, ["Fly"] = 28.25, ["Ride"] = 20.88, ["Fly|Ride"] = 38.05, ["Neon"] = 15.75, ["Neon|Ride"] = 52.98, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 23.63, ["Ride"] = 174.74, ["Neon"] = 104.9, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 292.97, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 33.76, ["Fly"] = 262.39, ["Ride"] = 88.1, ["Fly|Ride"] = 236.24, ["Neon"] = 105, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 321.2, ["Mega"] = 820.63, ["Mega|Ride"] = 931.75, ["Mega|Fly|Ride"] = 677.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.88, ["Neon"] = 27, ["Neon|Ride"] = 73.25, ["Neon|Fly|Ride"] = 121.37, ["Mega"] = 58.11, ["Mega|Fly|Ride"] = 317.69}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.4, ["Neon|Ride"] = 111.98, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 17.06, ["Mega|Ride"] = 50.13, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 19.69, ["Fly|Ride"] = 81.99, ["Neon"] = 2.63, ["Neon|Ride"] = 27.45, ["Mega"] = 25.12, ["Mega|Ride"] = 39.29, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 72.16, ["Fly|Ride"] = 51.65, ["Neon"] = 11.53, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 54.42, ["Mega"] = 61.69, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.51, ["Ride"] = 27.72, ["Fly|Ride"] = 5354.21, ["Neon"] = 13.27, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 58.61, ["Neon"] = 13.81, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 397.04, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.75, ["Ride"] = 150.94, ["Neon"] = 252.26, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1046.25, ["Mega"] = 835.95, ["Mega|Ride"] = 869.76, ["Mega|Fly|Ride"] = 1116.34}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.98, ["Ride"] = 18.84, ["Fly|Ride"] = 44.62, ["Neon"] = 3.84, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 23.72, ["Neon|Fly|Ride"] = 47.61, ["Mega"] = 27.69, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 85.04}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 39.38, ["Ride"] = 44.41, ["Fly|Ride"] = 78.51, ["Neon"] = 697.85, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 393.75, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 303.45}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.62, ["Fly"] = 39.37, ["Ride"] = 27.57, ["Fly|Ride"] = 78.73, ["Neon"] = 82.94, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 93.96, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 1127.85, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 475}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.94, ["Fly"] = 140.44, ["Ride"] = 47.6, ["Neon"] = 47.61, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 413.27}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 17.83, ["Fly|Ride"] = 32.82, ["Neon"] = 3.87, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 46.94, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 111.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 64.24, ["Ride"] = 27.21, ["Neon"] = 19.69, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.32}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Fly"] = 1228.29, ["Ride"] = 1039.49, ["Fly|Ride"] = 986.69, ["Neon"] = 2296.88, ["Neon|Fly"] = 2719.5, ["Neon|Ride"] = 2165.63, ["Neon|Fly|Ride"] = 2295.57, ["Mega|Fly|Ride"] = 6928.69}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 52.49, ["Fly"] = 159.43, ["Ride"] = 114.93, ["Fly|Ride"] = 190.38, ["Neon"] = 369.11, ["Neon|Ride"] = 313.85, ["Neon|Fly|Ride"] = 475, ["Mega"] = 1150.87, ["Mega|Ride"] = 1797.45, ["Mega|Fly|Ride"] = 1081.82}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.6, ["Neon"] = 6.28, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 209.26, ["Mega"] = 72.1, ["Mega|Ride"] = 78.48, ["Mega|Fly|Ride"] = 182.06}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 35.49, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 203.01, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 356.96, ["Mega"] = 1023.75, ["Mega|Ride"] = 1033.69, ["Mega|Fly|Ride"] = 1006.44}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.76, ["Ride"] = 64.87, ["Fly|Ride"] = 156.19, ["Neon"] = 121.03, ["Neon|Ride"] = 214.18, ["Neon|Fly|Ride"] = 278.32, ["Mega"] = 268.55, ["Mega|Ride"] = 285.57, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 244.18, ["Fly"] = 418.5, ["Ride"] = 262.5, ["Fly|Ride"] = 317.65, ["Neon"] = 1158.94, ["Neon|Ride"] = 1115.44, ["Neon|Fly|Ride"] = 1115.62, ["Mega|Fly|Ride"] = 7114.38}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.62, ["Fly"] = 61.76, ["Ride"] = 23.44, ["Fly|Ride"] = 202.64, ["Neon"] = 26.24, ["Neon|Ride"] = 32.15, ["Neon|Fly|Ride"] = 56.51, ["Mega"] = 406.81, ["Mega|Fly"] = 279.37}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 70.11, ["Mega"] = 334.82}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 63.39, ["Fly"] = 140.21, ["Ride"] = 140.21, ["Fly|Ride"] = 167.43, ["Neon"] = 558.77, ["Neon|Ride"] = 397.42, ["Neon|Fly|Ride"] = 237.98, ["Mega"] = 542, ["Mega|Ride"] = 555.57, ["Mega|Fly|Ride"] = 794.11}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 16.72, ["Mega"] = 159.45, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.7, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 23.81, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 30.84, ["Mega|Ride"] = 39.36, ["Mega|Fly|Ride"] = 104.71}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 3937.5, ["Fly|Ride"] = 4283.37, ["Neon"] = 31390.78, ["Neon|Fly|Ride"] = 22844.05, ["Mega|Fly|Ride"] = 69260.51}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.91, ["Ride"] = 56.43, ["Neon"] = 83.71, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 295.09, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 20.86, ["Fly|Ride"] = 46.05, ["Neon"] = 13, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 30.62, ["Neon|Fly|Ride"] = 70.11, ["Mega"] = 144.38, ["Mega|Ride"] = 141.28, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 450.21, ["Fly"] = 840, ["Ride"] = 518.44, ["Fly|Ride"] = 522.37, ["Neon"] = 1371.57, ["Neon|Ride"] = 1464.91, ["Neon|Fly|Ride"] = 1246.87, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.16, ["Ride"] = 19.6, ["Neon"] = 17.06, ["Neon|Ride"] = 145.68, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.11, ["Fly"] = 140.21, ["Ride"] = 52.5, ["Neon"] = 27.23, ["Neon|Ride"] = 279.39, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 416.41, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 558.71}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.34, ["Ride"] = 19.04, ["Neon"] = 4.41, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 39.77, ["Mega|Ride"] = 74.45, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 702.19, ["Fly"] = 767.94, ["Ride"] = 638.86, ["Fly|Ride"] = 682.5, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1745.01}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.71, ["Ride"] = 57.74, ["Neon"] = 29.94, ["Neon|Ride"] = 74.81, ["Neon|Fly|Ride"] = 186.24, ["Mega"] = 115.77, ["Mega|Ride"] = 169.95, ["Mega|Fly|Ride"] = 255.93}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.2, ["Fly"] = 236.15, ["Fly|Ride"] = 131.25, ["Neon"] = 41.56, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 154.21, ["Mega"] = 214.57, ["Mega|Ride"] = 301.39, ["Mega|Fly|Ride"] = 332.71}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 19.69, ["Ride"] = 19.68, ["Fly|Ride"] = 47.24, ["Neon"] = 12.48, ["Neon|Fly"] = 98.36, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 94.17, ["Mega"] = 201.32, ["Mega|Fly"] = 140.21, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21.15, ["Ride"] = 41.57, ["Neon"] = 118.13, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.08, ["Mega"] = 502.21, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 475.94}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.26, ["Neon"] = 3.91, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 39.98, ["Mega|Ride"] = 97.48, ["Mega|Fly|Ride"] = 277.72}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 445.72, ["Ride"] = 472.5, ["Fly|Ride"] = 558.77, ["Neon"] = 2589.57, ["Neon|Ride"] = 2442.21, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 9360.11, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 79.52, ["Neon"] = 9.06, ["Neon|Fly"] = 23.04, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 159.45, ["Mega"] = 69.57, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.41, ["Neon"] = 4.11, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 44.63, ["Mega|Fly"] = 98.36, ["Mega|Ride"] = 140.21, ["Mega|Fly|Ride"] = 209.26}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 22.28, ["Neon"] = 4.59, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 41.06, ["Mega|Fly"] = 154.86, ["Mega|Ride"] = 72.18, ["Mega|Fly|Ride"] = 195.66}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 7.69, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 47.61, ["Mega"] = 105, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 87.9, ["Ride"] = 137.82, ["Fly|Ride"] = 418.5, ["Neon"] = 396.33, ["Neon|Ride"] = 334.85, ["Neon|Fly|Ride"] = 2379.61, ["Mega"] = 1284.99, ["Mega|Ride"] = 2092.48, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 21.05, ["Fly"] = 69.06, ["Ride"] = 103.17, ["Fly|Ride"] = 91.87, ["Neon"] = 100.46, ["Neon|Ride"] = 152.64, ["Mega"] = 463.32, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.77, ["Fly"] = 32.81, ["Ride"] = 16.43, ["Fly|Ride"] = 48.16, ["Neon"] = 32.63, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 396.54, ["Mega|Ride"] = 320.17, ["Mega|Fly|Ride"] = 170.09}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.57, ["Ride"] = 64.32, ["Fly|Ride"] = 99.41, ["Neon"] = 89.25, ["Mega"] = 330.62, ["Mega|Fly|Ride"] = 977.19}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 31.38, ["Fly|Ride"] = 60.61, ["Neon"] = 35.6, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 211.79, ["Mega"] = 177.45, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 544.06}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.59, ["Fly"] = 69.06, ["Ride"] = 19.69, ["Fly|Ride"] = 56.39, ["Neon"] = 249.04, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 322.23, ["Mega"] = 940.58, ["Mega|Ride"] = 951.85, ["Mega|Fly|Ride"] = 767.94}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 31.5, ["Fly"] = 874.13, ["Neon"] = 140.22, ["Neon|Ride"] = 555.66, ["Mega|Ride"] = 317.69}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 47.02, ["Fly"] = 115.5, ["Ride"] = 82.43, ["Fly|Ride"] = 124.69, ["Neon"] = 273, ["Neon|Fly"] = 349.44, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 1682.39, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 49.88, ["Fly"] = 71.31, ["Ride"] = 60.38, ["Neon"] = 131.14, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 596.47, ["Mega|Ride"] = 606.83, ["Mega|Fly|Ride"] = 717.32}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 23.04, ["Fly"] = 57.75, ["Ride"] = 68.25, ["Neon"] = 138.13, ["Mega"] = 697.85, ["Mega|Ride"] = 588.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.86, ["Fly"] = 39.38, ["Ride"] = 42.87, ["Fly|Ride"] = 110.42, ["Neon"] = 73.29, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 151.18, ["Mega"] = 349.46, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.72, ["Ride"] = 15.39, ["Fly|Ride"] = 41.86, ["Neon"] = 4.39, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 62.78, ["Mega"] = 52.86, ["Mega|Fly"] = 209.26, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1737.75}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 25.6, ["Ride"] = 56.51, ["Fly|Ride"] = 167.43, ["Neon"] = 140.22, ["Neon|Ride"] = 196.88, ["Mega"] = 505.35, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 628.49}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Neon"] = 3.65, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 292.97, ["Mega"] = 30.19, ["Mega|Ride"] = 63}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 36.75, ["Fly"] = 118.97, ["Ride"] = 67.82, ["Neon"] = 410.12, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 626.7, ["Mega|Ride"] = 720.85, ["Mega|Fly|Ride"] = 1220.98}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.71, ["Neon|Ride"] = 105, ["Mega"] = 31.5}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 47.61, ["Mega"] = 31.5, ["Mega|Fly"] = 140.21, ["Mega|Ride"] = 136.84, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 114.24, ["Ride"] = 177.87, ["Fly|Ride"] = 226.08, ["Neon"] = 444.62, ["Neon|Ride"] = 458.25, ["Neon|Fly|Ride"] = 533.1, ["Mega|Ride"] = 2253.48, ["Mega|Fly|Ride"] = 2062.02}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 35.58, ["Fly|Ride"] = 73.25, ["Neon"] = 11.91, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 140.21, ["Mega"] = 90.15, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 205.43}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 5.91, ["Neon|Fly"] = 62.79, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 34.13, ["Mega|Ride"] = 117.39, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.2, ["Neon|Ride"] = 37.53, ["Mega"] = 32.71, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.54, ["Neon|Ride"] = 32.03, ["Mega"] = 49.68, ["Mega|Ride"] = 96.55, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 50.23, ["Ride"] = 111.57, ["Fly|Ride"] = 449.61, ["Neon"] = 348.91, ["Neon|Ride"] = 457.28, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1567.28, ["Mega|Ride"] = 1569.37, ["Mega|Fly|Ride"] = 1269.53}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.13, ["Ride"] = 37.3, ["Neon"] = 36.23, ["Neon|Ride"] = 142.79, ["Mega"] = 251.11, ["Mega|Ride"] = 840.67, ["Mega|Fly|Ride"] = 217.64}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 328.12, ["Fly|Ride"] = 523.2, ["Neon"] = 1215.89, ["Neon|Ride"] = 1535.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3459.75}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 73.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 39.38}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.47}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.06}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 8.6}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 191.01}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 34.9}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 28.26}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 16.74}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.51}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 11.75}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.81}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.21}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 7.8}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 493.96}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 726.1}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 12.27}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1568.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 43.32}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.42}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 21}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 18.37}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 52.31}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.73}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.39}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 32.44}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.45}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.19}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.06}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 157.5}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 8.38}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.87}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.93}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1785}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 27.48}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 262.5}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.28}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 13.07}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 11.53}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 183.71}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 41.42}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 31.89}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 10658.04}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 17.85}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.31}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.24}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.48}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.81}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 156.19}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 31.5}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.26}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 16.64}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 17.85}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 320.17}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.02}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.42}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 111.56}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 138.23}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.02}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 11.34}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 14.43}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 22.91}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 56.69}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 102.37}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22659.6}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.68}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 31.77}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 77.44}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 67.37}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 60.68}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 52.49}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 109.65}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.25}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 82.06}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.76}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 12.3}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.91}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.05}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.95}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 80.54}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.71}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.07}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.49}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 245.88}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 2611.88}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.45}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 524.99}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.89}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.36}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 93.21}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 138.65}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 45.7}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 56.7}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.62}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.72}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.4}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.77}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 14.39}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 33.11}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.66}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.19}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.43}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 165.79}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1045.2}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.95}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.46}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.85}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.45}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.54}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.54}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 37.16}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 133.45}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 87.05}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 38.07}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.89}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 17.06}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.75}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 15.7}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 71.03}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.14}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.46}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.86}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.62}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 29.7}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.96}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.16}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.57}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.28}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.23}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.14}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.27}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.64}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 136.5}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 5.97}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.13}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 19.68}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 7.88}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2614.55}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.3}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 42}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 11.3}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.66}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 85.32}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.35}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.24}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.11}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 19.05}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.42}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11.71}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 4.96}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.16}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.23}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.52}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 12.86}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.04}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.47}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 196.87}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.47}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 58.64}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.75}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 140.12}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 21.84}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.56}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.57}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 6.14}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 36.16}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.93}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 15.26}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.4}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 23}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.1}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 5.25}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.7}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.85}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 14.73}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.84}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 22.17}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.75}},
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
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 4.76}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.29}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.51}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 6.43}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 52.5}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 102.46}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.24}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 5.16}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 6.96}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 6.91}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.75}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 7.28}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 16.69}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.87}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 6.57}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 123.38}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1042.13}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.43}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 204.75}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 18.38}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.41}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.55}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.86}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 140.21}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.28}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.37}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 6.57}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.87}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.71}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.08}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 58.94}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.2}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.32}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 103.31}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.82}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 66.46}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.97}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 72.19}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 57.87}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 122.07}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 358.32}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.28}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 104.81}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 101.88}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.5}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.61}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.97}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.55}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 16.21}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.75}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.62}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 40.82}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 17.75}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.85}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 49.66}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.51}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 5.16}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.26}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 223}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.67}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 27.57}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1233.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.34}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.71}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 36.63}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 3.08}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 338.88}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.9}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.85}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.21}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 244.08}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.43}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 12.92}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.81}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 104.45}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 124.69}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 131.24}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.53}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2625}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 354.38}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.94}},
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