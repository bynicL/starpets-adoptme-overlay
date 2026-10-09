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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 984.37, ["Ride"] = 1179.92, ["Fly|Ride"] = 1640.63, ["Neon"] = 6853.67, ["Neon|Fly|Ride"] = 5066.49, ["Mega"] = 21585.45}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 564.38, ["Ride"] = 530.25, ["Fly|Ride"] = 661.91, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 10805.01, ["Mega|Fly|Ride"] = 8134.02}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 4593.73, ["Fly|Ride"] = 4856.25, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 73474.02}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 219.19, ["Fly"] = 236.25, ["Ride"] = 216.57, ["Fly|Ride"] = 490.24, ["Neon"] = 1144.69, ["Neon|Ride"] = 1153.87, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4948.71}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 863.43, ["Ride"] = 558.9, ["Fly|Ride"] = 615.57, ["Neon|Fly|Ride"] = 2008.39, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 13.65, ["Ride"] = 59.06, ["Fly|Ride"] = 129.94, ["Neon"] = 83.16, ["Neon|Fly"] = 288.18, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 324.16, ["Mega"] = 353.75, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 604.02}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.94, ["Fly"] = 45.94, ["Ride"] = 32.44, ["Fly|Ride"] = 65.52, ["Neon"] = 34.04, ["Neon|Fly"] = 126.99, ["Neon|Ride"] = 61.51, ["Neon|Fly|Ride"] = 112.87, ["Mega"] = 189, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 430.78}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 114.19, ["Fly"] = 216.12, ["Ride"] = 141.75, ["Fly|Ride"] = 185.87, ["Neon"] = 572.35, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2161.01}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.44, ["Fly"] = 97.76, ["Ride"] = 47.4, ["Fly|Ride"] = 105, ["Neon"] = 275.62, ["Neon|Ride"] = 231.46, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 2100, ["Mega|Ride"] = 1211.18, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.74, ["Fly"] = 49.08, ["Ride"] = 30.44, ["Fly|Ride"] = 72.35, ["Neon"] = 207.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 648.32, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 72.19, ["Fly"] = 216.57, ["Ride"] = 91.88, ["Fly|Ride"] = 170.73, ["Neon"] = 379.32, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 414.37, ["Mega|Fly|Ride"] = 1295.09}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.19}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 361.48, ["Fly"] = 478.24, ["Ride"] = 303.07, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1403.59, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5176.67}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.41, ["Fly"] = 170.5, ["Ride"] = 133.79, ["Fly|Ride"] = 159.71, ["Neon|Fly"] = 686.33, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 5.07, ["Fly"] = 78.23, ["Ride"] = 61.29, ["Fly|Ride"] = 164.25, ["Neon"] = 19.69, ["Neon|Ride"] = 57.75, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 326.33, ["Mega|Fly|Ride"] = 378.92}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 232.32, ["Fly"] = 284.82, ["Ride"] = 233.62, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 1397.67, ["Neon|Fly|Ride"] = 740.25, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.68, ["Fly"] = 26.25, ["Ride"] = 19.16, ["Fly|Ride"] = 41.99, ["Neon"] = 24.95, ["Neon|Fly"] = 82.14, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 164.07, ["Mega|Ride"] = 308.85, ["Mega|Fly|Ride"] = 401.49}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 143.07, ["Fly"] = 288.1, ["Ride"] = 169.21, ["Fly|Ride"] = 325.5, ["Neon"] = 485.63, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1312.5, ["Mega|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 1815.26}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.58}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 85.22, ["Ride"] = 170.63, ["Fly|Ride"] = 244.36, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1470.69}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 32.43, ["Fly"] = 393.75, ["Ride"] = 54.8, ["Fly|Ride"] = 432.26, ["Neon"] = 262.5, ["Neon|Ride"] = 352.94, ["Neon|Fly|Ride"] = 356.67, ["Mega"] = 1009.32, ["Mega|Ride"] = 1077.33, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 37.98, ["Fly"] = 110.23, ["Ride"] = 58.2, ["Fly|Ride"] = 111.55, ["Neon"] = 216.45, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 275.03, ["Mega"] = 1713.43, ["Mega|Fly|Ride"] = 923.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.23, ["Fly"] = 262.5, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 162.09, ["Neon|Ride"] = 391.68, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1967.44, ["Mega|Ride"] = 1728.81, ["Mega|Fly|Ride"] = 1554.87}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 49.86, ["Ride"] = 49.97, ["Fly|Ride"] = 111.11, ["Neon"] = 210, ["Neon|Ride"] = 299.44, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.84, ["Fly"] = 144.8, ["Ride"] = 65.63, ["Fly|Ride"] = 129.94, ["Neon"] = 374.53, ["Neon|Ride"] = 253.58, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1144.69, ["Mega|Fly|Ride"] = 1441.4}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.35, ["Fly"] = 32.45, ["Ride"] = 29.16, ["Fly|Ride"] = 54.43, ["Neon"] = 46.64, ["Neon|Fly"] = 97.44, ["Neon|Ride"] = 40.98, ["Neon|Fly|Ride"] = 101.05, ["Mega"] = 164.07, ["Mega|Fly"] = 27385.76, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 395.17, ["Ride"] = 415.8, ["Fly|Ride"] = 446.25, ["Neon"] = 2080.36, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1704.94, ["Mega"] = 10806.08, ["Mega|Fly|Ride"] = 9723.62}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.44, ["Ride"] = 32.82, ["Fly|Ride"] = 127.38, ["Neon"] = 219.18, ["Mega|Ride"] = 820.26, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.72, ["Fly"] = 43.23, ["Ride"] = 23.78, ["Fly|Ride"] = 45.94, ["Neon"] = 63, ["Neon|Ride"] = 74.07, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 331.45, ["Mega|Fly|Ride"] = 417.79}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 85.19, ["Fly"] = 119.95, ["Ride"] = 77.44, ["Fly|Ride"] = 115.73, ["Neon"] = 389.82, ["Neon|Fly"] = 392.19, ["Neon|Ride"] = 392.19, ["Neon|Fly|Ride"] = 400.6, ["Mega"] = 6493.15, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 16.04, ["Ride"] = 34.21, ["Fly|Ride"] = 77.44, ["Neon"] = 77.44, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 720.57, ["Mega|Ride"] = 735.35, ["Mega|Fly|Ride"] = 539.18}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 223.13, ["Fly"] = 288.75, ["Ride"] = 250.59, ["Fly|Ride"] = 331.78, ["Neon"] = 754.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 6483.66, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3105.59}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 25.17}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.28, ["Fly"] = 26.23, ["Ride"] = 20.52, ["Fly|Ride"] = 69.25, ["Neon"] = 23.63, ["Neon|Fly"] = 144.81, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 148.99, ["Mega|Fly"] = 490.16, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 944.97, ["Fly"] = 2625, ["Ride"] = 918.75, ["Fly|Ride"] = 1096.55, ["Neon"] = 7563.51, ["Neon|Ride"] = 5474.91, ["Neon|Fly|Ride"] = 5042.71, ["Mega|Ride"] = 55140.79, ["Mega|Fly|Ride"] = 18729.4}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.13, ["Fly"] = 55.4, ["Ride"] = 51.95, ["Fly|Ride"] = 81.05, ["Neon"] = 189.11, ["Neon|Ride"] = 274.46, ["Neon|Fly|Ride"] = 271.05, ["Mega"] = 1036.88, ["Mega|Ride"] = 1109.69, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 214.75, ["Fly"] = 367.68, ["Ride"] = 236.22, ["Fly|Ride"] = 328.13, ["Neon"] = 917.44, ["Neon|Ride"] = 977.82, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3889.81}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.94, ["Fly"] = 144.65, ["Ride"] = 50.6, ["Fly|Ride"] = 144.8, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 586.62, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 605.59}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 117.48, ["Ride"] = 144.38, ["Fly|Ride"] = 170.63, ["Neon"] = 427.17, ["Neon|Ride"] = 527.63, ["Neon|Fly|Ride"] = 577.48, ["Mega"] = 2378.01, ["Mega|Ride"] = 2289.37, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.19, ["Fly"] = 157.5, ["Ride"] = 116.82, ["Fly|Ride"] = 196.88, ["Neon"] = 377.97, ["Neon|Fly"] = 577, ["Neon|Ride"] = 404.13, ["Neon|Fly|Ride"] = 497.43, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1543.14}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50.44, ["Fly"] = 62.99, ["Ride"] = 48.33, ["Fly|Ride"] = 77.96, ["Neon|Ride"] = 396.57, ["Neon|Fly|Ride"] = 352.64, ["Mega"] = 4317.11, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.16, ["Ride"] = 47.34, ["Fly|Ride"] = 157.5, ["Neon"] = 37.06, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 200.1, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 228.89, ["Mega|Fly|Ride"] = 432.21}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Fly"] = 743.9, ["Ride"] = 560.27, ["Fly|Ride"] = 532.55, ["Neon"] = 1968.75, ["Neon|Fly"] = 3889.81, ["Neon|Ride"] = 3884.91, ["Neon|Fly|Ride"] = 2020.8, ["Mega|Ride"] = 15127.02, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 120.94, ["Fly"] = 170.63, ["Ride"] = 132.81, ["Fly|Ride"] = 183.75, ["Neon"] = 498.75, ["Neon|Ride"] = 566.2, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2593.21, ["Mega|Ride"] = 2593.21, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 15125.94}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 62.32, ["Fly"] = 115.63, ["Ride"] = 98.44, ["Fly|Ride"] = 189.1, ["Neon"] = 323.35, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 505.32, ["Mega"] = 2162.83, ["Mega|Ride"] = 2020.55, ["Mega|Fly|Ride"] = 2011.91}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 74.86, ["Ride"] = 72.19, ["Fly|Ride"] = 131.64, ["Neon"] = 575.75, ["Neon|Ride"] = 429.19, ["Neon|Fly|Ride"] = 430.05, ["Mega"] = 6339.93, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1626.35}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.94, ["Fly"] = 49.72, ["Ride"] = 46.65, ["Fly|Ride"] = 101.49, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 133.49, ["Neon|Fly|Ride"] = 187.14, ["Mega"] = 2625, ["Mega|Ride"] = 907.31, ["Mega|Fly|Ride"] = 589.92}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.2}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 42, ["Fly"] = 52.5, ["Ride"] = 64.65, ["Fly|Ride"] = 131.16, ["Neon|Ride"] = 327.24, ["Neon|Fly|Ride"] = 605.1, ["Mega|Ride"] = 1307.7, ["Mega|Fly|Ride"] = 1364.69}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 210, ["Fly|Ride"] = 282.19, ["Neon"] = 1152.9, ["Neon|Ride"] = 1152.9, ["Neon|Fly|Ride"] = 1294.44, ["Mega|Fly|Ride"] = 4902.27}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 716.63, ["Fly"] = 810.38, ["Ride"] = 717.93, ["Fly|Ride"] = 829.97, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11814.21}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.81, ["Fly"] = 65.54, ["Ride"] = 36.28, ["Fly|Ride"] = 64.3, ["Neon"] = 246.75, ["Neon|Fly"] = 272.3, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 211.6, ["Mega|Ride"] = 1176.46, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 24.52}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 7924.4, ["Fly|Ride"] = 4593.74, ["Neon|Ride"] = 17976.56, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 44120.24}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.79, ["Fly"] = 144.8, ["Ride"] = 26.06, ["Fly|Ride"] = 79.71, ["Neon"] = 90.77, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.26, ["Fly"] = 141.57, ["Ride"] = 33.54, ["Fly|Ride"] = 121.35, ["Neon"] = 91.88, ["Neon|Ride"] = 129.5, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 864.41, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1080.52}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 76.13, ["Ride"] = 93.19, ["Fly|Ride"] = 129.67, ["Neon|Ride"] = 403.74, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4322.45, ["Mega|Fly|Ride"] = 1797.92}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.08, ["Fly"] = 72.33, ["Ride"] = 36.75, ["Fly|Ride"] = 78.75, ["Neon"] = 93.19, ["Neon|Ride"] = 179.39, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 540.27, ["Mega|Ride"] = 768.44, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1575, ["Fly"] = 1998.94, ["Ride"] = 1970.07, ["Fly|Ride"] = 1689.19, ["Neon|Fly|Ride"] = 3261.57, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34579.41, ["Ride"] = 34125, ["Fly|Ride"] = 28122.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.41, ["Fly"] = 393.75, ["Ride"] = 54.51, ["Fly|Ride"] = 120.74, ["Neon"] = 221.43, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 591.54, ["Mega"] = 755.29, ["Mega|Ride"] = 1307.46, ["Mega|Fly|Ride"] = 1536.87}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4.9, ["Fly"] = 124.27, ["Ride"] = 46.79, ["Fly|Ride"] = 164.07, ["Neon"] = 24.33, ["Neon|Fly"] = 231.25, ["Neon|Ride"] = 72.31, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 135.18, ["Mega|Fly"] = 392.19, ["Mega|Ride"] = 234.92, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.82}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 11.7, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 56.44, ["Neon|Ride"] = 114.55, ["Neon|Fly|Ride"] = 268.86, ["Mega"] = 418.97, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 803.45, ["Ride"] = 673.08, ["Fly|Ride"] = 689.07, ["Neon"] = 3105.06, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10376.84}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 939.64, ["Fly"] = 1076.15, ["Ride"] = 871.5, ["Fly|Ride"] = 997.5, ["Neon|Ride"] = 3268.59, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13726.3}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.72, ["Fly"] = 122.57, ["Ride"] = 34.55, ["Fly|Ride"] = 90.78, ["Neon"] = 87.94, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 499.21, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.49}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 79.77, ["Fly"] = 117.67, ["Ride"] = 86.6, ["Fly|Ride"] = 157.4, ["Neon"] = 376.02, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 19687.5, ["Mega|Ride"] = 2018.4, ["Mega|Fly|Ride"] = 12253.52}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 102.38, ["Ride"] = 122.07, ["Fly|Ride"] = 157.49, ["Neon"] = 450.19, ["Neon|Ride"] = 436.92, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1406.29, ["Mega|Fly|Ride"] = 2146.97}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.56, ["Fly"] = 33.13, ["Ride"] = 25.47, ["Fly|Ride"] = 60.9, ["Neon"] = 49.88, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 99.42, ["Neon|Fly|Ride"] = 116.65, ["Mega"] = 360.91, ["Mega|Fly|Ride"] = 670.4}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 150.94, ["Fly"] = 190.32, ["Ride"] = 197.03, ["Fly|Ride"] = 249.27, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 5186.42, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.37, ["Ride"] = 51.19, ["Fly|Ride"] = 141.75, ["Neon"] = 45.94, ["Neon|Ride"] = 163.68, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.02}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.47, ["Ride"] = 29.16, ["Fly|Ride"] = 65.4, ["Neon"] = 126, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 790.95}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.78, ["Ride"] = 57.75, ["Fly|Ride"] = 148.38, ["Neon"] = 233.51, ["Neon|Ride"] = 210.39, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.75, ["Fly"] = 215.31, ["Ride"] = 36.57, ["Fly|Ride"] = 79.48, ["Neon"] = 131.25, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 331.45, ["Mega"] = 1259.88, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6784.32, ["Ride"] = 5643.75, ["Fly|Ride"] = 5694.94, ["Neon"] = 35976.47, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30110.32}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 209.2, ["Fly"] = 244.4, ["Ride"] = 222.9, ["Fly|Ride"] = 312.38, ["Neon"] = 647.22, ["Neon|Fly"] = 691.53, ["Neon|Fly|Ride"] = 608.9, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 61.04, ["Fly"] = 210, ["Ride"] = 115.4, ["Fly|Ride"] = 216.29, ["Neon"] = 157.5, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 326.67, ["Mega"] = 486.47, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 639.19}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.29, ["Fly"] = 90.6, ["Ride"] = 23.15, ["Fly|Ride"] = 81.37, ["Neon"] = 19.83, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 137.82, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61.61, ["Fly"] = 215.34, ["Ride"] = 117.93, ["Fly|Ride"] = 288.5, ["Neon"] = 199.5, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 388.5, ["Mega"] = 497.82, ["Mega|Fly"] = 734.76, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16568.41, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.57, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 102287.71}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 284.28, ["Ride"] = 367.5, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 2161.01, ["Neon|Fly|Ride"] = 1657.52}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 58.95, ["Fly"] = 90.5, ["Ride"] = 64.3, ["Fly|Ride"] = 91.87, ["Neon"] = 297.41, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 385.9, ["Mega|Fly|Ride"] = 2016.24}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.21, ["Ride"] = 24.94, ["Fly|Ride"] = 62.68, ["Neon"] = 59.07, ["Neon|Fly"] = 327.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 525, ["Mega|Ride"] = 735.35, ["Mega|Fly|Ride"] = 487.32}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 392.43, ["Ride"] = 421.32, ["Fly|Ride"] = 472.49, ["Neon"] = 1718.01, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.5, ["Ride"] = 52.5, ["Fly|Ride"] = 183.75, ["Neon"] = 30.19, ["Neon|Ride"] = 91.96, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 158.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.99, ["Fly"] = 202.12, ["Ride"] = 153.57, ["Fly|Ride"] = 207.99, ["Neon"] = 465.94, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 2419.98}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.8, ["Fly"] = 18.23, ["Ride"] = 15.75, ["Fly|Ride"] = 36.74, ["Neon"] = 115.73, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 107.08, ["Mega"] = 2593.46, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 78.75, ["Fly"] = 86.49, ["Ride"] = 87.94, ["Fly|Ride"] = 172.9, ["Neon"] = 353.07, ["Neon|Fly"] = 539.18, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 431.5, ["Mega|Ride"] = 2016.24, ["Mega|Fly|Ride"] = 1730.8}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.33, ["Fly"] = 294.14, ["Ride"] = 37.95, ["Fly|Ride"] = 105, ["Neon"] = 107.51, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 534.86, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 909.57}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 76.13, ["Fly"] = 144.8, ["Ride"] = 118.13, ["Fly|Ride"] = 432.21, ["Neon"] = 370.4, ["Neon|Ride"] = 396.18, ["Neon|Fly|Ride"] = 654.46, ["Mega|Ride"] = 1634.92, ["Mega|Fly|Ride"] = 2054.68}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.73, ["Ride"] = 29.24, ["Fly|Ride"] = 137.82, ["Neon"] = 22.01, ["Neon|Ride"] = 141.57, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 323.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.83, ["Fly"] = 56.44, ["Ride"] = 33.51, ["Fly|Ride"] = 78.66, ["Neon"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.03, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 537.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.96, ["Ride"] = 497.44, ["Fly|Ride"] = 498.73, ["Neon|Fly|Ride"] = 2808.23, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 44.25, ["Fly"] = 108.07, ["Ride"] = 68.61, ["Fly|Ride"] = 99.74, ["Neon"] = 195.57, ["Neon|Ride"] = 185.24, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 720.21}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 48.37, ["Fly"] = 144.46, ["Ride"] = 78.56, ["Fly|Ride"] = 143.75, ["Neon"] = 236.25, ["Neon|Ride"] = 201.88, ["Neon|Fly|Ride"] = 323.56, ["Mega|Ride"] = 1062.06, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 21.42, ["Fly"] = 81.56, ["Ride"] = 71.31, ["Fly|Ride"] = 127.38, ["Neon"] = 106.85, ["Neon|Ride"] = 143.21, ["Neon|Fly|Ride"] = 262.79, ["Mega"] = 490.67, ["Mega|Fly"] = 525, ["Mega|Ride"] = 526.21, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10229.1, ["Ride"] = 8862, ["Fly|Ride"] = 8400, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1506.75, ["Fly"] = 1517.02, ["Ride"] = 1364.9, ["Fly|Ride"] = 1365, ["Neon|Fly|Ride"] = 4015.45, ["Mega|Fly|Ride"] = 24491.71}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 616.88, ["Ride"] = 525, ["Fly|Ride"] = 720.7, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21612.14, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.97, ["Fly"] = 29.19, ["Ride"] = 19.56, ["Fly|Ride"] = 40.85, ["Neon"] = 136.5, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.23, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.97, ["Fly"] = 78.74, ["Ride"] = 27, ["Fly|Ride"] = 198.82, ["Neon"] = 20.62, ["Neon|Ride"] = 39.38, ["Mega"] = 145.04, ["Mega|Ride"] = 202.44, ["Mega|Fly|Ride"] = 288.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.94, ["Fly"] = 41.91, ["Ride"] = 51.1, ["Fly|Ride"] = 98.44, ["Neon"] = 238.81, ["Neon|Ride"] = 136.38, ["Neon|Fly|Ride"] = 177.19, ["Mega|Ride"] = 865.13, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.68, ["Fly"] = 28.21, ["Ride"] = 18.38, ["Fly|Ride"] = 39.36, ["Neon"] = 35.44, ["Neon|Fly"] = 43.19, ["Neon|Ride"] = 50.85, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 281.72, ["Mega|Ride"] = 209.44, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 280.6, ["Fly"] = 430.5, ["Ride"] = 313.41, ["Fly|Ride"] = 384.61, ["Neon|Ride"] = 1152.9, ["Neon|Fly|Ride"] = 1189.56, ["Mega|Fly|Ride"] = 4436.11}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.58, ["Fly"] = 60.53, ["Ride"] = 42.3, ["Fly|Ride"] = 65.63, ["Neon"] = 144.37, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 196.1, ["Mega"] = 864.41, ["Mega|Fly"] = 915.51, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.31}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.4, ["Fly"] = 22.31, ["Ride"] = 25.65, ["Fly|Ride"] = 45.9, ["Neon"] = 84.29, ["Neon|Fly"] = 121.98, ["Neon|Ride"] = 121.19, ["Neon|Fly|Ride"] = 119.61, ["Mega"] = 1575, ["Mega|Ride"] = 617.7, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 590.63, ["Fly|Ride"] = 864.41, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1238.98, ["Fly"] = 1439.76, ["Ride"] = 1155, ["Fly|Ride"] = 1181.24, ["Neon"] = 5251.63, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13685.63}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 108.07, ["Fly"] = 144.8, ["Ride"] = 99.23, ["Fly|Ride"] = 110.36, ["Neon"] = 971.25, ["Neon|Ride"] = 594.29, ["Neon|Fly|Ride"] = 492.19, ["Mega|Fly|Ride"] = 2858.03}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.04, ["Fly"] = 262.5, ["Ride"] = 202.12, ["Fly|Ride"] = 258.57, ["Neon"] = 961.66, ["Neon|Ride"] = 735.35, ["Neon|Fly|Ride"] = 602.44, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 32.44, ["Fly"] = 124.27, ["Ride"] = 52.5, ["Fly|Ride"] = 87.71, ["Neon"] = 249.53, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2161.01, ["Mega|Fly|Ride"] = 1096.9}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 393.75, ["Ride"] = 431.16, ["Fly|Ride"] = 490.56, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1296.61, ["Mega|Fly|Ride"] = 5763.4}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2449.51, ["Ride"] = 1968.65, ["Fly|Ride"] = 2042.57, ["Neon|Fly|Ride"] = 10805.01, ["Mega|Fly|Ride"] = 37422.56}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 37.03, ["Fly"] = 216.12, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2377.35, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 590.63, ["Fly"] = 777.98, ["Ride"] = 616.49, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1140.57, ["Mega|Fly|Ride"] = 3018.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.81, ["Fly"] = 63.52, ["Ride"] = 55.12, ["Fly|Ride"] = 102.38, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 288.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 24.22, ["Fly|Ride"] = 60.04, ["Neon"] = 28.28, ["Neon|Fly"] = 76.67, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 111.96, ["Mega"] = 166.68, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 187.39, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 63.67, ["Ride"] = 84.36, ["Fly|Ride"] = 157.5, ["Neon"] = 196.77, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 431.02, ["Mega"] = 1581.87, ["Mega|Ride"] = 1728.81, ["Mega|Fly|Ride"] = 1714.77}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 990.94, ["Fly"] = 1142.55, ["Ride"] = 966, ["Fly|Ride"] = 1086.63, ["Neon|Ride"] = 3457.61, ["Neon|Fly|Ride"] = 3084.38, ["Mega|Fly|Ride"] = 13254.51}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 761.25, ["Ride"] = 808.5, ["Fly|Ride"] = 906.55, ["Neon|Fly|Ride"] = 4320.94, ["Mega|Fly|Ride"] = 19449.02}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.86, ["Fly"] = 26.2, ["Ride"] = 22.15, ["Fly|Ride"] = 48.2, ["Neon"] = 91.88, ["Neon|Ride"] = 114.79, ["Neon|Fly|Ride"] = 170.23, ["Mega|Fly|Ride"] = 721.31}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 21.61, ["Ride"] = 42, ["Fly|Ride"] = 128.6, ["Neon"] = 142.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.94, ["Mega"] = 1728.81, ["Mega|Ride"] = 1003.55, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.77, ["Fly"] = 70.88, ["Ride"] = 31.5, ["Fly|Ride"] = 133.88, ["Neon"] = 24.76, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 202.25, ["Mega"] = 157.5, ["Mega|Fly"] = 572.35, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.87, ["Fly"] = 63.76, ["Ride"] = 51.86, ["Fly|Ride"] = 82.27, ["Neon"] = 201.88, ["Neon|Ride"] = 188.02, ["Neon|Fly|Ride"] = 216.2, ["Mega|Ride"] = 900.3, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 99.04, ["Ride"] = 189, ["Fly|Ride"] = 360.91, ["Neon"] = 426.57, ["Neon|Ride"] = 611.86, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 2870.05}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.4, ["Fly"] = 58.05, ["Ride"] = 39.51, ["Fly|Ride"] = 105, ["Neon"] = 107.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 192.8, ["Mega"] = 416.91, ["Mega|Ride"] = 374.19, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.66, ["Fly"] = 64.32, ["Ride"] = 44.63, ["Fly|Ride"] = 77.35, ["Neon"] = 242.82, ["Neon|Ride"] = 241.7, ["Neon|Fly|Ride"] = 239.26, ["Mega"] = 2052.96, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 6.09, ["Fly"] = 48.3, ["Ride"] = 18.38, ["Fly|Ride"] = 39.54, ["Neon"] = 26.25, ["Neon|Ride"] = 39.18, ["Neon|Fly|Ride"] = 101.67, ["Mega"] = 434.74, ["Mega|Ride"] = 490.24, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.47, ["Fly"] = 55.13, ["Ride"] = 36.74, ["Fly|Ride"] = 33100.45, ["Neon"] = 50.55, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 244.21, ["Mega"] = 420, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 39.38, ["Fly"] = 72.18, ["Ride"] = 53.45, ["Fly|Ride"] = 99.1, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 272.54, ["Mega"] = 1487.84, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1397.82, ["Fly"] = 1410.94, ["Ride"] = 1378.86, ["Fly|Ride"] = 1397.82, ["Neon|Ride"] = 4902.27, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 488.8, ["Fly"] = 525, ["Ride"] = 479.07, ["Fly|Ride"] = 564.36, ["Neon|Ride"] = 3268.59, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15128.5}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 292.9, ["Ride"] = 328.13, ["Fly|Ride"] = 387.19, ["Neon"] = 1575, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7779.62}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 48.51, ["Ride"] = 57.05, ["Fly|Ride"] = 110.24, ["Neon"] = 324.16, ["Neon|Fly"] = 288.74, ["Neon|Ride"] = 248.53, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1188.56, ["Mega|Fly|Ride"] = 972.48}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 32385.42, ["Ride"] = 37584.31, ["Fly|Ride"] = 16666.13, ["Neon|Fly|Ride"] = 37798.69, ["Mega"] = 216100, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 240.38, ["Fly"] = 284.71, ["Ride"] = 255.94, ["Fly|Ride"] = 312.37, ["Neon"] = 787.49, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 1044.64, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6483.66, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 118.13, ["Fly"] = 525, ["Ride"] = 207.23, ["Fly|Ride"] = 262.49}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 120.75, ["Fly"] = 159.73, ["Ride"] = 111.57, ["Fly|Ride"] = 179.73, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3170.21}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.09, ["Fly"] = 64.78, ["Ride"] = 32.94, ["Fly|Ride"] = 65.63, ["Neon"] = 82.14, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 239.89, ["Mega"] = 732.9, ["Mega|Ride"] = 720.7, ["Mega|Fly|Ride"] = 879.54}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5014.72, ["Ride"] = 3937.5, ["Fly|Ride"] = 4200, ["Neon"] = 21612.14, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81690.46}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.07, ["Fly"] = 44.88, ["Ride"] = 33.63, ["Fly|Ride"] = 57.66, ["Neon"] = 131.25, ["Neon|Ride"] = 215.03, ["Neon|Fly|Ride"] = 182.68, ["Mega|Ride"] = 1441.4, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.43, ["Fly"] = 105, ["Ride"] = 49.63, ["Fly|Ride"] = 85.31, ["Neon"] = 287.44, ["Neon|Fly"] = 259.33, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1440.23}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 389.59, ["Fly"] = 563.06, ["Ride"] = 459.38, ["Fly|Ride"] = 504.3, ["Neon"] = 1155, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4302.54}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.86, ["Fly"] = 30.64, ["Ride"] = 24.47, ["Fly|Ride"] = 53.82, ["Neon"] = 131.25, ["Neon|Ride"] = 111.18, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 623.49}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.07, ["Fly"] = 288.18, ["Ride"] = 34.56, ["Fly|Ride"] = 490.16, ["Neon"] = 91.88, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 215.52, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 735.35}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 122.07, ["Fly|Ride"] = 245.44, ["Neon"] = 735.35, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 736.92, ["Mega|Fly|Ride"] = 2615.37}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.3, ["Fly"] = 129.55, ["Ride"] = 74.72, ["Fly|Ride"] = 86.57, ["Neon"] = 77.3, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 286.16, ["Mega"] = 315.23, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4304.9, ["Fly"] = 6531.05, ["Ride"] = 4134.38, ["Fly|Ride"] = 4147.5, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10479, ["Mega"] = 48983.41, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.4, ["Fly"] = 144.64, ["Ride"] = 50.43, ["Fly|Ride"] = 165.47, ["Neon"] = 228.74, ["Neon|Fly"] = 275.63, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 864.41, ["Mega|Ride"] = 1797.6, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7995.71, ["Ride"] = 6857.82, ["Fly|Ride"] = 6126.75, ["Neon"] = 22877.58, ["Neon|Fly|Ride"] = 15146.25, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.93, ["Fly"] = 23.15, ["Ride"] = 17.21, ["Fly|Ride"] = 37.1, ["Neon"] = 27.99, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 80.18, ["Mega"] = 201.88, ["Mega|Ride"] = 209.44, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.02, ["Fly"] = 34, ["Ride"] = 26.25, ["Fly|Ride"] = 48.57, ["Neon"] = 188.02, ["Neon|Fly"] = 238.81, ["Neon|Ride"] = 141.57, ["Neon|Fly|Ride"] = 144.8, ["Mega|Ride"] = 1004.73, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.2}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.91, ["Fly"] = 32.82, ["Ride"] = 27.8, ["Fly|Ride"] = 87.9, ["Neon"] = 78.74, ["Neon|Ride"] = 138.2, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 1049.9, ["Mega|Ride"] = 1150.63, ["Mega|Fly|Ride"] = 1134.54}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.84, ["Fly"] = 190.37, ["Ride"] = 44.3, ["Fly|Ride"] = 118.13, ["Neon"] = 274.32, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 864.41, ["Mega|Fly|Ride"] = 1066.26}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.46, ["Fly"] = 27.57, ["Ride"] = 21, ["Fly|Ride"] = 42.95, ["Neon|Fly"] = 1077.38, ["Neon|Ride"] = 101.58, ["Neon|Fly|Ride"] = 121.65, ["Mega"] = 2593.46, ["Mega|Ride"] = 430.05, ["Mega|Fly|Ride"] = 626.7}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8635.37}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2899.32}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 278.15, ["Ride"] = 199.5, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1210.86}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 16.99, ["Fly"] = 98.05, ["Ride"] = 32.82, ["Fly|Ride"] = 138.33, ["Neon"] = 133.29, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 2044.25, ["Mega|Fly|Ride"] = 530.98}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.22}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.88, ["Ride"] = 26.25, ["Fly|Ride"] = 86.45, ["Neon"] = 155.6, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2391.38}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 234.92, ["Fly"] = 432.21, ["Ride"] = 262.5, ["Fly|Ride"] = 735.35, ["Neon"] = 1144.69, ["Neon|Ride"] = 863.34, ["Neon|Fly|Ride"] = 1079.43, ["Mega|Ride"] = 4178.31, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 59.07, ["Fly"] = 476.68, ["Ride"] = 58.31, ["Fly|Ride"] = 245.13, ["Neon"] = 393.75, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 577.06, ["Mega|Fly|Ride"] = 2003.27}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 194.33, ["Fly"] = 262.29, ["Ride"] = 209.68, ["Fly|Ride"] = 288.15, ["Neon"] = 865.13, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 858.38, ["Mega|Fly|Ride"] = 4174.22}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2489.82, ["Fly"] = 3313.91, ["Ride"] = 2756.25, ["Fly|Ride"] = 2953.13, ["Neon"] = 15176.72, ["Neon|Ride"] = 9804.53, ["Neon|Fly|Ride"] = 8932.52, ["Mega|Fly|Ride"] = 30254.02}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.73, ["Fly"] = 105.91, ["Ride"] = 53.95, ["Fly|Ride"] = 112.4, ["Neon"] = 144.8, ["Neon|Ride"] = 156.89, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 971.38, ["Mega|Ride"] = 1009.2, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 839.26, ["Fly|Ride"] = 864.41, ["Neon|Fly|Ride"] = 4320.94}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.11}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 18.25, ["Ride"] = 43.32, ["Fly|Ride"] = 157.5, ["Neon"] = 115.5, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 263.66, ["Mega"] = 444.94, ["Mega|Fly"] = 980.46, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.32, ["Fly"] = 41.87, ["Ride"] = 28.17, ["Fly|Ride"] = 131.24, ["Neon"] = 72.09, ["Neon|Fly"] = 315, ["Neon|Ride"] = 100.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 458.38, ["Mega|Ride"] = 288.5, ["Mega|Fly|Ride"] = 397.09}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.37}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.43, ["Ride"] = 26.14, ["Fly|Ride"] = 77.82, ["Neon|Ride"] = 234.09, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1225.31, ["Mega|Fly|Ride"] = 2158.56}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23.63, ["Fly"] = 46.58, ["Ride"] = 32.47, ["Fly|Ride"] = 60.53, ["Neon|Fly"] = 238.81, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 287.43, ["Mega"] = 1441.55, ["Mega|Ride"] = 1838.04, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6434.34, ["Fly"] = 4921.88, ["Ride"] = 6613.95, ["Fly|Ride"] = 5197.49, ["Neon|Fly|Ride"] = 10762.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.19, ["Fly"] = 49.72, ["Ride"] = 32.82, ["Fly|Ride"] = 81.84, ["Neon"] = 56.44, ["Neon|Ride"] = 91.55, ["Neon|Fly|Ride"] = 234.09, ["Mega"] = 354.38, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 555.73}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 83.58, ["Fly"] = 382.54, ["Ride"] = 102.38, ["Fly|Ride"] = 196.88, ["Neon"] = 523.69, ["Neon|Ride"] = 490.67, ["Neon|Fly|Ride"] = 531.57, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 2020.07}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 52.62, ["Fly"] = 190.93, ["Ride"] = 85.07, ["Fly|Ride"] = 171.23, ["Neon"] = 236.25, ["Neon|Fly"] = 392.19, ["Neon|Ride"] = 216.29, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2447.74, ["Mega|Ride"] = 2917.66, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.37, ["Fly"] = 82.14, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 174.57, ["Neon|Fly"] = 233.41, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 1016.21, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.45, ["Fly"] = 30.19, ["Ride"] = 29.64, ["Fly|Ride"] = 72.19, ["Neon"] = 28.01, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 145.58, ["Mega|Fly"] = 7195.53, ["Mega|Ride"] = 227.06, ["Mega|Fly|Ride"] = 335.22}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.38, ["Fly"] = 65.63, ["Ride"] = 27.57, ["Fly|Ride"] = 98.05, ["Neon"] = 79.75, ["Neon|Ride"] = 115.22, ["Neon|Fly|Ride"] = 216.11, ["Mega"] = 380.63, ["Mega|Ride"] = 721.31, ["Mega|Fly|Ride"] = 539.18}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21, ["Fly"] = 36.72, ["Ride"] = 28.23, ["Fly|Ride"] = 55.55, ["Neon"] = 278.25, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 144.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 188.4}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.57, ["Ride"] = 140.44, ["Fly|Ride"] = 288.5, ["Neon"] = 157.5, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 367.68, ["Mega"] = 793.11, ["Mega|Ride"] = 769.33, ["Mega|Fly|Ride"] = 784.83}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 210, ["Ride"] = 1441.4, ["Fly|Ride"] = 432.21, ["Neon|Fly|Ride"] = 28813.72}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 55.13, ["Fly"] = 216.12, ["Ride"] = 87.06, ["Fly|Ride"] = 219.19, ["Neon"] = 210, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1147.13, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.98, ["Fly"] = 1246.88, ["Ride"] = 1010.63, ["Fly|Ride"] = 1181.14, ["Neon|Fly"] = 4718.43, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 426.57, ["Fly"] = 719.88, ["Ride"] = 418.69, ["Fly|Ride"] = 515.78, ["Neon"] = 2861.25, ["Neon|Ride"] = 4322.01, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12966.01, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.12}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 6.57, ["Fly"] = 32.79, ["Ride"] = 24.92, ["Fly|Ride"] = 52.5, ["Neon"] = 82.29, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 143.06, ["Mega"] = 437.26, ["Mega|Ride"] = 720.7, ["Mega|Fly|Ride"] = 573.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 223.13, ["Fly"] = 352.92, ["Ride"] = 280.29, ["Fly|Ride"] = 379.32, ["Neon"] = 838.69, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 954.19, ["Mega|Fly|Ride"] = 3273.15}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 114.69, ["Ride"] = 169.61, ["Fly|Ride"] = 262.5, ["Neon"] = 525, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 505.03, ["Neon|Fly|Ride"] = 702.19, ["Mega"] = 2449.51, ["Mega|Ride"] = 2451.14, ["Mega|Fly|Ride"] = 2285.37}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 311.31, ["Ride"] = 144.8, ["Fly|Ride"] = 262.5, ["Neon"] = 720.7, ["Neon|Ride"] = 432.21, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.95, ["Fly"] = 79.97, ["Ride"] = 25.38, ["Fly|Ride"] = 216.12, ["Neon"] = 33.13, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 246.95, ["Mega"] = 226.92, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 311.31}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.12, ["Fly"] = 51.44, ["Ride"] = 28.77, ["Fly|Ride"] = 72.1, ["Neon"] = 177.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 326.8, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.38, ["Fly"] = 102.36, ["Ride"] = 34.13, ["Fly|Ride"] = 118.12, ["Neon"] = 79.54, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.8, ["Fly"] = 131.25, ["Ride"] = 45.94, ["Fly|Ride"] = 164.25, ["Neon"] = 26.25, ["Neon|Ride"] = 64.76, ["Neon|Fly|Ride"] = 200.81, ["Mega"] = 144.38, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 322.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.49, ["Ride"] = 312.38, ["Fly|Ride"] = 341.25, ["Neon"] = 1441.4, ["Neon|Ride"] = 1406.96, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6598.64}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 91.77, ["Fly"] = 576.35, ["Ride"] = 114.09, ["Fly|Ride"] = 192.36, ["Neon"] = 429.19, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2593.21, ["Mega|Ride"] = 2018.4, ["Mega|Fly|Ride"] = 1912.59}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 63.67, ["Fly"] = 167.45, ["Ride"] = 56.34, ["Fly|Ride"] = 101.8, ["Neon"] = 315, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1797.92, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.99, ["Fly"] = 127.32, ["Ride"] = 54.05, ["Fly|Ride"] = 288.5, ["Neon|Ride"] = 622.49, ["Neon|Fly|Ride"] = 518.65}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.19, ["Ride"] = 30.77, ["Fly|Ride"] = 94.85, ["Neon"] = 78.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 775.37, ["Mega|Ride"] = 490.24, ["Mega|Fly|Ride"] = 617.7}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 43.32, ["Ride"] = 21.38, ["Fly|Ride"] = 52.5, ["Neon"] = 19.59, ["Neon|Fly"] = 85.38, ["Neon|Ride"] = 41.48, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 160.13, ["Mega|Ride"] = 181.01, ["Mega|Fly|Ride"] = 282.72}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.16, ["Fly"] = 918.75, ["Ride"] = 913.5, ["Fly|Ride"] = 905.63, ["Neon"] = 3136.71, ["Neon|Fly"] = 3327.42, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 314.99, ["Fly"] = 328.13, ["Ride"] = 299.31, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1299.38, ["Mega"] = 10806.08, ["Mega|Fly|Ride"] = 5066.49}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 90.57, ["Fly"] = 172.9, ["Ride"] = 116.94, ["Fly|Ride"] = 173.25, ["Neon"] = 422.63, ["Neon|Ride"] = 411.8, ["Neon|Fly|Ride"] = 559.71, ["Mega"] = 1312.5, ["Mega|Ride"] = 1743.94, ["Mega|Fly|Ride"] = 1878.74}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 220.62, ["Fly"] = 283.5, ["Ride"] = 183.75, ["Fly|Ride"] = 240.28, ["Neon"] = 918.75, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10806.08, ["Mega|Fly|Ride"] = 7023.27}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.99, ["Fly"] = 58.36, ["Ride"] = 33.74, ["Fly|Ride"] = 69.57, ["Neon"] = 169.32, ["Neon|Ride"] = 105.6, ["Neon|Fly|Ride"] = 213.68, ["Mega|Ride"] = 756.36, ["Mega|Fly|Ride"] = 955.98}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 196.88, ["Ride"] = 270.8, ["Fly|Ride"] = 361.2, ["Neon"] = 1008, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1210.86, ["Mega"] = 3240.2, ["Mega|Fly|Ride"] = 4249.03}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.44, ["Fly"] = 126, ["Ride"] = 71.32, ["Fly|Ride"] = 129.55, ["Neon|Fly|Ride"] = 864.41, ["Mega|Ride"] = 2306.05, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 3193.83, ["Ride"] = 2186.49, ["Fly|Ride"] = 2546.24, ["Neon|Ride"] = 11439.41, ["Neon|Fly|Ride"] = 7014.61, ["Mega"] = 51869.11, ["Mega|Fly|Ride"] = 29413.5}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 72.23, ["Ride"] = 33.06, ["Fly|Ride"] = 108.83, ["Neon"] = 61.13, ["Neon|Fly"] = 73.5, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 187.85, ["Mega"] = 269.07, ["Mega|Ride"] = 309.71, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 42, ["Ride"] = 59.06, ["Fly|Ride"] = 149.63, ["Neon"] = 221.82, ["Neon|Ride"] = 224.35, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1173.22}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.41, ["Fly"] = 92.39, ["Ride"] = 82.6, ["Fly|Ride"] = 89.23, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1632.66, ["Ride"] = 1069.69, ["Fly|Ride"] = 997.49, ["Neon|Ride"] = 5719.71, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 37025.51, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 425.25, ["Fly"] = 862.25, ["Ride"] = 756.36, ["Fly|Ride"] = 534.19}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 79.03, ["Fly"] = 118.13, ["Ride"] = 122.11, ["Fly|Ride"] = 253.94, ["Neon"] = 380.63, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 540.27, ["Mega"] = 2161.01, ["Mega|Ride"] = 2615.37, ["Mega|Fly|Ride"] = 1809.14}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.64, ["Fly"] = 32.82, ["Ride"] = 21.81, ["Fly|Ride"] = 84, ["Neon"] = 86.63, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 36.74, ["Fly"] = 62.67, ["Ride"] = 51.17, ["Fly|Ride"] = 74.06, ["Neon"] = 212.63, ["Neon|Fly"] = 360.91, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 345.78, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 720.46, ["Fly"] = 1127.36, ["Ride"] = 892.4, ["Fly|Ride"] = 892.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 636.56}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 12255.63, ["Ride"] = 5250, ["Fly|Ride"] = 5184.38, ["Neon"] = 42000, ["Neon|Ride"] = 30968.24, ["Neon|Fly|Ride"] = 27090, ["Mega|Fly|Ride"] = 107927.22}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 236.25, ["Fly"] = 405.2, ["Ride"] = 343.62, ["Fly|Ride"] = 426.51, ["Neon"] = 1726.86, ["Neon|Fly|Ride"] = 2161.23, ["Mega"] = 6475.66, ["Mega|Fly|Ride"] = 6483.02}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 85.79, ["Ride"] = 157.39, ["Fly|Ride"] = 288.18, ["Neon"] = 1150.63, ["Neon|Ride"] = 577, ["Neon|Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 2611.38}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.77, ["Fly"] = 72.42, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 141.75, ["Neon|Ride"] = 176.98, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 864.41, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.31, ["Fly"] = 28.88, ["Ride"] = 23.58, ["Fly|Ride"] = 51.19, ["Neon"] = 146.5, ["Neon|Ride"] = 75.66, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1080.52}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.59, ["Ride"] = 32.82, ["Fly|Ride"] = 103.8, ["Neon"] = 118.13, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 642.36}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 29.19, ["Ride"] = 22.31, ["Fly|Ride"] = 49.03, ["Neon"] = 37.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 16.95, ["Ride"] = 52.5, ["Fly|Ride"] = 130.92, ["Neon"] = 156.58, ["Neon|Fly"] = 864.41, ["Neon|Ride"] = 233.41, ["Neon|Fly|Ride"] = 327.24, ["Mega"] = 630, ["Mega|Ride"] = 720.7}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 575.3, ["Fly"] = 577.5, ["Ride"] = 534.38, ["Fly|Ride"] = 597.72, ["Neon"] = 1860.02, ["Neon|Ride"] = 1795.87, ["Neon|Fly|Ride"] = 1468.13, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 6339.32}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.24, ["Fly"] = 18.62, ["Ride"] = 15.75, ["Fly|Ride"] = 38.05, ["Neon"] = 22.25, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 170.63, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 47.25, ["Fly"] = 116.82, ["Ride"] = 81.38, ["Fly|Ride"] = 141.61, ["Neon"] = 208.69, ["Neon|Fly"] = 361.58, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 564.38, ["Mega|Fly"] = 864.41, ["Mega|Ride"] = 524.9, ["Mega|Fly|Ride"] = 577.48}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756, ["Ride"] = 780.94, ["Fly|Ride"] = 787.48, ["Neon|Ride"] = 2125.14, ["Neon|Fly|Ride"] = 1732.49, ["Mega|Fly|Ride"] = 4166.73}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.38, ["Fly"] = 90.56, ["Ride"] = 46.76, ["Fly|Ride"] = 78.75, ["Neon"] = 262.5, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 252, ["Mega"] = 1223.88, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 288.22, ["Fly"] = 367.68, ["Ride"] = 300.57, ["Fly|Ride"] = 262.5, ["Neon"] = 1620.76, ["Neon|Ride"] = 1403.59, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4577.49}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 249.61, ["Fly"] = 330.75, ["Ride"] = 249.36, ["Fly|Ride"] = 330.64, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5042.71, ["Mega|Fly|Ride"] = 4574.85}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 736.63, ["Ride"] = 698.15, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3603.48, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10517.6}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.47, ["Fly"] = 62.68, ["Ride"] = 47.24, ["Fly|Ride"] = 107.47, ["Neon"] = 49.88, ["Neon|Fly"] = 293.74, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 262.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3281.25, ["Fly"] = 3543.75, ["Ride"] = 3346.88, ["Fly|Ride"] = 3213, ["Neon|Fly|Ride"] = 8020.69, ["Mega|Fly|Ride"] = 18898.95}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 141.74, ["Fly"] = 146.4, ["Ride"] = 155.63, ["Fly|Ride"] = 207.38, ["Neon"] = 535.5, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 3133.46, ["Mega|Fly|Ride"] = 3235.03}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.38, ["Fly"] = 20.57, ["Ride"] = 19.08, ["Fly|Ride"] = 43.32, ["Neon"] = 21, ["Neon|Fly"] = 99.74, ["Neon|Ride"] = 35.81, ["Neon|Fly|Ride"] = 98.05, ["Mega"] = 172.75, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 245.06}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.98, ["Ride"] = 27.98, ["Fly|Ride"] = 71.4, ["Neon"] = 22.15, ["Neon|Fly"] = 119.95, ["Neon|Ride"] = 49.01, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 179.15, ["Mega|Ride"] = 276.2, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 39.38, ["Fly"] = 41.99, ["Ride"] = 40.73, ["Fly|Ride"] = 49.08, ["Neon"] = 294.14, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1225.31}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 885.18, ["Fly"] = 1176.55, ["Ride"] = 853.13, ["Fly|Ride"] = 1038.19, ["Neon|Ride"] = 4577.49, ["Neon|Fly|Ride"] = 4770.13}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 8204.02, ["Ride"] = 9190.83, ["Fly|Ride"] = 8996.07}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21.65, ["Fly"] = 43.32, ["Ride"] = 23.16, ["Fly|Ride"] = 49.9, ["Neon"] = 452.13, ["Neon|Ride"] = 120.3, ["Neon|Fly|Ride"] = 162.56, ["Mega"] = 2520, ["Mega|Ride"] = 866.49, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.75, ["Fly"] = 43.28, ["Ride"] = 26.25, ["Fly|Ride"] = 78.74, ["Neon"] = 102.38, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 76.52, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 132.49, ["Ride"] = 101.32, ["Fly|Ride"] = 128.61, ["Neon"] = 487.73, ["Neon|Ride"] = 430.5, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.15, ["Fly"] = 236.25, ["Ride"] = 236.25, ["Fly|Ride"] = 262.29, ["Neon"] = 1286.25, ["Neon|Ride"] = 1079.25, ["Neon|Fly|Ride"] = 1017.19, ["Mega"] = 10805.01, ["Mega|Fly|Ride"] = 4577.49}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.25, ["Ride"] = 32.82, ["Fly|Ride"] = 72.19, ["Neon"] = 20.99, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 65.63, ["Mega"] = 136.5, ["Mega|Fly"] = 240.97, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 190.3, ["Fly"] = 253.3, ["Ride"] = 196.88, ["Fly|Ride"] = 288.74, ["Neon"] = 654.94, ["Neon|Fly"] = 833.4, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 720.57, ["Mega|Fly|Ride"] = 3062.13}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.3, ["Fly"] = 24.34, ["Ride"] = 17.07, ["Fly|Ride"] = 49.72, ["Neon"] = 25.2, ["Neon|Fly"] = 129.67, ["Neon|Ride"] = 44.14, ["Neon|Fly|Ride"] = 124.27, ["Mega"] = 183.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 262.49, ["Fly"] = 356.05, ["Ride"] = 196.88, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 1281.39, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 10806.08, ["Mega|Fly|Ride"] = 4902.27}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.18, ["Fly"] = 105, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 311.26, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 577.06, ["Mega|Ride"] = 445.18, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 98.15, ["Neon"] = 11.11, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 88.45, ["Mega|Ride"] = 136.14, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 20.9, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 137.36}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.29, ["Ride"] = 32.67, ["Fly|Ride"] = 115.47, ["Neon"] = 8.12, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 61.67, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 85.56, ["Mega|Fly|Ride"] = 280.1}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.48, ["Fly"] = 130.99, ["Ride"] = 96.77, ["Fly|Ride"] = 131.25, ["Neon"] = 274.32, ["Neon|Ride"] = 286.96, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1619.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.03, ["Ride"] = 16.22, ["Fly|Ride"] = 83.47, ["Neon"] = 11.55, ["Neon|Ride"] = 28.09, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.45, ["Ride"] = 73.49, ["Neon"] = 82.27, ["Neon|Fly"] = 327.24, ["Neon|Ride"] = 213.26, ["Neon|Fly|Ride"] = 360.91, ["Mega"] = 392.44, ["Mega|Ride"] = 574.84, ["Mega|Fly|Ride"] = 540.96}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.55, ["Neon"] = 3.23, ["Neon|Ride"] = 56.41, ["Neon|Fly|Ride"] = 198.82, ["Mega"] = 15.39, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.54, ["Ride"] = 11.82, ["Fly|Ride"] = 49.72, ["Neon"] = 2.1, ["Neon|Fly"] = 40.67, ["Neon|Ride"] = 12.32, ["Neon|Fly|Ride"] = 32.71, ["Mega"] = 14.33, ["Mega|Fly"] = 36.17, ["Mega|Ride"] = 18.27, ["Mega|Fly|Ride"] = 49.23}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.19, ["Ride"] = 16.06, ["Fly|Ride"] = 81.04, ["Neon"] = 2.1, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 17.16, ["Neon|Fly|Ride"] = 36.54, ["Mega"] = 18.24, ["Mega|Fly"] = 164.25, ["Mega|Ride"] = 32.4, ["Mega|Fly|Ride"] = 90.46}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 90.78, ["Mega"] = 18.38, ["Mega|Ride"] = 130.99, ["Mega|Fly|Ride"] = 432.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 21, ["Fly|Ride"] = 55.12, ["Neon"] = 3.57, ["Neon|Fly"] = 123.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 41.5, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 41.16, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.03, ["Neon|Ride"] = 84.63, ["Neon|Fly|Ride"] = 432.21, ["Mega"] = 19.02, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 5.49, ["Fly"] = 71.07, ["Ride"] = 42, ["Fly|Ride"] = 156.15, ["Neon"] = 43.08, ["Neon|Fly"] = 137.43, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 168.19, ["Mega"] = 212.07, ["Mega|Fly"] = 159.87, ["Mega|Ride"] = 170.15, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 81.95, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.97, ["Neon|Fly|Ride"] = 106.8, ["Mega"] = 16.28, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 66.01, ["Mega|Fly|Ride"] = 196.1}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.59, ["Fly"] = 65.63, ["Ride"] = 145.89, ["Fly|Ride"] = 144.8, ["Neon"] = 21.6, ["Mega"] = 111.57, ["Mega|Fly"] = 315, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 21, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.81, ["Ride"] = 32.82, ["Neon"] = 3.51, ["Neon|Ride"] = 26.57, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 22.28, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 98.05}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.6, ["Ride"] = 13.13, ["Fly|Ride"] = 40.27, ["Neon"] = 2.1, ["Neon|Fly"] = 35.21, ["Neon|Ride"] = 13.74, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 19.6, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.84, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 37.8, ["Neon|Ride"] = 72.42, ["Mega"] = 201.85, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.23, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 16.48, ["Neon|Ride"] = 195.11, ["Mega"] = 104.64, ["Mega|Ride"] = 179.39, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.24, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Ride"] = 50.74, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 36.17, ["Ride"] = 11.8, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 12.34, ["Neon|Ride"] = 13.79, ["Neon|Fly|Ride"] = 30.85, ["Mega"] = 11.82, ["Mega|Fly"] = 27.59, ["Mega|Ride"] = 20.9, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.19, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.67, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.41, ["Fly"] = 118.13, ["Ride"] = 24.52, ["Fly|Ride"] = 59.07, ["Neon"] = 77.23, ["Neon|Ride"] = 72.3, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 304.5, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.36, ["Ride"] = 14.42, ["Fly|Ride"] = 41.51, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 12.47, ["Neon|Fly|Ride"] = 41.89, ["Mega"] = 21.61, ["Mega|Fly"] = 50.79, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 180.46, ["Ride"] = 45.91, ["Neon"] = 7.38, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 45.94, ["Mega|Fly"] = 164.22, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.59, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 28.88, ["Mega|Fly"] = 115.75, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 19.65, ["Neon"] = 2.1, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 15.06, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 68.66, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.79, ["Ride"] = 19.67, ["Fly|Ride"] = 54.3, ["Neon"] = 6.04, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 34.37, ["Neon|Fly|Ride"] = 74.8, ["Mega"] = 105.21, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 23.3, ["Neon"] = 3.71, ["Neon|Ride"] = 43.23, ["Mega"] = 47.25, ["Mega|Fly"] = 327.09, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 20.51, ["Ride"] = 17.21, ["Fly|Ride"] = 40.68, ["Neon"] = 3.94, ["Neon|Fly"] = 82.14, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 114.19, ["Mega|Fly"] = 115.77, ["Mega|Ride"] = 90.11, ["Mega|Fly|Ride"] = 193.37}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 38.19, ["Neon"] = 16.23, ["Neon|Fly"] = 188.88, ["Neon|Ride"] = 25.97, ["Neon|Fly|Ride"] = 323.8, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 18.38, ["Fly|Ride"] = 47.25, ["Neon"] = 5.94, ["Neon|Fly"] = 49.03, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 102.67, ["Mega"] = 137.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 101.67, ["Mega|Fly|Ride"] = 177.79}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.36, ["Fly"] = 14.22, ["Ride"] = 17.07, ["Fly|Ride"] = 64.75, ["Neon"] = 13.01, ["Neon|Fly"] = 27.45, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 205.1, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 135.36, ["Mega|Fly|Ride"] = 231.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.94, ["Fly"] = 114.57, ["Neon"] = 101.58, ["Neon|Ride"] = 86.98, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 324.16}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.87, ["Ride"] = 53.93, ["Neon"] = 72.35, ["Neon|Ride"] = 170.63, ["Mega"] = 673.17, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 980.46}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 40.34, ["Neon"] = 52.5, ["Neon|Ride"] = 115.63, ["Mega"] = 223.13, ["Mega|Ride"] = 252.84}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 7.86, ["Ride"] = 59.85, ["Fly|Ride"] = 104.99, ["Neon"] = 49.82, ["Neon|Ride"] = 72.15, ["Neon|Fly|Ride"] = 125.58, ["Mega"] = 225.68, ["Mega|Ride"] = 418.17, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Mega"] = 18.38, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 127.4, ["Mega|Fly|Ride"] = 238.81}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.58}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.57, ["Fly"] = 23.39, ["Ride"] = 23.62, ["Fly|Ride"] = 47.25, ["Neon"] = 39.29, ["Neon|Fly"] = 187.7, ["Neon|Ride"] = 47.15, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 460.36, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 252.86}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.29, ["Neon"] = 4.62, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 18.38, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 56.21, ["Mega|Fly|Ride"] = 129.54}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 4.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70.73, ["Mega"] = 32.12, ["Mega|Ride"] = 59.01, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 50.81, ["Ride"] = 14.96, ["Fly|Ride"] = 45.27, ["Neon"] = 11.4, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 67.48, ["Mega"] = 162.09, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 158.68}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.38, ["Ride"] = 28.05, ["Fly|Ride"] = 82.05, ["Neon"] = 17.28, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 147, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 327.24}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 102.67, ["Mega"] = 18.27, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 50.96, ["Mega|Fly|Ride"] = 162.09}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.71, ["Ride"] = 17.18, ["Fly|Ride"] = 59.07, ["Neon"] = 3.5, ["Neon|Fly"] = 115.04, ["Neon|Ride"] = 16.42, ["Neon|Fly|Ride"] = 98.05, ["Mega"] = 32.82, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 51.97, ["Mega|Fly|Ride"] = 144.64}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.29, ["Fly|Ride"] = 26.95, ["Neon"] = 4.76, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 19.53, ["Neon|Fly|Ride"] = 59.58, ["Mega"] = 85.38, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 119.95}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.55, ["Fly"] = 91.88, ["Ride"] = 49.03, ["Fly|Ride"] = 131.25, ["Neon"] = 10.39, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 80.07, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 157823.93, ["Mega"] = 16.43, ["Mega|Fly"] = 122.11, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 18.95, ["Fly|Ride"] = 51.19, ["Neon"] = 3.86, ["Neon|Fly"] = 28.17, ["Neon|Ride"] = 24.2, ["Neon|Fly|Ride"] = 90.7, ["Mega"] = 17.07, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 38.09, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 15.49, ["Mega|Ride"] = 129.67}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.31, ["Mega|Ride"] = 206.39, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 14.97, ["Fly|Ride"] = 69.57, ["Neon"] = 6.57, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 17.91, ["Neon|Fly|Ride"] = 48.39, ["Mega"] = 38.07, ["Mega|Ride"] = 37.96, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.4, ["Ride"] = 78.75, ["Fly|Ride"] = 216.12, ["Neon"] = 78.41, ["Neon|Ride"] = 78.75, ["Mega"] = 351.46, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 28.88, ["Neon"] = 7.88, ["Neon|Ride"] = 157.5, ["Mega"] = 210.72, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.6, ["Ride"] = 32.63, ["Fly|Ride"] = 131.25, ["Neon"] = 23.94, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 232.31, ["Mega|Ride"] = 296.81, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.85, ["Ride"] = 12.99, ["Fly|Ride"] = 25.26, ["Neon"] = 2.1, ["Neon|Fly"] = 19.47, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 13.13, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 21.84, ["Mega|Fly|Ride"] = 53.82}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.53, ["Neon"] = 9.86, ["Neon|Fly"] = 68.59, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 719.88, ["Mega"] = 65.63, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.42, ["Mega|Fly"] = 144.8, ["Mega|Fly|Ride"] = 180.46}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.38, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 23.55, ["Mega|Fly"] = 216.12, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.56, ["Ride"] = 20.54, ["Fly|Ride"] = 44.35, ["Neon"] = 10.34, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 76.3, ["Mega"] = 168, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 245.13}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 192.94, ["Ride"] = 210, ["Fly|Ride"] = 823.13, ["Neon|Ride"] = 863.52, ["Neon|Fly|Ride"] = 954.73, ["Mega"] = 8644.88, ["Mega|Fly|Ride"] = 3267.45}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 4.33, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.84, ["Fly"] = 103.68, ["Ride"] = 16.23, ["Fly|Ride"] = 65.63, ["Neon"] = 28.11, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 172.7, ["Mega"] = 387.19, ["Mega|Ride"] = 229.2, ["Mega|Fly|Ride"] = 215.88}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 16.23, ["Fly|Ride"] = 30.19, ["Neon"] = 5.91, ["Neon|Fly"] = 33.51, ["Neon|Ride"] = 28.69, ["Neon|Fly|Ride"] = 52.77, ["Mega"] = 49.68, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 84.18, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.33, ["Ride"] = 19.69, ["Fly|Ride"] = 135.47, ["Neon"] = 8.91, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 85.38, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 27.11, ["Ride"] = 16.77, ["Fly|Ride"] = 40.69, ["Neon"] = 31.5, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega|Ride"] = 960.67, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 34.51, ["Fly|Ride"] = 117.67, ["Neon"] = 50.67, ["Neon|Ride"] = 68.72, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 257.25, ["Mega|Ride"] = 319.38, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 6.57, ["Fly"] = 18.35, ["Ride"] = 16.69, ["Fly|Ride"] = 32.45, ["Neon"] = 31.5, ["Neon|Fly"] = 95.61, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 97.12, ["Mega"] = 262.5, ["Mega|Ride"] = 374.95, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 59.24, ["Ride"] = 94.49, ["Fly|Ride"] = 144.38, ["Neon"] = 332, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 378.5, ["Neon|Fly|Ride"] = 365.97, ["Mega"] = 2018.4, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 247.95, ["Fly"] = 432.21, ["Ride"] = 247.19, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1296.49, ["Mega|Fly|Ride"] = 5042.71}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 63, ["Fly"] = 109.51, ["Ride"] = 70.88, ["Fly|Ride"] = 122.2, ["Neon"] = 490.24, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 429.6, ["Mega|Fly|Ride"] = 1873.6}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.88, ["Fly"] = 288.29, ["Ride"] = 28.88, ["Fly|Ride"] = 78.21, ["Neon"] = 49.03, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Neon|Fly|Ride"] = 215.21, ["Mega"] = 262.5, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 327.24}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.4, ["Ride"] = 26.24, ["Fly|Ride"] = 90.63, ["Neon"] = 63, ["Neon|Ride"] = 89.82, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 301.23, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 34.53, ["Ride"] = 16.26, ["Fly|Ride"] = 42, ["Neon"] = 3.76, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 72.33, ["Mega"] = 36.66, ["Mega|Fly"] = 149.51, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 545.66}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.35, ["Fly"] = 69.17, ["Ride"] = 32.8, ["Fly|Ride"] = 66.05, ["Neon"] = 101.87, ["Neon|Fly"] = 288.5, ["Neon|Ride"] = 114.55, ["Neon|Fly|Ride"] = 307.7, ["Mega"] = 518.65, ["Mega|Ride"] = 556.43, ["Mega|Fly|Ride"] = 605.1}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.9, ["Fly|Ride"] = 45.94, ["Neon"] = 17.33, ["Neon|Fly"] = 51.89, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 85.77, ["Mega"] = 144.22, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 291.06}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.58, ["Ride"] = 27.42, ["Fly|Ride"] = 328.13, ["Neon"] = 14.44, ["Neon|Ride"] = 115.22, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 207.38, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 231.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.39, ["Neon"] = 2.1, ["Neon|Ride"] = 19.09, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 14.64, ["Mega|Ride"] = 43.23, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.13, ["Fly"] = 24.82, ["Ride"] = 19.69, ["Fly|Ride"] = 43.28, ["Neon"] = 14.42, ["Neon|Fly"] = 108.08, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 139.73, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 214.6}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 19.09, ["Fly|Ride"] = 71.11, ["Neon"] = 19.69, ["Neon|Ride"] = 47.25, ["Mega"] = 131.25, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 267.68}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 108.93, ["Fly"] = 164.39, ["Ride"] = 141.48, ["Fly|Ride"] = 210, ["Neon"] = 430.39, ["Neon|Ride"] = 463.08, ["Neon|Fly|Ride"] = 556.5, ["Mega"] = 3921.82, ["Mega|Fly|Ride"] = 3456.16}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 3.94, ["Ride"] = 129.55, ["Fly|Ride"] = 131.25, ["Neon"] = 49.49, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.24, ["Ride"] = 19.41, ["Fly|Ride"] = 56.3, ["Neon"] = 32.82, ["Neon|Ride"] = 62.97, ["Neon|Fly|Ride"] = 122.31, ["Mega"] = 210, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 316.32}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.22, ["Ride"] = 28.88, ["Fly|Ride"] = 159.01, ["Neon"] = 91.88, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 501.05, ["Mega|Fly"] = 864.49, ["Mega|Ride"] = 755.29, ["Mega|Fly|Ride"] = 832.36}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 7.3}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.31, ["Ride"] = 36.65, ["Fly|Ride"] = 128.6, ["Neon"] = 39.38, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 300.46, ["Mega|Ride"] = 598.5, ["Mega|Fly|Ride"] = 864.41}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21, ["Fly"] = 33.38, ["Ride"] = 27.28, ["Fly|Ride"] = 39.37, ["Neon"] = 90.57, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 142.19, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 1393.35, ["Mega|Fly|Ride"] = 603.96}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 44.58, ["Neon|Fly|Ride"] = 137.25, ["Mega"] = 27.46, ["Mega|Fly"] = 189, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 232.83}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 28.21, ["Fly|Ride"] = 65.54, ["Neon"] = 64.84, ["Neon|Ride"] = 158.79, ["Mega"] = 288.33, ["Mega|Fly"] = 408.78, ["Mega|Ride"] = 326.33, ["Mega|Fly|Ride"] = 518.65}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 19.36, ["Fly|Ride"] = 48.57, ["Neon"] = 16.96, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 76.67, ["Mega"] = 183.75, ["Mega|Ride"] = 211.98, ["Mega|Fly|Ride"] = 232.58}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 81.05, ["Neon"] = 2.1, ["Neon|Fly"] = 274.46, ["Neon|Ride"] = 41.65, ["Mega"] = 39.38, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 220.62}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 21.78, ["Fly"] = 90.96, ["Ride"] = 86.51, ["Fly|Ride"] = 99.75, ["Neon"] = 227.07, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 834.17, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 15.65, ["Ride"] = 43.17, ["Fly|Ride"] = 210, ["Neon"] = 93.94, ["Neon|Ride"] = 42.91, ["Mega|Ride"] = 324.16}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.5, ["Fly"] = 23.63, ["Ride"] = 21.27, ["Fly|Ride"] = 65.63, ["Neon"] = 13.13, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 41.63, ["Neon|Fly|Ride"] = 63, ["Mega"] = 196.88, ["Mega|Ride"] = 136.59, ["Mega|Fly|Ride"] = 280.17}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.32, ["Fly"] = 433.12, ["Ride"] = 129.67, ["Neon"] = 319.85, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4577.49, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.23, ["Fly"] = 46.1, ["Ride"] = 24.93, ["Fly|Ride"] = 50.7, ["Neon"] = 30.74, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 121.42, ["Mega"] = 246.54, ["Mega|Ride"] = 252.15, ["Mega|Fly|Ride"] = 364.5}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 76.04, ["Fly"] = 131.24, ["Ride"] = 118.1, ["Fly|Ride"] = 206.07, ["Neon"] = 245.03, ["Neon|Ride"] = 205.82, ["Neon|Fly|Ride"] = 357, ["Mega"] = 1018.5, ["Mega|Ride"] = 1079.73, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 61.69, ["Fly|Ride"] = 165.74, ["Neon"] = 82.63, ["Neon|Ride"] = 81.17, ["Neon|Fly|Ride"] = 212.65, ["Mega"] = 339.13, ["Mega|Ride"] = 345.21, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 7.08, ["Fly"] = 39.38, ["Ride"] = 25.92, ["Fly|Ride"] = 72.42, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 389.21, ["Mega"] = 572.35, ["Mega|Ride"] = 574.84, ["Mega|Fly|Ride"] = 633.55}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.88, ["Fly"] = 100.59, ["Ride"] = 48.57, ["Fly|Ride"] = 83.15, ["Neon"] = 58.94, ["Neon|Ride"] = 120.63, ["Neon|Fly|Ride"] = 237.48, ["Mega"] = 288.5, ["Mega|Fly"] = 526.21, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 411.51}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 10.75, ["Ride"] = 30.18, ["Neon"] = 90.65, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 251.83, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 430.75}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 98.34, ["Neon|Ride"] = 179.39, ["Mega"] = 19.04, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 6.57, ["Ride"] = 141.75, ["Fly|Ride"] = 325.9, ["Neon"] = 35.57, ["Neon|Ride"] = 207.47, ["Neon|Fly|Ride"] = 201.54, ["Mega"] = 236.25, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 734.76}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.61, ["Ride"] = 29.19, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 230.98, ["Mega"] = 164.08, ["Mega|Ride"] = 327.24, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.17, ["Ride"] = 32.8, ["Neon"] = 14.47, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 129.67, ["Mega|Ride"] = 288.5, ["Mega|Fly|Ride"] = 517.13}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 511.87, ["Fly"] = 706.67, ["Ride"] = 551.25, ["Fly|Ride"] = 630, ["Neon"] = 1791.48, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1654.16, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.95, ["Fly"] = 45.47, ["Ride"] = 23.3, ["Fly|Ride"] = 61.74, ["Neon"] = 42.16, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 202.08, ["Mega|Ride"] = 375.75, ["Mega|Fly|Ride"] = 358.75}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 15.51, ["Fly"] = 66.94, ["Ride"] = 21, ["Fly|Ride"] = 54.1, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 331.87, ["Mega|Ride"] = 253.94, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.32, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 50.59, ["Neon"] = 13.13, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 32.82, ["Fly|Ride"] = 90.57, ["Neon"] = 11.82, ["Neon|Ride"] = 38.85, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 74.72, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 64.84, ["Neon"] = 2.1, ["Neon|Ride"] = 31.67, ["Neon|Fly|Ride"] = 129.67, ["Mega"] = 23.61, ["Mega|Ride"] = 108.07, ["Mega|Fly|Ride"] = 231.25}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.12}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.28, ["Ride"] = 40.85, ["Fly|Ride"] = 86.37, ["Neon"] = 69.93, ["Neon|Ride"] = 107.86, ["Mega"] = 295.32, ["Mega|Ride"] = 403.01, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 5.9, ["Neon|Ride"] = 28.11, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 127.65, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.58, ["Fly"] = 328.47, ["Ride"] = 82.14, ["Fly|Ride"] = 116.45, ["Neon"] = 26.25, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Fly"] = 539.63, ["Mega|Ride"] = 354.42, ["Mega|Fly|Ride"] = 1080.52}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.5, ["Ride"] = 341.25, ["Fly|Ride"] = 513.11, ["Neon"] = 1691.29, ["Neon|Ride"] = 1708.45, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8103.76, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.65, ["Fly"] = 196.88, ["Ride"] = 40.69, ["Fly|Ride"] = 129.67, ["Neon"] = 71.53, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.1, ["Mega"] = 306.57, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 518.7}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.61, ["Ride"] = 28.95, ["Fly|Ride"] = 118.12, ["Neon"] = 5.25, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 77.66, ["Mega"] = 105, ["Mega|Fly"] = 144.69, ["Mega|Ride"] = 72.31, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.09, ["Neon|Ride"] = 143, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 33.74, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 36.75, ["Fly"] = 107.91, ["Ride"] = 83.77, ["Fly|Ride"] = 172.9, ["Neon"] = 144.38, ["Neon|Ride"] = 410.53, ["Neon|Fly|Ride"] = 343.65, ["Mega"] = 706.67, ["Mega|Ride"] = 576.33, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 11.87, ["Neon"] = 98.44, ["Neon|Ride"] = 271.23, ["Neon|Fly|Ride"] = 864.41, ["Mega"] = 572.35, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.7, ["Ride"] = 76.13, ["Neon"] = 120.75, ["Neon|Ride"] = 172.9, ["Mega"] = 663.45, ["Mega|Fly|Ride"] = 1243.4}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.38, ["Ride"] = 50.72, ["Fly|Ride"] = 224.58, ["Neon"] = 144.38, ["Neon|Ride"] = 168.73, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.13, ["Mega|Ride"] = 793.11, ["Mega|Fly|Ride"] = 621.3}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.49, ["Ride"] = 427.23, ["Fly|Ride"] = 734.76, ["Neon"] = 1069.69, ["Neon|Ride"] = 1267.04, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 11.69, ["Fly"] = 41.15, ["Ride"] = 34.13, ["Fly|Ride"] = 132.7, ["Neon"] = 148.32, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 143.94, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 562.42, ["Mega|Fly|Ride"] = 864.41}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.61, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 78.75, ["Neon|Ride"] = 144.8, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 33.74, ["Fly"] = 345.78, ["Ride"] = 129.57, ["Neon"] = 144.65, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 540.27, ["Mega"] = 367.5, ["Mega|Ride"] = 455.43, ["Mega|Fly|Ride"] = 536.81}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 43.23, ["Fly|Ride"] = 215.87, ["Neon"] = 7.64, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 279.86, ["Mega"] = 65.62, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 49.88, ["Ride"] = 81.3, ["Neon"] = 262.42, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1654.52, ["Mega|Ride"] = 1586.42, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 21, ["Neon"] = 11.4, ["Neon|Fly"] = 188.02, ["Neon|Ride"] = 36.78, ["Neon|Fly|Ride"] = 147.08, ["Mega"] = 67.47, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 29.16, ["Ride"] = 28.88, ["Fly|Ride"] = 95.52, ["Neon"] = 6.57, ["Neon|Fly"] = 63.74, ["Neon|Ride"] = 37.84, ["Neon|Fly|Ride"] = 137.25, ["Mega"] = 26.76, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 77.13, ["Mega|Fly|Ride"] = 272.54}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 21.6, ["Fly|Ride"] = 130.97, ["Neon"] = 10.63, ["Neon|Ride"] = 53.97, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.44, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 53.64, ["Ride"] = 62.22, ["Fly|Ride"] = 246.37, ["Neon"] = 248.07, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 490.24, ["Mega|Ride"] = 1152.9, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 12.87, ["Neon"] = 21.2, ["Neon|Fly"] = 350.44, ["Mega"] = 262.49, ["Mega|Ride"] = 330.81, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.23, ["Fly|Ride"] = 78.75, ["Neon"] = 6.43, ["Neon|Ride"] = 72.42, ["Mega"] = 50.85, ["Mega|Fly"] = 210, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.28, ["Fly"] = 108.07, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Mega"] = 318.47, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.27, ["Fly"] = 78.75, ["Ride"] = 45.51, ["Fly|Ride"] = 308.91, ["Neon"] = 27.09, ["Neon|Ride"] = 71.34, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 184.83, ["Mega|Ride"] = 186.01, ["Mega|Fly|Ride"] = 361.56}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.57, ["Neon|Ride"] = 94.01, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 77.44, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 866.66}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 60.97, ["Neon"] = 4.1, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 102.88, ["Mega"] = 37.77, ["Mega|Ride"] = 99.26, ["Mega|Fly|Ride"] = 235.99}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 19.08, ["Fly|Ride"] = 57.75, ["Neon"] = 18.05, ["Neon|Fly"] = 102.55, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 156.16, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.85, ["Fly"] = 72.42, ["Ride"] = 27.02, ["Fly|Ride"] = 78.75, ["Neon"] = 144.35, ["Neon|Ride"] = 97.94, ["Mega"] = 459.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 646.75}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.88, ["Ride"] = 66.93, ["Fly|Ride"] = 139.13, ["Neon"] = 328.13, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 431.13, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2146.97, ["Mega|Ride"] = 1614.29, ["Mega|Fly|Ride"] = 1482.83}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Fly|Ride"] = 144.38, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 33.68, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 32.9, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.41, ["Ride"] = 15.65, ["Fly|Ride"] = 42.95, ["Neon"] = 4.29, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 39.37, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 7.51, ["Fly"] = 43.23, ["Ride"] = 38.04, ["Fly|Ride"] = 65.63, ["Neon"] = 40.67, ["Neon|Ride"] = 164.25, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 547.83, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 472.5, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4317.11, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.38, ["Fly"] = 99.74, ["Ride"] = 52.41, ["Fly|Ride"] = 78.75, ["Neon"] = 217.75, ["Neon|Ride"] = 204.28, ["Neon|Fly|Ride"] = 215.96, ["Mega"] = 720.57, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 864.05}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.76, ["Fly|Ride"] = 287.43, ["Neon"] = 9.3, ["Neon|Ride"] = 50.93, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 72.42, ["Mega|Ride"] = 123.48, ["Mega|Fly|Ride"] = 288.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 59.29, ["Fly|Ride"] = 261.97, ["Neon"] = 144.64, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 577.48}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.57, ["Fly"] = 169.31, ["Ride"] = 34.29, ["Fly|Ride"] = 78.75, ["Neon"] = 186.58, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 274.46, ["Mega|Ride"] = 1293.03, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.22, ["Fly"] = 188.02, ["Ride"] = 128.62, ["Fly|Ride"] = 180.91, ["Neon"] = 430.1, ["Neon|Fly"] = 821.2, ["Neon|Ride"] = 490.24, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3166.59, ["Mega|Fly|Ride"] = 6483.66}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.94, ["Ride"] = 295.32, ["Fly|Ride"] = 539.18, ["Neon"] = 774.38, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.21, ["Ride"] = 55.32, ["Fly|Ride"] = 72.19, ["Neon"] = 98.44, ["Neon|Ride"] = 88.48, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 863.5, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 16.42, ["Fly|Ride"] = 38.07, ["Neon"] = 8.63, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 58.42, ["Mega"] = 80.89, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.47, ["Fly"] = 43.32, ["Ride"] = 19.92, ["Fly|Ride"] = 63, ["Neon"] = 34.09, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.62, ["Neon|Fly|Ride"] = 142.4, ["Mega"] = 274.46, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 302.27}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 315, ["Ride"] = 350.44, ["Fly|Ride"] = 721.88, ["Neon"] = 1351.79, ["Neon|Fly|Ride"] = 2089.69, ["Mega"] = 10805.01, ["Mega|Fly|Ride"] = 5316.43}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.51, ["Neon"] = 9.74, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 34.8, ["Mega|Ride"] = 171.95}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.5, ["Ride"] = 16.35, ["Fly|Ride"] = 42.69, ["Neon"] = 22.32, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 79.46, ["Mega"] = 213.95, ["Mega|Fly"] = 288.5, ["Mega|Ride"] = 146.99, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.77, ["Fly"] = 6562.5, ["Ride"] = 59.07, ["Neon"] = 105, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 551.25, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 721.31}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 115.57, ["Fly"] = 157.5, ["Ride"] = 129.89, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 817.46, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2920.32}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 13.17, ["Fly"] = 39.29, ["Ride"] = 25.89, ["Fly|Ride"] = 64.84, ["Neon"] = 102.92, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 114.72, ["Mega"] = 875.44, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 477.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.45, ["Neon"] = 3.93, ["Neon|Ride"] = 81.05, ["Mega"] = 24.55, ["Mega|Ride"] = 124.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 86.36, ["Neon"] = 3.12, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 86.83, ["Mega"] = 24.68, ["Mega|Fly"] = 94.01, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 142.76}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 15.54, ["Ride"] = 85.32, ["Fly|Ride"] = 254.89, ["Neon"] = 42, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 165.27, ["Mega|Ride"] = 212.39, ["Mega|Fly|Ride"] = 357.76}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.13, ["Fly"] = 1529.52, ["Ride"] = 1312.5, ["Fly|Ride"] = 1312.5, ["Neon"] = 3281.25, ["Neon|Ride"] = 4322.01, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 426.11, ["Ride"] = 504, ["Fly|Ride"] = 545.99, ["Neon"] = 1680, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6537.16}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 300.99, ["Fly"] = 414.25, ["Ride"] = 347.82, ["Fly|Ride"] = 436.95, ["Neon"] = 787.5, ["Neon|Fly"] = 1144.69, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 898.41, ["Mega|Ride"] = 3457.61, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 229.69, ["Fly"] = 288.75, ["Ride"] = 274.32, ["Fly|Ride"] = 347.71, ["Neon"] = 647.07, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 3290.72}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 34.8, ["Ride"] = 15.75, ["Fly|Ride"] = 48.37, ["Neon"] = 7.88, ["Neon|Ride"] = 34.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.78, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 273.72, ["Fly"] = 1441.4, ["Ride"] = 326.04, ["Fly|Ride"] = 360.94, ["Neon"] = 1378.13, ["Neon|Ride"] = 1254.49, ["Neon|Fly|Ride"] = 1654.52, ["Mega"] = 21900.66, ["Mega|Ride"] = 5474.91, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 5.96, ["Fly"] = 144.38, ["Ride"] = 52.49, ["Neon"] = 28.45, ["Neon|Ride"] = 123.72, ["Neon|Fly|Ride"] = 129.67, ["Mega"] = 182.21, ["Mega|Ride"] = 343.04, ["Mega|Fly|Ride"] = 720.7}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.47, ["Fly|Ride"] = 39.38, ["Neon"] = 6.22, ["Neon|Ride"] = 54.05, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 118.02, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 159.12}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.81, ["Mega"] = 21.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.08, ["Ride"] = 91.88, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8170.83, ["Ride"] = 19.69, ["Fly|Ride"] = 68.25, ["Neon"] = 23.63, ["Neon|Ride"] = 62.37, ["Mega"] = 358.75, ["Mega|Ride"] = 231.25, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.62, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 22.32, ["Mega|Ride"] = 163.32, ["Mega|Fly|Ride"] = 96.37}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 6.56, ["Fly"] = 86.24, ["Ride"] = 41.1, ["Fly|Ride"] = 90.57, ["Neon"] = 30.77, ["Neon|Fly"] = 115.49, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 157.31, ["Mega|Fly"] = 86.37, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.68, ["Fly"] = 32.43, ["Ride"] = 22.31, ["Fly|Ride"] = 48.33, ["Neon"] = 28.88, ["Neon|Fly"] = 147.08, ["Neon|Ride"] = 135.85, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.84, ["Ride"] = 38.07, ["Fly|Ride"] = 147.08, ["Neon"] = 59.07, ["Neon|Ride"] = 172.9, ["Neon|Fly|Ride"] = 327.24, ["Mega|Ride"] = 809.39}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.94, ["Fly"] = 6536.03, ["Ride"] = 20.35, ["Fly|Ride"] = 131.24, ["Neon"] = 61.69, ["Neon|Ride"] = 215.03, ["Neon|Fly|Ride"] = 735.35, ["Mega"] = 366.19, ["Mega|Ride"] = 504.61, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 69.18, ["Ride"] = 17.07, ["Fly|Ride"] = 41.23, ["Neon"] = 5.25, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.21, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 164.39}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 162.42, ["Fly"] = 263.66, ["Ride"] = 183.75, ["Fly|Ride"] = 272.3, ["Neon"] = 864.41, ["Neon|Ride"] = 864.05, ["Neon|Fly|Ride"] = 968.69, ["Mega"] = 8644.88, ["Mega|Fly|Ride"] = 4412.03}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 22.51, ["Ride"] = 17.26, ["Fly|Ride"] = 36.88, ["Neon"] = 3.86, ["Neon|Fly"] = 36.78, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 50.78, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.57, ["Ride"] = 72.42, ["Fly|Ride"] = 230.9, ["Neon"] = 65.01, ["Neon|Fly|Ride"] = 744.74, ["Mega"] = 360.91, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 415.8}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.74, ["Ride"] = 101.58, ["Fly|Ride"] = 183.75, ["Neon"] = 189, ["Neon|Ride"] = 302.56, ["Neon|Fly|Ride"] = 414.12, ["Mega"] = 786.19, ["Mega|Ride"] = 918.74, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 194.25, ["Fly"] = 223.13, ["Ride"] = 236.24, ["Fly|Ride"] = 320.49, ["Neon"] = 811.07, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 849.99, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 23.81, ["Fly"] = 131.16, ["Ride"] = 154.71, ["Neon"] = 147.08, ["Neon|Ride"] = 176.65, ["Neon|Fly|Ride"] = 432.21, ["Mega"] = 273.24, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 596.05}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 26.44, ["Ride"] = 57.74, ["Fly|Ride"] = 147.9, ["Neon"] = 161.18, ["Neon|Fly"] = 164.25, ["Neon|Ride"] = 202.08, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 1728.81, ["Mega|Ride"] = 1441.4, ["Mega|Fly|Ride"] = 717.47}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 944.9, ["Fly"] = 1225.58, ["Ride"] = 1048.69, ["Fly|Ride"] = 1023.65, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 3740.63, ["Mega|Fly|Ride"] = 17286.94}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 13.02, ["Fly"] = 26.88, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 45.84, ["Neon|Fly"] = 68.58, ["Neon|Ride"] = 50.66, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 231.44, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.86, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 135.19, ["Neon"] = 25.98, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 211.79, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 288.5, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 77.44, ["Ride"] = 28.11, ["Fly|Ride"] = 105, ["Neon"] = 9.44, ["Neon|Ride"] = 47.81, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 81.23, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.22, ["Ride"] = 35.31, ["Fly|Ride"] = 122.34, ["Neon"] = 68.86, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 446.24, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 434.51}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.3, ["Ride"] = 17.06, ["Fly|Ride"] = 40.3, ["Neon"] = 19.19, ["Neon|Fly"] = 41.02, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 175.29}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 35.9, ["Ride"] = 26.15, ["Fly|Ride"] = 131.24, ["Neon"] = 15.17, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131.25, ["Mega|Ride"] = 215.86, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 262.49, ["Fly|Ride"] = 432.21, ["Neon"] = 576.33, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3919.93}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 105.59, ["Neon"] = 8.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 69.49, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 335.83}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.64, ["Ride"] = 21, ["Fly|Ride"] = 88.86, ["Neon"] = 19.21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 274.2}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 33.52, ["Neon"] = 19.69, ["Neon|Ride"] = 48.4, ["Mega"] = 93.19, ["Mega|Ride"] = 120.56, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 84.63, ["Ride"] = 131.25, ["Fly|Ride"] = 249.38, ["Neon"] = 431.13, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2593.21, ["Mega|Ride"] = 4322.45, ["Mega|Fly|Ride"] = 1564.59}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 13.13, ["Fly"] = 88.08, ["Ride"] = 63.79, ["Fly|Ride"] = 272.66, ["Neon"] = 124.76, ["Neon|Ride"] = 432.11, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.17, ["Fly"] = 263.44, ["Ride"] = 32.82, ["Fly|Ride"] = 114.55, ["Neon"] = 82.43, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 609, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 530.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.17, ["Ride"] = 71.58, ["Neon"] = 15.75, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 245.49, ["Mega"] = 108.86, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 36.75, ["Fly"] = 64.96, ["Ride"] = 71.3, ["Fly|Ride"] = 144.36, ["Neon"] = 249.82, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 288.74, ["Mega|Fly|Ride"] = 1027.35}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.6, ["Fly|Ride"] = 216.09, ["Neon"] = 5.6, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 91.88, ["Mega|Ride"] = 287.11, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.99, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 93.16, ["Neon"] = 64.54, ["Neon|Fly"] = 84, ["Neon|Ride"] = 82.14, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 360.91, ["Mega|Fly|Ride"] = 361.2}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.94, ["Fly"] = 203.41, ["Ride"] = 81.38, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 432.21, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1478.13, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.55, ["Ride"] = 15.75, ["Fly|Ride"] = 41.66, ["Neon"] = 2.1, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 17.29, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 19.58, ["Mega|Ride"] = 40.42, ["Mega|Fly|Ride"] = 86.14}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.88, ["Fly"] = 105, ["Ride"] = 25.41, ["Fly|Ride"] = 64.31, ["Neon"] = 26.25, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 168, ["Mega"] = 161.44, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 379.94}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.44, ["Fly"] = 144.8, ["Ride"] = 41.15, ["Fly|Ride"] = 117.25, ["Neon"] = 111.08, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 271.38, ["Mega"] = 706.67, ["Mega|Ride"] = 454.78, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 2.63, ["Neon|Fly"] = 32.81, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 21, ["Mega|Ride"] = 140.31, ["Mega|Fly|Ride"] = 431.34}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 31.4, ["Fly"] = 210, ["Ride"] = 65.6, ["Fly|Ride"] = 222.12, ["Neon"] = 161.44, ["Neon|Ride"] = 171.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 689.06, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 647.47, ["Mega|Fly|Ride"] = 704.6}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.7, ["Fly"] = 43.23, ["Ride"] = 24.54, ["Fly|Ride"] = 95.1, ["Neon"] = 376.69, ["Neon|Ride"] = 123.04, ["Neon|Fly|Ride"] = 166.42, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.68, ["Ride"] = 59.83, ["Neon"] = 58.42, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 720.7, ["Mega"] = 236.25, ["Mega|Ride"] = 345.78, ["Mega|Fly|Ride"] = 490.24}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.56, ["Fly"] = 72.19, ["Ride"] = 68.16, ["Fly|Ride"] = 242.19, ["Neon"] = 39.38, ["Neon|Ride"] = 102.44, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 254.69, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 36.71, ["Fly|Ride"] = 196.88, ["Neon"] = 12.8, ["Neon|Fly"] = 210, ["Neon|Ride"] = 37.43, ["Mega"] = 69.57, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 288.5}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 43.21, ["Mega"] = 45.85, ["Mega|Ride"] = 92.52, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 23.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 50.1, ["Fly"] = 65.63, ["Ride"] = 72.19, ["Fly|Ride"] = 91.87, ["Neon"] = 182.44, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.61}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.07, ["Neon"] = 2.1, ["Neon|Ride"] = 114.57, ["Mega"] = 21, ["Mega|Ride"] = 117.51, ["Mega|Fly|Ride"] = 324.16}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 513.68, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 4322.45, ["Neon|Ride"] = 2703.51, ["Neon|Fly|Ride"] = 2701.26, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.85, ["Fly"] = 48.86, ["Ride"] = 33.74, ["Fly|Ride"] = 66.21, ["Neon"] = 46.48, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.63, ["Mega"] = 327.24, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 634.28}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.78, ["Fly"] = 25.99, ["Ride"] = 23.61, ["Fly|Ride"] = 53.95, ["Neon"] = 26.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 140.47, ["Mega|Ride"] = 176.26, ["Mega|Fly|Ride"] = 230.61}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.37, ["Fly"] = 24.94, ["Ride"] = 38.07, ["Neon"] = 112.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 486.65, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 490.24}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.2, ["Fly"] = 58.36, ["Ride"] = 38.57, ["Fly|Ride"] = 72.42, ["Neon"] = 40.56, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 504.66}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 16.72, ["Ride"] = 57.75, ["Fly|Ride"] = 196.88, ["Neon"] = 90.87, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 534.86, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 500.18}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.81, ["Ride"] = 37.3, ["Fly|Ride"] = 101.58, ["Neon"] = 31.17, ["Neon|Ride"] = 97.26, ["Neon|Fly|Ride"] = 278.79, ["Mega"] = 232.21, ["Mega|Ride"] = 286.16, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.81, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 14.18, ["Mega|Fly"] = 66.21, ["Mega|Ride"] = 31.28, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.03, ["Fly"] = 26.25, ["Ride"] = 56.43, ["Fly|Ride"] = 108.07, ["Neon"] = 46.07, ["Neon|Fly"] = 122.57, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 203.46, ["Mega"] = 212.18, ["Mega|Ride"] = 274.7, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 251.79, ["Ride"] = 292.69, ["Fly|Ride"] = 390.01, ["Neon"] = 1151.72, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9510.38, ["Mega|Fly|Ride"] = 4329.94}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 83.91, ["Ride"] = 131.25, ["Fly|Ride"] = 257.17, ["Neon"] = 458.07, ["Neon|Fly"] = 925.01, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 2303.18, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 16.2, ["Fly|Ride"] = 36.75, ["Neon"] = 7.43, ["Neon|Fly"] = 101.59, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.8, ["Mega|Fly"] = 215.06, ["Mega|Ride"] = 114.55, ["Mega|Fly|Ride"] = 259.23}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 15.49, ["Fly|Ride"] = 32.82, ["Neon"] = 8.71, ["Neon|Fly"] = 28.18, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 51.19, ["Mega|Fly"] = 288.5, ["Mega|Ride"] = 92.66, ["Mega|Fly|Ride"] = 148.56}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.9, ["Fly"] = 101.47, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 114.55, ["Neon|Ride"] = 42.91, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 332.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.99, ["Fly"] = 327.24, ["Ride"] = 219.19, ["Fly|Ride"] = 336, ["Neon"] = 1188.56, ["Neon|Ride"] = 919.21, ["Neon|Fly|Ride"] = 972.19, ["Mega|Ride"] = 8644.88, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 32.06, ["Ride"] = 17.06, ["Fly|Ride"] = 50.79, ["Neon"] = 15.65, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 76.5, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Ride"] = 77.18, ["Fly|Ride"] = 216.12, ["Neon"] = 24.61, ["Neon|Ride"] = 110.1, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 262.29, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 431.72}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 12.63, ["Neon|Ride"] = 137.82, ["Mega"] = 103.95}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.82, ["Fly"] = 50.85, ["Ride"] = 27.45, ["Fly|Ride"] = 59.52, ["Neon"] = 98.67, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 354.38, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 817.46}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 34.09, ["Fly"] = 106.98, ["Ride"] = 98.15, ["Fly|Ride"] = 298.93, ["Neon"] = 142.05, ["Neon|Fly"] = 655.95, ["Neon|Ride"] = 181.56, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 393.74, ["Mega|Fly"] = 2269.29, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 718.98}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.94, ["Fly"] = 42, ["Ride"] = 49.63, ["Fly|Ride"] = 91.88, ["Neon"] = 144.27, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 150.89, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 863.43, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.81, ["Ride"] = 16.08, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.64, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 43.23, ["Mega"] = 20.62, ["Mega|Fly"] = 43.21, ["Mega|Ride"] = 31.91, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 230.24, ["Ride"] = 246.74, ["Fly|Ride"] = 297.41, ["Neon"] = 3431, ["Neon|Ride"] = 972.19, ["Neon|Fly|Ride"] = 1316.48, ["Mega|Fly|Ride"] = 5038.39}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.86, ["Fly"] = 101.19, ["Ride"] = 16.93, ["Fly|Ride"] = 95.82, ["Neon"] = 101.46, ["Neon|Ride"] = 66.25, ["Neon|Fly|Ride"] = 432.21, ["Mega"] = 380.63, ["Mega|Ride"] = 577, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.35, ["Ride"] = 18.78, ["Fly|Ride"] = 50.71, ["Neon"] = 5.22, ["Neon|Fly"] = 37.8, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 62.51, ["Mega|Fly"] = 231.25, ["Mega|Ride"] = 86.45, ["Mega|Fly|Ride"] = 201.41}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 18.41, ["Fly|Ride"] = 82.01, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 58.28, ["Mega"] = 26.12, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 12.5, ["Neon|Fly"] = 735.23, ["Neon|Ride"] = 54.98, ["Neon|Fly|Ride"] = 98.58, ["Mega"] = 155.54, ["Mega|Ride"] = 144.42, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.39, ["Fly"] = 26.97, ["Ride"] = 28.01, ["Fly|Ride"] = 75.66, ["Neon"] = 46.41, ["Neon|Fly"] = 245.28, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 286.5, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 55.13, ["Ride"] = 32.81, ["Neon"] = 129.67, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 215.93, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 58.36, ["Neon"] = 3.29, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 18.54, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 169.31}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.6, ["Fly"] = 83.99, ["Ride"] = 32.82, ["Fly|Ride"] = 144.8, ["Neon"] = 38.38, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 432.21, ["Mega"] = 159.93, ["Mega|Fly"] = 259.88, ["Mega|Ride"] = 319.6, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 3.92, ["Neon|Fly"] = 115.63, ["Neon|Ride"] = 29.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.86, ["Mega|Ride"] = 122.11, ["Mega|Fly|Ride"] = 201.88}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 52.24, ["Ride"] = 15.75, ["Fly|Ride"] = 58.84, ["Neon"] = 3.61, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 131.16, ["Mega"] = 45.92, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 206.39}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 617.46, ["Ride"] = 623.44, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3431.59, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 14.84, ["Fly|Ride"] = 34.53, ["Neon"] = 28.14, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 85.31}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 50.79, ["Neon"] = 7.76, ["Neon|Fly"] = 756.45, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 152.81, ["Mega"] = 77.44, ["Mega|Ride"] = 132.61, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.5, ["Fly"] = 23.63, ["Ride"] = 21.34, ["Fly|Ride"] = 48.44, ["Neon"] = 41.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 110.06, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.64, ["Fly|Ride"] = 58.36, ["Neon"] = 8.99, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 58.45, ["Mega"] = 65.63, ["Mega|Ride"] = 94.55, ["Mega|Fly|Ride"] = 152.78}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 33.05, ["Ride"] = 59.07, ["Fly|Ride"] = 323.35, ["Neon"] = 194.74, ["Neon|Ride"] = 287.43, ["Mega"] = 962.46, ["Mega|Ride"] = 777.14, ["Mega|Fly|Ride"] = 784.79}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 7.03, ["Neon|Fly"] = 139.73, ["Neon|Ride"] = 37.82, ["Neon|Fly|Ride"] = 123.47, ["Mega"] = 47.24, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.67, ["Fly"] = 39.38, ["Ride"] = 21.16, ["Fly|Ride"] = 81.35, ["Neon"] = 10.02, ["Neon|Ride"] = 56.39, ["Mega"] = 113.99, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.19, ["Fly|Ride"] = 65.83, ["Neon"] = 11.71, ["Mega"] = 97.13, ["Mega|Ride"] = 92.37, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.46, ["Ride"] = 15.62, ["Fly|Ride"] = 69.21, ["Neon"] = 4.73, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 45.94, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 75.51}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.37, ["Fly"] = 21.39, ["Ride"] = 18.38, ["Fly|Ride"] = 43.61, ["Neon"] = 118.13, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 140.47, ["Mega|Ride"] = 476.91, ["Mega|Fly|Ride"] = 485.18}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 721.77, ["Fly"] = 1080.52, ["Ride"] = 774.38, ["Fly|Ride"] = 787.5, ["Neon"] = 1584.19, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 8644.88, ["Mega|Fly|Ride"] = 4463.82}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.19, ["Ride"] = 13.13, ["Fly|Ride"] = 47.24, ["Neon"] = 3.94, ["Neon|Fly"] = 50.79, ["Neon|Ride"] = 19.2, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 36.66, ["Mega|Ride"] = 68.09, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 9.19, ["Ride"] = 36.74, ["Fly|Ride"] = 202.04, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 518.65}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.88, ["Ride"] = 63.95, ["Fly|Ride"] = 111.56, ["Neon"] = 315, ["Neon|Ride"] = 293.07, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 32.19, ["Fly"] = 146.86, ["Ride"] = 45.94, ["Fly|Ride"] = 106.42, ["Neon"] = 144.8, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 209.05, ["Mega"] = 1470.69, ["Mega|Ride"] = 935.72, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.5, ["Fly"] = 95.61, ["Ride"] = 29.33, ["Neon"] = 59.97, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 305.36, ["Mega|Ride"] = 431.13, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.79, ["Fly"] = 86.45, ["Ride"] = 59.07, ["Fly|Ride"] = 144.8, ["Neon"] = 105, ["Neon|Ride"] = 106.32, ["Mega"] = 338.97, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 22.84, ["Ride"] = 34.56, ["Neon"] = 146.9, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 374.95, ["Mega"] = 534.86, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.92}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.16, ["Ride"] = 28.88, ["Fly|Ride"] = 105, ["Neon"] = 31.5, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 244.88}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 19.03, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 34.02, ["Fly"] = 63, ["Ride"] = 45.85, ["Fly|Ride"] = 84.13, ["Neon"] = 220.5, ["Neon|Fly"] = 288.18, ["Neon|Ride"] = 202.08, ["Neon|Fly|Ride"] = 220.62, ["Mega|Ride"] = 720.7, ["Mega|Fly|Ride"] = 679.96}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.46, ["Fly"] = 18.52, ["Ride"] = 18.53, ["Fly|Ride"] = 43.32, ["Neon"] = 34.13, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 75.15, ["Mega"] = 233.41, ["Mega|Fly"] = 431.13, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 198.19}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.69, ["Fly"] = 31.87, ["Ride"] = 31.5, ["Fly|Ride"] = 53.91, ["Neon"] = 21.97, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 219.19, ["Mega|Ride"] = 146.9, ["Mega|Fly|Ride"] = 247.76}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Mega"] = 37.72, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 39.59, ["Ride"] = 53.81, ["Fly|Ride"] = 144.8, ["Neon"] = 245.28, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 454.13, ["Mega"] = 573.07, ["Mega|Ride"] = 855.78, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 31.36, ["Fly|Ride"] = 58.36, ["Neon"] = 7.65, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.74, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.24, ["Ride"] = 82.69, ["Fly|Ride"] = 287.43, ["Neon"] = 59.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 324.16, ["Mega"] = 406.88, ["Mega|Fly"] = 577, ["Mega|Ride"] = 400.77, ["Mega|Fly|Ride"] = 534.86}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 16.95, ["Fly|Ride"] = 44.63, ["Neon"] = 18.31, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 154.23, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.63, ["Fly"] = 52.49, ["Ride"] = 18.18, ["Fly|Ride"] = 47.31, ["Neon"] = 51.19, ["Neon|Ride"] = 43.28, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 612.69, ["Mega|Ride"] = 431.13, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.46, ["Neon"] = 91.87, ["Neon|Fly|Ride"] = 144.94, ["Mega"] = 418.06, ["Mega|Ride"] = 365.75, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 45.48, ["Ride"] = 72.34, ["Neon"] = 314.9, ["Neon|Ride"] = 483.82, ["Neon|Fly|Ride"] = 861.11}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.35, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 393.75, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 679.23}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.67, ["Ride"] = 114.09, ["Neon"] = 92.94, ["Neon|Fly"] = 216.12, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 512.17}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.63, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 138.32, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 677.49, ["Mega|Fly"] = 2161.23, ["Mega|Ride"] = 640.89, ["Mega|Fly|Ride"] = 810.38}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.67, ["Neon"] = 20.55, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 327.24}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.68, ["Fly|Ride"] = 42.02, ["Neon"] = 3.68, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 65.09, ["Mega"] = 58.28, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 144.27}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.67, ["Fly"] = 45.94, ["Ride"] = 26.95, ["Fly|Ride"] = 80.26, ["Neon"] = 12.74, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 89.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.8, ["Ride"] = 24.94, ["Fly|Ride"] = 71.91, ["Neon"] = 6.36, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 92.18, ["Mega"] = 45.94, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 164.39}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.29, ["Fly|Ride"] = 72.42, ["Neon"] = 19.15, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 328.02, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.08, ["Fly"] = 61.46, ["Ride"] = 26.17, ["Fly|Ride"] = 431.72, ["Neon"] = 30.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 306.89, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1080.62}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.71, ["Fly"] = 131.25, ["Ride"] = 23.21, ["Fly|Ride"] = 68.64, ["Neon"] = 33.67, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 85.32, ["Mega|Ride"] = 278.22, ["Mega|Fly|Ride"] = 466.6}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 22.32, ["Fly|Ride"] = 52.41, ["Neon"] = 26.31, ["Neon|Ride"] = 69.09, ["Neon|Fly|Ride"] = 151.3, ["Mega"] = 274.46, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.94, ["Fly"] = 288.73, ["Ride"] = 47.23, ["Fly|Ride"] = 131.25, ["Neon"] = 17.81, ["Neon|Fly"] = 49.72, ["Neon|Ride"] = 69.69, ["Neon|Fly|Ride"] = 73.49, ["Mega"] = 90.57, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.94, ["Ride"] = 105, ["Fly|Ride"] = 330.75, ["Neon"] = 131.25, ["Neon|Ride"] = 294.14, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 824.42, ["Mega|Ride"] = 791.2, ["Mega|Fly|Ride"] = 692.69}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 53.45, ["Fly"] = 164.07, ["Ride"] = 85.44, ["Fly|Ride"] = 144.66, ["Neon"] = 240.9, ["Neon|Ride"] = 243.22, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 1584.03, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1222.11}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 51.89, ["Neon"] = 2.1, ["Neon|Ride"] = 21.5, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 27.56, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 5.28, ["Neon"] = 105.94, ["Mega"] = 677.49, ["Mega|Fly|Ride"] = 1138.87}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.47, ["Ride"] = 90.7, ["Neon"] = 249.37, ["Neon|Ride"] = 344.37, ["Neon|Fly|Ride"] = 864.05, ["Mega"] = 1780.68, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.85, ["Fly"] = 190.32, ["Ride"] = 26.64, ["Fly|Ride"] = 133.88, ["Neon"] = 39.38, ["Neon|Fly"] = 131.13, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.62, ["Mega"] = 267.46, ["Mega|Fly"] = 740.12, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.41, ["Ride"] = 26.25, ["Fly|Ride"] = 118.12, ["Neon"] = 9.78, ["Neon|Ride"] = 95.1, ["Neon|Fly|Ride"] = 210, ["Mega"] = 87.94, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 265.46}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 34.04, ["Ride"] = 19.46, ["Fly|Ride"] = 47.44, ["Neon"] = 25.62, ["Neon|Fly"] = 43.28, ["Neon|Ride"] = 37.59, ["Neon|Fly|Ride"] = 95.51, ["Mega"] = 172.9, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.15}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.76, ["Ride"] = 14.11, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Fly"] = 124.77, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 23.62, ["Mega|Ride"] = 73.12, ["Mega|Fly|Ride"] = 154.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.55, ["Fly|Ride"] = 93.09, ["Neon"] = 4.85, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 39.46, ["Mega|Fly"] = 107.41, ["Mega|Ride"] = 85.8, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 42.18, ["Neon"] = 2.6, ["Neon|Ride"] = 145.08, ["Mega"] = 22.28, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.05, ["Ride"] = 157.5, ["Neon"] = 43.12, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 409.28, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.69, ["Ride"] = 30.19, ["Fly|Ride"] = 215.72, ["Neon"] = 61.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 285.48, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 8.14, ["Fly"] = 27.57, ["Ride"] = 21.52, ["Fly|Ride"] = 45.94, ["Neon"] = 45.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 354.42, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.98, ["Ride"] = 97.13, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 476.52, ["Neon|Fly|Ride"] = 720.78, ["Mega"] = 2451.14, ["Mega|Ride"] = 1628.32, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 12.9, ["Fly"] = 82.69, ["Ride"] = 59.07, ["Fly|Ride"] = 115.63, ["Neon"] = 1005.26, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1004.73}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.25, ["Fly|Ride"] = 36.38, ["Neon"] = 2.52, ["Neon|Fly"] = 43.19, ["Neon|Ride"] = 20.77, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 19.69, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 324.16}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.07, ["Ride"] = 15.57, ["Fly|Ride"] = 35.15, ["Neon"] = 3.84, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.07, ["Neon|Fly|Ride"] = 43.04, ["Mega"] = 51.93, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 90.57}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.75, ["Fly"] = 576.03, ["Ride"] = 419.99, ["Fly|Ride"] = 523.69, ["Neon"] = 2377.12, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2097.38, ["Mega|Fly|Ride"] = 6843.9}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.25, ["Ride"] = 34.13, ["Neon"] = 40.83, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 719.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 14.67, ["Fly|Ride"] = 49.72, ["Neon"] = 3.85, ["Neon|Fly"] = 20.1, ["Neon|Ride"] = 20.51, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.29, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.08, ["Ride"] = 117.59, ["Fly|Ride"] = 285, ["Neon"] = 199.49, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 702.92, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.99, ["Ride"] = 21.41, ["Fly|Ride"] = 90.57, ["Neon"] = 27.57, ["Neon|Fly"] = 80.05, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 163.31, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 18.74, ["Fly|Ride"] = 196.88, ["Neon"] = 3.61, ["Neon|Fly"] = 101.58, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 17.63, ["Mega|Ride"] = 52.45, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.25, ["Fly"] = 129.94, ["Ride"] = 75.12, ["Fly|Ride"] = 215.03, ["Neon"] = 131.15, ["Neon|Ride"] = 163.93, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 706.67, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 716.51}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 5.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.45, ["Mega"] = 62.68, ["Mega|Ride"] = 155.7, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.88, ["Ride"] = 63.44, ["Fly|Ride"] = 105, ["Neon"] = 283.23, ["Neon|Ride"] = 323.54, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1296.61, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.13, ["Fly"] = 72.42, ["Ride"] = 131.25, ["Fly|Ride"] = 432.21, ["Neon"] = 18.4, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 163.93, ["Mega"] = 169.32, ["Mega|Ride"] = 239.01, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.97, ["Ride"] = 81.33, ["Fly|Ride"] = 58.36, ["Neon"] = 8.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 117.6, ["Mega|Ride"] = 123.44, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 40.45, ["Fly"] = 188.02, ["Ride"] = 111.57, ["Fly|Ride"] = 163.24, ["Neon|Ride"] = 418.51, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2018.4}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.48, ["Ride"] = 29.4, ["Neon"] = 8.13, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 39.38, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 20.91, ["Ride"] = 19.69, ["Fly|Ride"] = 26.25, ["Neon"] = 5.12, ["Neon|Fly"] = 42, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 73.55, ["Mega"] = 59.13, ["Mega|Fly"] = 150.55, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 219.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.28, ["Fly"] = 57.91, ["Ride"] = 37.64, ["Fly|Ride"] = 195.83, ["Neon"] = 81.03, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 196.1, ["Mega"] = 210, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 405.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 10.63, ["Fly"] = 43.23, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 52.41, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 126, ["Mega"] = 354.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 420.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.32, ["Fly"] = 28.88, ["Ride"] = 32.82, ["Fly|Ride"] = 42, ["Neon"] = 50.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 156.15, ["Mega"] = 404.13, ["Mega|Ride"] = 327.45, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 72.19, ["Ride"] = 101.71, ["Fly|Ride"] = 194.24, ["Neon"] = 282.19, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1575, ["Mega|Ride"] = 1668.31, ["Mega|Fly|Ride"] = 1670.02}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.57, ["Ride"] = 115.63, ["Fly|Ride"] = 101.72, ["Neon"] = 62.39, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 302.39, ["Mega"] = 241.5, ["Mega|Fly"] = 577.48, ["Mega|Ride"] = 404.13, ["Mega|Fly|Ride"] = 621.37}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.85, ["Ride"] = 25.57, ["Fly|Ride"] = 78.73, ["Neon"] = 21.62, ["Neon|Ride"] = 44.63, ["Mega"] = 164.39, ["Mega|Ride"] = 166.42, ["Mega|Fly|Ride"] = 487.65}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 8.97, ["Fly"] = 135.19, ["Ride"] = 36.39, ["Fly|Ride"] = 115.5, ["Neon"] = 76.13, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 180.52, ["Mega"] = 317.63, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.99, ["Fly|Ride"] = 42.78, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.15, ["Neon|Fly|Ride"] = 55, ["Mega"] = 14.74, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.62, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 45.36, ["Fly"] = 164.07, ["Ride"] = 102.65, ["Neon"] = 236.15, ["Neon|Fly"] = 2449.75, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 486.25, ["Mega"] = 1080.52, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.05, ["Fly|Ride"] = 144.8, ["Neon"] = 7.72, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 45.4, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.16, ["Ride"] = 17.6, ["Fly|Ride"] = 45.94, ["Neon"] = 18.35, ["Neon|Ride"] = 29.09, ["Neon|Fly|Ride"] = 64.31, ["Mega"] = 257.25, ["Mega|Ride"] = 197.51, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 56.43, ["Fly"] = 108.07, ["Ride"] = 90.56, ["Fly|Ride"] = 170.63, ["Neon"] = 192.95, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 337.13, ["Mega"] = 836.14, ["Mega|Ride"] = 1144.69, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 10.41, ["Neon|Ride"] = 52.5, ["Mega"] = 40.69, ["Mega|Fly"] = 159.34, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.34}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.66, ["Fly|Ride"] = 134.08, ["Neon"] = 7.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 78.75, ["Mega|Fly"] = 188.02, ["Mega|Ride"] = 105.14, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.14, ["Ride"] = 183.75, ["Fly|Ride"] = 353.34, ["Neon"] = 604.52, ["Neon|Ride"] = 598.88, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6483.02, ["Mega|Ride"] = 3268.59, ["Mega|Fly|Ride"] = 2731.64}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.07, ["Ride"] = 36.75, ["Fly|Ride"] = 98.05, ["Neon"] = 24.49, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 103.47, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.48, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.92, ["Neon"] = 3.78, ["Neon|Ride"] = 21.32, ["Mega"] = 40.98, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 71.1, ["Mega|Fly|Ride"] = 345.78}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.19, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 65.54, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 159.71, ["Mega"] = 297.15, ["Mega|Ride"] = 432.21, ["Mega|Fly|Ride"] = 668.21}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 6.86, ["Fly"] = 43.89, ["Ride"] = 22.32, ["Fly|Ride"] = 62.68, ["Neon"] = 101.03, ["Neon|Ride"] = 128.6, ["Neon|Fly|Ride"] = 197.54, ["Mega"] = 229.2, ["Mega|Ride"] = 431.13, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.85, ["Ride"] = 52.67, ["Fly|Ride"] = 172.5, ["Neon"] = 128.63, ["Neon|Ride"] = 215.03, ["Neon|Fly|Ride"] = 322.21, ["Mega"] = 561.32, ["Mega|Ride"] = 496.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 157.4, ["Fly"] = 196.88, ["Ride"] = 144.65, ["Fly|Ride"] = 249.27, ["Neon"] = 577.5, ["Neon|Fly"] = 817.46, ["Neon|Ride"] = 578.55, ["Neon|Fly|Ride"] = 643.02, ["Mega|Fly|Ride"] = 2161.01}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 9.7, ["Fly"] = 23.22, ["Ride"] = 23.81, ["Fly|Ride"] = 44.91, ["Neon"] = 50.93, ["Neon|Fly"] = 58.36, ["Neon|Ride"] = 55.83, ["Neon|Fly|Ride"] = 64.77, ["Mega"] = 324.16, ["Mega|Ride"] = 315.61, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.48, ["Fly"] = 131.23, ["Ride"] = 27.78, ["Fly|Ride"] = 65.63, ["Neon"] = 18.27, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 115.22, ["Mega"] = 144.48, ["Mega|Ride"] = 205.31, ["Mega|Fly|Ride"] = 284.82}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.88, ["Fly"] = 42.33, ["Ride"] = 37.76, ["Fly|Ride"] = 90.57, ["Neon"] = 39.36, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 458.07, ["Mega|Ride"] = 429.85, ["Mega|Fly|Ride"] = 1303.23}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 49.35, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 127.4, ["Neon"] = 210, ["Neon|Fly"] = 178.5, ["Neon|Ride"] = 249.61, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 967.07, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 962.73}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.17, ["Fly"] = 57.75, ["Ride"] = 261.51, ["Neon"] = 196.88, ["Neon|Ride"] = 259.33, ["Neon|Fly|Ride"] = 476.52, ["Mega"] = 1049.9, ["Mega|Ride"] = 666.17, ["Mega|Fly|Ride"] = 821.2}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.88, ["Ride"] = 350.44, ["Neon"] = 1634.92, ["Neon|Ride"] = 3264.07, ["Mega|Fly|Ride"] = 5186.42}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 22.32, ["Fly"] = 58.65, ["Ride"] = 26.25, ["Fly|Ride"] = 69.47, ["Neon"] = 215.72, ["Neon|Ride"] = 129.55, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 761.25, ["Mega|Ride"] = 753.33, ["Mega|Fly|Ride"] = 859.3}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 14.44, ["Fly|Ride"] = 72.42, ["Neon"] = 2.1, ["Neon|Fly"] = 21.62, ["Neon|Ride"] = 16.91, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 22.04, ["Mega|Fly"] = 114.55, ["Mega|Ride"] = 50.29, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 29.19, ["Neon"] = 15.65, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 107.94, ["Mega|Ride"] = 164.25, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.45, ["Ride"] = 32.82, ["Fly|Ride"] = 144.21, ["Neon"] = 26.93, ["Neon|Ride"] = 69.22, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.62, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 380.01, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 356.9, ["Fly"] = 505.32, ["Ride"] = 418.48, ["Fly|Ride"] = 505.32, ["Neon"] = 1898.49, ["Neon|Ride"] = 2001.11, ["Neon|Fly|Ride"] = 1871.63, ["Mega|Fly|Ride"] = 5623.29}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.4, ["Fly|Ride"] = 86.45, ["Neon"] = 26.17, ["Neon|Ride"] = 36.78, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 221.71, ["Mega|Ride"] = 215.88, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.1, ["Fly"] = 22.32, ["Ride"] = 16.55, ["Fly|Ride"] = 42.89, ["Neon"] = 43.26, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 181.4, ["Mega|Ride"] = 288.5, ["Mega|Fly|Ride"] = 311.92}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.59, ["Fly"] = 42, ["Ride"] = 26.25, ["Fly|Ride"] = 56.46, ["Neon"] = 15.58, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 113.45, ["Mega"] = 94.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.08, ["Fly"] = 57.62, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 220.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 323.09, ["Mega"] = 1296.61, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 51.19, ["Fly|Ride"] = 51.85, ["Neon"] = 12.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 10.56, ["Fly"] = 93.12, ["Ride"] = 43.23, ["Neon"] = 108.15, ["Neon|Fly|Ride"] = 259.23, ["Mega"] = 748.13, ["Mega|Ride"] = 721.31, ["Mega|Fly|Ride"] = 791.6}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.57, ["Neon|Ride"] = 28.05, ["Neon|Fly|Ride"] = 115.32, ["Mega"] = 55.11, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 107.92, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.6, ["Neon"] = 53.66, ["Mega"] = 136.02, ["Mega|Ride"] = 327.18, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.71, ["Ride"] = 36.78, ["Neon"] = 72.1, ["Neon|Ride"] = 288.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 318.47, ["Mega|Ride"] = 560.8, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.82, ["Fly"] = 26.25, ["Ride"] = 23.28, ["Fly|Ride"] = 56.42, ["Neon"] = 55.02, ["Neon|Fly"] = 115.22, ["Neon|Ride"] = 51.81, ["Neon|Fly|Ride"] = 130.61, ["Mega"] = 539.18, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 462, ["Fly"] = 489.82, ["Ride"] = 440.46, ["Fly|Ride"] = 522.38, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 1958.69, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7448.98}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.26, ["Fly|Ride"] = 39.37, ["Neon"] = 29.43, ["Neon|Fly"] = 82.01, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 245.28, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 307.63}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.8, ["Fly"] = 71.31, ["Fly|Ride"] = 188.02, ["Neon"] = 73.5, ["Neon|Ride"] = 127.25, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 393.75, ["Mega|Fly"] = 720.7, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 588.28}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 28.18, ["Fly"] = 87.68, ["Ride"] = 91.56, ["Fly|Ride"] = 245.03, ["Neon"] = 88.68, ["Neon|Ride"] = 213.84, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 307.84, ["Mega|Ride"] = 466.79, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 50.07, ["Fly"] = 169.32, ["Ride"] = 84, ["Fly|Ride"] = 124.69, ["Neon"] = 311.85, ["Neon|Ride"] = 314.9, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Fly|Ride"] = 1846.94}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.03, ["Ride"] = 49.87, ["Neon"] = 46.23, ["Neon|Ride"] = 82.32, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 165.38, ["Mega|Ride"] = 194.41, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 18.24, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 102.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.46, ["Ride"] = 47.11, ["Neon"] = 22.26, ["Neon|Ride"] = 123.19, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 175.06, ["Mega|Fly"] = 257.17, ["Mega|Ride"] = 156.64, ["Mega|Fly|Ride"] = 273.4}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.72, ["Fly"] = 183.72, ["Ride"] = 87.94, ["Fly|Ride"] = 197.65, ["Neon"] = 118.13, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 262.97, ["Mega"] = 354.38, ["Mega|Ride"] = 395.19, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.33, ["Ride"] = 85.28, ["Neon"] = 9.18, ["Neon|Ride"] = 101.67, ["Neon|Fly|Ride"] = 230.9, ["Mega"] = 56.43, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 24.87, ["Ride"] = 97.11, ["Neon"] = 136.5, ["Neon|Ride"] = 374.07, ["Mega"] = 695.63, ["Mega|Fly|Ride"] = 814.79}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 951.56, ["Fly"] = 1194.38, ["Ride"] = 1009.32, ["Fly|Ride"] = 1074.12, ["Neon"] = 3603.48, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2859.94, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 17.07, ["Fly"] = 116.94, ["Ride"] = 44.18, ["Fly|Ride"] = 184.65, ["Neon"] = 65.63, ["Neon|Fly"] = 719.63, ["Neon|Ride"] = 177.56, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 229.69, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 50.37, ["Ride"] = 21.62, ["Fly|Ride"] = 103.95, ["Neon"] = 10.5, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 91.23, ["Mega"] = 64.94, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.49, ["Ride"] = 131.25, ["Fly|Ride"] = 144.8, ["Neon"] = 63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 382.03, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.7, ["Neon"] = 2.52, ["Neon|Ride"] = 26.7, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 17.07, ["Mega|Ride"] = 48.82, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 56.42, ["Fly"] = 129.67, ["Ride"] = 99.52, ["Fly|Ride"] = 266.44, ["Neon"] = 220.49, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 216.29, ["Neon|Fly|Ride"] = 384.74, ["Mega"] = 952.59, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.13, ["Ride"] = 62.89, ["Fly|Ride"] = 282.47, ["Neon"] = 168, ["Neon|Ride"] = 328.13, ["Mega"] = 490.56, ["Mega|Ride"] = 863.9, ["Mega|Fly|Ride"] = 1007.04}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.14, ["Ride"] = 23.2, ["Neon"] = 10.11, ["Neon|Ride"] = 40.99, ["Neon|Fly|Ride"] = 123.19, ["Mega"] = 98.04, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 484.09}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.12, ["Fly"] = 159.75, ["Ride"] = 41.03, ["Fly|Ride"] = 105.87, ["Neon"] = 84, ["Neon|Ride"] = 95.69, ["Neon|Fly|Ride"] = 188.02, ["Mega"] = 462.78, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 489.63}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.63, ["Fly"] = 96.14, ["Ride"] = 28.17, ["Fly|Ride"] = 59.07, ["Neon"] = 90.57, ["Neon|Fly"] = 131.16, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 144.19, ["Mega"] = 358.39, ["Mega|Ride"] = 540.27, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39, ["Ride"] = 91.88, ["Neon"] = 324.16, ["Neon|Ride"] = 324.16, ["Neon|Fly|Ride"] = 577, ["Mega"] = 2521.91, ["Mega|Ride"] = 2447.74, ["Mega|Fly|Ride"] = 2161.01}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.08, ["Fly|Ride"] = 192.94, ["Neon"] = 11.21, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 651, ["Mega"] = 66.18, ["Mega|Ride"] = 114.76, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.97, ["Ride"] = 23.63, ["Fly|Ride"] = 90.57, ["Neon"] = 39.29, ["Neon|Fly"] = 187.81, ["Neon|Ride"] = 93.01, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 301.26, ["Mega|Ride"] = 337.13, ["Mega|Fly|Ride"] = 299.82}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 109.66, ["Fly"] = 393.75, ["Ride"] = 157.5, ["Fly|Ride"] = 236.25, ["Neon"] = 459.38, ["Neon|Ride"] = 546.68, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 1951.62}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 18.38, ["Fly|Ride"] = 49.58, ["Neon"] = 25.5, ["Neon|Fly"] = 57.43, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 73.61, ["Mega"] = 131.25, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 21, ["Fly"] = 85.32, ["Ride"] = 58.5, ["Fly|Ride"] = 162.09, ["Neon"] = 170.63, ["Neon|Ride"] = 187.15, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 646.49, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 12.5, ["Fly|Ride"] = 57.75, ["Neon"] = 2.1, ["Neon|Fly"] = 29.03, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 14.42, ["Mega|Fly"] = 47.81, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 69.13}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.36, ["Neon"] = 3.28, ["Neon|Fly|Ride"] = 134.01, ["Mega"] = 20.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 27.57, ["Fly|Ride"] = 173.36, ["Neon"] = 14.89, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 136.17, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 34.13, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 345.78, ["Neon|Fly|Ride"] = 411.73, ["Mega"] = 511.88, ["Mega|Ride"] = 513.68, ["Mega|Fly|Ride"] = 865.13}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 23.33, ["Ride"] = 16.97, ["Fly|Ride"] = 32.82, ["Neon"] = 14.43, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 57.28, ["Mega"] = 121.96, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.64, ["Fly"] = 54.78, ["Ride"] = 35.44, ["Fly|Ride"] = 93.45, ["Neon"] = 45.94, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 103.91, ["Mega"] = 353.77, ["Mega|Fly"] = 441.21, ["Mega|Ride"] = 262.29, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.21, ["Ride"] = 18.38, ["Fly|Ride"] = 68.61, ["Neon"] = 8.05, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 36.18, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 12.49, ["Fly"] = 162.99, ["Ride"] = 32.44, ["Fly|Ride"] = 217.2, ["Neon"] = 39.86, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 323.11, ["Mega|Ride"] = 404.46, ["Mega|Fly|Ride"] = 490.24}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.66, ["Ride"] = 51.89, ["Fly|Ride"] = 170.63, ["Neon"] = 45.94, ["Neon|Ride"] = 73.5, ["Mega"] = 236.25, ["Mega|Ride"] = 302.56, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.51, ["Fly"] = 47.08, ["Ride"] = 19.08, ["Fly|Ride"] = 56.49, ["Neon"] = 27, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 38.67, ["Neon|Fly|Ride"] = 144.19, ["Mega"] = 232.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 242.82}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.07, ["Ride"] = 15.49, ["Fly|Ride"] = 52.56, ["Neon"] = 19.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 84.29, ["Mega"] = 164.01, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 216.57, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 431.13, ["Neon"] = 1282.57, ["Neon|Ride"] = 1282.57, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4249.03, ["Mega|Fly|Ride"] = 4035.68}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.84, ["Ride"] = 105, ["Neon"] = 36.83, ["Neon|Ride"] = 144.8, ["Mega"] = 119.69, ["Mega|Ride"] = 654.46, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.68, ["Fly"] = 108.07, ["Ride"] = 24.94, ["Fly|Ride"] = 86.36, ["Neon"] = 24.94, ["Neon|Fly"] = 245.28, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 147.07, ["Mega"] = 243.87, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.74, ["Fly|Ride"] = 720.78, ["Neon"] = 47.25, ["Neon|Ride"] = 195.56, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 166.42, ["Mega|Ride"] = 408.54, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 14.44, ["Fly|Ride"] = 31.19, ["Neon"] = 2.1, ["Neon|Fly"] = 21.62, ["Neon|Ride"] = 15.41, ["Neon|Fly|Ride"] = 37.37, ["Mega"] = 26.97, ["Mega|Fly"] = 81.05, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.18}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.97, ["Fly"] = 45.44, ["Ride"] = 21.04, ["Fly|Ride"] = 68.25, ["Neon"] = 13.02, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 150.82, ["Mega|Ride"] = 210.72, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.82, ["Ride"] = 119.85, ["Neon"] = 10.5, ["Neon|Ride"] = 288.18, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.22, ["Mega|Ride"] = 165.55, ["Mega|Fly|Ride"] = 280.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 78.75, ["Fly"] = 72.18, ["Ride"] = 91.67, ["Fly|Ride"] = 137.82, ["Neon"] = 315, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 484.42, ["Mega|Ride"] = 3603.48, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.34, ["Fly"] = 72.42, ["Ride"] = 28.88, ["Fly|Ride"] = 71.32, ["Neon"] = 21.31, ["Neon|Ride"] = 69.56, ["Mega"] = 169.3, ["Mega|Ride"] = 213.45, ["Mega|Fly|Ride"] = 363.76}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.72, ["Ride"] = 43.23, ["Neon"] = 7.22, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 550.19, ["Mega"] = 56.35, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.62, ["Fly"] = 118.13, ["Ride"] = 86.35, ["Fly|Ride"] = 172.6, ["Neon"] = 143.06, ["Neon|Ride"] = 172.73, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 511.88, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 898.46}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 12.84, ["Fly|Ride"] = 33.51, ["Neon"] = 2.1, ["Neon|Fly"] = 22.3, ["Neon|Ride"] = 15.83, ["Neon|Fly|Ride"] = 38.06, ["Mega"] = 16.7, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 33.87, ["Mega|Fly|Ride"] = 53.23}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 97.28, ["Neon"] = 2.1, ["Neon|Ride"] = 30.98, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 26.25, ["Mega|Fly"] = 144.66, ["Mega|Ride"] = 84.36, ["Mega|Fly|Ride"] = 190.35}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Fly"] = 33.51, ["Ride"] = 55.12, ["Fly|Ride"] = 161.34, ["Neon"] = 10.4, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 42, ["Mega|Fly"] = 188.02, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 270.18}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.5, ["Fly"] = 65.01, ["Ride"] = 43.31, ["Fly|Ride"] = 144.66, ["Neon"] = 18.96, ["Neon|Fly"] = 101.58, ["Neon|Ride"] = 141.67, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 106.55, ["Mega|Fly"] = 331.34, ["Mega|Ride"] = 169.03, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.79, ["Ride"] = 13.92, ["Fly|Ride"] = 43.23, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 23.56, ["Neon|Fly|Ride"] = 58.94, ["Mega"] = 19.28, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.41, ["Fly"] = 131.25, ["Ride"] = 53.82, ["Neon"] = 129.67, ["Neon|Ride"] = 202.08, ["Neon|Fly|Ride"] = 432.21, ["Mega"] = 360.55, ["Mega|Fly|Ride"] = 816.45}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2008.13, ["Fly"] = 3150, ["Ride"] = 2250.02, ["Fly|Ride"] = 2131.5, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44845.17}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 16.4, ["Fly|Ride"] = 48.57, ["Neon"] = 8.91, ["Neon|Fly"] = 71.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 76, ["Mega|Fly"] = 476.56, ["Mega|Ride"] = 93.85, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.11, ["Neon"] = 9.19, ["Mega"] = 101.72, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 490.24}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.68, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 157.5, ["Neon"] = 61.11, ["Neon|Fly"] = 102.67, ["Neon|Ride"] = 115.47, ["Neon|Fly|Ride"] = 277.07, ["Mega"] = 431.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 685.48}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.55, ["Fly"] = 108.15, ["Ride"] = 71.09, ["Neon"] = 150.94, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 327.24, ["Mega"] = 692.01, ["Mega|Ride"] = 690.45, ["Mega|Fly|Ride"] = 654.46}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 147.91, ["Fly"] = 1441.55, ["Ride"] = 185.24, ["Fly|Ride"] = 229.28, ["Neon"] = 647.07, ["Neon|Ride"] = 702.92, ["Neon|Fly|Ride"] = 652.32, ["Mega|Fly|Ride"] = 4170.76}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.09, ["Ride"] = 64.97, ["Fly|Ride"] = 43.19, ["Neon"] = 15.75, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 378.83}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Neon"] = 16.14, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.58, ["Ride"] = 27.85, ["Fly|Ride"] = 75.66, ["Neon"] = 7.13, ["Neon|Fly"] = 127.51, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 64.97, ["Mega|Ride"] = 113.02, ["Mega|Fly|Ride"] = 235.31}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 17.21, ["Ride"] = 70.03, ["Fly|Ride"] = 131.25, ["Neon"] = 129.94, ["Neon|Ride"] = 1229.04, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 273.77, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 571.6}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 2.61, ["Neon|Ride"] = 20.37, ["Mega"] = 26.25, ["Mega|Fly"] = 122.57, ["Mega|Ride"] = 83.58, ["Mega|Fly|Ride"] = 181.25}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.49, ["Fly"] = 202.08, ["Ride"] = 127.32, ["Fly|Ride"] = 150.94, ["Neon"] = 311.85, ["Neon|Fly"] = 379.28, ["Neon|Ride"] = 379.28, ["Neon|Fly|Ride"] = 388.58, ["Mega"] = 3241.84, ["Mega|Ride"] = 2483.25, ["Mega|Fly|Ride"] = 1348.52}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 45.4, ["Ride"] = 91.85, ["Neon"] = 11.45, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 63.41, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 105, ["Ride"] = 77.44, ["Fly|Ride"] = 170.63, ["Neon"] = 255.94, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1730.26}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.7, ["Ride"] = 21.57, ["Fly|Ride"] = 41.5, ["Neon"] = 3.82, ["Neon|Fly"] = 85.79, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 42, ["Mega|Fly"] = 146.41, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.52, ["Neon|Ride"] = 115.45, ["Mega"] = 53.82, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.66, ["Fly"] = 72.42, ["Ride"] = 39.38, ["Fly|Ride"] = 90.57, ["Neon"] = 19.08, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 141.74, ["Mega|Ride"] = 274.46, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 367.5, ["Fly"] = 499.25, ["Ride"] = 409.49, ["Fly|Ride"] = 498.75, ["Neon"] = 820.32, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1141.93, ["Mega"] = 3107.96, ["Mega|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.5, ["Fly"] = 64.32, ["Ride"] = 54.64, ["Fly|Ride"] = 86.21, ["Neon"] = 162.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1728.81, ["Mega|Fly|Ride"] = 1065.39}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 61.62, ["Ride"] = 32.81, ["Fly|Ride"] = 119.78, ["Neon"] = 24.08, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 79.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 117.1, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 23.63, ["Fly"] = 216.12, ["Ride"] = 57.62, ["Fly|Ride"] = 149.63, ["Neon"] = 77.44, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 137.36, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 301.88, ["Mega|Fly"] = 1008.66, ["Mega|Ride"] = 302.49, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 18.02, ["Ride"] = 23.38, ["Neon"] = 101.36, ["Neon|Ride"] = 122.4, ["Neon|Fly|Ride"] = 490.24, ["Mega"] = 654.46, ["Mega|Ride"] = 690.45, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Ride"] = 29.22, ["Neon"] = 18.41, ["Neon|Ride"] = 157.5, ["Mega"] = 91.88, ["Mega|Ride"] = 337.13}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 7.76, ["Fly"] = 72.42, ["Ride"] = 24.87, ["Fly|Ride"] = 62.97, ["Neon"] = 18.38, ["Neon|Fly"] = 94.01, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 249.38, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 89.25, ["Fly"] = 244.79, ["Ride"] = 120.9, ["Fly|Ride"] = 196.88, ["Neon"] = 486.65, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3264.07}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.94, ["Ride"] = 55.56, ["Fly|Ride"] = 144.63, ["Neon"] = 118.12, ["Neon|Ride"] = 172.7, ["Neon|Fly|Ride"] = 194.25, ["Mega"] = 510.57, ["Mega|Ride"] = 574.11, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1730.47, ["Fly"] = 2307.73, ["Ride"] = 1968.75, ["Fly|Ride"] = 1896.57, ["Neon"] = 11525.71, ["Neon|Fly|Ride"] = 6607.28, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.59, ["Fly"] = 131250, ["Ride"] = 68.25, ["Fly|Ride"] = 196.87, ["Neon"] = 19.47, ["Neon|Ride"] = 64.16, ["Mega"] = 142.96, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 215.03, ["Mega|Fly|Ride"] = 514.34}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.26, ["Fly"] = 72.42, ["Ride"] = 51.19, ["Fly|Ride"] = 149.13, ["Neon"] = 25.88, ["Neon|Ride"] = 86.84, ["Mega"] = 144.38, ["Mega|Ride"] = 283.82, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 861.86, ["Ride"] = 851.81, ["Fly|Ride"] = 1010.52, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2891.43, ["Mega|Ride"] = 13890.55, ["Mega|Fly|Ride"] = 15127.02}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.2, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 144.36, ["Neon|Ride"] = 187.85, ["Mega"] = 855.41, ["Mega|Ride"] = 863.43, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.01, ["Fly|Ride"] = 128.15, ["Neon"] = 10.97, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 215.03, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 144.8, ["Neon"] = 2.44, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 23.24, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 131.27}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.85, ["Ride"] = 124.24, ["Fly|Ride"] = 216.12, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2447.74, ["Mega|Fly|Ride"] = 2377.12}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.93, ["Ride"] = 36.75, ["Fly|Ride"] = 75.66, ["Neon"] = 19.38, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 90.57, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.06, ["Fly"] = 151.3, ["Ride"] = 102.1, ["Fly|Ride"] = 288.5, ["Neon"] = 647.07, ["Neon|Ride"] = 721.88, ["Mega"] = 1512.9, ["Mega|Fly|Ride"] = 1767.27}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.21, ["Fly"] = 105, ["Fly|Ride"] = 129.67, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 318.77}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Fly"] = 284.82, ["Ride"] = 301.87, ["Fly|Ride"] = 262.5, ["Neon"] = 1148.82, ["Neon|Ride"] = 1148.34, ["Neon|Fly|Ride"] = 879.37, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.78, ["Fly"] = 65.63, ["Ride"] = 24.82, ["Fly|Ride"] = 115.4, ["Neon"] = 33.48, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 115.22, ["Mega"] = 337.04, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 6.37, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 21.97, ["Neon|Fly|Ride"] = 57.18, ["Mega"] = 42, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1350.63, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7925.18, ["Neon|Fly|Ride"] = 7023.27, ["Mega"] = 24477.35, ["Mega|Fly|Ride"] = 23051.4}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 16.17, ["Ride"] = 77.58, ["Fly|Ride"] = 202.08, ["Neon"] = 93.71, ["Neon|Ride"] = 314.98, ["Mega"] = 379.32, ["Mega|Ride"] = 449.18, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.92, ["Fly"] = 48.3, ["Ride"] = 29.16, ["Fly|Ride"] = 59.07, ["Neon"] = 23.71, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 119.95, ["Mega"] = 419.9, ["Mega|Ride"] = 162.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.93, ["Fly"] = 33.44, ["Ride"] = 41.09, ["Fly|Ride"] = 74.72, ["Neon"] = 182.97, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 189.09, ["Mega"] = 2593.46, ["Mega|Ride"] = 1143.1, ["Mega|Fly|Ride"] = 696.55}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.86, ["Fly"] = 70.16, ["Ride"] = 31.5, ["Fly|Ride"] = 72.19, ["Neon"] = 59.07, ["Neon|Ride"] = 74.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 432.76}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 76.13, ["Ride"] = 157.5, ["Fly|Ride"] = 644, ["Neon"] = 395.48, ["Neon|Fly"] = 577, ["Neon|Ride"] = 503.95, ["Neon|Fly|Ride"] = 720.7, ["Mega"] = 1960.92, ["Mega|Ride"] = 1078.35, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 54.71, ["Neon|Ride"] = 103.14, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 18.31, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 101.07, ["Fly"] = 133.68, ["Ride"] = 135.14, ["Fly|Ride"] = 163.68, ["Neon"] = 432.57, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 621.91, ["Neon|Fly|Ride"] = 647.22, ["Mega"] = 2158.49, ["Mega|Fly|Ride"] = 2118.39}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.03, ["Fly"] = 144.38, ["Ride"] = 39.38, ["Fly|Ride"] = 67.36, ["Neon"] = 222.84, ["Neon|Ride"] = 72.19, ["Mega"] = 773.71, ["Mega|Ride"] = 412.79, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.62, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 13.13, ["Neon|Fly"] = 82.01, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 118, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 105, ["Neon|Fly"] = 142.48, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 81.37, ["Fly"] = 247.55, ["Ride"] = 223.13, ["Fly|Ride"] = 414.2, ["Neon"] = 363.35, ["Neon|Ride"] = 577, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2016.31, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.63, ["Fly|Ride"] = 432.21, ["Neon"] = 20.41, ["Neon|Ride"] = 59.07, ["Mega"] = 139.49, ["Mega|Ride"] = 157.77, ["Mega|Fly|Ride"] = 327.24}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Ride"] = 101.58, ["Mega"] = 18.11, ["Mega|Ride"] = 216.12, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 20.98, ["Fly|Ride"] = 144.64, ["Neon"] = 3.93, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 26.25, ["Mega"] = 19.71, ["Mega|Ride"] = 38.75, ["Mega|Fly|Ride"] = 132.6}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.3, ["Fly|Ride"] = 52.47, ["Neon"] = 5.79, ["Neon|Ride"] = 33.03, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 114.18}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.49, ["Neon"] = 27.57, ["Mega"] = 118.13, ["Mega|Ride"] = 129.67, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.36, ["Ride"] = 15.65, ["Fly|Ride"] = 38.41, ["Neon"] = 16.45, ["Neon|Fly"] = 86.46, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 223.13, ["Mega|Ride"] = 101.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 55.01, ["Ride"] = 148.88, ["Neon"] = 229.66, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 629.9, ["Mega"] = 643.13, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 860.09}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.36, ["Fly|Ride"] = 43.18, ["Neon"] = 3.94, ["Neon|Fly"] = 32.68, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 44.88, ["Mega"] = 144.94, ["Mega|Fly"] = 72.42, ["Mega|Ride"] = 159.96, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.76, ["Fly"] = 31.29, ["Ride"] = 36.78, ["Fly|Ride"] = 71.8, ["Neon"] = 36.75, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 66.9, ["Neon|Fly|Ride"] = 132.23, ["Mega"] = 301.88, ["Mega|Fly"] = 577.06, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 313.04}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 22.32, ["Fly"] = 58.97, ["Ride"] = 52.5, ["Fly|Ride"] = 117.6, ["Neon"] = 104.9, ["Neon|Ride"] = 129.55, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 1296.61, ["Mega|Ride"] = 864.41, ["Mega|Fly|Ride"] = 662.82}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.54, ["Fly"] = 29.19, ["Ride"] = 47.53, ["Fly|Ride"] = 67.01, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Mega"] = 549.94, ["Mega|Ride"] = 699.68, ["Mega|Fly|Ride"] = 717.47}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.24, ["Ride"] = 17.3, ["Fly|Ride"] = 31.83, ["Neon"] = 3.94, ["Neon|Fly"] = 28.17, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 69.65, ["Mega"] = 36.75, ["Mega|Fly"] = 89.25, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 10.4, ["Ride"] = 32.82, ["Neon"] = 78.75, ["Neon|Ride"] = 140.47, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 328.13, ["Mega|Fly"] = 534.86, ["Mega|Ride"] = 513.85, ["Mega|Fly|Ride"] = 569.44}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 912.19, ["Fly"] = 1389.81, ["Ride"] = 918.75, ["Fly|Ride"] = 1030.32, ["Neon"] = 2491.13, ["Neon|Fly"] = 2916.27, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2445.14, ["Mega|Fly|Ride"] = 8137.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 181.13, ["Ride"] = 304.37, ["Fly|Ride"] = 590.63, ["Neon"] = 656.25, ["Neon|Ride"] = 900.8, ["Neon|Fly|Ride"] = 1035.14, ["Mega"] = 3459.41, ["Mega|Ride"] = 3746.11, ["Mega|Fly|Ride"] = 3500.83}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 3.94, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 258.26, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 1152.9}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 129.94, ["Ride"] = 196.77, ["Fly|Ride"] = 360.91, ["Neon"] = 654.94, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 721.88, ["Mega|Ride"] = 2564.63, ["Mega|Fly|Ride"] = 1916.25}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.86, ["Fly"] = 41.08, ["Ride"] = 20.55, ["Fly|Ride"] = 93.92, ["Neon"] = 16.25, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 288.5, ["Mega"] = 115.96, ["Mega|Ride"] = 172.9, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 234.93, ["Fly"] = 432.21, ["Ride"] = 314.99, ["Fly|Ride"] = 423.94, ["Neon"] = 1446.19, ["Neon|Ride"] = 1469.5, ["Neon|Fly|Ride"] = 1404.67, ["Mega|Fly|Ride"] = 4901.05}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.2, ["Fly"] = 77.18, ["Ride"] = 19.69, ["Fly|Ride"] = 225.5, ["Neon"] = 33.45, ["Neon|Ride"] = 51.19, ["Mega"] = 393.74, ["Mega|Fly"] = 361.98, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.19, ["Ride"] = 26.25, ["Neon"] = 45.94, ["Neon|Ride"] = 53.93, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 25.15, ["Fly"] = 52.5, ["Ride"] = 68.12, ["Fly|Ride"] = 142.88, ["Neon"] = 111.46, ["Neon|Fly"] = 431.72, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 839.27, ["Mega|Ride"] = 595.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.62, ["Neon|Ride"] = 196.88, ["Mega"] = 245.13, ["Mega|Ride"] = 257.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.07, ["Ride"] = 15.12, ["Fly|Ride"] = 39.26, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 51.35, ["Mega"] = 25.01, ["Mega|Ride"] = 49.72, ["Mega|Fly|Ride"] = 92.94}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5474.91, ["Ride"] = 4462.5, ["Fly|Ride"] = 4559.5, ["Neon"] = 32418.2, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 5.49, ["Fly"] = 86.45, ["Ride"] = 41.47, ["Neon"] = 86.33, ["Neon|Fly"] = 384.7, ["Neon|Ride"] = 106.31, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 429.65}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 19.69, ["Fly|Ride"] = 45.92, ["Neon"] = 15.62, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 82.02, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 215.21}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 461.97, ["Fly"] = 547.78, ["Ride"] = 497.6, ["Fly|Ride"] = 570.94, ["Neon"] = 1635.89, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.57, ["Ride"] = 49.03, ["Neon"] = 21.19, ["Neon|Ride"] = 291.38, ["Mega"] = 144.8, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.49, ["Fly"] = 145.69, ["Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 49.72, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 432.21, ["Mega|Ride"] = 401.62}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 19.76, ["Fly|Ride"] = 65.62, ["Neon"] = 2.34, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 56.44, ["Mega|Ride"] = 90.86, ["Mega|Fly|Ride"] = 238.81}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.49, ["Fly"] = 879.54, ["Ride"] = 767.69, ["Fly|Ride"] = 762.3, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8500.32}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.99, ["Ride"] = 85.31, ["Fly|Ride"] = 312.54, ["Neon"] = 39.38, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 179.66, ["Mega"] = 200.82, ["Mega|Fly"] = 432.21, ["Mega|Ride"] = 288.24, ["Mega|Fly|Ride"] = 399.44}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.16, ["Fly"] = 106.2, ["Ride"] = 38.19, ["Fly|Ride"] = 129.67, ["Neon"] = 24.5, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 169.32, ["Mega|Fly"] = 817.34, ["Mega|Ride"] = 185.15, ["Mega|Fly|Ride"] = 327.24}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 33.68, ["Ride"] = 16.42, ["Fly|Ride"] = 42.3, ["Neon"] = 13.02, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.69, ["Neon|Fly|Ride"] = 83.81, ["Mega"] = 165.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 239.77}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 23.63, ["Fly"] = 39.38, ["Ride"] = 41.08, ["Fly|Ride"] = 65.63, ["Neon"] = 118.13, ["Neon|Ride"] = 114.18, ["Mega"] = 864.49, ["Mega|Ride"] = 612.8, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 81.95, ["Neon"] = 4.66, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.72, ["Mega|Fly"] = 147.08, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 549.94, ["Fly"] = 677.49, ["Ride"] = 649.3, ["Fly|Ride"] = 682.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 2794.19, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9559.4, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 4.31, ["Ride"] = 101.58, ["Fly|Ride"] = 262.5, ["Neon"] = 13.02, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 431.74, ["Mega"] = 52.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 318.66}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 49.69, ["Neon"] = 3.72, ["Neon|Fly"] = 288.5, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.88, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 6.49, ["Neon|Ride"] = 39.51, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 61.53, ["Mega|Fly"] = 159.93, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Mega"] = 236.64, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 27.44, ["Fly"] = 72.19, ["Ride"] = 60.53, ["Fly|Ride"] = 214.49, ["Neon"] = 103.93, ["Neon|Ride"] = 130.77, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 418.83, ["Mega|Ride"] = 523.18, ["Mega|Fly|Ride"] = 575.63}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 12.29, ["Ride"] = 52.63, ["Fly|Ride"] = 155.17, ["Neon"] = 87.4, ["Neon|Ride"] = 112.1, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 551.15, ["Mega|Ride"] = 561.21, ["Mega|Fly|Ride"] = 575.74}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.94, ["Ride"] = 16.96, ["Fly|Ride"] = 45.54, ["Neon"] = 51.24, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 299.92, ["Mega|Ride"] = 366.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.68, ["Ride"] = 78.74, ["Fly|Ride"] = 147.08, ["Neon"] = 59.07, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 109.5, ["Neon"] = 10.68, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 82.67, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 245.13}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.82, ["Fly"] = 26.25, ["Ride"] = 24.2, ["Fly|Ride"] = 55, ["Neon"] = 115.76, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 213.68, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 33.44, ["Fly"] = 874.13, ["Neon"] = 118.13, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 729.17}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 40.69, ["Fly"] = 86.63, ["Ride"] = 78.75, ["Fly|Ride"] = 144.65, ["Neon"] = 260.96, ["Neon|Ride"] = 324.44, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1960.92, ["Mega|Ride"] = 1404.76, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 36.66, ["Fly"] = 144.8, ["Ride"] = 63, ["Fly|Ride"] = 223.13, ["Neon"] = 125.87, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 215.91, ["Mega"] = 507.94, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 23.63, ["Ride"] = 41.08, ["Neon"] = 137, ["Neon|Ride"] = 223.13, ["Mega"] = 1050, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 819.37}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 34, ["Fly"] = 90.7, ["Ride"] = 62.98, ["Fly|Ride"] = 144.38, ["Neon"] = 196.88, ["Neon|Fly"] = 318.77, ["Neon|Ride"] = 218.68, ["Neon|Fly|Ride"] = 481.01, ["Mega"] = 721.74, ["Mega|Ride"] = 611.93, ["Mega|Fly|Ride"] = 735.35}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.96, ["Ride"] = 15.65, ["Fly|Ride"] = 32.81, ["Neon"] = 4.17, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 57.57, ["Mega"] = 49.13, ["Mega|Fly"] = 327.24, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1010.05}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 97.12, ["Ride"] = 146.45, ["Fly|Ride"] = 374.21, ["Neon"] = 499.97, ["Neon|Ride"] = 542.43, ["Neon|Fly|Ride"] = 754.2, ["Mega"] = 1632.75, ["Mega|Ride"] = 1615.21, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.07, ["Neon"] = 3.68, ["Neon|Fly"] = 101.58, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 302.56, ["Mega"] = 37.33, ["Mega|Ride"] = 88.26, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.19, ["Ride"] = 74.49, ["Fly|Ride"] = 216.12, ["Neon"] = 118.13, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 534.81, ["Mega|Fly|Ride"] = 653.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 22.32}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 2.24, ["Mega"] = 20.88, ["Mega|Ride"] = 101.42, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 88.73, ["Ride"] = 143.47, ["Fly|Ride"] = 229.68, ["Neon"] = 577.48, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 6739.44, ["Mega|Fly|Ride"] = 2077.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.62, ["Fly|Ride"] = 98.9, ["Neon"] = 6.48, ["Neon|Fly"] = 43.23, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.88, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.54, ["Fly|Ride"] = 65.63, ["Neon"] = 4.79, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 28.77, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.17, ["Ride"] = 71.58, ["Neon"] = 15.75, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 245.49, ["Mega"] = 108.86, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 12.63, ["Neon|Ride"] = 137.82, ["Mega"] = 103.95}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 99.04, ["Ride"] = 189, ["Fly|Ride"] = 360.91, ["Neon"] = 426.57, ["Neon|Ride"] = 611.86, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 2870.05}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.46, ["Neon"] = 91.87, ["Neon|Fly|Ride"] = 144.94, ["Mega"] = 418.06, ["Mega|Ride"] = 365.75, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.49, ["Ride"] = 427.23, ["Fly|Ride"] = 734.76, ["Neon"] = 1069.69, ["Neon|Ride"] = 1267.04, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 80.07}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 53.55}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.42}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 59.07}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.9}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.79}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 16.68}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.74}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.3}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 37.03}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 106.67}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 122.55}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 20.52}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 33.07}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.57}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 34.04}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 643.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 582.75}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.03}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1345.32}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.08}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 26.23}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 60.38}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 20.37}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.89}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.68}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.24}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 99.75}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.56}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3118.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 85.79}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 255.31}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.57}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 23.73}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 24.74}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 215.25}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 29.8}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 157.56}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 57.75}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 41.58}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.17}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 29.84}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.82}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 20.9}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.34}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.75}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 259.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.59}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.5}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 309.56}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.44}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 78.75}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.57}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24354.95}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.68}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 42.21}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 51.98}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.96}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.86}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.92}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 124.27}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.77}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 104.18}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 432.21}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.3}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 57.39}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 257.25}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 65.63}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.42}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.93}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 25.81}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 145.4}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.24}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 8.65}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 14.44}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.81}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.3}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.86}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.5}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 39.38}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.64}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.12}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 70.88}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.64}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.56}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 9.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.69}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.85}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.92}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.42}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.26}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.23}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 183.1}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.11}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 190.32}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 28.64}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 26.9}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 13.11}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.92}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 24.85}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.19}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 9.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.1}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 41.91}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 17.62}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.61}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 47.25}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 9.19}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.42}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7875}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 16.33}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.2}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 17.07}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.83}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.61}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.21}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.6}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.29}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 9.07}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 30.97}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.89}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 77.99}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.19}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.65}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.45}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.92}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.19}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.74}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 4.95}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.67}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 144187.35}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.21}},
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
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.97}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.71}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 6.98}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.79}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 102.38}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 10.87}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1312.49}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 72.19}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 30.19}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 36.65}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.75}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.58}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 17.36}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 19.68}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.2}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.29}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.81}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.8}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.31}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 34.98}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 8.44}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.45}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.45}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 79.94}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 17.73}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 5.22}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 412.92}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.68}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 13.95}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 26.16}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.87}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.84}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.89}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.08}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.6}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.73}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 126}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 161.44}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 12.08}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1017.18}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.84}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.74}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.14}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 3.69}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.86}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.37}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 49.9}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.98}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.57}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 63}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 108.25}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 49.21}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.59}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.85}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 12.47}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 114.18}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.22}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 84.9}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.26}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 54.34}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.82}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 90.3}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.14}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 15.68}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 5.4}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 41.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.45}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.2}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.34}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 16.07}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 32.48}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.07}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 35.34}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.87}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 29.58}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 144.8}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.88}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.2}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 31.92}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.45}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.88}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.51}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 17.92}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.07}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 15.27}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 281.22}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 70.88}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 42}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 6.48}},
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
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 85.32}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 976.5}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 182.34}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 5.92}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1659}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
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