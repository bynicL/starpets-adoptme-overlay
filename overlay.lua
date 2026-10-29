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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 963.09, ["Ride"] = 892.5, ["Fly|Ride"] = 1050, ["Neon"] = 4134.24, ["Neon|Fly|Ride"] = 3927, ["Mega|Fly|Ride"] = 33073.91}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 452.82, ["Fly"] = 608.39, ["Ride"] = 494.78, ["Fly|Ride"] = 525, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2067.13, ["Mega"] = 10335.61, ["Mega|Fly|Ride"] = 7759.19}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4593.75, ["Ride"] = 4593.75, ["Fly|Ride"] = 4331.25, ["Neon|Fly|Ride"] = 20533.74, ["Mega|Fly|Ride"] = 68904.33}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 136.5, ["Fly"] = 150.94, ["Ride"] = 155.76, ["Fly|Ride"] = 380.63, ["Neon"] = 776.1, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1102.82, ["Mega"] = 4134.24, ["Mega|Fly|Ride"] = 3346.23}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 550.65, ["Fly"] = 550.65, ["Ride"] = 612.2, ["Fly|Ride"] = 584.07, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.09, ["Ride"] = 27.68, ["Fly|Ride"] = 152.99, ["Neon"] = 56.44, ["Neon|Fly"] = 275.98, ["Neon|Ride"] = 109.4, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 285.27, ["Mega|Ride"] = 465.53, ["Mega|Fly|Ride"] = 465.53}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 31.35, ["Ride"] = 24.94, ["Fly|Ride"] = 77.98, ["Neon"] = 25.93, ["Neon|Fly"] = 115.98, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 114.06, ["Mega"] = 131.06, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.92, ["Ride"] = 147.72, ["Fly|Ride"] = 234.64, ["Neon"] = 521.06, ["Neon|Ride"] = 619.12, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 2343.09, ["Mega|Fly|Ride"] = 2656.5}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 28.87, ["Fly"] = 138.18, ["Ride"] = 51.97, ["Fly|Ride"] = 91.88, ["Neon"] = 288.75, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 310.76, ["Mega"] = 2100, ["Mega|Ride"] = 896.11, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 25.88, ["Fly"] = 52.5, ["Ride"] = 31.28, ["Fly|Ride"] = 65.62, ["Neon"] = 248.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1342.61, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 65.63, ["Fly"] = 206.07, ["Ride"] = 84.6, ["Fly|Ride"] = 131.25, ["Neon"] = 493.36, ["Neon|Fly"] = 372.1, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1550.35}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.3}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 295.32, ["Fly"] = 395.01, ["Ride"] = 350.44, ["Fly|Ride"] = 378.63, ["Neon"] = 1309.53, ["Neon|Ride"] = 1241.82, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4864.98}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 111.09, ["Fly"] = 155.5, ["Ride"] = 123.38, ["Fly|Ride"] = 162.42, ["Neon|Fly"] = 674.88, ["Neon|Fly|Ride"] = 551.94, ["Mega|Fly|Ride"] = 2637.23}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.66, ["Fly"] = 114.47, ["Ride"] = 51.85, ["Fly|Ride"] = 131.23, ["Neon"] = 19.69, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 189, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 206.72, ["Mega|Fly|Ride"] = 385.24}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 175.48, ["Fly"] = 200.82, ["Ride"] = 150.94, ["Fly|Ride"] = 209.98, ["Neon"] = 930.86, ["Neon|Ride"] = 689.39, ["Neon|Fly|Ride"] = 632.63, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.78, ["Fly"] = 21.38, ["Ride"] = 18.6, ["Fly|Ride"] = 39.96, ["Neon"] = 26.08, ["Neon|Ride"] = 62.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 207.38, ["Mega|Fly"] = 349.16, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 395.72}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.56, ["Fly"] = 262.5, ["Ride"] = 144.38, ["Fly|Ride"] = 258.28, ["Neon"] = 380.9, ["Neon|Fly"] = 465.53, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 413.43, ["Mega"] = 1513.15, ["Mega|Ride"] = 1194.38, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.28}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 126, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 1846.99}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.12, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 223.13, ["Neon"] = 206.72, ["Neon|Ride"] = 179.86, ["Neon|Fly|Ride"] = 206.72, ["Mega|Ride"] = 581.9, ["Mega|Fly|Ride"] = 1653.7}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 44.52, ["Fly"] = 124.17, ["Ride"] = 53.82, ["Fly|Ride"] = 131.25, ["Neon"] = 241.34, ["Neon|Ride"] = 233.63, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 1629.36, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.85, ["Ride"] = 189, ["Fly|Ride"] = 138.51, ["Neon"] = 192.05, ["Neon|Fly"] = 386.31, ["Neon|Ride"] = 296.64, ["Neon|Fly|Ride"] = 354.53, ["Mega"] = 1165.87, ["Mega|Ride"] = 1236.15, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 19.69, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 345.22, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 293.3, ["Mega"] = 824.79, ["Mega|Ride"] = 2065.06, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.68, ["Fly"] = 136.75, ["Ride"] = 43.64, ["Fly|Ride"] = 138.51, ["Neon"] = 210, ["Neon|Fly"] = 552.98, ["Neon|Ride"] = 180.09, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 885.44}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.97, ["Fly"] = 30.95, ["Ride"] = 23.62, ["Fly|Ride"] = 52.5, ["Neon"] = 30.95, ["Neon|Fly"] = 105, ["Neon|Ride"] = 45.38, ["Neon|Fly|Ride"] = 92.96, ["Mega"] = 131.25, ["Mega|Fly"] = 24849.92, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 249.55}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 322.9, ["Fly"] = 362.25, ["Ride"] = 413.03, ["Fly|Ride"] = 441.23, ["Neon"] = 1853.28, ["Neon|Ride"] = 1963.78, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7138.87}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.13, ["Ride"] = 32.45, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 177.79, ["Neon|Fly|Ride"] = 193.3, ["Mega"] = 515.75, ["Mega|Ride"] = 785.52, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.14, ["Fly"] = 34.19, ["Ride"] = 18.35, ["Fly|Ride"] = 47.32, ["Neon"] = 51.19, ["Neon|Fly"] = 78.1, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 124.72, ["Mega"] = 275.98, ["Mega|Ride"] = 268.47, ["Mega|Fly|Ride"] = 420.29}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 59.07, ["Fly"] = 117.3, ["Ride"] = 85.6, ["Fly|Ride"] = 144.42, ["Neon"] = 349.09, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 411.37, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3032.48, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2064.57}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 31.99, ["Ride"] = 33.72, ["Fly|Ride"] = 75.22, ["Neon"] = 97.16, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 698.31, ["Mega|Ride"] = 788.62}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.59, ["Fly"] = 348.54, ["Ride"] = 274.66, ["Fly|Ride"] = 291.38, ["Neon"] = 702.19, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 1254.62, ["Mega"] = 6201.37, ["Mega|Fly|Ride"] = 2935.32}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.2, ["Fly"] = 29.81, ["Ride"] = 24.8, ["Fly|Ride"] = 48.88, ["Neon"] = 25.34, ["Neon|Fly"] = 132.69, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 206.72, ["Mega|Fly"] = 503.35, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 879.37, ["Fly"] = 2625, ["Ride"] = 874.12, ["Fly|Ride"] = 1027.39, ["Neon"] = 7158.38, ["Neon|Ride"] = 6063.9, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52371.8, ["Mega|Fly|Ride"] = 20173.62}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Fly"] = 69.11, ["Ride"] = 32.8, ["Fly|Ride"] = 85.32, ["Neon"] = 77.98, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 226.36, ["Mega"] = 482.68, ["Mega|Ride"] = 689.39, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 194.13, ["Fly|Ride"] = 210, ["Neon"] = 875.43, ["Neon|Ride"] = 689.39, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2483.61, ["Mega|Fly|Ride"] = 3004.57}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.3, ["Fly"] = 68.84, ["Ride"] = 52.29, ["Fly|Ride"] = 145.69, ["Neon"] = 82.41, ["Neon|Ride"] = 202.52, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 729.72}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 114.28, ["Ride"] = 128.63, ["Neon"] = 584.07, ["Neon|Ride"] = 496.12, ["Neon|Fly|Ride"] = 723.51, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 128.81, ["Ride"] = 143.07, ["Fly|Ride"] = 272.85, ["Neon"] = 437.21, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 1550.35, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1980.33}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 36.44}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.4, ["Fly"] = 59.16, ["Ride"] = 54.95, ["Fly|Ride"] = 82.95, ["Neon|Ride"] = 479.51, ["Neon|Fly|Ride"] = 315, ["Mega"] = 4134.24, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.46, ["Fly"] = 55.7, ["Ride"] = 41.32, ["Fly|Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 232.56, ["Mega"] = 166.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 275.98, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 597.03, ["Ride"] = 465.51, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 3720.83, ["Neon|Fly|Ride"] = 1506.75, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 82.68, ["Fly"] = 180.46, ["Ride"] = 105, ["Fly|Ride"] = 170.63, ["Neon"] = 446.25, ["Neon|Fly"] = 826.86, ["Neon|Ride"] = 577.26, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2467.13, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3713.04, ["Ride"] = 3433.5, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14468.82}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42.67, ["Fly"] = 110.35, ["Ride"] = 59.72, ["Fly|Ride"] = 128.41, ["Neon"] = 393.75, ["Neon|Ride"] = 289.42, ["Neon|Fly|Ride"] = 345.22, ["Mega|Ride"] = 1186.55, ["Mega|Fly|Ride"] = 1422.19}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 75.36, ["Ride"] = 77.89, ["Fly|Ride"] = 195.57, ["Neon"] = 410.42, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 683.76, ["Mega"] = 2756.52, ["Mega|Fly|Ride"] = 2765.23}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.4, ["Fly"] = 72.19, ["Ride"] = 55.7, ["Fly|Ride"] = 110.5, ["Neon"] = 130.28, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 227.17, ["Mega"] = 965.35, ["Mega|Ride"] = 689.39, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.93, ["Fly"] = 393.75, ["Ride"] = 52.5, ["Fly|Ride"] = 63.63, ["Neon"] = 361.76, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 297.95, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.64, ["Ride"] = 206.53, ["Fly|Ride"] = 315.98, ["Neon|Ride"] = 1396.59, ["Neon|Fly|Ride"] = 1378.78, ["Mega|Fly|Ride"] = 4966.02}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1100.23, ["Ride"] = 964.41, ["Fly|Ride"] = 996.19, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3018.74}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.54, ["Fly"] = 51.19, ["Ride"] = 39.31, ["Fly|Ride"] = 60.31, ["Neon"] = 183.99, ["Neon|Ride"] = 204.66, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 921.95}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6310.52, ["Fly|Ride"] = 4724.99, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40346.08}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.79, ["Fly"] = 74.82, ["Ride"] = 25.97, ["Fly|Ride"] = 54.57, ["Neon"] = 98.2, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 656.32, ["Mega|Ride"] = 590.06, ["Mega|Fly|Ride"] = 614.25}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.91, ["Fly"] = 41.26, ["Ride"] = 27.89, ["Fly|Ride"] = 115.08, ["Neon"] = 97.16, ["Neon|Ride"] = 132.6, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1035.82, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.7, ["Fly"] = 271.07, ["Ride"] = 72.18, ["Fly|Ride"] = 94.5, ["Neon|Ride"] = 383.46, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4134.24}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.76, ["Fly"] = 150.93, ["Ride"] = 26.25, ["Fly|Ride"] = 107.5, ["Neon"] = 74.82, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1378.78, ["Mega|Ride"] = 503.35, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1776.7, ["Fly"] = 2122.32, ["Ride"] = 1858.58, ["Fly|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 3465, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 28911.01, ["Fly|Ride"] = 25265.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65460.51, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.07, ["Fly"] = 393.74, ["Ride"] = 52.68, ["Fly|Ride"] = 89.94, ["Neon"] = 262.55, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 310.08, ["Mega"] = 965.35, ["Mega|Ride"] = 758.65, ["Mega|Fly|Ride"] = 822.73}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.68, ["Fly"] = 75.75, ["Ride"] = 43.32, ["Fly|Ride"] = 199.5, ["Neon"] = 19.02, ["Neon|Fly"] = 134.38, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 118.02, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.22}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 9.48, ["Ride"] = 44.41, ["Fly|Ride"] = 124.67, ["Neon"] = 65.13, ["Neon|Ride"] = 125.31, ["Neon|Fly|Ride"] = 465.11, ["Mega"] = 370.57, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 643.13, ["Ride"] = 735, ["Fly|Ride"] = 786.19, ["Neon"] = 3169.93, ["Neon|Fly|Ride"] = 2808.75, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 891.19, ["Fly"] = 962.07, ["Ride"] = 1005.71, ["Fly|Ride"] = 1006.7, ["Neon"] = 4134.24, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11367.11}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.75, ["Fly"] = 116.05, ["Ride"] = 28.88, ["Fly|Ride"] = 90.57, ["Neon"] = 103.95, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1136.93, ["Mega|Ride"] = 946.76, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.91}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.78, ["Fly"] = 93.19, ["Ride"] = 73.5, ["Fly|Ride"] = 108.94, ["Neon"] = 413.43, ["Neon|Ride"] = 408.28, ["Neon|Fly|Ride"] = 413.43, ["Mega|Ride"] = 2023.73, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 57.88, ["Ride"] = 77.22, ["Fly|Ride"] = 155.76, ["Neon"] = 345.22, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2082.86, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 27.85, ["Ride"] = 20, ["Fly|Ride"] = 51.32, ["Neon"] = 36.75, ["Neon|Fly"] = 525, ["Neon|Ride"] = 93.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 322.88, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 103.38, ["Fly"] = 136.5, ["Ride"] = 118.12, ["Fly|Ride"] = 190.04, ["Neon|Ride"] = 450.21, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1442.27}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.25, ["Ride"] = 47.52, ["Fly|Ride"] = 157.5, ["Neon"] = 39.38, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 481.66, ["Mega"] = 235.75, ["Mega|Ride"] = 399.2, ["Mega|Fly|Ride"] = 511.54}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.07, ["Fly"] = 41.11, ["Ride"] = 27.89, ["Fly|Ride"] = 90.87, ["Neon"] = 109.38, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 163.32, ["Mega|Fly|Ride"] = 758.65}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 33.32, ["Ride"] = 62.77, ["Fly|Ride"] = 156.19, ["Neon"] = 263.58, ["Neon|Ride"] = 330.75, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 694.25, ["Mega|Ride"] = 776.29, ["Mega|Fly|Ride"] = 826.86}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.48, ["Fly"] = 124.8, ["Ride"] = 28.88, ["Fly|Ride"] = 49.88, ["Neon"] = 91.88, ["Neon|Ride"] = 109.4, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 826.86, ["Mega|Ride"] = 930.22, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7194.01, ["Ride"] = 7141.32, ["Fly|Ride"] = 6685.88, ["Neon"] = 31006.8, ["Neon|Fly|Ride"] = 27425.52}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 247.03, ["Fly"] = 273, ["Ride"] = 245.41, ["Fly|Ride"] = 295.32, ["Neon|Fly|Ride"] = 543.38, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 36.02, ["Fly"] = 131.13, ["Ride"] = 82.69, ["Fly|Ride"] = 131.25, ["Neon"] = 90.57, ["Neon|Fly"] = 179.86, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 380.63, ["Mega|Ride"] = 407.96, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.49, ["Fly"] = 85.87, ["Ride"] = 23.63, ["Fly|Ride"] = 97.16, ["Neon"] = 23.16, ["Neon|Ride"] = 55.83, ["Neon|Fly|Ride"] = 188.12, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 44.62, ["Fly"] = 5259.75, ["Ride"] = 84, ["Fly|Ride"] = 190.89, ["Neon"] = 184.55, ["Neon|Fly"] = 334.88, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 435.75, ["Mega|Ride"] = 505.39, ["Mega|Fly|Ride"] = 643.79}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14385, ["Ride"] = 13415.07, ["Fly|Ride"] = 12598.59, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 163.96, ["Ride"] = 164.07, ["Fly|Ride"] = 367.96, ["Neon"] = 1378.78, ["Neon|Ride"] = 1446.99, ["Neon|Fly|Ride"] = 1446.99, ["Mega|Fly|Ride"] = 5085.13}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 61.68, ["Fly"] = 101.88, ["Ride"] = 74.71, ["Fly|Ride"] = 86.98, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2581.85}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.19, ["Fly"] = 44.1, ["Ride"] = 26.86, ["Fly|Ride"] = 55.55, ["Neon"] = 85.32, ["Neon|Ride"] = 78.57, ["Neon|Fly|Ride"] = 106.6, ["Mega"] = 469.26, ["Mega|Ride"] = 345.22, ["Mega|Fly|Ride"] = 345.22}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 824.92, ["Ride"] = 411.18, ["Fly|Ride"] = 471.7, ["Neon"] = 1706.25, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1552.56, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.76, ["Fly"] = 101.53, ["Ride"] = 38.07, ["Fly|Ride"] = 85.32, ["Neon"] = 27.57, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 133.88, ["Fly"] = 204.18, ["Ride"] = 161.44, ["Fly|Ride"] = 233.6, ["Neon"] = 764.86, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 3169.93}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.09, ["Fly"] = 15.47, ["Ride"] = 18.36, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 96.37, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 758.83}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 59.07, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 551.94, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1396.59}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.83, ["Fly"] = 102.1, ["Ride"] = 35.3, ["Fly|Ride"] = 86.52, ["Neon"] = 102.38, ["Neon|Ride"] = 74.26, ["Neon|Fly|Ride"] = 189, ["Mega"] = 515.75, ["Mega|Ride"] = 413.43, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 21}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 36.72, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 249.38, ["Neon"] = 238.76, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1102.82, ["Mega|Ride"] = 957.09, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.24, ["Ride"] = 29.23, ["Fly|Ride"] = 132.54, ["Neon"] = 22.66, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 267.71, ["Mega"] = 118.13, ["Mega|Ride"] = 211.83, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.9, ["Fly"] = 47.25, ["Ride"] = 36.15, ["Fly|Ride"] = 77.55, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 163.26, ["Mega|Ride"] = 576.75, ["Mega|Fly|Ride"] = 776.29}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.24, ["Ride"] = 433.13, ["Fly|Ride"] = 523.69, ["Neon|Fly|Ride"] = 2749.28, ["Mega|Fly|Ride"] = 13781.5}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.74, ["Fly"] = 103.13, ["Ride"] = 55.1, ["Fly|Ride"] = 103.69, ["Neon"] = 234.64, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 1011.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 824.79}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.97, ["Fly"] = 117.49, ["Ride"] = 91.67, ["Fly|Ride"] = 124.04, ["Neon|Ride"] = 318.35, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 723.51, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.6, ["Fly"] = 91.68, ["Ride"] = 66.94, ["Fly|Ride"] = 146.47, ["Neon"] = 131.25, ["Neon|Ride"] = 179.86, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 408.28, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 590.18}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 13273.32, ["Fly|Ride"] = 7599.37, ["Neon|Fly|Ride"] = 13778.63, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1706.25, ["Ride"] = 1575, ["Fly|Ride"] = 1488.38, ["Neon|Fly|Ride"] = 4305, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 518.44, ["Ride"] = 505.32, ["Fly|Ride"] = 525, ["Neon"] = 2260.55, ["Neon|Fly|Ride"] = 2377.2, ["Mega|Fly|Ride"] = 6749.16}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.5, ["Fly"] = 23.63, ["Ride"] = 23, ["Fly|Ride"] = 45.5, ["Neon"] = 110.6, ["Neon|Ride"] = 95.1, ["Neon|Fly|Ride"] = 138.11, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.59, ["Fly"] = 78.74, ["Ride"] = 31.46, ["Neon"] = 15.75, ["Neon|Ride"] = 68.69, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 133.58, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.5, ["Fly"] = 78.74, ["Ride"] = 51.19, ["Fly|Ride"] = 90.96, ["Neon"] = 204.66, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 161.17, ["Mega|Fly|Ride"] = 511.35}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 26.77, ["Ride"] = 16.44, ["Fly|Ride"] = 37.9, ["Neon"] = 27.8, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 84, ["Mega"] = 262.5, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 304.91}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 316.92, ["Fly|Ride"] = 274.32, ["Neon"] = 1004.41, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1169.44}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.91, ["Fly"] = 60.08, ["Ride"] = 32.82, ["Fly|Ride"] = 76.48, ["Neon"] = 208.68, ["Neon|Fly"] = 407.52, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 419.9, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.24, ["Fly"] = 18.37, ["Ride"] = 20.4, ["Fly|Ride"] = 43.39, ["Neon"] = 69.26, ["Neon|Fly"] = 132.66, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 586.58, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.45, ["Fly"] = 787.5, ["Ride"] = 435.74, ["Fly|Ride"] = 660.84, ["Neon|Ride"] = 2893.97, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 892.5, ["Fly"] = 1392.4, ["Ride"] = 1155, ["Fly|Ride"] = 1176, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 91.88, ["Fly"] = 128.63, ["Ride"] = 99.52, ["Fly|Ride"] = 118.12, ["Neon"] = 516.79, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 2343.09, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 127.84, ["Fly"] = 157.5, ["Ride"] = 197.23, ["Fly|Ride"] = 245.44, ["Neon"] = 577.5, ["Neon|Ride"] = 698.31, ["Neon|Fly|Ride"] = 597.19, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2577.71}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.24, ["Ride"] = 61.69, ["Fly|Ride"] = 275.7, ["Neon"] = 232.74, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega|Ride"] = 2067.13, ["Mega|Fly|Ride"] = 813.43}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 123.76, ["Ride"] = 206.53, ["Fly|Ride"] = 115.5, ["Neon|Fly|Ride"] = 1303.5, ["Mega|Fly|Ride"] = 3307.4}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2099.99, ["Fly"] = 2337.59, ["Ride"] = 2244.75, ["Fly|Ride"] = 2616.46, ["Neon|Fly|Ride"] = 10335.61, ["Mega|Fly|Ride"] = 24828.9}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 55.7, ["Ride"] = 68.97, ["Fly|Ride"] = 196.88, ["Neon"] = 351.43, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 442.38, ["Mega|Ride"] = 2273.84, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.46, ["Fly"] = 616.88, ["Ride"] = 590.62, ["Fly|Ride"] = 603.75, ["Neon|Ride"] = 1378.78, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 3108}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 46.92, ["Fly"] = 60.37, ["Ride"] = 52.5, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 360.8, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1102.82}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 31.35, ["Ride"] = 17.05, ["Fly|Ride"] = 50.68, ["Neon"] = 21, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 44.39, ["Neon|Fly|Ride"] = 97.16, ["Mega"] = 144.31, ["Mega|Ride"] = 219.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.26, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 689.39, ["Mega"] = 1511.07, ["Mega|Ride"] = 1378.78, ["Mega|Fly|Ride"] = 1240.29}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.77, ["Fly"] = 1015.3, ["Ride"] = 813.9, ["Fly|Ride"] = 826.87, ["Neon"] = 2480.56, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2214.55, ["Mega|Fly|Ride"] = 8957.87}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 623.7, ["Ride"] = 590.63, ["Fly|Ride"] = 872.82, ["Neon"] = 5167.81, ["Neon|Fly|Ride"] = 4124.95, ["Mega|Fly|Ride"] = 15296.69}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.55, ["Fly"] = 26.25, ["Ride"] = 23.77, ["Fly|Ride"] = 49.81, ["Neon"] = 186.06, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 4.14, ["Ride"] = 23.55, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 101.27, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 508.52, ["Mega|Ride"] = 508.52, ["Mega|Fly|Ride"] = 388.63}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.99, ["Ride"] = 24.92, ["Fly|Ride"] = 111.46, ["Neon"] = 20.99, ["Neon|Fly"] = 310.69, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 152.99, ["Mega"] = 141.63, ["Mega|Fly"] = 528.39, ["Mega|Ride"] = 220, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 46.1, ["Fly"] = 85.32, ["Ride"] = 45.9, ["Fly|Ride"] = 87.02, ["Neon"] = 210, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 206.72, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 61.69, ["Ride"] = 69.2, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 499.23, ["Neon|Fly|Ride"] = 689.39, ["Mega"] = 1550.35, ["Mega|Ride"] = 1550.35, ["Mega|Fly|Ride"] = 1330.21}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 10.5, ["Fly"] = 55.48, ["Ride"] = 34.04, ["Fly|Ride"] = 78.66, ["Neon"] = 72.19, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 340.28, ["Mega|Ride"] = 403.86, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.82, ["Ride"] = 46.4, ["Fly|Ride"] = 83.16, ["Neon"] = 551.94, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 2100, ["Mega|Ride"] = 965.35, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.9, ["Fly"] = 27.83, ["Ride"] = 16.62, ["Fly|Ride"] = 40.68, ["Neon"] = 34.29, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 275.98, ["Mega|Fly|Ride"] = 317.31}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.25, ["Fly"] = 32.49, ["Ride"] = 28.58, ["Fly|Ride"] = 80.88, ["Neon"] = 25.95, ["Neon|Fly"] = 155.97, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 446.52, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.34, ["Fly"] = 65.62, ["Ride"] = 51.17, ["Fly|Ride"] = 89.45, ["Neon"] = 403.77, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 1018.87}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1600.89, ["Fly"] = 2623.21, ["Ride"] = 1389.84, ["Fly|Ride"] = 1442.7, ["Neon|Fly"] = 4712.42, ["Neon|Ride"] = 4686.18, ["Neon|Fly|Ride"] = 3739.32, ["Mega|Fly|Ride"] = 13190.72}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 456.75, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3032.48, ["Neon|Fly|Ride"] = 3000.44, ["Mega|Fly|Ride"] = 9645.19}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 252, ["Fly"] = 287.06, ["Ride"] = 267.75, ["Fly|Ride"] = 433.13, ["Neon|Fly|Ride"] = 1378.78, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.56, ["Ride"] = 41.9, ["Fly|Ride"] = 96.33, ["Neon"] = 330.47, ["Neon|Fly"] = 413.43, ["Neon|Ride"] = 353.5, ["Neon|Fly|Ride"] = 317.31, ["Mega"] = 1241.82, ["Mega|Ride"] = 965.35, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41245.12, ["Fly"] = 65625, ["Ride"] = 34869.36, ["Fly|Ride"] = 17823.75, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 342.22, ["Fly"] = 362.09, ["Ride"] = 315, ["Fly|Ride"] = 387.19, ["Neon"] = 1376.71, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1074.91, ["Mega"] = 6201.37, ["Mega|Fly|Ride"] = 3845.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 168, ["Fly"] = 525, ["Ride"] = 165.38, ["Fly|Ride"] = 172.05, ["Mega|Fly|Ride"] = 4134.24}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.59, ["Fly"] = 262.5, ["Ride"] = 122.79, ["Fly|Ride"] = 178.5, ["Neon"] = 698.15, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 551.94, ["Mega|Fly|Ride"] = 2479.53}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 94.5, ["Ride"] = 32.48, ["Fly|Ride"] = 104.63, ["Neon"] = 275.98, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 689.39, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 516.79}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4812.28, ["Ride"] = 4649.26, ["Fly|Ride"] = 4067.44, ["Neon|Fly|Ride"] = 27561.95, ["Mega|Fly|Ride"] = 62071.05}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.61, ["Fly"] = 48.57, ["Ride"] = 32.71, ["Fly|Ride"] = 53.8, ["Neon"] = 229.47, ["Neon|Ride"] = 206.72, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1378.78, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.31, ["Fly"] = 138.18, ["Ride"] = 43.32, ["Fly|Ride"] = 107.61, ["Neon"] = 403.96, ["Neon|Ride"] = 268.74, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1552.56, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 731.07, ["Fly"] = 918.75, ["Ride"] = 733.69, ["Fly|Ride"] = 813.75, ["Neon"] = 2792.54, ["Neon|Ride"] = 2205, ["Neon|Fly|Ride"] = 2218.13, ["Mega"] = 9081.91, ["Mega|Fly|Ride"] = 7218.75}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.52, ["Fly"] = 33.69, ["Ride"] = 26.16, ["Fly|Ride"] = 41.3, ["Neon"] = 131.25, ["Neon|Fly"] = 155.97, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 156, ["Mega|Fly|Ride"] = 620.15}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.48, ["Fly"] = 96.94, ["Ride"] = 30.92, ["Fly|Ride"] = 465.44, ["Neon"] = 80.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 179.86, ["Mega|Ride"] = 524.03, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 86.84, ["Ride"] = 115.5, ["Fly|Ride"] = 295.24, ["Neon"] = 536.43, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 721.59, ["Mega|Fly|Ride"] = 2483.61}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.5, ["Fly"] = 105.19, ["Ride"] = 78.63, ["Fly|Ride"] = 131.25, ["Neon"] = 82.69, ["Neon|Fly"] = 114.75, ["Neon|Ride"] = 128.68, ["Neon|Fly|Ride"] = 264.77, ["Mega"] = 275.63, ["Mega|Fly"] = 739.04, ["Mega|Ride"] = 275.98, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3977.95, ["Ride"] = 3937.5, ["Fly|Ride"] = 3740.63, ["Neon"] = 12402.72, ["Neon|Ride"] = 13965.82, ["Neon|Fly|Ride"] = 9016.88, ["Mega"] = 62011.52, ["Mega|Fly|Ride"] = 32800.03}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 64.3, ["Fly|Ride"] = 108.66, ["Neon"] = 205.7, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 413.43, ["Mega|Ride"] = 1032.54, ["Mega|Fly|Ride"] = 1226.86}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Ride"] = 7847.28, ["Fly|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 16829.43, ["Mega|Fly|Ride"] = 68277.7}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.68, ["Fly"] = 20.89, ["Ride"] = 16.28, ["Fly|Ride"] = 41.67, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 334.03, ["Mega|Ride"] = 193.3, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.69, ["Fly"] = 26.16, ["Ride"] = 26.25, ["Fly|Ride"] = 47.52, ["Neon"] = 138.51, ["Neon|Ride"] = 192.26, ["Neon|Fly|Ride"] = 156.08, ["Mega|Ride"] = 965.35, ["Mega|Fly|Ride"] = 931.06}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.52}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.44, ["Fly"] = 39.38, ["Ride"] = 37.93, ["Fly|Ride"] = 115.5, ["Neon"] = 183.74, ["Neon|Ride"] = 157.68, ["Mega"] = 770.6, ["Mega|Ride"] = 965.35, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 29.46, ["Fly"] = 190.37, ["Ride"] = 44.62, ["Fly|Ride"] = 138.37, ["Neon"] = 190.19, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 279.67, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.62, ["Fly"] = 23.55, ["Ride"] = 23.28, ["Fly|Ride"] = 35.09, ["Neon"] = 82.7, ["Neon|Ride"] = 114.75, ["Neon|Fly|Ride"] = 175.17, ["Mega"] = 786.19, ["Mega|Ride"] = 580.76, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8352.16}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.64}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 131.24, ["Fly"] = 344.42, ["Ride"] = 155.76, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1033.57}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.18, ["Fly"] = 123.76, ["Ride"] = 47.25, ["Fly|Ride"] = 105, ["Neon"] = 180.89, ["Neon|Ride"] = 155.05, ["Neon|Fly|Ride"] = 205.7, ["Mega|Ride"] = 931.06, ["Mega|Fly|Ride"] = 950.9}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.22}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.46, ["Ride"] = 29.22, ["Fly|Ride"] = 69.26, ["Neon"] = 81.67, ["Neon|Ride"] = 69.26, ["Mega|Fly|Ride"] = 826.86}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3045}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 150.82, ["Fly"] = 412.47, ["Ride"] = 199.5, ["Fly|Ride"] = 196.88, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 758.65, ["Mega|Ride"] = 2893.97, ["Mega|Fly|Ride"] = 3032.48}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 153.18, ["Ride"] = 142.97, ["Fly|Ride"] = 211.32, ["Neon"] = 551.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2756.52, ["Mega|Fly|Ride"] = 2483.61}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 163.86, ["Fly"] = 186.62, ["Ride"] = 207.38, ["Fly|Ride"] = 246.89, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 954.35, ["Mega|Fly|Ride"] = 3138.71}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1732.4, ["Fly"] = 2474.72, ["Ride"] = 1708.72, ["Fly|Ride"] = 1312.5, ["Neon"] = 14517.4, ["Neon|Ride"] = 6476.3, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 31035.54}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.01, ["Fly"] = 80.45, ["Ride"] = 39.41, ["Fly|Ride"] = 93.98, ["Neon"] = 156.08, ["Neon|Fly"] = 116.38, ["Neon|Ride"] = 204.66, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 929.18, ["Mega|Ride"] = 899.21, ["Mega|Fly|Ride"] = 1093.52}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 796.73, ["Fly"] = 2100, ["Ride"] = 590.63, ["Fly|Ride"] = 887.99, ["Neon|Ride"] = 2638.38, ["Neon|Fly|Ride"] = 4034.97}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 37.95}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.65, ["Ride"] = 48.47, ["Fly|Ride"] = 138.37, ["Neon"] = 99.75, ["Neon|Ride"] = 124.04, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 413.43, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 482.68}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.54, ["Fly"] = 48.48, ["Ride"] = 26.19, ["Fly|Ride"] = 44.18, ["Neon"] = 52.5, ["Neon|Ride"] = 78.62, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 918.75, ["Mega|Ride"] = 346.26, ["Mega|Fly|Ride"] = 357.31}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 53.69}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.6, ["Fly"] = 108.92, ["Ride"] = 31.29, ["Fly|Ride"] = 55.61, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 193.3, ["Mega"] = 918.75, ["Mega|Ride"] = 826.86, ["Mega|Fly|Ride"] = 1396.59}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 52.07, ["Neon|Ride"] = 304.91, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 826.86, ["Mega|Ride"] = 1745.75, ["Mega|Fly|Ride"] = 826.86}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10978.57, ["Ride"] = 4987.5, ["Fly|Ride"] = 5046.57, ["Neon|Fly|Ride"] = 10475.33, ["Mega|Fly|Ride"] = 35537.18}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.48, ["Fly"] = 46.88, ["Ride"] = 35.34, ["Fly|Ride"] = 93.1, ["Neon"] = 64.81, ["Neon|Ride"] = 78.6, ["Mega"] = 521.4, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 128.57, ["Fly"] = 365.04, ["Ride"] = 134.89, ["Fly|Ride"] = 170.63, ["Neon"] = 485.63, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 702.83, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1930.7}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.18, ["Fly"] = 96.94, ["Ride"] = 69.2, ["Fly|Ride"] = 165.39, ["Neon"] = 232.73, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 465.53, ["Mega"] = 2327.64, ["Mega|Ride"] = 2790.63, ["Mega|Fly|Ride"] = 1516.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.43, ["Fly"] = 70.46, ["Ride"] = 33.12, ["Fly|Ride"] = 66.17, ["Neon"] = 161.44, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 1016.21, ["Mega|Ride"] = 813.43, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.45, ["Fly"] = 58.79, ["Ride"] = 27.57, ["Fly|Ride"] = 59.9, ["Neon"] = 32.69, ["Neon|Ride"] = 56.48, ["Neon|Fly|Ride"] = 164.35, ["Mega"] = 157.49, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 217.55, ["Mega|Fly|Ride"] = 310.13}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.03, ["Fly"] = 138.18, ["Ride"] = 27.84, ["Fly|Ride"] = 64.32, ["Neon"] = 82.36, ["Neon|Ride"] = 124.04, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 515.75, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.4, ["Fly"] = 28.88, ["Ride"] = 26.86, ["Fly|Ride"] = 50.71, ["Neon"] = 204.66, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.88}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.45, ["Ride"] = 97.07, ["Neon"] = 177.19, ["Neon|Ride"] = 826.86, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 275.34, ["Fly"] = 464.15, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.54, ["Neon"] = 1102.82}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.38, ["Fly"] = 212.02, ["Ride"] = 91.88, ["Fly|Ride"] = 178.5, ["Neon"] = 249.38, ["Neon|Ride"] = 413.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 905.51, ["Mega|Ride"] = 2149.59, ["Mega|Fly|Ride"] = 1396.59}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1183.74, ["Ride"] = 935.29, ["Fly|Ride"] = 992.25, ["Neon|Fly"] = 4025.91, ["Neon|Ride"] = 3142.04, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11645.12}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 288.75, ["Fly"] = 464.15, ["Ride"] = 346.5, ["Fly|Ride"] = 393.74, ["Neon"] = 2834.27, ["Neon|Ride"] = 1102.82, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 8132.25, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.61}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.59, ["Fly"] = 34.37, ["Ride"] = 23.54, ["Fly|Ride"] = 52.48, ["Neon"] = 78.73, ["Neon|Fly"] = 116.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 688.37, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 301.88, ["Fly"] = 762.36, ["Ride"] = 301.88, ["Fly|Ride"] = 428.73, ["Neon"] = 1086.29, ["Neon|Ride"] = 891.19, ["Neon|Fly|Ride"] = 965.35, ["Mega|Ride"] = 3307.4, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 119.62, ["Fly"] = 138.18, ["Ride"] = 211.1, ["Fly|Ride"] = 310.35, ["Neon"] = 674.14, ["Neon|Fly"] = 1723.99, ["Neon|Ride"] = 675.03, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9922.18, ["Mega|Ride"] = 11757.79, ["Mega|Fly|Ride"] = 2665.14}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 130.96, ["Ride"] = 128.76, ["Fly|Ride"] = 200.52, ["Neon"] = 675.96, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 930.22, ["Mega|Fly|Ride"] = 2426.82}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 30.84, ["Fly|Ride"] = 73.32, ["Neon"] = 33.76, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 191.62, ["Mega"] = 264.75, ["Mega|Ride"] = 206.72, ["Mega|Fly|Ride"] = 806.19}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 18.38, ["Fly"] = 63, ["Ride"] = 27.82, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 110.6, ["Neon|Fly|Ride"] = 280.77, ["Mega|Ride"] = 804.12, ["Mega|Fly|Ride"] = 582.94}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.69, ["Fly"] = 102.31, ["Ride"] = 39.38, ["Fly|Ride"] = 128.84, ["Neon"] = 124.04, ["Neon|Ride"] = 130.87, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 455.82, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 688.37}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.14, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 138.51, ["Neon"] = 25.02, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 155.29, ["Mega"] = 161.43, ["Mega|Fly"] = 239.8, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.94, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1622.71, ["Neon|Ride"] = 1447.8, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5237.06}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 128.63, ["Fly"] = 550.65, ["Ride"] = 183.75, ["Fly|Ride"] = 291.1, ["Neon"] = 812.39, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 771.75, ["Mega"] = 9922.18, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2736.57}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 76.96, ["Fly"] = 167.45, ["Ride"] = 101.73, ["Fly|Ride"] = 181.13, ["Neon"] = 413.43, ["Neon|Ride"] = 411.37, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1364.31}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.81, ["Ride"] = 69.2, ["Fly|Ride"] = 275.98, ["Neon|Ride"] = 591.24, ["Neon|Fly|Ride"] = 482.68, ["Mega|Ride"] = 408.5, ["Mega|Fly|Ride"] = 1653.7}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.7, ["Fly"] = 75.63, ["Ride"] = 40.28, ["Fly|Ride"] = 82.62, ["Neon"] = 77.44, ["Neon|Fly"] = 206.72, ["Neon|Ride"] = 99.47, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 357.62, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.57, ["Fly"] = 47.45, ["Ride"] = 19.48, ["Fly|Ride"] = 81.33, ["Neon"] = 19.37, ["Neon|Ride"] = 41.01, ["Neon|Fly|Ride"] = 130.76, ["Mega"] = 131.25, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 936.78, ["Fly"] = 1072.39, ["Ride"] = 964.41, ["Fly|Ride"] = 1004.07, ["Neon"] = 3039.12, ["Neon|Fly"] = 3414.65, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7679.44}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 362.24, ["Ride"] = 389.03, ["Fly|Ride"] = 524.03, ["Neon|Ride"] = 2756.52, ["Neon|Fly|Ride"] = 1930.7, ["Mega"] = 10335.61, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 77.76, ["Fly"] = 105, ["Ride"] = 103.69, ["Fly|Ride"] = 193.3, ["Neon"] = 249.38, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 388.73, ["Mega"] = 1582.82, ["Mega|Ride"] = 1653.7, ["Mega|Fly|Ride"] = 1771.53}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 379.46, ["Ride"] = 295.42, ["Fly|Ride"] = 274.32, ["Neon|Ride"] = 1396.59, ["Neon|Fly|Ride"] = 1061.49, ["Mega"] = 10335.61, ["Mega|Fly|Ride"] = 5085.13}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 22.65, ["Fly"] = 138.18, ["Ride"] = 31.39, ["Fly|Ride"] = 69.44, ["Neon"] = 131.25, ["Neon|Ride"] = 103.37, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 768.13}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.89, ["Ride"] = 275.7, ["Fly|Ride"] = 549.87, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4113.87, ["Mega|Ride"] = 4272.75, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.88, ["Fly"] = 76.13, ["Ride"] = 39.38, ["Fly|Ride"] = 130.6, ["Neon|Ride"] = 496.12, ["Neon|Fly|Ride"] = 551.94, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1674.75, ["Ride"] = 1675.16, ["Fly|Ride"] = 1749.14, ["Neon|Ride"] = 10863.09, ["Neon|Fly|Ride"] = 5059.29, ["Mega"] = 49610.87, ["Mega|Fly|Ride"] = 21911.48}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.44, ["Fly"] = 85.87, ["Ride"] = 51.8, ["Fly|Ride"] = 104.73, ["Neon"] = 61, ["Neon|Fly"] = 185.22, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 217.65, ["Mega"] = 252.2, ["Mega|Fly"] = 372.44, ["Mega|Ride"] = 314.62, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 47.48, ["Fly"] = 119.1, ["Ride"] = 74.36, ["Fly|Ride"] = 157.5, ["Neon"] = 274.82, ["Neon|Ride"] = 280.11, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 887.85, ["Mega|Ride"] = 1011.87, ["Mega|Fly|Ride"] = 1009.04}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 81.24, ["Fly"] = 91.76, ["Ride"] = 77.44, ["Fly|Ride"] = 110.5, ["Neon|Ride"] = 455.82, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 1516.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1375.55, ["Ride"] = 836.37, ["Fly|Ride"] = 1170.75, ["Neon|Fly|Ride"] = 7441.64, ["Mega|Fly|Ride"] = 20793.94}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 617.31, ["Fly"] = 822.86, ["Ride"] = 598.88, ["Fly|Ride"] = 671.83, ["Neon|Fly|Ride"] = 2716.37, ["Mega|Fly|Ride"] = 17070.89}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 84, ["Ride"] = 115.5, ["Fly|Ride"] = 196.88, ["Neon"] = 444.29, ["Neon|Fly"] = 620.15, ["Neon|Ride"] = 455.82, ["Neon|Fly|Ride"] = 551.94, ["Mega"] = 4134.24, ["Mega|Ride"] = 2611.82, ["Mega|Fly|Ride"] = 2343.09}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.49, ["Ride"] = 20.87, ["Fly|Ride"] = 60.94, ["Neon"] = 69.83, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 186.23, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1378.78}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 102.13, ["Ride"] = 48.42, ["Fly|Ride"] = 106.72, ["Neon"] = 199.5, ["Neon|Fly"] = 413.43, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 312.15, ["Mega|Ride"] = 1198.95, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 714.66, ["Ride"] = 826.05, ["Fly|Ride"] = 892.5, ["Neon"] = 3030.41, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 15160.27}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 853.13}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5910.44, ["Ride"] = 6044.05, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29622.87, ["Neon|Fly|Ride"] = 24117.1, ["Mega|Fly|Ride"] = 88197.79}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 244.13, ["Fly"] = 406.82, ["Ride"] = 304.61, ["Fly|Ride"] = 367.5, ["Neon"] = 1653.7, ["Neon|Fly|Ride"] = 2067.13, ["Mega"] = 5787.94, ["Mega|Fly|Ride"] = 5926.45}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 65.33, ["Fly"] = 275.34, ["Ride"] = 99.14, ["Fly|Ride"] = 336, ["Neon"] = 411.37, ["Neon|Ride"] = 610.28, ["Neon|Fly|Ride"] = 1653.7, ["Mega|Fly|Ride"] = 2879.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 96.94, ["Ride"] = 36.15, ["Fly|Ride"] = 72.29, ["Neon"] = 110.6, ["Neon|Fly"] = 1241.52, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 660.47, ["Mega|Ride"] = 721.44, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.8, ["Fly"] = 39.38, ["Ride"] = 26.7, ["Fly|Ride"] = 44.34, ["Neon"] = 206.72, ["Neon|Fly"] = 275.98, ["Neon|Ride"] = 310.76, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 1312.5, ["Mega|Ride"] = 1593.77, ["Mega|Fly|Ride"] = 2191.17}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.46, ["Fly"] = 275.34, ["Ride"] = 41.32, ["Fly|Ride"] = 140.44, ["Neon"] = 154.88, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 148.84, ["Mega"] = 551.94, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 20.99, ["Fly|Ride"] = 52.5, ["Neon"] = 19.46, ["Neon|Fly"] = 341.1, ["Neon|Ride"] = 49.63, ["Neon|Fly|Ride"] = 186.23, ["Mega"] = 275.98, ["Mega|Ride"] = 234.64, ["Mega|Fly|Ride"] = 310.76}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.37, ["Ride"] = 43.31, ["Fly|Ride"] = 183.75, ["Neon"] = 165.39, ["Neon|Fly"] = 826.86, ["Neon|Ride"] = 223.27, ["Neon|Fly|Ride"] = 328.83, ["Mega"] = 663.55, ["Mega|Ride"] = 661.49, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 315, ["Fly"] = 454.74, ["Ride"] = 371.73, ["Fly|Ride"] = 429.19, ["Neon"] = 1207.5, ["Neon|Fly"] = 1463.54, ["Neon|Ride"] = 1226.86, ["Neon|Fly|Ride"] = 1237.69, ["Mega"] = 7875, ["Mega|Fly"] = 4546.64, ["Mega|Ride"] = 4134.24, ["Mega|Fly|Ride"] = 4603.5}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.49, ["Fly"] = 15.64, ["Ride"] = 15.36, ["Fly|Ride"] = 45.45, ["Neon"] = 19.67, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 465.11, ["Mega|Ride"] = 206.72, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.12, ["Fly"] = 92.81, ["Ride"] = 82.69, ["Fly|Ride"] = 115.48, ["Neon"] = 170.63, ["Neon|Fly"] = 289.27, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 260.93, ["Mega"] = 577.5, ["Mega|Fly"] = 826.86, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 777.67, ["Fly"] = 974.68, ["Ride"] = 768.93, ["Fly|Ride"] = 800.63, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1442.44, ["Mega|Fly|Ride"] = 3777.38}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.49, ["Fly"] = 91.88, ["Ride"] = 44.18, ["Fly|Ride"] = 73.48, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 221.58, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.88, ["Fly"] = 324.84, ["Ride"] = 275.7, ["Fly|Ride"] = 328.13, ["Neon|Fly|Ride"] = 1101.79, ["Mega|Fly|Ride"] = 13965.82}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 145.67, ["Fly"] = 241.37, ["Ride"] = 190.3, ["Fly|Ride"] = 198.19, ["Neon"] = 627.29, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 689.07, ["Mega|Fly|Ride"] = 3293.97}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 713.1, ["Ride"] = 682.5, ["Fly|Ride"] = 816, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2867.11, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.58, ["Ride"] = 43.21, ["Fly|Ride"] = 108.9, ["Neon"] = 78.08, ["Neon|Fly"] = 279.27, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 349.36, ["Mega|Ride"] = 353.96, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3590.9, ["Ride"] = 3876.32, ["Fly|Ride"] = 3022.69, ["Neon|Fly|Ride"] = 5946.91, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 105, ["Fly"] = 131.25, ["Ride"] = 138.18, ["Fly|Ride"] = 152.99, ["Neon"] = 549.87, ["Neon|Ride"] = 551.94, ["Neon|Fly|Ride"] = 413.43, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.47, ["Fly"] = 20.56, ["Ride"] = 16.96, ["Fly|Ride"] = 45.48, ["Neon"] = 23.63, ["Neon|Fly"] = 63.5, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 144.42, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 165.39, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.77, ["Ride"] = 27.89, ["Fly|Ride"] = 58.2, ["Neon"] = 23.99, ["Neon|Ride"] = 67.52, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 159.88, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 38.33, ["Fly"] = 152.62, ["Ride"] = 40.7, ["Fly|Ride"] = 51.97, ["Neon|Ride"] = 289.42, ["Neon|Fly|Ride"] = 304.91, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1027.69, ["Fly|Ride"] = 1233.75, ["Neon"] = 5167.81, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5775, ["Ride"] = 7051.76, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.63, ["Fly"] = 45.27, ["Ride"] = 27.76, ["Fly|Ride"] = 43.3, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 186.23, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.4, ["Fly"] = 31.5, ["Ride"] = 32.22, ["Fly|Ride"] = 88.51, ["Neon"] = 93.19, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 642.48, ["Mega|Ride"] = 613.35, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.53, ["Fly"] = 157.49, ["Ride"] = 62.9, ["Fly|Ride"] = 111.57, ["Neon"] = 459.38, ["Neon|Ride"] = 343.16, ["Neon|Fly|Ride"] = 305.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 189.52, ["Ride"] = 234.94, ["Fly|Ride"] = 275.7, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10335.61, ["Mega|Fly|Ride"] = 3706.36}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.6, ["Fly"] = 20.9, ["Ride"] = 34.13, ["Fly|Ride"] = 60.45, ["Neon"] = 23.29, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 132.57, ["Mega|Ride"] = 164.42, ["Mega|Fly|Ride"] = 299.75}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 185.07, ["Fly"] = 247.49, ["Ride"] = 239.54, ["Fly|Ride"] = 259.88, ["Neon"] = 893.02, ["Neon|Ride"] = 915.93, ["Neon|Fly|Ride"] = 947.63, ["Mega|Fly|Ride"] = 3582.33}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.82, ["Fly"] = 45.29, ["Ride"] = 15.75, ["Fly|Ride"] = 40.07, ["Neon"] = 23.99, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 31.63, ["Neon|Fly|Ride"] = 107.5, ["Mega"] = 257.22, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 268.82, ["Ride"] = 223.13, ["Fly|Ride"] = 234.64, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10335.61, ["Mega|Ride"] = 4134.24, ["Mega|Fly|Ride"] = 4107.38}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.5, ["Fly"] = 70.4, ["Ride"] = 26.79, ["Fly|Ride"] = 52.5, ["Neon"] = 62.68, ["Neon|Fly"] = 295.56, ["Neon|Ride"] = 98.2, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 620.15, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 69.11, ["Ride"] = 22.23, ["Fly|Ride"] = 59.07, ["Neon"] = 11.21, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.27, ["Neon|Fly|Ride"] = 176.79, ["Mega"] = 74.37, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 255.29}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.84, ["Neon|Ride"] = 41.35, ["Mega"] = 31.44, ["Mega|Ride"] = 147.95}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.84, ["Fly"] = 52.48, ["Ride"] = 30.19, ["Fly|Ride"] = 214.99, ["Neon"] = 6.14, ["Neon|Ride"] = 39.21, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 57.66, ["Mega|Fly"] = 155176.45, ["Mega|Ride"] = 86.1, ["Mega|Fly|Ride"] = 159.96}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 63.95, ["Fly"] = 139.26, ["Ride"] = 114.86, ["Fly|Ride"] = 131.25, ["Neon"] = 264.57, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 368.55, ["Mega|Ride"] = 1322.97, ["Mega|Fly|Ride"] = 1074.24}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 98.3, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 73.34, ["Mega"] = 124.04, ["Mega|Ride"] = 123.36, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 15.71, ["Ride"] = 158.09, ["Neon"] = 71.92, ["Neon|Ride"] = 210, ["Mega|Ride"] = 543.66, ["Mega|Fly|Ride"] = 648.06}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 45.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 19.45, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.26, ["Ride"] = 14.49, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 30.77, ["Mega"] = 13.77, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 19.05, ["Mega|Fly|Ride"] = 47.7}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.61, ["Ride"] = 12.47, ["Fly|Ride"] = 37.3, ["Neon"] = 2.1, ["Neon|Fly"] = 18.47, ["Neon|Ride"] = 15.51, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Fly"] = 155.97, ["Mega|Ride"] = 33.5, ["Mega|Fly|Ride"] = 95.71}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.72, ["Neon"] = 2.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.7, ["Mega"] = 21, ["Mega|Ride"] = 117.03}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.68, ["Fly|Ride"] = 107.63, ["Neon"] = 2.43, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 24.45, ["Mega|Fly"] = 89.94, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Fly|Ride"] = 205.7, ["Mega"] = 20.34, ["Mega|Ride"] = 776.29}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 20.11, ["Fly|Ride"] = 70.12, ["Neon"] = 7.88, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 87.84, ["Mega|Fly"] = 167.83, ["Mega|Ride"] = 87.72, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.52, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 14.07, ["Mega|Ride"] = 37.21, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 138.51, ["Mega|Fly"] = 315, ["Mega|Ride"] = 345.22, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 11.46, ["Neon|Ride"] = 30.8, ["Mega"] = 105, ["Mega|Ride"] = 103.37, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 5.25, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 136.44, ["Mega"] = 20.48, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.36, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 27.92, ["Neon|Ride"] = 12.97, ["Neon|Fly|Ride"] = 24.83, ["Mega"] = 15.03, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.93, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 33.15, ["Neon|Ride"] = 140.95, ["Mega"] = 262.55, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Neon"] = 4.41, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.33, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 53.48, ["Mega|Fly|Ride"] = 124.04}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 10, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 82.51, ["Mega|Ride"] = 150.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.41, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 12.79, ["Neon|Fly"] = 103.37, ["Neon|Fly|Ride"] = 146.78, ["Mega"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.38, ["Ride"] = 15.5, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 15.37, ["Neon|Ride"] = 12.05, ["Neon|Fly|Ride"] = 26.86, ["Mega"] = 15.75, ["Mega|Fly"] = 31.44, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 19.69, ["Fly|Ride"] = 136.44, ["Neon"] = 14.43, ["Neon|Ride"] = 111.74, ["Neon|Fly|Ride"] = 109.58, ["Mega"] = 78.75, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.89, ["Fly"] = 65.63, ["Ride"] = 21.11, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 48.4, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 236.25, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 12.99, ["Fly|Ride"] = 26.17, ["Neon"] = 3.68, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 45.04, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 42.6, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 4.2, ["Fly"] = 172.22, ["Ride"] = 28.73, ["Neon"] = 5.25, ["Neon|Ride"] = 41.35, ["Neon|Fly|Ride"] = 97.06, ["Mega"] = 68.06, ["Mega|Fly"] = 165.39, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 361.76}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.86, ["Fly|Ride"] = 82.7, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 27.92, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 232.78}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.35, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 16.68, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 135.35}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.94, ["Ride"] = 22.32, ["Fly|Ride"] = 41.91, ["Neon"] = 2.63, ["Neon|Fly"] = 52.73, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 55.83, ["Mega"] = 77.35, ["Mega|Ride"] = 78.57, ["Mega|Fly|Ride"] = 200.52}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Neon"] = 3.81, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 97.16, ["Mega"] = 39.38, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 3.84, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.08, ["Ride"] = 68.16, ["Neon"] = 36.66, ["Mega"] = 128.68, ["Mega|Fly"] = 380.63, ["Mega|Ride"] = 206.72, ["Mega|Fly|Ride"] = 826.86}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 3.72, ["Ride"] = 16.99, ["Fly|Ride"] = 138.51, ["Neon"] = 30.81, ["Neon|Fly"] = 104.25, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 236.25, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 7.88, ["Fly"] = 22.7, ["Ride"] = 19.59, ["Fly|Ride"] = 39, ["Neon"] = 16.37, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.31, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 274.66, ["Mega|Fly"] = 412.4, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.41, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 55.11, ["Mega"] = 177.28, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.5, ["Ride"] = 131.25, ["Neon"] = 110.06, ["Neon|Ride"] = 232.78, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.68, ["Ride"] = 64.89, ["Neon"] = 38.89, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 214.99}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.3, ["Ride"] = 31.5, ["Fly|Ride"] = 120.75, ["Neon"] = 47.76, ["Neon|Ride"] = 156.19, ["Mega"] = 223.13, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Neon|Ride"] = 64.99, ["Mega"] = 22.23, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 148.84}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 46.72}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 7.67, ["Fly"] = 22.11, ["Ride"] = 20.67, ["Fly|Ride"] = 40.68, ["Neon"] = 34.04, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 101.27, ["Mega"] = 275.98, ["Mega|Fly"] = 330.75, ["Mega|Ride"] = 279.33, ["Mega|Fly|Ride"] = 253.43}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.54, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Ride"] = 26.61, ["Neon|Fly|Ride"] = 69.26, ["Mega"] = 24.94, ["Mega|Fly"] = 138.51, ["Mega|Ride"] = 55.73, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.61, ["Fly|Ride"] = 275.7, ["Neon"] = 3.83, ["Neon|Ride"] = 33.65, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 38.66, ["Mega|Ride"] = 69.97, ["Mega|Fly|Ride"] = 185.39}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.61, ["Fly"] = 48.44, ["Ride"] = 15.67, ["Fly|Ride"] = 47.56, ["Neon"] = 6.08, ["Neon|Fly"] = 33.09, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 141.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.94, ["Ride"] = 39.25, ["Fly|Ride"] = 58.92, ["Neon"] = 35.03, ["Neon|Ride"] = 82.27, ["Neon|Fly|Ride"] = 212.24, ["Mega"] = 328.13, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 13.65, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.64, ["Ride"] = 16.05, ["Fly|Ride"] = 275616.26, ["Neon"] = 6.55, ["Neon|Fly"] = 69.26, ["Neon|Ride"] = 27.96, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 35.09, ["Mega|Ride"] = 47.93, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 14.76, ["Fly|Ride"] = 34.13, ["Neon"] = 5.16, ["Neon|Fly"] = 69.26, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 36.75, ["Mega|Fly"] = 138.51, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 202.52}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 51.19, ["Fly|Ride"] = 147.78, ["Neon"] = 3.92, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 158.45, ["Mega"] = 23.05, ["Mega|Fly"] = 103.37, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.55, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 123, ["Mega"] = 21, ["Mega|Fly"] = 106.32, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 18.17, ["Fly|Ride"] = 77.53, ["Neon"] = 3.29, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 65, ["Mega"] = 18.27, ["Mega|Fly"] = 62.03, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 2.1, ["Neon|Ride"] = 69.26, ["Mega"] = 23.63, ["Mega|Ride"] = 186.06}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 155.97, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 124.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 15.86, ["Fly|Ride"] = 49.87, ["Neon"] = 5.07, ["Neon|Fly"] = 55.83, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 26.25, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.5, ["Ride"] = 139.49, ["Neon"] = 91.88, ["Mega"] = 315, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.88, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 51.92, ["Neon|Ride"] = 204.66, ["Mega"] = 1574.13, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.13, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 30.59, ["Mega"] = 295.25, ["Mega|Ride"] = 289.42, ["Mega|Fly|Ride"] = 367.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.48, ["Ride"] = 15.5, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 28.59, ["Mega"] = 15.08, ["Mega|Fly"] = 33.09, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.84, ["Fly|Ride"] = 110.6, ["Neon"] = 3.94, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 32.06, ["Neon|Fly|Ride"] = 689.39, ["Mega"] = 51.19, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 156.08}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 69.11, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 31.02, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 14.34, ["Mega|Fly"] = 83.16, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.84, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 103.37, ["Mega"] = 19.22, ["Mega|Ride"] = 102.34, ["Mega|Fly|Ride"] = 152.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.08, ["Ride"] = 20.58, ["Fly|Ride"] = 45.92, ["Neon"] = 9.17, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 182.03, ["Mega"] = 208.85, ["Mega|Ride"] = 205.7, ["Mega|Fly|Ride"] = 345.22}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 157.5, ["Ride"] = 212.72, ["Fly|Ride"] = 325.81, ["Neon"] = 1021.17, ["Neon|Ride"] = 822.94, ["Neon|Fly|Ride"] = 1013.94, ["Mega"] = 8268.48, ["Mega|Fly|Ride"] = 3414.65}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.5, ["Neon"] = 15.44, ["Neon|Ride"] = 82.11, ["Mega"] = 68.93, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 826.86}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.45, ["Fly"] = 63.03, ["Ride"] = 24.8, ["Neon"] = 26.88, ["Neon|Ride"] = 93.12, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 350.83, ["Mega|Ride"] = 515.75, ["Mega|Fly|Ride"] = 403.86}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 15.37, ["Fly|Ride"] = 32.03, ["Neon"] = 4.5, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 55.83, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 171.59}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 27.57, ["Fly|Ride"] = 92.55, ["Neon"] = 6.01, ["Neon|Fly"] = 551.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.47, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.72, ["Fly"] = 17.99, ["Ride"] = 15.68, ["Fly|Ride"] = 35.42, ["Neon"] = 24.86, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 73.29, ["Mega|Ride"] = 262.55, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.98, ["Fly"] = 41.26, ["Ride"] = 34.12, ["Fly|Ride"] = 275.98, ["Neon"] = 45.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 613.95, ["Mega"] = 337.03, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.56, ["Ride"] = 15.05, ["Fly|Ride"] = 37.2, ["Neon"] = 18.17, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 27.92, ["Neon|Fly|Ride"] = 75.29, ["Mega|Ride"] = 241.87, ["Mega|Fly|Ride"] = 218.22}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 63.54, ["Fly"] = 169.12, ["Ride"] = 91.84, ["Fly|Ride"] = 152.38, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1653.7}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.59, ["Fly"] = 329.53, ["Ride"] = 204.46, ["Fly|Ride"] = 275.98, ["Neon"] = 1008.81, ["Neon|Ride"] = 1446.99, ["Neon|Fly|Ride"] = 1188.62, ["Mega"] = 10335.61, ["Mega|Fly|Ride"] = 3983.36}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.47, ["Fly"] = 100.93, ["Ride"] = 76.42, ["Fly|Ride"] = 126.11, ["Neon"] = 685.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 360.29, ["Mega|Ride"] = 1239.26, ["Mega|Fly|Ride"] = 1233.15}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.2, ["Fly"] = 96.94, ["Ride"] = 27.89, ["Fly|Ride"] = 69.2, ["Neon"] = 21.84, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 158.82, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 262.65}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.82, ["Fly"] = 68.97, ["Ride"] = 32.38, ["Fly|Ride"] = 89.25, ["Neon"] = 72.09, ["Neon|Ride"] = 151.66, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 351.75, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 621.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.18, ["Fly|Ride"] = 44.49, ["Neon"] = 5.24, ["Neon|Fly"] = 74.59, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 82.7, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 126.11, ["Mega|Fly|Ride"] = 548.83}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.03, ["Fly"] = 27.85, ["Ride"] = 27.89, ["Fly|Ride"] = 293.86, ["Neon"] = 88.4, ["Neon|Fly"] = 345.22, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 134.92, ["Mega"] = 1837.5, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.25, ["Ride"] = 17.29, ["Fly|Ride"] = 53.53, ["Neon"] = 15.62, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 95.6, ["Mega"] = 187.69, ["Mega|Ride"] = 206.72, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.89, ["Ride"] = 23.26, ["Fly|Ride"] = 328.13, ["Neon"] = 28.71, ["Neon|Ride"] = 55.83, ["Mega|Ride"] = 232.78, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 36.15, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 14.44, ["Mega|Fly"] = 41.35, ["Mega|Ride"] = 41.35, ["Mega|Fly|Ride"] = 209487.15}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.56, ["Fly"] = 17.57, ["Ride"] = 18.05, ["Fly|Ride"] = 39.38, ["Neon"] = 12.18, ["Neon|Fly"] = 103.37, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 98.2, ["Mega"] = 84, ["Mega|Ride"] = 109.07, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.83, ["Fly"] = 24.93, ["Ride"] = 18.32, ["Fly|Ride"] = 45.94, ["Neon"] = 27.92, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 119.91, ["Mega"] = 283.5, ["Mega|Ride"] = 193.3, ["Mega|Fly|Ride"] = 222.31}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 156.4, ["Fly"] = 247.49, ["Ride"] = 190.07, ["Fly|Ride"] = 250.88, ["Neon"] = 826.86, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 723.14, ["Mega|Fly|Ride"] = 2745.6}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.44, ["Ride"] = 30.99, ["Fly|Ride"] = 205.7, ["Neon"] = 93.1, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 342.12, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.63, ["Fly"] = 15.75, ["Ride"] = 24.39, ["Fly|Ride"] = 43.32, ["Neon"] = 67.94, ["Neon|Ride"] = 69.26, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.25, ["Ride"] = 41.32, ["Fly|Ride"] = 170.62, ["Neon"] = 166.21, ["Neon|Ride"] = 292.51, ["Neon|Fly|Ride"] = 459.39, ["Mega"] = 453.14, ["Mega|Fly"] = 826.86, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 688.37}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.09}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.61, ["Ride"] = 28.49, ["Neon"] = 24.61, ["Neon|Ride"] = 274.95, ["Neon|Fly|Ride"] = 620.15, ["Mega"] = 826.86, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 824.79}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 29.06, ["Fly"] = 35.49, ["Ride"] = 33.18, ["Fly|Ride"] = 57.74, ["Neon"] = 179.86, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1792.21, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 20.67, ["Fly|Ride"] = 78.75, ["Neon"] = 5.8, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 33.79, ["Mega|Fly"] = 275.98, ["Mega|Ride"] = 80.63, ["Mega|Fly|Ride"] = 225.25}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.11, ["Fly"] = 27.79, ["Ride"] = 23.77, ["Fly|Ride"] = 62.03, ["Neon"] = 45.45, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.78, ["Mega"] = 231.48, ["Mega|Fly"] = 388.73, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 304.91}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.37, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 45.65, ["Neon"] = 11.82, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.63, ["Fly|Ride"] = 206.72, ["Neon"] = 4.15, ["Neon|Ride"] = 31.02, ["Neon|Fly|Ride"] = 413.43, ["Mega"] = 31.24, ["Mega|Ride"] = 81.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.19, ["Ride"] = 82.25, ["Neon"] = 254.27, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 791.99, ["Mega|Ride"] = 965.35, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.29, ["Ride"] = 53.48, ["Fly|Ride"] = 210, ["Neon"] = 80.29, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 9.19, ["Fly"] = 96.94, ["Ride"] = 24.8, ["Fly|Ride"] = 93.19, ["Neon"] = 30.56, ["Neon|Fly"] = 315, ["Neon|Ride"] = 45.5, ["Neon|Fly|Ride"] = 99.24, ["Mega"] = 465.53, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.13, ["Ride"] = 179.17, ["Fly|Ride"] = 262.44, ["Neon"] = 551.94, ["Neon|Ride"] = 413.43, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.43, ["Fly"] = 45.94, ["Ride"] = 29.34, ["Fly|Ride"] = 62.85, ["Neon"] = 55.56, ["Neon|Ride"] = 66.66, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 322.88, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 263.84}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 71.05, ["Fly"] = 145.69, ["Ride"] = 106.37, ["Fly|Ride"] = 186.18, ["Neon"] = 241.5, ["Neon|Fly"] = 525, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 409.5, ["Mega"] = 1102.82, ["Mega|Ride"] = 1074.91, ["Mega|Fly|Ride"] = 905.97}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.29, ["Ride"] = 77.46, ["Fly|Ride"] = 173.55, ["Neon"] = 69.83, ["Neon|Ride"] = 124.53, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 345.22, ["Mega|Ride"] = 305.69, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.24, ["Ride"] = 18.6, ["Fly|Ride"] = 48.29, ["Neon"] = 105, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 249.06, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Ride"] = 60.13, ["Fly|Ride"] = 156.33, ["Neon"] = 85.18, ["Neon|Ride"] = 110.69, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 255.21, ["Mega|Ride"] = 292.14, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.3, ["Ride"] = 41.1, ["Fly|Ride"] = 138.51, ["Neon"] = 44.83, ["Neon|Ride"] = 69.26, ["Mega"] = 330.75, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 55.83, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 89.94, ["Mega"] = 17.74, ["Mega|Ride"] = 103.37, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.14, ["Ride"] = 27.65, ["Neon"] = 19.3, ["Neon|Fly"] = 124.04, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.71, ["Mega|Ride"] = 190.19, ["Mega|Fly|Ride"] = 304.91}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.49, ["Fly"] = 62.68, ["Neon"] = 22.44, ["Mega"] = 196.23, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.94, ["Ride"] = 32.79, ["Fly|Ride"] = 116.38, ["Neon"] = 18.62, ["Neon|Ride"] = 81.33, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 200.52, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.35, ["Fly"] = 649.79, ["Ride"] = 517.62, ["Fly|Ride"] = 603.74, ["Neon"] = 1792.21, ["Neon|Ride"] = 1614.38, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.81, ["Fly"] = 27.85, ["Ride"] = 23.68, ["Fly|Ride"] = 62.77, ["Neon"] = 31.43, ["Neon|Ride"] = 95.1, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.97, ["Mega|Ride"] = 357.31, ["Mega|Fly|Ride"] = 484.17}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.45, ["Fly"] = 77.76, ["Ride"] = 23.67, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 309.04, ["Mega|Ride"] = 318.05, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.71, ["Fly"] = 96.94, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon"] = 15.51, ["Neon|Ride"] = 196.88, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 78.75, ["Neon"] = 7.69, ["Neon|Ride"] = 31.28, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 58.37, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 116, ["Mega|Fly|Ride"] = 152.15}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.11, ["Ride"] = 19.69, ["Neon"] = 3.42, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 64.96, ["Mega"] = 26.25, ["Mega|Fly"] = 193.3, ["Mega|Ride"] = 82.7, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.8, ["Ride"] = 27.91, ["Fly|Ride"] = 323.64, ["Neon"] = 65.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 193.3, ["Mega"] = 400, ["Mega|Ride"] = 384.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.85, ["Neon"] = 6.57, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.65, ["Mega|Ride"] = 155.05, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.7, ["Fly|Ride"] = 99.75, ["Neon"] = 11.11, ["Neon|Fly"] = 124.04, ["Neon|Ride"] = 138, ["Neon|Fly|Ride"] = 689.39, ["Mega"] = 183.73, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.92, ["Ride"] = 426.57, ["Fly|Ride"] = 551.25, ["Neon|Ride"] = 1378.78, ["Neon|Fly|Ride"] = 1280.37, ["Mega|Fly|Ride"] = 7728.93}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.56, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 413.43, ["Neon"] = 56.35, ["Neon|Ride"] = 70.65, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 328.13, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.08, ["Fly|Ride"] = 161.24, ["Neon"] = 6.57, ["Neon|Ride"] = 30.72, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 43.55, ["Mega|Fly"] = 189, ["Mega|Ride"] = 85.58, ["Mega|Fly|Ride"] = 258.4}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 27.45, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 146.28}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 77.89, ["Neon"] = 102.76, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 450.4, ["Mega|Ride"] = 400, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 20.9, ["Neon"] = 109.38, ["Neon|Ride"] = 124.04, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 423.77, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.82, ["Fly|Ride"] = 412.4, ["Neon"] = 310.69, ["Neon|Ride"] = 155.97, ["Mega"] = 636.63, ["Mega|Ride"] = 758.65, ["Mega|Fly|Ride"] = 1240.29}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.54, ["Ride"] = 22.67, ["Neon"] = 275.98, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 525, ["Mega|Ride"] = 620.15, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 464.15, ["Ride"] = 433.69, ["Fly|Ride"] = 619.55, ["Neon"] = 2893.97, ["Neon|Ride"] = 2067.13, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3817.98}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.56, ["Fly"] = 69.65, ["Ride"] = 27.65, ["Fly|Ride"] = 131.25, ["Neon"] = 106.01, ["Neon|Fly"] = 185.07, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 171.21, ["Mega"] = 689.39, ["Mega|Ride"] = 411.37, ["Mega|Fly|Ride"] = 853.74}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.92, ["Ride"] = 69.98, ["Neon"] = 35.16, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 776.29}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.74, ["Ride"] = 69.57, ["Fly|Ride"] = 257.16, ["Neon"] = 72.19, ["Neon|Ride"] = 129.68, ["Neon|Fly|Ride"] = 288.09, ["Mega"] = 272.35, ["Mega|Fly"] = 689.39, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 352.96}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.3, ["Fly"] = 41.26, ["Ride"] = 42, ["Fly|Ride"] = 138.37, ["Neon"] = 6.35, ["Neon|Ride"] = 41.35, ["Neon|Fly|Ride"] = 205.7, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.06, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 157.5, ["Neon|Ride"] = 221.2, ["Neon|Fly|Ride"] = 659.9, ["Mega"] = 1792.21, ["Mega|Ride"] = 1335.37, ["Mega|Fly|Ride"] = 971.24}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.25, ["Neon"] = 9.09, ["Neon|Fly"] = 179.86, ["Neon|Ride"] = 63.65, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 71.92, ["Mega|Ride"] = 103.59, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.84, ["Ride"] = 30.19, ["Fly|Ride"] = 149.76, ["Neon"] = 5.79, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 39.62, ["Neon|Fly|Ride"] = 77.99, ["Mega"] = 39.38, ["Mega|Fly"] = 160.62, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 31.39, ["Fly|Ride"] = 122.75, ["Neon"] = 13.13, ["Neon|Ride"] = 41.35, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.44, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 102.96, ["Fly"] = 92.85, ["Ride"] = 78.74, ["Fly|Ride"] = 194.13, ["Neon"] = 291.38, ["Neon|Ride"] = 288.51, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1033.57, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.59, ["Ride"] = 272.02, ["Fly|Ride"] = 413.44, ["Neon"] = 1436.67, ["Neon|Ride"] = 1127.75, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6201.37, ["Mega|Fly|Ride"] = 4966.02}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.25, ["Neon"] = 28.84, ["Neon|Ride"] = 138.51, ["Mega"] = 96.73, ["Mega|Ride"] = 179.46, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 28.56, ["Fly|Ride"] = 155.93, ["Neon"] = 9.32, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 59.27, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 345.22}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.4, ["Fly"] = 30.18, ["Ride"] = 27.56, ["Fly|Ride"] = 175.72, ["Neon"] = 36.75, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 345.22}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 58.92, ["Ride"] = 36.15, ["Fly|Ride"] = 131.28, ["Neon"] = 7.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 84.36, ["Mega|Fly"] = 146.78, ["Mega|Ride"] = 90.37, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.93, ["Neon"] = 9.32, ["Mega"] = 37.42, ["Mega|Fly|Ride"] = 172.62}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 5.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 98.2, ["Mega"] = 97.16, ["Mega|Ride"] = 97.16, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 138.18, ["Ride"] = 24.8, ["Fly|Ride"] = 55.05, ["Neon"] = 9.81, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 39.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 93.03, ["Mega|Ride"] = 233.6, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 51.57, ["Ride"] = 42.61, ["Fly|Ride"] = 77.16, ["Neon"] = 192.13, ["Neon|Fly|Ride"] = 288.64, ["Mega"] = 577.78, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.91, ["Fly"] = 582.75, ["Ride"] = 81.39, ["Fly|Ride"] = 112.83, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 549.87, ["Mega"] = 1470, ["Mega|Ride"] = 4409.19, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 39.16, ["Mega|Fly"] = 672, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.47, ["Ride"] = 15.74, ["Fly|Ride"] = 39.36, ["Neon"] = 5.07, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.68, ["Neon|Fly|Ride"] = 55.83, ["Mega"] = 61.01, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.24, ["Fly"] = 37.14, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 248.07, ["Neon|Ride"] = 46.57, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 527.63, ["Mega|Ride"] = 427.13, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 413.44, ["Ride"] = 551.39, ["Fly|Ride"] = 492.19, ["Neon"] = 4134.24, ["Neon|Ride"] = 1792.21, ["Mega|Fly|Ride"] = 7234.92}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 31.5, ["Fly"] = 95.81, ["Ride"] = 85.72, ["Fly|Ride"] = 109.58, ["Neon"] = 170.43, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 305.79, ["Mega|Ride"] = 1240.29, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.87, ["Fly|Ride"] = 281.29, ["Neon"] = 7.72, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 123.38, ["Mega|Ride"] = 131.28, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.25, ["Fly"] = 205.82, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 23.79, ["Mega|Ride"] = 275.98}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.51, ["Fly"] = 76.32, ["Ride"] = 43.26, ["Fly|Ride"] = 82.69, ["Neon|Ride"] = 297.94, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2480.56, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1241.82}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.74, ["Fly"] = 117.56, ["Ride"] = 92.94, ["Fly|Ride"] = 155.93, ["Neon"] = 430.1, ["Neon|Ride"] = 469.26, ["Neon|Fly|Ride"] = 477.51, ["Mega"] = 8268.48, ["Mega|Fly|Ride"] = 1883.17}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.64, ["Ride"] = 282.66, ["Fly|Ride"] = 515.25, ["Neon"] = 1240.29, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4390.58, ["Mega|Fly|Ride"] = 3716.69}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.05, ["Fly"] = 51.18, ["Ride"] = 55.67, ["Fly|Ride"] = 150.94, ["Neon"] = 75.95, ["Neon|Ride"] = 108.55, ["Neon|Fly|Ride"] = 317.31, ["Mega"] = 379.71, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.66, ["Ride"] = 18.26, ["Fly|Ride"] = 40.63, ["Neon"] = 7.88, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 86.14, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.4, ["Fly"] = 33.5, ["Ride"] = 20.46, ["Fly|Ride"] = 43.32, ["Neon"] = 32.71, ["Neon|Fly"] = 144.72, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 111.11, ["Mega"] = 378.3, ["Mega|Ride"] = 308.02, ["Mega|Fly|Ride"] = 310.08}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 481.55, ["Ride"] = 349.13, ["Fly|Ride"] = 413.03, ["Neon"] = 1443.75, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 5742.29}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 9.32, ["Neon|Ride"] = 59.96, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 36.19, ["Mega|Ride"] = 254.27}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.7, ["Fly"] = 36.1, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 27.79, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 155.97, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.65, ["Ride"] = 98.44, ["Neon"] = 111.57, ["Neon|Fly"] = 413.43, ["Neon|Ride"] = 236.23, ["Neon|Fly|Ride"] = 435.29, ["Mega"] = 483.61, ["Mega|Ride"] = 548.83, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 110.25, ["Fly"] = 157.5, ["Ride"] = 110.25, ["Fly|Ride"] = 165.22, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 551.66, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.86, ["Fly"] = 43.29, ["Ride"] = 26.25, ["Fly|Ride"] = 54.44, ["Neon"] = 77.98, ["Neon|Ride"] = 103.68, ["Neon|Fly|Ride"] = 156.08, ["Mega"] = 634.62, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 493.29}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 25.58, ["Neon"] = 2.37, ["Neon|Fly|Ride"] = 689.39, ["Mega"] = 20.68, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.16, ["Ride"] = 15.75, ["Fly|Ride"] = 72.18, ["Neon"] = 3.83, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 27.57, ["Mega|Fly"] = 61.18, ["Mega|Ride"] = 51.85, ["Mega|Fly|Ride"] = 113.88}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.44, ["Fly"] = 412.47, ["Ride"] = 76.04, ["Fly|Ride"] = 145.28, ["Neon"] = 26.22, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 80.22, ["Neon|Fly|Ride"] = 169.66, ["Mega"] = 151.45, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 317.31}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1260.92, ["Fly"] = 1531.64, ["Ride"] = 1207.5, ["Fly|Ride"] = 1296.75, ["Neon"] = 4578.59, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 486.93, ["Fly"] = 618.7, ["Ride"] = 480.38, ["Fly|Ride"] = 571.91, ["Neon"] = 1792.21, ["Neon|Ride"] = 1916.25, ["Neon|Fly|Ride"] = 2052.66, ["Mega"] = 16536.96, ["Mega|Fly|Ride"] = 6956.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 328.01, ["Fly"] = 407.31, ["Ride"] = 373.15, ["Fly|Ride"] = 439.69, ["Neon"] = 735, ["Neon|Fly"] = 1241.52, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 287.4, ["Fly"] = 412.47, ["Ride"] = 365.1, ["Fly|Ride"] = 408.28, ["Neon"] = 918.75, ["Neon|Fly"] = 1378.78, ["Neon|Ride"] = 1177.23, ["Neon|Fly|Ride"] = 1033.57, ["Mega|Fly|Ride"] = 4531.14}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.06, ["Fly|Ride"] = 38.06, ["Neon"] = 5.8, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.8, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 360.94, ["Ride"] = 458.55, ["Fly|Ride"] = 547.32, ["Neon"] = 1680, ["Neon|Ride"] = 1326.55, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Ride"] = 6614.79, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.47, ["Fly"] = 183.75, ["Ride"] = 18.38, ["Neon"] = 9.19, ["Neon|Ride"] = 66.17, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 78.75, ["Mega|Ride"] = 181.54, ["Mega|Fly|Ride"] = 345.22}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.83, ["Ride"] = 18.6, ["Fly|Ride"] = 38.98, ["Neon"] = 7.77, ["Neon|Ride"] = 52.73, ["Neon|Fly|Ride"] = 108.21, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 69.84, ["Mega"] = 23.63, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.14, ["Ride"] = 109.47, ["Fly|Ride"] = 459.38, ["Neon"] = 193.3, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 931.06, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7735.87, ["Ride"] = 21.63, ["Fly|Ride"] = 60.44, ["Neon"] = 26.1, ["Neon|Ride"] = 77.99, ["Mega"] = 328.13, ["Mega|Ride"] = 310.08, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.83, ["Neon|Fly"] = 118.1, ["Neon|Ride"] = 37.22, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 19.69, ["Mega|Fly"] = 103.37, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 118.36}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 21, ["Fly|Ride"] = 64.87, ["Neon"] = 9.19, ["Neon|Fly"] = 97.16, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 98.44, ["Mega|Fly"] = 172.62, ["Mega|Ride"] = 117.75, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.42, ["Fly"] = 91.77, ["Ride"] = 27.91, ["Fly|Ride"] = 51.45, ["Neon"] = 19.69, ["Neon|Fly"] = 110.6, ["Neon|Ride"] = 82.7, ["Neon|Fly|Ride"] = 246.11, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 310.76}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.75, ["Fly"] = 190.32, ["Ride"] = 60.74, ["Neon"] = 44.62, ["Neon|Fly|Ride"] = 264.2, ["Mega"] = 289.42, ["Mega|Ride"] = 329.44, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.94, ["Fly"] = 6189.16, ["Ride"] = 26.62, ["Neon"] = 36.02, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.37, ["Fly|Ride"] = 45.94, ["Neon"] = 4.15, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 48.5, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 138.18, ["Fly"] = 227.89, ["Ride"] = 228.2, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 2583.92, ["Neon|Fly|Ride"] = 1087.03, ["Mega"] = 8268.48, ["Mega|Fly|Ride"] = 4189.76}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.22, ["Ride"] = 15.45, ["Fly|Ride"] = 35.06, ["Neon"] = 3.94, ["Neon|Fly"] = 27.92, ["Neon|Ride"] = 24.72, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 44.63, ["Mega|Ride"] = 59.27, ["Mega|Fly|Ride"] = 96.66}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.88, ["Fly"] = 138.18, ["Ride"] = 69.46, ["Fly|Ride"] = 183.75, ["Neon"] = 83.35, ["Neon|Ride"] = 123.27, ["Mega"] = 360.94, ["Mega|Ride"] = 278.21, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 33.33, ["Ride"] = 45.94, ["Fly|Ride"] = 167.23, ["Neon"] = 233.57, ["Neon|Ride"] = 275.98, ["Mega"] = 786.19, ["Mega|Ride"] = 814.69}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.1, ["Ride"] = 216.57, ["Fly|Ride"] = 322.17, ["Neon"] = 708.73, ["Neon|Fly"] = 1163.57, ["Neon|Ride"] = 900.8, ["Neon|Fly|Ride"] = 842.63, ["Mega|Fly|Ride"] = 3362.77}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.34, ["Fly"] = 168.88, ["Ride"] = 37.43, ["Fly|Ride"] = 139.49, ["Neon"] = 124.51, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1240.29}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 11.51, ["Ride"] = 44.63, ["Fly|Ride"] = 525, ["Neon"] = 97.16, ["Neon|Fly"] = 155.93, ["Neon|Ride"] = 199.5, ["Mega"] = 275.98, ["Mega|Ride"] = 1653.7, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 984.38, ["Ride"] = 1081.5, ["Fly|Ride"] = 1149.75, ["Neon"] = 4654.22, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4538.78, ["Mega"] = 18604.08, ["Mega|Fly|Ride"] = 17226.35}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.57, ["Fly"] = 30.18, ["Ride"] = 19.56, ["Fly|Ride"] = 90.78, ["Neon"] = 40.46, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 272.35, ["Mega|Ride"] = 234.64, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.29, ["Fly"] = 13610.9, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 30.24, ["Neon|Ride"] = 91.96, ["Mega"] = 206.72, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.48, ["Ride"] = 22.08, ["Fly|Ride"] = 69.57, ["Neon"] = 12.8, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 37.26, ["Mega"] = 95.82, ["Mega|Ride"] = 136.9, ["Mega|Fly|Ride"] = 686.21}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.12, ["Ride"] = 39.12, ["Fly|Ride"] = 81.38, ["Neon"] = 76.61, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 173.72, ["Mega"] = 342.57, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.56, ["Fly"] = 20.64, ["Ride"] = 18.47, ["Fly|Ride"] = 41.01, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 92.57, ["Mega"] = 139.67, ["Mega|Ride"] = 159.18, ["Mega|Fly|Ride"] = 272.35}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.82, ["Ride"] = 36.15, ["Neon"] = 11.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 111.57, ["Mega|Fly"] = 275.98, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 328.69}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 387.72, ["Ride"] = 328.13, ["Fly|Ride"] = 392.78, ["Neon|Fly|Ride"] = 1350.04}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.62, ["Fly"] = 25.47, ["Ride"] = 19.37, ["Fly|Ride"] = 72.19, ["Neon"] = 9.98, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 78.75, ["Mega|Fly"] = 413.43, ["Mega|Ride"] = 110.04, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.23, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 77.43, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 138.51, ["Mega|Ride"] = 372.1}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 8.26, ["Fly"] = 92.17, ["Ride"] = 26.17, ["Neon"] = 15.31, ["Neon|Ride"] = 1378.78, ["Mega"] = 83.99, ["Mega|Fly"] = 138.51, ["Mega|Ride"] = 206.72, ["Mega|Fly|Ride"] = 365.46}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 216.57, ["Ride"] = 315, ["Fly|Ride"] = 413.03, ["Neon"] = 787.5, ["Neon|Fly"] = 965.35, ["Neon|Ride"] = 816.38, ["Mega"] = 3100.69, ["Mega|Ride"] = 4961.1, ["Mega|Fly|Ride"] = 2789.41}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.98, ["Fly"] = 60.74, ["Ride"] = 68.16, ["Fly|Ride"] = 159.18, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1238.22}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.74, ["Ride"] = 37.79, ["Fly|Ride"] = 89.25, ["Neon"] = 77.49, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 491.07, ["Mega|Ride"] = 510.07, ["Mega|Fly|Ride"] = 566.55}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.62, ["Neon"] = 3.29, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 225.32}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 61.24, ["Fly"] = 106.09, ["Ride"] = 89.72, ["Fly|Ride"] = 178.8, ["Neon"] = 262.48, ["Neon|Fly"] = 413.43, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 328.12, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 5.16, ["Neon|Ride"] = 55.83, ["Neon|Fly|Ride"] = 123, ["Mega"] = 50.93, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.88, ["Fly"] = 97.48, ["Ride"] = 17.07, ["Fly|Ride"] = 75.78, ["Neon"] = 65.62, ["Neon|Ride"] = 122.8, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 275.98, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 382.44}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 52.87, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 137.31, ["Neon"] = 244.97, ["Neon|Ride"] = 310.76, ["Neon|Fly|Ride"] = 377.91, ["Mega|Ride"] = 3446.93, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.12, ["Fly|Ride"] = 25.47, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 16.55, ["Neon|Fly|Ride"] = 40.76, ["Mega"] = 15.75, ["Mega|Fly"] = 116.4, ["Mega|Ride"] = 30.33, ["Mega|Fly|Ride"] = 93.12}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.73, ["Fly"] = 32.81, ["Ride"] = 44.01, ["Fly|Ride"] = 131.25, ["Neon"] = 14.21, ["Neon|Ride"] = 59.96, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 129.94, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.89, ["Ride"] = 61.97, ["Fly|Ride"] = 109.28, ["Neon"] = 77.98, ["Neon|Ride"] = 124.53, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 586.69, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 825.83}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 134.38, ["Mega"] = 22.23, ["Mega|Ride"] = 137.48}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.34, ["Fly"] = 26.25, ["Ride"] = 57.9, ["Fly|Ride"] = 99.74, ["Neon"] = 89.32, ["Neon|Ride"] = 109.58, ["Neon|Fly|Ride"] = 345.22, ["Mega"] = 558.65, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 482.68}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.02, ["Fly"] = 67.96, ["Ride"] = 26.25, ["Fly|Ride"] = 45.85, ["Neon"] = 225.32, ["Neon|Ride"] = 110.6, ["Mega"] = 434.11, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 8.14, ["Ride"] = 49.58, ["Neon"] = 26.15, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.01, ["Fly"] = 2062.28, ["Ride"] = 85.32, ["Fly|Ride"] = 196.83, ["Neon"] = 52.5, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 6206.66, ["Mega"] = 274.96, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.62, ["Fly"] = 41.26, ["Ride"] = 18.56, ["Fly|Ride"] = 196.88, ["Neon"] = 6.49, ["Neon|Fly"] = 55.83, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 103.37, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.74, ["Neon"] = 3.94, ["Neon|Ride"] = 89.17, ["Mega"] = 29.5, ["Mega|Ride"] = 82.7, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.7, ["Fly"] = 78.75, ["Ride"] = 46.51, ["Fly|Ride"] = 206.72, ["Neon"] = 1050, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1232.02, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.41, ["Mega"] = 23.16, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 310.08}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 563, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3046.96, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16536.96, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.24, ["Fly"] = 25.91, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.91, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 78.47, ["Mega|Fly"] = 148.84, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 18.38, ["Fly|Ride"] = 64.2, ["Neon"] = 16.71, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 161.44, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.45, ["Fly"] = 77.35, ["Ride"] = 65.07, ["Fly|Ride"] = 106.32, ["Neon"] = 78.66, ["Neon|Ride"] = 179.24, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 797.92, ["Mega|Ride"] = 524.03, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.49, ["Fly"] = 316.57, ["Ride"] = 32.48, ["Fly|Ride"] = 688.72, ["Mega"] = 255.94, ["Mega|Ride"] = 232.78}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.5, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 107.5, ["Neon|Fly|Ride"] = 365.9, ["Mega"] = 347.28, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 490.95}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.46, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 46.6, ["Neon|Ride"] = 101.75, ["Neon|Fly|Ride"] = 136.44, ["Mega"] = 202.13, ["Mega|Fly"] = 551.94, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 316.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.32, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.51, ["Neon|Fly|Ride"] = 122.96, ["Mega"] = 14.11, ["Mega|Ride"] = 35.4, ["Mega|Fly|Ride"] = 110.6}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.81, ["Fly"] = 275.34, ["Ride"] = 27.89, ["Fly|Ride"] = 48.54, ["Neon"] = 28.65, ["Neon|Fly"] = 116.4, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 110.58, ["Mega"] = 195.57, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 296.52, ["Fly"] = 406.12, ["Ride"] = 331.26, ["Fly|Ride"] = 421.31, ["Neon"] = 1455.26, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4231.4}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.22, ["Ride"] = 274.66, ["Fly|Ride"] = 215.25, ["Neon"] = 308.44, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 491.32, ["Mega"] = 4134.24, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1707.33}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 27.08, ["Neon"] = 16.55, ["Neon|Fly"] = 31.02, ["Neon|Ride"] = 31.02, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 152.99, ["Mega|Fly"] = 205.7, ["Mega|Ride"] = 124.04, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.03, ["Ride"] = 15.48, ["Fly|Ride"] = 31.02, ["Neon"] = 6.13, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 59.11, ["Mega"] = 70.1, ["Mega|Fly"] = 344.02, ["Mega|Ride"] = 101.84, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 138.51, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 260.38, ["Fly"] = 420, ["Ride"] = 286.14, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 1142.89, ["Neon|Fly|Ride"] = 1392.22, ["Mega|Ride"] = 8268.48, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.83, ["Fly"] = 48.24, ["Ride"] = 16.7, ["Fly|Ride"] = 39.38, ["Neon"] = 19.66, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 40.22, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 196.88, ["Mega|Fly"] = 124.04, ["Mega|Ride"] = 310.76, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.57, ["Fly"] = 155.5, ["Ride"] = 82.11, ["Fly|Ride"] = 206.53, ["Neon"] = 13.13, ["Neon|Ride"] = 126.62, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 252, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 63, ["Mega|Ride"] = 200.61}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.43, ["Fly"] = 36.1, ["Ride"] = 17.61, ["Fly|Ride"] = 57.29, ["Neon"] = 79.38, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 172.62, ["Mega"] = 728.44, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 42, ["Fly"] = 138.18, ["Ride"] = 109.28, ["Fly|Ride"] = 196.88, ["Neon"] = 104.99, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 212.83, ["Neon|Fly|Ride"] = 379.32, ["Mega"] = 452.82, ["Mega|Fly"] = 2170.49, ["Mega|Ride"] = 508.52, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.84, ["Ride"] = 46.3, ["Fly|Ride"] = 104.52, ["Neon"] = 165.39, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega|Ride"] = 772.08, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 14.89, ["Fly|Ride"] = 33.09, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 20.04, ["Mega|Ride"] = 47.56, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 256.09, ["Ride"] = 275.7, ["Fly|Ride"] = 295.32, ["Neon"] = 3257.97, ["Neon|Ride"] = 965.35, ["Neon|Fly|Ride"] = 1321.69}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.56, ["Fly"] = 101.18, ["Ride"] = 69.2, ["Fly|Ride"] = 105, ["Neon"] = 127.85, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 69.26, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.69, ["Ride"] = 15.59, ["Fly|Ride"] = 44.41, ["Neon"] = 9.27, ["Neon|Fly"] = 39.4, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 109.58, ["Mega"] = 59.37, ["Mega|Fly"] = 275.98, ["Mega|Ride"] = 54.69, ["Mega|Fly|Ride"] = 139.67}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.95, ["Ride"] = 19.63, ["Fly|Ride"] = 35.44, ["Neon"] = 3.47, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.8, ["Mega"] = 20.68, ["Mega|Fly"] = 138.51, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 155.97}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 12.21, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 6866.86, ["Mega"] = 126.83, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.11, ["Fly"] = 38.74, ["Ride"] = 26.25, ["Fly|Ride"] = 70.5, ["Neon"] = 50.6, ["Neon|Fly"] = 82.7, ["Neon|Ride"] = 65.13, ["Neon|Fly|Ride"] = 117.84, ["Mega"] = 336.48, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.18, ["Ride"] = 55.09, ["Fly|Ride"] = 72.19, ["Neon"] = 59.07, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 268.74, ["Mega|Ride"] = 345.22, ["Mega|Fly|Ride"] = 372.44}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Neon"] = 3.68, ["Neon|Ride"] = 37.23, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 17.75, ["Mega|Ride"] = 66.61, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.08, ["Fly"] = 96.94, ["Ride"] = 28.88, ["Fly|Ride"] = 118.13, ["Neon"] = 25.91, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 137.07, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 296.64}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 69.11, ["Ride"] = 111.99, ["Neon"] = 3.46, ["Neon|Fly"] = 110.6, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 23.96, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 17.4, ["Fly|Ride"] = 40.74, ["Neon"] = 6.56, ["Neon|Ride"] = 22.24, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 49.88, ["Mega|Ride"] = 80.63, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 703.5, ["Ride"] = 756, ["Fly|Ride"] = 817.3, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3231.55, ["Mega"] = 12678.69, ["Mega|Fly|Ride"] = 12786.18}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.68, ["Fly|Ride"] = 34.13, ["Neon"] = 46.56, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 57.9, ["Mega"] = 185.03, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 81.26, ["Neon"] = 9.17, ["Neon|Ride"] = 87.65, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 62.53, ["Mega|Fly"] = 315, ["Mega|Ride"] = 124.06, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.56, ["Fly"] = 40.6, ["Ride"] = 21, ["Fly|Ride"] = 39.38, ["Neon"] = 52.31, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 38.57, ["Neon|Fly|Ride"] = 112.06, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.43, ["Fly|Ride"] = 31.62, ["Neon"] = 9.09, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 47.44, ["Mega"] = 55.83, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 138.51}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.07, ["Ride"] = 83.99, ["Fly|Ride"] = 206.53, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 893.82, ["Mega|Fly|Ride"] = 1157.61}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 138.18, ["Ride"] = 18.57, ["Fly|Ride"] = 63.74, ["Neon"] = 5.24, ["Neon|Fly"] = 132.66, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 59.85, ["Mega|Ride"] = 114.74, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.77, ["Fly"] = 69.11, ["Ride"] = 22.97, ["Fly|Ride"] = 61, ["Neon"] = 41.35, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 236.25, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 14.44, ["Mega"] = 93.5, ["Mega|Fly"] = 275.98, ["Mega|Ride"] = 172.26, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 63.67, ["Ride"] = 16.48, ["Fly|Ride"] = 49.83, ["Neon"] = 6.01, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 44.63, ["Mega|Fly"] = 250.63, ["Mega|Ride"] = 58.33}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.61, ["Fly"] = 23.63, ["Ride"] = 18.69, ["Fly|Ride"] = 39.37, ["Neon"] = 138.51, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 826.86, ["Mega|Fly|Ride"] = 458.25}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 735, ["Ride"] = 780.94, ["Fly|Ride"] = 918.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1903.13, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 6411.47}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.27, ["Fly|Ride"] = 39.82, ["Neon"] = 3.7, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 63.82, ["Mega"] = 52.5, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.34, ["Ride"] = 27.57, ["Fly|Ride"] = 77.55, ["Neon"] = 45.93, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 295.86, ["Mega|Ride"] = 315}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 46.43, ["Ride"] = 76.67, ["Fly|Ride"] = 113.28, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 413.43, ["Mega"] = 3169.93, ["Mega|Fly|Ride"] = 1294.02}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 34.53, ["Fly"] = 124.17, ["Ride"] = 35.96, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 138.2, ["Mega"] = 766.91, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 810.33}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.5, ["Ride"] = 26.23, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 137.73, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 423.65, ["Mega|Ride"] = 487.86, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.79, ["Ride"] = 76.42, ["Neon"] = 107.61, ["Neon|Ride"] = 136.44, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 244.52, ["Mega|Fly"] = 505.11, ["Mega|Ride"] = 342.12, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.56, ["Fly"] = 126.89, ["Ride"] = 314.99, ["Neon"] = 262.96, ["Neon|Ride"] = 304.91, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 621.5, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.57}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.19, ["Fly"] = 131248.69, ["Ride"] = 27.89, ["Fly|Ride"] = 84, ["Neon"] = 34.13, ["Neon|Ride"] = 214.34, ["Neon|Fly|Ride"] = 205.92, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 221.2, ["Mega|Fly|Ride"] = 310.76}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.5, ["Ride"] = 131.25, ["Neon"] = 14.83, ["Mega"] = 869.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 43.32, ["Fly"] = 412.47, ["Ride"] = 57.66, ["Fly|Ride"] = 108.96, ["Neon"] = 621.35, ["Neon|Ride"] = 267.75, ["Neon|Fly|Ride"] = 245.97, ["Mega|Ride"] = 868.2, ["Mega|Fly|Ride"] = 851.67}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.67, ["Fly"] = 18.37, ["Ride"] = 17.31, ["Fly|Ride"] = 41.32, ["Neon"] = 26.16, ["Neon|Fly"] = 47.56, ["Neon|Ride"] = 35.13, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 275.98, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.24, ["Fly"] = 82.5, ["Ride"] = 35, ["Fly|Ride"] = 105, ["Neon"] = 25.93, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 102.65, ["Mega|Ride"] = 172.17, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.64, ["Neon|Ride"] = 45.94, ["Mega"] = 41.58, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.24, ["Fly"] = 58.7, ["Ride"] = 54.51, ["Fly|Ride"] = 120.75, ["Neon"] = 152.25, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 1102.82, ["Mega|Ride"] = 783.46, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.89, ["Fly|Ride"] = 65.63, ["Neon"] = 8.28, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.06, ["Mega"] = 105, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.29, ["Ride"] = 52.5, ["Fly|Ride"] = 272.61, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 372.1, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 640.82}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 15.74, ["Fly|Ride"] = 37.92, ["Neon"] = 27.92, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 60.5, ["Mega"] = 170.63, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.62, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 62.25, ["Neon"] = 77.98, ["Neon|Ride"] = 410.93, ["Mega"] = 379.34, ["Mega|Ride"] = 390.7, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 59.3, ["Fly|Ride"] = 131.25, ["Neon"] = 46.56, ["Neon|Ride"] = 139.67, ["Mega"] = 364.58, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.26, ["Ride"] = 105, ["Fly|Ride"] = 206.53, ["Neon"] = 196.88, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 438.24, ["Mega|Ride"] = 1102.82, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.63, ["Ride"] = 119.01, ["Neon"] = 124.04, ["Neon|Ride"] = 179.86, ["Neon|Fly|Ride"] = 144.72, ["Mega"] = 413.43, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 105, ["Neon"] = 48.45, ["Neon|Ride"] = 91.88, ["Mega"] = 310.08, ["Mega|Ride"] = 978.79, ["Mega|Fly|Ride"] = 1653.7}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.68, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 826.86, ["Mega|Ride"] = 618.74}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.56, ["Neon"] = 26.76, ["Neon|Ride"] = 275.98, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 310.76}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.68, ["Fly|Ride"] = 38.19, ["Neon"] = 3.86, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 62.03, ["Mega|Ride"] = 93.18, ["Mega|Fly|Ride"] = 173.6}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.24, ["Fly"] = 50.19, ["Ride"] = 28.88, ["Fly|Ride"] = 77.88, ["Neon"] = 14.05, ["Neon|Ride"] = 41.35, ["Neon|Fly|Ride"] = 96.74, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 20.67, ["Fly|Ride"] = 55.95, ["Neon"] = 4.97, ["Neon|Fly"] = 31.43, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 46.93, ["Mega|Ride"] = 76.51, ["Mega|Fly|Ride"] = 152.99}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.5, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 69.2, ["Neon"] = 17.39, ["Neon|Ride"] = 98.2, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 241.4, ["Mega|Ride"] = 170.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.31, ["Fly"] = 65.63, ["Ride"] = 30.99, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 465.44, ["Neon|Ride"] = 69.26, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 304.91, ["Mega|Fly|Ride"] = 1033.57}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 23.63, ["Fly|Ride"] = 55.83, ["Neon"] = 26.25, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 138.51, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 17.97, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.7, ["Neon|Ride"] = 46.57, ["Neon|Fly|Ride"] = 103.37, ["Mega"] = 168, ["Mega|Ride"] = 228.43}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.97, ["Fly"] = 57.75, ["Ride"] = 42.67, ["Fly|Ride"] = 180.36, ["Neon"] = 19.42, ["Neon|Fly"] = 123.36, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 106.32, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.38, ["Fly"] = 138.18, ["Ride"] = 94.5, ["Fly|Ride"] = 242.82, ["Neon"] = 94.5, ["Neon|Fly"] = 206.72, ["Neon|Ride"] = 206.72, ["Neon|Fly|Ride"] = 465.53, ["Mega"] = 482.68, ["Mega|Fly"] = 689.39, ["Mega|Ride"] = 501.6, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 46.41, ["Ride"] = 103.27, ["Fly|Ride"] = 136.5, ["Neon"] = 283.04, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 918.75, ["Mega|Ride"] = 1089.39, ["Mega|Fly|Ride"] = 1116.26}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 18.37, ["Fly|Ride"] = 51.69, ["Neon"] = 2.63, ["Neon|Ride"] = 38.45, ["Mega"] = 26.49, ["Mega|Ride"] = 68.51, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 64.31, ["Neon"] = 97.16, ["Mega|Fly|Ride"] = 1240.29}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.74, ["Fly"] = 105, ["Ride"] = 91.88, ["Neon"] = 304.5, ["Neon|Ride"] = 275.98, ["Mega|Ride"] = 1102.82, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.93, ["Fly"] = 190.32, ["Ride"] = 26.25, ["Fly|Ride"] = 126, ["Neon"] = 49.87, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 192.93, ["Mega|Ride"] = 221.81, ["Mega|Fly|Ride"] = 366.94}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.1, ["Ride"] = 82.62, ["Fly|Ride"] = 137.69, ["Neon"] = 8.61, ["Neon|Ride"] = 40.69, ["Mega"] = 60.37, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 241.87}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.37, ["Fly|Ride"] = 45.93, ["Neon"] = 11.69, ["Neon|Ride"] = 35.16, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 164.07, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 15.44, ["Fly|Ride"] = 27.56, ["Neon"] = 2.62, ["Neon|Ride"] = 27.92, ["Neon|Fly|Ride"] = 46.57, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 74.27, ["Neon"] = 4.64, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 40.46, ["Mega|Fly"] = 168, ["Mega|Ride"] = 68.77, ["Mega|Fly|Ride"] = 150.9}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.93, ["Neon"] = 2.5, ["Neon|Ride"] = 137.96, ["Mega"] = 21.91, ["Mega|Ride"] = 551.94, ["Mega|Fly|Ride"] = 304.91}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.8, ["Ride"] = 44.41, ["Neon"] = 30.09, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 620.15, ["Mega"] = 155.97, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 252.76}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.76, ["Ride"] = 26.79, ["Fly|Ride"] = 189.96, ["Neon"] = 69.26, ["Neon|Ride"] = 103.37, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 455.82, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.71, ["Fly"] = 21.94, ["Ride"] = 20.58, ["Fly|Ride"] = 32.55, ["Neon"] = 29.01, ["Neon|Fly"] = 69.26, ["Neon|Ride"] = 43.57, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 452.82, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 81.24, ["Ride"] = 263.31, ["Fly|Ride"] = 262.5, ["Neon"] = 275.98, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 27.54, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 138.51, ["Neon"] = 124.69, ["Neon|Fly|Ride"] = 630, ["Mega"] = 882.18, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.5, ["Fly|Ride"] = 40.32, ["Neon"] = 3.93, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 20.68, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 32.16, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.29, ["Ride"] = 14.34, ["Fly|Ride"] = 30.91, ["Neon"] = 3.94, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.22, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 44.63, ["Mega|Fly"] = 82.7, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 86.68}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 498.75, ["Fly"] = 574.37, ["Ride"] = 516, ["Fly|Ride"] = 524.11, ["Neon|Fly|Ride"] = 1531.21}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.03, ["Ride"] = 90.19, ["Neon"] = 210, ["Neon|Ride"] = 97.16, ["Mega"] = 403.86, ["Mega|Ride"] = 663.38, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.48, ["Ride"] = 14.44, ["Fly|Ride"] = 36.04, ["Neon"] = 2.63, ["Neon|Fly"] = 26.88, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 43.32, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 59.76, ["Ride"] = 137.93, ["Fly|Ride"] = 328.13, ["Neon"] = 255.29, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 512.1, ["Mega"] = 861.84, ["Mega|Ride"] = 888.87, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 68.96, ["Ride"] = 19.69, ["Fly|Ride"] = 35.44, ["Neon"] = 13.02, ["Neon|Fly"] = 41.49, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 74.66, ["Mega"] = 84.96, ["Mega|Fly"] = 206.72, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 190.59}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.11, ["Ride"] = 39.53, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.93, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 39.29, ["Mega|Fly"] = 270.8, ["Mega|Ride"] = 84.76, ["Mega|Fly|Ride"] = 186.23}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.37, ["Fly"] = 143.22, ["Ride"] = 92.21, ["Fly|Ride"] = 206.53, ["Neon"] = 186.38, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 4.38, ["Neon|Ride"] = 39.99, ["Mega"] = 41.18, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.8, ["Ride"] = 96.78, ["Fly|Ride"] = 138.51, ["Neon"] = 309.04, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1633.05, ["Mega|Ride"] = 1653.7, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.63, ["Ride"] = 47.52, ["Fly|Ride"] = 157.12, ["Neon"] = 21.76, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 482.68, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 69.11, ["Ride"] = 26.25, ["Fly|Ride"] = 66.09, ["Neon"] = 10.28, ["Neon|Ride"] = 51.69, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 119.91, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.3, ["Ride"] = 95.01, ["Fly|Ride"] = 393.75, ["Neon"] = 275.63, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2065.06, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1168.97}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.22, ["Ride"] = 28.88, ["Fly|Ride"] = 908.98, ["Neon"] = 7.26, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 152.49, ["Mega"] = 45.5, ["Mega|Fly"] = 249.61, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 17.45, ["Fly|Ride"] = 102.88, ["Neon"] = 40.69, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 23.79, ["Neon|Fly|Ride"] = 59.07, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.4, ["Fly"] = 45.39, ["Ride"] = 26.25, ["Fly|Ride"] = 77.98, ["Neon"] = 77.53, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 147.82, ["Mega"] = 430.5, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 24.94, ["Ride"] = 29.39, ["Fly|Ride"] = 64.7, ["Neon"] = 138.51, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1061.49, ["Mega|Ride"] = 1860.42, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.16, ["Fly"] = 51.18, ["Ride"] = 31.49, ["Fly|Ride"] = 74.11, ["Neon"] = 81.38, ["Neon|Ride"] = 109.4, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 58.94, ["Fly"] = 82.5, ["Ride"] = 118.76, ["Fly|Ride"] = 242.54, ["Neon"] = 294, ["Neon|Ride"] = 448.59, ["Neon|Fly|Ride"] = 551.94, ["Mega|Ride"] = 1367.28, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.84, ["Ride"] = 44.05, ["Fly|Ride"] = 388.64, ["Neon"] = 24.94, ["Neon|Ride"] = 108.78, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 213.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 308.02}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.67, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 73.4, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 171.59, ["Mega|Ride"] = 186.23, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 18.38, ["Fly"] = 52.5, ["Ride"] = 40.28, ["Fly|Ride"] = 97.16, ["Neon"] = 46.25, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 93.12, ["Mega"] = 430.5, ["Mega|Ride"] = 314.22, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.12, ["Fly|Ride"] = 32.06, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 46.26, ["Mega"] = 15.75, ["Mega|Ride"] = 23.5, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 59.07, ["Fly"] = 138.18, ["Ride"] = 91.88, ["Fly|Ride"] = 297.89, ["Neon"] = 205.7, ["Neon|Fly"] = 2343.09, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1396.59, ["Mega|Ride"] = 1500.74, ["Mega|Fly|Ride"] = 974.67}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.85, ["Neon"] = 6.02, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 69.26, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 15.11, ["Fly|Ride"] = 45.93, ["Neon"] = 18.38, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 30.8, ["Neon|Fly|Ride"] = 94.75, ["Mega"] = 262.55, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 82.69, ["Ride"] = 123.43, ["Fly|Ride"] = 222.6, ["Neon"] = 275.98, ["Neon|Ride"] = 335.2, ["Neon|Fly|Ride"] = 606.72, ["Mega"] = 1233.75, ["Mega|Ride"] = 1303.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.74, ["Neon"] = 7.75, ["Neon|Ride"] = 63.67, ["Mega"] = 63.65, ["Mega|Ride"] = 155.97, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.5}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 31.5, ["Fly|Ride"] = 57.71, ["Neon"] = 4.66, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 202.52, ["Mega"] = 48.15, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 103.69, ["Ride"] = 204.46, ["Fly|Ride"] = 138.37, ["Neon"] = 472.5, ["Neon|Ride"] = 683.18, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 3569.44, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2840.24}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 40.86, ["Neon"] = 39.25, ["Neon|Ride"] = 54.11, ["Mega"] = 159.93, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Neon"] = 4.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.02, ["Ride"] = 22.1, ["Neon"] = 32.82, ["Neon|Ride"] = 108.8, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.49, ["Fly"] = 25.47, ["Ride"] = 20.86, ["Fly|Ride"] = 54.32, ["Neon"] = 81.04, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 165.39, ["Mega"] = 597.19, ["Mega|Ride"] = 413.43, ["Mega|Fly|Ride"] = 469.26}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 26.24, ["Ride"] = 70.79, ["Fly|Ride"] = 123.36, ["Neon"] = 143.38, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 621.5, ["Mega|Ride"] = 557.29, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 147.28, ["Fly"] = 183.74, ["Ride"] = 202.67, ["Fly|Ride"] = 206.72, ["Neon"] = 590.66, ["Neon|Fly"] = 659.75, ["Neon|Ride"] = 577.49, ["Neon|Fly|Ride"] = 597.43, ["Mega|Fly|Ride"] = 2415}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 16.94, ["Fly"] = 37.38, ["Ride"] = 26.14, ["Fly|Ride"] = 49.26, ["Neon"] = 133.47, ["Neon|Fly"] = 6201.37, ["Neon|Ride"] = 131.28, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 682.16, ["Mega|Fly|Ride"] = 643.38}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 4.09, ["Fly"] = 118.13, ["Ride"] = 18.52, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Fly"] = 69.26, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.84, ["Mega"] = 127.77, ["Mega|Ride"] = 179.86, ["Mega|Fly|Ride"] = 249.6}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.19, ["Fly"] = 232.08, ["Ride"] = 31.91, ["Fly|Ride"] = 117.02, ["Neon"] = 38.07, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 69.26, ["Neon|Fly|Ride"] = 124.04, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 138.18, ["Ride"] = 87.87, ["Fly|Ride"] = 179.67, ["Neon"] = 195.57, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 380.52, ["Mega"] = 1178.27, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 1017.19}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.03, ["Ride"] = 105, ["Neon"] = 155.93, ["Neon|Ride"] = 238.76, ["Neon|Fly|Ride"] = 455.82, ["Mega"] = 656.24, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 813.43}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 410.82, ["Fly|Ride"] = 386.18, ["Neon|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 6201.37}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Ride"] = 37.97, ["Fly|Ride"] = 69.57, ["Neon"] = 228.51, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 964.6}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.9, ["Ride"] = 15.36, ["Fly|Ride"] = 102.54, ["Neon"] = 3.15, ["Neon|Ride"] = 17.97, ["Neon|Fly|Ride"] = 64.34, ["Mega"] = 21.73, ["Mega|Fly"] = 103.37, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.61, ["Ride"] = 19.69, ["Neon"] = 16.96, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 408.28}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 8.27, ["Ride"] = 57.75, ["Fly|Ride"] = 144.17, ["Neon"] = 18.37, ["Neon|Ride"] = 81.67, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 124.52, ["Mega|Fly"] = 537.47, ["Mega|Ride"] = 239.69, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 619.63, ["Ride"] = 452.24, ["Fly|Ride"] = 647.07, ["Neon"] = 1498.67, ["Neon|Ride"] = 1378.78, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 54.74, ["Ride"] = 16.65, ["Fly|Ride"] = 50.93, ["Neon"] = 29.99, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 77.53, ["Mega"] = 168, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.81, ["Fly"] = 17, ["Ride"] = 17.07, ["Fly|Ride"] = 44.63, ["Neon"] = 31.43, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 51.69, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 689.39, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.13, ["Fly"] = 27.57, ["Ride"] = 27.56, ["Fly|Ride"] = 103.27, ["Neon"] = 16.49, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.56, ["Neon|Fly|Ride"] = 111.74, ["Mega"] = 78.75, ["Mega|Ride"] = 221.2, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.66, ["Fly"] = 45.93, ["Ride"] = 40.2, ["Fly|Ride"] = 82.62, ["Neon"] = 137.85, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 97.16, ["Mega"] = 930.22, ["Mega|Ride"] = 826.86, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 27.72, ["Fly|Ride"] = 68.66, ["Neon"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 428.94, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.57, ["Fly"] = 787.5, ["Ride"] = 19.69, ["Fly|Ride"] = 85.63, ["Neon"] = 131.25, ["Neon|Ride"] = 164.33, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 689.39, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.82, ["Neon|Ride"] = 20.68, ["Mega"] = 45.93, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.29, ["Ride"] = 138.37, ["Neon"] = 94.5, ["Mega"] = 165.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.42, ["Ride"] = 39.38, ["Neon"] = 62.91, ["Neon|Ride"] = 103.37, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 325.89, ["Mega|Ride"] = 343.33, ["Mega|Fly|Ride"] = 548.83}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.5, ["Fly"] = 31.5, ["Ride"] = 28.68, ["Fly|Ride"] = 44.63, ["Neon"] = 59.05, ["Neon|Fly"] = 116.4, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 113.88, ["Mega"] = 580.88, ["Mega|Ride"] = 396.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 410.27, ["Ride"] = 282.19, ["Fly|Ride"] = 389.81, ["Neon"] = 1473.87, ["Neon|Ride"] = 1172.07, ["Neon|Fly|Ride"] = 1221.95, ["Mega|Fly|Ride"] = 5085.13}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 56.8, ["Neon"] = 10.29, ["Neon|Fly"] = 77.98, ["Neon|Ride"] = 58.92, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 221.2, ["Mega|Ride"] = 155.97, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.25, ["Fly"] = 27.65, ["Ride"] = 27.8, ["Fly|Ride"] = 80.63, ["Neon"] = 37.38, ["Neon|Ride"] = 69.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 386.56}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 31.5, ["Ride"] = 100.97, ["Fly|Ride"] = 340.45, ["Neon"] = 93.1, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.11, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 500.54}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 105, ["Fly"] = 393.75, ["Ride"] = 140.44, ["Fly|Ride"] = 274.82, ["Neon"] = 549.87, ["Neon|Fly"] = 1048.05, ["Neon|Ride"] = 465.53, ["Neon|Fly|Ride"] = 686.31, ["Mega"] = 3103.91, ["Mega|Ride"] = 1792.88, ["Mega|Fly|Ride"] = 2208.75}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.25, ["Fly"] = 110.35, ["Ride"] = 119.79, ["Neon"] = 74.07, ["Neon|Ride"] = 189.15, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 249.38, ["Mega|Ride"] = 275.42, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 26.25, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 39.38, ["Mega|Ride"] = 194.37, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.67, ["Ride"] = 25.99, ["Fly|Ride"] = 81.67, ["Neon"] = 27.79, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 171.08, ["Mega"] = 136.92, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 508.52}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 92.85, ["Fly"] = 196.88, ["Ride"] = 111.56, ["Fly|Ride"] = 216.57, ["Neon"] = 141.26, ["Neon|Ride"] = 168.51, ["Neon|Fly|Ride"] = 302.3, ["Mega"] = 446.25, ["Mega|Ride"] = 413.43, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 65.63, ["Neon"] = 7.38, ["Neon|Ride"] = 205.7, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 59.07, ["Mega|Fly"] = 241.87, ["Mega|Ride"] = 152.99, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.33, ["Fly|Ride"] = 274.95, ["Neon"] = 95.82, ["Neon|Ride"] = 401.03, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 785.52}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 961.54, ["Fly"] = 1257.8, ["Ride"] = 1050, ["Fly|Ride"] = 862.32, ["Neon"] = 3032.48, ["Neon|Ride"] = 3881.35, ["Neon|Fly|Ride"] = 2741.82, ["Mega|Fly|Ride"] = 14331.36}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.57, ["Fly"] = 116.05, ["Ride"] = 119.43, ["Fly|Ride"] = 191.63, ["Neon"] = 123.38, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 193.3, ["Mega"] = 962.26, ["Mega|Ride"] = 516.79, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 25.91, ["Fly|Ride"] = 80.89, ["Neon"] = 12.8, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 82.59, ["Mega|Ride"] = 117.34, ["Mega|Fly|Ride"] = 206.45}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.67, ["Ride"] = 131.22, ["Fly|Ride"] = 138.37, ["Neon"] = 117.41, ["Mega"] = 234.02, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 16.82, ["Fly|Ride"] = 179.86, ["Neon"] = 2.1, ["Neon|Ride"] = 20.68, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 19.69, ["Mega|Fly"] = 124.04, ["Mega|Ride"] = 49.08, ["Mega|Fly|Ride"] = 138.51}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.5, ["Ride"] = 118.76, ["Fly|Ride"] = 225.74, ["Neon"] = 302.76, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 469.26, ["Mega"] = 1030.53, ["Mega|Ride"] = 1574.99, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.67, ["Fly"] = 174.57, ["Ride"] = 23.62, ["Fly|Ride"] = 86.63, ["Neon"] = 47.16, ["Neon|Ride"] = 97.16, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 400, ["Mega|Ride"] = 456.84, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.68, ["Fly"] = 96.66, ["Ride"] = 26.78, ["Fly|Ride"] = 46.51, ["Neon"] = 16.37, ["Neon|Ride"] = 47.22, ["Mega"] = 93.12, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 40.58, ["Ride"] = 60.94, ["Fly|Ride"] = 196.88, ["Neon"] = 198.47, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 683.18, ["Mega|Ride"] = 1033.57, ["Mega|Fly|Ride"] = 776.29}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 11.36, ["Ride"] = 44.18, ["Fly|Ride"] = 86.24, ["Neon"] = 58.2, ["Neon|Ride"] = 102.34, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 344.16, ["Mega|Ride"] = 504.39, ["Mega|Fly|Ride"] = 463.05}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 50.8, ["Ride"] = 84, ["Neon"] = 388.64, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 1867.7, ["Mega|Ride"] = 1653.7, ["Mega|Fly|Ride"] = 1585.49}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.24, ["Neon"] = 23.26, ["Neon|Ride"] = 81.63, ["Neon|Fly|Ride"] = 621.5, ["Mega"] = 105, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 287.34}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Ride"] = 22.31, ["Fly|Ride"] = 78.74, ["Neon"] = 45.02, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 363.81, ["Mega|Fly|Ride"] = 353.5}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 126, ["Fly"] = 515.58, ["Ride"] = 131.25, ["Fly|Ride"] = 259.58, ["Neon"] = 446.25, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 551.94, ["Mega"] = 3160.64, ["Mega|Ride"] = 2367.9, ["Mega|Fly|Ride"] = 1890}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 23.39, ["Ride"] = 18.37, ["Fly|Ride"] = 41.15, ["Neon"] = 11.46, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 100.1, ["Mega"] = 124.59, ["Mega|Fly"] = 124.53, ["Mega|Ride"] = 144.72, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.78, ["Fly"] = 88.29, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Fly"] = 186.23, ["Neon|Ride"] = 93.12, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 375.85, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 345.22}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.5, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 41.35, ["Mega"] = 14.44, ["Mega|Fly"] = 48.9, ["Mega|Ride"] = 30.86, ["Mega|Fly|Ride"] = 77.48}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.77, ["Fly|Ride"] = 65.63, ["Neon"] = 2.63, ["Neon|Ride"] = 39.29, ["Mega"] = 19.69, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 64.97, ["Mega|Fly|Ride"] = 110.6}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.92, ["Fly"] = 35.07, ["Ride"] = 19.66, ["Fly|Ride"] = 83.61, ["Neon"] = 14.97, ["Neon|Ride"] = 59.37, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 158.16, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 36.66, ["Ride"] = 315, ["Neon"] = 117.74, ["Neon|Ride"] = 413.43, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 668.72}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 16.83, ["Fly|Ride"] = 31.86, ["Neon"] = 11.38, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 27.83, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 115.23, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 118.51, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.8, ["Fly"] = 31.5, ["Ride"] = 23.93, ["Fly|Ride"] = 57, ["Neon"] = 29.69, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 182.44, ["Mega|Fly"] = 413.43, ["Mega|Ride"] = 178.62, ["Mega|Fly|Ride"] = 218.3}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 18.09, ["Fly|Ride"] = 74.08, ["Neon"] = 10.39, ["Neon|Fly"] = 86.12, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 62.34, ["Mega"] = 69.84, ["Mega|Fly"] = 102.34, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.09, ["Fly"] = 36.1, ["Ride"] = 32.95, ["Neon"] = 32.82, ["Neon|Ride"] = 80.31, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 224.13, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.12}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.57, ["Fly"] = 171.19, ["Ride"] = 122.72, ["Fly|Ride"] = 181.92, ["Neon"] = 123.38, ["Neon|Ride"] = 252.04, ["Neon|Fly|Ride"] = 345.22, ["Mega"] = 548.63, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.76, ["Fly"] = 41.88, ["Ride"] = 22.21, ["Fly|Ride"] = 65.54, ["Neon"] = 24.22, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 310.76, ["Mega|Ride"] = 232.78, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.6, ["Fly|Ride"] = 34.94, ["Neon"] = 11.64, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.15, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 181.83, ["Fly"] = 382.05, ["Ride"] = 299.44, ["Fly|Ride"] = 392.44, ["Neon"] = 965.35, ["Neon|Ride"] = 1240.29, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.36, ["Ride"] = 61.76, ["Neon"] = 27.92, ["Neon|Ride"] = 55.83, ["Neon|Fly|Ride"] = 413.43, ["Mega"] = 119.62, ["Mega|Ride"] = 413.43, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.62, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 77.46, ["Neon"] = 23.15, ["Neon|Fly"] = 221.2, ["Neon|Ride"] = 36.09, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 199.4, ["Mega|Ride"] = 279.33, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.42, ["Ride"] = 27.89, ["Neon"] = 60.37, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 620.15, ["Mega"] = 461.77, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 13.13, ["Fly|Ride"] = 31.02, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 17.05, ["Fly|Ride"] = 58.97, ["Neon"] = 9.16, ["Neon|Ride"] = 28.98, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 101.04, ["Mega|Ride"] = 143.57, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.42, ["Ride"] = 69.2, ["Neon"] = 16.55, ["Neon|Ride"] = 206.72, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 60.22, ["Mega|Ride"] = 205.7, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 73.5, ["Fly"] = 123.76, ["Ride"] = 103.27, ["Fly|Ride"] = 139.13, ["Neon"] = 621.35, ["Neon|Ride"] = 567.96, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 2067.13, ["Mega|Ride"] = 3446.93, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.71, ["Fly"] = 91.88, ["Ride"] = 30.23, ["Fly|Ride"] = 262.46, ["Neon"] = 21.41, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 209.42, ["Mega|Ride"] = 351.43, ["Mega|Fly|Ride"] = 412.4}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.52, ["Fly|Ride"] = 118.88, ["Neon"] = 15.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.69, ["Fly"] = 210, ["Ride"] = 73.37, ["Fly|Ride"] = 204.46, ["Neon"] = 150.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 310.76, ["Mega"] = 523.69, ["Mega|Ride"] = 621.5, ["Mega|Fly|Ride"] = 618.3}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 13.9, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 18.62, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 17.07, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 93.52}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 123.67, ["Mega"] = 23.79, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.8, ["Ride"] = 107.63, ["Neon"] = 9.85, ["Neon|Ride"] = 114.75, ["Neon|Fly|Ride"] = 181.92, ["Mega"] = 64.32, ["Mega|Fly"] = 179.86, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.5, ["Fly"] = 68.25, ["Ride"] = 38.06, ["Fly|Ride"] = 131.28, ["Neon"] = 21.24, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 69.32, ["Neon|Fly|Ride"] = 232.78, ["Mega"] = 103.69, ["Mega|Fly"] = 334.03, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.49, ["Ride"] = 13, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Ride"] = 48.59, ["Neon|Fly|Ride"] = 67.19, ["Mega"] = 23.29, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.96, ["Fly"] = 72.19, ["Ride"] = 117.73, ["Neon"] = 118.13, ["Neon|Fly"] = 413.43, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 965.35, ["Mega"] = 498.12, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 682.16}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Ride"] = 2520.9, ["Fly|Ride"] = 2521.64, ["Neon"] = 9330.99, ["Neon|Fly|Ride"] = 9619.35, ["Mega|Fly|Ride"] = 34727.61}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.4, ["Ride"] = 15.09, ["Fly|Ride"] = 37.42, ["Neon"] = 10.5, ["Neon|Fly"] = 62.49, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 52.73, ["Mega"] = 76.51, ["Mega|Fly"] = 455.82, ["Mega|Ride"] = 112.95, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.03, ["Neon"] = 13.98, ["Neon|Ride"] = 97.16, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 24, ["Ride"] = 34.13, ["Fly|Ride"] = 157.5, ["Neon"] = 105, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 266.67, ["Mega"] = 393.75, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 551.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 30.8, ["Ride"] = 66.94, ["Neon"] = 155.07, ["Neon|Ride"] = 206.72, ["Mega"] = 540.65, ["Mega|Ride"] = 772.08, ["Mega|Fly|Ride"] = 814.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 141.31, ["Fly"] = 1375.55, ["Ride"] = 197.73, ["Fly|Ride"] = 308.49, ["Neon"] = 689.39, ["Neon|Ride"] = 689.39, ["Neon|Fly|Ride"] = 748.27, ["Mega"] = 6201.37, ["Mega|Fly|Ride"] = 3378.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.19, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.15, ["Neon|Ride"] = 128.7, ["Mega"] = 106.32, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.77, ["Neon"] = 13.13, ["Neon|Fly"] = 103.37, ["Neon|Ride"] = 275.83, ["Neon|Fly|Ride"] = 516.79, ["Mega"] = 114.76, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.83, ["Fly"] = 101.99, ["Ride"] = 40.35, ["Fly|Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Ride"] = 56.44, ["Mega"] = 86.1, ["Mega|Ride"] = 96.84, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.89, ["Ride"] = 103.27, ["Neon"] = 131.25, ["Neon|Ride"] = 1165.83, ["Neon|Fly|Ride"] = 486.83, ["Mega|Ride"] = 599.48, ["Mega|Fly|Ride"] = 721.44}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.7, ["Mega"] = 17.07, ["Mega|Fly"] = 115.58, ["Mega|Ride"] = 153.88}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.88, ["Fly"] = 138.18, ["Ride"] = 102.94, ["Fly|Ride"] = 168.32, ["Neon"] = 410.84, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 482.99, ["Mega|Fly|Ride"] = 1731.22}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 10.21, ["Neon|Ride"] = 69.26, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 69.84, ["Mega|Ride"] = 193.3, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 42.79, ["Fly"] = 103.13, ["Ride"] = 81.2, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1677.38}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.63, ["Fly|Ride"] = 50.8, ["Neon"] = 3.94, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 43.32, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 166.82}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 4.14, ["Neon"] = 11.17, ["Neon|Ride"] = 118.13, ["Mega"] = 60.38, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 607.74}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.5, ["Ride"] = 36.65, ["Fly|Ride"] = 157.5, ["Neon"] = 51.05, ["Neon|Ride"] = 95.1, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 230.79, ["Mega|Ride"] = 345.22, ["Mega|Fly|Ride"] = 921.76}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 419.99, ["Ride"] = 446.25, ["Fly|Ride"] = 525, ["Neon"] = 1231.13, ["Neon|Ride"] = 1509.01, ["Neon|Fly|Ride"] = 1246.65, ["Mega"] = 4655.28, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.33, ["Ride"] = 55, ["Fly|Ride"] = 92.94, ["Neon"] = 206.72, ["Neon|Ride"] = 204.58, ["Neon|Fly|Ride"] = 274.95, ["Mega"] = 1378.78, ["Mega|Ride"] = 1219.62, ["Mega|Fly|Ride"] = 1102.82}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 19.46, ["Fly|Ride"] = 91.88, ["Neon"] = 7.27, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 50.43, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.31, ["Fly"] = 81.19, ["Ride"] = 54.65, ["Fly|Ride"] = 155.93, ["Neon"] = 44.89, ["Neon|Fly"] = 105, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 257.25, ["Mega|Fly"] = 957.84, ["Mega|Ride"] = 244.5, ["Mega|Fly|Ride"] = 343.71}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.12, ["Ride"] = 20.68, ["Fly|Ride"] = 263.58, ["Neon"] = 138.51, ["Neon|Ride"] = 128.18, ["Neon|Fly|Ride"] = 310.76, ["Mega"] = 1102.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.88, ["Ride"] = 27.89, ["Neon"] = 15.74, ["Mega"] = 68.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.5, ["Fly"] = 86.62, ["Ride"] = 20.16, ["Fly|Ride"] = 57.64, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.87, ["Mega"] = 138.51, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1653.7}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 108.8, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon"] = 717.3, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 698.31, ["Mega|Fly|Ride"] = 2591.15}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 21.67, ["Ride"] = 103.27, ["Fly|Ride"] = 138.37, ["Neon"] = 192.94, ["Neon|Ride"] = 192.15, ["Neon|Fly|Ride"] = 274.96, ["Mega"] = 682.5, ["Mega|Ride"] = 722.47, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.71, ["Fly"] = 2473.69, ["Ride"] = 2229.94, ["Fly|Ride"] = 2244.38, ["Neon"] = 11024.99, ["Neon|Fly|Ride"] = 5848.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 196.87, ["Neon"] = 8.79, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 193.3, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.77, ["Ride"] = 74.11, ["Fly|Ride"] = 97.07, ["Neon"] = 33.76, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.41, ["Mega|Ride"] = 294.73, ["Mega|Fly|Ride"] = 531.26}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 872.82, ["Fly"] = 1158.02, ["Ride"] = 925.73, ["Fly|Ride"] = 984.38, ["Neon"] = 2623.69, ["Neon|Ride"] = 2949.14, ["Neon|Fly|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.19, ["Ride"] = 55.77, ["Fly|Ride"] = 173.35, ["Neon"] = 155.93, ["Neon|Ride"] = 291.72, ["Mega"] = 839.9, ["Mega|Ride"] = 776.29, ["Mega|Fly|Ride"] = 689.39}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.96, ["Ride"] = 22.91, ["Fly|Ride"] = 128.15, ["Neon"] = 15.44, ["Neon|Ride"] = 41.35, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 194.25, ["Mega|Ride"] = 123.97, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138.37, ["Neon"] = 3.94, ["Neon|Fly"] = 41.35, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 77.99, ["Mega"] = 39.38, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.95, ["Ride"] = 127.32, ["Fly|Ride"] = 310.35, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2327.64, ["Mega|Fly|Ride"] = 2483.61}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.6, ["Neon"] = 23.29, ["Neon|Ride"] = 65.19, ["Neon|Fly|Ride"] = 116.4, ["Mega"] = 145.36, ["Mega|Ride"] = 317.31, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.03, ["Ride"] = 136.49, ["Neon"] = 380.63, ["Neon|Ride"] = 465.53, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 15.45, ["Fly"] = 105, ["Fly|Ride"] = 110.5, ["Neon"] = 39.22, ["Neon|Ride"] = 77.99, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 203.44, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 179.86}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Ride"] = 274.66, ["Fly|Ride"] = 364.74, ["Neon"] = 1410.28, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.07, ["Fly"] = 87.83, ["Ride"] = 17.45, ["Fly|Ride"] = 55.77, ["Neon"] = 37.25, ["Neon|Ride"] = 64.36, ["Neon|Fly|Ride"] = 114.17, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 349.41}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 6.46, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 44.85, ["Mega|Fly"] = 95.04, ["Mega|Ride"] = 77.84, ["Mega|Fly|Ride"] = 127.81}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.81, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 7580.14, ["Neon|Fly|Ride"] = 5513.02, ["Mega"] = 26184.21}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.13, ["Fly"] = 963.09, ["Ride"] = 210, ["Neon"] = 57.1, ["Neon|Ride"] = 129.4, ["Mega"] = 236.25, ["Mega|Ride"] = 345.22, ["Mega|Fly|Ride"] = 455.82}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.48, ["Fly"] = 54.91, ["Ride"] = 19.69, ["Fly|Ride"] = 95.82, ["Neon"] = 24.94, ["Neon|Fly"] = 93.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 179.2, ["Mega|Fly"] = 228.43, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.98, ["Fly"] = 40.78, ["Ride"] = 44.23, ["Fly|Ride"] = 66.26, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2067.13, ["Mega|Ride"] = 1240.29, ["Mega|Fly|Ride"] = 860.9}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.95, ["Fly"] = 59.07, ["Ride"] = 27.42, ["Fly|Ride"] = 89.24, ["Neon"] = 67.59, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 29.87, ["Fly"] = 109.08, ["Ride"] = 209.98, ["Fly|Ride"] = 402.7, ["Neon"] = 105.09, ["Neon|Ride"] = 275.98, ["Mega"] = 486.83, ["Mega|Ride"] = 576.75, ["Mega|Fly|Ride"] = 826.86}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 232.47, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 310.76, ["Mega"] = 18.38, ["Mega|Ride"] = 71.07, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.19, ["Fly"] = 102.38, ["Ride"] = 52.5, ["Fly|Ride"] = 131.15, ["Neon"] = 337.89, ["Neon|Fly"] = 383.98, ["Neon|Ride"] = 302.6, ["Neon|Fly|Ride"] = 371.67, ["Mega"] = 3307.4, ["Mega|Fly|Ride"] = 1182.39}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 19.91, ["Fly|Ride"] = 77.49, ["Neon"] = 31.5, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 338.12, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 16.48, ["Fly|Ride"] = 38.07, ["Neon"] = 14.11, ["Neon|Ride"] = 52.73, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.25, ["Ride"] = 172.46, ["Neon"] = 20.13, ["Neon|Fly|Ride"] = 185.03, ["Mega"] = 262.55, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.16, ["Ride"] = 66.09, ["Fly|Ride"] = 138.37, ["Neon"] = 232.73, ["Neon|Ride"] = 304.91, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1021.17, ["Mega|Ride"] = 1017.19, ["Mega|Fly|Ride"] = 937.46}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.87, ["Ride"] = 688.72, ["Fly|Ride"] = 413.43, ["Neon"] = 20.88, ["Neon|Ride"] = 77.53, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 92.69, ["Mega|Ride"] = 110.6, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 20.6, ["Mega"] = 15.65, ["Mega|Ride"] = 55.83, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.11, ["Ride"] = 24.47, ["Fly|Ride"] = 82.7, ["Neon"] = 2.56, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 21.77, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 22.17, ["Ride"] = 19.63, ["Fly|Ride"] = 38.66, ["Neon"] = 5.15, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 76.51, ["Mega"] = 99.24, ["Mega|Ride"] = 58.49, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 21.74, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.36, ["Fly"] = 39.19, ["Ride"] = 15.4, ["Fly|Ride"] = 47.25, ["Neon"] = 15.65, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 229.04, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 64.22, ["Ride"] = 155.23, ["Fly|Ride"] = 361.76, ["Neon"] = 196.88, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1033.57, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 1048.05}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 14.82, ["Fly|Ride"] = 35.43, ["Neon"] = 3.67, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 48.59, ["Mega"] = 30.24, ["Mega|Ride"] = 55.83, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.53, ["Fly"] = 79.5, ["Ride"] = 37.19, ["Fly|Ride"] = 82.4, ["Neon"] = 55.83, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 62.52, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 236.91, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.65, ["Fly"] = 51.49, ["Ride"] = 26.17, ["Fly|Ride"] = 65.63, ["Neon"] = 108.94, ["Neon|Ride"] = 124.04, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 787.5, ["Mega|Ride"] = 413.43, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.37, ["Fly"] = 196.88, ["Fly|Ride"] = 51.64, ["Neon"] = 45.94, ["Neon|Ride"] = 82.7, ["Mega"] = 289.42, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 409.31}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.42, ["Fly|Ride"] = 38.98, ["Neon"] = 3.93, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 42.31, ["Mega|Fly"] = 169.52, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.77, ["Fly"] = 39.38, ["Ride"] = 30.19, ["Neon"] = 10.28, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1017.53, ["Fly"] = 963.09, ["Ride"] = 974.43, ["Fly|Ride"] = 1076.24, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2264.07, ["Mega|Fly|Ride"] = 6891.39}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.37, ["Ride"] = 137.82, ["Fly|Ride"] = 202.48, ["Neon"] = 406.88, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 606.72, ["Mega"] = 3099.66, ["Mega|Ride"] = 2067.13, ["Mega|Fly|Ride"] = 1643.24}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.81, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 206.72, ["Mega"] = 73.9, ["Mega|Fly|Ride"] = 206.72}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.74, ["Ride"] = 77.46, ["Fly|Ride"] = 139.49, ["Neon"] = 310.08, ["Neon|Ride"] = 261.09, ["Neon|Fly|Ride"] = 413.43, ["Mega"] = 1050, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.55, ["Ride"] = 26.37, ["Fly|Ride"] = 89.94, ["Neon"] = 63.07, ["Neon|Fly"] = 54.71, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 268.55, ["Mega|Ride"] = 347.28, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.05, ["Fly"] = 412.47, ["Ride"] = 275.7, ["Fly|Ride"] = 443.98, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1750.86, ["Mega|Fly|Ride"] = 4353.38}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 39.25, ["Fly|Ride"] = 202.64, ["Neon"] = 24.68, ["Neon|Ride"] = 54.28, ["Mega"] = 138.51, ["Mega|Fly"] = 322.48, ["Mega|Ride"] = 186.23, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 20.68, ["Neon|Ride"] = 155.97, ["Mega"] = 330.75}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 38.07, ["Ride"] = 65.63, ["Fly|Ride"] = 165.39, ["Neon"] = 164.07, ["Neon|Fly"] = 275.98, ["Neon|Ride"] = 192.26, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 542, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 275.98, ["Neon"] = 20.68, ["Mega"] = 196.88, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.5, ["Fly|Ride"] = 34.13, ["Neon"] = 3.68, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 137.93, ["Neon|Fly|Ride"] = 37.53, ["Mega"] = 26.86, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4396.88, ["Fly|Ride"] = 4436.25, ["Neon"] = 31006.8, ["Neon|Fly|Ride"] = 21774.01, ["Mega|Fly|Ride"] = 85441.29}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.49, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega"] = 275.98, ["Mega|Ride"] = 213.62, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 22.28, ["Ride"] = 20.66, ["Fly|Ride"] = 39.83, ["Neon"] = 12.76, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 31.22, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 155.97, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 494.61, ["Fly"] = 547.77, ["Ride"] = 478.79, ["Fly|Ride"] = 551.94, ["Neon"] = 1378.78, ["Neon|Ride"] = 1653.7, ["Neon|Fly|Ride"] = 1529.29, ["Mega|Fly|Ride"] = 4961.1}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 7.87, ["Ride"] = 26.24, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 139.08, ["Mega|Fly|Ride"] = 689.39}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.11, ["Fly"] = 4110.2, ["Ride"] = 46.51, ["Neon"] = 27.92, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 411.37, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.36, ["Ride"] = 23.14, ["Neon"] = 5.12, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.39, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 275.98}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 742.62, ["Fly"] = 873.38, ["Ride"] = 630, ["Fly|Ride"] = 724.5, ["Neon"] = 2362.5, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2208.63}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Fly"] = 56.44, ["Ride"] = 73.07, ["Neon"] = 31.24, ["Neon|Ride"] = 97.16, ["Neon|Fly|Ride"] = 152.99, ["Mega"] = 156.19, ["Mega|Ride"] = 199.08, ["Mega|Fly|Ride"] = 357.62}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 9.45, ["Fly"] = 52.5, ["Ride"] = 63.21, ["Neon"] = 36.75, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 155.97, ["Mega"] = 203.43, ["Mega|Ride"] = 189.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 15.36, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 275.98, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.07, ["Fly"] = 19.69, ["Ride"] = 46.51, ["Fly|Ride"] = 155.93, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 138.51, ["Mega"] = 551.94, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 262.5, ["Neon"] = 5.2, ["Neon|Fly"] = 69.26, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 185.03, ["Mega"] = 45.93, ["Mega|Ride"] = 113.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 530.01, ["Ride"] = 545.65, ["Fly|Ride"] = 787.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 2716.37, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.41, ["Ride"] = 61.66, ["Fly|Ride"] = 310.69, ["Neon"] = 14.43, ["Neon|Ride"] = 69.26, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 77.44, ["Mega|Fly"] = 124.04, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.24, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 138.51, ["Mega|Fly|Ride"] = 262.55}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 3.94, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 138.51, ["Mega"] = 45.94, ["Mega|Fly"] = 152.99, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.63, ["Ride"] = 21.18, ["Neon"] = 18.5, ["Neon|Ride"] = 69.26, ["Mega"] = 193.3}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.43, ["Fly"] = 98.44, ["Ride"] = 62.35, ["Fly|Ride"] = 262.79, ["Neon"] = 144.38, ["Neon|Ride"] = 179.86, ["Neon|Fly|Ride"] = 268.74, ["Mega"] = 632.56, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 707.24}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 21.74, ["Ride"] = 61.66, ["Fly|Ride"] = 138.51, ["Neon"] = 77.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 464.2, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 631.52}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.62, ["Fly"] = 19.16, ["Ride"] = 15.28, ["Fly|Ride"] = 52.5, ["Neon"] = 26.78, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 81.67, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 206.72}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 20.55, ["Ride"] = 64.32, ["Fly|Ride"] = 124.51, ["Neon"] = 93.03, ["Mega"] = 301.88, ["Mega|Ride"] = 718.34, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.94, ["Fly|Ride"] = 73.08, ["Neon"] = 14.31, ["Neon|Ride"] = 31.33, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 86.63, ["Mega|Fly"] = 165.39, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 23.63, ["Ride"] = 23.61, ["Fly|Ride"] = 131.25, ["Neon"] = 228.74, ["Neon|Ride"] = 179.86, ["Neon|Fly|Ride"] = 199.03, ["Mega"] = 929.18, ["Mega|Ride"] = 931.06, ["Mega|Fly|Ride"] = 883.71}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 43.24, ["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Ride"] = 275.98, ["Mega|Fly|Ride"] = 965.35}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.86, ["Fly"] = 111.91, ["Ride"] = 70.59, ["Fly|Ride"] = 147.62, ["Neon"] = 259.88, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1645.65, ["Mega|Fly|Ride"] = 1512.11}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.98, ["Fly"] = 92.85, ["Ride"] = 84.33, ["Fly|Ride"] = 275.98, ["Neon"] = 129.94, ["Neon|Ride"] = 190.19, ["Neon|Fly|Ride"] = 275.98, ["Mega"] = 614.99, ["Mega|Ride"] = 619.32, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.96, ["Ride"] = 55.68, ["Fly|Ride"] = 138.51, ["Neon"] = 138.98, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Ride"] = 776.29, ["Mega|Fly|Ride"] = 1240.29}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 16.71, ["Fly"] = 428.27, ["Ride"] = 46.08, ["Fly|Ride"] = 65.63, ["Neon"] = 86.16, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 200.52, ["Mega"] = 457.47, ["Mega|Ride"] = 357.31, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 17.06, ["Fly|Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 44.61, ["Mega|Fly"] = 155.97, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1216.28}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 49.09, ["Fly"] = 232.08, ["Ride"] = 126.93, ["Fly|Ride"] = 249.38, ["Neon"] = 288.46, ["Neon|Ride"] = 258.68, ["Neon|Fly|Ride"] = 304.91, ["Mega"] = 792.75, ["Mega|Ride"] = 744.18, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.77, ["Neon"] = 3.27, ["Neon|Fly"] = 97.16, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 289.42, ["Mega"] = 27.92, ["Mega|Ride"] = 80.63, ["Mega|Fly|Ride"] = 152.99}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.35, ["Ride"] = 65.07, ["Neon"] = 128.37, ["Neon|Ride"] = 138.51, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 776.29, ["Mega|Ride"] = 810.33, ["Mega|Fly|Ride"] = 482.68}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.15, ["Neon|Ride"] = 105, ["Mega"] = 21}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.41, ["Neon|Ride"] = 39.38, ["Mega"] = 27.96, ["Mega|Ride"] = 82.7, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 105, ["Ride"] = 136.5, ["Fly|Ride"] = 206.53, ["Neon"] = 498.75, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 689.39, ["Mega|Ride"] = 6401.01, ["Mega|Fly|Ride"] = 3881.35}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 92.69, ["Neon"] = 6.49, ["Neon|Ride"] = 27.92, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 90.57, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 39.47, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 62.03, ["Neon|Ride"] = 35.16, ["Neon|Fly|Ride"] = 103.37, ["Mega"] = 32.06, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 221.2}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.62, ["Neon"] = 3.29, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 225.32}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 63, ["Mega|Ride"] = 200.61}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 61.69, ["Ride"] = 69.2, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 499.23, ["Neon|Fly|Ride"] = 689.39, ["Mega"] = 1550.35, ["Mega|Ride"] = 1550.35, ["Mega|Fly|Ride"] = 1330.21}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 59.3, ["Fly|Ride"] = 131.25, ["Neon"] = 46.56, ["Neon|Ride"] = 139.67, ["Mega"] = 364.58, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 464.15, ["Ride"] = 433.69, ["Fly|Ride"] = 619.55, ["Neon"] = 2893.97, ["Neon|Ride"] = 2067.13, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3817.98}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 81.38}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 46.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.95}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 110.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 54.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 19.38}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.75}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.79}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.39}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.15}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 206.24}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.73}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.84}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 2.63}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.17}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 606.64}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 19.68}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.1}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.46}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 29.96}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 39.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 20.22}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.63}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.19}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.12}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.77}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.8}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.56}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1856.05}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 325.4}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.69}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.13}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.46}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1373.48}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.61}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 13.13}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.38}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.34}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 210}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.47}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.38}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.57}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.46}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 36.1}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 125.88}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 177.19}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.45}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.83}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 27.43}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.17}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.35}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.06}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22101.8}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 38.07}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 133.77}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 92.81}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.66}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 68.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.07}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 64.59}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 37.68}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 89.73}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 411.59}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.88}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.31}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.5}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.46}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.35}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 85.22}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.84}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 10.23}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.29}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 263.99}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 636.76}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.76}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 20.64}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.34}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 603.39}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.74}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.72}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.8}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 49.88}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 217.75}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.18}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.4}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.48}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.16}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.57}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.27}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.3}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 179.34}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.28}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 14.22}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.54}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.07}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 5.72}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.48}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.01}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 60.26}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.48}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 9.3}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.14}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.87}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.51}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.14}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6431.25}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 4.66}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 15.48}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.25}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 25.98}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.44}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.07}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 8.99}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 68.97}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 6.18}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 94.65}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.22}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4276.13}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 154.76}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.17}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.5}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 48.45}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 6.57}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.55}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 15.62}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.25}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.04}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.87}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.47}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.31}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.27}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 85.32}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 48.36}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.84}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.97}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 18.27}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 68.55}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.24}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.46}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 20.64}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.42}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.21}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.15}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.54}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.52}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.4}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.38}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.71}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.71}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 36.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.55}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.23}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.26}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 46.09}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.14}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.81}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 52.49}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.59}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 5.87}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.45}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 314.89}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 140.44}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1162.88}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.35}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.61}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 31.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 56.44}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.3}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.56}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.82}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.07}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.81}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 6.98}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.76}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.67}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.31}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 68.07}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.41}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 6.2}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.42}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.26}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 6.58}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 23.62}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 124.59}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.77}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.69}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 6.18}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 98.44}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.06}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 87.28}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 230.98}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 74.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 5.15}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 135.19}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.29}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.06}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 50.98}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.74}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.04}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 26.25}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 21.95}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 16.28}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.05}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.44}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 36.65}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.58}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 687.78}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 8.27}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.42}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 138.18}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.72}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 8.54}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.93}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 74.82}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.82}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.25}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 48.75}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 375.17}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 315}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.35}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 259.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.61}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 42}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.31}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 60.35}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 115.5}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 73.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 212.43}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.3}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2062.28}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.93}},
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