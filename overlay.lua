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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1043.52, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6629.53, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63, ["Mega|Fly|Ride"] = 17376.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 497.44, ["Fly|Ride"] = 617.08, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 6886.56}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5465.25, ["Ride"] = 5249.99, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 21144.32, ["Mega|Fly|Ride"] = 69561.38}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 173.62, ["Ride"] = 227.58, ["Fly|Ride"] = 275.36, ["Neon"] = 973.61, ["Neon|Ride"] = 948.94, ["Neon|Fly|Ride"] = 1038.09, ["Mega|Fly|Ride"] = 4022.82}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 836.5, ["Ride"] = 538.13, ["Fly|Ride"] = 610.32, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.87, ["Ride"] = 32.42, ["Fly|Ride"] = 129.94, ["Neon"] = 59.07, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 348.47, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 584.33}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.14, ["Fly"] = 34.63, ["Ride"] = 24.87, ["Fly|Ride"] = 49.88, ["Neon"] = 25.95, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 55.21, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 154.88, ["Mega|Ride"] = 227.08, ["Mega|Fly|Ride"] = 288.44}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 209.13, ["Ride"] = 153.81, ["Neon"] = 485.63, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 1669.27, ["Mega"] = 2057.37}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.24, ["Fly"] = 105, ["Ride"] = 44.62, ["Fly|Ride"] = 103.48, ["Neon"] = 312.38, ["Neon|Ride"] = 286.13, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 2100}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.7, ["Fly"] = 85.32, ["Ride"] = 28.58, ["Fly|Ride"] = 70.63, ["Neon"] = 144.9, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 625.99}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.45, ["Fly"] = 119.21, ["Ride"] = 80.2, ["Fly|Ride"] = 177.19, ["Neon"] = 416.97, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 417.38}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 67.43}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 393.75, ["Fly"] = 399, ["Ride"] = 326.82, ["Fly|Ride"] = 384.56, ["Neon|Fly"] = 1349.6, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4941.03}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 187.7, ["Ride"] = 116.82, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 821.94, ["Mega|Fly|Ride"] = 3041.1}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Fly|Ride"] = 131.25, ["Neon"] = 19.38, ["Neon|Fly"] = 98, ["Neon|Ride"] = 50.61, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 129.93, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 315.08, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 190.26, ["Fly"] = 237.57, ["Ride"] = 183.75, ["Fly|Ride"] = 229.69, ["Neon"] = 828.71, ["Neon|Ride"] = 1351.96, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.62, ["Fly"] = 19.69, ["Ride"] = 20.92, ["Fly|Ride"] = 32.82, ["Neon"] = 35.46, ["Neon|Ride"] = 91.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 208.68, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.37, ["Fly"] = 284.72, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 282.59, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.59}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.69, ["Ride"] = 102.47, ["Fly|Ride"] = 177.22, ["Neon"] = 556.65, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1391.76}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.1, ["Fly"] = 393.75, ["Ride"] = 26.25, ["Fly|Ride"] = 375.27, ["Neon"] = 206.3, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2724, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 557.2}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.64, ["Fly"] = 157.5, ["Ride"] = 59.76, ["Fly|Ride"] = 100.11, ["Neon"] = 682.78, ["Neon|Ride"] = 295.98, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1658.09, ["Mega|Ride"] = 1391.76, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 369.02, ["Neon|Fly|Ride"] = 446.54, ["Mega"] = 1967.44, ["Mega|Ride"] = 1238.4, ["Mega|Fly|Ride"] = 1106.52}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.7, ["Ride"] = 40.4, ["Fly|Ride"] = 84, ["Neon"] = 174.09, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 316.23, ["Mega"] = 884.72, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 36.75, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 135.53, ["Neon"] = 196.88, ["Neon|Ride"] = 187.64, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.83, ["Fly"] = 26.6, ["Ride"] = 19.69, ["Fly|Ride"] = 52.25, ["Neon"] = 36.74, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 95.44, ["Mega"] = 158.71, ["Mega|Fly"] = 27100.4, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 510.21, ["Ride"] = 418.25, ["Fly|Ride"] = 486.87, ["Neon|Ride"] = 2918.71, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8069.79}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 18.83, ["Ride"] = 32.82, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 278.57, ["Mega|Ride"] = 792.91, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.94, ["Fly"] = 34.54, ["Ride"] = 19.85, ["Fly|Ride"] = 39.8, ["Neon"] = 69.85, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 208.68, ["Mega|Ride"] = 446.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 93.66, ["Fly"] = 102.38, ["Ride"] = 97.53, ["Fly|Ride"] = 128.63, ["Neon"] = 371.74, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 398.21, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 3896.7, ["Mega|Ride"] = 7875, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.7, ["Ride"] = 31.38, ["Fly|Ride"] = 75.2, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 695.89, ["Mega|Ride"] = 796.04, ["Mega|Fly|Ride"] = 834.74}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 206.06, ["Fly"] = 353.42, ["Ride"] = 228.38, ["Fly|Ride"] = 301.88, ["Mega"] = 6259.74, ["Mega|Fly|Ride"] = 5064.13}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.69, ["Fly"] = 32.07, ["Ride"] = 23.42, ["Fly|Ride"] = 53.44, ["Neon"] = 20.45, ["Neon|Fly"] = 139.7, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 146.71, ["Mega|Ride"] = 155.13, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 926.88, ["Fly"] = 2625, ["Ride"] = 892.5, ["Fly|Ride"] = 1112.47, ["Neon"] = 10207.32, ["Neon|Ride"] = 6115.72, ["Neon|Fly|Ride"] = 4451.72, ["Mega|Ride"] = 53295.32, ["Mega|Fly|Ride"] = 17054.51}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.3, ["Fly"] = 70.38, ["Ride"] = 22.88, ["Fly|Ride"] = 91.88, ["Neon"] = 139.7, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 230.58, ["Mega"] = 787.5, ["Mega|Ride"] = 1071.48, ["Mega|Fly|Ride"] = 815.97}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 170.63, ["Ride"] = 196.77, ["Fly|Ride"] = 301.88, ["Neon"] = 1105.73, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 977.82, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.01}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.3, ["Fly"] = 111.89, ["Ride"] = 65.52, ["Fly|Ride"] = 145.69, ["Neon"] = 104.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 695.89, ["Mega|Ride"] = 1100.68, ["Mega|Fly|Ride"] = 586.26}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.48}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 128.37, ["Ride"] = 136.49, ["Fly|Ride"] = 236.25, ["Neon"] = 639.19, ["Neon|Ride"] = 533.72, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.33, ["Fly"] = 157.49, ["Ride"] = 163.94, ["Fly|Ride"] = 274.31, ["Neon"] = 360.94, ["Neon|Ride"] = 322.43, ["Neon|Fly|Ride"] = 640.5, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1498.62}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.71}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.06, ["Fly"] = 89.94, ["Ride"] = 55.55, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 416.73, ["Neon|Fly|Ride"] = 369.11, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.58, ["Fly"] = 70.07, ["Ride"] = 56.82, ["Fly|Ride"] = 157.5, ["Neon"] = 40.67, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 557.12, ["Mega"] = 182.4, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 328.65, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 433.13, ["Fly"] = 455.11, ["Ride"] = 451.5, ["Fly|Ride"] = 473.8, ["Neon|Ride"] = 3752.63, ["Neon|Fly|Ride"] = 1668.11, ["Mega|Fly|Ride"] = 7372.94}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 102.78, ["Fly"] = 167.31, ["Ride"] = 122.07, ["Fly|Ride"] = 158.65, ["Neon"] = 420, ["Neon|Ride"] = 765.13, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2548.65}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3150, ["Ride"] = 3885, ["Fly|Ride"] = 3675}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.42, ["Fly"] = 118.13, ["Ride"] = 49.88, ["Fly|Ride"] = 173.06, ["Neon|Ride"] = 316.1, ["Neon|Fly|Ride"] = 549.84, ["Mega"] = 1355.25, ["Mega|Ride"] = 1780.9, ["Mega|Fly|Ride"] = 1350.03}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 83.67, ["Ride"] = 85.32, ["Fly|Ride"] = 139.52, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 757.99, ["Mega|Ride"] = 2226.38, ["Mega|Fly|Ride"] = 4082.08}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.29, ["Fly"] = 56.05, ["Ride"] = 45.95, ["Fly|Ride"] = 91.88, ["Neon"] = 208.49, ["Neon|Ride"] = 140.33, ["Neon|Fly|Ride"] = 183.29, ["Mega"] = 2625, ["Mega|Ride"] = 682.32, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.24}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 38.04, ["Ride"] = 93.85, ["Fly|Ride"] = 65.61, ["Neon|Ride"] = 316.1, ["Neon|Fly|Ride"] = 417.34, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.7}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1390.56}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 941.05, ["Ride"] = 918.75, ["Fly|Ride"] = 974.51, ["Neon|Fly|Ride"] = 3196.65, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.97}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.61, ["Fly"] = 39.35, ["Ride"] = 38.05, ["Fly|Ride"] = 89.11, ["Neon"] = 250.19, ["Neon|Ride"] = 158.65, ["Neon|Fly|Ride"] = 216.57, ["Mega|Ride"] = 1136.98, ["Mega|Fly|Ride"] = 996.35}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.78}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly|Ride"] = 4961.25, ["Neon|Fly|Ride"] = 10762.5, ["Mega|Fly|Ride"] = 41385.69}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.45, ["Fly"] = 52.41, ["Ride"] = 26.91, ["Fly|Ride"] = 53.99, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 695.89, ["Mega|Ride"] = 625.99, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.08, ["Ride"] = 26.25, ["Neon"] = 91.88, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 741.57, ["Mega|Ride"] = 675.03, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.88, ["Fly"] = 279.18, ["Ride"] = 74.39, ["Fly|Ride"] = 104.25, ["Neon|Ride"] = 386.75, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4173.17}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.19, ["Fly"] = 150.93, ["Ride"] = 36.61, ["Fly|Ride"] = 132.65, ["Neon"] = 69.85, ["Neon|Ride"] = 262.7, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1391.76, ["Mega|Ride"] = 742.6, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.87, ["Fly"] = 2314.96, ["Ride"] = 1749.48, ["Fly|Ride"] = 1662.94, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26505.94, ["Fly"] = 33458.93, ["Ride"] = 32025, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72324.12, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.98, ["Fly"] = 393.75, ["Ride"] = 67.73, ["Fly|Ride"] = 165.83, ["Neon"] = 312.73, ["Neon|Ride"] = 278.34, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1097.56, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 974.57}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.85, ["Fly"] = 87.68, ["Ride"] = 32.44, ["Fly|Ride"] = 153.71, ["Neon"] = 20.47, ["Neon|Fly"] = 150.36, ["Neon|Ride"] = 63.56, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 129.94, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.24, ["Ride"] = 32.09, ["Fly|Ride"] = 124.67, ["Neon"] = 88.81, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 548.79, ["Mega"] = 310.97, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 811.39, ["Ride"] = 708.75, ["Fly|Ride"] = 797.74, ["Neon"] = 2999.88, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11054.65}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 975.19, ["Ride"] = 853.13, ["Fly|Ride"] = 945, ["Neon|Ride"] = 3613.99, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10573.99}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.37, ["Fly"] = 118.8, ["Ride"] = 35.57, ["Fly|Ride"] = 65.62, ["Neon"] = 72.18, ["Neon|Ride"] = 119.91, ["Neon|Fly|Ride"] = 214.93, ["Mega|Ride"] = 934.5, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.38}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 67.09, ["Fly"] = 128.34, ["Ride"] = 77.44, ["Fly|Ride"] = 118.13, ["Neon"] = 586.02, ["Neon|Ride"] = 403.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2042.77, ["Mega|Fly|Ride"] = 1764.69}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.18, ["Ride"] = 91.88, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 337.47, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1357.74, ["Mega|Fly|Ride"] = 3145.91}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.5, ["Fly"] = 30.55, ["Ride"] = 19.99, ["Fly|Ride"] = 38.66, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 64.64, ["Neon|Fly|Ride"] = 90.95, ["Mega"] = 320.3, ["Mega|Fly|Ride"] = 524.68}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 141.17, ["Fly"] = 161.44, ["Ride"] = 157.5, ["Fly|Ride"] = 196.88, ["Neon"] = 725.82, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1864.36}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.96, ["Ride"] = 34.67, ["Fly|Ride"] = 140.13, ["Neon"] = 33.77, ["Neon|Ride"] = 82.69, ["Mega"] = 248.07, ["Mega|Ride"] = 918.74, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 9.62, ["Fly"] = 41.65, ["Ride"] = 30.18, ["Fly|Ride"] = 77.16, ["Neon"] = 91.88, ["Neon|Fly"] = 126.69, ["Neon|Ride"] = 131.24, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.24, ["Ride"] = 28.24, ["Fly|Ride"] = 156.19, ["Neon"] = 248.1, ["Neon|Ride"] = 316.1, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 892.02}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.54, ["Fly"] = 165.56, ["Ride"] = 35.75, ["Fly|Ride"] = 70.79, ["Neon"] = 91.88, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 207.63, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 8364.75, ["Ride"] = 6555.94, ["Fly|Ride"] = 5496.75, ["Neon"] = 34747.09, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 26290.86}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 205.07, ["Fly"] = 271.57, ["Ride"] = 247.7, ["Fly|Ride"] = 271.58, ["Neon|Fly|Ride"] = 564.37, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 39.38, ["Fly"] = 140.64, ["Ride"] = 78.74, ["Fly|Ride"] = 180.11, ["Neon"] = 118.13, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 280.86, ["Mega"] = 451.43, ["Mega|Fly"] = 543.76, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 560.46}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.85, ["Fly"] = 87.91, ["Ride"] = 28.88, ["Fly|Ride"] = 52.5, ["Neon"] = 31.16, ["Neon|Fly"] = 60.47, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 189.89, ["Mega"] = 341.25, ["Mega|Ride"] = 188.99}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.5, ["Fly"] = 140.76, ["Ride"] = 95.9, ["Fly|Ride"] = 170.63, ["Neon"] = 225.22, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 539.85, ["Mega|Ride"] = 591.91, ["Mega|Fly|Ride"] = 608.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 12009.38, ["Fly|Ride"] = 12073.69, ["Neon|Fly|Ride"] = 24150, ["Mega|Fly|Ride"] = 111297.99}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.77, ["Ride"] = 242.82, ["Fly|Ride"] = 357.69, ["Neon"] = 1543.75, ["Neon|Ride"] = 1390.56, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5968.35}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 64.14, ["Fly"] = 82.91, ["Ride"] = 57.17, ["Fly|Ride"] = 141.92, ["Neon"] = 396.13, ["Neon|Ride"] = 296.13, ["Neon|Fly|Ride"] = 416.29}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.66, ["Fly"] = 27.67, ["Ride"] = 28.24, ["Fly|Ride"] = 72.12, ["Neon"] = 69.85, ["Neon|Fly"] = 268.75, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 473.66}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.2, ["Fly"] = 836.5, ["Ride"] = 392.43, ["Fly|Ride"] = 492.19, ["Neon"] = 1568.76, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1624.04, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.48, ["Fly"] = 28.24, ["Ride"] = 38.06, ["Fly|Ride"] = 111.46, ["Neon"] = 28.16, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 129.94, ["Mega|Fly"] = 278.57, ["Mega|Ride"] = 617.44, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 102.26, ["Fly"] = 218.59, ["Ride"] = 129.83, ["Fly|Ride"] = 216.57, ["Neon"] = 553.52, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.54, ["Fly"] = 19.05, ["Ride"] = 18.79, ["Fly|Ride"] = 29.98, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 2503.91, ["Mega|Fly|Ride"] = 947.48}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.99}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.5, ["Ride"] = 58.46, ["Fly|Ride"] = 139.7, ["Neon"] = 421.32, ["Neon|Fly"] = 415.93, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 417.34, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1809.3}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.97, ["Fly"] = 103.52, ["Ride"] = 31.5, ["Fly|Ride"] = 93.19, ["Neon"] = 151.55, ["Neon|Ride"] = 146.82, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 539.18}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 46.92, ["Fly"] = 210, ["Ride"] = 109.58, ["Fly|Ride"] = 249.38, ["Neon"] = 284.13, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1564.95, ["Mega|Ride"] = 2092.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 21, ["Neon|Ride"] = 103.01, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 137.82, ["Mega|Ride"] = 284.25}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.64, ["Fly"] = 52.49, ["Ride"] = 28.82, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 311.85, ["Neon|Fly|Ride"] = 208.68, ["Mega|Ride"] = 636.42}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 446.25, ["Ride"] = 490.28, ["Fly|Ride"] = 485.62, ["Neon|Fly|Ride"] = 5564.91, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.36, ["Ride"] = 57.75, ["Fly|Ride"] = 177.19, ["Neon"] = 177.68, ["Neon|Ride"] = 254.69, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.67, ["Ride"] = 65.63, ["Fly|Ride"] = 139.7, ["Neon|Ride"] = 416.97, ["Neon|Fly|Ride"] = 458.1, ["Mega|Ride"] = 834.65, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.43, ["Ride"] = 59.07, ["Fly|Ride"] = 125.26, ["Neon"] = 95.81, ["Neon|Ride"] = 154.29, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 437.07, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 625.99}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 13621.46, ["Fly|Ride"] = 8528.63, ["Neon|Fly|Ride"] = 17259.38, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1365, ["Ride"] = 1509.38, ["Fly|Ride"] = 1611.75, ["Neon|Fly|Ride"] = 3936.19, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 1312.49, ["Ride"] = 853.13, ["Fly|Ride"] = 538.13, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2086.6, ["Mega|Fly|Ride"] = 6956.46}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.31, ["Fly"] = 20.71, ["Ride"] = 21.31, ["Fly|Ride"] = 40.5, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.5, ["Fly"] = 78.74, ["Ride"] = 29.98, ["Neon"] = 19.48, ["Neon|Ride"] = 55.12, ["Mega"] = 158.87, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.82, ["Fly"] = 102.47, ["Ride"] = 53.4, ["Fly|Ride"] = 87.94, ["Neon"] = 532.74, ["Neon|Ride"] = 155.92, ["Neon|Fly|Ride"] = 197.85, ["Mega|Fly|Ride"] = 586.47}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.7, ["Fly"] = 23.24, ["Ride"] = 15.17, ["Fly|Ride"] = 26.25, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 44.98, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 208.68, ["Mega|Ride"] = 239.97, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 354.38, ["Fly"] = 369.49, ["Ride"] = 324.19, ["Fly|Ride"] = 416.97, ["Neon|Ride"] = 1375.97, ["Neon|Fly|Ride"] = 1668.23, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.74, ["Fly"] = 59.4, ["Ride"] = 30.94, ["Fly|Ride"] = 105, ["Neon"] = 208.95, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 287.44, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.56, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 42.63, ["Neon"] = 139.7, ["Neon|Fly"] = 134.97, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.5, ["Fly"] = 1048.69, ["Ride"] = 521.77, ["Fly|Ride"] = 884.35, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1273.63, ["Ride"] = 1260, ["Fly|Ride"] = 1384.69, ["Neon"] = 4864.85, ["Neon|Ride"] = 4169.58, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13756.4}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 122, ["Fly"] = 135.94, ["Ride"] = 98.44, ["Fly|Ride"] = 97.89, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2365.15}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.45, ["Fly"] = 183.75, ["Ride"] = 176.87, ["Fly|Ride"] = 229.95, ["Neon"] = 845.39, ["Neon|Fly"] = 695.28, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 585.64, ["Mega|Ride"] = 3061.02, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.83, ["Fly"] = 120.26, ["Ride"] = 53.72, ["Neon"] = 389.88, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 2086.6, ["Mega|Fly|Ride"] = 974.57}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 315, ["Fly|Ride"] = 558.35, ["Neon|Fly|Ride"] = 1326.47, ["Mega|Fly|Ride"] = 3986.91}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2059.8, ["Fly"] = 2257, ["Ride"] = 2483.25, ["Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 28432.39}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 209.13, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1113.2, ["Mega|Fly|Ride"] = 2503.91}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 618.08, ["Fly|Ride"] = 654.94, ["Neon|Ride"] = 1529.2, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 3360}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 68.91, ["Ride"] = 48.53, ["Fly|Ride"] = 95.26, ["Neon|Ride"] = 277.29, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1391.76}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 20.98, ["Fly|Ride"] = 51.49, ["Neon"] = 19.69, ["Neon|Fly"] = 158.65, ["Neon|Ride"] = 44.58, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 150.46, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 182.11, ["Mega|Fly|Ride"] = 299.03}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.55, ["Ride"] = 91.88, ["Fly|Ride"] = 167.31, ["Neon"] = 420, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 695.89, ["Mega"] = 1525.3}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 1085.44, ["Ride"] = 835.96, ["Fly|Ride"] = 918.23, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2651.25, ["Mega|Fly|Ride"] = 9631.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 712.74, ["Ride"] = 1446.38, ["Fly|Ride"] = 970.32, ["Mega|Fly|Ride"] = 15162.93}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.38, ["Fly"] = 26.25, ["Ride"] = 22.24, ["Fly|Ride"] = 38.22, ["Neon"] = 78.75, ["Neon|Ride"] = 125.1, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.09, ["Ride"] = 19.16, ["Fly|Ride"] = 70.07, ["Neon"] = 139.54, ["Neon|Ride"] = 98, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 570.94, ["Mega|Ride"] = 417.34, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.42, ["Ride"] = 23.62, ["Fly|Ride"] = 111.57, ["Neon"] = 20.9, ["Neon|Fly"] = 316.1, ["Neon|Ride"] = 55.59, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 157.35, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 277.93, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 37.05, ["Fly"] = 75.3, ["Ride"] = 49.88, ["Fly|Ride"] = 103.01, ["Neon"] = 249.38, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1009.32}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 52.49, ["Ride"] = 135.19, ["Fly|Ride"] = 1042.41, ["Neon"] = 424.07, ["Neon|Ride"] = 556.65, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1806.98, ["Mega|Ride"] = 1564.95, ["Mega|Fly|Ride"] = 1530.52}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 43.31, ["Ride"] = 35.44, ["Fly|Ride"] = 68.24, ["Neon"] = 98.44, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 156.18, ["Mega"] = 624.94, ["Mega|Ride"] = 352.28, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.12, ["Ride"] = 44.54, ["Fly|Ride"] = 101.75, ["Neon"] = 331.49, ["Neon|Fly"] = 1390.56, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 2100, ["Mega|Ride"] = 1040.18, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 15.96, ["Fly|Ride"] = 41.99, ["Neon"] = 29.19, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 730.32, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.71, ["Fly"] = 46.41, ["Ride"] = 32.48, ["Fly|Ride"] = 70.47, ["Neon"] = 34.55, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 142.13, ["Mega"] = 299.43, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 483.06}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.5, ["Fly"] = 65.63, ["Ride"] = 52.5, ["Fly|Ride"] = 96.42, ["Neon"] = 410.82, ["Neon|Ride"] = 291.88, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1437.19, ["Fly|Ride"] = 1584.63, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 13966.82}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 479.81, ["Ride"] = 459.38, ["Fly|Ride"] = 473.82, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 10434.16}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.75, ["Ride"] = 284.82, ["Fly|Ride"] = 459.38, ["Neon"] = 1207.5, ["Neon|Ride"] = 1390.56, ["Neon|Fly|Ride"] = 1669.27, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.97, ["Ride"] = 45.61, ["Fly|Ride"] = 98.44, ["Neon|Fly"] = 416.97, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 417.34, ["Mega|Ride"] = 1433.5, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 32065.16, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17390.63, ["Neon|Fly|Ride"] = 35437.49, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 262.49, ["Fly"] = 611.63, ["Ride"] = 292.57, ["Fly|Ride"] = 357.75, ["Neon"] = 1388.48, ["Neon|Fly"] = 1105.73, ["Neon|Ride"] = 864.96, ["Neon|Fly|Ride"] = 1002.65, ["Mega"] = 3964.51, ["Mega|Ride"] = 4172.12, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 195.54, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1737.45}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 140.13, ["Fly"] = 279.18, ["Ride"] = 157.5, ["Fly|Ride"] = 225.75, ["Neon|Ride"] = 606.79, ["Neon|Fly|Ride"] = 811.69, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.17, ["Fly"] = 94.5, ["Ride"] = 30.08, ["Fly|Ride"] = 69.85, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 708.26, ["Mega|Fly|Ride"] = 654.17}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3936.19, ["Ride"] = 3937.5, ["Fly|Ride"] = 4724.27, ["Neon"] = 27102.2, ["Neon|Fly|Ride"] = 27821.35}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.03, ["Fly"] = 62.75, ["Ride"] = 30.18, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 211.97, ["Mega|Fly|Ride"] = 695.89}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.37, ["Fly"] = 106.51, ["Ride"] = 56.79, ["Fly|Ride"] = 71.07, ["Neon"] = 404.46, ["Neon|Fly"] = 1390.56, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 248.07, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 616.87, ["Ride"] = 712.47, ["Fly|Ride"] = 630, ["Neon"] = 2342.69, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1968.65, ["Mega"] = 8137.65, ["Mega|Fly"] = 8137.65, ["Mega|Fly|Ride"] = 6090}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.69, ["Fly"] = 26.17, ["Ride"] = 24.94, ["Fly|Ride"] = 39.37, ["Neon"] = 118.12, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 163.08, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.52, ["Ride"] = 27.57, ["Fly|Ride"] = 473.55, ["Neon"] = 95.82, ["Neon|Ride"] = 118.4, ["Neon|Fly|Ride"] = 249.38}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.69, ["Ride"] = 128.63, ["Fly|Ride"] = 136.57, ["Neon"] = 1010.63, ["Neon|Ride"] = 833.94, ["Neon|Fly|Ride"] = 557.12, ["Mega|Fly|Ride"] = 2747.69}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.74, ["Fly"] = 140.13, ["Ride"] = 79.25, ["Fly|Ride"] = 131.25, ["Neon"] = 72.19, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 249.43, ["Mega"] = 393.75, ["Mega|Fly"] = 724.06, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 414.23}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Ride"] = 3883.64, ["Fly|Ride"] = 4182.51, ["Neon"] = 13899.26, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 36515.07, ["Mega|Fly|Ride"] = 36003.95}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.71, ["Ride"] = 65.31, ["Fly|Ride"] = 111.55, ["Neon"] = 888.57, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 683.82, ["Mega|Ride"] = 1034.96, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5775, ["Ride"] = 6857.82, ["Fly|Ride"] = 7168.75, ["Neon|Ride"] = 19458.33, ["Neon|Fly|Ride"] = 17826.05, ["Mega|Fly|Ride"] = 81823.98}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 22.32, ["Ride"] = 16.89, ["Fly|Ride"] = 31.14, ["Neon"] = 26.16, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 195.57, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 345.34}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.3, ["Fly"] = 28.82, ["Ride"] = 26.38, ["Fly|Ride"] = 55.1, ["Neon"] = 194.95, ["Neon|Fly"] = 230.39, ["Neon|Ride"] = 103.22, ["Neon|Fly|Ride"] = 161.44, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.6}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.82, ["Ride"] = 32.71, ["Fly|Ride"] = 116.03, ["Neon"] = 79.33, ["Neon|Ride"] = 157.68, ["Mega"] = 1050, ["Mega|Ride"] = 875.34, ["Mega|Fly|Ride"] = 1579.93}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.58, ["Fly"] = 190.37, ["Ride"] = 41.84, ["Fly|Ride"] = 99.73, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 316.13, ["Mega"] = 945, ["Mega|Ride"] = 947.48, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.8, ["Fly"] = 26.25, ["Ride"] = 22.8, ["Fly|Ride"] = 35.35, ["Neon|Ride"] = 115.73, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2503.91, ["Mega|Ride"] = 591, ["Mega|Fly|Ride"] = 528.96}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8471.38}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.45}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 277.93, ["Ride"] = 250.95, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 5646.98}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.6, ["Fly"] = 131.76, ["Ride"] = 35.57, ["Fly|Ride"] = 127.87, ["Neon"] = 154.29, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 522.32, ["Mega|Fly|Ride"] = 972.48}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.95}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.24, ["Ride"] = 30.34, ["Neon|Ride"] = 181.39, ["Mega|Fly|Ride"] = 834.74}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3167.3}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.9, ["Ride"] = 215.25, ["Fly|Ride"] = 328.13, ["Neon"] = 903.76, ["Neon|Ride"] = 813.75, ["Neon|Fly|Ride"] = 1113.2, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 77.78, ["Ride"] = 103.03, ["Fly|Ride"] = 202.25, ["Neon"] = 556.65, ["Neon|Ride"] = 320.03, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2086.6, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 156.19, ["Fly"] = 349.25, ["Ride"] = 192, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 974.45, ["Mega|Ride"] = 3226.13, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 1968.75, ["Ride"] = 1837.5, ["Fly|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 18376.32}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 13.07, ["Fly"] = 98.3, ["Ride"] = 57.75, ["Fly|Ride"] = 99.73, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 937.94, ["Mega|Ride"] = 1026.84, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 735, ["Fly|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 4172.12, ["Mega|Fly|Ride"] = 16585.56}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.7, ["Ride"] = 56.47, ["Fly|Ride"] = 829.76, ["Neon"] = 87.63, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 407.27, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.39, ["Fly"] = 165.55, ["Ride"] = 27.57, ["Fly|Ride"] = 99.75, ["Neon"] = 65.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.7, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 64.32}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.77, ["Fly"] = 108.92, ["Ride"] = 30.9, ["Fly|Ride"] = 81.24, ["Neon"] = 94.73, ["Neon|Ride"] = 250.19, ["Neon|Fly|Ride"] = 487.24, ["Mega|Fly|Ride"] = 1949.12}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 20.78, ["Fly"] = 56.15, ["Ride"] = 45.94, ["Fly|Ride"] = 52.41, ["Neon"] = 288.75, ["Neon|Ride"] = 416.97, ["Neon|Fly|Ride"] = 308.83, ["Mega|Ride"] = 1776.52, ["Mega|Fly|Ride"] = 946.28}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 11812.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.01, ["Fly"] = 65.63, ["Ride"] = 33.52, ["Fly|Ride"] = 78.15, ["Neon"] = 56.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 221.49, ["Mega"] = 530.6, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 533.4}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 104.97, ["Fly"] = 370.16, ["Ride"] = 132.6, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 733.44, ["Mega"] = 2879.59}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 46.79, ["Fly"] = 140.91, ["Ride"] = 68.98, ["Fly|Ride"] = 157.49, ["Neon"] = 255.93, ["Neon|Ride"] = 278.34, ["Neon|Fly|Ride"] = 320.74, ["Mega"] = 2368.69, ["Mega|Ride"] = 2816.89, ["Mega|Fly|Ride"] = 1530.52}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.29, ["Fly"] = 70.47, ["Ride"] = 29.54, ["Fly|Ride"] = 66.31, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 1016.21, ["Mega|Ride"] = 869.32, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.19, ["Fly"] = 65.54, ["Ride"] = 25.81, ["Fly|Ride"] = 60.66, ["Neon"] = 25.94, ["Neon|Fly"] = 69.85, ["Neon|Ride"] = 50.89, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 202.41, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 178.4, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 8.03, ["Ride"] = 27.36, ["Fly|Ride"] = 90.7, ["Neon"] = 86.52, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 525, ["Mega|Ride"] = 537.71, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.04, ["Fly"] = 23.55, ["Ride"] = 24.81, ["Fly|Ride"] = 47.14, ["Neon"] = 361.73, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.3}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 215.95}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.97, ["Ride"] = 131.24, ["Fly|Ride"] = 280.37, ["Neon"] = 170.63, ["Neon|Ride"] = 278.34, ["Neon|Fly|Ride"] = 571.74, ["Mega"] = 1113.2, ["Mega|Fly|Ride"] = 1669.27}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 209.9, ["Ride"] = 443.63, ["Fly|Ride"] = 1579.27}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 46.99, ["Fly"] = 212.3, ["Ride"] = 98.44, ["Fly|Ride"] = 210.99, ["Neon"] = 269.99, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 423.62, ["Mega"] = 918.75, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1291.6}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.74, ["Fly"] = 1353.01, ["Ride"] = 1007.98, ["Fly|Ride"] = 978.7, ["Neon|Fly"] = 4096.11, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3425.9, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 393.65, ["Fly"] = 697.43, ["Ride"] = 413.44, ["Fly|Ride"] = 570.94, ["Neon"] = 2501.76, ["Neon|Ride"] = 2084.79, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 8347.34}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.67, ["Fly"] = 20.99, ["Ride"] = 23.42, ["Fly|Ride"] = 43.32, ["Neon"] = 78.74, ["Neon|Fly"] = 166.8, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 695.89, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 261.19, ["Fly"] = 525, ["Ride"] = 302.92, ["Fly|Ride"] = 380.63, ["Neon"] = 1083.07, ["Neon|Ride"] = 1034.1, ["Neon|Fly|Ride"] = 1092.34, ["Mega|Fly|Ride"] = 3227.95}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.72}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 139.01, ["Ride"] = 183.23, ["Fly|Ride"] = 285.6, ["Neon"] = 585.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 636.57, ["Mega"] = 2365.15, ["Mega|Ride"] = 11868.46, ["Mega|Fly|Ride"] = 3192.47}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 104.57, ["Fly"] = 105, ["Ride"] = 104.14, ["Fly|Ride"] = 208.49, ["Neon"] = 765.13, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 888.57, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3479.39, ["Mega|Fly|Ride"] = 2504.21}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.94, ["Ride"] = 27.63, ["Fly|Ride"] = 729.75, ["Neon"] = 27.57, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 320.3, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 833.61}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.93, ["Fly"] = 83.67, ["Ride"] = 27.13, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 99.73, ["Neon|Fly|Ride"] = 316.23, ["Mega|Ride"] = 812.75, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.76, ["Fly"] = 102.35, ["Ride"] = 39.82, ["Fly|Ride"] = 104.6, ["Neon"] = 65.62, ["Neon|Ride"] = 90.7, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 834.65}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.92, ["Fly"] = 131.23, ["Ride"] = 54.33, ["Fly|Ride"] = 278.34, ["Neon"] = 19.04, ["Neon|Ride"] = 68.93, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 140.43, ["Mega|Fly"] = 369.33, ["Mega|Ride"] = 170.52, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 269.07, ["Ride"] = 275.63, ["Fly|Ride"] = 354.38, ["Neon"] = 1640.73, ["Neon|Ride"] = 1347.23, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 140.33, ["Fly"] = 558.35, ["Ride"] = 185.33, ["Fly|Ride"] = 241.49, ["Neon"] = 703.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1173.27, ["Mega"] = 2086.6, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.56, ["Fly"] = 167.45, ["Ride"] = 69.34, ["Fly|Ride"] = 125.48, ["Neon"] = 393.75, ["Neon|Ride"] = 531.57, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.14}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 70.07, ["Fly|Ride"] = 278.34, ["Neon|Ride"] = 601.4, ["Neon|Fly|Ride"] = 487.24, ["Mega|Fly|Ride"] = 1949.12}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.82, ["Fly"] = 58.47, ["Ride"] = 33.53, ["Fly|Ride"] = 79.37, ["Neon"] = 77.44, ["Neon|Fly"] = 278.34, ["Neon|Ride"] = 123.02, ["Neon|Fly|Ride"] = 188.33, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.49, ["Fly"] = 26.25, ["Ride"] = 23.02, ["Fly|Ride"] = 44.05, ["Neon"] = 19.98, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 129.94, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 983.09, ["Fly"] = 1050, ["Ride"] = 914.82, ["Fly|Ride"] = 941.07, ["Neon|Fly"] = 3236.64, ["Neon|Ride"] = 8339.15, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10257.61}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.25, ["Ride"] = 354.38, ["Fly|Ride"] = 416.97, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 2086.6, ["Mega"] = 10432.88, ["Mega|Fly|Ride"] = 5843.14}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.18, ["Fly"] = 140.13, ["Ride"] = 103.64, ["Fly|Ride"] = 196.88, ["Neon"] = 339.94, ["Neon|Ride"] = 378.86, ["Neon|Fly|Ride"] = 586.35, ["Mega"] = 1312.5, ["Mega|Ride"] = 1669.27, ["Mega|Fly|Ride"] = 1784.82}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 217.5, ["Fly"] = 283.5, ["Ride"] = 220.58, ["Fly|Ride"] = 308.44, ["Neon|Fly|Ride"] = 1579.93, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 28.88, ["Fly|Ride"] = 76.13, ["Neon"] = 150.94, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 789.97}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.15, ["Ride"] = 249.38, ["Fly|Ride"] = 610.86, ["Neon"] = 1492.2, ["Neon|Ride"] = 918.37, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4152.59, ["Mega|Ride"] = 4590.48, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 44.62, ["Fly"] = 125.98, ["Ride"] = 75.45, ["Fly|Ride"] = 100.1, ["Neon|Fly|Ride"] = 557.12, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1967.44, ["Ride"] = 1837.5, ["Fly|Ride"] = 1820.44, ["Neon|Ride"] = 11049.98, ["Neon|Fly|Ride"] = 7234.17, ["Mega"] = 50077.8, ["Mega|Fly|Ride"] = 22537.78}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.63, ["Fly"] = 76.25, ["Ride"] = 34.06, ["Fly|Ride"] = 71.28, ["Neon"] = 51.89, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 375.6, ["Mega|Ride"] = 403.77, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.88, ["Ride"] = 82.62, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 320.03, ["Neon|Fly|Ride"] = 557.12, ["Mega"] = 1658.09, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 104.89, ["Fly"] = 78.7, ["Ride"] = 77.99, ["Fly|Ride"] = 106.32, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.71, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3018.75, ["Fly"] = 1584.64, ["Ride"] = 1115.63, ["Fly|Ride"] = 1133.16, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 580.32, ["Ride"] = 658.09, ["Neon|Fly|Ride"] = 4172.12}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 84.3, ["Fly"] = 317.19, ["Ride"] = 131.76, ["Fly|Ride"] = 278.34, ["Neon"] = 408.62, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2643.71, ["Mega|Fly|Ride"] = 2017.73}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.93, ["Ride"] = 22.32, ["Fly|Ride"] = 140.13, ["Neon"] = 69.16, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.29, ["Ride"] = 48.12, ["Fly|Ride"] = 104.25, ["Neon"] = 262.5, ["Neon|Fly"] = 327.33, ["Neon|Ride"] = 216.66, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 1706.25, ["Mega|Ride"] = 1669.27, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 796.59, ["Ride"] = 759.94, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 749.83}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6295.79, ["Fly|Ride"] = 5961.31, ["Neon"] = 42000, ["Neon|Ride"] = 29875.99, ["Neon|Fly|Ride"] = 23336.25, ["Mega|Fly|Ride"] = 89038.82}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 328.13, ["Fly"] = 496.12, ["Ride"] = 393.75, ["Fly|Ride"] = 413.02, ["Neon"] = 1667.85, ["Neon|Fly|Ride"] = 2190.92, ["Mega"] = 6258.7, ["Mega|Fly|Ride"] = 6634.23}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 91.82, ["Fly"] = 279.18, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon|Ride"] = 695.28, ["Neon|Fly|Ride"] = 621.81, ["Mega|Fly|Ride"] = 2143.98}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.03, ["Fly"] = 98.3, ["Ride"] = 37.26, ["Fly|Ride"] = 131.25, ["Neon"] = 111.55, ["Neon|Fly"] = 1263.18, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 972.36, ["Mega|Ride"] = 834.65, ["Mega|Fly|Ride"] = 807.53}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.02, ["Fly"] = 26.24, ["Ride"] = 21.39, ["Fly|Ride"] = 44.35, ["Neon|Ride"] = 316.1, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2226.67}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.69, ["Ride"] = 27.56, ["Fly|Ride"] = 120.75, ["Neon"] = 123.8, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 231.62, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.5, ["Ride"] = 19.88, ["Fly|Ride"] = 48.57, ["Neon"] = 35.43, ["Neon|Ride"] = 55.65, ["Neon|Fly|Ride"] = 137.72, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.49, ["Fly"] = 90.57, ["Ride"] = 34.12, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 833.94, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 630, ["Mega|Ride"] = 1246.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 422.46, ["Fly"] = 577.5, ["Ride"] = 437.07, ["Fly|Ride"] = 470.07, ["Neon"] = 1563.6, ["Neon|Ride"] = 1529.2, ["Neon|Fly|Ride"] = 1147.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5423.02}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 15.15, ["Fly|Ride"] = 31.5, ["Neon"] = 18.17, ["Neon|Ride"] = 23.27, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 834.65, ["Mega|Ride"] = 316.23, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.6, ["Fly"] = 102.11, ["Ride"] = 71.97, ["Fly|Ride"] = 127.32, ["Neon"] = 157.5, ["Neon|Fly"] = 428.45, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 255.7, ["Mega"] = 575.16, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 561.65}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 800.62, ["Fly|Ride"] = 824.15, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3934.88}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 43.32, ["Fly"] = 70.07, ["Ride"] = 39.5, ["Fly|Ride"] = 99.46, ["Neon|Ride"] = 235.28, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 392.11, ["Fly"] = 384.56, ["Ride"] = 290.76, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1579.27, ["Neon|Fly|Ride"] = 1460.62}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.19, ["Fly"] = 273.96, ["Ride"] = 194.85, ["Fly|Ride"] = 223.13, ["Neon"] = 903.76, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 859.69, ["Mega|Fly|Ride"] = 4965.02}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 869.54, ["Ride"] = 754.69, ["Fly|Ride"] = 918.37, ["Neon|Ride"] = 3655.68, ["Neon|Fly|Ride"] = 3045.37, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16, ["Ride"] = 39.38, ["Fly|Ride"] = 110.24, ["Neon"] = 104.25, ["Neon|Fly"] = 284.13, ["Neon|Ride"] = 107.75, ["Neon|Fly|Ride"] = 274.79, ["Mega"] = 354.38, ["Mega|Ride"] = 302.9, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3584.44, ["Neon"] = 13899.26, ["Neon|Fly|Ride"] = 7021.88, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 118.12, ["Fly"] = 166.28, ["Ride"] = 125.99, ["Fly|Ride"] = 161.21, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 3150.36}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.55, ["Ride"] = 19.79, ["Fly|Ride"] = 38.07, ["Neon"] = 19.81, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 144.85, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 359.63, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.39, ["Ride"] = 24.55, ["Fly|Ride"] = 57.71, ["Neon"] = 20.47, ["Neon|Fly"] = 116.03, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 146.69, ["Mega|Ride"] = 200.32, ["Mega|Fly|Ride"] = 328.94}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.38, ["Fly"] = 83.67, ["Ride"] = 39.36, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 945, ["Ride"] = 1171.08, ["Fly|Ride"] = 1250.88, ["Neon"] = 2918.71}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7105.86, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.34, ["Fly"] = 36.01, ["Ride"] = 24.65, ["Fly|Ride"] = 36.75, ["Neon"] = 452.13, ["Neon|Ride"] = 142.07, ["Neon|Fly|Ride"] = 199.17, ["Mega"] = 2503.91, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.52, ["Ride"] = 24.94, ["Fly|Ride"] = 74.43, ["Neon"] = 85.32, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 662.17, ["Mega|Ride"] = 789.97, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 74.8, ["Fly"] = 157.49, ["Ride"] = 85.31, ["Fly|Ride"] = 123.38, ["Neon|Ride"] = 583.75, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1697.85}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 262.54, ["Ride"] = 261.19, ["Fly|Ride"] = 344.61, ["Neon|Ride"] = 1608.43, ["Neon|Fly|Ride"] = 1000.13, ["Mega|Fly|Ride"] = 4579.86}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.68, ["Ride"] = 32.79, ["Fly|Ride"] = 93.19, ["Neon"] = 15.43, ["Neon|Fly"] = 69.85, ["Neon|Ride"] = 94.73, ["Mega"] = 160.13, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 283.79}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.49, ["Ride"] = 196.88, ["Fly|Ride"] = 288.75, ["Neon"] = 1000.13, ["Neon|Ride"] = 945.47, ["Neon|Fly|Ride"] = 939.92, ["Mega|Fly|Ride"] = 3461.64}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.62, ["Fly"] = 41.67, ["Ride"] = 14.43, ["Fly|Ride"] = 73.85, ["Neon"] = 19.69, ["Neon|Fly"] = 125.1, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 279.96, ["Ride"] = 223.13, ["Fly|Ride"] = 223.13, ["Neon|Fly|Ride"] = 772.01, ["Mega"] = 10432.88, ["Mega|Ride"] = 4869.03, ["Mega|Fly|Ride"] = 4866.5}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.11, ["Fly"] = 73.62, ["Ride"] = 28.24, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 300.71, ["Neon|Ride"] = 154.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 557.12, ["Mega|Ride"] = 625.99, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.84, ["Ride"] = 23.42, ["Neon"] = 10.49, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 177.09, ["Mega"] = 65.63, ["Mega|Ride"] = 103.06, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.51, ["Mega"] = 22.98, ["Mega|Ride"] = 150.25}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.05, ["Fly"] = 52.49, ["Ride"] = 33.34, ["Fly|Ride"] = 110.51, ["Neon"] = 7.53, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 70.42, ["Mega|Fly"] = 157912.82, ["Mega|Ride"] = 122, ["Mega|Fly|Ride"] = 205.59}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.69, ["Fly"] = 142.56, ["Ride"] = 116.45, ["Fly|Ride"] = 128.62, ["Neon"] = 236.8, ["Neon|Fly"] = 396.13, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 364.88, ["Mega|Fly|Ride"] = 1184.64}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.3, ["Ride"] = 15.74, ["Fly|Ride"] = 110.51, ["Neon"] = 8.68, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.02, ["Mega|Ride"] = 165.38}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.64, ["Neon"] = 159.84, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 417.34}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.35, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 13.12, ["Mega|Ride"] = 55.49, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.68, ["Fly"] = 61.13, ["Ride"] = 15.69, ["Fly|Ride"] = 42.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 37.91, ["Mega"] = 15.3, ["Mega|Fly"] = 31.32, ["Mega|Ride"] = 17.78, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.71, ["Fly|Ride"] = 64.13, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.24, ["Mega"] = 139.81, ["Mega|Fly"] = 158.71, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 95.81}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Ride"] = 63.67, ["Mega"] = 21.47, ["Mega|Ride"] = 121.85, ["Mega|Fly|Ride"] = 417.34}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.14, ["Fly"] = 91.84, ["Ride"] = 20.95, ["Fly|Ride"] = 107.62, ["Neon"] = 4.18, ["Neon|Fly"] = 167.96, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 24.09, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 417.34, ["Mega"] = 17.34, ["Mega|Fly"] = 135.64, ["Mega|Ride"] = 789.97}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.57, ["Fly"] = 77.44, ["Ride"] = 26.25, ["Fly|Ride"] = 70.12, ["Neon"] = 20.87, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 32.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.15, ["Mega|Fly"] = 126.39, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 196.27}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.48, ["Neon|Ride"] = 76.98, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 14.85, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 61.03, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 18.27, ["Mega"] = 162.74, ["Mega|Fly"] = 315, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 540.51}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.55, ["Neon"] = 16.7, ["Mega"] = 105, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.82, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 19.69, ["Mega|Ride"] = 50.1, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.78, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.03, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 32.12, ["Mega"] = 14.59, ["Mega|Fly"] = 60.42, ["Mega|Ride"] = 20.48, ["Mega|Fly|Ride"] = 49.86}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Neon"] = 37.4, ["Neon|Ride"] = 140.95, ["Mega"] = 179.82, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 26.46, ["Neon"] = 3.93, ["Neon|Ride"] = 26.44, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.25, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 171.11}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 14.18, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 94.4, ["Mega|Ride"] = 166.94, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 34.53, ["Fly|Ride"] = 189.73, ["Neon"] = 21.88, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 1.68, ["Fly"] = 12.56, ["Ride"] = 11.65, ["Fly|Ride"] = 26.28, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 13.99, ["Neon|Fly|Ride"] = 30.29, ["Mega"] = 13.85, ["Mega|Fly"] = 26.16, ["Mega|Ride"] = 20.99, ["Mega|Fly|Ride"] = 52.13}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 17.77, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 118.13, ["Mega|Ride"] = 158.71, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 22.93, ["Fly|Ride"] = 59.06, ["Neon"] = 55.89, ["Neon|Ride"] = 67.47, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.25, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 415.25}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 13, ["Fly|Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 13.13, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.63, ["Ride"] = 29.03, ["Neon"] = 7.88, ["Neon|Ride"] = 28.16, ["Neon|Fly|Ride"] = 165.89, ["Mega"] = 65.63, ["Mega|Fly"] = 166.94, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.91, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 142.13, ["Mega"] = 39.38, ["Mega|Fly"] = 139.81, ["Mega|Ride"] = 139.81, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 41.72, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 13.11, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 188.33}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.07, ["Ride"] = 23.62, ["Fly|Ride"] = 42.02, ["Neon"] = 11.48, ["Neon|Fly"] = 28.16, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 91.88, ["Mega|Ride"] = 94.77, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 56.47, ["Neon"] = 6.36, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 695.89, ["Mega"] = 35.02, ["Mega|Ride"] = 104.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.02, ["Ride"] = 17.81, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 35.54, ["Neon|Fly|Ride"] = 84, ["Mega"] = 103.69, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 13.13, ["Ride"] = 36.27, ["Neon"] = 30.49, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.75, ["Fly|Ride"] = 57.48, ["Neon"] = 33.7, ["Neon|Fly"] = 56.31, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 226.23}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.5, ["Ride"] = 21.55, ["Fly|Ride"] = 49.01, ["Neon"] = 15.75, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 72.17, ["Mega|Fly"] = 207.63, ["Mega|Ride"] = 417.34, ["Mega|Fly|Ride"] = 230.58}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.84, ["Neon"] = 27.57, ["Mega"] = 222.38, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.81, ["Ride"] = 56.44, ["Neon"] = 262.5, ["Neon|Ride"] = 236.79, ["Mega|Ride"] = 695.89, ["Mega|Fly|Ride"] = 791.98}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.66, ["Ride"] = 27.78, ["Neon"] = 41.67, ["Neon|Ride"] = 125.1, ["Mega"] = 238.88, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 11.12, ["Ride"] = 31.4, ["Neon"] = 158.65, ["Neon|Ride"] = 103.22, ["Mega"] = 473.74, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.01, ["Mega"] = 30.96, ["Mega|Fly"] = 62.62, ["Mega|Ride"] = 125.22, ["Mega|Fly|Ride"] = 156.52}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.04}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.24, ["Fly"] = 23.61, ["Ride"] = 20.15, ["Fly|Ride"] = 49.01, ["Neon"] = 53.16, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 78.63, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 290.05}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.02, ["Neon"] = 3.35, ["Neon|Fly"] = 31.99, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 156.35, ["Mega"] = 24.92, ["Mega|Fly"] = 139.81, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Ride"] = 48.12, ["Neon"] = 10.35, ["Neon|Ride"] = 33.1, ["Mega"] = 78.74, ["Mega|Ride"] = 73.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 18.83, ["Fly|Ride"] = 55.65, ["Neon"] = 15.65, ["Neon|Ride"] = 28.42, ["Neon|Fly|Ride"] = 126.74, ["Mega"] = 141.75, ["Mega|Ride"] = 158.71, ["Mega|Fly|Ride"] = 171.13}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 8.34, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 35.05, ["Neon|Ride"] = 131.06, ["Mega"] = 417.34, ["Mega|Ride"] = 278.57}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 83.67, ["Ride"] = 31.82, ["Neon"] = 3.93, ["Mega"] = 20.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.09, ["Mega|Fly|Ride"] = 333.87}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 16.49, ["Fly|Ride"] = 32.82, ["Neon"] = 2.85, ["Neon|Fly"] = 111.29, ["Neon|Ride"] = 20.87, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 30.78, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 47.67, ["Mega|Fly|Ride"] = 128.35}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 13.16, ["Fly|Ride"] = 41.72, ["Neon"] = 3.93, ["Neon|Fly"] = 91.18, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 81.39, ["Mega|Fly"] = 139.81, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 158.71}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 53.34, ["Fly|Ride"] = 139.7, ["Neon"] = 7.87, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 111.64, ["Mega"] = 32.36, ["Mega|Ride"] = 99.28, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.41, ["Neon|Ride"] = 166.8, ["Neon|Fly|Ride"] = 152541.84, ["Mega"] = 18.78, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 110.29, ["Mega|Fly|Ride"] = 417.34}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 16.97, ["Fly|Ride"] = 79.24, ["Neon"] = 3.04, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 85.29, ["Mega"] = 21.32, ["Mega|Ride"] = 41.47, ["Mega|Fly|Ride"] = 98.46}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 36.74, ["Mega"] = 22.39, ["Mega|Ride"] = 411.22}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.55, ["Neon"] = 2.1, ["Neon|Ride"] = 316.1, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19.69, ["Mega|Ride"] = 158.71}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 30.12, ["Fly|Ride"] = 56.31, ["Neon"] = 3.89, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 41.75, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.99, ["Ride"] = 77.96, ["Neon"] = 147, ["Mega"] = 435.75, ["Mega|Ride"] = 666.75}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.14, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 41.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.13, ["Ride"] = 30.5, ["Fly|Ride"] = 177.22, ["Mega"] = 397.95, ["Mega|Ride"] = 356.83, ["Mega|Fly|Ride"] = 375.27}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.98, ["Ride"] = 15.69, ["Fly|Ride"] = 24.9, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 10.43, ["Neon|Fly|Ride"] = 25.69, ["Mega"] = 12.97, ["Mega|Fly"] = 22.8, ["Mega|Ride"] = 20.5, ["Mega|Fly|Ride"] = 50.96}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.55, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Fly"] = 66.72, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 695.89, ["Mega"] = 85.32, ["Mega|Ride"] = 67.52}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 31.28, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.42, ["Mega|Fly"] = 124.17, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 132.54}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 127.32, ["Mega"] = 17.88, ["Mega|Fly|Ride"] = 166.95}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 16.87, ["Fly|Ride"] = 40.27, ["Neon"] = 10.91, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 91.6, ["Mega"] = 208.95, ["Mega|Ride"] = 396.46, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 178.26, ["Fly"] = 183.75, ["Ride"] = 196.67, ["Fly|Ride"] = 833.94, ["Neon|Fly|Ride"] = 926.45, ["Mega"] = 8346.31, ["Mega|Fly|Ride"] = 3949.79}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 10.5, ["Neon|Ride"] = 64.32, ["Mega"] = 91.88, ["Mega|Ride"] = 111.34, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.49, ["Fly"] = 103.68, ["Ride"] = 26.15, ["Fly|Ride"] = 65.63, ["Neon"] = 24.94, ["Neon|Ride"] = 94.77, ["Neon|Fly|Ride"] = 166.94, ["Mega"] = 374.07, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 413.2}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 14.89, ["Ride"] = 13.55, ["Fly|Ride"] = 32.79, ["Neon"] = 3.92, ["Neon|Fly"] = 28.16, ["Neon|Ride"] = 29.46, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.88, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.07, ["Ride"] = 19.69, ["Fly|Ride"] = 92.57, ["Neon"] = 6.36, ["Neon|Ride"] = 78.46, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 189.52}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.44, ["Fly"] = 23.49, ["Ride"] = 15.01, ["Fly|Ride"] = 36, ["Neon"] = 23.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 107.79, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.96, ["Ride"] = 41.84, ["Fly|Ride"] = 252.27, ["Neon"] = 91.88, ["Neon|Ride"] = 140.72, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 353.69, ["Mega|Ride"] = 382.46, ["Mega|Fly|Ride"] = 1043.31}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 13.13, ["Fly|Ride"] = 35.26, ["Neon"] = 19.85, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 76.13, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 245.77}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 61.68, ["Fly"] = 121.3, ["Ride"] = 86.47, ["Fly|Ride"] = 140.93, ["Neon"] = 382.57, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1579.93}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 334.61, ["Ride"] = 249.23, ["Fly|Ride"] = 315, ["Neon|Ride"] = 2605.99, ["Neon|Fly|Ride"] = 906.46, ["Mega"] = 10432.88, ["Mega|Fly|Ride"] = 4824.77}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.71, ["Fly"] = 140.13, ["Ride"] = 68.25, ["Fly|Ride"] = 105, ["Neon"] = 710.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 1286.72}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.94, ["Fly"] = 288.42, ["Ride"] = 36.61, ["Fly|Ride"] = 137.67, ["Neon"] = 23.55, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 309.72, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.49, ["Fly"] = 70.07, ["Ride"] = 31.5, ["Fly|Ride"] = 71.05, ["Neon"] = 81.37, ["Neon|Ride"] = 54.84, ["Mega"] = 353.07, ["Mega|Ride"] = 387.21, ["Mega|Fly|Ride"] = 1251.96}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.81, ["Fly|Ride"] = 44.51, ["Neon"] = 4.04, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 58.83, ["Mega"] = 52.35, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.15, ["Fly"] = 90.29, ["Ride"] = 20.89, ["Fly|Ride"] = 81.38, ["Neon"] = 123.69, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 413.44, ["Mega|Ride"] = 1018.5, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.21, ["Fly|Ride"] = 35.44, ["Neon"] = 11.81, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 181.55, ["Mega|Ride"] = 219.11, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.08, ["Ride"] = 27.34, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 35.46, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 375.6}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.47, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.44, ["Mega|Ride"] = 41.75, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.85, ["Fly|Ride"] = 41.72, ["Neon"] = 15.75, ["Neon|Fly"] = 104.25, ["Neon|Ride"] = 35.46, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 108.94, ["Mega|Ride"] = 194.07, ["Mega|Fly|Ride"] = 158.76}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.53, ["Neon"] = 47.25, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 198.24, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.12, ["Fly"] = 154.34, ["Ride"] = 157.5, ["Fly|Ride"] = 216.57, ["Neon"] = 673.4, ["Neon|Ride"] = 560.44, ["Neon|Fly|Ride"] = 632.63, ["Mega"] = 4173.17, ["Mega|Ride"] = 2643.71, ["Mega|Fly|Ride"] = 2035.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.12, ["Ride"] = 32.43, ["Fly|Ride"] = 208.49, ["Neon"] = 42, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 339.92, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 17.07, ["Fly|Ride"] = 36.01, ["Neon"] = 13, ["Neon|Ride"] = 28.16, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 236.88, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.55, ["Ride"] = 56.47, ["Fly|Ride"] = 170.63, ["Neon"] = 177.19, ["Neon|Fly|Ride"] = 578.96, ["Mega"] = 551.25, ["Mega|Fly"] = 834.65, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.85}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 28.88, ["Fly|Ride"] = 115.5, ["Neon"] = 52.5, ["Neon|Ride"] = 122.75, ["Neon|Fly|Ride"] = 348.47, ["Mega"] = 321.35, ["Mega|Ride"] = 390.21, ["Mega|Fly|Ride"] = 869.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.11, ["Fly"] = 26.2, ["Ride"] = 30.18, ["Fly|Ride"] = 49.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 208.49, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2086.6, ["Mega|Fly|Ride"] = 694.84}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 24.06, ["Neon"] = 3.71, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 106.28, ["Mega"] = 28.28, ["Mega|Ride"] = 62.51, ["Mega|Fly|Ride"] = 228.69}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.28, ["Fly"] = 28.24, ["Ride"] = 25.11, ["Fly|Ride"] = 65.63, ["Neon"] = 45.85, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 236.79, ["Mega"] = 268.86, ["Mega|Fly"] = 395.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.02, ["Fly|Ride"] = 47.57, ["Neon"] = 14.22, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 174.24, ["Mega|Ride"] = 182.23, ["Mega|Fly|Ride"] = 271.68}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 78.2, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 24.2, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 181.55}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.77, ["Ride"] = 74.44, ["Fly|Ride"] = 142.07, ["Neon"] = 357, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 729.28, ["Mega|Fly|Ride"] = 965.69}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.35, ["Ride"] = 83.67, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 139.7, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.51, ["Fly"] = 36.61, ["Ride"] = 21.36, ["Fly|Ride"] = 52.29, ["Neon"] = 26.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 333.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.04, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.48, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2060.77}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.17, ["Fly"] = 32.7, ["Ride"] = 23.15, ["Fly|Ride"] = 57.64, ["Neon"] = 46.05, ["Neon|Ride"] = 52.95, ["Neon|Fly|Ride"] = 278.02, ["Mega"] = 271.93, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 690.67}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.8, ["Fly"] = 163.13, ["Ride"] = 104.99, ["Neon"] = 270.38, ["Neon|Ride"] = 223.12, ["Mega"] = 1224.84, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1072.87}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 14.6, ["Ride"] = 53.91, ["Fly|Ride"] = 139.7, ["Neon"] = 72.16, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 212.77, ["Mega"] = 590.63, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.61, ["Fly"] = 104.13, ["Ride"] = 28.24, ["Fly|Ride"] = 62.75, ["Neon"] = 49.7, ["Neon|Ride"] = 90.56, ["Neon|Fly|Ride"] = 369.53, ["Mega"] = 208.68, ["Mega|Ride"] = 1564.95, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.2, ["Ride"] = 60.93, ["Fly|Ride"] = 162.54, ["Neon"] = 66.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 300.83, ["Mega|Ride"] = 307.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.84, ["Ride"] = 24.8, ["Fly|Ride"] = 87.39, ["Neon"] = 31.15, ["Neon|Ride"] = 83.21, ["Neon|Fly|Ride"] = 187.81, ["Mega"] = 236.25, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2, ["Mega"] = 26.24, ["Mega|Ride"] = 125.22, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 8.37, ["Ride"] = 28.42, ["Neon"] = 23.78, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 105, ["Mega|Ride"] = 274.4, ["Mega|Fly|Ride"] = 415.29}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.44, ["Neon"] = 27.2, ["Mega"] = 189.52, ["Mega|Ride"] = 137.72, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.8, ["Ride"] = 32.79, ["Fly|Ride"] = 118.4, ["Neon"] = 31.28, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 574.01, ["Ride"] = 565.9, ["Fly|Ride"] = 711.55, ["Neon|Ride"] = 1802.07, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.19, ["Fly"] = 28.24, ["Ride"] = 24.06, ["Fly|Ride"] = 56.35, ["Neon"] = 40.67, ["Neon|Ride"] = 97.79, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 158.45, ["Mega|Ride"] = 363.61, ["Mega|Fly|Ride"] = 473.72}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.03, ["Fly"] = 524.69, ["Ride"] = 31.12, ["Fly|Ride"] = 51.55, ["Neon"] = 48.57, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 158.71, ["Mega"] = 331.86, ["Mega|Ride"] = 444.46, ["Mega|Fly|Ride"] = 542.53}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 28.24, ["Fly|Ride"] = 312.73, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 158.71}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 21.84, ["Fly|Ride"] = 90.57, ["Neon"] = 6.28, ["Neon|Ride"] = 29.91, ["Neon|Fly|Ride"] = 86.91, ["Mega"] = 64.32, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.07, ["Ride"] = 17.07, ["Neon"] = 2.89, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 125.22, ["Mega"] = 18.4, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.07}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 9.53, ["Ride"] = 49.38, ["Fly|Ride"] = 52.5, ["Neon"] = 65.62, ["Neon|Ride"] = 91.75, ["Mega"] = 557.12, ["Mega|Ride"] = 568.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 6.01, ["Neon|Ride"] = 56.44, ["Mega"] = 39.37, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 268.94}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 385.81, ["Ride"] = 126.84, ["Neon"] = 22.23, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.98, ["Ride"] = 472.5, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1415.74, ["Neon|Fly|Ride"] = 2089.19, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.29, ["Fly"] = 196.88, ["Ride"] = 56.47, ["Fly|Ride"] = 416.97, ["Neon"] = 36.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 189.52, ["Mega"] = 520.62, ["Mega|Ride"] = 473.74, ["Mega|Fly|Ride"] = 695.23}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.33, ["Ride"] = 22.3, ["Fly|Ride"] = 118.13, ["Neon"] = 2.1, ["Neon|Ride"] = 35.78, ["Neon|Fly|Ride"] = 146.88, ["Mega"] = 37.05, ["Mega|Fly"] = 125.22, ["Mega|Ride"] = 71.54, ["Mega|Fly|Ride"] = 274.79}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 28.39, ["Mega"] = 32.71, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.27, ["Fly"] = 107.9, ["Ride"] = 80.05, ["Fly|Ride"] = 87.28, ["Neon"] = 127.45, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 230.86, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 498.7, ["Mega|Ride"] = 621.81, ["Mega|Fly|Ride"] = 602.44}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.05, ["Neon"] = 80.12, ["Neon|Ride"] = 158.65, ["Neon|Fly|Ride"] = 534.15, ["Mega"] = 575.92, ["Mega|Ride"] = 473.74}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.3, ["Ride"] = 31.38, ["Neon"] = 131.25, ["Neon|Ride"] = 178.78, ["Mega"] = 647.84, ["Mega|Fly|Ride"] = 1252.12}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.56, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 616.88, ["Mega|Ride"] = 522.32, ["Mega|Fly|Ride"] = 695.89}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Neon"] = 1115.63, ["Neon|Ride"] = 1183.86, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4005.46}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.29, ["Fly"] = 78.73, ["Ride"] = 20.01, ["Fly|Ride"] = 236.25, ["Neon"] = 144.04, ["Neon|Ride"] = 207.44, ["Neon|Fly|Ride"] = 193.86, ["Mega"] = 751.19, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 721.02}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.94, ["Ride"] = 126, ["Neon"] = 65.63, ["Neon|Ride"] = 221.82, ["Mega"] = 189.52, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 1043.43}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.22, ["Fly"] = 140.13, ["Ride"] = 70.88, ["Neon"] = 80.03, ["Neon|Ride"] = 151.99, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 301.76, ["Mega|Fly"] = 695.89, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Fly|Ride"] = 140.13, ["Neon"] = 6.48, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 269.18, ["Mega"] = 36.87, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.07, ["Ride"] = 78.75, ["Neon"] = 315, ["Neon|Ride"] = 415.93, ["Neon|Fly|Ride"] = 460.1, ["Mega"] = 2503.91, ["Mega|Ride"] = 2762.64, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 8.02, ["Neon|Fly"] = 181.39, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 119.28, ["Mega"] = 78.19, ["Mega|Ride"] = 105.6, ["Mega|Fly|Ride"] = 236.88}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 28.55, ["Neon"] = 3.83, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 46.18, ["Neon|Fly|Ride"] = 90.78, ["Mega"] = 38.33, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 75.48, ["Mega|Fly|Ride"] = 170.46}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 14.44, ["Neon|Ride"] = 53.73, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 111.34, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.88, ["Fly"] = 95.05, ["Ride"] = 60.25, ["Fly|Ride"] = 169.32, ["Neon"] = 291.38, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 473.74, ["Mega|Ride"] = 1113.2, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 259.32, ["Ride"] = 309.75, ["Fly|Ride"] = 415.93, ["Neon"] = 1462.13, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1494, ["Mega"] = 4200, ["Mega|Fly|Ride"] = 4417.88}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.52, ["Neon"] = 51.1, ["Neon|Fly"] = 350.44, ["Mega"] = 98.15, ["Mega|Ride"] = 139.81}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 10.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 159.2, ["Ride"] = 27.57, ["Fly|Ride"] = 95.82, ["Neon"] = 32.82, ["Neon|Ride"] = 69.85, ["Mega"] = 170.63, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.88, ["Fly"] = 71.12, ["Ride"] = 33.47, ["Fly|Ride"] = 69.8, ["Neon"] = 11.45, ["Neon|Ride"] = 61.52, ["Neon|Fly|Ride"] = 154.43, ["Mega"] = 109.1, ["Mega|Ride"] = 164.42, ["Mega|Fly|Ride"] = 255.83}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 190.94, ["Mega"] = 40.2, ["Mega|Fly|Ride"] = 345.34}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 18.38, ["Fly|Ride"] = 51.19, ["Neon"] = 5.19, ["Neon|Fly"] = 79.33, ["Neon|Ride"] = 28.16, ["Neon|Fly|Ride"] = 417.34, ["Mega"] = 39.38, ["Mega|Ride"] = 101.88, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.92, ["Fly|Ride"] = 28.16, ["Neon"] = 13.12, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 26.57, ["Neon|Fly|Ride"] = 94.77, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 29.29, ["Fly"] = 52.5, ["Ride"] = 31.37, ["Fly|Ride"] = 78.73, ["Neon"] = 194.95, ["Neon|Ride"] = 291.88, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.24}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Ride"] = 78.65, ["Fly|Ride"] = 139.7, ["Neon"] = 840, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3158.65, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 2.69, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 37.92, ["Mega|Fly"] = 672, ["Mega|Ride"] = 93.19}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14, ["Ride"] = 14.17, ["Fly|Ride"] = 20.92, ["Neon"] = 3.72, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.78, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 50.94, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.71, ["Ride"] = 73.5, ["Neon"] = 39.38, ["Neon|Ride"] = 142.07, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 687.53, ["Mega|Fly|Ride"] = 632.45}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1894.16, ["Mega|Fly|Ride"] = 7896}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 27.18, ["Fly"] = 101.33, ["Ride"] = 47.57, ["Fly|Ride"] = 108.94, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.81, ["Mega|Ride"] = 1251.96}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21.2, ["Fly|Ride"] = 281.31, ["Neon"] = 8.17, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 169.02, ["Mega"] = 85.04, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 264.22}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.77, ["Neon|Ride"] = 72.34, ["Mega"] = 328.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.46, ["Fly"] = 170.63, ["Ride"] = 48.12, ["Fly|Ride"] = 52.5, ["Neon"] = 194.25, ["Neon|Ride"] = 354.42, ["Neon|Fly|Ride"] = 316.23, ["Mega"] = 2503.91, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1199.93}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.16, ["Ride"] = 111.16, ["Fly|Ride"] = 416.97, ["Neon"] = 434.43, ["Neon|Ride"] = 554.56, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8346.31, ["Mega|Fly|Ride"] = 6260.51}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 190.21, ["Ride"] = 271.1, ["Fly|Ride"] = 520.16, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.18, ["Fly"] = 56.47, ["Ride"] = 62.75, ["Fly|Ride"] = 96.17, ["Neon"] = 78.75, ["Neon|Ride"] = 122.07, ["Mega"] = 388.49, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 512.3}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 15.75, ["Fly|Ride"] = 43.2, ["Neon"] = 11.69, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 90.78, ["Mega"] = 93.19, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.43}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 16.02, ["Fly|Ride"] = 59.21, ["Neon"] = 80.07, ["Neon|Fly"] = 145.94, ["Neon|Ride"] = 44.51, ["Neon|Fly|Ride"] = 79.36, ["Mega"] = 381.09, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.63, ["Fly"] = 488.31, ["Ride"] = 368.19, ["Fly|Ride"] = 617.11, ["Neon"] = 1575, ["Neon|Ride"] = 2150.36, ["Mega"] = 10015.57, ["Mega|Fly|Ride"] = 5811.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 35.44, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.29, ["Fly"] = 697.43, ["Ride"] = 15.73, ["Fly|Ride"] = 55.13, ["Neon"] = 26.17, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 230.58, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 16.03, ["Ride"] = 70.51, ["Neon"] = 111.55, ["Neon|Ride"] = 236.25, ["Mega"] = 521.18, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.38, ["Fly"] = 157.5, ["Ride"] = 109.4, ["Fly|Ride"] = 127.03, ["Neon"] = 645.26, ["Neon|Ride"] = 556.65, ["Neon|Fly|Ride"] = 586.34, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.92, ["Fly"] = 43.29, ["Ride"] = 23, ["Fly|Ride"] = 57.75, ["Neon"] = 104.25, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 695.89, ["Mega|Ride"] = 471.19, ["Mega|Fly|Ride"] = 727.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.84, ["Neon"] = 2.49, ["Neon|Ride"] = 139.7, ["Mega"] = 24.93, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 69.85, ["Neon"] = 2.23, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 27.15, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.4, ["Ride"] = 74, ["Fly|Ride"] = 136.85, ["Neon"] = 35.06, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 181.9, ["Mega"] = 140.75, ["Mega|Fly"] = 278.57, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1455.57, ["Ride"] = 1443.73, ["Fly|Ride"] = 1455.57, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 3976.88, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 500.1, ["Fly|Ride"] = 717.42, ["Neon"] = 2447.55, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 16692.61}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 316.04, ["Ride"] = 341.25, ["Fly|Ride"] = 429.18, ["Neon"] = 656.25, ["Neon|Ride"] = 803.36, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 277.94, ["Ride"] = 321.57, ["Fly|Ride"] = 482.65, ["Neon"] = 1390.56, ["Neon|Ride"] = 932.96, ["Neon|Fly|Ride"] = 1036.88, ["Mega|Fly|Ride"] = 4173.17}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.64, ["Fly|Ride"] = 37.3, ["Neon"] = 7.88, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.47, ["Mega|Fly"] = 98.09, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 328.13, ["Fly"] = 1394.82, ["Ride"] = 404.65, ["Fly|Ride"] = 943.95, ["Neon"] = 1574.99, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1946.79, ["Mega|Ride"] = 6677.05, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.41, ["Fly"] = 157.5, ["Ride"] = 40.8, ["Neon"] = 17.64, ["Neon|Ride"] = 207.34, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.36, ["Mega|Ride"] = 312.3, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 20.92, ["Fly|Ride"] = 31.98, ["Neon"] = 8.35, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 111.64, ["Mega"] = 105, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 145.03}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.69, ["Neon|Ride"] = 39.36, ["Mega"] = 40.28, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 79.22, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7919.63, ["Ride"] = 28.53, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.54, ["Neon|Ride"] = 41.72, ["Neon|Fly|Ride"] = 94.89, ["Mega"] = 26.04, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 160.28}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 18.75, ["Fly|Ride"] = 78.65, ["Neon"] = 10.66, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 76.55, ["Mega"] = 129.51, ["Mega|Fly"] = 473.74, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 154.29, ["Neon|Ride"] = 158.71, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.11, ["Ride"] = 62.75, ["Neon"] = 115.5, ["Mega"] = 514.02, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6336.18, ["Ride"] = 19.69, ["Neon"] = 63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 710.62, ["Mega"] = 301.88, ["Mega|Ride"] = 487.24, ["Mega|Fly|Ride"] = 402.94}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 95.16, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.16, ["Neon|Fly"] = 31.28, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 75.13, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 313.04}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 157.4, ["Ride"] = 164.07, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 970.48, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 8346.31, ["Mega|Ride"] = 4173.17, ["Mega|Fly|Ride"] = 3475.5}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.42, ["Fly|Ride"] = 28.61, ["Neon"] = 2.56, ["Neon|Fly"] = 52.14, ["Neon|Ride"] = 21.97, ["Neon|Fly|Ride"] = 56.36, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.08, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 134.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 312.38, ["Mega|Fly"] = 789.97, ["Mega|Fly|Ride"] = 695.89}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.8, ["Fly"] = 262.5, ["Ride"] = 279.18, ["Fly|Ride"] = 170.63, ["Neon"] = 208.49, ["Neon|Ride"] = 270.21, ["Neon|Fly|Ride"] = 236.88, ["Mega"] = 974.45, ["Mega|Ride"] = 834.65, ["Mega|Fly|Ride"] = 830.58}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.89, ["Ride"] = 213.93, ["Fly|Ride"] = 261.19, ["Neon"] = 761.25, ["Neon|Ride"] = 923.57, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3366.7}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21.52, ["Fly|Ride"] = 139.7, ["Neon"] = 91.87, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.89}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.06, ["Ride"] = 210, ["Fly|Ride"] = 181.39, ["Neon"] = 416.97, ["Neon|Fly"] = 158.65, ["Neon|Ride"] = 198.9, ["Mega"] = 789.97, ["Mega|Ride"] = 834.65}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1050, ["Ride"] = 1049.99, ["Fly|Ride"] = 1590.71, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4794.97, ["Mega|Fly|Ride"] = 19057.74}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 13.13, ["Fly"] = 19.69, ["Ride"] = 19.8, ["Fly|Ride"] = 43.32, ["Neon"] = 70.88, ["Neon|Fly"] = 106.05, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 221.49, ["Mega|Fly|Ride"] = 390.21}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.8, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 35.21, ["Neon|Ride"] = 65.68, ["Mega"] = 202.41, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.17}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.62, ["Ride"] = 26.23, ["Fly|Ride"] = 94.54, ["Neon"] = 10.5, ["Neon|Ride"] = 47.16, ["Mega"] = 199.66, ["Mega|Ride"] = 240.62}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.3, ["Ride"] = 32.46, ["Fly|Ride"] = 86.63, ["Neon"] = 77.42, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 417.34, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 8.37, ["Fly"] = 20.45, ["Ride"] = 23.02, ["Fly|Ride"] = 51.19, ["Neon"] = 16.76, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 55.68, ["Mega|Fly"] = 250.41, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.94, ["Neon"] = 12.31, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 142.13, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 231, ["Fly|Ride"] = 2084.79, ["Neon|Fly|Ride"] = 1391.76}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.8, ["Fly|Ride"] = 72.19, ["Neon"] = 6.18, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 157.56, ["Mega"] = 277.53, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.19, ["Ride"] = 82.02, ["Fly|Ride"] = 88.87, ["Neon"] = 139.7, ["Neon|Ride"] = 188.27, ["Mega"] = 125.22, ["Mega|Ride"] = 236.88}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.92, ["Fly"] = 98.3, ["Ride"] = 21, ["Neon"] = 20.9, ["Neon|Ride"] = 52.49, ["Mega"] = 99.75, ["Mega|Fly"] = 142.13, ["Mega|Ride"] = 142.13, ["Mega|Fly|Ride"] = 506.91}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 181.75, ["Fly|Ride"] = 558.35, ["Neon|Ride"] = 1968.75, ["Mega|Ride"] = 4173.17, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.53, ["Ride"] = 57.04, ["Fly|Ride"] = 223.09, ["Neon"] = 181.33, ["Neon|Fly|Ride"] = 355.36, ["Mega"] = 564.38, ["Mega|Ride"] = 884.72, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.02, ["Fly"] = 317.19, ["Ride"] = 32.37, ["Fly|Ride"] = 90.57, ["Neon"] = 96.67, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 432.16, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.1, ["Mega|Ride"] = 221.19, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 44.58, ["Fly"] = 96.22, ["Ride"] = 90.57, ["Fly|Ride"] = 153.74, ["Neon"] = 262.5, ["Neon|Fly"] = 245.85, ["Neon|Ride"] = 236.91, ["Neon|Fly|Ride"] = 292.58, ["Mega|Fly|Ride"] = 1183.1}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 35.36, ["Neon"] = 5, ["Neon|Ride"] = 56.31, ["Neon|Fly|Ride"] = 124.17, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.11, ["Fly"] = 127.13, ["Ride"] = 19.78, ["Fly|Ride"] = 85.24, ["Neon"] = 66.19, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 325.7, ["Mega|Fly|Ride"] = 632.45}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.8, ["Fly"] = 65.63, ["Ride"] = 102.47, ["Fly|Ride"] = 151.26, ["Neon"] = 183.75, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 416.29, ["Mega|Ride"] = 1948.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 15.69, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 23.99, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.47, ["Mega|Fly"] = 118.46, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 52.29, ["Fly|Ride"] = 131.36, ["Neon"] = 16.7, ["Neon|Ride"] = 56.31, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 236.83, ["Mega|Ride"] = 277.15, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.79, ["Ride"] = 52.61, ["Fly|Ride"] = 85.32, ["Neon"] = 110.14, ["Neon|Ride"] = 556.65, ["Mega"] = 536.82, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.63, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.54, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 175.31}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.56, ["Fly"] = 210, ["Ride"] = 59.07, ["Fly|Ride"] = 171.49, ["Neon"] = 60.29, ["Neon|Ride"] = 172.57, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 534.18, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 471.35, ["Mega|Fly|Ride"] = 656.14}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 6.57, ["Fly"] = 41.84, ["Ride"] = 26.48, ["Fly|Ride"] = 98.44, ["Neon"] = 408.98, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.31, ["Neon"] = 39.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 74.34, ["Mega"] = 196.88, ["Mega|Ride"] = 244.12, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.08, ["Fly"] = 2091.2, ["Ride"] = 84, ["Fly|Ride"] = 238.64, ["Neon"] = 118.02, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6316.1, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 991.14}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 25.11, ["Fly|Ride"] = 196.88, ["Neon"] = 6.56, ["Neon|Ride"] = 32.43, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 148.32}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 4.71, ["Mega"] = 26.25, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 256.98}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.21}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.54, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 237.68, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1669.27, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 110.51, ["Mega"] = 18.97, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 634.34, ["Fly|Ride"] = 789.65, ["Neon"] = 2780.07, ["Mega"] = 16692.61, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.94, ["Fly"] = 26.24, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 32.84, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 89.51, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 557.2}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 21.75, ["Fly|Ride"] = 69.33, ["Neon"] = 31.28, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 125.22, ["Mega"] = 164.07, ["Mega|Ride"] = 256.67, ["Mega|Fly|Ride"] = 237.18}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.67, ["Fly"] = 70.07, ["Ride"] = 50.21, ["Fly|Ride"] = 68.17, ["Neon"] = 100.73, ["Neon|Ride"] = 169.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 821.08, ["Mega|Ride"] = 553.1, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Ride"] = 38.57, ["Fly|Ride"] = 721.88, ["Neon"] = 30.24, ["Neon|Ride"] = 118.12, ["Mega"] = 262.5}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.95, ["Fly"] = 139.53, ["Ride"] = 42, ["Fly|Ride"] = 173.24, ["Neon"] = 64.56, ["Neon|Ride"] = 207.44, ["Neon|Fly|Ride"] = 359.28, ["Mega"] = 416.5, ["Mega|Ride"] = 500.79, ["Mega|Fly|Ride"] = 487.24}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 2.5, ["Ride"] = 52.99, ["Fly|Ride"] = 133.88, ["Neon"] = 31.9, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 207.63, ["Mega"] = 557.12, ["Mega|Fly"] = 557.12, ["Mega|Ride"] = 417.34, ["Mega|Fly|Ride"] = 384.79}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.54, ["Ride"] = 13.54, ["Fly|Ride"] = 70.07, ["Neon"] = 2.1, ["Neon|Fly"] = 59.43, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 15.75, ["Mega|Ride"] = 24.94}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.75, ["Fly"] = 53.34, ["Ride"] = 32.71, ["Fly|Ride"] = 104.25, ["Neon"] = 39.22, ["Neon|Fly"] = 118.4, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 223.28, ["Mega"] = 196.85, ["Mega|Ride"] = 217.88}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 311.95, ["Ride"] = 308.41, ["Fly|Ride"] = 421.32, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9190.5, ["Mega|Fly|Ride"] = 5086.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.21, ["Ride"] = 140.13, ["Fly|Ride"] = 278.34, ["Neon"] = 556.65, ["Neon|Ride"] = 556.65, ["Neon|Fly|Ride"] = 542.53, ["Mega"] = 2226.38, ["Mega|Ride"] = 1796.55, ["Mega|Fly|Ride"] = 1665.91}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.32, ["Fly|Ride"] = 41.84, ["Neon"] = 8.39, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 31.99, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 207.63, ["Mega|Ride"] = 158.71, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.29, ["Fly|Ride"] = 34.17, ["Neon"] = 10.34, ["Neon|Fly"] = 41.72, ["Neon|Ride"] = 19.83, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 65.63, ["Mega|Fly"] = 278.57, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85, ["Mega"] = 271.27}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 243.89, ["Fly"] = 420, ["Ride"] = 253.32, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1059.09, ["Neon|Fly|Ride"] = 1544.07, ["Mega|Ride"] = 8346.31, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 21.39, ["Ride"] = 13.55, ["Fly|Ride"] = 35.22, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.52, ["Ride"] = 94.56, ["Fly|Ride"] = 209.13, ["Neon"] = 69.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 299.25, ["Mega|Ride"] = 307.79, ["Mega|Fly|Ride"] = 400.63}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.24, ["Neon"] = 5.93, ["Neon|Ride"] = 155.81, ["Mega"] = 85.04, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.38, ["Fly"] = 26.25, ["Ride"] = 19.56, ["Fly|Ride"] = 101.75, ["Neon"] = 118.13, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 193.07, ["Mega"] = 611, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 789.97}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.07, ["Fly"] = 111.89, ["Ride"] = 105.24, ["Fly|Ride"] = 375.27, ["Neon"] = 171.94, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 166.37, ["Neon|Fly|Ride"] = 330.8, ["Mega"] = 402.94, ["Mega|Fly"] = 2190.92, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 528.94}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.94, ["Ride"] = 46.72, ["Fly|Ride"] = 96.49, ["Neon"] = 141.81, ["Neon|Ride"] = 416.97, ["Neon|Fly|Ride"] = 303.61, ["Mega|Ride"] = 947.48, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.92, ["Ride"] = 14.95, ["Fly|Ride"] = 42.33, ["Neon"] = 2.63, ["Neon|Fly"] = 23.83, ["Neon|Ride"] = 15.31, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 17.26, ["Mega|Fly"] = 417.34, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 196.88, ["Ride"] = 279.18, ["Fly|Ride"] = 379.1, ["Neon"] = 2082.64, ["Neon|Fly|Ride"] = 1246.74, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.44, ["Fly"] = 101.18, ["Ride"] = 49.41, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Ride"] = 39.63, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 710.62, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 17.68, ["Fly|Ride"] = 45, ["Neon"] = 7.66, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 110.6, ["Mega"] = 59.07, ["Mega|Fly"] = 278.57, ["Mega|Ride"] = 72.97, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 20.92, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 116.05, ["Mega"] = 25.34, ["Mega|Fly"] = 139.81, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 186.76}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.18, ["Neon"] = 12.95, ["Neon|Fly"] = 710.32, ["Neon|Ride"] = 35.54, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6.2, ["Fly"] = 38.75, ["Ride"] = 23.62, ["Fly|Ride"] = 59.07, ["Neon"] = 47.15, ["Neon|Fly"] = 299.18, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 128.94, ["Mega"] = 355.69, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.51, ["Ride"] = 55.13, ["Fly|Ride"] = 72.19, ["Neon"] = 38.19, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 316.23, ["Mega|Fly|Ride"] = 420.46}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 3.93, ["Neon|Ride"] = 31.28, ["Mega"] = 32.45, ["Mega|Ride"] = 72.08, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.18, ["Ride"] = 27.2, ["Fly|Ride"] = 131.25, ["Neon"] = 24.68, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 44.99, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 234.73, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 348.47}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 78.89, ["Neon"] = 3.28, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 41.75, ["Mega|Ride"] = 102.26, ["Mega|Fly|Ride"] = 129.39}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 4.94, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 121.85, ["Mega"] = 58.89, ["Mega|Fly"] = 139.81, ["Mega|Ride"] = 87.85, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.82, ["Ride"] = 651.49, ["Fly|Ride"] = 903.76, ["Neon|Fly|Ride"] = 3547.2, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.23, ["Fly|Ride"] = 31.38, ["Neon"] = 18.25, ["Neon|Fly"] = 140.89, ["Neon|Ride"] = 28.16, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly|Ride"] = 358.95}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 47.25, ["Neon"] = 8.9, ["Neon|Fly"] = 729.69, ["Neon|Ride"] = 88.45, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 54.49, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 417.34}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.57, ["Fly"] = 47.54, ["Ride"] = 24.68, ["Fly|Ride"] = 53.78, ["Neon"] = 50.6, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 97.11, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.34, ["Fly|Ride"] = 32.04, ["Neon"] = 7.53, ["Neon|Fly"] = 145.78, ["Neon|Ride"] = 26.06, ["Neon|Fly|Ride"] = 69.24, ["Mega"] = 65.01, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.35}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 37.97, ["Ride"] = 84.17, ["Fly|Ride"] = 278.34, ["Neon"] = 220.5, ["Neon|Ride"] = 267.57, ["Mega"] = 974.45, ["Mega|Fly|Ride"] = 1183.1}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 25.3, ["Fly|Ride"] = 64.46, ["Neon"] = 5.13, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 30.64, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 47.67, ["Mega|Ride"] = 119.59, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 125.48, ["Ride"] = 20.27, ["Fly|Ride"] = 60.66, ["Neon"] = 10.47, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 111.64, ["Mega"] = 114.19, ["Mega|Ride"] = 198.6, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Mega"] = 93.19, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.56, ["Fly|Ride"] = 49.88, ["Neon"] = 3.61, ["Neon|Fly"] = 100.68, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.81, ["Mega|Fly"] = 292.14, ["Mega|Ride"] = 62.91, ["Mega|Fly|Ride"] = 187.81}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.86, ["Fly"] = 19.58, ["Ride"] = 19.22, ["Fly|Ride"] = 34.11, ["Neon"] = 316.1, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43, ["Mega|Ride"] = 417.34}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 703.5, ["Ride"] = 853.13, ["Fly|Ride"] = 926.63, ["Neon"] = 1837.5, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 8346.31, ["Mega|Fly|Ride"] = 7578.61}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.56, ["Ride"] = 15.2, ["Fly|Ride"] = 37.97, ["Neon"] = 3.34, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.89, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.9, ["Ride"] = 36.74, ["Neon"] = 43.3, ["Neon|Fly"] = 71.05, ["Neon|Ride"] = 47.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 391.26, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 532.09}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.13, ["Ride"] = 59.03, ["Fly|Ride"] = 113.28, ["Neon|Ride"] = 473.55, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3199.77, ["Mega|Fly|Ride"] = 2040.94}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 33.44, ["Ride"] = 44.63, ["Fly|Ride"] = 104.89, ["Neon"] = 210, ["Neon|Ride"] = 218.92, ["Neon|Fly|Ride"] = 695.89, ["Mega"] = 1948.88, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1012.01}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.22, ["Ride"] = 26.23, ["Fly|Ride"] = 140.13, ["Neon"] = 62.55, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 115.82, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.03, ["Ride"] = 56.55, ["Neon"] = 278.34, ["Neon|Ride"] = 363.45, ["Mega"] = 459.38, ["Mega|Fly"] = 514.02, ["Mega|Ride"] = 349.4, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.63, ["Fly"] = 126.89, ["Neon"] = 420, ["Neon|Ride"] = 323, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 682.32}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.2}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.55, ["Ride"] = 18.42, ["Fly|Ride"] = 85.32, ["Neon"] = 32.71, ["Neon|Ride"] = 93.83, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 139.81, ["Mega|Fly"] = 471.59, ["Mega|Ride"] = 166.94, ["Mega|Fly|Ride"] = 291.55}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.19, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Mega"] = 139.81, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 39.38, ["Fly"] = 418.25, ["Ride"] = 38.07, ["Fly|Ride"] = 101.78, ["Neon"] = 262.5, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 947.48, ["Mega|Ride"] = 1585.81, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.25, ["Fly|Ride"] = 38.25, ["Neon"] = 25.3, ["Neon|Fly"] = 94.87, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 196.88, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 418.68}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.45, ["Fly"] = 148.49, ["Ride"] = 21.61, ["Fly|Ride"] = 55.7, ["Neon"] = 14.34, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 131.25, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.76, ["Mega"] = 48.56, ["Mega|Ride"] = 196.38}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 29.91, ["Fly"] = 77.17, ["Ride"] = 45.94, ["Fly|Ride"] = 89.25, ["Neon"] = 945, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 292.69, ["Mega|Ride"] = 13911.2, ["Mega|Fly|Ride"] = 816.71}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Fly|Ride"] = 65.63, ["Neon"] = 6.29, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 32.33, ["Mega"] = 74.81, ["Mega|Ride"] = 118.12}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.88, ["Ride"] = 79.61, ["Fly|Ride"] = 278.15, ["Neon"] = 75.07, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 619.73}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 14.58, ["Fly|Ride"] = 40.64, ["Neon"] = 18.68, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 313.01}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 75.12, ["Neon"] = 31.4, ["Neon|Ride"] = 65.63, ["Mega|Ride"] = 417.34, ["Mega|Fly|Ride"] = 447.82}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.47, ["Neon"] = 39.35, ["Neon|Ride"] = 227.07, ["Mega"] = 413.86, ["Mega|Ride"] = 947.48}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Ride"] = 123.27, ["Neon"] = 216.57, ["Neon|Fly|Ride"] = 417.34, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.91, ["Ride"] = 278.03, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Mega"] = 452.92, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 12.49, ["Ride"] = 125.97, ["Neon"] = 171.63, ["Neon|Fly"] = 208.49, ["Neon|Ride"] = 416.97, ["Mega"] = 425.67, ["Mega|Ride"] = 833.61}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.19, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 729.69, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 616.88, ["Mega|Fly"] = 2086.6, ["Mega|Fly|Ride"] = 1106.19}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.93, ["Neon"] = 20.87, ["Mega"] = 170.63, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 316.33}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.63, ["Ride"] = 17.81, ["Fly|Ride"] = 40.61, ["Neon"] = 3.72, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.67, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 52.5, ["Mega|Ride"] = 80.15, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.63, ["Ride"] = 43.93, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 105, ["Mega|Ride"] = 131.49, ["Mega|Fly|Ride"] = 260.87}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.46, ["Fly|Ride"] = 56.15, ["Neon"] = 3.83, ["Neon|Ride"] = 22.46, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 42, ["Mega|Fly"] = 166.94, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 222.67}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 15.65, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 258.76, ["Mega"] = 328.02, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 473.89}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Neon"] = 25.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 417.34}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.15, ["Fly"] = 131.25, ["Ride"] = 23.63, ["Fly|Ride"] = 77.16, ["Neon"] = 16.75, ["Neon|Fly"] = 111.55, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 352.65, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 33.72, ["Ride"] = 19.38, ["Fly|Ride"] = 51.78, ["Neon"] = 36.75, ["Neon|Ride"] = 69.85, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 250.41}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.94, ["Neon"] = 15.64, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 61.52, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 98.22, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.45, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 20.63, ["Ride"] = 99.53, ["Fly|Ride"] = 358.6, ["Neon"] = 108.94, ["Neon|Ride"] = 416.97, ["Neon|Fly|Ride"] = 527.05, ["Mega"] = 519.75, ["Mega|Ride"] = 920.19, ["Mega|Fly|Ride"] = 724.06}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.07, ["Fly"] = 164.07, ["Ride"] = 83.18, ["Fly|Ride"] = 487.75, ["Neon"] = 221.8, ["Neon|Ride"] = 316.1, ["Neon|Fly|Ride"] = 487.96, ["Mega"] = 1529.48, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1210.13}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 23.02, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Mega"] = 27.12, ["Mega|Ride"] = 79.36, ["Mega|Fly|Ride"] = 144.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.29, ["Neon"] = 158.65, ["Mega|Fly|Ride"] = 1001.69}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 54.55, ["Fly"] = 105, ["Ride"] = 78.75, ["Neon"] = 354.27, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 833.61, ["Mega"] = 1709.96, ["Mega|Fly|Ride"] = 1877.94}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.61, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 40.69, ["Neon|Ride"] = 83.42, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.5, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.11, ["Ride"] = 65.37, ["Fly|Ride"] = 141.75, ["Neon"] = 13.11, ["Neon|Ride"] = 59.07, ["Mega"] = 83.95, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 137.8, ["Mega|Fly|Ride"] = 349.49}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.86, ["Ride"] = 18.83, ["Fly|Ride"] = 39.36, ["Neon"] = 8.92, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.88, ["Mega|Ride"] = 207.63, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.75, ["Fly|Ride"] = 41.72, ["Neon"] = 2.51, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 56.86, ["Mega"] = 28.88, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 116.95}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.69, ["Fly|Ride"] = 89.93, ["Neon"] = 2.1, ["Neon|Ride"] = 17.78, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 49.75, ["Mega|Ride"] = 139.81, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 118.4, ["Neon"] = 2.49, ["Neon|Ride"] = 145.08, ["Mega"] = 25.65, ["Mega|Fly|Ride"] = 327.66}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.08, ["Ride"] = 157.5, ["Neon"] = 47.37, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 625.99, ["Mega"] = 236.88, ["Mega|Fly|Ride"] = 316.33}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.7, ["Ride"] = 34.13, ["Fly|Ride"] = 98.3, ["Neon"] = 52.85, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 183.64, ["Mega|Ride"] = 331.63, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.87, ["Fly"] = 40.4, ["Ride"] = 18.38, ["Fly|Ride"] = 37.97, ["Neon"] = 37.97, ["Neon|Fly"] = 69.85, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 101.68, ["Mega|Ride"] = 277.15, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 50.71, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.16, ["Mega"] = 2368.69, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.3, ["Fly"] = 82.67, ["Ride"] = 31.4, ["Neon"] = 250.19, ["Neon|Fly|Ride"] = 630, ["Mega"] = 632.45, ["Mega|Ride"] = 874.13}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 41.72, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 62.62, ["Mega|Ride"] = 94.01, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.71, ["Fly|Ride"] = 27.57, ["Neon"] = 3.63, ["Neon|Fly"] = 26.99, ["Neon|Ride"] = 14.76, ["Neon|Fly|Ride"] = 42.24, ["Mega"] = 43, ["Mega|Fly"] = 90.78, ["Mega|Ride"] = 56.43, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 451.5, ["Fly"] = 554.76, ["Ride"] = 534.19, ["Fly|Ride"] = 556.45, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 8.28, ["Ride"] = 56.35, ["Neon"] = 44.01, ["Neon|Ride"] = 63.95, ["Mega"] = 364.88, ["Mega|Ride"] = 682.32, ["Mega|Fly|Ride"] = 278210.29}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.75, ["Fly|Ride"] = 27.82, ["Neon"] = 3.94, ["Neon|Fly"] = 23.69, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 38.31, ["Mega"] = 139.81, ["Mega|Ride"] = 74.01, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.79, ["Ride"] = 140.13, ["Fly|Ride"] = 521.21, ["Neon"] = 240.9, ["Neon|Ride"] = 268.75, ["Neon|Fly|Ride"] = 460.1, ["Mega"] = 737.63, ["Mega|Ride"] = 710.72, ["Mega|Fly|Ride"] = 878.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.66, ["Ride"] = 12.6, ["Fly|Ride"] = 35.44, ["Neon"] = 12.77, ["Neon|Fly"] = 61.52, ["Neon|Ride"] = 19.58, ["Neon|Fly|Ride"] = 70.85, ["Mega"] = 110.15, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 56.47, ["Neon"] = 3.14, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 24.94, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.07, ["Fly"] = 117.27, ["Ride"] = 64.97, ["Fly|Ride"] = 195.54, ["Neon"] = 184.85, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 834.65, ["Mega|Fly|Ride"] = 1106.19}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 15.69, ["Ride"] = 23.02, ["Neon"] = 2.88, ["Neon|Ride"] = 39.99, ["Mega"] = 125.22, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 69.45, ["Fly|Ride"] = 140.13, ["Neon"] = 416.97, ["Neon|Ride"] = 277.29, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1648.4, ["Mega|Ride"] = 1669.27, ["Mega|Fly|Ride"] = 1502.53}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 19.69, ["Neon|Ride"] = 47.37, ["Neon|Fly|Ride"] = 487.24, ["Mega"] = 156.19, ["Mega|Ride"] = 185.07}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.25, ["Ride"] = 70.58, ["Fly|Ride"] = 69.85, ["Neon"] = 7.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 557.2}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 40.21, ["Ride"] = 104.99, ["Fly|Ride"] = 521.21, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1664.06}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 20.94, ["Fly|Ride"] = 60.15, ["Neon"] = 4.35, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.98, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 89.72, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.91, ["Fly|Ride"] = 101.82, ["Neon"] = 10.89, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.01, ["Fly"] = 58.5, ["Ride"] = 23.78, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 369.33, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.35, ["Fly"] = 57.11, ["Ride"] = 20.86, ["Fly|Ride"] = 71.3, ["Neon"] = 72.17, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 911.01, ["Mega|Ride"] = 401.82, ["Mega|Fly|Ride"] = 483.77}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.55, ["Fly"] = 51.18, ["Ride"] = 26.25, ["Fly|Ride"] = 63.95, ["Neon"] = 72.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 557.12, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 57.66, ["Ride"] = 118.13, ["Fly|Ride"] = 249.38, ["Neon"] = 359.63, ["Neon|Ride"] = 486.82, ["Neon|Fly|Ride"] = 734.3, ["Mega|Ride"] = 1809.07, ["Mega|Fly|Ride"] = 1310.4}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.45, ["Ride"] = 56.05, ["Neon"] = 26.25, ["Neon|Ride"] = 416.97, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 388.16}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.69, ["Ride"] = 26.24, ["Fly|Ride"] = 78.74, ["Neon"] = 25.17, ["Neon|Ride"] = 59.21, ["Neon|Fly|Ride"] = 125.22, ["Mega"] = 262.5, ["Mega|Ride"] = 269.18}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.03, ["Ride"] = 24.03, ["Fly|Ride"] = 109.83, ["Neon"] = 47.09, ["Neon|Ride"] = 208.49, ["Neon|Fly|Ride"] = 236.52, ["Mega"] = 460.1, ["Mega|Ride"] = 639.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.33, ["Ride"] = 12.56, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.31, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.36, ["Mega|Ride"] = 23.7, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.49, ["Fly"] = 221.68, ["Ride"] = 85.32, ["Neon"] = 408.19, ["Neon|Fly"] = 2363.11, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 467.83, ["Mega"] = 1113.2, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 829.16}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.92, ["Fly|Ride"] = 35.57, ["Neon"] = 3.18, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 139.81, ["Mega|Ride"] = 139.81, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 15.74, ["Fly|Ride"] = 58.46, ["Neon"] = 23.46, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 257.25, ["Mega|Ride"] = 118.46, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.63, ["Fly"] = 157.5, ["Ride"] = 118.13, ["Fly|Ride"] = 258.56, ["Neon"] = 360.94, ["Neon|Ride"] = 682.78, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1343.05}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 19.88, ["Neon"] = 5.23, ["Neon|Ride"] = 52.4, ["Mega"] = 63.73, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 12.91}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.03, ["Fly|Ride"] = 296.05, ["Neon"] = 3.94, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 154.43, ["Mega"] = 42.84, ["Mega|Ride"] = 114.01, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 113.17, ["Ride"] = 144.01, ["Fly|Ride"] = 284.13, ["Neon"] = 836.07, ["Neon|Ride"] = 682.78, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3338.53, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.52, ["Ride"] = 41.84, ["Neon"] = 19.57, ["Neon|Fly"] = 139.7, ["Neon|Ride"] = 65.63, ["Mega"] = 209.9, ["Mega|Fly|Ride"] = 631.76}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 41.84, ["Neon"] = 3.72, ["Neon|Ride"] = 26.25, ["Mega"] = 32.81, ["Mega|Fly|Ride"] = 139.83}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 8.37, ["Ride"] = 19.42, ["Neon"] = 65.63, ["Neon|Ride"] = 63.95, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 487.24, ["Mega|Ride"] = 417.34, ["Mega|Fly|Ride"] = 671.73}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.44, ["Fly"] = 53.39, ["Ride"] = 21, ["Fly|Ride"] = 55.65, ["Neon"] = 99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 603.75, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.97, ["Ride"] = 68.38, ["Fly|Ride"] = 111.55, ["Neon"] = 131.24, ["Neon|Ride"] = 223.09, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 632.45, ["Mega|Ride"] = 642.68, ["Mega|Fly|Ride"] = 736.57}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 127.32, ["Fly"] = 279.18, ["Ride"] = 171.32, ["Fly|Ride"] = 216.57, ["Neon"] = 593.14, ["Neon|Ride"] = 590.3, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2365.15}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 311.75, ["Ride"] = 60.88, ["Fly|Ride"] = 70.96, ["Neon"] = 471.14, ["Neon|Ride"] = 833.94, ["Neon|Fly|Ride"] = 538.35}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.59, ["Fly|Ride"] = 131.24, ["Neon"] = 15.75, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 139.13, ["Mega|Ride"] = 126.74, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 2.1, ["Fly"] = 98.44, ["Ride"] = 35.13, ["Neon"] = 62.42, ["Neon|Ride"] = 80.06, ["Neon|Fly|Ride"] = 156.52, ["Mega"] = 379.31, ["Mega|Ride"] = 496.62, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 48.09, ["Fly"] = 142.56, ["Ride"] = 76.92, ["Fly|Ride"] = 223.09, ["Neon"] = 219.19, ["Neon|Ride"] = 278.34, ["Neon|Fly|Ride"] = 328.65, ["Mega"] = 1016.18, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.29, ["Ride"] = 83.15, ["Neon"] = 105, ["Neon|Ride"] = 556.65, ["Neon|Fly|Ride"] = 460.1, ["Mega"] = 683.71, ["Mega|Ride"] = 616.6}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 472.5, ["Neon|Ride"] = 3157.32}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.88, ["Fly"] = 56.47, ["Ride"] = 32.8, ["Fly|Ride"] = 75.64, ["Neon"] = 416.97, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 462.19, ["Mega"] = 1034.25, ["Mega|Ride"] = 994.86, ["Mega|Fly|Ride"] = 1106.19}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 1.68, ["Fly"] = 39.2, ["Ride"] = 12.53, ["Fly|Ride"] = 121.3, ["Neon"] = 3.69, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 40.25, ["Mega"] = 19.24, ["Mega|Fly"] = 110.6, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Neon"] = 8.3, ["Neon|Ride"] = 66.87, ["Neon|Fly|Ride"] = 262.91, ["Mega"] = 146.08, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 35.57, ["Fly|Ride"] = 60.52, ["Neon"] = 19.78, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 974.45, ["Mega"] = 108.65, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.77, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1563.6, ["Neon|Ride"] = 9187.5, ["Neon|Fly|Ride"] = 1669.27, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.4, ["Fly"] = 70.07, ["Ride"] = 15.74, ["Fly|Ride"] = 42, ["Neon"] = 31.99, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 104.35, ["Mega"] = 160.13, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.24, ["Fly"] = 22.32, ["Ride"] = 17.2, ["Fly|Ride"] = 44.63, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 695.89, ["Mega|Fly|Ride"] = 208.7}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.28, ["Fly"] = 44.98, ["Ride"] = 28.87, ["Fly|Ride"] = 78.75, ["Neon"] = 10.63, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 56.83, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 158.71, ["Mega|Ride"] = 271.27, ["Mega|Fly|Ride"] = 307.79}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 46.34, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 140.44, ["Neon|Ride"] = 174.66, ["Neon|Fly|Ride"] = 311.96, ["Mega"] = 1312.5, ["Mega|Ride"] = 834.65, ["Mega|Fly|Ride"] = 683.82}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.24, ["Fly|Ride"] = 50.3, ["Neon"] = 11.7, ["Neon|Ride"] = 108.42, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.3, ["Fly"] = 64.26, ["Ride"] = 24.94, ["Neon"] = 185.73, ["Neon|Ride"] = 210, ["Mega"] = 730.32, ["Mega|Ride"] = 751.19, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 6.06, ["Neon|Ride"] = 35.11, ["Mega"] = 52.41, ["Mega|Ride"] = 112.02, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.87, ["Neon"] = 85.32}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.47, ["Ride"] = 77.39, ["Neon"] = 78.8, ["Neon|Ride"] = 473.55, ["Neon|Fly|Ride"] = 417.34, ["Mega"] = 834.65, ["Mega|Ride"] = 581.53, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.97, ["Fly"] = 27.63, ["Ride"] = 23.91, ["Fly|Ride"] = 71.05, ["Neon"] = 52.5, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 586.35, ["Mega|Fly|Ride"] = 344.9}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.84, ["Ride"] = 388.5, ["Fly|Ride"] = 482.99, ["Neon"] = 1659, ["Neon|Ride"] = 1326.14, ["Neon|Fly|Ride"] = 1470, ["Mega|Fly|Ride"] = 6955.6}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 28.16, ["Neon|Fly"] = 79.33, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 208.68, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.86, ["Ride"] = 44.1, ["Fly|Ride"] = 94.73, ["Neon"] = 43.84, ["Neon|Ride"] = 156.37, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 382.29, ["Mega|Fly"] = 695.89, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 30.14, ["Ride"] = 86.63, ["Fly|Ride"] = 315, ["Neon"] = 112.71, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 410.99, ["Mega"] = 356.29, ["Mega|Ride"] = 4173.17, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 279.18, ["Ride"] = 116.89, ["Neon"] = 1390.56, ["Neon|Ride"] = 1459.36, ["Neon|Fly|Ride"] = 1251.96, ["Mega"] = 2249.09, ["Mega|Ride"] = 5551.88, ["Mega|Fly|Ride"] = 2295.25}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.46, ["Ride"] = 119.21, ["Fly|Ride"] = 127.74, ["Neon"] = 52.14, ["Neon|Ride"] = 90.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 208.68, ["Mega|Ride"] = 255.11, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.59, ["Fly|Ride"] = 52.5, ["Neon"] = 12.48, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 65.61, ["Mega|Ride"] = 139.81, ["Mega|Fly|Ride"] = 236.96}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.64, ["Ride"] = 33.68, ["Neon"] = 26, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 210, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.76, ["Fly"] = 183.75, ["Ride"] = 94.45, ["Fly|Ride"] = 198.81, ["Neon"] = 150.93, ["Neon|Ride"] = 157.37, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 590.63, ["Mega|Ride"] = 682.32, ["Mega|Fly|Ride"] = 542.07}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 10.4, ["Neon|Ride"] = 253.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 66.78, ["Mega|Ride"] = 166.35, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.04, ["Neon"] = 118.13, ["Neon|Ride"] = 401.03, ["Mega"] = 520.62}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 958.13, ["Fly"] = 2091.2, ["Ride"] = 1036.88, ["Fly|Ride"] = 1086.65, ["Neon"] = 3316.9, ["Neon|Ride"] = 3585.84, ["Neon|Fly|Ride"] = 3221.36, ["Mega|Fly|Ride"] = 11130.13}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 12.38, ["Fly"] = 78.28, ["Ride"] = 56.15, ["Fly|Ride"] = 194.25, ["Neon"] = 85.32, ["Neon|Fly"] = 694.25, ["Neon|Ride"] = 208.49, ["Mega"] = 471.45, ["Mega|Fly|Ride"] = 784.58}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 16.47, ["Fly|Ride"] = 80.89, ["Neon"] = 10.67, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 92.02, ["Mega"] = 84, ["Mega|Ride"] = 139.81, ["Mega|Fly|Ride"] = 250.41}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Fly|Ride"] = 139.7, ["Neon"] = 141.75, ["Mega"] = 787.5, ["Mega|Ride"] = 421.94, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.06, ["Fly|Ride"] = 181.39, ["Neon"] = 2.1, ["Neon|Ride"] = 20.83, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 14.12, ["Mega|Fly"] = 125.22, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 157}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 56.13, ["Ride"] = 103.69, ["Fly|Ride"] = 236.25, ["Neon"] = 260.73, ["Neon|Ride"] = 362.77, ["Neon|Fly|Ride"] = 403.77, ["Mega"] = 1106.34, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 1062.87}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.22, ["Ride"] = 63, ["Fly|Ride"] = 157.83, ["Neon"] = 69.55, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 261.76, ["Mega"] = 695.89, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 555.11}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.09, ["Neon"] = 12.52, ["Neon|Ride"] = 65.62, ["Mega"] = 156.52, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 17.99, ["Fly"] = 52.5, ["Ride"] = 41.08, ["Fly|Ride"] = 117.51, ["Neon"] = 139.7, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 1039.49, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.04, ["Ride"] = 30.22, ["Fly|Ride"] = 68.25, ["Neon"] = 49.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315, ["Mega"] = 555.96, ["Mega|Ride"] = 521.67, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.18, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 904.55, ["Mega"] = 2086.6, ["Mega|Ride"] = 2368.69, ["Mega|Fly|Ride"] = 1664.06}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.94, ["Neon"] = 14.22, ["Neon|Ride"] = 83.42, ["Neon|Fly|Ride"] = 168.77, ["Mega"] = 101.87, ["Mega|Ride"] = 395.58, ["Mega|Fly|Ride"] = 226.31}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.6, ["Ride"] = 23.02, ["Fly|Ride"] = 91.74, ["Neon"] = 142.07, ["Neon|Ride"] = 139.7, ["Neon|Fly|Ride"] = 137.72, ["Mega"] = 301.67, ["Mega|Ride"] = 386.04, ["Mega|Fly|Ride"] = 632.45}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Fly"] = 179.86, ["Ride"] = 139.13, ["Fly|Ride"] = 207.9, ["Neon"] = 577.6, ["Neon|Ride"] = 553.52, ["Neon|Fly|Ride"] = 643.13, ["Mega|Ride"] = 2320.28, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.61, ["Ride"] = 19.88, ["Fly|Ride"] = 39.38, ["Neon"] = 12.18, ["Neon|Fly"] = 57.52, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 70.67, ["Mega|Ride"] = 236.88, ["Mega|Fly|Ride"] = 307.95}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.02, ["Fly"] = 193.47, ["Ride"] = 37.67, ["Fly|Ride"] = 92.86, ["Neon"] = 97.13, ["Neon|Fly"] = 316.1, ["Neon|Ride"] = 82.84, ["Neon|Fly|Ride"] = 246.23, ["Mega"] = 460.1, ["Mega|Ride"] = 462.19, ["Mega|Fly|Ride"] = 407.4}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.69, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 26.45, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.41, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.67, ["Neon|Ride"] = 41.72, ["Neon|Fly|Ride"] = 129.39, ["Mega"] = 18.16, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 162.77}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.57, ["Ride"] = 19.69, ["Fly|Ride"] = 104, ["Neon"] = 16.98, ["Neon|Ride"] = 60.4, ["Neon|Fly|Ride"] = 217.02, ["Mega"] = 77.44}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.18, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 137.82, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1181.25, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 974.45}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 14.44, ["Fly|Ride"] = 30.72, ["Neon"] = 13.96, ["Neon|Fly"] = 26.16, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 52.29, ["Mega"] = 104.9, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 122.42, ["Mega|Fly|Ride"] = 171.73}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.14, ["Fly"] = 40.6, ["Ride"] = 24.3, ["Fly|Ride"] = 84.77, ["Neon"] = 20.9, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 36.88, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 219.35, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 218.6, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 18.09, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 35.46, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 158.71, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 89.74, ["Mega|Fly|Ride"] = 250.41}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.31, ["Fly"] = 169.32, ["Ride"] = 23.55, ["Fly|Ride"] = 217.19, ["Neon"] = 30.19, ["Neon|Ride"] = 74.88, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 270.22, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 625.99}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.28, ["Ride"] = 140.13, ["Neon"] = 39.37, ["Neon|Ride"] = 262.5, ["Mega"] = 670.69, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 13.13, ["Fly"] = 42.21, ["Ride"] = 16.96, ["Fly|Ride"] = 44.91, ["Neon"] = 15.64, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 171.94, ["Mega"] = 255.94, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 417.34}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.08, ["Ride"] = 17.83, ["Fly|Ride"] = 35.54, ["Neon"] = 16.11, ["Neon|Fly"] = 47.37, ["Neon|Ride"] = 35.46, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 78.75, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 203.43, ["Fly"] = 393.75, ["Ride"] = 299.36, ["Fly|Ride"] = 392.44, ["Neon"] = 1209.18, ["Neon|Ride"] = 1385.11, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4034.41}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.97, ["Neon"] = 56.31, ["Mega"] = 122.07, ["Mega|Ride"] = 557.12}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.49, ["Fly"] = 104.57, ["Ride"] = 21.52, ["Fly|Ride"] = 52.5, ["Neon"] = 23.15, ["Neon|Fly"] = 236.64, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 204.35, ["Mega|Ride"] = 325.52, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.45, ["Fly|Ride"] = 212.89, ["Neon"] = 52.5, ["Neon|Ride"] = 221.01, ["Neon|Fly|Ride"] = 625.99, ["Mega"] = 603.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 561.56}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.72, ["Fly|Ride"] = 28.98, ["Neon"] = 2.1, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 18.38, ["Mega|Fly"] = 75.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.83, ["Fly|Ride"] = 111.42, ["Neon"] = 7.93, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.81, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 238.91}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.23, ["Ride"] = 140.13, ["Neon"] = 15.61, ["Neon|Ride"] = 278.34, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 174.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 77.44, ["Fly"] = 166.31, ["Ride"] = 112.88, ["Fly|Ride"] = 166.61, ["Neon"] = 556.49, ["Neon|Ride"] = 413.44, ["Neon|Fly|Ride"] = 557.12, ["Mega|Ride"] = 3479.39, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.2, ["Fly"] = 98.3, ["Ride"] = 28.88, ["Fly|Ride"] = 100.68, ["Neon"] = 22.78, ["Neon|Ride"] = 63.61, ["Neon|Fly|Ride"] = 417.34, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 562.42}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.12, ["Ride"] = 41.84, ["Neon"] = 6.57, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 531.78, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.87, ["Fly"] = 210, ["Ride"] = 103.03, ["Fly|Ride"] = 199.5, ["Neon"] = 144.15, ["Neon|Ride"] = 202.12, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 632.45, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 838.83}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.71, ["Fly|Ride"] = 91.77, ["Neon"] = 2.1, ["Neon|Fly"] = 22.95, ["Neon|Ride"] = 14.62, ["Neon|Fly|Ride"] = 32.7, ["Mega"] = 18.17, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 82.9}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Fly"] = 32.33, ["Neon|Ride"] = 43.49, ["Neon|Fly|Ride"] = 211.02, ["Mega"] = 15.59, ["Mega|Ride"] = 83.14, ["Mega|Fly|Ride"] = 175.77}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 51.52, ["Neon"] = 7.24, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 340.13, ["Mega"] = 98.44, ["Mega|Fly"] = 181.55, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.18, ["Fly"] = 55.97, ["Ride"] = 42, ["Fly|Ride"] = 146.13, ["Neon"] = 20.9, ["Neon|Fly"] = 89.66, ["Neon|Ride"] = 77.76, ["Neon|Fly|Ride"] = 459.27, ["Mega"] = 91.77, ["Mega|Fly"] = 223.28, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 12.56, ["Ride"] = 12.49, ["Fly|Ride"] = 36.61, ["Neon"] = 2.1, ["Neon|Fly"] = 25.03, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 67.1, ["Mega"] = 16.87, ["Mega|Ride"] = 62.05, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 21, ["Fly"] = 131.25, ["Ride"] = 204.75, ["Neon"] = 129.93, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 36519.54}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 53.01, ["Ride"] = 13.01, ["Fly|Ride"] = 42.97, ["Neon"] = 8.43, ["Neon|Fly"] = 63.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 76.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 197.79}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.93, ["Neon"] = 4.39, ["Mega"] = 139.81, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.71, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.63, ["Fly"] = 111.89, ["Ride"] = 28.53, ["Fly|Ride"] = 68.81, ["Neon"] = 70.16, ["Neon|Ride"] = 103.79, ["Neon|Fly|Ride"] = 293.73, ["Mega"] = 367.5, ["Mega|Ride"] = 592.6}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.35, ["Ride"] = 44.63, ["Neon"] = 187.69, ["Mega"] = 1249.4, ["Mega|Ride"] = 595.73, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.82, ["Fly"] = 131.25, ["Ride"] = 210, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 819.77, ["Mega"] = 6259.74, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.27, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.59, ["Neon|Ride"] = 139.7, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 307.79, ["Mega|Fly|Ride"] = 354.77}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.57, ["Fly|Ride"] = 69.85, ["Neon"] = 26.25, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 842.33}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.77, ["Fly|Ride"] = 131.25, ["Neon"] = 9.17, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 88.85, ["Mega|Ride"] = 108.96, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.19, ["Neon"] = 179.31, ["Neon|Ride"] = 177.19, ["Mega"] = 374.07, ["Mega|Ride"] = 462.19}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.84, ["Neon"] = 2.1, ["Neon|Ride"] = 28.16, ["Mega"] = 18.79, ["Mega|Ride"] = 158.45, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.11, ["Fly"] = 266.64, ["Ride"] = 87.94, ["Fly|Ride"] = 158.65, ["Neon"] = 366.19, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 417.34, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.28, ["Neon|Ride"] = 154.29, ["Mega"] = 71.07}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.69, ["Fly"] = 222.15, ["Ride"] = 78.75, ["Fly|Ride"] = 79.61, ["Neon"] = 295.32, ["Neon|Ride"] = 416.51, ["Neon|Fly|Ride"] = 532.88, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 27.2, ["Fly|Ride"] = 50.92, ["Neon"] = 5.23, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 178.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.85, ["Neon"] = 10.49, ["Neon|Ride"] = 98.44, ["Mega"] = 69.09, ["Mega|Ride"] = 164.43}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.55, ["Fly"] = 77.43, ["Ride"] = 38.57, ["Fly|Ride"] = 208.49, ["Neon"] = 27.74, ["Neon|Ride"] = 111.55, ["Mega"] = 262.5, ["Mega|Ride"] = 325.52, ["Mega|Fly|Ride"] = 557.2}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 346.73, ["Ride"] = 525, ["Fly|Ride"] = 518.25, ["Neon"] = 1048.68, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1421.22, ["Mega"] = 4451.72, ["Mega|Ride"] = 4173.17, ["Mega|Fly|Ride"] = 4263.65}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.25, ["Fly"] = 83.67, ["Ride"] = 52.5, ["Fly|Ride"] = 99.15, ["Neon"] = 196.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 375.6, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.89, ["Fly|Ride"] = 150.94, ["Neon"] = 10.25, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 119.55, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.62, ["Fly"] = 54.38, ["Ride"] = 43.34, ["Fly|Ride"] = 178.26, ["Neon"] = 66.94, ["Neon|Fly"] = 551.69, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 182, ["Mega"] = 314.9, ["Mega|Fly"] = 974.73, ["Mega|Ride"] = 344.81, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.29, ["Ride"] = 20.78, ["Fly|Ride"] = 83.42, ["Neon"] = 140.75, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 268.86, ["Mega"] = 313.01, ["Mega|Ride"] = 666.67, ["Mega|Fly|Ride"] = 529.03}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 17.06, ["Mega"] = 72.19, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.95, ["Fly|Ride"] = 56.31, ["Neon"] = 39.29, ["Neon|Ride"] = 41.72, ["Neon|Fly|Ride"] = 273.35, ["Mega"] = 553.1, ["Mega|Ride"] = 417.34, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Ride"] = 117.81, ["Fly|Ride"] = 236.25, ["Neon"] = 1026.41, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 568.51, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2961.72}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.61, ["Ride"] = 45.53, ["Fly|Ride"] = 91.88, ["Neon"] = 142.95, ["Neon|Ride"] = 208.49, ["Mega|Ride"] = 695.89, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2008.13, ["Ride"] = 2098.69, ["Fly|Ride"] = 2165.63, ["Neon"] = 11119.2, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.93, ["Fly"] = 65625, ["Ride"] = 32.82, ["Fly|Ride"] = 196.87, ["Neon"] = 17.74, ["Mega"] = 110.72, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.55, ["Ride"] = 47.25, ["Neon"] = 17.83, ["Neon|Ride"] = 76.63, ["Mega"] = 157.5, ["Mega|Ride"] = 204.11, ["Mega|Fly|Ride"] = 1043.31}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1194.09, ["Fly"] = 948.54, ["Ride"] = 1002.75, ["Fly|Ride"] = 987, ["Neon"] = 4731.43, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 12241.94, ["Mega|Fly|Ride"] = 12159.63}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.57, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Fly|Ride"] = 374.27, ["Mega"] = 834.65, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 829.43}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.57, ["Ride"] = 23.59, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 175.88, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 140.13, ["Neon"] = 3.83, ["Neon|Ride"] = 69.67, ["Neon|Fly|Ride"] = 91.83, ["Mega"] = 19.68, ["Mega|Ride"] = 254.58, ["Mega|Fly|Ride"] = 278.57}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.76, ["Ride"] = 128.63, ["Fly|Ride"] = 170.63, ["Neon"] = 416.97, ["Neon|Ride"] = 591.94, ["Neon|Fly|Ride"] = 630, ["Mega"] = 8346.31, ["Mega|Fly|Ride"] = 2086.85}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Neon"] = 11.71, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 158.71, ["Mega"] = 158.71, ["Mega|Ride"] = 186.76, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.48, ["Ride"] = 102.38, ["Neon"] = 614.25, ["Neon|Ride"] = 415.93, ["Neon|Fly|Ride"] = 512.27}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.72, ["Fly"] = 105, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 171.93, ["Mega|Ride"] = 307.79, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 216.14, ["Ride"] = 286.13, ["Fly|Ride"] = 334.69, ["Neon"] = 1498.88, ["Neon|Ride"] = 1059.56, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.2, ["Fly"] = 87.94, ["Ride"] = 19.45, ["Fly|Ride"] = 105, ["Neon"] = 28.76, ["Neon|Fly"] = 158.65, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 100.59, ["Mega"] = 210, ["Mega|Ride"] = 656.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 21.39, ["Ride"] = 13.34, ["Fly|Ride"] = 28.03, ["Neon"] = 3.5, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 60.35, ["Mega"] = 39.38, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 148.3}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1252.63, ["Ride"] = 1050, ["Fly|Ride"] = 1422.75, ["Neon|Ride"] = 7644.91, ["Neon|Fly|Ride"] = 6051.08, ["Mega"] = 23686.81}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.95, ["Fly"] = 976.6, ["Ride"] = 72.19, ["Neon"] = 72.71, ["Neon|Ride"] = 131.36, ["Mega"] = 315, ["Mega|Ride"] = 379.77, ["Mega|Fly|Ride"] = 695.89}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.86, ["Fly"] = 50.21, ["Ride"] = 44.97, ["Fly|Ride"] = 79.59, ["Neon"] = 20.69, ["Neon|Fly"] = 158.65, ["Neon|Ride"] = 52.87, ["Neon|Fly|Ride"] = 174.24, ["Mega"] = 175.88, ["Mega|Ride"] = 191.05, ["Mega|Fly|Ride"] = 304.4}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.13, ["Fly"] = 39.38, ["Ride"] = 35.43, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 183.75, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.44, ["Fly"] = 83.67, ["Ride"] = 27.46, ["Fly|Ride"] = 98.44, ["Neon"] = 69.42, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.75, ["Ride"] = 111.68, ["Fly|Ride"] = 407.79, ["Neon"] = 164.07, ["Neon|Ride"] = 376.69, ["Mega"] = 1050, ["Mega|Ride"] = 695.89, ["Mega|Fly|Ride"] = 542.53}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 79.33, ["Neon"] = 2.61, ["Neon|Ride"] = 111.29, ["Mega"] = 18.38, ["Mega|Ride"] = 83.54}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 72.19, ["Fly"] = 123.48, ["Ride"] = 94.68, ["Fly|Ride"] = 105.54, ["Neon"] = 446.24, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 447.57, ["Mega"] = 3338.53, ["Mega|Ride"] = 1717.27, ["Mega|Fly|Ride"] = 1563.58}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.4, ["Fly"] = 107.62, ["Ride"] = 30.9, ["Fly|Ride"] = 70.88, ["Neon"] = 63, ["Neon|Ride"] = 110.51, ["Mega|Ride"] = 395.58}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.89, ["Fly|Ride"] = 42, ["Neon"] = 17.26, ["Neon|Fly"] = 79.33, ["Neon|Ride"] = 56.31, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 274.4, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 137.62, ["Neon|Fly|Ride"] = 207.27, ["Mega"] = 362.04, ["Mega|Fly|Ride"] = 473.89}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 63, ["Ride"] = 111.89, ["Fly|Ride"] = 262.5, ["Neon"] = 262.5, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 557.12, ["Mega|Ride"] = 1356.29, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 13.13, ["Neon"] = 16.69, ["Mega"] = 122.07, ["Mega|Ride"] = 117.91, ["Mega|Fly|Ride"] = 316.23}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 16.54, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 521.72}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.57, ["Fly|Ride"] = 58.3, ["Neon"] = 3.81, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 166.94, ["Mega"] = 16.21, ["Mega|Ride"] = 56.09, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.24, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 6.55, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 87.65, ["Mega"] = 61.68, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.55, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 39.38, ["Mega"] = 118.1, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.08, ["Fly|Ride"] = 32.04, ["Neon"] = 6.57, ["Neon|Fly"] = 208.49, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 51.19, ["Ride"] = 91.62, ["Fly|Ride"] = 264.78, ["Neon"] = 196.87, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1043.31, ["Mega"] = 694.32, ["Mega|Ride"] = 1023.47, ["Mega|Fly|Ride"] = 1099.65}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 15.49, ["Fly|Ride"] = 35.44, ["Neon"] = 4.08, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 39.3, ["Mega"] = 19.69, ["Mega|Ride"] = 23.72, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.29, ["Fly"] = 129.92, ["Ride"] = 70.07, ["Fly|Ride"] = 57.19, ["Neon"] = 26.19, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 302.27, ["Mega|Fly"] = 325.52, ["Mega|Ride"] = 192.57, ["Mega|Fly|Ride"] = 834.65}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.23, ["Fly"] = 47.06, ["Ride"] = 27.57, ["Fly|Ride"] = 107.63, ["Neon"] = 124.69, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5, ["Mega|Ride"] = 694.84, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 13.12, ["Fly"] = 196.88, ["Ride"] = 44.63, ["Neon"] = 52.31, ["Mega"] = 366.19, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.6, ["Fly|Ride"] = 44.63, ["Neon"] = 3.71, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.48, ["Neon|Fly|Ride"] = 57.87, ["Mega"] = 72.19, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 145.26, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.1, ["Fly"] = 77.39, ["Ride"] = 38.07, ["Neon"] = 21.98, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 206.05, ["Mega"] = 208.68, ["Mega|Fly"] = 735, ["Mega|Ride"] = 223.28, ["Mega|Fly|Ride"] = 390.21}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 958.13, ["Fly"] = 1377.96, ["Ride"] = 1023.75, ["Fly|Ride"] = 1103.82, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2342.71, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 111.89, ["Ride"] = 166.27, ["Fly|Ride"] = 414.88, ["Neon"] = 556.65, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 820.31, ["Mega"] = 6259.74, ["Mega|Ride"] = 2643.71, ["Mega|Fly|Ride"] = 2347.02}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.47, ["Neon"] = 5.82, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 139.81}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.04, ["Ride"] = 120.75, ["Fly|Ride"] = 229.69, ["Neon"] = 392.42, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1836.19, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1711.05}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 20.92, ["Fly|Ride"] = 90.7, ["Neon"] = 16.21, ["Neon|Fly"] = 55.65, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 278.57, ["Mega|Ride"] = 316.32, ["Mega|Fly|Ride"] = 403.82}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 275.63, ["Fly"] = 950.33, ["Ride"] = 271.68, ["Fly|Ride"] = 369.36, ["Neon|Ride"] = 1237.34, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 59.07, ["Fly|Ride"] = 219.02, ["Neon"] = 31.5, ["Neon|Fly"] = 35.46, ["Neon|Ride"] = 54.37, ["Mega"] = 413.16, ["Mega|Fly"] = 325.52, ["Mega|Ride"] = 632.45}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 28.6, ["Mega"] = 333.87, ["Mega|Ride"] = 357.87}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.17, ["Ride"] = 52.45, ["Fly|Ride"] = 105, ["Neon"] = 151.55, ["Neon|Ride"] = 124.59, ["Mega"] = 639.56, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.75, ["Neon"] = 24.94, ["Neon|Ride"] = 141.91, ["Mega"] = 236.88, ["Mega|Ride"] = 253.3}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.92, ["Ride"] = 13.13, ["Fly|Ride"] = 39.36, ["Neon"] = 2.1, ["Neon|Fly"] = 31.99, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 37.57, ["Mega"] = 23.7, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5130.57, ["Fly|Ride"] = 4845.75, ["Neon"] = 31271.75, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 130426.91}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 18.83, ["Fly"] = 83.67, ["Ride"] = 56.43, ["Neon"] = 52.49, ["Neon|Ride"] = 105, ["Mega"] = 208.68, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 417.34}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 15.65, ["Fly|Ride"] = 35, ["Neon"] = 13.13, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 64.22, ["Mega"] = 124.69, ["Mega|Ride"] = 175.29, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 432.93, ["Fly"] = 547.77, ["Ride"] = 485.63, ["Fly|Ride"] = 560.34, ["Neon"] = 2100, ["Neon|Ride"] = 1528.16, ["Neon|Fly|Ride"] = 1391.76, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.08, ["Ride"] = 32.62, ["Neon"] = 35.32, ["Neon|Ride"] = 291.38, ["Mega"] = 187.95, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.34, ["Fly"] = 4182.38, ["Ride"] = 65.63, ["Neon"] = 23.55, ["Neon|Ride"] = 63.95, ["Mega"] = 415.25, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 278.6}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 20.36, ["Neon"] = 3.81, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.97, ["Mega|Ride"] = 78.09, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 1069.1, ["Ride"] = 765.19, ["Fly|Ride"] = 1390.56, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2940}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.13, ["Ride"] = 59.91, ["Fly|Ride"] = 416.97, ["Neon"] = 32.71, ["Neon|Ride"] = 69.56, ["Neon|Fly|Ride"] = 292.14, ["Mega"] = 170.51, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 380.33}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.96, ["Fly"] = 236.25, ["Ride"] = 44.63, ["Neon"] = 24.75, ["Neon|Ride"] = 51.1, ["Neon|Fly|Ride"] = 219.11, ["Mega"] = 205.04, ["Mega|Fly"] = 789.97, ["Mega|Ride"] = 278.57, ["Mega|Fly|Ride"] = 354.14}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.69, ["Fly|Ride"] = 45.94, ["Neon"] = 17.74, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 77.22, ["Mega"] = 278.57, ["Mega|Fly|Ride"] = 219.61}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.59, ["Ride"] = 38.07, ["Fly|Ride"] = 52.7, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 313.01, ["Mega"] = 557.12, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 974.57}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 83.67, ["Neon"] = 7.35, ["Neon|Ride"] = 45.22, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 101.06, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.88, ["Fly"] = 671.28, ["Ride"] = 538.12, ["Fly|Ride"] = 695.28, ["Neon"] = 2589.57, ["Neon|Ride"] = 2363.11, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9237.86, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 79.95, ["Neon"] = 16.82, ["Neon|Ride"] = 85.39, ["Neon|Fly|Ride"] = 473.74, ["Mega"] = 234.52, ["Mega|Ride"] = 190.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 5.25, ["Neon|Fly"] = 236.64, ["Neon|Ride"] = 36.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 86.63, ["Mega|Fly|Ride"] = 354.77}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 5.24, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 417.34, ["Mega"] = 45.94, ["Mega|Fly"] = 154.43, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Neon"] = 17.77, ["Mega"] = 208.68, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.88, ["Fly"] = 98.44, ["Ride"] = 45.77, ["Fly|Ride"] = 278.34, ["Neon"] = 122.06, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 277.53, ["Mega"] = 828.39, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 933.76}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 13.22, ["Ride"] = 48.39, ["Fly|Ride"] = 128.99, ["Neon"] = 65.61, ["Neon|Ride"] = 141.91, ["Neon|Fly|Ride"] = 278.57, ["Mega"] = 477.23, ["Mega|Ride"] = 531.78, ["Mega|Fly|Ride"] = 694.84}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 14.89, ["Fly|Ride"] = 32.82, ["Neon"] = 28.65, ["Neon|Fly"] = 56.31, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 87.18, ["Mega"] = 395.41, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.62, ["Ride"] = 102.87, ["Fly|Ride"] = 120.93, ["Neon"] = 70.9, ["Neon|Ride"] = 193.9, ["Mega"] = 473.74, ["Mega|Ride"] = 417.34}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 111.57, ["Neon"] = 10.49, ["Neon|Ride"] = 40.34, ["Neon|Fly|Ride"] = 156.35, ["Mega"] = 105, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.31, ["Ride"] = 30.18, ["Fly|Ride"] = 62.56, ["Neon"] = 416.97, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 223.28, ["Mega"] = 937.94, ["Mega|Fly|Ride"] = 822.23}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.74, ["Fly"] = 874.13, ["Neon"] = 274.16, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 56.59, ["Fly"] = 153.58, ["Ride"] = 79.55, ["Fly|Ride"] = 160.13, ["Neon"] = 280.21, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 418.97, ["Mega|Ride"] = 1674.67, ["Mega|Fly|Ride"] = 1788.21}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 38.07, ["Fly"] = 83.67, ["Ride"] = 76.73, ["Fly|Ride"] = 208.49, ["Neon"] = 143.28, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 869.32, ["Mega|Ride"] = 652.5, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.38, ["Ride"] = 57.5, ["Fly|Ride"] = 208.49, ["Neon"] = 139.7, ["Neon|Ride"] = 284.82, ["Mega"] = 1049.99, ["Mega|Ride"] = 789.97}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.96, ["Fly"] = 418.25, ["Ride"] = 32.19, ["Fly|Ride"] = 192.94, ["Neon"] = 114.72, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.78, ["Neon|Fly|Ride"] = 142.13, ["Mega"] = 464.37, ["Mega|Ride"] = 530.39, ["Mega|Fly|Ride"] = 636.59}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.09, ["Fly|Ride"] = 32.73, ["Neon"] = 3.82, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.9, ["Neon|Fly|Ride"] = 43.67, ["Mega"] = 35.44, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 403.77}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 41.49, ["Ride"] = 98.44, ["Fly|Ride"] = 370.06, ["Neon"] = 344.4, ["Neon|Ride"] = 341.25, ["Mega"] = 974.45, ["Mega|Ride"] = 1421.22, ["Mega|Fly|Ride"] = 1283.79}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 3.84, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 292.14, ["Mega"] = 28.05, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.09, ["Ride"] = 65.63, ["Fly|Ride"] = 168.88, ["Neon"] = 156.19, ["Neon|Ride"] = 136.57, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 514.55, ["Mega|Ride"] = 789.97, ["Mega|Fly|Ride"] = 1251.96}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 20.87, ["Mega"] = 22.66}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 39.38, ["Mega"] = 21, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 111.2, ["Fly"] = 223.13, ["Ride"] = 120.78, ["Neon"] = 494.82, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2627.01, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.2, ["Fly"] = 90.57, ["Ride"] = 27.2, ["Fly|Ride"] = 96.15, ["Neon"] = 9.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 111.64, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 52.5, ["Neon"] = 5.93, ["Neon|Ride"] = 36.5, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 34.13, ["Mega|Ride"] = 125.22, ["Mega|Fly|Ride"] = 695.98}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.1, ["Mega|Ride"] = 221.19, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.24, ["Neon"] = 5.93, ["Neon|Ride"] = 155.81, ["Mega"] = 85.04, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 52.49, ["Ride"] = 135.19, ["Fly|Ride"] = 1042.41, ["Neon"] = 424.07, ["Neon|Ride"] = 556.65, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1806.98, ["Mega|Ride"] = 1564.95, ["Mega|Fly|Ride"] = 1530.52}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.47, ["Neon"] = 39.35, ["Neon|Ride"] = 227.07, ["Mega"] = 413.86, ["Mega|Ride"] = 947.48}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.04}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Neon"] = 1115.63, ["Neon|Ride"] = 1183.86, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4005.46}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.04}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.84}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.71}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.34}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.85}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.04}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.4}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.36}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.76}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 19.69}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 213.36}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 11.51}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.33}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.84}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.57}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 552.57}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 788.57}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.4}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1243.27}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.89}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.55}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 31.94}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.3}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.1}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 47.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.33}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.54}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.59}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 17.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.57}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 30.36}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.55}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.54}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 5.62}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.64}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.21}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.26}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.55}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.76}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.75}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.33}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.55}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 12.95}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 219.64}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.88}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.02}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.94}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.43}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 13.12}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.04}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.87}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 131.1}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.91}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.89}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22564.07}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 315.51}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.4}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 71.06}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 47.53}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 44.63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 99.38}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.74}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 91.01}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.51}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 123.87}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.11}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7007.19}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.03}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.59}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.77}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 137.22}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.66}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.94}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.88}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1135.32}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 15.54}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.85}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.61}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 617.56}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 24.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 171.53}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.46}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 47.25}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.19}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.46}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.98}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.5}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.15}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.92}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.77}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.88}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.85}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.73}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 31.76}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 728.44}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
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
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.59}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.12}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.43}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.4}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.55}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 14.39}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.81}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.55}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 8.76}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 30.93}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.39}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.92}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.39}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.68}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.76}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.39}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.4}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.55}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.81}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8088.6}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 20.31}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 9}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.56}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 17.99}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.04}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 7.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.55}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.34}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.28}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4183.4}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 30.98}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.55}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.86}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 66.97}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 65.54}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.48}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.06}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.41}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.54}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 38.94}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.73}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.5}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.05}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.41}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.3}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 32.82}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.06}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.62}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 65.59}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.81}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 15.75}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1042.1}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 38.71}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.66}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 16.12}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 11.81}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 6.12}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.02}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.4}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.49}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.78}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.28}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.16}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.49}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.8}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.37}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21.41}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 5.98}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.84}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 18.9}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.65}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 32.44}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.32}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.14}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.71}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 50.19}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.77}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.59}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.09}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.59}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.08}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 137.45}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 6.57}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.75}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.07}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1277.7}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.2}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 236.38}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 20.44}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 55.12}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.56}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.34}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.58}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.59}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.49}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.34}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.89}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.58}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.52}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.27}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 3.97}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 166.28}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.74}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.07}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.11}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 10.48}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 66.1}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.41}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 182.72}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.9}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 54.32}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 195.59}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.4}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.49}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.38}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 26.46}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 66.07}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 10.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.66}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.29}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 81.37}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.96}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 61.43}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 34.85}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 1.68}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 24.82}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.24}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 64.99}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 37.58}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 81.78}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1700.57}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.71}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 173.62}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 334.69}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.93}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 16.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.33}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.97}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11.67}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.17}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 50.25}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 51.27}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 59.24}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.84}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1116.94}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 317.09}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2370.95}},
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