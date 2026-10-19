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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1050, ["Ride"] = 1123.99, ["Fly|Ride"] = 1292.82, ["Neon"] = 6682.99, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 12603.94}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 498.25, ["Fly|Ride"] = 561.93, ["Neon|Fly|Ride"] = 3182.53, ["Mega"] = 11946.89}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5520.53, ["Ride"] = 5250, ["Fly|Ride"] = 4528.13, ["Neon|Fly|Ride"] = 21628.89}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 161.44, ["Ride"] = 223.13, ["Fly|Ride"] = 263.37, ["Neon"] = 983.9, ["Neon|Ride"] = 948.19, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 842.73, ["Ride"] = 590.2, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1745.63}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.87, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 70.59, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 915.27, ["Mega"] = 354.38}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 42.68, ["Ride"] = 29.91, ["Fly|Ride"] = 65.54, ["Neon"] = 27.44, ["Neon|Fly"] = 159.93, ["Neon|Ride"] = 57.83, ["Neon|Fly|Ride"] = 116.1}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 105, ["Fly"] = 210.7, ["Ride"] = 151.71, ["Fly|Ride"] = 238.81, ["Neon"] = 560.42, ["Neon|Ride"] = 632.14, ["Neon|Fly|Ride"] = 681.64, ["Mega"] = 1586.82}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 44.37, ["Fly"] = 64.47, ["Ride"] = 43.21, ["Fly|Ride"] = 91.04, ["Neon"] = 275.63, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 334.67, ["Mega"] = 1405.92}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.2, ["Fly"] = 84.29, ["Ride"] = 41.1, ["Fly|Ride"] = 74.82, ["Neon|Ride"] = 310.8, ["Neon|Fly|Ride"] = 185.07}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.65, ["Fly"] = 206.07, ["Ride"] = 70.87, ["Fly|Ride"] = 151.71, ["Neon"] = 439.18, ["Neon|Ride"] = 275.62, ["Neon|Fly|Ride"] = 420.37}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.99}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 323.15, ["Fly"] = 466.68, ["Ride"] = 326.8, ["Fly|Ride"] = 367.49, ["Neon|Ride"] = 1405.42, ["Neon|Fly|Ride"] = 1128.75}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 106.4, ["Fly"] = 168.56, ["Ride"] = 102.85, ["Fly|Ride"] = 167.99, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 751.78}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.45, ["Ride"] = 54.79, ["Fly|Ride"] = 131.25, ["Neon"] = 20.1, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.43, ["Fly"] = 286.33, ["Ride"] = 180.08, ["Fly|Ride"] = 216.57, ["Neon"] = 871.17, ["Neon|Fly|Ride"] = 650.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.11, ["Fly"] = 23.19, ["Ride"] = 20.69, ["Fly|Ride"] = 37.94, ["Neon"] = 28.86, ["Neon|Fly"] = 126.42, ["Neon|Ride"] = 93.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 204.75, ["Mega|Fly"] = 393.75}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.36, ["Fly"] = 284.72, ["Ride"] = 138.74, ["Fly|Ride"] = 168.56, ["Neon"] = 328.12, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 474.37, ["Mega"] = 1686.27}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.99}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.69, ["Ride"] = 129.94, ["Fly|Ride"] = 210.7, ["Neon"] = 428.74, ["Neon|Fly|Ride"] = 702.72}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.27, ["Fly"] = 54.79, ["Ride"] = 39.16, ["Fly|Ride"] = 316.03, ["Neon"] = 262.5, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 577.57, ["Mega"] = 2625}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 49.53, ["Fly"] = 141.17, ["Ride"] = 61.69, ["Fly|Ride"] = 103.58, ["Neon"] = 702.63, ["Neon|Ride"] = 281.31, ["Neon|Fly|Ride"] = 407.73, ["Mega"] = 1672.58}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.94, ["Fly"] = 78.75, ["Ride"] = 111.56, ["Fly|Ride"] = 263.37, ["Neon"] = 141.17, ["Neon|Ride"] = 210.72, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 2047.5}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 24.25, ["Ride"] = 37.94, ["Fly|Ride"] = 84, ["Neon"] = 210.7, ["Neon|Ride"] = 209.67, ["Neon|Fly|Ride"] = 281.31, ["Mega"] = 1051.81}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 31.29, ["Fly"] = 136.75, ["Ride"] = 57.74, ["Fly|Ride"] = 159.93, ["Neon"] = 325.5, ["Neon|Ride"] = 198.08, ["Neon|Fly|Ride"] = 262.49}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.25, ["Fly"] = 36.89, ["Ride"] = 20.9, ["Fly|Ride"] = 57.75, ["Neon"] = 32.81, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 57.91, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 183.75, ["Mega|Fly"] = 273.7}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 525.3, ["Ride"] = 459.27, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10539.1}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.61, ["Ride"] = 32.82, ["Fly|Ride"] = 111.78, ["Neon"] = 212.66, ["Neon|Fly|Ride"] = 252.86}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.37, ["Fly"] = 56.89, ["Ride"] = 22.23, ["Fly|Ride"] = 42, ["Neon"] = 82.09, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.96, ["Fly"] = 102.38, ["Ride"] = 99.04, ["Fly|Ride"] = 134.86, ["Neon"] = 366.39, ["Neon|Fly"] = 369.8, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 4637.2}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.11, ["Ride"] = 30.93, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 702.97}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 208.04, ["Fly"] = 288.75, ["Ride"] = 273, ["Fly|Ride"] = 315, ["Neon"] = 780.49, ["Neon|Ride"] = 713.28, ["Neon|Fly|Ride"] = 997.7, ["Mega"] = 6323.47}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 21.94}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.63, ["Fly"] = 35.43, ["Ride"] = 24.25, ["Fly|Ride"] = 63.23, ["Neon"] = 20.67, ["Neon|Fly"] = 136.04, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 131.25, ["Mega|Fly"] = 513.27}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 818.52, ["Fly"] = 2625, ["Ride"] = 891.19, ["Fly|Ride"] = 853.13, ["Neon"] = 17184.8, ["Neon|Ride"] = 6181.05, ["Neon|Fly|Ride"] = 4282.34}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.12, ["Fly"] = 52.5, ["Ride"] = 32.81, ["Fly|Ride"] = 91.49, ["Neon"] = 99.04, ["Neon|Ride"] = 99.05, ["Neon|Fly|Ride"] = 252.86, ["Mega"] = 787.5}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 210, ["Fly"] = 358.15, ["Ride"] = 244.02, ["Fly|Ride"] = 300.57, ["Neon"] = 830.82, ["Neon|Ride"] = 763.93, ["Neon|Fly|Ride"] = 954.64}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 46.97}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.66, ["Fly"] = 112.73, ["Ride"] = 65.63, ["Fly|Ride"] = 145.69, ["Neon"] = 104.9, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 543.64, ["Mega"] = 637.98}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 111.17, ["Ride"] = 166.69, ["Fly|Ride"] = 262.5, ["Neon"] = 639.19, ["Neon|Ride"] = 526.98}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 122.97, ["Fly"] = 157.49, ["Ride"] = 162.24, ["Fly|Ride"] = 274.32, ["Neon"] = 360.93, ["Neon|Fly"] = 562.53, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 472.49}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 38.47}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 55, ["Fly"] = 68.78, ["Ride"] = 62.89, ["Fly|Ride"] = 63.93, ["Neon|Ride"] = 365.59, ["Neon|Fly|Ride"] = 416.16, ["Mega"] = 4215.65}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.25, ["Fly"] = 98.44, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 42, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 562.59, ["Mega"] = 131.25, ["Mega|Fly"] = 358.42}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 538.13, ["Fly"] = 496.13, ["Ride"] = 477.75, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 3792.71, ["Neon|Fly|Ride"] = 1743}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 94.5, ["Fly"] = 155.92, ["Ride"] = 118.13, ["Fly|Ride"] = 164.07, ["Neon"] = 477.75, ["Neon|Ride"] = 546.79, ["Neon|Fly|Ride"] = 701.67}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4213.6, ["Ride"] = 3885, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14748.32}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.25, ["Fly"] = 120.1, ["Ride"] = 56.91, ["Fly|Ride"] = 131.14, ["Neon|Ride"] = 322.88, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1894.94}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.49, ["Ride"] = 68.06, ["Fly|Ride"] = 83.45, ["Neon"] = 637.28, ["Neon|Ride"] = 196.88, ["Mega"] = 6183.29}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.77, ["Fly"] = 56.35, ["Ride"] = 50.96, ["Fly|Ride"] = 87.63, ["Neon"] = 188.57, ["Neon|Ride"] = 132.56, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 984.36}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40.58, ["Ride"] = 62.07, ["Fly|Ride"] = 71.6, ["Neon|Ride"] = 318.62}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.01, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Fly|Ride"] = 1264.25}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1685.45, ["Ride"] = 754.69, ["Fly|Ride"] = 1044.23, ["Neon|Fly|Ride"] = 3458.74}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.61}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.56, ["Fly"] = 52.68, ["Ride"] = 38.07, ["Fly|Ride"] = 77.96, ["Neon"] = 246.75, ["Neon|Ride"] = 103.83, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 2107.84}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.27}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4986.19, ["Neon|Fly|Ride"] = 10834.69}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.49, ["Fly"] = 141.17, ["Ride"] = 20.41, ["Fly|Ride"] = 62.01, ["Neon"] = 65.51, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 561.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.72, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 95.87, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 1063.29}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 69.45, ["Fly"] = 281.27, ["Ride"] = 58.95, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 390.88, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4215.65}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.16, ["Fly"] = 70.59, ["Ride"] = 25.91, ["Fly|Ride"] = 60.38, ["Neon"] = 56.89, ["Neon|Ride"] = 131.25, ["Mega"] = 1405.92}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1765.32, ["Fly"] = 2332.23, ["Ride"] = 1851.94, ["Fly|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 3596.25}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 33708.73, ["Ride"] = 52500, ["Fly|Ride"] = 26906.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72870.81, ["Mega"] = 210000}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.97, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 947.02, ["Neon"] = 316.03, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 842.83, ["Mega"] = 947.47}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 86.81, ["Ride"] = 74.01, ["Fly|Ride"] = 163.24, ["Neon"] = 17.75, ["Neon|Fly"] = 151.57, ["Neon|Ride"] = 66.85, ["Neon|Fly|Ride"] = 193.6}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.17}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.59, ["Ride"] = 36.75, ["Fly|Ride"] = 124.68, ["Neon"] = 58.46, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 394.99, ["Mega"] = 229.69}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 795.33, ["Ride"] = 682.5, ["Fly|Ride"] = 779.62, ["Neon"] = 2738.85, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 814.78, ["Fly"] = 975.19, ["Ride"] = 844.82, ["Fly|Ride"] = 918.75, ["Neon"] = 4073.5, ["Neon|Ride"] = 3652.59, ["Neon|Fly|Ride"] = 2493.75}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.69, ["Fly"] = 119.4, ["Ride"] = 30, ["Fly|Ride"] = 74.81, ["Neon"] = 85.32, ["Neon|Ride"] = 106.47, ["Neon|Fly|Ride"] = 252.86, ["Mega"] = 1205.46}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.6}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 77.07, ["Fly"] = 128.34, ["Ride"] = 81.38, ["Fly|Ride"] = 118.13, ["Neon"] = 420, ["Neon|Ride"] = 632.14, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 77.97, ["Ride"] = 112.24, ["Fly|Ride"] = 127.32, ["Neon"] = 420, ["Neon|Ride"] = 532.53, ["Neon|Fly|Ride"] = 15911.38, ["Mega"] = 1371.56}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.67, ["Fly"] = 35.44, ["Ride"] = 22.99, ["Fly|Ride"] = 42.77, ["Neon"] = 45.94, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 67.44, ["Neon|Fly|Ride"] = 100.06, ["Mega"] = 286.13}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 126.71, ["Fly"] = 147.13, ["Ride"] = 161.44, ["Fly|Ride"] = 205.78, ["Neon"] = 725.82, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 578.82, ["Mega"] = 5058.77}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Fly"] = 100.09, ["Ride"] = 51.1, ["Fly|Ride"] = 220.5, ["Neon"] = 30.97, ["Neon|Ride"] = 139.13}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.99, ["Fly"] = 63, ["Ride"] = 32.25, ["Fly|Ride"] = 78.78, ["Neon"] = 126.42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.69, ["Mega"] = 1050}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 30.96, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 210, ["Neon|Ride"] = 282.19, ["Mega"] = 918.75}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.88, ["Fly"] = 210.7, ["Ride"] = 26.25, ["Fly|Ride"] = 70.87, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 302.38}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7023.02, ["Ride"] = 6555.94, ["Fly|Ride"] = 5584.69, ["Neon"] = 35113.98, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 24020.39}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 242.71, ["Fly"] = 234.78, ["Ride"] = 247.68, ["Fly|Ride"] = 295.21, ["Neon|Fly|Ride"] = 530.66}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.79, ["Fly"] = 116.71, ["Ride"] = 93.1, ["Fly|Ride"] = 201.67, ["Neon"] = 141.74, ["Neon|Ride"] = 167.9, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 415.44}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.61, ["Fly"] = 88.36, ["Ride"] = 28.46, ["Fly|Ride"] = 49.53, ["Neon"] = 21.45, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 632.14, ["Mega"] = 144.38}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 60.29, ["Fly"] = 262.5, ["Ride"] = 102.27, ["Fly|Ride"] = 227.81, ["Neon"] = 196.87, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 387.16, ["Mega"] = 534.35}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 11351.92, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.13, ["Ride"] = 326.82, ["Fly|Ride"] = 337.11, ["Neon"] = 1376.8, ["Neon|Ride"] = 1405.42, ["Neon|Fly|Ride"] = 1595.06}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 55.13, ["Fly"] = 91.88, ["Ride"] = 59.07, ["Fly|Ride"] = 129.94, ["Neon"] = 400.31, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 525.73}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.38, ["Ride"] = 25.49, ["Fly|Ride"] = 45.85, ["Neon"] = 67.46, ["Neon|Fly"] = 270.92, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 525}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.08, ["Fly"] = 842.73, ["Ride"] = 393.74, ["Fly|Ride"] = 534.19, ["Neon"] = 1537.52, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 2624.99}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.17, ["Fly"] = 104.12, ["Ride"] = 26.24, ["Fly|Ride"] = 138.8, ["Neon"] = 34.04, ["Neon|Ride"] = 99.05, ["Neon|Fly|Ride"] = 281.31, ["Mega|Fly"] = 263.92}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.09, ["Fly"] = 204.38, ["Ride"] = 158.82, ["Fly|Ride"] = 211.73, ["Neon"] = 615.2, ["Neon|Fly"] = 525, ["Neon|Ride"] = 521.52, ["Neon|Fly|Ride"] = 557.82}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.68, ["Fly"] = 19.19, ["Ride"] = 18.69, ["Fly|Ride"] = 32.37, ["Neon"] = 159.93, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 2529.39}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.58}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Ride"] = 85.32, ["Fly|Ride"] = 421.38, ["Neon"] = 375.93, ["Neon|Fly"] = 420.32, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 477.33}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.45, ["Fly"] = 104.3, ["Ride"] = 34.13, ["Fly|Ride"] = 95.49, ["Neon"] = 105, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 185.74}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 52.31, ["Fly"] = 141.17, ["Ride"] = 115.5, ["Fly|Ride"] = 249.38, ["Neon"] = 285.49, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1580.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.98, ["Ride"] = 29.23, ["Fly|Ride"] = 136.06, ["Neon"] = 21, ["Neon|Ride"] = 112.19, ["Neon|Fly|Ride"] = 281.31}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.82, ["Fly"] = 56.44, ["Ride"] = 28.46, ["Fly|Ride"] = 52.68, ["Neon"] = 159.93, ["Neon|Ride"] = 136.98, ["Neon|Fly|Ride"] = 238.67}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 484.32, ["Ride"] = 505.32, ["Fly|Ride"] = 541.65, ["Neon|Fly|Ride"] = 5548.93}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.14, ["Fly"] = 99.04, ["Ride"] = 57.59, ["Fly|Ride"] = 131.24, ["Neon"] = 175.93, ["Neon|Ride"] = 182.61, ["Neon|Fly|Ride"] = 326.21, ["Mega"] = 1035.82}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 61.09, ["Fly"] = 119.89, ["Ride"] = 70.88, ["Fly|Ride"] = 118.13, ["Neon"] = 421.38, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 458.1}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.77, ["Fly"] = 80, ["Ride"] = 69.57, ["Fly|Ride"] = 122.07, ["Neon"] = 97.01, ["Neon|Ride"] = 177.14, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 433.02, ["Mega|Fly"] = 525}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 8862, ["Fly|Ride"] = 8098.13, ["Neon|Fly|Ride"] = 17718.75}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1422.75, ["Fly"] = 1486.83, ["Ride"] = 1509.38, ["Fly|Ride"] = 1363.69, ["Neon|Ride"] = 4776.7, ["Neon|Fly|Ride"] = 4734.32}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 576.22, ["Ride"] = 566.05, ["Fly|Ride"] = 538.13, ["Neon"] = 2388.07, ["Neon|Ride"] = 3139.53, ["Neon|Fly|Ride"] = 3160.59, ["Mega"] = 21078.18}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.71, ["Fly"] = 23.38, ["Ride"] = 24.55, ["Fly|Ride"] = 38.07, ["Neon"] = 64.45, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.12, ["Fly"] = 78.74, ["Ride"] = 29.77, ["Fly|Ride"] = 180.14, ["Neon"] = 22.23, ["Neon|Ride"] = 56, ["Mega"] = 167.9}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 84.29, ["Ride"] = 44.28, ["Fly|Ride"] = 97.91, ["Neon"] = 537.05, ["Neon|Ride"] = 225.47, ["Neon|Fly|Ride"] = 238.67}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.01, ["Fly"] = 26.25, ["Ride"] = 19.49, ["Fly|Ride"] = 36.75, ["Neon"] = 32.82, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 261.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 304.5, ["Fly"] = 369.49, ["Ride"] = 321.57, ["Fly|Ride"] = 351.75, ["Neon|Ride"] = 1228.27, ["Neon|Fly|Ride"] = 1764.68}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.45, ["Fly"] = 59.07, ["Ride"] = 30.84, ["Fly|Ride"] = 89.52, ["Neon"] = 208.95, ["Neon|Fly"] = 310.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 265.51, ["Mega"] = 660.81}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.34, ["Fly"] = 22.32, ["Ride"] = 21.51, ["Fly|Ride"] = 42.9, ["Neon"] = 141.17, ["Neon|Fly"] = 136.06, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 562.53, ["Fly"] = 1048.69, ["Ride"] = 526.71, ["Fly|Ride"] = 842.73, ["Neon|Fly|Ride"] = 2809.76}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1267.88, ["Ride"] = 1115.63, ["Fly|Ride"] = 1400.34, ["Neon"] = 4916.22, ["Neon|Fly|Ride"] = 5056.93}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.24, ["Fly"] = 219.12, ["Ride"] = 112.73, ["Fly|Ride"] = 120.77, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.75, ["Fly"] = 212.14, ["Ride"] = 189, ["Fly|Ride"] = 210, ["Neon"] = 854.32, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 595.42}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 73.5, ["Fly"] = 121.15, ["Ride"] = 53.81, ["Fly|Ride"] = 121.74, ["Neon"] = 236.24, ["Neon|Ride"] = 272.99}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 236.25, ["Ride"] = 315, ["Fly|Ride"] = 407.69, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1336.51}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2275.35, ["Ride"] = 2275.35, ["Fly|Ride"] = 1837.5}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 210.7, ["Ride"] = 52.47, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 316.08, ["Neon|Fly|Ride"] = 343.88}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.23, ["Ride"] = 661.5, ["Fly|Ride"] = 681.19, ["Neon|Fly|Ride"] = 1345.22}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 70.87, ["Ride"] = 45.94, ["Fly|Ride"] = 87.26, ["Neon|Ride"] = 318.62, ["Neon|Fly|Ride"] = 251.69}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.83, ["Fly"] = 43.32, ["Ride"] = 21.1, ["Fly|Ride"] = 54.5, ["Neon"] = 26.25, ["Neon|Fly"] = 120.75, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 144.36}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.66, ["Ride"] = 128.34, ["Fly|Ride"] = 205.43, ["Neon"] = 347.64, ["Neon|Ride"] = 490.95, ["Neon|Fly|Ride"] = 702.72, ["Mega"] = 1540.83}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 920.14, ["Ride"] = 867.37, ["Fly|Ride"] = 877.32, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2795.63}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 653.63, ["Ride"] = 1123.99, ["Fly|Ride"] = 853.13}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.75, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 44.62, ["Neon"] = 149.6, ["Neon|Ride"] = 105.36, ["Neon|Fly|Ride"] = 210.72, ["Mega"] = 796.87}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.12, ["Ride"] = 27.53, ["Fly|Ride"] = 85.32, ["Neon"] = 141.17, ["Neon|Ride"] = 126.44, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 702.19}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.5, ["Ride"] = 22.51, ["Fly|Ride"] = 159.93, ["Neon"] = 21.1, ["Neon|Fly"] = 318.65, ["Neon|Ride"] = 57.29, ["Neon|Fly|Ride"] = 183.78, ["Mega"] = 131.07, ["Mega|Fly"] = 542.4}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.82, ["Fly"] = 42.88, ["Ride"] = 40.28, ["Fly|Ride"] = 110.15, ["Neon"] = 237.2, ["Neon|Ride"] = 281.31, ["Neon|Fly|Ride"] = 233.05}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 118.13, ["Fly|Ride"] = 562.53, ["Neon"] = 437.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2038.26}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.46, ["Fly"] = 43.32, ["Ride"] = 28.92, ["Fly|Ride"] = 78.44, ["Neon"] = 72.1, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 149.43}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 41.1, ["Fly"] = 65.63, ["Ride"] = 42, ["Fly|Ride"] = 76.57, ["Neon"] = 331.83, ["Neon|Fly"] = 1405.25, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 328.72, ["Mega"] = 2100}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.84, ["Fly"] = 21, ["Ride"] = 18.02, ["Fly|Ride"] = 31.18, ["Neon"] = 28.88, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 737.76}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.17, ["Fly"] = 49.37, ["Ride"] = 33.72, ["Fly|Ride"] = 61.68, ["Neon"] = 52.37, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 79.96, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 315.13}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.5, ["Fly"] = 65.63, ["Ride"] = 55.13, ["Fly|Ride"] = 94.5, ["Neon"] = 578.44, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 262.49}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1394.31, ["Fly|Ride"] = 1475.25, ["Neon|Fly|Ride"] = 3567.56}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.75, ["Fly"] = 870.12, ["Ride"] = 446.25, ["Fly|Ride"] = 505.32, ["Neon|Fly|Ride"] = 2804.5}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 273, ["Ride"] = 341.25, ["Fly|Ride"] = 404.25, ["Neon"] = 1181.25, ["Neon|Ride"] = 1545.54}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.71}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.93, ["Ride"] = 51.18, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 350.44}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33708.73, ["Fly"] = 65625, ["Ride"] = 23876.25, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 38062.5, ["Mega"] = 210781.69}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 279.37, ["Fly"] = 351.85, ["Ride"] = 331.78, ["Fly|Ride"] = 374.73, ["Neon"] = 1050, ["Neon|Fly"] = 1068.16, ["Neon|Ride"] = 891.45, ["Neon|Fly|Ride"] = 1640.63, ["Mega"] = 4215.65}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.7, ["Fly"] = 525, ["Ride"] = 209.65, ["Fly|Ride"] = 257.23}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 196.88, ["Fly"] = 281.27, ["Ride"] = 150.94, ["Fly|Ride"] = 252.83, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 651.1}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.82, ["Fly"] = 91.88, ["Ride"] = 30.97, ["Fly|Ride"] = 126, ["Neon|Ride"] = 95.47, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 714.44}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4265.63, ["Ride"] = 3937.5, ["Fly|Ride"] = 3937.5, ["Neon"] = 27388.35, ["Neon|Fly|Ride"] = 28094.38}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.88, ["Fly"] = 52.68, ["Ride"] = 27.43, ["Fly|Ride"] = 48.99, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 199.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 49, ["Fly"] = 106.51, ["Ride"] = 56.79, ["Fly|Ride"] = 96.56, ["Neon"] = 314.26, ["Neon|Fly"] = 1405.25, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 262.47}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 500.07, ["Fly"] = 656.25, ["Ride"] = 737.4, ["Fly|Ride"] = 689.07, ["Neon|Ride"] = 1968.01, ["Neon|Fly|Ride"] = 1863.75}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.42, ["Fly"] = 26.25, ["Ride"] = 27.36, ["Fly|Ride"] = 47.55, ["Neon"] = 118.12, ["Neon|Ride"] = 126.51, ["Neon|Fly|Ride"] = 183.19}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.95, ["Ride"] = 27.57, ["Fly|Ride"] = 79.97, ["Neon"] = 95.82, ["Neon|Ride"] = 119.35, ["Neon|Fly|Ride"] = 252.86}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.09, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 737.4, ["Neon|Ride"] = 766.75, ["Neon|Fly|Ride"] = 1053.54}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 18.09, ["Fly"] = 106.56, ["Ride"] = 68.16, ["Fly|Ride"] = 131.25, ["Neon"] = 70.59, ["Neon|Fly"] = 105.35, ["Neon|Ride"] = 97.86, ["Neon|Fly|Ride"] = 234.98, ["Mega"] = 281.4, ["Mega|Fly"] = 731.42}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 6207.84, ["Ride"] = 4035.94, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42155.3}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.05, ["Fly"] = 141.17, ["Ride"] = 65.34, ["Fly|Ride"] = 157.5, ["Neon"] = 393.99, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 773.58}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7612.5, ["Fly"] = 8708.45, ["Ride"] = 6857.82, ["Fly|Ride"] = 7168.88, ["Neon|Fly|Ride"] = 17692.5}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.02, ["Fly"] = 23.44, ["Ride"] = 18.88, ["Fly|Ride"] = 35.9, ["Neon"] = 24.61, ["Neon|Fly"] = 59, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 222.23}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 14.28, ["Fly"] = 28.88, ["Ride"] = 28.46, ["Fly|Ride"] = 54.92, ["Neon"] = 183.3, ["Neon|Fly"] = 232.81, ["Neon|Ride"] = 105.36, ["Neon|Fly|Ride"] = 159.83}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.23}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.46, ["Ride"] = 32.12, ["Fly|Ride"] = 116.02, ["Neon"] = 281.27, ["Neon|Ride"] = 139.13, ["Mega"] = 1050}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 29.36, ["Fly"] = 190.37, ["Ride"] = 70.59, ["Fly|Ride"] = 99.73, ["Neon"] = 155.82, ["Neon|Ride"] = 236.25, ["Mega"] = 945}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.66, ["Fly"] = 21.54, ["Ride"] = 24.25, ["Fly|Ride"] = 34.92, ["Neon|Ride"] = 141.19, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2529.39}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8568.36}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 30.53}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 233.31, ["Ride"] = 351.85, ["Fly|Ride"] = 259.88}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.03, ["Fly"] = 128.93, ["Ride"] = 37.45, ["Fly|Ride"] = 126.52, ["Neon"] = 141.17, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.44, ["Fly"] = 32.82, ["Ride"] = 30.56, ["Fly|Ride"] = 84.29, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2729.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.61, ["Fly"] = 421.38, ["Ride"] = 210.7, ["Fly|Ride"] = 281.27, ["Neon"] = 955.44, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1545.54}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 70.88, ["Ride"] = 122.2, ["Fly|Ride"] = 210.7, ["Neon"] = 773.2, ["Neon|Ride"] = 547.85, ["Neon|Fly|Ride"] = 928.16}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.49, ["Fly"] = 315, ["Ride"] = 177.19, ["Fly|Ride"] = 213.45, ["Neon"] = 944.99, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3230.78, ["Ride"] = 2014.03, ["Fly|Ride"] = 2270.63, ["Neon"] = 14796.04, ["Neon|Ride"] = 8764.3, ["Neon|Fly|Ride"] = 7875}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 104.3, ["Ride"] = 56.8, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Ride"] = 197.03, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 947.47}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 794.28, ["Fly"] = 2100, ["Ride"] = 721.88, ["Fly|Ride"] = 774.38, ["Neon|Ride"] = 4073.99}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 44.63}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.33, ["Ride"] = 51.97, ["Fly|Ride"] = 342.79, ["Neon"] = 81.29, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 126.44, ["Neon|Fly|Ride"] = 419.31, ["Mega"] = 441.72}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.24, ["Fly"] = 262.5, ["Ride"] = 27.45, ["Fly|Ride"] = 104.3, ["Neon"] = 39.29, ["Neon|Fly"] = 315, ["Neon|Ride"] = 62.18, ["Neon|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.38}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.29, ["Fly"] = 104.62, ["Ride"] = 32.67, ["Fly|Ride"] = 82.18, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["Fly"] = 77.97, ["Ride"] = 49.03, ["Fly|Ride"] = 52.41, ["Neon|Fly|Ride"] = 335.04}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6531.08, ["Fly|Ride"] = 4907.44, ["Neon|Fly|Ride"] = 12468.75}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.77, ["Fly"] = 65.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.37, ["Neon"] = 42.77, ["Neon|Fly"] = 141.17, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.15, ["Mega"] = 535.23}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.14}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 95.52, ["Fly"] = 372.92, ["Ride"] = 132.74, ["Fly|Ride"] = 160.09, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 859.18}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 43.32, ["Ride"] = 95.51, ["Fly|Ride"] = 190.32, ["Neon"] = 291.38, ["Neon|Ride"] = 285.04, ["Neon|Fly|Ride"] = 421.42, ["Mega"] = 955.77}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.59, ["Fly"] = 70.47, ["Ride"] = 25.44, ["Fly|Ride"] = 55.13, ["Neon"] = 116.82, ["Neon|Fly"] = 227.57, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 208.69}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.2, ["Fly"] = 70.59, ["Ride"] = 22.85, ["Fly|Ride"] = 61.1, ["Neon"] = 32.79, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 179.68, ["Mega|Fly"] = 7026.43}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.74, ["Ride"] = 32.25, ["Fly|Ride"] = 91.88, ["Neon"] = 91.58, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 216.57}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.21, ["Fly"] = 30.19, ["Ride"] = 24.94, ["Fly|Ride"] = 42.1, ["Neon"] = 365.54, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 223.13}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.25, ["Ride"] = 131.21, ["Fly|Ride"] = 281.27, ["Neon"] = 168.56, ["Neon|Ride"] = 231, ["Mega"] = 1187.76}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 210, ["Ride"] = 598.5, ["Fly|Ride"] = 3791.2, ["Neon|Fly|Ride"] = 28094.38}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 44.54, ["Fly"] = 212.52, ["Ride"] = 87.41, ["Fly|Ride"] = 174.72, ["Neon"] = 300.57, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 547.85, ["Mega"] = 1065.52}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 955.01, ["Fly"] = 1363.1, ["Ride"] = 945, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 4218.31, ["Neon|Fly|Ride"] = 3675}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 361.59, ["Fly"] = 702.63, ["Ride"] = 413.44, ["Fly|Ride"] = 541.82, ["Neon"] = 2139.38, ["Neon|Ride"] = 2388.36, ["Neon|Fly|Ride"] = 2682.29, ["Mega"] = 7869.56}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.06}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.73}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.97, ["Fly"] = 23.27, ["Ride"] = 24.06, ["Fly|Ride"] = 50.68, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 166.47, ["Mega"] = 555.42}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 250.78, ["Fly"] = 392.03, ["Ride"] = 275.47, ["Fly|Ride"] = 354.53, ["Neon"] = 1114.51, ["Neon|Ride"] = 1068.01, ["Neon|Fly|Ride"] = 1062.12}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 114.18, ["Ride"] = 168.56, ["Fly|Ride"] = 252, ["Neon"] = 590.63, ["Neon|Ride"] = 744.85, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 3232.36}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 210.7, ["Ride"] = 128.77, ["Fly|Ride"] = 210.7, ["Neon"] = 1123.99, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 2317.77, ["Neon|Fly|Ride"] = 913.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.14, ["Ride"] = 26.25, ["Fly|Ride"] = 171.71, ["Neon"] = 39.37, ["Neon|Ride"] = 62.06, ["Neon|Fly|Ride"] = 238.11, ["Mega"] = 264.75}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.6, ["Fly"] = 63.23, ["Ride"] = 27.14, ["Fly|Ride"] = 78.64, ["Neon"] = 177.19, ["Neon|Ride"] = 147.51, ["Neon|Fly|Ride"] = 440.39}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.38, ["Fly"] = 102.36, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 7.88, ["Fly"] = 70.59, ["Ride"] = 53.81, ["Fly|Ride"] = 155.92, ["Neon"] = 19.69, ["Neon|Ride"] = 69.67, ["Neon|Fly|Ride"] = 154.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 249.38, ["Ride"] = 290.05, ["Fly|Ride"] = 364.81, ["Neon"] = 1658.06, ["Neon|Ride"] = 1353.2, ["Neon|Fly|Ride"] = 1424.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 99.04, ["Fly"] = 562.53, ["Ride"] = 164.07, ["Fly|Ride"] = 238.98, ["Neon"] = 525, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 643.16}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 60.12, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 126.42, ["Neon"] = 380.63, ["Neon|Ride"] = 535.21, ["Neon|Fly|Ride"] = 408.19}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 16.7, ["Fly"] = 78.75, ["Ride"] = 28.46, ["Fly|Ride"] = 281.27, ["Neon"] = 115.5, ["Neon|Ride"] = 606.21, ["Neon|Fly|Ride"] = 492.01}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.42, ["Fly"] = 42.15, ["Ride"] = 35.84, ["Fly|Ride"] = 84.29, ["Neon"] = 77.43, ["Neon|Ride"] = 107.47, ["Neon|Fly|Ride"] = 526.78, ["Mega"] = 373.1, ["Mega|Fly"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.12, ["Fly"] = 52.47, ["Ride"] = 19.69, ["Fly|Ride"] = 49.53, ["Neon"] = 20.46, ["Neon|Ride"] = 50.52, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.25}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1101.86, ["Fly"] = 1082.18, ["Ride"] = 851.82, ["Fly|Ride"] = 918.64, ["Neon"] = 3513.09, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 400.31, ["Fly"] = 407.69, ["Ride"] = 393.65, ["Fly|Ride"] = 393.75, ["Neon"] = 1277.38, ["Neon|Ride"] = 2528.48, ["Neon|Fly|Ride"] = 1658.27, ["Mega"] = 10539.1}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.32, ["Fly"] = 168.56, ["Ride"] = 103.64, ["Fly|Ride"] = 210, ["Neon"] = 323.42, ["Neon|Ride"] = 326.31, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1312.5}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 1094.62, ["Mega"] = 10539.1}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.69, ["Fly"] = 52.5, ["Ride"] = 26.17, ["Fly|Ride"] = 72.18, ["Neon"] = 169.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 273.93}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 232.81, ["Ride"] = 255.68, ["Fly|Ride"] = 616.88, ["Neon"] = 762.83, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4173.75}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.4, ["Fly"] = 125.98, ["Ride"] = 77.78, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 601.43, ["Neon|Fly|Ride"] = 562.59}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1968.75, ["Ride"] = 2165.63, ["Fly|Ride"] = 2021.14, ["Neon|Fly|Ride"] = 7726.58, ["Mega"] = 50587.62}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.41, ["Fly"] = 77.26, ["Ride"] = 38.19, ["Fly|Ride"] = 52.5, ["Neon"] = 67.6, ["Neon|Fly"] = 233.87, ["Neon|Ride"] = 136.98, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 352.02, ["Mega|Fly"] = 561.52}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.8, ["Ride"] = 82.95, ["Fly|Ride"] = 105, ["Neon"] = 223.13, ["Neon|Ride"] = 375.9, ["Neon|Fly|Ride"] = 562.59}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.85, ["Ride"] = 77.31, ["Fly|Ride"] = 90.84, ["Neon"] = 525, ["Neon|Fly|Ride"] = 534.15}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2106.81, ["Fly"] = 1592.56, ["Ride"] = 1048.69, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5091.79}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 485.63, ["Fly"] = 525, ["Ride"] = 661.15, ["Fly|Ride"] = 610.98, ["Neon|Fly|Ride"] = 3182.53}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 68.16, ["Fly"] = 318.76, ["Ride"] = 99.74, ["Fly|Ride"] = 196.88, ["Neon"] = 445.6, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 582.94, ["Mega"] = 5621.56}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.77, ["Ride"] = 21.68, ["Fly|Ride"] = 61.64, ["Neon"] = 68.04, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.19, ["Fly"] = 68.25, ["Ride"] = 55.13, ["Fly|Ride"] = 98.44, ["Neon"] = 284.82, ["Neon|Fly"] = 337.11, ["Neon|Ride"] = 218.38, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 1115.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 768.11, ["Fly"] = 1098.33, ["Ride"] = 761.25, ["Fly|Ride"] = 832.1, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2228.63}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 706.98}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5236.88, ["Ride"] = 6082.33, ["Fly|Ride"] = 5899.04, ["Neon"] = 42000, ["Neon|Ride"] = 30195.12, ["Neon|Fly|Ride"] = 17584.88}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 274.16, ["Fly"] = 395.05, ["Ride"] = 328.13, ["Neon"] = 1685.45, ["Neon|Fly|Ride"] = 2107.06, ["Mega"] = 6323.47}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.87, ["Fly"] = 281.27, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon"] = 632.05, ["Neon|Ride"] = 576.29, ["Neon|Fly|Ride"] = 632.14}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.96, ["Fly"] = 42.09, ["Ride"] = 30.18, ["Fly|Ride"] = 89.52, ["Neon"] = 152.24, ["Neon|Fly"] = 1273.35, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 982.26}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.13, ["Fly"] = 33.72, ["Ride"] = 22.99, ["Fly|Ride"] = 40.69, ["Neon"] = 210.7, ["Neon|Ride"] = 318.62, ["Neon|Fly|Ride"] = 197.03, ["Mega"] = 1312.5}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.43, ["Fly"] = 281.27, ["Ride"] = 27.28, ["Fly|Ride"] = 109.56, ["Neon"] = 154.88, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 4214.12, ["Mega"] = 645.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.63, ["Fly"] = 77.97, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.44, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 97.17, ["Mega"] = 316.19}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.25, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 139.13, ["Neon"] = 157.5, ["Neon|Fly"] = 842.83, ["Neon|Ride"] = 248.64, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 610.33}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 463.18, ["Fly"] = 465.94, ["Ride"] = 473.32, ["Fly|Ride"] = 523.68, ["Neon"] = 1578.01, ["Neon|Ride"] = 1468.63, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 7875}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 19.56, ["Ride"] = 16.94, ["Fly|Ride"] = 35.84, ["Neon"] = 19.46, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 70.51, ["Mega"] = 227.66}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 38.97, ["Fly"] = 92.47, ["Ride"] = 73.37, ["Fly|Ride"] = 142.7, ["Neon"] = 183.73, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 301.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Ride"] = 826.77, ["Fly|Ride"] = 843.28, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1744.32}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 41.81, ["Fly"] = 60.38, ["Ride"] = 48.41, ["Fly|Ride"] = 90.56, ["Neon|Ride"] = 188.9, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 1575}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.5, ["Fly"] = 422.62, ["Ride"] = 290.79, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1826.83, ["Neon|Fly|Ride"] = 1264.25}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 181.91, ["Fly"] = 178.48, ["Ride"] = 196.88, ["Fly|Ride"] = 233.83, ["Neon"] = 842.73, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 942.93, ["Mega"] = 4326}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.69, ["Fly|Ride"] = 812.34, ["Neon|Fly|Ride"] = 2999.96}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.25, ["Fly"] = 84.29, ["Ride"] = 41.77, ["Fly|Ride"] = 99.04, ["Neon"] = 87.94, ["Neon|Fly"] = 286.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 227.94, ["Mega"] = 354.38}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4073.5, ["Ride"] = 3543.75, ["Fly|Ride"] = 3359.99, ["Neon"] = 14046.02, ["Neon|Fly|Ride"] = 7350}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 105.25, ["Fly"] = 171.42, ["Ride"] = 141.17, ["Fly|Ride"] = 203.44, ["Neon"] = 433.13, ["Neon|Fly"] = 562.53, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 731.16}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.48, ["Fly"] = 27.41, ["Ride"] = 15.82, ["Fly|Ride"] = 38.53, ["Neon"] = 22.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 151.78, ["Mega|Fly"] = 446.25}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.88, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 20.9, ["Neon|Fly"] = 116.95, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 159.21}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 43.4, ["Fly"] = 84.29, ["Ride"] = 42.88, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 311.07}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 945, ["Ride"] = 1050, ["Fly|Ride"] = 1115.52}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.69, ["Fly"] = 26.25, ["Ride"] = 25.88, ["Fly|Ride"] = 55.13, ["Neon"] = 452.13, ["Neon|Ride"] = 155.93, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 2520}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.17, ["Ride"] = 28.25, ["Fly|Ride"] = 78.74, ["Neon"] = 84.29, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 207.65, ["Mega"] = 920.08}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 78.56, ["Fly"] = 157.5, ["Ride"] = 85.19, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 446.24, ["Neon|Fly|Ride"] = 452.82}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 219.23, ["Ride"] = 212.97, ["Fly|Ride"] = 280.76, ["Neon|Ride"] = 1053.54, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 10539.1}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.91, ["Ride"] = 35.84, ["Fly|Ride"] = 93.09, ["Neon"] = 20.27, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 49.53, ["Mega"] = 150.1, ["Mega|Fly"] = 228.68}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 168.62, ["Ride"] = 205.09, ["Fly|Ride"] = 307.95, ["Neon"] = 1259.88, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1591.87, ["Mega"] = 3231.31}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.34, ["Fly"] = 42.15, ["Ride"] = 16.7, ["Fly|Ride"] = 99.04, ["Neon"] = 23.39, ["Neon|Fly"] = 126.42, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 108.84, ["Mega"] = 225.75}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 313.99, ["Ride"] = 221.82, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 1193.31, ["Neon|Fly|Ride"] = 1189.13, ["Mega"] = 10539.1}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.69, ["Fly"] = 77.44, ["Ride"] = 27.57, ["Fly|Ride"] = 68.25, ["Neon"] = 99.04, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 23.88, ["Fly|Ride"] = 72.19, ["Neon"] = 10.5, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 76.13}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Mega"] = 15.75}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.15, ["Fly"] = 52.49, ["Ride"] = 31.16, ["Fly|Ride"] = 108.51, ["Neon"] = 5.99, ["Neon|Ride"] = 43.43, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 106.67, ["Mega|Fly"] = 159292.6}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.9, ["Fly"] = 525, ["Ride"] = 111.7, ["Fly|Ride"] = 204.75, ["Neon"] = 293.02, ["Neon|Fly"] = 400.31, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 368.82}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 15.74, ["Fly|Ride"] = 111.68, ["Neon"] = 9.16, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.6}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.85, ["Ride"] = 162.89, ["Neon"] = 78.61, ["Neon|Ride"] = 210.72, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.75}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 1.79, ["Ride"] = 28.46, ["Neon"] = 2.88, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 277.32, ["Mega|Fly"] = 141.24}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 64.96, ["Ride"] = 15.75, ["Fly|Ride"] = 24.92, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 28.79, ["Mega|Fly"] = 42.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.57, ["Ride"] = 15, ["Fly|Ride"] = 64.79, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 39.27, ["Mega"] = 24.94, ["Mega|Fly"] = 160.1}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 67.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 31.04, ["Fly|Ride"] = 107.63, ["Neon"] = 3.94, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 26.16, ["Mega|Fly"] = 91.88}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 421.42, ["Mega|Fly"] = 137.03}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 70.59, ["Ride"] = 32.8, ["Fly|Ride"] = 47.76, ["Neon"] = 17.35, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 118.12, ["Mega|Fly"] = 122.07}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.45, ["Neon"] = 2.36, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly"] = 144.38}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 142.23, ["Fly|Ride"] = 524.99, ["Neon"] = 18.13, ["Mega"] = 162.75, ["Mega|Fly"] = 315}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.92, ["Mega"] = 105}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.63, ["Ride"] = 32.8, ["Neon"] = 3.93, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 20.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 1.79, ["Fly"] = 19.69, ["Ride"] = 14.21, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 33.16, ["Mega|Fly"] = 28.93}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.21, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 40.48, ["Neon|Ride"] = 140.95, ["Mega"] = 168.63}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 1.79, ["Fly"] = 32.82, ["Ride"] = 28.87, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 65.42}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.5, ["Ride"] = 78.75, ["Neon"] = 15.54, ["Mega"] = 85.32}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.52, ["Fly"] = 65.63, ["Ride"] = 46.36, ["Fly|Ride"] = 59.07, ["Neon"] = 23.19, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 124.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 20.03, ["Ride"] = 11.8, ["Fly|Ride"] = 27.36, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 14.17, ["Neon|Fly|Ride"] = 35.84, ["Mega"] = 14.88, ["Mega|Fly"] = 27.57}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 27.4, ["Fly|Ride"] = 131.25, ["Neon"] = 9.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.65}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.52, ["Ride"] = 140.02, ["Fly|Ride"] = 59.06, ["Neon"] = 41.91, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 261.19}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.61, ["Ride"] = 13.71, ["Fly|Ride"] = 36.75, ["Neon"] = 2.37, ["Neon|Fly"] = 16.87, ["Neon|Ride"] = 14.23, ["Neon|Fly|Ride"] = 50.99, ["Mega"] = 26.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 175.93, ["Ride"] = 31.5, ["Neon"] = 7.37, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 63.95}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 5.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 35.44, ["Mega|Fly"] = 141.24}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 35.84, ["Ride"] = 17.92, ["Neon"] = 2.1, ["Neon|Fly"] = 42.15, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 281.31, ["Mega|Fly"] = 253.82}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.59, ["Ride"] = 14.33, ["Fly|Ride"] = 46.45, ["Neon"] = 4.69, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 21.06, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 143.48}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 4.18, ["Neon|Ride"] = 62.18, ["Mega"] = 33.5}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.19, ["Ride"] = 17.07, ["Fly|Ride"] = 46.36, ["Neon"] = 4.68, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 103.69}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.63, ["Ride"] = 35.84, ["Fly|Ride"] = 50.05, ["Neon"] = 41.78, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Fly"] = 341.25}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 14.42, ["Fly|Ride"] = 56.89, ["Neon"] = 11.6, ["Neon|Fly"] = 47.76, ["Neon|Ride"] = 30.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 143.2, ["Ride"] = 23.6, ["Fly|Ride"] = 52.49, ["Neon"] = 15.82, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 159.6, ["Mega|Fly"] = 161.95}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 111.68, ["Fly|Ride"] = 95.49, ["Neon"] = 26.25, ["Neon|Ride"] = 103.83, ["Mega"] = 163.96}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.15, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Neon|Fly|Ride"] = 126, ["Mega"] = 562.8}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 54.32, ["Neon"] = 42.68, ["Neon|Ride"] = 106.55, ["Mega"] = 237.57}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.02, ["Ride"] = 28.41, ["Fly|Ride"] = 120.75, ["Neon"] = 52.53, ["Neon|Ride"] = 78.78, ["Mega"] = 477.89}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.11, ["Neon|Ride"] = 65, ["Mega"] = 21.48}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 46.3}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.49, ["Fly"] = 23.61, ["Ride"] = 21.49, ["Fly|Ride"] = 41.57, ["Neon"] = 49.53, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 94.28, ["Mega"] = 271.44}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.34, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 28.88, ["Mega|Fly"] = 141.24}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 1.79, ["Ride"] = 28.88, ["Neon"] = 5.16, ["Neon|Ride"] = 35.11, ["Mega"] = 39.26}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 18.98, ["Fly|Ride"] = 42.83, ["Neon"] = 7.75, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 127.65, ["Mega"] = 128.6}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.89, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 36.51, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 262.5}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.47, ["Neon"] = 3.8, ["Mega|Fly"] = 118.13}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 14.44, ["Fly|Ride"] = 59.07, ["Neon"] = 3.46, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 95.47, ["Mega"] = 28.87, ["Mega|Fly"] = 143.16}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 15.82, ["Fly|Ride"] = 41.99, ["Neon"] = 4.99, ["Neon|Fly"] = 70.6, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 61.04, ["Mega"] = 47.95, ["Mega|Fly"] = 141.24}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 53.74, ["Fly|Ride"] = 115.5, ["Neon"] = 8.44, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 45.94}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.08, ["Neon|Ride"] = 168.57, ["Mega|Fly"] = 95.6}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 16.98, ["Fly|Ride"] = 80.08, ["Neon"] = 3.91, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 32.82, ["Mega|Fly"] = 63.25}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 1.79, ["Ride"] = 18.38, ["Neon"] = 3.7, ["Neon|Ride"] = 40.05}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.49, ["Mega"] = 25.36}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.33, ["Fly|Ride"] = 49.88, ["Neon"] = 5.25, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 112.77, ["Mega|Fly"] = 45.24}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.33, ["Fly"] = 39.38, ["Ride"] = 59.06, ["Fly|Ride"] = 210.7, ["Neon"] = 126, ["Mega"] = 562.8}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.42, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 45.93, ["Neon|Ride"] = 208.62}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.5, ["Fly|Ride"] = 178.76, ["Neon"] = 26.24, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 421.42, ["Mega"] = 397.95}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 1.79, ["Fly"] = 14.95, ["Ride"] = 11.71, ["Fly|Ride"] = 25.74, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 14.41, ["Neon|Fly|Ride"] = 27.83, ["Mega"] = 15.54, ["Mega|Fly"] = 28.88}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 6.57, ["Neon|Fly"] = 67.44, ["Neon|Ride"] = 48.48, ["Neon|Fly|Ride"] = 702.72, ["Mega"] = 71.76}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 1.79, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.44}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.27, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 18.38, ["Fly|Ride"] = 56.89, ["Neon"] = 19.67, ["Neon|Ride"] = 35.84, ["Neon|Fly|Ride"] = 100.69, ["Mega"] = 183.75}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 131.25, ["Fly"] = 183.75, ["Ride"] = 168.25, ["Fly|Ride"] = 405.77, ["Neon|Fly|Ride"] = 955.57, ["Mega"] = 8431.28}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 23.89, ["Neon"] = 8.05, ["Neon|Ride"] = 64.31, ["Mega"] = 88.54}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.84, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 61.56, ["Neon"] = 31.59, ["Neon|Ride"] = 168.57, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 381.82}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 15.26, ["Fly|Ride"] = 32.8, ["Neon"] = 4.77, ["Neon|Fly"] = 32.67, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 56.9, ["Mega"] = 49.76}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.59, ["Ride"] = 19.69, ["Fly|Ride"] = 92.58, ["Neon"] = 7.07, ["Neon|Fly"] = 562.53, ["Neon|Ride"] = 52.29, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.15, ["Fly"] = 24.74, ["Ride"] = 15.64, ["Fly|Ride"] = 37.9, ["Neon"] = 23.63, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 77.95}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 9.09, ["Ride"] = 42.15, ["Fly|Ride"] = 254.93, ["Neon"] = 43.81, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 288.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.65, ["Fly|Ride"] = 35.37, ["Neon"] = 23.78, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 70.7, ["Mega"] = 157.5}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 69.83, ["Fly"] = 84.29, ["Ride"] = 91.23, ["Fly|Ride"] = 139.22, ["Neon"] = 341.23, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 295, ["Neon|Fly|Ride"] = 443.07}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 210, ["Fly"] = 421.38, ["Ride"] = 249.23, ["Fly|Ride"] = 295.32, ["Neon|Ride"] = 1124.13, ["Neon|Fly|Ride"] = 953.71, ["Mega"] = 10539.1}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 72.85, ["Fly"] = 122.2, ["Ride"] = 68.86, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 354.26}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.62, ["Fly"] = 287.89, ["Ride"] = 23.28, ["Fly|Ride"] = 79.97, ["Neon"] = 24.93, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 122.22, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 262.49}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.49, ["Ride"] = 34.19, ["Fly|Ride"] = 67.38, ["Neon"] = 81.37, ["Neon|Ride"] = 136.04, ["Mega"] = 355.68}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.16, ["Ride"] = 21.08, ["Fly|Ride"] = 44.52, ["Neon"] = 5.24, ["Neon|Fly"] = 31.62, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 52.71, ["Mega|Fly"] = 154.88}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.88, ["Fly"] = 72.12, ["Ride"] = 22.78, ["Fly|Ride"] = 86.63, ["Neon"] = 398.61, ["Neon|Fly"] = 351.85, ["Neon|Ride"] = 162.26, ["Neon|Fly|Ride"] = 197.03, ["Mega"] = 1837.5}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.64, ["Fly|Ride"] = 32.82, ["Neon"] = 13.13, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 31.04, ["Neon|Fly|Ride"] = 157.5}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 8.44, ["Ride"] = 24.63, ["Fly|Ride"] = 328.13, ["Neon"] = 22.31, ["Neon|Ride"] = 59.07, ["Mega"] = 183.4}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 1.79, ["Fly"] = 33.72, ["Ride"] = 19.35, ["Neon"] = 2.62, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 27.28, ["Ride"] = 18.27, ["Fly|Ride"] = 42.15, ["Neon"] = 15.22, ["Neon|Fly"] = 105.35, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.75}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 19.68, ["Fly|Ride"] = 61.74, ["Neon"] = 21.08, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 107.62, ["Fly"] = 179.29, ["Ride"] = 141.17, ["Fly|Ride"] = 199.5, ["Neon"] = 702.63, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 632.63, ["Mega"] = 4215.65}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 16.87, ["Ride"] = 32.83, ["Fly|Ride"] = 127.71, ["Neon"] = 46.36, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 888.14, ["Mega"] = 328.13}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.15, ["Ride"] = 17.06, ["Fly|Ride"] = 45.31, ["Neon"] = 12.85, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 166.47, ["Mega"] = 238.95}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 300.46, ["Neon|Fly|Ride"] = 701.67, ["Mega"] = 674.51, ["Mega|Fly"] = 843.14}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.94, ["Ride"] = 28.82, ["Fly|Ride"] = 125.37, ["Neon"] = 52.5, ["Neon|Ride"] = 103.26, ["Neon|Fly|Ride"] = 421.42, ["Mega"] = 285.92}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 28.89, ["Fly"] = 39.9, ["Ride"] = 31.39, ["Fly|Ride"] = 49.25, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1360.61}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.68, ["Fly|Ride"] = 65.63, ["Neon"] = 3.28, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 106.31, ["Mega|Fly"] = 188.99}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.05, ["Fly"] = 28.41, ["Ride"] = 19.81, ["Neon"] = 55.04, ["Neon|Ride"] = 238.67, ["Mega"] = 281.4, ["Mega|Fly"] = 399.04}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.07, ["Fly|Ride"] = 28.81, ["Neon"] = 17.75, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 46.34, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 138.89}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 3.52, ["Neon|Fly"] = 36.89, ["Neon|Ride"] = 32.34, ["Mega"] = 28.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 25.1, ["Ride"] = 71.82, ["Fly|Ride"] = 143.21, ["Neon"] = 280.54, ["Neon|Ride"] = 280.88, ["Mega"] = 850.62}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.89, ["Ride"] = 28.46, ["Fly|Ride"] = 210, ["Neon"] = 92.54, ["Mega"] = 141.24}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 15.65, ["Fly"] = 28.8, ["Ride"] = 19.69, ["Fly|Ride"] = 41.91, ["Neon"] = 21.11, ["Neon|Fly"] = 315, ["Neon|Ride"] = 37.01, ["Neon|Fly|Ride"] = 112.19, ["Mega"] = 383.97}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 65.63, ["Fly"] = 433.12, ["Ride"] = 393.74, ["Fly|Ride"] = 262.47, ["Neon"] = 367.5, ["Neon|Ride"] = 562.59, ["Mega"] = 4462.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.46, ["Fly"] = 44.84, ["Ride"] = 27.41, ["Fly|Ride"] = 57.65, ["Neon"] = 46.32, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 238.95}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 176.7, ["Ride"] = 104.99, ["Fly|Ride"] = 150.94, ["Neon"] = 266.44, ["Neon|Ride"] = 234.84, ["Neon|Fly|Ride"] = 312.27, ["Mega"] = 1264.71}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.59, ["Ride"] = 60.39, ["Fly|Ride"] = 141.17, ["Neon"] = 91.02, ["Neon|Ride"] = 113.71, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 314.99}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.8, ["Fly"] = 41.36, ["Ride"] = 28.46, ["Fly|Ride"] = 63.23, ["Neon"] = 84.81, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 537, ["Mega"] = 210.8}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Fly"] = 69.54, ["Ride"] = 45.66, ["Fly|Ride"] = 159.93, ["Neon"] = 69.21, ["Neon|Ride"] = 99.05, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.91}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.96, ["Ride"] = 27.36, ["Fly|Ride"] = 88.5, ["Neon"] = 40.6, ["Neon|Ride"] = 60.52, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 238.95}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 68, ["Fly|Ride"] = 99.04, ["Neon"] = 2.36, ["Neon|Fly"] = 92.84, ["Neon|Ride"] = 85.81}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 24.05, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 202.79, ["Mega"] = 203.32}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 125.37, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 315, ["Mega"] = 179.18}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.01, ["Ride"] = 32.79, ["Fly|Ride"] = 119.36, ["Neon"] = 31.62, ["Neon|Ride"] = 79.03, ["Neon|Fly|Ride"] = 281.31, ["Mega"] = 124.69}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 524.99, ["Fly"] = 606.38, ["Ride"] = 577.5, ["Fly|Ride"] = 593.92, ["Neon"] = 1826.61, ["Neon|Ride"] = 2107.06, ["Neon|Fly|Ride"] = 1860.72}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.83, ["Fly"] = 56.89, ["Ride"] = 20.44, ["Fly|Ride"] = 56.35, ["Neon"] = 41.1, ["Neon|Ride"] = 62.18, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 144.38}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.9, ["Fly"] = 524.9, ["Ride"] = 30.56, ["Fly|Ride"] = 51.54, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 168.57, ["Mega"] = 331.86}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 35.82, ["Ride"] = 19.69, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 23.63, ["Fly|Ride"] = 71.65, ["Neon"] = 7.72, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 88.31, ["Mega|Fly"] = 281.4}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.59, ["Ride"] = 16.95, ["Neon"] = 2.98, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 126.44}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.02, ["Ride"] = 36.74, ["Fly|Ride"] = 105, ["Neon"] = 52.39, ["Neon|Ride"] = 91.75, ["Neon|Fly|Ride"] = 318.62, ["Mega"] = 419.47}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.93, ["Neon"] = 6.23, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 32.82}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 27.17, ["Ride"] = 64.04, ["Neon"] = 29.53, ["Neon|Ride"] = 70.6, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 223.13}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.99, ["Ride"] = 426.57, ["Fly|Ride"] = 459.27, ["Neon|Ride"] = 2384.82, ["Neon|Fly|Ride"] = 1781.53, ["Mega"] = 8761.86}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.87, ["Fly"] = 196.88, ["Ride"] = 56.89, ["Fly|Ride"] = 421.38, ["Neon"] = 30.07, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 201.24}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.33, ["Ride"] = 23.79, ["Fly|Ride"] = 118.13, ["Neon"] = 6.55, ["Neon|Ride"] = 36.9, ["Neon|Fly|Ride"] = 130.06}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 129.92}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 18.06, ["Fly"] = 107.63, ["Ride"] = 105.35, ["Fly|Ride"] = 157.45, ["Neon"] = 70.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 477.89}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.13, ["Neon"] = 80.33, ["Neon|Ride"] = 171.85, ["Neon|Fly|Ride"] = 842.83, ["Mega"] = 1264.71}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.7, ["Ride"] = 31.4, ["Neon"] = 96.94, ["Neon|Ride"] = 180.21, ["Mega"] = 653.5}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.81, ["Ride"] = 23.63, ["Fly|Ride"] = 262.5, ["Neon"] = 131.25, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 795.95, ["Mega"] = 616.77}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 380.63, ["Ride"] = 384.38, ["Fly|Ride"] = 768.56, ["Neon"] = 1365, ["Neon|Ride"] = 1405.42, ["Neon|Fly|Ride"] = 1076.25}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.24, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 64.3, ["Neon"] = 190.32, ["Neon|Ride"] = 190.94, ["Neon|Fly|Ride"] = 189.65}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.65, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 56.22, ["Neon|Ride"] = 221.82, ["Mega"] = 367.5}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 19.39, ["Ride"] = 78.75, ["Fly|Ride"] = 236.25, ["Neon"] = 81.25, ["Neon|Ride"] = 165.4, ["Neon|Fly|Ride"] = 288.54, ["Mega|Fly"] = 702.97}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.37, ["Ride"] = 42.15, ["Fly|Ride"] = 141.17, ["Neon"] = 7.27, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 210.72, ["Mega"] = 38.07}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.07, ["Ride"] = 82.18, ["Neon"] = 315, ["Neon|Ride"] = 464.62, ["Neon|Fly|Ride"] = 505.71, ["Mega"] = 1945.53}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Fly|Ride"] = 60.05, ["Neon"] = 9.19, ["Neon|Fly"] = 183.3, ["Neon|Ride"] = 52.69, ["Neon|Fly|Ride"] = 133.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 27.47, ["Neon"] = 3.81, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 109.58, ["Mega|Fly"] = 112.77}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 10.55, ["Neon|Ride"] = 61.13, ["Mega"] = 112.32}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.55, ["Fly"] = 65.61, ["Ride"] = 61.68, ["Fly|Ride"] = 169.32, ["Neon"] = 236.25, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 477.33}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 281.27, ["Ride"] = 310.77, ["Fly|Ride"] = 433.13, ["Neon"] = 1462.13, ["Neon|Ride"] = 1164.66, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9557.51}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.88, ["Neon"] = 28.32, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 99.05, ["Mega|Fly"] = 262.5}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.3, ["Neon"] = 8.24, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 52.41, ["Mega|Fly"] = 164.07}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.66, ["Fly"] = 105, ["Ride"] = 28.1, ["Fly|Ride"] = 79.97, ["Neon"] = 32.81, ["Mega"] = 140.93}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 28.14, ["Fly|Ride"] = 374.42, ["Neon"] = 13.02, ["Neon|Ride"] = 52.46, ["Neon|Fly|Ride"] = 162.26, ["Mega"] = 124.49}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 39.29}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 17.92, ["Fly|Ride"] = 52.49, ["Neon"] = 4.36, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 23.19, ["Neon|Fly|Ride"] = 84.29, ["Mega"] = 41.55}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.8, ["Fly|Ride"] = 56.44, ["Neon"] = 15.16, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 156.15}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 42, ["Fly"] = 52.5, ["Ride"] = 38.66, ["Fly|Ride"] = 78.74, ["Neon"] = 136.54, ["Neon|Ride"] = 454.09, ["Mega"] = 393.75}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 70.88, ["Ride"] = 84.32, ["Fly|Ride"] = 139.13, ["Neon"] = 561.75, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3186.25}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 144.38, ["Neon"] = 3.59, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 126.44, ["Mega"] = 45.34, ["Mega|Fly"] = 672}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.02, ["Fly|Ride"] = 26.25, ["Neon"] = 4.94, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 23.88, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 39.38, ["Mega|Fly"] = 131.21}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.77, ["Fly"] = 42.15, ["Ride"] = 42.15, ["Fly|Ride"] = 131.25, ["Neon"] = 48.37, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 281.31, ["Mega"] = 527.62}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 547.78, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 2069.18, ["Neon|Fly|Ride"] = 1771.88}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.16, ["Fly"] = 99.04, ["Ride"] = 40.71, ["Fly|Ride"] = 108.92, ["Neon"] = 241.5, ["Neon|Ride"] = 227.07}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.87, ["Fly|Ride"] = 281.33, ["Neon"] = 9.17, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 70.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.62, ["Fly"] = 91.88, ["Ride"] = 65.62, ["Fly|Ride"] = 143.21, ["Neon"] = 16.87}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 75.34, ["Fly"] = 169.3, ["Ride"] = 37.59, ["Fly|Ride"] = 104.81, ["Neon"] = 194.25, ["Neon|Ride"] = 358.21, ["Neon|Fly|Ride"] = 261.29, ["Mega"] = 2529.39}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 65.63, ["Fly"] = 104.9, ["Ride"] = 113.43, ["Fly|Ride"] = 189.62, ["Neon"] = 430.1, ["Neon|Ride"] = 477.33, ["Neon|Fly|Ride"] = 637.23, ["Mega"] = 8431.28}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 249.38, ["Ride"] = 304.49, ["Fly|Ride"] = 339.67, ["Neon"] = 1020.36, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.46}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.95, ["Ride"] = 61.6, ["Fly|Ride"] = 124.32, ["Neon"] = 73.5, ["Neon|Ride"] = 123.16, ["Mega"] = 420}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.75, ["Fly|Ride"] = 43.2, ["Neon"] = 6.57, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 91.67, ["Mega"] = 84.33}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.68, ["Fly"] = 39.3, ["Ride"] = 18.27, ["Fly|Ride"] = 55.97, ["Neon"] = 24.75, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 37.67, ["Neon|Fly|Ride"] = 81.89, ["Mega"] = 349.92}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 321.2, ["Fly"] = 491.96, ["Ride"] = 459.42, ["Fly|Ride"] = 632.05, ["Neon"] = 1968.75, ["Neon|Ride"] = 2029.3, ["Neon|Fly|Ride"] = 2767.63, ["Mega"] = 10117.53}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.66}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.63, ["Ride"] = 15.75, ["Fly|Ride"] = 56.89, ["Neon"] = 49.38, ["Neon|Ride"] = 37.94, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 233.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.02, ["Ride"] = 102.38, ["Neon"] = 93.18, ["Neon|Fly"] = 421.42, ["Neon|Ride"] = 141.19, ["Mega"] = 454.77}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.94, ["Fly"] = 157.5, ["Ride"] = 109.52, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 800.69}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.93, ["Fly"] = 24.33, ["Ride"] = 27.57, ["Fly|Ride"] = 48.39, ["Neon"] = 98.44, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 702.97}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.08, ["Neon"] = 3.68, ["Neon|Ride"] = 39.38, ["Mega"] = 24.94}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.98, ["Fly|Ride"] = 70.59, ["Neon"] = 3.93, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 18.8, ["Neon|Fly|Ride"] = 81.32, ["Mega|Fly"] = 97.12}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Ride"] = 77.59, ["Fly|Ride"] = 152.56, ["Neon"] = 31.4, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 218.78}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1443.75, ["Ride"] = 1443.75, ["Fly|Ride"] = 1435.88, ["Neon|Fly|Ride"] = 4313.15}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 486.81, ["Fly|Ride"] = 595.88, ["Neon"] = 2473.4, ["Neon|Ride"] = 2107.06, ["Neon|Fly|Ride"] = 2528.48, ["Mega"] = 16862.55}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 313.42, ["Fly"] = 417.17, ["Ride"] = 318.26, ["Fly|Ride"] = 451.5, ["Neon"] = 787.49, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 787.4}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 324.19, ["Fly"] = 341.25, ["Ride"] = 366.39, ["Fly|Ride"] = 469.84, ["Neon"] = 708.75, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 871.28}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 16.02, ["Fly|Ride"] = 39.01, ["Neon"] = 5.23, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.43, ["Mega|Fly"] = 112.77}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 421.04, ["Fly"] = 1405.25, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1342.21, ["Neon|Fly|Ride"] = 3160.59, ["Mega"] = 21359.58}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3, ["Fly"] = 157.5, ["Ride"] = 112.52, ["Neon"] = 22.18, ["Neon|Ride"] = 210.72, ["Neon|Fly|Ride"] = 252.45, ["Mega"] = 137.91}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.12, ["Fly|Ride"] = 31.98, ["Neon"] = 11.95, ["Neon|Ride"] = 37.89, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 105}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.18, ["Neon"] = 2.36, ["Neon|Ride"] = 39.38, ["Mega"] = 30.21}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 26.17, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 1050}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7959.16, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 26.07, ["Neon|Ride"] = 61.13}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.05, ["Ride"] = 55.13, ["Neon"] = 3.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.23, ["Mega"] = 22.32}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.37, ["Fly"] = 41.02, ["Ride"] = 23.45, ["Fly|Ride"] = 65.54, ["Neon"] = 14.1, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 23.88, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.23, ["Fly"] = 56.89, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 30.19, ["Neon|Fly"] = 143.21, ["Neon|Ride"] = 141.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 238.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.49, ["Ride"] = 52.5, ["Neon"] = 92.9, ["Neon|Ride"] = 168.57, ["Mega"] = 427.07}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.85, ["Fly"] = 6141.83, ["Ride"] = 15.75, ["Neon"] = 43, ["Neon|Fly"] = 47.92, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 716, ["Mega"] = 315}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.68, ["Ride"] = 18.38, ["Fly|Ride"] = 45.93, ["Neon"] = 3.9, ["Neon|Fly"] = 31.62, ["Neon|Ride"] = 27.93, ["Mega"] = 44.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.59, ["Fly"] = 257.06, ["Ride"] = 164.07, ["Fly|Ride"] = 229.69, ["Neon"] = 870.12, ["Neon|Ride"] = 910.26, ["Neon|Fly|Ride"] = 921.85, ["Mega"] = 8431.28}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 13.83, ["Fly|Ride"] = 36.75, ["Neon"] = 3.35, ["Neon|Fly"] = 24.25, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 56.36, ["Mega"] = 39.37}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.06, ["Ride"] = 28.46, ["Fly|Ride"] = 196.87, ["Neon"] = 55.13, ["Neon|Ride"] = 84.29, ["Mega"] = 313.69, ["Mega|Fly"] = 796.87}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 35.78, ["Ride"] = 81.25, ["Fly|Ride"] = 170.63, ["Neon"] = 210.7, ["Neon|Ride"] = 273.93, ["Mega"] = 984.36}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.64, ["Ride"] = 225.05, ["Fly|Ride"] = 379.23, ["Neon"] = 780.36, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 991.65}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 23.39, ["Ride"] = 158.3, ["Fly|Ride"] = 141.17, ["Neon"] = 91.88, ["Neon|Ride"] = 281.31, ["Mega"] = 287.44}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 11.6, ["Ride"] = 57.75, ["Fly|Ride"] = 182.44, ["Neon"] = 105, ["Neon|Fly"] = 159.93, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 223.15, ["Mega"] = 771.89}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.12, ["Fly"] = 1050, ["Ride"] = 1050, ["Fly|Ride"] = 1214.07, ["Neon|Ride"] = 4466.97, ["Neon|Fly|Ride"] = 4828.31}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.65, ["Fly"] = 21, ["Ride"] = 20.03, ["Fly|Ride"] = 52.5, ["Neon"] = 50.64, ["Neon|Fly"] = 49.41, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 351.89, ["Mega"] = 227}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.94, ["Fly"] = 78.75, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 37.7, ["Neon|Ride"] = 119.35, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 252.96, ["Mega|Fly"] = 1260}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 83.23, ["Ride"] = 23.76, ["Fly|Ride"] = 69.57, ["Neon"] = 15.74, ["Neon|Ride"] = 45.82, ["Mega"] = 78.75}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.15, ["Fly"] = 57.84, ["Ride"] = 32.48, ["Fly|Ride"] = 86.63, ["Neon"] = 83.91, ["Neon|Ride"] = 82.64, ["Neon|Fly|Ride"] = 196.75, ["Mega"] = 492.19}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.47, ["Ride"] = 23.19, ["Fly|Ride"] = 49.53, ["Neon"] = 16.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 103.83, ["Mega"] = 141.24, ["Mega|Fly"] = 252.96}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.1, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 52.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.98}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 293.91, ["Fly|Ride"] = 379.23, ["Neon|Fly|Ride"] = 1182.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.94, ["Fly"] = 32.8, ["Ride"] = 24.64, ["Fly|Ride"] = 108.94, ["Neon"] = 7.88, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 151.56, ["Mega"] = 75.29, ["Mega|Fly"] = 421.58}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.23, ["Ride"] = 82.02, ["Fly|Ride"] = 88.86, ["Neon"] = 26.25, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.83, ["Fly"] = 98.86, ["Ride"] = 42.15, ["Neon"] = 28.46, ["Neon|Ride"] = 52.5, ["Mega"] = 84.95}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 118.13, ["Ride"] = 318.65, ["Fly|Ride"] = 315, ["Neon"] = 485.72, ["Neon|Ride"] = 637.23, ["Neon|Fly|Ride"] = 795.95, ["Mega"] = 2716.74}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.57, ["Ride"] = 50.58, ["Fly|Ride"] = 225.44, ["Neon"] = 149.51, ["Neon|Fly|Ride"] = 842.83, ["Mega"] = 634.32}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.26, ["Fly"] = 318.76, ["Ride"] = 32.82, ["Fly|Ride"] = 94.21, ["Neon"] = 93.19, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 432.16}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.9, ["Mega"] = 77.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 50.37, ["Fly"] = 99.04, ["Ride"] = 75.06, ["Fly|Ride"] = 155.93, ["Neon"] = 315, ["Neon|Fly"] = 286.78, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 292.57}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Fly|Ride"] = 52.5, ["Neon"] = 5.33, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 125.39, ["Mega"] = 58.91}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.18, ["Fly"] = 127.75, ["Ride"] = 26.17, ["Fly|Ride"] = 119.36, ["Neon"] = 68.25, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 281.4, ["Mega|Fly"] = 971.25}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.93, ["Fly"] = 203.34, ["Ride"] = 139.07, ["Neon"] = 210.7, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 393.74}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 15.07, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.25, ["Neon|Ride"] = 16.87, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 17.06, ["Mega|Fly"] = 119.48}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.04, ["Ride"] = 52.49, ["Fly|Ride"] = 131.15, ["Neon"] = 18.51, ["Neon|Ride"] = 63.23, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 170.61}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.39, ["Ride"] = 43.22, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 133.82, ["Neon|Fly|Ride"] = 273, ["Mega"] = 404.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 1.79, ["Ride"] = 22.32, ["Neon"] = 2.62, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 138.03, ["Mega"] = 19.66}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 19.04, ["Fly"] = 197.3, ["Ride"] = 47.67, ["Fly|Ride"] = 172.78, ["Neon"] = 73.13, ["Neon|Ride"] = 172.57, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 606.04, ["Mega|Fly"] = 787.5}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.02, ["Fly"] = 42.15, ["Ride"] = 26.25, ["Fly|Ride"] = 98.44, ["Neon"] = 357.86, ["Neon|Ride"] = 113.54, ["Neon|Fly|Ride"] = 129.94}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.62, ["Ride"] = 38.98, ["Neon"] = 24.05, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 56.9, ["Mega"] = 254.87}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.23, ["Fly"] = 2056.43, ["Ride"] = 56.44, ["Fly|Ride"] = 196.86, ["Neon"] = 32.69, ["Neon|Ride"] = 367.4, ["Mega"] = 281.4}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.15, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 10.73, ["Neon|Ride"] = 32.43, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.78}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.48}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 39.27, ["Fly"] = 99.04, ["Ride"] = 52.49, ["Fly|Ride"] = 91.88, ["Neon"] = 242.29, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1827.49}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.57, ["Neon|Ride"] = 28.46}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 485.42, ["Fly"] = 498.75, ["Ride"] = 478.27, ["Fly|Ride"] = 792.42, ["Neon"] = 2809.43, ["Neon|Ride"] = 1968.01, ["Neon|Fly|Ride"] = 2669.65, ["Mega"] = 16862.55}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 8.33, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 66.38, ["Neon"] = 34.86, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 93.19}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 52.49, ["Ride"] = 22.32, ["Fly|Ride"] = 81.27, ["Neon"] = 18.38, ["Neon|Ride"] = 50.13, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 118.13, ["Mega|Fly"] = 210.8}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.75, ["Fly"] = 70.59, ["Ride"] = 30.19, ["Fly|Ride"] = 68.17, ["Neon"] = 102.94, ["Neon|Ride"] = 175.95, ["Mega"] = 843.14}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.19, ["Fly"] = 56.89, ["Ride"] = 28.46, ["Fly|Ride"] = 721.88, ["Neon"] = 17.03, ["Neon|Ride"] = 105, ["Mega"] = 275.63}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 4.7, ["Ride"] = 141.17, ["Fly|Ride"] = 70.59, ["Neon"] = 64.6, ["Neon|Ride"] = 112.74, ["Mega"] = 376.64}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.26, ["Ride"] = 53.74, ["Fly|Ride"] = 133.88, ["Neon"] = 33.69, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 238.67, ["Mega"] = 262.5}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 1.79, ["Fly"] = 40.61, ["Ride"] = 13.79, ["Fly|Ride"] = 70.59, ["Neon"] = 2.1, ["Neon|Fly"] = 60.08, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 14.85, ["Mega|Fly"] = 32.27}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.18, ["Fly"] = 53.74, ["Ride"] = 39.38, ["Fly|Ride"] = 105.35, ["Neon"] = 28.41, ["Neon|Fly"] = 119.35, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 225.47, ["Mega"] = 196.87}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.7, ["Ride"] = 300.57, ["Fly|Ride"] = 450.86, ["Neon"] = 1312.5, ["Neon|Ride"] = 1283.63, ["Neon|Fly|Ride"] = 1252.12}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Ride"] = 114.19, ["Fly|Ride"] = 284.82, ["Neon"] = 577.5, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2249.05}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.54, ["Fly|Ride"] = 33.57, ["Neon"] = 8.44, ["Neon|Fly"] = 69.35, ["Neon|Ride"] = 33.72, ["Neon|Fly|Ride"] = 64.07, ["Mega|Fly"] = 209.74}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.06, ["Fly|Ride"] = 32.48, ["Neon"] = 4.23, ["Neon|Fly"] = 52.68, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 59.27, ["Mega"] = 65.54, ["Mega|Fly"] = 352.02}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.71, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Mega"] = 274.02}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 249.54, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 266.26, ["Neon"] = 1181.25, ["Neon|Ride"] = 1064.07, ["Neon|Fly|Ride"] = 2080.73}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 5.24, ["Fly"] = 23.62, ["Ride"] = 16.44, ["Fly|Ride"] = 40.16, ["Neon"] = 18.38, ["Neon|Fly"] = 105, ["Neon|Ride"] = 35.84, ["Neon|Fly|Ride"] = 160.84, ["Mega"] = 255.93}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.57, ["Fly"] = 318.76, ["Ride"] = 34.13, ["Fly|Ride"] = 210.33, ["Neon"] = 35.6, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 3.44, ["Neon|Ride"] = 156.19, ["Mega"] = 70.63}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 47.77, ["Ride"] = 22.31, ["Fly|Ride"] = 73.94, ["Neon"] = 118.13, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 510.57}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.62, ["Fly"] = 119.4, ["Ride"] = 78.74, ["Fly|Ride"] = 196.88, ["Neon"] = 137.62, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 166.37, ["Neon|Fly|Ride"] = 310.8, ["Mega"] = 400.31, ["Mega|Fly"] = 2213.23}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21.73, ["Fly"] = 63, ["Ride"] = 91.88, ["Fly|Ride"] = 141.02, ["Neon"] = 210.7, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 213.51, ["Neon|Fly|Ride"] = 306.59, ["Mega"] = 843.14}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.95, ["Fly|Ride"] = 41.78, ["Neon"] = 2.62, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 18.38, ["Mega|Fly"] = 421.58}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.73, ["Ride"] = 262.5, ["Fly|Ride"] = 307.65, ["Neon"] = 2189.99, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.03, ["Fly"] = 101.18, ["Ride"] = 49.4, ["Fly|Ride"] = 105, ["Neon"] = 106.35, ["Neon|Ride"] = 208.62, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 18.36, ["Fly|Ride"] = 42.09, ["Neon"] = 7.87, ["Neon|Fly"] = 39, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 56.94, ["Mega|Fly"] = 281.4}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.62, ["Ride"] = 16.14, ["Fly|Ride"] = 43.72, ["Neon"] = 2.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 116.95, ["Mega"] = 28.47, ["Mega|Fly"] = 141.24}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 13.13, ["Neon|Fly"] = 716.04, ["Neon|Ride"] = 71.61, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 103.69}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.21, ["Fly"] = 38.75, ["Ride"] = 22.32, ["Fly|Ride"] = 37.01, ["Neon"] = 55.13, ["Neon|Fly"] = 302.34, ["Neon|Ride"] = 49.76, ["Neon|Fly|Ride"] = 113.07, ["Mega"] = 355.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.64, ["Ride"] = 56.89, ["Neon"] = 55.13, ["Mega"] = 318.99}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.72, ["Neon|Ride"] = 40.05, ["Neon|Fly|Ride"] = 100.36}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.11, ["Ride"] = 26.91, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 50.04, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 250.84}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 79.43, ["Neon"] = 7.17, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.32, ["Mega"] = 23.8}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.52, ["Ride"] = 17.11, ["Fly|Ride"] = 61.1, ["Neon"] = 6.43, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 134.87, ["Mega"] = 54.18}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.71, ["Ride"] = 748.13, ["Fly|Ride"] = 748.12, ["Neon|Ride"] = 3750.56, ["Neon|Fly|Ride"] = 3609.38}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.98, ["Ride"] = 15.33, ["Fly|Ride"] = 36.23, ["Neon"] = 13.13, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 112.19}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Fly|Ride"] = 210, ["Neon"] = 9.06, ["Neon|Fly"] = 737.4, ["Neon|Ride"] = 88.56, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly"] = 210.8}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.86, ["Fly"] = 40.65, ["Ride"] = 23.86, ["Fly|Ride"] = 52.49, ["Neon"] = 65.63, ["Neon|Fly"] = 190.97, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.62, ["Fly|Ride"] = 33.27, ["Neon"] = 6.37, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 65.63, ["Mega|Fly"] = 131.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 38.06, ["Fly"] = 105, ["Ride"] = 83.16, ["Fly|Ride"] = 281.27, ["Neon"] = 210.7, ["Neon|Ride"] = 216.48}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 64.36, ["Neon"] = 6.34, ["Neon|Fly"] = 141.17, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 52.5}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.25, ["Ride"] = 23, ["Fly|Ride"] = 61.1, ["Neon"] = 8.54, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 95.82}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.37, ["Fly|Ride"] = 78.75, ["Neon"] = 15.82, ["Mega"] = 97.12}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.07, ["Fly|Ride"] = 49.87, ["Neon"] = 2.1, ["Neon|Fly"] = 20.03, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 105.36, ["Mega|Fly"] = 227.39}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.5, ["Fly"] = 21.05, ["Ride"] = 20.77, ["Fly|Ride"] = 37.27, ["Neon"] = 105, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 135.19}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 727.63, ["Ride"] = 748.13, ["Fly|Ride"] = 840, ["Neon"] = 1805.06, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.13}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 1.79, ["Fly"] = 18.38, ["Ride"] = 16.87, ["Fly|Ride"] = 35.11, ["Neon"] = 4.75, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 47.14, ["Mega"] = 44.63}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.16, ["Ride"] = 32.81, ["Fly|Ride"] = 238.7, ["Neon"] = 47.25, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 421.42, ["Mega"] = 366.19}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.76, ["Fly"] = 105, ["Ride"] = 70.38, ["Fly|Ride"] = 111.57, ["Neon"] = 419.27, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 522.57}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.29, ["Ride"] = 57.3, ["Fly|Ride"] = 104.89, ["Neon"] = 157.5, ["Neon|Ride"] = 221.26, ["Mega"] = 984.36}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.75, ["Fly"] = 83.58, ["Ride"] = 26.17, ["Fly|Ride"] = 140.91, ["Neon"] = 56.6, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 172.79, ["Mega"] = 262.5}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.2, ["Ride"] = 69.26, ["Neon"] = 103.69, ["Neon|Ride"] = 70.6, ["Neon|Fly|Ride"] = 210.72, ["Mega"] = 236.15, ["Mega|Fly"] = 518.51}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.64, ["Ride"] = 56.89, ["Fly|Ride"] = 153.71, ["Neon"] = 124.69, ["Neon|Ride"] = 168.57, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.34}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.71, ["Ride"] = 24.71, ["Fly|Ride"] = 59, ["Neon"] = 37.89, ["Neon|Ride"] = 84.29, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.27, ["Mega|Fly"] = 476.38}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Ride"] = 46.85, ["Neon"] = 10.15, ["Mega"] = 140.44}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 38.05, ["Fly"] = 62.99, ["Ride"] = 39.38, ["Fly|Ride"] = 95.49, ["Neon"] = 200.82, ["Neon|Ride"] = 216.57}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.66, ["Fly"] = 17.9, ["Ride"] = 15.54, ["Fly|Ride"] = 35.84, ["Neon"] = 21.08, ["Neon|Fly"] = 69.54, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 198.19}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.03, ["Fly"] = 36.89, ["Ride"] = 27.56, ["Fly|Ride"] = 56.16, ["Neon"] = 19.68, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 136.04}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.32}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 25.83, ["Fly"] = 77.96, ["Ride"] = 52.49, ["Fly|Ride"] = 91.88, ["Neon"] = 945, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 301.88}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.78, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 32.67, ["Mega"] = 78}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.11, ["Ride"] = 79.97, ["Fly|Ride"] = 280.22, ["Neon"] = 89.52, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 543.64, ["Mega"] = 416.31}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.06, ["Fly|Ride"] = 40.64, ["Neon"] = 92.4, ["Neon|Ride"] = 38.2, ["Neon|Fly|Ride"] = 76.67}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.79, ["Fly"] = 52.49, ["Ride"] = 20.89, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 421.42, ["Mega"] = 291.38}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.52, ["Ride"] = 60.05, ["Neon"] = 39.38, ["Neon|Ride"] = 159.92, ["Mega"] = 413.86}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 41.36, ["Ride"] = 99.04, ["Neon"] = 328.12, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 674.27}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 32.25, ["Ride"] = 281.27, ["Neon"] = 107.62, ["Neon|Ride"] = 183.75, ["Mega"] = 421.31}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.54, ["Ride"] = 125.98, ["Neon"] = 181.19, ["Neon|Fly"] = 210.7, ["Neon|Ride"] = 421.42}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.23, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 737.48, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 592.38, ["Mega|Fly"] = 2107.84}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 13.12, ["Mega"] = 239.25}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.41, ["Ride"] = 18.98, ["Fly|Ride"] = 42.15, ["Neon"] = 4.74, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 66.69}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.94, ["Ride"] = 42.15, ["Fly|Ride"] = 65.63, ["Neon"] = 17.16, ["Neon|Ride"] = 70.73, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 87.83}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.48, ["Fly|Ride"] = 56.89, ["Neon"] = 7.58, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 105, ["Mega"] = 42.86, ["Mega|Fly"] = 168.63}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.83, ["Fly"] = 65.62, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 15.74, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 70.6, ["Mega"] = 328.02}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Neon"] = 28.39, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.44, ["Fly"] = 131.25, ["Ride"] = 25.08, ["Fly|Ride"] = 71.54, ["Neon"] = 17.07, ["Neon|Fly"] = 112.73, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 261.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 22.68, ["Fly|Ride"] = 51.89, ["Neon"] = 19.69, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.96}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.38, ["Fly"] = 57.66, ["Ride"] = 42.84, ["Fly|Ride"] = 131.24, ["Neon"] = 21, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 118.13, ["Mega|Fly"] = 196.88}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.68, ["Fly"] = 207.74, ["Ride"] = 101.75, ["Fly|Ride"] = 209.9, ["Neon"] = 133.8, ["Neon|Ride"] = 223.15, ["Neon|Fly|Ride"] = 378}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 53.74, ["Fly"] = 164.07, ["Ride"] = 82.68, ["Fly|Ride"] = 181.13, ["Neon"] = 219.59, ["Neon|Ride"] = 302.38, ["Neon|Fly|Ride"] = 702.72, ["Mega"] = 1546.11}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 64.45, ["Neon"] = 2.63, ["Neon|Ride"] = 24.25, ["Mega"] = 29.98}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.07, ["Ride"] = 52.5, ["Neon"] = 281.27, ["Mega"] = 686.56}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 64.21, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 275.99, ["Neon|Ride"] = 341.25, ["Mega"] = 1727.37}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 36.66, ["Neon|Ride"] = 84.29, ["Mega"] = 192.94}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.6, ["Ride"] = 28.88, ["Fly|Ride"] = 176.65, ["Neon"] = 10.21, ["Neon|Ride"] = 67.4, ["Neon|Fly|Ride"] = 138.03, ["Mega|Fly"] = 262.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 17.07, ["Fly|Ride"] = 37.8, ["Neon"] = 11.82, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 236.15, ["Mega|Fly"] = 196.86}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.74, ["Fly|Ride"] = 42.15, ["Neon"] = 2.63, ["Neon|Fly"] = 23.88, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.87}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.23, ["Fly|Ride"] = 93.08, ["Neon"] = 3.62, ["Neon|Ride"] = 31.62, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 39.36}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 145.08, ["Mega"] = 25.35}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.26, ["Ride"] = 157.5, ["Neon"] = 31.5, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 632.14, ["Mega"] = 420.52}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.35, ["Ride"] = 31.62, ["Fly|Ride"] = 195.74, ["Neon"] = 53.17, ["Neon|Ride"] = 138.03, ["Neon|Fly|Ride"] = 185.43, ["Mega"] = 286.78}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.57, ["Fly"] = 40.61, ["Ride"] = 18.09, ["Fly|Ride"] = 39.29, ["Neon"] = 32.82, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 95.24}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 57.28, ["Ride"] = 160.13, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2389.38}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.76, ["Fly"] = 82.68, ["Ride"] = 32.82, ["Fly|Ride"] = 141.17, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.29, ["Ride"] = 15.75, ["Fly|Ride"] = 38.07, ["Neon"] = 2.63, ["Neon|Fly"] = 42.15, ["Neon|Ride"] = 20.03, ["Neon|Fly|Ride"] = 59, ["Mega"] = 32.82}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 14.76, ["Fly|Ride"] = 35.44, ["Neon"] = 5.13, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 19.11, ["Neon|Fly|Ride"] = 56.9, ["Mega"] = 39.38, ["Mega|Fly"] = 99.08}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 446.15, ["Fly|Ride"] = 569.63, ["Neon|Fly|Ride"] = 1876.88}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.56, ["Ride"] = 47.77, ["Neon"] = 47.76, ["Neon|Ride"] = 112.74, ["Mega"] = 403.49}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.25, ["Ride"] = 18.8, ["Fly|Ride"] = 31.65, ["Neon"] = 5.15, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 16.87, ["Neon|Fly|Ride"] = 46.36, ["Mega"] = 141.24}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 45.31, ["Ride"] = 92.76, ["Fly|Ride"] = 294.97, ["Neon"] = 227.07, ["Neon|Ride"] = 308.34, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 728.44}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 17.92, ["Fly|Ride"] = 35.84, ["Neon"] = 12.26, ["Neon|Fly"] = 76.12, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105.36, ["Mega"] = 105.98}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.59, ["Ride"] = 21, ["Neon"] = 3.7, ["Neon|Ride"] = 35.84, ["Neon|Fly|Ride"] = 74.81}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 25.97, ["Fly"] = 126.55, ["Ride"] = 70.88, ["Fly|Ride"] = 211.42, ["Neon"] = 174.57, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 983.89}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.69, ["Neon"] = 4.72, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 77.98, ["Mega"] = 36.75}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.93, ["Ride"] = 67.37, ["Fly|Ride"] = 159.93, ["Neon"] = 341.32, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 477.33, ["Mega"] = 1752.62}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.57, ["Neon"] = 22.15, ["Neon|Ride"] = 20.03, ["Mega"] = 170.63}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.62, ["Fly"] = 70.59, ["Ride"] = 69.17, ["Fly|Ride"] = 70.49, ["Neon"] = 8.64, ["Neon|Ride"] = 56.9, ["Mega"] = 89.62}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.16, ["Fly"] = 141.17, ["Ride"] = 50.93, ["Fly|Ride"] = 210.7}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 27.41, ["Fly|Ride"] = 908.99, ["Neon"] = 6.2, ["Neon|Ride"] = 56.9, ["Mega"] = 49.23, ["Mega|Fly"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 19.49, ["Fly|Ride"] = 98.44, ["Neon"] = 6.41, ["Neon|Fly"] = 47.76, ["Neon|Ride"] = 32.63, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 95.6}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.34, ["Fly"] = 58.5, ["Ride"] = 31.08, ["Fly|Ride"] = 75.87, ["Neon"] = 81.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 328.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.54, ["Ride"] = 24.94, ["Fly|Ride"] = 70.55, ["Neon"] = 65.24, ["Neon|Ride"] = 76.11, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 922.19}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.34, ["Fly"] = 51.18, ["Ride"] = 25.99, ["Fly|Ride"] = 52.5, ["Neon"] = 74.28, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 562.8}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Ride"] = 113.17, ["Fly|Ride"] = 221.22, ["Neon"] = 318.31, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 573.14}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.86, ["Ride"] = 28.88, ["Neon"] = 24.07, ["Neon|Ride"] = 120.12, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 230.13}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.64, ["Ride"] = 26.88, ["Fly|Ride"] = 78.74, ["Neon"] = 18.52, ["Neon|Ride"] = 47.25, ["Mega"] = 262.4}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.26, ["Fly"] = 287.55, ["Ride"] = 28.45, ["Fly|Ride"] = 159.93, ["Neon"] = 76.13, ["Neon|Ride"] = 141.19, ["Mega"] = 446.83}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 32.16, ["Neon"] = 2.23, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 15.11}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.62, ["Ride"] = 91.88, ["Fly|Ride"] = 281.27, ["Neon"] = 262.5, ["Neon|Fly"] = 2388.07, ["Neon|Ride"] = 249.38, ["Mega"] = 1115.86}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 35.84, ["Neon"] = 3.59, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.49}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 16.68, ["Fly|Ride"] = 59.06, ["Neon"] = 15.75, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 257.25}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 55.1, ["Fly"] = 157.5, ["Ride"] = 105, ["Fly|Ride"] = 83.23, ["Neon"] = 280.88, ["Neon|Ride"] = 478.31, ["Neon|Fly|Ride"] = 562.59, ["Mega"] = 1745.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 1.85, ["Ride"] = 25.1, ["Neon"] = 7.56, ["Neon|Ride"] = 28.46}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.24}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 490.89, ["Neon"] = 6.57, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 103.95}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.1, ["Ride"] = 131.24, ["Fly|Ride"] = 334.16, ["Neon"] = 836.07, ["Neon|Ride"] = 700.48, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3372.52}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.92, ["Ride"] = 36.47, ["Fly|Ride"] = 210.7, ["Neon"] = 19.59, ["Neon|Fly"] = 141.17, ["Neon|Ride"] = 64.32, ["Mega"] = 178.39}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 1.79, ["Fly"] = 26.25, ["Ride"] = 35.84, ["Neon"] = 3.93, ["Neon|Ride"] = 20.86, ["Mega"] = 31.29}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 21.1, ["Fly|Ride"] = 131.25, ["Neon"] = 52.61, ["Neon|Ride"] = 64.45, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 407.88}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 71.56, ["Ride"] = 21.36, ["Fly|Ride"] = 56.58, ["Neon"] = 101.03, ["Neon|Ride"] = 157.31, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 626.07}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.11, ["Ride"] = 59.07, ["Neon"] = 172.29, ["Neon|Ride"] = 177.19, ["Mega"] = 560.44}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.15, ["Fly"] = 196.88, ["Ride"] = 181.13, ["Fly|Ride"] = 210, ["Neon"] = 565.13, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 654.94}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 3.94, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 42.71, ["Neon"] = 39.38, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 127.71}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 21, ["Fly|Ride"] = 131.24, ["Neon"] = 15.75, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 139.22}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.34, ["Fly"] = 49.53, ["Ride"] = 27.45, ["Fly|Ride"] = 91.87, ["Neon"] = 112.73, ["Neon|Ride"] = 112.19, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 379.32}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 50.15, ["Fly"] = 157.6, ["Ride"] = 76.13, ["Fly|Ride"] = 166.69, ["Neon"] = 223.13, ["Neon|Ride"] = 379.29, ["Neon|Fly|Ride"] = 562.59, ["Mega"] = 1546.11}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.36, ["Ride"] = 84.29, ["Neon"] = 155.92, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 464.62, ["Mega"] = 699.82}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 24.05, ["Fly"] = 56.89, ["Ride"] = 32.21, ["Fly|Ride"] = 94.29, ["Neon"] = 195.74, ["Neon|Ride"] = 141.19, ["Mega"] = 761.25}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.75, ["Ride"] = 14.44, ["Fly|Ride"] = 31.5, ["Neon"] = 2.62, ["Neon|Ride"] = 17.66, ["Neon|Fly|Ride"] = 66.39, ["Mega"] = 20.9, ["Mega|Fly"] = 108.56}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 265.51, ["Mega"] = 196.88}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 4.73, ["Ride"] = 23.63, ["Neon"] = 27.41, ["Neon|Ride"] = 83.24, ["Neon|Fly|Ride"] = 984.01, ["Mega"] = 115.31, ["Mega|Fly"] = 498.61}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 393.74, ["Fly|Ride"] = 448.94, ["Neon"] = 1405.25, ["Neon|Ride"] = 1708.82, ["Neon|Fly|Ride"] = 1685.65}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 20.83, ["Ride"] = 15.39, ["Fly|Ride"] = 49.87, ["Neon"] = 19.68, ["Neon|Ride"] = 47.74, ["Neon|Fly|Ride"] = 87.46, ["Mega"] = 170.52}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.72, ["Fly"] = 19.99, ["Ride"] = 18.19, ["Fly|Ride"] = 32.82, ["Neon"] = 20.03, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 136.04}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.82, ["Fly"] = 32.45, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 16.89, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 36.89, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 121.87}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 31.5, ["Fly"] = 44.78, ["Ride"] = 42.15, ["Fly|Ride"] = 65.63, ["Neon"] = 220.29, ["Neon|Ride"] = 180.21, ["Neon|Fly|Ride"] = 351.89, ["Mega"] = 1312.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34, ["Fly|Ride"] = 49.68, ["Neon"] = 11.82, ["Neon|Ride"] = 77.98, ["Mega"] = 163.74}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.57, ["Fly"] = 65.58, ["Ride"] = 28.7, ["Neon"] = 168.79, ["Neon|Ride"] = 197.03}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 6.17, ["Neon|Ride"] = 35.44, ["Mega"] = 54.37}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.08, ["Ride"] = 140.44, ["Neon"] = 50.67}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.56, ["Ride"] = 47.77, ["Neon"] = 82.3, ["Neon|Ride"] = 477.33, ["Mega"] = 310.92}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.06, ["Fly"] = 30.19, ["Ride"] = 23.92, ["Fly|Ride"] = 52.41, ["Neon"] = 42.97, ["Neon|Fly"] = 119.35, ["Neon|Ride"] = 54.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 592.31}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 354.38, ["Fly"] = 515.74, ["Ride"] = 328.13, ["Fly|Ride"] = 416.07, ["Neon"] = 1642.41, ["Neon|Ride"] = 1616.12, ["Neon|Fly|Ride"] = 1516.04}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 35.84, ["Neon"] = 13.13, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 34.08, ["Mega"] = 204.47}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.86, ["Ride"] = 40.28, ["Fly|Ride"] = 65.63, ["Neon"] = 71.3, ["Neon|Ride"] = 158.05, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 340.03, ["Mega|Fly"] = 702.97}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 22.73, ["Ride"] = 114.19, ["Fly|Ride"] = 315, ["Neon"] = 76.13, ["Neon|Ride"] = 205.46, ["Neon|Fly|Ride"] = 414.08, ["Mega"] = 422.61}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 115.5, ["Fly"] = 112.24, ["Ride"] = 91.54, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 412.62, ["Mega"] = 2492.09}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.53, ["Fly"] = 105.35, ["Ride"] = 53.74, ["Fly|Ride"] = 141.17, ["Neon"] = 43.32, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 656.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 12.48, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 70.6, ["Mega"] = 65.61}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.6, ["Ride"] = 40.85, ["Fly|Ride"] = 64.32, ["Neon"] = 25.69, ["Neon|Ride"] = 99.05, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 176.77}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 53.06, ["Fly"] = 183.75, ["Ride"] = 99.75, ["Fly|Ride"] = 216.57, ["Neon"] = 139.04, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 431.88}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 10.39, ["Neon|Fly"] = 64.45, ["Neon|Ride"] = 255.39, ["Neon|Fly|Ride"] = 199.31}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 18.8, ["Neon"] = 139.13, ["Neon|Ride"] = 401.03, ["Mega"] = 572.92}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 971.25, ["Ride"] = 1061.82, ["Fly|Ride"] = 1049.88, ["Neon"] = 3351.92, ["Neon|Ride"] = 3610.45, ["Neon|Fly|Ride"] = 3498.77}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.1, ["Ride"] = 62.18, ["Fly|Ride"] = 190.97, ["Neon"] = 117.97, ["Neon|Fly"] = 701.58, ["Neon|Ride"] = 142.24, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 326.48}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 28.46, ["Fly|Ride"] = 80.92, ["Neon"] = 13.91, ["Neon|Fly"] = 56.89, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 92.72, ["Mega"] = 93.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 12.24, ["Ride"] = 47.76, ["Fly|Ride"] = 141.17, ["Neon"] = 99.04, ["Mega"] = 787.5}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 34.72, ["Fly|Ride"] = 182.97, ["Neon"] = 2.56, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 17.07, ["Mega|Fly"] = 126.49}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 54.87, ["Ride"] = 111.59, ["Fly|Ride"] = 236.24, ["Neon"] = 260.91, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 410.59, ["Mega"] = 1106.35}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.73, ["Ride"] = 61.69, ["Fly|Ride"] = 266.43, ["Neon"] = 80.76, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 559.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.68, ["Ride"] = 27.41, ["Neon"] = 9.19, ["Neon|Ride"] = 65.63, ["Mega"] = 89.02}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 19.39, ["Fly"] = 66.38, ["Ride"] = 48.46, ["Fly|Ride"] = 104.3, ["Neon"] = 90.61, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 1039.49}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.46, ["Fly"] = 32.67, ["Ride"] = 34.13, ["Fly|Ride"] = 94.82, ["Neon"] = 90.61, ["Neon|Ride"] = 70.6, ["Neon|Fly|Ride"] = 120.09, ["Mega"] = 446.83}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.14, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 731.73, ["Mega"] = 2103.24}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.44, ["Ride"] = 50.58, ["Neon"] = 21.15, ["Neon|Ride"] = 99.05, ["Neon|Fly|Ride"] = 210.72}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.65, ["Ride"] = 19.4, ["Fly|Ride"] = 83.23, ["Neon"] = 39.38, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 295.32}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 118.13, ["Fly"] = 393.75, ["Ride"] = 161.44, ["Fly|Ride"] = 251.9, ["Neon"] = 656.25, ["Neon|Ride"] = 696.89, ["Neon|Fly|Ride"] = 702.72}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 21.08, ["Ride"] = 15.94, ["Fly|Ride"] = 45.31, ["Neon"] = 12.97, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 141.24}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 12.9, ["Fly"] = 200.81, ["Ride"] = 44.5, ["Fly|Ride"] = 99.04, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 252.86, ["Mega"] = 452.82}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.81, ["Fly|Ride"] = 52.4, ["Neon"] = 2.1, ["Neon|Fly"] = 26.67, ["Neon|Ride"] = 15.06, ["Neon|Fly|Ride"] = 40.05, ["Mega|Fly"] = 50.19}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.89, ["Fly|Ride"] = 39.38, ["Neon"] = 2.61, ["Neon|Ride"] = 42.15, ["Mega"] = 20.01, ["Mega|Fly"] = 104.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.24, ["Fly"] = 35.84, ["Ride"] = 27.16, ["Fly|Ride"] = 129.89, ["Neon"] = 18.98, ["Neon|Ride"] = 55.55, ["Mega"] = 74.92}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.15, ["Ride"] = 52.49, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 337.14, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 492.18}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.77, ["Fly"] = 20.31, ["Ride"] = 15.8, ["Fly|Ride"] = 36.74, ["Neon"] = 9.55, ["Neon|Fly"] = 32.93, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 74.01, ["Mega"] = 105, ["Mega|Fly"] = 170.62}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.71, ["Fly"] = 23.89, ["Ride"] = 24.66, ["Fly|Ride"] = 82.65, ["Neon"] = 28.76, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 119.23, ["Mega"] = 230.99, ["Mega|Fly"] = 433.13}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.36, ["Ride"] = 18.09, ["Fly|Ride"] = 69.54, ["Neon"] = 7.88, ["Neon|Fly"] = 35.84, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 160.1, ["Mega|Fly"] = 220.4}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.33, ["Fly"] = 159.07, ["Ride"] = 32.82, ["Fly|Ride"] = 217.19, ["Neon"] = 26.25, ["Neon|Ride"] = 109.58, ["Mega"] = 323.57, ["Mega|Fly"] = 400.32}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 15.1, ["Ride"] = 141.17, ["Neon"] = 74.67, ["Neon|Ride"] = 262.39, ["Mega"] = 682.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.3, ["Fly"] = 22.83, ["Ride"] = 27.41, ["Fly|Ride"] = 45.85, ["Neon"] = 25.99, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 154.2, ["Mega"] = 262.49}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 14.34, ["Fly|Ride"] = 52.56, ["Neon"] = 16.62, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 184.46}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 262.5, ["Fly"] = 393.75, ["Ride"] = 264.81, ["Fly|Ride"] = 393.75, ["Neon"] = 1053.41, ["Neon|Ride"] = 1396.17, ["Neon|Fly|Ride"] = 1174.69}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.62, ["Ride"] = 111.75, ["Neon"] = 35.44, ["Mega"] = 122.07}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.13, ["Fly"] = 105.35, ["Ride"] = 22.24, ["Fly|Ride"] = 83.23, ["Neon"] = 23.15, ["Neon|Fly"] = 239.14, ["Neon|Ride"] = 59.79, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 209.9}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 4.86, ["Fly|Ride"] = 212.89, ["Neon"] = 36.75, ["Neon|Ride"] = 223.36, ["Neon|Fly|Ride"] = 632.14, ["Mega"] = 596.53}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.45, ["Fly|Ride"] = 30.3, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 37.75, ["Mega"] = 20.04, ["Mega|Fly"] = 84.33}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.44, ["Fly"] = 24.86, ["Ride"] = 17.83, ["Fly|Ride"] = 77.97, ["Neon"] = 10.21, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 111.57}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.52, ["Ride"] = 42.15, ["Neon"] = 13.13, ["Neon|Ride"] = 141.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 67.62, ["Ride"] = 84, ["Fly|Ride"] = 210, ["Neon"] = 556.5, ["Neon|Ride"] = 434.44, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.35, ["Fly"] = 99.04, ["Ride"] = 26.23, ["Fly|Ride"] = 100.68, ["Neon"] = 23.13, ["Neon|Ride"] = 64.28, ["Mega"] = 157.5}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.46, ["Ride"] = 19.74, ["Neon"] = 9.08, ["Neon|Ride"] = 79.97, ["Mega"] = 66.94, ["Mega|Fly"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.49, ["Fly"] = 210, ["Ride"] = 85.32, ["Fly|Ride"] = 183.75, ["Neon"] = 143.75, ["Neon|Ride"] = 197.03, ["Neon|Fly|Ride"] = 396.38, ["Mega"] = 590.63}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 14.3, ["Fly|Ride"] = 28.59, ["Neon"] = 2.63, ["Neon|Fly"] = 21.49, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 99.05, ["Mega"] = 19.46, ["Mega|Fly"] = 49.87}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 105.35, ["Neon"] = 3.44, ["Neon|Ride"] = 112.19, ["Neon|Fly|Ride"] = 285.32}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.41, ["Ride"] = 56.89, ["Neon"] = 8.17, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 90.11, ["Neon|Fly|Ride"] = 136.13, ["Mega|Fly"] = 183.4}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.93, ["Fly"] = 77.97, ["Ride"] = 48.57, ["Fly|Ride"] = 146.81, ["Neon"] = 22.32, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 83.14, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly"] = 267.71}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.08, ["Ride"] = 13.98, ["Fly|Ride"] = 25.6, ["Neon"] = 2.37, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.24, ["Mega"] = 18.38}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.74, ["Fly"] = 131.25, ["Ride"] = 90.56, ["Neon"] = 128.64, ["Neon|Fly"] = 421.38, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 562.8}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2945.15, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2543.47}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 1.79, ["Fly"] = 16.76, ["Ride"] = 15.75, ["Fly|Ride"] = 28.46, ["Neon"] = 11.58, ["Neon|Fly"] = 45.36, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 83.24, ["Mega"] = 97.2, ["Mega|Fly"] = 118.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.65, ["Neon"] = 7.66, ["Mega"] = 107.01, ["Mega|Fly"] = 441}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.27, ["Fly"] = 112.73, ["Ride"] = 28.46, ["Fly|Ride"] = 105, ["Neon"] = 72.19, ["Neon|Ride"] = 114.57, ["Neon|Fly|Ride"] = 281.31, ["Mega"] = 426.57}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.18, ["Ride"] = 52.31, ["Neon"] = 187.69, ["Mega"] = 736.7}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.28, ["Fly"] = 1403.03, ["Ride"] = 193.43, ["Fly|Ride"] = 255.94, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 714.65, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6323.47}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.26, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 26.25, ["Neon|Ride"] = 141.19, ["Mega"] = 421.58, ["Mega|Fly"] = 13125}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 35.84, ["Fly|Ride"] = 70.59, ["Neon"] = 26.25, ["Mega"] = 177.19}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.48, ["Fly"] = 100.04, ["Ride"] = 26.23, ["Fly|Ride"] = 131.25, ["Neon"] = 9.09, ["Neon|Fly"] = 124.32, ["Neon|Ride"] = 40.04, ["Mega"] = 104.99}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 17, ["Ride"] = 84.29, ["Neon"] = 183.3, ["Mega"] = 380.63}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.49, ["Neon|Ride"] = 47.74, ["Mega|Fly"] = 119.48}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.25, ["Fly"] = 105, ["Ride"] = 103.76, ["Fly|Ride"] = 155.92, ["Neon"] = 346.5, ["Neon|Ride"] = 398.58, ["Neon|Fly|Ride"] = 330.87, ["Mega"] = 3161.74}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 7.88, ["Neon|Ride"] = 140.91, ["Mega"] = 75.9}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 60.06, ["Fly"] = 101.14, ["Ride"] = 74.73, ["Fly|Ride"] = 182.44, ["Neon"] = 405.57, ["Neon|Ride"] = 1273.26, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1897.05}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 23.89, ["Ride"] = 21.08, ["Fly|Ride"] = 51.34, ["Neon"] = 5.25, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 42}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 8.57, ["Neon|Ride"] = 98.44}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.83, ["Fly"] = 77.43, ["Ride"] = 32.67, ["Neon"] = 26.25, ["Neon|Ride"] = 120.75, ["Mega"] = 314.99}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 371.42, ["Ride"] = 389.82, ["Fly|Ride"] = 701.58, ["Neon"] = 1050, ["Neon|Ride"] = 964.67, ["Neon|Fly|Ride"] = 1144.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.89, ["Fly"] = 84.29, ["Ride"] = 39.94, ["Fly|Ride"] = 107.3, ["Neon"] = 196.88, ["Neon|Ride"] = 171.29, ["Neon|Fly|Ride"] = 386.64, ["Mega"] = 1403.82}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.69, ["Fly|Ride"] = 84.29, ["Neon"] = 11.68, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 95.46, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 119.55}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.8, ["Fly"] = 39.38, ["Ride"] = 27.41, ["Fly|Ride"] = 170.63, ["Neon"] = 68.81, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 126.05, ["Neon|Fly|Ride"] = 183.15, ["Mega"] = 307.13, ["Mega|Fly"] = 983.25}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.33, ["Ride"] = 37.68, ["Fly|Ride"] = 196.88, ["Neon"] = 142.23, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 270.88, ["Mega"] = 316.19}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Neon|Fly"] = 72.19}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 15.85, ["Fly|Ride"] = 65.63, ["Neon"] = 42.95, ["Neon|Ride"] = 45.47, ["Mega"] = 333.05}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 102.27, ["Ride"] = 129.92, ["Fly|Ride"] = 242.82, ["Neon"] = 775.39, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 651, ["Mega"] = 2887.5}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.08, ["Ride"] = 37.43, ["Fly|Ride"] = 91.88, ["Neon"] = 210, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 1124.53}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2030.44, ["Ride"] = 1881.24, ["Fly|Ride"] = 2060.63, ["Neon"] = 11236.61, ["Neon|Fly|Ride"] = 6561.19}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 57.66, ["Fly|Ride"] = 196.87, ["Neon"] = 18.72, ["Mega"] = 111.03, ["Mega|Fly"] = 786.19}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.88, ["Ride"] = 49.53, ["Fly|Ride"] = 111.07, ["Neon"] = 41.78, ["Neon|Ride"] = 76.63, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 179.18}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 865.98, ["Fly"] = 1107.73, ["Ride"] = 900.38, ["Fly|Ride"] = 987, ["Neon"] = 2778.57, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2485.87}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 30.75, ["Ride"] = 49.88, ["Fly|Ride"] = 223.18, ["Neon"] = 157.5, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 377.1, ["Mega"] = 840}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.62, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 10.89, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 141.17, ["Neon"] = 3.07, ["Neon|Ride"] = 48.93, ["Neon|Fly|Ride"] = 97.86, ["Mega"] = 19.69}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.88, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 596.66, ["Neon|Fly|Ride"] = 702.72, ["Mega"] = 2389.38}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.79, ["Ride"] = 37.01, ["Fly|Ride"] = 73.8, ["Neon"] = 13.13, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 117.01}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.49, ["Fly"] = 105.35, ["Ride"] = 126, ["Fly|Ride"] = 91.88, ["Neon"] = 459.37, ["Neon|Ride"] = 562.59, ["Neon|Fly|Ride"] = 517.3}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.13, ["Fly"] = 105, ["Fly|Ride"] = 126.42, ["Neon"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 238.95}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Fly"] = 281.27, ["Ride"] = 307.13, ["Fly|Ride"] = 340.4, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 24.75, ["Fly|Ride"] = 48.45, ["Neon"] = 32.67, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 101.15, ["Mega"] = 280.22}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 16.9, ["Fly|Ride"] = 32.82, ["Neon"] = 6.22, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 46.12, ["Mega"] = 40.68}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1257.78, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7726.58, ["Neon|Fly|Ride"] = 6602.47, ["Mega"] = 23415.91}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.56, ["Fly"] = 983.9, ["Ride"] = 77.58, ["Neon"] = 65.51, ["Neon|Ride"] = 314.98, ["Mega"] = 283.37}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.93, ["Fly"] = 50.58, ["Ride"] = 53.74, ["Fly|Ride"] = 91.77, ["Neon"] = 23.27, ["Neon|Fly"] = 285.21, ["Neon|Ride"] = 52.79, ["Neon|Fly|Ride"] = 210.72, ["Mega"] = 196.88}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.97, ["Fly"] = 49.79, ["Ride"] = 47.77, ["Fly|Ride"] = 77.35, ["Neon|Ride"] = 209.79, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 2529.39}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.88, ["Fly"] = 84.29, ["Ride"] = 27.57, ["Fly|Ride"] = 77.44, ["Neon"] = 69.57, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 179.69, ["Mega"] = 367.4}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 44.54, ["Ride"] = 103.69, ["Fly|Ride"] = 410.84, ["Neon"] = 188.9, ["Neon|Ride"] = 378, ["Mega"] = 1050}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 1.79, ["Ride"] = 116.61, ["Fly|Ride"] = 270.92, ["Neon"] = 3.09, ["Neon|Fly"] = 56.89, ["Neon|Ride"] = 112.19, ["Mega"] = 33.73}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 70.88, ["Fly"] = 126.42, ["Ride"] = 104.96, ["Fly|Ride"] = 168.39, ["Neon"] = 572.84, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 3372.52}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.94, ["Fly"] = 107.62, ["Ride"] = 23.63, ["Fly|Ride"] = 70.59, ["Neon"] = 198.19, ["Neon|Ride"] = 95.95, ["Mega"] = 773.06}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 16, ["Fly|Ride"] = 38.16, ["Neon"] = 18.38, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 66.39, ["Neon|Fly|Ride"] = 122.85}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 139.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 200.19, ["Mega"] = 394.17}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 49.12, ["Ride"] = 114.57, ["Fly|Ride"] = 262.5, ["Neon"] = 326.82, ["Neon|Ride"] = 505.71, ["Neon|Fly|Ride"] = 702.72}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.78, ["Fly|Ride"] = 421.38, ["Neon"] = 16.69, ["Mega"] = 126.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.72, ["Neon"] = 2.1, ["Neon|Ride"] = 116.95}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.39, ["Fly|Ride"] = 63.23, ["Neon"] = 3.08, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 70.6}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.04, ["Fly|Ride"] = 49.25, ["Neon"] = 8.57, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.52, ["Neon"] = 24.93, ["Mega"] = 118.09}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 18.27, ["Fly|Ride"] = 32.84, ["Neon"] = 15.82, ["Neon|Fly"] = 210.7, ["Neon|Ride"] = 24.94, ["Mega"] = 157.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.75, ["Ride"] = 101.73, ["Fly|Ride"] = 267.58, ["Neon"] = 210.3, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1053.54, ["Mega"] = 961.8}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 15.44, ["Fly|Ride"] = 35.84, ["Neon"] = 2.51, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 19.08, ["Neon|Fly|Ride"] = 48.14, ["Mega"] = 25.99}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 5.25, ["Fly"] = 56.84, ["Ride"] = 23.81, ["Fly|Ride"] = 68.16, ["Neon"] = 32.82, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 401.66}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.75, ["Fly"] = 58.97, ["Ride"] = 36.75, ["Fly|Ride"] = 99.04, ["Neon"] = 130.05, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.43, ["Fly"] = 196.88, ["Neon"] = 65.63, ["Neon|Ride"] = 70.6, ["Mega"] = 365.73}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.07, ["Fly|Ride"] = 49.53, ["Neon"] = 5.84, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.08, ["Neon|Fly|Ride"] = 61.69, ["Mega|Fly"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.67, ["Fly"] = 72.19, ["Ride"] = 38.07, ["Neon"] = 24.86, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.69, ["Mega"] = 131.25, ["Mega|Fly"] = 735}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 928.92, ["Ride"] = 1050, ["Fly|Ride"] = 1034.25, ["Neon|Ride"] = 2421.55, ["Neon|Fly|Ride"] = 2450.32}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 157.5, ["Ride"] = 197.01, ["Fly|Ride"] = 677.86, ["Neon"] = 632.05, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 842.83, ["Mega"] = 3160.69}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.24, ["Fly"] = 56.89, ["Neon"] = 6.35, ["Neon|Ride"] = 52.5, ["Mega"] = 95.6}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 78.73, ["Ride"] = 118.13, ["Fly|Ride"] = 157.31, ["Neon"] = 392.38, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 625.8, ["Mega"] = 1894.94}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 21.08, ["Fly|Ride"] = 91.66, ["Neon"] = 19.69, ["Neon|Fly"] = 42.15, ["Neon|Ride"] = 51.61, ["Neon|Fly|Ride"] = 323.45, ["Mega"] = 281.4}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 236, ["Fly"] = 955.07, ["Ride"] = 273.84, ["Fly|Ride"] = 328.13, ["Neon"] = 1199.83, ["Neon|Ride"] = 1646.76, ["Neon|Fly|Ride"] = 1273.26}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.1, ["Fly|Ride"] = 220.79, ["Neon"] = 31.5, ["Neon|Fly"] = 35.84, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 328.83}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 42.77, ["Mega"] = 131.25}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 25.78, ["Fly|Ride"] = 151.57, ["Neon"] = 111.61, ["Neon|Ride"] = 124.69, ["Mega"] = 463.76}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.75, ["Neon"] = 31.4, ["Neon|Ride"] = 196.88, ["Mega"] = 238.95}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.83, ["Fly|Ride"] = 28.46, ["Neon"] = 2.63, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 42.15, ["Mega"] = 42.17}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5263.13, ["Ride"] = 5118.75, ["Fly|Ride"] = 4588.5, ["Neon"] = 31601.94, ["Neon|Fly|Ride"] = 19293.75}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 52.39, ["Fly"] = 84.29, ["Ride"] = 56.43, ["Neon"] = 53.45, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 210}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 16.91, ["Fly|Ride"] = 35.79, ["Neon"] = 14.44, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 131.25}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 456.8, ["Fly"] = 610.98, ["Ride"] = 503.05, ["Fly|Ride"] = 547.72, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1274.44}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.83, ["Ride"] = 33.29, ["Neon"] = 19.11, ["Mega"] = 140.95}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.75, ["Fly"] = 4213.6, ["Ride"] = 36.74, ["Neon"] = 23.63, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 310.8, ["Mega"] = 1145.62}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.37, ["Ride"] = 17.63, ["Neon"] = 3.91, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.38}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 708.75, ["Ride"] = 666.37, ["Fly|Ride"] = 762.57, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2480.62}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.28, ["Ride"] = 55.18, ["Fly|Ride"] = 421.38, ["Neon"] = 31.5, ["Neon|Ride"] = 91.67, ["Neon|Fly|Ride"] = 281.31}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.62, ["Fly"] = 236.25, ["Ride"] = 33.79, ["Fly|Ride"] = 105.35, ["Neon"] = 24.22, ["Neon|Ride"] = 59.01, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 271.21, ["Mega|Fly"] = 796.87}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.96, ["Fly|Ride"] = 59, ["Neon"] = 11.7, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 157.5}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.38, ["Ride"] = 34.12, ["Fly|Ride"] = 58.42, ["Neon"] = 151.71, ["Mega"] = 842.08}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 84.29, ["Neon"] = 4.23, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega|Fly"] = 84.33}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 498.75, ["Ride"] = 590.63, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2566.4, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 105.35, ["Ride"] = 92.06, ["Neon"] = 13.5, ["Neon|Ride"] = 91.54}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Neon"] = 5.23, ["Neon|Fly"] = 105.35, ["Neon|Ride"] = 42.15}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 46.95, ["Mega|Fly"] = 155.99}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 35.84, ["Neon"] = 13.01, ["Mega"] = 210.8}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.5, ["Fly"] = 64.32, ["Ride"] = 52.5, ["Fly|Ride"] = 101.35, ["Neon"] = 122.06, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 285.92, ["Mega"] = 597.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 18.38, ["Ride"] = 68.25, ["Fly|Ride"] = 88.5, ["Neon"] = 84, ["Neon|Ride"] = 141.19, ["Mega"] = 381.94}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.96, ["Ride"] = 15.1, ["Fly|Ride"] = 38.07, ["Neon"] = 17.92, ["Neon|Fly"] = 56.89, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 232.93}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.63, ["Ride"] = 56.04, ["Neon"] = 28.93, ["Neon|Ride"] = 139.08}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.16, ["Fly|Ride"] = 87.05, ["Neon"] = 10.5, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 46.89, ["Neon|Fly|Ride"] = 112.74, ["Mega"] = 80.27}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.84, ["Fly"] = 112.24, ["Ride"] = 23.89, ["Fly|Ride"] = 63.23, ["Neon"] = 10533.98, ["Neon|Ride"] = 119.35, ["Neon|Fly|Ride"] = 192.05, ["Mega"] = 787.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.44, ["Fly"] = 874.13, ["Neon"] = 133.77, ["Mega"] = 328.12}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.55, ["Fly"] = 153.58, ["Ride"] = 85.2, ["Fly|Ride"] = 124.69, ["Neon"] = 420, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 431.82}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.59, ["Fly"] = 85.44, ["Ride"] = 76.74, ["Fly|Ride"] = 209.65, ["Neon"] = 144.36, ["Neon|Ride"] = 206.51, ["Neon|Fly|Ride"] = 315, ["Mega"] = 535.5}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 20.4, ["Ride"] = 57.5, ["Neon"] = 114.35, ["Mega"] = 1049.99}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.17, ["Fly"] = 421.38, ["Ride"] = 72.19, ["Fly|Ride"] = 208.6, ["Neon"] = 136.31, ["Neon|Fly"] = 420, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 315, ["Mega"] = 424.15}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.92, ["Ride"] = 15.75, ["Fly|Ride"] = 32.74, ["Neon"] = 6.57, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 70.6, ["Mega"] = 46.39}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1025.51}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 42.75, ["Ride"] = 97.12, ["Fly|Ride"] = 260.39, ["Neon"] = 346.87, ["Neon|Ride"] = 365.59, ["Mega"] = 1115.86}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 3.89, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 295, ["Mega"] = 31.5}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 47.25, ["Ride"] = 94.82, ["Fly|Ride"] = 159.93, ["Neon"] = 91.88, ["Neon|Ride"] = 133.95, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 525}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Mega"] = 26.24}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.86, ["Mega"] = 23.59}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 103.67, ["Fly"] = 223.13, ["Ride"] = 143.07, ["Fly|Ride"] = 354.13, ["Neon"] = 557.33, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 27.41, ["Fly|Ride"] = 133.88, ["Neon"] = 6.46, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 90.17}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Fly|Ride"] = 50.93, ["Neon"] = 4.79, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 141.19, ["Mega"] = 35.44}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.9, ["Mega"] = 77.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 3.44, ["Neon|Ride"] = 156.19, ["Mega"] = 70.63}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 118.13, ["Fly|Ride"] = 562.53, ["Neon"] = 437.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2038.26}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.52, ["Ride"] = 60.05, ["Neon"] = 39.38, ["Neon|Ride"] = 159.92, ["Mega"] = 413.86}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 380.63, ["Ride"] = 384.38, ["Fly|Ride"] = 768.56, ["Neon"] = 1365, ["Neon|Ride"] = 1405.42, ["Neon|Fly|Ride"] = 1076.25}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 89.25}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.22}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.09}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 43.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.82}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 24.69}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.44}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.77}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 10.29}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.45}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 1.79}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 589.89}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.19}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1184.53}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 3.29}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 15.68}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.52}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.34}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.37}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.54}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.12}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 47.16}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.82}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.25}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.26}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.02}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.78}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 24.55}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 145.38}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.66}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2672.25}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 31.64}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.93}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.15}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.39}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.6}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 203.24}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.14}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 32.37}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.77}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 1.84}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 59.07}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 17.71}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 97.39}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.97}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.18}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 42.71}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 92.03}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 229.67}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.01}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 318.76}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.23}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 22.58}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22739.75}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 319.2}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 159.99}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 88.36}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 21.18}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 82.19}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.3}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 91.66}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.89}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.88}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 12.5}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.16}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.12}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 126}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.09}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.49}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.31}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1137.68}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.99}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.82}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 1.79}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 26.99}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 105}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 24.46}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 51.76}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.71}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.47}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.77}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 52.41}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 281.27}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 318.76}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 12.89}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.4}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.86}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 37.97}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 20.9}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.71}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 12.79}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 15.23}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 21.59}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 21.95}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.44}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 7.02}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.25}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.76}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.68}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.03}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 1.79}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.82}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8100.83}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 23.88}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.98}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.59}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.45}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.26}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 1.79}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 22.32}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.76}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 1.79}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.06}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 52.5}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 13}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4417.11}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.44}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 30.35}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.34}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.45}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 70.61}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.1}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 100.82}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.26}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.7}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.68}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.23}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.01}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 16.94}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.18}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 1.79}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.17}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 7.53}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.89}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 1.82}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.81}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.34}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.88}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.72}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.1}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 256.53}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.65}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 67.59}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.76}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1165.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 58.78}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.23}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.35}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 14.96}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 6.18}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.28}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.55}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.63}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 1.79}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 7.19}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.92}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 16.67}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.5}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.68}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.55}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.61}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 20.03}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 56.33}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.9}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 6.57}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 29.95}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.55}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.07}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.24}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 81.25}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 34.13}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.37}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.71}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.13}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.14}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.02}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.48}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.51}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 152.06}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 8.53}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1432.58}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.75}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 201.22}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.83}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.55}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.28}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.34}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.98}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.57}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 52.41}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 10.6}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.94}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.09}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.49}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 141.17}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.55}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.44}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.43}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.22}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 137.21}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 7.19}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 80.85}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.77}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 48.48}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 56.62}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.59}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 187.69}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.67}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 3.19}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 152.02}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.73}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.45}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 17.97}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.97}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 92.99}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 18.19}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 65.51}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 14.2}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 55.44}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.68}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.33}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.05}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.9}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 15.73}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 68.1}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 35.53}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 159.99}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.8}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.22}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 21}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 341.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.72}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.98}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 33.18}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.82}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.23}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 293.22}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.44}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 101.13}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 183.31}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 76.79}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 152.8}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.39}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
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