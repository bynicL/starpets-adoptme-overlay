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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 822.94, ["Ride"] = 963.45, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 20126.97}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 518.62, ["Fly|Ride"] = 536.41, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2394.91, ["Mega"] = 10322.81, ["Mega|Fly|Ride"] = 9611.28}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["Ride"] = 4571.04, ["Fly|Ride"] = 4959.81, ["Neon"] = 23264.94, ["Neon|Fly|Ride"] = 21334.15, ["Mega|Fly|Ride"] = 68810.47}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 172.1, ["Ride"] = 182.43, ["Fly|Ride"] = 411.9, ["Neon"] = 775.9, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1236.68, ["Mega"] = 4129.13, ["Mega|Fly|Ride"] = 3574.35}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 825.23, ["Ride"] = 619.49, ["Fly|Ride"] = 630.1, ["Neon|Fly|Ride"] = 1519.87, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.47, ["Ride"] = 27.6, ["Fly|Ride"] = 152.79, ["Neon"] = 56.44, ["Neon|Fly"] = 275.63, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 301.63, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 576.99}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 41.14, ["Ride"] = 32, ["Fly|Ride"] = 107.37, ["Neon"] = 30.44, ["Neon|Fly"] = 128.62, ["Neon|Ride"] = 51.03, ["Neon|Fly|Ride"] = 121.96, ["Mega"] = 162.75, ["Mega|Fly"] = 223.13, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 276.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 116.94, ["Ride"] = 149.22, ["Fly|Ride"] = 234.35, ["Neon"] = 521.07, ["Neon|Ride"] = 618.35, ["Neon|Fly|Ride"] = 679.88, ["Mega|Ride"] = 2064.32, ["Mega|Fly|Ride"] = 2677.41}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 45.94, ["Fly"] = 81.38, ["Ride"] = 60.88, ["Fly|Ride"] = 103.24, ["Neon"] = 252, ["Neon|Ride"] = 206.47, ["Neon|Fly|Ride"] = 261.75, ["Mega"] = 2100, ["Mega|Ride"] = 1395.14, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.77, ["Fly"] = 56.7, ["Ride"] = 39.22, ["Fly|Ride"] = 61.85, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1340.78, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 46.71, ["Fly"] = 206.07, ["Ride"] = 81.38, ["Fly|Ride"] = 173.13, ["Neon"] = 412.93, ["Neon|Fly"] = 410.86, ["Neon|Ride"] = 289.05, ["Neon|Fly|Ride"] = 307.11}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 399, ["Ride"] = 353.6, ["Fly|Ride"] = 392.44, ["Neon"] = 1427.32, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4857.33}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 137.82, ["Fly"] = 170.23, ["Ride"] = 139.49, ["Fly|Ride"] = 194.25, ["Neon|Fly"] = 674.71, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2984.43}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.52, ["Ride"] = 53.43, ["Fly|Ride"] = 131.24, ["Neon"] = 20.66, ["Neon|Fly"] = 96.41, ["Neon|Fly|Ride"] = 189, ["Mega"] = 124.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 384.84}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.95, ["Fly"] = 210.53, ["Ride"] = 183.74, ["Fly|Ride"] = 240.76, ["Neon|Ride"] = 716.42, ["Neon|Fly|Ride"] = 688.55, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.67, ["Fly"] = 26.7, ["Ride"] = 19.69, ["Fly|Ride"] = 40.69, ["Neon"] = 26.85, ["Neon|Ride"] = 68.15, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 106.85, ["Fly"] = 262.5, ["Ride"] = 157.1, ["Fly|Ride"] = 206.32, ["Neon"] = 247.76, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 373.85, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1651.67, ["Mega|Ride"] = 1334.69, ["Mega|Fly|Ride"] = 1168.14}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 42}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 69.13, ["Ride"] = 154.74, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1377.08, ["Mega|Fly|Ride"] = 2062.25}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.07, ["Fly"] = 393.75, ["Ride"] = 32.48, ["Fly|Ride"] = 110.48, ["Neon"] = 225.05, ["Neon|Ride"] = 194.08, ["Neon|Fly|Ride"] = 272.54, ["Mega|Ride"] = 581.12, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 44.62, ["Fly"] = 124.38, ["Ride"] = 59.06, ["Fly|Ride"] = 126, ["Neon"] = 243.64, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1628.59, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 56.27, ["Fly"] = 72.18, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 208.69, ["Neon|Ride"] = 188.06, ["Neon|Fly|Ride"] = 371.64, ["Mega"] = 2047.49, ["Mega|Ride"] = 1307.76, ["Mega|Fly|Ride"] = 1253.04}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 28.88, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 344.8, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 293.15, ["Mega"] = 823.78, ["Mega|Ride"] = 2064.32, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.15, ["Fly"] = 116.24, ["Ride"] = 69.57, ["Fly|Ride"] = 123.88, ["Neon"] = 228.16, ["Neon|Fly"] = 552.28, ["Neon|Ride"] = 181.91, ["Neon|Fly|Ride"] = 388.55, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.57, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 57.75, ["Neon"] = 34.93, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 101.38, ["Mega"] = 154.75, ["Mega|Fly"] = 26157.81, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 357.69, ["Ride"] = 433.13, ["Fly|Ride"] = 480.11, ["Neon"] = 1858.13, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7208.18}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 32.45, ["Neon"] = 219.18, ["Mega"] = 515.12, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.91, ["Fly"] = 31.39, ["Ride"] = 20.93, ["Fly|Ride"] = 49.08, ["Neon"] = 72.19, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 309.7, ["Mega|Ride"] = 274.57, ["Mega|Fly|Ride"] = 426.4}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 91.88, ["Ride"] = 103.17, ["Fly|Ride"] = 131.22, ["Neon"] = 365.28, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 3303.3, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1596.76}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 10.5, ["Ride"] = 27.84, ["Fly|Ride"] = 118.13, ["Neon"] = 155.89, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 162.42, ["Mega"] = 479.16, ["Mega|Ride"] = 787.56}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 348.67, ["Ride"] = 280.87, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 734.99, ["Neon|Fly|Ride"] = 752.45, ["Mega"] = 6193.69, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2939.58}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.91, ["Fly"] = 28.32, ["Ride"] = 22.32, ["Fly|Ride"] = 53.02, ["Neon"] = 24.94, ["Neon|Fly"] = 5157.57, ["Neon|Ride"] = 53.52, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 202.42, ["Mega|Fly"] = 508.46, ["Mega|Ride"] = 394.13, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.74, ["Fly"] = 2625, ["Ride"] = 990.94, ["Fly|Ride"] = 1101.45, ["Neon"] = 7158.38, ["Neon|Ride"] = 6056.39, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52317.35, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.77, ["Fly"] = 69.13, ["Ride"] = 27.57, ["Fly|Ride"] = 93.08, ["Neon"] = 72.13, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 228.16, ["Mega"] = 551.25, ["Mega|Ride"] = 712.21, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.48, ["Ride"] = 229.69, ["Fly|Ride"] = 279.2, ["Neon"] = 874.36, ["Neon|Ride"] = 871.76, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 2790.27, ["Mega|Fly|Ride"] = 3028.35}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 24.78, ["Ride"] = 52.31, ["Fly|Ride"] = 138.25, ["Neon"] = 97.05, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 197.18, ["Mega"] = 677.69, ["Mega|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 728.97}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 91.88, ["Ride"] = 206.32, ["Fly|Ride"] = 233.71, ["Neon"] = 590.94, ["Neon|Ride"] = 465.94, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Ride"] = 172.05, ["Fly|Ride"] = 282.77, ["Neon"] = 389.45, ["Neon|Fly"] = 586.3, ["Neon|Ride"] = 412.93, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1417.5, ["Mega|Fly|Ride"] = 2676.45}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 59.04}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 56.49, ["Fly"] = 61.35, ["Ride"] = 58.04, ["Fly|Ride"] = 85.7, ["Neon|Ride"] = 372.26, ["Neon|Fly|Ride"] = 365.14, ["Mega"] = 4129.13, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.04, ["Fly"] = 55.71, ["Ride"] = 65.1, ["Fly|Ride"] = 131.25, ["Neon"] = 48.53, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 123.88, ["Neon|Fly|Ride"] = 232.29, ["Mega"] = 172.4, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 324.12, ["Mega|Fly|Ride"] = 482.03}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 473.82, ["Fly"] = 590.63, ["Ride"] = 465.63, ["Fly|Ride"] = 507.93, ["Neon|Ride"] = 1742.5, ["Neon|Fly|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 6477.19}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 102.14, ["Fly"] = 151.12, ["Ride"] = 117.35, ["Fly|Ride"] = 175.51, ["Neon"] = 388.54, ["Neon|Fly"] = 825.84, ["Neon|Ride"] = 576.99, ["Neon|Fly|Ride"] = 523.38, ["Mega|Ride"] = 2476.15, ["Mega|Fly|Ride"] = 2317.34}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3719.41, ["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14450.9}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 110.35, ["Ride"] = 60.45, ["Fly|Ride"] = 128.42, ["Neon"] = 393.75, ["Neon|Ride"] = 582.64, ["Neon|Fly|Ride"] = 403.67, ["Mega|Ride"] = 1184.93, ["Mega|Fly|Ride"] = 1225.18}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 81.51, ["Ride"] = 78.74, ["Fly|Ride"] = 171.38, ["Neon"] = 410.42, ["Neon|Ride"] = 621.2, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2753.1, ["Mega|Ride"] = 2615.49, ["Mega|Fly|Ride"] = 2790.27}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.44, ["Fly"] = 61.9, ["Ride"] = 55.81, ["Fly|Ride"] = 102.38, ["Neon"] = 189, ["Neon|Ride"] = 175.67, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 2625, ["Mega|Ride"] = 729.75, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 41.28, ["Fly"] = 41.28, ["Ride"] = 63, ["Fly|Ride"] = 64.94, ["Neon"] = 515.12, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1514.18}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.12, ["Ride"] = 223.13, ["Fly|Ride"] = 259.87, ["Neon|Ride"] = 1377.08, ["Neon|Fly|Ride"] = 1377.08, ["Mega|Fly|Ride"] = 4960.87}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1085.61, ["Fly|Ride"] = 1032.29, ["Neon"] = 2887.5, ["Neon|Ride"] = 4187.76, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13762.72}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.55}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.24, ["Fly"] = 76.35, ["Ride"] = 43.52, ["Fly|Ride"] = 63.84, ["Neon"] = 160.78, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 233.01, ["Mega|Ride"] = 787.29, ["Mega|Fly|Ride"] = 990.88}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 16.02}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5982.79, ["Ride"] = 5982.79, ["Fly|Ride"] = 4610.81, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40304.14}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.86, ["Fly"] = 52.4, ["Ride"] = 23.14, ["Fly|Ride"] = 55.13, ["Neon"] = 132.57, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 787.5, ["Mega|Ride"] = 589.46, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.47, ["Fly"] = 191.88, ["Ride"] = 33.03, ["Fly|Ride"] = 115.18, ["Neon"] = 69.18, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 247.76, ["Mega"] = 721.88, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1029.07}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 107.29, ["Fly"] = 276.59, ["Ride"] = 91.86, ["Fly|Ride"] = 111.57, ["Neon|Ride"] = 382.99, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4129.13}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.13, ["Fly"] = 150.93, ["Ride"] = 32.28, ["Fly|Ride"] = 78.75, ["Neon"] = 75.64, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 551.18, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.75, ["Fly"] = 2127.04, ["Ride"] = 2034.38, ["Fly|Ride"] = 1806.94, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 52500, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 70195.02, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21.26, ["Fly"] = 393.74, ["Ride"] = 52.62, ["Fly|Ride"] = 124.69, ["Neon"] = 262.22, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 964.17, ["Mega|Ride"] = 757.62, ["Mega|Fly|Ride"] = 821.61}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.89, ["Fly"] = 82.55, ["Ride"] = 36.11, ["Fly|Ride"] = 152.79, ["Neon"] = 22.3, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 62.28, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 125.89, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 311.72}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.77}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 32, ["Fly|Ride"] = 125.25, ["Neon"] = 62.84, ["Neon|Ride"] = 129.88, ["Neon|Fly|Ride"] = 152.79, ["Mega"] = 270.92, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 768.51, ["Ride"] = 721.88, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 2710.42, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1121.27, ["Fly"] = 1076.25, ["Ride"] = 1069.35, ["Fly|Ride"] = 1012.37, ["Neon|Ride"] = 3166.02, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11006.42}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 17.07, ["Fly"] = 116.24, ["Ride"] = 36.75, ["Fly|Ride"] = 90.76, ["Neon"] = 140.44, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 234.35, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 605.89}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.04}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.9, ["Fly"] = 93, ["Ride"] = 73.5, ["Fly|Ride"] = 118.73, ["Neon"] = 463.51, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 455.34, ["Mega|Ride"] = 2020.97, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.08, ["Fly"] = 138.25, ["Ride"] = 52.5, ["Fly|Ride"] = 228.38, ["Neon"] = 427.68, ["Neon|Ride"] = 278.74, ["Neon|Fly|Ride"] = 549.2, ["Mega"] = 2080.29, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.5, ["Fly"] = 44.54, ["Ride"] = 20.32, ["Fly|Ride"] = 61.95, ["Neon"] = 55.76, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.64, ["Neon|Fly|Ride"] = 132.55, ["Mega"] = 288.75, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 111.57, ["Fly"] = 143.07, ["Ride"] = 144.38, ["Fly|Ride"] = 192.93, ["Neon|Ride"] = 454.78, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1376.91}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.25, ["Ride"] = 66.27, ["Fly|Ride"] = 232.67, ["Neon"] = 51.1, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 481.05, ["Mega"] = 236.25, ["Mega|Ride"] = 275.6, ["Mega|Fly|Ride"] = 581.33}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.49, ["Fly"] = 41.22, ["Ride"] = 33.03, ["Fly|Ride"] = 88.35, ["Neon"] = 69.13, ["Neon|Ride"] = 110.32, ["Neon|Fly|Ride"] = 165.18, ["Mega|Fly|Ride"] = 784.45}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 31.5, ["Ride"] = 55.71, ["Fly|Ride"] = 156.19, ["Neon"] = 263.24, ["Neon|Ride"] = 330.35, ["Neon|Fly|Ride"] = 344.8, ["Mega"] = 1241.22, ["Mega|Ride"] = 775.48, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.06, ["Fly"] = 189.06, ["Ride"] = 35.44, ["Fly|Ride"] = 69.57, ["Neon"] = 71.07, ["Neon|Ride"] = 109.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 891.91, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7152.51, ["Ride"] = 7141.32, ["Fly|Ride"] = 5496.74, ["Neon"] = 30968.4, ["Neon|Fly|Ride"] = 27376.08}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 249.38, ["Fly"] = 275.43, ["Ride"] = 253.84, ["Fly|Ride"] = 296.8, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 36.75, ["Fly"] = 315, ["Ride"] = 79.27, ["Fly|Ride"] = 143.4, ["Neon"] = 89.63, ["Neon|Fly"] = 308.67, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 385.88, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 86.03, ["Ride"] = 20.93, ["Fly|Ride"] = 105.88, ["Neon"] = 24.98, ["Neon|Fly"] = 49.56, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.88, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.5, ["Fly"] = 5265.65, ["Ride"] = 86.62, ["Fly|Ride"] = 232.29, ["Neon"] = 201.12, ["Neon|Fly"] = 251.89, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 262.22, ["Mega"] = 445.76, ["Mega|Ride"] = 545.2, ["Mega|Fly|Ride"] = 590.07}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15679, ["Ride"] = 13387.5, ["Fly|Ride"] = 12600, ["Neon|Fly|Ride"] = 27527.82}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 181.13, ["Ride"] = 285.77, ["Fly|Ride"] = 371.44, ["Neon"] = 1238.75, ["Neon|Ride"] = 1514.37, ["Neon|Fly|Ride"] = 1506.11, ["Mega|Fly|Ride"] = 5229.93}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 50.17, ["Fly"] = 67.51, ["Ride"] = 75.8, ["Fly|Ride"] = 112.43, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 412.93, ["Mega|Fly|Ride"] = 2578.33}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.24, ["Fly"] = 44.18, ["Ride"] = 23.49, ["Fly|Ride"] = 55.55, ["Neon"] = 86.73, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 128.28, ["Mega"] = 229.69, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 385.88, ["Ride"] = 472.5, ["Fly|Ride"] = 484.31, ["Neon"] = 2340.19, ["Neon|Ride"] = 1717.73, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.3, ["Fly"] = 101.53, ["Ride"] = 34.8, ["Fly|Ride"] = 84.96, ["Neon"] = 26.85, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 129.94, ["Fly"] = 218.7, ["Ride"] = 174.56, ["Fly|Ride"] = 232.67, ["Neon"] = 548.16, ["Neon|Fly"] = 420, ["Neon|Ride"] = 678.65, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2572.48}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.13, ["Fly"] = 17.07, ["Ride"] = 18.17, ["Fly|Ride"] = 36.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 82.6, ["Mega"] = 874.13, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 206.32, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 551.25, ["Neon|Ride"] = 412.93, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1789.76}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Fly"] = 102.14, ["Ride"] = 35.09, ["Fly|Ride"] = 96.97, ["Neon"] = 165.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 290.07, ["Mega"] = 1030.23, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 44.16, ["Fly"] = 210, ["Ride"] = 81.38, ["Fly|Ride"] = 249.38, ["Neon"] = 208.69, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 344.8, ["Mega"] = 1101.45, ["Mega|Ride"] = 1307.76, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 132.63, ["Neon"] = 24.72, ["Neon|Ride"] = 104.71, ["Neon|Fly|Ride"] = 272.54, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.89, ["Fly"] = 47.25, ["Ride"] = 36.95, ["Fly|Ride"] = 92.91, ["Neon"] = 119.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 180.91, ["Mega|Ride"] = 605.89, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 412.62, ["Ride"] = 457.19, ["Fly|Ride"] = 539.44, ["Neon|Fly|Ride"] = 2745.88, ["Mega|Fly|Ride"] = 10230.96}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.11, ["Fly"] = 103.17, ["Ride"] = 55.1, ["Fly|Ride"] = 139.13, ["Neon"] = 234.35, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 209.41, ["Mega"] = 1064.3, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 58.82, ["Fly"] = 117.49, ["Ride"] = 89.76, ["Fly|Ride"] = 131.25, ["Neon"] = 412.93, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 455.25, ["Mega|Ride"] = 755.55, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 25.99, ["Fly"] = 69.21, ["Ride"] = 67.33, ["Fly|Ride"] = 193.06, ["Neon"] = 105, ["Neon|Ride"] = 232.67, ["Neon|Fly|Ride"] = 316.93, ["Mega"] = 414.74, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 625.28}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13328.26, ["Fly|Ride"] = 8190, ["Neon|Fly|Ride"] = 14436.19, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1391.25, ["Fly|Ride"] = 1573.18, ["Neon"] = 5350.95, ["Neon|Fly|Ride"] = 4528.13, ["Mega|Fly|Ride"] = 15487.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 688.03, ["Ride"] = 560.37, ["Fly|Ride"] = 618.35, ["Neon"] = 4338.65, ["Mega|Fly|Ride"] = 6744.09}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.82, ["Fly"] = 19.69, ["Ride"] = 20.99, ["Fly|Ride"] = 41.32, ["Neon"] = 110.25, ["Neon|Ride"] = 102.21, ["Neon|Fly|Ride"] = 138.34, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.88, ["Fly"] = 78.74, ["Ride"] = 25.88, ["Fly|Ride"] = 82.6, ["Neon"] = 28.62, ["Neon|Ride"] = 76.26, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 142.09, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.96, ["Fly"] = 60.82, ["Ride"] = 51.19, ["Fly|Ride"] = 99.75, ["Neon"] = 523.47, ["Neon|Ride"] = 155.9, ["Neon|Fly|Ride"] = 187.7, ["Mega|Fly|Ride"] = 524.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.82, ["Fly"] = 26.84, ["Ride"] = 18.5, ["Fly|Ride"] = 46.13, ["Neon"] = 21.96, ["Neon|Fly"] = 76.91, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 241.54}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 269.07, ["Fly"] = 369.49, ["Ride"] = 301.88, ["Fly|Ride"] = 370.32, ["Neon"] = 1241.2, ["Neon|Ride"] = 1830.99, ["Neon|Fly|Ride"] = 1312.38}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.39, ["Fly"] = 60.59, ["Ride"] = 32.82, ["Fly|Ride"] = 87.86, ["Neon"] = 91.88, ["Neon|Fly"] = 412.93, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 536.81, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.49, ["Fly"] = 15.49, ["Ride"] = 20.65, ["Fly|Ride"] = 41.3, ["Neon"] = 76.41, ["Neon|Fly"] = 123.88, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 616.86, ["Fly"] = 787.5, ["Ride"] = 435.75, ["Fly|Ride"] = 824.8, ["Neon|Ride"] = 2890.4, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1304.46, ["Fly"] = 1394.79, ["Ride"] = 1154.99, ["Fly|Ride"] = 1312.5, ["Neon"] = 4817.67, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 96.97, ["Fly"] = 129.98, ["Ride"] = 103.69, ["Fly|Ride"] = 131.57, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 493.5, ["Mega|Fly|Ride"] = 3565.73}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 154.74, ["Fly"] = 212.13, ["Ride"] = 168.75, ["Fly|Ride"] = 272.35, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.46, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2635.64}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.92, ["Ride"] = 72.12, ["Fly|Ride"] = 118.58, ["Neon"] = 252.27, ["Neon|Ride"] = 206.47, ["Neon|Fly|Ride"] = 386.08, ["Mega|Ride"] = 2064.32, ["Mega|Fly|Ride"] = 853.6}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 150.94, ["Ride"] = 273, ["Fly|Ride"] = 597.19, ["Neon|Fly"] = 930.63, ["Neon|Fly|Ride"] = 1302.87, ["Mega|Fly|Ride"] = 3715.77}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Ride"] = 2483.25, ["Fly|Ride"] = 2167.8, ["Mega|Fly|Ride"] = 24803.08}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 77.89, ["Ride"] = 82.55, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2270.75, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 612.94, ["Fly"] = 616.88, ["Ride"] = 616.88, ["Fly|Ride"] = 664.13, ["Neon|Ride"] = 1521.57, ["Neon|Fly|Ride"] = 1246.86, ["Mega|Fly|Ride"] = 3267.92}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.75, ["Fly"] = 64.22, ["Ride"] = 58.12, ["Fly|Ride"] = 89.22, ["Neon|Ride"] = 360.63, ["Neon|Fly|Ride"] = 295.49, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.83, ["Fly"] = 37.41, ["Ride"] = 20.65, ["Fly|Ride"] = 53.61, ["Neon"] = 24.53, ["Neon|Fly"] = 155.9, ["Neon|Ride"] = 44.42, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 144.33, ["Mega|Fly"] = 248.99, ["Mega|Ride"] = 179.8, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 340.67, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 465.32, ["Mega"] = 1509.2, ["Mega|Ride"] = 1376.91, ["Mega|Fly|Ride"] = 1238.61}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 830.68, ["Fly"] = 1017.03, ["Ride"] = 825.71, ["Fly|Ride"] = 905.62, ["Neon|Ride"] = 2572.77, ["Neon|Fly|Ride"] = 2334.94, ["Mega|Fly|Ride"] = 9358.53}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 675.66, ["Ride"] = 645.74, ["Fly|Ride"] = 799, ["Neon|Fly|Ride"] = 4119.85, ["Mega|Fly|Ride"] = 14863}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.3, ["Fly"] = 26.25, ["Ride"] = 24.98, ["Fly|Ride"] = 45.94, ["Neon"] = 185.83, ["Neon|Ride"] = 97.79, ["Neon|Fly|Ride"] = 179.64, ["Mega"] = 786.19, ["Mega|Ride"] = 688.47, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.91, ["Ride"] = 23.15, ["Fly|Ride"] = 59.06, ["Neon"] = 72.02, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 179.64, ["Mega"] = 507.9, ["Mega|Ride"] = 507.84, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.96, ["Ride"] = 23.63, ["Fly|Ride"] = 111.56, ["Neon"] = 22.31, ["Neon|Fly"] = 310.38, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 156.23, ["Mega"] = 165.18, ["Mega|Fly"] = 528.13, ["Mega|Ride"] = 241.4, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 46.51, ["Fly"] = 62.77, ["Ride"] = 52.31, ["Fly|Ride"] = 116.12, ["Neon"] = 153.57, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 246.75, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 362.35, ["Neon|Ride"] = 511, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1238.75, ["Mega|Ride"] = 1548.24, ["Mega|Fly|Ride"] = 1498.7}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.65, ["Fly"] = 57.19, ["Ride"] = 34.79, ["Fly|Ride"] = 85.32, ["Neon"] = 93.95, ["Neon|Fly"] = 155.9, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 201.31, ["Mega"] = 344.8, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 40.69, ["Fly"] = 56.01, ["Ride"] = 55.71, ["Fly|Ride"] = 85.32, ["Neon"] = 548.5, ["Neon|Ride"] = 232.67, ["Neon|Fly|Ride"] = 299.37, ["Mega"] = 2100, ["Mega|Ride"] = 964.04, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.84, ["Fly"] = 27.87, ["Ride"] = 18.58, ["Fly|Ride"] = 36.75, ["Neon"] = 24.02, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 91.72, ["Mega"] = 525, ["Mega|Ride"] = 275.6, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.88, ["Fly"] = 37.44, ["Ride"] = 27.87, ["Fly|Ride"] = 62.84, ["Neon"] = 25.97, ["Neon|Fly"] = 139.38, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 152.79, ["Mega"] = 193.06, ["Mega|Ride"] = 305.36, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 51.59, ["Fly"] = 65.62, ["Ride"] = 54.03, ["Fly|Ride"] = 105, ["Neon"] = 403.67, ["Neon|Ride"] = 222.98, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 1019.71}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1664.25, ["Fly"] = 1575, ["Ride"] = 1575, ["Fly|Ride"] = 1575, ["Neon|Fly"] = 4711.24, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13177.01}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.64, ["Ride"] = 459.38, ["Fly|Ride"] = 619.39, ["Neon|Ride"] = 3028.72, ["Neon|Fly|Ride"] = 3013.24, ["Mega|Fly|Ride"] = 9634.12}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 274.32, ["Ride"] = 315, ["Fly|Ride"] = 525, ["Neon"] = 1542.24, ["Neon|Ride"] = 1486.5, ["Neon|Fly|Ride"] = 1514.37, ["Mega|Fly|Ride"] = 7244.68}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 49.88}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.57, ["Ride"] = 47.14, ["Fly|Ride"] = 96.97, ["Neon"] = 330.38, ["Neon|Fly"] = 412.93, ["Neon|Ride"] = 353.06, ["Neon|Fly|Ride"] = 344.8, ["Mega|Ride"] = 1100.28, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41260.48, ["Fly"] = 65625, ["Ride"] = 34781.25, ["Fly|Ride"] = 17981.24, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 430.07, ["Fly"] = 441.51, ["Ride"] = 412.62, ["Fly|Ride"] = 433.25, ["Neon"] = 1032.29, ["Neon|Fly"] = 1241.22, ["Neon|Ride"] = 1135.52, ["Neon|Fly|Ride"] = 1101.45, ["Mega"] = 6193.69, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 136.73, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 202.42, ["Mega|Fly|Ride"] = 4128.63}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 129.39, ["Fly"] = 262.49, ["Ride"] = 124.74, ["Fly|Ride"] = 138.25, ["Neon"] = 697.97, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 803.13, ["Mega|Fly|Ride"] = 2476.15}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 16.52, ["Fly"] = 94.5, ["Ride"] = 35.44, ["Fly|Ride"] = 97.05, ["Neon"] = 392.44, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 274.61, ["Mega"] = 695.65, ["Mega|Ride"] = 604.57, ["Mega|Fly|Ride"] = 619.32}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4896.61, ["Ride"] = 4814.09, ["Fly|Ride"] = 4462.49, ["Neon"] = 20645.6, ["Neon|Fly|Ride"] = 27527.82, ["Mega|Fly|Ride"] = 62006.53}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 25.65, ["Fly"] = 48.57, ["Ride"] = 34.89, ["Fly|Ride"] = 58.73, ["Neon"] = 229.18, ["Neon|Ride"] = 221.03, ["Neon|Fly|Ride"] = 169.32, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.36, ["Fly"] = 155.76, ["Ride"] = 58.12, ["Fly|Ride"] = 82.6, ["Neon"] = 400.54, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1551.82, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 770.44, ["Fly"] = 918.75, ["Ride"] = 805.88, ["Fly|Ride"] = 936.29, ["Neon"] = 2890.4, ["Neon|Ride"] = 2615.82, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9082.95}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.45, ["Fly"] = 28.74, ["Ride"] = 27.57, ["Fly|Ride"] = 49.53, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 157.4, ["Mega|Fly|Ride"] = 748.73}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.71, ["Fly"] = 96.97, ["Ride"] = 30.96, ["Fly|Ride"] = 465.32, ["Neon"] = 69.18, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 408.8, ["Mega|Ride"] = 412.88}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 88.15, ["Ride"] = 128.63, ["Fly|Ride"] = 206.32, ["Neon"] = 485.63, ["Neon|Ride"] = 530.66, ["Neon|Fly|Ride"] = 578.09, ["Mega|Fly|Ride"] = 2546.34}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.26, ["Fly"] = 138.25, ["Ride"] = 55.82, ["Fly|Ride"] = 138.45, ["Neon"] = 97.13, ["Neon|Ride"] = 128.02, ["Neon|Fly|Ride"] = 378.87, ["Mega"] = 242.82, ["Mega|Fly"] = 738.69, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3937.5, ["Ride"] = 4442.63, ["Fly|Ride"] = 3806.25, ["Neon|Ride"] = 12280.02, ["Neon|Fly|Ride"] = 9502.67, ["Mega"] = 61935.77, ["Mega|Fly|Ride"] = 32755.35}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 48.49, ["Ride"] = 78.74, ["Fly|Ride"] = 136.27, ["Neon"] = 393.32, ["Neon|Ride"] = 181, ["Neon|Fly|Ride"] = 399.51, ["Mega|Ride"] = 1340.78, ["Mega|Fly|Ride"] = 1376.91}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 6767.25, ["Neon|Ride"] = 16516.48, ["Neon|Fly|Ride"] = 15736.88, ["Mega|Fly|Ride"] = 69756.46}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.68, ["Fly"] = 20.65, ["Ride"] = 16.01, ["Fly|Ride"] = 41.15, ["Neon"] = 23.14, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 79.16, ["Mega"] = 450.2, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 26.15, ["Ride"] = 30.19, ["Fly|Ride"] = 55.13, ["Neon"] = 138.34, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 1181.93, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.12, ["Ride"] = 39.25, ["Fly|Ride"] = 116, ["Neon"] = 275.63, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 775.24, ["Mega|Ride"] = 964.04, ["Mega|Fly|Ride"] = 756.46}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 32.82, ["Fly"] = 190.37, ["Ride"] = 55.71, ["Fly|Ride"] = 150.73, ["Neon"] = 200.27, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 294.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.02, ["Fly"] = 23.55, ["Ride"] = 20.93, ["Fly|Ride"] = 40.43, ["Neon|Ride"] = 110.48, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 728.44, ["Mega|Ride"] = 580.15, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8356.29}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.18}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 157.5, ["Ride"] = 196.87, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1032.29}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.85, ["Fly"] = 123.8, ["Ride"] = 39.85, ["Fly|Ride"] = 105, ["Neon"] = 139.61, ["Neon|Ride"] = 112.18, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 722.61, ["Mega|Ride"] = 930.09, ["Mega|Fly|Ride"] = 953.73}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 69.82, ["Neon"] = 102.9, ["Neon|Ride"] = 97.05, ["Mega|Fly|Ride"] = 825.74}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 138.25, ["Fly"] = 412.62, ["Ride"] = 136.5, ["Fly|Ride"] = 481.05, ["Neon"] = 701.37, ["Neon|Ride"] = 860.84, ["Neon|Fly|Ride"] = 825.84, ["Mega|Ride"] = 3165.63, ["Mega|Fly|Ride"] = 3028.35}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 104.9, ["Ride"] = 135.19, ["Fly|Ride"] = 211.32, ["Neon"] = 613.49, ["Neon|Ride"] = 684.87, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 3302.9, ["Mega|Fly|Ride"] = 3302.9}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 167.99, ["Fly"] = 186.62, ["Ride"] = 207.38, ["Fly|Ride"] = 249.05, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 1003.67, ["Mega|Fly|Ride"] = 4066.69}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2475.64, ["Ride"] = 1575, ["Fly|Ride"] = 1785, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 34105.11}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.44, ["Fly"] = 96.97, ["Ride"] = 39.53, ["Fly|Ride"] = 69.01, ["Neon"] = 156.93, ["Neon|Ride"] = 204.41, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 928.04, ["Mega|Ride"] = 898, ["Mega|Fly|Ride"] = 687.43}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 804.79, ["Fly"] = 2100, ["Ride"] = 727.65, ["Fly|Ride"] = 963.45, ["Neon|Ride"] = 2947.72, ["Neon|Fly|Ride"] = 4033.04}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 45.94}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.2, ["Ride"] = 39.38, ["Fly|Ride"] = 138.34, ["Neon"] = 99.75, ["Neon|Ride"] = 123.88, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 465.32, ["Mega|Ride"] = 462.58, ["Mega|Fly|Ride"] = 620.85}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.55, ["Fly"] = 48.49, ["Ride"] = 27.57, ["Fly|Ride"] = 70.87, ["Neon"] = 62.84, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 918.75, ["Mega|Ride"] = 344.75, ["Mega|Fly|Ride"] = 356.93}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 70.88}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21.67, ["Ride"] = 23.63, ["Fly|Ride"] = 69.18, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 918.75, ["Mega|Ride"] = 825.74, ["Mega|Fly|Ride"] = 1426.53}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.57, ["Fly"] = 51.59, ["Ride"] = 41.03, ["Fly|Ride"] = 57.7, ["Neon|Ride"] = 412.93, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 882.62, ["Mega|Ride"] = 1743.93, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 11003.14, ["Ride"] = 5250, ["Fly|Ride"] = 5053.02, ["Neon|Fly|Ride"] = 10926.2, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Fly"] = 56.14, ["Ride"] = 35.44, ["Fly|Ride"] = 105, ["Neon"] = 81.57, ["Neon|Ride"] = 78.61, ["Neon|Fly|Ride"] = 164.14, ["Mega"] = 521.15, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.83}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 94.65, ["Fly"] = 365.17, ["Ride"] = 135.14, ["Fly|Ride"] = 196.88, ["Neon"] = 524.99, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 725.7, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 49.37, ["Fly"] = 109.28, ["Ride"] = 89.25, ["Fly|Ride"] = 204.41, ["Neon"] = 259.77, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 713.83, ["Mega"] = 2326.55, ["Mega|Ride"] = 2786.82, ["Mega|Fly|Ride"] = 1651.46}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 26.25, ["Fly"] = 70.46, ["Ride"] = 31.5, ["Fly|Ride"] = 79.75, ["Neon"] = 172.4, ["Neon|Ride"] = 165.18, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 1016.21, ["Mega|Ride"] = 841.21, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.41, ["Fly"] = 68.16, ["Ride"] = 23.63, ["Fly|Ride"] = 59.07, ["Neon"] = 37.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 179.64, ["Mega"] = 157.5, ["Mega|Fly"] = 344.8, ["Mega|Ride"] = 251.81, ["Mega|Fly|Ride"] = 334.67}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.95, ["Fly"] = 138.25, ["Ride"] = 26.25, ["Fly|Ride"] = 63, ["Neon"] = 103.24, ["Neon|Ride"] = 124.49, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 721.24, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 605.89}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.47, ["Fly"] = 30.08, ["Ride"] = 30.33, ["Fly|Ride"] = 55.13, ["Neon"] = 206.47, ["Neon|Ride"] = 262.22, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 757.62}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.32}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.62, ["Ride"] = 291.38, ["Fly|Ride"] = 273.78, ["Neon"] = 190.3, ["Neon|Ride"] = 206.47, ["Mega"] = 825.84, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 192.91, ["Fly"] = 464.94, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.71, ["Neon"] = 1238.75}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 42, ["Fly"] = 212.02, ["Ride"] = 110.25, ["Fly|Ride"] = 206.47, ["Neon"] = 258.24, ["Neon|Ride"] = 422.41, ["Neon|Fly|Ride"] = 525, ["Mega"] = 896.56, ["Mega|Ride"] = 2171.77, ["Mega|Fly|Ride"] = 1204.54}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1158.85, ["Ride"] = 931.88, ["Fly|Ride"] = 1018.5, ["Neon|Fly"] = 4024.91, ["Neon|Ride"] = 3138.15, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 385.81, ["Fly"] = 464.94, ["Ride"] = 378, ["Fly|Ride"] = 468.33, ["Neon"] = 2862.9, ["Neon|Ride"] = 1514.37, ["Neon|Fly|Ride"] = 1940.7, ["Mega|Fly|Ride"] = 6954.94}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 69.57}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.5, ["Fly"] = 30.23, ["Ride"] = 24.77, ["Fly|Ride"] = 48.63, ["Neon"] = 78.73, ["Neon|Fly"] = 116.34, ["Neon|Ride"] = 155.9, ["Neon|Fly|Ride"] = 166.69, ["Mega|Ride"] = 687.43, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.5, ["Fly"] = 412.62, ["Ride"] = 330.75, ["Fly|Ride"] = 428.73, ["Neon"] = 1056.04, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1080.81, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 20.93}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 144.38, ["Fly"] = 256.88, ["Ride"] = 183.75, ["Fly|Ride"] = 324.15, ["Neon"] = 757.71, ["Neon|Fly"] = 1721.86, ["Neon|Ride"] = 923.9, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9909.9, ["Mega|Ride"] = 11741.78, ["Mega|Fly|Ride"] = 2946.06}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Ride"] = 125.89, ["Fly|Ride"] = 204.41, ["Neon"] = 675.12, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2423.51}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.92, ["Ride"] = 29.3, ["Fly|Ride"] = 168.28, ["Neon"] = 31.43, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 228.16, ["Mega"] = 264.75, ["Mega|Ride"] = 509.23, ["Mega|Fly|Ride"] = 815.41}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.11, ["Fly"] = 63.03, ["Ride"] = 32.82, ["Fly|Ride"] = 70.33, ["Neon"] = 177.19, ["Neon|Ride"] = 110.48, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 803.03, ["Mega|Fly|Ride"] = 621.36}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.25, ["Fly"] = 102.33, ["Ride"] = 39.22, ["Fly|Ride"] = 102.21, ["Neon"] = 93.08, ["Neon|Ride"] = 131.12, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.65, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 454.16}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 131.25, ["Ride"] = 51.19, ["Fly|Ride"] = 170.62, ["Neon"] = 24.78, ["Neon|Fly"] = 232.67, ["Neon|Ride"] = 67.54, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 170.62, ["Mega|Fly"] = 309.7, ["Mega|Ride"] = 178.48, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.95, ["Ride"] = 346.49, ["Fly|Ride"] = 399.84, ["Neon"] = 1620.69, ["Neon|Ride"] = 1324.98, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5229.93}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 148.56, ["Fly"] = 204.26, ["Ride"] = 237.62, ["Fly|Ride"] = 328.13, ["Neon"] = 656.25, ["Neon|Ride"] = 3837.23, ["Mega"] = 9909.9, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3715.77}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 80.07, ["Fly"] = 167.45, ["Ride"] = 102.15, ["Fly|Ride"] = 186.14, ["Neon"] = 272.22, ["Neon|Ride"] = 473.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1651.46}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 12.85, ["Ride"] = 58.24, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 590.94, ["Neon|Fly|Ride"] = 482.09, ["Mega|Ride"] = 412.88, ["Mega|Fly|Ride"] = 1857.9}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.51, ["Fly"] = 75.63, ["Ride"] = 41.28, ["Fly|Ride"] = 98.09, ["Neon"] = 77.39, ["Neon|Fly"] = 206.47, ["Neon|Ride"] = 101.22, ["Neon|Fly|Ride"] = 152.79, ["Mega"] = 343.18, ["Mega|Fly"] = 525, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 454.77}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.68, ["Fly"] = 52.45, ["Ride"] = 25.58, ["Fly|Ride"] = 82.6, ["Neon"] = 19.59, ["Neon|Ride"] = 34.8, ["Neon|Fly|Ride"] = 134.22, ["Mega"] = 131.24, ["Mega|Ride"] = 160.63, ["Mega|Fly|Ride"] = 254.52}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 992.25, ["Fly"] = 1082.72, ["Ride"] = 945, ["Fly|Ride"] = 1053.94, ["Neon"] = 3047.71, ["Neon|Fly"] = 3413.03, ["Neon|Ride"] = 3028.72, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 9456.66}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 571.88, ["Ride"] = 447.69, ["Fly|Ride"] = 551.25, ["Neon"] = 1395.92, ["Neon|Fly"] = 1377.08, ["Neon|Ride"] = 1544.3, ["Neon|Fly|Ride"] = 1706.52, ["Mega"] = 10322.81, ["Mega|Fly|Ride"] = 6271.42}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 74.82, ["Fly"] = 138.25, ["Ride"] = 91.88, ["Fly|Ride"] = 206.47, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 463.51, ["Mega"] = 1582.05, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 267.54, ["Fly"] = 379.61, ["Ride"] = 268.21, ["Fly|Ride"] = 354.37, ["Neon"] = 1101.45, ["Neon|Ride"] = 1395.93, ["Neon|Fly|Ride"] = 1386.63, ["Mega"] = 10322.81, ["Mega|Fly|Ride"] = 5115.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.36, ["Fly"] = 138.25, ["Ride"] = 32.82, ["Fly|Ride"] = 71.21, ["Neon"] = 139.61, ["Neon|Ride"] = 216.38, ["Neon|Fly|Ride"] = 232.67, ["Mega|Fly|Ride"] = 774.31}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 233.88, ["Ride"] = 236.25, ["Fly|Ride"] = 472.4, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 930.63, ["Mega"] = 4105.61, ["Mega|Ride"] = 4266.93, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 76.13, ["Ride"] = 71.92, ["Fly|Ride"] = 132.53, ["Neon|Ride"] = 450.2, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 1376.91}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1788.66, ["Ride"] = 1788.66, ["Fly|Ride"] = 1779.75, ["Neon"] = 6577.01, ["Neon|Ride"] = 10857.92, ["Neon|Fly|Ride"] = 5919.11, ["Mega"] = 49549.43, ["Mega|Fly|Ride"] = 23395.79}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 23.26, ["Fly"] = 82.22, ["Ride"] = 45.4, ["Fly|Ride"] = 114.33, ["Neon"] = 68.25, ["Neon|Fly"] = 185.83, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 176.09, ["Mega"] = 317.09, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 335.58, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 51.65, ["Fly"] = 119.1, ["Ride"] = 74.28, ["Fly|Ride"] = 161.44, ["Neon"] = 223.13, ["Neon|Ride"] = 293.18, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1019.91, ["Mega|Ride"] = 1012.56, ["Mega|Fly|Ride"] = 961.97}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.76, ["Ride"] = 78.11, ["Fly|Ride"] = 97.13, ["Neon"] = 412.93, ["Neon|Ride"] = 455.25, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3437.01, ["Ride"] = 1049.99, ["Fly|Ride"] = 1171.86, ["Mega|Fly|Ride"] = 20772.33}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 530.21, ["Fly"] = 823.16, ["Ride"] = 550.85, ["Fly|Ride"] = 672.37, ["Neon|Fly|Ride"] = 2791.85, ["Mega|Fly|Ride"] = 18601.74}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 94.5, ["Ride"] = 141.75, ["Fly|Ride"] = 215.25, ["Neon"] = 446.8, ["Neon|Fly"] = 619.39, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 536.81, ["Mega"] = 4129.13, ["Mega|Ride"] = 1395.14, ["Mega|Fly|Ride"] = 2709.26}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.36, ["Ride"] = 32.71, ["Fly|Ride"] = 93.08, ["Neon"] = 76.41, ["Neon|Fly"] = 138.34, ["Neon|Ride"] = 101.22, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 755.09, ["Mega|Fly|Ride"] = 825.74}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.38, ["Fly"] = 69.13, ["Ride"] = 48.56, ["Fly|Ride"] = 103.24, ["Neon"] = 196.88, ["Neon|Fly"] = 412.93, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 729.75, ["Ride"] = 874.13, ["Fly|Ride"] = 918.75, ["Neon"] = 3028.72, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 971.25}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6036.42, ["Ride"] = 4987.5, ["Fly|Ride"] = 5208.08, ["Neon"] = 42000, ["Neon|Ride"] = 29586.19, ["Neon|Fly|Ride"] = 24087.24, ["Mega|Fly|Ride"] = 88077.65}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 288.65, ["Fly"] = 410.93, ["Ride"] = 295.24, ["Neon"] = 1651.67, ["Neon|Ride"] = 2064.57, ["Neon|Fly|Ride"] = 2064.57, ["Mega"] = 6192.66, ["Mega|Fly|Ride"] = 6192.93}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.58, ["Fly"] = 275.43, ["Ride"] = 110.39, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 523.38, ["Neon|Fly|Ride"] = 1651.67, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.96, ["Fly"] = 58.82, ["Ride"] = 36.9, ["Neon"] = 147.75, ["Neon|Fly"] = 1241.22, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 659.65, ["Mega|Ride"] = 722.52, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.64, ["Fly"] = 26.17, ["Ride"] = 27.2, ["Fly|Ride"] = 44.35, ["Neon"] = 206.47, ["Neon|Ride"] = 310.61, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2188.18}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.44, ["Fly"] = 274.3, ["Ride"] = 39.19, ["Fly|Ride"] = 140.44, ["Neon"] = 154.88, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 202.42, ["Mega"] = 670.69, ["Mega|Ride"] = 614.14, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.87, ["Fly"] = 21, ["Ride"] = 21, ["Fly|Ride"] = 57.75, ["Neon"] = 23, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 275.63, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 310.44}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.87, ["Ride"] = 43.32, ["Fly|Ride"] = 97.05, ["Neon"] = 172.4, ["Neon|Fly"] = 825.84, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 330.35, ["Mega"] = 779.39, ["Mega|Ride"] = 675.04, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 381.65, ["Fly"] = 462.61, ["Ride"] = 399.2, ["Fly|Ride"] = 469.88, ["Neon"] = 1341.98, ["Neon|Fly"] = 1461.72, ["Neon|Ride"] = 1362.62, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 4858.35}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.6, ["Fly"] = 15.65, ["Ride"] = 14.43, ["Fly|Ride"] = 42, ["Neon"] = 18.38, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 86.43, ["Mega"] = 464.55, ["Mega|Ride"] = 542.95, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.62, ["Fly"] = 95.23, ["Ride"] = 95.92, ["Fly|Ride"] = 144.38, ["Neon"] = 204.75, ["Neon|Fly"] = 289.27, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 261.01, ["Mega"] = 688.55, ["Mega|Fly"] = 825.84, ["Mega|Ride"] = 582.63, ["Mega|Fly|Ride"] = 551.23}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 949.01, ["Fly"] = 976.36, ["Ride"] = 813.74, ["Fly|Ride"] = 876.91, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1509.27, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.33, ["Fly"] = 91.88, ["Ride"] = 46.51, ["Fly|Ride"] = 69.68, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 321.57, ["Fly"] = 339.71, ["Ride"] = 336, ["Fly|Ride"] = 354.38, ["Neon|Ride"] = 1441.08, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 13951.31}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 183.75, ["Fly"] = 232.47, ["Ride"] = 190.32, ["Fly|Ride"] = 200.09, ["Neon"] = 633.63, ["Neon|Ride"] = 799, ["Neon|Fly|Ride"] = 750.08, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 630, ["Fly|Ride"] = 799, ["Neon|Ride"] = 2615.82, ["Neon|Fly|Ride"] = 3000.85, ["Mega|Fly|Ride"] = 6823.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 23.35, ["Ride"] = 43.21, ["Fly|Ride"] = 108.94, ["Neon"] = 78.75, ["Neon|Fly"] = 279.2, ["Neon|Ride"] = 107.37, ["Neon|Fly|Ride"] = 269.9, ["Mega"] = 274.61, ["Mega|Ride"] = 356.93, ["Mega|Fly|Ride"] = 516.09}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3255, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3313.41, ["Neon"] = 13764.43, ["Neon|Fly|Ride"] = 6759.38, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 111.57, ["Fly"] = 157.5, ["Ride"] = 127.35, ["Fly|Ride"] = 161.33, ["Neon"] = 550.97, ["Neon|Fly"] = 482.09, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 547.82, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 26.77, ["Ride"] = 18.86, ["Fly|Ride"] = 52.5, ["Neon"] = 18.38, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 148.38, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 288.33}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 24.55, ["Fly|Ride"] = 58.17, ["Neon"] = 15.75, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.49, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.34, ["Ride"] = 35.27, ["Fly|Ride"] = 58.9, ["Neon"] = 279.2, ["Neon|Ride"] = 378.87, ["Neon|Fly|Ride"] = 343.18, ["Mega|Fly|Ride"] = 1101.32}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 838.13, ["Ride"] = 1165.82, ["Fly|Ride"] = 1247.4}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6221.25, ["Ride"] = 7051.77, ["Fly|Ride"] = 6562.5}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.59, ["Fly"] = 35.35, ["Ride"] = 27.56, ["Fly|Ride"] = 55.12, ["Neon"] = 667.9, ["Neon|Ride"] = 155.9, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2428.13, ["Mega|Ride"] = 961.97, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.39, ["Fly"] = 39.38, ["Ride"] = 26.84, ["Fly|Ride"] = 85.32, ["Neon"] = 72.19, ["Neon|Ride"] = 94.21, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 648.98, ["Mega|Ride"] = 578.02, ["Mega|Fly|Ride"] = 497.61}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 45.94, ["Fly"] = 157.49, ["Ride"] = 67.17, ["Fly|Ride"] = 91.88, ["Neon"] = 301.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Fly"] = 296.06, ["Ride"] = 275.43, ["Fly|Ride"] = 325.19, ["Neon"] = 1005.46, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10322.81, ["Mega|Fly|Ride"] = 3950.05}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.2, ["Ride"] = 32.69, ["Fly|Ride"] = 86.52, ["Neon"] = 23.77, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 139.02, ["Mega|Ride"] = 188.9, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 219.19, ["Fly"] = 309.47, ["Ride"] = 232.47, ["Fly|Ride"] = 301.63, ["Neon"] = 711.43, ["Neon|Ride"] = 946.91, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.57, ["Fly"] = 44.38, ["Ride"] = 15.49, ["Fly|Ride"] = 45.94, ["Neon"] = 26.81, ["Neon|Fly"] = 123.04, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 293.87}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196, ["Fly"] = 268.82, ["Ride"] = 206.32, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10322.81, ["Mega|Ride"] = 4128.63, ["Mega|Fly|Ride"] = 4127.6}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.13, ["Fly"] = 76.33, ["Ride"] = 26.84, ["Fly|Ride"] = 61.9, ["Neon"] = 66.65, ["Neon|Fly"] = 295.49, ["Neon|Ride"] = 93.08, ["Neon|Fly|Ride"] = 152.79, ["Mega|Ride"] = 619.32, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.52, ["Fly"] = 69.13, ["Ride"] = 13.02, ["Fly|Ride"] = 59.06, ["Neon"] = 12.47, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 77.35, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 192.05}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.6, ["Neon|Ride"] = 41.3, ["Mega"] = 18.26, ["Mega|Ride"] = 137.21, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.56, ["Fly"] = 52.48, ["Ride"] = 22.64, ["Fly|Ride"] = 45.94, ["Neon"] = 10.37, ["Neon|Ride"] = 43.3, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 63.84, ["Mega|Fly"] = 155102.72, ["Mega|Ride"] = 97.54, ["Mega|Fly|Ride"] = 161.81}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 84.55, ["Fly"] = 138.25, ["Ride"] = 112.4, ["Fly|Ride"] = 181.07, ["Neon"] = 347.16, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 377.7, ["Mega"] = 1129.32, ["Mega|Ride"] = 1341.81, ["Mega|Fly|Ride"] = 1101.02}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.73, ["Fly|Ride"] = 103.47, ["Neon"] = 4.79, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 137.49, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.76, ["Ride"] = 101.07, ["Neon"] = 71.91, ["Neon|Ride"] = 210, ["Mega"] = 497.89}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 46.61, ["Mega"] = 15.57, ["Mega|Ride"] = 78.31, ["Mega|Fly|Ride"] = 206.63}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 39.69, ["Ride"] = 15, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 12.29, ["Neon|Fly|Ride"] = 31.83, ["Mega"] = 13.77, ["Mega|Fly"] = 38.07, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 48.9}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 11.36, ["Fly|Ride"] = 39.26, ["Neon"] = 3.94, ["Neon|Fly"] = 16.44, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 27.2, ["Mega|Fly"] = 155.9, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 109.3}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 103.24, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 103.24, ["Mega"] = 19.69, ["Mega|Ride"] = 121.85, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 4.54, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 37.31, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 18.2, ["Mega|Ride"] = 100.01, ["Mega|Fly|Ride"] = 165.16}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 4.97, ["Fly"] = 69.13, ["Ride"] = 17.31, ["Fly|Ride"] = 70.12, ["Neon"] = 11.15, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.41, ["Mega"] = 104.74, ["Mega|Fly"] = 155.9, ["Mega|Ride"] = 117.5, ["Mega|Fly|Ride"] = 169.21}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 15.27, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 185.81}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.99, ["Fly|Ride"] = 524.99, ["Neon"] = 19.69, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.5, ["Ride"] = 27.56, ["Neon"] = 14.85, ["Mega"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.12, ["Neon|Ride"] = 26.67, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 20.9, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 158.79}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.49, ["Fly|Ride"] = 30.03, ["Neon"] = 2.1, ["Neon|Fly"] = 19.63, ["Neon|Ride"] = 12.29, ["Neon|Fly|Ride"] = 31.04, ["Mega"] = 15.74, ["Mega|Fly"] = 39.24, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 51.27}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.93, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 34.92, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 5.25, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.75, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 160.32}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.41, ["Ride"] = 27.87, ["Neon"] = 10.01, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 95.32, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.61, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 18.34, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.82, ["Ride"] = 11.64, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 13.9, ["Neon|Ride"] = 11.74, ["Neon|Fly|Ride"] = 26.45, ["Mega"] = 15.21, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 16.75, ["Mega|Fly|Ride"] = 44.18}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 20.51, ["Fly|Ride"] = 138.34, ["Neon"] = 12.46, ["Neon|Ride"] = 115.18, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 91.77, ["Mega|Ride"] = 155.8}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.56, ["Fly"] = 91.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 67.37, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 138.34, ["Mega|Ride"] = 285.57, ["Mega|Fly|Ride"] = 395.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 11.64, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 14.41, ["Neon|Fly|Ride"] = 40.62, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 61.94, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 6.99, ["Fly"] = 172.29, ["Ride"] = 30.19, ["Neon"] = 3.82, ["Neon|Ride"] = 26.09, ["Neon|Fly|Ride"] = 131.76, ["Mega"] = 74.74, ["Mega|Fly"] = 165.18, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 239.52}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 27.87, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 34.12, ["Mega|Fly"] = 138.34, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.91, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 15.05, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 158.79}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.97, ["Ride"] = 19.62, ["Fly|Ride"] = 41.91, ["Neon"] = 5.16, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 18.59, ["Neon|Fly|Ride"] = 97.05, ["Mega"] = 65.01, ["Mega|Ride"] = 82.59, ["Mega|Fly|Ride"] = 206.45}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.16, ["Neon"] = 5.09, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 35.82, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 44.88, ["Neon"] = 7.76, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 20.35, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.2, ["Ride"] = 68.1, ["Neon"] = 37.49, ["Neon|Ride"] = 74.34, ["Mega"] = 98.44, ["Mega|Ride"] = 206.45, ["Mega|Fly|Ride"] = 825.74}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 17.37, ["Fly|Ride"] = 138.34, ["Neon"] = 19.46, ["Neon|Fly"] = 104.52, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 8.39, ["Fly"] = 22.71, ["Ride"] = 19.62, ["Fly|Ride"] = 39, ["Neon"] = 9.32, ["Neon|Fly"] = 26.23, ["Neon|Ride"] = 29.82, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 272.54, ["Mega|Fly"] = 411.9, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 7.56, ["Fly"] = 110.93, ["Fly|Ride"] = 137.82, ["Neon"] = 31.43, ["Neon|Ride"] = 32.82, ["Mega"] = 213.75, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.45, ["Ride"] = 56.44, ["Neon"] = 121.7, ["Neon|Ride"] = 206.47, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 64.89, ["Fly|Ride"] = 104.71, ["Neon"] = 39.1, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 275.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.09, ["Ride"] = 30.09, ["Fly|Ride"] = 120.75, ["Neon"] = 53.44, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 179.45, ["Mega"] = 248.07, ["Mega|Ride"] = 248.81, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 64.99, ["Mega"] = 15, ["Mega|Fly"] = 123.88, ["Mega|Ride"] = 123.87, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.85}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.72, ["Fly"] = 22.91, ["Ride"] = 21.95, ["Fly|Ride"] = 39.38, ["Neon"] = 39.19, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 310.01, ["Mega|Ride"] = 309.66, ["Mega|Fly|Ride"] = 302.59}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.56, ["Neon"] = 3.08, ["Neon|Ride"] = 26.61, ["Mega"] = 30.53, ["Mega|Fly"] = 138.34, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 27.77, ["Fly|Ride"] = 275.43, ["Neon"] = 3.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 408.98, ["Mega"] = 77.42, ["Mega|Ride"] = 73.68, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.49, ["Ride"] = 15.68, ["Fly|Ride"] = 55.13, ["Neon"] = 6.55, ["Neon|Ride"] = 53.01, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 125.23, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.38, ["Ride"] = 49.53, ["Fly|Ride"] = 62.84, ["Neon"] = 35.04, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 214.39, ["Mega"] = 328.13, ["Mega|Ride"] = 272.69, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.62, ["Ride"] = 32.81, ["Neon"] = 3.89, ["Mega"] = 17.64, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.55, ["Ride"] = 15.78, ["Fly|Ride"] = 275274.95, ["Neon"] = 3.92, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 77.96, ["Mega"] = 27.16, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 46.52, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.62, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 4.92, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 15.56, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.94, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 155.8}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 27.87, ["Fly|Ride"] = 147.75, ["Neon"] = 2.15, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 110.77, ["Mega"] = 26.16, ["Mega|Fly"] = 124.49, ["Mega|Ride"] = 75.51, ["Mega|Fly|Ride"] = 162.42}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.54, ["Neon|Ride"] = 164.42, ["Neon|Fly|Ride"] = 149827.31, ["Mega"] = 20.9, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 146.22}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.46, ["Fly|Ride"] = 45.94, ["Neon"] = 3.92, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 65, ["Mega"] = 18.65, ["Mega|Fly"] = 61.95, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.49, ["Neon"] = 2.63, ["Mega"] = 18.27, ["Mega|Ride"] = 224.6}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 3.52, ["Neon|Ride"] = 155.9, ["Neon|Fly|Ride"] = 420, ["Mega"] = 17.91, ["Mega|Ride"] = 155.8}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.15, ["Fly|Ride"] = 49.88, ["Neon"] = 3.62, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 91.76, ["Mega|Ride"] = 92.64, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.65, ["Ride"] = 139.49, ["Neon"] = 123.88, ["Mega"] = 688.55, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.52, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 54.76, ["Neon|Ride"] = 204.41, ["Mega"] = 1572.17, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.81, ["Ride"] = 30.18, ["Fly|Ride"] = 410.17, ["Neon"] = 54.51, ["Neon|Fly|Ride"] = 262.22, ["Mega"] = 295.25, ["Mega|Ride"] = 353.01, ["Mega|Fly|Ride"] = 370.22}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.71, ["Ride"] = 15.49, ["Fly|Ride"] = 24.29, ["Neon"] = 2.1, ["Neon|Fly"] = 11.71, ["Neon|Ride"] = 11.79, ["Neon|Fly|Ride"] = 27.77, ["Mega"] = 17.36, ["Mega|Fly"] = 32.75, ["Mega|Ride"] = 19.47, ["Mega|Fly|Ride"] = 47.99}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Fly"] = 118.12, ["Ride"] = 57.78, ["Fly|Ride"] = 110.48, ["Neon"] = 15.75, ["Neon|Fly"] = 90.86, ["Neon|Ride"] = 32.02, ["Neon|Fly|Ride"] = 688.55, ["Mega"] = 51.66, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 21.03, ["Neon|Fly|Ride"] = 55.76, ["Mega"] = 14.74, ["Mega|Fly"] = 85.72, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 103.23}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.84, ["Neon"] = 2.52, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 117.69, ["Mega"] = 15.39, ["Mega|Ride"] = 103.23, ["Mega|Fly|Ride"] = 162.02}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 20.58, ["Fly|Ride"] = 56.44, ["Neon"] = 10.4, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 208.85, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 161.09, ["Ride"] = 206.32, ["Fly|Ride"] = 246.63, ["Neon|Ride"] = 1031.26, ["Mega"] = 8258.24, ["Mega|Fly|Ride"] = 3565.07}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 18.58, ["Neon"] = 7.35, ["Neon|Ride"] = 82.6, ["Mega"] = 83.61, ["Mega|Ride"] = 124.42, ["Mega|Fly|Ride"] = 825.74}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 63.67, ["Ride"] = 25.57, ["Fly|Ride"] = 62.84, ["Neon"] = 31.43, ["Neon|Ride"] = 93.08, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 357.33, ["Mega|Fly|Ride"] = 403.44}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 14.25, ["Ride"] = 14.38, ["Fly|Ride"] = 32.13, ["Neon"] = 4.66, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.68, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.13, ["Neon|Fly"] = 551.25, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.81, ["Fly"] = 18.29, ["Ride"] = 16.44, ["Fly|Ride"] = 35.44, ["Neon"] = 28.88, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.81, ["Mega|Ride"] = 268.37, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 34.21, ["Fly|Ride"] = 249.58, ["Neon"] = 54.76, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 613.19, ["Mega"] = 340.45, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.91, ["Fly"] = 15.75, ["Ride"] = 14.73, ["Fly|Ride"] = 39.24, ["Neon"] = 15.65, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 76.06, ["Mega|Ride"] = 234.31, ["Mega|Fly|Ride"] = 234.31}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 60.98, ["Fly"] = 171.25, ["Ride"] = 93.56, ["Fly|Ride"] = 157.4, ["Neon"] = 349.82, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 366.87}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.57, ["Fly"] = 330.1, ["Ride"] = 231.25, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1170.62, ["Neon|Fly|Ride"] = 1238.75, ["Mega"] = 10322.81, ["Mega|Fly|Ride"] = 4128.63}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 51.23, ["Fly"] = 110.39, ["Ride"] = 76.7, ["Fly|Ride"] = 123.58, ["Neon"] = 692.34, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1237.57, ["Mega|Fly|Ride"] = 1093.63}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Fly"] = 17.36, ["Ride"] = 26.84, ["Fly|Ride"] = 138.34, ["Neon"] = 23.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 165.18, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 263.93}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.87, ["Fly"] = 69.13, ["Ride"] = 31.4, ["Fly|Ride"] = 89.82, ["Neon"] = 72.1, ["Neon|Ride"] = 96.97, ["Mega"] = 353.07, ["Mega|Ride"] = 344.75, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 16.72, ["Ride"] = 17.82, ["Fly|Ride"] = 34.93, ["Neon"] = 5.25, ["Neon|Fly"] = 25.6, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 176.51}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 27.87, ["Ride"] = 19.69, ["Fly|Ride"] = 302.87, ["Neon"] = 95.86, ["Neon|Fly"] = 344.8, ["Neon|Ride"] = 162.88, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 604.57}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 15.9, ["Fly|Ride"] = 52.49, ["Neon"] = 11.82, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 103.63, ["Mega|Ride"] = 202.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.43, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 25.6, ["Neon|Ride"] = 55.76, ["Mega"] = 207.37, ["Mega|Ride"] = 232.54}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 17.45, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 53.69, ["Mega"] = 15, ["Mega|Fly"] = 41.3, ["Mega|Ride"] = 27.88, ["Mega|Fly|Ride"] = 62.79}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.94, ["Fly"] = 17.75, ["Ride"] = 18.05, ["Fly|Ride"] = 55.76, ["Neon"] = 14.13, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.09, ["Mega"] = 81.5, ["Mega|Ride"] = 99.83, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.52, ["Fly"] = 24.94, ["Ride"] = 18.41, ["Fly|Ride"] = 58.95, ["Neon"] = 24.78, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 262.22, ["Mega|Ride"] = 191.99, ["Mega|Fly|Ride"] = 222.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 152.25, ["Fly"] = 275.43, ["Ride"] = 246.88, ["Fly|Ride"] = 288.75, ["Neon"] = 592.54, ["Neon|Ride"] = 815.52, ["Neon|Fly|Ride"] = 723.14, ["Mega|Fly|Ride"] = 2752.76}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 17.07, ["Ride"] = 31.8, ["Fly|Ride"] = 206.07, ["Neon"] = 19.69, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 344.8, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.52, ["Fly"] = 15.54, ["Ride"] = 24.04, ["Fly|Ride"] = 45.33, ["Neon"] = 20.35, ["Neon|Ride"] = 25.65, ["Neon|Fly|Ride"] = 105.3, ["Mega"] = 308.44, ["Mega|Ride"] = 220.89, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.94, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 491.12, ["Mega|Fly"] = 825.84, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 1032.17}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.29, ["Ride"] = 28.49, ["Neon"] = 23.61, ["Neon|Ride"] = 273.93, ["Neon|Fly|Ride"] = 619.39, ["Mega"] = 825.84, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 823.67}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.93, ["Fly"] = 35.49, ["Ride"] = 31.16, ["Fly|Ride"] = 52.48, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 161, ["Neon|Fly|Ride"] = 136.27, ["Mega"] = 2064.57, ["Mega|Fly|Ride"] = 1928.08}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.62, ["Fly|Ride"] = 103.24, ["Neon"] = 2.62, ["Neon|Ride"] = 50.04, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 31.5, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 136.26, ["Mega|Fly|Ride"] = 226.7}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.94, ["Fly"] = 28.09, ["Ride"] = 26.75, ["Fly|Ride"] = 61.95, ["Neon"] = 45.55, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.67, ["Mega"] = 232.67, ["Mega|Fly"] = 388.55, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 341.66}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.43, ["Fly|Ride"] = 46.1, ["Neon"] = 23.63, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 164.07, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 34.35, ["Fly|Ride"] = 206.47, ["Neon"] = 3.94, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 35.44, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 194.17}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.74, ["Ride"] = 86.63, ["Fly|Ride"] = 525, ["Neon"] = 275.63, ["Neon|Fly|Ride"] = 621.2, ["Mega"] = 799.99, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.03, ["Ride"] = 32.82, ["Fly|Ride"] = 210, ["Neon"] = 81.94, ["Neon|Ride"] = 93.08, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 465.05}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 41.99, ["Fly"] = 96.97, ["Ride"] = 24.77, ["Fly|Ride"] = 61.52, ["Neon"] = 91.35, ["Neon|Fly"] = 465.32, ["Neon|Ride"] = 68.64, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 343.39, ["Mega|Ride"] = 309.66, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.12, ["Ride"] = 179.5, ["Fly|Ride"] = 262.44, ["Neon"] = 315, ["Neon|Ride"] = 536.81, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1836.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.97, ["Fly"] = 45.93, ["Ride"] = 24.77, ["Fly|Ride"] = 55.76, ["Neon"] = 39.38, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 551.15, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 407.71}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.61, ["Fly"] = 145.69, ["Ride"] = 109.28, ["Fly|Ride"] = 185.83, ["Neon"] = 241.5, ["Neon|Ride"] = 241.5, ["Neon|Fly|Ride"] = 407.77, ["Mega"] = 1071.52, ["Mega|Ride"] = 1101.32, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 29.89, ["Ride"] = 74.82, ["Fly|Ride"] = 173.55, ["Neon"] = 86.52, ["Neon|Ride"] = 132.97, ["Neon|Fly|Ride"] = 283.86, ["Mega"] = 470.96, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.56, ["Ride"] = 27.46, ["Fly|Ride"] = 67.28, ["Neon"] = 52.41, ["Neon|Ride"] = 77.96, ["Neon|Fly|Ride"] = 248.96, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.19, ["Ride"] = 60.93, ["Fly|Ride"] = 161.13, ["Neon"] = 123.88, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.14, ["Mega|Ride"] = 259.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 12.41, ["Ride"] = 31.39, ["Fly|Ride"] = 55.73, ["Neon"] = 42.54, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 155.9, ["Mega"] = 236.25, ["Mega|Ride"] = 262.18, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 57, ["Mega"] = 15.1, ["Mega|Ride"] = 123.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.63, ["Ride"] = 28.25, ["Neon"] = 22.21, ["Neon|Fly"] = 123.88, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.39, ["Mega|Ride"] = 204.38, ["Mega|Fly|Ride"] = 467.38}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 24.86, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.7, ["Ride"] = 32.79, ["Fly|Ride"] = 116.34, ["Neon"] = 18.59, ["Neon|Ride"] = 82.6, ["Mega"] = 123.44, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 348.5}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 541.14, ["Ride"] = 544.88, ["Fly|Ride"] = 678.26, ["Neon"] = 1789.98, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.54, ["Fly"] = 27.87, ["Ride"] = 23.73, ["Fly|Ride"] = 62.84, ["Neon"] = 37.17, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.9, ["Mega|Ride"] = 355.78, ["Mega|Fly|Ride"] = 483.67}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.57, ["Fly"] = 524.69, ["Ride"] = 27.87, ["Fly|Ride"] = 51.35, ["Neon"] = 56.41, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 309.7, ["Mega|Ride"] = 362.76, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.92, ["Fly"] = 91.88, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon"] = 16.53, ["Neon|Ride"] = 196.88, ["Mega"] = 264.08, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 26.75, ["Fly|Ride"] = 90.57, ["Neon"] = 10.5, ["Neon|Ride"] = 37.76, ["Neon|Fly|Ride"] = 105.6, ["Mega"] = 58.86, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 145.09, ["Mega|Fly|Ride"] = 251.86}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 89.14, ["Mega"] = 35.12, ["Mega|Fly"] = 193.06, ["Mega|Ride"] = 151.74, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.13, ["Ride"] = 55.43, ["Fly|Ride"] = 323.64, ["Neon"] = 65.63, ["Neon|Ride"] = 86.63, ["Mega"] = 399.51, ["Mega|Ride"] = 268.37, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 24.05, ["Neon"] = 6.57, ["Neon|Ride"] = 74.34, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 43.46, ["Mega|Ride"] = 154.84, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 27.57, ["Ride"] = 20.65, ["Fly|Ride"] = 99.75, ["Neon"] = 13.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 155.7, ["Mega"] = 183.73, ["Mega|Ride"] = 275.6, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.84, ["Ride"] = 523.69, ["Fly|Ride"] = 557.52, ["Neon|Ride"] = 1902.58, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 8119.95}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.31, ["Fly"] = 196.88, ["Ride"] = 109.36, ["Fly|Ride"] = 412.93, ["Neon"] = 123.88, ["Neon|Ride"] = 73.63, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 482.09, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 80.32, ["Ride"] = 31.43, ["Fly|Ride"] = 163.12, ["Neon"] = 6.57, ["Neon|Ride"] = 27.18, ["Neon|Fly|Ride"] = 99.96, ["Mega"] = 56.43, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 127.21, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 30.09, ["Mega|Ride"] = 130.76, ["Mega|Fly|Ride"] = 233.28}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.43, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 82.55, ["Neon"] = 117.74, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 344.8, ["Mega"] = 494.48, ["Mega|Ride"] = 510.92, ["Mega|Fly|Ride"] = 589.92}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 6.57, ["Ride"] = 27.87, ["Neon"] = 109.36, ["Neon|Ride"] = 123.88, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 423.25, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1651.46}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.17, ["Ride"] = 41.28, ["Fly|Ride"] = 412.93, ["Neon"] = 310.61, ["Neon|Ride"] = 174.7, ["Mega"] = 636.33, ["Mega|Ride"] = 633.75, ["Mega|Fly|Ride"] = 1238.61}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.75, ["Ride"] = 22.67, ["Fly|Ride"] = 262.5, ["Neon"] = 275.63, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 581.19, ["Mega|Ride"] = 647.73, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 328.12, ["Fly"] = 464.94, ["Ride"] = 481.73, ["Fly|Ride"] = 619.39, ["Neon"] = 1032.29, ["Neon|Ride"] = 1086.5, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 4458.91}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.13, ["Fly"] = 69.65, ["Ride"] = 22.71, ["Fly|Ride"] = 236.25, ["Neon"] = 114.95, ["Neon|Fly"] = 185.07, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 185.58, ["Mega|Ride"] = 544.99, ["Mega|Fly|Ride"] = 852.57}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.84, ["Fly|Ride"] = 127.32, ["Neon"] = 36.75, ["Neon|Ride"] = 221.82, ["Mega"] = 218.86, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 19.69, ["Ride"] = 70.88, ["Fly|Ride"] = 257.1, ["Neon"] = 82.69, ["Neon|Ride"] = 130.97, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 272.35, ["Mega|Fly"] = 688.55, ["Mega|Ride"] = 275.61, ["Mega|Fly|Ride"] = 370.47}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 52.5, ["Fly|Ride"] = 138.25, ["Neon"] = 6.56, ["Neon|Ride"] = 43.37, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 44.63, ["Mega|Ride"] = 97.04, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 46.83, ["Ride"] = 69.76, ["Fly|Ride"] = 157.5, ["Neon"] = 275.63, ["Neon|Ride"] = 309.7, ["Mega"] = 1377.08, ["Mega|Ride"] = 1163.26, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 581.17, ["Ride"] = 27.83, ["Fly|Ride"] = 60.36, ["Neon"] = 6.46, ["Neon|Fly"] = 179.64, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 65.63, ["Mega|Ride"] = 103.23, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 36.04, ["Ride"] = 27.57, ["Fly|Ride"] = 151.28, ["Neon"] = 3.94, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 155.9, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.4, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Fly|Ride"] = 123.32, ["Neon"] = 15.75, ["Neon|Ride"] = 55.6, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 109.58, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 49.88, ["Fly"] = 93, ["Ride"] = 55.8, ["Fly|Ride"] = 194.13, ["Neon"] = 291.38, ["Neon|Ride"] = 285.63, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 252, ["Ride"] = 288.75, ["Fly|Ride"] = 418.69, ["Neon"] = 1434.88, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1241.22, ["Mega"] = 6193.69, ["Mega|Fly|Ride"] = 5271.28}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 10.34, ["Ride"] = 36.11, ["Neon"] = 36.15, ["Mega"] = 103.83, ["Mega|Fly"] = 228.16, ["Mega|Ride"] = 165.16, ["Mega|Fly|Ride"] = 688.47}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 69.13, ["Ride"] = 28.46, ["Neon"] = 10.5, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 179.64, ["Mega"] = 76.13, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 344.75}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.24, ["Fly"] = 30.23, ["Ride"] = 27.56, ["Fly|Ride"] = 175.51, ["Neon"] = 32.81, ["Neon|Ride"] = 69.18, ["Mega"] = 373.42, ["Mega|Ride"] = 344.74, ["Mega|Fly|Ride"] = 578.02}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.35, ["Fly"] = 64.55, ["Ride"] = 63.97, ["Neon"] = 9.09, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 138.15, ["Mega"] = 91.88, ["Mega|Fly"] = 146.6, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 259.09}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.24, ["Ride"] = 68.1, ["Neon"] = 8.93, ["Mega"] = 34.13, ["Mega|Ride"] = 206.45, ["Mega|Fly|Ride"] = 272.51}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 6.2, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 38.07, ["Mega|Ride"] = 100.36, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.61, ["Ride"] = 15.75, ["Fly|Ride"] = 58.57, ["Neon"] = 16.11, ["Neon|Fly"] = 63.67, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 102.21, ["Mega|Ride"] = 233.28, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.88, ["Ride"] = 52.62, ["Fly|Ride"] = 77.15, ["Neon"] = 131.25, ["Mega"] = 577.06, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63.96, ["Fly"] = 110.39, ["Ride"] = 103.17, ["Fly|Ride"] = 115.13, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 455.25, ["Neon|Fly|Ride"] = 447.51, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 49.26, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.73, ["Fly|Ride"] = 36.66, ["Neon"] = 5.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 61.15, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.61, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.57, ["Fly"] = 35.09, ["Ride"] = 73.48, ["Neon"] = 35.44, ["Neon|Ride"] = 69.82, ["Neon|Fly|Ride"] = 274.61, ["Mega"] = 527.63, ["Mega|Ride"] = 542.95, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 388.63, ["Fly"] = 518.44, ["Ride"] = 578.39, ["Fly|Ride"] = 492.19, ["Neon"] = 4129.13, ["Neon|Ride"] = 1928.32, ["Mega|Fly|Ride"] = 7225.08}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 32.11, ["Fly"] = 96.97, ["Ride"] = 58.82, ["Fly|Ride"] = 91.88, ["Neon"] = 170.63, ["Neon|Ride"] = 164.14, ["Neon|Fly|Ride"] = 291.38, ["Mega|Ride"] = 1238.61, ["Mega|Fly|Ride"] = 988.22}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 281.29, ["Neon"] = 7.88, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 85.22, ["Mega|Ride"] = 167.43, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.52, ["Fly"] = 206.32, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 16.96, ["Neon|Ride"] = 69.18}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.17, ["Fly"] = 76.35, ["Ride"] = 43.31, ["Fly|Ride"] = 82.69, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2477.49, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1306.72}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 55.13, ["Fly"] = 117.6, ["Ride"] = 99.75, ["Fly|Ride"] = 179.64, ["Neon"] = 434.44, ["Neon|Ride"] = 468.67, ["Neon|Fly|Ride"] = 465.32, ["Mega"] = 8258.24, ["Mega|Fly|Ride"] = 2058.12}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 223.12, ["Ride"] = 279.68, ["Fly|Ride"] = 824.8, ["Neon"] = 711.93, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.44, ["Fly"] = 51.19, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 77.43, ["Neon|Ride"] = 109.1, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 402.73, ["Mega|Ride"] = 383.09, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.2, ["Ride"] = 17.36, ["Fly|Ride"] = 41.9, ["Neon"] = 9.49, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 91.11, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.17, ["Fly"] = 15.75, ["Ride"] = 40.24, ["Fly|Ride"] = 41.41, ["Neon"] = 40.53, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 93, ["Mega"] = 344.8, ["Mega|Ride"] = 328.25, ["Mega|Fly|Ride"] = 358.18}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.68, ["Fly"] = 481.73, ["Ride"] = 412.62, ["Fly|Ride"] = 611.13, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4832.26}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 59.84, ["Neon"] = 10.5, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 62.84, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 7.87, ["Fly"] = 41.28, ["Ride"] = 15.49, ["Fly|Ride"] = 40.1, ["Neon"] = 49.88, ["Neon|Ride"] = 31.54, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 192.02, ["Mega|Fly"] = 205.44, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 16.89, ["Ride"] = 117.6, ["Neon"] = 116.27, ["Neon|Fly"] = 412.93, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 435.07, ["Mega"] = 522.41, ["Mega|Ride"] = 613.12, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 116.24, ["Fly"] = 157.5, ["Ride"] = 97.12, ["Fly|Ride"] = 155.89, ["Neon"] = 638.99, ["Neon|Ride"] = 697.97, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 20.65, ["Fly"] = 35.09, ["Ride"] = 27.57, ["Fly|Ride"] = 39.38, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 109.28, ["Mega"] = 633.84, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 688.55, ["Mega"] = 21.67, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 72.19, ["Neon"] = 2.61, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 24.94, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 46.1, ["Mega|Fly|Ride"] = 97.04}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Fly"] = 412.62, ["Ride"] = 82.63, ["Fly|Ride"] = 98.09, ["Neon"] = 34.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 165.18, ["Mega"] = 153.2, ["Mega|Ride"] = 212.22, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1389.7, ["Fly"] = 1534.28, ["Ride"] = 1271.82, ["Fly|Ride"] = 1336, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11529.74}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 495.05, ["Ride"] = 522.96, ["Fly|Ride"] = 590.63, ["Neon"] = 2423.08, ["Neon|Ride"] = 1993.59, ["Neon|Fly|Ride"] = 2061.32, ["Mega"] = 16516.48, ["Mega|Fly|Ride"] = 9358.53}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 353.07, ["Ride"] = 372.92, ["Fly|Ride"] = 439.69, ["Neon"] = 738.67, ["Neon|Fly"] = 1241.22, ["Neon|Ride"] = 761.04, ["Neon|Fly|Ride"] = 784.88, ["Mega|Fly|Ride"] = 2915.75}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 304.13, ["Fly"] = 412.62, ["Ride"] = 337.84, ["Fly|Ride"] = 452.4, ["Neon"] = 925.32, ["Neon|Fly"] = 1377.08, ["Neon|Ride"] = 1046.74, ["Neon|Fly|Ride"] = 1101.45, ["Mega|Fly|Ride"] = 4640.56}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 15.93, ["Fly|Ride"] = 32.32, ["Neon"] = 5.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 77.96, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 318.77, ["Fly"] = 1376.05, ["Ride"] = 439.37, ["Fly|Ride"] = 592.54, ["Neon"] = 1680, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1383.76, ["Mega|Ride"] = 6605.79, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.92, ["Fly"] = 157.5, ["Ride"] = 27.57, ["Fly|Ride"] = 62.68, ["Neon"] = 13.12, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 81.29, ["Mega|Ride"] = 183.35, ["Mega|Fly|Ride"] = 366.42}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.46, ["Ride"] = 15.49, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 110.42, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 155.9, ["Mega"] = 24.94, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.22, ["Ride"] = 109.36, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 930.09, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7749.15, ["Ride"] = 25.2, ["Fly|Ride"] = 65.55, ["Neon"] = 31.5, ["Neon|Ride"] = 77.96, ["Mega|Ride"] = 309.66, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.94, ["Neon|Fly"] = 118.73, ["Neon|Ride"] = 38.31, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 19.59, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 36.01, ["Ride"] = 17.07, ["Fly|Ride"] = 66.78, ["Neon"] = 13.12, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 97.05, ["Mega|Fly"] = 172.4, ["Mega|Ride"] = 118.96, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.71, ["Fly"] = 91.77, ["Ride"] = 27.91, ["Fly|Ride"] = 51.97, ["Neon"] = 27.57, ["Neon|Fly"] = 110.48, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 246.72, ["Mega"] = 237.57, ["Mega|Ride"] = 1470, ["Mega|Fly|Ride"] = 310.44}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.87, ["Ride"] = 46.51, ["Neon"] = 62.75, ["Neon|Fly|Ride"] = 264.08, ["Mega"] = 412.93, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6199.79, ["Ride"] = 27.55, ["Neon"] = 37.79, ["Neon|Ride"] = 138.15, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 98.24, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.84, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 59.07, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 152.23, ["Ride"] = 178.5, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 961.07, ["Neon|Fly|Ride"] = 1086.5, ["Mega"] = 8258.24, ["Mega|Ride"] = 4128.63, ["Mega|Fly|Ride"] = 4115.21}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 14.94, ["Fly|Ride"] = 34.96, ["Neon"] = 2.63, ["Neon|Fly"] = 42.37, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 52.91, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 161.03}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.46, ["Fly"] = 138.25, ["Ride"] = 69.46, ["Fly|Ride"] = 160.12, ["Neon"] = 103.24, ["Neon|Ride"] = 110.48, ["Mega"] = 399.51, ["Mega|Fly|Ride"] = 516.09}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 25.99, ["Ride"] = 93.19, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 275.63, ["Mega"] = 786.19, ["Mega|Ride"] = 813.84, ["Mega|Fly|Ride"] = 1030.11}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 198.24, ["Ride"] = 250.69, ["Fly|Ride"] = 317.55, ["Neon"] = 708.74, ["Neon|Fly"] = 1163.28, ["Neon|Ride"] = 825.84, ["Neon|Fly|Ride"] = 872.82, ["Mega|Fly|Ride"] = 3357.61}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.07, ["Fly"] = 168.88, ["Fly|Ride"] = 139.49, ["Neon"] = 155.89, ["Neon|Ride"] = 145.34, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1238.61}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 9.93, ["Ride"] = 138.25, ["Fly|Ride"] = 619.39, ["Neon"] = 96.87, ["Neon|Fly"] = 155.9, ["Neon|Ride"] = 199.49, ["Mega"] = 1651.67, ["Mega|Ride"] = 619.32, ["Mega|Fly|Ride"] = 961.97}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1115.63, ["Fly"] = 1447.22, ["Ride"] = 1112.36, ["Fly|Ride"] = 1149.75, ["Neon"] = 4680.38, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 17876.87}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 11.18, ["Fly"] = 30.23, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 23.28, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 81.57, ["Neon|Fly|Ride"] = 185.83, ["Mega"] = 232.67, ["Mega|Ride"] = 234.31, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.7, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 110.48, ["Mega"] = 248.96, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.85, ["Mega|Fly|Ride"] = 578.02}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.51, ["Ride"] = 26.84, ["Fly|Ride"] = 69.57, ["Neon"] = 15.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 37.24, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 93.79, ["Mega|Ride"] = 182.09, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.44, ["Ride"] = 32.82, ["Fly|Ride"] = 114.6, ["Neon"] = 64.95, ["Neon|Ride"] = 75.49, ["Neon|Fly|Ride"] = 179.45, ["Mega"] = 342.51, ["Mega|Ride"] = 353.43, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 5.24, ["Fly"] = 20.65, ["Ride"] = 16.53, ["Fly|Ride"] = 39.19, ["Neon"] = 19.63, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 40.28, ["Neon|Fly|Ride"] = 93.17, ["Mega|Ride"] = 158.96, ["Mega|Fly|Ride"] = 411.84}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 26.25, ["Ride"] = 21.97, ["Neon"] = 189.52, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 54.32, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 123.88, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.25}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 229.69, ["Fly"] = 262.02, ["Ride"] = 229.69, ["Fly|Ride"] = 367.6, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.69, ["Ride"] = 22.68, ["Fly|Ride"] = 72.19, ["Neon"] = 9.32, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 77.96, ["Mega|Fly"] = 412.93, ["Mega|Ride"] = 112.8, ["Mega|Fly|Ride"] = 232.54}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.66, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.19, ["Fly"] = 95.01, ["Ride"] = 26.23, ["Fly|Ride"] = 105, ["Neon"] = 11.46, ["Neon|Ride"] = 1377.08, ["Mega"] = 84, ["Mega|Fly"] = 138.34, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 371.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 207.27, ["Ride"] = 408.99, ["Fly|Ride"] = 688.55, ["Neon"] = 918.75, ["Neon|Fly"] = 1032.29, ["Neon|Ride"] = 1032.29, ["Mega"] = 3096.85, ["Mega|Ride"] = 4954.35, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.82, ["Fly"] = 60.88, ["Ride"] = 45.4, ["Fly|Ride"] = 164.14, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 771.14, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.38, ["Ride"] = 41.6, ["Fly|Ride"] = 89.25, ["Neon"] = 95.82, ["Neon|Ride"] = 138.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 511.24, ["Mega|Ride"] = 581.33, ["Mega|Fly|Ride"] = 652.34}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.55, ["Neon"] = 3.14, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 127.34, ["Mega"] = 37.1, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 237.42}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 57.56, ["Fly"] = 138.25, ["Ride"] = 111.57, ["Fly|Ride"] = 158.52, ["Neon"] = 262.48, ["Neon|Fly"] = 344.8, ["Neon|Ride"] = 294.16, ["Neon|Fly|Ride"] = 384.02, ["Mega|Ride"] = 825.74, ["Mega|Fly|Ride"] = 1174.06}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 122.87, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.75, ["Fly"] = 97.64, ["Ride"] = 27.91, ["Fly|Ride"] = 79.78, ["Neon"] = 97.05, ["Neon|Ride"] = 123.32, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 385.91, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 53.72, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 153.49, ["Neon"] = 251.69, ["Neon|Ride"] = 310.61, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1238.75, ["Mega|Ride"] = 3442.24, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.84, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 14.3, ["Neon|Fly|Ride"] = 33.3, ["Mega"] = 17.07, ["Mega|Fly"] = 116.34, ["Mega|Ride"] = 32.25, ["Mega|Fly|Ride"] = 86.5}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.74, ["Fly"] = 32.82, ["Ride"] = 39.29, ["Fly|Ride"] = 130.08, ["Neon"] = 15.65, ["Neon|Ride"] = 59.89, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 129.94, ["Mega|Ride"] = 272.08, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.69, ["Ride"] = 52.43, ["Fly|Ride"] = 202.34, ["Neon"] = 133.47, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 543.26, ["Mega|Ride"] = 546.96, ["Mega|Fly|Ride"] = 775.48}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.84, ["Neon"] = 2.1, ["Neon|Ride"] = 27.89, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 19.69, ["Mega|Ride"] = 81.4, ["Mega|Fly|Ride"] = 210.57}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.43, ["Fly"] = 178.38, ["Ride"] = 58.49, ["Fly|Ride"] = 86.73, ["Neon"] = 65.63, ["Neon|Ride"] = 87.47, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 474.36, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 8.54, ["Fly"] = 15.75, ["Ride"] = 26.17, ["Fly|Ride"] = 46.49, ["Neon"] = 408.98, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 179.43, ["Mega|Fly|Ride"] = 434.83}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 25.75, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Mega"] = 228.38, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 434.83}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.95, ["Fly"] = 2063.03, ["Ride"] = 85.12, ["Fly|Ride"] = 196.85, ["Neon"] = 39.38, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6203.71, ["Mega"] = 325.74, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 930.09}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 18.62, ["Fly|Ride"] = 196.88, ["Neon"] = 11.82, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 103.24, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 152.77}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.74, ["Neon"] = 3.94, ["Neon|Ride"] = 98.09, ["Mega"] = 30.65, ["Mega|Ride"] = 123.87, ["Mega|Fly|Ride"] = 268.37}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.6}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.91, ["Fly"] = 78.75, ["Ride"] = 53.48, ["Fly|Ride"] = 138.34, ["Neon"] = 235.37, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1230.49, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 30.18, ["Mega|Ride"] = 275.6, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 418.69, ["Fly"] = 563.22, ["Ride"] = 550.85, ["Fly|Ride"] = 641.82, ["Neon"] = 4129.13, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16516.48, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.6, ["Fly"] = 26.17, ["Ride"] = 22.97, ["Fly|Ride"] = 66.26, ["Neon"] = 26.25, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 85.1, ["Mega|Fly"] = 154.86, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 95.55, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 18.4, ["Neon|Ride"] = 34.48, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 164.07, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 231.13}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.82, ["Fly"] = 77.38, ["Ride"] = 65, ["Fly|Ride"] = 67.49, ["Neon"] = 98.44, ["Neon|Ride"] = 172.4, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 796.93, ["Mega|Ride"] = 654.41, ["Mega|Fly|Ride"] = 685.36}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.07, ["Fly"] = 316.68, ["Ride"] = 38.07, ["Fly|Ride"] = 688.55, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.13, ["Fly"] = 139.53, ["Ride"] = 138.25, ["Fly|Ride"] = 157.5, ["Neon"] = 110.52, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 359, ["Mega"] = 378.35, ["Mega|Ride"] = 403.44, ["Mega|Fly|Ride"] = 687.43}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 15.19, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 26.85, ["Neon|Ride"] = 155.9, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 217.88, ["Mega|Fly"] = 551.25, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 403.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.13, ["Fly|Ride"] = 68.16, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 134.3, ["Mega"] = 14.58, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 110.15}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.25, ["Fly"] = 275.84, ["Ride"] = 27.87, ["Fly|Ride"] = 103.24, ["Neon"] = 40.32, ["Neon|Fly"] = 116.34, ["Neon|Ride"] = 93.95, ["Neon|Fly|Ride"] = 82.6, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 316.68, ["Fly"] = 406.83, ["Ride"] = 336, ["Fly|Ride"] = 421.32, ["Neon"] = 1457.59, ["Neon|Ride"] = 1377.08, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 4335.06, ["Mega|Fly|Ride"] = 4401.1}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 94.84, ["Ride"] = 137.17, ["Fly|Ride"] = 295.49, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 543.55, ["Mega"] = 4129.13, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1651.46}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 14.34, ["Fly|Ride"] = 29.59, ["Neon"] = 8.87, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 33.05, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 152.79, ["Mega|Fly"] = 205.44, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 207.9}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.04, ["Ride"] = 14.44, ["Fly|Ride"] = 32.8, ["Neon"] = 9.1, ["Neon|Fly"] = 51.34, ["Neon|Ride"] = 25.52, ["Neon|Fly|Ride"] = 59.12, ["Mega"] = 70.77, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 110.46, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.61, ["Fly"] = 96.97, ["Ride"] = 20.99, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 138.34, ["Mega|Ride"] = 411.84, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 306.78, ["Fly"] = 420, ["Ride"] = 275.43, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 964.17, ["Neon|Fly|Ride"] = 1445.2, ["Mega|Ride"] = 8257.24, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.77, ["Fly"] = 48.49, ["Ride"] = 15.74, ["Fly|Ride"] = 32.68, ["Neon"] = 18.38, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 109.36, ["Mega"] = 196.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 490.29}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.98, ["Fly"] = 310.35, ["Ride"] = 82.46, ["Fly|Ride"] = 206.32, ["Neon"] = 48.2, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 253.32, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.94, ["Neon|Ride"] = 155.71, ["Mega"] = 62.79, ["Mega|Ride"] = 202.32}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.34, ["Fly"] = 59.07, ["Ride"] = 26.75, ["Fly|Ride"] = 74.79, ["Neon"] = 79.49, ["Neon|Ride"] = 109.36, ["Neon|Fly|Ride"] = 247.76, ["Mega"] = 728.44, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 618.28}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 53.82, ["Fly"] = 155.76, ["Ride"] = 107.63, ["Fly|Ride"] = 209.9, ["Neon"] = 131.15, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 206.47, ["Neon|Fly|Ride"] = 424.1, ["Mega"] = 533.97, ["Mega|Fly"] = 2167.8, ["Mega|Ride"] = 556.24, ["Mega|Fly|Ride"] = 753.48}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 25.87, ["Ride"] = 55.71, ["Fly|Ride"] = 85.32, ["Neon"] = 262.5, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 205.44, ["Neon|Fly|Ride"] = 203.43, ["Mega|Ride"] = 930.09, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.6, ["Fly|Ride"] = 35.12, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 21.45, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 262.49, ["Ride"] = 295.24, ["Fly|Ride"] = 318.94, ["Neon"] = 3257.1, ["Neon|Fly|Ride"] = 1060.17}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.32, ["Fly"] = 101.18, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 185.83, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 515.12, ["Mega|Fly|Ride"] = 760.36}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.61, ["Fly|Ride"] = 44.22, ["Neon"] = 5.91, ["Neon|Fly"] = 33.92, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 59.35, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 72.98, ["Mega|Fly|Ride"] = 139.53}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.96, ["Ride"] = 19.62, ["Fly|Ride"] = 37.92, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 124.3, ["Mega"] = 27.89, ["Mega|Fly"] = 138.34, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 154.84}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 12.2, ["Neon|Fly"] = 697.97, ["Neon|Ride"] = 34.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 127.98, ["Mega|Ride"] = 128.84, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.88, ["Fly"] = 27.57, ["Ride"] = 24.94, ["Fly|Ride"] = 66.59, ["Neon"] = 53.72, ["Neon|Fly"] = 262.22, ["Neon|Ride"] = 56.46, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 347.94, ["Mega|Ride"] = 318.34, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.46, ["Ride"] = 55.09, ["Neon"] = 59.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 324.38}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 275.63, ["Neon"] = 3.94, ["Neon|Ride"] = 30.43, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 22.58, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.77, ["Fly"] = 96.97, ["Ride"] = 31.5, ["Fly|Ride"] = 131.25, ["Neon"] = 31.48, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 69.74, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 191.29, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 290.67}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 121.41, ["Neon"] = 3.82, ["Neon|Fly"] = 110.48, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.29, ["Mega"] = 23.69, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 123.87}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.45, ["Ride"] = 16.69, ["Fly|Ride"] = 66.87, ["Neon"] = 3.94, ["Neon|Ride"] = 22.2, ["Neon|Fly|Ride"] = 94.69, ["Mega"] = 49.69, ["Mega|Ride"] = 82.46, ["Mega|Fly|Ride"] = 228.5}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 714.62, ["Ride"] = 689.07, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.38, ["Mega|Fly|Ride"] = 17615.74}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.49, ["Fly|Ride"] = 27.77, ["Neon"] = 10.5, ["Neon|Fly"] = 123.05, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 43.64, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 5.98, ["Ride"] = 70.45, ["Fly|Ride"] = 81.57, ["Neon"] = 16.42, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 65.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 89.65, ["Mega|Fly|Ride"] = 313.92}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 15.49, ["Fly"] = 47.46, ["Ride"] = 27.87, ["Fly|Ride"] = 46.55, ["Neon"] = 53.82, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 54.69, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 482.09, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 372.57}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 14.8, ["Fly|Ride"] = 33.63, ["Neon"] = 6.3, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 61.63, ["Mega"] = 65.62, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 167.44}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 34, ["Ride"] = 47.16, ["Fly|Ride"] = 274.4, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 909.57}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 138.25, ["Ride"] = 18.38, ["Fly|Ride"] = 63.74, ["Neon"] = 5.25, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 69.18, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 271.47}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.4, ["Fly"] = 69.13, ["Ride"] = 22.97, ["Fly|Ride"] = 60.92, ["Neon"] = 23.77, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 15.16, ["Mega"] = 93.5, ["Mega|Ride"] = 172.08, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 14.76, ["Fly|Ride"] = 98.09, ["Neon"] = 5.24, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 35.12, ["Mega|Fly"] = 285.87, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 138.33}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 20.9, ["Fly"] = 17.75, ["Ride"] = 20.77, ["Fly|Ride"] = 41.99, ["Neon"] = 309.74, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 825.84, ["Mega|Fly|Ride"] = 534.66}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 813.75, ["Ride"] = 905.63, ["Fly|Ride"] = 1032.29, ["Neon"] = 2017.09, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 8258.24, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7596.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 14.43, ["Fly|Ride"] = 32.33, ["Neon"] = 4.73, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 60.74, ["Mega"] = 57.75, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 18.38, ["Ride"] = 36.91, ["Fly|Ride"] = 116.34, ["Neon"] = 59.89, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 274.61, ["Mega"] = 321.59, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 482.03}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 44.62, ["Ride"] = 76.35, ["Fly|Ride"] = 112.88, ["Neon|Ride"] = 389.81, ["Neon|Fly|Ride"] = 532.67, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1294.33}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 22.31, ["Ride"] = 45.4, ["Fly|Ride"] = 138.34, ["Neon"] = 105, ["Neon|Ride"] = 179.64, ["Mega"] = 933.2, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.39, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 56.44, ["Neon|Ride"] = 113.45, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 412.93, ["Mega|Ride"] = 465.05, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.62, ["Ride"] = 63.51, ["Neon"] = 107.63, ["Neon|Ride"] = 136.27, ["Mega"] = 258.26, ["Mega|Fly"] = 504.88, ["Mega|Ride"] = 344.75, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.38, ["Fly"] = 126.89, ["Ride"] = 28.61, ["Neon"] = 225.05, ["Neon|Ride"] = 307, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 697.58, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.6}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.57, ["Fly"] = 131248.69, ["Ride"] = 26.84, ["Fly|Ride"] = 78.75, ["Neon"] = 38.07, ["Neon|Ride"] = 72.93, ["Neon|Fly|Ride"] = 229.18, ["Mega"] = 206.47, ["Mega|Fly"] = 459.23, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.82, ["Ride"] = 131.25, ["Neon"] = 19.63, ["Mega"] = 868.97}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 99.71, ["Fly"] = 412.55, ["Ride"] = 73.25, ["Fly|Ride"] = 111.6, ["Neon"] = 367.5, ["Neon|Ride"] = 241.57, ["Neon|Fly|Ride"] = 282.19, ["Mega|Ride"] = 899.88, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.25, ["Fly"] = 19.69, ["Ride"] = 16.52, ["Fly|Ride"] = 36.11, ["Neon"] = 22.32, ["Neon|Fly"] = 93.95, ["Neon|Ride"] = 35.49, ["Neon|Fly|Ride"] = 69.18, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.19, ["Fly"] = 82.55, ["Ride"] = 31.39, ["Fly|Ride"] = 105, ["Neon"] = 27.89, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 125.44, ["Mega"] = 126.06, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.77, ["Mega"] = 42, ["Mega|Ride"] = 97.04, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.82, ["Fly"] = 63.67, ["Ride"] = 61.8, ["Fly|Ride"] = 94.46, ["Neon"] = 196.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 388.55, ["Mega"] = 1101.45, ["Mega|Ride"] = 865.99, ["Mega|Fly|Ride"] = 816.66}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.65, ["Fly|Ride"] = 65.54, ["Neon"] = 5.92, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.26, ["Mega"] = 74.82, ["Mega|Fly|Ride"] = 310.44}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.7, ["Ride"] = 61.07, ["Fly|Ride"] = 274.4, ["Neon"] = 82.6, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 412.93, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 659.56}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 14.49, ["Fly|Ride"] = 38.7, ["Neon"] = 18.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 63.65, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.2, ["Fly"] = 52.49, ["Ride"] = 17.75, ["Fly|Ride"] = 73.21, ["Neon"] = 26.25, ["Neon|Ride"] = 410.93, ["Mega"] = 378.87, ["Mega|Ride"] = 390.16, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.37, ["Ride"] = 61.76, ["Fly|Ride"] = 131.25, ["Neon"] = 53.52, ["Neon|Ride"] = 155.9, ["Mega"] = 379.65, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.56, ["Ride"] = 126.77, ["Neon"] = 257.1, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1238.75, ["Mega|Ride"] = 1638.05, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.74, ["Ride"] = 90.79, ["Neon"] = 107.63, ["Neon|Ride"] = 412.93, ["Mega"] = 412.93, ["Mega|Ride"] = 428.36, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.01, ["Ride"] = 105, ["Neon"] = 142.48, ["Neon|Ride"] = 105, ["Mega"] = 391.26, ["Mega|Ride"] = 1552.09, ["Mega|Fly|Ride"] = 1651.46}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 28.87, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 291.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 825.84, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1445.03}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.76, ["Neon"] = 105, ["Neon|Ride"] = 275.63, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 310.44}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 17.8, ["Fly|Ride"] = 59.89, ["Neon"] = 5.2, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 93.08, ["Mega|Ride"] = 93.02, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.07, ["Fly"] = 50.18, ["Ride"] = 288.64, ["Fly|Ride"] = 77.89, ["Neon"] = 39.38, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 116.34, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.69, ["Fly|Ride"] = 55.95, ["Neon"] = 5.25, ["Neon|Fly"] = 31.43, ["Neon|Ride"] = 27.89, ["Neon|Fly|Ride"] = 65.65, ["Mega"] = 47.25, ["Mega|Ride"] = 73.37, ["Mega|Fly|Ride"] = 202.51}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Fly|Ride"] = 118.13, ["Neon"] = 47.5, ["Neon|Ride"] = 98.09, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 247.48, ["Mega|Ride"] = 189.53, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.68, ["Fly"] = 65.63, ["Ride"] = 22.23, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 465.32, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1211.76}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 7.77, ["Fly"] = 26.18, ["Ride"] = 23.63, ["Fly|Ride"] = 55.85, ["Neon"] = 20.31, ["Neon|Fly"] = 54.69, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 163.7, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 310.27}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 35.49, ["Ride"] = 18.58, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 54.68, ["Neon|Fly|Ride"] = 184.79, ["Mega"] = 170.62, ["Mega|Ride"] = 228.12, ["Mega|Fly|Ride"] = 247.73}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 13.13, ["Fly"] = 63, ["Ride"] = 31.49, ["Neon"] = 14.37, ["Neon|Fly"] = 123.69, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 138.41, ["Mega|Ride"] = 147.89, ["Mega|Fly|Ride"] = 280.37}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 22.1, ["Fly"] = 206.32, ["Ride"] = 110.66, ["Fly|Ride"] = 301.63, ["Neon"] = 118.13, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 498.75, ["Mega|Fly"] = 688.55, ["Mega|Ride"] = 603.49, ["Mega|Fly|Ride"] = 721.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 58.47, ["Ride"] = 103.17, ["Fly|Ride"] = 229.69, ["Neon"] = 294.68, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 329.44, ["Mega"] = 1241.22, ["Mega|Ride"] = 1101.32, ["Mega|Fly|Ride"] = 1177}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.5, ["Fly|Ride"] = 57.83, ["Neon"] = 3.69, ["Neon|Ride"] = 38.83, ["Mega"] = 26.25, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 11.46, ["Neon"] = 155.89, ["Mega|Fly|Ride"] = 1238.61}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 59.76, ["Ride"] = 94.5, ["Neon"] = 247.76, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 412.93, ["Mega|Ride"] = 1101.32, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.72, ["Fly"] = 190.32, ["Ride"] = 32.1, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 155.9, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.94, ["Ride"] = 110.39, ["Fly|Ride"] = 97.79, ["Neon"] = 5.25, ["Neon|Ride"] = 63.21, ["Neon|Fly|Ride"] = 89.82, ["Mega"] = 62.37, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 300.44}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 688.03, ["Ride"] = 18.38, ["Fly|Ride"] = 60.92, ["Neon"] = 10.5, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 164.07, ["Mega|Fly"] = 344.8, ["Mega|Ride"] = 179.62, ["Mega|Fly|Ride"] = 221.24}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 15.49, ["Fly|Ride"] = 38.66, ["Neon"] = 2.63, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 31.43, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 80.54, ["Neon"] = 4.14, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 47.5, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.6, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.47, ["Neon"] = 2.44, ["Neon|Ride"] = 145.08, ["Mega"] = 24.62, ["Mega|Ride"] = 551.18, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.14, ["Ride"] = 44.38, ["Neon"] = 30.09, ["Neon|Ride"] = 155.9, ["Neon|Fly|Ride"] = 619.39, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 187.21}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.65, ["Ride"] = 30.18, ["Fly|Ride"] = 202.98, ["Neon"] = 31.4, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 181.71, ["Mega|Ride"] = 551.18, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.19, ["Fly"] = 22.37, ["Ride"] = 23.73, ["Fly|Ride"] = 45.85, ["Neon"] = 36.66, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 46.12, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 465.32, ["Mega|Ride"] = 346.34, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 58.97, ["Ride"] = 263.05, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1783.45}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.43, ["Fly"] = 82.66, ["Ride"] = 65.63, ["Fly|Ride"] = 150.73, ["Neon"] = 262.22, ["Neon|Fly|Ride"] = 630, ["Mega"] = 881.77, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 825.74}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 14.74, ["Fly|Ride"] = 38, ["Neon"] = 4.14, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 53.69, ["Mega"] = 48.53, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 15.74, ["Fly|Ride"] = 35.12, ["Neon"] = 4.94, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 17.76, ["Neon|Fly|Ride"] = 36.15, ["Mega"] = 44.4, ["Mega|Fly"] = 82.6, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 101.35}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 618.37, ["Ride"] = 534.18, ["Fly|Ride"] = 549.93, ["Neon|Fly|Ride"] = 1858.13}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.72, ["Ride"] = 90.6, ["Neon"] = 49.56, ["Neon|Ride"] = 117.69, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Ride"] = 15.27, ["Fly|Ride"] = 34.13, ["Neon"] = 3.15, ["Neon|Fly"] = 26.77, ["Neon|Ride"] = 15.5, ["Neon|Fly|Ride"] = 55.55, ["Mega"] = 140.76, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 61.07, ["Ride"] = 164.07, ["Fly|Ride"] = 328.13, ["Neon"] = 260.69, ["Neon|Ride"] = 304.54, ["Neon|Fly|Ride"] = 452.16, ["Mega"] = 737.62, ["Mega|Ride"] = 917.44}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 18.38, ["Fly|Ride"] = 45.93, ["Neon"] = 16.53, ["Neon|Fly"] = 45.63, ["Neon|Ride"] = 30.98, ["Neon|Fly|Ride"] = 62.37, ["Mega"] = 85.32, ["Mega|Fly"] = 243.64, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.13, ["Ride"] = 42.94, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.94, ["Neon|Ride"] = 32.02, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 18.38, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 190.76}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.38, ["Fly"] = 126.14, ["Ride"] = 105.24, ["Fly|Ride"] = 111.57, ["Neon"] = 169.31, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 787.5, ["Mega|Ride"] = 623.7, ["Mega|Fly|Ride"] = 784.45}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Neon"] = 6.79, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 40.85, ["Mega|Ride"] = 176.22, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 22.22, ["Ride"] = 96.97, ["Fly|Ride"] = 138.34, ["Neon"] = 325.19, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1631.01, ["Mega|Ride"] = 1651.46, ["Mega|Fly|Ride"] = 1228.49}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3, ["Ride"] = 55.71, ["Fly|Ride"] = 156.93, ["Neon"] = 18.8, ["Neon|Ride"] = 275.29, ["Neon|Fly|Ride"] = 482.09, ["Mega"] = 104.99, ["Mega|Ride"] = 465.05, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.84, ["Fly"] = 69.13, ["Ride"] = 26.25, ["Fly|Ride"] = 66.08, ["Neon"] = 7.88, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.83, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 38.4, ["Ride"] = 98.95, ["Fly|Ride"] = 516.15, ["Neon"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2062.52, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1362.45}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.24, ["Ride"] = 30.23, ["Fly|Ride"] = 908.98, ["Neon"] = 5.19, ["Neon|Ride"] = 37.17, ["Neon|Fly|Ride"] = 152.41, ["Mega"] = 49.87, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 218.84}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 13.49, ["Ride"] = 17.45, ["Fly|Ride"] = 102.88, ["Neon"] = 10.49, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.53, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.7, ["Fly"] = 48.49, ["Ride"] = 28.77, ["Fly|Ride"] = 102.21, ["Neon"] = 77.9, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 136.27, ["Mega"] = 393.75, ["Mega|Ride"] = 484.65, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 39.22, ["Ride"] = 34.85, ["Fly|Ride"] = 85.07, ["Neon"] = 91.76, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 234.35, ["Mega"] = 540.93, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 619.32}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.65, ["Fly"] = 51.18, ["Ride"] = 22.32, ["Fly|Ride"] = 74.28, ["Neon"] = 81.38, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 542.55, ["Mega|Ride"] = 311.07, ["Mega|Fly|Ride"] = 428.36}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 46.51, ["Ride"] = 96.97, ["Fly|Ride"] = 206.47, ["Neon"] = 299.25, ["Neon|Ride"] = 482.09, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 1651.67, ["Mega|Ride"] = 1493.55, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.19, ["Ride"] = 47.88, ["Fly|Ride"] = 309.7, ["Neon"] = 26.25, ["Neon|Ride"] = 109.36, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 216.57, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 344.75}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.24, ["Ride"] = 26.57, ["Fly|Ride"] = 78.74, ["Neon"] = 22.12, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 138.15, ["Mega"] = 185.07, ["Mega|Ride"] = 192.3, ["Mega|Fly|Ride"] = 310.44}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.71, ["Ride"] = 37.15, ["Fly|Ride"] = 160.13, ["Neon"] = 52.65, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 232.67, ["Mega"] = 379.32, ["Mega|Ride"] = 454.16, ["Mega|Fly|Ride"] = 510.57}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.16, ["Fly|Ride"] = 22.74, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 12.71, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 14.44, ["Mega|Ride"] = 25.2, ["Mega|Fly|Ride"] = 89.2}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 61.9, ["Fly"] = 218.7, ["Ride"] = 110.25, ["Fly|Ride"] = 275.63, ["Neon"] = 205.44, ["Neon|Fly"] = 2340.19, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1086.5, ["Mega|Ride"] = 1500.76, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.6, ["Fly|Ride"] = 112.22, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.55, ["Mega|Ride"] = 51.79, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 14.44, ["Fly|Ride"] = 45.93, ["Neon"] = 11.61, ["Neon|Fly"] = 138.34, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 97.05, ["Mega"] = 110.48, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 86.18, ["Ride"] = 170.63, ["Fly|Ride"] = 249.38, ["Neon"] = 334.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 515.34, ["Mega"] = 1260.39, ["Mega|Ride"] = 1101.32, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 21.98, ["Neon"] = 7.79, ["Neon|Ride"] = 36.15, ["Mega"] = 91.88, ["Mega|Ride"] = 106.64, ["Mega|Fly|Ride"] = 232.24}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.12}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 30.07, ["Fly|Ride"] = 57.83, ["Neon"] = 9.19, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 40.69, ["Mega|Ride"] = 109.6, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 138.25, ["Ride"] = 138.25, ["Fly|Ride"] = 262.5, ["Neon"] = 688.55, ["Neon|Ride"] = 676.16, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3567.75, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.6, ["Ride"] = 27.87, ["Neon"] = 19.69, ["Neon|Ride"] = 55.79, ["Mega"] = 173.15, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.77, ["Neon"] = 3.83, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.8, ["Mega|Ride"] = 101.16, ["Mega|Fly|Ride"] = 134.53}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.81, ["Ride"] = 26.5, ["Neon"] = 45.87, ["Neon|Ride"] = 110.48, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 412.93, ["Mega|Ride"] = 259.09, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.85, ["Fly"] = 25.47, ["Ride"] = 20.96, ["Fly|Ride"] = 54.69, ["Neon"] = 88.5, ["Neon|Ride"] = 117.91, ["Neon|Fly|Ride"] = 186.14, ["Mega"] = 597.19, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 27.51, ["Ride"] = 60.38, ["Fly|Ride"] = 123.32, ["Neon"] = 163.62, ["Neon|Ride"] = 177.57, ["Neon|Fly|Ride"] = 321.07, ["Mega|Ride"] = 604.61, ["Mega|Fly|Ride"] = 704.17}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 165.06, ["Fly"] = 237.78, ["Ride"] = 195.57, ["Fly|Ride"] = 254.27, ["Neon"] = 403.65, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 630.23, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 26.17, ["Fly"] = 51.19, ["Ride"] = 40.92, ["Fly|Ride"] = 77.57, ["Neon"] = 177.94, ["Neon|Fly"] = 205.44, ["Neon|Ride"] = 127.21, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 688.55, ["Mega|Ride"] = 551.18, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.89, ["Fly"] = 131.23, ["Ride"] = 19.63, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 137.82, ["Mega|Ride"] = 206.45, ["Mega|Fly|Ride"] = 254.68}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.09, ["Fly"] = 232.47, ["Ride"] = 32.45, ["Fly|Ride"] = 117.5, ["Neon"] = 63.68, ["Neon|Fly"] = 138.34, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 380.63, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.1, ["Fly"] = 143.4, ["Ride"] = 77.44, ["Fly|Ride"] = 137.82, ["Neon"] = 252.42, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 410.46, ["Mega"] = 1548.44, ["Mega|Ride"] = 1032.17, ["Mega|Fly|Ride"] = 1096.41}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.26, ["Ride"] = 126.07, ["Neon"] = 138.34, ["Neon|Ride"] = 243.64, ["Neon|Fly|Ride"] = 455.25, ["Mega"] = 683.82, ["Mega|Ride"] = 767.34, ["Mega|Fly|Ride"] = 825.74}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 550.85, ["Neon"] = 1377.08, ["Neon|Ride"] = 3102.44, ["Neon|Fly|Ride"] = 1789.98}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.86, ["Ride"] = 54.88, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.27, ["Ride"] = 15.49, ["Fly|Ride"] = 102.55, ["Neon"] = 2.1, ["Neon|Ride"] = 16.27, ["Neon|Fly|Ride"] = 65.04, ["Mega"] = 22.19, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 123.87, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 16.75, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 455.19}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 28.47, ["Ride"] = 65.63, ["Fly|Ride"] = 144.18, ["Neon"] = 19.68, ["Neon|Ride"] = 81.57, ["Neon|Fly|Ride"] = 964.17, ["Mega"] = 119.13, ["Mega|Fly"] = 504.88, ["Mega|Ride"] = 260.12, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 422.63, ["Ride"] = 458.07, ["Fly|Ride"] = 511, ["Neon"] = 1400.04, ["Neon|Ride"] = 1238.75, ["Neon|Fly|Ride"] = 1238.75, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.14, ["Fly"] = 61.2, ["Ride"] = 15.65, ["Fly|Ride"] = 52.49, ["Neon"] = 22.31, ["Neon|Ride"] = 66.4, ["Neon|Fly|Ride"] = 82.55, ["Mega"] = 168, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.86, ["Fly"] = 20.9, ["Ride"] = 17.07, ["Fly|Ride"] = 43.34, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 412.93, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 688.47, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.23, ["Fly"] = 32.61, ["Ride"] = 15.75, ["Neon"] = 13.12, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 111.69, ["Mega"] = 91.88, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 34.92, ["Ride"] = 40.2, ["Fly|Ride"] = 82.6, ["Neon"] = 103.24, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 824.71, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.43, ["Fly|Ride"] = 49.8, ["Neon"] = 12.57, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 160.47, ["Mega|Ride"] = 441.77, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 64.26, ["Ride"] = 25.46, ["Fly|Ride"] = 91.88, ["Neon"] = 138.34, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 275.63, ["Mega|Ride"] = 743.16, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.92, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 51.79, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 54.96, ["Ride"] = 138.25, ["Neon"] = 90.86}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 34.8, ["Ride"] = 80.07, ["Neon"] = 76.56, ["Neon|Ride"] = 123.88, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 304.54, ["Mega|Ride"] = 272.9, ["Mega|Fly|Ride"] = 548.09}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.82, ["Fly"] = 31.39, ["Ride"] = 29.93, ["Fly|Ride"] = 55.8, ["Neon"] = 51.16, ["Neon|Fly"] = 116.34, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 123.32, ["Mega"] = 580.15, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.5, ["Fly"] = 454.91, ["Ride"] = 327.15, ["Fly|Ride"] = 393.74, ["Neon"] = 1472.05, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1300.69, ["Mega|Fly|Ride"] = 5155.61}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32, ["Ride"] = 15.21, ["Fly|Ride"] = 56.8, ["Neon"] = 11.82, ["Neon|Fly"] = 77.96, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 212.89, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 291.83}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.93, ["Fly"] = 27.77, ["Ride"] = 45.92, ["Fly|Ride"] = 77.96, ["Neon"] = 39.38, ["Neon|Ride"] = 132.63, ["Neon|Fly|Ride"] = 262.22, ["Mega"] = 278.11, ["Mega|Ride"] = 344.75}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 26.25, ["Ride"] = 393.65, ["Fly|Ride"] = 232.67, ["Neon"] = 118.02, ["Neon|Ride"] = 187.7, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 363.64, ["Mega|Fly|Ride"] = 521.73}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 91.25, ["Ride"] = 163.63, ["Fly|Ride"] = 193.06, ["Neon"] = 673.05, ["Neon|Ride"] = 1466.16, ["Neon|Fly|Ride"] = 1321.32, ["Mega"] = 3102.44, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2697.27}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 35.09, ["Fly"] = 102.38, ["Ride"] = 77.38, ["Fly|Ride"] = 139.61, ["Neon"] = 97.1, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 214.73, ["Mega"] = 242.82, ["Mega|Ride"] = 296.4, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 16.94, ["Fly|Ride"] = 52.41, ["Neon"] = 10.28, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 52.5, ["Mega|Ride"] = 152.77, ["Mega|Fly|Ride"] = 155.8}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 7.88, ["Ride"] = 38.48, ["Neon"] = 30.89, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 153.57, ["Mega|Ride"] = 220.89, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 70.88, ["Fly"] = 196.88, ["Ride"] = 136.18, ["Fly|Ride"] = 216.57, ["Neon"] = 196.14, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 397.52, ["Mega"] = 467.78, ["Mega|Fly"] = 596.67, ["Mega|Ride"] = 542.49, ["Mega|Fly|Ride"] = 603.65}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.15, ["Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 97.08, ["Mega|Ride"] = 154.21, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 12.39, ["Fly|Ride"] = 275.63, ["Neon"] = 89.25, ["Neon|Ride"] = 401.03, ["Mega"] = 523.69, ["Mega|Fly|Ride"] = 816.45}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1006.69, ["Fly"] = 1100.64, ["Ride"] = 1023.75, ["Fly|Ride"] = 1076.25, ["Neon"] = 3166.02, ["Neon|Ride"] = 3879.5, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 14313.9}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 26.17, ["Fly"] = 116.17, ["Ride"] = 120.89, ["Fly|Ride"] = 191.63, ["Neon"] = 131.25, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 193.06, ["Mega"] = 964.17, ["Mega|Ride"] = 688.47, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.63, ["Fly"] = 49.26, ["Ride"] = 20.65, ["Fly|Ride"] = 80.89, ["Neon"] = 11.8, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.84, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 82.26, ["Mega|Ride"] = 143.88, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.51, ["Ride"] = 47.25, ["Fly|Ride"] = 138.34, ["Neon"] = 59.07, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 262.22, ["Mega|Ride"] = 344.3, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.48, ["Fly|Ride"] = 59.49, ["Neon"] = 2.63, ["Neon|Ride"] = 22.56, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 19.69, ["Mega|Fly"] = 123.88, ["Mega|Ride"] = 48.07, ["Mega|Fly|Ride"] = 162.78}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 54.9, ["Ride"] = 116.68, ["Fly|Ride"] = 228.38, ["Neon"] = 511, ["Neon|Ride"] = 410.93, ["Mega"] = 1051.46, ["Mega|Ride"] = 1395.49, ["Mega|Fly|Ride"] = 2477.19}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.17, ["Ride"] = 26.25, ["Fly|Ride"] = 124.68, ["Neon"] = 46.46, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 116.34, ["Mega"] = 589.79, ["Mega|Ride"] = 480.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.61, ["Ride"] = 26.69, ["Fly|Ride"] = 62.77, ["Neon"] = 13.12, ["Neon|Ride"] = 47.23, ["Mega"] = 99.74, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 33.66, ["Ride"] = 206.32, ["Fly|Ride"] = 157.5, ["Neon"] = 100.1, ["Neon|Fly|Ride"] = 344.8, ["Mega"] = 684.36, ["Mega|Ride"] = 1032.17, ["Mega|Fly|Ride"] = 775.48}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.69, ["Fly"] = 27.87, ["Ride"] = 52.49, ["Fly|Ride"] = 82.6, ["Neon"] = 47.54, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 315, ["Mega"] = 428.4, ["Mega|Ride"] = 513.4, ["Mega|Fly|Ride"] = 468.62}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 38.46, ["Ride"] = 84, ["Neon"] = 388.54, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 971.92, ["Mega"] = 1872.57, ["Mega|Ride"] = 1651.46, ["Mega|Fly|Ride"] = 1596.76}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.45, ["Ride"] = 60.54, ["Neon"] = 19.58, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 106.86, ["Mega|Ride"] = 210.57, ["Mega|Fly|Ride"] = 288.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.36, ["Ride"] = 22.32, ["Fly|Ride"] = 78.74, ["Neon"] = 61.69, ["Neon|Ride"] = 65.76, ["Neon|Fly|Ride"] = 160.01, ["Mega"] = 412.93, ["Mega|Ride"] = 381.92, ["Mega|Fly|Ride"] = 510.92}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 110.44, ["Fly"] = 515.76, ["Ride"] = 131.25, ["Fly|Ride"] = 275.63, ["Neon"] = 552.13, ["Neon|Ride"] = 565.15, ["Neon|Fly|Ride"] = 605.91, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1929.38}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 27.87, ["Ride"] = 15.65, ["Fly|Ride"] = 48.57, ["Neon"] = 11.95, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 124.59, ["Mega|Fly"] = 124.49, ["Mega|Ride"] = 184.77, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 8.54, ["Fly"] = 95.78, ["Ride"] = 25.16, ["Fly|Ride"] = 101.1, ["Neon"] = 73.5, ["Neon|Fly"] = 232.67, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 385.55, ["Mega|Ride"] = 326.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 12.29, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.81, ["Neon|Ride"] = 15.39, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 15.74, ["Mega|Ride"] = 33.06, ["Mega|Fly|Ride"] = 85.07}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.71, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 39.24, ["Mega"] = 30.26, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 61.76, ["Mega|Fly|Ride"] = 121.82}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.09, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 59.35, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 240.85}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 55.71, ["Ride"] = 52.47, ["Neon"] = 117.74, ["Neon|Ride"] = 348.99, ["Neon|Fly|Ride"] = 630, ["Mega"] = 418.4, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 668.85}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.94, ["Fly"] = 13.7, ["Ride"] = 16.34, ["Fly|Ride"] = 36.08, ["Neon"] = 14.33, ["Neon|Fly"] = 21, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 61.41, ["Mega"] = 114.18, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 10.34, ["Fly"] = 38.26, ["Ride"] = 24.94, ["Fly|Ride"] = 61.95, ["Neon"] = 21.84, ["Neon|Fly"] = 68.54, ["Neon|Ride"] = 27.89, ["Neon|Fly|Ride"] = 90.83, ["Mega"] = 183.21, ["Mega|Fly"] = 412.93, ["Mega|Ride"] = 184.48, ["Mega|Fly|Ride"] = 233.89}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 21.84, ["Ride"] = 18.09, ["Fly|Ride"] = 80.32, ["Neon"] = 6.43, ["Neon|Fly"] = 86.09, ["Neon|Ride"] = 20.06, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 102.8, ["Mega|Fly"] = 123.88, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 12.79, ["Fly"] = 36.11, ["Ride"] = 23.34, ["Neon"] = 26.25, ["Neon|Ride"] = 81, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 220.92, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 9.76, ["Ride"] = 122.72, ["Fly|Ride"] = 221.03, ["Neon"] = 46.55, ["Neon|Ride"] = 262.39, ["Mega"] = 412.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.16, ["Fly"] = 41.88, ["Ride"] = 25.58, ["Fly|Ride"] = 44.35, ["Neon"] = 21, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 65.04, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 330.35, ["Mega|Ride"] = 275.6, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 12.84, ["Fly|Ride"] = 34.9, ["Neon"] = 11.82, ["Neon|Fly"] = 46.55, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.15, ["Mega|Ride"] = 232.54, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.72, ["Fly"] = 393.75, ["Ride"] = 309.47, ["Fly|Ride"] = 392.43, ["Neon"] = 1129.32, ["Neon|Ride"] = 1361.04, ["Neon|Fly|Ride"] = 1094.23, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 8.91, ["Ride"] = 62.39, ["Neon"] = 42.94, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 412.93, ["Mega"] = 120.84, ["Mega|Ride"] = 544.99, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.78, ["Fly"] = 102.14, ["Ride"] = 21.53, ["Fly|Ride"] = 79.07, ["Neon"] = 20.26, ["Neon|Fly"] = 275.63, ["Neon|Ride"] = 53.69, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.7, ["Ride"] = 35.09, ["Neon"] = 60.38, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 619.39, ["Mega"] = 464.16, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 12.39, ["Ride"] = 13.02, ["Fly|Ride"] = 26.03, ["Neon"] = 2.1, ["Neon|Fly"] = 28.66, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 18.38, ["Mega|Fly"] = 69.18, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.63, ["Fly"] = 24.92, ["Ride"] = 18.94, ["Fly|Ride"] = 61.15, ["Neon"] = 9.19, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 95.78, ["Mega"] = 85.32, ["Mega|Ride"] = 143.6, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.29, ["Ride"] = 144.38, ["Fly|Ride"] = 197.18, ["Neon"] = 26.25, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 71.08, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 310.44}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.45, ["Fly"] = 162.74, ["Ride"] = 123.8, ["Fly|Ride"] = 193.06, ["Neon"] = 621.18, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2064.57, ["Mega|Ride"] = 3442.24, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 7.29, ["Fly"] = 91.88, ["Ride"] = 30.23, ["Fly|Ride"] = 262.48, ["Neon"] = 22.32, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 124.49, ["Mega"] = 211.54, ["Mega|Ride"] = 777.73, ["Mega|Fly|Ride"] = 411.84}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.46, ["Neon"] = 3.94, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 522.01, ["Mega"] = 43.32, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 82.59, ["Mega|Fly|Ride"] = 102.32}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.92, ["Fly"] = 77.89, ["Ride"] = 94.39, ["Fly|Ride"] = 209.99, ["Neon"] = 165.18, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 310.61, ["Mega"] = 636.57, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 13.78, ["Fly|Ride"] = 30.2, ["Neon"] = 2.63, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 15.68, ["Neon|Fly|Ride"] = 35.15, ["Mega"] = 16.96, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 47.5, ["Mega|Fly|Ride"] = 103.23}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.04, ["Neon|Fly|Ride"] = 179.64, ["Mega"] = 26.85, ["Mega|Ride"] = 97.04, ["Mega|Fly|Ride"] = 206.45}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 11.53, ["Neon|Ride"] = 108.61, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 63, ["Mega|Fly"] = 179.64, ["Mega|Ride"] = 116.16, ["Mega|Fly|Ride"] = 210.79}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.25, ["Fly"] = 45.94, ["Ride"] = 45.4, ["Fly|Ride"] = 105, ["Neon"] = 26.25, ["Neon|Fly"] = 138.34, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 232.67, ["Mega"] = 200.27, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 156.58, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.4, ["Fly|Ride"] = 36.15, ["Neon"] = 2.1, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.04, ["Mega|Ride"] = 48.24, ["Mega|Fly|Ride"] = 101.16}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 22.12, ["Fly"] = 131.25, ["Ride"] = 117.6, ["Neon"] = 104.82, ["Neon|Fly"] = 412.93, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 964.17, ["Mega"] = 448.03, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 687.43}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2888.25, ["Ride"] = 2100, ["Fly|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 9620.86, ["Mega|Fly|Ride"] = 34680.32}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 132.43, ["Ride"] = 13.97, ["Fly|Ride"] = 44.61, ["Neon"] = 10.45, ["Neon|Fly"] = 62.84, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 83.23, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.62, ["Fly"] = 110.39, ["Ride"] = 32.65, ["Fly|Ride"] = 105, ["Neon"] = 118.12, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 292.36, ["Mega"] = 344.8, ["Mega|Ride"] = 404.62, ["Mega|Fly|Ride"] = 893.21}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.41, ["Ride"] = 66.94, ["Neon"] = 186.14, ["Neon|Ride"] = 206.47, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1238.75, ["Mega|Ride"] = 817.47, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 218.7, ["Ride"] = 197.87, ["Fly|Ride"] = 375.76, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 881.57, ["Mega"] = 6193.69, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.71, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 18.38, ["Neon|Ride"] = 140.14, ["Mega"] = 156.19, ["Mega|Ride"] = 180.64, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.71, ["Fly|Ride"] = 138.34, ["Neon"] = 13.13, ["Neon|Ride"] = 275.63, ["Mega"] = 124.41, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 69.13, ["Fly|Ride"] = 131.25, ["Neon"] = 12.39, ["Neon|Ride"] = 24.78, ["Mega"] = 82.55, ["Mega|Ride"] = 112.8, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.4, ["Ride"] = 103.17, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.82, ["Mega"] = 465.32, ["Mega|Ride"] = 614.14, ["Mega|Fly|Ride"] = 412.88}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.28, ["Neon"] = 2.1, ["Neon|Ride"] = 82.6, ["Mega"] = 16.89, ["Mega|Fly"] = 116.34, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.88, ["Fly"] = 138.25, ["Ride"] = 110.39, ["Fly|Ride"] = 160.01, ["Neon"] = 455.25, ["Neon|Fly"] = 258.08, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 513.01, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1750.54}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.31, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 118.13, ["Mega|Ride"] = 255.98, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.63, ["Fly"] = 206.32, ["Ride"] = 88.73, ["Fly|Ride"] = 154.03, ["Neon"] = 266.44, ["Neon|Ride"] = 316.93, ["Neon|Fly|Ride"] = 688.55, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1547.44}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.62, ["Fly|Ride"] = 51.33, ["Neon"] = 6.27, ["Neon|Fly"] = 110.48, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 78.47, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 168.51}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 6.51, ["Neon"] = 21, ["Neon|Ride"] = 118.13, ["Mega"] = 64.32, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 7.65, ["Ride"] = 40.04, ["Neon"] = 104.9, ["Neon|Ride"] = 102.04, ["Mega"] = 232.4, ["Mega|Ride"] = 348.88, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 406.88, ["Ride"] = 515.76, ["Fly|Ride"] = 556.5, ["Neon"] = 1163.27, ["Neon|Ride"] = 1734.25, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 3536.96}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.9, ["Ride"] = 52.59, ["Fly|Ride"] = 81.27, ["Neon"] = 275.63, ["Neon|Ride"] = 255.97, ["Neon|Fly|Ride"] = 246.72, ["Mega|Ride"] = 1217.95, ["Mega|Fly|Ride"] = 1101.32}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.07, ["Fly|Ride"] = 91.88, ["Neon"] = 9.19, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 59.07, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 98.07}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.75, ["Fly"] = 219.18, ["Ride"] = 47.25, ["Fly|Ride"] = 124.38, ["Neon"] = 64.32, ["Neon|Fly"] = 103.24, ["Neon|Ride"] = 90.86, ["Neon|Fly|Ride"] = 180.55, ["Mega"] = 257.25, ["Mega|Fly"] = 957.38, ["Mega|Ride"] = 264.86, ["Mega|Fly|Ride"] = 377.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 10.34, ["Ride"] = 20.68, ["Fly|Ride"] = 82.6, ["Neon"] = 139.38, ["Neon|Ride"] = 76.41, ["Mega"] = 1101.45, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.89, ["Neon"] = 20.69, ["Mega"] = 63, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 20.9, ["Fly|Ride"] = 55.76, ["Neon"] = 24.94, ["Neon|Ride"] = 31.9, ["Neon|Fly|Ride"] = 378.87, ["Mega"] = 123.88, ["Mega|Ride"] = 94.98, ["Mega|Fly|Ride"] = 1651.46}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Ride"] = 129.98, ["Fly|Ride"] = 223.13, ["Neon"] = 636.32, ["Neon|Ride"] = 578.09, ["Neon|Fly|Ride"] = 769.13, ["Mega|Fly|Ride"] = 2600.01}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 50.67, ["Ride"] = 103.17, ["Fly|Ride"] = 138.34, ["Neon"] = 192.94, ["Neon|Ride"] = 179.64, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 682.5, ["Mega|Ride"] = 666.79, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.13, ["Fly"] = 2338.45, ["Ride"] = 2152.5, ["Fly|Ride"] = 2174.82, ["Neon"] = 11011.34, ["Neon|Fly|Ride"] = 5904.05, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.3, ["Fly"] = 65625, ["Ride"] = 75.98, ["Fly|Ride"] = 196.87, ["Neon"] = 13.13, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 105, ["Mega"] = 123.88, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 12.33, ["Ride"] = 51.35, ["Neon"] = 104.37, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.83, ["Mega|Ride"] = 408.99, ["Mega|Fly|Ride"] = 650.27}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1035.57, ["Fly"] = 1160, ["Ride"] = 961.54, ["Fly|Ride"] = 857.59, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2782.5, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 34.37, ["Fly"] = 82.55, ["Ride"] = 57.51, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 152.79, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 853.6}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.51, ["Ride"] = 23, ["Fly|Ride"] = 128.15, ["Neon"] = 15.75, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 214.6, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 551.18}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138.25, ["Neon"] = 2.52, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 77.96, ["Mega"] = 30.19, ["Mega|Ride"] = 106.33, ["Mega|Fly|Ride"] = 247.73}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.91, ["Ride"] = 127.32, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 8258.24, ["Mega|Fly|Ride"] = 5335.22}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.87, ["Ride"] = 30.02, ["Neon"] = 26.25, ["Neon|Ride"] = 123.88, ["Mega"] = 145.16, ["Mega|Ride"] = 310.44, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.49, ["Ride"] = 144.42, ["Fly|Ride"] = 103.24, ["Neon"] = 385.87, ["Neon|Ride"] = 465.32, ["Neon|Fly|Ride"] = 412.93}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.34, ["Fly"] = 105, ["Fly|Ride"] = 110.39, ["Neon"] = 18.38, ["Neon|Ride"] = 77.96, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 203.44, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 289.02}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 255.93, ["Ride"] = 275.63, ["Fly|Ride"] = 374.05, ["Neon"] = 1438.92, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.24, ["Fly"] = 87.94, ["Ride"] = 24.77, ["Fly|Ride"] = 55.76, ["Neon"] = 22.32, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 124.49, ["Mega"] = 309.7, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 374.92}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.73, ["Fly|Ride"] = 32.8, ["Neon"] = 3.94, ["Neon|Fly"] = 27.89, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 55.76, ["Mega"] = 54.58, ["Mega|Fly"] = 142.47, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 917.34, ["Ride"] = 1050, ["Fly|Ride"] = 1141.88, ["Neon|Ride"] = 7570.76, ["Neon|Fly|Ride"] = 5478.33, ["Mega"] = 26151.79}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.19, ["Fly"] = 963.45, ["Ride"] = 72.19, ["Fly|Ride"] = 206.47, ["Neon"] = 39.38, ["Neon|Ride"] = 131.12, ["Mega"] = 262.5, ["Mega|Ride"] = 379.85, ["Mega|Fly|Ride"] = 489.25}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 10.34, ["Fly"] = 46.09, ["Ride"] = 39.36, ["Fly|Ride"] = 97.05, ["Neon"] = 30.19, ["Neon|Fly"] = 124.49, ["Neon|Ride"] = 58.85, ["Neon|Fly|Ride"] = 134.22, ["Mega"] = 186.65, ["Mega|Fly"] = 228.16, ["Mega|Ride"] = 194.06, ["Mega|Fly|Ride"] = 268.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 39.38, ["Fly"] = 57.74, ["Ride"] = 39.29, ["Fly|Ride"] = 83.91, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 167.3, ["Mega"] = 2064.57, ["Mega|Ride"] = 1238.61, ["Mega|Fly|Ride"] = 1349.04}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.44, ["Fly"] = 77.38, ["Ride"] = 23.63, ["Fly|Ride"] = 89.25, ["Neon"] = 72.86, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 87.49, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 335.9}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.25, ["Ride"] = 209.99, ["Fly|Ride"] = 402.3, ["Neon"] = 113.95, ["Neon|Ride"] = 544.42, ["Mega"] = 465.32, ["Mega|Ride"] = 575.95, ["Mega|Fly|Ride"] = 516.09}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 275.63, ["Neon"] = 2.63, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 310.61, ["Mega"] = 15.75, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 55.13, ["Fly"] = 110.25, ["Ride"] = 65.54, ["Fly|Ride"] = 145.68, ["Neon"] = 393.75, ["Neon|Fly"] = 383.9, ["Neon|Ride"] = 379.23, ["Neon|Fly|Ride"] = 398.9, ["Mega"] = 3303.3, ["Mega|Ride"] = 1550.94, ["Mega|Fly|Ride"] = 1208.46}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.45, ["Fly"] = 103.31, ["Ride"] = 26.25, ["Fly|Ride"] = 104.99, ["Neon"] = 45.85, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 354.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 16.52, ["Fly|Ride"] = 38.07, ["Neon"] = 14.85, ["Neon|Ride"] = 52.65, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 271.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 20.14, ["Neon|Fly|Ride"] = 184.79, ["Mega"] = 275.63}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 40.06, ["Ride"] = 88.1, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 351, ["Mega"] = 825.84, ["Mega|Ride"] = 964.04, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 14.34, ["Fly|Ride"] = 412.93, ["Neon"] = 20.99, ["Neon|Ride"] = 77.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 101.67, ["Mega|Fly|Ride"] = 310.27}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 20.66, ["Mega"] = 15.63, ["Mega|Ride"] = 55.75, ["Mega|Fly|Ride"] = 385.71}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 25.49, ["Fly|Ride"] = 134.85, ["Neon"] = 2.1, ["Neon|Ride"] = 32.92, ["Mega"] = 19.57, ["Mega|Ride"] = 43.89, ["Mega|Fly|Ride"] = 129.84}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 23.35, ["Ride"] = 15.75, ["Fly|Ride"] = 40.25, ["Neon"] = 5.95, ["Neon|Ride"] = 18.05, ["Neon|Fly|Ride"] = 76.41, ["Mega"] = 123.88, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 148.83}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 36.14, ["Ride"] = 15.49, ["Fly|Ride"] = 46.55, ["Neon"] = 12.42, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 229.04, ["Mega|Ride"] = 275.6, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.66, ["Fly"] = 123.8, ["Ride"] = 165.06, ["Fly|Ride"] = 262.22, ["Neon"] = 155.89, ["Neon|Ride"] = 330.35, ["Neon|Fly|Ride"] = 1032.29, ["Mega"] = 1551.82, ["Mega|Ride"] = 955, ["Mega|Fly|Ride"] = 1094.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.8, ["Ride"] = 15.72, ["Fly|Ride"] = 35.34, ["Neon"] = 2.1, ["Neon|Fly"] = 27.89, ["Neon|Ride"] = 18.29, ["Neon|Fly|Ride"] = 41.63, ["Mega"] = 22.25, ["Mega|Fly|Ride"] = 129.74}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 15.39, ["Fly"] = 77.6, ["Ride"] = 21, ["Fly|Ride"] = 94.98, ["Neon"] = 25.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 58.77, ["Neon|Fly|Ride"] = 123.56, ["Mega"] = 383.9, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 289.7, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.46, ["Fly"] = 39.38, ["Ride"] = 30.11, ["Fly|Ride"] = 81.38, ["Neon"] = 110.15, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 787.5, ["Mega|Ride"] = 557.7, ["Mega|Fly|Ride"] = 620.85}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.54, ["Fly"] = 196.88, ["Neon"] = 44.63, ["Mega"] = 288.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.39, ["Fly|Ride"] = 43.29, ["Neon"] = 4.01, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.63, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 38.98, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.41, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.68, ["Fly"] = 52.5, ["Ride"] = 30.96, ["Neon"] = 11.63, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 91.88, ["Mega"] = 138.34, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 408.75}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1039.49, ["Ride"] = 1023.65, ["Fly|Ride"] = 1098.57, ["Neon"] = 3001.19, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2485.87, ["Mega|Fly|Ride"] = 6929.61}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 138.25, ["Fly|Ride"] = 144.25, ["Neon"] = 412.93, ["Neon|Ride"] = 511, ["Neon|Fly|Ride"] = 605.97, ["Mega"] = 1928.32, ["Mega|Ride"] = 2477.19, ["Mega|Fly|Ride"] = 1913.62}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.71, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 78.31, ["Mega|Fly|Ride"] = 206.45}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 66.94, ["Ride"] = 96.97, ["Fly|Ride"] = 186.14, ["Neon"] = 259.71, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1050, ["Mega|Ride"] = 1321.17, ["Mega|Fly|Ride"] = 1376.91}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.25, ["Ride"] = 26.75, ["Fly|Ride"] = 89.82, ["Neon"] = 19.69, ["Neon|Fly"] = 54.69, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 271.27, ["Mega|Ride"] = 337.87, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.08, ["Fly"] = 412.62, ["Ride"] = 315.67, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1750.76, ["Mega|Fly|Ride"] = 4580.68}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 40.24, ["Fly|Ride"] = 202.63, ["Neon"] = 25.6, ["Neon|Ride"] = 54.28, ["Mega"] = 309.7, ["Mega|Fly"] = 322.08, ["Mega|Ride"] = 186.03, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 155.9, ["Mega"] = 330.35}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 62.33, ["Ride"] = 72.19, ["Fly|Ride"] = 153.82, ["Neon"] = 123.32, ["Neon|Fly"] = 412.93, ["Neon|Ride"] = 192.02, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 605.97, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 275.63, ["Neon"] = 20.66, ["Neon|Ride"] = 412.93, ["Mega"] = 227.07, ["Mega|Ride"] = 253.29, ["Mega|Fly|Ride"] = 454.6}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 12.69, ["Ride"] = 12.94, ["Fly|Ride"] = 34.13, ["Neon"] = 3.87, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 37.53, ["Mega"] = 26.24, ["Mega|Ride"] = 45.44, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4442.82, ["Fly|Ride"] = 4488.75, ["Neon"] = 30968.4, ["Neon|Fly|Ride"] = 19293.74, ["Mega|Fly|Ride"] = 85324.89}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 20.9, ["Fly"] = 39.38, ["Ride"] = 55.44, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega|Ride"] = 236.71, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 20.65, ["Fly|Ride"] = 61.95, ["Neon"] = 13, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 165.16, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.47, ["Fly"] = 547.77, ["Ride"] = 525, ["Fly|Ride"] = 565.53, ["Neon"] = 1514.37, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1429.38, ["Mega|Fly|Ride"] = 5273.63}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.57, ["Ride"] = 26.25, ["Neon"] = 22.12, ["Neon|Ride"] = 145.69, ["Mega"] = 140.59, ["Mega|Fly|Ride"] = 688.47}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 8.27, ["Fly"] = 4126.06, ["Ride"] = 2063.03, ["Neon"] = 24.05, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 410.86, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 19.63, ["Neon"] = 5.25, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 55.76, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 811.81, ["Fly"] = 2063.03, ["Ride"] = 728.03, ["Fly|Ride"] = 761.25, ["Neon"] = 2362.5, ["Neon|Ride"] = 2615.82, ["Neon|Fly|Ride"] = 2361.09}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.69, ["Fly"] = 288.26, ["Ride"] = 74.81, ["Neon"] = 29.58, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 644.44, ["Mega"] = 156.19, ["Mega|Ride"] = 209.14, ["Mega|Fly|Ride"] = 387.49}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.62, ["Fly"] = 236.15, ["Ride"] = 39.38, ["Fly|Ride"] = 138.34, ["Neon"] = 22.32, ["Neon|Fly"] = 41.34, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 3879.5, ["Mega"] = 203.43, ["Mega|Ride"] = 218.76, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 16.68, ["Fly|Ride"] = 49.49, ["Neon"] = 7.88, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 275.63, ["Mega|Fly"] = 247.76, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.5, ["Ride"] = 69.13, ["Fly|Ride"] = 155.89, ["Neon"] = 117.59, ["Mega"] = 551.25, ["Mega|Fly|Ride"] = 743.16}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 412.93, ["Neon"] = 3.92, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 184.79, ["Mega"] = 44.18, ["Mega|Ride"] = 138.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 564.37, ["Fly|Ride"] = 700.94, ["Neon"] = 2589.57, ["Neon|Ride"] = 2715.07, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.94, ["Ride"] = 62.4, ["Fly|Ride"] = 310.61, ["Neon"] = 19.63, ["Neon|Ride"] = 111.69, ["Neon|Fly|Ride"] = 152.79, ["Mega"] = 72.19, ["Mega|Ride"] = 171.95, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.28, ["Neon"] = 6.57, ["Neon|Fly"] = 138.34, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 42, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.13, ["Neon|Ride"] = 41.73, ["Neon|Fly|Ride"] = 138.34, ["Mega"] = 45.94, ["Mega|Fly"] = 152.79, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.52, ["Ride"] = 27.46, ["Neon"] = 18.59, ["Mega"] = 202.42}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 123.98, ["Fly"] = 72.19, ["Ride"] = 61.9, ["Fly|Ride"] = 165.18, ["Neon"] = 129.94, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 688.55, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 727.13}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 30.97, ["Ride"] = 275.43, ["Fly|Ride"] = 138.34, ["Neon"] = 103.24, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 464.19, ["Mega|Fly"] = 412.93, ["Mega|Ride"] = 389.82, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.04, ["Fly"] = 19.45, ["Ride"] = 15.51, ["Fly|Ride"] = 44.33, ["Neon"] = 28.87, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 299.92, ["Mega|Ride"] = 276.86, ["Mega|Fly|Ride"] = 256.95}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.34, ["Ride"] = 64.32, ["Fly|Ride"] = 124.48, ["Neon"] = 138.34, ["Neon|Ride"] = 136.27, ["Mega"] = 310.61}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.58, ["Fly|Ride"] = 111.55, ["Neon"] = 14.44, ["Neon|Ride"] = 33.75, ["Neon|Fly|Ride"] = 207.08, ["Mega"] = 99.11, ["Mega|Ride"] = 152.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 23.63, ["Ride"] = 23.62, ["Fly|Ride"] = 76.41, ["Neon"] = 275.63, ["Neon|Ride"] = 185.83, ["Neon|Fly|Ride"] = 241.57, ["Mega"] = 928.04, ["Mega|Ride"] = 930.09, ["Mega|Fly|Ride"] = 894.89}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 69.13, ["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Fly|Ride"] = 964.04}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 65.63, ["Fly"] = 115.38, ["Ride"] = 77.18, ["Fly|Ride"] = 162.87, ["Neon"] = 294.96, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 364.88, ["Mega|Ride"] = 1643.95, ["Mega|Fly|Ride"] = 1510.05}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 42, ["Fly"] = 291.38, ["Ride"] = 82.46, ["Fly|Ride"] = 656.25, ["Neon"] = 160, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 408.33, ["Mega"] = 570.47, ["Mega|Ride"] = 660.6, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 22.39, ["Ride"] = 56.43, ["Fly|Ride"] = 138.34, ["Neon"] = 123.38, ["Neon|Ride"] = 123.88, ["Mega"] = 393.75, ["Mega|Ride"] = 757.62, ["Mega|Fly|Ride"] = 1238.61}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.1, ["Fly"] = 428.27, ["Ride"] = 47.25, ["Fly|Ride"] = 190.32, ["Neon"] = 87.92, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 464.37, ["Mega|Ride"] = 461.56, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.24, ["Fly|Ride"] = 37.17, ["Neon"] = 3.94, ["Neon|Fly"] = 25.41, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 123.88, ["Mega"] = 44.61, ["Mega|Fly"] = 155.9, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.38, ["Fly"] = 232.47, ["Ride"] = 126.93, ["Fly|Ride"] = 288.75, ["Neon"] = 293.99, ["Neon|Ride"] = 259.43, ["Mega"] = 784.54, ["Mega|Ride"] = 775.48, ["Mega|Fly|Ride"] = 936.17}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.6, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 46.55, ["Mega"] = 48.57, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 206.45}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.43, ["Ride"] = 69.76, ["Fly|Ride"] = 152.79, ["Neon"] = 128.37, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 619.32, ["Mega|Fly|Ride"] = 845.23}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 105, ["Mega"] = 32.82}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega|Ride"] = 165.16, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 105, ["Ride"] = 85.32, ["Fly|Ride"] = 257.25, ["Neon"] = 516.15, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 688.55, ["Mega|Ride"] = 2132.44, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 92.99, ["Neon"] = 7, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 108.71, ["Mega|Fly|Ride"] = 206.45}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 69.13, ["Fly|Ride"] = 55.76, ["Neon"] = 3.93, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 122.87, ["Mega"] = 38.07, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.55, ["Neon"] = 3.14, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 127.34, ["Mega"] = 37.1, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 237.42}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.94, ["Neon|Ride"] = 155.71, ["Mega"] = 62.79, ["Mega|Ride"] = 202.32}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 362.35, ["Neon|Ride"] = 511, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1238.75, ["Mega|Ride"] = 1548.24, ["Mega|Fly|Ride"] = 1498.7}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.37, ["Ride"] = 61.76, ["Fly|Ride"] = 131.25, ["Neon"] = 53.52, ["Neon|Ride"] = 155.9, ["Mega"] = 379.65, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 328.12, ["Fly"] = 464.94, ["Ride"] = 481.73, ["Fly|Ride"] = 619.39, ["Neon"] = 1032.29, ["Neon|Ride"] = 1086.5, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 4458.91}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.04}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.15}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 25.14}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 110.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.9}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 23.26}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.41}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 30.19}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 28.14}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.17}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.87}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.34}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 8.96}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 6.46}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 824.3}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 62.97}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.97}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 31.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.35}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.56}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.91}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.39}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 34.13}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 14.44}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.82}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.31}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.3}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.57}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.55}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1869.35}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 45.75}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.34}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.16}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 206.35}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.14}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.29}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1376.22}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 25.29}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.11}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 21.8}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.01}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.43}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.72}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.87}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.39}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.35}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 29.92}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.7}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.83}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 35.09}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 125.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.23}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 29.3}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.25}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 92.87}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.07}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22139.42}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 147.92}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 53.08}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.66}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 131.24}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.16}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.5}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 75.8}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 69.14}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 46.15}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 81.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 38.56}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 177.19}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 98.86}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.79}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.43}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.93}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.21}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 358}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.75}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.52}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.45}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 60.8}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.08}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.68}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 205.31}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 76.46}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.62}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.63}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.16}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 21.67}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.52}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.88}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.83}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.44}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 188.9}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.76}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.31}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.56}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 104.99}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.56}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.16}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.75}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 90.56}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 107.63}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 35.37}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.88}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.07}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.25}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.4}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 12.39}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7492.64}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.61}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.14}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.96}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 15.57}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 23.62}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.32}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 4.67}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 110.4}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 69.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.44}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 99.74}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.46}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4300.51}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.5}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.01}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.15}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.12}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 5.08}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.54}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.84}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.9}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.87}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 32.82}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.53}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.14}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.36}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 7.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.25}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.05}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 96.87}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.12}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 37.41}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 15.11}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 21.31}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.51}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.57}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 78.75}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.43}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 82.64}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.69}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.35}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21.61}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.9}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.05}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.05}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.44}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 18.69}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.38}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.49}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 70.87}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.2}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 27.81}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.02}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 105}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.45}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.74}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1254.84}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.45}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 233.37}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.09}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 48.77}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 72.19}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.41}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.52}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.14}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.7}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.61}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 18.37}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 8.27}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.61}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 69.14}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.5}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 77.02}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.35}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 35.44}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 124.69}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.52}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.83}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.16}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.48}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.31}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 138.26}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.41}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 237.56}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.61}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 110.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 8.26}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 164.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.54}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.35}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 58.8}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.84}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.18}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.18}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 35.95}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.65}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.92}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 11.46}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.11}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.01}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 50.55}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.43}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.79}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.82}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 36.66}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 20.85}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1771.88}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.11}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 39.75}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.35}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 377.03}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.85}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.43}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 262.4}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.86}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.92}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.82}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 61.69}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 124.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 72.19}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 183.75}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2166.2}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 6.14}},
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