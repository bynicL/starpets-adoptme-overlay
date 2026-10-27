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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 813.75, ["Ride"] = 916.13, ["Fly|Ride"] = 1140.06, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 607.62, ["Ride"] = 510.2, ["Fly|Ride"] = 549.95, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2883.59, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 9567.67}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5250, ["Ride"] = 4593.75, ["Fly|Ride"] = 4959.82, ["Neon|Fly|Ride"] = 17749.48, ["Mega|Fly|Ride"] = 68648.34}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.5, ["Ride"] = 179.19, ["Fly|Ride"] = 409.89, ["Neon"] = 772.12, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1233.78, ["Mega"] = 4119.41, ["Mega|Fly|Ride"] = 3434.12}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 823.9, ["Ride"] = 616.88, ["Fly|Ride"] = 612.94, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.96, ["Ride"] = 27.68, ["Fly|Ride"] = 152.43, ["Neon"] = 56.44, ["Neon|Fly"] = 274.98, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 288.33, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 575.63}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 2.1, ["Fly"] = 20.61, ["Ride"] = 27.71, ["Fly|Ride"] = 60.74, ["Neon"] = 29.79, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 46.06, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 150.05, ["Mega|Fly"] = 223.13, ["Mega|Ride"] = 194.61, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 105, ["Ride"] = 147.72, ["Fly|Ride"] = 233.8, ["Neon"] = 514.94, ["Neon|Ride"] = 616.9, ["Neon|Fly|Ride"] = 679.71, ["Mega|Ride"] = 2609.32, ["Mega|Fly|Ride"] = 2663.9}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.6, ["Fly"] = 138.02, ["Ride"] = 53.5, ["Fly|Ride"] = 106.32, ["Neon"] = 252, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 2100, ["Mega|Ride"] = 1388.82, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.27, ["Fly"] = 55.56, ["Ride"] = 36.15, ["Fly|Ride"] = 59.47, ["Neon"] = 1968.75, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1337.62, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 51.19, ["Fly"] = 206.07, ["Ride"] = 97.25, ["Fly|Ride"] = 169.47, ["Neon"] = 411.96, ["Neon|Fly"] = 409.89, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 277.82, ["Mega|Fly|Ride"] = 1544.6}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66.78}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 399, ["Ride"] = 340.56, ["Fly|Ride"] = 359.49, ["Neon"] = 1420.38, ["Neon|Ride"] = 1389.05, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4839.7}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.37, ["Fly"] = 170.23, ["Ride"] = 136.11, ["Fly|Ride"] = 179.22, ["Neon|Fly"] = 671.41, ["Neon|Fly|Ride"] = 549.95, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 131.23, ["Neon"] = 20.61, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 189, ["Mega"] = 124.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 383.09}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 205.3, ["Ride"] = 157.39, ["Fly|Ride"] = 219.54, ["Neon|Ride"] = 714.73, ["Neon|Fly|Ride"] = 686.93, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.82, ["Fly"] = 22.51, ["Ride"] = 17.07, ["Fly|Ride"] = 40.6, ["Neon"] = 25.93, ["Neon|Ride"] = 67.98, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 96.95, ["Fly"] = 144.38, ["Ride"] = 131.25, ["Fly|Ride"] = 238.17, ["Neon"] = 393.75, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 373.86, ["Neon|Fly|Ride"] = 430.49, ["Mega"] = 1510.8, ["Mega|Ride"] = 1330.3, ["Mega|Fly|Ride"] = 1163.26}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.15}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 154.5, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1373.84, ["Mega|Fly|Ride"] = 1840.12}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18, ["Fly"] = 31.27, ["Ride"] = 28.88, ["Fly|Ride"] = 110.2, ["Neon"] = 224.48, ["Neon|Ride"] = 193.64, ["Neon|Fly|Ride"] = 271.89, ["Mega|Ride"] = 579.74, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.93, ["Fly"] = 123.87, ["Ride"] = 55.55, ["Fly|Ride"] = 110.44, ["Neon"] = 243.78, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1620.54, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 56.44, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 192.47, ["Neon|Fly"] = 384.34, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 370.76, ["Mega"] = 1161.68, ["Mega|Ride"] = 1231.56, ["Mega|Fly|Ride"] = 1249.92}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.38, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 344, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 291.71, ["Mega"] = 821.73, ["Mega|Ride"] = 2057.4, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.92, ["Fly"] = 115.78, ["Ride"] = 62.77, ["Fly|Ride"] = 123.6, ["Neon"] = 227.61, ["Neon|Fly"] = 550.98, ["Neon|Ride"] = 181.92, ["Neon|Fly|Ride"] = 309.07, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 894.38}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.03, ["Fly"] = 34.74, ["Ride"] = 17.37, ["Fly|Ride"] = 52.42, ["Neon"] = 31.94, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 95.96, ["Mega"] = 139.76, ["Mega|Fly"] = 26157.81, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 255.93}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 339.9, ["Ride"] = 411.96, ["Fly|Ride"] = 480.11, ["Neon"] = 1853.74, ["Neon|Ride"] = 1956.73, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7253.01}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.21, ["Ride"] = 32.45, ["Neon"] = 219.18, ["Mega"] = 513.85, ["Mega|Ride"] = 782.6, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.25, ["Fly"] = 31.17, ["Ride"] = 23, ["Fly|Ride"] = 48.54, ["Neon"] = 66.38, ["Neon|Ride"] = 63.26, ["Neon|Fly|Ride"] = 119.43, ["Mega|Ride"] = 306.87, ["Mega|Fly|Ride"] = 439.52}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 91.88, ["Ride"] = 100.55, ["Fly|Ride"] = 131.22, ["Neon"] = 363.93, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.24, ["Mega"] = 3021.21, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1559.01}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.64, ["Ride"] = 23.16, ["Fly|Ride"] = 75.22, ["Neon"] = 155.14, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 162.42, ["Mega"] = 479.16, ["Mega|Ride"] = 785.7}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 193.26, ["Fly"] = 348.11, ["Ride"] = 250.94, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 825.57, ["Neon|Fly|Ride"] = 840, ["Mega"] = 6179.1, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2932.65}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.88}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.1, ["Fly"] = 26.91, ["Ride"] = 20.85, ["Fly|Ride"] = 51.42, ["Neon"] = 24.93, ["Neon|Fly"] = 131.98, ["Neon|Ride"] = 53.26, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 159.72, ["Mega|Fly"] = 501.48, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 308.94}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 930.99, ["Fly"] = 2625, ["Ride"] = 850.04, ["Fly|Ride"] = 1128.51, ["Neon"] = 4200, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52079.9, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.07, ["Fly"] = 69.02, ["Ride"] = 26.25, ["Fly|Ride"] = 96.83, ["Neon"] = 92.63, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 225.54, ["Mega"] = 543.72, ["Mega|Ride"] = 698.16, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 131.25, ["Ride"] = 217.24, ["Fly|Ride"] = 210, ["Neon"] = 872.29, ["Neon|Ride"] = 878.95, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 2469.76, ["Mega|Fly|Ride"] = 3021.21}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 33.59}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.85, ["Fly"] = 68.85, ["Ride"] = 52.29, ["Fly|Ride"] = 138.02, ["Neon"] = 82.41, ["Neon|Ride"] = 201.42, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 677.69, ["Mega|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 725.66}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 116.82, ["Ride"] = 127.32, ["Fly|Ride"] = 233.71, ["Neon"] = 588.08, ["Neon|Ride"] = 290.07, ["Neon|Fly|Ride"] = 822.86, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 111.57, ["Ride"] = 204.02, ["Fly|Ride"] = 272.85, ["Neon"] = 389.44, ["Neon|Fly"] = 583.43, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 590.62, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 2059.45}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.45}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 45.93, ["Fly"] = 61.35, ["Ride"] = 55.35, ["Fly|Ride"] = 85.68, ["Neon|Ride"] = 370.42, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 4118.89, ["Mega|Fly|Ride"] = 1518.57}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.03, ["Fly"] = 55.62, ["Ride"] = 41.21, ["Fly|Ride"] = 131.25, ["Neon"] = 47.39, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231.73, ["Mega"] = 167.88, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 321.29, ["Mega|Fly|Ride"] = 409.71}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 473.82, ["Fly"] = 590.63, ["Ride"] = 465.52, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1738.4, ["Neon|Fly|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 6470.63}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 85.31, ["Fly"] = 162.08, ["Ride"] = 122.06, ["Fly|Ride"] = 197.97, ["Neon"] = 446.25, ["Neon|Fly"] = 823.9, ["Neon|Ride"] = 574.16, ["Neon|Fly|Ride"] = 480.96, ["Mega|Ride"] = 2470.31, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3515.91, ["Ride"] = 3707.47, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14416.86}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.36, ["Fly"] = 110.2, ["Ride"] = 59.72, ["Fly|Ride"] = 128.41, ["Neon"] = 393.75, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 344, ["Mega|Ride"] = 1182.13, ["Mega|Fly|Ride"] = 1222.29}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 69.02, ["Fly|Ride"] = 173.64, ["Neon"] = 410.42, ["Neon|Ride"] = 618.15, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2746.28, ["Mega|Ride"] = 2609.32, ["Mega|Fly|Ride"] = 2777.61}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 37.54, ["Fly"] = 61.83, ["Ride"] = 45.94, ["Fly|Ride"] = 111.57, ["Neon"] = 130.29, ["Neon|Fly"] = 195.68, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 961.77, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 654.84}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.23}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.32, ["Fly"] = 41.21, ["Ride"] = 59.06, ["Fly|Ride"] = 64.29, ["Neon"] = 262.5, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.98}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 138.02, ["Ride"] = 221.82, ["Fly|Ride"] = 261.56, ["Neon|Ride"] = 1373.84, ["Neon|Fly|Ride"] = 1373.84, ["Mega|Fly|Ride"] = 4938.34}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1089.6, ["Ride"] = 1034.25, ["Fly|Ride"] = 1056.57, ["Neon"] = 2887.5, ["Neon|Ride"] = 3860.51, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13386.37}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 4.87}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 24.94, ["Fly"] = 68.99, ["Ride"] = 43.22, ["Fly|Ride"] = 62.15, ["Neon"] = 160.78, ["Neon|Ride"] = 148.45, ["Neon|Fly|Ride"] = 196.92, ["Mega|Ride"] = 787.08, ["Mega|Fly|Ride"] = 980.31}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5849.55, ["Ride"] = 5973.14, ["Fly|Ride"] = 4610.82, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40121.2}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.4, ["Fly"] = 74.72, ["Ride"] = 23.79, ["Fly|Ride"] = 54.57, ["Neon"] = 132.57, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 787.5, ["Mega|Ride"] = 586.79, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.13, ["Fly"] = 41.21, ["Ride"] = 39.38, ["Fly|Ride"] = 114.61, ["Neon"] = 65.63, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 247.19, ["Mega"] = 1030.21, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 1026.65}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.64, ["Fly"] = 273.81, ["Ride"] = 91.85, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 382.09, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4119.41}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.21, ["Fly"] = 150.93, ["Ride"] = 39.15, ["Fly|Ride"] = 139.02, ["Neon"] = 74.87, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.75, ["Fly"] = 2212.12, ["Ride"] = 1968.75, ["Fly|Ride"] = 1788.87, ["Neon|Fly|Ride"] = 3430.35, ["Mega|Fly|Ride"] = 13124.9}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 52500, ["Fly|Ride"] = 25856.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68656.88, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.85, ["Fly"] = 393.74, ["Ride"] = 52.54, ["Fly|Ride"] = 124.69, ["Neon"] = 205.98, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 961.77, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 819.68}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.46, ["Fly"] = 82.41, ["Ride"] = 41.21, ["Fly|Ride"] = 136.5, ["Neon"] = 20.31, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 66.43, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 125.68, ["Mega|Fly"] = 184.33, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.72}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.97, ["Ride"] = 44.3, ["Fly|Ride"] = 125.24, ["Neon"] = 62.52, ["Neon|Ride"] = 129.88, ["Neon|Fly|Ride"] = 152.43, ["Mega"] = 261.06, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 768.51, ["Ride"] = 719.25, ["Fly|Ride"] = 772.12, ["Neon|Fly|Ride"] = 2815.12, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 954.69, ["Fly"] = 1076.25, ["Ride"] = 971.25, ["Fly|Ride"] = 935.55, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10956.47}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.65, ["Fly"] = 115.78, ["Ride"] = 36.75, ["Fly|Ride"] = 86.63, ["Neon"] = 140.44, ["Neon|Ride"] = 119.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 652.85}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.18}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.79, ["Fly"] = 92.63, ["Ride"] = 72.68, ["Fly|Ride"] = 118.43, ["Neon"] = 411.96, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 440.79, ["Mega|Ride"] = 2016.2, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 61.17, ["Ride"] = 65.63, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2075.38, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 44.63, ["Ride"] = 20.01, ["Fly|Ride"] = 54.39, ["Neon"] = 55.77, ["Neon|Fly"] = 525, ["Neon|Ride"] = 68.32, ["Neon|Fly|Ride"] = 132.55, ["Mega"] = 288.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 110.25, ["Fly"] = 143.07, ["Ride"] = 118.12, ["Fly|Ride"] = 173.92, ["Neon|Ride"] = 450.22, ["Neon|Fly|Ride"] = 393.65, ["Mega|Fly|Ride"] = 1414.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.45, ["Ride"] = 47.39, ["Fly|Ride"] = 110.2, ["Neon"] = 51.1, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 479.93, ["Mega"] = 236.25, ["Mega|Ride"] = 396.98, ["Mega|Fly|Ride"] = 547.83}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.65, ["Fly"] = 41.22, ["Ride"] = 28.38, ["Fly|Ride"] = 87.98, ["Neon"] = 84, ["Neon|Ride"] = 110.31, ["Neon|Fly|Ride"] = 138.02, ["Mega|Fly|Ride"] = 755.84}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.25, ["Ride"] = 55.62, ["Fly|Ride"] = 156.19, ["Neon"] = 262.63, ["Neon|Ride"] = 329.57, ["Neon|Fly|Ride"] = 344, ["Mega"] = 694.53, ["Mega|Ride"] = 771.95, ["Mega|Fly|Ride"] = 892.79}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.94, ["Fly"] = 145.58, ["Ride"] = 28.88, ["Fly|Ride"] = 69.56, ["Neon"] = 71.07, ["Neon|Ride"] = 108.82, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 823.9, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7177.12, ["Ride"] = 7141.32, ["Fly|Ride"] = 6956.25, ["Neon"] = 30895.45, ["Neon|Fly|Ride"] = 27311.59}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.25, ["Fly"] = 303.81, ["Ride"] = 261.07, ["Fly|Ride"] = 272.36, ["Neon|Ride"] = 686.93, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 37.95, ["Fly"] = 150.94, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 90.55, ["Neon|Fly"] = 205.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 393.65, ["Mega|Ride"] = 411.46, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.62, ["Fly"] = 85.68, ["Ride"] = 23.7, ["Fly|Ride"] = 105.35, ["Neon"] = 31.5, ["Neon|Fly"] = 49.45, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.45, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 45.94, ["Fly"] = 5247.36, ["Ride"] = 94.5, ["Fly|Ride"] = 192.45, ["Neon"] = 199.11, ["Neon|Fly"] = 251.3, ["Neon|Ride"] = 229.21, ["Neon|Fly|Ride"] = 329.15, ["Mega"] = 445.76, ["Mega|Ride"] = 533.57, ["Mega|Fly|Ride"] = 583.87}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14385, ["Ride"] = 13387.5, ["Fly|Ride"] = 12600, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 170.52, ["Ride"] = 262.5, ["Fly|Ride"] = 371.44, ["Neon"] = 1497.42, ["Neon|Ride"] = 1510.8, ["Neon|Fly|Ride"] = 1502.57, ["Mega|Fly|Ride"] = 5148.61}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 56.85, ["Fly"] = 118.83, ["Ride"] = 74.73, ["Fly|Ride"] = 90.02, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 411.96, ["Mega|Fly|Ride"] = 2572.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.96, ["Fly"] = 44, ["Ride"] = 23.63, ["Fly|Ride"] = 55.55, ["Neon"] = 86.52, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 229.69, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Ride"] = 393.75, ["Fly|Ride"] = 566.44, ["Neon"] = 1647.78, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1647.78, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.94, ["Fly"] = 101.53, ["Ride"] = 34.43, ["Fly|Ride"] = 84.96, ["Neon"] = 26.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 129.93, ["Mega|Ride"] = 208.45, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 133.88, ["Fly"] = 205.98, ["Ride"] = 179.22, ["Fly|Ride"] = 232.76, ["Neon"] = 543.77, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2496.82}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.11, ["Fly"] = 21, ["Ride"] = 18.05, ["Fly|Ride"] = 41.52, ["Neon|Ride"] = 96.8, ["Neon|Fly|Ride"] = 105, ["Mega"] = 874.13}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 53.82, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 549.95, ["Neon|Ride"] = 411.96, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1543.89}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.9, ["Fly"] = 101.97, ["Ride"] = 36.75, ["Fly|Ride"] = 92.63, ["Neon"] = 164.8, ["Neon|Ride"] = 87.28, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 1027.68, ["Mega|Ride"] = 616.82, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.37}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 39.37, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 249.38, ["Neon"] = 208.69, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1098.72, ["Mega|Ride"] = 959.72, ["Mega|Fly|Ride"] = 1153.3}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 131.98, ["Neon"] = 23.61, ["Neon|Ride"] = 104.2, ["Neon|Fly|Ride"] = 269.83, ["Mega"] = 123.24, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.22, ["Fly"] = 47.25, ["Ride"] = 36.06, ["Fly|Ride"] = 92.19, ["Neon"] = 119.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 171.86, ["Mega|Ride"] = 589.01, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 549.95, ["Ride"] = 452.61, ["Fly|Ride"] = 539.44, ["Neon|Fly|Ride"] = 2739.41, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.25, ["Fly"] = 103, ["Ride"] = 54.96, ["Fly|Ride"] = 103.69, ["Neon"] = 233.8, ["Neon|Ride"] = 186.5, ["Neon|Fly|Ride"] = 220.4, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 947.36}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 52.01, ["Fly"] = 117.49, ["Ride"] = 83.26, ["Fly|Ride"] = 131.25, ["Neon"] = 411.96, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 720.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 27.2, ["Fly"] = 76.33, ["Ride"] = 71.77, ["Fly|Ride"] = 131.25, ["Neon"] = 170.63, ["Neon|Ride"] = 231.52, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 414.74, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 611.68}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13274, ["Fly|Ride"] = 8006.24, ["Neon|Fly|Ride"] = 14173.69, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.27, ["Fly"] = 1852.16, ["Ride"] = 1561.25, ["Fly|Ride"] = 1442.44, ["Neon"] = 5324.83, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 535.5, ["Ride"] = 525, ["Fly|Ride"] = 525, ["Neon"] = 4323.61, ["Mega|Fly|Ride"] = 6728.19}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.8, ["Fly"] = 23.63, ["Ride"] = 20.35, ["Fly|Ride"] = 44.63, ["Neon"] = 110.2, ["Neon|Ride"] = 101.97, ["Neon|Fly|Ride"] = 124.55, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.76, ["Fly"] = 78.74, ["Ride"] = 32.18, ["Fly|Ride"] = 77.25, ["Neon"] = 23.86, ["Neon|Ride"] = 76.11, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 143.07, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 60.76, ["Ride"] = 47.16, ["Fly|Ride"] = 91.68, ["Neon"] = 520.92, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 166.18, ["Mega|Fly|Ride"] = 524.69}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 26.79, ["Ride"] = 17.14, ["Fly|Ride"] = 43.34, ["Neon"] = 27.81, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.69, ["Fly"] = 320.25, ["Ride"] = 262.5, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1346.02, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.37, ["Fly"] = 82.41, ["Ride"] = 31.49, ["Fly|Ride"] = 76.48, ["Neon"] = 188.48, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 142.13, ["Mega"] = 480.89, ["Mega|Ride"] = 524.9, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.43, ["Fly"] = 18.38, ["Ride"] = 20.31, ["Fly|Ride"] = 44.3, ["Neon"] = 81.04, ["Neon|Fly"] = 131.98, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 106.6, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 196.88, ["Fly"] = 787.5, ["Ride"] = 435.75, ["Fly|Ride"] = 686.93, ["Neon|Ride"] = 2883.59, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1299.38, ["Fly"] = 1389.13, ["Ride"] = 1155, ["Fly|Ride"] = 1302, ["Neon"] = 4806.32, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 96.83, ["Fly"] = 129.78, ["Ride"] = 101.73, ["Fly|Ride"] = 128.85, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 173.16, ["Fly"] = 163.72, ["Ride"] = 169.32, ["Fly|Ride"] = 261.32, ["Neon"] = 577.5, ["Neon|Fly"] = 686.93, ["Neon|Ride"] = 694.55, ["Neon|Fly|Ride"] = 700.11, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2469.76}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.2, ["Ride"] = 72.11, ["Fly|Ride"] = 118.58, ["Neon"] = 244.76, ["Neon|Ride"] = 205.98, ["Neon|Fly|Ride"] = 385.12, ["Mega|Ride"] = 2059.45, ["Mega|Fly|Ride"] = 851.6}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 124.69, ["Ride"] = 273, ["Fly|Ride"] = 137.82, ["Neon|Fly|Ride"] = 1296.44, ["Mega|Fly|Ride"] = 3295.13}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Ride"] = 2483.25, ["Fly|Ride"] = 2470.31, ["Mega|Fly|Ride"] = 24690.51}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 70.18, ["Ride"] = 82.41, ["Fly|Ride"] = 196.88, ["Neon"] = 350.16, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2265.4, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 623.7, ["Fly"] = 616.88, ["Ride"] = 630, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1517.53, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3267.73}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.28, ["Fly"] = 64.21, ["Ride"] = 57.65, ["Fly|Ride"] = 101.72, ["Neon|Ride"] = 358.84, ["Neon|Fly|Ride"] = 295.32, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.48, ["Fly|Ride"] = 47.46, ["Neon"] = 24.93, ["Neon|Fly"] = 155.12, ["Neon|Ride"] = 44.4, ["Neon|Fly|Ride"] = 92.61, ["Mega"] = 150.84, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.74, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 262.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 686.93, ["Mega"] = 1504.54, ["Mega|Ride"] = 1373.66, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 833.44, ["Fly"] = 1012.91, ["Ride"] = 824.25, ["Fly|Ride"] = 871.45, ["Neon|Ride"] = 2471.65, ["Neon|Fly|Ride"] = 2310, ["Mega|Fly|Ride"] = 9199.53}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 630, ["Ride"] = 645.74, ["Fly|Ride"] = 769.31, ["Neon|Fly|Ride"] = 4110.14}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11, ["Fly"] = 26.25, ["Ride"] = 25.93, ["Fly|Ride"] = 42.71, ["Neon"] = 185.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 138.03, ["Mega"] = 786.19, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.9, ["Ride"] = 21.32, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Ride"] = 108.83, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 506.7, ["Mega|Ride"] = 506.64, ["Mega|Fly|Ride"] = 453.09}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.04, ["Ride"] = 24.93, ["Fly|Ride"] = 111.56, ["Neon"] = 22.08, ["Neon|Fly"] = 309, ["Neon|Ride"] = 53.91, ["Neon|Fly|Ride"] = 155.12, ["Mega"] = 152.43, ["Mega|Fly"] = 525.45, ["Mega|Ride"] = 241.19, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 47.02, ["Fly"] = 62.52, ["Ride"] = 52.41, ["Fly|Ride"] = 104.49, ["Neon"] = 147.04, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 246.75, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 63.95, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 361.49, ["Neon|Ride"] = 509.79, ["Neon|Fly|Ride"] = 686.93, ["Mega"] = 1235.83, ["Mega|Ride"] = 1544.6, ["Mega|Fly|Ride"] = 1371.6}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.02, ["Fly"] = 56.04, ["Ride"] = 34.13, ["Fly|Ride"] = 78.75, ["Neon"] = 78.75, ["Neon|Fly"] = 155.12, ["Neon|Ride"] = 102.8, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 343.94, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.45, ["Fly"] = 56.01, ["Ride"] = 47.29, ["Fly|Ride"] = 85.32, ["Neon"] = 548.5, ["Neon|Ride"] = 198.19, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.33, ["Fly"] = 27.82, ["Ride"] = 18.25, ["Fly|Ride"] = 41.36, ["Neon"] = 26.99, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 316.15}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.46, ["Fly"] = 65.63, ["Ride"] = 23.63, ["Fly|Ride"] = 85.14, ["Neon"] = 25.97, ["Neon|Fly"] = 139.05, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 164.8, ["Mega"] = 309.07, ["Mega|Ride"] = 305.36, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 59.07, ["Fly"] = 65.62, ["Ride"] = 48.57, ["Fly|Ride"] = 97.47, ["Neon"] = 401.69, ["Neon|Ride"] = 158.62, ["Neon|Fly|Ride"] = 207.21, ["Mega|Fly|Ride"] = 1019.4}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1678.76, ["Fly"] = 1575, ["Ride"] = 1593.42, ["Fly|Ride"] = 1443.74, ["Neon|Fly"] = 4688.16, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 13117.2}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 598.05, ["Neon|Ride"] = 3021.59, ["Neon|Fly|Ride"] = 3005.12, ["Mega|Fly|Ride"] = 9609.35}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 259.77, ["Ride"] = 312.43, ["Fly|Ride"] = 341.25, ["Neon"] = 1538.6, ["Neon|Ride"] = 1318.23, ["Neon|Fly|Ride"] = 1503.58, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 35.21}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.84, ["Ride"] = 43.1, ["Fly|Ride"] = 96.83, ["Neon"] = 328.78, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 352.23, ["Neon|Fly|Ride"] = 344, ["Mega"] = 1234.89, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41193.92, ["Fly"] = 65625, ["Ride"] = 34727.65, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 328.13, ["Fly"] = 360.94, ["Ride"] = 368.82, ["Fly|Ride"] = 376.69, ["Neon"] = 1371.78, ["Neon|Ride"] = 1147.13, ["Neon|Fly|Ride"] = 1373.84, ["Mega"] = 6179.1, ["Mega|Fly|Ride"] = 3858.75}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 143.93, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4118.89}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.69, ["Fly"] = 262.49, ["Ride"] = 122.8, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 488.17, ["Mega"] = 7551.98, ["Mega|Fly|Ride"] = 1661.99}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.33, ["Fly"] = 94.5, ["Ride"] = 39.38, ["Fly|Ride"] = 107.85, ["Neon"] = 392.44, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 686.83, ["Mega|Ride"] = 601.82, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4943.29, ["Ride"] = 4806.32, ["Fly|Ride"] = 4198.69, ["Neon"] = 20460, ["Neon|Fly|Ride"] = 27462.96, ["Mega|Fly|Ride"] = 61725.09}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 25.65, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 55.12, ["Neon"] = 228.64, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1373.66, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.21, ["Fly"] = 138.02, ["Ride"] = 45.93, ["Fly|Ride"] = 101.07, ["Neon"] = 344, ["Neon|Ride"] = 267.78, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 766.5, ["Fly"] = 918.75, ["Ride"] = 853.13, ["Fly|Ride"] = 944.35, ["Neon"] = 2362.5, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2315.07, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.03, ["Fly"] = 25.94, ["Ride"] = 26.31, ["Fly|Ride"] = 44.43, ["Neon"] = 85.32, ["Neon|Fly"] = 155.12, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 154.44, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.57, ["Fly"] = 96.83, ["Ride"] = 30.9, ["Fly|Ride"] = 463.05, ["Neon"] = 80.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 522.09}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 87.83, ["Ride"] = 128.62, ["Fly|Ride"] = 208.38, ["Neon"] = 472.5, ["Neon|Ride"] = 530.66, ["Neon|Fly|Ride"] = 604.53, ["Mega|Fly|Ride"] = 2334.39}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.9, ["Fly"] = 85.32, ["Ride"] = 61.8, ["Fly|Ride"] = 163.08, ["Neon"] = 81.37, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 271.89, ["Mega"] = 269.83, ["Mega|Fly"] = 734.92, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4003.13, ["Ride"] = 4302.47, ["Fly|Ride"] = 3681.57, ["Neon|Ride"] = 13890.83, ["Neon|Fly|Ride"] = 9581.25, ["Mega"] = 61788.82, ["Mega|Fly|Ride"] = 32678.17}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 41.98, ["Ride"] = 65.33, ["Fly|Ride"] = 135.95, ["Neon"] = 220.43, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 398.57, ["Mega|Ride"] = 1028.7, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 6561.19, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 69439.85}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.52, ["Fly"] = 20.9, ["Ride"] = 17.37, ["Fly|Ride"] = 41.21, ["Neon"] = 19.69, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 76.11, ["Mega"] = 447.98, ["Mega|Fly|Ride"] = 363.42}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 21.79, ["Fly"] = 26.15, ["Ride"] = 24.94, ["Fly|Ride"] = 55.62, ["Neon"] = 138.02, ["Neon|Ride"] = 191.57, ["Neon|Fly|Ride"] = 138.02, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.63}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.92, ["Fly"] = 39.38, ["Ride"] = 35.42, ["Fly|Ride"] = 115.5, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 172.01, ["Mega"] = 772.01, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 748.89}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 31.06, ["Fly"] = 190.37, ["Ride"] = 39.38, ["Fly|Ride"] = 150.36, ["Neon"] = 195.68, ["Neon|Ride"] = 124.53, ["Neon|Fly|Ride"] = 294.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.25, ["Fly"] = 23.55, ["Ride"] = 20.61, ["Fly|Ride"] = 39.38, ["Neon|Ride"] = 114.33, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 728.44, ["Mega|Ride"] = 577.53, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8341.78}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 131.25, ["Ride"] = 196.87, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1029.87}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.69, ["Fly"] = 123.6, ["Ride"] = 43.82, ["Fly|Ride"] = 96.83, ["Neon"] = 82.41, ["Neon|Ride"] = 109.94, ["Neon|Fly|Ride"] = 204.95, ["Mega"] = 406.81, ["Mega|Ride"] = 925.88, ["Mega|Fly|Ride"] = 954.56}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.45}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 62.52, ["Neon"] = 59.07, ["Neon|Ride"] = 94.77, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.57}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 157.5, ["Fly"] = 411.96, ["Ride"] = 205.44, ["Fly|Ride"] = 183.75, ["Neon"] = 701.37, ["Neon|Ride"] = 856.58, ["Neon|Fly|Ride"] = 947.47, ["Mega|Ride"] = 3158.16, ["Mega|Fly|Ride"] = 3021.21}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 104.21, ["Ride"] = 129.94, ["Fly|Ride"] = 211.32, ["Neon"] = 613.49, ["Neon|Ride"] = 684.87, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 3295.13, ["Mega|Fly|Ride"] = 3086.62}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 154.88, ["Fly"] = 186.62, ["Ride"] = 189, ["Fly|Ride"] = 246.75, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 989.14, ["Mega|Fly|Ride"] = 3982.13}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1923.77, ["Fly"] = 2471.65, ["Ride"] = 1443.75, ["Fly|Ride"] = 1443.75, ["Neon"] = 6615.52, ["Neon|Ride"] = 6588.99, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 33950.31}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.54, ["Fly"] = 96.83, ["Ride"] = 39.37, ["Fly|Ride"] = 93.74, ["Neon"] = 156.55, ["Neon|Fly"] = 115.78, ["Neon|Ride"] = 203.93, ["Neon|Fly|Ride"] = 220.4, ["Mega"] = 925.74, ["Mega|Ride"] = 895.86, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 804.79, ["Fly"] = 2100, ["Ride"] = 720.91, ["Fly|Ride"] = 885.69, ["Neon|Ride"] = 2624.12, ["Neon|Fly|Ride"] = 4013.15}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 38.66}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.4, ["Ride"] = 48.47, ["Fly|Ride"] = 138.02, ["Neon"] = 99.75, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 273.96, ["Mega"] = 464.63, ["Mega|Ride"] = 462.58, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.18, ["Fly"] = 48.42, ["Ride"] = 26.46, ["Fly|Ride"] = 70.16, ["Neon"] = 52.54, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 918.75, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 355.31}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.36}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.71, ["Fly"] = 108.92, ["Ride"] = 34.74, ["Fly|Ride"] = 61.81, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 1388.82}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 30.45, ["Fly"] = 51.51, ["Ride"] = 32.82, ["Fly|Ride"] = 54.71, ["Neon|Ride"] = 411.96, ["Neon|Fly|Ride"] = 411.96, ["Mega"] = 823.79, ["Mega|Ride"] = 1736.01, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10985.4, ["Ride"] = 4987.5, ["Fly|Ride"] = 5049.19, ["Neon|Fly|Ride"] = 10714.12, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.65, ["Fly"] = 55.01, ["Ride"] = 35.35, ["Fly|Ride"] = 105, ["Neon"] = 77.58, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 162.73, ["Mega"] = 518.58, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.76}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 131.25, ["Fly"] = 364.58, ["Ride"] = 134.89, ["Fly|Ride"] = 173.64, ["Neon"] = 485.63, ["Neon|Ride"] = 510.82, ["Neon|Fly|Ride"] = 473.74, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1851.74}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 49.87, ["Fly"] = 108.83, ["Ride"] = 93.47, ["Fly|Ride"] = 203.93, ["Neon"] = 259.88, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 2315.07, ["Mega|Ride"] = 2780.26, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.5, ["Fly"] = 70.46, ["Ride"] = 29.47, ["Fly|Ride"] = 70.35, ["Neon"] = 172.01, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 192.56, ["Mega"] = 1016.21, ["Mega|Ride"] = 818.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.81, ["Fly"] = 69.02, ["Ride"] = 27.56, ["Fly|Ride"] = 59.07, ["Neon"] = 36.27, ["Neon|Ride"] = 58.13, ["Neon|Fly|Ride"] = 179.22, ["Mega"] = 157.5, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 223.21, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.4, ["Fly"] = 138.02, ["Ride"] = 31.23, ["Fly|Ride"] = 64.97, ["Neon"] = 103, ["Neon|Ride"] = 123.87, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 717.56, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.38, ["Fly"] = 26.17, ["Ride"] = 21, ["Fly|Ride"] = 50.74, ["Neon"] = 203.93, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 35.02, ["Ride"] = 175.06, ["Neon"] = 147.04, ["Neon|Ride"] = 823.9, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 823.9, ["Mega|Fly|Ride"] = 783.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 220.92, ["Fly"] = 463.05, ["Ride"] = 443.63, ["Fly|Ride"] = 1544.23, ["Neon"] = 1235.83}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.97, ["Fly"] = 212.02, ["Ride"] = 91.88, ["Fly|Ride"] = 200.84, ["Neon"] = 220.4, ["Neon|Ride"] = 344, ["Neon|Fly|Ride"] = 480.88, ["Mega"] = 905.63, ["Mega|Ride"] = 2145.71, ["Mega|Fly|Ride"] = 1175.05}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1097.83, ["Ride"] = 917.44, ["Fly|Ride"] = 1018.5, ["Neon|Fly"] = 4005.2, ["Neon|Ride"] = 3130.76, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 344, ["Fly"] = 463.05, ["Ride"] = 378, ["Fly|Ride"] = 393.75, ["Neon"] = 2862.9, ["Neon|Ride"] = 1235.83, ["Neon|Fly|Ride"] = 1923.77, ["Mega"] = 8134.81, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 62.36}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.96, ["Fly"] = 55.38, ["Ride"] = 24.64, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 115.78, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 549.95, ["Mega|Ride"] = 685.81, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.4, ["Fly"] = 411.96, ["Ride"] = 341.16, ["Fly|Ride"] = 428.73, ["Neon"] = 1053.55, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1077.23, ["Mega|Ride"] = 3295.13, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 160.13, ["Ride"] = 209.58, ["Fly|Ride"] = 341.25, ["Neon"] = 892.89, ["Neon|Fly"] = 1717.79, ["Neon|Ride"] = 921.73, ["Neon|Fly|Ride"] = 981.75, ["Mega"] = 9886.55, ["Mega|Ride"] = 2787.46, ["Mega|Fly|Ride"] = 2932.69}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Ride"] = 128.63, ["Fly|Ride"] = 199.8, ["Neon"] = 673.54, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2417.8}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.03, ["Ride"] = 29.3, ["Fly|Ride"] = 167.88, ["Neon"] = 39.41, ["Neon|Ride"] = 62.52, ["Neon|Fly|Ride"] = 191.62, ["Mega"] = 264.75, ["Mega|Ride"] = 494.27, ["Mega|Fly|Ride"] = 813.49}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.13, ["Fly"] = 63, ["Ride"] = 26.25, ["Fly|Ride"] = 69.63, ["Neon"] = 177.19, ["Neon|Ride"] = 110.2, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 801.13, ["Mega|Fly|Ride"] = 583.87}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.25, ["Fly"] = 102.31, ["Ride"] = 44.61, ["Fly|Ride"] = 110.2, ["Neon"] = 105, ["Neon|Ride"] = 130.8, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 467.4, ["Mega|Ride"] = 498.96, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 94.5, ["Ride"] = 70.87, ["Fly|Ride"] = 170.6, ["Neon"] = 29.53, ["Neon|Fly"] = 231.52, ["Neon|Ride"] = 64.79, ["Neon|Fly|Ride"] = 155.3, ["Mega"] = 155.61, ["Mega|Fly"] = 308.94, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 282.65}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.95, ["Ride"] = 316.23, ["Fly|Ride"] = 367.5, ["Neon"] = 1616.88, ["Neon|Ride"] = 1373.84, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5217.6}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 134.92, ["Fly"] = 549.95, ["Ride"] = 196.88, ["Fly|Ride"] = 344.98, ["Neon"] = 656.25, ["Neon|Ride"] = 823.9, ["Neon|Fly|Ride"] = 1373.84, ["Mega"] = 9886.55, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 4105.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.1, ["Fly"] = 167.45, ["Ride"] = 93.74, ["Fly|Ride"] = 185.22, ["Neon|Ride"] = 471.15, ["Neon|Fly|Ride"] = 494.34, ["Mega|Fly|Ride"] = 1559.01}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.81, ["Ride"] = 55.62, ["Fly|Ride"] = 274.98, ["Neon|Ride"] = 588.06, ["Neon|Fly|Ride"] = 480.96, ["Mega|Ride"] = 408.5, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.55, ["Fly"] = 75.63, ["Ride"] = 39.27, ["Fly|Ride"] = 97.85, ["Neon"] = 77.44, ["Neon|Fly"] = 205.98, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 341.49, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 454.77}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 23.17, ["Fly|Ride"] = 82.4, ["Neon"] = 19.68, ["Neon|Fly"] = 51.19, ["Neon|Ride"] = 44.29, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 137.73, ["Mega|Ride"] = 159.56, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 972.4, ["Fly"] = 1082.72, ["Ride"] = 943.69, ["Fly|Ride"] = 909.99, ["Neon"] = 3032.9, ["Neon|Fly"] = 3396.32, ["Neon|Ride"] = 2883.59, ["Neon|Fly|Ride"] = 2414.99, ["Mega|Fly|Ride"] = 8200.02}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 363.66, ["Ride"] = 453.1, ["Fly|Ride"] = 538.13, ["Neon"] = 1389.11, ["Neon|Fly"] = 1373.84, ["Neon|Ride"] = 1538.6, ["Neon|Fly|Ride"] = 1923.77, ["Mega"] = 10298.49, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.43, ["Ride"] = 103.69, ["Fly|Ride"] = 203.93, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1574.25, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 378.99, ["Ride"] = 329.57, ["Fly|Ride"] = 307.44, ["Neon|Ride"] = 1389.05, ["Neon|Fly|Ride"] = 1389.05, ["Mega"] = 10298.49, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.2, ["Fly"] = 138.02, ["Ride"] = 31.37, ["Fly|Ride"] = 71.05, ["Neon"] = 143.07, ["Neon|Ride"] = 213.01, ["Neon|Fly|Ride"] = 231.52, ["Mega|Fly|Ride"] = 763.85}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 223.13, ["Ride"] = 262.5, ["Fly|Ride"] = 489.2, ["Neon"] = 1419.05, ["Neon|Ride"] = 921.73, ["Neon|Fly|Ride"] = 975.29, ["Mega"] = 4098.99, ["Mega|Ride"] = 4256.88, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 76.13, ["Ride"] = 62.41, ["Fly|Ride"] = 131.98, ["Neon|Ride"] = 447.98, ["Neon|Fly|Ride"] = 549.95, ["Mega|Fly|Ride"] = 1234.89}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1822.08, ["Ride"] = 1717.79, ["Fly|Ride"] = 1771.35, ["Neon|Ride"] = 10804.34, ["Neon|Fly|Ride"] = 5659.03, ["Mega"] = 49432.7, ["Mega|Fly|Ride"] = 23340.68}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.28, ["Fly"] = 89.49, ["Ride"] = 42.32, ["Fly|Ride"] = 104.3, ["Neon"] = 57.17, ["Neon|Fly"] = 185.26, ["Neon|Ride"] = 110.2, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 310.02, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 50.51, ["Fly"] = 119.1, ["Ride"] = 74.17, ["Fly|Ride"] = 157.5, ["Neon"] = 223.13, ["Neon|Ride"] = 292.49, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 892.79, ["Mega|Ride"] = 1008.12, ["Mega|Fly|Ride"] = 959.72}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 68.25, ["Fly"] = 91.85, ["Ride"] = 91.88, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 454.17, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2590.88, ["Ride"] = 2315.18, ["Fly|Ride"] = 1170.33, ["Mega|Fly|Ride"] = 20678.05}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 564.93, ["Fly"] = 821.83, ["Ride"] = 549.95, ["Fly|Ride"] = 669.1, ["Neon"] = 2470.31, ["Neon|Fly|Ride"] = 2778.07, ["Mega|Fly|Ride"] = 16975.74}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 78.75, ["Ride"] = 107.63, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 617.92, ["Neon|Ride"] = 466.74, ["Neon|Fly|Ride"] = 606.11, ["Mega"] = 4119.41, ["Mega|Ride"] = 2602.11, ["Mega|Fly|Ride"] = 2331.31}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.29, ["Ride"] = 22.89, ["Fly|Ride"] = 91.77, ["Neon"] = 72.11, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 755.09, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.38, ["Fly"] = 101.89, ["Ride"] = 48.42, ["Fly|Ride"] = 103, ["Neon"] = 196.88, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1194.5, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 874.13, ["Fly|Ride"] = 918.75, ["Neon"] = 3019.53, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 951.92}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5905.16, ["Ride"] = 4987.5, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29516.48, ["Neon|Fly|Ride"] = 24030.48, ["Mega|Fly|Ride"] = 87870.13}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.5, ["Fly"] = 410.93, ["Ride"] = 294.05, ["Neon"] = 1647.78, ["Neon|Fly|Ride"] = 2059.72, ["Mega"] = 6177.3, ["Mega|Fly|Ride"] = 6173.22}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.5, ["Fly"] = 274.98, ["Ride"] = 100.94, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 616.9, ["Neon|Fly|Ride"] = 1647.78, ["Mega|Fly|Ride"] = 2868.81}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.89, ["Fly"] = 96.83, ["Ride"] = 30.58, ["Neon"] = 146, ["Neon|Fly"] = 1235.14, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 658.08, ["Mega|Ride"] = 718.76, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.17, ["Ride"] = 27.82, ["Fly|Ride"] = 44.34, ["Neon"] = 205.98, ["Neon|Ride"] = 309.07, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2183.03}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.46, ["Fly"] = 274.98, ["Ride"] = 31.5, ["Fly|Ride"] = 140.44, ["Neon"] = 105, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 144.2, ["Mega"] = 670.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.2, ["Fly"] = 21, ["Ride"] = 17.37, ["Fly|Ride"] = 57.75, ["Neon"] = 22.93, ["Neon|Ride"] = 46.32, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 274.95, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 309.02}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 30.19, ["Ride"] = 43.31, ["Fly|Ride"] = 96.83, ["Neon"] = 176.12, ["Neon|Fly"] = 823.9, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 329.57, ["Mega"] = 776.52, ["Mega|Ride"] = 659.04, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 333.38, ["Fly"] = 460.73, ["Ride"] = 398.26, ["Fly|Ride"] = 447.09, ["Neon"] = 1334.82, ["Neon|Fly"] = 1458.29, ["Neon|Ride"] = 1235.83, ["Neon|Fly|Ride"] = 1299.38, ["Mega"] = 7875, ["Mega|Fly"] = 4845.88, ["Mega|Fly|Ride"] = 4843.82}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.06, ["Fly|Ride"] = 35.43, ["Neon"] = 19.67, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 86.43, ["Mega"] = 131.25, ["Mega|Ride"] = 540.48, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.58, ["Fly"] = 95.22, ["Ride"] = 82.36, ["Fly|Ride"] = 116.95, ["Neon"] = 203.44, ["Neon|Fly"] = 274.98, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 683.74, ["Mega|Fly"] = 823.79, ["Mega|Ride"] = 572.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 899.17, ["Fly"] = 972.39, ["Ride"] = 773.07, ["Fly|Ride"] = 870.19, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1443.74, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.95, ["Fly"] = 91.88, ["Ride"] = 50.66, ["Fly|Ride"] = 76.22, ["Neon"] = 205.98, ["Neon|Ride"] = 179.22, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 753.38}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 380.61, ["Ride"] = 272.9, ["Fly|Ride"] = 353.06, ["Neon|Ride"] = 1263.64, ["Neon|Fly|Ride"] = 1233.78, ["Mega|Fly|Ride"] = 13887.99}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 150.94, ["Fly"] = 231.54, ["Ride"] = 190.31, ["Fly|Ride"] = 196.75, ["Neon"] = 633.63, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 755.93, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 682.5, ["Fly|Ride"] = 840.46, ["Neon|Ride"] = 2609.64, ["Neon|Fly|Ride"] = 2993.79, ["Mega|Fly|Ride"] = 6823.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.36, ["Ride"] = 43.21, ["Fly|Ride"] = 108.83, ["Neon"] = 78.08, ["Neon|Fly"] = 277.83, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 261.6, ["Mega|Ride"] = 355.31, ["Mega|Fly|Ride"] = 513.85}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3176.25, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3022.99, ["Neon"] = 13732, ["Neon|Fly|Ride"] = 6542.82, ["Mega|Fly|Ride"] = 25058.15}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 98.43, ["Fly"] = 131.25, ["Ride"] = 103.95, ["Fly|Ride"] = 144.38, ["Neon"] = 550.97, ["Neon|Fly"] = 480.96, ["Neon|Ride"] = 549.95, ["Neon|Fly|Ride"] = 522.15, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 26.75, ["Ride"] = 18.24, ["Fly|Ride"] = 52.5, ["Neon"] = 18.67, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 130.69, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 57.9, ["Neon"] = 18.38, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 278.35}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.02, ["Ride"] = 32.82, ["Fly|Ride"] = 52.48, ["Neon|Ride"] = 377.97, ["Neon|Fly|Ride"] = 308.98, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1085.44, ["Ride"] = 1219.36, ["Fly|Ride"] = 1247.4}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5906.25, ["Ride"] = 7023.11, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 24.17, ["Fly"] = 30.19, ["Ride"] = 27.57, ["Fly|Ride"] = 46.56, ["Neon"] = 666.33, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 127.35, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.59, ["Fly"] = 45.83, ["Ride"] = 26.08, ["Fly|Ride"] = 70.88, ["Neon"] = 72.19, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 648.98, ["Mega|Ride"] = 614.56, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 58.46, ["Fly"] = 157.49, ["Ride"] = 63, ["Fly|Ride"] = 118.02, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 363.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 213.94, ["Fly"] = 295.58, ["Ride"] = 236.24, ["Fly|Ride"] = 288.75, ["Neon"] = 961.89, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1081.15, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 3898.53}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.99, ["Ride"] = 32.69, ["Fly|Ride"] = 86.52, ["Neon"] = 23.7, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 136.5, ["Mega|Ride"] = 188.9, ["Mega|Fly|Ride"] = 298.64}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 196.88, ["Fly"] = 308.98, ["Ride"] = 262.5, ["Fly|Ride"] = 262.5, ["Neon"] = 821.63, ["Neon|Ride"] = 923.72, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 3395.62}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 41.21, ["Ride"] = 15.65, ["Fly|Ride"] = 52.56, ["Neon"] = 22.72, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 34.02, ["Neon|Fly|Ride"] = 105, ["Mega"] = 416.08, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 268.82, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1111.24, ["Mega"] = 10298.49, ["Mega|Ride"] = 4118.89, ["Mega|Fly|Ride"] = 4118.89}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.12, ["Fly"] = 74.05, ["Ride"] = 26.79, ["Fly|Ride"] = 52.5, ["Neon"] = 62.05, ["Neon|Fly"] = 294.04, ["Neon|Ride"] = 92.63, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 23.17, ["Fly|Ride"] = 59.07, ["Neon"] = 5.25, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 76.67, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 187.7}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 41.21, ["Mega"] = 18.38, ["Mega|Ride"] = 136.58, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 22.1, ["Fly|Ride"] = 152.43, ["Neon"] = 6.02, ["Neon|Ride"] = 51.51, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 69.25, ["Mega|Fly"] = 154311.55, ["Mega|Ride"] = 114.59, ["Mega|Fly|Ride"] = 160.08}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 47.25, ["Fly"] = 138.02, ["Ride"] = 116.74, ["Fly|Ride"] = 178.58, ["Neon"] = 308.61, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 379.21, ["Mega|Ride"] = 1338.66, ["Mega|Fly|Ride"] = 1090.01}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.59, ["Ride"] = 15.65, ["Fly|Ride"] = 103.47, ["Neon"] = 4.32, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.94, ["Mega"] = 129.94, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.56, ["Neon"] = 71.91, ["Neon|Ride"] = 210, ["Mega"] = 495.44}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 45.64, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 16, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.21, ["Ride"] = 14.99, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 13.17, ["Neon|Fly|Ride"] = 31.4, ["Mega"] = 13.55, ["Mega|Fly"] = 55.61, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 48.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 12.45, ["Fly|Ride"] = 39.26, ["Neon"] = 2.1, ["Neon|Fly"] = 39.26, ["Neon|Ride"] = 15.61, ["Neon|Fly|Ride"] = 45.31, ["Mega"] = 30.32, ["Mega|Fly"] = 155.1, ["Mega|Ride"] = 34.39, ["Mega|Fly|Ride"] = 108.81}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 103, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 103, ["Mega"] = 16.89, ["Mega|Ride"] = 120.62, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.68, ["Fly|Ride"] = 107.62, ["Neon"] = 2.1, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.17, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 20.34, ["Mega|Ride"] = 96.08}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 19.69, ["Fly|Ride"] = 70.12, ["Neon"] = 8.09, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 31.83, ["Neon|Fly|Ride"] = 70.26, ["Mega"] = 101.43, ["Mega|Fly"] = 155.01, ["Mega|Ride"] = 107.24, ["Mega|Fly|Ride"] = 168.74}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.39, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 13.32, ["Mega|Ride"] = 32.48, ["Mega|Fly|Ride"] = 185.36}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 105, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.29, ["Neon|Ride"] = 26.79, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 19.59, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 144.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.45, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 19.59, ["Neon|Ride"] = 12.29, ["Neon|Fly|Ride"] = 30.82, ["Mega"] = 15.59, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 19.82, ["Mega|Fly|Ride"] = 50.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 34.91, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.5, ["Neon"] = 4.8, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.66, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 159.73}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 94.71, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 12.99, ["Neon|Fly"] = 103, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.37, ["Ride"] = 10.31, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 14.24, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 26.78, ["Mega"] = 15.04, ["Mega|Fly"] = 28.25, ["Mega|Ride"] = 18.52, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 27.4, ["Fly|Ride"] = 138.02, ["Neon"] = 11.46, ["Neon|Ride"] = 111.14, ["Neon|Fly|Ride"] = 109.18, ["Mega"] = 87.94, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 21.99, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 67.1, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 203.44, ["Mega|Ride"] = 285.57, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 11.82, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.04, ["Mega"] = 20.83, ["Mega|Fly"] = 1312.5, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 172.01, ["Ride"] = 28.72, ["Neon"] = 3.81, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 72.76, ["Mega|Fly"] = 164.77, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 360.42}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 27.82, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 39.38, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.21, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 18.54, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 137.91}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.83, ["Ride"] = 19.59, ["Fly|Ride"] = 41.91, ["Neon"] = 4.7, ["Neon|Fly"] = 55.62, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 75.48, ["Mega"] = 77.6, ["Mega|Ride"] = 82.4, ["Mega|Fly|Ride"] = 231.49}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.16, ["Neon"] = 3.71, ["Neon|Ride"] = 52.29, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 40.58, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 31.9, ["Ride"] = 14.89, ["Fly|Ride"] = 44.88, ["Neon"] = 4.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 67.98, ["Neon"] = 36.66, ["Neon|Ride"] = 74.17, ["Mega"] = 133.88, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 16.7, ["Fly|Ride"] = 138.02, ["Neon"] = 11.46, ["Neon|Fly"] = 104.1, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 303.81, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.48}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.67, ["Ride"] = 19.59, ["Fly|Ride"] = 38.75, ["Neon"] = 19.59, ["Neon|Fly"] = 25.97, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 102.8, ["Mega"] = 273.96, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 220.38}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.94, ["Fly"] = 110.93, ["Fly|Ride"] = 137.82, ["Neon"] = 30.98, ["Mega"] = 179.22, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.81, ["Ride"] = 131.25, ["Neon"] = 121.42, ["Neon|Ride"] = 231.52, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 64.78, ["Fly|Ride"] = 104.71, ["Neon"] = 38.99, ["Neon|Ride"] = 125.71, ["Neon|Fly|Ride"] = 220.4, ["Mega"] = 253.32, ["Mega|Ride"] = 214.19}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.14, ["Ride"] = 30.09, ["Fly|Ride"] = 120.75, ["Neon"] = 152.06, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 192.6, ["Mega"] = 246.15, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 64.98, ["Mega"] = 21, ["Mega|Fly"] = 123.59, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.59, ["Fly"] = 22.91, ["Ride"] = 20.04, ["Fly|Ride"] = 40.34, ["Neon"] = 36.66, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 306.91, ["Mega|Fly"] = 329.53, ["Mega|Ride"] = 513.87, ["Mega|Fly|Ride"] = 255.26}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.56, ["Neon"] = 2.1, ["Neon|Ride"] = 26.6, ["Mega"] = 27.24, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 123.44}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 27.77, ["Neon"] = 2.1, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 408.98, ["Mega"] = 51.17, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.42, ["Ride"] = 12.75, ["Fly|Ride"] = 55.13, ["Neon"] = 6.43, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 118.25, ["Mega"] = 141.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.87, ["Ride"] = 49.45, ["Fly|Ride"] = 58.72, ["Neon"] = 35.04, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 214.39, ["Mega"] = 325.42, ["Mega|Ride"] = 272.69, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 32.81, ["Neon"] = 3.86, ["Mega"] = 14.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.78, ["Fly|Ride"] = 274626.43, ["Neon"] = 3.86, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 26.25, ["Mega|Ride"] = 47.94, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 14.17, ["Fly|Ride"] = 34.13, ["Neon"] = 8.29, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 37.09, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 201.39}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 26.25, ["Fly|Ride"] = 147.04, ["Neon"] = 2.1, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 110.45, ["Mega"] = 23, ["Mega|Fly"] = 123.85, ["Mega|Ride"] = 73.71, ["Mega|Fly|Ride"] = 160.65}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 149087.79, ["Mega"] = 18.38, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 86.82, ["Mega|Fly|Ride"] = 144.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 19.25, ["Fly|Ride"] = 78.28, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 22.47, ["Neon|Fly|Ride"] = 65, ["Mega"] = 19.08, ["Mega|Fly"] = 61.8, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.42, ["Neon"] = 2.63, ["Mega"] = 18.37, ["Mega|Ride"] = 224.39}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.35, ["Neon|Ride"] = 155.12, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 155.1}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 22.67, ["Fly|Ride"] = 49.88, ["Neon"] = 3.94, ["Neon|Fly"] = 55.62, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 39.38, ["Mega|Ride"] = 90.76, ["Mega|Fly|Ride"] = 94.15}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.82, ["Ride"] = 138.92, ["Neon"] = 96.83, ["Mega"] = 422.25, ["Mega|Ride"] = 428.38, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 54.76, ["Neon|Ride"] = 203.93, ["Mega"] = 1568.48, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 261.6, ["Mega"] = 295.25, ["Mega|Ride"] = 347.22, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.24, ["Ride"] = 15.46, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 10.5, ["Neon|Ride"] = 12.26, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 103.85, ["Mega|Fly"] = 32.86, ["Mega|Ride"] = 21.7, ["Mega|Fly|Ride"] = 45.85}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.69, ["Fly|Ride"] = 110.2, ["Neon"] = 11.59, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 686.93, ["Mega"] = 51.66, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 55.6, ["Mega"] = 15.39, ["Mega|Fly"] = 84, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.47, ["Neon"] = 2.63, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 110.2, ["Mega"] = 24.06, ["Mega|Ride"] = 101.96, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.86, ["Ride"] = 19.95, ["Fly|Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 182.03, ["Mega"] = 208.85, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.66, ["Ride"] = 164.07, ["Fly|Ride"] = 245.42, ["Neon|Ride"] = 757.32, ["Mega"] = 8238.8, ["Mega|Fly|Ride"] = 3501.06}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 18.56, ["Neon"] = 7.35, ["Neon|Ride"] = 82.41, ["Mega"] = 70.35, ["Mega|Ride"] = 108.81, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.84, ["Fly"] = 63.03, ["Ride"] = 25.57, ["Neon"] = 30.01, ["Neon|Ride"] = 92.61, ["Neon|Fly|Ride"] = 164.8, ["Mega"] = 357.33, ["Mega|Ride"] = 513.85, ["Mega|Fly|Ride"] = 401.61}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.73, ["Fly|Ride"] = 32.24, ["Neon"] = 5.16, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 55.62, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.02, ["Neon|Fly"] = 549.95, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.83, ["Mega|Ride"] = 168.89, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.77, ["Fly"] = 17.99, ["Ride"] = 14, ["Fly|Ride"] = 35.44, ["Neon"] = 26.17, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 74.04, ["Mega|Ride"] = 267.74, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.85, ["Ride"] = 34.12, ["Fly|Ride"] = 249.58, ["Neon"] = 53.02, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 611.75, ["Mega"] = 340.45, ["Mega|Ride"] = 254.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.65, ["Ride"] = 15.37, ["Fly|Ride"] = 40.6, ["Neon"] = 15.65, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 53.57, ["Neon|Fly|Ride"] = 75.29, ["Mega|Ride"] = 233.76, ["Mega|Fly|Ride"] = 222.66}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 170.97, ["Ride"] = 76.82, ["Fly|Ride"] = 157.5, ["Neon"] = 346.32, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 348.87, ["Mega|Fly|Ride"] = 4805.72}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 236.25, ["Fly"] = 329.57, ["Ride"] = 219.19, ["Fly|Ride"] = 274.98, ["Neon|Ride"] = 1017.51, ["Neon|Fly|Ride"] = 1235.83, ["Mega"] = 10297.21, ["Mega|Fly|Ride"] = 4118.89}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 51.98, ["Fly"] = 123.87, ["Ride"] = 62.52, ["Fly|Ride"] = 121.92, ["Neon"] = 692.33, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1234.66, ["Mega|Fly|Ride"] = 1095.68}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.1, ["Fly"] = 24.74, ["Ride"] = 26.79, ["Fly|Ride"] = 138.02, ["Neon"] = 22.67, ["Neon|Ride"] = 70.17, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 158.82, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 262.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.87, ["Fly"] = 69.02, ["Ride"] = 35.01, ["Fly|Ride"] = 89.25, ["Neon"] = 72.09, ["Neon|Ride"] = 82.41, ["Mega"] = 353.07, ["Mega|Ride"] = 364.54, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 25.49, ["Fly|Ride"] = 35.44, ["Neon"] = 4.14, ["Neon|Fly"] = 25.49, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 455.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 27.82, ["Ride"] = 35.44, ["Fly|Ride"] = 299.83, ["Neon"] = 92.98, ["Neon|Fly"] = 344, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.21, ["Ride"] = 15.89, ["Fly|Ride"] = 52.5, ["Neon"] = 15.63, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 100.54, ["Mega|Fly"] = 86.82, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.26, ["Ride"] = 26.6, ["Fly|Ride"] = 328.13, ["Neon"] = 25.49, ["Neon|Ride"] = 55.62, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 207.38, ["Mega|Ride"] = 231.41, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 13.93, ["Mega|Fly"] = 41.21, ["Mega|Ride"] = 50.47, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 17.48, ["Ride"] = 18.05, ["Fly|Ride"] = 55.62, ["Neon"] = 13.29, ["Neon|Fly"] = 103, ["Neon|Ride"] = 26.79, ["Neon|Fly|Ride"] = 97.85, ["Mega"] = 79.06, ["Mega|Ride"] = 97.82, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.43, ["Fly"] = 24.93, ["Ride"] = 18.52, ["Fly|Ride"] = 52.5, ["Neon"] = 45.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 549.95, ["Mega"] = 283.5, ["Mega|Ride"] = 192.57, ["Mega|Fly|Ride"] = 221.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 142.94, ["Fly"] = 274.98, ["Ride"] = 189, ["Fly|Ride"] = 300.66, ["Neon"] = 685.13, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 723.13, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 13.91, ["Ride"] = 30.91, ["Fly|Ride"] = 205.98, ["Neon"] = 66.94, ["Neon|Ride"] = 138.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 344, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.75, ["Fly|Ride"] = 45.29, ["Neon"] = 69.01, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.85, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 98.44, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 476.52, ["Mega|Fly"] = 823.79, ["Mega|Ride"] = 471.19, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.2}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 23.61, ["Neon|Ride"] = 274.95, ["Neon|Fly|Ride"] = 617.92, ["Mega"] = 823.9, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.79, ["Fly"] = 35.49, ["Ride"] = 32.82, ["Fly|Ride"] = 58.47, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 92.63, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 2059.72, ["Mega|Fly|Ride"] = 1907.07}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Fly|Ride"] = 103, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 35.26, ["Mega|Fly"] = 274.95, ["Mega|Ride"] = 135.94, ["Mega|Fly|Ride"] = 225.54}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.83, ["Fly"] = 27.81, ["Ride"] = 23.7, ["Fly|Ride"] = 61.81, ["Neon"] = 45.55, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 23.17, ["Mega"] = 231.48, ["Mega|Fly"] = 386.56, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.35, ["Fly|Ride"] = 46.12, ["Neon"] = 15.37, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 154.35, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 34.35, ["Fly|Ride"] = 205.98, ["Neon"] = 3.84, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 411.96, ["Mega"] = 31.4, ["Mega|Ride"] = 76.21, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 32.23, ["Ride"] = 86.63, ["Fly|Ride"] = 710.61, ["Neon"] = 307.97, ["Neon|Fly|Ride"] = 618.13, ["Mega"] = 799.99, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.71, ["Ride"] = 26.25, ["Fly|Ride"] = 210, ["Neon"] = 79.48, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 462.95}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 138.02, ["Ride"] = 22.31, ["Fly|Ride"] = 61.52, ["Neon"] = 25.87, ["Neon|Fly"] = 463.03, ["Neon|Ride"] = 33.06, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 339.94, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.13, ["Ride"] = 26.25, ["Fly|Ride"] = 262.44, ["Neon"] = 315, ["Neon|Ride"] = 411.96, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.25, ["Fly"] = 26.17, ["Ride"] = 30.58, ["Fly|Ride"] = 55.62, ["Neon"] = 48.56, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 129.78, ["Mega"] = 261.76, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 295.65}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.38, ["Fly"] = 145.69, ["Ride"] = 108.83, ["Fly|Ride"] = 185.35, ["Neon"] = 217.95, ["Neon|Fly"] = 525, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 406.81, ["Mega"] = 1070.03, ["Mega|Ride"] = 1089.46, ["Mega|Fly|Ride"] = 926.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.47, ["Ride"] = 57.75, ["Fly|Ride"] = 131.24, ["Neon"] = 85.22, ["Neon|Ride"] = 148.64, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 473.74, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 2.63, ["Ride"] = 27.57, ["Fly|Ride"] = 47.33, ["Neon"] = 123.2, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 247.73, ["Mega"] = 416.96, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 17.06, ["Ride"] = 109.18, ["Fly|Ride"] = 157.91, ["Neon"] = 114.61, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.14, ["Mega|Ride"] = 259.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.88, ["Ride"] = 35.02, ["Fly|Ride"] = 55.72, ["Neon"] = 41.48, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 155.12, ["Mega"] = 221.82, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 57.1, ["Mega"] = 15.1, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.94, ["Ride"] = 28.14, ["Neon"] = 19.69, ["Neon|Fly"] = 123.6, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.08, ["Mega|Ride"] = 203.89, ["Mega|Fly|Ride"] = 465.26}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 6.97, ["Neon"] = 23.63, ["Mega"] = 196.23, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.74, ["Ride"] = 32.79, ["Fly|Ride"] = 115.78, ["Neon"] = 18.84, ["Neon|Ride"] = 82.41, ["Mega"] = 199.8, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.38, ["Ride"] = 535.5, ["Fly|Ride"] = 658.88, ["Neon"] = 1785.77, ["Neon|Ride"] = 1766.19, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.61, ["Fly"] = 27.82, ["Ride"] = 26.92, ["Fly|Ride"] = 62.52, ["Neon"] = 32.97, ["Neon|Ride"] = 94.77, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.12, ["Mega|Ride"] = 355.31, ["Mega|Fly|Ride"] = 481.46}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.3, ["Fly"] = 524.48, ["Ride"] = 23.61, ["Fly|Ride"] = 51.35, ["Neon"] = 61.81, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.15, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 303.81, ["Mega|Ride"] = 323.65, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.82, ["Fly"] = 96.83, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 196.88, ["Mega"] = 262.78, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 9.43, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 105.6, ["Mega"] = 58.97, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 98.97, ["Mega|Fly|Ride"] = 249.21}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 19.69, ["Neon"] = 3.84, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 88.25, ["Mega"] = 31.27, ["Mega|Fly"] = 192.57, ["Mega|Ride"] = 85.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.25, ["Ride"] = 35.89, ["Fly|Ride"] = 323.64, ["Neon"] = 65.62, ["Neon|Ride"] = 89.25, ["Mega"] = 398.57, ["Mega|Ride"] = 365.74, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 6.56, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 42.45, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 59.06, ["Fly|Ride"] = 99.75, ["Neon"] = 11.59, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 138, ["Neon|Fly|Ride"] = 155.03, ["Mega"] = 183.73, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.94, ["Ride"] = 522.38, ["Fly|Ride"] = 556.07, ["Neon|Ride"] = 1441.8, ["Neon|Fly|Ride"] = 1347.76, ["Mega|Fly|Ride"] = 8100.83}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.21, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 411.96, ["Neon"] = 123.6, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 469.63, ["Mega|Ride"] = 380.63}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 77.93, ["Ride"] = 29.19, ["Fly|Ride"] = 162.73, ["Neon"] = 7.62, ["Neon|Ride"] = 32.33, ["Mega"] = 41.91, ["Mega|Ride"] = 108.81, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 115.64, ["Neon|Fly|Ride"] = 411.96, ["Mega"] = 26.25, ["Mega|Ride"] = 119.55, ["Mega|Fly|Ride"] = 189.52}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.8, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 164.8, ["Neon"] = 115.4, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 344, ["Mega"] = 577.62, ["Mega|Ride"] = 509.73, ["Mega|Fly|Ride"] = 589.92}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.82, ["Ride"] = 41.21, ["Fly|Ride"] = 105, ["Neon"] = 108.83, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 422.25, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.81, ["Fly|Ride"] = 411.96, ["Neon"] = 309.09, ["Neon|Ride"] = 174.7, ["Mega"] = 633.08, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 1234.89}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.95, ["Ride"] = 22.67, ["Fly|Ride"] = 262.5, ["Neon"] = 274.98, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 549.95, ["Mega|Ride"] = 647.73, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.5, ["Ride"] = 467.57, ["Fly|Ride"] = 617.92, ["Neon"] = 1029.87, ["Neon|Ride"] = 1304.83, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 3871.76}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.78, ["Fly"] = 69.65, ["Ride"] = 22.67, ["Fly|Ride"] = 138.02, ["Neon"] = 111.51, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 180.06, ["Mega|Ride"] = 480.89, ["Mega|Fly|Ride"] = 850.56}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.49, ["Ride"] = 69.98, ["Fly|Ride"] = 127.32, ["Neon"] = 36.39, ["Neon|Ride"] = 221.82, ["Mega"] = 218.34, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.9, ["Ride"] = 70.88, ["Fly|Ride"] = 255.85, ["Neon"] = 70.88, ["Neon|Ride"] = 129.77, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 272.25, ["Mega|Fly"] = 686.83, ["Mega|Ride"] = 294.05, ["Mega|Fly|Ride"] = 368.17}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.52, ["Fly"] = 41.21, ["Ride"] = 52.5, ["Fly|Ride"] = 138.02, ["Neon"] = 6.55, ["Neon|Ride"] = 41.21, ["Neon|Fly|Ride"] = 204.95, ["Mega"] = 40.27, ["Mega|Fly"] = 105, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 44.22, ["Ride"] = 57.69, ["Fly|Ride"] = 157.5, ["Neon"] = 201.44, ["Neon|Ride"] = 274.98, ["Mega"] = 1373.84, ["Mega|Ride"] = 1345.86, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 578.82, ["Ride"] = 27.43, ["Neon"] = 7.88, ["Neon|Fly"] = 179.22, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 65.59, ["Mega|Ride"] = 90.2, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.89, ["Ride"] = 27.57, ["Fly|Ride"] = 149.76, ["Neon"] = 6.42, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 39.62, ["Neon|Fly|Ride"] = 125.02, ["Mega"] = 41.1, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 66.24, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 31.27, ["Fly|Ride"] = 122.72, ["Neon"] = 12.87, ["Neon|Ride"] = 55.62, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 78.75, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 49.77, ["Fly"] = 92.63, ["Ride"] = 78.74, ["Fly|Ride"] = 193.33, ["Neon"] = 291.38, ["Neon|Ride"] = 282.76, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.35, ["Ride"] = 289.88, ["Fly|Ride"] = 393.75, ["Neon"] = 1431.5, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 6179.1, ["Mega|Fly|Ride"] = 5247.36}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.57, ["Neon"] = 28.54, ["Neon|Ride"] = 143.56, ["Mega"] = 101.75, ["Mega|Ride"] = 188.73, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.52, ["Fly"] = 69.02, ["Ride"] = 28.46, ["Fly|Ride"] = 155.14, ["Neon"] = 11.71, ["Neon|Ride"] = 43.56, ["Neon|Fly|Ride"] = 179.22, ["Mega"] = 61.69, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.47, ["Fly"] = 30.11, ["Ride"] = 27.56, ["Fly|Ride"] = 175.08, ["Neon"] = 32.81, ["Mega"] = 373.42, ["Mega|Ride"] = 344.74}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 61.99, ["Ride"] = 63.87, ["Neon"] = 7.88, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 88.75, ["Mega|Fly"] = 146.24, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 246.12}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.97, ["Neon"] = 15.46, ["Mega"] = 39.38, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 271.87}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 6.15, ["Neon|Ride"] = 22.67, ["Neon|Fly|Ride"] = 101.88, ["Mega"] = 41.99, ["Mega|Ride"] = 99.54, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 17.37, ["Ride"] = 24.94, ["Fly|Ride"] = 57.4, ["Neon"] = 14.99, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 39.14, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 101.97, ["Mega|Ride"] = 232.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.04, ["Ride"] = 42.62, ["Fly|Ride"] = 77.15, ["Neon"] = 137.69, ["Mega"] = 575.7, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.91, ["Fly"] = 123.6, ["Ride"] = 103, ["Fly|Ride"] = 111.69, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 541.72, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 45.94, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 4.14, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 61.69, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 89.6, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.18, ["Fly"] = 35.02, ["Ride"] = 73.48, ["Neon"] = 27.82, ["Neon|Ride"] = 69.46, ["Neon|Fly|Ride"] = 273.96, ["Mega"] = 527.63, ["Mega|Ride"] = 354.24, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 578.39, ["Fly|Ride"] = 492.19, ["Neon"] = 4119.41, ["Neon|Ride"] = 1923.77, ["Mega|Fly|Ride"] = 7208.04}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 34.16, ["Fly"] = 96.83, ["Ride"] = 42.95, ["Fly|Ride"] = 92.26, ["Neon"] = 170.52, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 185.21, ["Mega|Ride"] = 926.77, ["Mega|Fly|Ride"] = 983.75}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 17.16, ["Fly|Ride"] = 281.29, ["Neon"] = 9.18, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 93.74, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 17.2, ["Neon|Ride"] = 69.02, ["Mega|Ride"] = 411.9}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 20.6, ["Fly"] = 76.22, ["Ride"] = 43.3, ["Fly|Ride"] = 82.41, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 364.58, ["Mega"] = 2471.34, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1303.64}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.84, ["Fly"] = 117.42, ["Ride"] = 98.75, ["Fly|Ride"] = 123.6, ["Neon"] = 430.1, ["Neon|Fly|Ride"] = 463.02, ["Mega"] = 8238.8, ["Mega|Fly|Ride"] = 1876.17}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 228.17, ["Ride"] = 288.75, ["Fly|Ride"] = 509.25, ["Neon|Ride"] = 1235.83, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4374.26, ["Mega|Fly|Ride"] = 4393.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.11, ["Fly"] = 51.19, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 76.04, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 216.48, ["Mega"] = 390.1, ["Mega|Ride"] = 350.7, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.59, ["Ride"] = 13.14, ["Fly|Ride"] = 41.9, ["Neon"] = 9.17, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.67, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 35.76, ["Ride"] = 38.68, ["Fly|Ride"] = 41.1, ["Neon"] = 30.75, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 81.03, ["Mega"] = 376.94, ["Mega|Ride"] = 316.15, ["Mega|Fly|Ride"] = 315.11}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 480.96, ["Ride"] = 370.33, ["Fly|Ride"] = 609.69, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4688.25}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 59.75, ["Neon"] = 10.5, ["Neon|Ride"] = 59.75, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 87.68, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.83, ["Fly"] = 18.54, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 49.87, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 164.8, ["Mega|Fly"] = 204.93, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.6, ["Ride"] = 114.33, ["Neon"] = 112.88, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 432.93, ["Mega"] = 522.41, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 210.1, ["Ride"] = 111.57, ["Fly|Ride"] = 164.8, ["Neon"] = 637.5, ["Neon|Ride"] = 563.34, ["Neon|Fly|Ride"] = 617.21, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.36, ["Fly"] = 35.02, ["Ride"] = 27.46, ["Fly|Ride"] = 55.62, ["Neon"] = 85.32, ["Neon|Ride"] = 85.49, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 632.27, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 526.31}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 23.17, ["Neon"] = 2.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 686.93, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 24.42, ["Mega|Fly"] = 71.36, ["Mega|Ride"] = 44.8, ["Mega|Fly|Ride"] = 116.22}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.59, ["Fly"] = 411.96, ["Ride"] = 64.84, ["Fly|Ride"] = 138.02, ["Neon"] = 31.19, ["Neon|Ride"] = 81.14, ["Neon|Fly|Ride"] = 169.1, ["Mega"] = 153.21, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 363.08}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Fly"] = 1528.04, ["Ride"] = 1207.5, ["Fly|Ride"] = 1312.5, ["Neon"] = 3860.57, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 490.88, ["Ride"] = 523.56, ["Fly|Ride"] = 548.63, ["Neon"] = 1923.77, ["Neon|Ride"] = 1975.32, ["Neon|Fly|Ride"] = 2046.33, ["Mega"] = 16475.52, ["Mega|Fly|Ride"] = 9336.49}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 313.69, ["Fly"] = 344, ["Ride"] = 370.13, ["Fly|Ride"] = 443.89, ["Neon"] = 721.87, ["Neon|Fly"] = 1235.14, ["Neon|Ride"] = 753.12, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 287.43, ["Fly"] = 411.96, ["Ride"] = 393.41, ["Fly|Ride"] = 459.38, ["Neon"] = 925.32, ["Neon|Fly"] = 1081.18, ["Neon|Ride"] = 965.43, ["Neon|Fly|Ride"] = 1085.48, ["Mega|Fly|Ride"] = 4628.61}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 17.97, ["Fly|Ride"] = 38.06, ["Neon"] = 5.7, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 76.22, ["Mega|Ride"] = 114.18, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 340.85, ["Fly"] = 1373.84, ["Ride"] = 434.11, ["Fly|Ride"] = 563.5, ["Neon"] = 1440.77, ["Neon|Ride"] = 1360.23, ["Neon|Fly|Ride"] = 1383.76, ["Mega|Ride"] = 6590.21, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.68, ["Fly"] = 183.75, ["Ride"] = 27.82, ["Fly|Ride"] = 62.41, ["Neon"] = 12.7, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 81.2, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 365.57}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.83, ["Ride"] = 18.56, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 61.62, ["Neon|Fly|Ride"] = 109.31, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 24.44, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 78.37, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 925.88, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7717.73, ["Ride"] = 24.45, ["Fly|Ride"] = 63.58, ["Neon"] = 29.94, ["Neon|Ride"] = 77.57, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.84, ["Neon|Fly"] = 118.46, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 19.28, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 121.52}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 36.01, ["Ride"] = 20.61, ["Fly|Ride"] = 66.89, ["Neon"] = 11.24, ["Neon|Fly"] = 96.83, ["Neon|Ride"] = 38.76, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 100.33, ["Mega|Fly"] = 171.98, ["Mega|Ride"] = 117.76, ["Mega|Fly|Ride"] = 153.85}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.68, ["Fly"] = 91.77, ["Ride"] = 27.8, ["Fly|Ride"] = 51.98, ["Neon"] = 19.69, ["Neon|Fly"] = 110.2, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 246.15, ["Mega"] = 237.57, ["Mega|Ride"] = 440.73, ["Mega|Fly|Ride"] = 309.02}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.39, ["Fly"] = 196.88, ["Ride"] = 60.77, ["Neon"] = 52.05, ["Neon|Fly|Ride"] = 262.78, ["Mega"] = 411.96, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.65, ["Fly"] = 6174.58, ["Ride"] = 27.09, ["Neon"] = 36.39, ["Neon|Ride"] = 137.91, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 5.74, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 59.75, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 144.27, ["Fly"] = 227.61, ["Ride"] = 205.98, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 958.8, ["Neon|Fly|Ride"] = 1029.87, ["Mega"] = 8238.8, ["Mega|Ride"] = 4118.89, ["Mega|Fly|Ride"] = 4105.5}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.33, ["Ride"] = 15.43, ["Fly|Ride"] = 34.85, ["Neon"] = 2.1, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 22.28, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 39.37, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 152.41}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.19, ["Fly"] = 138.02, ["Ride"] = 69.46, ["Fly|Ride"] = 183.74, ["Neon"] = 103, ["Neon|Ride"] = 178.27, ["Mega"] = 370.76, ["Mega|Ride"] = 398.52, ["Mega|Fly|Ride"] = 1029.73}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 33.23, ["Ride"] = 93.19, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 274.98, ["Mega"] = 786.19, ["Mega|Ride"] = 810.14, ["Mega|Fly|Ride"] = 1027.68}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.12, ["Ride"] = 249.38, ["Fly|Ride"] = 333.64, ["Neon"] = 708.73, ["Neon|Fly"] = 1157.58, ["Neon|Ride"] = 823.9, ["Neon|Fly|Ride"] = 864.08, ["Mega|Fly|Ride"] = 3240.55}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.65, ["Fly"] = 168.88, ["Fly|Ride"] = 138.92, ["Neon"] = 155.14, ["Neon|Ride"] = 145.34, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.88, ["Ride"] = 57.75, ["Fly|Ride"] = 617.92, ["Neon"] = 39.15, ["Neon|Fly"] = 155.12, ["Neon|Ride"] = 199.49, ["Mega"] = 686.93, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1444.89, ["Ride"] = 1108.72, ["Fly|Ride"] = 1149.75, ["Neon"] = 4630.36, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 17492.89}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.76, ["Fly"] = 19.69, ["Ride"] = 19.56, ["Fly|Ride"] = 52.5, ["Neon"] = 40.53, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 231.52, ["Mega|Ride"] = 233.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.41, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 31.83, ["Neon|Ride"] = 91.47, ["Mega"] = 233.8, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.85, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.52, ["Fly"] = 81.37, ["Ride"] = 26.37, ["Fly|Ride"] = 69.57, ["Neon"] = 11.42, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.02, ["Mega"] = 107.12, ["Mega|Ride"] = 176.67, ["Mega|Fly|Ride"] = 720.57}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.96, ["Ride"] = 55.62, ["Fly|Ride"] = 100.31, ["Neon"] = 65.62, ["Neon|Ride"] = 76.27, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 342.57, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 20.61, ["Ride"] = 18.47, ["Fly|Ride"] = 39.29, ["Neon"] = 19.64, ["Neon|Fly"] = 41.21, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 92.61, ["Mega|Ride"] = 158.59, ["Mega|Fly|Ride"] = 309.02}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 21.97, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 118.13, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 220.4, ["Fly"] = 261.6, ["Ride"] = 229.69, ["Fly|Ride"] = 391.36, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 20.61, ["Fly|Ride"] = 72.19, ["Neon"] = 9.78, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 81.18, ["Mega|Fly"] = 411.9, ["Mega|Ride"] = 111.97, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Fly|Ride"] = 88.87, ["Neon"] = 77.43, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 93.11, ["Ride"] = 26.23, ["Neon"] = 13.44, ["Neon|Ride"] = 93.74, ["Mega"] = 83.99, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 370.61}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 203.23, ["Ride"] = 315, ["Fly|Ride"] = 686.93, ["Neon"] = 656.25, ["Neon|Fly"] = 1029.87, ["Neon|Ride"] = 823.9, ["Neon|Fly|Ride"] = 1098.86, ["Mega"] = 3089.56, ["Mega|Ride"] = 4942.67, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 25.5, ["Fly"] = 60.77, ["Ride"] = 45.31, ["Fly|Ride"] = 162.73, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 782.6}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.74, ["Ride"] = 39.68, ["Fly|Ride"] = 89.25, ["Neon"] = 85.32, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 506.13, ["Mega|Ride"] = 562.25, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.41, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 48.57, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.85}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 52.4, ["Fly"] = 69.02, ["Ride"] = 110.2, ["Fly|Ride"] = 157.49, ["Neon"] = 262.48, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 291.21, ["Neon|Fly|Ride"] = 353.98, ["Mega|Fly|Ride"] = 1151.24}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 5.25, ["Neon|Ride"] = 55.62, ["Neon|Fly|Ride"] = 122.57, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.59, ["Fly"] = 97.25, ["Ride"] = 34.13, ["Fly|Ride"] = 79.77, ["Neon"] = 72.19, ["Neon|Ride"] = 122.72, ["Neon|Fly|Ride"] = 247.19, ["Mega"] = 385.91, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.82, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 147, ["Neon"] = 247.8, ["Neon|Ride"] = 309.08, ["Neon|Fly|Ride"] = 311.07, ["Mega|Ride"] = 3434.12, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.69, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 14.77, ["Neon|Fly|Ride"] = 33.23, ["Mega"] = 15.62, ["Mega|Fly"] = 115.75, ["Mega|Ride"] = 32.58, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 44, ["Fly|Ride"] = 129.78, ["Neon"] = 14.23, ["Neon|Ride"] = 59.75, ["Neon|Fly|Ride"] = 411.96, ["Mega"] = 129.94, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.97, ["Ride"] = 64.91, ["Fly|Ride"] = 108.83, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 586.69, ["Mega|Ride"] = 546.96, ["Mega|Fly|Ride"] = 618.03}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 24.73, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 15.46, ["Mega|Ride"] = 76.39, ["Mega|Fly|Ride"] = 210.08}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 9.28, ["Fly"] = 176.59, ["Ride"] = 57.89, ["Fly|Ride"] = 99.75, ["Neon"] = 92.63, ["Neon|Ride"] = 109.18, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 555.63, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.14, ["Fly"] = 101.6, ["Ride"] = 26.5, ["Fly|Ride"] = 45.94, ["Neon"] = 408.98, ["Neon|Ride"] = 118.79, ["Neon|Fly|Ride"] = 179.43, ["Mega|Fly|Ride"] = 432.87}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.46, ["Ride"] = 52.5, ["Neon"] = 38.87, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 69.02, ["Mega"] = 223.12, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 386.56}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.21, ["Fly"] = 2059.72, ["Ride"] = 85.12, ["Fly|Ride"] = 196.83, ["Neon"] = 58.47, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6173.09, ["Mega"] = 324.13, ["Mega|Ride"] = 505.32, ["Mega|Fly|Ride"] = 293.97}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.21, ["Ride"] = 18.56, ["Fly|Ride"] = 196.88, ["Neon"] = 7.8, ["Neon|Fly"] = 55.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 103, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 152.32, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.42, ["Neon"] = 3.81, ["Neon|Ride"] = 41.21, ["Mega"] = 31.5, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 267.74}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.61}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 42.71, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 193.64, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1227.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 23.51, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 308.94}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 562.32, ["Ride"] = 513.91, ["Fly|Ride"] = 641.82, ["Neon"] = 3036.01, ["Neon|Ride"] = 1881.55, ["Neon|Fly|Ride"] = 2059.72, ["Mega"] = 16475.52, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.25, ["Fly"] = 25.81, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.64, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 82.55, ["Mega|Fly"] = 154.47, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.37, ["Fly"] = 95.55, ["Ride"] = 20.85, ["Fly|Ride"] = 65.54, ["Neon"] = 18.21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 161.44, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.7, ["Fly"] = 77.25, ["Ride"] = 64.91, ["Fly|Ride"] = 106.32, ["Neon"] = 89.25, ["Neon|Ride"] = 172.01, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 782.6, ["Mega|Ride"] = 547.83, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.66, ["Fly"] = 316.18, ["Ride"] = 32.48, ["Fly|Ride"] = 686.93, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.5, ["Fly"] = 139.53, ["Ride"] = 138.02, ["Fly|Ride"] = 157.5, ["Neon"] = 109.87, ["Neon|Ride"] = 205.98, ["Neon|Fly|Ride"] = 369.73, ["Mega"] = 347.27, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.14, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 33.01, ["Neon|Ride"] = 155.12, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 216.57, ["Mega|Fly"] = 549.88, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 364.54}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.12, ["Fly|Ride"] = 66.85, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.47, ["Neon|Fly|Ride"] = 129.74, ["Mega"] = 14.34, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 107}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.37, ["Fly"] = 275.84, ["Ride"] = 18.56, ["Fly|Ride"] = 48.42, ["Neon"] = 28.65, ["Neon|Fly"] = 115.78, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 82.41, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 313.69, ["Fly"] = 405.18, ["Ride"] = 317.34, ["Fly|Ride"] = 421.32, ["Neon"] = 1450.03, ["Neon|Ride"] = 1373.84, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Ride"] = 4324.84, ["Mega|Fly|Ride"] = 4377.35}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 88.36, ["Ride"] = 136.61, ["Fly|Ride"] = 294.05, ["Neon"] = 315, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 543.55, ["Mega"] = 4119.41, ["Mega|Ride"] = 1318.06, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 28.51, ["Neon"] = 55.62, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 32.97, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 152.43, ["Mega|Fly"] = 204.93, ["Mega|Ride"] = 155.1, ["Mega|Fly|Ride"] = 207.9}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.45, ["Ride"] = 15.14, ["Fly|Ride"] = 27.82, ["Neon"] = 6.48, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 25.52, ["Neon|Fly|Ride"] = 53.2, ["Mega"] = 68.25, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 107.1, ["Mega|Fly|Ride"] = 171.42}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.08, ["Fly"] = 96.83, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.29, ["Mega"] = 138.01, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 276.87, ["Fly"] = 420, ["Ride"] = 245.22, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 961.89, ["Neon|Fly|Ride"] = 1428.41, ["Mega|Ride"] = 8237.77, ["Mega|Fly|Ride"] = 3434.12}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.36, ["Fly|Ride"] = 43.28, ["Neon"] = 19.69, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 77.57, ["Mega"] = 196.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 427.34}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.45, ["Fly"] = 155.14, ["Ride"] = 82.3, ["Fly|Ride"] = 205.98, ["Neon"] = 45.32, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 273.96, ["Mega"] = 253.32, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 324.84}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 4.98, ["Neon|Ride"] = 155.71, ["Mega"] = 62.79, ["Mega|Ride"] = 200.82}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 6.08, ["Ride"] = 26.56, ["Fly|Ride"] = 65.63, ["Neon"] = 79.38, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 172.01, ["Mega"] = 728.44, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 616.65}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 48.75, ["Fly"] = 155.14, ["Ride"] = 89.25, ["Fly|Ride"] = 209.99, ["Neon"] = 103.85, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 427.41, ["Mega"] = 449.18, ["Mega|Fly"] = 2162.43, ["Mega|Ride"] = 514.87, ["Mega|Fly|Ride"] = 704.49}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.72, ["Ride"] = 57.69, ["Fly|Ride"] = 112.88, ["Neon"] = 262.5, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 201.39, ["Mega"] = 823.79, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 14.9, ["Fly|Ride"] = 32.97, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 60.77, ["Mega"] = 20.1, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 68.92, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 196.87, ["Ride"] = 307.02, ["Fly|Ride"] = 275.63, ["Neon"] = 3241.27, ["Neon|Fly|Ride"] = 1321.69}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.85, ["Fly"] = 101.18, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon"] = 91.77, ["Neon|Ride"] = 155.52, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 513.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 694.42}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.6, ["Fly|Ride"] = 44, ["Neon"] = 5.91, ["Neon|Fly"] = 33.57, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 107.12, ["Mega"] = 60.77, ["Mega|Fly"] = 274.95, ["Mega|Ride"] = 54.69, ["Mega|Fly|Ride"] = 138.9}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.91, ["Ride"] = 19.51, ["Fly|Ride"] = 36.78, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 110.15, ["Mega"] = 26.97, ["Mega|Fly"] = 138.01, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 154.47}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 9.37, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 6866.01, ["Mega"] = 129.84, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.17, ["Fly"] = 38.74, ["Ride"] = 24.32, ["Fly|Ride"] = 70.5, ["Neon"] = 53.82, ["Neon|Fly"] = 261.6, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 343.71, ["Mega|Ride"] = 318.34, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.87, ["Ride"] = 55.08, ["Fly|Ride"] = 72.19, ["Neon"] = 59.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 233.76, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 274.98, ["Neon"] = 2.1, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 19.69, ["Mega|Ride"] = 69.45, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.23, ["Fly"] = 96.83, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 26.25, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 67.65, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 185.59, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 300.69}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 117.78, ["Neon"] = 3.94, ["Neon|Fly"] = 110.2, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.29, ["Mega"] = 25.85, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 15.89, ["Fly|Ride"] = 66.87, ["Neon"] = 4.49, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 48.57, ["Mega|Ride"] = 82.3, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 714.62, ["Ride"] = 695.62, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.44, ["Mega|Fly|Ride"] = 13028.03}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.46, ["Fly|Ride"] = 29.3, ["Neon"] = 10.5, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 42.76, ["Mega"] = 184.36, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.29, ["Ride"] = 44.28, ["Fly|Ride"] = 81.37, ["Neon"] = 25.1, ["Neon|Fly"] = 617.92, ["Neon|Ride"] = 87.74, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 65.62, ["Mega|Fly"] = 315, ["Mega|Ride"] = 88.39, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.44, ["Fly"] = 47.35, ["Ride"] = 20.82, ["Fly|Ride"] = 57.64, ["Neon"] = 52.42, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 127.29, ["Mega"] = 549.88, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 372.61}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.48, ["Fly|Ride"] = 33.63, ["Neon"] = 9.1, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 60.51, ["Mega"] = 65.62, ["Mega|Ride"] = 99.62, ["Mega|Fly|Ride"] = 155.33}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.24, ["Ride"] = 83.99, ["Fly|Ride"] = 273.96, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 905.62}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 138.02, ["Ride"] = 18.38, ["Fly|Ride"] = 63.74, ["Neon"] = 5.2, ["Neon|Fly"] = 131.98, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 63.59, ["Mega|Ride"] = 114.74, ["Mega|Fly|Ride"] = 270.83}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 22.97, ["Fly|Ride"] = 60.77, ["Neon"] = 15.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 14.96, ["Mega"] = 93.5, ["Mega|Ride"] = 171.3, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.54, ["Fly|Ride"] = 49.83, ["Neon"] = 5.18, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 41.91, ["Mega|Fly"] = 253.33, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 155.1}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.16, ["Fly"] = 17.75, ["Ride"] = 18.51, ["Fly|Ride"] = 43.12, ["Neon"] = 309.03, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 823.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 800.63, ["Ride"] = 866.24, ["Fly|Ride"] = 826.88, ["Neon"] = 1837.5, ["Neon|Ride"] = 1798.13, ["Neon|Fly|Ride"] = 1952.99, ["Mega"] = 8238.8, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.49, ["Fly|Ride"] = 32.42, ["Neon"] = 3.57, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 61.81, ["Mega"] = 55.58, ["Mega|Ride"] = 75.52, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.6, ["Ride"] = 47.39, ["Fly|Ride"] = 115.78, ["Neon"] = 48.42, ["Neon|Fly"] = 152.43, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 273.96, ["Mega"] = 311.85, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 473.69}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.49, ["Ride"] = 71.65, ["Fly|Ride"] = 113.28, ["Neon"] = 295.32, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 531.42, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1263.48}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 22.4, ["Ride"] = 39.38, ["Fly|Ride"] = 138.02, ["Neon"] = 105, ["Neon|Ride"] = 177.15, ["Mega"] = 764.07, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.17, ["Ride"] = 26.23, ["Fly|Ride"] = 123.59, ["Neon"] = 52.5, ["Neon|Ride"] = 111.18, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 398.57, ["Mega|Ride"] = 462.95, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.9, ["Ride"] = 76.22, ["Neon"] = 107.62, ["Neon|Ride"] = 135.95, ["Mega"] = 247.19, ["Mega|Fly"] = 502.29, ["Mega|Ride"] = 332.61, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Fly"] = 126.89, ["Ride"] = 88.58, ["Neon"] = 274.36, ["Neon|Ride"] = 307, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 924, ["Mega|Ride"] = 632.27, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.48}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.94, ["Fly"] = 131248.69, ["Ride"] = 26.79, ["Fly|Ride"] = 78.75, ["Neon"] = 37.97, ["Neon|Ride"] = 72.93, ["Neon|Fly|Ride"] = 220.4, ["Mega"] = 204.75, ["Mega|Fly"] = 459.23, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 379.62}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 18.56, ["Mega"] = 864.69}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 40.3, ["Fly"] = 411.79, ["Ride"] = 72.11, ["Fly|Ride"] = 94.5, ["Neon"] = 271.69, ["Neon|Ride"] = 241, ["Neon|Fly|Ride"] = 246.15, ["Mega|Ride"] = 895.79, ["Mega|Fly|Ride"] = 921.61}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.16, ["Fly|Ride"] = 39.37, ["Neon"] = 30.19, ["Neon|Fly"] = 88.58, ["Neon|Ride"] = 35.13, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 274.98, ["Mega|Ride"] = 188.35, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.94, ["Fly"] = 82.41, ["Ride"] = 27.79, ["Fly|Ride"] = 105, ["Neon"] = 27.28, ["Neon|Ride"] = 53.78, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 127.34, ["Mega|Ride"] = 177.17, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 45.94, ["Mega"] = 45.22, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.29, ["Fly"] = 61.76, ["Ride"] = 68.81, ["Fly|Ride"] = 120.75, ["Neon"] = 152.43, ["Neon|Ride"] = 148.05, ["Neon|Fly|Ride"] = 386.63, ["Mega"] = 1098.86, ["Mega|Ride"] = 782.6, ["Mega|Fly|Ride"] = 771.95}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.28, ["Fly|Ride"] = 65.54, ["Neon"] = 4.81, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66, ["Mega"] = 74.82, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 14.77, ["Ride"] = 60.8, ["Fly|Ride"] = 271.89, ["Neon"] = 82.41, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 368.69, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 645.65}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 13.26, ["Fly|Ride"] = 37.52, ["Neon"] = 18.5, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 61.73, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.35, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 65.63, ["Neon"] = 77.58, ["Neon|Ride"] = 410.93, ["Mega"] = 377.97, ["Mega|Ride"] = 389.25, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 60.52, ["Fly|Ride"] = 131.25, ["Neon"] = 51.76, ["Neon|Ride"] = 155.12, ["Mega"] = 379.65, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.07, ["Ride"] = 125.5, ["Neon"] = 201.44, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 436.67, ["Mega"] = 1647.78, ["Mega|Ride"] = 1634.18, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.26, ["Ride"] = 119.01, ["Neon"] = 107.63, ["Neon|Ride"] = 411.96, ["Mega"] = 411.96, ["Mega|Ride"] = 427.34, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.45, ["Ride"] = 105, ["Neon"] = 77.17, ["Neon|Ride"] = 105, ["Mega"] = 975.29, ["Mega|Ride"] = 975.16, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.94, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 174.81, ["Neon|Ride"] = 617.92, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 823.9, ["Mega|Ride"] = 879.27, ["Mega|Fly|Ride"] = 1441.62}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 105, ["Neon|Ride"] = 274.98, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 309.02}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 14.65, ["Fly|Ride"] = 58.71, ["Neon"] = 5.13, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 36.06, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 88.58, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 319.6}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.97, ["Fly"] = 50.19, ["Ride"] = 55.61, ["Fly|Ride"] = 77.89, ["Neon"] = 14.7, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 115.88, ["Mega"] = 108.93, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 24, ["Fly|Ride"] = 55.95, ["Neon"] = 7.76, ["Neon|Fly"] = 31.27, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.16, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 190.64}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.8, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 69.02, ["Neon"] = 17.37, ["Neon|Ride"] = 97.85, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 250.59, ["Mega|Ride"] = 180.05, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.5, ["Fly"] = 65.63, ["Ride"] = 22.31, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 463.03, ["Neon|Ride"] = 82.41, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1208.91}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.63, ["Fly|Ride"] = 39.38, ["Neon"] = 19.18, ["Neon|Fly"] = 102.74, ["Neon|Ride"] = 32.11, ["Neon|Fly|Ride"] = 87.29, ["Mega"] = 157.2, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 18.35, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.41, ["Neon|Ride"] = 54.12, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 205.98, ["Mega|Ride"] = 227.59}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 12.29, ["Fly"] = 63, ["Ride"] = 42.95, ["Neon"] = 15.84, ["Neon|Fly"] = 123.36, ["Neon|Ride"] = 130.1, ["Neon|Fly|Ride"] = 192.6, ["Mega"] = 105, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 312.01}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.31, ["Fly"] = 205.98, ["Ride"] = 112.25, ["Fly|Ride"] = 242.82, ["Neon"] = 119.48, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 413.12, ["Mega"] = 484.32, ["Mega|Fly"] = 686.83, ["Mega|Ride"] = 523.65, ["Mega|Fly|Ride"] = 722.96}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 46.88, ["Ride"] = 110.2, ["Fly|Ride"] = 211.32, ["Neon"] = 288.81, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 472.28, ["Mega"] = 1220.63, ["Mega|Ride"] = 1085.34, ["Mega|Fly|Ride"] = 1144.55}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.56, ["Fly|Ride"] = 53.57, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Mega"] = 20.61, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.63, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.06, ["Fly"] = 105, ["Ride"] = 78.75, ["Neon"] = 304.5, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 411.96, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.36, ["Fly"] = 190.32, ["Ride"] = 31.29, ["Fly|Ride"] = 126, ["Neon"] = 46.32, ["Neon|Ride"] = 89.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 155.12, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 96.83, ["Fly|Ride"] = 137.7, ["Neon"] = 7.77, ["Neon|Ride"] = 40.69, ["Mega"] = 61.74, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 97.22, ["Mega|Fly|Ride"] = 274.87}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 686.93, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 10.49, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 112.68, ["Mega"] = 164.07, ["Mega|Fly"] = 343.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 316.15}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.64, ["Ride"] = 15.49, ["Fly|Ride"] = 32.7, ["Neon"] = 2.63, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 69.46, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.28, ["Fly|Ride"] = 78.12, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 103, ["Mega"] = 46.77, ["Mega|Fly"] = 168, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Fly|Ride"] = 155.14, ["Neon"] = 2.52, ["Neon|Ride"] = 145.07, ["Mega"] = 22.82, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.96, ["Ride"] = 44.3, ["Neon"] = 30.19, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 617.92, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 183.47}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 15.12, ["Ride"] = 21, ["Fly|Ride"] = 189.87, ["Neon"] = 52.85, ["Neon|Ride"] = 103, ["Neon|Fly|Ride"] = 181.27, ["Mega"] = 280.13, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.25, ["Fly"] = 22.14, ["Ride"] = 18.51, ["Fly|Ride"] = 45.33, ["Neon"] = 32.38, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 91.83, ["Mega|Ride"] = 346.34, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 58.96, ["Ride"] = 262.63, ["Fly|Ride"] = 262.5, ["Neon"] = 196.88, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1775.37}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.17, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 138.02, ["Neon"] = 261.6, ["Neon|Fly|Ride"] = 630, ["Mega"] = 877.27, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.26, ["Ride"] = 16.37, ["Fly|Ride"] = 41.21, ["Neon"] = 3.94, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 53.57, ["Mega"] = 32.48, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.58, ["Fly|Ride"] = 31.55, ["Neon"] = 5.23, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 44.63, ["Mega|Fly"] = 82.4, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 101.26}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 599.65, ["Ride"] = 534.18, ["Fly|Ride"] = 549.95, ["Neon|Fly|Ride"] = 1778.56}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.25, ["Ride"] = 90.2, ["Neon"] = 30.19, ["Neon|Ride"] = 117.42, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Ride"] = 398.52, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 15.27, ["Fly|Ride"] = 31.27, ["Neon"] = 2.1, ["Neon|Fly"] = 26.7, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 55.55, ["Mega"] = 39.38, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.27}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 60.44, ["Ride"] = 109.12, ["Fly|Ride"] = 328.13, ["Neon"] = 255.29, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 509.32, ["Mega"] = 907.31, ["Mega|Ride"] = 917.44}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.73, ["Ride"] = 19.59, ["Fly|Ride"] = 45.92, ["Neon"] = 12.92, ["Neon|Fly"] = 43.95, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 85.22, ["Mega|Fly"] = 247.15, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 197.38}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 42.94, ["Fly|Ride"] = 1312.5, ["Neon"] = 5.13, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.83, ["Mega|Ride"] = 53.25, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 48.37, ["Fly"] = 167.06, ["Ride"] = 101.97, ["Fly|Ride"] = 111.57, ["Neon"] = 169.31, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 787.5, ["Mega|Ride"] = 623.7, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 13.92, ["Neon"] = 6.07, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 63, ["Mega"] = 40.85, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 30.5, ["Ride"] = 96.8, ["Fly|Ride"] = 138.02, ["Neon"] = 324.41, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1626.97, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 55.62, ["Fly|Ride"] = 156.55, ["Neon"] = 21.79, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.61, ["Fly"] = 23.63, ["Ride"] = 26.25, ["Fly|Ride"] = 65.92, ["Neon"] = 9.28, ["Neon|Ride"] = 51.51, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.53, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.8, ["Ride"] = 98.83, ["Fly|Ride"] = 514.94, ["Neon"] = 326.82, ["Neon|Ride"] = 700.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2057.4, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1345.86}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.23, ["Ride"] = 31.94, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Ride"] = 37.09, ["Neon|Fly|Ride"] = 151.65, ["Mega"] = 41.99, ["Mega|Fly"] = 252.14, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 218.31}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 17.37, ["Fly|Ride"] = 102.88, ["Neon"] = 11.82, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 115.78, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.88, ["Fly"] = 48.42, ["Ride"] = 28.67, ["Fly|Ride"] = 77.58, ["Neon"] = 77.49, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 131.83, ["Mega"] = 430.5, ["Mega|Ride"] = 467.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 14.44, ["Ride"] = 20.61, ["Fly|Ride"] = 138.02, ["Neon"] = 91.75, ["Neon|Ride"] = 80.21, ["Neon|Fly|Ride"] = 130.8, ["Mega"] = 865.09, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.7, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 64.91, ["Neon"] = 80.34, ["Neon|Ride"] = 86.52, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 542.55, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 348.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 61.46, ["Ride"] = 114.39, ["Fly|Ride"] = 220.64, ["Neon"] = 299.24, ["Neon|Ride"] = 501.56, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 1389.05, ["Mega|Ride"] = 1485.9, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.76, ["Ride"] = 46.45, ["Fly|Ride"] = 308.98, ["Neon"] = 13.13, ["Neon|Ride"] = 106.09, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 213.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.25, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 55.77, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 185.07, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.71, ["Fly"] = 52.5, ["Ride"] = 40.19, ["Fly|Ride"] = 138.02, ["Neon"] = 52.16, ["Neon|Ride"] = 392.43, ["Mega"] = 329.57, ["Mega|Ride"] = 316.15, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.69, ["Fly|Ride"] = 19.68, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.46, ["Neon|Fly|Ride"] = 53.57, ["Mega"] = 14.44, ["Mega|Ride"] = 22.67, ["Mega|Fly|Ride"] = 86.54}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 55.6, ["Fly"] = 218.34, ["Ride"] = 96.8, ["Fly|Ride"] = 296.36, ["Neon"] = 205.98, ["Neon|Fly"] = 2334.68, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1081.15, ["Mega|Ride"] = 1497.2, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.85, ["Fly|Ride"] = 112.22, ["Neon"] = 5.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 51.27, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 15.75, ["Fly|Ride"] = 45.93, ["Neon"] = 18.56, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 94.77, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 82.3, ["Ride"] = 170.63, ["Fly|Ride"] = 223.13, ["Neon"] = 334.69, ["Neon|Ride"] = 385.91, ["Neon|Fly|Ride"] = 684.17, ["Mega"] = 1260, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 7.79, ["Neon|Ride"] = 36.06, ["Mega"] = 65.44, ["Mega|Ride"] = 104.71, ["Mega|Fly|Ride"] = 232.73}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 28.86}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 35.44, ["Fly|Ride"] = 57.72, ["Neon"] = 7.91, ["Neon|Ride"] = 46.04, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 43.28, ["Mega|Ride"] = 131.96, ["Mega|Fly|Ride"] = 201.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 110.15, ["Ride"] = 204.95, ["Fly|Ride"] = 262.5, ["Neon"] = 645.73, ["Neon|Ride"] = 674.57, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3550.13, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 40.85, ["Neon"] = 14.44, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 155.12, ["Mega"] = 160.02, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.71, ["Neon"] = 4.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 130.52}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.24, ["Ride"] = 26.51, ["Neon"] = 38.98, ["Neon|Ride"] = 110.2, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 258.47, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.12, ["Fly"] = 25.47, ["Ride"] = 20.86, ["Fly|Ride"] = 54.42, ["Neon"] = 85.85, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 185.21, ["Mega"] = 597.19, ["Mega|Ride"] = 427.34, ["Mega|Fly|Ride"] = 480.89}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.05, ["Ride"] = 82.3, ["Fly|Ride"] = 106.09, ["Neon"] = 150.8, ["Neon|Ride"] = 158.97, ["Neon|Fly|Ride"] = 319.49, ["Mega|Ride"] = 604.46, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.38, ["Fly"] = 183.74, ["Ride"] = 152.43, ["Fly|Ride"] = 229.69, ["Neon"] = 590.85, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 617.92, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.58, ["Fly"] = 43.16, ["Ride"] = 27.71, ["Fly|Ride"] = 65.4, ["Neon"] = 138.02, ["Neon|Fly"] = 204.95, ["Neon|Ride"] = 118.01, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 18.58, ["Fly|Ride"] = 90.64, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 135.19, ["Mega|Ride"] = 203.89, ["Mega|Fly|Ride"] = 247.1}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.63, ["Fly"] = 231.54, ["Ride"] = 27.57, ["Fly|Ride"] = 117.42, ["Neon"] = 63.68, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 131.25, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 143.16, ["Ride"] = 68.17, ["Fly|Ride"] = 179.22, ["Neon"] = 227.61, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 380.52, ["Mega"] = 985.13, ["Mega|Ride"] = 1081.22, ["Mega|Fly|Ride"] = 1091.98}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.9, ["Ride"] = 121.31, ["Neon"] = 138.02, ["Neon|Ride"] = 241, ["Neon|Fly|Ride"] = 454.17, ["Mega"] = 682.5, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 822.76}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 411.96, ["Neon|Ride"] = 3087.13, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 27.81, ["Ride"] = 55.62, ["Fly|Ride"] = 74.82, ["Neon"] = 224.26, ["Neon|Ride"] = 220.4, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 1034.25, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 880.42}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.06, ["Ride"] = 15.46, ["Fly|Ride"] = 102.55, ["Neon"] = 2.1, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 64.34, ["Mega"] = 18.03, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 122.47, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 14.62, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 216.44, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly|Ride"] = 144.17, ["Neon"] = 22.77, ["Neon|Ride"] = 81.37, ["Neon|Fly|Ride"] = 961.89, ["Mega"] = 125.13, ["Mega|Fly"] = 535.47, ["Mega|Ride"] = 259.5, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.88, ["Ride"] = 458.07, ["Fly|Ride"] = 514.94, ["Neon"] = 1389.11, ["Neon|Ride"] = 1222.45, ["Neon|Fly|Ride"] = 1385.18, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 58.76, ["Ride"] = 16.75, ["Fly|Ride"] = 52.5, ["Neon"] = 22.3, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 82.41, ["Mega"] = 168, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.79, ["Fly"] = 17.28, ["Ride"] = 17.07, ["Fly|Ride"] = 43.28, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 411.96, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.13, ["Fly"] = 32.61, ["Ride"] = 27.56, ["Neon"] = 13.12, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 103, ["Mega"] = 78.75, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.95, ["Fly"] = 45.93, ["Ride"] = 40.2, ["Fly|Ride"] = 96.83, ["Neon"] = 138.02, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 822.76, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 26.99, ["Fly|Ride"] = 49.8, ["Neon"] = 21, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 160.47, ["Mega|Ride"] = 440.73, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.51, ["Fly"] = 64.26, ["Ride"] = 23.63, ["Fly|Ride"] = 85.63, ["Neon"] = 138.02, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 274.98, ["Mega|Ride"] = 741.41, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 4.55, ["Neon|Ride"] = 20.61, ["Mega"] = 50.3, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 233.76}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 54.1, ["Ride"] = 138.02, ["Neon"] = 90.64, ["Mega"] = 315, ["Mega|Ride"] = 341.25}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 19.69, ["Ride"] = 39.38, ["Neon"] = 69.47, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 411.96, ["Mega"] = 316.32, ["Mega|Ride"] = 272.98, ["Mega|Fly|Ride"] = 618.03}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.89, ["Fly"] = 617.92, ["Ride"] = 21.68, ["Fly|Ride"] = 69.46, ["Neon"] = 51.06, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 134.9, ["Mega"] = 578.71, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 410.95, ["Ride"] = 301.88, ["Fly|Ride"] = 393.74, ["Neon"] = 1468.59, ["Neon|Ride"] = 1229.82, ["Neon|Fly|Ride"] = 1289.39, ["Mega|Fly|Ride"] = 5080.65}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.45, ["Fly|Ride"] = 56.8, ["Neon"] = 10.4, ["Neon|Fly"] = 77.57, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 220.4, ["Mega|Ride"] = 155.1, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.89, ["Fly"] = 27.71, ["Ride"] = 27.81, ["Fly|Ride"] = 80.34, ["Neon"] = 37.7, ["Neon|Ride"] = 131.98, ["Neon|Fly|Ride"] = 261.6, ["Mega"] = 278.11, ["Mega|Ride"] = 271.87}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 27.81, ["Ride"] = 274.98, ["Fly|Ride"] = 201.44, ["Neon"] = 115.5, ["Neon|Ride"] = 205.98, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 363.46, ["Mega|Fly|Ride"] = 521.73}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 118.01, ["Ride"] = 163.63, ["Fly|Ride"] = 443.57, ["Neon"] = 1098.86, ["Neon|Ride"] = 1466.16, ["Neon|Fly|Ride"] = 1168.12, ["Mega"] = 2315.07, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2815.28}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 22.91, ["Fly"] = 102.38, ["Ride"] = 52.5, ["Fly|Ride"] = 185.38, ["Neon"] = 90.3, ["Neon|Ride"] = 118.46, ["Neon|Fly|Ride"] = 199.02, ["Mega"] = 242.71, ["Mega|Ride"] = 275.52, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.7, ["Fly|Ride"] = 51.79, ["Neon"] = 10.39, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 52.5, ["Mega|Ride"] = 193.3, ["Mega|Fly|Ride"] = 155.1}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 9.95, ["Ride"] = 38.09, ["Fly|Ride"] = 81.37, ["Neon"] = 55.06, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 135.94}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 61.6, ["Fly"] = 196.88, ["Ride"] = 89.58, ["Fly|Ride"] = 216.57, ["Neon"] = 160.55, ["Neon|Ride"] = 196.55, ["Neon|Fly|Ride"] = 343.52, ["Mega"] = 408.19, ["Mega|Ride"] = 525.17, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.41, ["Ride"] = 69.46, ["Neon"] = 7.69, ["Neon|Ride"] = 205.98, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 67.78, ["Mega|Ride"] = 167.93, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.34, ["Fly|Ride"] = 273.96, ["Neon"] = 111.91, ["Neon|Ride"] = 401.03, ["Mega"] = 523.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 814.53}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 971.25, ["Fly"] = 1254.84, ["Ride"] = 1089.22, ["Fly|Ride"] = 1187.82, ["Neon|Ride"] = 3434.57, ["Neon|Fly|Ride"] = 2743.13, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.08, ["Fly"] = 115.68, ["Ride"] = 120.4, ["Fly|Ride"] = 191.63, ["Neon"] = 157.5, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 192.6, ["Mega"] = 411.96, ["Mega|Ride"] = 578.68, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 20.61, ["Fly|Ride"] = 41.21, ["Neon"] = 14.6, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 118.46, ["Mega"] = 78.66, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 178.28}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 6.56, ["Ride"] = 47.25, ["Fly|Ride"] = 138.02, ["Neon"] = 201.44, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 220.4, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 17.91, ["Fly|Ride"] = 59.49, ["Neon"] = 2.1, ["Neon|Ride"] = 21.92, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 23.17, ["Mega|Fly"] = 123.59, ["Mega|Ride"] = 49.82, ["Mega|Fly|Ride"] = 155.1}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 67.73, ["Ride"] = 105.34, ["Fly|Ride"] = 236.25, ["Neon"] = 309.09, ["Neon|Ride"] = 366.98, ["Mega"] = 1040.94, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.26, ["Ride"] = 23.63, ["Fly|Ride"] = 101.07, ["Neon"] = 45.85, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 108.82, ["Mega"] = 398.57, ["Mega|Ride"] = 471.62, ["Mega|Fly|Ride"] = 546.8}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Fly|Ride"] = 46.32, ["Neon"] = 8.99, ["Neon|Ride"] = 47.22, ["Mega"] = 99.75, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 82.66, ["Ride"] = 192.6, ["Fly|Ride"] = 196.88, ["Neon"] = 262.49, ["Neon|Fly|Ride"] = 278.08, ["Mega"] = 684.36, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 771.95}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 7.88, ["Ride"] = 52.48, ["Fly|Ride"] = 86.41, ["Neon"] = 50.04, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 315, ["Mega"] = 577.62, ["Mega|Ride"] = 502.52, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 38.64, ["Ride"] = 84, ["Neon"] = 386.65, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 943.69, ["Mega"] = 1867.7, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 2059.45}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.03, ["Neon"] = 23.73, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 108.83, ["Mega|Ride"] = 128.1, ["Mega|Fly|Ride"] = 287.34}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.67, ["Ride"] = 22.32, ["Fly|Ride"] = 78.74, ["Neon"] = 45.48, ["Neon|Ride"] = 65.76, ["Neon|Fly|Ride"] = 158.62, ["Mega"] = 399, ["Mega|Ride"] = 373.19, ["Mega|Fly|Ride"] = 427.34}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 103.69, ["Fly"] = 514.94, ["Ride"] = 157.04, ["Fly|Ride"] = 266.7, ["Neon"] = 540.98, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 617.92, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 16.7, ["Fly|Ride"] = 41.15, ["Neon"] = 11.46, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 124.59, ["Mega|Fly"] = 123.85, ["Mega|Ride"] = 155.1, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.56, ["Fly"] = 92.89, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 73.5, ["Neon|Fly"] = 231.52, ["Neon|Ride"] = 92.63, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 384.64, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 12.38, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 14.84, ["Mega|Fly"] = 48.62, ["Mega|Ride"] = 28.6, ["Mega|Fly|Ride"] = 84}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 131.14, ["Fly|Ride"] = 131.25, ["Neon"] = 3.54, ["Neon|Ride"] = 39.15, ["Mega"] = 22.15, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 60.52, ["Mega|Fly|Ride"] = 110.19}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.02, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 138.02, ["Mega|Fly|Ride"] = 240.85}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.12, ["Ride"] = 52.47, ["Neon"] = 117.74, ["Neon|Ride"] = 411.96, ["Neon|Fly|Ride"] = 630, ["Mega"] = 418.4, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 666.25}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 16.49, ["Fly|Ride"] = 30.71, ["Neon"] = 13.76, ["Neon|Fly"] = 32.96, ["Neon|Ride"] = 25.85, ["Neon|Fly|Ride"] = 58.32, ["Mega"] = 110.2, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 184.95}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.94, ["Fly"] = 37.32, ["Ride"] = 24.29, ["Fly|Ride"] = 55.13, ["Neon"] = 24.83, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.05, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 182.44, ["Mega|Fly"] = 411.9, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.94, ["Fly"] = 19.15, ["Ride"] = 18.09, ["Fly|Ride"] = 77.93, ["Neon"] = 11.46, ["Neon|Fly"] = 85.68, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 55.13, ["Mega|Fly"] = 123.59, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.16, ["Fly"] = 36.06, ["Ride"] = 32.95, ["Fly|Ride"] = 77.44, ["Neon"] = 35.44, ["Neon|Ride"] = 81, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 220.4, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.94, ["Ride"] = 122.72, ["Fly|Ride"] = 219.96, ["Neon"] = 123.98, ["Neon|Ride"] = 262.39, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 41.88, ["Ride"] = 26.78, ["Fly|Ride"] = 69, ["Neon"] = 24.31, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 329.57, ["Mega|Ride"] = 231.49, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.74, ["Fly|Ride"] = 34.94, ["Neon"] = 11.65, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 30.91, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.15, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 389.82, ["Ride"] = 245.12, ["Fly|Ride"] = 392.43, ["Neon"] = 1126.67, ["Neon|Ride"] = 1354.32, ["Neon|Fly|Ride"] = 1091.65, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 7.88, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Neon|Ride"] = 55.62, ["Mega"] = 120.84, ["Mega|Ride"] = 411.9, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 6.04, ["Fly"] = 26.25, ["Ride"] = 21.63, ["Fly|Ride"] = 79.07, ["Neon"] = 20.26, ["Neon|Fly"] = 274.98, ["Neon|Ride"] = 53.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 201.1, ["Mega|Ride"] = 321.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.88, ["Ride"] = 35.02, ["Neon"] = 60.38, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 617.92, ["Mega"] = 461.77, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 12.37, ["Ride"] = 13.13, ["Fly|Ride"] = 36.06, ["Neon"] = 2.1, ["Neon|Fly"] = 28.66, ["Neon|Ride"] = 15.18, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.94, ["Fly|Ride"] = 61.04, ["Neon"] = 9.17, ["Neon|Fly"] = 31.27, ["Neon|Ride"] = 23.66, ["Neon|Fly|Ride"] = 95.78, ["Mega"] = 102.38, ["Mega|Ride"] = 143.59, ["Mega|Fly|Ride"] = 203.16}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.62, ["Ride"] = 69.02, ["Neon"] = 26.24, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.59, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 309.02}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.5, ["Fly"] = 123.6, ["Ride"] = 110.32, ["Fly|Ride"] = 158.81, ["Neon"] = 618.16, ["Neon|Ride"] = 461.39, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 2059.45, ["Mega|Ride"] = 3434.12, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 31.27, ["Fly|Ride"] = 262.48, ["Neon"] = 22.09, ["Neon|Ride"] = 103, ["Neon|Fly|Ride"] = 122.54, ["Mega"] = 211.54, ["Mega|Ride"] = 357.33, ["Mega|Fly|Ride"] = 406.75}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Neon"] = 15.75, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.41, ["Fly"] = 210, ["Ride"] = 90.96, ["Fly|Ride"] = 205.98, ["Neon"] = 131.15, ["Neon|Ride"] = 214.22, ["Neon|Fly|Ride"] = 309.07, ["Mega"] = 628.68, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 13.44, ["Fly|Ride"] = 29.28, ["Neon"] = 2.1, ["Neon|Fly"] = 18.56, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 17.06, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 44.29, ["Mega|Fly|Ride"] = 112.77}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 64.86, ["Neon|Fly|Ride"] = 123.87, ["Mega"] = 24.71, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 10.39, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 181.27, ["Mega"] = 58.54, ["Mega|Fly"] = 179.19, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 201.99}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.88, ["Fly"] = 68.25, ["Ride"] = 43.95, ["Fly|Ride"] = 130.8, ["Neon"] = 23.05, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 231.52, ["Mega"] = 104.63, ["Mega|Fly"] = 332.17, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 253.18}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 15.33, ["Fly|Ride"] = 31.92, ["Neon"] = 2.63, ["Neon|Ride"] = 24.15, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 25.48, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.99, ["Ride"] = 123.6, ["Neon"] = 101.7, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 961.89, ["Mega"] = 410.92, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 679.63}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2739.41, ["Ride"] = 2668.95, ["Fly|Ride"] = 2520, ["Neon"] = 10298.49, ["Neon|Fly|Ride"] = 9612.62, ["Mega|Fly|Ride"] = 34598.61}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.18, ["Ride"] = 15.36, ["Fly|Ride"] = 39.37, ["Neon"] = 11.75, ["Neon|Fly"] = 62.52, ["Neon|Ride"] = 24.73, ["Neon|Fly|Ride"] = 45.04, ["Mega"] = 81.38, ["Mega|Fly"] = 458.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 192.57}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 24.86, ["Fly"] = 110.2, ["Ride"] = 33.5, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Ride"] = 105.57, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 345.19, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 482.9}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 31.98, ["Ride"] = 66.94, ["Neon"] = 155.14, ["Neon|Ride"] = 205.98, ["Mega"] = 1235.83, ["Mega|Ride"] = 769.21, ["Mega|Fly|Ride"] = 810.14}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 170.51, ["Fly"] = 218.34, ["Ride"] = 197.87, ["Fly|Ride"] = 374.88, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 795.61, ["Mega"] = 6178.33, ["Mega|Fly|Ride"] = 3378.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.07, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.58, ["Neon|Ride"] = 135.64, ["Mega"] = 106.08, ["Mega|Ride"] = 164.77, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.62, ["Neon"] = 6.57, ["Neon|Ride"] = 274.98, ["Mega"] = 120.69, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 102, ["Ride"] = 40.53, ["Fly|Ride"] = 131.25, ["Neon"] = 10.41, ["Neon|Ride"] = 59.75, ["Mega"] = 78.75, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.39, ["Ride"] = 103, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.83, ["Mega|Ride"] = 612.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 2.1, ["Neon|Ride"] = 82.41, ["Mega"] = 17.07, ["Mega|Fly"] = 115.75, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 273.92}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Fly"] = 138.02, ["Ride"] = 110.2, ["Fly|Ride"] = 177.15, ["Neon"] = 411.96, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 453.76, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1734.07}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.29, ["Neon|Ride"] = 69.02, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 118.13, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.15, ["Fly"] = 205.98, ["Ride"] = 85.49, ["Fly|Ride"] = 157.48, ["Neon"] = 262.5, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 673.07, ["Mega"] = 2625, ["Mega|Ride"] = 1902.93, ["Mega|Fly|Ride"] = 1546.13}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.5, ["Fly|Ride"] = 50.81, ["Neon"] = 2.1, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 44.77, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 168.51}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Mega"] = 63.26, ["Mega|Ride"] = 509.73, ["Mega|Fly|Ride"] = 605.49}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.5, ["Ride"] = 37.41, ["Neon"] = 104.79, ["Neon|Ride"] = 94.77, ["Neon|Fly|Ride"] = 205.98, ["Mega"] = 231.48, ["Mega|Ride"] = 346.01, ["Mega|Fly|Ride"] = 771.95}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 422.63, ["Ride"] = 456.74, ["Fly|Ride"] = 556.5, ["Neon"] = 1050, ["Neon|Ride"] = 1456.22, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4193.44}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 39.29, ["Ride"] = 48.45, ["Fly|Ride"] = 129.78, ["Neon"] = 205.98, ["Neon|Ride"] = 248.36, ["Neon|Fly|Ride"] = 229.67, ["Mega|Ride"] = 1215.09, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 8.7, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 57.29, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.44, ["Fly"] = 92.63, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 53.29, ["Neon|Fly"] = 105, ["Neon|Ride"] = 98.88, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 257.25, ["Mega|Fly"] = 952.5, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 377.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.85, ["Ride"] = 20.68, ["Fly|Ride"] = 262.63, ["Neon"] = 138.02, ["Neon|Ride"] = 76.22, ["Neon|Fly|Ride"] = 309.07, ["Mega"] = 1098.86, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.83, ["Ride"] = 27.82, ["Neon"] = 20.69, ["Mega"] = 63, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 20.37, ["Fly|Ride"] = 55.62, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 123.6, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 111.56, ["Ride"] = 127.32, ["Fly|Ride"] = 223.13, ["Neon"] = 633.21, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 694.53, ["Mega|Fly|Ride"] = 2593.87}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.19, ["Ride"] = 103, ["Fly|Ride"] = 138.02, ["Neon"] = 192.94, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 274.96, ["Mega"] = 682.5, ["Mega|Ride"] = 762, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.02, ["Fly"] = 2349.38, ["Ride"] = 2152.5, ["Fly|Ride"] = 2257.5, ["Neon"] = 10985.4, ["Neon|Fly|Ride"] = 5848.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 75.22, ["Fly|Ride"] = 196.87, ["Neon"] = 9.08, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 105, ["Mega"] = 104.89, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 180.05, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.49, ["Ride"] = 53.44, ["Neon"] = 32.06, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.38, ["Mega|Ride"] = 300.74, ["Mega|Fly|Ride"] = 636.39}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1025.1, ["Fly"] = 1155.29, ["Ride"] = 1041.38, ["Fly|Ride"] = 969.94, ["Neon"] = 2778.57, ["Neon|Ride"] = 2933.3, ["Neon|Fly|Ride"] = 2782.5, ["Mega|Fly|Ride"] = 9843.75}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.8, ["Fly"] = 69.02, ["Ride"] = 55.62, ["Fly|Ride"] = 173.35, ["Neon"] = 182.27, ["Neon|Ride"] = 294.67, ["Mega"] = 796.85, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 850.56}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 103, ["Neon"] = 24.92, ["Neon|Ride"] = 41.21, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.97, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138.02, ["Neon"] = 3.94, ["Neon|Fly"] = 41.21, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 77.57, ["Mega"] = 35.04, ["Mega|Ride"] = 251.27, ["Mega|Fly|Ride"] = 247.15}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.91, ["Ride"] = 127.32, ["Fly|Ride"] = 205.98, ["Neon"] = 459.38, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 8238.8, ["Mega|Fly|Ride"] = 5311.01}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.25, ["Neon"] = 27.57, ["Neon|Ride"] = 123.6, ["Neon|Fly|Ride"] = 115.78, ["Mega"] = 145.16, ["Mega|Ride"] = 325.41, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.39, ["Ride"] = 136.49, ["Fly|Ride"] = 123.38, ["Neon"] = 380.63, ["Neon|Ride"] = 463.02, ["Neon|Fly|Ride"] = 411.96}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.14, ["Fly"] = 105, ["Fly|Ride"] = 110.2, ["Neon"] = 18.38, ["Neon|Ride"] = 77.57, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 138.02, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 192.57}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 288.75, ["Ride"] = 271.04, ["Fly|Ride"] = 365.1, ["Neon"] = 1424.53, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.83, ["Ride"] = 22.01, ["Fly|Ride"] = 55.62, ["Neon"] = 78.1, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 308.98, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 360.12}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.74, ["Fly|Ride"] = 35.99, ["Neon"] = 6.57, ["Neon|Fly"] = 27.82, ["Neon|Ride"] = 20.31, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 55.13, ["Mega|Fly"] = 110.87, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.92, ["Ride"] = 1050, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 7552.92, ["Neon|Fly|Ride"] = 5465.42, ["Mega"] = 26086.94}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.07, ["Fly"] = 961.89, ["Ride"] = 72.19, ["Neon"] = 42, ["Neon|Ride"] = 130.8, ["Mega"] = 249.38, ["Mega|Ride"] = 377.92, ["Mega|Fly|Ride"] = 480.89}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 46.09, ["Ride"] = 34.95, ["Fly|Ride"] = 96.8, ["Neon"] = 30.18, ["Neon|Fly"] = 123.87, ["Neon|Ride"] = 53.26, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 187.27, ["Mega|Fly"] = 227.59, ["Mega|Ride"] = 170.94, ["Mega|Fly|Ride"] = 265.55}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 33.36, ["Fly"] = 40.8, ["Ride"] = 46.11, ["Fly|Ride"] = 66.26, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 179.22, ["Mega"] = 2059.45, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 901.07}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.7, ["Fly"] = 59.07, ["Ride"] = 27.43, ["Fly|Ride"] = 89.25, ["Neon"] = 69.02, ["Neon|Ride"] = 76.22, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 25.89, ["Ride"] = 209.99, ["Fly|Ride"] = 401.66, ["Neon"] = 110.55, ["Neon|Ride"] = 541.75, ["Mega"] = 463.02, ["Mega|Ride"] = 574.6, ["Mega|Fly|Ride"] = 880.41}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 231.54, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 108.81, ["Neon|Fly|Ride"] = 309.07, ["Mega"] = 15.65, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.31, ["Fly"] = 103, ["Ride"] = 76.04, ["Fly|Ride"] = 131.25, ["Neon"] = 338.02, ["Neon|Fly"] = 382.02, ["Neon|Ride"] = 370.42, ["Neon|Fly|Ride"] = 398.89, ["Mega"] = 3295.13, ["Mega|Fly|Ride"] = 1202.32}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 26.25, ["Fly|Ride"] = 81.58, ["Neon"] = 32.81, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.48, ["Fly|Ride"] = 38.07, ["Neon"] = 14.85, ["Neon|Ride"] = 52.54, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 172.01, ["Neon"] = 20.14, ["Neon|Fly|Ride"] = 184.36, ["Mega"] = 274.95}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.08, ["Ride"] = 88.11, ["Fly|Ride"] = 262.5, ["Neon"] = 247.19, ["Neon|Ride"] = 247.19, ["Neon|Fly|Ride"] = 288.38, ["Mega"] = 1021.62, ["Mega|Ride"] = 1010.63, ["Mega|Fly|Ride"] = 1044.15}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.9, ["Fly|Ride"] = 411.96, ["Neon"] = 23.55, ["Neon|Ride"] = 77.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 98.22, ["Mega|Ride"] = 110.19, ["Mega|Fly|Ride"] = 308.93}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 20.61, ["Mega"] = 15.44, ["Mega|Ride"] = 55.6, ["Mega|Fly|Ride"] = 385.04}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.02, ["Ride"] = 25.49, ["Fly|Ride"] = 133.49, ["Neon"] = 2.46, ["Neon|Ride"] = 32.96, ["Mega"] = 23.69, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 23.35, ["Ride"] = 16.4, ["Fly|Ride"] = 38.66, ["Neon"] = 5.46, ["Neon|Fly"] = 123.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 76.22, ["Mega"] = 98.88, ["Mega|Ride"] = 58.97, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.23, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.72, ["Fly|Ride"] = 32.82, ["Neon"] = 14.33, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 229.04, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 52.5, ["Ride"] = 155.23, ["Neon"] = 156.45, ["Neon|Ride"] = 233.8, ["Neon|Fly|Ride"] = 1029.87, ["Mega"] = 1544.15, ["Mega|Ride"] = 892.79, ["Mega|Fly|Ride"] = 1085.34}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.77, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.82, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 41.52, ["Mega"] = 28.77, ["Mega|Ride"] = 36.95, ["Mega|Fly|Ride"] = 126.95}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.28, ["Fly"] = 76.05, ["Ride"] = 39.15, ["Fly|Ride"] = 94.77, ["Neon"] = 43.32, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 76.22, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 310.43, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 240.86, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.9, ["Fly"] = 39.39, ["Ride"] = 28.22, ["Fly|Ride"] = 65.62, ["Neon"] = 108.94, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 787.5, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Neon"] = 45.94, ["Neon|Ride"] = 41.21, ["Mega"] = 288.38, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 17.32, ["Fly|Ride"] = 37.06, ["Neon"] = 6.19, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 42.95, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.42, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.29, ["Fly"] = 52.5, ["Ride"] = 30.91, ["Neon"] = 11.26, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 930.57, ["Fly"] = 1263.64, ["Ride"] = 984.27, ["Fly|Ride"] = 1076.25, ["Neon"] = 2994.7, ["Neon|Ride"] = 2191.87, ["Neon|Fly|Ride"] = 2485.87, ["Mega|Fly|Ride"] = 6929.41}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.38, ["Ride"] = 137.82, ["Fly|Ride"] = 143.56, ["Neon"] = 413.44, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 604.53, ["Mega"] = 1923.53, ["Mega|Ride"] = 2471.34, ["Mega|Fly|Ride"] = 1757.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.62, ["Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 315, ["Mega"] = 73.02, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 62.91, ["Fly"] = 152.43, ["Ride"] = 95.81, ["Fly|Ride"] = 138.92, ["Neon"] = 301.88, ["Neon|Ride"] = 338.63, ["Neon|Fly|Ride"] = 411.96, ["Mega"] = 1050, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1276.87}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 26.63, ["Fly|Ride"] = 89.62, ["Neon"] = 21.51, ["Neon|Fly"] = 54.42, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 271.27, ["Mega|Ride"] = 305.92, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.05, ["Fly"] = 411.96, ["Ride"] = 336, ["Fly|Ride"] = 463.44, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1235.83, ["Mega|Fly|Ride"] = 4559.9}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 40.19, ["Fly|Ride"] = 200.62, ["Neon"] = 25.5, ["Neon|Ride"] = 54.28, ["Mega"] = 308.94, ["Mega|Fly"] = 321.29, ["Mega|Ride"] = 185.19, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 27.71, ["Neon|Ride"] = 138.02, ["Mega"] = 329.57}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.17, ["Ride"] = 138.02, ["Fly|Ride"] = 196.88, ["Neon"] = 196.88, ["Neon|Fly"] = 411.96, ["Neon|Ride"] = 191.57, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 568.49, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 720.82}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 274.98, ["Neon"] = 20.61, ["Mega"] = 196.88, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 3.86, ["Neon|Fly"] = 31.27, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 37.53, ["Mega"] = 24.94, ["Mega|Ride"] = 39.27, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.25, ["Ride"] = 4436.25, ["Fly|Ride"] = 4462.5, ["Neon"] = 30895.45, ["Neon|Fly|Ride"] = 19911.09, ["Mega|Fly|Ride"] = 85123.86}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.44, ["Fly"] = 39.38, ["Ride"] = 54.51, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 224.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 17.37, ["Fly|Ride"] = 46.9, ["Neon"] = 13.26, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 72.14, ["Mega"] = 144.37, ["Mega|Ride"] = 164.77, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 500.62, ["Fly"] = 547.77, ["Ride"] = 567, ["Fly|Ride"] = 525, ["Neon"] = 1373.84, ["Neon|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 1544.15, ["Mega|Fly|Ride"] = 5492.54}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 140.59, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 8.16, ["Fly"] = 4119.41, ["Ride"] = 2059.72, ["Neon"] = 41.21, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 409.85, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.77, ["Neon"] = 5.07, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.3, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 46.78, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 682.4, ["Fly"] = 880.53, ["Ride"] = 727.13, ["Fly|Ride"] = 773.07, ["Neon"] = 2362.5, ["Neon|Ride"] = 2583.21, ["Neon|Fly|Ride"] = 2208.84}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.81, ["Fly"] = 56.44, ["Ride"] = 78.75, ["Neon"] = 25.99, ["Neon|Ride"] = 68.92, ["Neon|Fly|Ride"] = 644.43, ["Mega"] = 156.19, ["Mega|Ride"] = 204.4, ["Mega|Fly|Ride"] = 376.08}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 52.5, ["Ride"] = 52.41, ["Neon"] = 24.84, ["Neon|Ride"] = 50.06, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 203.44, ["Mega|Ride"] = 195.32, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 41.21, ["Ride"] = 18.31, ["Fly|Ride"] = 52.5, ["Neon"] = 11.82, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 274.95, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.37, ["Ride"] = 68.92, ["Fly|Ride"] = 155.14, ["Neon"] = 117.59, ["Mega"] = 549.95, ["Mega|Fly|Ride"] = 741.41}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 411.96, ["Neon"] = 4.94, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 39.15, ["Neon|Fly|Ride"] = 184.36, ["Mega"] = 43.57, ["Mega|Ride"] = 117.14, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 534.19, ["Ride"] = 564.38, ["Fly|Ride"] = 699.28, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 46.32, ["Fly|Ride"] = 309.09, ["Neon"] = 15.3, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 81.38, ["Mega|Ride"] = 155.1, ["Mega|Fly|Ride"] = 297.91}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 3.94, ["Neon|Fly"] = 138.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 273.92}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 25.73, ["Neon"] = 5.25, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 39.33, ["Mega|Fly"] = 152.41, ["Mega|Ride"] = 80.06, ["Mega|Fly|Ride"] = 192.57}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.03, ["Ride"] = 21.95, ["Neon"] = 18.56, ["Mega"] = 201.39}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 40.05, ["Fly"] = 98.44, ["Ride"] = 118.13, ["Fly|Ride"] = 293.97, ["Neon"] = 129.94, ["Neon|Ride"] = 158.58, ["Neon|Fly|Ride"] = 327.51, ["Mega"] = 632.35, ["Mega|Ride"] = 615.79, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.75, ["Ride"] = 274.98, ["Fly|Ride"] = 138.02, ["Neon"] = 78.66, ["Neon|Ride"] = 175.96, ["Neon|Fly|Ride"] = 273.29, ["Mega"] = 464.2, ["Mega|Ride"] = 389.81, ["Mega|Fly|Ride"] = 560.8}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.02, ["Fly"] = 19.16, ["Ride"] = 15.44, ["Fly|Ride"] = 43.28, ["Neon"] = 28.87, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 299.92, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 15.37, ["Ride"] = 64.32, ["Fly|Ride"] = 123.87, ["Neon"] = 138.02, ["Neon|Ride"] = 131.25, ["Mega"] = 309.07, ["Mega|Ride"] = 715.67, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.45, ["Fly|Ride"] = 73.14, ["Neon"] = 14.42, ["Neon|Ride"] = 33.57, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 98.44, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.67, ["Fly"] = 23.63, ["Ride"] = 23.62, ["Fly|Ride"] = 77.58, ["Neon"] = 231.54, ["Neon|Ride"] = 185.38, ["Neon|Fly|Ride"] = 197.95, ["Mega"] = 925.74, ["Mega|Ride"] = 925.88, ["Mega|Fly|Ride"] = 880.42}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 26.17, ["Fly"] = 874.13, ["Neon"] = 273.98, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 39.37, ["Fly"] = 115.38, ["Ride"] = 71.3, ["Fly|Ride"] = 162.08, ["Neon"] = 262.92, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1636.48, ["Mega|Fly|Ride"] = 1506.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.91, ["Fly"] = 92.63, ["Ride"] = 85.66, ["Fly|Ride"] = 656.25, ["Neon"] = 129.94, ["Neon|Ride"] = 192.6, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 546.99, ["Mega|Ride"] = 659.04, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.17, ["Ride"] = 56.43, ["Fly|Ride"] = 138.02, ["Neon"] = 140.44, ["Neon|Ride"] = 274.26, ["Mega"] = 262.5, ["Mega|Ride"] = 758.09, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.57, ["Fly"] = 428.27, ["Ride"] = 48.2, ["Fly|Ride"] = 69.02, ["Neon"] = 87.91, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 233.89, ["Mega"] = 464.37, ["Mega|Ride"] = 386.56, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.25, ["Fly|Ride"] = 35.01, ["Neon"] = 3.94, ["Neon|Fly"] = 25.15, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 50.81, ["Mega|Fly"] = 155.1, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 140.05}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.41, ["Fly"] = 231.54, ["Ride"] = 126.93, ["Fly|Ride"] = 262.5, ["Neon"] = 291.38, ["Neon|Ride"] = 258.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 789.91, ["Mega|Ride"] = 769.21, ["Mega|Fly|Ride"] = 851.6}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.62, ["Neon"] = 3.27, ["Neon|Fly"] = 96.83, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 288.38, ["Mega"] = 26.66, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 40.19, ["Ride"] = 111.75, ["Neon"] = 69.02, ["Neon|Ride"] = 138.02, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 771.95, ["Mega|Fly|Ride"] = 841.39}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 32.82}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 39.38, ["Mega"] = 26.25, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 98.34, ["Ride"] = 144.2, ["Fly|Ride"] = 253.36, ["Neon"] = 582.75, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 686.93, ["Mega|Ride"] = 2129.47, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 41.99, ["Neon"] = 8.23, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 108.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 69.02, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 61.81, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 122.57, ["Mega"] = 37.09, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 220.38}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.41, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 48.57, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.85}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 4.98, ["Neon|Ride"] = 155.71, ["Mega"] = 62.79, ["Mega|Ride"] = 200.82}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 63.95, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 361.49, ["Neon|Ride"] = 509.79, ["Neon|Fly|Ride"] = 686.93, ["Mega"] = 1235.83, ["Mega|Ride"] = 1544.6, ["Mega|Fly|Ride"] = 1371.6}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 60.52, ["Fly|Ride"] = 131.25, ["Neon"] = 51.76, ["Neon|Ride"] = 155.12, ["Mega"] = 379.65, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.5, ["Ride"] = 467.57, ["Fly|Ride"] = 617.92, ["Neon"] = 1029.87, ["Neon|Ride"] = 1304.83, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 3871.76}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 81.38}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 24.02}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.87}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 115.96}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.54}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.83}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 44}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 27.13}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.43}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.87}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.87}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.21}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 2.1}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.56}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 6.24}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 522.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 787.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.75}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.97}},
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
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.27}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 27.56}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.45}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 14.83}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.25}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.03}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.24}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.96}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.15}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1864.89}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 45.34}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 271.69}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.22}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 39.29}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 210}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.34}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1373.84}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26.25}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 20.89}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.81}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 24.94}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.55}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.15}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 28.88}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.99}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.27}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.26}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.24}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 87.84}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.06}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22049.94}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 146.44}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.3}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 49.88}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 75.51}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 65.63}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 46.15}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 76.99}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 37.68}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 53.81}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 411.96}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.32}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.46}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 89.06}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.33}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 643.19}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 10.31}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.94}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.43}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 601.96}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 49.8}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.91}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.68}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 196.88}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 76.13}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.75}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.91}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.16}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.67}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.2}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.45}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.61}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.64}},
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
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.75}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.21}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.3}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 19.69}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 104.9}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.16}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 4.87}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 20.9}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 77.6}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 23.45}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.15}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.03}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
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
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.39}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 11.71}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7075.09}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 8.25}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.45}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.16}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.84}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.85}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 16.69}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.13}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.13}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 110.14}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 68.99}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.18}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 99.64}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.12}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4283.13}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 252.13}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.91}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 8.16}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.11}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 4.96}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.41}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.83}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.17}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.15}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.2}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.52}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.89}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.94}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 99.21}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.11}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.73}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.84}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 18.37}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.53}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 23.35}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.15}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 23.55}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.11}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 14.34}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.18}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.83}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.18}},
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
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.72}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 45.94}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 4.55}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.08}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.46}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 6.19}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.62}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 315}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.37}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1218}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.34}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 220.4}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 35.44}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 61.69}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.41}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.81}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.46}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 10.5}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.81}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.4}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.23}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.5}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.57}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 61.69}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.82}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.15}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 32.81}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.66}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 91.88}},
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
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.16}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 225.75}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.5}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 74.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 7.76}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 155.72}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.49}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 52.5}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.67}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.18}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.34}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 31.4}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.46}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.65}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 9.17}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 39.37}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.92}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 50.3}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.11}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.08}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 36.65}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 20.74}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.92}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 30.18}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 375.27}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.85}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.4}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.45}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.77}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 259.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.35}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 60.29}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 131.24}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 52.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 118.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.56}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2162.69}},
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