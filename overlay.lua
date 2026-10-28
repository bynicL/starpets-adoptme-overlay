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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 813.75, ["Ride"] = 984.38, ["Fly|Ride"] = 1139.2, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 607.18, ["Ride"] = 509.76, ["Fly|Ride"] = 549.54, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2881.45, ["Mega"] = 10290.8, ["Mega|Fly|Ride"] = 9554.37}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4921.88, ["Ride"] = 4593.75, ["Fly|Ride"] = 4723.69, ["Neon|Ride"] = 20719.52, ["Neon|Fly|Ride"] = 16952.94, ["Mega|Fly|Ride"] = 68605.68}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.5, ["Ride"] = 179.19, ["Fly|Ride"] = 398.27, ["Neon"] = 770.82, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1098.05, ["Mega"] = 4116.33, ["Mega|Fly|Ride"] = 3403.18}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 823.28, ["Ride"] = 616.87, ["Fly|Ride"] = 606.81, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.88, ["Ride"] = 27.68, ["Fly|Ride"] = 152.33, ["Neon"] = 56.44, ["Neon|Fly"] = 274.78, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 575.28}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 20.6, ["Ride"] = 31.81, ["Fly|Ride"] = 60.75, ["Neon"] = 29.78, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 46.06, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 162.75, ["Mega|Fly"] = 223.13, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 103.95, ["Ride"] = 147.72, ["Fly|Ride"] = 233.61, ["Neon"] = 521.07, ["Neon|Ride"] = 617.47, ["Neon|Fly|Ride"] = 679.21, ["Mega|Fly|Ride"] = 2662.25}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.6, ["Fly"] = 137.92, ["Ride"] = 41.18, ["Fly|Ride"] = 106.32, ["Neon"] = 252, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 2100, ["Mega|Ride"] = 1386.89, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.27, ["Fly"] = 55.56, ["Ride"] = 36.15, ["Fly|Ride"] = 58.86, ["Neon"] = 1968.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1336.78, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 65.63, ["Fly"] = 206.07, ["Ride"] = 95.87, ["Fly|Ride"] = 169.89, ["Neon"] = 490.06, ["Neon|Fly"] = 398.27, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1543.63}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66.78}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 350.44, ["Fly"] = 395.01, ["Ride"] = 339.49, ["Fly|Ride"] = 359.6, ["Neon"] = 1417.97, ["Neon|Ride"] = 1386.94, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4836.68}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 170.23, ["Ride"] = 131.25, ["Fly|Ride"] = 177.01, ["Neon|Fly"] = 670.37, ["Neon|Fly|Ride"] = 509.4, ["Mega|Fly|Ride"] = 2620.04}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Ride"] = 52.5, ["Fly|Ride"] = 205.83, ["Neon"] = 22.14, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 189, ["Mega"] = 103.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 204.8, ["Mega|Fly|Ride"] = 382.56}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 205.3, ["Ride"] = 150.94, ["Fly|Ride"] = 231.14, ["Neon"] = 924.65, ["Neon|Ride"] = 686.41, ["Neon|Fly|Ride"] = 652.03, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.82, ["Fly"] = 22.51, ["Ride"] = 20.6, ["Fly|Ride"] = 40.6, ["Neon"] = 19.57, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 207.38, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 97.06, ["Fly"] = 144.38, ["Ride"] = 152.16, ["Fly|Ride"] = 245.28, ["Neon"] = 288.75, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 430.17, ["Mega"] = 1509.67, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1132.68}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.97}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 220.23, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1372.81, ["Mega|Fly|Ride"] = 1838.99}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.43, ["Fly"] = 31.21, ["Ride"] = 28.88, ["Fly|Ride"] = 110.12, ["Neon"] = 224.35, ["Neon|Ride"] = 193.49, ["Neon|Fly|Ride"] = 266.56, ["Mega|Ride"] = 579.39, ["Mega|Fly|Ride"] = 1646.54}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.92, ["Fly"] = 123.67, ["Ride"] = 57.05, ["Fly|Ride"] = 136.39, ["Neon"] = 241.34, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1618.02, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 56.44, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 192.45, ["Neon|Fly"] = 383.73, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 370.49, ["Mega"] = 1160.81, ["Mega|Ride"] = 1230.79, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 29.81, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 343.72, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 291.27, ["Mega"] = 821.22, ["Mega|Ride"] = 2056.11, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.92, ["Fly"] = 115.58, ["Ride"] = 62.77, ["Fly|Ride"] = 123.51, ["Neon"] = 227.07, ["Neon|Fly"] = 550.57, ["Neon|Ride"] = 180.09, ["Neon|Fly|Ride"] = 308.61, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.03, ["Fly"] = 31.21, ["Ride"] = 21.3, ["Fly|Ride"] = 52.41, ["Neon"] = 27.81, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 95.96, ["Mega"] = 118.13, ["Mega|Fly"] = 26157.81, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 255.92}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 339.9, ["Ride"] = 411.65, ["Fly|Ride"] = 480.11, ["Neon"] = 1852.36, ["Neon|Ride"] = 1955.26, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7242.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.21, ["Ride"] = 31.26, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 177.01, ["Mega"] = 513.53, ["Mega|Ride"] = 782.12, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.15, ["Fly"] = 31.17, ["Ride"] = 23, ["Fly|Ride"] = 48.54, ["Neon"] = 54.41, ["Neon|Ride"] = 62.12, ["Neon|Fly|Ride"] = 119.33, ["Mega|Ride"] = 308.75, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 91.88, ["Ride"] = 96.75, ["Fly|Ride"] = 131.22, ["Neon"] = 363.93, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.24, ["Mega"] = 3019.34, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1551.86}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.64, ["Ride"] = 23.14, ["Fly|Ride"] = 75.22, ["Neon"] = 154.87, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 479.16, ["Mega|Ride"] = 785.19}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 193.26, ["Fly"] = 347.84, ["Ride"] = 252.45, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 840, ["Mega"] = 6174.49, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2930.83}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.88}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.63, ["Fly"] = 26.91, ["Ride"] = 20.82, ["Fly|Ride"] = 51.42, ["Neon"] = 24.93, ["Neon|Fly"] = 131.77, ["Neon|Ride"] = 53.18, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 159.72, ["Mega|Fly"] = 501.18, ["Mega|Ride"] = 274.78, ["Mega|Fly|Ride"] = 303.6}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.75, ["Fly"] = 2625, ["Ride"] = 787.5, ["Fly|Ride"] = 1123.37, ["Neon"] = 4200, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52007.58, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.45, ["Fly"] = 68.97, ["Ride"] = 26.25, ["Fly|Ride"] = 92.47, ["Neon"] = 91.55, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 227.45, ["Mega"] = 543.37, ["Mega|Ride"] = 697.73, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 216.85, ["Fly|Ride"] = 210, ["Neon"] = 871.64, ["Neon|Ride"] = 770.91, ["Neon|Fly|Ride"] = 932.81, ["Mega|Ride"] = 2466.33, ["Mega|Fly|Ride"] = 3019.34}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 27.81}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.82, ["Fly"] = 68.85, ["Ride"] = 52.29, ["Fly|Ride"] = 137.92, ["Neon"] = 82.41, ["Neon|Ride"] = 201.12, ["Neon|Fly|Ride"] = 164.67, ["Mega"] = 670.9, ["Mega|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 724.65}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 116.82, ["Ride"] = 127.32, ["Fly|Ride"] = 233.71, ["Neon"] = 587.07, ["Neon|Ride"] = 290.07, ["Neon|Fly|Ride"] = 586.59, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 152.15, ["Ride"] = 203.6, ["Fly|Ride"] = 272.85, ["Neon"] = 389.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 1595.09, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 2058.17}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.44}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.41, ["Fly"] = 61.35, ["Ride"] = 55.26, ["Fly|Ride"] = 85.67, ["Neon|Ride"] = 369.87, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 4116.33, ["Mega|Fly|Ride"] = 1518.57}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 3.94, ["Fly"] = 55.59, ["Ride"] = 41.08, ["Fly|Ride"] = 131.25, ["Neon"] = 41.18, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 231.56, ["Mega"] = 167.75, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 321.08, ["Mega|Fly|Ride"] = 409.15}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 473.82, ["Fly"] = 590.63, ["Ride"] = 465.52, ["Fly|Ride"] = 485.62, ["Neon|Ride"] = 1737.1, ["Neon|Fly|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 6470.63}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 82.69, ["Fly"] = 161.8, ["Ride"] = 117.33, ["Fly|Ride"] = 144.38, ["Neon"] = 446.25, ["Neon|Fly"] = 823.28, ["Neon|Ride"] = 573.28, ["Neon|Fly|Ride"] = 440.46, ["Mega|Ride"] = 2468.78, ["Mega|Fly|Ride"] = 2291.78}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3513.29, ["Ride"] = 3432, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14406.1}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.36, ["Fly"] = 110.12, ["Ride"] = 59.72, ["Fly|Ride"] = 128.41, ["Neon"] = 393.75, ["Neon|Ride"] = 582.64, ["Neon|Fly|Ride"] = 308.75, ["Mega|Ride"] = 1181.4, ["Mega|Fly|Ride"] = 1221.53}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 68.97, ["Fly|Ride"] = 173.36, ["Neon"] = 410.42, ["Neon|Ride"] = 617.19, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2744.57, ["Mega|Ride"] = 2607.7, ["Mega|Fly|Ride"] = 2773.76}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 37.62, ["Fly"] = 61.82, ["Ride"] = 45.83, ["Fly|Ride"] = 107.63, ["Neon"] = 130.28, ["Neon|Fly"] = 195.54, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 961.17, ["Mega|Ride"] = 686.41, ["Mega|Fly|Ride"] = 654.84}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.46}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.25, ["Fly"] = 41.18, ["Ride"] = 59.09, ["Fly|Ride"] = 64.29, ["Neon"] = 262.5, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1098.05}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.96}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 137.92, ["Ride"] = 221.82, ["Fly|Ride"] = 314.91, ["Neon|Fly|Ride"] = 1372.81, ["Mega|Fly|Ride"] = 4931.49}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1029.09, ["Ride"] = 1034.25, ["Fly|Ride"] = 1053.94, ["Neon"] = 2625, ["Neon|Ride"] = 3854.53, ["Neon|Fly|Ride"] = 3018.74, ["Mega|Fly|Ride"] = 13378.04}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 24.94, ["Fly"] = 68.99, ["Ride"] = 43.22, ["Fly|Ride"] = 62.15, ["Neon"] = 160.78, ["Neon|Ride"] = 148.45, ["Neon|Fly|Ride"] = 196.54, ["Mega|Ride"] = 787.08, ["Mega|Fly|Ride"] = 926.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6297.98, ["Fly|Ride"] = 4610.82, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40065.48}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.39, ["Fly"] = 52.41, ["Ride"] = 23.79, ["Fly|Ride"] = 54.56, ["Neon"] = 132.57, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 787.5, ["Mega|Ride"] = 585.98, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.13, ["Fly"] = 41.18, ["Ride"] = 39.38, ["Fly|Ride"] = 114.42, ["Neon"] = 65.63, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 247, ["Mega"] = 1028.61, ["Mega|Ride"] = 645.25, ["Mega|Fly|Ride"] = 1026.01}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.4, ["Fly"] = 273.81, ["Ride"] = 91.85, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 381.81, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4116.33}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.22, ["Fly"] = 150.93, ["Ride"] = 35.44, ["Fly|Ride"] = 138.94, ["Neon"] = 74.87, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 152.33, ["Mega"] = 1372.81, ["Mega|Ride"] = 501.18, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.75, ["Fly"] = 2278.39, ["Ride"] = 1968.75, ["Fly|Ride"] = 1778.44, ["Neon|Fly|Ride"] = 3430.35, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 28814.24, ["Fly|Ride"] = 25856.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68605.68, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21.76, ["Fly"] = 393.74, ["Ride"] = 52.5, ["Fly|Ride"] = 124.69, ["Neon"] = 45.08, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 961.17, ["Mega|Ride"] = 1309, ["Mega|Fly|Ride"] = 819.16}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 82.34, ["Ride"] = 41.18, ["Fly|Ride"] = 129.94, ["Neon"] = 20.31, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 66.39, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 124.69, ["Mega|Fly"] = 179.07, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.51}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.57, ["Ride"] = 44.26, ["Fly|Ride"] = 125.25, ["Neon"] = 62.42, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.1, ["Mega"] = 3120.47, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 768.51, ["Ride"] = 719.25, ["Fly|Ride"] = 825.57, ["Neon|Fly|Ride"] = 2810.87, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 953.97, ["Fly"] = 1076.25, ["Ride"] = 971.25, ["Fly|Ride"] = 935.55, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11387.81}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 22.67, ["Fly"] = 115.58, ["Ride"] = 36.75, ["Fly|Ride"] = 86.63, ["Neon"] = 140.44, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.68, ["Fly"] = 92.47, ["Ride"] = 72.68, ["Fly|Ride"] = 118.43, ["Neon"] = 411.65, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 409.59, ["Mega|Ride"] = 2014.95, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 61.17, ["Ride"] = 65.63, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2073.83, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.63, ["Fly"] = 44.63, ["Ride"] = 20.01, ["Fly|Ride"] = 52.14, ["Neon"] = 61.68, ["Neon|Fly"] = 525, ["Neon|Ride"] = 68.21, ["Neon|Fly|Ride"] = 132.54, ["Mega"] = 288.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 110.25, ["Fly"] = 143.07, ["Ride"] = 118.01, ["Fly|Ride"] = 173.92, ["Neon|Ride"] = 450.22, ["Neon|Fly|Ride"] = 389.71, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.19, ["Ride"] = 47.36, ["Fly|Ride"] = 110.12, ["Neon"] = 43.23, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 479.57, ["Mega"] = 157.5, ["Mega|Ride"] = 377.69, ["Mega|Fly|Ride"] = 521.76}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.76, ["Fly"] = 41.22, ["Ride"] = 26.25, ["Fly|Ride"] = 87.85, ["Neon"] = 84, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 137.92, ["Mega|Fly|Ride"] = 755.36}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.23, ["Ride"] = 55.59, ["Fly|Ride"] = 156.19, ["Neon"] = 262.43, ["Neon|Ride"] = 329.32, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 693.46, ["Mega|Ride"] = 770.87, ["Mega|Fly|Ride"] = 892.23}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.94, ["Fly"] = 145.58, ["Ride"] = 28.88, ["Fly|Ride"] = 69.56, ["Neon"] = 71.07, ["Neon|Ride"] = 108.66, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 823.28, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7166.08, ["Ride"] = 7141.32, ["Fly|Ride"] = 6750.78, ["Neon"] = 30872.4, ["Neon|Fly|Ride"] = 27291.22}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.25, ["Fly"] = 274.78, ["Ride"] = 247, ["Fly|Ride"] = 272.27, ["Neon|Ride"] = 686.41, ["Neon|Fly|Ride"] = 570.94, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.56, ["Fly"] = 150.94, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 90.55, ["Neon|Fly"] = 204.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 393.64, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 85.53, ["Ride"] = 23.69, ["Fly|Ride"] = 105.18, ["Neon"] = 23.98, ["Neon|Fly"] = 49.41, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 187.3, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.49, ["Fly"] = 5238.36, ["Ride"] = 94.5, ["Fly|Ride"] = 195.59, ["Neon"] = 199.11, ["Neon|Fly"] = 357.1, ["Neon|Ride"] = 231.53, ["Neon|Fly|Ride"] = 335, ["Mega"] = 445.75, ["Mega|Ride"] = 535.26, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14385, ["Ride"] = 13387.5, ["Fly|Ride"] = 12599.9, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 170.52, ["Ride"] = 262.5, ["Fly|Ride"] = 371.43, ["Neon"] = 1496.3, ["Neon|Ride"] = 1440.73, ["Neon|Fly|Ride"] = 1440.73, ["Mega|Fly|Ride"] = 5118.66}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 56.85, ["Fly"] = 118.83, ["Ride"] = 73.98, ["Fly|Ride"] = 90.02, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2570.66}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.83, ["Fly"] = 43.93, ["Ride"] = 23.63, ["Fly|Ride"] = 55.55, ["Neon"] = 86.45, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 229.69, ["Mega|Ride"] = 343.72, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.16, ["Ride"] = 393.75, ["Fly|Ride"] = 562.92, ["Neon"] = 1646.54, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.84, ["Fly"] = 101.53, ["Ride"] = 34.43, ["Fly|Ride"] = 84.96, ["Neon"] = 26.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 273.75, ["Mega"] = 129.93, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 131.25, ["Fly"] = 205.83, ["Ride"] = 168.78, ["Fly|Ride"] = 232.78, ["Neon"] = 549.54, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2515.45}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.11, ["Fly"] = 20.6, ["Ride"] = 18.05, ["Fly|Ride"] = 41.18, ["Neon|Ride"] = 96.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 874.13}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.72, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 549.54, ["Neon|Ride"] = 411.65, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1541.74}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14, ["Fly"] = 101.9, ["Ride"] = 36.75, ["Fly|Ride"] = 96.75, ["Neon"] = 102.93, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 1027.04, ["Mega|Ride"] = 616.44, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.08}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 39.37, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 249.38, ["Neon"] = 208.69, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1098.05, ["Mega|Ride"] = 959.12, ["Mega|Fly|Ride"] = 1152.58}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 131.76, ["Neon"] = 23.61, ["Neon|Ride"] = 104.04, ["Neon|Fly|Ride"] = 267.58, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.22, ["Fly"] = 47.25, ["Ride"] = 36.03, ["Fly|Ride"] = 92.19, ["Neon"] = 119.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 171.86, ["Mega|Ride"] = 588.66, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 549.54, ["Ride"] = 452.61, ["Fly|Ride"] = 539.44, ["Neon|Fly|Ride"] = 2737.37, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.25, ["Fly"] = 102.93, ["Ride"] = 54.88, ["Fly|Ride"] = 65.63, ["Neon"] = 233.61, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 306.68, ["Mega"] = 1011.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 892.23}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.73, ["Fly"] = 117.49, ["Ride"] = 83.16, ["Fly|Ride"] = 131.25, ["Neon"] = 453.84, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 720.37, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 25.46, ["Fly"] = 76.33, ["Ride"] = 71.77, ["Fly|Ride"] = 131.25, ["Neon"] = 170.63, ["Neon|Ride"] = 231.17, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 414.74, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13251.31, ["Fly|Ride"] = 7999.59, ["Neon|Fly|Ride"] = 14173.69, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.27, ["Fly"] = 1848.98, ["Ride"] = 1561.25, ["Fly|Ride"] = 1470, ["Neon"] = 5316.59, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 525, ["Ride"] = 519.75, ["Fly|Ride"] = 525, ["Neon"] = 2263.98, ["Neon|Fly|Ride"] = 2366.9, ["Mega|Fly|Ride"] = 6724.03}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.7, ["Fly"] = 27.81, ["Ride"] = 20.35, ["Fly|Ride"] = 44.63, ["Neon"] = 110.12, ["Neon|Ride"] = 101.73, ["Neon|Fly|Ride"] = 124.55, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.94, ["Fly"] = 78.74, ["Ride"] = 32.18, ["Fly|Ride"] = 77.19, ["Neon"] = 23.87, ["Neon|Ride"] = 76.11, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 143.06, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 343.72}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 60.76, ["Ride"] = 50.18, ["Fly|Ride"] = 91.68, ["Neon"] = 520.11, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 164.22, ["Mega|Fly|Ride"] = 511.77}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 26.77, ["Ride"] = 15.75, ["Fly|Ride"] = 43.34, ["Neon"] = 26.77, ["Neon|Fly"] = 39.12, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 686.41}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.69, ["Fly"] = 320.25, ["Ride"] = 262.5, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1345.02, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.37, ["Fly"] = 82.34, ["Ride"] = 31.49, ["Fly|Ride"] = 76.48, ["Neon"] = 123.51, ["Neon|Fly"] = 407.52, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 480.59, ["Mega|Ride"] = 524.9, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.24, ["Fly"] = 18.37, ["Ride"] = 20.4, ["Fly|Ride"] = 43.83, ["Neon"] = 80.91, ["Neon|Fly"] = 131.77, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 106.6, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 462.34, ["Fly"] = 787.5, ["Ride"] = 435.75, ["Fly|Ride"] = 686.41, ["Neon|Ride"] = 2881.45, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1169.44, ["Fly"] = 1386.99, ["Ride"] = 1154.99, ["Fly|Ride"] = 1302, ["Neon"] = 4802.74, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 97.78, ["Fly"] = 129.68, ["Ride"] = 101.73, ["Fly|Ride"] = 108.65, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 164.67, ["Fly"] = 163.72, ["Ride"] = 169.32, ["Fly|Ride"] = 272.35, ["Neon"] = 577.5, ["Neon|Fly"] = 686.41, ["Neon|Ride"] = 693.48, ["Neon|Fly|Ride"] = 706.04, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2466.33}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.46, ["Ride"] = 72.05, ["Fly|Ride"] = 118.58, ["Neon"] = 244.76, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 384.89, ["Mega|Ride"] = 2058.17, ["Mega|Fly|Ride"] = 837.68}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 124.69, ["Ride"] = 273, ["Fly|Ride"] = 137.82, ["Neon|Fly|Ride"] = 1294.49, ["Mega|Fly|Ride"] = 3293.07}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Fly"] = 2332.94, ["Ride"] = 2483.25, ["Fly|Ride"] = 2466.11, ["Neon|Fly|Ride"] = 10290.8, ["Mega|Fly|Ride"] = 24656.22}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 70.18, ["Ride"] = 68.97, ["Fly|Ride"] = 196.88, ["Neon"] = 349.91, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2263.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 623.7, ["Fly"] = 616.88, ["Ride"] = 629.9, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1515.24, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3267.73}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.27, ["Fly"] = 64.21, ["Ride"] = 57.66, ["Fly|Ride"] = 101.72, ["Neon|Ride"] = 358.31, ["Neon|Fly|Ride"] = 274.78, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.24, ["Fly|Ride"] = 47.46, ["Neon"] = 24.93, ["Neon|Fly"] = 154.88, ["Neon|Ride"] = 44.4, ["Neon|Fly|Ride"] = 92.61, ["Mega"] = 144.32, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 1502.45, ["Mega|Ride"] = 1372.81, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 833.43, ["Fly"] = 1011.35, ["Ride"] = 822.94, ["Fly|Ride"] = 890.29, ["Neon|Ride"] = 2469.8, ["Neon|Fly|Ride"] = 2301.16, ["Mega|Fly|Ride"] = 9193.82}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 623.7, ["Ride"] = 645.74, ["Fly|Ride"] = 768.74, ["Neon|Fly|Ride"] = 4107.07}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.3, ["Fly"] = 26.25, ["Ride"] = 23.14, ["Fly|Ride"] = 43.63, ["Neon"] = 185.26, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 138.03, ["Mega"] = 786.19, ["Mega|Ride"] = 686.41, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.9, ["Ride"] = 23.63, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 506.33, ["Mega|Ride"] = 506.33, ["Mega|Fly|Ride"] = 452.81}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 2.63, ["Ride"] = 24.93, ["Fly|Ride"] = 111.57, ["Neon"] = 22.08, ["Neon|Fly"] = 308.61, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 152.33, ["Mega"] = 161.43, ["Mega|Fly"] = 524.72, ["Mega|Ride"] = 238.6, ["Mega|Fly|Ride"] = 303.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 47.02, ["Fly"] = 107.04, ["Ride"] = 52.4, ["Fly|Ride"] = 104.31, ["Neon"] = 146.78, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 246.75, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 509.4, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 1234.91, ["Mega|Ride"] = 1543.63, ["Mega|Fly|Ride"] = 1370.75}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.13, ["Fly"] = 56.04, ["Ride"] = 34.04, ["Fly|Ride"] = 78.75, ["Neon"] = 78.75, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.45, ["Fly"] = 56.01, ["Ride"] = 47.29, ["Fly|Ride"] = 85.32, ["Neon"] = 549.54, ["Neon|Ride"] = 198.19, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 961.17, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.24, ["Fly"] = 27.81, ["Ride"] = 17.07, ["Fly|Ride"] = 40.58, ["Neon"] = 26.65, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 274.78, ["Mega|Fly|Ride"] = 314.91}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.38, ["Fly"] = 36.21, ["Ride"] = 23.63, ["Fly|Ride"] = 84.96, ["Neon"] = 25.97, ["Neon|Fly"] = 138.94, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 162.61, ["Mega"] = 293.25, ["Mega|Ride"] = 302.3, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 53.52, ["Fly"] = 65.62, ["Ride"] = 59.11, ["Fly|Ride"] = 97.47, ["Neon"] = 401.02, ["Neon|Ride"] = 220.35, ["Neon|Fly|Ride"] = 207.37, ["Mega|Fly|Ride"] = 1019.29}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1616.67, ["Fly"] = 1575, ["Ride"] = 1391.25, ["Fly|Ride"] = 1443.74, ["Neon|Fly"] = 4680.9, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 13098.99}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 604.36, ["Neon|Ride"] = 3019.34, ["Neon|Fly|Ride"] = 3002.87, ["Mega|Fly|Ride"] = 9603.39}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 249.37, ["Fly"] = 301.88, ["Ride"] = 312.43, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1571.88, ["Neon|Fly|Ride"] = 1496.3, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 35.11}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.6, ["Ride"] = 43.1, ["Fly|Ride"] = 96.75, ["Neon"] = 328.2, ["Neon|Fly"] = 411.65, ["Neon|Ride"] = 351.96, ["Neon|Fly|Ride"] = 315.94, ["Mega"] = 1233.17, ["Mega|Ride"] = 961.17, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41163.2, ["Fly"] = 65625, ["Ride"] = 34668.1, ["Fly|Ride"] = 17977.32, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 328.13, ["Fly"] = 360.94, ["Ride"] = 368.82, ["Fly|Ride"] = 387.19, ["Neon"] = 1370.75, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6174.49, ["Mega|Fly|Ride"] = 3858.74}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 143.93, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4116.33}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 109.82, ["Fly"] = 262.49, ["Ride"] = 122.8, ["Fly|Ride"] = 196.87, ["Neon|Ride"] = 462.33, ["Neon|Fly|Ride"] = 800.64, ["Mega"] = 7547.28, ["Mega|Fly|Ride"] = 1660.95}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.44, ["Fly"] = 94.5, ["Ride"] = 39.38, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 686.41, ["Mega|Ride"] = 600.99, ["Mega|Fly|Ride"] = 617.47}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4939.6, ["Ride"] = 4930.97, ["Fly|Ride"] = 4171.13, ["Neon"] = 20444.74, ["Neon|Fly|Ride"] = 27442.49, ["Mega|Fly|Ride"] = 61639.38}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 25.65, ["Fly"] = 31.5, ["Ride"] = 31.5, ["Fly|Ride"] = 55.12, ["Neon"] = 228.46, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1372.81, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.32, ["Fly"] = 137.92, ["Ride"] = 45.92, ["Fly|Ride"] = 101.07, ["Neon"] = 343.72, ["Neon|Ride"] = 267.58, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 766.45, ["Fly"] = 918.75, ["Ride"] = 853.12, ["Fly|Ride"] = 884.01, ["Neon"] = 2362.49, ["Neon|Ride"] = 2231.24, ["Neon|Fly|Ride"] = 2362.49, ["Mega"] = 9042.54, ["Mega|Fly|Ride"] = 7821.02}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.02, ["Fly"] = 33.9, ["Ride"] = 24.89, ["Fly|Ride"] = 39.38, ["Neon"] = 131.25, ["Neon|Fly"] = 154.88, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 154.44, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.58, ["Fly"] = 96.75, ["Ride"] = 30.87, ["Fly|Ride"] = 462.27, ["Neon"] = 80.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 128.64, ["Mega|Ride"] = 521.76, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 87.83, ["Ride"] = 128.62, ["Fly|Ride"] = 262.5, ["Neon"] = 472.5, ["Neon|Ride"] = 530.66, ["Neon|Fly|Ride"] = 604.09, ["Mega|Fly|Ride"] = 2401.88}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 21.07, ["Fly"] = 85.32, ["Ride"] = 61.8, ["Fly|Ride"] = 135.26, ["Neon"] = 81.31, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 271.69, ["Mega"] = 275.63, ["Mega|Fly"] = 733.9, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3871.88, ["Ride"] = 4313.95, ["Fly|Ride"] = 3655.32, ["Neon|Ride"] = 11800.47, ["Neon|Fly|Ride"] = 9579.94, ["Mega"] = 61742.75, ["Mega|Fly|Ride"] = 32657.86}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 65.33, ["Fly|Ride"] = 135.95, ["Neon"] = 220.43, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 411.65, ["Mega|Ride"] = 1028.06, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 6622.88, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 67802.85}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.35, ["Fly|Ride"] = 41.18, ["Neon"] = 19.69, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 76.11, ["Mega"] = 447.28, ["Mega|Fly|Ride"] = 362.92}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 21.76, ["Fly"] = 26.15, ["Ride"] = 24.94, ["Fly|Ride"] = 55.59, ["Neon"] = 137.92, ["Neon|Ride"] = 191.42, ["Neon|Fly|Ride"] = 137.92, ["Mega|Ride"] = 961.17, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.8, ["Fly"] = 39.38, ["Ride"] = 35.42, ["Fly|Ride"] = 115.5, ["Neon"] = 183.75, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 171.87, ["Mega"] = 770.87, ["Mega|Ride"] = 961.17, ["Mega|Fly|Ride"] = 748.89}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 31.06, ["Fly"] = 190.37, ["Ride"] = 39.38, ["Fly|Ride"] = 150.26, ["Neon"] = 195.54, ["Neon|Ride"] = 124.53, ["Neon|Fly|Ride"] = 294.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.25, ["Fly"] = 23.55, ["Ride"] = 24.61, ["Fly|Ride"] = 39.38, ["Neon"] = 82.34, ["Neon|Ride"] = 114.23, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 728.44, ["Mega|Ride"] = 576.73, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8335.57}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.89}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 118.13, ["Ride"] = 196.87, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1029.09}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.5, ["Fly"] = 123.51, ["Ride"] = 43.82, ["Fly|Ride"] = 105, ["Neon"] = 61.77, ["Neon|Ride"] = 109.94, ["Neon|Fly|Ride"] = 204.8, ["Mega"] = 406.5, ["Mega|Ride"] = 924.59, ["Mega|Fly|Ride"] = 953.97}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.46}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 62.42, ["Neon"] = 59.07, ["Neon|Ride"] = 96.75, ["Mega|Fly|Ride"] = 823.28}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.56}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 155.93, ["Fly"] = 411.65, ["Ride"] = 205.44, ["Fly|Ride"] = 183.75, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 946.78, ["Mega|Ride"] = 3156.21, ["Mega|Fly|Ride"] = 3019.34}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 96.75, ["Ride"] = 129.94, ["Fly|Ride"] = 211.32, ["Neon"] = 607.35, ["Neon|Ride"] = 684.87, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 3293.07, ["Mega|Fly|Ride"] = 3082.33}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.5, ["Fly"] = 186.62, ["Ride"] = 204.8, ["Fly|Ride"] = 210, ["Neon"] = 897.75, ["Neon|Ride"] = 1029.09, ["Neon|Fly|Ride"] = 993.57, ["Mega|Fly|Ride"] = 3982.13}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1949.1, ["Fly"] = 2469.8, ["Ride"] = 1443.75, ["Fly|Ride"] = 1443.75, ["Neon"] = 6605.27, ["Neon|Ride"] = 6584.07, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 33903.17}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 96.75, ["Ride"] = 39.38, ["Fly|Ride"] = 93.66, ["Neon"] = 155.4, ["Neon|Fly"] = 115.59, ["Neon|Ride"] = 203.78, ["Neon|Fly|Ride"] = 220.23, ["Mega"] = 925.16, ["Mega|Ride"] = 895.31, ["Mega|Fly|Ride"] = 1784.44}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 796.73, ["Fly"] = 2100, ["Ride"] = 678.53, ["Fly|Ride"] = 885.02, ["Neon|Ride"] = 2620.16, ["Neon|Fly|Ride"] = 4007.09}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 38.66}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.48, ["Ride"] = 48.47, ["Fly|Ride"] = 137.92, ["Neon"] = 99.75, ["Neon|Ride"] = 123.51, ["Neon|Fly|Ride"] = 273.75, ["Mega"] = 464.63, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.88, ["Fly"] = 48.38, ["Ride"] = 26.46, ["Fly|Ride"] = 70.16, ["Neon"] = 62.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 110.12, ["Mega"] = 918.75, ["Mega|Ride"] = 343.72, ["Mega|Fly|Ride"] = 354.82}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.11}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.71, ["Fly"] = 108.92, ["Ride"] = 34.69, ["Fly|Ride"] = 55.59, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 823.28, ["Mega|Fly|Ride"] = 1386.89}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 54.71, ["Neon|Ride"] = 401.36, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 823.28, ["Mega|Ride"] = 1733.61, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10977.21, ["Ride"] = 4987.5, ["Fly|Ride"] = 5049.19, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.65, ["Fly"] = 55.01, ["Ride"] = 35.35, ["Fly|Ride"] = 104.97, ["Neon"] = 77.44, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 162.61, ["Mega"] = 517.78, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.3}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 123.51, ["Fly"] = 364.31, ["Ride"] = 134.89, ["Fly|Ride"] = 170.63, ["Neon"] = 485.63, ["Neon|Ride"] = 462.33, ["Neon|Fly|Ride"] = 722.44, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1849.17}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 49.87, ["Fly"] = 108.64, ["Ride"] = 93.47, ["Fly|Ride"] = 196.88, ["Neon"] = 259.88, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 2311.46, ["Mega|Ride"] = 2778.53, ["Mega|Fly|Ride"] = 1633.16}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 26, ["Fly"] = 70.46, ["Ride"] = 29.33, ["Fly|Ride"] = 70.35, ["Neon"] = 201.71, ["Neon|Ride"] = 123.51, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 1016.21, ["Mega|Ride"] = 817.11, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 68.97, ["Ride"] = 27.57, ["Fly|Ride"] = 59.07, ["Neon"] = 36.27, ["Neon|Ride"] = 85.55, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 118.13, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 223.07, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.34, ["Fly"] = 137.92, ["Ride"] = 31.23, ["Fly|Ride"] = 64.97, ["Neon"] = 102.93, ["Neon|Ride"] = 123.68, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 716.57, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.38, ["Fly"] = 26.17, ["Ride"] = 21, ["Fly|Ride"] = 50.74, ["Neon"] = 203.78, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 218.67}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 29.86, ["Ride"] = 175.06, ["Neon"] = 137.92, ["Neon|Ride"] = 823.28, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 823.28, ["Mega|Fly|Ride"] = 783.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 220.92, ["Fly"] = 462.26, ["Ride"] = 443.63, ["Fly|Ride"] = 1541.61, ["Neon"] = 1234.91}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.86, ["Fly"] = 212.02, ["Ride"] = 78.75, ["Fly|Ride"] = 200.68, ["Neon"] = 220.23, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 480.88, ["Mega"] = 905.62, ["Mega|Ride"] = 2142.73, ["Mega|Fly|Ride"] = 1181.4}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1152.15, ["Ride"] = 917.44, ["Fly|Ride"] = 1018.5, ["Neon|Fly"] = 3998.99, ["Neon|Ride"] = 3128.42, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 343.72, ["Fly"] = 462.26, ["Ride"] = 378, ["Fly|Ride"] = 481.35, ["Neon"] = 2862.9, ["Neon|Ride"] = 1234.91, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 8129.75, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 62.36}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.76, ["Fly"] = 55.38, ["Ride"] = 23.69, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 115.59, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 686.41, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.39, ["Fly"] = 411.65, ["Ride"] = 339.12, ["Fly|Ride"] = 422.15, ["Neon"] = 1052.77, ["Neon|Ride"] = 883.58, ["Neon|Fly|Ride"] = 1076.43, ["Mega|Ride"] = 3293.07, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.06}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 160.13, ["Ride"] = 196.88, ["Fly|Ride"] = 329.32, ["Neon"] = 1079.36, ["Neon|Fly"] = 1716.52, ["Neon|Ride"] = 685.38, ["Neon|Fly|Ride"] = 961.17, ["Mega"] = 9879.18, ["Mega|Ride"] = 2675.63, ["Mega|Fly|Ride"] = 2799.12}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 130.71, ["Ride"] = 128.63, ["Fly|Ride"] = 199.66, ["Neon"] = 673.03, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2416.29}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.13, ["Ride"] = 29.3, ["Fly|Ride"] = 167.75, ["Neon"] = 39.35, ["Neon|Ride"] = 62.43, ["Neon|Fly|Ride"] = 191.62, ["Mega"] = 264.75, ["Mega|Ride"] = 493.98, ["Mega|Fly|Ride"] = 812.99}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.12, ["Fly"] = 63, ["Ride"] = 20.82, ["Fly|Ride"] = 69.63, ["Neon"] = 177.19, ["Neon|Ride"] = 110.12, ["Neon|Fly|Ride"] = 282.19, ["Mega|Ride"] = 800.64, ["Mega|Fly|Ride"] = 583.51}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 55.59, ["Fly"] = 102.31, ["Ride"] = 44.61, ["Fly|Ride"] = 110.12, ["Neon"] = 105, ["Neon|Ride"] = 130.71, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 467.21, ["Mega|Ride"] = 539.44, ["Mega|Fly|Ride"] = 685.38}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 94.5, ["Ride"] = 70.88, ["Fly|Ride"] = 170.6, ["Neon"] = 20.6, ["Neon|Fly"] = 231.18, ["Neon|Ride"] = 64.79, ["Neon|Fly|Ride"] = 155.29, ["Mega"] = 162.73, ["Mega|Fly"] = 307.71, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 273.75}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.95, ["Ride"] = 315, ["Fly|Ride"] = 367.5, ["Neon"] = 1615.67, ["Neon|Ride"] = 1372.81, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5214.37}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 135.85, ["Fly"] = 549.54, ["Ride"] = 196.88, ["Fly|Ride"] = 344.38, ["Neon"] = 656.25, ["Neon|Ride"] = 529.99, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 9879.18, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3560.64}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.01, ["Fly"] = 167.45, ["Ride"] = 101.74, ["Fly|Ride"] = 184.91, ["Neon"] = 354.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 493.98, ["Mega|Fly|Ride"] = 1468.51}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.81, ["Ride"] = 55.59, ["Fly|Ride"] = 274.78, ["Neon|Ride"] = 587.14, ["Neon|Fly|Ride"] = 480.59, ["Mega|Fly|Ride"] = 1646.54}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.71, ["Fly"] = 75.63, ["Ride"] = 39.27, ["Fly|Ride"] = 97.78, ["Neon"] = 77.39, ["Neon|Fly"] = 205.83, ["Neon|Ride"] = 100.57, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 345.57, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 25.24, ["Fly|Ride"] = 82.3, ["Neon"] = 19.57, ["Neon|Ride"] = 46.1, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 131.25, ["Mega|Ride"] = 158.54, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 968.77, ["Fly"] = 1082.72, ["Ride"] = 943.69, ["Fly|Ride"] = 1034.84, ["Neon"] = 3027.73, ["Neon|Fly"] = 3391.05, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2414.99, ["Mega|Fly|Ride"] = 8177.06}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 393.75, ["Ride"] = 452.81, ["Fly|Ride"] = 526.91, ["Neon"] = 1317.42, ["Neon|Ride"] = 1290.48, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10290.8, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.43, ["Ride"] = 103.69, ["Fly|Ride"] = 201.71, ["Neon"] = 339.94, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1571.8, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 378.72, ["Ride"] = 274.78, ["Fly|Ride"] = 307.44, ["Neon|Ride"] = 1386.94, ["Neon|Fly|Ride"] = 1167, ["Mega"] = 10290.8, ["Mega|Fly|Ride"] = 5145.4}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.38, ["Fly"] = 137.92, ["Ride"] = 31.37, ["Fly|Ride"] = 71.05, ["Neon"] = 143.07, ["Neon|Ride"] = 212.67, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 762.79}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.89, ["Ride"] = 262.5, ["Fly|Ride"] = 489.2, ["Neon"] = 1419.05, ["Neon|Ride"] = 921.04, ["Neon|Fly|Ride"] = 974.56, ["Mega"] = 4096.04, ["Mega|Ride"] = 4254.24, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 76.13, ["Ride"] = 47.36, ["Fly|Ride"] = 131.76, ["Neon|Ride"] = 525.89, ["Neon|Fly|Ride"] = 549.54, ["Mega|Fly|Ride"] = 1233.17}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1660.95, ["Ride"] = 1716.52, ["Fly|Ride"] = 1575, ["Neon|Ride"] = 10788.02, ["Neon|Fly|Ride"] = 5419.15, ["Mega"] = 49395.84, ["Mega|Fly|Ride"] = 23326.16}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.27, ["Fly"] = 102.93, ["Ride"] = 42.32, ["Fly|Ride"] = 104.96, ["Neon"] = 57.17, ["Neon|Fly"] = 185.26, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 262.38, ["Mega"] = 310.01, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 50.51, ["Fly"] = 119.1, ["Ride"] = 74.11, ["Fly|Ride"] = 157.5, ["Neon"] = 223.13, ["Neon|Ride"] = 102.93, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 892.23, ["Mega|Ride"] = 1007.49, ["Mega|Fly|Ride"] = 961.17}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 68.25, ["Fly"] = 91.76, ["Ride"] = 91.88, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 467.21, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2590.88, ["Ride"] = 833.57, ["Fly|Ride"] = 1170.75, ["Neon|Fly|Ride"] = 7135.66, ["Mega|Fly|Ride"] = 20649.34}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 564.05, ["Ride"] = 673.03, ["Fly|Ride"] = 667.96, ["Neon"] = 2466.11, ["Neon|Fly|Ride"] = 2773.87, ["Mega|Fly|Ride"] = 16952.17}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 85.2, ["Ride"] = 137.92, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 617.47, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 576.3, ["Mega"] = 4116.33, ["Mega|Ride"] = 2600.51, ["Mega|Fly|Ride"] = 2161.08}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.51, ["Ride"] = 19.69, ["Fly|Ride"] = 91.77, ["Neon"] = 76.44, ["Neon|Fly"] = 137.92, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1372.81}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 101.73, ["Ride"] = 48.38, ["Fly|Ride"] = 106.33, ["Neon"] = 196.88, ["Neon|Fly"] = 411.65, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1193.74, ["Mega|Fly|Ride"] = 961.17}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 874.13, ["Fly|Ride"] = 918.75, ["Neon"] = 3017.27, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 951.92}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5900.76, ["Ride"] = 4987.5, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29494.47, ["Neon|Fly|Ride"] = 24012.56, ["Mega|Fly|Ride"] = 87815.51}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 259.77, ["Fly"] = 406.82, ["Ride"] = 293.54, ["Neon"] = 1646.54, ["Neon|Fly|Ride"] = 2058.17, ["Mega"] = 6173.46, ["Mega|Fly|Ride"] = 6164.65}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Fly"] = 274.78, ["Ride"] = 100.86, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 610.28, ["Neon|Fly|Ride"] = 1646.54, ["Mega|Fly|Ride"] = 2867.04}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.45, ["Fly"] = 96.75, ["Ride"] = 26.25, ["Neon"] = 123.67, ["Neon|Fly"] = 1233.23, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 657.6, ["Mega|Ride"] = 718.32, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.17, ["Ride"] = 27.81, ["Fly|Ride"] = 44.34, ["Neon"] = 205.83, ["Neon|Ride"] = 308.61, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2181.66}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.46, ["Fly"] = 274.78, ["Ride"] = 31.5, ["Fly|Ride"] = 140.44, ["Neon"] = 105, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 144.09, ["Mega"] = 670.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.13, ["Fly"] = 21, ["Ride"] = 17.35, ["Fly|Ride"] = 57.75, ["Neon"] = 22.91, ["Neon|Ride"] = 46.25, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 274.78, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 30.19, ["Ride"] = 43.31, ["Fly|Ride"] = 96.75, ["Neon"] = 176, ["Neon|Fly"] = 823.28, ["Neon|Ride"] = 222.3, ["Neon|Fly|Ride"] = 329.32, ["Mega"] = 767.71, ["Mega|Ride"] = 658.63, ["Mega|Fly|Ride"] = 961.17}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 333.38, ["Fly"] = 459.95, ["Ride"] = 398.27, ["Fly|Ride"] = 406.88, ["Neon"] = 1312.5, ["Neon|Fly"] = 1457.19, ["Neon|Ride"] = 1233.88, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 7875, ["Mega|Fly"] = 4842.87, ["Mega|Ride"] = 4527.96, ["Mega|Fly|Ride"] = 4831.55}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.47, ["Fly|Ride"] = 35.43, ["Neon"] = 19.67, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 68.97, ["Mega"] = 131.25, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.6, ["Fly"] = 95.22, ["Ride"] = 78.75, ["Fly|Ride"] = 118.13, ["Neon"] = 196.88, ["Neon|Fly"] = 274.78, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 647.21, ["Mega|Fly"] = 823.28, ["Mega|Ride"] = 572.24, ["Mega|Fly|Ride"] = 590.55}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 892.5, ["Fly"] = 970.72, ["Ride"] = 773.07, ["Fly|Ride"] = 870.19, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1441.13, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.95, ["Fly"] = 91.88, ["Ride"] = 50.66, ["Fly|Ride"] = 75.42, ["Neon"] = 205.83, ["Neon|Ride"] = 179.07, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 324.84, ["Ride"] = 272.9, ["Fly|Ride"] = 353.06, ["Neon|Ride"] = 1262.69, ["Neon|Fly|Ride"] = 1232.85, ["Mega|Fly|Ride"] = 13868.7}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 150.94, ["Fly"] = 231.17, ["Ride"] = 190.31, ["Fly|Ride"] = 196.76, ["Neon"] = 627.29, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 755.36, ["Mega|Fly|Ride"] = 3293.07}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 656.25, ["Fly|Ride"] = 851.34, ["Neon|Ride"] = 2607.7, ["Neon|Fly|Ride"] = 2950.39, ["Mega|Fly|Ride"] = 6823.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.58, ["Ride"] = 41.18, ["Fly|Ride"] = 108.65, ["Neon"] = 78.08, ["Neon|Fly"] = 277.39, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 261.4, ["Mega|Ride"] = 354.82, ["Mega|Fly|Ride"] = 513.53}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3176.25, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3022.98, ["Neon"] = 13721.76, ["Neon|Fly|Ride"] = 6431.25, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 98.34, ["Fly"] = 131.25, ["Ride"] = 103.95, ["Fly|Ride"] = 157.5, ["Neon"] = 550.97, ["Neon|Fly"] = 480.59, ["Neon|Ride"] = 549.54, ["Neon|Fly|Ride"] = 521.76, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 26.75, ["Ride"] = 18.12, ["Fly|Ride"] = 47.36, ["Neon"] = 18.64, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 148.32, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.62, ["Ride"] = 23.63, ["Fly|Ride"] = 57.8, ["Neon"] = 18.38, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 166.65, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 278.35}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 41.18, ["Ride"] = 32.82, ["Fly|Ride"] = 52.48, ["Neon|Ride"] = 377.69, ["Neon|Fly|Ride"] = 303.6, ["Mega|Fly|Ride"] = 1098.05}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1028.06, ["Ride"] = 1303.85, ["Fly|Ride"] = 1247.4}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5906.25, ["Ride"] = 7011.05, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 24, ["Fly"] = 30.19, ["Ride"] = 26.94, ["Fly|Ride"] = 46.55, ["Neon"] = 549.54, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 19.09, ["Fly"] = 45.83, ["Ride"] = 24.69, ["Fly|Ride"] = 70.88, ["Neon"] = 72.19, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 178.49, ["Mega"] = 642.48, ["Mega|Ride"] = 613.71, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.56, ["Fly"] = 157.49, ["Ride"] = 62.91, ["Fly|Ride"] = 117.93, ["Neon"] = 459.38, ["Neon|Ride"] = 411.65, ["Neon|Fly|Ride"] = 308.61, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 227.43, ["Fly"] = 295.36, ["Ride"] = 236.24, ["Fly|Ride"] = 284.82, ["Neon"] = 961.17, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1079.51, ["Mega"] = 10290.8, ["Mega|Fly|Ride"] = 3675.9}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.69, ["Fly|Ride"] = 86.52, ["Neon"] = 22.65, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 136.4, ["Mega|Ride"] = 164.67, ["Mega|Fly|Ride"] = 287.13}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 196.88, ["Fly"] = 308.75, ["Ride"] = 247, ["Fly|Ride"] = 262.5, ["Neon"] = 787.5, ["Neon|Ride"] = 922.32, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 3390.91}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 40.15, ["Ride"] = 15.45, ["Fly|Ride"] = 51.48, ["Neon"] = 22.72, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 34.82, ["Neon|Fly|Ride"] = 96.75, ["Mega"] = 415.76, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 261.4}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 268.82, ["Ride"] = 249.38, ["Fly|Ride"] = 262.43, ["Neon|Fly|Ride"] = 1109.56, ["Mega"] = 10290.8, ["Mega|Ride"] = 4116.33, ["Mega|Fly|Ride"] = 4089.59}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.93, ["Fly"] = 36.03, ["Ride"] = 26.77, ["Fly|Ride"] = 52.5, ["Neon"] = 62.05, ["Neon|Fly"] = 293.57, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 23.14, ["Fly|Ride"] = 59.07, ["Neon"] = 10.5, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 176.78, ["Mega"] = 77.44, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 191.52}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 41.18, ["Mega"] = 22.98, ["Mega|Ride"] = 137.08, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 22.56, ["Fly|Ride"] = 214.07, ["Neon"] = 6.14, ["Neon|Ride"] = 41.33, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 68.16, ["Mega|Fly"] = 154097.27, ["Mega|Ride"] = 114.43, ["Mega|Fly|Ride"] = 160.08}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 47.24, ["Fly"] = 137.92, ["Ride"] = 116.24, ["Fly|Ride"] = 180.09, ["Neon"] = 308.61, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 380.03, ["Mega|Ride"] = 1317.24, ["Mega|Fly|Ride"] = 1090.01}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.53, ["Ride"] = 15.65, ["Fly|Ride"] = 103.47, ["Neon"] = 4.32, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.83, ["Mega"] = 129.94, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 12.36, ["Neon"] = 71.92, ["Neon|Ride"] = 259.74, ["Mega"] = 494.66}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 45.64, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 18.08, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 206.63}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.18, ["Ride"] = 14.89, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 31.4, ["Mega"] = 13.77, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 48.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 12.45, ["Fly|Ride"] = 39.26, ["Neon"] = 2.93, ["Neon|Fly"] = 39.26, ["Neon|Ride"] = 15.61, ["Neon|Fly|Ride"] = 45.29, ["Mega"] = 30.32, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 108.81}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 102.93, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 102.93, ["Mega"] = 16.42, ["Mega|Ride"] = 145.63, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.68, ["Fly|Ride"] = 107.62, ["Neon"] = 4.34, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.17, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 96.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 19.69, ["Mega|Ride"] = 95.94}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.19, ["Fly"] = 68.97, ["Ride"] = 19.59, ["Fly|Ride"] = 70.12, ["Neon"] = 10.5, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 70.26, ["Mega"] = 101.07, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 104.81, ["Mega|Fly|Ride"] = 168.74}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.36, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 13.02, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 185.26}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.92, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 343.72, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 14.67, ["Mega"] = 105, ["Mega|Ride"] = 102.93, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.29, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 19.57, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 144.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.45, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 10.4, ["Neon|Fly|Ride"] = 30.82, ["Mega"] = 15.72, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 22.23, ["Mega|Fly|Ride"] = 50.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 34.91, ["Neon|Ride"] = 41.18, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.4, ["Neon"] = 3.94, ["Neon|Ride"] = 51.48, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.66, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 62.43, ["Mega|Fly|Ride"] = 159.51}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 94.71, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 12.99, ["Neon|Fly"] = 102.93, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.6, ["Ride"] = 10.31, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 14.24, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 26.78, ["Mega"] = 15.04, ["Mega|Fly"] = 28.25, ["Mega|Ride"] = 20.29, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 20.51, ["Fly|Ride"] = 137.92, ["Neon"] = 11.46, ["Neon|Ride"] = 110.97, ["Neon|Fly|Ride"] = 109.1, ["Mega"] = 87.94, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 21.99, ["Fly|Ride"] = 59.06, ["Neon"] = 73.07, ["Neon|Ride"] = 67.1, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 203.44, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 390.47}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 12.99, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 10.5, ["Neon|Fly|Ride"] = 45.04, ["Mega|Fly"] = 1312.5, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 6.34, ["Fly"] = 171.87, ["Ride"] = 28.72, ["Neon"] = 3.81, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 72.65, ["Mega|Fly"] = 164.67, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 360.2}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.77, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 39.38, ["Mega|Ride"] = 137.92, ["Mega|Fly|Ride"] = 303.6}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 14.34, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 137.91}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.75, ["Ride"] = 19.57, ["Fly|Ride"] = 41.91, ["Neon"] = 4.7, ["Neon|Fly"] = 55.59, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 75.48, ["Mega"] = 77.6, ["Mega|Ride"] = 82.34, ["Mega|Fly|Ride"] = 231.16}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.16, ["Neon"] = 3.71, ["Neon|Ride"] = 52.29, ["Mega"] = 40.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 31.9, ["Ride"] = 17.55, ["Fly|Ride"] = 44.88, ["Neon"] = 4.82, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 67.93, ["Neon"] = 36.66, ["Mega"] = 133.88, ["Mega|Ride"] = 205.83, ["Mega|Fly|Ride"] = 823.28}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 16.7, ["Fly|Ride"] = 137.91, ["Neon"] = 11.46, ["Neon|Fly"] = 104.1, ["Neon|Ride"] = 28.83, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 303.6, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 462.3}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.65, ["Ride"] = 19.57, ["Fly|Ride"] = 38.75, ["Neon"] = 13.13, ["Neon|Fly"] = 25.97, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 273.66, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.84, ["Fly"] = 110.93, ["Fly|Ride"] = 137.82, ["Neon"] = 30.98, ["Mega"] = 177.28, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.5, ["Ride"] = 131.25, ["Neon"] = 121.35, ["Neon|Ride"] = 231.17, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 64.78, ["Neon"] = 38.99, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 214.07}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.03, ["Ride"] = 30.19, ["Fly|Ride"] = 120.75, ["Neon"] = 63.81, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 192.45, ["Mega"] = 245.97, ["Mega|Ride"] = 248.06, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 64.98, ["Mega"] = 22.32, ["Mega|Fly"] = 123.51, ["Mega|Ride"] = 123.51, ["Mega|Fly|Ride"] = 148.2}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.1, ["Fly"] = 22.91, ["Ride"] = 20.04, ["Fly|Ride"] = 39.95, ["Neon"] = 36.66, ["Neon|Ride"] = 40.47, ["Neon|Fly|Ride"] = 100.57, ["Mega"] = 306.68, ["Mega|Fly"] = 329.32, ["Mega|Ride"] = 513.16, ["Mega|Fly|Ride"] = 258.19}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.56, ["Neon"] = 2.1, ["Neon|Ride"] = 26.6, ["Mega"] = 27.24, ["Mega|Fly"] = 137.92, ["Mega|Ride"] = 55.59, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.6, ["Neon"] = 2.63, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 39.29, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.38, ["Ride"] = 12.75, ["Fly|Ride"] = 55.13, ["Neon"] = 6.43, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 118.25, ["Mega"] = 141.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.34, ["Ride"] = 49.41, ["Fly|Ride"] = 58.67, ["Neon"] = 35.04, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 214.39, ["Mega"] = 325.2, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.57, ["Ride"] = 32.81, ["Neon"] = 3.82, ["Mega"] = 14.3, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.78, ["Fly|Ride"] = 274421.64, ["Neon"] = 3.86, ["Neon|Fly"] = 68.97, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 27.57, ["Mega|Ride"] = 47.36, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 14.06, ["Fly|Ride"] = 34.13, ["Neon"] = 8.37, ["Neon|Fly"] = 68.97, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 37.09, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 201.11}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 26.25, ["Fly|Ride"] = 146.78, ["Neon"] = 3.65, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 154.85, ["Mega"] = 23.06, ["Mega|Fly"] = 123.68, ["Mega|Ride"] = 72.97, ["Mega|Fly|Ride"] = 158.94}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.48, ["Mega"] = 18.38, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 86.69, ["Mega|Fly|Ride"] = 144.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 19.25, ["Fly|Ride"] = 77.19, ["Neon"] = 2.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 22.37, ["Neon|Fly|Ride"] = 65, ["Mega"] = 19.28, ["Mega|Fly"] = 61.77, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.38, ["Neon"] = 2.63, ["Mega"] = 17.73, ["Mega|Ride"] = 224.25}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.45, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.65, ["Mega|Ride"] = 154.88}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 22.65, ["Fly|Ride"] = 49.88, ["Neon"] = 3.93, ["Neon|Fly"] = 55.59, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 26.25, ["Mega|Ride"] = 55.59, ["Mega|Fly|Ride"] = 94.15}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.82, ["Ride"] = 138.69, ["Neon"] = 96.75, ["Mega"] = 409.59, ["Mega|Ride"] = 428.12, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.63, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 54.76, ["Neon|Ride"] = 203.78, ["Mega"] = 1567.31, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 32.82, ["Mega"] = 295.25, ["Mega|Ride"] = 346.74, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.24, ["Ride"] = 15.45, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 10.5, ["Neon|Ride"] = 12.27, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 103.95, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 21.69, ["Mega|Fly|Ride"] = 45.86}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.64, ["Fly|Ride"] = 110.12, ["Neon"] = 15.75, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.91, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 51.66, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.89, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 55.59, ["Mega"] = 15.49, ["Mega|Fly"] = 84, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.31, ["Neon"] = 2.61, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 102.93, ["Mega"] = 24.94, ["Mega|Ride"] = 102.93, ["Mega|Fly|Ride"] = 152.33}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.86, ["Ride"] = 19.95, ["Fly|Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 208.85, ["Mega|Ride"] = 204.8, ["Mega|Fly|Ride"] = 343.72}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.38, ["Ride"] = 171.87, ["Fly|Ride"] = 245.01, ["Neon|Ride"] = 757.32, ["Mega"] = 8232.65, ["Mega|Fly|Ride"] = 3417.59}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 18.55, ["Neon"] = 7.35, ["Neon|Ride"] = 82.34, ["Mega"] = 70.35, ["Mega|Ride"] = 108.65, ["Mega|Fly|Ride"] = 823.28}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.96, ["Fly"] = 63.03, ["Ride"] = 25.57, ["Neon"] = 30.01, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 164.67, ["Mega"] = 350.83, ["Mega|Ride"] = 513.53, ["Mega|Fly|Ride"] = 401.05}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.81, ["Ride"] = 13.74, ["Fly|Ride"] = 32.13, ["Neon"] = 6.57, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 55.59, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 5.92, ["Neon|Fly"] = 549.54, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.75, ["Mega|Ride"] = 168.78, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.64, ["Fly"] = 18.1, ["Ride"] = 13.91, ["Fly|Ride"] = 35.44, ["Neon"] = 26.17, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 74.8, ["Mega|Ride"] = 267.58, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 7.91, ["Ride"] = 34.12, ["Fly|Ride"] = 249.58, ["Neon"] = 52.91, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 611.29, ["Mega"] = 337.03, ["Mega|Ride"] = 254.52, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.64, ["Ride"] = 14.76, ["Fly|Ride"] = 40.57, ["Neon"] = 15.65, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 53.52, ["Neon|Fly|Ride"] = 75.27, ["Mega|Ride"] = 233.61, ["Mega|Fly|Ride"] = 222.66}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 168.78, ["Ride"] = 90.06, ["Fly|Ride"] = 157.5, ["Neon"] = 346.32, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 348.87, ["Mega|Fly|Ride"] = 2058.17}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.83, ["Fly"] = 329.32, ["Ride"] = 219.19, ["Fly|Ride"] = 274.78, ["Neon|Ride"] = 1016.75, ["Neon|Fly|Ride"] = 1234.91, ["Mega"] = 10290.8, ["Mega|Fly|Ride"] = 4049.45}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 51.98, ["Fly"] = 123.69, ["Ride"] = 75.59, ["Fly|Ride"] = 122.12, ["Neon"] = 685.4, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1233.88, ["Mega|Fly|Ride"] = 1052.59}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.41, ["Fly"] = 24.74, ["Ride"] = 24.71, ["Fly|Ride"] = 137.92, ["Neon"] = 22.91, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 158.82, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 262.37}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.08, ["Fly"] = 68.97, ["Ride"] = 35, ["Fly|Ride"] = 89.25, ["Neon"] = 46.25, ["Neon|Ride"] = 82.34, ["Mega"] = 353.07, ["Mega|Ride"] = 364.31, ["Mega|Fly|Ride"] = 410.62}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 25.44, ["Fly|Ride"] = 35.44, ["Neon"] = 4.13, ["Neon|Fly"] = 25.44, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 455.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.56, ["Fly"] = 27.81, ["Ride"] = 27.81, ["Fly|Ride"] = 299.83, ["Neon"] = 92.98, ["Neon|Fly"] = 343.72, ["Neon|Ride"] = 159.51, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.18, ["Ride"] = 15.89, ["Fly|Ride"] = 52.5, ["Neon"] = 15.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 100.54, ["Mega|Fly"] = 86.69, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 26.6, ["Fly|Ride"] = 328.13, ["Neon"] = 30.07, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 207.38, ["Mega|Ride"] = 231.16, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.36, ["Mega"] = 13.13, ["Mega|Fly"] = 41.18, ["Mega|Ride"] = 50.44, ["Mega|Fly|Ride"] = 208030.26}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 17.48, ["Ride"] = 18.05, ["Fly|Ride"] = 55.59, ["Neon"] = 13.18, ["Neon|Fly"] = 102.93, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 97.78, ["Mega"] = 79.06, ["Mega|Ride"] = 97.82, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 5.24, ["Fly"] = 24.93, ["Ride"] = 18.52, ["Fly|Ride"] = 52.5, ["Neon"] = 27.81, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 119.38, ["Mega"] = 283.5, ["Mega|Ride"] = 192.45, ["Mega|Fly|Ride"] = 220.77}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 142.94, ["Fly"] = 274.78, ["Ride"] = 189, ["Fly|Ride"] = 303.19, ["Neon"] = 685.13, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 723.13, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.44, ["Ride"] = 30.89, ["Fly|Ride"] = 205.83, ["Neon"] = 72.19, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 343.72, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.44, ["Fly|Ride"] = 45.29, ["Neon"] = 68.97, ["Neon|Ride"] = 49.41, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.19, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 98.44, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 476.52, ["Mega|Fly"] = 823.28, ["Mega|Ride"] = 471.19, ["Mega|Fly|Ride"] = 686.41}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.2}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 24.71, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 617.47, ["Mega"] = 385.91, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 821.22}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 30.87, ["Fly"] = 35.49, ["Ride"] = 32.82, ["Fly|Ride"] = 58.47, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 135.97, ["Mega"] = 2058.17, ["Mega|Fly|Ride"] = 1905.87}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Fly|Ride"] = 102.93, ["Neon"] = 6.14, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 53.52, ["Mega|Fly"] = 274.78, ["Mega|Ride"] = 135.85, ["Mega|Fly|Ride"] = 225.44}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.87, ["Fly"] = 27.81, ["Ride"] = 23.69, ["Fly|Ride"] = 61.77, ["Neon"] = 45.55, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 23.14, ["Mega"] = 231.16, ["Mega|Fly"] = 386.03, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 303.6}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.35, ["Fly|Ride"] = 46.11, ["Neon"] = 15.28, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 34.35, ["Fly|Ride"] = 205.83, ["Neon"] = 3.46, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 31.29, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 32.12, ["Fly"] = 52.5, ["Ride"] = 86.63, ["Neon"] = 307.97, ["Neon|Fly|Ride"] = 617.19, ["Mega"] = 799.99, ["Mega|Ride"] = 961.17, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.71, ["Ride"] = 26.25, ["Fly|Ride"] = 210, ["Neon"] = 72.19, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 462.3}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.87, ["Fly"] = 137.92, ["Ride"] = 22.31, ["Fly|Ride"] = 61.52, ["Neon"] = 25.97, ["Neon|Fly"] = 315, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 339.94, ["Mega|Ride"] = 274.78, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.13, ["Ride"] = 179.07, ["Fly|Ride"] = 262.44, ["Neon"] = 549.54, ["Neon|Ride"] = 411.65, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.88, ["Fly"] = 26.17, ["Ride"] = 30.58, ["Fly|Ride"] = 55.59, ["Neon"] = 39.38, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 262.08, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 295.65}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 76.17, ["Fly"] = 145.69, ["Ride"] = 108.64, ["Fly|Ride"] = 185.26, ["Neon"] = 217.95, ["Neon|Fly"] = 525, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 406.5, ["Mega"] = 1069.23, ["Mega|Ride"] = 1080.55, ["Mega|Fly|Ride"] = 912.57}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 22.13, ["Ride"] = 77.44, ["Fly|Ride"] = 131.24, ["Neon"] = 97.13, ["Neon|Ride"] = 148.64, ["Neon|Fly|Ride"] = 823.28, ["Mega"] = 473.4, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.73, ["Ride"] = 27.57, ["Fly|Ride"] = 47.33, ["Neon"] = 123.2, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 247.35, ["Mega"] = 416.96, ["Mega|Ride"] = 1029.09, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 26.17, ["Ride"] = 51.19, ["Fly|Ride"] = 157.91, ["Neon"] = 105, ["Neon|Ride"] = 110.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.14, ["Mega|Ride"] = 257.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 11.33, ["Ride"] = 40.15, ["Fly|Ride"] = 55.72, ["Neon"] = 40.47, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 221.82, ["Mega|Ride"] = 340.65, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 57.1, ["Mega"] = 17.07, ["Mega|Ride"] = 102.93, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.94, ["Ride"] = 28.14, ["Neon"] = 19.69, ["Neon|Fly"] = 123.51, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.08, ["Mega|Ride"] = 192.45, ["Mega|Fly|Ride"] = 464.62}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.62, ["Neon"] = 24.94, ["Mega"] = 196.23, ["Mega|Ride"] = 137.92, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.74, ["Ride"] = 32.79, ["Fly|Ride"] = 115.58, ["Neon"] = 18.84, ["Neon|Ride"] = 82.34, ["Mega"] = 199.66, ["Mega|Ride"] = 205.83, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.37, ["Ride"] = 525, ["Fly|Ride"] = 652.03, ["Neon"] = 1784.44, ["Neon|Ride"] = 1766.19, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.5, ["Fly"] = 27.81, ["Ride"] = 26.92, ["Fly|Ride"] = 62.42, ["Neon"] = 32.95, ["Neon|Ride"] = 94.69, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 154.88, ["Mega|Ride"] = 354.82, ["Mega|Fly|Ride"] = 480.8}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.11, ["Fly"] = 524.48, ["Ride"] = 23.61, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 303.6, ["Mega|Ride"] = 323.65, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.82, ["Fly"] = 96.75, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 196.88, ["Mega"] = 260.06, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 9.43, ["Neon|Ride"] = 31.22, ["Neon|Fly|Ride"] = 105.6, ["Mega"] = 58.97, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 232.59}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 19.69, ["Neon"] = 3.84, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 88.25, ["Mega"] = 32.82, ["Mega|Fly"] = 192.45, ["Mega|Ride"] = 150.26, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.25, ["Ride"] = 35.84, ["Fly|Ride"] = 323.64, ["Neon"] = 65.62, ["Neon|Ride"] = 89.25, ["Mega"] = 398.27, ["Mega|Ride"] = 365.23, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 6.56, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 41.25, ["Mega|Ride"] = 154.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 59.06, ["Fly|Ride"] = 99.75, ["Neon"] = 9.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 155.03, ["Mega"] = 183.73, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 446.25, ["Ride"] = 522.38, ["Fly|Ride"] = 548.58, ["Neon|Ride"] = 1440.73, ["Neon|Fly|Ride"] = 1347.76, ["Mega|Fly|Ride"] = 8095.79}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 8.25, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 411.65, ["Neon"] = 68.97, ["Neon|Ride"] = 72.09, ["Mega"] = 469.28, ["Mega|Ride"] = 380.63}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 77.93, ["Ride"] = 29.24, ["Fly|Ride"] = 162.61, ["Neon"] = 6.19, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 54.33, ["Mega"] = 41.91, ["Mega|Fly"] = 189, ["Mega|Ride"] = 108.9, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 115.64, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 26.25, ["Mega|Ride"] = 119.55, ["Mega|Fly|Ride"] = 189.52}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.55, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 85.54, ["Neon"] = 115.4, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 343.72, ["Mega"] = 576.73, ["Mega|Ride"] = 411.65, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 19.69, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 108.65, ["Neon|Ride"] = 123.51, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 421.94, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1372.81}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.75, ["Ride"] = 39.31, ["Fly|Ride"] = 411.65, ["Neon"] = 308.56, ["Neon|Ride"] = 174.55, ["Mega"] = 632.2, ["Mega|Ride"] = 961.17, ["Mega|Fly|Ride"] = 1233.17}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.86, ["Ride"] = 22.67, ["Fly|Ride"] = 262.5, ["Neon"] = 274.78, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 549.54, ["Mega|Ride"] = 647.73, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 398.27, ["Fly|Ride"] = 617.47, ["Neon"] = 2881.45, ["Neon|Ride"] = 2058.17, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 3869.36}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.78, ["Fly"] = 69.65, ["Ride"] = 22.65, ["Fly|Ride"] = 137.92, ["Neon"] = 111.51, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 180.06, ["Mega|Ride"] = 411.65, ["Mega|Fly|Ride"] = 850.04}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.49, ["Fly|Ride"] = 127.32, ["Neon"] = 35, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 21, ["Ride"] = 70.88, ["Fly|Ride"] = 255.41, ["Neon"] = 70.17, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 365.34, ["Mega"] = 272.25, ["Mega|Fly"] = 686.41, ["Mega|Ride"] = 275.61, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 41.18, ["Ride"] = 52.5, ["Fly|Ride"] = 137.92, ["Neon"] = 6.55, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 204.8, ["Mega"] = 44.63, ["Mega|Fly"] = 105, ["Mega|Ride"] = 96.75, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 44.23, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 201.09, ["Neon|Ride"] = 274.78, ["Mega"] = 1372.81, ["Mega|Ride"] = 1345.02, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 577.82, ["Ride"] = 27.43, ["Neon"] = 9.72, ["Neon|Fly"] = 179.07, ["Neon|Ride"] = 63.81, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 64.94, ["Mega|Ride"] = 109.1, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.84, ["Ride"] = 27.57, ["Fly|Ride"] = 149.76, ["Neon"] = 6.42, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 39.62, ["Neon|Fly|Ride"] = 124.84, ["Mega"] = 41.18, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 66.22, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 31.21, ["Fly|Ride"] = 122.51, ["Neon"] = 15, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 78.75, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 102.93, ["Fly"] = 92.47, ["Ride"] = 78.74, ["Fly|Ride"] = 193.01, ["Neon"] = 291.38, ["Neon|Ride"] = 282.76, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1029.09, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.35, ["Ride"] = 286.2, ["Fly|Ride"] = 393.75, ["Neon"] = 1430.44, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 6174.49, ["Mega|Fly|Ride"] = 5240.06}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.46, ["Ride"] = 71.67, ["Neon"] = 28.93, ["Neon|Ride"] = 143.33, ["Mega"] = 95.75, ["Mega|Ride"] = 188.73, ["Mega|Fly|Ride"] = 686.41}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 28.46, ["Fly|Ride"] = 154.87, ["Neon"] = 11.71, ["Neon|Ride"] = 43.45, ["Neon|Fly|Ride"] = 179.07, ["Mega"] = 61.69, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 343.72}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.39, ["Fly"] = 30.07, ["Ride"] = 27.56, ["Fly|Ride"] = 174.97, ["Neon"] = 32.81, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 61.99, ["Ride"] = 63.81, ["Neon"] = 7.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 88.73, ["Mega|Fly"] = 146.14, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.93, ["Neon"] = 15.45, ["Mega"] = 36.75, ["Mega|Ride"] = 205.83, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 6.15, ["Neon|Ride"] = 22.65, ["Neon|Fly|Ride"] = 101.73, ["Mega"] = 41.99, ["Mega|Ride"] = 99.41, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 17.35, ["Ride"] = 24.94, ["Fly|Ride"] = 57.4, ["Neon"] = 11.82, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 92.47, ["Mega|Ride"] = 232.59, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 48.2, ["Ride"] = 42.62, ["Fly|Ride"] = 77.16, ["Neon"] = 137.69, ["Mega"] = 575.28, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.91, ["Fly"] = 123.51, ["Ride"] = 102.93, ["Fly|Ride"] = 111.69, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 452.82, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 39.32, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 11.82, ["Fly|Ride"] = 39.37, ["Neon"] = 5.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 60.38, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 89.55, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.18, ["Fly"] = 35, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 35.44, ["Neon|Ride"] = 69.36, ["Neon|Fly|Ride"] = 273.75, ["Mega"] = 527.63, ["Mega|Ride"] = 354.02, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 576.3, ["Fly|Ride"] = 492.19, ["Neon"] = 4116.33, ["Neon|Ride"] = 1922.33, ["Mega|Fly|Ride"] = 7203.57}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 30.96, ["Fly"] = 96.75, ["Ride"] = 42.84, ["Fly|Ride"] = 92.26, ["Neon"] = 170.52, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 184.94, ["Mega|Ride"] = 926.19, ["Mega|Fly|Ride"] = 982.38}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 36.03, ["Fly|Ride"] = 281.29, ["Neon"] = 9.18, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 82.34, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 17.2, ["Mega|Ride"] = 411.65}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23, ["Fly"] = 76.17, ["Ride"] = 43.29, ["Fly|Ride"] = 82.34, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 364.31, ["Mega"] = 2469.8, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1290.48}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.84, ["Fly"] = 117.33, ["Ride"] = 98.75, ["Fly|Ride"] = 123.51, ["Neon"] = 430.1, ["Neon|Fly|Ride"] = 462.33, ["Mega"] = 8232.65, ["Mega|Fly|Ride"] = 1875}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 228.27, ["Ride"] = 288.75, ["Fly|Ride"] = 509.25, ["Neon|Ride"] = 1234.91, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4371.54, ["Mega|Fly|Ride"] = 4367.43}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.64, ["Fly"] = 51.19, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 76.04, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 184.94, ["Mega"] = 388.49, ["Mega|Ride"] = 352.31, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.59, ["Ride"] = 18.27, ["Fly|Ride"] = 41.9, ["Neon"] = 9.17, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.54, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 35.76, ["Ride"] = 19.57, ["Fly|Ride"] = 41.1, ["Neon"] = 31, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 81.03, ["Mega"] = 376.65, ["Mega|Ride"] = 303.6, ["Mega|Fly|Ride"] = 314.91}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 480.59, ["Ride"] = 370.33, ["Fly|Ride"] = 609.23, ["Neon"] = 2047.88, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4688.25}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 59.7, ["Neon"] = 11.82, ["Neon|Ride"] = 59.7, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 72.19, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.71, ["Ride"] = 18.38, ["Fly|Ride"] = 39.53, ["Neon"] = 49.87, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 164.67, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.6, ["Ride"] = 114.23, ["Neon"] = 112.88, ["Neon|Fly"] = 411.65, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 432.27, ["Mega"] = 517.18, ["Mega|Ride"] = 549.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 209.94, ["Ride"] = 111.57, ["Fly|Ride"] = 164.67, ["Neon|Ride"] = 562.92, ["Neon|Fly|Ride"] = 611.02, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 27.36, ["Fly"] = 35, ["Ride"] = 27.46, ["Fly|Ride"] = 48.38, ["Neon"] = 85.32, ["Neon|Ride"] = 85.43, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 631.87, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 526.31}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 24.67, ["Mega|Fly"] = 71.36, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 116.16}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.46, ["Fly"] = 411.65, ["Ride"] = 58.7, ["Fly|Ride"] = 123.51, ["Neon"] = 31.49, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 151.66, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 362.09}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Fly"] = 1525.7, ["Ride"] = 1207.5, ["Fly|Ride"] = 1312.5, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 485.63, ["Ride"] = 525.29, ["Fly|Ride"] = 544.14, ["Neon"] = 1922.33, ["Neon|Ride"] = 1975.32, ["Neon|Fly|Ride"] = 2044.81, ["Mega"] = 16465.29, ["Mega|Fly|Ride"] = 9330.69}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 313.48, ["Ride"] = 328.13, ["Fly|Ride"] = 443.88, ["Neon"] = 715.32, ["Neon|Fly"] = 1233.23, ["Neon|Ride"] = 753.12, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 287.42, ["Fly"] = 411.65, ["Ride"] = 373.91, ["Fly|Ride"] = 465.6, ["Neon"] = 925.32, ["Neon|Fly"] = 1079.51, ["Neon|Ride"] = 1070.25, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 4625.73}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 17.97, ["Fly|Ride"] = 38.06, ["Neon"] = 5.76, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 76.17, ["Mega|Ride"] = 114.18, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 354.34, ["Fly"] = 1372.81, ["Ride"] = 410.21, ["Fly|Ride"] = 565.47, ["Neon"] = 1680, ["Neon|Ride"] = 1338.08, ["Neon|Fly|Ride"] = 1383.76, ["Mega|Ride"] = 5351.22, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.81, ["Fly"] = 157.5, ["Ride"] = 27.81, ["Fly|Ride"] = 62.41, ["Neon"] = 12.7, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 81.2, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 365.34}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.83, ["Ride"] = 18.55, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 61.62, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 24.44, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 78.37, ["Fly|Ride"] = 459.38, ["Neon"] = 192.45, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 924.59, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7705.84, ["Ride"] = 10.5, ["Fly|Ride"] = 63.58, ["Neon"] = 30.24, ["Neon|Ride"] = 77.44, ["Mega"] = 411.65, ["Mega|Ride"] = 308.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.84, ["Neon|Fly"] = 118.36, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 19.28, ["Mega|Ride"] = 121.45, ["Mega|Fly|Ride"] = 121.45}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 36.01, ["Ride"] = 20.6, ["Fly|Ride"] = 66.89, ["Neon"] = 11.15, ["Neon|Fly"] = 89.55, ["Neon|Ride"] = 38.73, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 99.75, ["Mega|Fly"] = 171.87, ["Mega|Ride"] = 117.76, ["Mega|Fly|Ride"] = 153.85}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.68, ["Fly"] = 91.77, ["Ride"] = 27.75, ["Fly|Ride"] = 51.98, ["Neon"] = 17.07, ["Neon|Fly"] = 110.12, ["Neon|Ride"] = 82.34, ["Neon|Fly|Ride"] = 246.11, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.39, ["Fly"] = 196.88, ["Ride"] = 60.74, ["Fly|Ride"] = 65.63, ["Neon"] = 52.05, ["Neon|Fly|Ride"] = 262.38, ["Mega"] = 411.65, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6164.01, ["Ride"] = 27.09, ["Neon"] = 36.39, ["Neon|Ride"] = 137.91, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 5.74, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 41.18, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 144.18, ["Fly"] = 227.45, ["Ride"] = 205.83, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 958.09, ["Neon|Fly|Ride"] = 1029.09, ["Mega"] = 8232.65, ["Mega|Ride"] = 4116.33, ["Mega|Fly|Ride"] = 4102.96}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.33, ["Ride"] = 15.45, ["Fly|Ride"] = 34.55, ["Neon"] = 3.84, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 22.28, ["Neon|Fly|Ride"] = 45.39, ["Mega"] = 39.37, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.29, ["Fly"] = 137.92, ["Ride"] = 69.46, ["Fly|Ride"] = 183.74, ["Neon"] = 137.92, ["Neon|Ride"] = 178.01, ["Mega"] = 370.49, ["Mega|Ride"] = 398.27, ["Mega|Fly|Ride"] = 1029.09}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 33.33, ["Ride"] = 93.19, ["Fly|Ride"] = 105, ["Neon"] = 155.66, ["Neon|Ride"] = 274.78, ["Mega"] = 786.19, ["Mega|Ride"] = 809.02, ["Mega|Fly|Ride"] = 1027.04}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.11, ["Ride"] = 249.38, ["Fly|Ride"] = 333.63, ["Neon"] = 708.73, ["Neon|Fly"] = 1155.79, ["Neon|Ride"] = 823.28, ["Neon|Fly|Ride"] = 841.61, ["Mega|Fly|Ride"] = 3236.04}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.65, ["Fly"] = 168.88, ["Ride"] = 39.38, ["Fly|Ride"] = 138.69, ["Neon"] = 154.87, ["Neon|Ride"] = 145.34, ["Mega"] = 281.71, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.57, ["Ride"] = 57.75, ["Fly|Ride"] = 617.47, ["Neon"] = 39.12, ["Neon|Fly"] = 154.88, ["Neon|Ride"] = 199.5, ["Mega"] = 549.54, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1443.82, ["Ride"] = 1106.05, ["Fly|Ride"] = 1149.75, ["Neon"] = 4622.49, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4623.11, ["Mega|Fly|Ride"] = 17426.46}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.92, ["Fly"] = 30.07, ["Ride"] = 19.56, ["Fly|Ride"] = 52.5, ["Neon"] = 40.46, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 231.16, ["Mega|Ride"] = 233.61, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.87, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 31.83, ["Neon|Ride"] = 91.32, ["Mega"] = 220.23, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.85, ["Mega|Fly|Ride"] = 546.46}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.31, ["Ride"] = 22.65, ["Fly|Ride"] = 69.57, ["Neon"] = 11.4, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.81, ["Mega"] = 91.88, ["Mega|Ride"] = 176.67, ["Mega|Fly|Ride"] = 720.57}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.86, ["Ride"] = 55.59, ["Fly|Ride"] = 100.28, ["Neon"] = 77.4, ["Neon|Ride"] = 76.27, ["Neon|Fly|Ride"] = 173.38, ["Mega"] = 342.57, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.52, ["Fly"] = 20.6, ["Ride"] = 18.47, ["Fly|Ride"] = 39.29, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 92.48, ["Mega|Ride"] = 158.49, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 21.97, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 118.13, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 327.27}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 220.23, ["Fly"] = 261.4, ["Ride"] = 229.69, ["Fly|Ride"] = 391.07, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 20.6, ["Fly|Ride"] = 72.19, ["Neon"] = 13.12, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 82.6, ["Mega|Fly"] = 411.65, ["Mega|Ride"] = 114.03, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 77.43, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 137.92, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 93.11, ["Ride"] = 26.23, ["Neon"] = 13.44, ["Neon|Ride"] = 1372.81, ["Mega"] = 83.99, ["Mega|Fly"] = 137.92, ["Mega|Ride"] = 205.83, ["Mega|Fly|Ride"] = 370.61}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 200.1, ["Ride"] = 311.85, ["Fly|Ride"] = 1036.23, ["Neon"] = 853.13, ["Neon|Fly"] = 1029.09, ["Neon|Ride"] = 823.28, ["Neon|Fly|Ride"] = 1098.05, ["Mega"] = 3087.25, ["Mega|Ride"] = 4939.6, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.88, ["Fly"] = 60.74, ["Ride"] = 45.31, ["Fly|Ride"] = 162.61, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 768.74}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.74, ["Ride"] = 40.57, ["Fly|Ride"] = 89.25, ["Neon"] = 85.32, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 506.13, ["Mega|Ride"] = 561.89, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.34, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 48.57, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.71}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 78.73, ["Fly"] = 68.97, ["Ride"] = 110.12, ["Fly|Ride"] = 157.49, ["Neon"] = 262.48, ["Neon|Fly"] = 411.65, ["Neon|Ride"] = 291.21, ["Neon|Fly|Ride"] = 353.98, ["Mega|Fly|Ride"] = 1098.05}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 2.63, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 122.48, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 410.62}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 24.94, ["Fly"] = 97.08, ["Ride"] = 34.13, ["Fly|Ride"] = 79.77, ["Neon"] = 72.19, ["Neon|Ride"] = 122.52, ["Neon|Fly|Ride"] = 247, ["Mega"] = 382.05, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 386.03}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 53.82, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 146.14, ["Neon"] = 247.8, ["Neon|Ride"] = 308.61, ["Neon|Fly|Ride"] = 311.07, ["Mega|Ride"] = 3432, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.45, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 14.76, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 15.38, ["Mega|Fly"] = 115.59, ["Mega|Ride"] = 31.89, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 43.93, ["Fly|Ride"] = 131.25, ["Neon"] = 15.65, ["Neon|Ride"] = 59.7, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 129.94, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.86, ["Ride"] = 64.85, ["Fly|Ride"] = 108.65, ["Neon"] = 77.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 315, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 617.17}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.77, ["Neon"] = 2.1, ["Neon|Ride"] = 18.55, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.71, ["Mega|Ride"] = 81.31, ["Mega|Fly|Ride"] = 212.82}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.89, ["Fly"] = 176.59, ["Ride"] = 57.89, ["Fly|Ride"] = 99.75, ["Neon"] = 92.16, ["Neon|Ride"] = 109.1, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 554.76, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 101.6, ["Ride"] = 26.5, ["Fly|Ride"] = 45.94, ["Neon"] = 408.98, ["Neon|Ride"] = 118.78, ["Neon|Fly|Ride"] = 179.43, ["Mega|Fly|Ride"] = 432.26}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 8.25, ["Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.97, ["Mega"] = 223.12, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 386.03}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.31, ["Fly"] = 2058.17, ["Ride"] = 85.12, ["Fly|Ride"] = 196.83, ["Neon"] = 59.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6163.77, ["Mega"] = 274.78, ["Mega|Ride"] = 505.32, ["Mega|Fly|Ride"] = 293.56}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.18, ["Ride"] = 20.6, ["Fly|Ride"] = 196.88, ["Neon"] = 7.88, ["Neon|Fly"] = 55.59, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 102.93, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.29, ["Neon"] = 2.1, ["Neon|Ride"] = 41.21, ["Mega"] = 31.5, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.98}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 46.1, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1226.69, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 23.05, ["Mega|Ride"] = 8507.42, ["Mega|Fly|Ride"] = 308.75}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 561.89, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3033.75, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16465.29, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.25, ["Fly"] = 25.81, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.64, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 82.55, ["Mega|Fly"] = 154.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 20.87, ["Fly|Ride"] = 65.54, ["Neon"] = 17.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 161.44, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.7, ["Fly"] = 77.19, ["Ride"] = 64.85, ["Fly|Ride"] = 106.32, ["Neon"] = 89.25, ["Neon|Ride"] = 178.01, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 782.12, ["Mega|Ride"] = 521.76, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.66, ["Fly"] = 315.94, ["Ride"] = 32.48, ["Fly|Ride"] = 686.41, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.97, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.5, ["Neon"] = 104.36, ["Neon|Ride"] = 205.83, ["Neon|Fly|Ride"] = 369.46, ["Mega"] = 346.74, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 547.49}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 8.25, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 47.36, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 216.57, ["Mega|Fly"] = 549.54, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 343.72}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 9.19, ["Ride"] = 12.12, ["Fly|Ride"] = 66.85, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.47, ["Neon|Fly|Ride"] = 129.74, ["Mega"] = 13.02, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 107}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.37, ["Ride"] = 18.55, ["Fly|Ride"] = 48.38, ["Neon"] = 28.65, ["Neon|Fly"] = 115.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 82.34, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 310.55, ["Fly"] = 404.55, ["Ride"] = 316.94, ["Fly|Ride"] = 421.32, ["Neon"] = 1448.96, ["Neon|Ride"] = 1372.81, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 4254.24}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 88.36, ["Ride"] = 136.37, ["Fly|Ride"] = 293.54, ["Neon"] = 315, ["Neon|Ride"] = 411.65, ["Neon|Fly|Ride"] = 480.59, ["Mega"] = 4116.33, ["Mega|Ride"] = 1317.24, ["Mega|Fly|Ride"] = 1695.46}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 28.51, ["Neon"] = 16.48, ["Neon|Fly"] = 68.97, ["Neon|Ride"] = 31.22, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 152.33, ["Mega|Fly"] = 204.8, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.45, ["Ride"] = 15.14, ["Fly|Ride"] = 27.81, ["Neon"] = 4.13, ["Neon|Fly"] = 39.12, ["Neon|Ride"] = 25.52, ["Neon|Fly|Ride"] = 53.2, ["Mega"] = 68.25, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 102.93, ["Mega|Fly|Ride"] = 171.42}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.18, ["Fly"] = 96.75, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.29, ["Mega"] = 137.92, ["Mega|Ride"] = 410.62, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 274.1, ["Fly"] = 420, ["Ride"] = 292.73, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 1029.09, ["Neon|Fly|Ride"] = 1427.34, ["Mega|Ride"] = 8232.65, ["Mega|Fly|Ride"] = 3417.59}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 16.73, ["Fly|Ride"] = 43.23, ["Neon"] = 19.69, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 47.32, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 196.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.52, ["Fly"] = 154.9, ["Ride"] = 82.3, ["Fly|Ride"] = 205.83, ["Neon"] = 39.38, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 273.75, ["Mega"] = 236.25, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.19, ["Neon|Ride"] = 155.71, ["Mega"] = 62.79, ["Mega|Ride"] = 200.71}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 7.97, ["Ride"] = 19.82, ["Fly|Ride"] = 64.85, ["Neon"] = 79.38, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 171.87, ["Mega"] = 728.44, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 616.44}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 55.79, ["Fly"] = 154.87, ["Ride"] = 89.25, ["Fly|Ride"] = 209.99, ["Neon"] = 103.85, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 199.18, ["Neon|Fly|Ride"] = 427.08, ["Mega"] = 448.37, ["Mega|Fly"] = 2161.08, ["Mega|Ride"] = 521.76, ["Mega|Fly|Ride"] = 704.49}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 45.29, ["Ride"] = 46.25, ["Fly|Ride"] = 112.88, ["Neon"] = 205.83, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega"] = 823.28, ["Mega|Ride"] = 823.28, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 14.9, ["Fly|Ride"] = 27.81, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 60.74, ["Mega"] = 19.69, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 57.64, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 196.74, ["Ride"] = 307.02, ["Fly|Ride"] = 275.63, ["Neon"] = 3235.75, ["Neon|Ride"] = 1440.73, ["Neon|Fly|Ride"] = 1111.6}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.15, ["Fly"] = 82.34, ["Fly|Ride"] = 105, ["Neon"] = 91.77, ["Neon|Ride"] = 155.4, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 693.46}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.6, ["Fly|Ride"] = 48.38, ["Neon"] = 6.57, ["Neon|Fly"] = 33.57, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 60.74, ["Mega|Fly"] = 274.78, ["Mega|Ride"] = 54.69, ["Mega|Fly|Ride"] = 138.7}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.89, ["Ride"] = 19.46, ["Fly|Ride"] = 36.78, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 110.12, ["Mega"] = 25.36, ["Mega|Fly"] = 137.92, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 152.33}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 9.38, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 6860.89, ["Mega"] = 129.84, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.67, ["Fly"] = 38.74, ["Ride"] = 24.32, ["Fly|Ride"] = 70.88, ["Neon"] = 53.47, ["Neon|Fly"] = 261.4, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 117.33, ["Mega"] = 341.21, ["Mega|Ride"] = 318.34, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.14, ["Ride"] = 55.08, ["Fly|Ride"] = 72.19, ["Neon"] = 59.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 216.57, ["Mega|Ride"] = 343.72, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 274.78, ["Neon"] = 3.49, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.19, ["Fly"] = 96.75, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 26.25, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 67.65, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 185.49, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 300.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 117.78, ["Neon"] = 3.94, ["Neon|Fly"] = 110.12, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 25.4, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 13.13, ["Fly|Ride"] = 42, ["Neon"] = 4.39, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 50.12, ["Mega|Ride"] = 82.3, ["Mega|Fly|Ride"] = 204}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Ride"] = 695.27, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.44, ["Mega|Fly|Ride"] = 12731.79}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 13.13, ["Fly|Ride"] = 29.3, ["Neon"] = 10.5, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 43.64, ["Mega"] = 184.23, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 44.25, ["Fly|Ride"] = 82.34, ["Neon"] = 17.35, ["Neon|Fly"] = 617.47, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 65.62, ["Mega|Fly"] = 315, ["Mega|Ride"] = 88.39, ["Mega|Fly|Ride"] = 288.16}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.01, ["Fly"] = 47.16, ["Ride"] = 20.82, ["Fly|Ride"] = 57.64, ["Neon"] = 52.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 549.54, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 364.08}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.48, ["Fly|Ride"] = 33.5, ["Neon"] = 11.91, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 60.5, ["Mega"] = 65.62, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 155.33}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.15, ["Ride"] = 83.99, ["Fly|Ride"] = 273.75, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 896.56}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 137.92, ["Ride"] = 18.38, ["Fly|Ride"] = 63.74, ["Neon"] = 6.57, ["Neon|Fly"] = 131.77, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 63.59, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 270.45}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 22.97, ["Fly|Ride"] = 60.74, ["Neon"] = 15.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 14.96, ["Mega"] = 93.5, ["Mega|Fly"] = 274.78, ["Mega|Ride"] = 171.06, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 49.83, ["Neon"] = 5.18, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 41.91, ["Mega|Fly"] = 250.63, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 137.92}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 16.57, ["Fly"] = 17.64, ["Ride"] = 18.4, ["Fly|Ride"] = 41.06, ["Neon"] = 308.56, ["Neon|Ride"] = 92.64, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 823.28, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 800.63, ["Ride"] = 866.24, ["Fly|Ride"] = 820.32, ["Neon"] = 1706.25, ["Neon|Ride"] = 1754.16, ["Neon|Fly|Ride"] = 1952.99, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.48, ["Fly|Ride"] = 32.42, ["Neon"] = 3.5, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 19.51, ["Neon|Fly|Ride"] = 57.81, ["Mega"] = 55.5, ["Mega|Ride"] = 74.32, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.35, ["Ride"] = 27.81, ["Fly|Ride"] = 115.58, ["Neon"] = 48.38, ["Neon|Fly"] = 152.33, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 273.75, ["Mega"] = 301.88, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 473.4}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 61.77, ["Ride"] = 70.87, ["Fly|Ride"] = 113.28, ["Neon"] = 295.32, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 531.02, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1262.69}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 25.1, ["Ride"] = 39.38, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 168.78, ["Mega"] = 763.6, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 23.78, ["Ride"] = 26.23, ["Fly|Ride"] = 82.34, ["Neon"] = 55.13, ["Neon|Ride"] = 111.18, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 398.27, ["Mega|Ride"] = 485.73, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.9, ["Ride"] = 76.17, ["Neon"] = 107.62, ["Neon|Ride"] = 135.85, ["Mega"] = 244.52, ["Mega|Fly"] = 501.6, ["Mega|Ride"] = 341.67, ["Mega|Fly|Ride"] = 487.8}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 32.82, ["Ride"] = 88.52, ["Neon"] = 274.36, ["Neon|Ride"] = 307, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 924, ["Mega|Ride"] = 631.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.48}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.45, ["Fly"] = 65.63, ["Ride"] = 26.77, ["Fly|Ride"] = 78.75, ["Neon"] = 39.12, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 493.49, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 18.55, ["Mega"] = 863.34}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 49.8, ["Fly"] = 411.79, ["Ride"] = 60.23, ["Fly|Ride"] = 94.5, ["Neon"] = 271.69, ["Neon|Ride"] = 240.82, ["Neon|Fly|Ride"] = 245.97, ["Mega|Ride"] = 894.55, ["Mega|Fly|Ride"] = 918.63}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.93, ["Fly"] = 18.27, ["Ride"] = 17.53, ["Fly|Ride"] = 39.37, ["Neon"] = 29.3, ["Neon|Fly"] = 93.66, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 274.78, ["Mega|Ride"] = 188.33, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.94, ["Fly"] = 82.34, ["Ride"] = 27.36, ["Fly|Ride"] = 104.97, ["Neon"] = 27.28, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 123.51, ["Mega"] = 126.06, ["Mega|Ride"] = 177.31, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 45.94, ["Mega"] = 42, ["Mega|Ride"] = 96.75, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.18, ["Fly"] = 61.76, ["Ride"] = 58.97, ["Fly|Ride"] = 120.75, ["Neon"] = 152.33, ["Neon|Ride"] = 148.05, ["Neon|Fly|Ride"] = 386.05, ["Mega"] = 1098.05, ["Mega|Ride"] = 782.12, ["Mega|Fly|Ride"] = 770.87}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.28, ["Fly|Ride"] = 65.54, ["Neon"] = 2.63, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 65.89, ["Mega"] = 99.41, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 310.27}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 14.44, ["Fly"] = 55.59, ["Ride"] = 60.8, ["Fly|Ride"] = 271.69, ["Neon"] = 82.34, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 357.1, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 657.6}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.77, ["Ride"] = 13.18, ["Fly|Ride"] = 37.52, ["Neon"] = 26.77, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 61.73, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.07, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 65.63, ["Neon"] = 77.44, ["Neon|Ride"] = 410.93, ["Mega"] = 377.69, ["Mega|Ride"] = 389.01, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 7.24, ["Ride"] = 60.52, ["Fly|Ride"] = 131.25, ["Neon"] = 47.36, ["Neon|Ride"] = 154.88, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 37.7, ["Ride"] = 125.5, ["Neon"] = 192.94, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 436.34, ["Mega"] = 1646.54, ["Mega|Ride"] = 1633.16, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.65, ["Ride"] = 119.01, ["Neon"] = 107.63, ["Neon|Ride"] = 411.65, ["Mega"] = 411.65, ["Mega|Ride"] = 427.08, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.93, ["Ride"] = 105, ["Neon"] = 77.17, ["Neon|Ride"] = 105, ["Mega"] = 205.83, ["Mega|Ride"] = 974.56, ["Mega|Fly|Ride"] = 1646.54}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.91, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 174.51, ["Neon|Ride"] = 617.47, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 823.28, ["Mega|Ride"] = 879.27, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 105, ["Neon|Ride"] = 274.78, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.81, ["Ride"] = 14.65, ["Fly|Ride"] = 39.38, ["Neon"] = 5.18, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 68.97, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 319.6}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 8.87, ["Fly"] = 50.19, ["Ride"] = 55.59, ["Fly|Ride"] = 77.89, ["Neon"] = 14.7, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 96.75, ["Mega"] = 108.73, ["Mega|Fly|Ride"] = 406.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.86, ["Ride"] = 23.98, ["Fly|Ride"] = 55.95, ["Neon"] = 7.76, ["Neon|Fly"] = 31.22, ["Neon|Ride"] = 29.86, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.16, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 190.64}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 68.97, ["Neon"] = 17.35, ["Neon|Ride"] = 97.78, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 250.59, ["Mega|Ride"] = 180.05, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 462.33, ["Neon|Ride"] = 82.34, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Fly|Ride"] = 1208.15}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 26.6, ["Fly|Ride"] = 39.38, ["Neon"] = 21, ["Neon|Fly"] = 102.74, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 87.29, ["Mega"] = 157.2, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 18.35, ["Fly|Ride"] = 51.69, ["Neon"] = 27.75, ["Neon|Fly"] = 82.34, ["Neon|Ride"] = 54.12, ["Neon|Fly|Ride"] = 123.51, ["Mega"] = 205.83, ["Mega|Ride"] = 227.45}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 12.18, ["Fly"] = 88.52, ["Ride"] = 42.84, ["Neon"] = 18.38, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 130.1, ["Neon|Fly|Ride"] = 192.45, ["Mega"] = 231.16, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 323.61}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.36, ["Fly"] = 205.83, ["Ride"] = 112.25, ["Fly|Ride"] = 242.82, ["Neon"] = 122.48, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 413.12, ["Mega"] = 484.32, ["Mega|Fly"] = 686.41, ["Mega|Ride"] = 518.61, ["Mega|Fly|Ride"] = 728.03}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 49.26, ["Ride"] = 109.1, ["Fly|Ride"] = 211.32, ["Neon"] = 288.81, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 471.57, ["Mega"] = 1076.25, ["Mega|Ride"] = 1081.58, ["Mega|Fly|Ride"] = 1148.09}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.56, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Mega"] = 20.6, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.63, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 56.96, ["Fly"] = 105, ["Ride"] = 78.75, ["Neon"] = 304.5, ["Neon|Ride"] = 274.78, ["Mega|Ride"] = 1070.25, ["Mega|Fly|Ride"] = 1358.4}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.25, ["Fly"] = 190.32, ["Ride"] = 31.29, ["Fly|Ride"] = 126, ["Neon"] = 46.87, ["Neon|Ride"] = 89.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 192.93, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.24, ["Ride"] = 89.55, ["Fly|Ride"] = 137.7, ["Neon"] = 7.77, ["Neon|Ride"] = 40.69, ["Mega"] = 61.74, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 97.22, ["Mega|Fly|Ride"] = 274.87}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 686.41, ["Ride"] = 18.27, ["Fly|Ride"] = 45.94, ["Neon"] = 10.49, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 112.14, ["Mega"] = 164.07, ["Mega|Fly"] = 343.72, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.64, ["Ride"] = 15.45, ["Fly|Ride"] = 32.7, ["Neon"] = 2.61, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.28, ["Fly|Ride"] = 78.12, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 102.93, ["Mega"] = 46.19, ["Mega|Fly"] = 168, ["Mega|Ride"] = 68.97, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Fly|Ride"] = 154.87, ["Neon"] = 2.5, ["Neon|Ride"] = 47.36, ["Mega"] = 22.79, ["Mega|Ride"] = 549.54, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.86, ["Ride"] = 44.26, ["Neon"] = 30.19, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 617.47, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 183.47}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.6, ["Ride"] = 21, ["Fly|Ride"] = 189.54, ["Neon"] = 52.5, ["Neon|Ride"] = 102.93, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 279.92, ["Mega|Ride"] = 549.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.09, ["Fly"] = 21.95, ["Ride"] = 18.63, ["Fly|Ride"] = 44.94, ["Neon"] = 32.71, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 91.83, ["Mega|Ride"] = 342.87, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 131.25, ["Ride"] = 262.43, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1772.9}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 27.76, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 137.92, ["Neon"] = 261.4, ["Neon|Fly|Ride"] = 630, ["Mega"] = 876.05, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.26, ["Ride"] = 16.37, ["Fly|Ride"] = 41.18, ["Neon"] = 3.94, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 53.52, ["Mega"] = 32.48, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.73, ["Fly|Ride"] = 31.55, ["Neon"] = 5.22, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 17.52, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 44.63, ["Mega|Fly"] = 82.34, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 99.94}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 598.73, ["Ride"] = 530.01, ["Fly|Ride"] = 548.58, ["Neon|Fly|Ride"] = 1777.23}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.07, ["Ride"] = 90.2, ["Neon"] = 53.18, ["Neon|Ride"] = 117.33, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Ride"] = 398.27, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.38, ["Ride"] = 15.27, ["Fly|Ride"] = 31.21, ["Neon"] = 2.1, ["Neon|Fly"] = 26.7, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 54.99, ["Mega"] = 39.38, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 64.03, ["Ride"] = 109.12, ["Fly|Ride"] = 328.13, ["Neon"] = 255.29, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 508.56, ["Mega"] = 921.04, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1156.7}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.64, ["Ride"] = 19.57, ["Fly|Ride"] = 45.92, ["Neon"] = 12.71, ["Neon|Fly"] = 43.95, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 85.22, ["Mega|Fly"] = 247, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 194.5}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 39.31, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.94, ["Neon|Ride"] = 31.91, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 21.95, ["Mega|Fly"] = 274.78, ["Mega|Ride"] = 69.47, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 48.37, ["Fly"] = 167.06, ["Ride"] = 100.86, ["Fly|Ride"] = 111.57, ["Neon"] = 169.31, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.54, ["Fly|Ride"] = 52.5, ["Neon"] = 5.97, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 63, ["Mega"] = 121.35, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 93.66, ["Fly|Ride"] = 137.92, ["Neon"] = 307.71, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1625.96, ["Mega|Ride"] = 1646.54, ["Mega|Fly|Ride"] = 1208.15}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 55.59, ["Neon"] = 21.75, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 480.59, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.5, ["Fly"] = 23.63, ["Ride"] = 26.25, ["Fly|Ride"] = 65.88, ["Neon"] = 9.26, ["Neon|Ride"] = 51.48, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.45, ["Mega|Ride"] = 137.92, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.69, ["Fly"] = 59.07, ["Ride"] = 98.81, ["Fly|Ride"] = 514.55, ["Neon"] = 326.82, ["Neon|Ride"] = 700.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2056.11, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1290.48}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.23, ["Ride"] = 31.91, ["Fly|Ride"] = 908.98, ["Neon"] = 6.35, ["Neon|Ride"] = 37.07, ["Neon|Fly|Ride"] = 151.41, ["Mega"] = 41.99, ["Mega|Fly"] = 252.14, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 17.35, ["Fly|Ride"] = 102.88, ["Neon"] = 11.82, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 96.75, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.29, ["Fly"] = 48.38, ["Ride"] = 28.67, ["Fly|Ride"] = 77.44, ["Neon"] = 77.49, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 131.74, ["Mega"] = 430.5, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 23.69, ["Ride"] = 31.5, ["Fly|Ride"] = 73.07, ["Neon"] = 91.75, ["Neon|Ride"] = 80.21, ["Neon|Fly|Ride"] = 130.71, ["Mega"] = 900.45, ["Mega|Ride"] = 410.62, ["Mega|Fly|Ride"] = 582.47}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.7, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 64.85, ["Neon"] = 68.97, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 155.4, ["Mega"] = 537.12, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 343.01}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 61.6, ["Ride"] = 128.63, ["Fly|Ride"] = 222.1, ["Neon"] = 299.24, ["Neon|Ride"] = 492.95, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 1386.89, ["Mega|Ride"] = 1484.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.66, ["Ride"] = 46.45, ["Fly|Ride"] = 308.75, ["Neon"] = 20.82, ["Neon|Ride"] = 104.97, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 213.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 315.94}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.94, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 55.77, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 185.07, ["Mega|Ride"] = 190.81, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.96, ["Fly"] = 52.5, ["Ride"] = 40.15, ["Fly|Ride"] = 137.92, ["Neon"] = 46.25, ["Neon|Ride"] = 392.43, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 379.32, ["Mega|Ride"] = 315.94, ["Mega|Fly|Ride"] = 493.98}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.69, ["Fly|Ride"] = 19.68, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 13.95, ["Mega|Ride"] = 23.61, ["Mega|Fly|Ride"] = 86.54}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 55.5, ["Fly"] = 218.18, ["Ride"] = 96.75, ["Neon"] = 205.7, ["Neon|Fly"] = 2332.94, ["Neon|Ride"] = 225.11, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1079.47, ["Mega|Ride"] = 1497.2, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.85, ["Fly|Ride"] = 112.22, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 51.26, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.81, ["Ride"] = 15.75, ["Fly|Ride"] = 45.93, ["Neon"] = 18.55, ["Neon|Fly"] = 137.92, ["Neon|Ride"] = 31.13, ["Neon|Fly|Ride"] = 94.69, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 85.32, ["Ride"] = 160.55, ["Fly|Ride"] = 223.13, ["Neon"] = 334.69, ["Neon|Ride"] = 385.91, ["Neon|Fly|Ride"] = 684.17, ["Mega"] = 1247.4, ["Mega|Ride"] = 1098.05, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 7.79, ["Neon|Ride"] = 36.03, ["Mega"] = 65.54, ["Mega|Ride"] = 104.56, ["Mega|Fly|Ride"] = 232.59}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 12.47}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 35.44, ["Fly|Ride"] = 57.72, ["Neon"] = 3.84, ["Neon|Ride"] = 44.09, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 48.2, ["Mega|Ride"] = 131.77, ["Mega|Fly|Ride"] = 198.18}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 110.15, ["Ride"] = 203.78, ["Fly|Ride"] = 262.5, ["Neon"] = 645.25, ["Neon|Ride"] = 674.06, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3544.63, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2827.93}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 40.85, ["Neon"] = 14.44, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 160.02, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Neon"] = 6.57, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 130.52}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.24, ["Ride"] = 26.5, ["Neon"] = 38.98, ["Neon|Ride"] = 110.12, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 258.32, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.02, ["Fly"] = 25.47, ["Ride"] = 20.86, ["Fly|Ride"] = 54.33, ["Neon"] = 85.85, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 179.07, ["Mega"] = 597.19, ["Mega|Ride"] = 427.08, ["Mega|Fly|Ride"] = 480.59}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 24.43, ["Ride"] = 80.2, ["Fly|Ride"] = 106.01, ["Neon"] = 150.8, ["Neon|Ride"] = 158.97, ["Neon|Fly|Ride"] = 319.01, ["Mega"] = 525, ["Mega|Ride"] = 582.52, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.38, ["Fly"] = 183.75, ["Ride"] = 170.63, ["Fly|Ride"] = 229.69, ["Neon"] = 590.85, ["Neon|Ride"] = 577.49, ["Neon|Fly|Ride"] = 611.73, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 23.13, ["Fly"] = 41.91, ["Ride"] = 26.25, ["Fly|Ride"] = 51.98, ["Neon"] = 133.47, ["Neon|Fly"] = 204.8, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 677.15, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 20.6, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 135.19, ["Mega|Ride"] = 203.78, ["Mega|Fly|Ride"] = 247.1}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.28, ["Fly"] = 231.14, ["Ride"] = 27.46, ["Fly|Ride"] = 117.33, ["Neon"] = 65.45, ["Neon|Fly"] = 137.92, ["Neon|Ride"] = 68.97, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 143.07, ["Ride"] = 69.19, ["Fly|Ride"] = 179.07, ["Neon"] = 236.25, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 253.17, ["Mega"] = 1234.91, ["Mega|Ride"] = 1080.55, ["Mega|Fly|Ride"] = 1065.49}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.03, ["Ride"] = 121.31, ["Neon"] = 137.92, ["Neon|Ride"] = 238.75, ["Neon|Fly|Ride"] = 453.84, ["Mega"] = 682.5, ["Mega|Ride"] = 823.28, ["Mega|Fly|Ride"] = 822.25}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 411.65, ["Fly|Ride"] = 384.89, ["Neon|Ride"] = 3082.47, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 44.63, ["Fly"] = 65.63, ["Ride"] = 55.61, ["Fly|Ride"] = 74.82, ["Neon"] = 224.26, ["Neon|Ride"] = 224.79, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 879.88}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.06, ["Ride"] = 13.13, ["Fly|Ride"] = 102.55, ["Neon"] = 2.63, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 64.35, ["Mega"] = 18.23, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 122.36, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 15.19, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 216.14, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly|Ride"] = 144.17, ["Neon"] = 24.94, ["Neon|Ride"] = 81.31, ["Neon|Fly|Ride"] = 961.17, ["Mega"] = 125.16, ["Mega|Fly"] = 549.54, ["Mega|Ride"] = 259.34, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.87, ["Ride"] = 458.07, ["Fly|Ride"] = 514.55, ["Neon"] = 1386.76, ["Neon|Ride"] = 1221.53, ["Neon|Fly|Ride"] = 1373.24, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.88, ["Fly"] = 58.76, ["Ride"] = 16.86, ["Fly|Ride"] = 52.5, ["Neon"] = 20.6, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 82.34, ["Mega"] = 168, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.6, ["Fly"] = 17.18, ["Ride"] = 17.07, ["Fly|Ride"] = 43.23, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 51.48, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 686.41, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.09, ["Fly"] = 39.31, ["Ride"] = 27.56, ["Neon"] = 17.53, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 110.97, ["Mega"] = 78.75, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 303.6}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.66, ["Fly"] = 45.93, ["Ride"] = 40.2, ["Fly|Ride"] = 82.34, ["Neon"] = 137.92, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 822.25, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 26.99, ["Fly|Ride"] = 68.2, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 440.46, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.84, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.63, ["Neon"] = 137.92, ["Neon|Ride"] = 164.33, ["Neon|Fly|Ride"] = 274.78, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.91, ["Neon|Ride"] = 20.6, ["Mega"] = 50.3, ["Mega|Ride"] = 137.92, ["Mega|Fly|Ride"] = 233.61}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 54.1, ["Ride"] = 137.92, ["Neon"] = 94.5, ["Mega"] = 315, ["Mega|Ride"] = 341.25}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.82, ["Ride"] = 39.38, ["Neon"] = 69.47, ["Neon|Ride"] = 102.93, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 316.32, ["Mega|Ride"] = 305.12, ["Mega|Fly|Ride"] = 546.46}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.22, ["Fly"] = 55.59, ["Ride"] = 30.17, ["Fly|Ride"] = 65.71, ["Neon"] = 51.06, ["Neon|Fly"] = 68.97, ["Neon|Ride"] = 58.67, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 578.36, ["Mega|Ride"] = 406.5, ["Mega|Fly|Ride"] = 419.39}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 410.26, ["Ride"] = 288.75, ["Fly|Ride"] = 389.81, ["Neon"] = 1467.48, ["Neon|Ride"] = 1229.82, ["Neon|Fly|Ride"] = 1276.57, ["Mega|Fly|Ride"] = 5077.5}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 56.8, ["Neon"] = 10.4, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 220.23, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.68, ["Fly"] = 27.71, ["Ride"] = 27.81, ["Fly|Ride"] = 80.27, ["Neon"] = 37.7, ["Neon|Ride"] = 131.77, ["Neon|Fly|Ride"] = 261.4, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 33.77, ["Fly"] = 117.33, ["Ride"] = 41.18, ["Fly|Ride"] = 201.09, ["Neon"] = 185.26, ["Neon|Ride"] = 205.83, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 360.84, ["Mega|Fly|Ride"] = 516.62}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 116.82, ["Ride"] = 161.99, ["Fly|Ride"] = 443.57, ["Neon"] = 1098.05, ["Neon|Ride"] = 1079.51, ["Neon|Fly|Ride"] = 615.4, ["Mega"] = 3082.33, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2813.52}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 22.66, ["Fly"] = 102.38, ["Ride"] = 76.56, ["Fly|Ride"] = 185.26, ["Neon"] = 96.75, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 197.03, ["Mega"] = 220.37, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.7, ["Fly|Ride"] = 51.79, ["Neon"] = 10.39, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 52.5, ["Mega|Ride"] = 193.02, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 17.07, ["Ride"] = 38.09, ["Fly|Ride"] = 81.31, ["Neon"] = 55.06, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 171.08, ["Mega"] = 160.79, ["Mega|Ride"] = 187.93}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 61.69, ["Fly"] = 196.88, ["Ride"] = 89.44, ["Fly|Ride"] = 216.57, ["Neon"] = 156.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 350.51, ["Mega"] = 467.78, ["Mega|Ride"] = 514.54, ["Mega|Fly|Ride"] = 562.92}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 69.3, ["Neon"] = 7.49, ["Neon|Ride"] = 205.83, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 65.61, ["Mega|Ride"] = 167.71, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.31, ["Fly|Ride"] = 273.75, ["Neon"] = 111.91, ["Neon|Ride"] = 401.03, ["Mega"] = 523.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 814.02}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 961.54, ["Fly"] = 1252.7, ["Ride"] = 1050, ["Fly|Ride"] = 1128.75, ["Neon|Ride"] = 3854.53, ["Neon|Fly|Ride"] = 2723.44, ["Mega|Fly|Ride"] = 14269.23}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.87, ["Fly"] = 115.59, ["Ride"] = 119.38, ["Fly|Ride"] = 191.63, ["Neon"] = 127.35, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 192.45, ["Mega"] = 411.65, ["Mega|Ride"] = 577.88, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 20.6, ["Fly|Ride"] = 41.18, ["Neon"] = 13.13, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 78.66, ["Mega|Ride"] = 152.33, ["Mega|Fly|Ride"] = 178.28}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 5.25, ["Ride"] = 47.25, ["Fly|Ride"] = 137.92, ["Neon"] = 201.09, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 220.23, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 17.91, ["Fly|Ride"] = 59.49, ["Neon"] = 2.1, ["Neon|Ride"] = 22.22, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 21.97, ["Mega|Fly"] = 123.51, ["Mega|Ride"] = 50.71, ["Mega|Fly|Ride"] = 154.25}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.49, ["Ride"] = 109.08, ["Fly|Ride"] = 236.25, ["Neon"] = 329.32, ["Neon|Ride"] = 366.98, ["Mega"] = 1030.53, ["Mega|Ride"] = 1574.99, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.27, ["Ride"] = 23.63, ["Fly|Ride"] = 101.07, ["Neon"] = 45.85, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 108.66, ["Mega"] = 398.27, ["Mega|Ride"] = 465.17, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.77, ["Fly|Ride"] = 46.25, ["Neon"] = 8.99, ["Neon|Ride"] = 65.63, ["Mega"] = 99.74, ["Mega|Ride"] = 258.03}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 82.66, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 118.36, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 684.36, ["Mega|Ride"] = 411.65, ["Mega|Fly|Ride"] = 770.87}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 10.85, ["Ride"] = 52.48, ["Fly|Ride"] = 86.41, ["Neon"] = 50.04, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 315, ["Mega"] = 576.73, ["Mega|Ride"] = 502.21, ["Mega|Fly|Ride"] = 453.84}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 38.68, ["Ride"] = 84, ["Neon"] = 385.98, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 943.69, ["Mega"] = 1867.7, ["Mega|Ride"] = 1646.54, ["Mega|Fly|Ride"] = 1584.79}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.94, ["Neon"] = 26.24, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 123.51, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 287.34}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.48, ["Ride"] = 20.52, ["Fly|Ride"] = 78.74, ["Neon"] = 45.94, ["Neon|Ride"] = 65.76, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 399, ["Mega|Ride"] = 367.48, ["Mega|Fly|Ride"] = 427.08}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 110.25, ["Fly"] = 514.55, ["Ride"] = 157.04, ["Fly|Ride"] = 265.48, ["Neon"] = 494.69, ["Neon|Ride"] = 524.9, ["Neon|Fly|Ride"] = 594.51, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 15.75, ["Fly|Ride"] = 41.15, ["Neon"] = 11.46, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 124.59, ["Mega|Fly"] = 123.68, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.24, ["Fly"] = 92.89, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 72.77, ["Neon|Fly"] = 231.17, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 152.33, ["Mega"] = 378.83, ["Mega|Ride"] = 329.32, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 10.5, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 14.95, ["Mega|Fly"] = 48.55, ["Mega|Ride"] = 39.12, ["Mega|Fly|Ride"] = 82.68}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 131.14, ["Fly|Ride"] = 131.25, ["Neon"] = 3.54, ["Neon|Ride"] = 39.12, ["Mega"] = 22.15, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 60.52, ["Mega|Fly|Ride"] = 110.12}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 58.96, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 110.12, ["Mega|Fly|Ride"] = 240.85}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.12, ["Ride"] = 315, ["Neon"] = 117.74, ["Neon|Ride"] = 411.65, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 665.82}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 16.62, ["Fly|Ride"] = 30.6, ["Neon"] = 13.81, ["Neon|Fly"] = 21, ["Neon|Ride"] = 25.85, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 108.65, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 138.01}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.25, ["Fly"] = 37.32, ["Ride"] = 24.05, ["Fly|Ride"] = 49.41, ["Neon"] = 24.83, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.16, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 182.44, ["Mega|Fly"] = 411.65, ["Mega|Ride"] = 155.93, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.94, ["Fly"] = 26.77, ["Ride"] = 18.09, ["Fly|Ride"] = 77.93, ["Neon"] = 15.45, ["Neon|Fly"] = 85.55, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 55.04, ["Mega|Fly"] = 101.9, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.96, ["Fly"] = 36.03, ["Ride"] = 32.95, ["Neon"] = 35.44, ["Neon|Ride"] = 81, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.84, ["Ride"] = 122.72, ["Fly|Ride"] = 219.58, ["Neon"] = 123.98, ["Neon|Ride"] = 262.39, ["Mega"] = 549.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.91, ["Fly"] = 41.88, ["Ride"] = 26.77, ["Fly|Ride"] = 68.97, ["Neon"] = 24.31, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 329.32, ["Mega|Ride"] = 231.16, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.74, ["Fly|Ride"] = 34.95, ["Neon"] = 11.65, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.15, ["Mega|Ride"] = 137.92, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 389.82, ["Ride"] = 245.97, ["Fly|Ride"] = 392.43, ["Neon"] = 1125.84, ["Neon|Ride"] = 1234.91, ["Neon|Fly|Ride"] = 1090.84, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.36, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 119.62, ["Mega|Ride"] = 411.65, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.63, ["Fly|Ride"] = 79.07, ["Neon"] = 20.26, ["Neon|Fly"] = 274.78, ["Neon|Ride"] = 46.25, ["Neon|Fly|Ride"] = 201.12, ["Mega"] = 201.1, ["Mega|Ride"] = 321.08, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.44, ["Ride"] = 35, ["Neon"] = 27.57, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 617.47, ["Mega"] = 461.15, ["Mega|Ride"] = 329.32, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 12.36, ["Ride"] = 13.13, ["Fly|Ride"] = 36.03, ["Neon"] = 2.1, ["Neon|Fly"] = 28.77, ["Neon|Ride"] = 15.18, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 17.07, ["Fly|Ride"] = 85.35, ["Neon"] = 9.17, ["Neon|Fly"] = 31.22, ["Neon|Ride"] = 28.98, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 101.04, ["Mega|Ride"] = 143.59, ["Mega|Fly|Ride"] = 203.16}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 68.97, ["Neon"] = 16.48, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.59, ["Mega|Ride"] = 204.8, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.63, ["Fly"] = 123.51, ["Ride"] = 110.31, ["Fly|Ride"] = 135.85, ["Neon"] = 617.11, ["Neon|Ride"] = 461.05, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 2058.17, ["Mega|Ride"] = 3432, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.35, ["Fly"] = 91.88, ["Ride"] = 31.21, ["Fly|Ride"] = 262.48, ["Neon"] = 22.32, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 92.48, ["Mega"] = 209.42, ["Mega|Ride"] = 357.1, ["Mega|Fly|Ride"] = 410.62}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.36, ["Neon"] = 2.63, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 518.96, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 343.72}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 54.84, ["Fly"] = 210, ["Ride"] = 90.02, ["Fly|Ride"] = 205.83, ["Neon"] = 118.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 303.6, ["Mega"] = 626.07, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 12.92, ["Fly|Ride"] = 29.28, ["Neon"] = 2.1, ["Neon|Fly"] = 18.55, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 17.06, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 44.26, ["Mega|Fly|Ride"] = 112.77}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 64.85, ["Neon|Fly|Ride"] = 123.68, ["Mega"] = 53.45, ["Mega|Ride"] = 96.8, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 9.19, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 58.54, ["Mega|Fly"] = 179.07, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 200.02}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 11.16, ["Fly"] = 68.25, ["Ride"] = 36.03, ["Fly|Ride"] = 130.71, ["Neon"] = 18.06, ["Neon|Fly"] = 137.92, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 231.17, ["Mega"] = 104.52, ["Mega|Fly"] = 331.71, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 253.18}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 15.33, ["Fly|Ride"] = 31.91, ["Neon"] = 2.1, ["Neon|Fly"] = 25.67, ["Neon|Ride"] = 48.38, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 24.94, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.99, ["Ride"] = 123.51, ["Neon"] = 101.7, ["Neon|Fly"] = 411.65, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 961.17, ["Mega"] = 410.62, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 679.21}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2840.28, ["Ride"] = 2613.66, ["Fly|Ride"] = 2520, ["Neon"] = 10290.8, ["Neon|Fly|Ride"] = 9605.45, ["Mega|Fly|Ride"] = 34577.1}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.18, ["Ride"] = 15.36, ["Fly|Ride"] = 39.31, ["Neon"] = 9.19, ["Neon|Fly"] = 62.43, ["Neon|Ride"] = 24.71, ["Neon|Fly|Ride"] = 45.04, ["Mega"] = 81.38, ["Mega|Fly"] = 457.95, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 137.92, ["Mega|Fly|Ride"] = 192.45}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 129.47, ["Fly"] = 110.12, ["Ride"] = 33.5, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Ride"] = 105.57, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 345.19, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 535.14}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 31.87, ["Ride"] = 66.94, ["Neon"] = 154.87, ["Neon|Ride"] = 205.83, ["Mega"] = 462.74, ["Mega|Ride"] = 768.74, ["Mega|Fly|Ride"] = 809.02}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 169.32, ["Fly"] = 218.18, ["Ride"] = 197.75, ["Fly|Ride"] = 374.6, ["Neon"] = 782.12, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 787.65, ["Mega"] = 6174.49, ["Mega|Fly|Ride"] = 3378.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.39, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.37, ["Neon|Ride"] = 135.64, ["Mega"] = 156.19, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.59, ["Neon"] = 13.13, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 514.55, ["Mega"] = 120.69, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 40.42, ["Fly|Ride"] = 131.25, ["Neon"] = 8.02, ["Neon|Ride"] = 59.7, ["Mega"] = 78.75, ["Mega|Ride"] = 112.46, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.31, ["Ride"] = 102.93, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.83, ["Neon|Fly|Ride"] = 484.72, ["Mega|Ride"] = 605.11, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.18, ["Neon"] = 2.1, ["Neon|Ride"] = 82.34, ["Mega"] = 17.07, ["Mega|Fly"] = 115.59, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 273.75}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Fly"] = 137.92, ["Ride"] = 110.12, ["Fly|Ride"] = 177.01, ["Neon"] = 411.65, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 440.46, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1725.78}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 96.75, ["Ride"] = 91.84, ["Neon"] = 10.29, ["Neon|Ride"] = 68.97, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 77.19, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.29, ["Fly"] = 205.83, ["Ride"] = 85.49, ["Fly|Ride"] = 157.5, ["Neon"] = 262.5, ["Neon|Ride"] = 261.4, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 2625, ["Mega|Ride"] = 1901.75, ["Mega|Fly|Ride"] = 1546.13}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.5, ["Fly|Ride"] = 50.81, ["Neon"] = 4.64, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 68.97, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 46.92, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 166.82}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 13.55, ["Neon|Ride"] = 65.63, ["Mega"] = 63.26, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 605.11}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.39, ["Fly"] = 17.35, ["Ride"] = 37.41, ["Neon"] = 96.75, ["Neon|Ride"] = 94.69, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 231.18, ["Mega|Ride"] = 345.79, ["Mega|Fly|Ride"] = 770.87}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 422.63, ["Ride"] = 456.74, ["Fly|Ride"] = 556.5, ["Neon"] = 1050, ["Neon|Ride"] = 1210.01, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4193.44}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.29, ["Ride"] = 48.45, ["Fly|Ride"] = 85.54, ["Neon"] = 205.83, ["Neon|Ride"] = 248.36, ["Neon|Fly|Ride"] = 229.49, ["Mega|Ride"] = 1214.33, ["Mega|Fly|Ride"] = 1098.05}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.74, ["Fly|Ride"] = 91.88, ["Neon"] = 8.59, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 57.29, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.51, ["Fly"] = 82.34, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 53.29, ["Neon|Fly"] = 105, ["Neon|Ride"] = 82.34, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 257.25, ["Mega|Fly"] = 951.18, ["Mega|Ride"] = 257.07, ["Mega|Fly|Ride"] = 377.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.85, ["Ride"] = 20.68, ["Fly|Ride"] = 262.43, ["Neon"] = 137.92, ["Neon|Ride"] = 76.17, ["Neon|Fly|Ride"] = 308.61, ["Mega"] = 1098.05, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.83, ["Ride"] = 27.81, ["Neon"] = 20.6, ["Mega"] = 52.5, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 20.37, ["Fly|Ride"] = 57.66, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 137.92, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1646.54}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 111.56, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon"] = 632.14, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 693.48, ["Mega|Fly|Ride"] = 2579.92}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.18, ["Ride"] = 102.93, ["Fly|Ride"] = 137.92, ["Neon"] = 192.94, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 682.5, ["Mega|Ride"] = 761.53, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.02, ["Fly"] = 2349.38, ["Ride"] = 2100, ["Fly|Ride"] = 2254.88, ["Neon"] = 10977.21, ["Neon|Fly|Ride"] = 5775, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 196.87, ["Neon"] = 9.17, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 105, ["Mega"] = 104.89, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.49, ["Ride"] = 53.44, ["Fly|Ride"] = 137.92, ["Neon"] = 32.06, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.26, ["Mega|Ride"] = 300.72, ["Mega|Fly|Ride"] = 627.76}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1025.09, ["Fly"] = 1153.3, ["Ride"] = 1039.68, ["Fly|Ride"] = 969.94, ["Neon"] = 2778.57, ["Neon|Ride"] = 2928.75, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 9439.5}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 30.52, ["Fly"] = 68.97, ["Ride"] = 55.59, ["Fly|Ride"] = 173.35, ["Neon"] = 308.56, ["Neon|Ride"] = 294.67, ["Mega"] = 796.85, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 864.45}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.97, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 137.92, ["Neon"] = 3.94, ["Neon|Fly"] = 41.18, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 26.6, ["Mega|Ride"] = 251.11, ["Mega|Fly|Ride"] = 247}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.91, ["Ride"] = 127.32, ["Fly|Ride"] = 205.83, ["Neon"] = 459.38, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 8232.65, ["Mega|Fly|Ride"] = 2744.57}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.35, ["Neon"] = 15.45, ["Neon|Ride"] = 123.51, ["Neon|Fly|Ride"] = 115.59, ["Mega"] = 145.16, ["Mega|Ride"] = 325.2, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.39, ["Ride"] = 136.49, ["Fly|Ride"] = 85.32, ["Neon"] = 380.63, ["Neon|Ride"] = 462.33, ["Neon|Fly|Ride"] = 411.65}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 2.61, ["Fly"] = 105, ["Fly|Ride"] = 110.12, ["Neon"] = 18.38, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 137.92, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 179.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Ride"] = 270.8, ["Fly|Ride"] = 362.79, ["Neon"] = 1424.53, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.83, ["Ride"] = 20.6, ["Fly|Ride"] = 55.59, ["Neon"] = 78.1, ["Neon|Ride"] = 65.5, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 308.75, ["Mega|Ride"] = 269.39, ["Mega|Fly|Ride"] = 360.12}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.74, ["Fly|Ride"] = 36.03, ["Neon"] = 6.57, ["Neon|Fly"] = 30.89, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 55.13, ["Mega|Fly"] = 110.87, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.92, ["Ride"] = 1050, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 7547.28, ["Neon|Fly|Ride"] = 5461.34, ["Mega"] = 26070.72}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.07, ["Fly"] = 961.17, ["Ride"] = 72.19, ["Neon"] = 42, ["Neon|Ride"] = 130.71, ["Mega"] = 247, ["Mega|Ride"] = 377.69, ["Mega|Fly|Ride"] = 477.5}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 46.09, ["Ride"] = 35.17, ["Fly|Ride"] = 96.8, ["Neon"] = 30.17, ["Neon|Fly"] = 123.68, ["Neon|Ride"] = 53.18, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 182.63, ["Mega|Fly"] = 227.45, ["Mega|Ride"] = 188.24, ["Mega|Fly|Ride"] = 265.55}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 44.28, ["Fly"] = 40.79, ["Ride"] = 43.51, ["Fly|Ride"] = 66.26, ["Neon"] = 131.25, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 2058.17, ["Mega|Ride"] = 1234.91, ["Mega|Fly|Ride"] = 892.21}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.54, ["Fly"] = 59.07, ["Ride"] = 27.43, ["Fly|Ride"] = 89.25, ["Neon"] = 72.86, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.17, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.24, ["Ride"] = 209.99, ["Fly|Ride"] = 401.36, ["Neon"] = 110.55, ["Neon|Ride"] = 540.92, ["Mega"] = 462.3, ["Mega|Ride"] = 574.24, ["Mega|Fly|Ride"] = 879.88}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 231.14, ["Neon"] = 2.1, ["Neon|Ride"] = 108.66, ["Neon|Fly|Ride"] = 308.61, ["Mega"] = 17.35, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.29, ["Fly"] = 102.93, ["Ride"] = 76.04, ["Fly|Ride"] = 131.25, ["Neon"] = 337.51, ["Neon|Fly"] = 381.43, ["Neon|Ride"] = 354.83, ["Neon|Fly|Ride"] = 370.49, ["Mega"] = 3293.07, ["Mega|Fly|Ride"] = 1202.99}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 19.69, ["Fly|Ride"] = 81.58, ["Neon"] = 32.81, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 344.99, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.48, ["Fly|Ride"] = 38.07, ["Neon"] = 14.44, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 28.25, ["Ride"] = 171.87, ["Neon"] = 20.14, ["Neon|Fly|Ride"] = 184.23, ["Mega"] = 274.78}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.39, ["Ride"] = 88.1, ["Fly|Ride"] = 262.5, ["Neon"] = 261.4, ["Neon|Ride"] = 247, ["Neon|Fly|Ride"] = 288.16, ["Mega"] = 1016.75, ["Mega|Ride"] = 1010.63, ["Mega|Fly|Ride"] = 946.78}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.9, ["Fly|Ride"] = 411.65, ["Neon"] = 20.99, ["Neon|Ride"] = 77.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 98.22, ["Mega|Ride"] = 110.12, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.63, ["Neon|Ride"] = 20.6, ["Mega"] = 15.33, ["Mega|Ride"] = 55.59, ["Mega|Fly|Ride"] = 384.89}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.97, ["Ride"] = 25.35, ["Fly|Ride"] = 133.49, ["Neon"] = 2.46, ["Neon|Ride"] = 32.95, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 32.95, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 110.12}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 23.35, ["Ride"] = 15.45, ["Fly|Ride"] = 38.66, ["Neon"] = 5.46, ["Neon|Fly"] = 123.51, ["Neon|Ride"] = 20.39, ["Neon|Fly|Ride"] = 76.17, ["Mega"] = 98.81, ["Mega|Ride"] = 58.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.23, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.45, ["Fly|Ride"] = 32.82, ["Neon"] = 14.34, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 229.04, ["Mega|Ride"] = 274.78, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 52.5, ["Ride"] = 155.23, ["Neon"] = 196.88, ["Neon|Ride"] = 233.61, ["Neon|Fly|Ride"] = 1029.09, ["Mega"] = 1541.74, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 1068.2}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.76, ["Fly|Ride"] = 32.82, ["Neon"] = 3.83, ["Neon|Fly"] = 26.77, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 51.48, ["Mega"] = 28.77, ["Mega|Ride"] = 31.11, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.46, ["Fly"] = 76.05, ["Ride"] = 39.15, ["Fly|Ride"] = 94.69, ["Neon"] = 43.32, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 63.81, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 310.43, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.33, ["Fly"] = 39.39, ["Ride"] = 28.22, ["Fly|Ride"] = 65.62, ["Neon"] = 108.94, ["Neon|Ride"] = 156.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 787.5, ["Mega|Ride"] = 459.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Neon"] = 45.94, ["Mega"] = 288.16, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 16.48, ["Fly|Ride"] = 37, ["Neon"] = 6.19, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 42.95, ["Mega|Fly"] = 168.78, ["Mega|Ride"] = 59.42, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.29, ["Fly"] = 52.5, ["Ride"] = 30.89, ["Neon"] = 11.38, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 87.94, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 398.27}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Fly"] = 1262.69, ["Ride"] = 981.75, ["Fly|Ride"] = 1076.25, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2485.87, ["Mega|Fly|Ride"] = 6929.41}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.38, ["Ride"] = 137.82, ["Fly|Ride"] = 210, ["Neon"] = 413.44, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 604.09, ["Mega"] = 3086.23, ["Mega|Ride"] = 2469.8, ["Mega|Fly|Ride"] = 1681.54}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.59, ["Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 73.02, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 62.27, ["Fly"] = 152.33, ["Ride"] = 95.81, ["Fly|Ride"] = 138.69, ["Neon"] = 301.88, ["Neon|Ride"] = 338.63, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 1050, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1235.67}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.88, ["Ride"] = 26.6, ["Fly|Ride"] = 89.55, ["Neon"] = 19.69, ["Neon|Fly"] = 54.33, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 268.55, ["Mega|Ride"] = 154.38, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.05, ["Fly"] = 411.65, ["Ride"] = 334.69, ["Fly|Ride"] = 463.1, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1743.28, ["Mega|Fly|Ride"] = 4553.56}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 40.15, ["Fly|Ride"] = 200.62, ["Neon"] = 25.5, ["Neon|Ride"] = 54.28, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 308.75, ["Mega|Fly"] = 321.08, ["Mega|Ride"] = 184.93, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 27.71, ["Neon|Ride"] = 154.88, ["Mega"] = 329.32}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.23, ["Ride"] = 78.62, ["Fly|Ride"] = 196.88, ["Neon"] = 104.03, ["Neon|Fly"] = 411.65, ["Neon|Ride"] = 191.42, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 542, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 720.37}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 274.78, ["Neon"] = 20.6, ["Mega"] = 231.16, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 3.86, ["Neon|Fly"] = 31.22, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 37.53, ["Mega"] = 27.66, ["Mega|Ride"] = 39.69, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.25, ["Ride"] = 4436.25, ["Fly|Ride"] = 4449.38, ["Neon"] = 30872.4, ["Neon|Fly|Ride"] = 19896.24, ["Mega|Fly|Ride"] = 85070.95}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.34, ["Fly"] = 39.38, ["Ride"] = 54.51, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 224.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 17.39, ["Fly|Ride"] = 42.86, ["Neon"] = 13.26, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 31.22, ["Neon|Fly|Ride"] = 71.64, ["Mega"] = 144.37, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 192.45}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 462.34, ["Fly"] = 547.77, ["Ride"] = 462.26, ["Fly|Ride"] = 525, ["Neon"] = 1372.81, ["Neon|Ride"] = 1640.38, ["Neon|Fly|Ride"] = 1372.81, ["Mega|Fly|Ride"] = 5489.12}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 139.18, ["Mega|Fly|Ride"] = 686.41}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.1, ["Fly"] = 4116.33, ["Ride"] = 2058.17, ["Neon"] = 131.25, ["Neon|Ride"] = 274.78, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 409.59, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.77, ["Neon"] = 5.08, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.3, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.25, ["Fly"] = 871.64, ["Ride"] = 727.13, ["Fly|Ride"] = 754.69, ["Neon"] = 2362.5, ["Neon|Fly|Ride"] = 2208.84}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Fly"] = 56.44, ["Ride"] = 78.74, ["Neon"] = 28.97, ["Neon|Ride"] = 76.99, ["Neon|Fly|Ride"] = 179.07, ["Mega"] = 156.19, ["Mega|Ride"] = 204.83, ["Mega|Fly|Ride"] = 377.22}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 52.5, ["Ride"] = 52.41, ["Neon"] = 25.1, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 203.43, ["Mega|Ride"] = 191.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 18.2, ["Fly|Ride"] = 52.5, ["Neon"] = 6.57, ["Neon|Fly"] = 41.18, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 68.97, ["Mega"] = 274.78, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.07, ["Ride"] = 68.92, ["Fly|Ride"] = 154.87, ["Neon"] = 92.47, ["Mega"] = 549.54, ["Mega|Fly|Ride"] = 740.96}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 411.65, ["Neon"] = 4.94, ["Neon|Fly"] = 68.97, ["Neon|Ride"] = 39.12, ["Neon|Fly|Ride"] = 184.23, ["Mega"] = 44.63, ["Mega|Ride"] = 117.07, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 534.19, ["Ride"] = 564.37, ["Fly|Ride"] = 698.77, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 61.66, ["Fly|Ride"] = 308.56, ["Neon"] = 4.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 80.07, ["Mega|Ride"] = 171.23, ["Mega|Fly|Ride"] = 289.43}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.18, ["Neon"] = 3.94, ["Neon|Fly"] = 137.92, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 270.66}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 25.73, ["Neon"] = 5.25, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.92, ["Mega"] = 39.1, ["Mega|Fly"] = 152.33, ["Mega|Ride"] = 80.06, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.63, ["Ride"] = 21.95, ["Neon"] = 18.55, ["Mega"] = 201.11}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 40.05, ["Fly"] = 66.94, ["Ride"] = 57.8, ["Fly|Ride"] = 293.54, ["Neon"] = 129.94, ["Neon|Ride"] = 185.26, ["Neon|Fly|Ride"] = 308.75, ["Mega"] = 631.87, ["Mega|Ride"] = 549.54, ["Mega|Fly|Ride"] = 714.19}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.42, ["Ride"] = 64.75, ["Fly|Ride"] = 137.92, ["Neon"] = 78.61, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 273.29, ["Mega"] = 464.2, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 628.78}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.01, ["Fly"] = 19.16, ["Ride"] = 15.06, ["Fly|Ride"] = 43.23, ["Neon"] = 19.69, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.81, ["Ride"] = 64.32, ["Fly|Ride"] = 123.67, ["Neon"] = 137.92, ["Neon|Ride"] = 131.25, ["Mega"] = 308.6, ["Mega|Ride"] = 715.22, ["Mega|Fly|Ride"] = 961.17}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.45, ["Fly|Ride"] = 73.07, ["Neon"] = 14.31, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 205.74, ["Mega"] = 88.36, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.67, ["Fly"] = 23.63, ["Ride"] = 23.62, ["Fly|Ride"] = 68.97, ["Neon"] = 231.14, ["Neon|Ride"] = 185.26, ["Neon|Fly|Ride"] = 197.66, ["Mega"] = 925.16, ["Mega|Ride"] = 924.59, ["Mega|Fly|Ride"] = 879.88}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 26.17, ["Fly"] = 874.13, ["Neon"] = 273.98, ["Mega|Fly|Ride"] = 961.17}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.79, ["Fly"] = 115.38, ["Ride"] = 71.3, ["Fly|Ride"] = 161.8, ["Neon"] = 262.92, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1634.2, ["Mega|Fly|Ride"] = 1505.56}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.91, ["Fly"] = 92.47, ["Ride"] = 88.41, ["Fly|Ride"] = 656.25, ["Neon"] = 129.94, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 390.03, ["Mega"] = 545.66, ["Mega|Ride"] = 1922.33, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 20.93, ["Ride"] = 56.43, ["Fly|Ride"] = 137.92, ["Neon"] = 138.94, ["Neon|Ride"] = 274.26, ["Mega"] = 411.65, ["Mega|Ride"] = 770.87, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.41, ["Fly"] = 428.27, ["Ride"] = 46.25, ["Fly|Ride"] = 68.97, ["Neon"] = 87.91, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 233.89, ["Mega"] = 464.37, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 17.07, ["Fly|Ride"] = 35, ["Neon"] = 3.94, ["Neon|Fly"] = 25.15, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 44.61, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.49, ["Fly"] = 231.14, ["Ride"] = 126.93, ["Fly|Ride"] = 262.5, ["Neon"] = 291.38, ["Neon|Ride"] = 257.75, ["Neon|Fly|Ride"] = 343.72, ["Mega"] = 789.32, ["Mega|Ride"] = 755.36, ["Mega|Fly|Ride"] = 851.07}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.59, ["Neon"] = 3.27, ["Neon|Fly"] = 96.75, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 288.16, ["Mega"] = 31.22, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 164.67}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 47.16, ["Ride"] = 64.85, ["Neon"] = 128.37, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 770.87, ["Mega|Fly|Ride"] = 832.13}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 20.82}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 39.38, ["Mega"] = 77.44, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 97.35, ["Ride"] = 137.92, ["Fly|Ride"] = 253.17, ["Neon"] = 511.88, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 686.41, ["Mega|Ride"] = 6356.49, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 92.69, ["Neon"] = 9.19, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 68.97, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 61.77, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 122.48, ["Mega"] = 40.15, ["Mega|Ride"] = 123.51, ["Mega|Fly|Ride"] = 220.23}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.34, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 48.57, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.71}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.19, ["Neon|Ride"] = 155.71, ["Mega"] = 62.79, ["Mega|Ride"] = 200.71}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 509.4, ["Neon|Fly|Ride"] = 686.41, ["Mega"] = 1234.91, ["Mega|Ride"] = 1543.63, ["Mega|Fly|Ride"] = 1370.75}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 7.24, ["Ride"] = 60.52, ["Fly|Ride"] = 131.25, ["Neon"] = 47.36, ["Neon|Ride"] = 154.88, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 398.27, ["Fly|Ride"] = 617.47, ["Neon"] = 2881.45, ["Neon|Ride"] = 2058.17, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 3869.36}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 79.94}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.82}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.71}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.85}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 115.96}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.54}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 80.07}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 43.94}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.81}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.87}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.6}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.19}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.81}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.56}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 6.35}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 522.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 787.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 14.12}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 50.03}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.48}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.66}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.13}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.74}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 14.83}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.4}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.3}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.03}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.09}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.75}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1864.7}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 45.05}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 273}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 39.29}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 210}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.33}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1372.81}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 27.2}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.8}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 20.89}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 17.84}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.23}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.54}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 28.77}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.97}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.19}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.27}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.26}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.72}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.24}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 87.84}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.06}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22015.98}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 149.42}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.3}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.4}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 75.51}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 65.63}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 46.15}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 76.99}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 37.48}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 53.81}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 411.65}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 4.87}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.46}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.58}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 89.06}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.14}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 96.77}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 9.85}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 643.19}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 10.31}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.93}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.43}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 601.05}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 49.69}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.81}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 53.52}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 196.88}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 218.18}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.75}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.91}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.08}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.67}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.2}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.44}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.56}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.65}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 188.6}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.76}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.21}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.3}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 96.59}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.16}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 4.76}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 20.79}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 77.44}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 18.38}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.15}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.03}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.68}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 14.74}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.87}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.34}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.39}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.66}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7075.09}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.45}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.16}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.84}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.85}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.02}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.32}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 110.12}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 12.5}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.42}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.68}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 99.64}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.32}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.12}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4276.53}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 242.82}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.81}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 65.63}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.11}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.41}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.37}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.35}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.14}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.04}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.99}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 12.36}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.91}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.94}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 98.44}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.11}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.65}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.53}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 23.35}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.16}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 23.55}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.11}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.38}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.94}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.68}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 5.25}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.34}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.44}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 18.23}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.16}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.76}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.42}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.19}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 4.55}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.08}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.28}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 5.25}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.3}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 315}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.37}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1218}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.34}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 220.23}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 26.25}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.38}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.47}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 54.67}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.46}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 10.5}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.01}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.59}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 9.19}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 51.1}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 65.61}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.38}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.82}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.09}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 129.29}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.78}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.1}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 135.96}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.17}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 225.75}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.61}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 72.94}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 7.66}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 156.08}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.68}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 26.17}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 56.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.67}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.18}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.34}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 31.4}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.19}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.65}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 9.08}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 39.37}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.7}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 50.3}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 21}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 36.65}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.29}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.8}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.05}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 375.27}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.39}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 44.26}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.11}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.77}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 259.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.51}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.73}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 59.07}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 131.24}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 58.79}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 98.44}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.29}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2161.08}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
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