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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 654.94, ["Ride"] = 1027.16, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 20124.48}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 564.26, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2408.76, ["Mega"] = 10320.24, ["Mega|Fly|Ride"] = 9659.66}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5916.31, ["Ride"] = 4593.75, ["Fly|Ride"] = 4593.75, ["Neon"] = 23377.09, ["Neon|Fly|Ride"] = 22703.51, ["Mega|Fly|Ride"] = 68801.94}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 135.14, ["Ride"] = 183.75, ["Fly|Ride"] = 592.45, ["Neon"] = 825.53, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1197.16, ["Mega"] = 4128.11, ["Mega|Fly|Ride"] = 3814.13}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 623.44, ["Fly"] = 825.53, ["Ride"] = 523.69, ["Fly|Ride"] = 630, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.19, ["Ride"] = 26.3, ["Fly|Ride"] = 156.6, ["Neon"] = 56.44, ["Neon|Fly"] = 275.6, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 307.56, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 577.95}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.2, ["Fly"] = 26.25, ["Ride"] = 30.97, ["Fly|Ride"] = 111.46, ["Neon"] = 23.94, ["Neon|Fly"] = 82.59, ["Neon|Ride"] = 59.88, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 146.21, ["Mega|Fly"] = 390.29, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 118.13, ["Ride"] = 149.22, ["Fly|Ride"] = 240.19, ["Neon"] = 551.06, ["Neon|Ride"] = 455.14, ["Neon|Fly|Ride"] = 681.15, ["Mega|Fly|Ride"] = 2694.63}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 44.4, ["Fly"] = 81.81, ["Ride"] = 52.49, ["Fly|Ride"] = 77.84, ["Neon"] = 252, ["Neon|Ride"] = 163.65, ["Neon|Fly|Ride"] = 234.29, ["Mega"] = 2100, ["Mega|Ride"] = 1402.17, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.67, ["Fly"] = 57.28, ["Ride"] = 35.07, ["Fly|Ride"] = 65.63, ["Neon"] = 69.18, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 68.16, ["Fly"] = 109.39, ["Ride"] = 82.57, ["Fly|Ride"] = 176.81, ["Neon"] = 402.8, ["Neon|Ride"] = 295.86, ["Neon|Fly|Ride"] = 311.99, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 70.12}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 339.94, ["Ride"] = 355.69, ["Fly|Ride"] = 332.05, ["Neon"] = 1341.48, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4857.75}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 170.23, ["Ride"] = 108.63, ["Fly|Ride"] = 149.63, ["Neon|Fly"] = 677.95, ["Neon|Ride"] = 573.57, ["Neon|Fly|Ride"] = 654.32, ["Mega|Fly|Ride"] = 2999.46}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.62, ["Ride"] = 53.43, ["Fly|Ride"] = 131.24, ["Neon"] = 20.66, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 189, ["Mega"] = 126.89, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 205.4, ["Mega|Fly|Ride"] = 386.77}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.95, ["Fly"] = 212.66, ["Ride"] = 183.65, ["Fly|Ride"] = 236.25, ["Neon"] = 779.64, ["Neon|Ride"] = 716.24, ["Neon|Fly|Ride"] = 688.38, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.78, ["Fly"] = 27.24, ["Ride"] = 18.38, ["Fly|Ride"] = 41.29, ["Neon"] = 29.94, ["Neon|Ride"] = 93.5, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 102.38, ["Fly"] = 466.38, ["Ride"] = 146.35, ["Fly|Ride"] = 309.59, ["Neon"] = 344.67, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 373.86, ["Neon|Fly|Ride"] = 412.83, ["Mega"] = 1703.79, ["Mega|Ride"] = 1348.88, ["Mega|Fly|Ride"] = 1194.38}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 42}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 62.64, ["Ride"] = 90.02, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1376.74, ["Mega|Fly|Ride"] = 1348.88}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.87, ["Fly"] = 41.29, ["Ride"] = 26.25, ["Fly|Ride"] = 110.42, ["Neon"] = 262.48, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 275.56, ["Mega|Ride"] = 961.86, ["Mega|Fly|Ride"] = 618.2}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.3, ["Fly"] = 125.05, ["Ride"] = 59.07, ["Fly|Ride"] = 113.19, ["Neon"] = 247.67, ["Neon|Ride"] = 240.18, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1635.86, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.75, ["Fly"] = 68.13, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 206.39, ["Neon|Fly"] = 388.07, ["Neon|Ride"] = 189.96, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 1164.14, ["Mega|Ride"] = 1307.59, ["Mega|Fly|Ride"] = 1252.89}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 26.91, ["Ride"] = 41.1, ["Fly|Ride"] = 69.15, ["Neon"] = 180.6, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 294.47, ["Mega"] = 823.57, ["Mega|Ride"] = 2064.06, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly"] = 116.87, ["Ride"] = 57.75, ["Fly|Ride"] = 123.84, ["Neon"] = 233.78, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 407.66, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 13.02, ["Fly"] = 30.13, ["Ride"] = 26.82, ["Fly|Ride"] = 64.32, ["Neon"] = 38.97, ["Neon|Fly"] = 102.2, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 101.17, ["Mega"] = 154.88, ["Mega|Fly"] = 27555.05, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 322.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 396.67, ["Ride"] = 461.57, ["Fly|Ride"] = 480.11, ["Neon"] = 2213.16, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7322.74}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.76, ["Ride"] = 32.32, ["Fly|Ride"] = 105.18, ["Neon"] = 198.19, ["Neon|Ride"] = 138.3, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 34.54, ["Ride"] = 20.99, ["Fly|Ride"] = 59.07, ["Neon"] = 73.5, ["Neon|Ride"] = 70.13, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 286.93, ["Mega|Fly|Ride"] = 444.85}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 71.72, ["Fly"] = 98.85, ["Ride"] = 102.67, ["Fly|Ride"] = 131.25, ["Neon"] = 366.92, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 426.14, ["Mega"] = 3302.49, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1596.55}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.46, ["Ride"] = 27.88, ["Fly|Ride"] = 118.13, ["Neon"] = 101.68, ["Neon|Ride"] = 147.24, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 479.16, ["Mega|Ride"] = 786.42, ["Mega|Fly|Ride"] = 577.95}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 180.06, ["Fly"] = 344.67, ["Ride"] = 229.45, ["Fly|Ride"] = 314.85, ["Neon|Ride"] = 734.99, ["Neon|Fly|Ride"] = 980.44, ["Mega"] = 6192.16, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2939.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 46.77}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 31.97, ["Ride"] = 22.73, ["Fly|Ride"] = 54.1, ["Neon"] = 27.88, ["Neon|Fly"] = 5160.77, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 140.6, ["Mega"] = 234.94, ["Mega|Fly"] = 508.46, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 903, ["Fly"] = 2625, ["Ride"] = 939.94, ["Fly|Ride"] = 1073.03, ["Neon"] = 4127.6, ["Neon|Ride"] = 6054.89, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52580.62, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Fly"] = 69.15, ["Ride"] = 28.09, ["Fly|Ride"] = 106.36, ["Neon"] = 72.45, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 228.1, ["Mega"] = 756, ["Mega|Ride"] = 753.39, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.5, ["Ride"] = 229.69, ["Fly|Ride"] = 262.13, ["Neon"] = 1789.32, ["Neon|Ride"] = 865.81, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 3967.11, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.46}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.04, ["Ride"] = 52.31, ["Fly|Ride"] = 138.29, ["Neon"] = 98.17, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 684.53, ["Mega|Ride"] = 1081.79, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.77}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 125.12, ["Ride"] = 120.75, ["Fly|Ride"] = 233.72, ["Neon|Ride"] = 551.11, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 145, ["Ride"] = 216.46, ["Fly|Ride"] = 314.79, ["Neon"] = 389.45, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1963.96}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 40.24}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.48, ["Fly"] = 61.35, ["Ride"] = 62.91, ["Fly|Ride"] = 85.7, ["Neon|Fly"] = 358.18, ["Neon|Ride"] = 358.13, ["Neon|Fly|Ride"] = 365.14, ["Mega"] = 4128.11, ["Mega|Fly|Ride"] = 1627.5}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.26, ["Ride"] = 65.45, ["Fly|Ride"] = 131.25, ["Neon"] = 45.44, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 232.22, ["Mega"] = 129.42, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 324.07, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 511.88, ["Fly"] = 590.63, ["Ride"] = 465.52, ["Fly|Ride"] = 498.74, ["Neon|Ride"] = 3697.79, ["Neon|Fly|Ride"] = 1575.68, ["Mega|Fly|Ride"] = 6483.75}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.87, ["Fly"] = 151.93, ["Ride"] = 115.49, ["Fly|Ride"] = 194.13, ["Neon"] = 459.38, ["Neon|Fly"] = 825.74, ["Neon|Ride"] = 688.38, ["Neon|Fly|Ride"] = 451.5, ["Mega|Ride"] = 2475.84, ["Mega|Fly|Ride"] = 2317.34}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7018.66, ["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14447.31}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 45.59, ["Fly"] = 110.42, ["Ride"] = 55.13, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 405.47, ["Mega"] = 1307.59, ["Mega|Ride"] = 1721.44, ["Mega|Fly|Ride"] = 1211.61}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 156.69, ["Ride"] = 78.75, ["Fly|Ride"] = 134.25, ["Neon"] = 410.42, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2752.42, ["Mega|Ride"] = 2615.17, ["Mega|Fly|Ride"] = 2973.41}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 39, ["Fly"] = 60.92, ["Ride"] = 52.5, ["Fly|Ride"] = 109.86, ["Neon"] = 139.13, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 2625, ["Mega|Ride"] = 729.65, ["Mega|Fly|Ride"] = 655.56}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 10.34}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.77, ["Fly"] = 51.6, ["Ride"] = 51.6, ["Fly|Ride"] = 64.94, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1869.55}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 223.13, ["Fly|Ride"] = 275.54, ["Neon|Ride"] = 934.79, ["Neon|Fly|Ride"] = 1376.74, ["Mega|Fly|Ride"] = 4985.82}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1307.76, ["Ride"] = 958.78, ["Fly|Ride"] = 1362.12, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13761.02}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.17}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.18, ["Fly"] = 34.13, ["Ride"] = 43.62, ["Fly|Ride"] = 64.1, ["Neon"] = 229.71, ["Neon|Ride"] = 158.34, ["Neon|Fly|Ride"] = 220.87, ["Mega|Ride"] = 891.66, ["Mega|Fly|Ride"] = 1007.27}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 16.5}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5986.5, ["Ride"] = 5985, ["Fly|Ride"] = 4608.19, ["Neon|Fly|Ride"] = 9821.44, ["Mega|Fly|Ride"] = 35678.88}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.71, ["Fly"] = 52.4, ["Ride"] = 23.38, ["Fly|Ride"] = 63.99, ["Neon"] = 104.99, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 193.35, ["Mega"] = 787.5, ["Mega|Ride"] = 481.98, ["Mega|Fly|Ride"] = 650.45}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.6, ["Fly"] = 191.96, ["Ride"] = 31.37, ["Fly|Ride"] = 275.54, ["Neon"] = 69.15, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 721.88, ["Mega|Ride"] = 521.07, ["Mega|Fly|Ride"] = 1028.94}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 112.26, ["Fly"] = 275.54, ["Ride"] = 91.88, ["Fly|Ride"] = 126.53, ["Neon|Ride"] = 382.9, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4128.11}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.13, ["Fly"] = 150.93, ["Ride"] = 31.56, ["Fly|Ride"] = 78.75, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 731.08, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1903.02, ["Fly"] = 2233.03, ["Ride"] = 1785, ["Fly|Ride"] = 1876.87, ["Neon|Fly|Ride"] = 3495.32, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 26117.44, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72241.66, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 22.01, ["Fly"] = 393.74, ["Ride"] = 55.13, ["Fly|Ride"] = 124.69, ["Neon"] = 268.3, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 963.93, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.92, ["Fly"] = 69.15, ["Ride"] = 26.25, ["Fly|Ride"] = 158.9, ["Neon"] = 20.9, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 114.01, ["Mega"] = 125.98, ["Mega|Ride"] = 236.64, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 11.71, ["Ride"] = 32, ["Fly|Ride"] = 125.25, ["Neon"] = 61.6, ["Neon|Ride"] = 131.09, ["Neon|Fly|Ride"] = 165.14, ["Mega"] = 344.72, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 733.69, ["Fly|Ride"] = 918.75, ["Neon|Fly|Ride"] = 2546.02, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.61, ["Fly"] = 975.19, ["Ride"] = 918.65, ["Fly|Ride"] = 1017.19, ["Neon|Ride"] = 3165.23, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 12151.98}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 16.53, ["Fly"] = 116.87, ["Ride"] = 22.44, ["Fly|Ride"] = 85.32, ["Neon"] = 138.29, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 605.81}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 55.75, ["Fly"] = 93.5, ["Ride"] = 75.51, ["Fly|Ride"] = 104.9, ["Neon"] = 463.34, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 399, ["Mega|Ride"] = 2020.71, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 64.38, ["Ride"] = 78.75, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 278.73, ["Neon|Fly|Ride"] = 551.11, ["Mega"] = 1343.07, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.61, ["Fly"] = 44.42, ["Ride"] = 19.69, ["Fly|Ride"] = 55.43, ["Neon"] = 47.15, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 132.55, ["Mega"] = 288.75, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 133.81, ["Fly"] = 132.57, ["Ride"] = 137.41, ["Fly|Ride"] = 199.5, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Fly|Ride"] = 262.49, ["Neon"] = 41.61, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 480.94, ["Mega"] = 232.02, ["Mega|Ride"] = 288.98}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.15, ["Fly"] = 41.22, ["Ride"] = 32.69, ["Fly|Ride"] = 79.31, ["Neon"] = 85.32, ["Neon|Ride"] = 101.15, ["Neon|Fly|Ride"] = 165.14, ["Mega|Fly|Ride"] = 784.35}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 31.71, ["Ride"] = 55.74, ["Fly|Ride"] = 156.19, ["Neon"] = 218.53, ["Neon|Ride"] = 330.31, ["Neon|Fly|Ride"] = 412.83, ["Mega"] = 918.74, ["Mega|Ride"] = 779.38, ["Mega|Fly|Ride"] = 963.93}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.55, ["Fly"] = 161.32, ["Ride"] = 35.79, ["Fly|Ride"] = 70.88, ["Neon"] = 87.28, ["Neon|Ride"] = 109.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 891.69, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6956.25, ["Ride"] = 7141.32, ["Fly|Ride"] = 5494, ["Neon"] = 30956.88, ["Neon|Fly|Ride"] = 27369.29, ["Mega|Fly|Ride"] = 93476.64}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 233.63, ["Fly"] = 267.75, ["Ride"] = 252.97, ["Fly|Ride"] = 275.54, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 40.68, ["Fly"] = 210, ["Ride"] = 88.53, ["Fly|Ride"] = 159.6, ["Neon"] = 120.75, ["Neon|Fly"] = 308.63, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 392.34, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 86.49, ["Ride"] = 23.39, ["Fly|Ride"] = 106.36, ["Neon"] = 25.38, ["Neon|Fly"] = 49.55, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.85, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 56.44, ["Fly"] = 5265.65, ["Ride"] = 85.32, ["Fly|Ride"] = 199.87, ["Neon"] = 203.16, ["Neon|Fly"] = 358.18, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 311.56, ["Mega"] = 457.25, ["Mega|Ride"] = 558.71, ["Mega|Fly|Ride"] = 596.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15688.72, ["Ride"] = 11943.75, ["Fly|Ride"] = 11811.19, ["Neon|Fly|Ride"] = 22141.88}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 196.88, ["Ride"] = 262.13, ["Fly|Ride"] = 343.08, ["Neon"] = 1513.15, ["Neon|Fly|Ride"] = 1548.05, ["Mega|Fly|Ride"] = 5567.78}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 56.76, ["Fly"] = 71.07, ["Ride"] = 76.96, ["Fly|Ride"] = 101.58, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2751.39}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.5, ["Fly"] = 44.42, ["Ride"] = 22.6, ["Fly|Ride"] = 55.74, ["Neon"] = 109.86, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 142.14, ["Mega"] = 295.32, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.09, ["Ride"] = 414.75, ["Fly|Ride"] = 484.3, ["Neon"] = 1706.25, ["Neon|Ride"] = 1394.94, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.57, ["Fly"] = 101.53, ["Ride"] = 37.3, ["Fly|Ride"] = 84.96, ["Neon"] = 26.85, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 169.26, ["Mega"] = 129.94, ["Mega|Fly"] = 289.79, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 131.25, ["Fly"] = 212.8, ["Ride"] = 156.94, ["Fly|Ride"] = 233.63, ["Neon"] = 547.95, ["Neon|Fly"] = 525, ["Neon|Ride"] = 524.88, ["Neon|Fly|Ride"] = 555.08, ["Mega|Fly|Ride"] = 2619.25}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.39, ["Fly"] = 18.08, ["Ride"] = 18.25, ["Fly|Ride"] = 34.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 874.13}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.49}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 138.29, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 551.18, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1789.55}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 20.66, ["Fly"] = 102.18, ["Ride"] = 81.9, ["Fly|Ride"] = 91.88, ["Neon"] = 117.66, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 245.44, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.93}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.16, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 97.04, ["Neon|Ride"] = 260.46, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 1548.05, ["Mega|Ride"] = 1331.33, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.78, ["Ride"] = 29.23, ["Fly|Ride"] = 133.22, ["Neon"] = 24.97, ["Neon|Ride"] = 101.67, ["Neon|Fly|Ride"] = 274.54, ["Mega"] = 135.19, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.23, ["Fly"] = 47.25, ["Ride"] = 37.16, ["Fly|Ride"] = 93.35, ["Neon"] = 131.25, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 200.46, ["Mega|Ride"] = 619.23, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 412.88, ["Ride"] = 443.59, ["Fly|Ride"] = 446.25, ["Neon|Fly|Ride"] = 2745.2, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 40.69, ["Ride"] = 55.11, ["Fly|Ride"] = 135.19, ["Neon"] = 234.67, ["Neon|Ride"] = 231.54, ["Neon|Fly|Ride"] = 304.47, ["Mega"] = 1013.07, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 50.88, ["Fly"] = 117.49, ["Ride"] = 72.26, ["Fly|Ride"] = 131.15, ["Neon"] = 455.09, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 757.53, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 30.41, ["Fly"] = 77.14, ["Ride"] = 68.25, ["Fly|Ride"] = 138.29, ["Neon"] = 118.32, ["Neon|Ride"] = 206.42, ["Neon|Fly|Ride"] = 322, ["Mega"] = 409.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 631.6}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13399.24, ["Fly|Ride"] = 8006.25, ["Neon|Fly|Ride"] = 16202.82, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1822.88, ["Ride"] = 1391.24, ["Fly|Ride"] = 1575, ["Neon|Fly|Ride"] = 4959.74, ["Mega|Fly|Ride"] = 17792.1}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 459.38, ["Ride"] = 560.37, ["Fly|Ride"] = 688.28, ["Neon"] = 4338.65, ["Mega|Fly|Ride"] = 6867.1}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.07, ["Fly"] = 21.76, ["Ride"] = 21.6, ["Fly|Ride"] = 49.92, ["Neon"] = 110.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 138.3, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.69, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 82.57, ["Neon"] = 27.57, ["Neon|Ride"] = 76.38, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 143.54, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 44.4, ["Fly"] = 114.35, ["Ride"] = 45.88, ["Fly|Ride"] = 102.08, ["Neon"] = 525.99, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 189.84, ["Mega|Fly|Ride"] = 551.14}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.84, ["Fly"] = 26.82, ["Ride"] = 18.77, ["Fly|Ride"] = 41.29, ["Neon"] = 28.41, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 261.19, ["Mega|Ride"] = 206.42}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.32, ["Fly"] = 369.49, ["Ride"] = 262.5, ["Fly|Ride"] = 404.82, ["Neon|Fly|Ride"] = 1236.38, ["Mega|Ride"] = 4679.21, ["Mega|Fly|Ride"] = 4679.21}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 23.4, ["Fly"] = 60.59, ["Ride"] = 33.97, ["Fly|Ride"] = 88.76, ["Neon"] = 91.88, ["Neon|Fly"] = 412.88, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 247.7, ["Mega"] = 602.73, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.76, ["Fly"] = 18.38, ["Ride"] = 20.66, ["Fly|Ride"] = 43.12, ["Neon"] = 138.29, ["Neon|Fly"] = 123.87, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 446.25, ["Fly"] = 787.5, ["Ride"] = 446.24, ["Fly|Ride"] = 688.28, ["Neon|Ride"] = 2951.6, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1317.75, ["Ride"] = 1154.9, ["Fly|Ride"] = 1312.5, ["Neon"] = 4815.87, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 117.94, ["Fly"] = 136.19, ["Ride"] = 99.75, ["Fly|Ride"] = 133.22, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 3583.68}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 159.29, ["Fly"] = 192.98, ["Ride"] = 157.5, ["Fly|Ride"] = 242.82, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.46, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2336.94}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.15, ["Ride"] = 78.44, ["Fly|Ride"] = 118.58, ["Neon"] = 257.4, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 387.02, ["Mega|Ride"] = 2064.06, ["Mega|Fly|Ride"] = 866.91}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 215.75, ["Ride"] = 273, ["Fly|Ride"] = 551.06, ["Neon|Fly"] = 935.09, ["Neon|Fly|Ride"] = 1308.68, ["Mega|Fly|Ride"] = 3715.3}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Ride"] = 2483.25, ["Fly|Ride"] = 2132.95, ["Neon|Fly|Ride"] = 10320.24, ["Mega|Fly|Ride"] = 28043.01}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 78.75, ["Ride"] = 83.53, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2270.47, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 643.12, ["Fly|Ride"] = 670.48, ["Neon|Ride"] = 1635.86, ["Neon|Fly|Ride"] = 1279.69, ["Mega|Fly|Ride"] = 3274.69}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 52.65, ["Fly"] = 64.22, ["Ride"] = 63, ["Fly|Ride"] = 103.06, ["Neon|Ride"] = 362.23, ["Neon|Fly|Ride"] = 303.19, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 20.93, ["Fly|Ride"] = 39.9, ["Neon"] = 21, ["Neon|Fly"] = 120.75, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 147.98, ["Mega|Fly"] = 182.62, ["Mega|Ride"] = 179.33, ["Mega|Fly|Ride"] = 303.2}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 340.54, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 688.38, ["Mega"] = 1508.83, ["Mega|Ride"] = 1651.26, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 1023.02, ["Ride"] = 833.44, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 2572.77, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8256.21}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 656.25, ["Ride"] = 783.23, ["Fly|Ride"] = 888.07, ["Neon|Fly|Ride"] = 4073.42, ["Mega|Fly|Ride"] = 14861.16}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.75, ["Fly"] = 26.25, ["Ride"] = 25.89, ["Fly|Ride"] = 38.07, ["Neon|Ride"] = 99.8, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 786.19, ["Mega|Ride"] = 688.38, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.22, ["Ride"] = 30.97, ["Fly|Ride"] = 59.06, ["Neon"] = 85.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 179.59, ["Mega"] = 347.82, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.7, ["Ride"] = 24.92, ["Fly|Ride"] = 111.56, ["Neon"] = 21.19, ["Neon|Fly"] = 312.1, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 156.59, ["Mega"] = 166.05, ["Mega|Fly"] = 530.5, ["Mega|Ride"] = 244.02, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.95, ["Fly"] = 63.15, ["Ride"] = 55.9, ["Fly|Ride"] = 104.45, ["Neon"] = 229.69, ["Neon|Ride"] = 217.34, ["Neon|Fly|Ride"] = 218.52, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.54, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 419.83, ["Neon|Ride"] = 515, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1514, ["Mega|Ride"] = 1548.05, ["Mega|Fly|Ride"] = 1502.65}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 59.06, ["Ride"] = 34.8, ["Fly|Ride"] = 91.88, ["Neon"] = 82.7, ["Neon|Fly"] = 156.64, ["Neon|Ride"] = 117.85, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 399.41, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 26.18, ["Fly"] = 56.01, ["Ride"] = 45.74, ["Fly|Ride"] = 84.31, ["Neon"] = 548.5, ["Neon|Ride"] = 206.42, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 963.93, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.84, ["Fly"] = 27.88, ["Ride"] = 17.07, ["Fly|Ride"] = 47.99, ["Neon"] = 24.03, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 525, ["Mega|Ride"] = 363.28, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.99, ["Fly"] = 38.2, ["Ride"] = 31.26, ["Fly|Ride"] = 1312.5, ["Neon"] = 25.99, ["Neon|Fly"] = 51.98, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 247.7, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 53.68, ["Fly"] = 65.62, ["Ride"] = 58.61, ["Fly|Ride"] = 110.36, ["Neon"] = 405.61, ["Neon|Ride"] = 210.34, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1070.14}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1649.82, ["Fly|Ride"] = 1561.88, ["Neon|Fly|Ride"] = 3804.94, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 420, ["Fly"] = 479.64, ["Ride"] = 459.27, ["Fly|Ride"] = 605.74, ["Neon|Fly|Ride"] = 3027.97, ["Mega|Fly|Ride"] = 9632.93}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 239.52, ["Ride"] = 322.01, ["Fly|Ride"] = 392.44, ["Neon"] = 1510.05, ["Neon|Ride"] = 1486.31, ["Neon|Fly|Ride"] = 1583.14, ["Mega|Fly|Ride"] = 7224.18}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 52.49}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.57, ["Ride"] = 47.15, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 179.59, ["Neon|Fly|Ride"] = 467.4, ["Mega|Ride"] = 1238.45, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 48167.44, ["Fly"] = 65625, ["Ride"] = 34781.25, ["Fly|Ride"] = 17917.83, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 336.53, ["Fly"] = 448.89, ["Ride"] = 452.23, ["Fly|Ride"] = 460.24, ["Neon"] = 1374.84, ["Neon|Fly"] = 1247.18, ["Neon|Ride"] = 1147.13, ["Neon|Fly|Ride"] = 981.75, ["Mega"] = 6192.16, ["Mega|Fly|Ride"] = 3577.19}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 151.51, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 4128.11}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 137.44, ["Fly"] = 262.49, ["Ride"] = 124.69, ["Fly|Ride"] = 190.32, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 688.38, ["Mega|Fly|Ride"] = 2476.87}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 16.66, ["Fly"] = 94.5, ["Ride"] = 35.44, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 274.54, ["Mega"] = 698.76, ["Mega|Fly|Ride"] = 619.23}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4954.35, ["Ride"] = 4980.97, ["Fly|Ride"] = 4677.37, ["Neon"] = 20637.92, ["Neon|Fly|Ride"] = 27520.99, ["Mega|Fly|Ride"] = 62318.55}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 24.67, ["Fly"] = 137.42, ["Ride"] = 36.05, ["Fly|Ride"] = 58.73, ["Neon"] = 337.32, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 41.02, ["Ride"] = 56.26, ["Fly|Ride"] = 109.86, ["Neon"] = 400.39, ["Neon|Ride"] = 234.31, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 703.5, ["Fly"] = 918.75, ["Ride"] = 787.5, ["Fly|Ride"] = 787.5, ["Neon"] = 2752.76, ["Neon|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 2415, ["Mega"] = 7491.47, ["Mega|Fly"] = 7491.47, ["Mega|Fly|Ride"] = 7491.47}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.58, ["Fly"] = 26.15, ["Ride"] = 22.21, ["Fly|Ride"] = 36.75, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 747.83}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.81, ["Ride"] = 30.97, ["Fly|Ride"] = 467.42, ["Neon"] = 80.5, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 179.59, ["Mega"] = 408.7}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 89.24, ["Ride"] = 116.62, ["Fly|Ride"] = 210.34, ["Neon"] = 577.88, ["Neon|Ride"] = 753.66, ["Neon|Fly|Ride"] = 598.59, ["Mega|Fly|Ride"] = 2600.71}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 17.55, ["Fly"] = 138.29, ["Ride"] = 56.32, ["Fly|Ride"] = 185.76, ["Neon"] = 85.04, ["Neon|Fly"] = 102.74, ["Neon|Ride"] = 118.26, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 249.38, ["Mega|Fly"] = 741.99, ["Mega|Ride"] = 276.28, ["Mega|Fly|Ride"] = 409.31}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4266.01, ["Ride"] = 4068.75, ["Fly|Ride"] = 4000.5, ["Neon|Ride"] = 12276.96, ["Neon|Fly|Ride"] = 9581.25, ["Mega"] = 61921.43, ["Mega|Fly|Ride"] = 34401.49}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 43.46, ["Ride"] = 78.75, ["Fly|Ride"] = 191.65, ["Neon"] = 393.32, ["Neon|Ride"] = 250.49, ["Neon|Fly|Ride"] = 412.83, ["Mega|Ride"] = 1023.79, ["Mega|Fly|Ride"] = 1822.82}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 6232.82, ["Neon|Ride"] = 18991.61, ["Neon|Fly|Ride"] = 15736.88, ["Mega|Fly|Ride"] = 77401.78}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.81, ["Fly"] = 16.94, ["Ride"] = 17.07, ["Fly|Ride"] = 41.29, ["Neon"] = 27.88, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.43, ["Neon|Fly|Ride"] = 83.33, ["Mega"] = 452.21, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.17, ["Fly"] = 26.17, ["Ride"] = 26.25, ["Fly|Ride"] = 50.04, ["Neon"] = 136.23, ["Neon|Fly"] = 228.12, ["Neon|Ride"] = 191.98, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 688.38}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.66}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 17.55, ["Ride"] = 39.23, ["Fly|Ride"] = 116.01, ["Neon"] = 265.82, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 1049.9, ["Mega|Ride"] = 963.93, ["Mega|Fly|Ride"] = 764.1}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.88, ["Fly"] = 190.37, ["Ride"] = 55.74, ["Fly|Ride"] = 99.73, ["Neon"] = 202.27, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 311.99, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 9.98, ["Fly"] = 19.69, ["Ride"] = 20.66, ["Fly|Ride"] = 36.75, ["Neon|Ride"] = 114.57, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 654.94, ["Mega|Ride"] = 583.08, ["Mega|Fly|Ride"] = 504}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8360.45}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 164.07, ["Ride"] = 196.88, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1032.04, ["Mega|Fly|Ride"] = 5572.95}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.42, ["Fly"] = 130.04, ["Ride"] = 40.14, ["Fly|Ride"] = 105, ["Neon"] = 140.23, ["Neon|Ride"] = 113.31, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 934.79, ["Mega|Fly|Ride"] = 956.7}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.87, ["Ride"] = 29.94, ["Fly|Ride"] = 78.3, ["Neon"] = 81.54, ["Neon|Ride"] = 94.97, ["Neon|Fly|Ride"] = 140.24, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 170.21, ["Fly"] = 412.77, ["Ride"] = 205.35, ["Fly|Ride"] = 262.5, ["Neon"] = 701.37, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3165.23, ["Mega|Fly|Ride"] = 3441.82}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 77.31, ["Ride"] = 120.38, ["Fly|Ride"] = 165.38, ["Neon"] = 688.28, ["Neon|Ride"] = 412.83, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 3302.49}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 170.63, ["Fly"] = 265.49, ["Ride"] = 207.38, ["Fly|Ride"] = 247.62, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 849.79, ["Mega|Fly|Ride"] = 3739.09}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2476.57, ["Ride"] = 1968.75, ["Fly|Ride"] = 1818.04, ["Neon"] = 8179.53, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 34276.73}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.04, ["Fly"] = 97.04, ["Ride"] = 39.75, ["Fly|Ride"] = 69.01, ["Neon"] = 165.13, ["Neon|Ride"] = 179.59, ["Neon|Fly|Ride"] = 262.15, ["Mega"] = 927.81, ["Mega|Ride"] = 857.67, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 873.36, ["Fly"] = 2100, ["Ride"] = 894.67, ["Fly|Ride"] = 928.72, ["Neon|Fly|Ride"] = 4051.06}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 52.29}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Ride"] = 39.38, ["Fly|Ride"] = 138.29, ["Neon"] = 101.06, ["Neon|Ride"] = 118.7, ["Neon|Fly|Ride"] = 304.47, ["Mega"] = 480.27, ["Mega|Ride"] = 467.4, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.88, ["Fly"] = 162.24, ["Ride"] = 23.63, ["Fly|Ride"] = 70.88, ["Neon"] = 63.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 918.75, ["Mega|Ride"] = 358.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.69}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 14.54, ["Ride"] = 22.31, ["Fly|Ride"] = 80.14, ["Neon"] = 192.98, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 825.64, ["Mega|Fly|Ride"] = 1506.86}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 18.73, ["Fly"] = 51.6, ["Ride"] = 41.02, ["Fly|Ride"] = 63.95, ["Neon"] = 288.75, ["Neon|Ride"] = 412.83, ["Neon|Fly|Ride"] = 412.83, ["Mega"] = 882.39, ["Mega|Ride"] = 1752.71, ["Mega|Fly|Ride"] = 963.93}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 11007.24, ["Ride"] = 5250, ["Fly|Ride"] = 4987.5, ["Neon|Fly|Ride"] = 11696.97, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.6, ["Fly"] = 56.72, ["Ride"] = 36.05, ["Fly|Ride"] = 105, ["Neon"] = 82.57, ["Neon|Ride"] = 103.22, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 523.48, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.82}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 131.1, ["Fly"] = 365.3, ["Ride"] = 133.22, ["Fly|Ride"] = 196.88, ["Neon"] = 525, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 737.3, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 72.51, ["Fly"] = 124.31, ["Ride"] = 90.65, ["Fly|Ride"] = 246.64, ["Neon"] = 259.88, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 399.41, ["Mega"] = 2336.94, ["Mega|Ride"] = 2786.48, ["Mega|Fly|Ride"] = 1659.23}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.77, ["Fly"] = 70.47, ["Ride"] = 31.38, ["Fly|Ride"] = 81.38, ["Neon"] = 128.77, ["Neon|Ride"] = 184.59, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1016.21, ["Mega|Ride"] = 841.12, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.25, ["Fly"] = 69.15, ["Ride"] = 27.57, ["Fly|Ride"] = 92.32, ["Neon"] = 39.76, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 202.29, ["Mega"] = 168, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 219.58, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Ride"] = 30.52, ["Fly|Ride"] = 63, ["Neon"] = 116.62, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 724.46, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 633.68}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.69, ["Fly"] = 30.19, ["Ride"] = 30.78, ["Fly|Ride"] = 52.85, ["Neon"] = 165.16, ["Neon|Ride"] = 165.14, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 758.55}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 223.11}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 37.17, ["Ride"] = 291.38, ["Fly|Ride"] = 273.78, ["Neon"] = 148.41, ["Neon|Ride"] = 206.42, ["Mega"] = 825.64, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 220.89, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.71, ["Neon"] = 1238.29}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 48.57, ["Fly"] = 212.02, ["Ride"] = 121.77, ["Fly|Ride"] = 196.88, ["Neon"] = 259.85, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 525, ["Mega"] = 904.32, ["Mega|Ride"] = 1032.04, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1197.02, ["Ride"] = 966.13, ["Fly|Ride"] = 1022.44, ["Neon|Fly"] = 4044.26, ["Neon|Ride"] = 3165.23, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12549.43}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 401.52, ["Fly"] = 688.28, ["Ride"] = 412.77, ["Fly|Ride"] = 480.88, ["Neon"] = 2889.33, ["Neon|Ride"] = 2064.06, ["Neon|Fly|Ride"] = 1927.84, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 70.66}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.92}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 55.38, ["Ride"] = 26.17, ["Fly|Ride"] = 51.19, ["Neon"] = 78.73, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 688.38, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 304.66, ["Fly"] = 392.14, ["Ride"] = 304.5, ["Fly|Ride"] = 454.06, ["Neon"] = 1073.19, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 2687.47}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.43}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 136.83, ["Ride"] = 183.22, ["Fly|Ride"] = 389.82, ["Neon"] = 736.79, ["Neon|Ride"] = 825.74, ["Neon|Fly|Ride"] = 1739.07, ["Mega"] = 3027.97, ["Mega|Ride"] = 11740.32, ["Mega|Fly|Ride"] = 3019.71}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 139.32, ["Ride"] = 125.89, ["Fly|Ride"] = 206.39, ["Neon"] = 688.28, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2423.21}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 29.3, ["Fly|Ride"] = 168.21, ["Neon"] = 26.25, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 228.1, ["Mega"] = 264.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 823.57}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.13, ["Fly"] = 63.03, ["Ride"] = 26.37, ["Fly|Ride"] = 71.05, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 311.99, ["Mega|Ride"] = 803.96, ["Mega|Fly|Ride"] = 621.29}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.36, ["Fly"] = 102.33, ["Ride"] = 44.63, ["Fly|Ride"] = 110.42, ["Neon"] = 105, ["Neon|Ride"] = 102.2, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.65, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 455.14}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 27.57, ["Fly"] = 157.5, ["Ride"] = 53.82, ["Fly|Ride"] = 170.63, ["Neon"] = 30.73, ["Neon|Fly"] = 233.78, ["Neon|Ride"] = 61.68, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 164.07, ["Mega|Fly"] = 309.63, ["Mega|Ride"] = 178.4, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Ride"] = 344.67, ["Fly|Ride"] = 364.17, ["Neon"] = 1620.09, ["Neon|Ride"] = 1376.74, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5229.28}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 132.14, ["Fly"] = 294.63, ["Ride"] = 206.39, ["Fly|Ride"] = 263.82, ["Neon"] = 1031.91, ["Neon|Ride"] = 721.87, ["Mega"] = 9907.44, ["Mega|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 3082.67}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 92.46, ["Ride"] = 87.94, ["Fly|Ride"] = 123.84, ["Neon|Ride"] = 551.11, ["Neon|Fly|Ride"] = 481.98, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Ride"] = 58.24, ["Fly|Ride"] = 275.54, ["Neon"] = 342.6, ["Neon|Ride"] = 593.59, ["Neon|Fly|Ride"] = 481.98, ["Mega|Ride"] = 619.23, ["Mega|Fly|Ride"] = 1857.66}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 19.69, ["Fly"] = 57.29, ["Ride"] = 36.75, ["Fly|Ride"] = 98.04, ["Neon"] = 77.39, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 158.95, ["Mega"] = 411.79, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.89, ["Fly"] = 52.45, ["Ride"] = 22.89, ["Fly|Ride"] = 82.57, ["Neon"] = 19.68, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 136.24, ["Mega"] = 131.25, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1012.05, ["Fly"] = 1073.19, ["Ride"] = 992.63, ["Fly|Ride"] = 1034.21, ["Neon|Fly"] = 3429.43, ["Neon|Ride"] = 8257.24, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 9770.18}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 464.63, ["Ride"] = 514.94, ["Fly|Ride"] = 551.06, ["Neon|Fly"] = 1376.91, ["Neon|Ride"] = 1543.91, ["Neon|Fly|Ride"] = 1622.36, ["Mega"] = 10320.24, ["Mega|Fly|Ride"] = 6271.42}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 78.75, ["Fly"] = 138.29, ["Ride"] = 124.57, ["Fly|Ride"] = 140.23, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 463.4, ["Mega|Fly|Ride"] = 1909.26}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 346.7, ["Fly|Ride"] = 314.81, ["Neon"] = 1170.19, ["Neon|Fly|Ride"] = 2064.06, ["Mega"] = 10320.24, ["Mega|Fly|Ride"] = 5504.83}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.59, ["Fly"] = 73.28, ["Ride"] = 28.28, ["Fly|Ride"] = 71.49, ["Neon"] = 169.32, ["Neon|Ride"] = 217.34, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 778.21}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 262.5, ["Fly|Ride"] = 472.4, ["Neon"] = 758.33, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 934.79, ["Mega"] = 4107.75, ["Mega|Ride"] = 4266.4, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 45.85, ["Fly"] = 125.98, ["Ride"] = 72.02, ["Fly|Ride"] = 68.25, ["Neon|Ride"] = 241.5, ["Neon|Fly|Ride"] = 275.56, ["Mega|Fly|Ride"] = 1376.74}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 1995.71, ["Fly|Ride"] = 1844.01, ["Neon"] = 6606.72, ["Neon|Ride"] = 10906.41, ["Neon|Fly|Ride"] = 6300, ["Mega"] = 49537.16, ["Mega|Fly|Ride"] = 23392.89}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 18.8, ["Fly"] = 82.17, ["Ride"] = 39.75, ["Fly|Ride"] = 114.55, ["Neon"] = 64.32, ["Neon|Fly"] = 228.12, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 227.85, ["Mega"] = 323.02, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 51.35, ["Ride"] = 81.54, ["Fly|Ride"] = 102.38, ["Neon"] = 223.13, ["Neon|Ride"] = 293.1, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1028.94, ["Mega|Fly|Ride"] = 961.86}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.85, ["Ride"] = 85.28, ["Fly|Ride"] = 97.01, ["Neon"] = 455.09, ["Neon|Ride"] = 455.14, ["Neon|Fly|Ride"] = 505.32, ["Mega|Fly|Ride"] = 1823.95}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3439.15, ["Ride"] = 1050, ["Fly|Ride"] = 1170.23}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 398.9, ["Fly"] = 823.47, ["Ride"] = 551.06, ["Fly|Ride"] = 675.42, ["Neon|Fly|Ride"] = 2804.32, ["Mega|Fly|Ride"] = 18695.35}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 125.12, ["Fly"] = 203.34, ["Ride"] = 123.84, ["Fly|Ride"] = 196.88, ["Neon"] = 446.8, ["Neon|Fly"] = 619.32, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 598.59, ["Mega"] = 4128.11, ["Mega|Ride"] = 4128.11, ["Mega|Fly|Ride"] = 2709.26}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.88, ["Ride"] = 31.56, ["Fly|Ride"] = 58.44, ["Neon"] = 87.94, ["Neon|Fly"] = 138.33, ["Neon|Ride"] = 107.36, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72, ["Mega|Fly|Ride"] = 1376.74}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 40.85, ["Fly"] = 54.53, ["Ride"] = 48.06, ["Fly|Ride"] = 103.2, ["Neon"] = 196.88, ["Neon|Fly"] = 412.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1197.16, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 740.64, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon"] = 3026.28, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.37, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 966.89}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6042.23, ["Ride"] = 4987.5, ["Fly|Ride"] = 4984.88, ["Neon"] = 42000, ["Neon|Ride"] = 29578.84, ["Neon|Fly|Ride"] = 24081.25, ["Mega|Fly|Ride"] = 88066.73}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 315.95, ["Fly"] = 410.93, ["Ride"] = 393.75, ["Neon"] = 1651.05, ["Neon|Ride"] = 2064.06, ["Neon|Fly|Ride"] = 2064.06, ["Mega"] = 6191.13, ["Mega|Fly|Ride"] = 6192.16}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 84, ["Fly"] = 275.6, ["Ride"] = 118.13, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 510.87, ["Neon|Fly|Ride"] = 551.11, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.57, ["Fly"] = 58.84, ["Ride"] = 37.69, ["Fly|Ride"] = 105.18, ["Neon"] = 109.36, ["Neon|Fly"] = 1247.18, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 659.48, ["Mega|Ride"] = 825.64, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.69, ["Fly"] = 26.17, ["Ride"] = 21, ["Fly|Ride"] = 44.34, ["Neon"] = 206.39, ["Neon|Ride"] = 311.99, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2187.9}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.55, ["Fly"] = 274.3, ["Ride"] = 39.75, ["Fly|Ride"] = 140.44, ["Neon"] = 115.5, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 670.69, ["Mega|Ride"] = 619.23, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 55.74, ["Ride"] = 21.93, ["Fly|Ride"] = 48.57, ["Neon"] = 28.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 275.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 29.6, ["Fly"] = 90.57, ["Ride"] = 51.19, ["Fly|Ride"] = 183.75, ["Neon"] = 156.6, ["Neon|Fly"] = 825.74, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 330.26, ["Mega"] = 825.64, ["Mega|Ride"] = 674.96, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 387.19, ["Fly"] = 467.42, ["Ride"] = 383.25, ["Fly|Ride"] = 459.38, ["Neon"] = 1370.38, ["Neon|Ride"] = 1374.68, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 7875, ["Mega|Fly"] = 5081.7, ["Mega|Fly|Ride"] = 4953.73}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.21, ["Fly"] = 14.44, ["Ride"] = 12.39, ["Fly|Ride"] = 45.43, ["Neon"] = 19.69, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 86.43, ["Mega"] = 825.64, ["Mega|Ride"] = 545.69, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 51.19, ["Fly"] = 86.16, ["Ride"] = 83.99, ["Fly|Ride"] = 150.61, ["Neon"] = 194.24, ["Neon|Fly"] = 289.02, ["Neon|Ride"] = 200.4, ["Neon|Fly|Ride"] = 275.41, ["Mega"] = 633.19, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 960.95, ["Fly"] = 1004.93, ["Ride"] = 813.75, ["Fly|Ride"] = 819, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.35, ["Fly"] = 91.88, ["Ride"] = 49.88, ["Fly|Ride"] = 82.57, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 393.75, ["Fly"] = 339.71, ["Ride"] = 336, ["Fly|Ride"] = 394.2, ["Neon|Ride"] = 1789.55, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 14021.52}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 156.69, ["Fly"] = 234.31, ["Ride"] = 157.39, ["Fly|Ride"] = 232.92, ["Neon|Ride"] = 798.8, ["Neon|Fly|Ride"] = 763.72, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 682.5, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2889.68, ["Neon|Fly|Ride"] = 3000.11, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 23.36, ["Ride"] = 42, ["Fly|Ride"] = 110.25, ["Neon"] = 78.08, ["Neon|Fly"] = 280.53, ["Neon|Ride"] = 107.35, ["Neon|Fly|Ride"] = 271.09, ["Mega"] = 354.38, ["Mega|Ride"] = 358.74, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3465, ["Fly"] = 3543.75, ["Ride"] = 3924.38, ["Fly|Ride"] = 3116.42, ["Neon"] = 13759.32, ["Neon|Fly|Ride"] = 6825, ["Mega|Fly|Ride"] = 24516.98}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 98.44, ["Fly"] = 166.28, ["Ride"] = 128.64, ["Fly|Ride"] = 161.34, ["Neon"] = 550.97, ["Neon|Ride"] = 551.11, ["Neon|Fly|Ride"] = 551.11, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.52, ["Fly"] = 27.32, ["Ride"] = 19.74, ["Fly|Ride"] = 44.1, ["Neon"] = 22.19, ["Neon|Fly"] = 62.34, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 148.38, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 22.6, ["Fly|Ride"] = 58.44, ["Neon"] = 20.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.49, ["Mega|Fly|Ride"] = 309.23}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.44, ["Ride"] = 34.56, ["Fly|Ride"] = 61.93, ["Neon|Ride"] = 378.77, ["Neon|Fly|Ride"] = 412.83, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 904.18, ["Ride"] = 1093.82, ["Fly|Ride"] = 1260, ["Neon|Fly|Ride"] = 4263.31}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6562.5, ["Fly|Ride"] = 7361.55}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.45, ["Fly"] = 35.1, ["Ride"] = 30.97, ["Fly|Ride"] = 47.06, ["Neon"] = 667.65, ["Neon|Ride"] = 275.56, ["Neon|Fly|Ride"] = 193.01, ["Mega"] = 2476.87, ["Mega|Ride"] = 963.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 18.59, ["Fly"] = 55.74, ["Ride"] = 28.82, ["Fly|Ride"] = 70.88, ["Neon"] = 89.24, ["Neon|Ride"] = 93.5, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 655.54, ["Mega|Ride"] = 596.53, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.56, ["Fly"] = 157.49, ["Ride"] = 65.52, ["Fly|Ride"] = 94.5, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 388.5, ["Mega|Fly|Ride"] = 1368.99}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 208.69, ["Ride"] = 263.13, ["Fly|Ride"] = 377.44, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1089.02, ["Mega"] = 10320.24, ["Mega|Fly|Ride"] = 3990.84}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.26, ["Ride"] = 32.68, ["Fly|Ride"] = 86.52, ["Neon"] = 18.38, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 143.75, ["Mega|Ride"] = 188.88, ["Mega|Fly|Ride"] = 304.47}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 232.47, ["Fly"] = 309.59, ["Ride"] = 225.75, ["Fly|Ride"] = 282.19, ["Neon"] = 718.62, ["Neon|Ride"] = 894.78, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.89, ["Fly"] = 55.74, ["Ride"] = 15.49, ["Fly|Ride"] = 39.35, ["Neon"] = 22.32, ["Neon|Fly"] = 123.04, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 358.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 301.77}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 231, ["Fly"] = 195.17, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10320.24, ["Mega|Ride"] = 4128.11, ["Mega|Fly|Ride"] = 4128.11}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.83, ["Fly"] = 77.89, ["Ride"] = 26.84, ["Fly|Ride"] = 68.25, ["Neon"] = 71.3, ["Neon|Fly"] = 296.91, ["Neon|Ride"] = 97.02, ["Neon|Fly|Ride"] = 156.59, ["Mega|Ride"] = 619.23, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.63, ["Fly"] = 69.15, ["Ride"] = 19.36, ["Fly|Ride"] = 59.07, ["Neon"] = 12.79, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 78.66, ["Mega|Ride"] = 94.54, ["Mega|Fly|Ride"] = 194.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.14, ["Neon|Ride"] = 41.29, ["Mega"] = 18.37, ["Mega|Ride"] = 137.49, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.65, ["Fly|Ride"] = 108.18, ["Neon"] = 6.57, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 72.96, ["Mega|Fly"] = 155795.18, ["Mega|Ride"] = 92.45, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.85, ["Fly"] = 140.23, ["Ride"] = 128.63, ["Fly|Ride"] = 176.96, ["Neon"] = 347.16, ["Neon|Fly"] = 392.23, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 373.13, ["Mega|Ride"] = 1341.65, ["Mega|Fly|Ride"] = 1123.68}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.73, ["Fly|Ride"] = 108.92, ["Neon"] = 5.15, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 109.86, ["Mega|Ride"] = 137.49, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.85, ["Ride"] = 101.07, ["Neon"] = 51.79, ["Neon|Ride"] = 259.62}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.5, ["Neon|Ride"] = 47.16, ["Mega"] = 16.7, ["Mega|Ride"] = 61.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 39.84, ["Ride"] = 15, ["Fly|Ride"] = 33.45, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 11.38, ["Neon|Fly|Ride"] = 31.85, ["Mega"] = 14.55, ["Mega|Fly"] = 38.07, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 50.65}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 12.39, ["Fly|Ride"] = 66.8, ["Neon"] = 3.76, ["Neon|Fly"] = 22.61, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 45.43, ["Mega"] = 28.5, ["Mega|Ride"] = 42.53}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 62.39, ["Mega"] = 19.69, ["Mega|Ride"] = 121.85}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 4.99, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 41.5, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 103.22}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 15.75, ["Mega|Ride"] = 90.84, ["Mega|Fly|Ride"] = 206.42}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.63, ["Fly"] = 69.15, ["Ride"] = 17.31, ["Fly|Ride"] = 70.03, ["Neon"] = 11.82, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 114.09, ["Mega|Fly"] = 344.72, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 15.75, ["Mega|Ride"] = 37.21, ["Mega|Fly|Ride"] = 185.78}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.58, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega"] = 307.56, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.72}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.83, ["Ride"] = 27.57, ["Neon"] = 15.64, ["Mega"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 551.11}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.29, ["Neon|Ride"] = 26.67, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 21.79, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.49, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 11.82, ["Neon|Ride"] = 12.39, ["Neon|Fly|Ride"] = 31.05, ["Mega"] = 13.11, ["Mega|Fly"] = 39.23, ["Mega|Ride"] = 20.35, ["Mega|Fly|Ride"] = 45.85}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.13, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 36.75, ["Neon|Ride"] = 140.94, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 6.56, ["Neon|Ride"] = 51.62, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.86, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.36, ["Neon"] = 10.02, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 97.83, ["Mega|Ride"] = 157.29, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.6, ["Fly"] = 262.49, ["Ride"] = 34.54, ["Fly|Ride"] = 43.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 167.2}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.71, ["Ride"] = 11.62, ["Fly|Ride"] = 26.28, ["Neon"] = 2.1, ["Neon|Fly"] = 11.71, ["Neon|Ride"] = 12.06, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 15.59, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 19.62, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 12.39, ["Fly|Ride"] = 138.29, ["Neon"] = 12.55, ["Neon|Ride"] = 103.22, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 91.77, ["Mega|Ride"] = 156.59, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 50.29, ["Fly"] = 112.03, ["Ride"] = 21.99, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 205.4, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 10.78, ["Ride"] = 12.22, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 39.77, ["Mega"] = 23.39, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 172.34, ["Ride"] = 30.23, ["Neon"] = 3.83, ["Neon|Ride"] = 26.63, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 81.81, ["Mega|Fly"] = 165.14, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 240.72}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.33, ["Fly|Ride"] = 65.63, ["Neon"] = 5.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 32.82, ["Mega|Fly"] = 138.3, ["Mega|Ride"] = 138.3, ["Mega|Fly|Ride"] = 304.47}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.65, ["Ride"] = 27.56, ["Fly|Ride"] = 97, ["Neon"] = 2.39, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 15.39, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 97, ["Ride"] = 22.73, ["Fly|Ride"] = 41.91, ["Neon"] = 4.94, ["Neon|Fly"] = 55.75, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 65.01, ["Mega|Ride"] = 78.3, ["Mega|Fly|Ride"] = 206.42}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.24, ["Neon"] = 5.2, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 35.6, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.39, ["Fly|Ride"] = 47.24, ["Neon"] = 5.25, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 338.09}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.72, ["Fly"] = 40.74, ["Ride"] = 39.38, ["Neon"] = 38.99, ["Neon|Ride"] = 74.32, ["Mega"] = 98.18, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 17.49, ["Fly|Ride"] = 138.29, ["Neon"] = 19.62, ["Neon|Fly"] = 104.64, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 203.33, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.41, ["Fly"] = 22.73, ["Ride"] = 19.69, ["Fly|Ride"] = 40.68, ["Neon"] = 23.62, ["Neon|Fly"] = 33.87, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.4, ["Mega"] = 274.34, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 233.71}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 138.29, ["Neon"] = 23.35, ["Neon|Ride"] = 101.67, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.3, ["Ride"] = 56.44, ["Neon"] = 123.84, ["Neon|Ride"] = 233.71, ["Mega"] = 551.11, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 5.25, ["Ride"] = 53.67, ["Fly|Ride"] = 104.71, ["Neon"] = 39.1, ["Neon|Ride"] = 125.71, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 253.32, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.13, ["Ride"] = 29.19, ["Fly|Ride"] = 120.75, ["Neon"] = 43.81, ["Neon|Ride"] = 102.19, ["Neon|Fly|Ride"] = 179.59, ["Mega"] = 246.67, ["Mega|Ride"] = 287.95, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 64.99, ["Mega"] = 20.9, ["Mega|Fly"] = 123.86, ["Mega|Ride"] = 123.86, ["Mega|Fly|Ride"] = 152.76}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.34}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.82, ["Fly"] = 22.91, ["Ride"] = 20.66, ["Fly|Ride"] = 54.51, ["Neon"] = 45.84, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 109.86, ["Mega"] = 374.32, ["Mega|Ride"] = 344.72, ["Mega|Fly|Ride"] = 305.75}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 92.89, ["Ride"] = 19.56, ["Neon"] = 5.25, ["Neon|Fly"] = 31.58, ["Neon|Ride"] = 26.72, ["Mega"] = 30.52, ["Mega|Fly"] = 138.3, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 32.74, ["Neon"] = 3.68, ["Neon|Ride"] = 31.57, ["Neon|Fly|Ride"] = 98, ["Mega"] = 77.43, ["Mega|Ride"] = 73.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.45, ["Ride"] = 15.69, ["Fly|Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Ride"] = 55.75, ["Neon|Fly|Ride"] = 123.12, ["Mega"] = 123.86, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.82, ["Ride"] = 49.54, ["Fly|Ride"] = 63.11, ["Neon"] = 35.04, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.13, ["Mega|Ride"] = 275.45, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.62, ["Ride"] = 32.81, ["Neon"] = 2.62, ["Mega"] = 19.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.74, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.65, ["Ride"] = 15.94, ["Fly|Ride"] = 275172.55, ["Neon"] = 6.56, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 86.48, ["Mega"] = 23.51, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 72.72, ["Mega|Fly|Ride"] = 138.17}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 14.69, ["Fly|Ride"] = 65.02, ["Neon"] = 9.09, ["Neon|Fly"] = 26.85, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.95, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 138.3}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 31.5, ["Fly|Ride"] = 148.41, ["Neon"] = 5.22, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 110.77, ["Mega"] = 27.57, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 208.6}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Neon|Ride"] = 164.42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.48, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 149.2}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.55, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 76.76, ["Mega"] = 17.07, ["Mega|Fly"] = 61.94, ["Mega|Ride"] = 42.94, ["Mega|Fly|Ride"] = 114.53}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.51, ["Neon"] = 2.63, ["Mega"] = 656.25, ["Mega|Ride"] = 225.65}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.26, ["Neon"] = 4.96, ["Neon|Ride"] = 156.59, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.08, ["Mega|Ride"] = 156.35, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.15, ["Fly|Ride"] = 49.88, ["Neon"] = 12.77, ["Neon|Fly"] = 55.75, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 90.7, ["Mega|Fly"] = 61.94, ["Mega|Ride"] = 93.58, ["Mega|Fly|Ride"] = 93.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.89, ["Ride"] = 139.53, ["Neon"] = 170.63, ["Mega"] = 1032.04, ["Mega|Ride"] = 549.05, ["Mega|Fly|Ride"] = 510.87}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.63, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 58.44, ["Neon|Ride"] = 204.36, ["Mega"] = 1572.81, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.94, ["Ride"] = 30.18, ["Fly|Ride"] = 410.17, ["Neon"] = 39.23, ["Neon|Fly|Ride"] = 262.15, ["Mega"] = 265.27, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 404.15}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 11.67, ["Fly|Ride"] = 22.72, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 12.39, ["Neon|Fly|Ride"] = 27.75, ["Mega"] = 16.66, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 18.59, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.8, ["Fly|Ride"] = 110.42, ["Neon"] = 8.27, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 688.38, ["Mega"] = 85.31, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 55.55, ["Mega"] = 13.13, ["Mega|Fly"] = 86.59, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 117.5}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 117.67, ["Mega"] = 16.41, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 162.02}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.73, ["Ride"] = 15.66, ["Fly|Ride"] = 42.69, ["Neon"] = 8.71, ["Neon|Ride"] = 37.84, ["Neon|Fly|Ride"] = 90.96, ["Mega"] = 208.85, ["Mega|Ride"] = 206.42, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 168, ["Ride"] = 206.39, ["Fly|Ride"] = 177.19, ["Neon|Ride"] = 1651.26, ["Neon|Fly|Ride"] = 1101.19, ["Mega"] = 8256.21, ["Mega|Fly|Ride"] = 3573.91}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 19.62, ["Neon"] = 6.57, ["Neon|Ride"] = 82.58, ["Mega"] = 85.32, ["Mega|Ride"] = 125.05, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.23, ["Fly"] = 63.67, ["Ride"] = 25.57, ["Fly|Ride"] = 63.11, ["Neon"] = 31.56, ["Neon|Ride"] = 93.5, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 408.7}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.01, ["Ride"] = 12.39, ["Fly|Ride"] = 32.13, ["Neon"] = 5.24, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.68, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.57, ["Neon"] = 6.13, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.47, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.86, ["Fly"] = 18.29, ["Ride"] = 16.53, ["Fly|Ride"] = 35.44, ["Neon"] = 34.04, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 262.15, ["Mega|Ride"] = 271.44, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.6, ["Ride"] = 34.31, ["Fly|Ride"] = 249.58, ["Neon"] = 55.17, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 613.04, ["Mega"] = 516.03, ["Mega|Ride"] = 255.64, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.41, ["Ride"] = 15.41, ["Fly|Ride"] = 34.55, ["Neon"] = 17.39, ["Neon|Fly"] = 75.95, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 157.5, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 69.57, ["Fly"] = 178.5, ["Ride"] = 93.19, ["Fly|Ride"] = 157.5, ["Neon"] = 360.61, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 370.58}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 330.23, ["Ride"] = 248.79, ["Fly|Ride"] = 303.83, ["Neon|Ride"] = 2580.08, ["Neon|Fly|Ride"] = 1232.65, ["Mega"] = 10320.24, ["Mega|Fly|Ride"] = 4651.35}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.75, ["Fly"] = 125.12, ["Ride"] = 78.3, ["Fly|Ride"] = 110.25, ["Neon"] = 392.14, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 412.83, ["Mega|Ride"] = 1323.07, ["Mega|Fly|Ride"] = 1387.22}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.63, ["Fly"] = 26.17, ["Ride"] = 26.84, ["Fly|Ride"] = 138.29, ["Neon"] = 33.29, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 262.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.24, ["Fly"] = 69.15, ["Ride"] = 27.72, ["Fly|Ride"] = 90.83, ["Neon"] = 52.41, ["Neon|Ride"] = 123.86, ["Mega"] = 353.07, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 823.57}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 12.31, ["Ride"] = 17.82, ["Fly|Ride"] = 34.93, ["Neon"] = 4.17, ["Neon|Fly"] = 25.73, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 61.94, ["Mega"] = 114.6, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 176.49}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.24, ["Fly"] = 72.12, ["Ride"] = 20.9, ["Fly|Ride"] = 309.03, ["Neon"] = 97.82, ["Neon|Ride"] = 82.58, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 607.61}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 16.53, ["Ride"] = 16.41, ["Fly|Ride"] = 36.11, ["Neon"] = 19.68, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 112.56, ["Mega|Ride"] = 204.88, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.07, ["Ride"] = 16.53, ["Fly|Ride"] = 328.13, ["Neon"] = 22.28, ["Neon|Ride"] = 61.53, ["Mega"] = 200.23, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.68}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 53.68, ["Mega"] = 14.68, ["Mega|Ride"] = 27.88, ["Mega|Fly|Ride"] = 78.3}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.52, ["Fly"] = 18.27, ["Ride"] = 18.05, ["Fly|Ride"] = 55.74, ["Neon"] = 14.22, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 30.39, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 100.85, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.87, ["Fly"] = 24.94, ["Ride"] = 18.5, ["Fly|Ride"] = 59.07, ["Neon"] = 35.1, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 551.11, ["Mega"] = 262.15, ["Mega|Ride"] = 193.01, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 161.13, ["Fly"] = 234.25, ["Ride"] = 262.99, ["Fly|Ride"] = 276.56, ["Neon"] = 685.21, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 722.44, ["Mega"] = 4128.11, ["Mega|Fly|Ride"] = 2752.42}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.88, ["Ride"] = 31.8, ["Fly|Ride"] = 125.05, ["Neon"] = 49.88, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 262.5, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 16.53, ["Fly|Ride"] = 45.34, ["Neon"] = 21, ["Neon|Ride"] = 25.65, ["Neon|Fly|Ride"] = 105.28, ["Mega"] = 233.71, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.63, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 125.05, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 551.25, ["Mega|Fly"] = 825.64, ["Mega|Ride"] = 521.07, ["Mega|Fly|Ride"] = 642.44}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 10.49}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.85, ["Ride"] = 28.5, ["Neon"] = 24.21, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 619.23, ["Mega"] = 825.64, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 894.78}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.58, ["Fly"] = 27.88, ["Ride"] = 35.1, ["Fly|Ride"] = 59.07, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 2064.06, ["Mega|Fly|Ride"] = 1927.84}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 24.77, ["Fly|Ride"] = 103.2, ["Neon"] = 3.89, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 28.88, ["Mega|Fly"] = 275.56, ["Mega|Ride"] = 121.79, ["Mega|Fly|Ride"] = 227.11}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 15.22, ["Fly"] = 27.88, ["Ride"] = 15.67, ["Fly|Ride"] = 61.93, ["Neon"] = 45.55, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 233.71, ["Mega"] = 233.21, ["Mega|Fly"] = 390.29, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 341.61}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.95, ["Fly|Ride"] = 40.69, ["Neon"] = 13.15, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 174.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.79}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 36.14, ["Fly|Ride"] = 38.07, ["Neon"] = 3.94, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 412.83, ["Mega"] = 31.5, ["Mega|Ride"] = 53.76, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 32.45, ["Ride"] = 78.66, ["Fly|Ride"] = 525, ["Neon"] = 131.25, ["Neon|Fly|Ride"] = 806.26, ["Mega"] = 799.99, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 8.27, ["Ride"] = 45.94, ["Fly|Ride"] = 210, ["Neon"] = 83.61, ["Neon|Ride"] = 116.86, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.48, ["Fly"] = 210, ["Ride"] = 21.46, ["Fly|Ride"] = 69.12, ["Neon"] = 27.74, ["Neon|Fly"] = 467.55, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 107.58, ["Mega"] = 344.72, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.12, ["Ride"] = 179.57, ["Fly|Ride"] = 262.44, ["Neon"] = 315, ["Neon|Ride"] = 536.67, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1836.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.64, ["Fly"] = 26.17, ["Ride"] = 28.87, ["Fly|Ride"] = 63.11, ["Neon"] = 76.39, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 216.57, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 504.73}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.1, ["Fly"] = 186.38, ["Ride"] = 112.88, ["Neon"] = 236.91, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 407.66, ["Mega"] = 1062.99, ["Mega|Ride"] = 1238.45, ["Mega|Fly|Ride"] = 958.76}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 46.66, ["Ride"] = 72.19, ["Fly|Ride"] = 173.37, ["Neon"] = 87.1, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 470.96, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.51, ["Ride"] = 27.55, ["Fly|Ride"] = 68.65, ["Neon"] = 11.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 250.07, ["Mega"] = 206.42, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.57, ["Ride"] = 47.16, ["Fly|Ride"] = 275.54, ["Neon"] = 61.69, ["Neon|Ride"] = 139.11, ["Neon|Fly|Ride"] = 307.56, ["Mega"] = 256.14, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 17.43, ["Ride"] = 30.45, ["Fly|Ride"] = 55.73, ["Neon"] = 44.38, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 236.25, ["Mega|Ride"] = 275.56, ["Mega|Fly|Ride"] = 385.98}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2, ["Mega"] = 18.52, ["Mega|Ride"] = 123.86, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.24, ["Ride"] = 28.25, ["Neon"] = 17.91, ["Neon|Fly"] = 123.87, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.5, ["Mega|Ride"] = 206.42, ["Mega|Fly|Ride"] = 469.74}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 25.82, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.16, ["Ride"] = 32.79, ["Fly|Ride"] = 116.87, ["Neon"] = 20.66, ["Neon|Ride"] = 82.95, ["Mega"] = 200.23, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 541.14, ["Ride"] = 573.57, ["Fly|Ride"] = 682.5, ["Neon"] = 1789.32, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1806.17, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7, ["Fly"] = 27.88, ["Ride"] = 19.69, ["Fly|Ride"] = 63.11, ["Neon"] = 36.14, ["Neon|Ride"] = 89.8, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 156.59, ["Mega|Ride"] = 355.72, ["Mega|Fly|Ride"] = 486.09}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 19.69, ["Fly"] = 524.69, ["Ride"] = 25.01, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 103.23, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 330.75, ["Mega|Ride"] = 280.26, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.92, ["Fly"] = 91.88, ["Ride"] = 15.39, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 196.88, ["Mega"] = 265.27, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 23.63, ["Fly|Ride"] = 88.75, ["Neon"] = 7.54, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 92.14, ["Mega"] = 59.06, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 251.84}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.15, ["Ride"] = 19.69, ["Neon"] = 3.82, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 90.96, ["Mega"] = 33.91, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 9.86, ["Ride"] = 55.74, ["Fly|Ride"] = 323.64, ["Neon"] = 84.15, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 275.56, ["Mega|Ride"] = 548.02, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 25.1, ["Neon"] = 5.1, ["Neon|Ride"] = 41.29, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 165.14, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 6.9, ["Fly"] = 27.57, ["Ride"] = 58.97, ["Fly|Ride"] = 99.75, ["Neon"] = 15.4, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 55.75, ["Neon|Fly|Ride"] = 156.59, ["Mega"] = 183.73, ["Mega|Ride"] = 275.56, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.84, ["Ride"] = 523.69, ["Fly|Ride"] = 467.42, ["Neon|Ride"] = 1902.58, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 8118.95}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 31.48, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 412.77, ["Neon"] = 51.22, ["Neon|Ride"] = 76.38, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 481.98, ["Mega|Ride"] = 444.03}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 81.97, ["Ride"] = 32.01, ["Fly|Ride"] = 163.06, ["Neon"] = 5.25, ["Neon|Ride"] = 25.87, ["Neon|Fly|Ride"] = 104.49, ["Mega"] = 58.84, ["Mega|Ride"] = 76.01, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 25.72, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 275.37}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.39, ["Fly"] = 107.63, ["Ride"] = 68.84, ["Fly|Ride"] = 191.96, ["Neon"] = 120.7, ["Neon|Ride"] = 95.51, ["Neon|Fly|Ride"] = 186.97, ["Mega"] = 469.59, ["Mega|Ride"] = 536.67, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.37, ["Neon"] = 138.29, ["Neon|Ride"] = 123.86, ["Neon|Fly|Ride"] = 825.64, ["Mega"] = 474.75, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1101.19}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.84, ["Ride"] = 31.38, ["Fly|Ride"] = 412.77, ["Neon"] = 311.25, ["Neon|Ride"] = 174.7, ["Mega"] = 639.16, ["Mega|Ride"] = 619.23, ["Mega|Fly|Ride"] = 688.38}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.69, ["Ride"] = 22.67, ["Fly|Ride"] = 262.5, ["Neon"] = 656.25, ["Neon|Ride"] = 182.43, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 610.32, ["Mega|Ride"] = 646.42, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 485.63, ["Fly|Ride"] = 688.28, ["Neon"] = 1031.91, ["Neon|Ride"] = 1376.91, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.25, ["Fly"] = 69.65, ["Ride"] = 22.73, ["Fly|Ride"] = 236.25, ["Neon"] = 117.29, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 187.46, ["Mega|Ride"] = 551.11, ["Mega|Fly|Ride"] = 849.36}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Fly|Ride"] = 127.32, ["Neon"] = 38.87, ["Neon|Ride"] = 105, ["Mega"] = 218.8, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.32, ["Ride"] = 70.88, ["Fly|Ride"] = 258.26, ["Neon"] = 85.32, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 272.35, ["Mega|Fly"] = 688.38, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 377.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 138.29, ["Neon"] = 8.34, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 47.79, ["Mega|Ride"] = 97.02, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.78, ["Ride"] = 73.5, ["Neon"] = 315.77, ["Neon|Ride"] = 350.9, ["Mega"] = 1514, ["Mega|Ride"] = 1362.29, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 584.27, ["Ride"] = 25.16, ["Fly|Ride"] = 60.36, ["Neon"] = 9.72, ["Neon|Fly"] = 179.62, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 74.32, ["Mega|Ride"] = 108.84, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 36.23, ["Ride"] = 27.97, ["Fly|Ride"] = 152.81, ["Neon"] = 4.88, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 41.93, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 32.7, ["Mega|Fly"] = 111.75, ["Mega|Ride"] = 73.4, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.56, ["Fly|Ride"] = 123.87, ["Neon"] = 15.49, ["Neon|Ride"] = 59.4, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 51.1, ["Fly"] = 93.5, ["Ride"] = 65.63, ["Fly|Ride"] = 195.16, ["Neon"] = 291.38, ["Neon|Ride"] = 288.51, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 252, ["Ride"] = 271.53, ["Fly|Ride"] = 420, ["Neon"] = 1434.35, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1278.97, ["Mega"] = 6192.16, ["Mega|Fly|Ride"] = 3963.75}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.22, ["Neon"] = 36.7, ["Mega"] = 99.75, ["Mega|Ride"] = 222.94}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 69.15, ["Ride"] = 27.57, ["Neon"] = 7.29, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 179.59, ["Mega"] = 56.11, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 344.72}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.13, ["Fly"] = 30.41, ["Ride"] = 27.56, ["Neon"] = 32.81, ["Neon|Ride"] = 69.17, ["Mega"] = 206.73, ["Mega|Ride"] = 348.23, ["Mega|Fly|Ride"] = 390.29}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.9, ["Fly"] = 66.54, ["Ride"] = 63.99, ["Neon"] = 10.28, ["Neon|Ride"] = 35.04, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 105, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Neon"] = 7.63, ["Mega"] = 38.83, ["Mega|Fly|Ride"] = 272.47}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 6.57, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 132.57, ["Mega"] = 38.9, ["Mega|Ride"] = 100.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.61, ["Ride"] = 15.75, ["Fly|Ride"] = 37.41, ["Neon"] = 16.54, ["Neon|Fly"] = 63.67, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 93.28, ["Mega"] = 102.19, ["Mega|Ride"] = 233.25, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 138.69, ["Ride"] = 52.64, ["Fly|Ride"] = 77.15, ["Neon"] = 137.69, ["Neon|Ride"] = 152.76, ["Neon|Fly|Ride"] = 262.15, ["Mega"] = 1135.24, ["Mega|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 77.09, ["Fly"] = 110.42, ["Ride"] = 93.5, ["Fly|Ride"] = 116.29, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 504.96, ["Neon|Fly|Ride"] = 458.68, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 3.49, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 49.26, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.5, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 5.2, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 61.41, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.48, ["Fly"] = 41.29, ["Ride"] = 73.48, ["Neon"] = 51.42, ["Neon|Ride"] = 70.13, ["Neon|Fly|Ride"] = 274.54, ["Mega"] = 527.63, ["Mega|Ride"] = 481.98, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 492.19, ["Neon"] = 4127.6, ["Neon|Ride"] = 1927.84, ["Mega|Fly|Ride"] = 7224.18}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.34, ["Fly"] = 15.75, ["Fly|Ride"] = 116.62, ["Neon"] = 165.13, ["Neon|Ride"] = 189.36, ["Neon|Fly|Ride"] = 291.38, ["Mega|Ride"] = 1138.09}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 34.91, ["Fly|Ride"] = 281.29, ["Neon"] = 9.19, ["Neon|Ride"] = 42.53, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 85.32, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 263.45}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 206.39, ["Ride"] = 26.25, ["Fly|Ride"] = 142.7, ["Neon"] = 16.31, ["Mega|Ride"] = 399.41}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.88, ["Fly"] = 160.97, ["Ride"] = 43.32, ["Fly|Ride"] = 89.79, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2476.87, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1357.13}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.93, ["Ride"] = 105, ["Fly|Ride"] = 179.57, ["Neon"] = 434.43, ["Neon|Ride"] = 468.56, ["Neon|Fly|Ride"] = 467.4, ["Mega"] = 8256.21, ["Mega|Fly|Ride"] = 2057.87}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 194.88, ["Fly"] = 280.45, ["Ride"] = 284.82, ["Fly|Ride"] = 705.83, ["Neon"] = 1050, ["Neon|Ride"] = 894.89, ["Neon|Fly|Ride"] = 985.6, ["Mega|Fly|Ride"] = 4664.77}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 15.65, ["Fly"] = 51.19, ["Ride"] = 43.53, ["Fly|Ride"] = 150.94, ["Neon"] = 81.38, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 388.49, ["Mega|Ride"] = 388.44, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.63, ["Fly"] = 18.69, ["Ride"] = 18.38, ["Fly|Ride"] = 41.9, ["Neon"] = 10.34, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 91.11, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.83, ["Fly"] = 37.94, ["Ride"] = 12.39, ["Fly|Ride"] = 43.35, ["Neon"] = 41.58, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 93, ["Mega"] = 344.72, ["Mega|Ride"] = 328.19, ["Mega|Fly|Ride"] = 355.03}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 302.05, ["Fly"] = 482.03, ["Ride"] = 262.5, ["Fly|Ride"] = 610.89, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega"] = 9907.44, ["Mega|Fly|Ride"] = 5917.64}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 59.87, ["Neon"] = 15.49, ["Neon|Ride"] = 69.17, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 44.39, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 7.88, ["Ride"] = 12.39, ["Fly|Ride"] = 40.51, ["Neon"] = 26.24, ["Neon|Ride"] = 31.46, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 204.36, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 245.64}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 16.7, ["Ride"] = 135.7, ["Neon"] = 130.6, ["Neon|Fly"] = 412.88, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 296.8, ["Mega"] = 527.69, ["Mega|Ride"] = 613.04, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 138.33, ["Fly"] = 157.5, ["Ride"] = 110.42, ["Fly|Ride"] = 127.32, ["Neon"] = 262.5, ["Neon|Ride"] = 701.1, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 32.51, ["Fly"] = 35.1, ["Ride"] = 27.88, ["Fly|Ride"] = 66.06, ["Neon"] = 103.69, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 123.86, ["Mega"] = 687.35, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 521.07}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.41, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 688.38, ["Mega"] = 21.45, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.64, ["Fly|Ride"] = 72.19, ["Neon"] = 2.1, ["Neon|Ride"] = 19.28, ["Neon|Fly|Ride"] = 71.81, ["Mega"] = 23.39, ["Mega|Fly"] = 79.08, ["Mega|Ride"] = 48.09, ["Mega|Fly|Ride"] = 103.55}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.11, ["Fly"] = 412.77, ["Ride"] = 89.79, ["Fly|Ride"] = 129.29, ["Neon"] = 39.27, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 186.97, ["Mega"] = 143.29, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1418.79, ["Fly"] = 1612.55, ["Ride"] = 1271.82, ["Fly|Ride"] = 1364.99, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12475.32}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.24, ["Ride"] = 531.87, ["Fly|Ride"] = 605.07, ["Neon"] = 2422.91, ["Neon|Ride"] = 2005.4, ["Neon|Fly|Ride"] = 2050.64, ["Mega"] = 16512.39, ["Mega|Fly|Ride"] = 9357.37}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 320.25, ["Ride"] = 378, ["Fly|Ride"] = 472.5, ["Neon"] = 784.26, ["Neon|Ride"] = 779.64, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2362.4}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 369.44, ["Fly"] = 336, ["Ride"] = 365.88, ["Fly|Ride"] = 453.25, ["Neon"] = 925.32, ["Neon|Fly"] = 1376.91, ["Neon|Ride"] = 1100.28, ["Neon|Fly|Ride"] = 1091.36, ["Mega|Fly|Ride"] = 4640}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 15.65, ["Fly|Ride"] = 33, ["Neon"] = 5.97, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 75.81, ["Mega|Ride"] = 136.24, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 354.38, ["Fly"] = 1376.55, ["Ride"] = 444.04, ["Fly|Ride"] = 549.94, ["Neon"] = 1706.24, ["Neon|Ride"] = 1296.09, ["Neon|Fly|Ride"] = 1383.76, ["Mega|Ride"] = 6604.97, ["Mega|Fly|Ride"] = 4803.8}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.42, ["Fly"] = 183.75, ["Ride"] = 85.32, ["Fly|Ride"] = 46.75, ["Neon"] = 15.39, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 83.91, ["Mega|Ride"] = 183.35, ["Mega|Fly|Ride"] = 369.64}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.2, ["Ride"] = 17.36, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 110.42, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 39.37, ["Mega"] = 28.27, ["Mega|Ride"] = 173.78}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.43, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 351.29, ["Mega"] = 656.25, ["Mega|Ride"] = 934.79, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7794.66, ["Ride"] = 25.99, ["Fly|Ride"] = 67.57, ["Neon"] = 32.48, ["Mega|Ride"] = 425.34, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.29, ["Neon|Ride"] = 38.31, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 20.53, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 121.79}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.65, ["Fly"] = 36.01, ["Ride"] = 19.61, ["Fly|Ride"] = 66.89, ["Neon"] = 12.39, ["Neon|Fly"] = 97.04, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 110.97, ["Mega|Fly"] = 172.37, ["Mega|Ride"] = 118.97, ["Mega|Fly|Ride"] = 181}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.82, ["Fly"] = 55.74, ["Ride"] = 15.49, ["Fly|Ride"] = 51.97, ["Neon"] = 19.69, ["Neon|Fly"] = 117.68, ["Neon|Ride"] = 156.59, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 328.19}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.91, ["Ride"] = 39.38, ["Neon"] = 62.75, ["Mega"] = 507.12, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.46, ["Fly"] = 6232.82, ["Ride"] = 41.29, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 99.07, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 6.09, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 55.75, ["Mega"] = 58.84, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 152.25, ["Ride"] = 178.5, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 951.46, ["Neon|Fly|Ride"] = 981.52, ["Mega"] = 8256.21, ["Mega|Ride"] = 4128.11, ["Mega|Fly|Ride"] = 4114.7}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.88, ["Fly|Ride"] = 34.96, ["Neon"] = 4.18, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 53.8, ["Mega"] = 36.66, ["Mega|Ride"] = 52.64, ["Mega|Fly|Ride"] = 121.79}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 134.8, ["Fly"] = 138.29, ["Ride"] = 69.15, ["Fly|Ride"] = 160.12, ["Neon"] = 152.74, ["Neon|Ride"] = 152.76, ["Mega"] = 412.83, ["Mega|Ride"] = 467.4, ["Mega|Fly|Ride"] = 1032.04}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.24, ["Ride"] = 206.39, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 412.83, ["Mega"] = 786.19, ["Mega|Ride"] = 911.42}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 194.25, ["Ride"] = 253.45, ["Fly|Ride"] = 309.78, ["Neon"] = 708.74, ["Neon|Ride"] = 809.23, ["Neon|Fly|Ride"] = 912.99, ["Mega|Fly|Ride"] = 3356.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.74, ["Fly|Ride"] = 140.23, ["Neon"] = 156.6, ["Neon|Ride"] = 145.34, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1238.45}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 9.19, ["Ride"] = 138.29, ["Fly|Ride"] = 619.16, ["Neon"] = 39.24, ["Neon|Fly"] = 156.64, ["Neon|Ride"] = 199.5, ["Mega"] = 771.75, ["Mega|Ride"] = 619.23, ["Mega|Fly|Ride"] = 1155.88}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1448.13, ["Ride"] = 1158.98, ["Fly|Ride"] = 1154.99, ["Neon"] = 4678.63, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4644.12, ["Mega|Fly|Ride"] = 17992.31}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.77, ["Fly"] = 30.41, ["Ride"] = 19.82, ["Fly|Ride"] = 52.5, ["Neon"] = 26.24, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 82.58, ["Mega"] = 233.71, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.97, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 35.77, ["Neon|Ride"] = 77.42, ["Mega"] = 244.62, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.85, ["Mega|Fly|Ride"] = 585.18}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.54, ["Ride"] = 27.3, ["Fly|Ride"] = 69.57, ["Neon"] = 20.35, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 91.88, ["Mega|Ride"] = 189.57, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.55, ["Fly"] = 35.07, ["Ride"] = 37, ["Fly|Ride"] = 80.27, ["Neon"] = 77.4, ["Neon|Ride"] = 76.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 342.57, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 5.25, ["Fly"] = 20.55, ["Ride"] = 16.53, ["Fly|Ride"] = 40.84, ["Neon"] = 20.66, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 30.98, ["Neon|Fly|Ride"] = 93.17, ["Mega|Ride"] = 311.99, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.63, ["Ride"] = 101.35, ["Neon"] = 16.53, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 54.32, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 131.15, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 208.69, ["Fly"] = 262.18, ["Ride"] = 229.69, ["Fly|Ride"] = 344.67, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 27.88, ["Fly|Ride"] = 72.19, ["Neon"] = 19.69, ["Neon|Fly"] = 82.59, ["Neon|Ride"] = 27.08, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 84, ["Mega|Fly"] = 412.83, ["Mega|Ride"] = 127.36, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 245.64, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.63, ["Fly"] = 96.95, ["Ride"] = 26.23, ["Neon"] = 12.62, ["Neon|Ride"] = 1376.91, ["Mega"] = 94.5, ["Mega|Fly"] = 138.3, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 292.29, ["Ride"] = 584.27, ["Fly|Ride"] = 701.12, ["Neon"] = 1050, ["Neon|Fly"] = 1238.61, ["Neon|Ride"] = 1170.33, ["Mega"] = 4673.85, ["Mega|Ride"] = 3428.28, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.23, ["Fly"] = 111.02, ["Ride"] = 46.75, ["Fly|Ride"] = 165.13, ["Neon"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 623.98, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.77, ["Fly"] = 74.81, ["Ride"] = 36.75, ["Fly|Ride"] = 89.25, ["Neon"] = 91.88, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 516.03, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 674.96}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.57, ["Neon"] = 3.54, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 129.93, ["Mega"] = 45.92, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 237.38}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 49.24, ["Fly"] = 5842.52, ["Ride"] = 86.21, ["Fly|Ride"] = 170.63, ["Neon"] = 196.88, ["Neon|Fly"] = 233.56, ["Neon|Ride"] = 294.16, ["Neon|Fly|Ride"] = 343.18, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Fly|Ride"] = 52.5, ["Neon"] = 6.46, ["Neon|Ride"] = 55.75, ["Neon|Fly|Ride"] = 122.82, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.39, ["Fly"] = 103.2, ["Ride"] = 27.88, ["Fly|Ride"] = 82.57, ["Neon"] = 93.5, ["Neon|Ride"] = 155.67, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 389.82, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 411.79, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.61, ["Fly"] = 95.84, ["Ride"] = 79.95, ["Fly|Ride"] = 154.37, ["Neon"] = 315.77, ["Neon|Ride"] = 257.28, ["Neon|Fly|Ride"] = 355.23, ["Mega"] = 1238.45, ["Mega|Ride"] = 3441.82, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 12.39, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 12.39, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 17.89, ["Mega|Fly"] = 116.86, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.85, ["Fly"] = 32.82, ["Ride"] = 39.29, ["Fly|Ride"] = 130.04, ["Neon"] = 16.89, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 129.94, ["Mega|Ride"] = 272.08, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.12, ["Ride"] = 46.64, ["Fly|Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 140.23, ["Mega"] = 1032.04, ["Mega|Ride"] = 553.87}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.84, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 18.17, ["Mega|Ride"] = 79.23, ["Mega|Fly|Ride"] = 210.55}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.62, ["Fly"] = 210, ["Ride"] = 58.7, ["Fly|Ride"] = 138.29, ["Neon"] = 64.85, ["Neon|Ride"] = 107.93, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 496.71, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 598.59}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.84, ["Fly"] = 103.69, ["Ride"] = 16.53, ["Fly|Ride"] = 98.43, ["Neon"] = 430.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 172.95, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 437.01}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.75, ["Ride"] = 18.86, ["Neon"] = 25.9, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.43, ["Mega"] = 231, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 15.6, ["Fly"] = 2063.81, ["Fly|Ride"] = 248.49, ["Neon"] = 60.09, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6231.4, ["Mega|Ride"] = 567, ["Mega|Fly|Ride"] = 592.39}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.3, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 11.82, ["Neon|Fly"] = 55.75, ["Neon|Ride"] = 32.43, ["Mega"] = 68.16, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 152.76}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.85, ["Neon|Ride"] = 100.09, ["Mega"] = 31.49, ["Mega|Ride"] = 138.3, ["Mega|Fly|Ride"] = 267.31}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 77.95}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 42, ["Fly"] = 78.75, ["Ride"] = 53.76, ["Neon|Ride"] = 263.7, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1238.45, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.65, ["Neon|Fly|Ride"] = 123.86, ["Mega"] = 22.2, ["Mega|Ride"] = 275.56, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 417.38, ["Ride"] = 577.5, ["Fly|Ride"] = 641.82, ["Neon"] = 2059.67, ["Neon|Ride"] = 1869.55, ["Mega"] = 16512.39, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.52, ["Fly"] = 26.17, ["Ride"] = 24.19, ["Fly|Ride"] = 66.26, ["Neon"] = 27.42, ["Neon|Ride"] = 275.56, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 87.71, ["Mega|Fly"] = 154.83, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 551.11}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.62, ["Fly"] = 95.55, ["Ride"] = 22.23, ["Fly|Ride"] = 68.25, ["Neon"] = 18.4, ["Neon|Ride"] = 35.19, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 345.19, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 56.95, ["Fly"] = 77.41, ["Ride"] = 65.02, ["Fly|Ride"] = 68.86, ["Neon"] = 126, ["Neon|Ride"] = 172.37, ["Mega"] = 809.12, ["Mega|Ride"] = 623.98, ["Mega|Fly|Ride"] = 820.47}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.12, ["Fly"] = 412.77, ["Ride"] = 38.07, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.59, ["Fly"] = 139.53, ["Ride"] = 138.29, ["Fly|Ride"] = 157.5, ["Neon"] = 103.2, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 359.28, ["Mega"] = 378.07, ["Mega|Ride"] = 390.29, ["Mega|Fly|Ride"] = 633.68}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.02, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 32.9, ["Neon|Ride"] = 156.64, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 216.57, ["Mega|Fly"] = 551.11, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 338.26}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.75, ["Ride"] = 11.23, ["Fly|Ride"] = 68.25, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 13.89, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.86, ["Mega|Fly"] = 32.21, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 78.3}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 11.79, ["Fly"] = 110.42, ["Ride"] = 27.88, ["Fly|Ride"] = 103.2, ["Neon"] = 40.32, ["Neon|Fly"] = 116.89, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 103.22, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.83, ["Fly"] = 408.99, ["Ride"] = 332.07, ["Fly|Ride"] = 421.32, ["Neon"] = 1246.82, ["Neon|Ride"] = 1376.74, ["Neon|Fly|Ride"] = 1252.12, ["Mega"] = 4374.57, ["Mega|Ride"] = 4437.71, ["Mega|Fly|Ride"] = 4527.51}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 101.99, ["Ride"] = 137.89, ["Fly|Ride"] = 296.81, ["Neon"] = 315, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 543.27, ["Mega"] = 2202.36, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1514.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 14.34, ["Fly|Ride"] = 40.43, ["Neon"] = 9.12, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 205.4, ["Mega|Ride"] = 156.59, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.04, ["Ride"] = 12.39, ["Fly|Ride"] = 32.81, ["Neon"] = 5.25, ["Neon|Fly"] = 51.35, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 59.13, ["Mega"] = 69.17, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 98.44, ["Neon"] = 39.23, ["Mega"] = 206.42, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 239, ["Fly"] = 420, ["Ride"] = 315, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 2054.58, ["Neon|Fly|Ride"] = 1995.95, ["Mega|Ride"] = 8256.21, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.89, ["Fly"] = 17.54, ["Ride"] = 15.75, ["Fly|Ride"] = 32.67, ["Neon"] = 19.69, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 131.09, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.16, ["Fly"] = 312, ["Ride"] = 82.57, ["Fly|Ride"] = 206.39, ["Neon"] = 40.85, ["Neon|Ride"] = 123.86, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 253.32, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 413.22}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.88, ["Neon"] = 5.09, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 203.33}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14, ["Fly"] = 24.77, ["Ride"] = 20.66, ["Fly|Ride"] = 74.79, ["Neon"] = 79.59, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 247.7, ["Mega"] = 575.19, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 101.07, ["Fly"] = 156.6, ["Ride"] = 107.51, ["Fly|Ride"] = 209.99, ["Neon"] = 210, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 209.09, ["Neon|Fly|Ride"] = 336, ["Mega"] = 519.48, ["Mega|Fly"] = 2167.27, ["Mega|Ride"] = 654.35, ["Mega|Fly|Ride"] = 853.5}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 49.88, ["Ride"] = 61.69, ["Fly|Ride"] = 93.5, ["Neon"] = 262.5, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 193.01, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 759.59}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 14.6, ["Fly|Ride"] = 35.1, ["Neon"] = 2.1, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 18.12, ["Neon|Fly|Ride"] = 45.2, ["Mega"] = 21.05, ["Mega|Fly"] = 35.1, ["Mega|Ride"] = 39.69, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 262.49, ["Ride"] = 307.13, ["Fly|Ride"] = 318.94, ["Neon"] = 3271.83, ["Neon|Ride"] = 1091.36, ["Neon|Fly|Ride"] = 823.29, ["Mega|Fly|Ride"] = 4673.85}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 104.97, ["Fly"] = 101.18, ["Ride"] = 59.87, ["Fly|Ride"] = 105, ["Neon"] = 131.25, ["Neon|Ride"] = 185.9, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.61, ["Fly|Ride"] = 44.42, ["Neon"] = 5.91, ["Neon|Fly"] = 34.27, ["Neon|Ride"] = 25.72, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 60.9, ["Mega|Fly"] = 275.56, ["Mega|Ride"] = 60.61, ["Mega|Fly|Ride"] = 293.3}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.97, ["Ride"] = 19.62, ["Fly|Ride"] = 38.7, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 125.05, ["Mega"] = 26.25, ["Mega|Fly"] = 138.3, ["Mega|Ride"] = 59.61, ["Mega|Fly|Ride"] = 154.83}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 12.22, ["Neon|Fly"] = 701.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 127.98, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 15.5, ["Fly"] = 32.82, ["Ride"] = 28.18, ["Fly|Ride"] = 64.12, ["Neon"] = 55.74, ["Neon|Fly"] = 262.18, ["Neon|Ride"] = 56.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 304.5, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.88, ["Ride"] = 55.09, ["Neon"] = 59.61, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 344.72}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 275.54, ["Neon"] = 3.94, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 98.63, ["Mega"] = 26.25, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.72, ["Fly"] = 97, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 31.8, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 70.45, ["Neon|Fly|Ride"] = 150.02, ["Mega"] = 199.4, ["Mega|Ride"] = 158.24, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 69.15, ["Ride"] = 123.84, ["Neon"] = 3.93, ["Neon|Fly"] = 110.46, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 23.93, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 123.86}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 12.39, ["Fly|Ride"] = 66.87, ["Neon"] = 4.87, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 52.4, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.86, ["Ride"] = 689.07, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.38, ["Mega|Fly|Ride"] = 17613.56}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 13.68, ["Fly|Ride"] = 27.6, ["Neon"] = 11.71, ["Neon|Fly"] = 123.05, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 45.93, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 206.39, ["Neon"] = 14.01, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 70.19, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 328.14}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.38, ["Fly"] = 46.75, ["Ride"] = 22.21, ["Fly|Ride"] = 57.66, ["Neon"] = 97, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 58.25, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 688.38, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 369.75}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 17.48, ["Ride"] = 14.42, ["Fly|Ride"] = 35.42, ["Neon"] = 6.51, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 23.48, ["Neon|Fly|Ride"] = 63.36, ["Mega"] = 65.62, ["Mega|Ride"] = 66.38, ["Mega|Fly|Ride"] = 172.95}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 31.56, ["Ride"] = 47.2, ["Fly|Ride"] = 274.5, ["Neon"] = 116.82, ["Neon|Ride"] = 258.05, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1170.33}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.6, ["Fly|Ride"] = 63.95, ["Neon"] = 7.44, ["Neon|Fly"] = 133.27, ["Neon|Ride"] = 31.2, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 111.25, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.62, ["Ride"] = 19.36, ["Fly|Ride"] = 65.63, ["Neon"] = 21.05, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 15.37, ["Mega"] = 92.32, ["Mega|Ride"] = 172.95, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.95, ["Neon"] = 5.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 22.21, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 44.01, ["Mega|Fly"] = 288.75, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 138.3}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.21, ["Fly"] = 18.03, ["Ride"] = 20.9, ["Fly|Ride"] = 41.29, ["Neon"] = 309.74, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 825.64, ["Mega|Ride"] = 467.4, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 891.19, ["Ride"] = 916.13, ["Fly|Ride"] = 1236.22, ["Neon"] = 2038, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 1943.31, ["Mega"] = 8256.21, ["Mega|Fly|Ride"] = 6045.16}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.38, ["Ride"] = 14.44, ["Fly|Ride"] = 32.75, ["Neon"] = 8.27, ["Neon|Fly"] = 23.22, ["Neon|Ride"] = 16.53, ["Neon|Fly|Ride"] = 67.51, ["Mega|Ride"] = 68.61, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.41, ["Fly|Ride"] = 116.87, ["Neon"] = 48.67, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 262.15, ["Mega"] = 383.59, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 481.98}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 51.19, ["Ride"] = 85.32, ["Fly|Ride"] = 105, ["Neon|Ride"] = 389.81, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2064.06}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.88, ["Ride"] = 41.29, ["Fly|Ride"] = 102.79, ["Neon"] = 183.75, ["Neon|Ride"] = 188.88, ["Mega"] = 932.96, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.6, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 55.74, ["Neon|Ride"] = 114.6, ["Neon|Fly|Ride"] = 121.47, ["Mega"] = 412.83, ["Mega|Ride"] = 551.11, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.08, ["Ride"] = 63.51, ["Neon"] = 179.57, ["Neon|Ride"] = 355.18, ["Mega"] = 259.42, ["Mega|Fly"] = 507.12, ["Mega|Ride"] = 368.08, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.18, ["Fly"] = 126.89, ["Ride"] = 28.61, ["Neon"] = 157.5, ["Neon|Ride"] = 307, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.72}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.61, ["Fly"] = 131248.69, ["Ride"] = 26.84, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Ride"] = 72.93, ["Neon|Fly|Ride"] = 229.13, ["Mega"] = 162.82, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 105, ["Mega"] = 872.85}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.07, ["Fly"] = 412.77, ["Ride"] = 79.48, ["Fly|Ride"] = 111.59, ["Neon"] = 383.88, ["Neon|Ride"] = 271.09, ["Neon|Fly|Ride"] = 282.19, ["Mega|Ride"] = 1651.26, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.53, ["Fly"] = 15.21, ["Ride"] = 15.05, ["Fly|Ride"] = 45.66, ["Neon"] = 27.06, ["Neon|Fly"] = 63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 71.95, ["Mega|Fly"] = 411.79, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.66, ["Fly"] = 146.57, ["Ride"] = 26.25, ["Fly|Ride"] = 198.14, ["Neon"] = 23.35, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 128.63, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.91, ["Mega"] = 48.51, ["Mega|Ride"] = 97.02, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 35.42, ["Fly"] = 64.97, ["Ride"] = 48.51, ["Fly|Ride"] = 94.46, ["Neon"] = 131.25, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 1101.19, ["Mega|Ride"] = 825.64, ["Mega|Fly|Ride"] = 777}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.56, ["Fly|Ride"] = 65.63, ["Neon"] = 5.85, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.26, ["Mega"] = 74.82, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 14.44, ["Ride"] = 22.73, ["Fly|Ride"] = 274.5, ["Neon"] = 145.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 674.96}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 11.9, ["Fly|Ride"] = 39.71, ["Neon"] = 13.02, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 64.3, ["Mega"] = 170.63, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.99, ["Fly"] = 52.49, ["Ride"] = 18.69, ["Fly|Ride"] = 73.12, ["Neon"] = 35.44, ["Neon|Ride"] = 410.93, ["Mega"] = 385.98, ["Mega|Ride"] = 399.41, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.35, ["Ride"] = 63.11, ["Fly|Ride"] = 131.25, ["Neon"] = 38.55, ["Neon|Ride"] = 156.59, ["Mega"] = 383.5, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 26.25, ["Ride"] = 138.29, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 643.99, ["Mega"] = 1496.45, ["Mega|Ride"] = 1637.84, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.99, ["Ride"] = 110.42, ["Neon"] = 99.02, ["Neon|Ride"] = 412.83, ["Mega"] = 410.76, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.91, ["Ride"] = 105, ["Neon"] = 153.04, ["Neon|Fly"] = 206.45, ["Mega|Ride"] = 1559.91, ["Mega|Fly|Ride"] = 1651.26}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.55, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 291.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 825.64, ["Mega|Ride"] = 879.27, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.76, ["Neon"] = 20.66, ["Neon|Ride"] = 275.56, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 311.99}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.41, ["Ride"] = 17.91, ["Fly|Ride"] = 60.61, ["Neon"] = 4.14, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 79.48, ["Mega|Ride"] = 86.48, ["Mega|Fly|Ride"] = 200.23}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 12.88, ["Fly"] = 50.18, ["Ride"] = 41.29, ["Fly|Ride"] = 77.9, ["Neon"] = 17.68, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 116.73, ["Mega"] = 138.3, ["Mega|Fly|Ride"] = 327.18}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.48, ["Fly|Ride"] = 55.95, ["Neon"] = 5.24, ["Neon|Fly"] = 31.58, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 69.06, ["Mega"] = 45.93, ["Mega|Ride"] = 74.11, ["Mega|Fly|Ride"] = 274.52}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.94, ["Fly"] = 45.94, ["Fly|Ride"] = 118.13, ["Neon"] = 32.82, ["Neon|Ride"] = 97.02, ["Neon|Fly|Ride"] = 255.96, ["Mega"] = 247.42, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 467.55, ["Neon|Ride"] = 82.58, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1211.61}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.84, ["Fly"] = 26.17, ["Ride"] = 16.53, ["Fly|Ride"] = 53.32, ["Neon"] = 20.5, ["Neon|Fly"] = 54.95, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 91.81, ["Mega"] = 199.4, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 18.58, ["Fly|Ride"] = 51.69, ["Neon|Fly"] = 82.59, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 184.74, ["Mega"] = 170.63, ["Mega|Ride"] = 138.3, ["Mega|Fly|Ride"] = 247.7}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.43, ["Fly"] = 57.66, ["Ride"] = 40.99, ["Neon"] = 14.68, ["Neon|Fly"] = 123.87, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 94.5, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 123.86, ["Mega|Fly|Ride"] = 265.42}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.5, ["Fly"] = 206.45, ["Ride"] = 105, ["Fly|Ride"] = 287.91, ["Neon"] = 124.69, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 548.02, ["Mega"] = 571.76, ["Mega|Fly"] = 716.24, ["Mega|Ride"] = 607.04, ["Mega|Fly|Ride"] = 712.69}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 82.59, ["Ride"] = 94.21, ["Fly|Ride"] = 217.88, ["Neon"] = 291.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1312.5, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1216.53}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.5, ["Fly|Ride"] = 54.45, ["Neon"] = 2.63, ["Neon|Ride"] = 41.29, ["Mega"] = 24.97, ["Mega|Ride"] = 69.17, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 12.95, ["Mega|Fly|Ride"] = 1238.45}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 60.38, ["Ride"] = 97.13, ["Neon"] = 247.67, ["Neon|Ride"] = 304.47, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1211.61, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.35, ["Fly"] = 190.32, ["Ride"] = 32.97, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 82.58, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 173.9, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.82, ["Ride"] = 110.42, ["Fly|Ride"] = 138.29, ["Neon"] = 7.7, ["Neon|Ride"] = 65.62, ["Mega"] = 64.83, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 317.02}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 688.28, ["Ride"] = 15.56, ["Fly|Ride"] = 59.87, ["Neon"] = 14.2, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 169.32, ["Mega|Fly"] = 344.72, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 12.39, ["Fly|Ride"] = 40.74, ["Neon"] = 2.57, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 133.14, ["Mega"] = 30.39, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 82.19, ["Neon"] = 5.16, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 46.24, ["Mega|Fly"] = 168, ["Mega|Ride"] = 67.07, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 76.37, ["Neon"] = 2.47, ["Neon|Ride"] = 145.08, ["Mega"] = 19.29, ["Mega|Ride"] = 551.11, ["Mega|Fly|Ride"] = 312.72}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.06, ["Ride"] = 44.39, ["Neon"] = 30.19, ["Neon|Ride"] = 155.81, ["Neon|Fly|Ride"] = 619.23, ["Mega"] = 148.41, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 189.11}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 8.27, ["Ride"] = 30.18, ["Fly|Ride"] = 202.98, ["Neon"] = 49.88, ["Neon|Ride"] = 203.4, ["Neon|Fly|Ride"] = 138.3, ["Mega|Ride"] = 551.11, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.88, ["Fly"] = 22.61, ["Ride"] = 24.77, ["Fly|Ride"] = 48.07, ["Neon"] = 39.29, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 39.21, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 551.11, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.57, ["Ride"] = 45.93, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1792.44}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.42, ["Fly"] = 82.66, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 950.92, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 15.5, ["Fly|Ride"] = 38, ["Neon"] = 2.35, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 48.2, ["Mega"] = 69.17, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 12.39, ["Fly|Ride"] = 35.1, ["Neon"] = 5.2, ["Neon|Fly"] = 15.5, ["Neon|Ride"] = 20.54, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 44.63, ["Mega|Fly"] = 82.58, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 624.33, ["Ride"] = 534.18, ["Fly|Ride"] = 549.94, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 65.63, ["Ride"] = 65.63, ["Neon"] = 45.93, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Ride"] = 390.29, ["Mega|Fly|Ride"] = 1238.45}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 15.27, ["Fly|Ride"] = 27.57, ["Neon"] = 3.9, ["Neon|Fly"] = 26.85, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 140.76, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 100.23, ["Ride"] = 164.07, ["Fly|Ride"] = 328.13, ["Neon"] = 260.78, ["Neon|Ride"] = 307.85, ["Neon|Fly|Ride"] = 452.04, ["Mega"] = 737.62, ["Mega|Ride"] = 917.44}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 16.53, ["Fly|Ride"] = 39.75, ["Neon"] = 8.79, ["Neon|Fly"] = 47.14, ["Neon|Ride"] = 24.21, ["Neon|Fly|Ride"] = 66.78, ["Mega"] = 91.88, ["Mega|Fly"] = 245.64, ["Mega|Ride"] = 123.86, ["Mega|Fly|Ride"] = 236.2}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.15, ["Ride"] = 42.84, ["Neon"] = 3.94, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 93.5, ["Mega"] = 16.89, ["Mega|Ride"] = 64.54, ["Mega|Fly|Ride"] = 190.76}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 55.12, ["Fly"] = 185.34, ["Ride"] = 86.35, ["Fly|Ride"] = 164.07, ["Neon"] = 169.32, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 325.11, ["Mega"] = 787.5, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 902}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 17.64, ["Fly|Ride"] = 52.5, ["Neon"] = 6.79, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 40.85, ["Mega|Ride"] = 178, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 33.77, ["Ride"] = 66.94, ["Fly|Ride"] = 138.29, ["Neon"] = 233.19, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1630.61, ["Mega|Ride"] = 1651.26, ["Mega|Fly|Ride"] = 1228.49}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.55, ["Ride"] = 156.32, ["Fly|Ride"] = 156.86, ["Neon"] = 16.4, ["Neon|Ride"] = 275.56, ["Neon|Fly|Ride"] = 481.98, ["Mega"] = 104.99, ["Mega|Ride"] = 467.4, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.29, ["Fly"] = 69.15, ["Ride"] = 26.25, ["Fly|Ride"] = 66.06, ["Neon"] = 10.14, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.79, ["Mega|Ride"] = 138.3, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.01, ["Ride"] = 145.69, ["Fly|Ride"] = 213.63, ["Neon"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1376.74}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.24, ["Ride"] = 32.82, ["Fly|Ride"] = 908.98, ["Neon"] = 4.95, ["Neon|Ride"] = 48.51, ["Neon|Fly|Ride"] = 153.08, ["Mega"] = 52.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.3, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 13.49, ["Ride"] = 17.54, ["Fly|Ride"] = 127.32, ["Neon"] = 10.48, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.53, ["Neon|Fly|Ride"] = 116.86, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.12, ["Fly"] = 51.35, ["Ride"] = 31.81, ["Fly|Ride"] = 77.86, ["Neon"] = 78.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 430.5, ["Mega|Ride"] = 467.4, ["Mega|Fly|Ride"] = 393.72}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 22.58, ["Fly"] = 57.11, ["Ride"] = 49.54, ["Fly|Ride"] = 77.41, ["Neon"] = 96.93, ["Neon|Fly"] = 138.33, ["Neon|Ride"] = 99.85, ["Neon|Fly|Ride"] = 235.32, ["Mega"] = 866.91, ["Mega|Ride"] = 561.44, ["Mega|Fly|Ride"] = 2064.06}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.63, ["Fly"] = 48.51, ["Ride"] = 28.25, ["Fly|Ride"] = 59.61, ["Neon"] = 82.59, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.86, ["Mega"] = 548.03, ["Mega|Ride"] = 311.99, ["Mega|Fly|Ride"] = 694.08}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 66.75, ["Fly"] = 135.19, ["Ride"] = 128.48, ["Fly|Ride"] = 223.13, ["Neon"] = 330.75, ["Neon|Ride"] = 500.12, ["Neon|Fly|Ride"] = 505.32, ["Mega"] = 1869.55, ["Mega|Ride"] = 1448.9, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Fly"] = 138.29, ["Ride"] = 48.87, ["Fly|Ride"] = 309.59, ["Neon"] = 31.56, ["Neon|Ride"] = 109.86, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 366.39}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.24, ["Ride"] = 26.57, ["Fly|Ride"] = 105.18, ["Neon"] = 22.05, ["Neon|Ride"] = 55.75, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 185.07, ["Mega|Ride"] = 195.05, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.78, ["Ride"] = 33.5, ["Fly|Ride"] = 160.13, ["Neon"] = 97.04, ["Neon|Ride"] = 412.83, ["Neon|Fly|Ride"] = 233.71, ["Mega"] = 382.1, ["Mega|Ride"] = 480.94, ["Mega|Fly|Ride"] = 551.11}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.39, ["Fly|Ride"] = 25.62, ["Neon"] = 2.1, ["Neon|Fly"] = 10.5, ["Neon|Ride"] = 12.71, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 14.36, ["Mega|Ride"] = 25.2, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 50.8, ["Ride"] = 110.24, ["Fly|Ride"] = 275.54, ["Neon"] = 356.9, ["Neon|Fly"] = 2339.9, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1266.3, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.19, ["Fly|Ride"] = 112.22, ["Neon"] = 6.08, ["Neon|Ride"] = 48.39, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.75, ["Mega|Ride"] = 75.17, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 14.44, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Fly"] = 138.33, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 262.15, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 105, ["Ride"] = 129.46, ["Fly|Ride"] = 275.54, ["Neon"] = 303.74, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 1273.13, ["Mega|Ride"] = 1376.74, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.67, ["Neon"] = 12.31, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 58.84, ["Mega"] = 94.5, ["Mega|Ride"] = 108.82, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.39}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 57.8, ["Neon"] = 6.18, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 48.08, ["Mega|Ride"] = 113.46, ["Mega|Fly|Ride"] = 262.15}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.56, ["Ride"] = 205.35, ["Fly|Ride"] = 262.5, ["Neon"] = 576.22, ["Neon|Ride"] = 647.1, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.97, ["Ride"] = 39.23, ["Neon"] = 19.56, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 173.15, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 385.98}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 81.38, ["Neon"] = 3.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.8, ["Mega|Ride"] = 101.15, ["Mega|Fly|Ride"] = 138.3}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.76, ["Ride"] = 26.48, ["Neon"] = 46.54, ["Neon|Ride"] = 110.44, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 412.83, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.54, ["Fly"] = 25.47, ["Ride"] = 20.97, ["Fly|Ride"] = 54.66, ["Neon"] = 90.3, ["Neon|Ride"] = 118.01, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 437.01}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.85, ["Ride"] = 60.29, ["Fly|Ride"] = 110.42, ["Neon"] = 168.92, ["Neon|Ride"] = 228.19, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 604.52, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.38, ["Fly"] = 210.98, ["Ride"] = 195.57, ["Fly|Ride"] = 259.72, ["Neon"] = 591.45, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 636.69, ["Mega|Fly|Ride"] = 2577.75}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 27.57, ["Fly"] = 48.57, ["Ride"] = 45.84, ["Fly|Ride"] = 58.24, ["Neon"] = 206.39, ["Neon|Fly"] = 6192.93, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 757.53, ["Mega|Ride"] = 757.53, ["Mega|Fly|Ride"] = 784.35}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.62, ["Fly"] = 131.23, ["Ride"] = 19.27, ["Fly|Ride"] = 65.62, ["Neon"] = 11.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.82, ["Mega|Ride"] = 220.87, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 23.56, ["Fly"] = 233.72, ["Ride"] = 32.45, ["Fly|Ride"] = 123.04, ["Neon"] = 131.25, ["Neon|Fly"] = 138.33, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 379.31, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.06, ["Fly"] = 140.23, ["Ride"] = 103.2, ["Fly|Ride"] = 109.29, ["Neon"] = 266.24, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 408.02, ["Mega"] = 950.22, ["Mega|Ride"] = 1087.77, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.86, ["Ride"] = 127.35, ["Neon"] = 138.33, ["Neon|Ride"] = 246.67, ["Neon|Fly|Ride"] = 455.14, ["Mega"] = 683.82, ["Mega|Ride"] = 817.93, ["Mega|Fly|Ride"] = 928.85}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 551.06, ["Neon|Ride"] = 3116.29, ["Neon|Fly|Ride"] = 1857.66}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 38.07, ["Ride"] = 97.13, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 965.94}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.27, ["Ride"] = 12.39, ["Fly|Ride"] = 28.88, ["Neon"] = 3.84, ["Neon|Ride"] = 13.02, ["Neon|Fly|Ride"] = 61.94, ["Mega"] = 24.05, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 46.75, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.45, ["Neon"] = 17.35, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 259.89, ["Mega"] = 143.83, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.12, ["Ride"] = 65.63, ["Fly|Ride"] = 144.18, ["Neon"] = 51.98, ["Neon|Ride"] = 122.82, ["Neon|Fly|Ride"] = 963.93, ["Mega"] = 124.66, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 417.42, ["Ride"] = 458.07, ["Fly|Ride"] = 619.16, ["Neon"] = 1402.22, ["Neon|Ride"] = 1335.46, ["Neon|Fly|Ride"] = 1431.43, ["Mega|Fly|Ride"] = 4862.82}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 62.45, ["Ride"] = 15.65, ["Fly|Ride"] = 52.5, ["Neon"] = 38.38, ["Neon|Ride"] = 66.4, ["Neon|Fly|Ride"] = 85.67, ["Mega"] = 168, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 378.77}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 8.21, ["Fly"] = 21.07, ["Ride"] = 16.36, ["Fly|Ride"] = 32.16, ["Neon"] = 26.71, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 412.83, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 688.38, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.6, ["Fly"] = 32.71, ["Ride"] = 28.87, ["Neon"] = 13.32, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 41.29, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 123.87, ["Mega|Ride"] = 268.34, ["Mega|Fly|Ride"] = 304.47}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 34.93, ["Ride"] = 40.2, ["Fly|Ride"] = 96.85, ["Neon"] = 140.44, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 824.6, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.72, ["Fly|Ride"] = 49.8, ["Neon"] = 6.24, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Ride"] = 441.73, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5, ["Fly"] = 64.26, ["Ride"] = 25.46, ["Fly|Ride"] = 91.88, ["Neon"] = 140.23, ["Neon|Ride"] = 164.34, ["Mega|Ride"] = 743.07, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.93, ["Neon|Ride"] = 27.69, ["Mega"] = 51.89, ["Mega|Ride"] = 117.67, ["Mega|Fly|Ride"] = 234.29}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 55.69, ["Ride"] = 138.29, ["Neon"] = 275.6, ["Mega"] = 551.11}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 34.8, ["Ride"] = 80.5, ["Neon"] = 76.56, ["Neon|Ride"] = 138.3, ["Mega"] = 304.47, ["Mega|Ride"] = 311.99, ["Mega|Fly|Ride"] = 548.02}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.27, ["Fly"] = 31.56, ["Ride"] = 27.88, ["Fly|Ride"] = 68.73, ["Neon"] = 51.16, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 580, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 305.7, ["Fly"] = 441.67, ["Ride"] = 327.99, ["Fly|Ride"] = 393.65, ["Neon"] = 1471.5, ["Neon|Ride"] = 1371.7, ["Neon|Fly|Ride"] = 1341.65, ["Mega|Fly|Ride"] = 5201.41}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.01, ["Ride"] = 15.32, ["Fly|Ride"] = 39.38, ["Neon"] = 11.71, ["Neon|Fly"] = 78.32, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 130.6, ["Mega"] = 213.85, ["Mega|Ride"] = 156.59, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.07, ["Fly"] = 110.42, ["Ride"] = 45.92, ["Fly|Ride"] = 78.3, ["Neon"] = 41.56, ["Neon|Ride"] = 146.47, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 286.55, ["Mega|Ride"] = 362.25}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 26.85, ["Ride"] = 91.88, ["Fly|Ride"] = 183.75, ["Neon"] = 131.25, ["Neon|Ride"] = 192.3, ["Neon|Fly|Ride"] = 296.8, ["Mega"] = 328.12, ["Mega|Ride"] = 374.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 127.22, ["Ride"] = 186.98, ["Fly|Ride"] = 220.84, ["Neon"] = 923.56, ["Neon|Ride"] = 1466.16, ["Neon|Fly|Ride"] = 1444.85, ["Mega"] = 3116.29, ["Mega|Ride"] = 7790.12, ["Mega|Fly|Ride"] = 3550.18}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.25, ["Fly"] = 78.75, ["Ride"] = 45.94, ["Fly|Ride"] = 154.26, ["Neon"] = 110.14, ["Neon|Ride"] = 138.33, ["Neon|Fly|Ride"] = 220.69, ["Mega"] = 247, ["Mega|Ride"] = 459.27, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 16.94, ["Fly|Ride"] = 57.66, ["Neon"] = 10.39, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 65.58, ["Mega|Ride"] = 152.76, ["Mega|Fly|Ride"] = 156.59}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 9.31, ["Ride"] = 40.25, ["Neon"] = 27.74, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 118.13, ["Mega|Ride"] = 311.99, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 91.77, ["Fly"] = 196.88, ["Ride"] = 121.77, ["Fly|Ride"] = 202.63, ["Neon"] = 219.98, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 511.88, ["Mega|Ride"] = 570.7, ["Mega|Fly|Ride"] = 610.31}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 123.84, ["Neon"] = 8.27, ["Neon|Ride"] = 50.68, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 62.87, ["Mega|Ride"] = 161.91, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 17.07, ["Fly|Ride"] = 275.54, ["Neon"] = 103.69, ["Neon|Ride"] = 308.59, ["Mega|Fly|Ride"] = 714.53}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2063.81, ["Ride"] = 1150.96, ["Fly|Ride"] = 1048.69, ["Neon"] = 3577.61, ["Neon|Ride"] = 3896.82, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 11696.97}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 23.87, ["Fly"] = 72.78, ["Ride"] = 165.13, ["Fly|Ride"] = 191.63, ["Neon"] = 112.88, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 206.42, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.26, ["Ride"] = 25.89, ["Fly|Ride"] = 80.89, ["Neon"] = 13.88, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.84, ["Neon|Fly|Ride"] = 91.47, ["Mega"] = 78.75, ["Mega|Ride"] = 121.79, ["Mega|Fly|Ride"] = 186.97}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.26, ["Ride"] = 47.25, ["Fly|Ride"] = 138.29, ["Neon"] = 202.14, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 412.83, ["Mega|Ride"] = 421.71, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.72, ["Fly|Ride"] = 59.49, ["Neon"] = 3.67, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 19.69, ["Mega|Fly"] = 123.86, ["Mega|Ride"] = 51.62, ["Mega|Fly|Ride"] = 148.83}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 69.74, ["Ride"] = 118.69, ["Fly|Ride"] = 228.38, ["Neon"] = 412.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 429.83, ["Mega"] = 1062.09, ["Mega|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 1241.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.88, ["Ride"] = 44.39, ["Fly|Ride"] = 124.68, ["Neon"] = 62.11, ["Neon|Ride"] = 97.02, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 669.38, ["Mega|Ride"] = 481.98, ["Mega|Fly|Ride"] = 547.32}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.67, ["Ride"] = 26.69, ["Neon"] = 11.76, ["Neon|Ride"] = 46.75, ["Mega"] = 99.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 344.72}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 131.25, ["Fly"] = 152.74, ["Ride"] = 131.25, ["Fly|Ride"] = 110.61, ["Neon"] = 140.23, ["Neon|Fly|Ride"] = 210.34, ["Mega"] = 684.36, ["Mega|Ride"] = 1032.04, ["Mega|Fly|Ride"] = 1074.99}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 24.93, ["Fly"] = 27.88, ["Ride"] = 45.43, ["Fly|Ride"] = 86.69, ["Neon"] = 49.85, ["Neon|Ride"] = 174.18, ["Neon|Fly|Ride"] = 163.07, ["Mega"] = 468.56, ["Mega|Ride"] = 511.9, ["Mega|Fly|Ride"] = 468.56}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.25, ["Ride"] = 84, ["Neon"] = 390.3, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1872.1, ["Mega|Ride"] = 2336.94, ["Mega|Fly|Ride"] = 1589.34}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.46, ["Ride"] = 60.56, ["Fly|Ride"] = 78.74, ["Neon"] = 24.5, ["Neon|Ride"] = 86.2, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 104.46, ["Mega|Ride"] = 224.99, ["Mega|Fly|Ride"] = 288.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.84, ["Ride"] = 12.39, ["Fly|Ride"] = 78.75, ["Neon"] = 63.47, ["Neon|Ride"] = 128.38, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 464.63, ["Mega|Ride"] = 402.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 119.55, ["Fly"] = 174.04, ["Ride"] = 176.48, ["Fly|Ride"] = 268.04, ["Neon"] = 546.87, ["Neon|Ride"] = 571.64, ["Neon|Fly|Ride"] = 636.57, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1942.5}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.3, ["Ride"] = 12.39, ["Fly|Ride"] = 38.07, ["Neon"] = 12.31, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 68.23, ["Mega"] = 124.69, ["Mega|Ride"] = 226.69, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.12, ["Fly"] = 97.76, ["Ride"] = 26.78, ["Fly|Ride"] = 62.78, ["Neon"] = 74.69, ["Neon|Fly"] = 233.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 315, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.34, ["Ride"] = 12.39, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 25.45, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 16.97, ["Mega|Fly"] = 49.09, ["Mega|Ride"] = 33.78, ["Mega|Fly|Ride"] = 93.5}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.74, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 39.23, ["Mega"] = 18.38, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 62.39, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.1, ["Ride"] = 18.38, ["Fly|Ride"] = 85.79, ["Neon"] = 26.25, ["Neon|Ride"] = 64.98, ["Mega"] = 262.5, ["Mega|Ride"] = 116.17, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 37.52, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 117.74, ["Neon|Ride"] = 156.59, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 668.77}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 13.58, ["Ride"] = 16.42, ["Fly|Ride"] = 36.94, ["Neon"] = 15.49, ["Neon|Fly"] = 32.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.17, ["Mega"] = 114.19, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 30.87, ["Fly"] = 39.38, ["Ride"] = 19.49, ["Fly|Ride"] = 41.29, ["Neon"] = 27.28, ["Neon|Fly"] = 37.17, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 185.17, ["Mega|Fly"] = 412.83, ["Mega|Ride"] = 189.53, ["Mega|Fly|Ride"] = 254.68}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 21, ["Ride"] = 15.99, ["Fly|Ride"] = 81.97, ["Neon"] = 7.24, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 89.22, ["Mega"] = 101.43, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 204.74, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.34, ["Fly"] = 169.32, ["Ride"] = 23.34, ["Neon"] = 31.5, ["Neon|Ride"] = 81, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 232.15, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 468.56}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 10.49, ["Ride"] = 122.75, ["Fly|Ride"] = 157.5, ["Neon"] = 65.62, ["Neon|Ride"] = 262.39, ["Mega"] = 464.43, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.36, ["Fly"] = 41.88, ["Ride"] = 17.77, ["Fly|Ride"] = 44.35, ["Neon"] = 22.4, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 330.26, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.18, ["Ride"] = 12.39, ["Fly|Ride"] = 34.9, ["Neon"] = 14.15, ["Neon|Fly"] = 46.76, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 209.9, ["Mega|Ride"] = 233.71, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 308.51, ["Fly|Ride"] = 392.43, ["Neon"] = 1101.92, ["Neon|Ride"] = 1367.12, ["Neon|Fly|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.83, ["Ride"] = 63.67, ["Neon"] = 42.94, ["Neon|Ride"] = 55.75, ["Neon|Fly|Ride"] = 412.83, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Fly"] = 103.2, ["Ride"] = 21.63, ["Fly|Ride"] = 79.06, ["Neon"] = 20.9, ["Neon|Ride"] = 41.29, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.83, ["Ride"] = 35.1, ["Neon"] = 60.9, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 11.68, ["Fly|Ride"] = 26.03, ["Neon"] = 2.63, ["Neon|Fly"] = 28.66, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 27.76, ["Mega"] = 18.38, ["Mega|Fly"] = 69.17, ["Mega|Ride"] = 41.29, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.62, ["Fly"] = 22.04, ["Ride"] = 18.93, ["Fly|Ride"] = 61.36, ["Neon"] = 12.44, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 85.32, ["Mega|Ride"] = 150.68, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.82, ["Ride"] = 144.38, ["Neon"] = 39.38, ["Neon|Ride"] = 275.56, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 78.67, ["Mega|Ride"] = 344.72, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.13, ["Fly"] = 163.61, ["Ride"] = 110.42, ["Fly|Ride"] = 173.24, ["Neon"] = 556.49, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2064.06, ["Mega|Ride"] = 3441.82, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.55, ["Fly"] = 81.29, ["Ride"] = 31.56, ["Fly|Ride"] = 262.49, ["Neon"] = 22.23, ["Neon|Ride"] = 109.7, ["Neon|Fly|Ride"] = 125.05, ["Mega"] = 213.68, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 411.79}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 48.99, ["Neon"] = 5.07, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 524.66, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 97.02}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 65.04, ["Fly"] = 210, ["Ride"] = 94.39, ["Fly|Ride"] = 209.99, ["Neon"] = 144.38, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 247.7, ["Mega"] = 636.57, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 13.88, ["Fly|Ride"] = 32.48, ["Neon"] = 2.62, ["Neon|Fly"] = 12.39, ["Neon|Ride"] = 12.31, ["Neon|Fly|Ride"] = 37.41, ["Mega"] = 17.63, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 90.6}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Ride"] = 65.52, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 26.85, ["Mega|Ride"] = 98.17, ["Mega|Fly|Ride"] = 386.77}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Neon"] = 12.03, ["Neon|Ride"] = 128.8, ["Neon|Fly|Ride"] = 181.65, ["Mega"] = 65.63, ["Mega|Fly"] = 179.59, ["Mega|Ride"] = 116.85, ["Mega|Fly|Ride"] = 209.08}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.87, ["Fly"] = 77.17, ["Ride"] = 42, ["Fly|Ride"] = 206.05, ["Neon"] = 26.82, ["Neon|Fly"] = 138.33, ["Neon|Ride"] = 76.65, ["Neon|Fly|Ride"] = 218.8, ["Mega"] = 301.47, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 11.31, ["Ride"] = 15.4, ["Fly|Ride"] = 36.14, ["Neon"] = 2.1, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 18.04, ["Mega|Fly"] = 46.75, ["Mega|Ride"] = 48.74, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.42, ["Fly"] = 131.25, ["Ride"] = 123.84, ["Neon"] = 106.95, ["Neon|Fly"] = 412.88, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 963.93, ["Mega"] = 468.56, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2520, ["Ride"] = 2493.75, ["Fly|Ride"] = 2639.58, ["Neon|Fly|Ride"] = 9628.8, ["Mega|Fly|Ride"] = 36052.73}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 135.13, ["Ride"] = 12.39, ["Fly|Ride"] = 44.62, ["Neon"] = 9.19, ["Neon|Fly"] = 63.14, ["Neon|Ride"] = 22.73, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 94.52, ["Mega|Fly"] = 460.29, ["Mega|Ride"] = 126.2, ["Mega|Fly|Ride"] = 172.35}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.95, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.69, ["Fly"] = 110.42, ["Ride"] = 29.6, ["Fly|Ride"] = 105, ["Neon"] = 131.25, ["Neon|Ride"] = 106.38, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 455.14, ["Mega|Ride"] = 459.19, ["Mega|Fly|Ride"] = 482.41}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.44, ["Ride"] = 66.94, ["Neon"] = 187.67, ["Neon|Ride"] = 206.42, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 1237.42, ["Mega|Ride"] = 757.53, ["Mega|Fly|Ride"] = 778.16}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 145.78, ["Fly"] = 1376.55, ["Ride"] = 197.88, ["Fly|Ride"] = 415.96, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 977.34, ["Mega"] = 6192.16, ["Mega|Fly|Ride"] = 3478.13}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 15.65, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.31, ["Neon|Ride"] = 141.77, ["Mega"] = 156.19, ["Mega|Ride"] = 172.37, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Neon"] = 18.36, ["Neon|Ride"] = 114.85, ["Mega"] = 130.85, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.3, ["Fly"] = 101.99, ["Ride"] = 34.73, ["Fly|Ride"] = 131.25, ["Neon"] = 8.27, ["Neon|Ride"] = 48.53, ["Mega"] = 85.05, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 18.51, ["Ride"] = 98.44, ["Neon"] = 145.68, ["Neon|Ride"] = 1165.82, ["Mega|Ride"] = 614.08, ["Mega|Fly|Ride"] = 791.58}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.58, ["Mega"] = 16.89, ["Mega|Fly"] = 116.27, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.77, ["Fly"] = 206.39, ["Ride"] = 122.81, ["Fly|Ride"] = 167.19, ["Neon"] = 515.06, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 515.31, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1750.33}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.31, ["Neon|Ride"] = 142.44, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 127.32, ["Mega|Ride"] = 274.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.18, ["Fly"] = 206.45, ["Ride"] = 85.15, ["Fly|Ride"] = 157.39, ["Neon"] = 262.5, ["Neon|Ride"] = 328.02, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1547.44}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.66, ["Fly|Ride"] = 51.33, ["Neon"] = 5.25, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 55.75, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.22}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 13.77, ["Neon|Ride"] = 105, ["Mega"] = 69.35, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 618.19}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.6, ["Fly"] = 77.43, ["Neon"] = 30.75, ["Neon|Ride"] = 103.22, ["Mega"] = 232.79, ["Mega|Ride"] = 371.55, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 458.07, ["Ride"] = 521.07, ["Fly|Ride"] = 609.87, ["Neon"] = 1307.25, ["Neon|Ride"] = 1333.56, ["Neon|Fly|Ride"] = 1378.12, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 3635.42}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.43, ["Ride"] = 57.08, ["Fly|Ride"] = 81.27, ["Neon"] = 278.67, ["Neon|Ride"] = 154.26, ["Neon|Fly|Ride"] = 270.4, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 49.88, ["Ride"] = 17.68, ["Fly|Ride"] = 91.88, ["Neon"] = 12.45, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 100.5, ["Mega"] = 65.63, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.29, ["Fly"] = 219.19, ["Ride"] = 49.87, ["Fly|Ride"] = 125.05, ["Neon"] = 59.07, ["Neon|Fly"] = 187.03, ["Neon|Ride"] = 110.46, ["Neon|Fly|Ride"] = 182.39, ["Mega"] = 262.5, ["Mega|Fly"] = 961.65, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 377.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 11.33, ["Ride"] = 20.69, ["Fly|Ride"] = 82.57, ["Neon"] = 139.32, ["Neon|Ride"] = 117.67, ["Neon|Fly|Ride"] = 265.27, ["Mega"] = 481.98, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.84, ["Neon"] = 16.96, ["Mega"] = 69.57, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.73, ["Fly"] = 70.88, ["Ride"] = 21.52, ["Fly|Ride"] = 55.74, ["Neon"] = 24.44, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 274.41, ["Mega"] = 123.86, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 1651.26}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 114.19, ["Fly"] = 344.67, ["Ride"] = 156.19, ["Fly|Ride"] = 235.62, ["Neon"] = 639.19, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 824.6, ["Mega|Fly|Ride"] = 2339.61}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 30.52, ["Fly"] = 95.82, ["Ride"] = 103.2, ["Fly|Ride"] = 138.29, ["Neon"] = 179.57, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 682.5, ["Mega|Ride"] = 804.99, ["Mega|Fly|Ride"] = 688.38}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.12, ["Fly"] = 2349.38, ["Ride"] = 2152.5, ["Fly|Ride"] = 2152.5, ["Neon"] = 11007.24, ["Neon|Fly|Ride"] = 6424.59, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 78.3, ["Neon"] = 17.07, ["Neon|Ride"] = 138.3, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 128.67, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 198.31, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.13, ["Ride"] = 53.76, ["Neon"] = 38.74, ["Neon|Ride"] = 119.2, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 551.5, ["Mega|Ride"] = 551.11, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1035.57, ["Fly"] = 1166.18, ["Ride"] = 984.38, ["Fly|Ride"] = 918.75, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2775.94, ["Mega|Fly|Ride"] = 11156.25}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 33.3, ["Fly"] = 82.57, ["Ride"] = 57.51, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 275.56, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1376.74}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.63, ["Ride"] = 23, ["Fly|Ride"] = 138.29, ["Neon"] = 10.34, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 223.13, ["Mega|Ride"] = 156.59, ["Mega|Fly|Ride"] = 551.11}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.09, ["Ride"] = 138.29, ["Neon"] = 3.9, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 78.3, ["Mega"] = 22.73, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 247.7}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.93, ["Ride"] = 236.25, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 8256.21, ["Mega|Fly|Ride"] = 5362.07}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Neon"] = 21.27, ["Neon|Ride"] = 52.02, ["Mega"] = 196.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.49, ["Ride"] = 102.38, ["Neon"] = 385.87, ["Neon|Ride"] = 467.4, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Fly|Ride"] = 110.42, ["Neon"] = 26.2, ["Neon|Ride"] = 78.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 145.72, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 304.47}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 259.88, ["Ride"] = 330.74, ["Fly|Ride"] = 380.98, ["Neon"] = 1438.92, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 87.94, ["Ride"] = 21, ["Fly|Ride"] = 103.76, ["Neon"] = 35, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 344.72, ["Mega|Ride"] = 274.54, ["Mega|Fly|Ride"] = 382.54}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 12.39, ["Fly|Ride"] = 32.81, ["Neon"] = 5.25, ["Neon|Fly"] = 30.98, ["Neon|Ride"] = 18.63, ["Neon|Fly|Ride"] = 65.03, ["Mega"] = 54.55, ["Mega|Fly"] = 122.87, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 917.44, ["Ride"] = 1050, ["Fly|Ride"] = 1194.38, ["Neon|Ride"] = 7568.88, ["Neon|Fly|Ride"] = 5476.96, ["Mega"] = 26145.31}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 17.58, ["Fly"] = 963.81, ["Ride"] = 72.19, ["Fly|Ride"] = 206.39, ["Neon"] = 42.75, ["Neon|Ride"] = 311.75, ["Mega"] = 262.5, ["Mega|Ride"] = 385.98, ["Mega|Fly|Ride"] = 467.4}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 9.19, ["Fly"] = 46.26, ["Ride"] = 41.29, ["Fly|Ride"] = 125.05, ["Neon"] = 32.71, ["Neon|Fly"] = 124.4, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 124.25, ["Mega"] = 189.73, ["Mega|Fly"] = 228.1, ["Mega|Ride"] = 195.81, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.6, ["Fly"] = 46.75, ["Ride"] = 47.22, ["Fly|Ride"] = 63, ["Neon"] = 206.39, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 203.33, ["Mega"] = 2064.06, ["Mega|Ride"] = 1238.45, ["Mega|Fly|Ride"] = 1031.56}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.5, ["Fly"] = 82.57, ["Ride"] = 26.24, ["Fly|Ride"] = 91.87, ["Neon"] = 72.86, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 87.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 38.06, ["Ride"] = 209.99, ["Fly|Ride"] = 402.46, ["Neon"] = 116.28, ["Neon|Ride"] = 275.56, ["Mega"] = 575.89, ["Mega|Ride"] = 575.89, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 275.54, ["Neon"] = 2.36, ["Neon|Fly"] = 55.75, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 311.99, ["Mega"] = 15.75, ["Mega|Ride"] = 88.77, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 58.33, ["Fly"] = 114.19, ["Ride"] = 78.44, ["Fly|Ride"] = 157.49, ["Neon"] = 393.75, ["Neon|Ride"] = 309.63, ["Neon|Fly|Ride"] = 439.69, ["Mega"] = 3302.49, ["Mega|Ride"] = 1698.72, ["Mega|Fly|Ride"] = 1221.06}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 103.31, ["Ride"] = 22.91, ["Fly|Ride"] = 110.42, ["Neon"] = 51.19, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 378.83, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 16.53, ["Fly|Ride"] = 27.88, ["Neon"] = 15.64, ["Neon|Ride"] = 52.64, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 271.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.75, ["Neon|Fly"] = 136.26, ["Neon|Fly|Ride"] = 184.74, ["Mega"] = 275.56, ["Mega|Fly|Ride"] = 287.95}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.04, ["Ride"] = 92.91, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 371.55, ["Mega"] = 1101.19, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 9.89, ["Neon"] = 28.77, ["Neon|Ride"] = 77.42, ["Mega"] = 103.85, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 311.99}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 20.66, ["Mega"] = 15.64, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 385.98}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 31.65, ["Fly|Ride"] = 136.21, ["Neon"] = 2.62, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 18.22, ["Mega|Ride"] = 44.91, ["Mega|Fly|Ride"] = 135.52}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 18.59, ["Fly|Ride"] = 52.46, ["Neon"] = 6.42, ["Neon|Ride"] = 19.31, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 123.86, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 138.3}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.89, ["Fly|Ride"] = 46.49, ["Neon"] = 12.39, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 69.17, ["Mega"] = 231.36, ["Mega|Ride"] = 275.56, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 66.91, ["Ride"] = 101.73, ["Fly|Ride"] = 220.84, ["Neon"] = 196.76, ["Neon|Ride"] = 330.26, ["Neon|Fly|Ride"] = 1032.04, ["Mega"] = 1558.74, ["Mega|Fly"] = 1005.2, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1097.06}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.81, ["Ride"] = 14.44, ["Fly|Ride"] = 35.34, ["Neon"] = 4.14, ["Neon|Fly"] = 41.75, ["Neon|Ride"] = 18.51, ["Neon|Fly|Ride"] = 45.43, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 116.86}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.22, ["Fly"] = 78.39, ["Ride"] = 23.28, ["Fly|Ride"] = 101.68, ["Neon"] = 39.79, ["Neon|Fly"] = 87.18, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 343.97, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 267.65, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.38, ["Fly"] = 47.25, ["Ride"] = 31.79, ["Fly|Ride"] = 93.59, ["Neon"] = 110.15, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 787.5, ["Mega|Ride"] = 492.09, ["Mega|Fly|Ride"] = 701.1}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.64, ["Fly"] = 196.88, ["Neon"] = 63.11, ["Mega"] = 288.98, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.49, ["Fly|Ride"] = 32.01, ["Neon"] = 4.87, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.85, ["Neon|Fly|Ride"] = 52.95, ["Mega"] = 42.87, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 58.07, ["Mega|Fly|Ride"] = 102.52}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.18, ["Fly"] = 52.5, ["Ride"] = 38.07, ["Neon"] = 18.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 138.3, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 385.98}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 917.44, ["Ride"] = 1018.36, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 6929.61}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 100.65, ["Ride"] = 140.44, ["Fly|Ride"] = 105, ["Neon"] = 525, ["Neon|Ride"] = 569.63, ["Neon|Fly|Ride"] = 659.48, ["Mega"] = 2064.06, ["Mega|Ride"] = 2476.87, ["Mega|Fly|Ride"] = 2047.5}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.74, ["Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 206.42, ["Mega"] = 80.52, ["Mega|Fly|Ride"] = 206.42}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 66.78, ["Ride"] = 91.88, ["Fly|Ride"] = 138.29, ["Neon"] = 344.67, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1050, ["Mega|Ride"] = 1514, ["Mega|Fly|Ride"] = 1486.36}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.4, ["Ride"] = 26.88, ["Fly|Ride"] = 89.79, ["Neon"] = 19.42, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 274.02, ["Mega|Ride"] = 341.3, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 288.75, ["Fly"] = 412.77, ["Ride"] = 330.23, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1110.05, ["Neon|Fly|Ride"] = 1750.33, ["Mega|Fly|Ride"] = 4509.96}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 35.44, ["Fly|Ride"] = 204.69, ["Neon"] = 31.38, ["Neon|Ride"] = 54.37, ["Mega"] = 344.72, ["Mega|Fly"] = 322}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 16.53, ["Mega"] = 330.26}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 31.5, ["Ride"] = 27.88, ["Fly|Ride"] = 153.82, ["Neon"] = 152.74, ["Neon|Ride"] = 390.29, ["Mega"] = 619.23, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 963.93}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.65, ["Fly|Ride"] = 275.54, ["Neon"] = 20.66, ["Neon|Ride"] = 46.76, ["Mega"] = 227.07, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 456.65}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 12.09, ["Fly|Ride"] = 34.78, ["Neon"] = 2.63, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 25.71, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 23.63, ["Mega|Ride"] = 43.36, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4450.69, ["Fly|Ride"] = 4488.75, ["Neon"] = 30956.88, ["Neon|Fly|Ride"] = 19293.74, ["Mega|Fly|Ride"] = 129002.97}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.04, ["Ride"] = 54.51, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 262.28, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 15.75, ["Fly|Ride"] = 45.02, ["Neon"] = 13.39, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 131.25, ["Mega|Ride"] = 165.14, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.47, ["Fly"] = 547.77, ["Ride"] = 510.82, ["Fly|Ride"] = 544.69, ["Neon"] = 1643.46, ["Neon|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 1490.96, ["Mega|Fly|Ride"] = 5273.63}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.94, ["Ride"] = 31.96, ["Neon"] = 18.69, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 688.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 9.18, ["Fly"] = 65.63, ["Ride"] = 7169.95, ["Neon"] = 27.2, ["Neon|Ride"] = 275.56, ["Neon|Fly|Ride"] = 275.56, ["Mega"] = 875.61, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 469.23}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 16.21, ["Neon"] = 5.13, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 21.83, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 49.7, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 790.48, ["Fly"] = 2063.81, ["Ride"] = 756.03, ["Fly|Ride"] = 853.4, ["Neon"] = 2362.5, ["Neon|Ride"] = 3248.44, ["Neon|Fly|Ride"] = 2361.19}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.69, ["Fly"] = 289.8, ["Ride"] = 78.75, ["Neon"] = 31.5, ["Neon|Ride"] = 63.11, ["Neon|Fly|Ride"] = 202.29, ["Mega"] = 157.49, ["Mega|Ride"] = 213.87, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.96, ["Fly"] = 236.15, ["Ride"] = 55.74, ["Fly|Ride"] = 138.29, ["Neon"] = 24.81, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 3896.82, ["Mega"] = 205.08, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 15.33, ["Neon"] = 14.33, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 274.54, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.78, ["Ride"] = 69.15, ["Fly|Ride"] = 156.6, ["Neon"] = 117.59, ["Neon|Fly|Ride"] = 309.63, ["Mega"] = 551.11, ["Mega|Ride"] = 770.94, ["Mega|Fly|Ride"] = 743.07}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 412.77, ["Neon"] = 3.57, ["Neon|Fly"] = 27.88, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 184.74, ["Mega"] = 49.93, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 478.8, ["Ride"] = 564.38, ["Fly|Ride"] = 787.5, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2492.69, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 103.23, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 14.44, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 83.21, ["Mega|Ride"] = 126.95, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.29, ["Neon"] = 4.64, ["Neon|Fly"] = 234.31, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 61.07, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 275.56}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 8.22, ["Neon|Ride"] = 42.59, ["Neon|Fly|Ride"] = 138.3, ["Mega"] = 52.64, ["Mega|Fly"] = 152.76, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.02, ["Ride"] = 27.48, ["Neon"] = 18.59, ["Mega"] = 203.33}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 36.07, ["Fly"] = 98.44, ["Ride"] = 112.3, ["Fly|Ride"] = 296.81, ["Neon"] = 121.95, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 963.93, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.32, ["Ride"] = 69.15, ["Fly|Ride"] = 128.99, ["Neon"] = 103.2, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 257.15, ["Mega"] = 464.68, ["Mega|Fly"] = 551.11, ["Mega|Ride"] = 451.8, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 15.49, ["Fly|Ride"] = 31.49, ["Neon"] = 28.87, ["Neon|Ride"] = 34.41, ["Neon|Fly|Ride"] = 76.82, ["Mega"] = 299.92, ["Mega|Ride"] = 429.34, ["Mega|Fly|Ride"] = 265.27}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.09, ["Ride"] = 64.32, ["Fly|Ride"] = 119.73, ["Neon"] = 143.74, ["Neon|Ride"] = 136.24, ["Mega|Ride"] = 288.98}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.17, ["Fly|Ride"] = 111.55, ["Neon"] = 15.49, ["Neon|Ride"] = 39.75, ["Neon|Fly|Ride"] = 208, ["Mega"] = 105, ["Mega|Ride"] = 152.76, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 23.63, ["Ride"] = 24.77, ["Fly|Ride"] = 103.2, ["Neon"] = 275.54, ["Neon|Ride"] = 516.06, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 927.81}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Fly|Ride"] = 963.93}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 66.65, ["Fly"] = 115.38, ["Ride"] = 76.26, ["Fly|Ride"] = 185.57, ["Neon"] = 294.96, ["Neon|Fly"] = 392.23, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1652.22, ["Mega|Fly|Ride"] = 1043.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 70.85, ["Fly"] = 291.38, ["Ride"] = 44.63, ["Neon"] = 137.45, ["Neon|Ride"] = 140.23, ["Neon|Fly|Ride"] = 410.15, ["Mega"] = 592.51, ["Mega|Ride"] = 647.1, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 24.97, ["Ride"] = 56.44, ["Fly|Ride"] = 138.29, ["Neon"] = 123.84, ["Neon|Ride"] = 274.26, ["Mega"] = 590.63, ["Mega|Ride"] = 757.53, ["Mega|Fly|Ride"] = 1238.45}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.63, ["Fly"] = 428.28, ["Ride"] = 47.25, ["Fly|Ride"] = 192.93, ["Neon"] = 87.94, ["Neon|Fly"] = 420, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 249.48, ["Mega"] = 464.37, ["Mega|Ride"] = 486.72, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 14.18, ["Fly|Ride"] = 26.5, ["Neon"] = 5.25, ["Neon|Fly"] = 27.88, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.61, ["Mega|Fly"] = 156.59, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 44.63, ["Fly"] = 233.72, ["Ride"] = 97.13, ["Fly|Ride"] = 288.75, ["Neon"] = 293.99, ["Neon|Ride"] = 288.74, ["Mega"] = 784.35, ["Mega|Ride"] = 825.64, ["Mega|Fly|Ride"] = 987.96}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.73, ["Neon|Fly"] = 97.04, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.62, ["Mega"] = 27.88, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.45, ["Ride"] = 76.37, ["Fly|Ride"] = 167.19, ["Neon"] = 124.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 637.97, ["Mega|Ride"] = 593.44, ["Mega|Fly|Ride"] = 825.64}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Mega"] = 26.25}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega|Ride"] = 91.16, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 118.13, ["Fly"] = 242.58, ["Ride"] = 154.88, ["Fly|Ride"] = 247.67, ["Neon"] = 516.09, ["Neon|Ride"] = 587.99, ["Neon|Fly|Ride"] = 729.65, ["Mega|Ride"] = 2546.02, ["Mega|Fly|Ride"] = 1824.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.22, ["Fly|Ride"] = 92.99, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 205.13}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.99, ["Fly|Ride"] = 86.63, ["Neon"] = 3.94, ["Neon|Ride"] = 35.1, ["Neon|Fly|Ride"] = 122.82, ["Mega"] = 32.81, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.57, ["Neon"] = 3.54, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 129.93, ["Mega"] = 45.92, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 237.38}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.88, ["Neon"] = 5.09, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 203.33}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.54, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 419.83, ["Neon|Ride"] = 515, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1514, ["Mega|Ride"] = 1548.05, ["Mega|Fly|Ride"] = 1502.65}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.35, ["Ride"] = 63.11, ["Fly|Ride"] = 131.25, ["Neon"] = 38.55, ["Neon|Ride"] = 156.59, ["Mega"] = 383.5, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 328.13, ["Ride"] = 485.63, ["Fly|Ride"] = 688.28, ["Neon"] = 1031.91, ["Neon|Ride"] = 1376.91, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 91.53}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.19}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 84}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 61.94}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 45.94}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.87}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.44}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 30.19}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 33.07}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.12}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 8.34}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.16}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.34}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.96}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.39}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 824.71}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.17}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.97}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 31.59}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.57}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 19.63}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.91}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.42}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.55}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.9}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.76}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.31}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.89}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.27}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 17.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 8.82}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.7}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.55}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1870.28}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 48.09}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.23}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.59}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 203.44}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.35}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.4}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1376.91}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 25.92}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.68}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.91}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 32.82}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.77}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 29.82}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.38}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 9.18}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 23.83}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 94.5}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 30.85}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 101.16}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.4}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22269.78}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 150.94}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 62.88}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 34.91}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.97}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 29.8}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 87.05}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.06}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 43.32}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 87.93}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.36}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 46.77}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 412.88}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.15}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.34}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.07}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 88.91}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.8}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 358.18}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.82}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 582.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 16.64}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.52}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.51}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 607.98}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 137.64}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.19}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.68}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 206.45}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 49.88}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.61}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.25}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.15}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 24.29}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.89}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.12}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 7.88}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 189}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.42}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.35}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 147.97}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.98}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 105}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.4}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.45}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.44}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 90.57}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 36.07}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 26.25}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.64}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.08}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.26}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.34}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.13}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.49}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 13.11}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7794.66}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.02}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.96}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.18}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 15.02}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.27}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.9}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 4.7}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 110.46}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.47}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.55}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4366.76}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 3.23}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 196.88}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.34}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.64}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 53.82}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 4.77}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.64}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.42}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.93}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.89}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 45.94}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.52}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.98}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.8}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 18.38}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.36}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.16}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.56}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.5}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 42.67}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.7}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 917.44}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 39.37}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.62}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 21.34}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 15.65}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.35}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 78.66}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.67}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 82.59}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.59}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 49.55}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.02}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.54}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.35}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.82}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.16}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.52}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 21.17}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 52.41}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.28}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.14}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 32.82}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.39}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.77}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 38.98}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.75}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.46}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1011.35}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.61}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 247.73}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 70.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 72.19}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.36}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.7}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.71}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.88}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.87}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.57}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.36}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.29}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 73.04}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 39.8}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 131.15}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 78.4}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 69.57}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 45.94}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 103.23}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 232.32}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 84}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 8.27}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 179.62}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.55}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.46}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 60.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.83}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.95}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.24}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.46}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 39.29}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.57}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.49}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 37.3}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 14.41}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.11}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.36}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 97.04}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.88}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 5.64}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 37.02}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 20.64}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1706.25}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.11}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 44.89}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 377.03}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.29}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.34}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 262.49}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 27.57}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.33}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 6.2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 53.45}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 124.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 80.07}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 211.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.45}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2339.9}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.87}},
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