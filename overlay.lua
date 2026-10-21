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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1047.5, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6672.05, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63, ["Mega|Fly|Ride"] = 17478.86}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 497.44, ["Fly|Ride"] = 560.82, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 6932.17}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 4470.1, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 21144.73, ["Mega|Fly|Ride"] = 70022.16}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 147, ["Ride"] = 227.64, ["Fly|Ride"] = 275.36, ["Neon"] = 980.89, ["Neon|Ride"] = 948.94, ["Neon|Fly|Ride"] = 1045.09, ["Mega|Fly|Ride"] = 4184.25}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 840.17, ["Ride"] = 639.19, ["Fly|Ride"] = 636.47, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 6.89, ["Ride"] = 32.42, ["Fly|Ride"] = 129.94, ["Neon"] = 59.07, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 350.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 588.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.09, ["Fly"] = 32.82, ["Ride"] = 24.87, ["Fly|Ride"] = 49.88, ["Neon"] = 27.44, ["Neon|Fly"] = 103.67, ["Neon|Ride"] = 55.43, ["Neon|Fly|Ride"] = 115.64, ["Mega"] = 154.77, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 279.69}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 210.06, ["Ride"] = 147.05, ["Neon"] = 557.67, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 1680.54, ["Mega"] = 2071.26}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.15, ["Fly"] = 83.42, ["Ride"] = 53.58, ["Fly|Ride"] = 103.48, ["Neon"] = 312.38, ["Neon|Ride"] = 286.13, ["Neon|Fly|Ride"] = 309.84, ["Mega"] = 1401.16, ["Mega|Ride"] = 1271.48, ["Mega|Fly|Ride"] = 1259.36}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.74, ["Fly"] = 79.31, ["Ride"] = 30.18, ["Fly|Ride"] = 69.34, ["Neon"] = 146, ["Neon|Ride"] = 309.83, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 47.25, ["Fly"] = 111.57, ["Ride"] = 70.87, ["Fly|Ride"] = 73.5, ["Neon"] = 445.61, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 417.38, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.07}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 399, ["Ride"] = 321.57, ["Fly|Ride"] = 380.69, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 4974.37}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.69, ["Fly"] = 168.05, ["Ride"] = 116.82, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 826.87, ["Mega|Fly|Ride"] = 3058.94}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 54.63, ["Fly|Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Fly"] = 98.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 128.63, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 317.22, ["Mega|Fly|Ride"] = 309.87}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 170.52, ["Fly"] = 225.9, ["Ride"] = 183.75, ["Fly|Ride"] = 229.66, ["Neon"] = 834.02, ["Neon|Ride"] = 868.53, ["Neon|Fly|Ride"] = 822.5, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.1, ["Fly"] = 19.49, ["Ride"] = 19.07, ["Fly|Ride"] = 37.31, ["Neon"] = 35.73, ["Neon|Ride"] = 92.44, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 77.26, ["Fly"] = 284.72, ["Ride"] = 140.13, ["Fly|Ride"] = 168.05, ["Neon"] = 271.39, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 474.37, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.75}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 63.89, ["Ride"] = 140.75, ["Fly|Ride"] = 210.06, ["Neon"] = 420.1, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15, ["Fly"] = 393.75, ["Ride"] = 26.25, ["Fly|Ride"] = 378.09, ["Neon"] = 206.3, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2740.77, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 630.21}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.01, ["Fly"] = 140.75, ["Ride"] = 61.59, ["Fly|Ride"] = 102.37, ["Neon"] = 699.45, ["Neon|Ride"] = 297.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1668.31, ["Mega|Ride"] = 1401.16, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Fly"] = 72.19, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 371.79, ["Neon|Fly|Ride"] = 449.5, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.7, ["Ride"] = 40.52, ["Fly|Ride"] = 84, ["Neon"] = 210.06, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 318.19, ["Mega"] = 890.7, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 35.83, ["Fly"] = 136.75, ["Ride"] = 75.26, ["Fly|Ride"] = 136.55, ["Neon"] = 196.88, ["Neon|Fly"] = 233.17, ["Neon|Ride"] = 378.1, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 941.07}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.61, ["Fly"] = 26.6, ["Ride"] = 23.19, ["Fly|Ride"] = 52.25, ["Neon"] = 21.84, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 48.04, ["Neon|Fly|Ride"] = 95.45, ["Mega"] = 190.32, ["Mega|Fly"] = 27100.4, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 446.25, ["Ride"] = 426.08, ["Fly|Ride"] = 490.21, ["Neon|Ride"] = 2940.57, ["Neon|Fly|Ride"] = 1906.63, ["Mega|Fly|Ride"] = 7687.35}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.02, ["Ride"] = 32.82, ["Fly|Ride"] = 107.34, ["Neon"] = 208.43, ["Mega|Ride"] = 798.27, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.72, ["Fly"] = 34.54, ["Ride"] = 19.85, ["Fly|Ride"] = 39.38, ["Neon"] = 75.26, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 113.24, ["Mega"] = 420.15, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 87.47, ["Fly"] = 102.38, ["Ride"] = 97.53, ["Fly|Ride"] = 128.63, ["Neon"] = 262.5, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 410.64, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 4075.29, ["Mega|Ride"] = 7985.65, ["Mega|Fly|Ride"] = 1666.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.09, ["Ride"] = 33.63, ["Fly|Ride"] = 75.21, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 700.49, ["Mega|Ride"] = 801.42, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.88, ["Fly"] = 354.98, ["Ride"] = 228.38, ["Fly|Ride"] = 301.88, ["Neon"] = 672.79, ["Neon|Ride"] = 903.12, ["Neon|Fly|Ride"] = 784.49, ["Mega"] = 6301.98, ["Mega|Fly|Ride"] = 5182.33}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 27.2}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.61, ["Fly"] = 32.07, ["Ride"] = 23.54, ["Fly|Ride"] = 53.44, ["Neon"] = 20.55, ["Neon|Fly"] = 140.75, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 147.71, ["Mega|Ride"] = 318.19, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.47, ["Fly"] = 2625, ["Ride"] = 892.5, ["Fly|Ride"] = 1106.27, ["Neon"] = 10207.32, ["Neon|Ride"] = 6161.53, ["Neon|Fly|Ride"] = 4480.71, ["Mega|Ride"] = 53623.41, ["Mega|Fly|Ride"] = 17159.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.81, ["Fly"] = 70.38, ["Ride"] = 22.65, ["Fly|Ride"] = 91.88, ["Neon"] = 98.74, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 225.75, ["Mega"] = 787.5, ["Mega|Ride"] = 1078.7, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.5, ["Ride"] = 201.41, ["Fly|Ride"] = 301.88, ["Neon"] = 1112.82, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 977.82, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.01}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.3, ["Fly"] = 112.4, ["Ride"] = 65.52, ["Fly|Ride"] = 145.69, ["Neon"] = 103.99, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 700.59, ["Mega|Ride"] = 1108.11, ["Mega|Fly|Ride"] = 589.87}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 127.38, ["Ride"] = 136.49, ["Fly|Ride"] = 236.25, ["Neon"] = 639.19, ["Neon|Ride"] = 446.92, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 115.49, ["Fly"] = 157.49, ["Ride"] = 163.95, ["Fly|Ride"] = 274.32, ["Neon"] = 360.94, ["Neon|Fly"] = 560.82, ["Neon|Ride"] = 332.32, ["Neon|Fly|Ride"] = 560.89, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1516.15}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.86}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.06, ["Fly"] = 62.7, ["Ride"] = 53.88, ["Fly|Ride"] = 73.34, ["Neon|Ride"] = 389.61, ["Neon|Fly|Ride"] = 367.84, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.03, ["Fly"] = 70.39, ["Ride"] = 56.82, ["Fly|Ride"] = 157.5, ["Neon"] = 42, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 560.89, ["Mega"] = 183.52, ["Mega|Fly"] = 267.75, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 433.13, ["Fly"] = 455.11, ["Ride"] = 462.95, ["Fly|Ride"] = 473.8, ["Neon|Ride"] = 3780.73, ["Neon|Fly|Ride"] = 1646.49, ["Mega|Fly|Ride"] = 8006.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 102.79, ["Fly"] = 210.06, ["Ride"] = 122.07, ["Fly|Ride"] = 179.67, ["Neon"] = 420, ["Neon|Ride"] = 770.44, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2519.75, ["Mega|Fly|Ride"] = 2497.7}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3150, ["Ride"] = 3885, ["Fly|Ride"] = 3675}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.42, ["Fly"] = 118.13, ["Ride"] = 49.88, ["Fly|Ride"] = 220.48, ["Neon|Ride"] = 318.12, ["Neon|Fly|Ride"] = 553.54, ["Mega"] = 1364.39, ["Mega|Ride"] = 2100.68, ["Mega|Fly|Ride"] = 1372.8}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 85.32, ["Fly|Ride"] = 136.71, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 710.83, ["Mega|Ride"] = 2241.42, ["Mega|Fly|Ride"] = 1998.52}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 29.72, ["Fly"] = 55.68, ["Ride"] = 44.18, ["Fly|Ride"] = 83.65, ["Neon"] = 210.06, ["Neon|Ride"] = 140.2, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 2625, ["Mega|Ride"] = 686.94, ["Mega|Fly|Ride"] = 656.04}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.16}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40.25, ["Fly"] = 393.75, ["Ride"] = 56.06, ["Fly|Ride"] = 65.61, ["Neon|Ride"] = 318.12, ["Neon|Fly|Ride"] = 420.15, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.66}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1092.21, ["Neon|Fly|Ride"] = 1088.16}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 984.38, ["Ride"] = 918.75, ["Fly|Ride"] = 1021.13, ["Neon|Fly|Ride"] = 3150.99, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.92}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.17, ["Fly"] = 39.35, ["Ride"] = 37.7, ["Fly|Ride"] = 58.97, ["Neon"] = 252.07, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 209.65, ["Mega|Ride"] = 1143.98, ["Mega|Fly|Ride"] = 905}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.16}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 6300.16, ["Fly|Ride"] = 4961.25, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41628.45}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.31, ["Fly"] = 52.41, ["Ride"] = 22.09, ["Fly|Ride"] = 53.44, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 700.59, ["Mega|Ride"] = 1514.63, ["Mega|Fly|Ride"] = 630.78}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.44, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 95.59, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 741.57, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 280.42, ["Ride"] = 58.95, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 389.64, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4201.33}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.91, ["Fly"] = 150.93, ["Ride"] = 25.91, ["Fly|Ride"] = 132.64, ["Neon"] = 78.78, ["Neon|Ride"] = 264.67, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1401.16, ["Mega|Ride"] = 747.16, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.87, ["Fly"] = 2325.16, ["Ride"] = 1706.25, ["Fly|Ride"] = 1598.23, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26505.94, ["Fly"] = 33606.38, ["Ride"] = 32156.25, ["Fly|Ride"] = 26250, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72769.34, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.98, ["Fly"] = 393.75, ["Ride"] = 67.69, ["Fly|Ride"] = 165.83, ["Neon"] = 315.07, ["Neon|Ride"] = 280.42, ["Neon|Fly|Ride"] = 420.15, ["Mega"] = 1181.25, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1527.2}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 73.63, ["Ride"] = 32.44, ["Fly|Ride"] = 155.39, ["Neon"] = 20.26, ["Neon|Fly"] = 151.33, ["Neon|Ride"] = 61.03, ["Neon|Fly|Ride"] = 181.09, ["Mega"] = 139.3, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.65}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.25, ["Ride"] = 38.45, ["Fly|Ride"] = 124.67, ["Neon"] = 89.09, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 552.49, ["Mega"] = 317.93, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 714, ["Ride"] = 708.75, ["Fly|Ride"] = 766.57, ["Neon"] = 3019.11, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11122.71}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.74, ["Fly"] = 975.19, ["Ride"] = 827.94, ["Fly|Ride"] = 905.62, ["Neon|Ride"] = 3641.06, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10603.69}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.37, ["Fly"] = 119.16, ["Ride"] = 32.48, ["Fly|Ride"] = 71.38, ["Neon"] = 112.88, ["Neon|Ride"] = 119.91, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 1202.37, ["Mega|Ride"] = 933.45, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.76}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 67.09, ["Fly"] = 111.57, ["Ride"] = 77.44, ["Fly|Ride"] = 112.26, ["Neon"] = 589.78, ["Neon|Ride"] = 406.44, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 77.97, ["Ride"] = 123.94, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 348.59, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1366.89, ["Mega|Fly|Ride"] = 2271.94}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.88, ["Fly"] = 30.55, ["Ride"] = 19.99, ["Fly|Ride"] = 38.89, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 65.13, ["Neon|Fly|Ride"] = 90.95, ["Mega|Fly|Ride"] = 527.9}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 118.42, ["Fly"] = 147, ["Ride"] = 158.06, ["Fly|Ride"] = 212.62, ["Neon"] = 725.82, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 530.25, ["Mega|Fly|Ride"] = 2004.19}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.1, ["Ride"] = 34.67, ["Fly|Ride"] = 140.75, ["Neon"] = 42, ["Neon|Ride"] = 82.69, ["Mega"] = 247.42, ["Mega|Ride"] = 918.74, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 9.19, ["Fly"] = 41.65, ["Ride"] = 30.19, ["Fly|Ride"] = 77.73, ["Neon"] = 91.88, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 310.92, ["Mega|Fly|Ride"] = 793.64}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.14, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 267.82, ["Neon|Ride"] = 318.12, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 898.04}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 12.86, ["Fly"] = 165.56, ["Ride"] = 35.75, ["Fly|Ride"] = 66.7, ["Neon"] = 91.87, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 209.03, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7326.81, ["Ride"] = 6555.94, ["Fly|Ride"] = 5500.69, ["Neon"] = 35007.34, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 26468.26}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.42, ["Fly"] = 236.25, ["Ride"] = 223.5, ["Fly|Ride"] = 271.68, ["Neon|Fly|Ride"] = 577.49, ["Mega|Fly|Ride"] = 1798.13}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 33.74, ["Fly"] = 141.53, ["Ride"] = 78.74, ["Fly|Ride"] = 179.83, ["Neon"] = 118.13, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 229.68, ["Mega"] = 448.01, ["Mega|Fly"] = 543.76, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 556.71}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 88.18, ["Ride"] = 28.38, ["Fly|Ride"] = 52.5, ["Neon"] = 31.5, ["Neon|Fly"] = 60.93, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 191.18, ["Mega"] = 341.25, ["Mega|Ride"] = 188.99}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 45.47, ["Fly"] = 140.76, ["Ride"] = 96.97, ["Fly|Ride"] = 136.5, ["Neon"] = 220.58, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 277.15, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 539.85, ["Mega|Ride"] = 594.55, ["Mega|Fly|Ride"] = 608.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13387.5, ["Fly|Ride"] = 12139.32, ["Neon|Fly|Ride"] = 24937.5, ["Mega|Fly|Ride"] = 112035.24}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.77, ["Ride"] = 255.94, ["Fly|Ride"] = 336.08, ["Neon"] = 1553.65, ["Neon|Ride"] = 1400.98, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6022.58}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.21, ["Fly"] = 82.91, ["Ride"] = 57.18, ["Fly|Ride"] = 111.57, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 6.36, ["Fly"] = 27.67, ["Ride"] = 28.38, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 270.46, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 476.86, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 378.96, ["Fly"] = 840.17, ["Ride"] = 393.74, ["Fly|Ride"] = 498.75, ["Neon"] = 1568.76, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1804.25, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.64, ["Fly"] = 103.81, ["Ride"] = 38.06, ["Fly|Ride"] = 111.57, ["Neon"] = 30.23, ["Neon|Ride"] = 127.31, ["Neon|Fly|Ride"] = 192.22, ["Mega"] = 137.82, ["Mega|Fly"] = 280.45, ["Mega|Ride"] = 202.99, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 100.96, ["Fly"] = 195.76, ["Ride"] = 129.83, ["Fly|Ride"] = 210, ["Neon"] = 625.93, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.4, ["Fly"] = 18.69, ["Ride"] = 18.8, ["Fly|Ride"] = 30.3, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 2520.8, ["Mega|Fly|Ride"] = 953.32}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.71}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.5, ["Ride"] = 58.46, ["Fly|Ride"] = 420.1, ["Neon"] = 421.32, ["Neon|Fly"] = 419.05, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 504.17, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1821.28}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.89, ["Fly"] = 103.99, ["Ride"] = 31.5, ["Fly|Ride"] = 93.19, ["Neon"] = 104.99, ["Neon|Ride"] = 164.43, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 548.46}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.48}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 44.84, ["Fly"] = 210, ["Ride"] = 111, ["Fly|Ride"] = 249.38, ["Neon"] = 295.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 2092.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.1, ["Ride"] = 29.24, ["Fly|Ride"] = 136.57, ["Neon"] = 24.94, ["Neon|Ride"] = 103.67, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 124.69, ["Mega|Ride"] = 225.75, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.19, ["Fly"] = 52.49, ["Ride"] = 28.82, ["Fly|Ride"] = 65.63, ["Neon"] = 159.67, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 210.08}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 490.28, ["Fly|Ride"] = 485.62, ["Neon|Fly|Ride"] = 5602.46, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 30.06, ["Ride"] = 57.58, ["Fly|Ride"] = 177.19, ["Neon"] = 318.12, ["Neon|Ride"] = 254.69, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.17, ["Fly"] = 140.75, ["Ride"] = 65.63, ["Fly|Ride"] = 159.67, ["Neon"] = 420.1, ["Neon|Ride"] = 420.1, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.16, ["Ride"] = 59.07, ["Fly|Ride"] = 125.98, ["Neon"] = 96.99, ["Neon|Ride"] = 187.2, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 414.74, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 12231.69, ["Fly|Ride"] = 8528.63, ["Neon|Fly|Ride"] = 17325, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1366.66, ["Fly"] = 1670.39, ["Ride"] = 1509.38, ["Fly|Ride"] = 1391.25, ["Neon|Fly|Ride"] = 3936.19, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 1312.49, ["Ride"] = 560.39, ["Fly|Ride"] = 538.12, ["Neon"] = 2552.07, ["Mega|Fly|Ride"] = 7002.54}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.5, ["Fly"] = 20.29, ["Ride"] = 21.51, ["Fly|Ride"] = 41.91, ["Neon"] = 67.93, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.93, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.4, ["Fly"] = 78.74, ["Ride"] = 28.38, ["Fly|Ride"] = 48.33, ["Neon"] = 20.29, ["Neon|Ride"] = 55.12, ["Mega"] = 160.89, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.37, ["Fly"] = 44.63, ["Ride"] = 53.63, ["Fly|Ride"] = 79.71, ["Neon"] = 536.17, ["Neon|Ride"] = 155.92, ["Neon|Fly|Ride"] = 197.75, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 22.46, ["Ride"] = 15.75, ["Fly|Ride"] = 26.25, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 195.57, ["Mega|Ride"] = 241.6, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.69, ["Fly"] = 369.49, ["Ride"] = 324.19, ["Fly|Ride"] = 420.35, ["Neon|Ride"] = 1469.25, ["Neon|Fly|Ride"] = 1674.03, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 12.91, ["Fly"] = 59.53, ["Ride"] = 44.63, ["Fly|Ride"] = 105, ["Neon"] = 208.95, ["Neon|Ride"] = 142.7, ["Neon|Fly|Ride"] = 287.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.66, ["Fly"] = 20.99, ["Ride"] = 17.88, ["Fly|Ride"] = 45.17, ["Neon"] = 98.94, ["Neon|Fly"] = 135.84, ["Neon|Ride"] = 129.06, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.5, ["Fly"] = 1048.69, ["Ride"] = 524.06, ["Fly|Ride"] = 700.49, ["Neon|Fly|Ride"] = 2100.68, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1452.26, ["Ride"] = 1260, ["Fly|Ride"] = 1384.69, ["Neon"] = 4901.29, ["Neon|Ride"] = 4200.8, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 103.62, ["Fly"] = 136.55, ["Ride"] = 97.13, ["Fly|Ride"] = 98.74, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2381.1}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 179.58, ["Fly"] = 196.87, ["Ride"] = 182.44, ["Fly|Ride"] = 232.32, ["Neon"] = 851.73, ["Neon|Fly"] = 699.45, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 591.21, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.44, ["Fly"] = 120.79, ["Ride"] = 53.81, ["Neon"] = 233.88, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 2100.68, ["Mega|Fly|Ride"] = 981.02}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 315, ["Fly|Ride"] = 560.82, ["Neon|Fly"] = 953.16, ["Neon|Fly|Ride"] = 1334.65, ["Mega|Fly|Ride"] = 4201.33}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2065.82, ["Fly"] = 2263.57, ["Ride"] = 2483.25, ["Fly|Ride"] = 2230.62, ["Neon|Fly|Ride"] = 10503.28, ["Mega|Fly|Ride"] = 28599.16}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 210.06, ["Ride"] = 51.75, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1120.71, ["Mega|Fly|Ride"] = 2520.8}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 610.19, ["Fly|Ride"] = 630, ["Neon|Fly|Ride"] = 1214.07, ["Mega|Fly|Ride"] = 3360}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 26.25, ["Fly"] = 69.12, ["Ride"] = 45.93, ["Fly|Ride"] = 87.25, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1453.67}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 17.07, ["Fly|Ride"] = 53.17, ["Neon"] = 19.69, ["Neon|Fly"] = 159.67, ["Neon|Ride"] = 44.59, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 138.25, ["Mega|Ride"] = 182.11, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 52.41, ["Ride"] = 91.88, ["Fly|Ride"] = 253.32, ["Neon"] = 346.59, ["Neon|Ride"] = 489.41, ["Neon|Fly|Ride"] = 700.49, ["Mega"] = 1535.6}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 1085.44, ["Ride"] = 835.96, ["Fly|Ride"] = 918.23, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2651.25, ["Mega|Fly|Ride"] = 10762.5}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714.65, ["Ride"] = 1027.09, ["Fly|Ride"] = 974.59, ["Neon|Fly|Ride"] = 4200.28, ["Mega|Fly|Ride"] = 15263.36}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.85, ["Fly"] = 25.71, ["Ride"] = 22.26, ["Fly|Ride"] = 38.72, ["Neon"] = 85.32, ["Neon|Ride"] = 98.74, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.09, ["Ride"] = 19.37, ["Fly|Ride"] = 70.39, ["Neon"] = 141.44, ["Neon|Ride"] = 103.97, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 570.94, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.31, ["Ride"] = 23.63, ["Fly|Ride"] = 140.75, ["Neon"] = 19.47, ["Neon|Fly"] = 318.12, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 157.68, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 276.05, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.45, ["Fly"] = 75.64, ["Ride"] = 47.02, ["Fly|Ride"] = 106.22, ["Neon"] = 249.38, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1271.48}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 52.49, ["Ride"] = 135.19, ["Fly|Ride"] = 1050.2, ["Neon"] = 424.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1575.51, ["Mega|Fly|Ride"] = 1575.51}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 43.31, ["Ride"] = 26.25, ["Fly|Ride"] = 63, ["Neon"] = 98.44, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 156.18, ["Mega|Ride"] = 352.97, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 33.16, ["Ride"] = 39.37, ["Fly|Ride"] = 94.56, ["Neon"] = 333.98, ["Neon|Fly"] = 1400.98, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 16.07, ["Fly|Ride"] = 42, ["Neon"] = 29.3, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 735.25, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.71, ["Fly"] = 46.41, ["Ride"] = 32.48, ["Fly|Ride"] = 32206.47, ["Neon"] = 37.03, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 142.99, ["Mega"] = 301.46, ["Mega|Ride"] = 315}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.35, ["Fly"] = 65.63, ["Ride"] = 53.33, ["Fly|Ride"] = 96.55, ["Neon"] = 413.44, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1574.9, ["Fly"] = 1575, ["Ride"] = 1417.4, ["Fly|Ride"] = 658.45, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 14020.62}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.38, ["Fly"] = 479.81, ["Ride"] = 472.5, ["Fly|Ride"] = 473.82, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 10503.28}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 282.19, ["Ride"] = 284.82, ["Fly|Ride"] = 459.38, ["Neon"] = 1181.25, ["Neon|Ride"] = 1540.66, ["Neon|Fly|Ride"] = 1687.37, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.31}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.61, ["Ride"] = 46.85, ["Fly|Ride"] = 98.44, ["Neon|Fly"] = 420.1, ["Neon|Ride"] = 524.06, ["Neon|Fly|Ride"] = 420.15, ["Mega|Ride"] = 1527.2, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 32206.47, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17456.25, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 210065.4, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 262.49, ["Fly"] = 611.63, ["Ride"] = 275.63, ["Fly|Ride"] = 354.75, ["Neon"] = 945, ["Neon|Fly"] = 1112.82, ["Neon|Ride"] = 864.96, ["Neon|Fly|Ride"] = 1010.24, ["Mega"] = 4760.1, ["Mega|Ride"] = 4200.28, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.69, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1748.14}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.38, ["Fly"] = 280.42, ["Ride"] = 140.75, ["Fly|Ride"] = 229.48, ["Neon|Ride"] = 625.37, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.45, ["Fly"] = 94.5, ["Ride"] = 26.25, ["Fly|Ride"] = 70.39, ["Neon"] = 70.88, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 712.62, ["Mega|Fly|Ride"] = 650.16}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3936.19, ["Ride"] = 3937.5, ["Fly|Ride"] = 4689.89, ["Neon"] = 27305.18, ["Neon|Fly|Ride"] = 28005.67}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.57, ["Fly"] = 56.73, ["Ride"] = 30.17, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 212.63, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.37, ["Fly"] = 106.51, ["Ride"] = 56.59, ["Fly|Ride"] = 95.82, ["Neon|Fly"] = 1400.98, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 248.07, ["Mega|Fly|Ride"] = 1372.87}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 603.75, ["Fly"] = 826.52, ["Ride"] = 619.5, ["Fly|Ride"] = 682.5, ["Neon"] = 1837.5, ["Neon|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 2034.38, ["Mega"] = 8192.57, ["Mega|Fly"] = 8192.57, ["Mega|Fly|Ride"] = 6090}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.49, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 39.38, ["Neon"] = 118.12, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 141.96, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.85, ["Ride"] = 27.57, ["Fly|Ride"] = 476.59, ["Neon"] = 95.82, ["Neon|Ride"] = 119.16, ["Neon|Fly|Ride"] = 249.38}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.69, ["Ride"] = 128.63, ["Fly|Ride"] = 204.8, ["Neon"] = 1010.63, ["Neon|Ride"] = 840.17, ["Neon|Fly|Ride"] = 560.89, ["Mega|Fly|Ride"] = 2764.6}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 9.98, ["Fly"] = 151.59, ["Ride"] = 62.79, ["Fly|Ride"] = 131.06, ["Neon"] = 52.53, ["Neon|Fly"] = 210.06, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 236.4, ["Mega"] = 307.13, ["Mega|Fly"] = 728.95, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 413.77}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3734.28, ["Ride"] = 3883.64, ["Fly|Ride"] = 4182.51, ["Neon"] = 18903.6, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 36761.45, ["Mega|Fly|Ride"] = 36225.6}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 27.97, ["Fly"] = 105.04, ["Ride"] = 65.31, ["Fly|Ride"] = 155.45, ["Neon"] = 1611.02, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 571.6, ["Mega"] = 840.28, ["Mega|Ride"] = 1748.14, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 7841.86, ["Ride"] = 6857.82, ["Fly|Ride"] = 7168.87, ["Neon|Ride"] = 19604.07, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 82376.11}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 21.84, ["Ride"] = 14.88, ["Fly|Ride"] = 31.29, ["Neon"] = 23.63, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 195.57, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 347.67}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.1, ["Fly"] = 28.92, ["Ride"] = 26.38, ["Fly|Ride"] = 50.68, ["Neon"] = 182.76, ["Neon|Fly"] = 232.12, ["Neon|Ride"] = 102.94, ["Neon|Fly|Ride"] = 161.44, ["Mega|Ride"] = 985.04, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.46}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 7.77, ["Ride"] = 32.82, ["Fly|Ride"] = 116.03, ["Neon"] = 86.47, ["Neon|Ride"] = 139.12, ["Mega"] = 1050, ["Mega|Ride"] = 881.24, ["Mega|Fly|Ride"] = 1589.65}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 190.37, ["Ride"] = 43.29, ["Fly|Ride"] = 99.73, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 318.27, ["Mega"] = 945, ["Mega|Ride"] = 953.32, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.69, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 34.63, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2520.8, ["Mega|Ride"] = 594.64, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8541.29}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 16.96}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 219.14, ["Ride"] = 252.07, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 5684.39}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.5, ["Ride"] = 35.57, ["Fly|Ride"] = 128.69, ["Neon"] = 183.81, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 525.53, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.96}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 30.48, ["Neon|Ride"] = 182.76, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 162.75, ["Ride"] = 215.25, ["Fly|Ride"] = 328.13, ["Neon"] = 910.53, ["Neon|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 69.93, ["Ride"] = 102.94, ["Fly|Ride"] = 210.06, ["Neon"] = 560.82, ["Neon|Ride"] = 322.43, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2100.68, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 156.19, ["Fly"] = 350.78, ["Ride"] = 196.8, ["Fly|Ride"] = 254.17, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 849.79, ["Mega|Ride"] = 3226.13, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 1968.75, ["Ride"] = 1837.5, ["Fly|Ride"] = 1968.75, ["Neon|Ride"] = 8736.62, ["Neon|Fly|Ride"] = 7219.89, ["Mega|Fly|Ride"] = 18507.57}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 13.06, ["Fly"] = 98.74, ["Ride"] = 56.8, ["Fly|Ride"] = 99.73, ["Neon"] = 127.32, ["Neon|Ride"] = 207.33, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 944.26, ["Mega|Ride"] = 1033.16, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 735, ["Fly|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 4200.28, ["Mega|Fly|Ride"] = 16682.86}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.37}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 17.06, ["Ride"] = 52.53, ["Fly|Ride"] = 647.98, ["Neon"] = 81.38, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 411.35, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.12, ["Fly"] = 165.55, ["Ride"] = 19.85, ["Fly|Ride"] = 100.84, ["Neon"] = 53.45, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.7, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 77.73}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.92, ["Fly"] = 108.92, ["Ride"] = 30.97, ["Fly|Ride"] = 81.93, ["Neon"] = 95.33, ["Neon|Ride"] = 252.07, ["Neon|Fly|Ride"] = 352.93, ["Mega|Fly|Ride"] = 2225.98}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 20.48, ["Fly"] = 77.74, ["Ride"] = 45.94, ["Fly|Ride"] = 52.4, ["Neon|Ride"] = 420.1, ["Neon|Fly|Ride"] = 318.27, ["Mega|Ride"] = 1787.46, ["Mega|Fly|Ride"] = 981.02}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 5183.2, ["Neon|Fly|Ride"] = 11812.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.88, ["Fly"] = 65.62, ["Ride"] = 33.52, ["Fly|Ride"] = 78.65, ["Neon"] = 44.56, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 222.86, ["Mega"] = 532.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 533.4}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.96}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 105, ["Fly"] = 371.79, ["Ride"] = 132.6, ["Fly|Ride"] = 196.88, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 738.31, ["Mega"] = 2879.59}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 42.26, ["Fly"] = 142.97, ["Ride"] = 69.69, ["Fly|Ride"] = 155.93, ["Neon"] = 255.94, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2383.27, ["Mega|Ride"] = 2835.9, ["Mega|Fly|Ride"] = 1540.84}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.9, ["Fly"] = 70.47, ["Ride"] = 27.56, ["Fly|Ride"] = 68.23, ["Neon|Ride"] = 142.7, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 1016.21, ["Mega|Ride"] = 874.68, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.61, ["Fly"] = 65.54, ["Ride"] = 22.85, ["Fly|Ride"] = 60.93, ["Neon"] = 25.94, ["Neon|Fly"] = 70.39, ["Neon|Ride"] = 50.89, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 190.11, ["Mega|Fly"] = 6976.09, ["Mega|Ride"] = 178.29, ["Mega|Fly|Ride"] = 310.06}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 8.76, ["Ride"] = 27.46, ["Fly|Ride"] = 94.5, ["Neon"] = 86.63, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 525, ["Mega|Ride"] = 541.02, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.28, ["Fly"] = 23.63, ["Ride"] = 24.82, ["Fly|Ride"] = 42.09, ["Neon"] = 364.43, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 187.69}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.97, ["Ride"] = 131.24, ["Fly|Ride"] = 280.42, ["Neon"] = 170.63, ["Neon|Ride"] = 280.42, ["Neon|Fly|Ride"] = 575.6, ["Mega"] = 1260.41, ["Mega|Fly|Ride"] = 1680.54}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 209.9, ["Ride"] = 443.63, ["Fly|Ride"] = 1589.27}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.59, ["Fly"] = 212.42, ["Ride"] = 105.88, ["Fly|Ride"] = 210.99, ["Neon"] = 243.66, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 918.75, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1549.13}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.73, ["Fly"] = 1190.95, ["Ride"] = 1007.97, ["Fly|Ride"] = 978.7, ["Neon|Fly"] = 4122.38, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 393.65, ["Fly"] = 700.49, ["Ride"] = 413.44, ["Fly|Ride"] = 570.94, ["Neon"] = 2520.5, ["Neon|Ride"] = 2520.5, ["Neon|Fly|Ride"] = 2559.38, ["Mega"] = 12603.94, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 66.89}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.59, ["Fly"] = 20.99, ["Ride"] = 20.9, ["Fly|Ride"] = 43.32, ["Neon"] = 78.74, ["Neon|Fly"] = 168.05, ["Neon|Ride"] = 116.6, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 261.19, ["Fly"] = 525, ["Ride"] = 306.58, ["Fly|Ride"] = 380.63, ["Neon"] = 1099.58, ["Neon|Ride"] = 1029.16, ["Neon|Fly|Ride"] = 1100.75, ["Mega|Fly|Ride"] = 3249.73}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.3}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 160.96, ["Ride"] = 187.67, ["Fly|Ride"] = 283.71, ["Neon"] = 538.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 702.19, ["Mega"] = 10083.15, ["Mega|Ride"] = 11948.53, ["Mega|Fly|Ride"] = 3287.53}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 110.25, ["Fly"] = 105, ["Ride"] = 128.56, ["Fly|Ride"] = 130.09, ["Neon"] = 770.86, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 888.57, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 5602.46, ["Mega|Fly|Ride"] = 2520.8}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.93, ["Ride"] = 27.49, ["Fly|Ride"] = 171.2, ["Neon"] = 27.57, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 322.46, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 839.22}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.61, ["Fly"] = 63.03, ["Ride"] = 27.13, ["Fly|Ride"] = 74.75, ["Neon"] = 140.75, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 318.19, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.71, ["Fly"] = 102.34, ["Ride"] = 39.82, ["Fly|Ride"] = 104.69, ["Neon"] = 65.63, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.92, ["Fly"] = 131.23, ["Ride"] = 54.57, ["Fly|Ride"] = 165.55, ["Neon"] = 21.15, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 142.7, ["Mega|Ride"] = 179.45, ["Mega|Fly|Ride"] = 285.48}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 269.07, ["Ride"] = 290.04, ["Fly|Ride"] = 354.38, ["Neon"] = 1653.03, ["Neon|Ride"] = 1355.86, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 106.32, ["Fly"] = 111.57, ["Ride"] = 150.25, ["Fly|Ride"] = 241.49, ["Neon"] = 1096.13, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1173.38, ["Mega|Fly|Ride"] = 2401.88}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.56, ["Ride"] = 69.34, ["Fly|Ride"] = 126.04, ["Neon"] = 393.75, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.14}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.17, ["Ride"] = 70.39, ["Fly|Ride"] = 280.42, ["Neon|Ride"] = 605.27, ["Neon|Fly|Ride"] = 490.52, ["Mega|Fly|Ride"] = 1962.02}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.13, ["Fly"] = 58.47, ["Ride"] = 28.73, ["Fly|Ride"] = 79.03, ["Neon"] = 77.42, ["Neon|Fly"] = 280.42, ["Neon|Ride"] = 126.04, ["Neon|Fly|Ride"] = 189.49, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 464.76, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.36, ["Fly|Ride"] = 44.16, ["Neon"] = 19.98, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 137.1, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 987.73, ["Fly"] = 1050, ["Ride"] = 914.82, ["Fly|Ride"] = 397.89, ["Neon|Fly"] = 3257.4, ["Neon|Ride"] = 3203.12, ["Neon|Fly|Ride"] = 2624.88, ["Mega|Fly|Ride"] = 10327.88}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.25, ["Ride"] = 315, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1557.48, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 6298.99}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.18, ["Fly"] = 160.13, ["Ride"] = 103.64, ["Fly|Ride"] = 196.88, ["Neon"] = 283.08, ["Neon|Ride"] = 336.08, ["Neon|Fly|Ride"] = 590.22, ["Mega"] = 1312.5, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 1730.26}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 263.82, ["Fly"] = 283.5, ["Ride"] = 223.13, ["Fly|Ride"] = 308.44, ["Neon|Fly|Ride"] = 1589.39, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 27.57, ["Fly|Ride"] = 68.61, ["Neon"] = 150.94, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 794.83}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 236.25, ["Fly|Ride"] = 472.5, ["Neon"] = 1537.89, ["Neon|Ride"] = 925.24, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4171.13, ["Mega|Ride"] = 4621.45, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 44.62, ["Fly"] = 125.98, ["Ride"] = 75.45, ["Fly|Ride"] = 100.11, ["Neon|Fly|Ride"] = 560.89, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1967.44, ["Ride"] = 1968.75, ["Fly|Ride"] = 1820.44, ["Neon|Ride"] = 11120.87, ["Neon|Fly|Ride"] = 7422.69, ["Mega"] = 50415.7, ["Mega|Fly|Ride"] = 22827.82}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.12, ["Fly"] = 76.25, ["Ride"] = 34.06, ["Fly|Ride"] = 71.28, ["Neon"] = 51.89, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 103.99, ["Neon|Fly|Ride"] = 192.09, ["Mega"] = 420.97, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.79, ["Ride"] = 99.79, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 349.13, ["Mega"] = 1668.31, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 64.34, ["Fly"] = 78.7, ["Ride"] = 77.3, ["Fly|Ride"] = 106.32, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.71, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2135.97, ["Fly"] = 1589.27, ["Ride"] = 958.13, ["Fly|Ride"] = 1131.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 582.88, ["Ride"] = 660.01, ["Fly|Ride"] = 630.13, ["Neon|Fly|Ride"] = 3333.74}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 67.93, ["Fly"] = 318.1, ["Ride"] = 94.5, ["Fly|Ride"] = 284.62, ["Neon"] = 418, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2661.54, ["Mega|Fly|Ride"] = 3502.86}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.85, ["Ride"] = 19.58, ["Fly|Ride"] = 105.04, ["Neon"] = 73.59, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.14, ["Ride"] = 54.01, ["Fly|Ride"] = 104.68, ["Neon"] = 210.06, ["Neon|Fly"] = 329.78, ["Neon|Ride"] = 218.05, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 796.59, ["Fly"] = 1096.06, ["Ride"] = 715.43, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2162.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 739.83}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6721.3, ["Fly|Ride"] = 5904.03, ["Neon"] = 42000, ["Neon|Ride"] = 30099.78, ["Neon|Fly|Ride"] = 23362.5, ["Mega|Fly|Ride"] = 89628.61}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 303.38, ["Fly"] = 496.12, ["Ride"] = 393.75, ["Neon"] = 1680.33, ["Neon|Fly|Ride"] = 2205.7, ["Mega"] = 6300.93, ["Mega|Fly|Ride"] = 6673.15}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 91.82, ["Fly"] = 280.42, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon|Ride"] = 722.55, ["Neon|Fly|Ride"] = 626.01, ["Mega|Fly|Ride"] = 2158.44}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.71, ["Fly"] = 65.62, ["Ride"] = 37.36, ["Fly|Ride"] = 118.69, ["Neon"] = 112.88, ["Neon|Fly"] = 1271.28, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 978.92, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 812.97}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.77, ["Fly"] = 26.24, ["Ride"] = 21.4, ["Fly|Ride"] = 44.36, ["Neon|Ride"] = 318.12, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2241.42}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.69, ["Ride"] = 25.98, ["Fly|Ride"] = 120.75, ["Neon"] = 154.88, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 233.19, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.45, ["Fly"] = 77.74, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.44, ["Neon|Ride"] = 56.01, ["Neon|Fly|Ride"] = 138.66, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.28, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 840.17, ["Neon|Ride"] = 247.86, ["Neon|Fly|Ride"] = 420.04, ["Mega"] = 630, ["Mega|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 812.97}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 425.15, ["Fly"] = 538.12, ["Ride"] = 443.03, ["Fly|Ride"] = 465.36, ["Neon"] = 1575.31, ["Neon|Ride"] = 1575.1, ["Neon|Fly|Ride"] = 1147.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5459.62}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 15.16, ["Fly|Ride"] = 31.5, ["Neon"] = 25.23, ["Neon|Ride"] = 23.27, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 840.28, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.8, ["Fly"] = 102, ["Ride"] = 83.06, ["Fly|Ride"] = 127.33, ["Neon"] = 157.5, ["Neon|Fly"] = 428.45, ["Neon|Ride"] = 199.63, ["Neon|Fly|Ride"] = 255.81, ["Mega"] = 575.49, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 561.37}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 800.62, ["Fly|Ride"] = 462.05, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3934.88}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.37, ["Fly"] = 165.38, ["Ride"] = 39.48, ["Fly|Ride"] = 101.34, ["Neon|Ride"] = 158.09, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 390.65, ["Fly"] = 380.7, ["Ride"] = 283.5, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1821.06, ["Neon|Fly|Ride"] = 1470.48}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.18, ["Fly"] = 275.17, ["Ride"] = 196.27, ["Fly|Ride"] = 233.89, ["Neon"] = 980.89, ["Neon|Ride"] = 990.1, ["Neon|Fly|Ride"] = 890.44, ["Mega|Fly|Ride"] = 4998.52}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 826.52, ["Ride"] = 783.57, ["Fly|Ride"] = 939.94, ["Neon|Fly|Ride"] = 3010.93, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.04, ["Fly"] = 84.03, ["Ride"] = 32.58, ["Fly|Ride"] = 110.25, ["Neon"] = 84.03, ["Neon|Fly"] = 285.96, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 276.48, ["Mega"] = 354.38, ["Mega|Ride"] = 437.34, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3584.44, ["Neon"] = 14003.36, ["Neon|Fly|Ride"] = 7021.88, ["Mega|Fly|Ride"] = 25006.2}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 118.13, ["Fly"] = 166.28, ["Ride"] = 115.5, ["Fly|Ride"] = 206.58, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 3169.76}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 18.36, ["Ride"] = 15.94, ["Fly|Ride"] = 38.07, ["Neon"] = 19.81, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 116.61, ["Mega"] = 146.77, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 364.48, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.1, ["Ride"] = 18.92, ["Fly|Ride"] = 57.71, ["Neon"] = 20.47, ["Neon|Fly"] = 116.78, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 147, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 364.48}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 25.73, ["Fly"] = 84.03, ["Ride"] = 39.36, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1386.45}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 918.75, ["Ride"] = 985.13, ["Fly|Ride"] = 1312.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7137.17, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.34, ["Fly"] = 35.44, ["Ride"] = 23.63, ["Fly|Ride"] = 36.75, ["Neon"] = 452.12, ["Neon|Ride"] = 142.99, ["Neon|Fly|Ride"] = 168.49, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.52, ["Ride"] = 24.94, ["Fly|Ride"] = 74.43, ["Neon"] = 85.32, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 662.17, ["Mega|Ride"] = 794.83, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 74.8, ["Fly"] = 157.49, ["Ride"] = 85.31, ["Fly|Ride"] = 123.12, ["Neon|Ride"] = 540.87, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1698.97}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 242.82, ["Fly|Ride"] = 336.08, ["Neon|Ride"] = 1620.47, ["Neon|Fly|Ride"] = 1000.13, ["Mega|Fly|Ride"] = 4608.05}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.64, ["Ride"] = 32.79, ["Fly|Ride"] = 93.19, ["Neon"] = 21, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 95.32, ["Mega"] = 145.83, ["Mega|Fly"] = 226.4, ["Mega|Ride"] = 191.23, ["Mega|Fly|Ride"] = 285.7}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.49, ["Ride"] = 195.57, ["Fly|Ride"] = 288.74, ["Neon"] = 763.23, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 937.73, ["Mega|Fly|Ride"] = 3485}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 42.02, ["Ride"] = 13.13, ["Fly|Ride"] = 54.63, ["Neon"] = 17.43, ["Neon|Fly"] = 126.04, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 220.89, ["Fly"] = 279.96, ["Ride"] = 223.13, ["Fly|Ride"] = 231.55, ["Neon|Fly|Ride"] = 844.71, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 7745.61}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.74, ["Fly"] = 73.62, ["Ride"] = 27.33, ["Fly|Ride"] = 68.25, ["Neon"] = 69.18, ["Neon|Fly"] = 302.65, ["Neon|Ride"] = 155.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 489.47, ["Mega|Ride"] = 630.21, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 23.54, ["Neon"] = 12.24, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 70.07, ["Mega|Ride"] = 115.02, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.52, ["Mega"] = 18.38, ["Mega|Ride"] = 151.26}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 33.34, ["Fly|Ride"] = 108.19, ["Neon"] = 7.77, ["Neon|Ride"] = 33.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 70.96, ["Mega|Fly"] = 158884.94, ["Mega|Ride"] = 97.85, ["Mega|Fly|Ride"] = 211.68}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 75.48, ["Fly"] = 525, ["Ride"] = 105, ["Fly|Ride"] = 124.69, ["Neon"] = 249.27, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 361.23, ["Mega|Fly|Ride"] = 1196.6}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.57, ["Ride"] = 15.74, ["Fly|Ride"] = 111.34, ["Neon"] = 8.69, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.02, ["Mega|Ride"] = 165.38}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.14, ["Neon"] = 78.61, ["Neon|Ride"] = 259.88, ["Mega"] = 366.73, ["Mega|Ride"] = 378.14}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.35, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 14.43, ["Mega|Fly"] = 140.76, ["Mega|Ride"] = 54.09, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 61.13, ["Ride"] = 15.77, ["Fly|Ride"] = 42.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 28.79, ["Mega"] = 15.75, ["Mega|Fly"] = 37.83, ["Mega|Ride"] = 19.06, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 17.88, ["Ride"] = 12.71, ["Fly|Ride"] = 62.84, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 39.24, ["Mega"] = 140.76, ["Mega|Fly"] = 159.69, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 77.87}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 63.67, ["Mega"] = 65.63, ["Mega|Ride"] = 121.85}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 15.75, ["Fly|Ride"] = 107.62, ["Neon"] = 3.75, ["Neon|Fly"] = 167.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 24.09, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 420.15, ["Mega"] = 17.29, ["Mega|Fly"] = 95.34, ["Mega|Ride"] = 794.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.15, ["Fly"] = 77.44, ["Ride"] = 32.76, ["Fly|Ride"] = 143.07, ["Neon"] = 12.86, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 32.34, ["Neon|Fly|Ride"] = 119.05, ["Mega"] = 115.5, ["Mega|Fly"] = 287.81, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 196.53}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 76.99, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 14.9, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 61.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 18.38, ["Mega"] = 162.75, ["Mega|Fly"] = 315, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 544.08}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.7, ["Mega"] = 52.5, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.62, ["Neon|Ride"] = 40.52, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 19.14, ["Mega|Ride"] = 42.95, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.87, ["Fly|Ride"] = 56.73, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 11.69, ["Neon|Fly|Ride"] = 32.12, ["Mega"] = 14.44, ["Mega|Fly"] = 60.78, ["Mega|Ride"] = 20.3, ["Mega|Fly|Ride"] = 81.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Fly|Ride"] = 118.11, ["Neon"] = 37.41, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 25.66, ["Neon"] = 3.15, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 22.32, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 172.27}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.14, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 94.5, ["Mega|Ride"] = 168.07, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.53, ["Fly|Ride"] = 191.16, ["Neon"] = 65.63, ["Neon|Ride"] = 49.38, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.29, ["Ride"] = 11.12, ["Fly|Ride"] = 26.3, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 14.13, ["Neon|Fly|Ride"] = 30.48, ["Mega"] = 14.44, ["Mega|Fly"] = 37.83, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 52.14}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 11.8, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 128.63, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 22.93, ["Fly|Ride"] = 59.06, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.25, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 476.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.23, ["Ride"] = 13.01, ["Fly|Ride"] = 43.29, ["Neon"] = 2.5, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.06, ["Neon|Fly|Ride"] = 56.73, ["Mega"] = 21, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 175.4, ["Ride"] = 29.03, ["Neon"] = 7.88, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 167.02, ["Mega"] = 65.63, ["Mega|Fly"] = 168.07, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 4.51, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 39.38, ["Mega|Fly"] = 140.76, ["Mega|Ride"] = 140.3, ["Mega|Fly|Ride"] = 309.87}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 18.37, ["Neon"] = 2.1, ["Neon|Fly"] = 42.02, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 13.11, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 189.49}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.39, ["Ride"] = 23.63, ["Fly|Ride"] = 42.02, ["Neon"] = 11.57, ["Neon|Fly"] = 28.38, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 137.61, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 53.81, ["Fly|Ride"] = 45.94, ["Neon"] = 5.81, ["Neon|Ride"] = 62.06, ["Mega"] = 35.02, ["Mega|Ride"] = 104.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.13, ["Ride"] = 15.07, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 35.77, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 103.69, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.45, ["Ride"] = 36.26, ["Neon"] = 42, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 19.77, ["Fly|Ride"] = 57.48, ["Neon"] = 8.6, ["Neon|Fly"] = 56.73, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.66, ["Ride"] = 16.96, ["Fly|Ride"] = 49.38, ["Neon"] = 15.75, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 47.67, ["Neon|Fly|Ride"] = 72.19, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Neon"] = 71.31, ["Mega"] = 229.21, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.6, ["Ride"] = 56.44, ["Neon"] = 216.2, ["Neon|Ride"] = 238.3, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 27.78, ["Neon"] = 42, ["Neon|Ride"] = 126, ["Mega"] = 238.88, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.41, ["Ride"] = 30.97, ["Fly|Ride"] = 120.75, ["Neon"] = 49.9, ["Neon|Ride"] = 93.91, ["Mega"] = 476.67, ["Mega|Ride"] = 315.12, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.01, ["Mega"] = 30.97, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.46}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 20.37, ["Fly|Ride"] = 40.73, ["Neon"] = 53.63, ["Neon|Ride"] = 41.69, ["Neon|Fly|Ride"] = 78.63, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 296.73}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 94.54, ["Ride"] = 12.9, ["Neon"] = 3.56, ["Neon|Fly"] = 32.19, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 157.32, ["Mega"] = 24.93, ["Mega|Fly"] = 140.76, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 48.33, ["Neon"] = 6.46, ["Neon|Ride"] = 33.1, ["Mega"] = 38.3, ["Mega|Ride"] = 73.39, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 49.38, ["Ride"] = 12.62, ["Fly|Ride"] = 55.65, ["Neon"] = 5.25, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 122.27, ["Mega"] = 141.75, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 172.27}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 8.34, ["Ride"] = 36.75, ["Fly|Ride"] = 57.75, ["Neon"] = 35.04, ["Neon|Ride"] = 131.06, ["Mega"] = 420.15, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 324.14}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.2, ["Mega"] = 20.98, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.4, ["Mega|Fly|Ride"] = 336.12}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 16.49, ["Fly|Ride"] = 32.71, ["Neon"] = 2.86, ["Neon|Fly"] = 111.34, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 31.69, ["Mega|Ride"] = 38.68, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 15.6, ["Fly|Ride"] = 42, ["Neon"] = 3.94, ["Neon|Fly"] = 91.75, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 56.74, ["Mega|Fly"] = 140.76, ["Mega|Ride"] = 112.41, ["Mega|Fly|Ride"] = 159.69}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 52.38, ["Fly|Ride"] = 131.25, ["Neon"] = 3.29, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 112.41, ["Mega"] = 32.36, ["Mega|Ride"] = 80.77, ["Mega|Fly|Ride"] = 220.64}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 168.05, ["Neon|Fly|Ride"] = 153480.9, ["Mega"] = 18.79, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 84.04}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 1.79, ["Fly"] = 45.88, ["Ride"] = 16.97, ["Fly|Ride"] = 78.89, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.2, ["Mega|Ride"] = 41.41, ["Mega|Fly|Ride"] = 98.46}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 1.79, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 36.74, ["Mega|Ride"] = 414.65, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 2.1, ["Neon|Ride"] = 318.12, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.94, ["Mega|Ride"] = 153.62}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.65, ["Fly|Ride"] = 56.73, ["Neon"] = 3.81, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 32.71, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 63}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.57, ["Ride"] = 77.96, ["Neon"] = 125.99, ["Mega"] = 435.75, ["Mega|Ride"] = 3178.1}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 42}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.5, ["Fly|Ride"] = 178.55, ["Mega"] = 397.95, ["Mega|Ride"] = 406.49, ["Mega|Fly|Ride"] = 375.27}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.97, ["Ride"] = 15.65, ["Fly|Ride"] = 25.3, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 25.8, ["Mega"] = 12.97, ["Mega|Fly"] = 22.8, ["Mega|Ride"] = 20.51, ["Mega|Fly|Ride"] = 40.64}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 5.2, ["Neon|Fly"] = 67.24, ["Neon|Ride"] = 32.58, ["Neon|Fly|Ride"] = 700.59, ["Mega"] = 72.19, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 31.53, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.43, ["Mega|Fly"] = 125.01, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 133.41}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 24.06, ["Mega|Fly|Ride"] = 168.07}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 16.89, ["Fly|Ride"] = 32.82, ["Neon"] = 11.03, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 183.75, ["Mega|Ride"] = 399.14, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 178.26, ["Ride"] = 211.21, ["Fly|Ride"] = 840.17, ["Neon|Fly|Ride"] = 944.26, ["Mega"] = 8402.63, ["Mega|Fly|Ride"] = 3974.11}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.05, ["Neon|Ride"] = 64.32, ["Mega"] = 78.09, ["Mega|Ride"] = 171.22, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.43, ["Fly"] = 64.97, ["Ride"] = 26.22, ["Fly|Ride"] = 57.88, ["Neon"] = 31.28, ["Neon|Ride"] = 95.33, ["Neon|Fly|Ride"] = 168.05, ["Mega"] = 374.07, ["Mega|Ride"] = 420.97, ["Mega|Fly|Ride"] = 419.1}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.55, ["Fly|Ride"] = 32.79, ["Neon"] = 3.84, ["Neon|Fly"] = 28.38, ["Neon|Ride"] = 29.46, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.88, ["Mega|Ride"] = 92.45, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.39, ["Ride"] = 19.69, ["Fly|Ride"] = 92.57, ["Neon"] = 6.46, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 190.67}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.29, ["Fly"] = 23.49, ["Ride"] = 15.01, ["Fly|Ride"] = 36, ["Neon"] = 30.53, ["Neon|Fly"] = 98.74, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 74.83, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 34.32, ["Fly|Ride"] = 252.07, ["Neon"] = 79.24, ["Neon|Ride"] = 71.44, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 420.15, ["Mega|Ride"] = 394.17, ["Mega|Fly|Ride"] = 1050.34}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 15.06, ["Fly|Ride"] = 35.36, ["Neon"] = 19.85, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 69.66, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 61.58, ["Fly"] = 121.84, ["Ride"] = 86.06, ["Fly|Ride"] = 131.22, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1589.65}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.57, ["Fly"] = 336.08, ["Ride"] = 249.38, ["Fly|Ride"] = 315, ["Neon|Ride"] = 2625.51, ["Neon|Fly|Ride"] = 906.46, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 4856.73}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.55, ["Fly"] = 140.75, ["Ride"] = 68.69, ["Fly|Ride"] = 99.2, ["Neon"] = 495.71, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 365.91, ["Mega|Fly|Ride"] = 1742.5}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.52, ["Fly"] = 287.88, ["Ride"] = 23.63, ["Fly|Ride"] = 137.67, ["Neon"] = 26.93, ["Neon|Fly"] = 84.03, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 309.72, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 6.4, ["Fly"] = 70.39, ["Ride"] = 20.35, ["Fly|Ride"] = 62.13, ["Neon"] = 81.38, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 353.07, ["Mega|Ride"] = 390.16, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 17.89, ["Fly|Ride"] = 44.51, ["Neon"] = 4.22, ["Neon|Fly"] = 27.42, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 51.76, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.25, ["Fly"] = 72.12, ["Ride"] = 20.89, ["Fly|Ride"] = 81.38, ["Neon"] = 124.04, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 173.38, ["Mega"] = 413.44, ["Mega|Ride"] = 1018.5, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 12.85, ["Fly|Ride"] = 32.81, ["Neon"] = 11.81, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 149.63, ["Mega|Ride"] = 220.59, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.19, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 35.73, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.68}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.63, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15, ["Mega|Ride"] = 51.49, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 18.27, ["Fly|Ride"] = 42.02, ["Neon"] = 15.75, ["Neon|Fly"] = 105.04, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 108.94, ["Mega|Fly|Ride"] = 159.69}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.53, ["Neon"] = 26.25, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 115.5, ["Fly"] = 154.34, ["Ride"] = 140.81, ["Fly|Ride"] = 216.57, ["Neon"] = 678.44, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 632.63, ["Mega"] = 4201.33, ["Mega|Ride"] = 2730.87, ["Mega|Fly|Ride"] = 2035.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.36, ["Ride"] = 32.58, ["Fly|Ride"] = 210.06, ["Neon"] = 42, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 420.15, ["Mega|Ride"] = 399.14, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.43, ["Fly|Ride"] = 36.01, ["Neon"] = 19.69, ["Neon|Ride"] = 28.08, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 238.34, ["Mega|Ride"] = 260.49, ["Mega|Fly|Ride"] = 318.19}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.69, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 177.19, ["Neon|Fly|Ride"] = 596.7, ["Mega"] = 654.15, ["Mega|Fly"] = 840.28, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.25, ["Fly|Ride"] = 114.35, ["Neon"] = 40.52, ["Neon|Fly|Ride"] = 350.82, ["Mega"] = 233.63, ["Mega|Ride"] = 566.31, ["Mega|Fly|Ride"] = 874.68}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.49, ["Fly"] = 26.2, ["Ride"] = 30.54, ["Fly|Ride"] = 49.23, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 2100.68, ["Mega|Fly|Ride"] = 893.85}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.27, ["Fly|Ride"] = 69.34, ["Neon"] = 3.71, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 106.28, ["Mega"] = 28.28, ["Mega|Fly"] = 280.45, ["Mega|Ride"] = 57.66}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 8.42, ["Fly"] = 28.38, ["Ride"] = 25.23, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Ride"] = 238.3, ["Mega"] = 270.52, ["Mega|Fly"] = 398.03, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.83, ["Fly|Ride"] = 46.6, ["Neon"] = 16.8, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 175.43, ["Mega|Ride"] = 182.23, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.43, ["Neon"] = 3.94, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 27.56, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 188.03}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.77, ["Ride"] = 55.13, ["Fly|Ride"] = 142.99, ["Neon"] = 280.53, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 1018.86, ["Mega|Fly|Ride"] = 965.92}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.15, ["Ride"] = 15.75, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 36.78, ["Ride"] = 21.02, ["Fly|Ride"] = 52.53, ["Neon"] = 18.53, ["Neon|Fly"] = 315, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 194.24, ["Mega|Ride"] = 255.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.04, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 328.13, ["Neon|Ride"] = 546.11, ["Mega"] = 4450.76, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2100.68}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 4.66, ["Fly"] = 44.52, ["Ride"] = 19.69, ["Fly|Ride"] = 57.64, ["Neon"] = 46.03, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 47.67, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 551.25, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.42, ["Fly"] = 168.05, ["Ride"] = 104.99, ["Fly|Ride"] = 150.93, ["Neon"] = 271.69, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 2065.11, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1059.17}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 14.34, ["Ride"] = 53.99, ["Fly|Ride"] = 140.75, ["Neon"] = 71.47, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 265.71, ["Mega"] = 417.1, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.94, ["Fly"] = 40.94, ["Ride"] = 28.38, ["Fly|Ride"] = 63.03, ["Neon"] = 49.7, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 378.96, ["Mega"] = 210.08, ["Mega|Ride"] = 1575.51, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 12.98, ["Ride"] = 60.93, ["Fly|Ride"] = 162.54, ["Neon"] = 66.99, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 299.57, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.88, ["Ride"] = 24.81, ["Fly|Ride"] = 88.23, ["Neon"] = 42.02, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 189.06, ["Mega"] = 236.25, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 1.79, ["Neon"] = 2.1, ["Neon|Ride"] = 91.69, ["Mega"] = 26.24, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 22.59, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 199.6, ["Mega|Ride"] = 279.7, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.99, ["Neon"] = 27.3, ["Mega"] = 190.67, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.81, ["Ride"] = 32.81, ["Fly|Ride"] = 119.16, ["Neon"] = 31.53, ["Neon|Ride"] = 78.79, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 560.26, ["Ride"] = 616.88, ["Fly|Ride"] = 656.25, ["Neon"] = 1821.06, ["Neon|Ride"] = 2100.4, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.25, ["Fly"] = 28.38, ["Ride"] = 19.2, ["Fly|Ride"] = 56.34, ["Neon"] = 40.97, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 159.69, ["Mega|Ride"] = 365.85, ["Mega|Fly|Ride"] = 504.17}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.03, ["Fly"] = 524.69, ["Ride"] = 31.12, ["Fly|Ride"] = 51.55, ["Neon"] = 74.59, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 159.69, ["Mega"] = 331.86, ["Mega|Ride"] = 396.46, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 26.98, ["Fly|Ride"] = 315.07, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 159.69}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 21.86, ["Fly|Ride"] = 90.57, ["Neon"] = 7.56, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 86.91, ["Mega"] = 64.32, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.39, ["Ride"] = 17.07, ["Neon"] = 2.63, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 126.06, ["Mega"] = 21, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.07}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.55, ["Ride"] = 49.38, ["Fly|Ride"] = 327.68, ["Neon"] = 65.63, ["Neon|Ride"] = 91.75, ["Mega"] = 560.89, ["Mega|Ride"] = 572, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.11, ["Neon"] = 5.11, ["Neon|Ride"] = 56.44, ["Mega"] = 39.38, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 270.52}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 385.81, ["Ride"] = 126.86, ["Neon"] = 22.96, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1050.34}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.99, ["Ride"] = 502.47, ["Fly|Ride"] = 543.47, ["Neon|Ride"] = 2030.48, ["Neon|Fly|Ride"] = 2102.05, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.29, ["Fly"] = 196.88, ["Ride"] = 56.73, ["Fly|Ride"] = 420.1, ["Neon"] = 36.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 190.67, ["Mega"] = 524.12, ["Mega|Ride"] = 476.67, ["Mega|Fly|Ride"] = 699.5}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 1.79, ["Fly"] = 90.33, ["Ride"] = 22.04, ["Fly|Ride"] = 118.13, ["Neon"] = 3.83, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 36.65, ["Mega|Fly"] = 120.81, ["Mega|Ride"] = 71.67, ["Mega|Fly|Ride"] = 278.85}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.38, ["Mega"] = 32.82, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.18, ["Fly"] = 107.9, ["Ride"] = 109.24, ["Neon"] = 127.88, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 622.91, ["Mega|Ride"] = 638.63, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.95, ["Neon"] = 80.22, ["Neon|Ride"] = 159.67, ["Neon|Fly|Ride"] = 537.45, ["Mega"] = 579.79, ["Mega|Ride"] = 478.42}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.84, ["Ride"] = 31.38, ["Neon"] = 131.25, ["Neon|Ride"] = 179.92, ["Mega"] = 651.84, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.46, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 616.88, ["Mega|Ride"] = 649.04, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Fly|Ride"] = 767.3, ["Neon"] = 1115.63, ["Neon|Ride"] = 1191.45, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 78.74, ["Ride"] = 20.79, ["Fly|Ride"] = 236.25, ["Neon"] = 144.04, ["Neon|Ride"] = 159.86, ["Neon|Fly|Ride"] = 193.86, ["Mega"] = 840.28, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 725.79}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 62.39, ["Neon|Ride"] = 105, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 1050.34}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.79, ["Ride"] = 96.03, ["Neon"] = 78.75, ["Neon|Ride"] = 147.98, ["Neon|Fly|Ride"] = 374.13, ["Mega"] = 285.48, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 393.49}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly|Ride"] = 140.75, ["Neon"] = 7.27, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 271, ["Mega"] = 53.82, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 228.37}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.42, ["Ride"] = 77.05, ["Neon"] = 315, ["Neon|Ride"] = 419.05, ["Neon|Fly|Ride"] = 463.2, ["Mega"] = 2520.8, ["Mega|Ride"] = 2781.28, ["Mega|Fly|Ride"] = 1152.35}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 10.5, ["Neon|Fly"] = 182.76, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 132.29, ["Mega"] = 72.19, ["Mega|Ride"] = 99.64, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 28.55, ["Neon"] = 6.57, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 46.18, ["Neon|Fly|Ride"] = 98.74, ["Mega"] = 32.45, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 75.48, ["Mega|Fly|Ride"] = 170.46}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 126.3, ["Neon"] = 6.57, ["Neon|Ride"] = 60.93, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 112.03, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.9, ["Fly"] = 95.31, ["Ride"] = 60.25, ["Fly|Ride"] = 169.32, ["Neon"] = 268.29, ["Neon|Ride"] = 306.48, ["Neon|Fly|Ride"] = 476.67, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 260.47, ["Ride"] = 309.75, ["Fly|Ride"] = 419.05, ["Neon"] = 1459.79, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1504.09, ["Mega"] = 12603.94, ["Mega|Fly|Ride"] = 4416.57}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.1, ["Neon"] = 27.28, ["Neon|Fly"] = 350.44, ["Mega"] = 108.94}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.23, ["Neon"] = 8.33, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 159.66, ["Ride"] = 27.57, ["Fly|Ride"] = 95.82, ["Neon"] = 32.82, ["Mega"] = 210.08, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 70.71, ["Ride"] = 36.01, ["Fly|Ride"] = 373.89, ["Neon"] = 15.74, ["Neon|Ride"] = 60.93, ["Neon|Fly|Ride"] = 155.45, ["Mega"] = 78.66, ["Mega|Fly|Ride"] = 257.41}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 192.22, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 347.67}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 1.79, ["Fly"] = 28.38, ["Ride"] = 18.38, ["Fly|Ride"] = 51.19, ["Neon"] = 2.99, ["Neon|Fly"] = 79.84, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 420.15, ["Mega"] = 41.26, ["Mega|Ride"] = 102.43, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.89, ["Fly|Ride"] = 28.38, ["Neon"] = 13.13, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 95.34, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.75, ["Fly"] = 52.5, ["Ride"] = 31.37, ["Fly|Ride"] = 78.73, ["Neon|Fly|Ride"] = 318.19, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.14}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63.67, ["Ride"] = 78.75, ["Fly|Ride"] = 129.65, ["Neon"] = 518.44, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3178.1, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 3.92, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 37.92, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14, ["Ride"] = 14.02, ["Fly|Ride"] = 21.02, ["Neon"] = 5.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 51.26, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 73.5, ["Neon"] = 36.39, ["Neon|Ride"] = 159.67, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 704.78, ["Mega|Fly|Ride"] = 636.35}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1906.31, ["Mega|Fly|Ride"] = 7944.62}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.17, ["Fly"] = 101.33, ["Ride"] = 47.09, ["Fly|Ride"] = 84.73, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.8, ["Mega|Ride"] = 1260.41}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21.2, ["Fly|Ride"] = 281.31, ["Neon"] = 8.56, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 170.17, ["Mega"] = 84.68, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 264}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.9, ["Neon|Ride"] = 72.34}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.71, ["Fly"] = 169.3, ["Ride"] = 54.57, ["Fly|Ride"] = 52.49, ["Neon"] = 194.25, ["Neon|Ride"] = 357.08, ["Neon|Fly|Ride"] = 318.19, ["Mega"] = 2520.8, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 76.38, ["Fly"] = 91.77, ["Ride"] = 110.04, ["Fly|Ride"] = 210.06, ["Neon"] = 434.43, ["Neon|Ride"] = 558.72, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8402.63, ["Mega|Fly|Ride"] = 6301.98}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 190.32, ["Ride"] = 269.16, ["Fly|Ride"] = 504.1, ["Neon"] = 1050, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 6.17, ["Fly"] = 56.73, ["Ride"] = 33.77, ["Fly|Ride"] = 96.17, ["Neon"] = 77.97, ["Neon|Ride"] = 118.13, ["Mega"] = 388.49, ["Mega|Ride"] = 419.57, ["Mega|Fly|Ride"] = 520.04}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 12.62, ["Fly|Ride"] = 28.38, ["Neon"] = 11.82, ["Neon|Ride"] = 21.98, ["Neon|Fly|Ride"] = 91.4, ["Mega"] = 42, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.43}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.11, ["Ride"] = 16.03, ["Fly|Ride"] = 62.91, ["Neon"] = 30.45, ["Neon|Fly"] = 105, ["Neon|Ride"] = 35.85, ["Neon|Fly|Ride"] = 72.77, ["Mega"] = 381.09, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 311.28, ["Fly"] = 490.46, ["Ride"] = 379.47, ["Fly|Ride"] = 665.84, ["Neon"] = 1575, ["Neon|Ride"] = 2150.36, ["Mega"] = 10083.15, ["Mega|Fly|Ride"] = 5811.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.62, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 35.44, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Fly"] = 21.46, ["Ride"] = 15.65, ["Fly|Ride"] = 55.13, ["Neon"] = 25.89, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 231.38, ["Mega|Ride"] = 194.35, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.37, ["Ride"] = 69.8, ["Neon"] = 192.18, ["Neon|Ride"] = 236.25, ["Mega"] = 590.63, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 572.36}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.78, ["Fly"] = 157.5, ["Ride"] = 99.43, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 709.95, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.44, ["Fly"] = 43.19, ["Ride"] = 23.14, ["Fly|Ride"] = 57.68, ["Neon"] = 105.04, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 157.1, ["Mega"] = 700.59, ["Mega|Ride"] = 471.19, ["Mega|Fly|Ride"] = 727.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 1.79, ["Ride"] = 21.02, ["Neon"] = 2.1, ["Neon|Ride"] = 140.75, ["Mega"] = 24.93, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 15.77, ["Fly|Ride"] = 70.39, ["Neon"] = 3.94, ["Neon|Fly"] = 159.67, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 27.2, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 56.84, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.92, ["Ride"] = 52.42, ["Fly|Ride"] = 137.54, ["Neon"] = 28.88, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 81.77, ["Neon|Fly|Ride"] = 181.9, ["Mega"] = 168.42, ["Mega|Fly"] = 315.12, ["Mega|Ride"] = 204.54, ["Mega|Fly|Ride"] = 308.23}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1644.07, ["Ride"] = 1443.73, ["Fly|Ride"] = 1312.5, ["Neon|Ride"] = 3976.88, ["Neon|Fly|Ride"] = 3976.88, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.15, ["Ride"] = 503.24, ["Fly|Ride"] = 633.23, ["Neon"] = 2465.88, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 16805.24}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 309.39, ["Ride"] = 341.25, ["Fly|Ride"] = 420, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 248.07, ["Ride"] = 305.33, ["Fly|Ride"] = 436.24, ["Neon"] = 777, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1049.99}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.64, ["Fly|Ride"] = 37.3, ["Neon"] = 7.88, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.57, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 314.9, ["Fly"] = 1400.98, ["Ride"] = 361.59, ["Fly|Ride"] = 544.23, ["Neon"] = 1706.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1959.68, ["Mega|Ride"] = 6722.12, ["Mega|Fly|Ride"] = 4264.32}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.5, ["Fly"] = 183.75, ["Ride"] = 40.97, ["Neon"] = 17.54, ["Neon|Ride"] = 207.34, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.36, ["Mega|Ride"] = 314.9, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 14.2, ["Fly|Ride"] = 31.98, ["Neon"] = 11.81, ["Neon|Ride"] = 63.03, ["Neon|Fly|Ride"] = 112.41, ["Mega"] = 105, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 151.26}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 55.47, ["Neon"] = 2.49, ["Neon|Ride"] = 39.36, ["Mega"] = 40.53, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.63, ["Ride"] = 55.49, ["Fly|Ride"] = 459.37, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 25.73, ["Fly|Ride"] = 67.56, ["Neon"] = 72.77, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 433.77, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.55, ["Neon|Ride"] = 41.57, ["Neon|Fly|Ride"] = 97.82, ["Mega"] = 26.25, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 161.77}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 18.34, ["Fly|Ride"] = 78.65, ["Neon"] = 12.53, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 76.44, ["Mega"] = 129.62, ["Mega|Fly"] = 476.67, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 155.45, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.19, ["Ride"] = 62.98, ["Neon"] = 115.5, ["Mega"] = 517.18, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.19, ["Fly"] = 6354.66, ["Ride"] = 19.69, ["Neon"] = 63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 714.99, ["Mega"] = 301.88, ["Mega|Ride"] = 490.52, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.37, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.25, ["Neon|Fly"] = 31.53, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 315.12}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 155.97, ["Ride"] = 164.07, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 903.18, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 8402.63, ["Mega|Ride"] = 4201.33, ["Mega|Fly|Ride"] = 3475.5}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.42, ["Fly|Ride"] = 28.61, ["Neon"] = 2.1, ["Neon|Fly"] = 52.53, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 56.36, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 4.03, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 135.84, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 794.83, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 20.79, ["Fly"] = 262.5, ["Ride"] = 280.42, ["Fly|Ride"] = 170.63, ["Neon"] = 210.06, ["Neon|Ride"] = 270.21, ["Mega"] = 981.02, ["Mega|Ride"] = 688.26, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 163.23, ["Fly"] = 357.41, ["Ride"] = 229.69, ["Fly|Ride"] = 558.72, ["Neon"] = 761.25, ["Neon|Ride"] = 794.7, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3389.43}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.25, ["Ride"] = 158.3, ["Fly|Ride"] = 140.75, ["Neon"] = 159.67, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.57, ["Ride"] = 210, ["Fly|Ride"] = 182.76, ["Neon"] = 149.15, ["Neon|Fly"] = 159.67, ["Neon|Ride"] = 199, ["Mega"] = 794.83, ["Mega|Ride"] = 840.28}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1036.88, ["Fly"] = 1050, ["Ride"] = 1049.99, ["Fly|Ride"] = 1271.18, ["Neon"] = 4901.29, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4691.26, ["Mega|Fly|Ride"] = 19956.23}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.89, ["Fly"] = 19.68, ["Ride"] = 19.8, ["Fly|Ride"] = 43.32, ["Neon"] = 70.88, ["Neon|Fly"] = 109.33, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 222.86, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 35.6, ["Neon|Ride"] = 119.16, ["Mega"] = 228.99, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 264.13}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.98, ["Ride"] = 26.36, ["Fly|Ride"] = 94.54, ["Neon"] = 11.48, ["Neon|Ride"] = 26.25, ["Mega"] = 199.66, ["Mega|Ride"] = 240.62}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.07, ["Ride"] = 32.11, ["Fly|Ride"] = 82.99, ["Neon"] = 77.42, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 196.26, ["Mega"] = 437.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 20.45, ["Ride"] = 28.38, ["Fly|Ride"] = 51.19, ["Neon"] = 26.25, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 33.63, ["Neon|Fly|Ride"] = 98.9, ["Mega|Fly"] = 252.1, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.77, ["Neon"] = 10, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 182.78, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 419.1}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 231.17, ["Fly|Ride"] = 2100.4, ["Neon|Fly|Ride"] = 1401.16}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.8, ["Fly|Ride"] = 72.19, ["Neon"] = 6.27, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 158.62, ["Mega"] = 280.45, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 127.36, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.19, ["Ride"] = 82.02, ["Fly|Ride"] = 88.87, ["Neon"] = 140.75, ["Neon|Ride"] = 252.07, ["Mega"] = 140.76, ["Mega|Ride"] = 238.34}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.04, ["Fly"] = 98.42, ["Ride"] = 21, ["Neon"] = 21.02, ["Neon|Ride"] = 52.5, ["Mega"] = 99.75, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 510.03}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 259.77, ["Fly|Ride"] = 560.82, ["Neon|Ride"] = 656.25, ["Mega|Ride"] = 4201.33, ["Mega|Fly|Ride"] = 2661.54}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.02, ["Fly"] = 118.97, ["Ride"] = 70.39, ["Fly|Ride"] = 224.76, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 564.38, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.08, ["Fly"] = 318.1, ["Ride"] = 31.28, ["Fly|Ride"] = 90.57, ["Neon"] = 96.67, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 589.87, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.74, ["Neon"] = 6.09, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.1, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 44.58, ["Fly"] = 89.15, ["Ride"] = 98.44, ["Fly|Ride"] = 149.2, ["Neon"] = 294.07, ["Neon|Fly"] = 272.43, ["Neon|Ride"] = 269.05, ["Neon|Fly|Ride"] = 298.83, ["Mega|Fly|Ride"] = 1191.08}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 35.36, ["Neon"] = 5, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 59.89}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.64, ["Fly"] = 127.49, ["Ride"] = 19.78, ["Fly|Ride"] = 85.8, ["Neon"] = 66.2, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 636.35}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.78, ["Fly"] = 65.63, ["Ride"] = 94.07, ["Fly|Ride"] = 149.57, ["Neon"] = 183.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 674.33, ["Mega|Ride"] = 1962.02, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.62, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.18, ["Neon|Ride"] = 16.82, ["Neon|Fly|Ride"] = 32.71, ["Mega"] = 16.95, ["Mega|Fly"] = 119.18, ["Mega|Ride"] = 32.76, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 16.98, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 238.44, ["Mega|Ride"] = 278.85, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.3, ["Ride"] = 56, ["Fly|Ride"] = 85.32, ["Neon"] = 110.25, ["Neon|Ride"] = 560.82, ["Mega"] = 536.82, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.96, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 419.47}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 9.72, ["Fly"] = 191.42, ["Ride"] = 65.55, ["Fly|Ride"] = 172.25, ["Neon"] = 61.13, ["Neon|Ride"] = 172.57, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 534.6, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 470.07, ["Mega|Fly|Ride"] = 714.17}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 6.57, ["Fly"] = 42.02, ["Ride"] = 26.48, ["Fly|Ride"] = 98.44, ["Neon"] = 408.97, ["Neon|Ride"] = 108.7, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.31, ["Neon"] = 39.03, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 71.36, ["Mega"] = 196.88, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.84, ["Fly"] = 72.19, ["Ride"] = 70.88, ["Neon"] = 42.09, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6354.98, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 997.83}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 25.23, ["Fly|Ride"] = 196.88, ["Neon"] = 6.47, ["Neon|Ride"] = 32.43, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 148.32}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 2.71, ["Mega"] = 28.23, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 257.78}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.87}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.2, ["Fly"] = 78.75, ["Ride"] = 39.38, ["Neon"] = 239.46, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1680.54, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 111.34, ["Mega"] = 18.38, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 315.12}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 622.79, ["Fly|Ride"] = 791.06, ["Neon"] = 2096.21, ["Neon|Fly|Ride"] = 2661.22, ["Mega"] = 16805.24, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.94, ["Fly"] = 26.24, ["Ride"] = 25.2, ["Fly|Ride"] = 66.26, ["Neon"] = 32.5, ["Mega"] = 89.51, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 21.27, ["Fly|Ride"] = 69.33, ["Neon"] = 31.53, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 140.76, ["Mega|Ride"] = 159.43, ["Mega|Fly|Ride"] = 237.07}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.23, ["Fly"] = 70.39, ["Ride"] = 50.44, ["Fly|Ride"] = 68.17, ["Neon"] = 99.72, ["Neon|Ride"] = 171.2, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 826.63, ["Mega|Ride"] = 560.89, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Ride"] = 28.38, ["Fly|Ride"] = 721.88, ["Neon"] = 30.48, ["Neon|Ride"] = 118.13, ["Mega"] = 275.63}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.84, ["Fly"] = 140.75, ["Ride"] = 140.75, ["Fly|Ride"] = 173.24, ["Neon"] = 64.56, ["Neon|Ride"] = 236.25, ["Mega"] = 420.15, ["Mega|Ride"] = 557.74, ["Mega|Fly|Ride"] = 490.52}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.03, ["Ride"] = 52.45, ["Fly|Ride"] = 133.88, ["Neon"] = 32.02, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 209.03, ["Mega"] = 560.89, ["Mega|Fly"] = 560.89, ["Mega|Ride"] = 359.89, ["Mega|Fly|Ride"] = 376.87}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.67, ["Ride"] = 13.54, ["Fly|Ride"] = 69.29, ["Neon"] = 2.1, ["Neon|Fly"] = 59.88, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 15.75, ["Mega|Ride"] = 35.4}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.76, ["Fly"] = 53.58, ["Ride"] = 32.71, ["Fly|Ride"] = 105.04, ["Neon"] = 40.46, ["Neon|Fly"] = 119.16, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 224.79, ["Mega"] = 196.84, ["Mega|Ride"] = 259.88}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 311.95, ["Ride"] = 295.77, ["Fly|Ride"] = 421.32, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9247.07, ["Mega|Fly|Ride"] = 5086.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.21, ["Ride"] = 140.75, ["Fly|Ride"] = 280.42, ["Neon"] = 560.82, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 546.18, ["Mega"] = 2241.42, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1645.13}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.62, ["Ride"] = 15.32, ["Fly|Ride"] = 48.33, ["Neon"] = 8.42, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 32.19, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 209.03, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.4, ["Fly|Ride"] = 34.17, ["Neon"] = 7.88, ["Neon|Fly"] = 52.36, ["Neon|Ride"] = 19.83, ["Neon|Fly|Ride"] = 60.95, ["Mega"] = 65.54, ["Mega|Fly"] = 350.82, ["Mega|Ride"] = 108.2, ["Mega|Fly|Ride"] = 233.19}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 52.41, ["Mega"] = 273.1}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.6, ["Fly"] = 420, ["Ride"] = 245.34, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1067.01, ["Neon|Fly|Ride"] = 1554.32, ["Mega|Ride"] = 8402.63, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 34.76, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 111.2, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 419.1}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 94.56, ["Fly|Ride"] = 210.06, ["Neon"] = 70.39, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 299.25, ["Mega|Ride"] = 313.02}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 78.75, ["Neon"] = 5.93, ["Neon|Ride"] = 156.19, ["Mega"] = 86.57, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 8.97, ["Fly"] = 25.99, ["Ride"] = 19.56, ["Fly|Ride"] = 102.6, ["Neon"] = 80.76, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 194.24, ["Mega"] = 616.55, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 794.83}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.66, ["Fly"] = 112.4, ["Ride"] = 90.44, ["Fly|Ride"] = 378.09, ["Neon"] = 171.94, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.29, ["Mega"] = 402.94, ["Mega|Fly"] = 2205.7, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 577.33}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21.9, ["Ride"] = 43.32, ["Fly|Ride"] = 96.49, ["Neon"] = 138.72, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 305.63, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.77, ["Fly|Ride"] = 42.33, ["Neon"] = 2.63, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 17.29, ["Mega|Fly"] = 420.15, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.38, ["Ride"] = 280.88, ["Fly|Ride"] = 840.17, ["Neon"] = 2146.4, ["Neon|Fly|Ride"] = 1255, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.53, ["Fly"] = 101.18, ["Ride"] = 43.32, ["Fly|Ride"] = 105, ["Neon"] = 198.98, ["Neon|Ride"] = 205.86, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 714.99, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 17.68, ["Fly|Ride"] = 45.29, ["Neon"] = 7.76, ["Neon|Fly"] = 36.05, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 111.36, ["Mega"] = 61.99, ["Mega|Fly"] = 280.45, ["Mega|Ride"] = 84.04, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.53, ["Ride"] = 19.8, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 79.84, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 116.05, ["Mega"] = 28.88, ["Mega|Fly"] = 140.76, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 183.83}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 8.77, ["Neon|Fly"] = 714.88, ["Neon|Ride"] = 71.51, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6.83, ["Fly"] = 38.75, ["Ride"] = 23.63, ["Fly|Ride"] = 41.85, ["Neon"] = 47.15, ["Neon|Fly"] = 301.43, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 339.63, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.41, ["Ride"] = 56.22, ["Fly|Ride"] = 72.19, ["Neon"] = 38.19, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 318.19, ["Mega|Fly|Ride"] = 406.49}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 2.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 32.7, ["Mega|Ride"] = 72.08, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.28, ["Ride"] = 27.33, ["Fly|Ride"] = 131.25, ["Neon"] = 31.18, ["Neon|Fly"] = 138.65, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 259.87, ["Mega"] = 234.83, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 270.13}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 78.89, ["Neon"] = 3.39, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 42.03, ["Mega|Ride"] = 102.95, ["Mega|Fly|Ride"] = 136.56}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 41.88, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 4.31, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 121.85, ["Mega"] = 59.49, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.46, ["Ride"] = 651.49, ["Fly|Ride"] = 913.5, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.23, ["Fly|Ride"] = 31.53, ["Neon"] = 18.36, ["Neon|Fly"] = 140.88, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 112.03, ["Mega|Fly|Ride"] = 361.33}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 47.25, ["Neon"] = 9.19, ["Neon|Fly"] = 735.16, ["Neon|Ride"] = 91.39, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 54.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.57, ["Fly"] = 47.67, ["Ride"] = 17.1, ["Fly|Ride"] = 39.92, ["Neon"] = 65.63, ["Neon|Fly"] = 190.65, ["Neon|Ride"] = 54.57, ["Neon|Fly|Ride"] = 97.12, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 14.83, ["Fly|Ride"] = 32.04, ["Neon"] = 8.43, ["Neon|Fly"] = 145.78, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 69.21, ["Mega"] = 65.62, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 175.54}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 37.32, ["Ride"] = 83.16, ["Fly|Ride"] = 280.42, ["Neon"] = 318.12, ["Neon|Ride"] = 280.42}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.36, ["Fly|Ride"] = 64.46, ["Neon"] = 5.25, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 30.74, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 48.39, ["Mega|Ride"] = 119.14, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 126.04, ["Ride"] = 20.27, ["Fly|Ride"] = 65.63, ["Neon"] = 8.93, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 112.41, ["Mega"] = 114.19, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Mega"] = 94.16, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.16, ["Fly|Ride"] = 49.87, ["Neon"] = 3.94, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 44.16, ["Mega|Fly"] = 420.15, ["Mega|Ride"] = 62.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.8, ["Fly"] = 19.58, ["Ride"] = 17.41, ["Fly|Ride"] = 34.11, ["Neon"] = 318.12, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 703.5, ["Ride"] = 833.44, ["Fly|Ride"] = 919.43, ["Neon"] = 1747.41, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 8402.63, ["Mega|Fly|Ride"] = 7625.26}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 1.79, ["Fly"] = 15.57, ["Ride"] = 15.21, ["Fly|Ride"] = 33.9, ["Neon"] = 3.64, ["Neon|Ride"] = 16.87, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 41.99, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.92, ["Ride"] = 36.75, ["Neon"] = 43.3, ["Neon|Fly"] = 71.51, ["Neon|Ride"] = 126.14, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 393.88, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 535.68}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 50.27, ["Ride"] = 59.03, ["Fly|Ride"] = 113.28, ["Neon|Ride"] = 476.59, ["Neon|Fly|Ride"] = 383.72, ["Mega"] = 3221.36, ["Mega|Fly|Ride"] = 2040.94}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 22.32, ["Ride"] = 41.52, ["Fly|Ride"] = 98.75, ["Neon"] = 183.75, ["Neon|Ride"] = 210.06, ["Neon|Fly|Ride"] = 700.59, ["Mega"] = 1962.02, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1018.84}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 7.77, ["Ride"] = 25.72, ["Fly|Ride"] = 140.75, ["Neon"] = 70.39, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 116.61, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.71, ["Ride"] = 56.55, ["Neon"] = 280.42, ["Neon|Ride"] = 365.78, ["Mega"] = 459.38, ["Mega|Fly"] = 517.18, ["Mega|Ride"] = 351.54}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.21, ["Fly|Ride"] = 152.17, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 630.21, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.33}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.94, ["Ride"] = 18.42, ["Fly|Ride"] = 85.32, ["Neon"] = 32.82, ["Neon|Ride"] = 94.54, ["Neon|Fly|Ride"] = 182.78, ["Mega"] = 196.27, ["Mega|Fly"] = 474.76, ["Mega|Ride"] = 167.02, ["Mega|Fly|Ride"] = 289.75}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.56, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Mega"] = 140.76}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 40.58, ["Fly"] = 420.1, ["Ride"] = 38.42, ["Fly|Ride"] = 101.6, ["Neon"] = 262.5, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 953.32, ["Mega|Ride"] = 1680.54}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.25, ["Fly|Ride"] = 38.46, ["Neon"] = 25.43, ["Neon|Fly"] = 95.59, ["Neon|Ride"] = 31.35, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 196.88, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 418.68}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.3, ["Fly"] = 36.78, ["Ride"] = 21.72, ["Fly|Ride"] = 55.7, ["Neon"] = 14.44, ["Neon|Ride"] = 41.06, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 135.83, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 261.29}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Mega"] = 38.74, ["Mega|Ride"] = 196.42}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.55, ["Fly"] = 77.17, ["Ride"] = 52.5, ["Fly|Ride"] = 89.25, ["Neon"] = 945, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 289.91, ["Mega|Ride"] = 14005.07, ["Mega|Fly|Ride"] = 824.09}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 15.77, ["Fly|Ride"] = 65.63, ["Neon"] = 5.93, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.38, ["Mega"] = 74.81, ["Mega|Ride"] = 118.12}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.08, ["Ride"] = 79.84, ["Fly|Ride"] = 279.37, ["Neon"] = 107.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 391.75, ["Mega|Fly|Ride"] = 630.21}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 14.58, ["Fly|Ride"] = 40.63, ["Neon"] = 18.83, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 315.12}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 75.12, ["Neon"] = 31.5, ["Neon|Ride"] = 420.1, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.63, ["Neon"] = 79.54, ["Neon|Ride"] = 227.06, ["Mega"] = 476.67, ["Mega|Ride"] = 953.32}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.19, ["Ride"] = 123.38, ["Neon"] = 216.57, ["Neon|Fly|Ride"] = 866.33, ["Mega"] = 2241.42, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.62, ["Ride"] = 280.42, ["Neon"] = 103.55, ["Neon|Ride"] = 262.5, ["Mega"] = 452.92, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.88, ["Ride"] = 125.97, ["Neon"] = 171.62, ["Neon|Fly"] = 210.06, ["Neon|Ride"] = 420.1, ["Mega|Ride"] = 839.22}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.29, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 735.16, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 604.54, ["Mega|Fly"] = 2100.68, ["Mega|Ride"] = 728.18, ["Mega|Fly|Ride"] = 1112.99}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 21.02, ["Mega"] = 183.75, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 318.19}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 17.89, ["Fly|Ride"] = 40.61, ["Neon"] = 3.4, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 64.37, ["Mega|Ride"] = 79.85, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Ride"] = 44.12, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 68.61, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 105, ["Mega|Ride"] = 132.29, ["Mega|Fly|Ride"] = 262.59}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.44, ["Ride"] = 15.46, ["Fly|Ride"] = 56.73, ["Neon"] = 3.83, ["Neon|Ride"] = 25.61, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 41.36, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 224.03}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 118.13, ["Neon"] = 15.74, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 261.54, ["Mega"] = 328.02, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 476.67}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 140.75, ["Neon"] = 25.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 287.46}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.07, ["Fly|Ride"] = 61.03, ["Neon"] = 17.07, ["Neon|Fly"] = 112.4, ["Neon|Ride"] = 40.52, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 355.03, ["Mega|Ride"] = 286, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 19.69, ["Fly|Ride"] = 51.77, ["Neon"] = 18.52, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 254.15}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 43.29, ["Fly|Ride"] = 87.93, ["Neon"] = 19.68, ["Neon|Fly"] = 437.04, ["Neon|Ride"] = 88.18, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 97.13, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.45, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.69, ["Fly"] = 106.56, ["Ride"] = 99.54, ["Fly|Ride"] = 231.53, ["Neon"] = 110.44, ["Neon|Ride"] = 357.08, ["Neon|Fly|Ride"] = 530.3, ["Mega"] = 519.75, ["Mega|Ride"] = 926.4}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 41.48, ["Fly"] = 164.07, ["Ride"] = 78.8, ["Fly|Ride"] = 490.88, ["Neon"] = 221.8, ["Neon|Ride"] = 318.12, ["Neon|Fly|Ride"] = 490.96, ["Mega"] = 1539.79, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1210.13}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 23.04, ["Fly|Ride"] = 65.63, ["Neon"] = 3.82, ["Neon|Ride"] = 23.73, ["Mega"] = 28.64, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 144.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.4, ["Neon"] = 159.67, ["Mega|Fly|Ride"] = 1030.38}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 54.02, ["Fly"] = 105, ["Ride"] = 78.75, ["Neon"] = 354.38, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 839.22, ["Mega"] = 1721.51}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.72, ["Fly"] = 190.32, ["Ride"] = 35.73, ["Fly|Ride"] = 133.88, ["Neon"] = 36.63, ["Neon|Ride"] = 84.03, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 65.37, ["Fly|Ride"] = 141.75, ["Neon"] = 8.9, ["Neon|Ride"] = 65.63, ["Mega"] = 84, ["Mega|Ride"] = 137.81, ["Mega|Fly|Ride"] = 348.08}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.62, ["Ride"] = 13.13, ["Fly|Ride"] = 39.36, ["Neon"] = 11.42, ["Neon|Ride"] = 42.02, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 236.25, ["Mega|Ride"] = 209.03, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.75, ["Fly|Ride"] = 42.02, ["Neon"] = 2.63, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 57.21, ["Mega"] = 27.42, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 116.95}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.89, ["Fly|Ride"] = 89.93, ["Neon"] = 3.73, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 38.73, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 119.16, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 25.74, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.08, ["Ride"] = 157.5, ["Neon"] = 30.45, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 630.21, ["Mega"] = 318.19, ["Mega|Fly|Ride"] = 318.19}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.89, ["Ride"] = 34.13, ["Fly|Ride"] = 98.74, ["Neon"] = 52.5, ["Neon|Ride"] = 207.33, ["Neon|Fly|Ride"] = 184.88, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 1035.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.66, ["Fly"] = 20.98, ["Ride"] = 18.38, ["Fly|Ride"] = 39.01, ["Neon"] = 41.4, ["Neon|Ride"] = 42.02, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly|Ride"] = 360.39}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 50.19, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 449.5, ["Mega"] = 2383.27, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.49, ["Fly"] = 82.67, ["Ride"] = 31.4, ["Neon"] = 252.07, ["Neon|Fly|Ride"] = 630, ["Mega"] = 636.35, ["Mega|Ride"] = 874.13}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 42.02, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 63.04, ["Mega"] = 32.82, ["Mega|Ride"] = 94.01, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 12.71, ["Fly|Ride"] = 30.12, ["Neon"] = 3.84, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 19.16, ["Neon|Fly|Ride"] = 42.24, ["Mega"] = 42.61, ["Mega|Ride"] = 57.25, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.81, ["Fly"] = 556.38, ["Ride"] = 534.19, ["Fly|Ride"] = 551.24, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.94, ["Ride"] = 56.44, ["Fly|Ride"] = 535.42, ["Neon"] = 31.5, ["Neon|Ride"] = 107.14, ["Mega"] = 364.88, ["Mega|Ride"] = 686.94, ["Mega|Fly|Ride"] = 280087.56}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.58, ["Fly|Ride"] = 27.92, ["Neon"] = 3.94, ["Neon|Fly"] = 23.85, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 38.31, ["Mega"] = 140.76, ["Mega|Ride"] = 74.97, ["Mega|Fly|Ride"] = 105.45}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.88, ["Ride"] = 140.75, ["Fly|Ride"] = 525.12, ["Neon"] = 262.5, ["Neon|Ride"] = 269.61, ["Neon|Fly|Ride"] = 463.2, ["Mega"] = 737.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 878.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.83, ["Ride"] = 12.62, ["Fly|Ride"] = 35.44, ["Neon"] = 14.44, ["Neon|Fly"] = 61.78, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 110.25, ["Mega|Ride"] = 143.03, ["Mega|Fly|Ride"] = 215.19}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.39, ["Ride"] = 56.73, ["Neon"] = 3.15, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 26.25, ["Mega|Ride"] = 55.57, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 37.97, ["Fly"] = 117.27, ["Ride"] = 64.97, ["Fly|Ride"] = 196.4, ["Neon"] = 220.5, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 1112.99}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 23.13, ["Neon"] = 3.19, ["Neon|Ride"] = 40.45, ["Mega"] = 126.06, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 69.45, ["Fly|Ride"] = 142.99, ["Neon"] = 336.08, ["Neon|Ride"] = 322.43, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1659.54, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 1512.49}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Neon"] = 19.67, ["Neon|Ride"] = 47.67, ["Neon|Fly|Ride"] = 490.39, ["Mega"] = 156.19, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 70.58, ["Fly|Ride"] = 70.39, ["Neon"] = 7.3, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 40.21, ["Ride"] = 65.63, ["Fly|Ride"] = 525.12, ["Mega|Ride"] = 2801.24}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 314.74, ["Ride"] = 24.74, ["Fly|Ride"] = 60.15, ["Neon"] = 6.3, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 91.27, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.32, ["Ride"] = 14.91, ["Fly|Ride"] = 101.82, ["Neon"] = 10.9, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.38, ["Fly"] = 58.49, ["Ride"] = 23.78, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 441.16, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.57, ["Fly"] = 57.11, ["Ride"] = 20.85, ["Fly|Ride"] = 59.07, ["Neon"] = 148.32, ["Neon|Ride"] = 98.78, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 354.25, ["Mega|Ride"] = 407.34, ["Mega|Fly|Ride"] = 484.31}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.59, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 64.25, ["Neon"] = 72.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 560.89, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 432.75}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 56, ["Ride"] = 118.13, ["Fly|Ride"] = 249.38, ["Neon"] = 282.99, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1821.28, ["Mega|Fly|Ride"] = 1310.4}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.34, ["Ride"] = 56.05, ["Neon"] = 35.77, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 168.05, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 525.53}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 2.1, ["Ride"] = 26.88, ["Fly|Ride"] = 78.74, ["Neon"] = 25.17, ["Neon|Ride"] = 39.8, ["Neon|Fly|Ride"] = 126.06, ["Mega"] = 262.5, ["Mega|Ride"] = 271}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.91, ["Ride"] = 26.25, ["Fly|Ride"] = 109.83, ["Neon"] = 47.11, ["Neon|Ride"] = 138.65, ["Neon|Fly|Ride"] = 238.34, ["Mega"] = 463.2, ["Mega|Ride"] = 639.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 1.79, ["Fly"] = 15.33, ["Ride"] = 12.58, ["Fly|Ride"] = 30.86, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.31, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.75, ["Mega|Ride"] = 28.17, ["Mega|Fly|Ride"] = 93.83}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 41.91, ["Fly"] = 222.66, ["Ride"] = 104.99, ["Fly|Ride"] = 280.42, ["Neon"] = 408.19, ["Neon|Fly"] = 2380.82, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3150.99, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1271.48}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.79, ["Fly|Ride"] = 35.73, ["Neon"] = 3.94, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 265.75, ["Mega|Ride"] = 136.69, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 16.4, ["Fly|Ride"] = 58.47, ["Neon"] = 42.02, ["Neon|Ride"] = 29.11, ["Mega"] = 257.25, ["Mega|Ride"] = 138.92, ["Mega|Fly|Ride"] = 238.34}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 63.84, ["Fly"] = 157.5, ["Ride"] = 118.13, ["Fly|Ride"] = 258.57, ["Neon"] = 315, ["Neon|Ride"] = 687.9, ["Neon|Fly|Ride"] = 1260.41, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1618.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.13, ["Neon"] = 5.75, ["Neon|Ride"] = 52.5, ["Mega"] = 64.19, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 12.8}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.88, ["Fly|Ride"] = 489.41, ["Neon"] = 4.19, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 155.47, ["Mega"] = 44.5, ["Mega|Ride"] = 114.78, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 107.62, ["Ride"] = 144.01, ["Fly|Ride"] = 285.96, ["Neon"] = 836.07, ["Neon|Ride"] = 699.38, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3361.07, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.19, ["Ride"] = 41.91, ["Fly|Ride"] = 55.13, ["Neon"] = 19.58, ["Neon|Fly"] = 140.75, ["Neon|Ride"] = 64.32, ["Mega"] = 209.9, ["Mega|Ride"] = 202.86, ["Mega|Fly|Ride"] = 636.35}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 42.02, ["Neon"] = 6.57, ["Neon|Ride"] = 20.86, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 140.76}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.57, ["Ride"] = 19.83, ["Neon"] = 49.72, ["Neon|Ride"] = 64.36, ["Neon|Fly|Ride"] = 159.86, ["Mega"] = 490.52, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 675.67}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.54, ["Fly"] = 55.04, ["Ride"] = 21, ["Fly|Ride"] = 55.76, ["Neon"] = 99, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 616.88, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.75, ["Ride"] = 68.69, ["Fly|Ride"] = 126.3, ["Neon"] = 129.65, ["Neon|Ride"] = 168.05, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 784.61, ["Mega|Ride"] = 578.55, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 126.74, ["Fly"] = 280.42, ["Ride"] = 155.27, ["Fly|Ride"] = 210, ["Neon"] = 593.14, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2383.61}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 72.13, ["Ride"] = 85.32, ["Fly|Ride"] = 129.91, ["Neon"] = 471.14, ["Neon|Ride"] = 840.17, ["Neon|Fly|Ride"] = 545.13, ["Mega|Ride"] = 1120.71, ["Mega|Fly|Ride"] = 1120.71}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.69, ["Fly|Ride"] = 131.25, ["Neon"] = 15.75, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.81, ["Mega|Fly|Ride"] = 318.19}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 12.11, ["Fly"] = 98.43, ["Ride"] = 34.16, ["Fly|Ride"] = 180.65, ["Neon"] = 67.38, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 157.57, ["Mega"] = 379.31, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 500.07}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.99, ["Ride"] = 75.51, ["Fly|Ride"] = 224.76, ["Neon"] = 238.88, ["Neon|Ride"] = 278.51, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1112.99, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.32, ["Ride"] = 68.77, ["Neon"] = 131.25, ["Neon|Ride"] = 560.82, ["Neon|Fly|Ride"] = 463.2, ["Mega"] = 686.6, ["Mega|Ride"] = 714.67}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3177.57}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 23.55, ["Fly"] = 56.73, ["Ride"] = 32.79, ["Fly|Ride"] = 98.44, ["Neon"] = 419.05, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 490.52, ["Mega"] = 1218.39, ["Mega|Ride"] = 1000.99, ["Mega|Fly|Ride"] = 1112.99}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.54, ["Ride"] = 12.53, ["Fly|Ride"] = 121.84, ["Neon"] = 2.62, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 41.5, ["Mega"] = 19.24, ["Mega|Fly"] = 102.95, ["Mega|Ride"] = 35.12, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 13.12, ["Neon|Ride"] = 66.87, ["Neon|Fly|Ride"] = 264.69, ["Mega"] = 147.06, ["Mega|Ride"] = 322.46, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 38.57, ["Fly|Ride"] = 144.21, ["Neon"] = 18.38, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 981.02, ["Mega"] = 108.74, ["Mega|Fly"] = 517.18, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 433.13, ["Fly|Ride"] = 525, ["Neon"] = 1522.8, ["Neon|Ride"] = 1540.66, ["Neon|Fly|Ride"] = 1680.33, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 69.45, ["Ride"] = 15.74, ["Fly|Ride"] = 42, ["Neon"] = 32.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.19, ["Mega"] = 159.69, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 630.21}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.29, ["Fly"] = 22.32, ["Ride"] = 17.3, ["Fly|Ride"] = 28.88, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 210.08}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 45.17, ["Ride"] = 15.8, ["Fly|Ride"] = 78.75, ["Neon"] = 10.73, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 57.21, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 155.47, ["Mega|Ride"] = 273.1, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.32, ["Fly"] = 44.77, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 220.29, ["Neon|Ride"] = 174.67, ["Neon|Fly|Ride"] = 314.07, ["Mega"] = 1312.5, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 683.82}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.38, ["Fly|Ride"] = 50.3, ["Neon"] = 11.7, ["Neon|Ride"] = 109.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.73, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.7, ["Fly"] = 64.26, ["Ride"] = 39.92, ["Neon"] = 185.73, ["Neon|Fly"] = 159.67, ["Neon|Ride"] = 141.92, ["Mega"] = 1680.54, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.37, ["Neon"] = 6.17, ["Neon|Ride"] = 35.11, ["Mega"] = 55.13, ["Mega|Ride"] = 112.02, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.9, ["Neon"] = 50.67, ["Mega"] = 318.19}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.16, ["Ride"] = 77.74, ["Neon"] = 78.8, ["Neon|Ride"] = 476.59, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 840.28, ["Mega|Ride"] = 585.11, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.59, ["Fly"] = 27.63, ["Ride"] = 20.6, ["Fly|Ride"] = 45.94, ["Neon"] = 34.53, ["Neon|Fly"] = 69.34, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 590.29, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 344.9}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 333.44, ["Fly"] = 449.5, ["Ride"] = 388.4, ["Fly|Ride"] = 482.99, ["Neon"] = 1659, ["Neon|Ride"] = 1469.25, ["Neon|Fly|Ride"] = 1540.66}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 13.01, ["Neon|Fly"] = 79.84, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 210.08, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.73, ["Ride"] = 44.1, ["Fly|Ride"] = 95.33, ["Neon"] = 45.03, ["Neon|Ride"] = 158.59, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 383.65, ["Mega|Fly"] = 700.59, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 30.14, ["Ride"] = 118.13, ["Fly|Ride"] = 314.99, ["Neon"] = 75.35, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 422.62, ["Mega|Ride"] = 4201.33}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 100.51, ["Fly"] = 169.32, ["Ride"] = 209.19, ["Fly|Ride"] = 232.32, ["Neon|Ride"] = 1470.3, ["Neon|Fly|Ride"] = 925.24, ["Mega|Ride"] = 5551.88, ["Mega|Fly|Ride"] = 7002.54}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.46, ["Ride"] = 119.74, ["Fly|Ride"] = 128.46, ["Neon"] = 95.5, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 400.32, ["Mega|Ride"] = 485.01}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.59, ["Fly|Ride"] = 58.45, ["Neon"] = 12.48, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 65.61, ["Mega|Ride"] = 145.39, ["Mega|Fly|Ride"] = 238.34}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.81, ["Ride"] = 33.98, ["Neon"] = 23, ["Neon|Ride"] = 107.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 169.7, ["Mega|Ride"] = 191.18, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.69, ["Fly"] = 183.74, ["Ride"] = 82.69, ["Fly|Ride"] = 200.84, ["Neon"] = 150.93, ["Neon|Ride"] = 157.36, ["Neon|Fly|Ride"] = 279.55, ["Mega"] = 590.63, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 10.5, ["Neon|Ride"] = 210.06, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 55.54, ["Mega|Fly"] = 115.5, ["Mega|Ride"] = 168.41, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.75, ["Neon"] = 114.6, ["Neon|Ride"] = 490.46, ["Mega"] = 840.28}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 984.37, ["Fly"] = 2100.4, ["Ride"] = 1036.88, ["Fly|Ride"] = 1086.65, ["Neon"] = 3341.76, ["Neon|Ride"] = 3612.71, ["Neon|Fly|Ride"] = 3220.98, ["Mega|Fly|Ride"] = 11203.86}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 12.06, ["Fly"] = 78.28, ["Ride"] = 56.15, ["Fly|Ride"] = 143.16, ["Neon"] = 202.13, ["Neon|Fly"] = 699.45, ["Neon|Ride"] = 210.06, ["Mega"] = 344.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 15.75, ["Fly|Ride"] = 80.89, ["Neon"] = 10.16, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.35, ["Mega"] = 89.15, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 262.59}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 6.02, ["Ride"] = 47.79, ["Fly|Ride"] = 140.75, ["Neon"] = 141.75, ["Mega"] = 787.5, ["Mega|Ride"] = 421.94, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 182.76, ["Neon"] = 2.1, ["Neon|Ride"] = 21.02, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 14.22, ["Mega|Fly"] = 126.06, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 140.76}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 59.68, ["Ride"] = 88.36, ["Fly|Ride"] = 236.25, ["Neon"] = 260.86, ["Neon|Ride"] = 436.09, ["Mega"] = 1378.13, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 1062.87}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.07, ["Ride"] = 62.99, ["Fly|Ride"] = 157.83, ["Neon"] = 69.55, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 263.37, ["Mega"] = 700.59, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 558.79}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.23, ["Neon"] = 13.13, ["Neon|Ride"] = 65.62, ["Mega"] = 157.57, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 11.82, ["Fly"] = 52.5, ["Ride"] = 41.08, ["Fly|Ride"] = 116.33, ["Neon"] = 140.75, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 1039.49, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 2.71, ["Ride"] = 36.75, ["Fly|Ride"] = 68.25, ["Neon"] = 51.19, ["Neon|Ride"] = 210.06, ["Neon|Fly|Ride"] = 165.95, ["Mega"] = 560.89, ["Mega|Ride"] = 525.17, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 44.12, ["Ride"] = 322.43, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 910.65, ["Mega"] = 2520.8, ["Mega|Ride"] = 2383.27, ["Mega|Fly|Ride"] = 1678.43}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.5, ["Neon"] = 45.94, ["Neon|Ride"] = 98.74, ["Neon|Fly|Ride"] = 168.77, ["Mega"] = 105.2, ["Mega|Ride"] = 398.03, ["Mega|Fly|Ride"] = 226.31}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.84, ["Ride"] = 21.02, ["Fly|Ride"] = 78.75, ["Neon"] = 142.99, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 350.82, ["Mega"] = 301.67, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 699.54}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 138.11, ["Fly"] = 168.54, ["Ride"] = 160.55, ["Fly|Ride"] = 207.9, ["Neon"] = 656.25, ["Neon|Ride"] = 582.8, ["Neon|Fly|Ride"] = 687.24, ["Mega"] = 2327.07, ["Mega|Ride"] = 2339.09, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.35, ["Ride"] = 19.81, ["Fly|Ride"] = 39.38, ["Neon"] = 12.96, ["Neon|Fly"] = 57.52, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 70.59, ["Mega"] = 140.76, ["Mega|Ride"] = 238.34, ["Mega|Fly|Ride"] = 476.67}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.45, ["Fly"] = 193.47, ["Ride"] = 38.07, ["Fly|Ride"] = 91.92, ["Neon"] = 79.64, ["Neon|Fly"] = 318.12, ["Neon|Ride"] = 82.88, ["Neon|Fly|Ride"] = 420.15, ["Mega"] = 452.81, ["Mega|Ride"] = 481.49, ["Mega|Fly|Ride"] = 407.4}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.07, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 26.36, ["Neon|Ride"] = 15.63, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.65, ["Mega|Ride"] = 32.62, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.66, ["Neon|Ride"] = 42.02, ["Neon|Fly|Ride"] = 130.25, ["Mega"] = 18.16, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 163.87}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 12.62, ["Ride"] = 26.04, ["Fly|Ride"] = 107.21, ["Neon"] = 26.25, ["Neon|Ride"] = 60.78, ["Neon|Fly|Ride"] = 218.48, ["Mega"] = 77.44, ["Mega|Ride"] = 268}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 29.22, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 167.99, ["Neon|Ride"] = 357.45, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 547.32, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 13.89, ["Fly|Ride"] = 30.72, ["Neon"] = 14.13, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 105, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 157.24}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.71, ["Fly"] = 40.21, ["Ride"] = 24.35, ["Fly|Ride"] = 84.77, ["Neon"] = 25.44, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 36.89, ["Neon|Fly|Ride"] = 127, ["Mega"] = 219.19, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 218.13, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 18.09, ["Fly|Ride"] = 39.38, ["Neon"] = 9.08, ["Neon|Fly"] = 35.73, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 159.69, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 252.1}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7, ["Fly"] = 169.32, ["Ride"] = 23.71, ["Fly|Ride"] = 217.19, ["Neon"] = 26.25, ["Neon|Ride"] = 111.34, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 275.2, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 377.09}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.49, ["Ride"] = 140.75, ["Neon"] = 38.19, ["Neon|Ride"] = 262.5, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 981.02}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.6, ["Fly"] = 42.21, ["Ride"] = 16.8, ["Fly|Ride"] = 44.91, ["Neon"] = 22.32, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 63.03, ["Neon|Fly|Ride"] = 171.94, ["Mega"] = 255.94, ["Mega|Ride"] = 323.51, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 17.88, ["Fly|Ride"] = 35.72, ["Neon"] = 15.95, ["Neon|Fly"] = 47.67, ["Neon|Ride"] = 35.73, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 238.34, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 202.08, ["Fly"] = 393.75, ["Ride"] = 300.23, ["Fly|Ride"] = 392.44, ["Neon"] = 1123.54, ["Neon|Ride"] = 1394, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4003.13}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.29, ["Ride"] = 108.41, ["Neon"] = 60.93, ["Neon|Ride"] = 140.75, ["Mega"] = 122.07, ["Mega|Ride"] = 636.35}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.63, ["Fly"] = 105.04, ["Ride"] = 21.52, ["Fly|Ride"] = 79.07, ["Neon"] = 21.95, ["Neon|Fly"] = 238.41, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 204.44, ["Mega|Ride"] = 327.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.02, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 222.66, ["Neon|Fly|Ride"] = 630.21, ["Mega"] = 603.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 564.85}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.72, ["Fly|Ride"] = 29.19, ["Neon"] = 2.1, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 14.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.83, ["Fly|Ride"] = 112.4, ["Neon"] = 13.84, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.82, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 220.66}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 39.92, ["Neon"] = 13.13, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 174.57, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 77.33, ["Fly"] = 166.8, ["Ride"] = 112.88, ["Fly|Ride"] = 168.05, ["Neon"] = 556.5, ["Neon|Ride"] = 413.44, ["Neon|Fly|Ride"] = 636.35, ["Mega|Ride"] = 3502.86, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 98.74, ["Ride"] = 28.29, ["Fly|Ride"] = 18108.49, ["Neon"] = 22.78, ["Neon|Ride"] = 62.33, ["Mega"] = 210.08, ["Mega|Ride"] = 266.8, ["Mega|Fly|Ride"] = 566.14}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.33, ["Ride"] = 33.08, ["Neon"] = 6.57, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 535.05, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.56, ["Fly"] = 210, ["Ride"] = 106.3, ["Fly|Ride"] = 199.5, ["Neon"] = 144.36, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 309.87, ["Mega"] = 590.63, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.57, ["Fly|Ride"] = 91.88, ["Neon"] = 2.1, ["Neon|Fly"] = 24.18, ["Neon|Ride"] = 14.62, ["Neon|Fly|Ride"] = 32.45, ["Mega"] = 18.17, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 52.45, ["Mega|Fly|Ride"] = 84.33}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 211.02, ["Mega"] = 16.58, ["Mega|Ride"] = 83.14, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 50.8, ["Neon"] = 8.17, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 159.69, ["Mega"] = 102.38, ["Mega|Fly"] = 182.78, ["Mega|Ride"] = 124.04, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.94, ["Fly"] = 77.17, ["Ride"] = 37.69, ["Fly|Ride"] = 146.55, ["Neon"] = 23.85, ["Neon|Fly"] = 90.33, ["Neon|Ride"] = 77.76, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 96.48, ["Mega|Fly"] = 342.01, ["Mega|Ride"] = 192.73, ["Mega|Fly|Ride"] = 254.51}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 12.62, ["Ride"] = 12.62, ["Fly|Ride"] = 25.18, ["Neon"] = 2.1, ["Neon|Fly"] = 25.23, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 61.43, ["Mega"] = 16.69, ["Mega|Ride"] = 62.05, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.07, ["Fly"] = 131.25, ["Ride"] = 126.04, ["Neon"] = 87.94, ["Neon|Fly"] = 420.1, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.56, ["Fly"] = 3150, ["Ride"] = 2493.74, ["Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 36761.45}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.43, ["Ride"] = 14.16, ["Fly|Ride"] = 44.63, ["Neon"] = 6.32, ["Neon|Fly"] = 55.95, ["Neon|Ride"] = 25.23, ["Neon|Fly|Ride"] = 72.43, ["Mega"] = 76.13, ["Mega|Ride"] = 98.43, ["Mega|Fly|Ride"] = 236.34}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 4.39, ["Mega"] = 140.76, ["Mega|Fly"] = 441, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 238.34}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 98.6, ["Fly"] = 112.4, ["Ride"] = 28.89, ["Fly|Ride"] = 70.39, ["Neon"] = 70.16, ["Neon|Ride"] = 102.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 367.5, ["Mega|Ride"] = 449.55}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.17, ["Ride"] = 44.18, ["Neon"] = 187.69, ["Mega"] = 1259.9, ["Mega|Ride"] = 602.9, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.82, ["Fly"] = 1400.98, ["Ride"] = 197.88, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6301.98, ["Mega|Fly|Ride"] = 4061.63}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.71, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.59, ["Neon|Ride"] = 140.75, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 309.87, ["Mega|Fly|Ride"] = 357.13}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.73, ["Fly|Ride"] = 70.39, ["Neon"] = 22.84, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 847.26}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 7.88, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 105, ["Mega|Ride"] = 99.1, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 8.76, ["Neon"] = 180.07, ["Neon|Ride"] = 1195.02, ["Mega"] = 374.07, ["Mega|Ride"] = 465.31, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.02, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Mega"] = 18.79, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.88, ["Fly"] = 210.06, ["Ride"] = 103.64, ["Fly|Ride"] = 315.07, ["Neon"] = 366.19, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 449.55, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.84, ["Neon"] = 10.4, ["Neon|Ride"] = 155.45, ["Mega"] = 71.52}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.3, ["Fly"] = 222.79, ["Ride"] = 73.5, ["Fly|Ride"] = 144.38, ["Neon"] = 295.32, ["Neon|Ride"] = 420.1, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 18.92, ["Fly|Ride"] = 51.19, ["Neon"] = 3.93, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 41.13, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 178.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 13.18, ["Neon|Ride"] = 98.44, ["Mega"] = 73.49, ["Mega|Ride"] = 164.28, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.55, ["Fly"] = 77.43, ["Ride"] = 38.57, ["Fly|Ride"] = 210.06, ["Neon"] = 27.74, ["Neon|Ride"] = 120.79, ["Mega"] = 262.5, ["Mega|Ride"] = 327.71, ["Mega|Fly|Ride"] = 558.79}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 346.74, ["Ride"] = 402.94, ["Fly|Ride"] = 525, ["Neon"] = 1050, ["Neon|Ride"] = 955.01, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 4726.5, ["Mega|Ride"] = 4201.33, ["Mega|Fly|Ride"] = 4289.88}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.93, ["Fly"] = 84.03, ["Ride"] = 51.96, ["Fly|Ride"] = 99.15, ["Neon"] = 196.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 396.99, ["Mega"] = 1399.06, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.89, ["Fly|Ride"] = 72.19, ["Neon"] = 10.16, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 119.55, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 266.8}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.92, ["Fly"] = 54.59, ["Ride"] = 43.43, ["Fly|Ride"] = 178.5, ["Neon"] = 68.24, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 182.11, ["Mega"] = 315, ["Mega|Fly"] = 980.73, ["Mega|Ride"] = 359.41, ["Mega|Fly|Ride"] = 414.89}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.81, ["Ride"] = 20.78, ["Fly|Ride"] = 196.88, ["Neon"] = 141.8, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 270.52, ["Mega"] = 1120.71, ["Mega|Ride"] = 671.18, ["Mega|Fly|Ride"] = 557.74}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 14.32, ["Mega"] = 78.75, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 20.96, ["Fly|Ride"] = 56.73, ["Neon"] = 41.37, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 275.2, ["Mega"] = 86.63, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 95.89, ["Ride"] = 117.81, ["Fly|Ride"] = 236.25, ["Neon"] = 1032.99, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 568.51, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2979.1}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.2, ["Ride"] = 45.53, ["Fly|Ride"] = 91.88, ["Neon"] = 142.95, ["Neon|Ride"] = 282.19, ["Mega"] = 1120.71, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 3641.06, ["Ride"] = 2060.63, ["Fly|Ride"] = 2033.07, ["Neon"] = 11202.49, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 32.82, ["Neon"] = 18.09, ["Mega"] = 97.46, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.65, ["Ride"] = 47.25, ["Fly|Ride"] = 111.07, ["Neon"] = 36.59, ["Neon|Ride"] = 76.63, ["Mega"] = 157.5, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 1050.34}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1048.11, ["Fly"] = 948.54, ["Ride"] = 879.38, ["Fly|Ride"] = 969.94, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2485.86, ["Mega"] = 12324.55, ["Mega|Fly|Ride"] = 12234.5}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.27, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 208.69, ["Neon|Ride"] = 420.1, ["Neon|Fly|Ride"] = 376.57, ["Mega"] = 840, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.58, ["Fly|Ride"] = 128.15, ["Neon"] = 15.41, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 140.75, ["Neon"] = 3.94, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 92.45, ["Mega"] = 19.69, ["Mega|Ride"] = 256.29, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 86.98, ["Ride"] = 128.63, ["Fly|Ride"] = 170.63, ["Neon"] = 420.1, ["Neon|Ride"] = 595.73, ["Neon|Fly|Ride"] = 630, ["Mega"] = 8402.63, ["Mega|Fly|Ride"] = 2100.68}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 159.69, ["Mega"] = 159.69, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.49, ["Ride"] = 102.38, ["Neon"] = 393.75, ["Neon|Ride"] = 419.05, ["Neon|Fly|Ride"] = 515.72}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.85, ["Fly"] = 105, ["Neon"] = 35.43, ["Neon|Fly|Ride"] = 315, ["Mega"] = 190.67, ["Mega|Ride"] = 309.87}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 215.25, ["Ride"] = 286.13, ["Fly|Ride"] = 334.69, ["Neon"] = 1498.88, ["Neon|Ride"] = 1066.35, ["Neon|Fly|Ride"] = 941.56, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.45, ["Fly|Ride"] = 103.94, ["Neon"] = 28.88, ["Neon|Fly"] = 159.67, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 100.59, ["Mega"] = 210, ["Mega|Ride"] = 656.23}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.92, ["Ride"] = 14.11, ["Fly|Ride"] = 28.25, ["Neon"] = 5.25, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 20.5, ["Neon|Fly|Ride"] = 46.09, ["Mega"] = 47.48, ["Mega|Ride"] = 70.56, ["Mega|Fly|Ride"] = 148.58}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1258, ["Ride"] = 1050, ["Fly|Ride"] = 1422.75, ["Neon|Ride"] = 7702.16, ["Neon|Fly|Ride"] = 6162.28, ["Mega"] = 23832.63}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.04, ["Fly"] = 980.89, ["Ride"] = 72.19, ["Neon"] = 43.63, ["Neon|Ride"] = 132.34, ["Mega"] = 320.13, ["Mega|Ride"] = 382.34, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.76, ["Fly"] = 50.43, ["Ride"] = 41.5, ["Fly|Ride"] = 79.59, ["Neon"] = 21.15, ["Neon|Fly"] = 159.67, ["Neon|Ride"] = 52.87, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 170.63, ["Mega|Ride"] = 190.95, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 30.09, ["Fly"] = 39.38, ["Ride"] = 31.67, ["Fly|Ride"] = 52.5, ["Neon"] = 157.5, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 209.76, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.32, ["Fly"] = 84.03, ["Ride"] = 27.56, ["Fly|Ride"] = 85.31, ["Neon"] = 69.43, ["Neon|Ride"] = 100.1, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.86, ["Ride"] = 112.01, ["Fly|Ride"] = 409.59, ["Neon"] = 181.13, ["Neon|Ride"] = 378, ["Mega"] = 1050, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 588.19}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 79.84, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 18.38, ["Mega|Ride"] = 83.54}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 70.27, ["Fly"] = 123.48, ["Ride"] = 71.31, ["Fly|Ride"] = 148.03, ["Neon"] = 446.24, ["Neon|Ride"] = 432.06, ["Neon|Fly|Ride"] = 455.45, ["Mega"] = 3361.07, ["Mega|Fly|Ride"] = 1586.64}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.52, ["Fly"] = 103.31, ["Ride"] = 18.8, ["Fly|Ride"] = 70.88, ["Neon"] = 65.63, ["Neon|Ride"] = 111.34, ["Mega|Ride"] = 398.03}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 18.38, ["Fly|Ride"] = 36.02, ["Neon"] = 17.26, ["Neon|Fly"] = 84.03, ["Neon|Ride"] = 66.18, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.06, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 138.65, ["Neon|Fly|Ride"] = 208.56, ["Mega"] = 376.04, ["Mega|Fly|Ride"] = 476.67}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 56.35, ["Ride"] = 77.74, ["Fly|Ride"] = 262.5, ["Neon"] = 262.5, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 560.89, ["Mega|Ride"] = 1365.44, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.97, ["Neon"] = 19.69, ["Mega"] = 122.07, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 318.19}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 16.54, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 525.17}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.73, ["Fly|Ride"] = 58.3, ["Neon"] = 3.63, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 168.07, ["Mega"] = 17.63, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 6.56, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.68, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 28.88, ["Fly|Ride"] = 112.4, ["Neon"] = 39.38, ["Mega"] = 118.1, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15.04, ["Fly|Ride"] = 26.25, ["Neon"] = 15.77, ["Neon|Fly"] = 210.06, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 52.42, ["Ride"] = 91.62, ["Fly|Ride"] = 266.77, ["Neon"] = 210.29, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1050.34, ["Mega"] = 694.32, ["Mega|Ride"] = 1030.38, ["Mega|Fly|Ride"] = 1107.06}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.36, ["Fly|Ride"] = 35.44, ["Neon"] = 4.22, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 46.89, ["Mega"] = 27.33, ["Mega|Ride"] = 23.5, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.92, ["Fly"] = 129.93, ["Ride"] = 23.69, ["Fly|Ride"] = 57.1, ["Neon"] = 26.21, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 47.57, ["Neon|Fly|Ride"] = 168.05, ["Mega"] = 302.27, ["Mega|Ride"] = 192.57, ["Mega|Fly|Ride"] = 308.43}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.02, ["Fly"] = 47.06, ["Ride"] = 26.16, ["Fly|Ride"] = 84.79, ["Neon"] = 125.64, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 182.43, ["Mega"] = 787.5, ["Mega|Ride"] = 728.95, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.83, ["Fly"] = 196.88, ["Neon"] = 52.4, ["Mega"] = 366.19, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.94, ["Fly|Ride"] = 45.29, ["Neon"] = 3.82, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 57.87, ["Mega"] = 72.1, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Fly"] = 71.44, ["Ride"] = 38.07, ["Neon"] = 21.98, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 206.05, ["Mega"] = 162.75, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 948.53, ["Fly"] = 1381.98, ["Ride"] = 1023.75, ["Fly|Ride"] = 1104.33, ["Neon"] = 3073.92, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2342.82, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.68, ["Ride"] = 181.9, ["Fly|Ride"] = 413.44, ["Neon"] = 598.63, ["Neon|Ride"] = 628.68, ["Neon|Fly|Ride"] = 813.75, ["Mega"] = 6301.98, ["Mega|Ride"] = 2661.54, ["Mega|Fly|Ride"] = 2347.02}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.73, ["Ride"] = 70.39, ["Neon"] = 5.82, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 140.76}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 66.66, ["Ride"] = 120.75, ["Fly|Ride"] = 229.69, ["Neon"] = 392.42, ["Neon|Ride"] = 406.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1836.19, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1725.84}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Fly|Ride"] = 91.39, ["Neon"] = 16.43, ["Neon|Fly"] = 56.01, ["Neon|Ride"] = 48.77, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 280.45, ["Mega|Ride"] = 316.32, ["Mega|Fly|Ride"] = 406.49}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223, ["Fly"] = 420.1, ["Ride"] = 271.68, ["Fly|Ride"] = 328.12, ["Neon|Ride"] = 1199.35, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 59.07, ["Fly|Ride"] = 215.24, ["Neon"] = 31.49, ["Neon|Fly"] = 35.73, ["Neon|Ride"] = 54.37, ["Mega"] = 415.94, ["Mega|Fly"] = 327.71, ["Mega|Ride"] = 636.35}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 28.29, ["Mega"] = 336.12, ["Mega|Ride"] = 360.28}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 20.69, ["Fly"] = 159.66, ["Ride"] = 72.1, ["Fly|Ride"] = 131.25, ["Neon"] = 152.52, ["Neon|Ride"] = 124.59, ["Mega"] = 643.5, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 25.25, ["Neon|Ride"] = 141.91, ["Mega"] = 238.34, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.92, ["Ride"] = 14.44, ["Fly|Ride"] = 39.36, ["Neon"] = 2.62, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 42.02, ["Mega"] = 23.85, ["Mega|Ride"] = 43.28, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5130.57, ["Fly|Ride"] = 4882.5, ["Neon"] = 31505.98, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 131290.88}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.15, ["Fly"] = 84.03, ["Ride"] = 41.91, ["Neon"] = 52.49, ["Neon|Ride"] = 105, ["Mega"] = 279.4, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 15.69, ["Fly|Ride"] = 35.32, ["Neon"] = 13.13, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 63.95, ["Mega"] = 124.69, ["Mega|Ride"] = 175.43, ["Mega|Fly|Ride"] = 237.39}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 432.84, ["Fly"] = 547.77, ["Ride"] = 534.19, ["Fly|Ride"] = 560.44, ["Neon"] = 2100, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1744.44, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.18, ["Ride"] = 32.62, ["Neon"] = 35.73, ["Neon|Ride"] = 291.38, ["Mega"] = 187.95, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.3, ["Fly"] = 4200.3, ["Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Ride"] = 64.36, ["Mega"] = 418.04, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 20.36, ["Neon"] = 3.91, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.97, ["Mega|Ride"] = 78.09, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 708.75, ["Ride"] = 735, ["Fly|Ride"] = 753.38, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2940, ["Mega|Fly|Ride"] = 9103.2}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.45, ["Fly"] = 295.47, ["Ride"] = 51.92, ["Fly|Ride"] = 420.1, ["Neon"] = 32.82, ["Neon|Ride"] = 69.56, ["Neon|Fly|Ride"] = 298.31, ["Mega"] = 169.32, ["Mega|Ride"] = 229.04, ["Mega|Fly|Ride"] = 385.71}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.07, ["Fly"] = 236.25, ["Ride"] = 30.19, ["Neon"] = 27.8, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 144.35, ["Mega"] = 205.04, ["Mega|Fly"] = 794.83, ["Mega|Ride"] = 214.1, ["Mega|Fly|Ride"] = 356.32}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 15.75, ["Fly|Ride"] = 45.94, ["Neon"] = 11.32, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 84.15, ["Mega"] = 280.45, ["Mega|Fly|Ride"] = 223.92}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.59, ["Ride"] = 34.12, ["Fly|Ride"] = 58.42, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 315.12, ["Mega"] = 560.89, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 84.03, ["Neon"] = 6.19, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 101.07, ["Mega|Fly"] = 166.85, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.88, ["Ride"] = 538.12, ["Fly|Ride"] = 695.25, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9294.74, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 105.04, ["Ride"] = 76.13, ["Neon"] = 16.94, ["Neon|Ride"] = 85.56, ["Neon|Fly|Ride"] = 476.67, ["Mega"] = 203.79, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 5.81, ["Neon|Fly"] = 238.41, ["Neon|Ride"] = 36.78, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 86.63, ["Mega|Fly|Ride"] = 357.13}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 5.24, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 267.85, ["Mega"] = 105.05, ["Mega|Fly"] = 155.47, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 35.73, ["Neon"] = 17.9, ["Mega"] = 210.08, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.1, ["Fly"] = 98.44, ["Ride"] = 50.3, ["Fly|Ride"] = 280.42, ["Neon"] = 120.75, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 684.01, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 940.06}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.05, ["Ride"] = 48.39, ["Fly|Ride"] = 128.99, ["Neon"] = 65.63, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 492.18, ["Mega|Ride"] = 546.18, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 14.89, ["Fly|Ride"] = 32.82, ["Neon"] = 28.65, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.18, ["Mega"] = 398.09, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 250.48}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 103.66, ["Neon"] = 89.25, ["Neon|Ride"] = 195.35, ["Mega"] = 476.67}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 129.94, ["Ride"] = 26.25, ["Fly|Ride"] = 87.04, ["Neon"] = 11.52, ["Neon|Ride"] = 40.34, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 105, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15, ["Ride"] = 30.18, ["Fly|Ride"] = 63, ["Neon"] = 420.1, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 944.26, ["Mega|Fly|Ride"] = 827.68}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 36.42, ["Fly"] = 874.13, ["Neon"] = 212.16, ["Mega"] = 452.7, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 81.93, ["Fly"] = 115.4, ["Ride"] = 81.18, ["Fly|Ride"] = 157.54, ["Neon"] = 297.94, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 418.97, ["Mega|Ride"] = 1684.98, ["Mega|Fly|Ride"] = 1632.22}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 37.1, ["Fly"] = 84.03, ["Ride"] = 76.74, ["Fly|Ride"] = 209.01, ["Neon"] = 160.01, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 654.98, ["Mega|Fly|Ride"] = 617.25}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.05, ["Ride"] = 57.5, ["Neon"] = 131.14, ["Neon|Ride"] = 284.82, ["Mega"] = 1049.99, ["Mega|Ride"] = 794.83}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 13.13, ["Fly"] = 420.1, ["Ride"] = 31.87, ["Fly|Ride"] = 192.94, ["Neon"] = 120.75, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.78, ["Neon|Fly|Ride"] = 143.01, ["Mega"] = 464.37, ["Mega|Ride"] = 531.68, ["Mega|Fly|Ride"] = 627.22}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.09, ["Fly|Ride"] = 32.73, ["Neon"] = 3.92, ["Neon|Fly"] = 28.01, ["Neon|Ride"] = 28.9, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 39.36, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 406.49}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 41.49, ["Ride"] = 98.44, ["Fly|Ride"] = 420.1, ["Neon"] = 344.4, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 1120.71, ["Mega|Ride"] = 1429.97, ["Mega|Fly|Ride"] = 1291.91}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 3.84, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 294.11, ["Mega"] = 28.24, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.09, ["Ride"] = 51.98, ["Fly|Ride"] = 170.15, ["Neon"] = 156.19, ["Neon|Ride"] = 133.94, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 514.55, ["Mega|Ride"] = 794.83, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 26.24}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 102.53, ["Fly"] = 223.13, ["Ride"] = 120.78, ["Fly|Ride"] = 309.83, ["Neon"] = 262.5, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.15, ["Mega|Ride"] = 2644.73, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 20.87, ["Fly|Ride"] = 95.31, ["Neon"] = 4.17, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 66.77, ["Fly|Ride"] = 51.45, ["Neon"] = 6.03, ["Neon|Ride"] = 41.72, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 34.13, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.74, ["Neon"] = 6.09, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.1, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 78.75, ["Neon"] = 5.93, ["Neon|Ride"] = 156.19, ["Mega"] = 86.57, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 52.49, ["Ride"] = 135.19, ["Fly|Ride"] = 1050.2, ["Neon"] = 424.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1575.51, ["Mega|Fly|Ride"] = 1575.51}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.63, ["Neon"] = 79.54, ["Neon|Ride"] = 227.06, ["Mega"] = 476.67, ["Mega|Ride"] = 953.32}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Fly|Ride"] = 767.3, ["Neon"] = 1115.63, ["Neon|Ride"] = 1191.45, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 85.2}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 26.1}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 12.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.9}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.48}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.17}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.44}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.6}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 11.46}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.35}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.84}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 7.88}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 11.82}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 552.57}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 790.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 5.25}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1049.99}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.25}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 31.92}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.09}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 47.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.56}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.09}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.64}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.09}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.06}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.92}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 28.25}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.81}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.53}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 5.62}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.54}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.34}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.17}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 16.59}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.65}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 219.74}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 29.19}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.67}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 15.78}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 318.03}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 13.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.45}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 87.93}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.07}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 130.89}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.92}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.89}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22629.8}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 316.89}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 59.77}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.4}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 71.06}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 36.27}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 44.98}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.27}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.74}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 43.31}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.52}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 123.87}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.11}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7035.5}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 3.84}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 1.79}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 2.57}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.97}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 116.82}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.76}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.73}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.66}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 1.79}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 944.99}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.85}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.6}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.51}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.51}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 619.36}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 20.78}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 18.61}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.46}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 47.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.57}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.96}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.5}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.25}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.03}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.67}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.85}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.78}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.16}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 276.83}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 630.06}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.91}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.39}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.19}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.45}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 14.39}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.31}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.5}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 9.06}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.37}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.81}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.29}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.56}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.42}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.81}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.18}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.07}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.29}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.41}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8121.27}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 19.56}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.31}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 2.6}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.69}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.71}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.55}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.45}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.32}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4200.3}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.23}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.67}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.2}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 55.27}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.81}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 97.55}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 13.55}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 4.12}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.65}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 17.57}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.71}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.61}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.08}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.05}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.41}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.51}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.85}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.99}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.08}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.2}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.59}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1042}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 28.14}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.66}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 16.65}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 18.69}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.02}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.86}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.49}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.3}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.16}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.37}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 6.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.37}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 1.79}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.84}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.15}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.7}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 18.8}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.24}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 3.39}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.67}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 31.71}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.31}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.55}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 48.44}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.67}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.52}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.29}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.5}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.59}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 4.2}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.01}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.43}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.75}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 6.5}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.82}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.39}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 237.34}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.21}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 20.44}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 53.82}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.94}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.61}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.44}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.54}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.59}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 1.79}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 4.99}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.49}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.5}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 20.52}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 132.57}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.09}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 7.77}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.02}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 17.88}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 55.13}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 1.79}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.88}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 182.72}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 54.21}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 137.13}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.19}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.41}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.38}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.2}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.39}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.03}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.98}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 81.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 15.25}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 61.6}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 32.97}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 66.14}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.29}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.13}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 48.57}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 24.83}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 81.78}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1700.57}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.71}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.58}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 335.22}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.93}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.97}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.65}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.45}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.87}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.06}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 50.25}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 59.24}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.39}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 74.72}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1116.94}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 270.38}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.24}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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