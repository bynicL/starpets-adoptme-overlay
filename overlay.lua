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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 984.37, ["Ride"] = 1179.92, ["Fly|Ride"] = 1693.13, ["Neon"] = 6830.27, ["Neon|Fly|Ride"] = 5042.36, ["Mega"] = 21574.72}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 515.65, ["Ride"] = 530.25, ["Fly|Ride"] = 679.1, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 10787.37, ["Mega|Fly|Ride"] = 8128.14}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 4593.74, ["Fly|Ride"] = 4899.57, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 73601.45}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 196.88, ["Fly"] = 249.38, ["Ride"] = 223.13, ["Fly|Ride"] = 487.61, ["Neon"] = 1139.23, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4940.64}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 863.09, ["Ride"] = 588, ["Fly|Ride"] = 616.87, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.22, ["Ride"] = 59.07, ["Fly|Ride"] = 129.94, ["Neon"] = 87.49, ["Neon|Fly"] = 288.08, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 323.64, ["Mega"] = 353.75, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 512.9}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 43.21, ["Ride"] = 27.57, ["Fly|Ride"] = 58.47, ["Neon"] = 31.5, ["Neon|Fly"] = 63, ["Neon|Ride"] = 62.6, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 203.44, ["Mega|Ride"] = 218.7, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 107.77, ["Fly"] = 215.79, ["Ride"] = 141.75, ["Fly|Ride"] = 210.03, ["Neon"] = 505.49, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2157.48}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.98, ["Fly"] = 97.76, ["Ride"] = 49.84, ["Fly|Ride"] = 117.69, ["Neon"] = 275.62, ["Neon|Ride"] = 231.55, ["Neon|Fly|Ride"] = 245.16, ["Mega"] = 2100, ["Mega|Ride"] = 1212.28, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.29, ["Fly"] = 48.95, ["Ride"] = 32.03, ["Fly|Ride"] = 73.83, ["Neon"] = 201.06, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 647.26, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 76.06, ["Fly"] = 216.57, ["Ride"] = 110.23, ["Fly|Ride"] = 172.64, ["Neon"] = 388.8, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 414.37, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.19}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 361.48, ["Fly"] = 487.66, ["Ride"] = 350.43, ["Fly|Ride"] = 412.13, ["Neon"] = 1294.64, ["Neon|Ride"] = 1401.46, ["Neon|Fly|Ride"] = 1207.5, ["Mega|Fly|Ride"] = 5150.5}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.42, ["Fly"] = 170.47, ["Ride"] = 145.69, ["Fly|Ride"] = 159.7, ["Neon|Fly"] = 683.06, ["Neon|Fly|Ride"] = 563.07, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.41, ["Fly"] = 78.23, ["Ride"] = 60.97, ["Fly|Ride"] = 163.37, ["Neon"] = 20.88, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 325.79, ["Mega|Fly|Ride"] = 388.4}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 232.32, ["Fly"] = 229.69, ["Ride"] = 233.63, ["Fly|Ride"] = 279.19, ["Neon|Ride"] = 837.77, ["Neon|Fly|Ride"] = 740.66, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 19.81, ["Fly|Ride"] = 41.99, ["Neon"] = 26.25, ["Neon|Fly"] = 129.48, ["Neon|Ride"] = 71.14, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 170.63, ["Mega|Ride"] = 307.39, ["Mega|Fly|Ride"] = 401.49}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 131.24, ["Fly"] = 215.79, ["Ride"] = 173.2, ["Fly|Ride"] = 325.49, ["Neon"] = 485.63, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1312.5, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1856.29}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.68}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 79.38, ["Ride"] = 170.63, ["Fly|Ride"] = 288.03, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1462.8}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 32.38, ["Fly"] = 393.75, ["Ride"] = 57.69, ["Fly|Ride"] = 431.55, ["Neon"] = 262.5, ["Neon|Ride"] = 353.84, ["Neon|Fly|Ride"] = 373.3, ["Mega"] = 1009.32, ["Mega|Ride"] = 1108, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.09, ["Fly"] = 110.04, ["Ride"] = 65.62, ["Fly|Ride"] = 111.54, ["Neon"] = 216.56, ["Neon|Ride"] = 197.45, ["Neon|Fly|Ride"] = 275.03, ["Mega"] = 1707.59, ["Mega|Fly|Ride"] = 916.2}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.19, ["Fly"] = 247.11, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 161.84, ["Neon|Ride"] = 395.63, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1967.44, ["Mega|Ride"] = 1439.22, ["Mega|Fly|Ride"] = 1551.42}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 49.86, ["Ride"] = 52.59, ["Fly|Ride"] = 111.11, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.84, ["Fly"] = 102.38, ["Ride"] = 66.94, ["Fly|Ride"] = 131.25, ["Neon"] = 374.33, ["Neon|Ride"] = 277.97, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1139.23, ["Mega|Fly|Ride"] = 1439.05}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.64, ["Fly"] = 32.45, ["Ride"] = 28.88, ["Fly|Ride"] = 52.49, ["Neon"] = 43.98, ["Neon|Fly"] = 97.86, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 157.5, ["Mega|Fly"] = 27385.76, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 426.15}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 401.63, ["Fly"] = 538.31, ["Ride"] = 415.8, ["Fly|Ride"] = 465.94, ["Neon"] = 2072.3, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1704.94, ["Mega"] = 10788.53, ["Mega|Fly|Ride"] = 9677.3}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.73, ["Ride"] = 31.49, ["Fly|Ride"] = 127.31, ["Neon"] = 90.57, ["Mega|Ride"] = 403.46, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.24, ["Fly"] = 43.23, ["Ride"] = 19.68, ["Fly|Ride"] = 53.95, ["Neon"] = 61.74, ["Neon|Ride"] = 74.07, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 346.38, ["Mega|Ride"] = 345.24, ["Mega|Fly|Ride"] = 459.56}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 65.63, ["Fly"] = 119.76, ["Ride"] = 82.69, ["Fly|Ride"] = 129.87, ["Neon"] = 393.75, ["Neon|Fly"] = 374.38, ["Neon|Ride"] = 438.85, ["Neon|Fly|Ride"] = 400.6, ["Mega"] = 6458.5, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 17.07, ["Ride"] = 34.21, ["Fly|Ride"] = 55.04, ["Neon"] = 83.32, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 241.64, ["Mega"] = 720.57, ["Mega|Ride"] = 731.85, ["Mega|Fly|Ride"] = 538.31}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 225.73, ["Fly"] = 288.75, ["Ride"] = 250.69, ["Fly|Ride"] = 361.52, ["Neon"] = 754.07, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 2804.73, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3090.78}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 25.87}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 6.15, ["Fly"] = 26.23, ["Ride"] = 23.2, ["Fly|Ride"] = 72.85, ["Neon"] = 23.63, ["Neon|Fly"] = 144.58, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 148.32, ["Mega|Fly"] = 487.54, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 284.84}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 944.99, ["Fly"] = 2625, ["Ride"] = 984.38, ["Fly|Ride"] = 1284.94, ["Neon"] = 7552.02, ["Neon|Ride"] = 5466.59, ["Neon|Fly|Ride"] = 5035.07, ["Mega|Ride"] = 54846.56, ["Mega|Fly|Ride"] = 18698.84}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 15.73, ["Fly"] = 55.4, ["Ride"] = 51.95, ["Fly|Ride"] = 80.94, ["Neon"] = 189.11, ["Neon|Ride"] = 274.01, ["Neon|Fly|Ride"] = 273.79, ["Mega"] = 1036.88, ["Mega|Ride"] = 1107.88, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 206.07, ["Fly"] = 365.93, ["Ride"] = 223.13, ["Fly|Ride"] = 328.13, ["Neon"] = 921.38, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 1030.31, ["Mega"] = 4200.62, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4029.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.57, ["Fly"] = 144.57, ["Ride"] = 119.44, ["Fly|Ride"] = 144.57, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 586.62, ["Mega|Ride"] = 576.06, ["Mega|Fly|Ride"] = 651.35}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 118.13, ["Fly"] = 162.24, ["Ride"] = 144.38, ["Fly|Ride"] = 170.63, ["Neon"] = 430.48, ["Neon|Ride"] = 528.29, ["Mega|Ride"] = 2278.46, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 112.88, ["Fly"] = 250.08, ["Ride"] = 144.57, ["Fly|Ride"] = 196.88, ["Neon"] = 388.4, ["Neon|Fly"] = 576.14, ["Neon|Ride"] = 426.27, ["Neon|Fly|Ride"] = 497.43, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 38.05}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 48.44, ["Fly"] = 62.99, ["Ride"] = 45, ["Fly|Ride"] = 77.96, ["Neon|Ride"] = 502.16, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 4315.42, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.69, ["Ride"] = 49.64, ["Fly|Ride"] = 157.5, ["Neon"] = 39, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 144.58, ["Mega"] = 202.13, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 203.58, ["Mega|Fly|Ride"] = 431.55}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Fly"] = 743.9, ["Ride"] = 560.27, ["Fly|Ride"] = 543.38, ["Neon"] = 1968.75, ["Neon|Fly"] = 3883.46, ["Neon|Ride"] = 2157.73, ["Neon|Fly|Ride"] = 2041.23, ["Mega|Ride"] = 15102.32, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 126, ["Fly"] = 170.63, ["Ride"] = 132.81, ["Fly|Ride"] = 170.63, ["Neon"] = 498.75, ["Neon|Ride"] = 565.34, ["Neon|Fly|Ride"] = 740.11, ["Mega"] = 2589.28, ["Mega|Ride"] = 2589.28, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 15102.96}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 62.32, ["Fly"] = 115.46, ["Ride"] = 98.44, ["Fly|Ride"] = 188.83, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 505.32, ["Mega|Ride"] = 2017.47, ["Mega|Fly|Ride"] = 2013.17}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 72.19, ["Fly|Ride"] = 131.64, ["Neon"] = 575.75, ["Neon|Ride"] = 429.19, ["Neon|Fly|Ride"] = 429.35, ["Mega"] = 6329.64, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1799.25}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.42, ["Fly"] = 38.07, ["Ride"] = 49.63, ["Fly|Ride"] = 101.42, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2625, ["Mega|Ride"] = 906.13, ["Mega|Fly|Ride"] = 589.92}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.33}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 60.38, ["Fly"] = 52.5, ["Ride"] = 66.9, ["Fly|Ride"] = 130.53, ["Neon|Ride"] = 331.23, ["Neon|Fly|Ride"] = 604.11, ["Mega|Ride"] = 1301.45, ["Mega|Fly|Ride"] = 1362.45}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 207.38, ["Fly|Ride"] = 282.19, ["Neon"] = 1151.03, ["Neon|Ride"] = 1151.03, ["Neon|Fly|Ride"] = 1292.33, ["Mega|Fly|Ride"] = 4878.9}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 787.48, ["Fly"] = 809.07, ["Ride"] = 717.93, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11794.92}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.61}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.55, ["Fly"] = 56.17, ["Ride"] = 36.75, ["Fly|Ride"] = 64.32, ["Neon"] = 246.75, ["Neon|Fly"] = 280.49, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 213.74, ["Mega|Ride"] = 1170.94, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 23.5}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 7912.37, ["Fly|Ride"] = 4462.5, ["Neon|Ride"] = 17890.88, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43909.99}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.42, ["Fly"] = 144.57, ["Ride"] = 26.04, ["Fly|Ride"] = 79.84, ["Neon"] = 95.5, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 185.58, ["Mega"] = 560.96, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.54, ["Fly"] = 141.33, ["Ride"] = 31.74, ["Fly|Ride"] = 120.7, ["Neon"] = 82.9, ["Neon|Ride"] = 133.77, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 865.92, ["Mega|Ride"] = 475.79, ["Mega|Fly|Ride"] = 1078.88}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 76.13, ["Ride"] = 93.18, ["Fly|Ride"] = 129.48, ["Neon|Ride"] = 502.7, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4314.96, ["Mega|Fly|Ride"] = 1789.34}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 72.29, ["Ride"] = 36.69, ["Fly|Ride"] = 78.75, ["Neon"] = 93.19, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 485.49, ["Mega|Ride"] = 764.78, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1575, ["Fly"] = 1995.91, ["Ride"] = 1970.07, ["Fly|Ride"] = 1721.66, ["Neon|Fly|Ride"] = 3261.57, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34519.56, ["Ride"] = 34125, ["Fly|Ride"] = 28209.57, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 14.8, ["Fly"] = 393.75, ["Ride"] = 54.87, ["Fly|Ride"] = 120.74, ["Neon"] = 245.22, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 592.07, ["Mega"] = 754.07, ["Mega|Ride"] = 1300.48, ["Mega|Fly|Ride"] = 754.07}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4.18, ["Fly"] = 123.06, ["Ride"] = 46.79, ["Fly|Ride"] = 199.5, ["Neon"] = 22.32, ["Neon|Fly"] = 230.86, ["Neon|Ride"] = 81.2, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 135.19, ["Mega|Fly"] = 390.09, ["Mega|Ride"] = 234.93, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.3}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.87, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 56.43, ["Neon|Ride"] = 101.42, ["Neon|Fly|Ride"] = 268.86, ["Mega"] = 420.77, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 721.62, ["Ride"] = 679.88, ["Fly|Ride"] = 708.74, ["Neon"] = 3088.49, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10327.4}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 939.75, ["Fly"] = 1076.15, ["Ride"] = 871.5, ["Fly|Ride"] = 846.57, ["Neon|Ride"] = 3251.06, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13660.89}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13.23, ["Fly"] = 121.99, ["Ride"] = 36.74, ["Fly|Ride"] = 76.4, ["Neon"] = 87.93, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 500.59, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 523.95}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.6}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 83.99, ["Fly"] = 118.13, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 374.52, ["Neon|Ride"] = 370.18, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Fly|Ride"] = 2115.42}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 102.38, ["Ride"] = 122.07, ["Fly|Ride"] = 157.49, ["Neon"] = 450.19, ["Neon|Ride"] = 450.43, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1403.87, ["Mega|Fly|Ride"] = 2143.46}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.19, ["Fly"] = 43.17, ["Ride"] = 25.47, ["Fly|Ride"] = 64.81, ["Neon"] = 49.88, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 81.69, ["Neon|Fly|Ride"] = 116.65, ["Mega"] = 360.35, ["Mega|Fly|Ride"] = 666.82}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 181.91, ["Fly"] = 224.43, ["Ride"] = 211.32, ["Fly|Ride"] = 250.69, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 725.82, ["Mega"] = 5177.95, ["Mega|Fly|Ride"] = 2614.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.22, ["Ride"] = 49.24, ["Fly|Ride"] = 141.75, ["Neon"] = 44.63, ["Neon|Ride"] = 169.32, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.02, ["Mega|Fly|Ride"] = 469.31}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.13, ["Ride"] = 38.25, ["Fly|Ride"] = 65.5, ["Neon"] = 126, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.58}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.9, ["Ride"] = 57.74, ["Fly|Ride"] = 156.19, ["Neon"] = 257.25, ["Neon|Ride"] = 210.39, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.92, ["Fly"] = 215.32, ["Ride"] = 38.59, ["Fly|Ride"] = 80.29, ["Neon"] = 131.25, ["Neon|Ride"] = 144.57, ["Neon|Fly|Ride"] = 227.96, ["Mega"] = 1257.83, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6785.63, ["Ride"] = 5643.75, ["Fly|Ride"] = 5743.5, ["Neon"] = 35962.46, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30061.15}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.12, ["Fly"] = 249.38, ["Ride"] = 210, ["Fly|Ride"] = 276.94, ["Neon"] = 646.25, ["Neon|Fly"] = 690.48, ["Neon|Fly|Ride"] = 568.55, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 64.05, ["Fly"] = 288.08, ["Ride"] = 126, ["Fly|Ride"] = 236.25, ["Neon"] = 194.25, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 360.93, ["Mega"] = 485.63, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 623.7}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.94, ["Fly"] = 90.27, ["Ride"] = 33.78, ["Fly|Ride"] = 81.37, ["Neon"] = 21, ["Neon|Fly"] = 86.33, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 137.82, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 64.74, ["Fly"] = 215.34, ["Ride"] = 124.15, ["Fly|Ride"] = 288.08, ["Neon"] = 210, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 502.85, ["Mega|Fly"] = 733.56, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16541.35, ["Ride"] = 13415.07, ["Fly|Ride"] = 11807.25, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 107598.93}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 315, ["Ride"] = 389.82, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 2157.48, ["Neon|Fly|Ride"] = 1654.79, ["Mega|Fly|Ride"] = 7192.78}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 41.88, ["Fly"] = 90.5, ["Ride"] = 63, ["Fly|Ride"] = 91.88, ["Neon"] = 1050, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 374.25, ["Mega|Fly|Ride"] = 2012.94}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.32, ["Ride"] = 24.86, ["Fly|Ride"] = 69.04, ["Neon"] = 66.78, ["Neon|Fly"] = 325.68, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 525, ["Mega|Ride"] = 731.85, ["Mega|Fly|Ride"] = 486.59}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.72, ["Ride"] = 421.32, ["Fly|Ride"] = 472.5, ["Neon"] = 1715.2, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.25, ["Ride"] = 42, ["Fly|Ride"] = 183.75, ["Neon"] = 30.17, ["Neon|Ride"] = 91.96, ["Neon|Fly|Ride"] = 168, ["Mega"] = 157.5, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105, ["Fly"] = 187.71, ["Ride"] = 152.25, ["Fly|Ride"] = 185.15, ["Neon"] = 598.55, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2419.98}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.88, ["Fly"] = 19.19, ["Ride"] = 18.38, ["Fly|Ride"] = 36.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 2589.26, ["Mega|Fly|Ride"] = 551.24}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.66}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65, ["Fly"] = 863.1, ["Ride"] = 87.94, ["Fly|Ride"] = 172.61, ["Neon"] = 244.13, ["Neon|Fly"] = 538.31, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 431.51, ["Mega|Ride"] = 2012.94}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.8, ["Fly"] = 93.89, ["Ride"] = 38.05, ["Fly|Ride"] = 106.07, ["Neon"] = 85.32, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 178.27, ["Mega"] = 581.52, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1154.92}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 36.74}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 74.81, ["Fly"] = 144.57, ["Ride"] = 118.13, ["Fly|Ride"] = 431.55, ["Neon"] = 392.44, ["Neon|Ride"] = 403.51, ["Neon|Fly|Ride"] = 650.96, ["Mega|Ride"] = 1627.13, ["Mega|Fly|Ride"] = 2071.42}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.99, ["Fly|Ride"] = 137.82, ["Neon"] = 22.61, ["Neon|Ride"] = 141.33, ["Neon|Fly|Ride"] = 288.03, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 323.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.82, ["Fly"] = 56.42, ["Ride"] = 33.46, ["Fly|Ride"] = 78.75, ["Neon"] = 131.25, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.96, ["Ride"] = 519, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2803.66, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.82, ["Fly"] = 107.89, ["Ride"] = 72.19, ["Fly|Ride"] = 99.74, ["Neon"] = 195.57, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 719.62}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.88, ["Fly"] = 144.46, ["Ride"] = 78.65, ["Fly|Ride"] = 143.97, ["Neon"] = 270.38, ["Neon|Ride"] = 232.16, ["Neon|Fly|Ride"] = 164.07, ["Mega|Ride"] = 1070.24, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 22.32, ["Ride"] = 58.47, ["Fly|Ride"] = 129.48, ["Neon"] = 112.88, ["Neon|Ride"] = 175.24, ["Neon|Fly|Ride"] = 262.79, ["Mega"] = 446.25, ["Mega|Fly"] = 525, ["Mega|Ride"] = 526.51, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10213.59, ["Ride"] = 8862, ["Fly|Ride"] = 8516.82, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1641.94, ["Fly"] = 1517.02, ["Ride"] = 1365, ["Fly|Ride"] = 1298.87, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Fly|Ride"] = 16396.8}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 515.65, ["Ride"] = 525, ["Fly|Ride"] = 804.75, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21577.05, ["Mega|Fly|Ride"] = 8629.91}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.98, ["Fly"] = 29.14, ["Ride"] = 21.56, ["Fly|Ride"] = 41.05, ["Neon"] = 136.5, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.23, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.46, ["Fly"] = 78.74, ["Ride"] = 37.77, ["Fly|Ride"] = 198.5, ["Neon"] = 23.63, ["Neon|Ride"] = 39.38, ["Mega"] = 145.43, ["Mega|Ride"] = 202.44, ["Mega|Fly|Ride"] = 288.08}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.64, ["Fly"] = 43.3, ["Ride"] = 52.49, ["Fly|Ride"] = 101.06, ["Neon"] = 238.44, ["Neon|Ride"] = 136.38, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 526.24}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 28.05, ["Ride"] = 18.78, ["Fly|Ride"] = 39.37, ["Neon"] = 35.44, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 51.8, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 216.49, ["Mega|Ride"] = 360.31, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.55, ["Fly"] = 331.2, ["Ride"] = 317.63, ["Fly|Ride"] = 383.25, ["Neon"] = 1077.67, ["Neon|Ride"] = 1151.03, ["Neon|Fly|Ride"] = 1080.06, ["Mega|Fly|Ride"] = 4436.11}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.68, ["Fly"] = 60.42, ["Ride"] = 44.63, ["Fly|Ride"] = 65.63, ["Neon"] = 144.37, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 158.65, ["Mega"] = 863.02, ["Mega|Fly"] = 911.15, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.39, ["Fly"] = 28.94, ["Ride"] = 26.85, ["Fly|Ride"] = 45.92, ["Neon"] = 84.17, ["Neon|Fly"] = 121.92, ["Neon|Ride"] = 120.79, ["Neon|Fly|Ride"] = 119.61, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 417.54}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 404.58, ["Fly|Ride"] = 430.48, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1239, ["Fly"] = 1439.21, ["Ride"] = 1155, ["Fly|Ride"] = 1181.25, ["Neon"] = 5233.7, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13663.29}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 107.9, ["Fly"] = 144.57, ["Ride"] = 94.26, ["Fly|Ride"] = 105.18, ["Neon"] = 971.25, ["Neon|Ride"] = 593.39, ["Neon|Fly|Ride"] = 492.19, ["Mega|Fly|Ride"] = 2846.85}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.14, ["Fly"] = 218.39, ["Ride"] = 210, ["Fly|Ride"] = 258.57, ["Neon"] = 960.2, ["Neon|Ride"] = 731.85, ["Neon|Fly|Ride"] = 602.44, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 29.17, ["Fly"] = 124.07, ["Ride"] = 53.81, ["Fly|Ride"] = 103.58, ["Neon"] = 262.49, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2157.48, ["Mega|Fly|Ride"] = 1091.66}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 393.75, ["Ride"] = 431.16, ["Fly|Ride"] = 489.76, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1294.5, ["Mega|Fly|Ride"] = 5753.98}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2445.8, ["Ride"] = 1968.75, ["Fly|Ride"] = 2068.11, ["Neon|Fly|Ride"] = 10787.37, ["Mega|Fly|Ride"] = 37244.2}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 37.78, ["Fly"] = 215.77, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2373.23, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 590.63, ["Fly"] = 776.79, ["Ride"] = 619.47, ["Fly|Ride"] = 682.47, ["Neon"] = 1626.15, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1140.57, ["Mega|Fly|Ride"] = 3018.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.91, ["Fly"] = 63.95, ["Ride"] = 55.13, ["Fly|Ride"] = 104.99, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 249.37, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.25, ["Fly"] = 43.21, ["Ride"] = 19.95, ["Fly|Ride"] = 67.98, ["Neon"] = 28.28, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 48.78, ["Neon|Fly|Ride"] = 111.97, ["Mega"] = 166.28, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 187.39, ["Mega|Fly|Ride"] = 236.8}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.63, ["Ride"] = 82.27, ["Fly|Ride"] = 157.5, ["Neon"] = 196.77, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 576.06, ["Mega"] = 1579.3, ["Mega|Ride"] = 1726.01, ["Mega|Fly|Ride"] = 1711.97}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 990.94, ["Fly"] = 1185.55, ["Ride"] = 977.82, ["Fly|Ride"] = 1087.57, ["Neon|Ride"] = 3451.97, ["Neon|Fly|Ride"] = 3084.38, ["Mega|Fly|Ride"] = 13299.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 656.25, ["Ride"] = 808.5, ["Fly|Ride"] = 905.08, ["Neon|Fly|Ride"] = 4313.88, ["Mega|Fly|Ride"] = 20136.78}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.58, ["Fly"] = 26.24, ["Ride"] = 21.86, ["Fly|Ride"] = 50.72, ["Neon"] = 91.88, ["Neon|Ride"] = 114.79, ["Neon|Fly|Ride"] = 133.8, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 19.57, ["Ride"] = 43.29, ["Fly|Ride"] = 128.39, ["Neon"] = 144.58, ["Neon|Ride"] = 151.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 895.29, ["Mega|Ride"] = 1005.51, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Fly"] = 70.88, ["Ride"] = 36.69, ["Fly|Ride"] = 133.88, ["Neon"] = 24.61, ["Neon|Fly"] = 325.67, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 230.9, ["Mega"] = 157.5, ["Mega|Fly"] = 569.62, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.88, ["Fly"] = 55.12, ["Ride"] = 51.97, ["Fly|Ride"] = 129.94, ["Neon"] = 243.95, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 231.4, ["Mega|Ride"] = 1083.69, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.04, ["Ride"] = 131.25, ["Fly|Ride"] = 360.31, ["Neon"] = 426.57, ["Neon|Ride"] = 557.08, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 2874.38}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.11, ["Fly"] = 58.15, ["Ride"] = 43.22, ["Fly|Ride"] = 105, ["Neon"] = 107.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 192.04, ["Mega"] = 416.91, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.56, ["Fly"] = 64.32, ["Ride"] = 35.44, ["Fly|Ride"] = 78.09, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 241.68, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1141.87}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.33, ["Fly"] = 48.32, ["Ride"] = 16.85, ["Fly|Ride"] = 39.54, ["Neon"] = 25.9, ["Neon|Ride"] = 54.01, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 434.74, ["Mega|Ride"] = 487.9, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.8, ["Fly"] = 55.13, ["Ride"] = 36.74, ["Fly|Ride"] = 106.14, ["Neon"] = 50.87, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 205.31, ["Mega"] = 431.55, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 39.37, ["Fly"] = 72.18, ["Ride"] = 53.45, ["Fly|Ride"] = 100.8, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 275.3, ["Mega"] = 1480.76, ["Mega|Fly|Ride"] = 1074.93}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1428, ["Fly"] = 1410.93, ["Ride"] = 1406.99, ["Fly|Ride"] = 1397.82, ["Neon|Ride"] = 4878.9, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.73, ["Fly"] = 525, ["Ride"] = 479.07, ["Fly|Ride"] = 564.38, ["Neon|Ride"] = 3253.01, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15103.94}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 309.49, ["Ride"] = 345.54, ["Fly|Ride"] = 387.19, ["Neon"] = 1575, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7767.8}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.74}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 48.53, ["Ride"] = 57.73, ["Fly|Ride"] = 110.25, ["Neon"] = 323.64, ["Neon|Fly"] = 288.39, ["Neon|Ride"] = 180.16, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Ride"] = 1186.63, ["Mega|Fly|Ride"] = 970.98}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 90562.5, ["Ride"] = 37405.2, ["Fly|Ride"] = 16929.94, ["Neon|Fly|Ride"] = 28863.68, ["Mega"] = 215771.8, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 205.83, ["Fly"] = 284.82, ["Ride"] = 250.69, ["Fly|Ride"] = 275.63, ["Neon"] = 787.5, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 976.97, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6473.13, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 118.13, ["Fly"] = 525, ["Ride"] = 207.23, ["Fly|Ride"] = 262.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 120.74, ["Fly"] = 159.83, ["Ride"] = 111.57, ["Fly|Ride"] = 179.1, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 538.3, ["Mega|Fly|Ride"] = 3150.28}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.83, ["Fly"] = 64.75, ["Ride"] = 33.86, ["Fly|Ride"] = 59.07, ["Neon"] = 81.74, ["Neon|Ride"] = 155.36, ["Neon|Fly|Ride"] = 233.02, ["Mega"] = 728.97, ["Mega|Ride"] = 719.61, ["Mega|Fly|Ride"] = 878.11}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5031.24, ["Ride"] = 3937.5, ["Fly|Ride"] = 4200, ["Neon"] = 21574.72, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81254.55}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.09, ["Fly"] = 45.82, ["Ride"] = 33.63, ["Fly|Ride"] = 57.75, ["Neon"] = 131.25, ["Neon|Ride"] = 172.64, ["Neon|Fly|Ride"] = 182.68, ["Mega|Ride"] = 1439.05, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 33.68, ["Ride"] = 56.44, ["Fly|Ride"] = 85.32, ["Neon"] = 301.53, ["Neon|Fly"] = 258.95, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 317.63, ["Mega|Fly|Ride"] = 1439.05}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 415.79, ["Fly"] = 563.06, ["Ride"] = 468.24, ["Fly|Ride"] = 524.98, ["Neon"] = 1155, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Ride"] = 4315.45, ["Mega|Fly|Ride"] = 4302.54}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.28, ["Fly"] = 30.74, ["Ride"] = 24.85, ["Fly|Ride"] = 51.19, ["Neon"] = 72.19, ["Neon|Ride"] = 111.14, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 485.9}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.9, ["Fly"] = 288.08, ["Ride"] = 30.18, ["Fly|Ride"] = 487.54, ["Neon"] = 91.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.52, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 731.85}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.95, ["Ride"] = 122.07, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 662.43, ["Mega|Fly|Ride"] = 4065.35}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.26, ["Fly"] = 123, ["Ride"] = 72.19, ["Fly|Ride"] = 144.38, ["Neon"] = 90.83, ["Neon|Fly"] = 107.9, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 276.2, ["Mega"] = 365.71, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4305, ["Ride"] = 4095, ["Fly|Ride"] = 3937.5, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10500, ["Mega"] = 48909.02, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.12, ["Fly"] = 144.58, ["Ride"] = 50.43, ["Fly|Ride"] = 135.19, ["Neon"] = 233.62, ["Neon|Fly"] = 275.63, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 863.1, ["Mega|Ride"] = 1788.02, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7983.57, ["Ride"] = 6857.82, ["Fly|Ride"] = 6105.75, ["Neon"] = 22768.54, ["Neon|Fly|Ride"] = 15093.75, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.94, ["Fly"] = 24.36, ["Ride"] = 18.31, ["Fly|Ride"] = 36.75, ["Neon"] = 32.39, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 80.2, ["Mega"] = 210, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.34, ["Fly"] = 33.99, ["Ride"] = 32.81, ["Fly|Ride"] = 64.32, ["Neon"] = 187.71, ["Neon|Fly"] = 238.42, ["Neon|Ride"] = 141.33, ["Neon|Fly|Ride"] = 144.58, ["Mega|Ride"] = 1004.73, ["Mega|Fly|Ride"] = 863.02}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.72}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.82, ["Fly"] = 47.2, ["Ride"] = 28.88, ["Fly|Ride"] = 86.96, ["Neon"] = 78.75, ["Neon|Ride"] = 138.2, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 1049.9, ["Mega|Ride"] = 1149.94, ["Mega|Fly|Ride"] = 1125.27}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.83, ["Fly"] = 190.37, ["Ride"] = 44.29, ["Fly|Ride"] = 118.13, ["Neon"] = 144.57, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 863.02, ["Mega|Fly|Ride"] = 1061.18}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.88, ["Fly"] = 27.57, ["Ride"] = 21, ["Fly|Ride"] = 43.32, ["Neon"] = 94, ["Neon|Fly"] = 1075.53, ["Neon|Ride"] = 101.41, ["Neon|Fly|Ride"] = 122.58, ["Mega"] = 2588.99, ["Mega|Ride"] = 431.55, ["Mega|Fly|Ride"] = 625.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8621.27}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2899.79}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 194.85, ["Ride"] = 201.76, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1205.09}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.42, ["Fly"] = 97.54, ["Ride"] = 36.66, ["Fly|Ride"] = 138.11, ["Neon"] = 124.08, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 431.55, ["Mega|Ride"] = 2034.52, ["Mega|Fly|Ride"] = 533.93}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.33}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.03, ["Ride"] = 26.24, ["Fly|Ride"] = 86.31, ["Neon"] = 155.36, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2391.38}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 236.01, ["Fly"] = 431.51, ["Ride"] = 262.5, ["Fly|Ride"] = 731.85, ["Neon"] = 1139.23, ["Neon|Ride"] = 862.02, ["Neon|Fly|Ride"] = 1077.67, ["Mega|Ride"] = 4171.96, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 60.43, ["Fly"] = 474.13, ["Ride"] = 86.33, ["Fly|Ride"] = 243.81, ["Neon"] = 414.72, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 576.06, ["Mega|Fly|Ride"] = 1999.99}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 203.74, ["Fly"] = 261.03, ["Ride"] = 211.8, ["Fly|Ride"] = 285.29, ["Neon"] = 944.99, ["Neon|Ride"] = 819.86, ["Neon|Fly|Ride"] = 887.39, ["Mega|Fly|Ride"] = 3163.31}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2489.82, ["Fly"] = 3308.5, ["Ride"] = 2756.25, ["Fly|Ride"] = 2966.25, ["Neon"] = 15151.94, ["Neon|Ride"] = 9757.79, ["Neon|Fly|Ride"] = 8918.95, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.25, ["Fly"] = 105.73, ["Ride"] = 52.5, ["Fly|Ride"] = 112.22, ["Neon"] = 127.32, ["Neon|Ride"] = 130.45, ["Neon|Fly|Ride"] = 270.78, ["Mega"] = 969.81, ["Mega|Ride"] = 1007.67, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 682.5, ["Fly"] = 2100, ["Ride"] = 686.31, ["Fly|Ride"] = 755.22, ["Neon|Fly|Ride"] = 5392.63}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.98}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 18.36, ["Ride"] = 48.18, ["Fly|Ride"] = 203.44, ["Neon"] = 115.5, ["Neon|Ride"] = 137.01, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 444.94, ["Mega|Fly"] = 978.7, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.86, ["Fly"] = 41.87, ["Ride"] = 29.14, ["Fly|Ride"] = 131.25, ["Neon"] = 72.1, ["Neon|Ride"] = 100.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 456.19, ["Mega|Ride"] = 288.03, ["Mega|Fly|Ride"] = 288.08}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 49.87}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.43, ["Fly"] = 32.39, ["Ride"] = 26.14, ["Fly|Ride"] = 77.68, ["Neon|Ride"] = 232.99, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1223.31, ["Mega|Fly|Ride"] = 2157.48}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.18, ["Fly"] = 46.34, ["Ride"] = 32.47, ["Fly|Ride"] = 60.42, ["Neon|Fly"] = 238.44, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 286.96, ["Mega"] = 1439.21, ["Mega|Ride"] = 1828.23, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6742.88, ["Fly"] = 4921.88, ["Ride"] = 6613.95, ["Fly|Ride"] = 5197.49, ["Neon|Fly|Ride"] = 10762.5, ["Mega|Fly|Ride"] = 31044.55}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.43, ["Fly"] = 49.64, ["Ride"] = 32.82, ["Fly|Ride"] = 86.33, ["Neon"] = 56.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 232.99, ["Mega"] = 354.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 649.49}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 85.3, ["Fly"] = 381.89, ["Ride"] = 118.13, ["Fly|Ride"] = 203.96, ["Neon"] = 531.57, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 535.49, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 53.82, ["Fly"] = 190.93, ["Ride"] = 83.99, ["Fly|Ride"] = 171.23, ["Neon"] = 236.25, ["Neon|Fly"] = 390.32, ["Neon|Ride"] = 330.93, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2439.4, ["Mega|Ride"] = 1236.24, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.54, ["Fly"] = 82, ["Ride"] = 26.23, ["Fly|Ride"] = 65.58, ["Neon"] = 174.57, ["Neon|Fly"] = 233.02, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 1016.21, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.21, ["Fly"] = 30.19, ["Ride"] = 29.64, ["Fly|Ride"] = 72.19, ["Neon"] = 31.49, ["Neon|Fly"] = 86.33, ["Neon|Ride"] = 78.3, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 210, ["Mega|Fly"] = 7192.73, ["Mega|Ride"] = 227.68, ["Mega|Fly|Ride"] = 335.22}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.13, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 97.54, ["Neon"] = 79.75, ["Neon|Ride"] = 107.9, ["Neon|Fly|Ride"] = 216.11, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 538.31}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.07, ["Fly"] = 33.5, ["Ride"] = 28.27, ["Fly|Ride"] = 55.79, ["Neon"] = 278.25, ["Neon|Fly"] = 81.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 183.75}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.61, ["Ride"] = 140.27, ["Fly|Ride"] = 288.08, ["Neon"] = 169.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 794.49, ["Mega|Ride"] = 768.08, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 243.78, ["Ride"] = 1439.05, ["Fly|Ride"] = 431.55, ["Neon|Fly|Ride"] = 28766.67}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 53.82, ["Fly"] = 215.79, ["Ride"] = 89.24, ["Fly|Ride"] = 139.07, ["Neon"] = 210, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1153.69, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.98, ["Fly"] = 1246.88, ["Ride"] = 1050, ["Fly|Ride"] = 1010.96, ["Neon"] = 4695.94, ["Neon|Fly"] = 4695.94, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 10102.91}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 429.19, ["Fly"] = 719.54, ["Ride"] = 418.69, ["Fly|Ride"] = 536.52, ["Neon"] = 2861.25, ["Neon|Ride"] = 4314.96, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12944.85, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 56.15}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.92}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.19, ["Fly"] = 32.79, ["Ride"] = 24.94, ["Fly|Ride"] = 53.82, ["Neon"] = 72.31, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 129.48, ["Mega"] = 437.26, ["Mega|Ride"] = 719.54, ["Mega|Fly|Ride"] = 572.82}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 228.37, ["Fly"] = 339.86, ["Ride"] = 282.19, ["Fly|Ride"] = 344.75, ["Neon"] = 846.02, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 952.88, ["Mega|Fly|Ride"] = 2992.78}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.2}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 114.19, ["Ride"] = 177.91, ["Fly|Ride"] = 244.63, ["Neon"] = 525, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 584.06, ["Neon|Fly|Ride"] = 714, ["Mega"] = 2453.76, ["Mega|Ride"] = 2437.99, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 112.22, ["Fly"] = 288.03, ["Ride"] = 144.58, ["Fly|Ride"] = 262.5, ["Neon"] = 719.54, ["Neon|Ride"] = 431.55, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.28, ["Fly"] = 79.86, ["Ride"] = 25.38, ["Fly|Ride"] = 215.77, ["Neon"] = 33.38, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 258.91, ["Mega"] = 228.74, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.12, ["Fly"] = 51.44, ["Ride"] = 28.88, ["Fly|Ride"] = 72.19, ["Neon"] = 177.19, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 325.67, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.49, ["Fly"] = 102.36, ["Ride"] = 34.13, ["Fly|Ride"] = 118.13, ["Neon"] = 80.94, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.48, ["Fly"] = 172.61, ["Ride"] = 45.29, ["Fly|Ride"] = 163.37, ["Neon"] = 32.01, ["Neon|Fly"] = 102.82, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 200.68, ["Mega"] = 144.38, ["Mega|Ride"] = 167.22, ["Mega|Fly|Ride"] = 324.54}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Ride"] = 315, ["Fly|Ride"] = 341.25, ["Neon"] = 1439.22, ["Neon|Ride"] = 1400.25, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6588.61}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 91.88, ["Fly"] = 576.06, ["Ride"] = 114.71, ["Fly|Ride"] = 204.53, ["Neon"] = 362.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 514.48, ["Mega|Ride"] = 2015.32, ["Mega|Fly|Ride"] = 1985.09}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.63, ["Fly"] = 167.45, ["Ride"] = 78.66, ["Fly|Ride"] = 107.09, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1789.34, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.99, ["Fly"] = 127.32, ["Ride"] = 53.95, ["Fly|Ride"] = 288.08, ["Neon|Ride"] = 619.17, ["Neon|Fly|Ride"] = 292.58}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.28, ["Ride"] = 32.42, ["Fly|Ride"] = 58.47, ["Neon"] = 79.42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 775.37, ["Mega|Ride"] = 508.73, ["Mega|Fly|Ride"] = 503.84}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.74, ["Fly"] = 43.32, ["Ride"] = 22.31, ["Fly|Ride"] = 52.5, ["Neon"] = 19.17, ["Neon|Fly"] = 85.25, ["Neon|Ride"] = 39.72, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 131.25, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 282.72}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.37, ["Fly"] = 918.75, ["Ride"] = 913.5, ["Fly|Ride"] = 927.68, ["Neon"] = 3136.26, ["Neon|Fly"] = 3309.57, ["Neon|Fly|Ride"] = 2349.38, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 288.75, ["Fly"] = 328.13, ["Ride"] = 299.25, ["Fly|Ride"] = 339.98, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 10788.53, ["Mega|Fly|Ride"] = 5042.36}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 95.97, ["Fly"] = 172.61, ["Ride"] = 122.07, ["Fly|Ride"] = 175.55, ["Neon"] = 422.63, ["Neon|Ride"] = 409.86, ["Neon|Fly|Ride"] = 558.8, ["Mega"] = 1312.5, ["Mega|Ride"] = 1741.09, ["Mega|Fly|Ride"] = 1871.06}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 219.43, ["Fly"] = 283.5, ["Ride"] = 183.73, ["Fly|Ride"] = 240.28, ["Neon"] = 918.75, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10788.53, ["Mega|Fly|Ride"] = 4067.8}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21, ["Fly"] = 58.27, ["Ride"] = 33.74, ["Fly|Ride"] = 69.57, ["Neon"] = 169.32, ["Neon|Ride"] = 193.11, ["Neon|Fly|Ride"] = 213.68, ["Mega|Ride"] = 757.68, ["Mega|Fly|Ride"] = 961.24}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 203.44, ["Ride"] = 271.32, ["Fly|Ride"] = 380.63, ["Neon"] = 1050.53, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1204.39, ["Mega"] = 3235.52, ["Mega|Fly|Ride"] = 4228.8}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 84.93, ["Fly"] = 125.99, ["Ride"] = 71.22, ["Fly|Ride"] = 129.57, ["Neon|Fly|Ride"] = 863.1, ["Mega|Ride"] = 2302.29, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 3178.61, ["Ride"] = 2231.13, ["Fly|Ride"] = 2546.25, ["Neon|Ride"] = 11384.89, ["Neon|Fly|Ride"] = 7003.97, ["Mega"] = 51784.9, ["Mega|Fly|Ride"] = 29273.32}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.57, ["Fly"] = 72.23, ["Ride"] = 39.38, ["Fly|Ride"] = 108.93, ["Neon"] = 59.07, ["Neon|Fly"] = 173.02, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 202.42, ["Mega"] = 271.52, ["Mega|Ride"] = 296.7, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 45.83, ["Ride"] = 59.06, ["Fly|Ride"] = 149.63, ["Neon"] = 188.83, ["Neon|Ride"] = 224.35, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 883.58, ["Mega|Fly|Ride"] = 1255.56}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.42, ["Fly"] = 94.29, ["Ride"] = 85.3, ["Fly|Ride"] = 89.25, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1627.08, ["Ride"] = 1069.69, ["Fly|Ride"] = 997.49, ["Neon|Ride"] = 5692.45, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 36965.06, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 425.25, ["Fly"] = 860.85, ["Ride"] = 755.13, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 118.13, ["Ride"] = 114.99, ["Fly|Ride"] = 183.75, ["Neon"] = 393.75, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 475.79, ["Mega"] = 2164.77, ["Mega|Ride"] = 2602.89, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.18, ["Fly"] = 32.82, ["Ride"] = 21.81, ["Fly|Ride"] = 63.25, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 133.58, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 36.75, ["Fly"] = 68.25, ["Ride"] = 51.19, ["Fly|Ride"] = 84.62, ["Neon"] = 161.83, ["Neon|Fly"] = 360.35, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 720.57, ["Fly"] = 1122.13, ["Ride"] = 891.16, ["Fly|Ride"] = 829.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 636.67}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5906.25, ["Fly|Ride"] = 4593.75, ["Neon"] = 42000, ["Neon|Ride"] = 30917.66, ["Neon|Fly|Ride"] = 27342, ["Mega|Fly|Ride"] = 107873.59}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 236.25, ["Fly"] = 404.55, ["Ride"] = 343.05, ["Fly|Ride"] = 424.48, ["Neon"] = 1312.5, ["Neon|Fly|Ride"] = 2157.71, ["Mega"] = 6471.35, ["Mega|Fly|Ride"] = 6472.43}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 98.12, ["Ride"] = 157.39, ["Fly|Ride"] = 288.03, ["Neon"] = 1324.11, ["Neon|Ride"] = 576.06, ["Neon|Fly|Ride"] = 473.82}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.53, ["Fly"] = 72.31, ["Ride"] = 40.05, ["Fly|Ride"] = 78.75, ["Neon"] = 141.75, ["Neon|Ride"] = 129.48, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 863.02, ["Mega|Fly|Ride"] = 787.58}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.44, ["Fly"] = 28.87, ["Ride"] = 25.86, ["Fly|Ride"] = 51.19, ["Neon"] = 146.5, ["Neon|Ride"] = 75.54, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1078.88}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.09, ["Ride"] = 38.03, ["Fly|Ride"] = 103.8, ["Neon"] = 124.69, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 640.86}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.15, ["Fly"] = 29.14, ["Ride"] = 22.31, ["Fly|Ride"] = 48.78, ["Neon"] = 37.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 256.99}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 17.07, ["Ride"] = 50.85, ["Fly|Ride"] = 144.38, ["Neon"] = 158.17, ["Neon|Fly"] = 863.02, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 322.55, ["Mega"] = 630, ["Mega|Ride"] = 719.61}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 536.82, ["Fly"] = 538.13, ["Ride"] = 576.14, ["Fly|Ride"] = 603.75, ["Neon"] = 1909.5, ["Neon|Ride"] = 1837.03, ["Neon|Fly|Ride"] = 1614.38, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.68, ["Fly"] = 19.69, ["Ride"] = 17.05, ["Fly|Ride"] = 38.07, ["Neon"] = 22.25, ["Neon|Ride"] = 37.79, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 170.63, ["Mega|Ride"] = 203.58, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 41.3, ["Fly"] = 118.1, ["Ride"] = 81.32, ["Fly|Ride"] = 148.3, ["Neon"] = 196.86, ["Neon|Fly"] = 360.35, ["Neon|Ride"] = 223.59, ["Neon|Fly|Ride"] = 270.37, ["Mega"] = 564.37, ["Mega|Fly"] = 863.02, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.25, ["Ride"] = 780.94, ["Fly|Ride"] = 788.82, ["Neon|Ride"] = 2113.74, ["Neon|Fly|Ride"] = 1732.5, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.24, ["Fly"] = 70.86, ["Ride"] = 48.2, ["Fly|Ride"] = 94.5, ["Neon"] = 262.5, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 252, ["Mega"] = 1219.72, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 318.88, ["Fly"] = 356.87, ["Ride"] = 253.18, ["Fly|Ride"] = 314.99, ["Neon"] = 1618.3, ["Neon|Ride"] = 1401.46, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4552.94}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 252.14, ["Fly"] = 330.75, ["Ride"] = 249.36, ["Fly|Ride"] = 356.9, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5107.34, ["Mega|Fly|Ride"] = 4588.96}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 752.17, ["Ride"] = 698.15, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3597.6, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.28, ["Fly"] = 62.6, ["Ride"] = 47.25, ["Fly|Ride"] = 107.47, ["Neon"] = 48.57, ["Neon|Fly"] = 292.74, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 164.8, ["Mega"] = 321.59, ["Mega|Ride"] = 343.09, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3281.25, ["Fly"] = 3543.75, ["Ride"] = 3346.88, ["Fly|Ride"] = 3215.63, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 18965.63}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 147, ["Fly"] = 146.39, ["Ride"] = 163.74, ["Fly|Ride"] = 215.79, ["Neon"] = 535.5, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 3128.7, ["Mega|Fly|Ride"] = 3229.74}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.84, ["Fly"] = 21.59, ["Ride"] = 19.68, ["Fly|Ride"] = 43.32, ["Neon"] = 22.32, ["Neon|Fly"] = 99.74, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 97.54, ["Mega"] = 145.68, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 201.76, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 27.98, ["Fly|Ride"] = 69.16, ["Neon"] = 29.14, ["Neon|Fly"] = 119.55, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 280.49, ["Mega|Fly|Ride"] = 324.84}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 44.84, ["Fly"] = 42, ["Ride"] = 42, ["Fly|Ride"] = 64.75, ["Neon"] = 292.74, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1236.39}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 896.55, ["Fly"] = 1170.94, ["Ride"] = 918.73, ["Fly|Ride"] = 1038.19, ["Neon"] = 4294.88, ["Neon|Ride"] = 4552.94, ["Neon|Fly|Ride"] = 4799.62}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["Ride"] = 8630.89, ["Fly|Ride"] = 10434.38}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.12, ["Fly"] = 27.57, ["Ride"] = 23.15, ["Fly|Ride"] = 59.07, ["Neon"] = 452.13, ["Neon|Ride"] = 120.3, ["Neon|Fly|Ride"] = 129.48, ["Mega"] = 2520, ["Mega|Ride"] = 862.36, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.14, ["Fly"] = 35.44, ["Ride"] = 30.19, ["Fly|Ride"] = 77.96, ["Neon"] = 102.38, ["Neon|Fly"] = 90.7, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 164.27, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 104.98, ["Ride"] = 101.59, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 430.5, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 210, ["Fly"] = 236.25, ["Ride"] = 236.23, ["Fly|Ride"] = 314.78, ["Neon"] = 1286.25, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1029, ["Mega"] = 10787.37, ["Mega|Fly|Ride"] = 4255.04}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.56, ["Ride"] = 34.54, ["Fly|Ride"] = 72.19, ["Neon"] = 26.24, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 70.88, ["Mega"] = 136.5, ["Mega|Fly"] = 240.57, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 190.31, ["Fly"] = 257.25, ["Ride"] = 208.37, ["Fly|Ride"] = 291.38, ["Neon"] = 654.94, ["Neon|Fly"] = 828.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 780.94, ["Mega|Fly|Ride"] = 3072.01}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.64, ["Fly"] = 25.1, ["Ride"] = 17.28, ["Fly|Ride"] = 48.78, ["Neon"] = 26.25, ["Neon|Fly"] = 129.47, ["Neon|Ride"] = 43.91, ["Neon|Fly|Ride"] = 124.07, ["Mega"] = 183.75, ["Mega|Fly"] = 187.74, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 262.5, ["Fly"] = 269.42, ["Ride"] = 336, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1340.91, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 10788.53, ["Mega|Fly|Ride"] = 4875.97}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.81, ["Fly"] = 104.98, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 309.82, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 576.13, ["Mega|Ride"] = 444.46, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.13, ["Ride"] = 24.94, ["Neon"] = 9.77, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 82.15, ["Mega|Ride"] = 136.14, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 21.91, ["Mega|Ride"] = 144.58, ["Mega|Fly|Ride"] = 137.44}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.61, ["Ride"] = 73.16, ["Fly|Ride"] = 115.43, ["Neon"] = 8.37, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 62.05, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 83.85, ["Mega|Fly|Ride"] = 256.4}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.55, ["Fly"] = 163.68, ["Ride"] = 99.75, ["Fly|Ride"] = 146.57, ["Neon"] = 281.54, ["Neon|Ride"] = 295.84, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1617.23}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.84, ["Ride"] = 17.07, ["Fly|Ride"] = 83.47, ["Neon"] = 11.68, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 82.01, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.53, ["Fly"] = 26.25, ["Ride"] = 73.49, ["Neon"] = 82.27, ["Neon|Fly"] = 325.68, ["Neon|Ride"] = 212.12, ["Neon|Fly|Ride"] = 360.31, ["Mega"] = 392.44, ["Mega|Ride"] = 573.9, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.51, ["Neon"] = 2.63, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 198.52, ["Mega"] = 19.69, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.53, ["Ride"] = 11.82, ["Fly|Ride"] = 49.64, ["Neon"] = 2.1, ["Neon|Fly"] = 40.68, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 13.11, ["Mega|Fly"] = 36.17, ["Mega|Ride"] = 19.08, ["Mega|Fly|Ride"] = 49.64}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 16.06, ["Fly|Ride"] = 80.94, ["Neon"] = 2.1, ["Neon|Fly"] = 23.69, ["Neon|Ride"] = 17.26, ["Neon|Fly|Ride"] = 36.18, ["Mega"] = 18.35, ["Mega|Fly"] = 163.47, ["Mega|Ride"] = 32.4, ["Mega|Fly|Ride"] = 91.68}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 18.25, ["Mega|Ride"] = 108.94}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 32.39, ["Ride"] = 21, ["Fly|Ride"] = 56.44, ["Neon"] = 4.7, ["Neon|Fly"] = 122.99, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 41.5, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 144.57}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 87.26, ["Neon|Fly|Ride"] = 431.51, ["Mega"] = 20.9, ["Mega|Ride"] = 83.16, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.93, ["Fly"] = 72.31, ["Ride"] = 65.63, ["Fly|Ride"] = 163.37, ["Neon"] = 45.44, ["Neon|Fly"] = 144.58, ["Neon|Ride"] = 88.53, ["Neon|Fly|Ride"] = 173.53, ["Mega"] = 218.64, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 324.71}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 26.83, ["Neon|Fly|Ride"] = 327.28, ["Mega"] = 18.38, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 137.04, ["Mega|Fly|Ride"] = 195.05}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.6, ["Fly"] = 65.63, ["Ride"] = 145.66, ["Fly|Ride"] = 144.57, ["Neon"] = 23.61, ["Mega"] = 111.57, ["Mega|Fly"] = 315, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 22.96, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.57, ["Ride"] = 32.81, ["Neon"] = 3.63, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 22.29, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 97.54}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.55, ["Ride"] = 16.21, ["Fly|Ride"] = 40.27, ["Neon"] = 2.1, ["Neon|Fly"] = 35.21, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 13.13, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 51.69}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.88, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 37.8, ["Neon|Ride"] = 140.25, ["Mega"] = 201.76, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Neon"] = 3.26, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.23, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.63, ["Neon"] = 16.99, ["Neon|Ride"] = 195.11, ["Mega"] = 84.44, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.24, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Ride"] = 50.72, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.59, ["Ride"] = 11.81, ["Fly|Ride"] = 34.53, ["Neon"] = 2.1, ["Neon|Fly"] = 12.99, ["Neon|Ride"] = 13.42, ["Neon|Fly|Ride"] = 32.4, ["Mega"] = 13.13, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 21.65, ["Mega|Fly|Ride"] = 47.9}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 24.4, ["Fly|Ride"] = 93.19, ["Neon"] = 77.24, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 315, ["Mega|Ride"] = 297.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 14.42, ["Fly|Ride"] = 41.62, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 14.96, ["Neon|Fly|Ride"] = 50.15, ["Mega"] = 23.63, ["Mega|Fly"] = 50.71, ["Mega|Ride"] = 36.02, ["Mega|Fly|Ride"] = 84.07}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 180.16, ["Ride"] = 45.92, ["Neon"] = 7.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 163.47, ["Mega"] = 47.25, ["Mega|Fly"] = 163.47, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.77, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 32.62, ["Mega|Fly"] = 115.76, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 19.6, ["Neon"] = 2.1, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 107.89, ["Mega"] = 13.13, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 70.8, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.75, ["Ride"] = 19.69, ["Fly|Ride"] = 55.41, ["Neon"] = 6.57, ["Neon|Fly"] = 58.27, ["Neon|Ride"] = 43.74, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 105.23, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 24.42, ["Neon"] = 4.98, ["Neon|Ride"] = 43.17, ["Mega"] = 43.17, ["Mega|Fly"] = 215.79, ["Mega|Ride"] = 115.39, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 18.24, ["Fly|Ride"] = 40.68, ["Neon"] = 6.37, ["Neon|Fly"] = 81.69, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.19, ["Mega|Fly"] = 115.77, ["Mega|Ride"] = 101.41, ["Mega|Fly|Ride"] = 199.37}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 16.21, ["Neon|Fly"] = 188.88, ["Neon|Ride"] = 25.94, ["Neon|Fly|Ride"] = 323.64, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 21.44, ["Fly|Ride"] = 47.49, ["Neon"] = 6.38, ["Neon|Fly"] = 48.81, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 137.04, ["Mega|Fly"] = 420, ["Mega|Ride"] = 101.54, ["Mega|Fly|Ride"] = 183.29}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.37, ["Fly"] = 14.33, ["Ride"] = 23.63, ["Fly|Ride"] = 64.75, ["Neon"] = 13.01, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 28.68, ["Neon|Fly|Ride"] = 55.3, ["Mega"] = 211.45, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 135.36, ["Mega|Fly|Ride"] = 231.14}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.37, ["Neon"] = 21.59, ["Neon|Ride"] = 108.02, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 323.67}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.57, ["Ride"] = 65.63, ["Neon"] = 93.86, ["Neon|Ride"] = 170.63, ["Mega"] = 672.14, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 975.79}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 42, ["Neon"] = 56.43, ["Neon|Ride"] = 115.43, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 223.13, ["Mega|Ride"] = 258.95}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 9.91, ["Ride"] = 62.99, ["Fly|Ride"] = 104.99, ["Neon"] = 52.42, ["Neon|Ride"] = 74.4, ["Neon|Fly|Ride"] = 127.29, ["Mega"] = 225.68, ["Mega|Ride"] = 429.35, ["Mega|Fly|Ride"] = 343.88}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.88, ["Mega"] = 15.75, ["Mega|Fly"] = 144.58, ["Mega|Ride"] = 129.47, ["Mega|Fly|Ride"] = 243.02}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 9.19, ["Fly"] = 23.39, ["Ride"] = 23.62, ["Fly|Ride"] = 47.25, ["Neon"] = 42, ["Neon|Fly"] = 187.7, ["Neon|Ride"] = 48.61, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 459.56, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 252.48}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.5, ["Neon"] = 5.04, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 22.32, ["Mega|Fly"] = 144.57, ["Mega|Ride"] = 56.13, ["Mega|Fly|Ride"] = 129.54}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 5.25, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 74.42, ["Mega"] = 34, ["Mega|Ride"] = 59.63, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.19, ["Ride"] = 14.96, ["Fly|Ride"] = 45.27, ["Neon"] = 9.55, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 71.08, ["Mega"] = 161.83, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 160.29}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.48, ["Fly"] = 56.11, ["Ride"] = 32.8, ["Fly|Ride"] = 112.88, ["Neon"] = 47.6, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 328.13, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 345.21}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.9, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 102.51, ["Mega"] = 18.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.74, ["Mega|Fly|Ride"] = 161.84}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.81, ["Ride"] = 17.17, ["Fly|Ride"] = 59.07, ["Neon"] = 5.07, ["Neon|Fly"] = 114.68, ["Neon|Ride"] = 17.28, ["Neon|Fly|Ride"] = 94.02, ["Mega"] = 35.44, ["Mega|Fly"] = 144.57, ["Mega|Ride"] = 50.94, ["Mega|Fly|Ride"] = 133.8}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.29, ["Fly|Ride"] = 35.21, ["Neon"] = 5.83, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 19.53, ["Neon|Fly|Ride"] = 61.53, ["Mega"] = 85.23, ["Mega|Fly"] = 144.57, ["Mega|Ride"] = 121.9, ["Mega|Fly|Ride"] = 119.77}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.85, ["Fly"] = 91.88, ["Ride"] = 48.81, ["Fly|Ride"] = 131.25, ["Neon"] = 11.2, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 78.75, ["Mega|Ride"] = 150.57, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 105.68, ["Neon|Fly|Ride"] = 156981.76, ["Mega"] = 18.38, ["Mega|Fly"] = 125.89, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 19.94, ["Fly|Ride"] = 51.19, ["Neon"] = 3.88, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.4, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 19.15, ["Mega|Fly"] = 57.3, ["Mega|Ride"] = 38.09, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 15.75, ["Mega|Ride"] = 129.48}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.22, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.31, ["Mega|Ride"] = 206.08, ["Mega|Fly|Ride"] = 144.57}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Fly|Ride"] = 69.57, ["Neon"] = 6.57, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 18.01, ["Neon|Fly|Ride"] = 48.39, ["Mega"] = 38.07, ["Mega|Ride"] = 50.72, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.29, ["Ride"] = 78.75, ["Fly|Ride"] = 215.79, ["Neon"] = 77.33, ["Neon|Ride"] = 78.75, ["Mega"] = 361.82, ["Mega|Ride"] = 483.3, ["Mega|Fly|Ride"] = 576.74}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 28.87, ["Neon"] = 10.5, ["Neon|Ride"] = 157.5, ["Mega"] = 216.49, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.7, ["Ride"] = 32.63, ["Fly|Ride"] = 131.25, ["Neon"] = 24.43, ["Neon|Ride"] = 144.57, ["Neon|Fly|Ride"] = 274.04, ["Mega"] = 232.31, ["Mega|Ride"] = 288.03, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.21, ["Ride"] = 12.75, ["Fly|Ride"] = 25.26, ["Neon"] = 2.1, ["Neon|Fly"] = 10.5, ["Neon|Ride"] = 12.89, ["Neon|Fly|Ride"] = 33.46, ["Mega"] = 14.14, ["Mega|Fly"] = 105, ["Mega|Ride"] = 22.3, ["Mega|Fly|Ride"] = 52.91}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.42, ["Neon"] = 10.18, ["Neon|Fly"] = 68.59, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 719.54, ["Mega"] = 118.13, ["Mega|Ride"] = 144.57, ["Mega|Fly|Ride"] = 130.45}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.31, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.41, ["Mega|Fly"] = 144.57, ["Mega|Fly|Ride"] = 188.83}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 24.94, ["Mega|Fly"] = 215.79, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.56, ["Ride"] = 20.01, ["Fly|Ride"] = 44.35, ["Neon"] = 10.34, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 79.14, ["Mega"] = 168, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 243.81}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 209.89, ["Ride"] = 210, ["Fly|Ride"] = 863.09, ["Neon|Ride"] = 926.99, ["Neon|Fly|Ride"] = 950.18, ["Mega"] = 8630.84, ["Mega|Fly|Ride"] = 3262.1}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 7.53, ["Neon|Ride"] = 64.31, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.68, ["Ride"] = 24.44, ["Fly|Ride"] = 65.63, ["Neon"] = 28.06, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 172.61, ["Mega"] = 387.19, ["Mega|Ride"] = 227.96, ["Mega|Fly|Ride"] = 302.07}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.53, ["Fly|Ride"] = 32.7, ["Neon"] = 4.13, ["Neon|Fly"] = 33.46, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 49.68, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 84.17, ["Mega|Fly|Ride"] = 144.57}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.31, ["Ride"] = 19.69, ["Fly|Ride"] = 142.62, ["Neon"] = 7.88, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 85.2, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.6, ["Fly"] = 27.11, ["Ride"] = 16.95, ["Fly|Ride"] = 43.91, ["Neon"] = 10.81, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 288.08, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.17, ["Fly"] = 21, ["Ride"] = 34.51, ["Fly|Ride"] = 117.04, ["Neon"] = 50.67, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 257.27, ["Mega|Ride"] = 318.26, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.94, ["Fly"] = 23.87, ["Ride"] = 16.87, ["Fly|Ride"] = 32.54, ["Neon"] = 32.82, ["Neon|Fly"] = 71.22, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.12, ["Mega"] = 262.5, ["Mega|Ride"] = 374.33, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.19, ["Ride"] = 94.5, ["Fly|Ride"] = 149.41, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 353.81, ["Neon|Fly|Ride"] = 365.97, ["Mega"] = 2015.32, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 248.07, ["Fly"] = 431.51, ["Ride"] = 245.82, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1296.49, ["Mega|Fly|Ride"] = 3235.52}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.06, ["Fly"] = 109.51, ["Ride"] = 64.02, ["Fly|Ride"] = 113.53, ["Neon"] = 487.61, ["Neon|Fly"] = 365.71, ["Neon|Ride"] = 296.7, ["Neon|Fly|Ride"] = 366.82, ["Mega|Ride"] = 1294.64, ["Mega|Fly|Ride"] = 1409.01}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.99, ["Fly"] = 288.3, ["Ride"] = 28.88, ["Fly|Ride"] = 78.21, ["Neon"] = 16.21, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Neon|Fly|Ride"] = 214.93, ["Mega"] = 262.5, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 325.68}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.51, ["Ride"] = 30.03, ["Fly|Ride"] = 65.63, ["Neon"] = 65.61, ["Neon|Ride"] = 89.83, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 301.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 34.89, ["Ride"] = 17.07, ["Fly|Ride"] = 50.71, ["Neon"] = 3.93, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 58.95, ["Mega"] = 36.75, ["Mega|Fly"] = 148.82, ["Mega|Ride"] = 80.88, ["Mega|Fly|Ride"] = 553.77}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.28, ["Fly"] = 69.06, ["Ride"] = 32.76, ["Fly|Ride"] = 65.81, ["Neon"] = 106.81, ["Neon|Fly"] = 288.03, ["Neon|Ride"] = 72.31, ["Neon|Fly|Ride"] = 260.11, ["Mega"] = 517.81, ["Mega|Ride"] = 553.77, ["Mega|Fly|Ride"] = 604.11}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 16.17, ["Fly|Ride"] = 45.92, ["Neon"] = 18.25, ["Neon|Fly"] = 51.8, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 86.64, ["Mega"] = 144.22, ["Mega|Ride"] = 103.68, ["Mega|Fly|Ride"] = 291.06}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.76, ["Fly"] = 38.85, ["Ride"] = 20.53, ["Fly|Ride"] = 328.13, ["Neon"] = 19.68, ["Neon|Ride"] = 114.6, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 230.9, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.09, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 14.8, ["Mega|Ride"] = 43.17, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.82, ["Ride"] = 22.32, ["Fly|Ride"] = 41.65, ["Neon"] = 14.42, ["Neon|Fly"] = 107.89, ["Neon|Ride"] = 33.56, ["Neon|Fly|Ride"] = 139.07, ["Mega"] = 78.72, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 214.6}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 57.1, ["Ride"] = 22.28, ["Fly|Ride"] = 71.12, ["Neon"] = 22.74, ["Neon|Ride"] = 47.25, ["Mega"] = 143.07, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 267.54}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105, ["Fly"] = 179.1, ["Ride"] = 144.37, ["Fly|Ride"] = 199.5, ["Neon"] = 430.39, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 567, ["Mega"] = 2437.64, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.65, ["Ride"] = 240.57, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.24, ["Ride"] = 17.07, ["Fly|Ride"] = 57.88, ["Neon"] = 32.82, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 123.55, ["Mega"] = 221.82, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.46, ["Ride"] = 32.82, ["Fly|Ride"] = 160.61, ["Neon"] = 98.44, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 510.12, ["Mega|Fly"] = 863.02, ["Mega|Ride"] = 754.15, ["Mega|Fly|Ride"] = 863.1}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 7.32}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 88.49, ["Fly|Ride"] = 128.39, ["Neon"] = 40.69, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 472.5, ["Mega|Ride"] = 597.63, ["Mega|Fly|Ride"] = 863.02}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.36, ["Fly"] = 33.38, ["Ride"] = 27.9, ["Fly|Ride"] = 45.92, ["Neon"] = 90.57, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 141.5, ["Neon|Fly|Ride"] = 150.9, ["Mega"] = 1392.67, ["Mega|Fly|Ride"] = 648.02}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 44.59, ["Neon|Fly|Ride"] = 137.04, ["Mega"] = 24.86, ["Mega|Fly"] = 189, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 232.83}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.6, ["Fly"] = 26.21, ["Ride"] = 21.25, ["Fly|Ride"] = 65.54, ["Neon"] = 64.75, ["Mega"] = 288.03, ["Mega|Fly"] = 407.4, ["Mega|Ride"] = 325.79, ["Mega|Fly|Ride"] = 517.81}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 20.51, ["Fly|Ride"] = 48.57, ["Neon"] = 15.88, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 183.75, ["Mega|Ride"] = 188.09, ["Mega|Fly|Ride"] = 234.93}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 39.38, ["Fly|Ride"] = 80.94, ["Neon"] = 3.63, ["Neon|Fly"] = 274.05, ["Neon|Ride"] = 29.14, ["Mega"] = 45.85, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 227.96}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.08, ["Fly"] = 90.96, ["Ride"] = 86.61, ["Fly|Ride"] = 98.76, ["Neon"] = 144.68, ["Neon|Ride"] = 163.87, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 835.06, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 15.74, ["Ride"] = 43.17, ["Fly|Ride"] = 210, ["Neon"] = 79.9, ["Neon|Ride"] = 42.7, ["Mega|Ride"] = 323.64}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 9.78, ["Fly"] = 24.57, ["Ride"] = 21.48, ["Fly|Ride"] = 65.63, ["Neon"] = 16.2, ["Neon|Fly"] = 86.31, ["Neon|Ride"] = 30.53, ["Neon|Fly|Ride"] = 103.58, ["Mega"] = 196.88, ["Mega|Ride"] = 139.16, ["Mega|Fly|Ride"] = 322.6}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.32, ["Fly"] = 145.01, ["Ride"] = 127.31, ["Neon"] = 319.37, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4555.68, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 3491.25}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 8.64, ["Fly"] = 46.4, ["Ride"] = 24.93, ["Fly|Ride"] = 53.34, ["Neon"] = 29.25, ["Neon|Ride"] = 47.48, ["Neon|Fly|Ride"] = 122.2, ["Mega"] = 254.52, ["Mega|Ride"] = 218.5, ["Mega|Fly|Ride"] = 368.37}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.81, ["Fly"] = 131.24, ["Ride"] = 118.1, ["Fly|Ride"] = 209.99, ["Neon"] = 245.03, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 373, ["Mega"] = 1019.82, ["Mega|Ride"] = 1073.94, ["Mega|Fly|Ride"] = 938.43}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.68, ["Ride"] = 66.9, ["Fly|Ride"] = 165.74, ["Neon"] = 81.86, ["Neon|Ride"] = 88.4, ["Neon|Fly|Ride"] = 212.65, ["Mega"] = 339.13, ["Mega|Ride"] = 345.02, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 19.24, ["Fly"] = 39.38, ["Ride"] = 25.91, ["Fly|Ride"] = 72.43, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 387.89, ["Mega"] = 569.62, ["Mega|Ride"] = 573.9, ["Mega|Fly|Ride"] = 633.32}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.43, ["Ride"] = 48.57, ["Fly|Ride"] = 83.15, ["Neon"] = 58.52, ["Neon|Ride"] = 86.61, ["Neon|Fly|Ride"] = 249.73, ["Mega"] = 256.15, ["Mega|Fly"] = 525.41, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 424.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 10.5, ["Ride"] = 30.17, ["Fly|Ride"] = 196.88, ["Neon"] = 38.68, ["Neon|Ride"] = 71.98, ["Neon|Fly|Ride"] = 142.15, ["Mega"] = 265.02, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 437.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 36.69, ["Neon"] = 2.63, ["Neon|Fly"] = 101.41, ["Neon|Ride"] = 179.1, ["Mega"] = 19.43, ["Mega|Ride"] = 144.57, ["Mega|Fly|Ride"] = 576.14}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.25, ["Ride"] = 141.74, ["Fly|Ride"] = 325.9, ["Neon"] = 39.37, ["Neon|Ride"] = 207.13, ["Neon|Fly|Ride"] = 201.54, ["Mega"] = 237.44, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 733.56}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.4, ["Ride"] = 29.14, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 211.98, ["Mega|Ride"] = 326.65, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.27, ["Ride"] = 32.8, ["Neon"] = 15.24, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 129.61, ["Mega|Ride"] = 288.03, ["Mega|Fly|Ride"] = 517.13}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 491.68, ["Fly"] = 705.58, ["Ride"] = 590.63, ["Fly|Ride"] = 630, ["Neon"] = 1872.7, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1706.15, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.52, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 59.87, ["Neon"] = 42.09, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 331.53, ["Mega"] = 201.73, ["Mega|Ride"] = 374.25, ["Mega|Fly|Ride"] = 358.2}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 15.75, ["Fly"] = 66.94, ["Ride"] = 20.95, ["Fly|Ride"] = 51.39, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.54, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 331.87, ["Mega|Ride"] = 253.55, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 5.92, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 50.79, ["Neon"] = 16.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 258.91}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 23.34, ["Fly|Ride"] = 90.57, ["Neon"] = 10.4, ["Neon|Ride"] = 38.87, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 74.82, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 232.84}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 24.05, ["Fly|Ride"] = 64.75, ["Neon"] = 3.52, ["Neon|Ride"] = 31.67, ["Neon|Fly|Ride"] = 129.48, ["Mega"] = 23.6, ["Mega|Ride"] = 107.89, ["Mega|Fly|Ride"] = 230.86}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.12}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.95, ["Ride"] = 43.17, ["Fly|Ride"] = 129.48, ["Neon"] = 70.25, ["Neon|Ride"] = 107.28, ["Neon|Fly|Ride"] = 359.83, ["Mega"] = 295.32, ["Mega|Ride"] = 414.72, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 6.02, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 127.65, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.62, ["Fly"] = 328.47, ["Ride"] = 91.88, ["Fly|Ride"] = 58.27, ["Neon"] = 58.47, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Fly"] = 538.36, ["Mega|Ride"] = 356, ["Mega|Fly|Ride"] = 487.9}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 391.13, ["Ride"] = 446.24, ["Fly|Ride"] = 522.38, ["Neon"] = 1683.23, ["Neon|Ride"] = 1700.3, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8090.54, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.3, ["Fly"] = 196.88, ["Ride"] = 31.5, ["Fly|Ride"] = 129.47, ["Neon"] = 71.54, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 195.17, ["Mega"] = 306.57, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 517.88}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.1, ["Ride"] = 28.95, ["Fly|Ride"] = 118.12, ["Neon"] = 5.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 81.8, ["Mega"] = 35.56, ["Mega|Fly"] = 144.58, ["Mega|Ride"] = 72.54, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.67, ["Neon|Ride"] = 143, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 34.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 431.54}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 28.88, ["Fly"] = 107.89, ["Ride"] = 92.79, ["Fly|Ride"] = 144.57, ["Neon"] = 128.64, ["Neon|Ride"] = 430.43, ["Neon|Fly|Ride"] = 360.31, ["Mega"] = 705.58, ["Mega|Ride"] = 590.15, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 12.03, ["Neon"] = 58.33, ["Neon|Ride"] = 270.78, ["Neon|Fly|Ride"] = 863.02, ["Mega"] = 569.62, ["Mega|Ride"] = 715.98, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.29, ["Ride"] = 43.17, ["Neon"] = 120.75, ["Neon|Ride"] = 172.61, ["Mega"] = 431.55, ["Mega|Fly|Ride"] = 1243.4}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 14, ["Ride"] = 56.35, ["Fly|Ride"] = 236.25, ["Neon"] = 131.25, ["Neon|Ride"] = 173.95, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.13, ["Mega|Ride"] = 791.9, ["Mega|Fly|Ride"] = 620.37}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 413.44, ["Ride"] = 427.33, ["Fly|Ride"] = 733.56, ["Neon"] = 1069.69, ["Neon|Ride"] = 1266.59, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 11.79, ["Fly"] = 43.17, ["Ride"] = 34.13, ["Fly|Ride"] = 132.71, ["Neon"] = 148.32, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 145.4, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 562.42, ["Mega|Fly|Ride"] = 863.02}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.72, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 78.75, ["Neon|Ride"] = 144.57, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 34.89, ["Fly"] = 345.24, ["Ride"] = 99.75, ["Fly|Ride"] = 307.13, ["Neon"] = 157.5, ["Neon|Ride"] = 227.96, ["Neon|Fly|Ride"] = 539.4, ["Mega"] = 380.63, ["Mega|Fly"] = 431.55, ["Mega|Ride"] = 448.21, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 31.5, ["Fly|Ride"] = 215.79, ["Neon"] = 7.88, ["Neon|Fly"] = 84.3, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 279.41, ["Mega"] = 61.5, ["Mega|Fly"] = 144.58, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.05, ["Ride"] = 85.25, ["Neon"] = 260.88, ["Neon|Ride"] = 325.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1646.65, ["Mega|Ride"] = 1584.42, ["Mega|Fly|Ride"] = 1138.55}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 77.68, ["Ride"] = 28.54, ["Neon"] = 8.86, ["Neon|Fly"] = 187.71, ["Neon|Ride"] = 36.59, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 67.57, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 28.88, ["Fly|Ride"] = 99.98, ["Neon"] = 3.67, ["Neon|Fly"] = 58.27, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 137.04, ["Mega"] = 28.14, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 77.13, ["Mega|Fly|Ride"] = 195.05}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Fly|Ride"] = 130.53, ["Neon"] = 10.63, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 79.26, ["Mega|Ride"] = 117.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 53.65, ["Ride"] = 63.49, ["Fly|Ride"] = 248.07, ["Neon"] = 265.41, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 509.18, ["Mega|Ride"] = 1151.03, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Neon"] = 22.32, ["Neon|Fly"] = 350.44, ["Mega"] = 140.44}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.24, ["Fly|Ride"] = 78.75, ["Neon"] = 6.57, ["Neon|Ride"] = 72.29, ["Mega"] = 52.49, ["Mega|Fly"] = 210, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 107.89, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Mega"] = 334.04, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.58, ["Fly"] = 78.75, ["Ride"] = 47.23, ["Fly|Ride"] = 101.07, ["Neon"] = 17.93, ["Neon|Ride"] = 99.57, ["Mega"] = 167.91, ["Mega|Ride"] = 208.42, ["Mega|Fly|Ride"] = 359.12}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 5.9, ["Neon|Ride"] = 93.86, ["Neon|Fly|Ride"] = 144.58, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 309.61}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 60.98, ["Neon"] = 4.2, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 106.08, ["Mega"] = 42, ["Mega|Ride"] = 104.92, ["Mega|Fly|Ride"] = 235.99}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 20.09, ["Fly|Ride"] = 57.75, ["Neon"] = 18.06, ["Neon|Fly"] = 102.51, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 115.46, ["Mega"] = 163.47, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.97, ["Fly"] = 72.29, ["Ride"] = 28.79, ["Fly|Ride"] = 80.94, ["Neon"] = 144.35, ["Neon|Ride"] = 243.96, ["Neon|Fly|Ride"] = 288.03, ["Mega"] = 459.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 646.75}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.99, ["Ride"] = 66.94, ["Fly|Ride"] = 139.13, ["Neon"] = 360.08, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 288.08, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2143.46, ["Mega|Ride"] = 1611.83, ["Mega|Fly|Ride"] = 1482.83}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Fly|Ride"] = 144.38, ["Neon"] = 2.6, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 144.58, ["Mega"] = 33.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.65, ["Fly|Ride"] = 42.95, ["Neon"] = 4.33, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 39.37, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 7.87, ["Fly"] = 43.17, ["Ride"] = 38.04, ["Fly|Ride"] = 65.62, ["Neon"] = 40.67, ["Neon|Ride"] = 48.78, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 546.94, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.73, ["Ride"] = 496.49, ["Fly|Ride"] = 577.5, ["Neon"] = 4315.42, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 19.27, ["Fly"] = 99.74, ["Ride"] = 55.02, ["Fly|Ride"] = 123.71, ["Neon"] = 217.75, ["Neon|Ride"] = 226.62, ["Neon|Fly|Ride"] = 215.96, ["Mega"] = 720.57, ["Mega|Ride"] = 840}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.76, ["Fly|Ride"] = 91.87, ["Neon"] = 5.25, ["Neon|Ride"] = 55.11, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 72.31, ["Mega|Ride"] = 124.73, ["Mega|Fly|Ride"] = 288.27}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.84, ["Fly"] = 91.88, ["Ride"] = 59.29, ["Fly|Ride"] = 261.97, ["Neon"] = 144.57, ["Mega"] = 131.25}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.57, ["Fly"] = 169.31, ["Ride"] = 37.7, ["Fly|Ride"] = 78.75, ["Neon"] = 186.58, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 274.01, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.94, ["Fly"] = 187.71, ["Ride"] = 128.62, ["Fly|Ride"] = 190.32, ["Neon"] = 430.1, ["Neon|Fly"] = 819.86, ["Neon|Ride"] = 487.61, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3165.02, ["Mega|Fly|Ride"] = 6472.43}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 243.34, ["Ride"] = 295.32, ["Fly|Ride"] = 269.07, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.67, ["Ride"] = 55.13, ["Fly|Ride"] = 72.19, ["Neon"] = 99.75, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 863.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 16.42, ["Fly|Ride"] = 38.75, ["Neon"] = 6.96, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 58.27, ["Mega"] = 89.58, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 163.37}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.67, ["Fly"] = 49.64, ["Ride"] = 21.4, ["Fly|Ride"] = 63, ["Neon"] = 31.02, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.62, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 274.01, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 315.02}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 315, ["Ride"] = 350.44, ["Fly|Ride"] = 762.49, ["Neon"] = 1562.54, ["Neon|Fly|Ride"] = 2086.53, ["Mega"] = 10787.37, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 10.37, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 34.9, ["Mega|Ride"] = 172.64}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.11, ["Ride"] = 15.38, ["Fly|Ride"] = 39.76, ["Neon"] = 23.35, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 79.46, ["Mega"] = 213.61, ["Mega|Fly"] = 288.08, ["Mega|Ride"] = 146.99, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.73, ["Fly"] = 6562.5, ["Ride"] = 56.72, ["Neon"] = 105, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 551.25, ["Mega|Ride"] = 647.33, ["Mega|Fly|Ride"] = 719.54}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 116.94, ["Fly"] = 157.5, ["Ride"] = 133.65, ["Fly|Ride"] = 165.37, ["Neon|Ride"] = 813.58, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1834.08}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 13.57, ["Fly"] = 39.29, ["Ride"] = 27.55, ["Fly|Ride"] = 62.58, ["Neon"] = 102.92, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 114.72, ["Mega"] = 875.44, ["Mega|Ride"] = 362.34, ["Mega|Fly|Ride"] = 485.1}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 37.05, ["Neon"] = 3.68, ["Neon|Ride"] = 76.6, ["Mega"] = 24.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 17.05, ["Fly|Ride"] = 86.33, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.82, ["Mega"] = 24.93, ["Mega|Fly"] = 93.89, ["Mega|Ride"] = 53.96, ["Mega|Fly|Ride"] = 144.74}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 19.5, ["Ride"] = 85.32, ["Fly|Ride"] = 254.89, ["Neon"] = 44.63, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 165.38, ["Mega|Ride"] = 212.4, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1176, ["Fly"] = 1521.32, ["Ride"] = 1144.55, ["Fly|Ride"] = 1312.5, ["Neon"] = 3281.25, ["Neon|Ride"] = 4314.96, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 448.28, ["Ride"] = 504, ["Fly|Ride"] = 538.13, ["Neon"] = 1680, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6506}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 314.99, ["Fly"] = 325.94, ["Ride"] = 350.44, ["Fly|Ride"] = 435.75, ["Neon"] = 787.5, ["Neon|Fly"] = 1138.55, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 914.81, ["Mega|Ride"] = 3451.97, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 243.84, ["Fly"] = 288.75, ["Ride"] = 286.13, ["Fly|Ride"] = 347.82, ["Neon"] = 647.07, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 3312.37}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 36.69, ["Ride"] = 17.07, ["Fly|Ride"] = 45.96, ["Neon"] = 8.65, ["Neon|Ride"] = 34.51, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 71.22, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 288.75, ["Fly"] = 1439.05, ["Ride"] = 299.25, ["Fly|Ride"] = 389.82, ["Neon"] = 1509.38, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1320.76, ["Mega"] = 21865.12, ["Mega|Ride"] = 5465.99, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.25, ["Fly"] = 144.38, ["Ride"] = 52.49, ["Neon"] = 27.57, ["Neon|Fly|Ride"] = 129.48, ["Mega"] = 196.55, ["Mega|Ride"] = 343.04, ["Mega|Fly|Ride"] = 719.62}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 22.97, ["Ride"] = 16.48, ["Fly|Ride"] = 39.38, ["Neon"] = 6.42, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 118.13, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 159.12}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.89, ["Mega"] = 21.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.46, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8131.9, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 23.63, ["Neon|Ride"] = 63.03, ["Mega"] = 358.15, ["Mega|Ride"] = 230.9, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 42.09, ["Neon"] = 2.45, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 18.95, ["Mega|Ride"] = 163.32, ["Mega|Fly|Ride"] = 96.37}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.85, ["Fly"] = 86.23, ["Ride"] = 41.3, ["Fly|Ride"] = 90.96, ["Neon"] = 31.5, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 58.45, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 181.84, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.6, ["Fly"] = 32.43, ["Ride"] = 18.37, ["Fly|Ride"] = 50.85, ["Neon"] = 27.57, ["Neon|Fly"] = 146.31, ["Neon|Ride"] = 135.85, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 7.88, ["Ride"] = 38.07, ["Fly|Ride"] = 146.39, ["Neon"] = 28.4, ["Neon|Ride"] = 172.61, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 807.98}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6505.85, ["Ride"] = 21.41, ["Fly|Ride"] = 131.25, ["Neon"] = 63, ["Neon|Ride"] = 214.68, ["Neon|Fly|Ride"] = 731.85, ["Mega"] = 366.19, ["Mega|Ride"] = 503.84, ["Mega|Fly|Ride"] = 552.34}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 69.18, ["Ride"] = 15.86, ["Fly|Ride"] = 41.23, ["Neon"] = 5.25, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 32.39, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 164.27}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 185.29, ["Fly"] = 263.23, ["Ride"] = 183.75, ["Fly|Ride"] = 267.54, ["Neon"] = 978.44, ["Neon|Ride"] = 1021.7, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 8630.84, ["Mega|Fly|Ride"] = 4391.01}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 23.69, ["Ride"] = 16.21, ["Fly|Ride"] = 36.88, ["Neon"] = 2.1, ["Neon|Fly"] = 36.61, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 50.79, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.97, ["Ride"] = 71.22, ["Fly|Ride"] = 230.86, ["Neon"] = 64.31, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 744.74, ["Mega"] = 319.03, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 24.94, ["Ride"] = 90.84, ["Fly|Ride"] = 183.75, ["Neon"] = 210, ["Neon|Ride"] = 302.11, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 786.19, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 198.18, ["Fly"] = 274.36, ["Ride"] = 236.24, ["Fly|Ride"] = 309.75, ["Neon"] = 874.13, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 732.12, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 35.44, ["Fly"] = 130.53, ["Ride"] = 162.75, ["Neon"] = 101.42, ["Neon|Ride"] = 178.43, ["Neon|Fly|Ride"] = 431.55, ["Mega"] = 281.69, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 403.46}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Fly|Ride"] = 147.9, ["Neon"] = 161.18, ["Neon|Fly"] = 163.47, ["Neon|Ride"] = 201.73, ["Mega"] = 1726.01, ["Mega|Ride"] = 1439.05, ["Mega|Fly|Ride"] = 716.39}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 945, ["Fly"] = 1219, ["Ride"] = 1048.69, ["Fly|Ride"] = 1023.75, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 3740.63, ["Mega|Fly|Ride"] = 17260.68}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 10.5, ["Fly"] = 27.16, ["Ride"] = 19.66, ["Fly|Ride"] = 45.93, ["Neon"] = 46.31, ["Neon|Fly"] = 65.15, ["Neon|Ride"] = 54.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 242.82, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.55, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 135.19, ["Neon"] = 27.06, ["Neon|Ride"] = 107.9, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 288.08, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.5, ["Ride"] = 23.72, ["Fly|Ride"] = 942.38, ["Neon"] = 12.18, ["Neon|Ride"] = 47.57, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 81.23, ["Mega|Ride"] = 360.31, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.8, ["Ride"] = 35.31, ["Fly|Ride"] = 124.83, ["Neon"] = 72.44, ["Neon|Fly"] = 187.74, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 446.24, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.36, ["Fly"] = 24.3, ["Ride"] = 17.07, ["Fly|Ride"] = 43.32, ["Neon"] = 14.47, ["Neon|Fly"] = 58.66, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 166.52}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 26.16, ["Fly|Ride"] = 131.24, ["Neon"] = 15.35, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 144.26, ["Mega|Ride"] = 227.06, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 244.92, ["Ride"] = 262.49, ["Fly|Ride"] = 431.51, ["Neon"] = 935.39, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3917.99}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 27.56, ["Fly|Ride"] = 105.59, ["Neon"] = 8.43, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 72.03, ["Mega|Ride"] = 124.82, ["Mega|Fly|Ride"] = 334.22}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.08, ["Ride"] = 144.57, ["Fly|Ride"] = 88.86, ["Neon"] = 19.21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 288.08}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 34.92, ["Neon"] = 10.49, ["Neon|Ride"] = 48.89, ["Neon|Fly|Ride"] = 103.58, ["Mega"] = 62.25, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 89.15, ["Ride"] = 130.94, ["Fly|Ride"] = 249.38, ["Neon"] = 430.48, ["Neon|Ride"] = 457.4, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 1454.33, ["Mega|Ride"] = 1508.27, ["Mega|Fly|Ride"] = 1562.21}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 32.82, ["Fly"] = 88.08, ["Ride"] = 58.27, ["Fly|Ride"] = 274.01, ["Neon"] = 127.29, ["Neon|Ride"] = 431.45, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.37, ["Fly"] = 263.44, ["Ride"] = 32.81, ["Fly|Ride"] = 114.37, ["Neon"] = 81.6, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 609, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 4.26, ["Ride"] = 71.59, ["Neon"] = 16.76, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 245.51, ["Mega"] = 106.08, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 46.32, ["Fly"] = 91.88, ["Ride"] = 75.27, ["Fly|Ride"] = 136.5, ["Neon"] = 253.56, ["Neon|Fly"] = 164.25, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 288.74, ["Mega|Fly|Ride"] = 1023.96}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 216.09, ["Neon"] = 5.86, ["Neon|Fly|Ride"] = 128.39, ["Mega"] = 91.88, ["Mega|Ride"] = 286.96, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.84, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 92.71, ["Neon"] = 64.54, ["Neon|Fly"] = 84, ["Neon|Ride"] = 81.74, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 360.35, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.9, ["Fly"] = 203.41, ["Ride"] = 82.31, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 431.55, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1475.73, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.55, ["Ride"] = 16.11, ["Fly|Ride"] = 41.66, ["Neon"] = 2.1, ["Neon|Fly"] = 28.06, ["Neon|Ride"] = 17.28, ["Neon|Fly|Ride"] = 46.56, ["Mega"] = 19.36, ["Mega|Ride"] = 40.42, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.92, ["Fly"] = 105, ["Ride"] = 26.74, ["Fly|Ride"] = 64.31, ["Neon"] = 19.66, ["Neon|Ride"] = 51.99, ["Neon|Fly|Ride"] = 168, ["Mega"] = 161.44, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 377.9}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.48, ["Fly"] = 144.58, ["Ride"] = 41.91, ["Fly|Ride"] = 117.25, ["Neon"] = 111.08, ["Neon|Ride"] = 121.92, ["Neon|Fly|Ride"] = 271.38, ["Mega"] = 705.5, ["Mega|Ride"] = 454.78, ["Mega|Fly|Ride"] = 576.14}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.38, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 95.55, ["Mega"] = 18.38, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 429.03}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 31.49, ["Fly"] = 210, ["Ride"] = 65.62, ["Fly|Ride"] = 245.41, ["Neon"] = 177.19, ["Neon|Ride"] = 171.56, ["Neon|Fly|Ride"] = 417.14, ["Mega"] = 691.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 654.01, ["Mega|Fly|Ride"] = 745.42}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.11, ["Fly"] = 43.17, ["Ride"] = 26.46, ["Fly|Ride"] = 85.68, ["Neon"] = 376.69, ["Neon|Ride"] = 123.04, ["Neon|Fly|Ride"] = 166.15, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.75, ["Ride"] = 59.84, ["Neon"] = 39.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 72.31, ["Neon|Fly|Ride"] = 719.54, ["Mega"] = 241.48, ["Mega|Ride"] = 289.02, ["Mega|Fly|Ride"] = 487.9}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.96, ["Fly"] = 73.16, ["Ride"] = 68.15, ["Fly|Ride"] = 244.63, ["Neon"] = 42.8, ["Neon|Ride"] = 102.44, ["Neon|Fly|Ride"] = 196.85, ["Mega"] = 257.28, ["Mega|Ride"] = 302.11, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 36.69, ["Fly|Ride"] = 196.88, ["Neon"] = 9.19, ["Neon|Fly"] = 210, ["Neon|Ride"] = 39.37, ["Mega"] = 69.57, ["Mega|Fly"] = 215.79, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 288.03}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 32.92, ["Mega"] = 49.76, ["Mega|Ride"] = 92.52, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.4}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 50.46, ["Fly"] = 78.75, ["Ride"] = 72.19, ["Fly|Ride"] = 91.87, ["Neon"] = 191.97, ["Neon|Ride"] = 215.77, ["Neon|Fly|Ride"] = 302.11, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 854.47}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Fly|Ride"] = 107.89, ["Neon"] = 2.1, ["Neon|Ride"] = 37.77, ["Mega"] = 23.63, ["Mega|Ride"] = 8918.88, ["Mega|Fly|Ride"] = 323.64}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 498.74, ["Fly"] = 328.13, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 4314.96, ["Neon|Ride"] = 2705.18, ["Neon|Fly|Ride"] = 2696.86, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.86, ["Fly"] = 48.86, ["Ride"] = 39.38, ["Fly|Ride"] = 65.84, ["Neon"] = 72.23, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.46, ["Mega"] = 325.68, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 633.24}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.83, ["Fly"] = 28, ["Ride"] = 23.6, ["Fly|Ride"] = 53.95, ["Neon"] = 21.57, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.58, ["Mega|Fly"] = 187.71, ["Mega|Ride"] = 171.56, ["Mega|Fly|Ride"] = 244.63}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Neon"] = 112.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 525.36, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 487.61}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.2, ["Fly"] = 43.17, ["Ride"] = 38.57, ["Fly|Ride"] = 72.29, ["Neon"] = 42.68, ["Neon|Fly"] = 72.29, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 286.96, ["Mega|Fly|Ride"] = 503.84}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.84, ["Ride"] = 67.96, ["Fly|Ride"] = 196.88, ["Neon"] = 101.64, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 142.41, ["Mega"] = 534, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 516.89}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Ride"] = 37.3, ["Fly|Ride"] = 101.41, ["Neon"] = 31.48, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 97.37, ["Neon|Fly|Ride"] = 278.33, ["Mega"] = 233.86, ["Mega|Ride"] = 306.73, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.57, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 13.95, ["Mega|Fly"] = 65.88, ["Mega|Ride"] = 31.28, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.1, ["Fly"] = 26.25, ["Ride"] = 30.19, ["Fly|Ride"] = 107.89, ["Neon"] = 51.23, ["Neon|Fly"] = 121.99, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 230.86, ["Mega"] = 212.17, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 252, ["Ride"] = 252.14, ["Fly|Ride"] = 390.88, ["Neon"] = 1268.52, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9465.05, ["Mega|Fly|Ride"] = 4221.05}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 77.59, ["Ride"] = 131.25, ["Fly|Ride"] = 256.76, ["Neon"] = 458.07, ["Neon|Fly"] = 923.41, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2302.29, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 16.21, ["Fly|Ride"] = 56.11, ["Neon"] = 7.53, ["Neon|Fly"] = 101.42, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 144.57, ["Mega|Fly"] = 214.68, ["Mega|Ride"] = 110.85, ["Mega|Fly|Ride"] = 259.23}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 25.99, ["Ride"] = 15.53, ["Fly|Ride"] = 34.12, ["Neon"] = 8.8, ["Neon|Fly"] = 32.46, ["Neon|Ride"] = 24.43, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 63, ["Mega|Fly"] = 288.03, ["Mega|Ride"] = 93.6, ["Mega|Fly|Ride"] = 147.31}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.29, ["Fly"] = 101.42, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 114.37, ["Neon|Ride"] = 42.7, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 436.94, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.99, ["Fly"] = 325.49, ["Ride"] = 219.19, ["Fly|Ride"] = 336, ["Neon"] = 1186.77, ["Neon|Ride"] = 1143.01, ["Neon|Fly|Ride"] = 1060.54, ["Mega|Ride"] = 8630.84, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.56, ["Fly"] = 32.25, ["Ride"] = 16.25, ["Fly|Ride"] = 32.82, ["Neon"] = 17.99, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 76.61, ["Mega"] = 262.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.16, ["Ride"] = 77.18, ["Fly|Ride"] = 215.77, ["Neon"] = 18.71, ["Neon|Ride"] = 110.04, ["Mega"] = 243.84, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 431.51}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 14.43, ["Neon|Ride"] = 43.17, ["Mega"] = 113.67, ["Mega|Ride"] = 331.23, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.82, ["Fly"] = 58.11, ["Ride"] = 27.28, ["Fly|Ride"] = 66.9, ["Neon"] = 96.91, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 354.38, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 33.66, ["Ride"] = 84.17, ["Fly|Ride"] = 302.06, ["Neon"] = 113.31, ["Neon|Fly"] = 655.95, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 231.53, ["Mega"] = 393.74, ["Mega|Fly"] = 2265.37, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 860.5}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21, ["Fly"] = 42, ["Ride"] = 49.63, ["Fly|Ride"] = 99.44, ["Neon"] = 144.38, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 150.89, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 863.09, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 16.08, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.64, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 43.17, ["Mega"] = 39.82, ["Mega|Fly"] = 43.17, ["Mega|Ride"] = 32.34, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 163.57, ["Ride"] = 236.25, ["Fly|Ride"] = 320.2, ["Neon"] = 3412.69, ["Neon|Ride"] = 1183.11, ["Neon|Fly|Ride"] = 1322.69, ["Mega|Fly|Ride"] = 5026.88}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.05, ["Fly"] = 101.18, ["Ride"] = 23.12, ["Fly|Ride"] = 100.82, ["Neon"] = 103.58, ["Neon|Ride"] = 81.69, ["Neon|Fly|Ride"] = 431.51, ["Mega"] = 380.63, ["Mega|Ride"] = 576.06, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.35, ["Ride"] = 18.78, ["Fly|Ride"] = 50.71, ["Neon"] = 5.58, ["Neon|Fly"] = 37.8, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 62.22, ["Mega|Fly"] = 230.86, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 201.41}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 18.4, ["Fly|Ride"] = 86.24, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 56.13, ["Mega"] = 26.09, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 34.64, ["Fly|Ride"] = 72.19, ["Neon"] = 12.57, ["Neon|Fly"] = 731.82, ["Neon|Ride"] = 56.69, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 155.54, ["Mega|Ride"] = 148.89, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.54, ["Fly"] = 26.83, ["Ride"] = 28.88, ["Fly|Ride"] = 70.88, ["Neon"] = 32.81, ["Neon|Fly"] = 244.9, ["Neon|Ride"] = 46.66, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 262.5, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 370.06}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.48, ["Ride"] = 32.81, ["Neon"] = 131.64, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 258.95, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 58.27, ["Neon"] = 3.74, ["Neon|Ride"] = 52.24, ["Neon|Fly|Ride"] = 115.43, ["Mega"] = 18.55, ["Mega|Ride"] = 70.48, ["Mega|Fly|Ride"] = 175.54}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.44, ["Fly"] = 83.99, ["Ride"] = 33.87, ["Fly|Ride"] = 144.57, ["Neon"] = 40.42, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 198.52, ["Mega"] = 159.67, ["Mega|Fly"] = 259.88, ["Mega|Ride"] = 319.6, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 3.93, ["Neon|Fly"] = 115.43, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 163.47, ["Mega"] = 21.45, ["Mega|Ride"] = 121.93, ["Mega|Fly|Ride"] = 258.91}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 52.78, ["Ride"] = 17.06, ["Fly|Ride"] = 56.11, ["Neon"] = 3.69, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 130.45, ["Mega"] = 45.93, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 224.42}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.99, ["Ride"] = 630.32, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3415.25, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.1, ["Ride"] = 15.16, ["Fly|Ride"] = 34.53, ["Neon"] = 65.61, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 85.31}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 49.24, ["Neon"] = 7.66, ["Neon|Fly"] = 755.13, ["Neon|Ride"] = 54.27, ["Neon|Fly|Ride"] = 152.81, ["Mega"] = 87.29, ["Mega|Ride"] = 133.6, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.39, ["Fly"] = 24.29, ["Ride"] = 24.51, ["Fly|Ride"] = 48.49, ["Neon"] = 30.55, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 111.17, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.49, ["Fly|Ride"] = 58.27, ["Neon"] = 9.19, ["Neon|Fly"] = 151.05, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 58.45, ["Mega"] = 52.5, ["Mega|Ride"] = 94.55, ["Mega|Fly|Ride"] = 166.16}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.72, ["Ride"] = 59.07, ["Neon"] = 194.83, ["Neon|Ride"] = 287, ["Mega"] = 965.48, ["Mega|Ride"] = 791.8, ["Mega|Fly|Ride"] = 806.77}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 28.09, ["Fly|Ride"] = 91.88, ["Neon"] = 7.35, ["Neon|Fly"] = 139.07, ["Neon|Ride"] = 37.82, ["Neon|Fly|Ride"] = 127.3, ["Mega"] = 47.25, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 270.79}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.87, ["Fly"] = 32.82, ["Ride"] = 21.16, ["Fly|Ride"] = 85.59, ["Neon"] = 10.67, ["Neon|Ride"] = 40.31, ["Mega"] = 114.09, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.17, ["Fly|Ride"] = 65.83, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 107.89, ["Mega"] = 97.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2588.99, ["Ride"] = 16.88, ["Fly|Ride"] = 69.45, ["Neon"] = 4.18, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 41.57, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 75.58, ["Mega|Fly|Ride"] = 133.77}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.81, ["Fly"] = 21.39, ["Ride"] = 19.27, ["Fly|Ride"] = 43.82, ["Neon"] = 118.13, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 140.27, ["Mega|Ride"] = 537.93, ["Mega|Fly|Ride"] = 484.32}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 721.88, ["Fly"] = 1078.88, ["Ride"] = 774.38, ["Fly|Ride"] = 912.19, ["Neon"] = 1557.94, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 8596.88, ["Mega|Fly|Ride"] = 4383.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.19, ["Ride"] = 16.53, ["Fly|Ride"] = 47.24, ["Neon"] = 2.63, ["Neon|Fly"] = 50.71, ["Neon|Ride"] = 19.49, ["Neon|Fly|Ride"] = 57.3, ["Mega"] = 36.75, ["Mega|Ride"] = 71.22, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.33, ["Ride"] = 36.74, ["Fly|Ride"] = 201.76, ["Neon"] = 57.52, ["Neon|Ride"] = 91.64, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 489.49}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 51.18, ["Ride"] = 59.07, ["Fly|Ride"] = 107.63, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 315, ["Mega"] = 2437.64}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 32.2, ["Fly"] = 146.73, ["Ride"] = 45.94, ["Fly|Ride"] = 109.79, ["Neon"] = 144.58, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 244.92, ["Mega"] = 1463.68, ["Mega|Ride"] = 935.28, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 7.87, ["Fly"] = 95.1, ["Ride"] = 30.86, ["Neon"] = 63.1, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 305.36, ["Mega|Ride"] = 430.43, ["Mega|Fly|Ride"] = 457.38}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.32, ["Fly"] = 86.31, ["Ride"] = 63.66, ["Fly|Ride"] = 144.57, ["Neon"] = 109.72, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 210, ["Mega"] = 380.63, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 22.99, ["Ride"] = 71.22, ["Neon"] = 148.17, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 374.33, ["Mega"] = 534, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 718.45}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.56}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.45, ["Ride"] = 28.88, ["Fly|Ride"] = 105, ["Neon"] = 32.82, ["Neon|Ride"] = 97.12, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 19.13, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.37, ["Fly"] = 62.99, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 223.13, ["Neon|Fly"] = 288.08, ["Neon|Ride"] = 201.76, ["Neon|Fly|Ride"] = 230.9, ["Mega"] = 1255.4, ["Mega|Ride"] = 775.68, ["Mega|Fly|Ride"] = 684.15}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.19, ["Fly"] = 19.69, ["Ride"] = 21.59, ["Fly|Ride"] = 43.21, ["Neon"] = 23.63, ["Neon|Fly"] = 71.22, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 76.61, ["Mega"] = 233.04, ["Mega|Fly"] = 430.48, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 200.81}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.93, ["Fly"] = 31.7, ["Ride"] = 26.25, ["Fly|Ride"] = 58.47, ["Neon"] = 23.15, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 219.43, ["Mega|Ride"] = 163.37, ["Mega|Fly|Ride"] = 246.68}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 41.9, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 20.58, ["Ride"] = 54.64, ["Fly|Ride"] = 144.58, ["Neon"] = 244.92, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 735, ["Mega"] = 578.87, ["Mega|Ride"] = 854.38, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 33, ["Fly|Ride"] = 58.27, ["Neon"] = 7.65, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.74, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.55, ["Ride"] = 87.94, ["Fly|Ride"] = 286.96, ["Neon"] = 59.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 323.64, ["Mega"] = 429.4, ["Mega|Fly"] = 576.06, ["Mega|Ride"] = 400.77, ["Mega|Fly|Ride"] = 534.06}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 17.06, ["Fly|Ride"] = 44.63, ["Neon"] = 18.31, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 152.69, ["Mega|Fly|Ride"] = 287}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.81, ["Fly"] = 52.49, ["Ride"] = 18.19, ["Fly|Ride"] = 47.31, ["Neon"] = 51.19, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 609.42, ["Mega|Ride"] = 430.48, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 9.45, ["Neon"] = 91.88, ["Neon|Ride"] = 76.61, ["Mega"] = 406.88, ["Mega|Ride"] = 365.75, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 49.87, ["Ride"] = 133.89, ["Fly|Ride"] = 288.07, ["Neon"] = 275.63, ["Neon|Ride"] = 492.49, ["Neon|Fly|Ride"] = 952.76, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.05, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Neon|Ride"] = 142.43, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 421.31, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 593.39}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 15.71, ["Ride"] = 114.1, ["Neon"] = 92.79, ["Neon|Fly"] = 215.77, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 511.4}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.29, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 145.53, ["Neon|Fly"] = 263.23, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 705.5, ["Mega|Fly"] = 2157.48, ["Mega|Ride"] = 640.78, ["Mega|Fly|Ride"] = 840.34}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 20.55, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 325.49}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.69, ["Fly|Ride"] = 42.02, ["Neon"] = 3.89, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 65.09, ["Mega"] = 58.28, ["Mega|Ride"] = 77.68, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 29.14, ["Fly|Ride"] = 84.17, ["Neon"] = 12.74, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 89.64, ["Mega|Ride"] = 100.33, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.58, ["Ride"] = 19.68, ["Fly|Ride"] = 72.01, ["Neon"] = 3.94, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 92.01, ["Mega"] = 52.5, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.63, ["Fly"] = 65.62, ["Ride"] = 19.09, ["Fly|Ride"] = 72.29, ["Neon"] = 20.27, ["Neon|Ride"] = 107.9, ["Neon|Fly|Ride"] = 215.77, ["Mega"] = 288.39, ["Mega|Ride"] = 331.2, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.93, ["Fly"] = 62.73, ["Ride"] = 26.17, ["Fly|Ride"] = 431.51, ["Neon"] = 29.88, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 306.37, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1078.76}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.42, ["Fly"] = 131.25, ["Ride"] = 23.56, ["Fly|Ride"] = 68.28, ["Neon"] = 35.44, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 56.13, ["Neon|Fly|Ride"] = 90.04, ["Mega|Ride"] = 276.73, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.63, ["Fly"] = 35.48, ["Ride"] = 16.14, ["Fly|Ride"] = 52.41, ["Neon"] = 26.31, ["Neon|Ride"] = 69.06, ["Neon|Fly|Ride"] = 151.05, ["Mega"] = 274.01, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.83, ["Fly"] = 288.73, ["Ride"] = 47.23, ["Neon"] = 14.09, ["Neon|Fly"] = 49.64, ["Neon|Ride"] = 69.66, ["Neon|Fly|Ride"] = 107.9, ["Mega"] = 90.57, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 11.82, ["Ride"] = 105, ["Fly|Ride"] = 330.75, ["Neon"] = 103.95, ["Neon|Ride"] = 191.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 619.5, ["Mega|Ride"] = 633.11, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 49.86, ["Fly"] = 164.07, ["Ride"] = 88.49, ["Fly|Ride"] = 157.5, ["Neon"] = 240.9, ["Neon|Ride"] = 270.9, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 1581.45, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 51.8, ["Neon"] = 3.78, ["Neon|Ride"] = 21.5, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 27.55, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 5.5, ["Neon"] = 105.94, ["Mega"] = 676.38, ["Mega|Fly|Ride"] = 1137.02}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 56.59, ["Ride"] = 68.25, ["Neon"] = 249.37, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 863.02, ["Mega"] = 1777.78, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.29, ["Fly"] = 190.32, ["Ride"] = 34.54, ["Fly|Ride"] = 133.88, ["Neon"] = 46.87, ["Neon|Fly"] = 130.44, ["Neon|Ride"] = 86.31, ["Neon|Fly|Ride"] = 121.92, ["Mega"] = 267.46, ["Mega|Fly"] = 736.17, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.55, ["Fly|Ride"] = 118.12, ["Neon"] = 11.82, ["Neon|Ride"] = 69.16, ["Neon|Fly|Ride"] = 210, ["Mega"] = 83.97, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 130.1, ["Mega|Fly|Ride"] = 252.74}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 3.29, ["Fly"] = 34.04, ["Ride"] = 20.51, ["Fly|Ride"] = 57.75, ["Neon"] = 26.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 37.59, ["Neon|Fly|Ride"] = 96.48, ["Mega"] = 163.47, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 163.37}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 14.11, ["Fly|Ride"] = 52.4, ["Neon"] = 2.19, ["Neon|Fly"] = 120.48, ["Neon|Ride"] = 23.36, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 23.62, ["Mega|Ride"] = 73.12, ["Mega|Fly|Ride"] = 154.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.51, ["Fly|Ride"] = 36.75, ["Neon"] = 5.92, ["Neon|Ride"] = 23.18, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 45.94, ["Mega|Fly"] = 118.85, ["Mega|Ride"] = 71.95, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.6, ["Neon|Ride"] = 145.08, ["Mega"] = 23.06, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.18, ["Ride"] = 157.5, ["Neon"] = 45.38, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 407.39, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.23, ["Ride"] = 26.24, ["Fly|Ride"] = 215.77, ["Neon"] = 61.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 285.48, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.95, ["Fly"] = 28.09, ["Ride"] = 17.06, ["Fly|Ride"] = 38.19, ["Neon"] = 49.86, ["Neon|Fly"] = 115.46, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 98.42, ["Mega"] = 356, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 348.48}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.78, ["Ride"] = 97.13, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 475.75, ["Neon|Fly|Ride"] = 719.61, ["Mega"] = 2439.46, ["Mega|Ride"] = 1631.15, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 13.12, ["Fly"] = 82.69, ["Ride"] = 59.07, ["Fly|Ride"] = 115.46, ["Neon"] = 1004.31, ["Neon|Fly|Ride"] = 630, ["Mega"] = 463.51, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1004.73}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.35, ["Fly|Ride"] = 36.38, ["Neon"] = 3.15, ["Neon|Fly"] = 43.17, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 22.98, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 323.64}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.07, ["Ride"] = 16.16, ["Fly|Ride"] = 31.05, ["Neon"] = 5.41, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 19.44, ["Neon|Fly|Ride"] = 43.78, ["Mega"] = 39.25, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 91.95}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.88, ["Fly"] = 573.28, ["Ride"] = 441.83, ["Fly|Ride"] = 523.69, ["Neon"] = 2373.23, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2097.38, ["Mega|Fly|Ride"] = 6833.51}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.55, ["Ride"] = 34.13, ["Neon"] = 43.41, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 719.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 14.67, ["Fly|Ride"] = 49.64, ["Neon"] = 3.93, ["Neon|Fly"] = 21.16, ["Neon|Ride"] = 22.18, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 33.6, ["Mega|Ride"] = 144.58, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 45.8, ["Ride"] = 115.68, ["Fly|Ride"] = 284.84, ["Neon"] = 196.88, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 718.53, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 779.63}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.25, ["Ride"] = 23.59, ["Fly|Ride"] = 39.38, ["Neon"] = 27.78, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 86.33, ["Mega"] = 118.13, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 227.67}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 18.74, ["Fly|Ride"] = 196.88, ["Neon"] = 3.62, ["Neon|Fly"] = 101.41, ["Neon|Ride"] = 62.58, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 17.63, ["Mega|Ride"] = 52.48, ["Mega|Fly|Ride"] = 244.9}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 41.86, ["Fly"] = 129.94, ["Ride"] = 75.12, ["Fly|Ride"] = 214.67, ["Neon"] = 131.25, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 288.03, ["Mega"] = 705.5, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.16, ["Neon|Ride"] = 41.02, ["Neon|Fly|Ride"] = 86.31, ["Mega"] = 62.58, ["Mega|Ride"] = 165.76, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.56, ["Ride"] = 66.75, ["Fly|Ride"] = 105, ["Neon"] = 283.23, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 1181.25, ["Mega|Ride"] = 1294.5, ["Mega|Fly|Ride"] = 1333.33}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.16, ["Fly"] = 72.31, ["Ride"] = 131.25, ["Fly|Ride"] = 431.51, ["Neon"] = 28.86, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 498.88, ["Mega"] = 169.32, ["Mega|Ride"] = 238.44, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.97, ["Ride"] = 81.34, ["Fly|Ride"] = 58.27, ["Neon"] = 9.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 117.6, ["Mega|Ride"] = 123.44, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.27, ["Fly"] = 187.71, ["Ride"] = 118.13, ["Fly|Ride"] = 163.24, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2015.1}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.48, ["Ride"] = 29.4, ["Neon"] = 7.38, ["Neon|Ride"] = 57.35, ["Neon|Fly|Ride"] = 115.43, ["Mega"] = 47.25, ["Mega|Fly"] = 215.77, ["Mega|Ride"] = 86.31, ["Mega|Fly|Ride"] = 282.65}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 21.79, ["Ride"] = 20.14, ["Fly|Ride"] = 102.38, ["Neon"] = 5.22, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 81.69, ["Mega"] = 59.13, ["Mega|Fly"] = 150.04, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 219.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.57, ["Fly"] = 57.91, ["Ride"] = 37.64, ["Fly|Ride"] = 195.17, ["Neon"] = 81.03, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 203.72, ["Mega"] = 262.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 405.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 8.54, ["Fly"] = 43.17, ["Ride"] = 28.56, ["Fly|Ride"] = 97.54, ["Neon"] = 51.98, ["Neon|Ride"] = 46.13, ["Neon|Fly|Ride"] = 132.54, ["Mega"] = 354.38, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 420.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.58, ["Fly"] = 28.88, ["Ride"] = 32.82, ["Fly|Ride"] = 42, ["Neon"] = 81.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 160.98, ["Mega"] = 403.46, ["Mega|Ride"] = 327.45, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 72.18, ["Ride"] = 121.8, ["Fly|Ride"] = 192.31, ["Neon"] = 314.99, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1575, ["Mega|Ride"] = 1664.7, ["Mega|Fly|Ride"] = 1677.64}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.46, ["Ride"] = 115.4, ["Fly|Ride"] = 115.46, ["Neon"] = 65.63, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 302.4, ["Mega"] = 242.06, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 618.05}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.63, ["Ride"] = 25.57, ["Fly|Ride"] = 78.73, ["Neon"] = 25.19, ["Neon|Ride"] = 44.63, ["Mega"] = 105.74, ["Mega|Ride"] = 170.46, ["Mega|Fly|Ride"] = 487.61}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.44, ["Fly"] = 135.19, ["Ride"] = 36.75, ["Fly|Ride"] = 115.5, ["Neon"] = 76.13, ["Neon|Ride"] = 112.2, ["Neon|Fly|Ride"] = 186.11, ["Mega"] = 317.63, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.12, ["Fly|Ride"] = 45.01, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.32, ["Neon|Fly|Ride"] = 55.04, ["Mega"] = 13.3, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.28, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 45.38, ["Fly"] = 164.07, ["Ride"] = 102.65, ["Neon"] = 236.25, ["Neon|Fly"] = 2445.52, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 485.45, ["Mega"] = 1078.76, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.25, ["Fly|Ride"] = 144.57, ["Neon"] = 7.88, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 45.45, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 17.6, ["Fly|Ride"] = 45.94, ["Neon"] = 19.08, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 64.31, ["Mega"] = 257.25, ["Mega|Ride"] = 197.51, ["Mega|Fly|Ride"] = 288.08}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.89, ["Ride"] = 90.56, ["Fly|Ride"] = 170.63, ["Neon"] = 195.57, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 779.63, ["Mega|Ride"] = 1111.19, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 11.89, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 46.56, ["Mega"] = 40.84, ["Mega|Fly"] = 163.37, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 446.21}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.76}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Fly|Ride"] = 134.08, ["Neon"] = 6.3, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 121.92, ["Mega"] = 111.57, ["Mega|Fly"] = 187.74, ["Mega|Ride"] = 105.25, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.22, ["Ride"] = 224.39, ["Fly|Ride"] = 352.8, ["Neon"] = 604.2, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6472.43, ["Mega|Ride"] = 3253.01, ["Mega|Fly|Ride"] = 2381.45}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.57, ["Ride"] = 36.69, ["Fly|Ride"] = 97.54, ["Neon"] = 30.2, ["Neon|Fly"] = 144.57, ["Neon|Ride"] = 103.47, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.48, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.8, ["Neon|Ride"] = 21.33, ["Mega"] = 45.42, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 66.89, ["Mega|Fly|Ride"] = 345.21}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 36.73, ["Fly|Ride"] = 131.25, ["Neon"] = 65.54, ["Neon|Ride"] = 89.55, ["Neon|Fly|Ride"] = 159.67, ["Mega"] = 296.7, ["Mega|Ride"] = 431.51, ["Mega|Fly|Ride"] = 676.45}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.18, ["Fly"] = 52.21, ["Ride"] = 22.32, ["Fly|Ride"] = 62.58, ["Neon"] = 101.04, ["Neon|Ride"] = 128.39, ["Neon|Fly|Ride"] = 197.54, ["Mega"] = 227.96, ["Mega|Ride"] = 430.48, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.68, ["Ride"] = 56.74, ["Fly|Ride"] = 172.5, ["Neon"] = 129.68, ["Neon|Ride"] = 214.71, ["Neon|Fly|Ride"] = 327.95, ["Mega"] = 552.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 148.17, ["Fly"] = 196.88, ["Ride"] = 190.31, ["Fly|Ride"] = 249.27, ["Neon"] = 632.02, ["Neon|Fly"] = 813.08, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2157.73}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.51, ["Fly"] = 20.98, ["Ride"] = 23.75, ["Fly|Ride"] = 52.49, ["Neon"] = 63.19, ["Neon|Fly"] = 58.27, ["Neon|Ride"] = 64, ["Neon|Fly|Ride"] = 68.24, ["Mega"] = 323.67, ["Mega|Ride"] = 315.61, ["Mega|Fly|Ride"] = 511.4}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.65, ["Fly"] = 72.31, ["Ride"] = 28.06, ["Fly|Ride"] = 78.75, ["Neon"] = 18.75, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 114.68, ["Mega"] = 143.33, ["Mega|Ride"] = 205, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.2, ["Fly"] = 42.33, ["Ride"] = 37.8, ["Fly|Ride"] = 76.13, ["Neon"] = 39.36, ["Neon|Fly"] = 72.29, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 172.61, ["Mega"] = 458.62, ["Mega|Ride"] = 429.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.83, ["Fly"] = 82.62, ["Ride"] = 65.62, ["Fly|Ride"] = 127.4, ["Neon"] = 210, ["Neon|Ride"] = 252.14, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 975.31, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 962.73}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.59, ["Fly"] = 57.75, ["Ride"] = 261.06, ["Neon"] = 196.87, ["Neon|Ride"] = 258.91, ["Neon|Fly|Ride"] = 475.79, ["Mega"] = 1050, ["Mega|Ride"] = 705.5, ["Mega|Fly|Ride"] = 819.95}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.88, ["Ride"] = 350.44, ["Fly|Ride"] = 328.13, ["Neon"] = 1627.13, ["Neon|Ride"] = 3253.01, ["Mega|Fly|Ride"] = 5178.55}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 22.25, ["Fly"] = 58.65, ["Ride"] = 27.2, ["Fly|Ride"] = 69.45, ["Neon"] = 204.74, ["Neon|Ride"] = 133.07, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 761.25, ["Mega|Ride"] = 753.43, ["Mega|Fly|Ride"] = 897.63}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 14.43, ["Fly|Ride"] = 72.31, ["Neon"] = 2.63, ["Neon|Fly"] = 21.59, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 18.36, ["Mega|Fly"] = 114.36, ["Mega|Ride"] = 51.58, ["Mega|Fly|Ride"] = 117.03}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 29.14, ["Neon"] = 16.05, ["Neon|Ride"] = 86.12, ["Neon|Fly|Ride"] = 163.47, ["Mega"] = 132.71, ["Mega|Ride"] = 163.47, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.92, ["Ride"] = 32.82, ["Fly|Ride"] = 57.19, ["Neon"] = 62.53, ["Neon|Ride"] = 85.21, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.76, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 382.97, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 357, ["Fly"] = 393.75, ["Ride"] = 418.68, ["Fly|Ride"] = 552.57, ["Neon"] = 1898.49, ["Neon|Ride"] = 2015.1, ["Neon|Fly|Ride"] = 1871.63, ["Mega|Fly|Ride"] = 5710.03}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.84, ["Fly"] = 39.38, ["Ride"] = 16.21, ["Fly|Ride"] = 86.31, ["Neon"] = 32.71, ["Neon|Ride"] = 36.59, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 221.82, ["Mega|Ride"] = 272.77, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.35, ["Fly"] = 28.06, ["Ride"] = 19.52, ["Fly|Ride"] = 33.11, ["Neon"] = 43.36, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.27, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 180.43, ["Mega|Ride"] = 288.03, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.49, ["Fly"] = 42, ["Ride"] = 28.06, ["Fly|Ride"] = 59.41, ["Neon"] = 15.58, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 94.5, ["Mega|Fly"] = 127.35, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 34.15, ["Fly"] = 57.35, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 220.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 322.55, ["Mega"] = 1294.5, ["Mega|Ride"] = 861.92, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.48, ["Fly|Ride"] = 50.85, ["Neon"] = 12.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 10.78, ["Fly"] = 93.13, ["Ride"] = 72.29, ["Neon"] = 170.63, ["Neon|Ride"] = 201.76, ["Neon|Fly|Ride"] = 259.23, ["Mega"] = 748.13, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 791.9}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 4.67, ["Neon|Ride"] = 29.17, ["Mega"] = 55.13, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 107.92, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.73, ["Neon"] = 53.76, ["Mega"] = 136.02, ["Mega|Ride"] = 325.67, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.07, ["Ride"] = 29.14, ["Fly|Ride"] = 63, ["Neon"] = 72.19, ["Neon|Ride"] = 288.03, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 559.94, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.7, ["Fly"] = 26.24, ["Ride"] = 27.06, ["Fly|Ride"] = 56.44, ["Neon"] = 55.02, ["Neon|Fly"] = 114.68, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 130.45, ["Mega"] = 538.31, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 420, ["Fly"] = 609.89, ["Ride"] = 440.46, ["Fly|Ride"] = 513.19, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 2277.09, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7436.82}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 16.21, ["Fly|Ride"] = 39.38, ["Neon"] = 15.74, ["Neon|Fly"] = 81.74, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 244.9, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 306.18}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.18, ["Fly"] = 71.22, ["Fly|Ride"] = 187.74, ["Neon"] = 87.94, ["Neon|Ride"] = 127.25, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 393.75, ["Mega|Fly"] = 719.54, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 585.13}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 75.74, ["Ride"] = 96.52, ["Fly|Ride"] = 243.96, ["Neon"] = 125.99, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 374.47, ["Mega"] = 409.98, ["Mega|Ride"] = 409.94, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 51.18, ["Fly"] = 169.32, ["Ride"] = 83.99, ["Fly|Ride"] = 131.25, ["Neon"] = 345.23, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Fly|Ride"] = 1837.03}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.35, ["Ride"] = 49.87, ["Neon"] = 47.49, ["Neon|Ride"] = 84.88, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 170.51, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 194.52, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 192.02, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.16, ["Ride"] = 71.4, ["Neon"] = 23.43, ["Neon|Ride"] = 123, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 174.8, ["Mega|Fly"] = 256.76, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 272.1}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 41.97, ["Fly"] = 183.72, ["Ride"] = 88.38, ["Fly|Ride"] = 197.74, ["Neon"] = 118.13, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 262.97, ["Mega"] = 388.5, ["Mega|Ride"] = 446.35, ["Mega|Fly|Ride"] = 477.15}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.24, ["Ride"] = 85.28, ["Neon"] = 7.88, ["Neon|Ride"] = 94.37, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 57.75, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.75, ["Ride"] = 86.33, ["Neon"] = 169.32, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 315, ["Mega"] = 708.75, ["Mega|Fly|Ride"] = 825.88}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 951.56, ["Fly"] = 1194.38, ["Ride"] = 1009.32, ["Fly|Ride"] = 1074.12, ["Neon"] = 3598.01, ["Neon|Ride"] = 2605.32, ["Neon|Fly|Ride"] = 2859.94, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.47, ["Fly"] = 116.94, ["Ride"] = 44.63, ["Fly|Ride"] = 194.25, ["Neon"] = 65.63, ["Neon|Fly"] = 718.45, ["Neon|Ride"] = 179.36, ["Mega"] = 249.38, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.87, ["Ride"] = 20.5, ["Fly|Ride"] = 79.92, ["Neon"] = 10.5, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 30.73, ["Neon|Fly|Ride"] = 83.16, ["Mega"] = 64.94, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.88, ["Ride"] = 131.25, ["Fly|Ride"] = 144.57, ["Neon"] = 62.83, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 382.03, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.7, ["Neon"] = 2.55, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 16.64, ["Mega|Ride"] = 48.83, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 50.26, ["Fly"] = 129.47, ["Ride"] = 99.52, ["Fly|Ride"] = 266.44, ["Neon"] = 210, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 384.74, ["Mega"] = 980.75, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 11.04, ["Ride"] = 62.89, ["Fly|Ride"] = 282.47, ["Neon"] = 169.32, ["Neon|Ride"] = 442.3, ["Mega"] = 489.82, ["Mega|Ride"] = 863.1, ["Mega|Fly|Ride"] = 1005.4}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.29, ["Ride"] = 23.2, ["Neon"] = 10.5, ["Neon|Ride"] = 41.41, ["Neon|Fly|Ride"] = 123, ["Mega"] = 97.59, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 431.55}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.23, ["Fly"] = 159.67, ["Ride"] = 45.94, ["Fly|Ride"] = 105.87, ["Neon"] = 86.08, ["Neon|Ride"] = 95.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 462.78, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 741.29}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 7.32, ["Fly"] = 97.11, ["Ride"] = 27.9, ["Fly|Ride"] = 59.07, ["Neon"] = 90.57, ["Neon|Fly"] = 130.53, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 146.31, ["Mega"] = 262.5, ["Mega|Ride"] = 539.4, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.34, ["Ride"] = 91.88, ["Neon"] = 323.67, ["Neon|Ride"] = 323.67, ["Neon|Fly|Ride"] = 576.06, ["Mega"] = 2517.78, ["Mega|Ride"] = 2439.46, ["Mega|Fly|Ride"] = 2157.48}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.26, ["Ride"] = 46.37, ["Fly|Ride"] = 194.21, ["Neon"] = 11.79, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 651, ["Mega"] = 58.75, ["Mega|Ride"] = 114.79, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Ride"] = 23.63, ["Fly|Ride"] = 90.57, ["Neon"] = 39.29, ["Neon|Fly"] = 187.71, ["Neon|Ride"] = 58.27, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 301.55, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 309.73}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 113.04, ["Fly"] = 393.75, ["Ride"] = 182.43, ["Fly|Ride"] = 236.25, ["Neon"] = 480.38, ["Neon|Ride"] = 546.69, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 1951.62}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 3.29, ["Fly"] = 26.75, ["Ride"] = 18.38, ["Fly|Ride"] = 48.78, ["Neon"] = 26.3, ["Neon|Fly"] = 57.54, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 75.89, ["Mega"] = 137.82, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 24.83, ["Fly"] = 267.04, ["Ride"] = 62.34, ["Fly|Ride"] = 170.63, ["Neon"] = 170.63, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 656.25, ["Mega|Ride"] = 593.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 12.74, ["Fly|Ride"] = 62.98, ["Neon"] = 2.1, ["Neon|Fly"] = 29.04, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 13.85, ["Mega|Fly"] = 47.58, ["Mega|Ride"] = 31.38, ["Mega|Fly|Ride"] = 69.23}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.27, ["Neon"] = 3.38, ["Neon|Fly|Ride"] = 133.8, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.62, ["Fly"] = 36.69, ["Ride"] = 28.59, ["Fly|Ride"] = 173.36, ["Neon"] = 15, ["Neon|Ride"] = 58.27, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 130.45, ["Neon|Ride"] = 345.21, ["Neon|Fly|Ride"] = 424.47, ["Mega"] = 511.88, ["Mega|Ride"] = 646.17, ["Mega|Fly|Ride"] = 865.92}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.74, ["Fly"] = 20.51, ["Ride"] = 16.97, ["Fly|Ride"] = 39.38, ["Neon"] = 10.4, ["Neon|Fly"] = 28.86, ["Neon|Ride"] = 26.27, ["Neon|Fly|Ride"] = 58.47, ["Mega"] = 130.4, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.71, ["Fly"] = 43.32, ["Ride"] = 39.9, ["Fly|Ride"] = 94.15, ["Neon"] = 51.19, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 364.72, ["Mega|Fly"] = 439.11, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 354.25}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.21, ["Ride"] = 18.38, ["Fly|Ride"] = 68.61, ["Neon"] = 8.32, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 47.83, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.8, ["Fly"] = 162.91, ["Ride"] = 32.39, ["Fly|Ride"] = 217.2, ["Neon"] = 39.86, ["Neon|Ride"] = 72.29, ["Neon|Fly|Ride"] = 163.37, ["Mega"] = 322.6, ["Mega|Ride"] = 403.94, ["Mega|Fly|Ride"] = 487.61}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.55, ["Ride"] = 51.8, ["Fly|Ride"] = 170.63, ["Neon"] = 51.19, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 73.5, ["Mega"] = 241.5, ["Mega|Ride"] = 302.07, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.6, ["Fly"] = 47.07, ["Ride"] = 19.08, ["Fly|Ride"] = 56.49, ["Neon"] = 27.57, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 146.37, ["Mega"] = 232.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 242.82}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 23.88, ["Ride"] = 16.09, ["Fly|Ride"] = 52.56, ["Neon"] = 15.98, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.15, ["Neon|Fly|Ride"] = 83.32, ["Mega"] = 144.57, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 287}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 216.57, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 430.48, ["Neon"] = 1280.48, ["Neon|Ride"] = 1280.63, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4228.8, ["Mega|Fly|Ride"] = 3900.78}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.23, ["Ride"] = 114.17, ["Neon"] = 38.75, ["Neon|Ride"] = 144.58, ["Mega"] = 119.69, ["Mega|Ride"] = 651.35, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.94, ["Fly"] = 107.89, ["Ride"] = 18.64, ["Fly|Ride"] = 86.33, ["Neon"] = 32.06, ["Neon|Fly"] = 244.9, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 146.39, ["Mega"] = 244.18, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.74, ["Fly|Ride"] = 719.54, ["Neon"] = 47.48, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 166.16, ["Mega|Ride"] = 487.61, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 14.43, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 21.59, ["Neon|Ride"] = 16.33, ["Neon|Fly|Ride"] = 42.09, ["Mega"] = 18.17, ["Mega|Fly"] = 80.94, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.18}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.53, ["Fly"] = 47.15, ["Ride"] = 16.69, ["Fly|Ride"] = 103.59, ["Neon"] = 19.49, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 120.21, ["Mega|Ride"] = 210.38, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.42, ["Ride"] = 119.85, ["Neon"] = 6.49, ["Neon|Ride"] = 288.03, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 51.19, ["Mega|Ride"] = 165.55, ["Mega|Fly|Ride"] = 280.53}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 73.16, ["Fly"] = 72.18, ["Ride"] = 91.67, ["Fly|Ride"] = 140.33, ["Neon"] = 315, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 425.32, ["Mega|Ride"] = 3597.6, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.84, ["Fly"] = 72.31, ["Ride"] = 28.88, ["Fly|Ride"] = 71.22, ["Neon"] = 21.31, ["Neon|Ride"] = 69.56, ["Mega"] = 169.3, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 364.63}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.64, ["Ride"] = 43.17, ["Neon"] = 7.22, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 547.26, ["Mega"] = 56.35, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 43.28, ["Fly"] = 118.13, ["Ride"] = 78.73, ["Fly|Ride"] = 172.81, ["Neon"] = 144.38, ["Neon|Ride"] = 166.16, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 511.88, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 12.83, ["Fly|Ride"] = 33.38, ["Neon"] = 2.63, ["Neon|Fly"] = 22.39, ["Neon|Ride"] = 16.01, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 16.8, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.68, ["Mega|Fly|Ride"] = 61.76}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 58.27, ["Fly|Ride"] = 97.11, ["Neon"] = 3.17, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 29.17, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 26.25, ["Mega|Fly"] = 144.57, ["Mega|Ride"] = 89.55, ["Mega|Fly|Ride"] = 287}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Fly"] = 33.46, ["Ride"] = 39.38, ["Fly|Ride"] = 161.34, ["Neon"] = 6.56, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.03, ["Mega"] = 64.32, ["Mega|Fly"] = 187.71, ["Mega|Ride"] = 125.98, ["Mega|Fly|Ride"] = 274.01}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 9.19, ["Fly"] = 72.3, ["Ride"] = 43.31, ["Fly|Ride"] = 106.32, ["Neon"] = 19.57, ["Neon|Fly"] = 101.42, ["Neon|Ride"] = 85.76, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 106.55, ["Mega|Fly"] = 331.2, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 14.43, ["Fly|Ride"] = 43.17, ["Neon"] = 2.1, ["Neon|Fly"] = 24.83, ["Neon|Ride"] = 24.83, ["Neon|Fly|Ride"] = 58.94, ["Mega"] = 19.59, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 118.11}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.58, ["Fly"] = 127.31, ["Ride"] = 55.13, ["Neon"] = 144.58, ["Neon|Ride"] = 201.73, ["Neon|Fly|Ride"] = 431.51, ["Mega"] = 505.49, ["Mega|Fly|Ride"] = 861.92}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2625, ["Fly"] = 3150, ["Ride"] = 2256.19, ["Fly|Ride"] = 2163, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44767.55}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 16.41, ["Fly|Ride"] = 45.94, ["Neon"] = 9.45, ["Neon|Fly"] = 71.22, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 58.27, ["Mega"] = 76.13, ["Mega|Fly"] = 475.79, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.07, ["Neon"] = 9.84, ["Mega"] = 104.87, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 487.9}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.28, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 144.63, ["Neon"] = 105.73, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 277.07, ["Mega"] = 420, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 714.74}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.57, ["Fly"] = 108.23, ["Ride"] = 71.19, ["Neon"] = 161.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 359.62, ["Mega"] = 754.07, ["Mega|Ride"] = 689.32, ["Mega|Fly|Ride"] = 650.96}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 147.91, ["Fly"] = 1439.05, ["Ride"] = 188.87, ["Fly|Ride"] = 242.82, ["Neon"] = 647.07, ["Neon|Ride"] = 766.63, ["Neon|Fly|Ride"] = 652.32, ["Mega|Fly|Ride"] = 4168.73}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.28, ["Ride"] = 64.97, ["Fly|Ride"] = 86.33, ["Neon"] = 15.74, ["Neon|Ride"] = 72.29, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 144.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 378.7}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.69, ["Neon"] = 16.14, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 179.82, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.41, ["Ride"] = 33.46, ["Fly|Ride"] = 85.25, ["Neon"] = 7.34, ["Neon|Fly"] = 127.31, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 64.97, ["Mega|Ride"] = 113.02, ["Mega|Fly|Ride"] = 235.31}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.56, ["Ride"] = 70.03, ["Fly|Ride"] = 131.25, ["Neon"] = 140.79, ["Neon|Ride"] = 1222.48, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 318.61, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 571.6}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 28.05, ["Neon"] = 2.63, ["Neon|Ride"] = 27.77, ["Mega"] = 22.32, ["Mega|Fly"] = 121.92, ["Mega|Ride"] = 86.18}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Fly"] = 201.76, ["Ride"] = 128.4, ["Fly|Ride"] = 164.07, ["Neon"] = 311.85, ["Neon|Fly"] = 378.7, ["Neon|Ride"] = 378.7, ["Neon|Fly|Ride"] = 417.54, ["Mega"] = 3236.57, ["Mega|Ride"] = 2483.25, ["Mega|Fly|Ride"] = 1348.59}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 45.32, ["Ride"] = 91.85, ["Neon"] = 13.15, ["Neon|Ride"] = 144.57, ["Neon|Fly|Ride"] = 215.77, ["Mega"] = 63.41, ["Mega|Ride"] = 287, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 48.57, ["Fly"] = 105, ["Ride"] = 77.44, ["Fly|Ride"] = 170.63, ["Neon"] = 228.66, ["Neon|Ride"] = 294.12, ["Neon|Fly|Ride"] = 429.4, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1728}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.67, ["Ride"] = 21.59, ["Fly|Ride"] = 41.5, ["Neon"] = 4.16, ["Neon|Fly"] = 85.39, ["Neon|Ride"] = 72.31, ["Neon|Fly|Ride"] = 115.43, ["Mega"] = 40.74, ["Mega|Fly"] = 146.39, ["Mega|Ride"] = 71.95, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.7, ["Neon|Ride"] = 115.46, ["Mega"] = 41.15, ["Mega|Fly|Ride"] = 390.56}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.91, ["Fly"] = 77.44, ["Ride"] = 28.88, ["Fly|Ride"] = 90.57, ["Neon"] = 19.48, ["Neon|Fly"] = 107.89, ["Neon|Ride"] = 72.47, ["Neon|Fly|Ride"] = 106.82, ["Mega"] = 141.74, ["Mega|Ride"] = 274.01, ["Mega|Fly|Ride"] = 576.06}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 367.5, ["Fly"] = 731.85, ["Ride"] = 410.82, ["Fly|Ride"] = 504, ["Neon"] = 820.31, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1124.2, ["Mega"] = 3113.24, ["Mega|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.42, ["Fly"] = 65.63, ["Ride"] = 54.64, ["Fly|Ride"] = 87.92, ["Neon"] = 183.68, ["Neon|Ride"] = 231.14, ["Neon|Fly|Ride"] = 195.57, ["Mega|Fly"] = 2747.21, ["Mega|Ride"] = 1726.01, ["Mega|Fly|Ride"] = 1063.64}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 3.93, ["Fly"] = 61.62, ["Ride"] = 32.81, ["Fly|Ride"] = 126, ["Neon"] = 25.88, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 79.84, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 127.09, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.58, ["Fly"] = 215.77, ["Ride"] = 58.47, ["Fly|Ride"] = 149.63, ["Neon"] = 77.95, ["Neon|Fly"] = 355.36, ["Neon|Ride"] = 145.06, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 301.88, ["Mega|Fly"] = 1003.85, ["Mega|Ride"] = 253.55, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 3.94, ["Ride"] = 23.61, ["Neon"] = 101.36, ["Neon|Ride"] = 121.98, ["Neon|Fly|Ride"] = 487.61, ["Mega"] = 651.35, ["Mega|Ride"] = 283.74, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.82, ["Neon"] = 17.04, ["Neon|Ride"] = 157.5, ["Mega"] = 82.69, ["Mega|Ride"] = 336.62}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 7.88, ["Fly"] = 72.29, ["Ride"] = 19.69, ["Fly|Ride"] = 62.97, ["Neon"] = 26.83, ["Neon|Fly"] = 93.89, ["Neon|Ride"] = 72.31, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 249.38, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 89.92, ["Fly"] = 243.95, ["Ride"] = 90.96, ["Fly|Ride"] = 131.25, ["Neon"] = 656.25, ["Neon|Ride"] = 518.45, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3252.93}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.63, ["Ride"] = 55.56, ["Fly|Ride"] = 85.32, ["Neon"] = 118.12, ["Neon|Ride"] = 172.61, ["Neon|Fly|Ride"] = 194.25, ["Mega"] = 536.82, ["Mega|Ride"] = 574.11, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1647.19, ["Fly"] = 2157.73, ["Ride"] = 1903.13, ["Fly|Ride"] = 1895.25, ["Neon"] = 11506.89, ["Neon|Fly|Ride"] = 6761.23, ["Mega|Fly|Ride"] = 24279.94}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.67, ["Fly"] = 131250, ["Ride"] = 68.25, ["Fly|Ride"] = 196.87, ["Neon"] = 19.57, ["Neon|Ride"] = 73.16, ["Mega"] = 161.44, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 216.02, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.48, ["Fly"] = 72.31, ["Ride"] = 52.48, ["Fly|Ride"] = 148.89, ["Neon"] = 25.89, ["Neon|Ride"] = 86.85, ["Mega"] = 144.38, ["Mega|Ride"] = 284.8, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.38, ["Ride"] = 851.82, ["Fly|Ride"] = 892.5, ["Neon"] = 2309.81, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.49, ["Mega|Ride"] = 13824.34, ["Mega|Fly|Ride"] = 13010.79}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.28, ["Ride"] = 55.12, ["Fly|Ride"] = 173.35, ["Neon"] = 144.36, ["Neon|Ride"] = 215.79, ["Mega"] = 852.6, ["Mega|Ride"] = 863.09, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 21.79, ["Fly|Ride"] = 128.15, ["Neon"] = 11.79, ["Neon|Fly"] = 163.47, ["Neon|Ride"] = 58.33, ["Neon|Fly|Ride"] = 288.03, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 144.57, ["Neon"] = 2.49, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 86.33, ["Mega"] = 23.36, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 163.37}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.86, ["Fly"] = 431.55, ["Ride"] = 130.53, ["Fly|Ride"] = 215.77, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2439.4, ["Mega|Fly|Ride"] = 2373.23}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 36.69, ["Fly|Ride"] = 75.54, ["Neon"] = 12.41, ["Neon|Ride"] = 34.54, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 91.87, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 212.33}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.64, ["Fly"] = 151.05, ["Ride"] = 102.1, ["Fly|Ride"] = 288.08, ["Neon"] = 647.07, ["Neon|Ride"] = 721.88, ["Mega"] = 2157.48, ["Mega|Fly|Ride"] = 1650.68}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.5, ["Fly"] = 105, ["Fly|Ride"] = 129.47, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.13, ["Mega|Ride"] = 318.26}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Fly"] = 284.82, ["Ride"] = 304.04, ["Fly|Ride"] = 295.32, ["Neon"] = 1148.82, ["Neon|Ride"] = 1294.64, ["Neon|Fly|Ride"] = 879.37, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.89, ["Fly"] = 65.63, ["Ride"] = 24.83, ["Fly|Ride"] = 115.4, ["Neon"] = 72.29, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 115.43, ["Mega"] = 335.24, ["Mega|Ride"] = 416.72, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.37, ["Ride"] = 15.65, ["Fly|Ride"] = 42, ["Neon"] = 3.94, ["Neon|Fly"] = 38.03, ["Neon|Ride"] = 21.97, ["Neon|Fly|Ride"] = 62.24, ["Mega"] = 44.63, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 125.97}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1348.44, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7911.46, ["Neon|Fly|Ride"] = 7048.48, ["Mega"] = 24393.78, ["Mega|Fly|Ride"] = 23016.39}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 18.64, ["Ride"] = 77.58, ["Fly|Ride"] = 215.79, ["Neon"] = 98.58, ["Neon|Ride"] = 314.98, ["Mega"] = 380.63, ["Mega|Ride"] = 449.51, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.2, ["Fly"] = 49.8, ["Ride"] = 43.17, ["Fly|Ride"] = 104.89, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 119.77, ["Mega"] = 393.75, ["Mega|Ride"] = 163.8, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.54, ["Fly"] = 33.44, ["Ride"] = 37.2, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 189.07, ["Mega"] = 2589.26, ["Mega|Ride"] = 1139.2, ["Mega|Fly|Ride"] = 696.55}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.06, ["Fly"] = 70.16, ["Ride"] = 31.2, ["Fly|Ride"] = 72.19, ["Neon"] = 65.84, ["Neon|Ride"] = 77.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 560.96}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 78.75, ["Ride"] = 99.26, ["Fly|Ride"] = 644.01, ["Neon"] = 415.29, ["Neon|Fly"] = 576.06, ["Neon|Ride"] = 503.29, ["Neon|Fly|Ride"] = 719.54, ["Mega"] = 1950.4, ["Mega|Ride"] = 1078.88, ["Mega|Fly|Ride"] = 968.71}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.63, ["Neon|Fly"] = 54.71, ["Neon|Ride"] = 106.33, ["Neon|Fly|Ride"] = 107.89, ["Mega"] = 16.78, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 102.88, ["Fly"] = 160.13, ["Ride"] = 142.8, ["Fly|Ride"] = 157.5, ["Neon"] = 822.94, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 646.25, ["Mega"] = 3150, ["Mega|Fly|Ride"] = 2153.19}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 144.38, ["Ride"] = 52.43, ["Fly|Ride"] = 67.36, ["Neon"] = 222.84, ["Neon|Ride"] = 72.18, ["Mega"] = 773.71, ["Mega|Ride"] = 412.79, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 13.13, ["Neon|Fly"] = 86.31, ["Neon|Ride"] = 72.29, ["Neon|Fly|Ride"] = 118, ["Mega|Ride"] = 275.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.74, ["Neon|Fly"] = 142.43, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.71}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 83.07, ["Fly"] = 247.55, ["Ride"] = 223.13, ["Fly|Ride"] = 414.31, ["Neon"] = 417.38, ["Neon|Ride"] = 576.06, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2205, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.72, ["Ride"] = 39.38, ["Fly|Ride"] = 431.55, ["Neon"] = 21.48, ["Neon|Ride"] = 59.07, ["Mega"] = 126.87, ["Mega|Ride"] = 157.52, ["Mega|Fly|Ride"] = 325.66}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.37, ["Neon|Ride"] = 101.42, ["Mega"] = 18.11, ["Mega|Ride"] = 92.74, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 20.98, ["Fly|Ride"] = 144.57, ["Neon"] = 2.63, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 26.25, ["Mega"] = 18.37, ["Mega|Ride"] = 53.96, ["Mega|Fly|Ride"] = 105.74}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.19, ["Fly|Ride"] = 52.48, ["Neon"] = 5.97, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 114.18}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.43, ["Neon"] = 24.42, ["Mega"] = 118.13, ["Mega|Ride"] = 129.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.49, ["Fly|Ride"] = 38.52, ["Neon"] = 16.45, ["Neon|Fly"] = 86.31, ["Neon|Ride"] = 40.93, ["Neon|Fly|Ride"] = 101.41, ["Mega"] = 223.13, ["Mega|Ride"] = 101.41, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 55.11, ["Ride"] = 148.88, ["Fly|Ride"] = 290.51, ["Neon"] = 229.66, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 629.9, ["Mega"] = 643.13, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 860.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 18.37, ["Fly|Ride"] = 43.17, ["Neon"] = 2.57, ["Neon|Fly"] = 32.78, ["Neon|Ride"] = 21.51, ["Neon|Fly|Ride"] = 45.35, ["Mega"] = 145.01, ["Mega|Fly"] = 72.31, ["Mega|Ride"] = 32.39, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.22, ["Fly"] = 32.71, ["Ride"] = 32.89, ["Fly|Ride"] = 71.8, ["Neon"] = 36.45, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 66.91, ["Neon|Fly|Ride"] = 129.48, ["Mega"] = 301.88, ["Mega|Fly"] = 576.06, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 30.18, ["Fly"] = 59.07, ["Ride"] = 52.5, ["Fly|Ride"] = 129.47, ["Neon"] = 105, ["Neon|Ride"] = 144.58, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 616.88, ["Mega|Ride"] = 863.02, ["Mega|Fly|Ride"] = 662.82}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.87, ["Fly"] = 29.14, ["Ride"] = 19.69, ["Fly|Ride"] = 66.89, ["Neon"] = 85.32, ["Neon|Ride"] = 105, ["Mega"] = 566.87, ["Mega|Ride"] = 771.52, ["Mega|Fly|Ride"] = 716.29}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.24, ["Ride"] = 17.28, ["Fly|Ride"] = 37.77, ["Neon"] = 4.2, ["Neon|Fly"] = 29.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.37, ["Mega"] = 39.12, ["Mega|Ride"] = 64.75, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 11.46, ["Fly"] = 78.74, ["Ride"] = 32.82, ["Neon"] = 43.17, ["Neon|Ride"] = 206.05, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 354.38, ["Mega|Fly"] = 534, ["Mega|Ride"] = 525.41, ["Mega|Fly|Ride"] = 568.53}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 958.13, ["Fly"] = 1242.87, ["Ride"] = 1004.06, ["Fly|Ride"] = 1023.75, ["Neon"] = 2491.13, ["Neon|Fly"] = 2911.86, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2469.86, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 190.32, ["Ride"] = 304.37, ["Fly|Ride"] = 568.57, ["Neon"] = 656.25, ["Neon|Ride"] = 895.97, ["Neon|Fly|Ride"] = 1035.71, ["Mega"] = 36303.75, ["Mega|Ride"] = 3739.99, ["Mega|Fly|Ride"] = 3495.12}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 8.97, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 258.91, ["Mega"] = 64.32, ["Mega|Fly|Ride"] = 1151.03}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 119.54, ["Fly"] = 147, ["Ride"] = 196.88, ["Fly|Ride"] = 377.57, ["Neon"] = 643.13, ["Neon|Ride"] = 622.13, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2445.52, ["Mega|Fly|Ride"] = 1916.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.31, ["Fly"] = 41.02, ["Ride"] = 22.1, ["Fly|Ride"] = 93.89, ["Neon"] = 17.92, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 115.96, ["Mega|Ride"] = 172.64, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 236.25, ["Fly"] = 431.51, ["Ride"] = 288.75, ["Fly|Ride"] = 426.16, ["Neon"] = 1438.42, ["Neon|Ride"] = 1467.1, ["Neon|Fly|Ride"] = 1402.37, ["Mega|Fly|Ride"] = 4874.76}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.2, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 225.51, ["Neon"] = 33.46, ["Neon|Ride"] = 56.54, ["Mega"] = 393.74, ["Mega|Fly"] = 361.39, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 26.25, ["Neon"] = 45.94, ["Neon|Ride"] = 53.65, ["Mega"] = 249.38, ["Mega|Ride"] = 345.24}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 24.94, ["Fly"] = 52.5, ["Ride"] = 68.13, ["Fly|Ride"] = 144.57, ["Neon"] = 92.79, ["Neon|Fly"] = 431.55, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 839.27, ["Mega|Ride"] = 595.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 10.5, ["Neon|Ride"] = 196.88, ["Mega"] = 243.96, ["Mega|Ride"] = 257.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.08, ["Ride"] = 15.12, ["Fly|Ride"] = 39.37, ["Neon"] = 2.58, ["Neon|Fly"] = 20.69, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 52.95, ["Mega"] = 26.44, ["Mega|Ride"] = 48.75, ["Mega|Fly|Ride"] = 92.79}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5466.59, ["Ride"] = 4462.5, ["Fly|Ride"] = 4554.38, ["Neon"] = 32362.09, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.07, ["Fly"] = 86.31, ["Ride"] = 41.99, ["Neon"] = 86.38, ["Neon|Fly"] = 384.04, ["Neon|Ride"] = 106.31, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 430.48}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 19.25, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 83.06, ["Mega"] = 137.81, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 433.13, ["Fly"] = 547.78, ["Ride"] = 498.75, ["Fly|Ride"] = 580.13, ["Neon"] = 1633.23, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.57, ["Ride"] = 48.81, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 144.58, ["Mega|Ride"] = 171.54, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.24, ["Fly"] = 145.69, ["Ride"] = 131.25, ["Neon"] = 52.5, ["Neon|Ride"] = 49.64, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 431.55, ["Mega|Ride"] = 401.62}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.29, ["Ride"] = 19.76, ["Fly|Ride"] = 65.62, ["Neon"] = 3.62, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 43.17, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 228.74}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.5, ["Fly"] = 878.11, ["Ride"] = 767.8, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2086.88, ["Mega|Fly|Ride"] = 8486.43}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.47, ["Ride"] = 85.31, ["Fly|Ride"] = 144.58, ["Neon"] = 32.49, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 179.66, ["Mega"] = 193.26, ["Mega|Fly"] = 431.51, ["Mega|Ride"] = 327.28, ["Mega|Fly|Ride"] = 430.8}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.24, ["Fly"] = 106.2, ["Ride"] = 45.94, ["Fly|Ride"] = 115.46, ["Neon"] = 26.66, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 169.32, ["Mega|Fly"] = 812.96, ["Mega|Ride"] = 160.58, ["Mega|Fly|Ride"] = 324.29}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.61, ["Fly"] = 35.44, ["Ride"] = 18.18, ["Fly|Ride"] = 42.73, ["Neon"] = 24.83, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 83.81, ["Mega"] = 165.38, ["Mega|Ride"] = 163.37, ["Mega|Fly|Ride"] = 239.77}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 14.95, ["Fly"] = 39.38, ["Ride"] = 41.02, ["Fly|Ride"] = 65.63, ["Neon"] = 118.13, ["Neon|Ride"] = 114.18, ["Mega"] = 863.09, ["Mega|Ride"] = 609.89, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 288.03, ["Neon"] = 5.94, ["Neon|Ride"] = 142.43, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 35.44, ["Mega|Fly"] = 146.31, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 575.87, ["Fly"] = 676.38, ["Ride"] = 667.69, ["Fly|Ride"] = 682.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 2294.5, ["Neon|Fly|Ride"] = 2302.04, ["Mega|Ride"] = 9513.84, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Ride"] = 107.89, ["Fly|Ride"] = 262.5, ["Neon"] = 7.58, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 54.13, ["Mega|Ride"] = 146.39, ["Mega|Fly|Ride"] = 213.54}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 49.68, ["Neon"] = 4.28, ["Neon|Fly"] = 288.03, ["Neon|Ride"] = 58.27, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 6.57, ["Neon|Ride"] = 39.51, ["Neon|Fly|Ride"] = 576.14, ["Mega"] = 40.69, ["Mega|Fly"] = 159.67, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 144.57}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Mega"] = 236.29, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 27.57, ["Fly"] = 72.19, ["Ride"] = 60.33, ["Fly|Ride"] = 213.47, ["Neon"] = 103.94, ["Neon|Ride"] = 124.23, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 418.83, ["Mega|Ride"] = 523.18, ["Mega|Fly|Ride"] = 575.63}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 12.83, ["Ride"] = 36.75, ["Fly|Ride"] = 155.17, ["Neon"] = 86.61, ["Neon|Ride"] = 121.92, ["Neon|Fly|Ride"] = 288.08, ["Mega"] = 551.25, ["Mega|Ride"] = 569, ["Mega|Fly|Ride"] = 575.74}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.33, ["Fly"] = 20.99, ["Ride"] = 17.07, ["Fly|Ride"] = 42.09, ["Neon"] = 51.24, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 299.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.91, ["Ride"] = 78.74, ["Fly|Ride"] = 146.39, ["Neon"] = 63.98, ["Neon|Ride"] = 91.88, ["Mega|Ride"] = 431.55}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 109.5, ["Neon"] = 11.46, ["Neon|Ride"] = 51.8, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 82.67, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 243.96}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.95, ["Fly"] = 26.25, ["Ride"] = 24.71, ["Fly|Ride"] = 55.11, ["Neon"] = 115.76, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 201.73, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.13, ["Fly"] = 874.13, ["Neon"] = 114.68, ["Mega"] = 278.88, ["Mega|Fly"] = 647.33, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 576.14}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 41.44, ["Fly"] = 86.63, ["Ride"] = 65.63, ["Fly|Ride"] = 195.56, ["Neon"] = 260.96, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 1950.4, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 31.49, ["Fly"] = 144.57, ["Ride"] = 74.8, ["Fly|Ride"] = 236.64, ["Neon"] = 125.87, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 315, ["Mega"] = 502.85, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.38, ["Ride"] = 32.71, ["Neon"] = 137, ["Neon|Ride"] = 223.12, ["Mega"] = 689.32, ["Mega|Ride"] = 624.52, ["Mega|Fly|Ride"] = 819.86}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 36, ["Fly"] = 72.19, ["Ride"] = 97.44, ["Fly|Ride"] = 144.38, ["Neon"] = 210, ["Neon|Fly"] = 318.28, ["Neon|Ride"] = 218.68, ["Neon|Fly|Ride"] = 483.52, ["Mega"] = 741.12, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.66, ["Neon|Fly|Ride"] = 57.57, ["Mega"] = 49.64, ["Mega|Fly"] = 325.68, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1482.21}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 98.42, ["Ride"] = 120.16, ["Fly|Ride"] = 374.22, ["Neon"] = 459.38, ["Neon|Ride"] = 562.85, ["Neon|Fly|Ride"] = 752.97, ["Mega"] = 1632.75, ["Mega|Ride"] = 1624.32, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.07, ["Neon"] = 3.81, ["Neon|Fly"] = 101.41, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 302.07, ["Mega"] = 39.38, ["Mega|Ride"] = 87.78, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.18, ["Ride"] = 78.75, ["Fly|Ride"] = 215.79, ["Neon"] = 118.13, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 564.88, ["Mega|Fly|Ride"] = 653.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Fly|Ride"] = 144.57, ["Mega"] = 22.11}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.9, ["Mega"] = 21, ["Mega|Ride"] = 107.16, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 90.56, ["Fly"] = 1799.34, ["Ride"] = 146.4, ["Fly|Ride"] = 196.88, ["Neon"] = 593.66, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 6703.48, ["Mega|Fly|Ride"] = 2077.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.69, ["Fly|Ride"] = 66.94, ["Neon"] = 6.41, ["Neon|Fly"] = 43.17, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.88, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.54, ["Fly|Ride"] = 65.63, ["Neon"] = 3.36, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 34.8, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 4.26, ["Ride"] = 71.59, ["Neon"] = 16.76, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 245.51, ["Mega"] = 106.08, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 14.43, ["Neon|Ride"] = 43.17, ["Mega"] = 113.67, ["Mega|Ride"] = 331.23, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.04, ["Ride"] = 131.25, ["Fly|Ride"] = 360.31, ["Neon"] = 426.57, ["Neon|Ride"] = 557.08, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 2874.38}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 9.45, ["Neon"] = 91.88, ["Neon|Ride"] = 76.61, ["Mega"] = 406.88, ["Mega|Ride"] = 365.75, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 413.44, ["Ride"] = 427.33, ["Fly|Ride"] = 733.56, ["Neon"] = 1069.69, ["Neon|Ride"] = 1266.59, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 87.94}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.19}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 25.91}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 49.26}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.8}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.07}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.35}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.31}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 16.86}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 106.6}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 852.86}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 13.48}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 18.38}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.57}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 38.56}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 682.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 582.75}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.58}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1345.32}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.1}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 26.24}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 20.69}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 61.37}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 21}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.82}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.27}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.33}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 24.42}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.9}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3118.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.63}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 86.14}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 268.71}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.85}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.5}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 11.96}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 26.66}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.56}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 249.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 12.04}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 160.78}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 52.5}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 55.04}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 16.21}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 34.13}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.39}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.92}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.84}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.2}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 82.91}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 262.5}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.16}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 325.66}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.69}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 87.28}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.57}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24271.83}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.52}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 62.58}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 31.48}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.97}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 28.67}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.93}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 122.75}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.81}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 104.19}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.35}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 57.3}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.44}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.98}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.41}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 144.23}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.49}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.48}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 60.38}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.86}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.8}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.19}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.88}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 9.98}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.5}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 41.98}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 31.48}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 71.31}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.65}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.74}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.62}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.74}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.74}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 13.13}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.86}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 129.94}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.12}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 13.12}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.25}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 26.24}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.64}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 154.37}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 42.09}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 17.15}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.43}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.24}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.23}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 16.21}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.5}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 11506.89}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.99}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.45}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.54}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 17.07}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.34}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.86}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.21}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.71}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.29}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 9.18}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.49}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.03}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 78.1}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.23}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.65}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.37}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 47.48}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.2}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.75}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.67}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 144000.09}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.35}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.24}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.97}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.39}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.9}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 102.38}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.45}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1312.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 73.77}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 33.44}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 36.74}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 8.49}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 18.38}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.57}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.29}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.81}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.46}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.42}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 27.43}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 8.53}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.56}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 83.19}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 17.83}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 6.13}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 412.92}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.83}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 14.1}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.52}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 25.17}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 19.69}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.99}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.63}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 144.57}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 153.57}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 12.72}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1017.19}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.94}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 53.82}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.09}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.39}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 52.49}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.93}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.18}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 77.23}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.49}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.83}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.68}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 18.4}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 108.22}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 77.43}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.64}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 58.41}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.82}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 95.01}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 6.12}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.75}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 4.96}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 6.18}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 53.91}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 56.34}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.6}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.69}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.18}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.45}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 16.93}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 84.03}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.38}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.07}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 11.44}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 33.56}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.34}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 28.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 144.57}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.87}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 21}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 7.96}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.8}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.34}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.71}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.23}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 23.69}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.07}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 20.62}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 295.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 62.99}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.13}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 51.45}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 155.86}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 90.18}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 976.5}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 182.34}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1659.17}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.63}},
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