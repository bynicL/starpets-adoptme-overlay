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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1190.88, ["Ride"] = 1050, ["Fly|Ride"] = 1512.54, ["Neon"] = 6825, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 5072.57, ["Mega"] = 21666.71, ["Mega|Fly|Ride"] = 21666.71}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 526.32, ["Ride"] = 479.78, ["Fly|Ride"] = 511.88, ["Neon|Fly|Ride"] = 1771.88, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 7713.37}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 5117.43, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 71645.31}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 183.75, ["Ride"] = 289.3, ["Fly|Ride"] = 319.01, ["Neon"] = 1145.94, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1103.82, ["Mega|Fly|Ride"] = 4790.63}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 866.88, ["Ride"] = 564.38, ["Fly|Ride"] = 555.08, ["Neon|Ride"] = 1841.68, ["Neon|Fly|Ride"] = 1922.69, ["Mega|Fly|Ride"] = 6069}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.46, ["Ride"] = 52.5, ["Fly|Ride"] = 129.94, ["Neon"] = 71.5, ["Neon|Fly"] = 289.3, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 325.02, ["Mega"] = 353.75, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 606.38}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 127.2, ["Ride"] = 27.46, ["Fly|Ride"] = 70.12, ["Neon"] = 33.23, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 64.1, ["Neon|Fly|Ride"] = 132.77, ["Mega"] = 236.25, ["Mega|Ride"] = 268.68, ["Mega|Fly|Ride"] = 419.27}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 123.37, ["Ride"] = 141.74, ["Neon"] = 576.42, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1443.02, ["Mega"] = 1586.82, ["Mega|Fly"] = 2023.68, ["Mega|Ride"] = 2166.69}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 28.2, ["Fly"] = 83.62, ["Ride"] = 41.73, ["Fly|Ride"] = 106.32, ["Neon"] = 275.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 318.29, ["Mega"] = 2100, ["Mega|Ride"] = 1206.84, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.57, ["Fly"] = 47.86, ["Ride"] = 39.04, ["Fly|Ride"] = 71.47, ["Neon|Ride"] = 164.43, ["Neon|Fly|Ride"] = 207.38, ["Mega|Ride"] = 780.07, ["Mega|Fly|Ride"] = 1126.68}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 75.93, ["Fly"] = 130.31, ["Ride"] = 102.77, ["Fly|Ride"] = 194.25, ["Neon"] = 341.84, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 482.3, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 67.32}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 314.9, ["Fly"] = 327.51, ["Ride"] = 349.13, ["Fly|Ride"] = 380.63, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 5142.61}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 166.88, ["Ride"] = 152.11, ["Fly|Ride"] = 157.9, ["Neon"] = 446.6, ["Neon|Fly"] = 722.69, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.62, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 24.92, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 359.86}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 199.48, ["Fly"] = 287.44, ["Ride"] = 203.69, ["Fly|Ride"] = 232.59, ["Neon|Ride"] = 975.01, ["Neon|Fly|Ride"] = 721.88, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.24, ["Fly"] = 26.82, ["Ride"] = 18.37, ["Fly|Ride"] = 49.86, ["Neon"] = 28.87, ["Neon|Fly"] = 82.23, ["Neon|Ride"] = 76.1, ["Neon|Fly|Ride"] = 105, ["Mega"] = 164.07, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 126.93, ["Fly"] = 289.33, ["Ride"] = 171.56, ["Fly|Ride"] = 286.78, ["Neon"] = 459.4, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 584.21, ["Mega"] = 1800.06, ["Mega|Ride"] = 1502.6, ["Mega|Fly|Ride"] = 1529.69}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.62}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 77.42, ["Ride"] = 232.32, ["Fly|Ride"] = 244.13, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2166.69, ["Mega|Fly|Ride"] = 1588.18}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 26.62, ["Fly"] = 58.52, ["Ride"] = 51.19, ["Fly|Ride"] = 433.13, ["Neon"] = 260.05, ["Neon|Ride"] = 319.74, ["Neon|Fly|Ride"] = 332.6, ["Mega"] = 578.51, ["Mega|Ride"] = 1011.85, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.66, ["Fly"] = 78.75, ["Ride"] = 45.94, ["Fly|Ride"] = 110.25, ["Neon"] = 231, ["Neon|Ride"] = 190.31, ["Neon|Fly|Ride"] = 276.94, ["Mega"] = 1717.86, ["Mega|Fly|Ride"] = 993.6}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.78, ["Fly"] = 244.63, ["Ride"] = 82.22, ["Fly|Ride"] = 196.88, ["Neon"] = 249.38, ["Neon|Ride"] = 289.27, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1354.19, ["Mega|Fly|Ride"] = 1557.86}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 29.11, ["Ride"] = 36.27, ["Fly|Ride"] = 101.87, ["Neon"] = 210, ["Neon|Ride"] = 210.27, ["Neon|Fly|Ride"] = 189, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.64, ["Fly"] = 145.21, ["Ride"] = 64.97, ["Fly|Ride"] = 129.94, ["Neon"] = 325.5, ["Neon|Fly"] = 409.85, ["Neon|Ride"] = 361.04, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1146.06, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.97, ["Fly"] = 33.92, ["Ride"] = 24.85, ["Fly|Ride"] = 70.8, ["Neon"] = 45.85, ["Neon|Fly"] = 191.83, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 162.41, ["Mega|Fly"] = 28925.07, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 391, ["Ride"] = 416.07, ["Fly|Ride"] = 452.82, ["Neon|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 9735.27}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.76, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Neon|Fly|Ride"] = 280.88, ["Mega|Ride"] = 823.35, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.12, ["Fly"] = 65.03, ["Ride"] = 23.36, ["Fly|Ride"] = 50.16, ["Neon"] = 62.99, ["Neon|Ride"] = 71.9, ["Neon|Fly|Ride"] = 130.81, ["Mega"] = 324.05, ["Mega|Ride"] = 361.85, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.3, ["Fly"] = 120.16, ["Ride"] = 106.32, ["Fly|Ride"] = 131.84, ["Neon"] = 343.42, ["Neon|Ride"] = 354.26, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 6502.05, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.34, ["Fly"] = 26.25, ["Ride"] = 36.65, ["Fly|Ride"] = 72.44, ["Neon"] = 124.61, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 720.57, ["Mega|Ride"] = 573.04}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 216.56, ["Fly"] = 288.75, ["Ride"] = 240.38, ["Fly|Ride"] = 315, ["Neon"] = 578.59, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 736.23, ["Mega"] = 3465.6, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3190.29}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.6}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.7, ["Fly"] = 37.94, ["Ride"] = 22.31, ["Fly|Ride"] = 72.19, ["Neon"] = 24.92, ["Neon|Fly"] = 145.2, ["Neon|Ride"] = 52.2, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 196.88, ["Mega|Fly"] = 346.68, ["Mega|Ride"] = 302.27, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 900.45, ["Fly"] = 2625, ["Ride"] = 919, ["Fly|Ride"] = 918.75, ["Neon"] = 6500.8, ["Neon|Ride"] = 4911.85, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Ride"] = 55216.37, ["Mega|Fly|Ride"] = 17998.1}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.12, ["Fly"] = 54.01, ["Ride"] = 51.94, ["Fly|Ride"] = 80.18, ["Neon"] = 184.21, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 1036.88, ["Mega|Ride"] = 1112.6, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 242.87, ["Fly"] = 368.11, ["Ride"] = 236.9, ["Fly|Ride"] = 327.59, ["Neon"] = 830.82, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1030.3, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.75}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.89, ["Fly"] = 130.05, ["Ride"] = 72.59, ["Fly|Ride"] = 145.2, ["Neon"] = 65.62, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 361.85, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 607.4}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.44, ["Fly"] = 160.61, ["Ride"] = 145.2, ["Fly|Ride"] = 219.19, ["Neon"] = 515.31, ["Neon|Ride"] = 483.18, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2403.77}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.58, ["Fly"] = 157.5, ["Ride"] = 146.99, ["Fly|Ride"] = 232.32, ["Neon"] = 389.46, ["Neon|Fly"] = 578.59, ["Neon|Ride"] = 426.27, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1430.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.82, ["Fly"] = 97.35, ["Ride"] = 58.95, ["Fly|Ride"] = 71.31, ["Neon|Ride"] = 505.56, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 4333.35, ["Mega|Fly|Ride"] = 1350.28}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.16, ["Fly"] = 101.88, ["Ride"] = 45.94, ["Fly|Ride"] = 157.5, ["Neon"] = 41.24, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 127.85, ["Neon|Fly|Ride"] = 243.77, ["Mega"] = 189, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 361.85}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 568.32, ["Fly"] = 715.19, ["Ride"] = 509.15, ["Fly|Ride"] = 553.3, ["Neon|Fly"] = 3900.49, ["Neon|Ride"] = 1876.88, ["Neon|Fly|Ride"] = 1868.66, ["Mega|Ride"] = 15166.71, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 116.66, ["Fly"] = 188.97, ["Ride"] = 131.25, ["Fly|Ride"] = 196.87, ["Neon"] = 420, ["Neon|Ride"] = 506.63, ["Neon|Fly|Ride"] = 721.51, ["Mega|Ride"] = 2600.03, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3806.25, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 15165.63}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 50.67, ["Fly"] = 131.25, ["Ride"] = 85.31, ["Fly|Ride"] = 188.62, ["Neon"] = 341.25, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 2166.69, ["Mega|Ride"] = 2016.1, ["Mega|Fly|Ride"] = 1866.38}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Ride"] = 70.88, ["Fly|Ride"] = 147, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 6355.94, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2304.9}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.7, ["Fly"] = 64.37, ["Ride"] = 44.56, ["Fly|Ride"] = 96.47, ["Neon"] = 170.63, ["Neon|Fly"] = 289.3, ["Neon|Ride"] = 140.89, ["Neon|Fly|Ride"] = 211.3, ["Mega"] = 2625, ["Mega|Ride"] = 900.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.18}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 57.75, ["Fly"] = 393.75, ["Ride"] = 53.82, ["Fly|Ride"] = 98.17, ["Neon|Ride"] = 289.27, ["Neon|Fly|Ride"] = 606.68, ["Mega|Ride"] = 1309.25, ["Mega|Fly|Ride"] = 1368.26}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.8}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 188.56, ["Ride"] = 236.25, ["Fly|Ride"] = 282.19, ["Neon"] = 1156.07, ["Neon|Ride"] = 1154.85, ["Neon|Fly|Ride"] = 1152.68, ["Mega|Fly|Ride"] = 5153.55}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.24, ["Fly"] = 823.55, ["Ride"] = 643.13, ["Fly|Ride"] = 630, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 4188.19, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.35, ["Fly"] = 56.26, ["Ride"] = 35.65, ["Fly|Ride"] = 69.18, ["Neon"] = 246.75, ["Neon|Fly"] = 343.54, ["Neon|Ride"] = 190.96, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 2166.69, ["Mega|Ride"] = 1177.46, ["Mega|Fly|Ride"] = 767.81}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 6499.71, ["Fly|Ride"] = 5055.75, ["Neon|Ride"] = 17998.1, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 44173.11}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.87, ["Fly"] = 55.13, ["Ride"] = 25.12, ["Fly|Ride"] = 57.84, ["Neon"] = 76.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 151.69, ["Mega"] = 496.79, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 464.38}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.78, ["Fly"] = 141.96, ["Ride"] = 43.32, ["Fly|Ride"] = 121.48, ["Neon"] = 127.86, ["Neon|Ride"] = 130.03, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 722.6, ["Mega|Ride"] = 864.52, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 75.36, ["Ride"] = 72.6, ["Fly|Ride"] = 85.3, ["Neon|Ride"] = 401.93, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4333.35, ["Mega|Fly|Ride"] = 1800.06}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 8.84, ["Fly"] = 72.61, ["Ride"] = 36.65, ["Fly|Ride"] = 78.75, ["Neon"] = 89.25, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 505.93, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 1950.47, ["Ride"] = 1851.93, ["Fly|Ride"] = 1627.5, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34674.89, ["Ride"] = 33950.34, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 49.44, ["Fly"] = 393.75, ["Ride"] = 59.06, ["Fly|Ride"] = 130.04, ["Neon"] = 250.81, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 578.51, ["Mega"] = 648.94, ["Mega|Ride"] = 1305.94, ["Mega|Fly|Ride"] = 1300.02}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.56, ["Fly"] = 129.83, ["Ride"] = 35.73, ["Fly|Ride"] = 164.07, ["Neon"] = 25.45, ["Neon|Fly"] = 145.15, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 183.87, ["Mega"] = 194.25, ["Mega|Fly"] = 405.19, ["Mega|Ride"] = 228.37, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.82}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.23, ["Ride"] = 49.88, ["Fly|Ride"] = 105, ["Neon"] = 78.53, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 361.85, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 767.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.25, ["Fly"] = 916.59, ["Ride"] = 712.59, ["Fly|Ride"] = 819, ["Neon"] = 3108.97, ["Neon|Ride"] = 2860.03, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11453.11}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 917.34, ["Fly"] = 1076.15, ["Ride"] = 1052.63, ["Fly|Ride"] = 918.75, ["Neon"] = 4189.77, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11616.3}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13, ["Fly"] = 122.72, ["Ride"] = 29.5, ["Fly|Ride"] = 93.19, ["Neon"] = 84.92, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 152.17, ["Mega"] = 496.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.73}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.75, ["Fly"] = 89.25, ["Ride"] = 85.31, ["Fly|Ride"] = 131.15, ["Neon"] = 578.59, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 399, ["Mega"] = 19687.5, ["Mega|Ride"] = 2023.68, ["Mega|Fly|Ride"] = 2162.35}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 102.37, ["Ride"] = 91.88, ["Fly|Ride"] = 173.37, ["Neon"] = 425.75, ["Neon|Ride"] = 411.09, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1437.02, ["Mega|Ride"] = 1950.01, ["Mega|Fly|Ride"] = 1963.26}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.77, ["Fly"] = 31.43, ["Ride"] = 23.02, ["Fly|Ride"] = 52.32, ["Neon"] = 41.73, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 99.68, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 319.6, ["Mega|Fly|Ride"] = 427.93}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 150.34, ["Fly"] = 183.75, ["Ride"] = 172.01, ["Fly|Ride"] = 240.61, ["Neon"] = 865.7, ["Neon|Fly"] = 699.85, ["Neon|Ride"] = 648.37, ["Neon|Fly|Ride"] = 649.68, ["Mega"] = 5200.02, ["Mega|Ride"] = 2944.89, ["Mega|Fly|Ride"] = 2622.36}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.57, ["Ride"] = 46.43, ["Fly|Ride"] = 220.5, ["Neon"] = 43.32, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 235.66, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 16.21, ["Fly"] = 65.63, ["Ride"] = 35.35, ["Fly|Ride"] = 91.03, ["Neon"] = 120.75, ["Neon|Ride"] = 152.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 655.25, ["Mega|Ride"] = 838.52, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.8, ["Ride"] = 68.25, ["Fly|Ride"] = 156.19, ["Neon"] = 214.48, ["Neon|Ride"] = 282.19, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.65, ["Fly"] = 58.52, ["Ride"] = 36.85, ["Fly|Ride"] = 75.22, ["Neon"] = 82.22, ["Neon|Ride"] = 127.85, ["Neon|Fly|Ride"] = 278.25, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6744.94, ["Ride"] = 5341.88, ["Fly|Ride"] = 5374.69, ["Neon"] = 36116.18, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 28889.32, ["Mega|Fly|Ride"] = 91618.68}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 249.38, ["Fly"] = 262.5, ["Ride"] = 246.32, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 637.87, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 55.65, ["Fly"] = 157.86, ["Ride"] = 88.51, ["Fly|Ride"] = 183.54, ["Neon"] = 170.62, ["Neon|Ride"] = 207.9, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 521.07, ["Mega|Ride"] = 588.96, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.6, ["Fly"] = 90.81, ["Ride"] = 21.19, ["Fly|Ride"] = 81.37, ["Neon"] = 26.25, ["Neon|Fly"] = 86.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 50.94, ["Fly"] = 213.18, ["Ride"] = 129.13, ["Fly|Ride"] = 157.49, ["Neon"] = 210, ["Neon|Ride"] = 248.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 487.89, ["Mega|Ride"] = 534.18, ["Mega|Fly|Ride"] = 818.44}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16611, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.56, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 115556.13}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 287.44, ["Ride"] = 406.88, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1586.01, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 7362.2}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 68.28, ["Fly"] = 80.59, ["Ride"] = 62.35, ["Fly|Ride"] = 113.17, ["Neon"] = 368.08, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 328.02, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.05, ["Ride"] = 24.94, ["Fly|Ride"] = 58.47, ["Neon"] = 66.78, ["Neon|Fly"] = 327.59, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 130.03, ["Mega"] = 421.32, ["Mega|Ride"] = 563.34, ["Mega|Fly|Ride"] = 504.86}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 369.31, ["Fly"] = 866.88, ["Ride"] = 433.12, ["Fly|Ride"] = 551.25, ["Neon"] = 1683.72, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.26, ["Ride"] = 41.95, ["Fly|Ride"] = 199.5, ["Neon"] = 33.6, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 225.36, ["Mega"] = 158.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 106.82, ["Fly"] = 167.92, ["Ride"] = 118.13, ["Fly|Ride"] = 193.76, ["Neon"] = 578.59, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 522.38, ["Mega|Ride"] = 2398.52, ["Mega|Fly|Ride"] = 2223.88}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.54, ["Fly"] = 21.39, ["Ride"] = 19.09, ["Fly|Ride"] = 35.15, ["Neon"] = 115.95, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 108.7, ["Mega"] = 2600.03, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.87}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 66.35, ["Ride"] = 87.94, ["Fly|Ride"] = 319.64, ["Neon"] = 287.11, ["Neon|Fly"] = 432.32, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 430.5, ["Mega"] = 1589.27, ["Mega|Ride"] = 2021.52, ["Mega|Fly|Ride"] = 1661.86}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.82, ["Fly"] = 80.07, ["Ride"] = 35.93, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 210, ["Mega"] = 583.93, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 655.25}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.66}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 51.98, ["Fly"] = 145.21, ["Ride"] = 118.11, ["Fly|Ride"] = 131.25, ["Neon"] = 315.4, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 433.35, ["Mega|Fly|Ride"] = 1722.52}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.74, ["Ride"] = 29.23, ["Fly|Ride"] = 137.82, ["Neon"] = 26.66, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 260.02, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.31, ["Fly"] = 56.44, ["Ride"] = 33.15, ["Fly|Ride"] = 106.2, ["Neon"] = 82.22, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 209.23, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 540.6}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 541.82, ["Ride"] = 529.01, ["Fly|Ride"] = 552.12, ["Neon|Fly|Ride"] = 2815.61, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.45, ["Fly"] = 108.38, ["Ride"] = 52.41, ["Fly|Ride"] = 86.69, ["Neon"] = 129.94, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 344.52, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.4, ["Fly"] = 144.46, ["Ride"] = 72.19, ["Fly|Ride"] = 144.27, ["Neon"] = 145.2, ["Neon|Ride"] = 161.72, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.41, ["Fly"] = 91.88, ["Ride"] = 58.95, ["Fly|Ride"] = 110.23, ["Neon"] = 97.34, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 438.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 516.79, ["Mega|Fly|Ride"] = 585.02}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8186.07, ["Neon|Fly|Ride"] = 14259, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1506.75, ["Fly"] = 1501.85, ["Ride"] = 1481.29, ["Fly|Ride"] = 1443.63, ["Neon|Fly|Ride"] = 4452.63, ["Mega|Fly|Ride"] = 24555.97}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 630.69, ["Ride"] = 785.23, ["Fly|Ride"] = 721.66, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21666.71, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.43, ["Fly"] = 25.74, ["Ride"] = 23.89, ["Fly|Ride"] = 49.38, ["Neon"] = 136.5, ["Neon|Ride"] = 92.05, ["Neon|Fly|Ride"] = 130.03, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.18, ["Fly"] = 52.5, ["Ride"] = 33.6, ["Fly|Ride"] = 131.25, ["Neon"] = 25.31, ["Neon|Ride"] = 56.11, ["Mega"] = 215.6, ["Mega|Ride"] = 200.42, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.13, ["Fly"] = 85.32, ["Ride"] = 48.2, ["Fly|Ride"] = 106.38, ["Neon"] = 551.86, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 175.67, ["Mega|Fly|Ride"] = 655.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.66, ["Fly"] = 23.5, ["Ride"] = 13.13, ["Fly|Ride"] = 41.94, ["Neon"] = 29.54, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 319.6, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 306.51, ["Fly"] = 376.02, ["Ride"] = 310.92, ["Fly|Ride"] = 353.07, ["Neon"] = 1128.75, ["Neon|Ride"] = 1460.34, ["Neon|Fly|Ride"] = 1214.78, ["Mega|Fly|Ride"] = 4336.5}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.31, ["Fly"] = 60.6, ["Ride"] = 42, ["Fly|Ride"] = 90.8, ["Neon"] = 131.25, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 174.5, ["Neon|Fly|Ride"] = 223.18, ["Mega"] = 866.69, ["Mega|Fly"] = 916.61, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 655.25}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.12, ["Fly"] = 22.92, ["Ride"] = 21.51, ["Fly|Ride"] = 48.38, ["Neon"] = 84.52, ["Neon|Fly"] = 122.45, ["Neon|Ride"] = 82.23, ["Neon|Fly|Ride"] = 110.76, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 545.06, ["Fly"] = 1048.69, ["Ride"] = 578.59, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3612.94, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1445.52, ["Ride"] = 1214.07, ["Fly|Ride"] = 1181.24, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13432.29}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 101.07, ["Fly"] = 145.21, ["Ride"] = 90.57, ["Fly|Ride"] = 107.34, ["Neon"] = 971.25, ["Neon|Ride"] = 578.51, ["Neon|Fly|Ride"] = 487.51, ["Mega|Fly|Ride"] = 2855.31}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 200.82, ["Fly"] = 210, ["Ride"] = 216.46, ["Fly|Ride"] = 210, ["Neon"] = 1011.96, ["Neon|Ride"] = 578.51, ["Neon|Fly|Ride"] = 722.6, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.25, ["Fly"] = 58.52, ["Ride"] = 52.4, ["Fly|Ride"] = 115.95, ["Neon"] = 254.62, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 2166.69, ["Mega|Fly|Ride"] = 1098.21}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 431.16, ["Fly|Ride"] = 433.4, ["Neon"] = 1220.63, ["Neon|Fly"] = 981.52, ["Neon|Fly|Ride"] = 1300.02, ["Mega|Fly|Ride"] = 5778.52}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2456.51, ["Ride"] = 1962.19, ["Fly|Ride"] = 2029.07, ["Neon|Fly|Ride"] = 10833.36, ["Mega|Fly|Ride"] = 36810.92}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 37.77, ["Fly"] = 216.74, ["Ride"] = 49.88, ["Fly|Ride"] = 196.88, ["Neon"] = 216.7, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 1445.18, ["Mega|Ride"] = 1155.94, ["Mega|Fly|Ride"] = 1259.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.23, ["Fly"] = 743.36, ["Ride"] = 637.75, ["Fly|Ride"] = 660.95, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1283.63, ["Mega|Fly|Ride"] = 3600.12}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.32, ["Fly"] = 72.19, ["Ride"] = 64.07, ["Fly|Ride"] = 91.85, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 1083.35, ["Mega|Fly|Ride"] = 1146.06}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.5, ["Fly"] = 40.78, ["Ride"] = 21.67, ["Fly|Ride"] = 64.29, ["Neon"] = 25.98, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 100.73, ["Mega"] = 179.82, ["Mega|Ride"] = 187.28, ["Mega|Fly|Ride"] = 299.83}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 61.69, ["Ride"] = 131.29, ["Fly|Ride"] = 157.5, ["Neon"] = 275.52, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 1586.01, ["Mega|Ride"] = 1733.36, ["Mega|Fly|Ride"] = 1719.27}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 935.74, ["Ride"] = 969.94, ["Fly|Ride"] = 975.79, ["Neon|Ride"] = 3313, ["Neon|Fly|Ride"] = 3064.69, ["Mega|Fly|Ride"] = 13284.96}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 689.07, ["Ride"] = 809.82, ["Fly|Ride"] = 956.99, ["Neon|Fly|Ride"] = 4332.27, ["Mega|Fly|Ride"] = 15743.04}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.42, ["Fly"] = 25.22, ["Ride"] = 23.78, ["Fly|Ride"] = 37.4, ["Neon"] = 144.38, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 795.18, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 15.3, ["Ride"] = 36.75, ["Fly|Ride"] = 120.27, ["Neon"] = 165.38, ["Neon|Ride"] = 148.66, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1011.85, ["Mega|Ride"] = 981.51, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.02, ["Fly"] = 59.2, ["Ride"] = 55.8, ["Fly|Ride"] = 216.7, ["Neon"] = 23.24, ["Neon|Fly"] = 326.17, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 231.95, ["Mega"] = 196.88, ["Mega|Fly"] = 573.04, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 44.01, ["Fly"] = 51.97, ["Ride"] = 51.17, ["Fly|Ride"] = 115.86, ["Neon"] = 319.64, ["Neon|Ride"] = 162.59, ["Neon|Fly|Ride"] = 240.38, ["Mega|Ride"] = 903.52, ["Mega|Fly|Ride"] = 979.13}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 83.91, ["Ride"] = 145.2, ["Fly|Ride"] = 808.21, ["Neon"] = 413.44, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2455.93, ["Mega|Ride"] = 2166.69, ["Mega|Fly|Ride"] = 2528.51}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.81, ["Fly"] = 52.41, ["Ride"] = 36.66, ["Fly|Ride"] = 73.49, ["Neon"] = 72.6, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 429.7, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 515.82}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 37.77, ["Fly"] = 52.5, ["Ride"] = 44.58, ["Fly|Ride"] = 111.57, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 236.71, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.24, ["Fly"] = 37.97, ["Ride"] = 17.85, ["Fly|Ride"] = 45.62, ["Neon"] = 29.94, ["Neon|Ride"] = 60.8, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 289.27, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.77, ["Fly"] = 53.82, ["Ride"] = 45.84, ["Fly|Ride"] = 88.92, ["Neon"] = 52.41, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 231.84, ["Mega"] = 416.07, ["Mega|Ride"] = 441.75, ["Mega|Fly|Ride"] = 535.49}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 37.21, ["Fly"] = 71.46, ["Ride"] = 33.78, ["Fly|Ride"] = 102.26, ["Neon"] = 578.44, ["Neon|Ride"] = 332.6, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1367.63, ["Ride"] = 1367.63, ["Fly|Ride"] = 1400.44, ["Neon|Ride"] = 4766.69, ["Neon|Fly|Ride"] = 3621.19, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 467.76, ["Fly"] = 524.99, ["Ride"] = 525, ["Fly|Ride"] = 509.23, ["Neon|Ride"] = 3755.94, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15166.71}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 259.88, ["Fly"] = 378.23, ["Ride"] = 325.5, ["Fly|Ride"] = 452.82, ["Neon"] = 1575, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7222.61}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.45, ["Ride"] = 52.87, ["Fly|Ride"] = 99.74, ["Neon"] = 325.5, ["Neon|Fly"] = 433.4, ["Neon|Ride"] = 198.8, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1191.68, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 27089.76, ["Ride"] = 36806.85, ["Fly|Ride"] = 18797.7, ["Neon|Fly|Ride"] = 38061.19, ["Mega"] = 216667.04, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 232.34, ["Fly"] = 284.44, ["Ride"] = 245.34, ["Fly|Ride"] = 334.59, ["Neon"] = 1039.98, ["Neon|Ride"] = 981.64, ["Neon|Fly|Ride"] = 931.55, ["Mega"] = 6500.03, ["Mega|Fly|Ride"] = 4115.61}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 177.19, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 164.73, ["Fly"] = 157.5, ["Ride"] = 144.37, ["Fly|Ride"] = 174.84, ["Neon"] = 590.63, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 548.81, ["Mega|Ride"] = 3612.94, ["Mega|Fly|Ride"] = 3031.19}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.1, ["Fly"] = 65.03, ["Ride"] = 31.44, ["Fly|Ride"] = 85.61, ["Neon"] = 164.42, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 231.84, ["Mega"] = 733.79, ["Mega|Ride"] = 607.4, ["Mega|Fly|Ride"] = 975.01}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4840.41, ["Ride"] = 3937.5, ["Fly|Ride"] = 4068.75, ["Neon"] = 21669.27, ["Neon|Fly|Ride"] = 15750, ["Mega"] = 73621.82, ["Mega|Fly|Ride"] = 81802.44}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.97, ["Fly"] = 41.98, ["Ride"] = 34.04, ["Fly|Ride"] = 60.38, ["Neon"] = 131.25, ["Neon|Ride"] = 215.6, ["Neon|Fly|Ride"] = 173.13, ["Mega|Ride"] = 1445.18, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.68, ["Ride"] = 51.17, ["Fly|Ride"] = 106.2, ["Neon"] = 170.63, ["Neon|Fly"] = 1445.35, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1408.32}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 472.41, ["Fly"] = 563.06, ["Ride"] = 448.88, ["Fly|Ride"] = 524.99, ["Neon"] = 1312.5, ["Neon|Ride"] = 1226.91, ["Neon|Fly|Ride"] = 1391.25, ["Mega"] = 4908.14, ["Mega|Fly|Ride"] = 5388.53}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.15, ["Fly"] = 28.76, ["Ride"] = 24.05, ["Fly|Ride"] = 38.98, ["Neon"] = 131.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.4, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 582.24}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.26, ["Ride"] = 34.54, ["Fly|Ride"] = 84.52, ["Neon"] = 129.94, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 211.21, ["Mega"] = 573.04, ["Mega|Ride"] = 760.77, ["Mega|Fly|Ride"] = 578.51}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.84, ["Ride"] = 124.69, ["Fly|Ride"] = 245.44, ["Neon"] = 736.15, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 1576.26, ["Mega|Fly|Ride"] = 2454.08}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.45, ["Fly"] = 103.69, ["Ride"] = 72.6, ["Fly|Ride"] = 169.84, ["Neon"] = 71.98, ["Neon|Fly"] = 120.27, ["Neon|Ride"] = 162.51, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 393.75, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 488.92}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4264.21, ["Fly"] = 6315.37, ["Ride"] = 4264.32, ["Fly|Ride"] = 3937.5, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10421.25, ["Mega"] = 49111.93, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Fly"] = 145.21, ["Ride"] = 65.54, ["Fly|Ride"] = 86.69, ["Neon"] = 164.07, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 866.69, ["Mega|Ride"] = 865.6, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6300, ["Fly"] = 7693.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 6496.88, ["Neon|Fly|Ride"] = 14445.21, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.35, ["Fly"] = 22.29, ["Ride"] = 17.14, ["Fly|Ride"] = 39.37, ["Neon"] = 24.94, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 196.88, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 262.61}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.25, ["Fly"] = 36.83, ["Ride"] = 39.96, ["Fly|Ride"] = 65.02, ["Neon"] = 188.53, ["Neon|Fly"] = 239.46, ["Neon|Ride"] = 505.93, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 998.17, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.19}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.22, ["Ride"] = 31.4, ["Fly|Ride"] = 87.02, ["Neon"] = 78.62, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 1050, ["Mega|Ride"] = 1081.18, ["Mega|Fly|Ride"] = 813.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.3, ["Fly"] = 190.37, ["Ride"] = 72.6, ["Fly|Ride"] = 173.37, ["Neon"] = 145.2, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 160.35, ["Mega"] = 945, ["Mega|Ride"] = 866.69, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.73, ["Fly"] = 28.88, ["Ride"] = 20.97, ["Fly|Ride"] = 41.9, ["Neon|Fly"] = 1080.22, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2600.03, ["Mega|Ride"] = 427.93, ["Mega|Fly|Ride"] = 606.68}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8813.94}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2625}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 18.79}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 243.18, ["Ride"] = 397.65, ["Fly|Ride"] = 315}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 16.13, ["Fly"] = 145.21, ["Ride"] = 31.5, ["Fly|Ride"] = 145.2, ["Neon"] = 118.34, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 444.19, ["Mega|Ride"] = 541.14, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.34, ["Ride"] = 25.46, ["Fly|Ride"] = 86.69, ["Neon|Ride"] = 249.38, ["Mega"] = 1589.27}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 170.63, ["Fly"] = 433.46, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1011.94, ["Neon|Ride"] = 981.64, ["Neon|Fly|Ride"] = 788.69, ["Mega|Ride"] = 4189.27, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 60.37, ["Fly"] = 196.88, ["Ride"] = 101.88, ["Fly|Ride"] = 525, ["Neon"] = 315, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 722.6, ["Mega|Ride"] = 1945.69, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.3, ["Fly"] = 276.33, ["Ride"] = 183.75, ["Fly|Ride"] = 253.41, ["Neon"] = 944.99, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 822.07, ["Mega|Fly|Ride"] = 3501.89}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2488.5, ["Fly"] = 3126.41, ["Ride"] = 2455.69, ["Fly|Ride"] = 2730, ["Neon"] = 15218.34, ["Neon|Ride"] = 9816.26, ["Neon|Fly|Ride"] = 8017.66, ["Mega|Fly|Ride"] = 27445.23}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 21.39, ["Fly"] = 106.21, ["Ride"] = 54.11, ["Fly|Ride"] = 115.95, ["Neon"] = 126.04, ["Neon|Fly"] = 164.42, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 973.93, ["Mega|Ride"] = 1011.85, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 866.24, ["Fly"] = 2100, ["Ride"] = 1083.48, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4332.27}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.38}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.28, ["Ride"] = 55.28, ["Fly|Ride"] = 75.86, ["Neon"] = 91.88, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 167.94, ["Mega"] = 440.49, ["Mega|Fly"] = 981.64, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 700.87}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.76, ["Fly"] = 49.06, ["Ride"] = 28.85, ["Fly|Ride"] = 128.62, ["Neon"] = 65.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 458.92, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 578.51}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.97}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 16.95, ["Ride"] = 32.82, ["Fly|Ride"] = 101.87, ["Neon|Ride"] = 196.33, ["Neon|Fly|Ride"] = 245.93, ["Mega|Ride"] = 1083.35, ["Mega|Fly|Ride"] = 2166.69}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 30.21, ["Fly"] = 45.94, ["Ride"] = 42, ["Fly|Ride"] = 70.88, ["Neon|Fly"] = 239.46, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 1445.18, ["Mega|Ride"] = 1840.57, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6562.5, ["Fly"] = 10237.5, ["Ride"] = 6499.71, ["Fly|Ride"] = 5053.13, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.11, ["Fly"] = 63, ["Ride"] = 34.04, ["Fly|Ride"] = 81.38, ["Neon"] = 55.11, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 190.44, ["Mega"] = 354.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.89}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 84.2, ["Fly"] = 383.61, ["Ride"] = 125.99, ["Fly|Ride"] = 196.88, ["Neon"] = 374.07, ["Neon|Ride"] = 484.81, ["Neon|Fly|Ride"] = 535.48, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2706.19}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.97, ["Fly"] = 189.02, ["Ride"] = 80.27, ["Fly|Ride"] = 190.32, ["Neon"] = 288.33, ["Neon|Ride"] = 319.6, ["Neon|Fly|Ride"] = 457.94, ["Mega"] = 2454.08, ["Mega|Ride"] = 1155.94, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 25.95, ["Fly"] = 72.18, ["Ride"] = 31.5, ["Fly|Ride"] = 76.01, ["Neon"] = 131.29, ["Neon|Fly"] = 234.01, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 1016.21, ["Mega|Ride"] = 818.44, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.15, ["Fly"] = 77.07, ["Ride"] = 27.22, ["Fly|Ride"] = 112.59, ["Neon"] = 26.23, ["Neon|Ride"] = 82.68, ["Neon|Fly|Ride"] = 162.3, ["Mega"] = 164.06, ["Mega|Fly"] = 7226.76, ["Mega|Ride"] = 221.8, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.29, ["Fly"] = 145.21, ["Ride"] = 27.27, ["Fly|Ride"] = 98.06, ["Neon"] = 123.98, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 433.35, ["Mega|Ride"] = 655.25, ["Mega|Fly|Ride"] = 686.85}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.68, ["Fly"] = 28.4, ["Ride"] = 26.17, ["Fly|Ride"] = 55.38, ["Neon"] = 127.86, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 115.92, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.87}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.67, ["Ride"] = 131.25, ["Fly|Ride"] = 289.3, ["Neon"] = 170.62, ["Neon|Ride"] = 214.52, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 110.55, ["Ride"] = 1445.35, ["Neon|Fly|Ride"] = 28889.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 81.72, ["Fly"] = 216.74, ["Ride"] = 88.33, ["Fly|Ride"] = 202.13, ["Neon"] = 275.63, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1098.53, ["Mega|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 1259.88}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1049.99, ["Fly"] = 1378.13, ["Ride"] = 1039.5, ["Fly|Ride"] = 1049.99, ["Neon|Fly"] = 4449.96, ["Neon|Ride"] = 4391.86, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 337.84, ["Fly"] = 722.77, ["Ride"] = 413.32, ["Fly|Ride"] = 433.4, ["Neon"] = 2388.75, ["Neon|Ride"] = 3178.52, ["Neon|Fly|Ride"] = 1994.99, ["Mega"] = 13000.04, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 58.49}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.5, ["Fly"] = 31.49, ["Ride"] = 25.41, ["Fly|Ride"] = 58.52, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 81.26, ["Neon|Fly|Ride"] = 137.75, ["Mega"] = 437.26, ["Mega|Ride"] = 722.6, ["Mega|Fly|Ride"] = 570.93}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 212.39, ["Fly"] = 509.24, ["Ride"] = 288.64, ["Fly|Ride"] = 397.8, ["Neon"] = 965.48, ["Neon|Ride"] = 859.69, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3110.69}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.01}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 120.57, ["Ride"] = 164.42, ["Fly|Ride"] = 301.88, ["Neon"] = 572.98, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 577.49, ["Neon|Fly|Ride"] = 654.83, ["Mega"] = 2600.03, ["Mega|Ride"] = 2455.93, ["Mega|Fly|Ride"] = 2266.79}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.12, ["Fly"] = 216.74, ["Ride"] = 143.72, ["Fly|Ride"] = 196.88, ["Neon"] = 650.09, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 866.69, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.77, ["Fly"] = 80.2, ["Ride"] = 26.25, ["Fly|Ride"] = 176.61, ["Neon"] = 36.63, ["Neon|Ride"] = 69.35, ["Neon|Fly|Ride"] = 250.22, ["Mega"] = 216.68, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 377.02}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.11, ["Fly"] = 72.61, ["Ride"] = 28.88, ["Fly|Ride"] = 90.57, ["Neon"] = 177.18, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 173.35, ["Mega|Ride"] = 1445.18, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.53, ["Fly"] = 102.36, ["Ride"] = 34.06, ["Fly|Ride"] = 117, ["Neon"] = 72.19, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 361.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 578.51}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.45, ["Fly"] = 131.24, ["Ride"] = 52.41, ["Fly|Ride"] = 152.15, ["Neon"] = 24.57, ["Neon|Ride"] = 75.1, ["Neon|Fly|Ride"] = 182.94, ["Mega"] = 168.92, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 271.68, ["Ride"] = 290.04, ["Fly|Ride"] = 344.75, ["Neon"] = 1445.35, ["Neon|Ride"] = 1408.64, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6500.03}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 97.54, ["Fly"] = 157.5, ["Ride"] = 144.27, ["Fly|Ride"] = 282.19, ["Neon"] = 420, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 605.9, ["Mega"] = 2311.85, ["Mega|Fly|Ride"] = 1829.46}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 64.22, ["Fly"] = 97.54, ["Ride"] = 81.31, ["Fly|Ride"] = 115.95, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1800.06, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.99, ["Ride"] = 72.6, ["Fly|Ride"] = 289.3, ["Neon|Ride"] = 623.35, ["Neon|Fly|Ride"] = 505.93, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13, ["Fly"] = 77.97, ["Ride"] = 29.88, ["Fly|Ride"] = 93.18, ["Neon"] = 94.5, ["Neon|Fly"] = 145.2, ["Neon|Ride"] = 123.52, ["Neon|Fly|Ride"] = 126, ["Mega"] = 431.82, ["Mega|Fly"] = 525, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 785.32}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.62, ["Fly"] = 39.38, ["Ride"] = 21.41, ["Fly|Ride"] = 69.57, ["Neon"] = 18.39, ["Neon|Fly"] = 78.03, ["Neon|Ride"] = 52.78, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 166.69, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 271.95}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 839.9, ["Fly"] = 1128.85, ["Ride"] = 910.58, ["Fly|Ride"] = 999.83, ["Neon"] = 4333.87, ["Neon|Fly"] = 3331.04, ["Neon|Ride"] = 3435.7, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 282.17, ["Fly"] = 405.28, ["Ride"] = 302.75, ["Fly|Ride"] = 360.6, ["Neon"] = 1300.18, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 4766.69}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.87, ["Fly"] = 173.39, ["Ride"] = 103.37, ["Fly|Ride"] = 186.51, ["Neon"] = 422.63, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1312.5, ["Mega|Ride"] = 1748.52, ["Mega|Fly|Ride"] = 1878.52}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 178.24, ["Fly"] = 283.5, ["Ride"] = 190.98, ["Fly|Ride"] = 221.37, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 870.19, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 5026.69}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.62, ["Fly"] = 43.36, ["Ride"] = 29.87, ["Fly|Ride"] = 86.63, ["Neon"] = 169.32, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 736.68, ["Mega|Fly|Ride"] = 952.27}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 257.35, ["Ride"] = 322.69, ["Fly|Ride"] = 360.94, ["Neon"] = 895.32, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4314.35, ["Mega|Fly|Ride"] = 4247.22}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.43, ["Fly"] = 125.99, ["Ride"] = 90.45, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 578.51, ["Neon|Fly|Ride"] = 433.35, ["Mega|Fly|Ride"] = 1589.27}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2659.14, ["Ride"] = 2453.24, ["Fly|Ride"] = 2471.03, ["Neon|Ride"] = 8666.69, ["Neon|Fly|Ride"] = 7583.37, ["Mega"] = 52000.1, ["Mega|Fly|Ride"] = 26693.39}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.82, ["Fly"] = 78.04, ["Ride"] = 31.49, ["Fly|Ride"] = 91.88, ["Neon"] = 53.23, ["Neon|Fly"] = 105, ["Neon|Ride"] = 76.07, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 230.74, ["Mega|Fly"] = 578.51, ["Mega|Ride"] = 319.6, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 65.63, ["Ride"] = 66.24, ["Fly|Ride"] = 210, ["Neon"] = 196.88, ["Neon|Ride"] = 216.68, ["Neon|Fly|Ride"] = 477.31, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1391.48}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 91.25, ["Fly"] = 91.88, ["Ride"] = 82.42, ["Fly|Ride"] = 101.07, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.79, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1636.84, ["Ride"] = 1069.69, ["Fly|Ride"] = 1179.94, ["Neon|Ride"] = 5726.57, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 37556.01, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 578.66, ["Fly"] = 864.72, ["Ride"] = 576.65, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11555.96}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 71.73, ["Fly"] = 327.63, ["Ride"] = 86.69, ["Fly|Ride"] = 209.72, ["Neon"] = 341.25, ["Neon|Ride"] = 342.57, ["Neon|Fly|Ride"] = 541.92, ["Mega"] = 2166.69, ["Mega|Ride"] = 2618.49, ["Mega|Fly|Ride"] = 1660.39}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.5, ["Fly"] = 32.82, ["Ride"] = 24.93, ["Fly|Ride"] = 86.73, ["Neon"] = 86.63, ["Neon|Ride"] = 86.85, ["Neon|Fly|Ride"] = 164.43, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.11, ["Fly"] = 62.67, ["Ride"] = 43.35, ["Fly|Ride"] = 62.99, ["Neon"] = 284.82, ["Neon|Fly"] = 361.9, ["Neon|Ride"] = 281.69, ["Neon|Fly|Ride"] = 346.68, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1128.85, ["Ride"] = 840, ["Fly|Ride"] = 866.25, ["Neon"] = 2600.33, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.43, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 592.43}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6609.91, ["Ride"] = 7223.47, ["Fly|Ride"] = 5315.63, ["Neon"] = 42000, ["Neon|Ride"] = 31049.48, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 83438.07}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.5, ["Fly"] = 406.35, ["Ride"] = 341.25, ["Fly|Ride"] = 426.97, ["Neon"] = 1312.5, ["Neon|Ride"] = 1878.52, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6498.95, ["Mega|Ride"] = 6211.86, ["Mega|Fly|Ride"] = 6211.86}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.34, ["Ride"] = 147.82, ["Fly|Ride"] = 336, ["Neon"] = 1137.66, ["Neon|Ride"] = 505.93, ["Neon|Fly|Ride"] = 485.63}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 19.16, ["Fly"] = 101.87, ["Ride"] = 32.16, ["Fly|Ride"] = 91.77, ["Neon"] = 186.38, ["Neon|Ride"] = 129.82, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 795.18, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.46, ["Fly"] = 28.86, ["Ride"] = 24.82, ["Fly|Ride"] = 57.68, ["Neon"] = 146.5, ["Neon|Ride"] = 327.63, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2166.69}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.72, ["Ride"] = 25.98, ["Fly|Ride"] = 103.69, ["Neon"] = 118.12, ["Neon|Ride"] = 122.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 635.93}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.65, ["Fly"] = 63.95, ["Ride"] = 21.65, ["Fly|Ride"] = 48.57, ["Neon"] = 33.23, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 127.85, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 204.27}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.7, ["Fly"] = 90.57, ["Ride"] = 47.25, ["Fly|Ride"] = 147, ["Neon"] = 145.2, ["Neon|Fly"] = 866.69, ["Neon|Ride"] = 234.01, ["Neon|Fly|Ride"] = 344.52, ["Mega"] = 630, ["Mega|Ride"] = 722.6}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 504.95, ["Fly"] = 538.13, ["Ride"] = 551.24, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1589.27, ["Neon|Fly|Ride"] = 1548.75, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 6000.75}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.15, ["Fly"] = 19.59, ["Ride"] = 15.77, ["Fly|Ride"] = 35.44, ["Neon"] = 24.52, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 76.89, ["Mega"] = 170.63, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 51.18, ["Fly"] = 116.45, ["Ride"] = 74.81, ["Fly|Ride"] = 149.35, ["Neon"] = 229.27, ["Neon|Fly"] = 449.66, ["Neon|Ride"] = 228.35, ["Neon|Fly|Ride"] = 285.75, ["Mega"] = 523.69, ["Mega|Fly"] = 866.69, ["Mega|Ride"] = 557.81, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 823.29, ["Fly"] = 982.83, ["Ride"] = 721.87, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2482.3, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.72, ["Fly"] = 69.96, ["Ride"] = 44.54, ["Fly|Ride"] = 89.24, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 188.88, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 864.87}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 272.45, ["Fly"] = 433.46, ["Ride"] = 287.42, ["Fly|Ride"] = 314.95, ["Neon"] = 1625.21, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 3755.94}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 170.63, ["Fly"] = 368.11, ["Ride"] = 262.49, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 1098.53, ["Neon|Fly|Ride"] = 771.83, ["Mega"] = 4329.02, ["Mega|Fly|Ride"] = 3683.35}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 954.65, ["Ride"] = 709.47, ["Fly|Ride"] = 911.23, ["Neon|Ride"] = 3860.26, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10543.03}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.17, ["Fly"] = 62.86, ["Ride"] = 43.32, ["Fly|Ride"] = 121.48, ["Neon"] = 59.5, ["Neon|Fly"] = 294.47, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 173.35, ["Mega"] = 354.38, ["Mega|Ride"] = 346.68, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4047.22, ["Fly"] = 3508.32, ["Ride"] = 3281.25, ["Fly|Ride"] = 3157.88, ["Neon|Fly|Ride"] = 7481.25, ["Mega|Fly|Ride"] = 18873.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 131.24, ["Fly"] = 164.07, ["Ride"] = 150.94, ["Fly|Ride"] = 208.69, ["Neon"] = 535.5, ["Neon|Fly"] = 662.54, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 3105.94, ["Mega|Fly|Ride"] = 3219.68}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 18.77, ["Fly|Ride"] = 52.02, ["Neon"] = 25.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 241.6}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.57, ["Fly"] = 30.19, ["Ride"] = 27.98, ["Fly|Ride"] = 59.07, ["Neon"] = 22.43, ["Neon|Fly"] = 120.26, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 216.68, ["Mega|Ride"] = 257.84, ["Mega|Fly|Ride"] = 473.82}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 29.8, ["Fly"] = 38.07, ["Ride"] = 38.07, ["Fly|Ride"] = 48.86, ["Neon"] = 294.47, ["Neon|Ride"] = 319.05, ["Neon|Fly|Ride"] = 245.93, ["Mega|Fly|Ride"] = 1152.68}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 787.5, ["Fly"] = 1276.09, ["Ride"] = 892.5, ["Fly|Ride"] = 1038.18, ["Neon"] = 4186.52, ["Neon|Ride"] = 4582.97, ["Neon|Fly|Ride"] = 4828.38}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7809.38, ["Fly|Ride"] = 7875}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.89, ["Fly"] = 34.69, ["Ride"] = 24.15, ["Fly|Ride"] = 50.36, ["Neon"] = 452.13, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 123.4, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.12, ["Fly"] = 42.96, ["Ride"] = 29.29, ["Fly|Ride"] = 84.45, ["Neon"] = 91.88, ["Neon|Fly"] = 177.71, ["Neon|Ride"] = 81.26, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 668.87, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 92.82, ["Fly"] = 157.5, ["Ride"] = 112.46, ["Fly|Ride"] = 196.23, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 539.09, ["Mega|Fly|Ride"] = 2061.43}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 194.91, ["Fly"] = 266.58, ["Ride"] = 242.79, ["Fly|Ride"] = 315, ["Neon"] = 917.7, ["Neon|Ride"] = 998.82, ["Neon|Fly|Ride"] = 1028.99, ["Mega"] = 10833.36, ["Mega|Fly"] = 4092.17, ["Mega|Fly|Ride"] = 4582.97}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.51, ["Ride"] = 38.19, ["Fly|Ride"] = 71.53, ["Neon"] = 20.69, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 67.18, ["Neon|Fly|Ride"] = 327.63, ["Mega"] = 225.74, ["Mega|Fly"] = 241.6, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.5, ["Fly"] = 231.71, ["Ride"] = 195.56, ["Fly|Ride"] = 291.37, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.43, ["Fly|Ride"] = 40.69, ["Neon"] = 23.55, ["Neon|Fly"] = 125.7, ["Neon|Ride"] = 43.91, ["Neon|Fly|Ride"] = 118.39, ["Mega"] = 217.88, ["Mega|Ride"] = 187.03, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 353.27, ["Ride"] = 262.5, ["Fly|Ride"] = 307.43, ["Neon|Ride"] = 1309.2, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 4617.19}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.31, ["Fly"] = 104.98, ["Ride"] = 28.58, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 311.64, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 578.51, ["Mega|Ride"] = 563.34, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.22, ["Fly|Ride"] = 51.19, ["Neon"] = 7.5, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 78.14, ["Mega|Ride"] = 136.12, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.41, ["Neon"] = 3.61, ["Mega"] = 22.95, ["Mega|Ride"] = 145.19, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 35.07, ["Fly|Ride"] = 115.47, ["Neon"] = 6.57, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 62.14, ["Mega|Fly"] = 163604.85, ["Mega|Ride"] = 88.35, ["Mega|Fly|Ride"] = 289.27}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 62.99, ["Fly"] = 102.65, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 282.19, ["Neon|Fly"] = 332.64, ["Neon|Ride"] = 286.44, ["Neon|Fly|Ride"] = 391.11, ["Mega|Fly|Ride"] = 1504.27}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 17.05, ["Fly|Ride"] = 83.73, ["Neon"] = 6.57, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.88, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.06, ["Neon"] = 70.02, ["Neon|Fly"] = 311.64, ["Neon|Ride"] = 212.52, ["Mega"] = 261.19, ["Mega|Ride"] = 559.02, ["Mega|Fly|Ride"] = 613.17}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 43.36, ["Neon"] = 2.1, ["Neon|Ride"] = 55.81, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 16.59, ["Mega|Ride"] = 65.02, ["Mega|Fly|Ride"] = 209.73}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 72.34, ["Ride"] = 16.1, ["Fly|Ride"] = 49.86, ["Neon"] = 2.1, ["Neon|Fly"] = 39.43, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 36.74, ["Mega"] = 13.39, ["Mega|Fly"] = 35.8, ["Mega|Ride"] = 25.99, ["Mega|Fly|Ride"] = 58.26}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 14.81, ["Fly|Ride"] = 81.04, ["Neon"] = 5.25, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 34.68, ["Mega|Fly"] = 164.43, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 87.93}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 91.02, ["Mega"] = 17.06, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.98, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 2.9, ["Neon|Fly"] = 123.56, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 90.95, ["Mega"] = 38.1, ["Mega|Fly"] = 101.85, ["Mega|Ride"] = 38.19, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 79.63, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 33.91, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.28, ["Fly"] = 77.43, ["Ride"] = 35.44, ["Fly|Ride"] = 173.37, ["Neon"] = 28.77, ["Neon|Fly"] = 122.22, ["Neon|Ride"] = 51.1, ["Neon|Fly|Ride"] = 146.94, ["Mega"] = 159.41, ["Mega|Fly"] = 401.06, ["Mega|Ride"] = 166.83, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 326.91, ["Mega"] = 15.64, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 115.97, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 146.29, ["Fly|Ride"] = 145.2, ["Neon"] = 18.4, ["Mega"] = 111.56, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 17.05, ["Mega"] = 127.32, ["Mega|Ride"] = 160.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.94, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 22.32, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 14.34, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 29.46, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 38.05, ["Mega"] = 13.47, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.1, ["Neon"] = 36.75, ["Neon|Ride"] = 72.6, ["Mega"] = 202.59, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.17, ["Mega|Ride"] = 44.55, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.58, ["Neon"] = 16.13, ["Mega"] = 84.45, ["Mega|Ride"] = 167.9, ["Mega|Fly|Ride"] = 245.93}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 28.87, ["Neon"] = 16.26, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 130.03, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.54, ["Fly|Ride"] = 31.48, ["Neon"] = 2.1, ["Neon|Fly"] = 15.49, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 31.2, ["Mega"] = 16, ["Mega|Fly"] = 30.87, ["Mega|Ride"] = 24.31, ["Mega|Fly|Ride"] = 45.64}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.56, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 164.43}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 24.55, ["Fly|Ride"] = 59.07, ["Neon"] = 58.68, ["Neon|Ride"] = 71.46, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 291.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 14.41, ["Fly|Ride"] = 42.95, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 20.78, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 104.97}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 180.98, ["Ride"] = 45.91, ["Neon"] = 5.25, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 71.52, ["Mega|Fly"] = 173.35, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 216.81}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.8, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 368.12, ["Mega"] = 28.25, ["Mega|Fly"] = 114.58, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 175.52}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 33.14, ["Ride"] = 27.56, ["Neon"] = 2.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 16.01, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 43.35, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.86, ["Ride"] = 18.38, ["Fly|Ride"] = 49.52, ["Neon"] = 3.75, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 32.06, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 86.71, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.59, ["Neon"] = 4.27, ["Neon|Ride"] = 72.6, ["Mega"] = 45.94, ["Mega|Fly"] = 327.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 16.21, ["Fly|Ride"] = 43.37, ["Neon"] = 3.93, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 25.74, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 114.19, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 73.64, ["Mega|Fly|Ride"] = 152.78}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 37.03, ["Neon"] = 28.14, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 325.02, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.35, ["Fly|Ride"] = 47.23, ["Neon"] = 5.25, ["Neon|Fly"] = 49.09, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 115.36, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.2, ["Fly|Ride"] = 64.75, ["Neon"] = 12.92, ["Neon|Fly"] = 68.27, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 210.23, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.87, ["Ride"] = 72.65, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 255.29, ["Mega|Ride"] = 320.69}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 3.93, ["Ride"] = 85.32, ["Neon"] = 131.25, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 674.93, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 655.25}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 55.85, ["Neon"] = 44.61, ["Neon|Ride"] = 108.32, ["Mega"] = 238.88, ["Mega|Ride"] = 361.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.67, ["Ride"] = 37.68, ["Fly|Ride"] = 120.75, ["Neon"] = 43.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 127.28, ["Mega"] = 278.92, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 29.27, ["Neon"] = 3.52, ["Neon|Ride"] = 65.03, ["Mega"] = 17.72, ["Mega|Fly"] = 124.6, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 231.95}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.49, ["Fly"] = 23.13, ["Ride"] = 23.6, ["Fly|Ride"] = 51.37, ["Neon"] = 38.07, ["Neon|Fly"] = 189, ["Neon|Ride"] = 61.94, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 361.85, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.31, ["Fly|Ride"] = 86.63, ["Neon"] = 3.35, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 24.94, ["Mega|Fly"] = 145.19, ["Mega|Ride"] = 58.51, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.49, ["Neon"] = 5.15, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 30.55, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 44.71, ["Ride"] = 16.27, ["Fly|Ride"] = 44.8, ["Neon"] = 10.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.49, ["Mega"] = 108.39, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 171.71}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Fly"] = 43.36, ["Ride"] = 21.73, ["Fly|Ride"] = 69.57, ["Neon"] = 41.99, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 328.13, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 323.93}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 2.1, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 315, ["Mega"] = 20.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.7, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.49, ["Ride"] = 17.15, ["Fly|Ride"] = 58.7, ["Neon"] = 2.1, ["Neon|Fly"] = 114.9, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 98.01, ["Mega"] = 31.07, ["Mega|Fly"] = 145.19, ["Mega|Ride"] = 38.98, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 29.04, ["Ride"] = 17.72, ["Fly|Ride"] = 43.36, ["Neon"] = 3.13, ["Neon|Fly"] = 52.58, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.11, ["Mega"] = 84, ["Mega|Fly"] = 145.19, ["Mega|Ride"] = 103.03, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 55.28, ["Fly|Ride"] = 145.2, ["Neon"] = 6.33, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 77.63, ["Mega|Ride"] = 128.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 158040.26, ["Mega"] = 16.59, ["Mega|Fly"] = 111.45, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 135.85}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 19.69, ["Fly|Ride"] = 43.36, ["Neon"] = 2.1, ["Neon|Fly"] = 28.23, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 90.61, ["Mega"] = 18.17, ["Mega|Fly"] = 65.04, ["Mega|Ride"] = 36.74, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.47, ["Mega"] = 18.19, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.28, ["Neon|Fly|Ride"] = 420, ["Mega"] = 26.98, ["Mega|Ride"] = 199.35, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.89, ["Fly|Ride"] = 47.25, ["Neon"] = 3.84, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 17.71, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 38.06, ["Mega|Ride"] = 51.53, ["Mega|Fly|Ride"] = 108.36}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.56, ["Ride"] = 78.75, ["Fly|Ride"] = 216.7, ["Neon"] = 81.38, ["Mega"] = 389.81, ["Mega|Ride"] = 513.51, ["Mega|Fly|Ride"] = 722.6}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.24, ["Neon"] = 26.25, ["Neon|Ride"] = 157.5, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.51, ["Fly|Ride"] = 177.71, ["Neon"] = 22.73, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 325.02, ["Mega|Ride"] = 297.93, ["Mega|Fly|Ride"] = 383.15}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 11.7, ["Fly|Ride"] = 30.1, ["Neon"] = 2.1, ["Neon|Fly"] = 28.18, ["Neon|Ride"] = 11.81, ["Neon|Fly|Ride"] = 30.45, ["Mega"] = 14.6, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 59.77}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.37, ["Neon"] = 7.62, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 722.6, ["Mega"] = 86.72, ["Mega|Ride"] = 145.26}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.61, ["Ride"] = 44.18, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14, ["Mega|Fly"] = 130.03, ["Mega|Ride"] = 56.46, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 72.63, ["Mega"] = 20.21, ["Mega|Fly"] = 216.68, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 143.11, ["Ride"] = 19.39, ["Fly|Ride"] = 57.92, ["Neon"] = 8.59, ["Neon|Fly"] = 61.22, ["Neon|Ride"] = 36.85, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 170.62, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 295.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 176.56, ["Ride"] = 236.23, ["Fly|Ride"] = 841.08, ["Neon"] = 656.25, ["Neon|Ride"] = 866.69, ["Neon|Fly|Ride"] = 1009.68, ["Mega"] = 8666.69, ["Mega|Fly|Ride"] = 4092.17}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 28.24, ["Neon"] = 7.37, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.86, ["Fly"] = 103.68, ["Ride"] = 24.68, ["Fly|Ride"] = 64.97, ["Neon"] = 33.12, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 173.35, ["Mega"] = 385.87, ["Mega|Ride"] = 225.79, ["Mega|Fly|Ride"] = 653.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 15.72, ["Fly|Ride"] = 32.82, ["Neon"] = 5.11, ["Neon|Fly"] = 33.6, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 50.94, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 145.19}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.61, ["Ride"] = 19.69, ["Fly|Ride"] = 98.44, ["Neon"] = 10.85, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.35, ["Mega|Ride"] = 196.33, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.2, ["Fly|Ride"] = 37.9, ["Neon"] = 16.26, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 866.69, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.7, ["Ride"] = 34.68, ["Fly|Ride"] = 66.27, ["Neon"] = 41.72, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 231.84, ["Mega|Ride"] = 449.1, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 20.57, ["Ride"] = 17.73, ["Fly|Ride"] = 31.4, ["Neon"] = 31.5, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 79.16, ["Mega"] = 262.5, ["Mega|Fly"] = 215.6, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 62.29, ["Ride"] = 83.98, ["Fly|Ride"] = 149.62, ["Neon"] = 341.24, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 418.68, ["Neon|Fly|Ride"] = 385.91, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 242.34, ["Fly"] = 433.46, ["Ride"] = 245.99, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 5055.94}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.16, ["Fly"] = 85.2, ["Ride"] = 78.1, ["Fly|Ride"] = 111.61, ["Neon"] = 490.43, ["Neon|Fly"] = 367.31, ["Neon|Ride"] = 293.28, ["Neon|Fly|Ride"] = 286.81, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.76, ["Fly"] = 288.09, ["Ride"] = 48.59, ["Fly|Ride"] = 65.63, ["Neon"] = 47.16, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.75, ["Mega"] = 262.5, ["Mega|Ride"] = 190.31, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.1, ["Fly"] = 72.61, ["Ride"] = 28.87, ["Fly|Ride"] = 65.54, ["Neon"] = 61.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 411.68, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 33.58, ["Ride"] = 17.05, ["Fly|Ride"] = 50.94, ["Neon"] = 3.5, ["Neon|Fly"] = 57.68, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 62.85, ["Mega"] = 46.59, ["Mega|Fly"] = 149.71, ["Mega|Ride"] = 216.68, ["Mega|Fly|Ride"] = 402.09}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.81, ["Fly"] = 39.38, ["Ride"] = 31.44, ["Fly|Ride"] = 66.25, ["Neon"] = 95.81, ["Neon|Fly"] = 289.3, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 255.69, ["Mega"] = 477.77, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 592.6}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.75, ["Fly|Ride"] = 36.67, ["Neon"] = 14.44, ["Neon|Fly"] = 82.22, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 62.35, ["Mega"] = 131.25, ["Mega|Ride"] = 271.93, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.49, ["Ride"] = 31.57, ["Fly|Ride"] = 328.13, ["Neon"] = 44.63, ["Neon|Ride"] = 36.85, ["Mega"] = 207.38, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.51, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.65, ["Mega|Ride"] = 43.35, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.07, ["Fly|Ride"] = 43.36, ["Neon"] = 13.09, ["Neon|Fly"] = 108.35, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 66.28, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 52.63, ["Ride"] = 18.51, ["Fly|Ride"] = 71.1, ["Neon"] = 19.09, ["Neon|Ride"] = 47.25, ["Mega"] = 131.23, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 87.26, ["Fly"] = 164.11, ["Ride"] = 152.71, ["Fly|Ride"] = 199.4, ["Neon"] = 489.57, ["Neon|Ride"] = 433.35, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3926.51, ["Mega|Fly|Ride"] = 2903.36}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.14, ["Ride"] = 129.94, ["Fly|Ride"] = 131.29, ["Neon"] = 42.94, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.94, ["Ride"] = 19.47, ["Fly|Ride"] = 55.89, ["Neon"] = 14.44, ["Neon|Ride"] = 49.06, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 246.75, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 272.06}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 15.74, ["Ride"] = 46.6, ["Fly|Ride"] = 155.84, ["Neon"] = 90.84, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 440.63, ["Mega|Fly"] = 866.69, ["Mega|Ride"] = 679.26, ["Mega|Fly|Ride"] = 828.26}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Fly|Ride"] = 128.94, ["Neon"] = 32.81, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 852.6, ["Mega|Ride"] = 598.5, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.08, ["Fly"] = 41.99, ["Ride"] = 26.17, ["Fly|Ride"] = 61.85, ["Neon"] = 407.39, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 161.02, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 1398.59, ["Mega|Fly|Ride"] = 534.72}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.18, ["Fly|Ride"] = 52.38, ["Neon"] = 2.1, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 137.9, ["Mega"] = 32.71, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 231.89}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.93, ["Fly"] = 32.55, ["Ride"] = 13.13, ["Fly|Ride"] = 65.54, ["Neon"] = 58.52, ["Neon|Ride"] = 164.43, ["Mega"] = 288.33, ["Mega|Fly"] = 409.85, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 21.6, ["Fly|Ride"] = 47.09, ["Neon"] = 12.89, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 183.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.1, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 57.69, ["Mega"] = 37.86, ["Mega|Ride"] = 71.52, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 22.29, ["Fly"] = 149.7, ["Ride"] = 83.66, ["Fly|Ride"] = 136.49, ["Neon"] = 180.57, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 574.87, ["Mega"] = 735, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 866.69}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.3, ["Fly"] = 29.27, ["Ride"] = 65.02, ["Fly|Ride"] = 210, ["Neon"] = 98.17, ["Mega|Ride"] = 325.02, ["Mega|Fly|Ride"] = 327.63}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 24.6, ["Ride"] = 20.56, ["Fly|Ride"] = 64.93, ["Neon"] = 17.07, ["Neon|Fly"] = 86.69, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 108.4, ["Mega"] = 158.82, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 80.19, ["Fly"] = 433.12, ["Ride"] = 130.04, ["Neon"] = 427.98, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 565.04, ["Mega"] = 4582.97, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 4.96, ["Fly"] = 45.75, ["Ride"] = 19.52, ["Fly|Ride"] = 70.88, ["Neon"] = 36.92, ["Neon|Ride"] = 63.94, ["Neon|Fly|Ride"] = 107.79, ["Mega"] = 361.99, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 398.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.62, ["Fly"] = 131.24, ["Ride"] = 91.86, ["Fly|Ride"] = 214.55, ["Neon"] = 223.13, ["Neon|Fly"] = 329.39, ["Neon|Ride"] = 207.89, ["Neon|Fly|Ride"] = 354.36, ["Mega"] = 1185.18, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1077.57}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.36, ["Fly"] = 173.39, ["Ride"] = 55, ["Fly|Ride"] = 151.7, ["Neon"] = 58.52, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 336.66, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.81, ["Fly"] = 54, ["Ride"] = 26.02, ["Fly|Ride"] = 72.42, ["Neon"] = 145.2, ["Neon|Ride"] = 196.33, ["Neon|Fly|Ride"] = 390.22, ["Mega"] = 573.04, ["Mega|Ride"] = 576.35, ["Mega|Fly|Ride"] = 578.51}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Fly"] = 77.32, ["Ride"] = 98.15, ["Fly|Ride"] = 102.92, ["Neon"] = 50.7, ["Neon|Ride"] = 79.71, ["Neon|Fly|Ride"] = 280.71, ["Mega"] = 346.76, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 413.77}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.59, ["Ride"] = 39.25, ["Neon"] = 41.99, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 276.83, ["Mega|Ride"] = 280.01, ["Mega|Fly|Ride"] = 417.18}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 72.61, ["Neon"] = 2.1, ["Neon|Ride"] = 131.23, ["Neon|Fly|Ride"] = 210, ["Mega"] = 19.57, ["Mega|Ride"] = 145.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.2, ["Ride"] = 126.06, ["Neon"] = 24.94, ["Neon|Ride"] = 198.27, ["Neon|Fly|Ride"] = 202.79, ["Mega"] = 238.88, ["Mega|Ride"] = 511.35, ["Mega|Fly|Ride"] = 540.6}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.96, ["Ride"] = 29.27, ["Neon"] = 28.87, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 101.85, ["Neon|Fly|Ride"] = 201.52, ["Mega"] = 210.67, ["Mega|Ride"] = 289.27, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 122.71, ["Neon"] = 18.8, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 128.93, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Fly"] = 649.09, ["Ride"] = 576.75, ["Fly|Ride"] = 577.5, ["Neon"] = 1841.9, ["Neon|Fly"] = 1844.07, ["Neon|Ride"] = 1800.06, ["Neon|Fly|Ride"] = 1682.99, ["Mega|Fly|Ride"] = 5085.94}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.19, ["Fly"] = 45.47, ["Ride"] = 20.65, ["Fly|Ride"] = 57.51, ["Neon"] = 120.25, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 319.93, ["Mega"] = 202.6, ["Mega|Ride"] = 376.57, ["Mega|Fly|Ride"] = 358.6}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.48, ["Fly"] = 66.94, ["Ride"] = 20.94, ["Fly|Ride"] = 52.61, ["Neon"] = 86.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 82.23, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 331.87, ["Mega|Ride"] = 325.02, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.56, ["Fly"] = 24.93, ["Ride"] = 24.68, ["Fly|Ride"] = 50.3, ["Neon"] = 15.75, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.6, ["Ride"] = 26.22, ["Fly|Ride"] = 89.24, ["Neon"] = 8.75, ["Neon|Ride"] = 44.35, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 66.27, ["Mega|Ride"] = 141.06, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Neon"] = 2.1, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 45.84, ["Mega|Fly"] = 202.6, ["Mega|Ride"] = 147.27, ["Mega|Fly|Ride"] = 231.84}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.97, ["Ride"] = 32.71, ["Fly|Ride"] = 338.06, ["Neon"] = 81.38, ["Neon|Ride"] = 112.87, ["Mega"] = 409.85, ["Mega|Ride"] = 417.2, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.27, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.6, ["Fly"] = 321.92, ["Ride"] = 57.66, ["Fly|Ride"] = 78.75, ["Neon"] = 47.12, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 261.37, ["Mega|Ride"] = 361.85, ["Mega|Fly|Ride"] = 1083.35}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.74, ["Ride"] = 446.23, ["Fly|Ride"] = 551.25, ["Neon|Ride"] = 1603.35, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8125.02, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.12, ["Fly"] = 196.88, ["Ride"] = 26.25, ["Fly|Ride"] = 130.04, ["Neon"] = 58.53, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.33, ["Mega"] = 306.56, ["Mega|Ride"] = 497.27, ["Mega|Fly|Ride"] = 770.26}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.71, ["Ride"] = 29.92, ["Fly|Ride"] = 118.11, ["Neon"] = 3.59, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 42.93, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 37.28, ["Mega|Fly"] = 145.2, ["Mega|Ride"] = 86.62, ["Mega|Fly|Ride"] = 191.03}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.82, ["Neon|Ride"] = 144.44, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 28.88, ["Mega|Ride"] = 181.91, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.72, ["Fly"] = 107.9, ["Ride"] = 45.94, ["Fly|Ride"] = 144.38, ["Neon"] = 104.99, ["Neon|Ride"] = 215.16, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 518.44, ["Mega|Ride"] = 689.03, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.2, ["Ride"] = 72.51, ["Neon"] = 95.29, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 866.69, ["Mega"] = 573.04, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.62, ["Ride"] = 76.12, ["Neon"] = 96.94, ["Neon|Ride"] = 200.82, ["Mega"] = 663.02, ["Mega|Fly|Ride"] = 818.44}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.58, ["Ride"] = 26.44, ["Fly|Ride"] = 229.17, ["Neon"] = 167.37, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.13, ["Mega|Ride"] = 509.23, ["Mega|Fly|Ride"] = 573.04}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 719.43, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 7.75, ["Fly"] = 42.05, ["Ride"] = 33.5, ["Fly|Ride"] = 82.18, ["Neon"] = 101.87, ["Neon|Ride"] = 131.25, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 795.18}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.3, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 52.5, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 33.07, ["Fly"] = 346.77, ["Ride"] = 116.82, ["Fly|Ride"] = 233.63, ["Neon"] = 146.99, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 412.48, ["Mega|Ride"] = 409.89, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 77.32, ["Neon"] = 9.69, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 280.6, ["Mega"] = 44.89, ["Mega|Fly"] = 188.51, ["Mega|Ride"] = 385.68, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.19, ["Ride"] = 80.18, ["Neon"] = 262.5, ["Neon|Ride"] = 325.02, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1656.51, ["Mega|Ride"] = 2868.69, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Fly|Ride"] = 300.57, ["Neon"] = 10.08, ["Neon|Fly"] = 188.53, ["Neon|Ride"] = 58.45, ["Neon|Fly|Ride"] = 131.32, ["Mega"] = 61.41, ["Mega|Ride"] = 90.71, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 27.93, ["Ride"] = 21.41, ["Fly|Ride"] = 100.62, ["Neon"] = 3.66, ["Neon|Fly"] = 49.86, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 30.98, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 289.27}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 131.07, ["Neon"] = 12.76, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 61.69, ["Mega|Ride"] = 138.68, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 48.38, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 137.62, ["Neon"] = 223.13, ["Neon|Ride"] = 361.6, ["Neon|Fly|Ride"] = 490.83, ["Mega|Ride"] = 1155.94, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2167.19}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.93, ["Neon"] = 22.04, ["Neon|Fly"] = 350.44, ["Mega"] = 137.82, ["Mega|Ride"] = 248.07, ["Mega|Fly|Ride"] = 364.34}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 8.66, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 173.35, ["Mega"] = 46.27, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.59, ["Fly"] = 108.38, ["Ride"] = 32.48, ["Fly|Ride"] = 82.22, ["Neon"] = 32.81, ["Mega"] = 310.93, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 82.23, ["Ride"] = 39.38, ["Fly|Ride"] = 298.86, ["Neon"] = 13.09, ["Neon|Ride"] = 63.65, ["Neon|Fly|Ride"] = 138.99, ["Mega"] = 171.78, ["Mega|Fly"] = 175.88, ["Mega|Ride"] = 187.41, ["Mega|Fly|Ride"] = 362.74}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 95.37, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 65.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 410.6}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 22.31, ["Fly|Ride"] = 52.5, ["Neon"] = 4.55, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 105.14, ["Mega"] = 43.35, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 19.69, ["Fly|Ride"] = 57.74, ["Neon"] = 15.75, ["Neon|Fly"] = 102.94, ["Neon|Ride"] = 36.85, ["Neon|Fly|Ride"] = 108.34, ["Mega"] = 151.46, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.91, ["Ride"] = 39.13, ["Fly|Ride"] = 78.75, ["Neon"] = 144.34, ["Neon|Ride"] = 164.07, ["Mega"] = 459.38, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.3, ["Ride"] = 95.19, ["Fly|Ride"] = 139.13, ["Neon"] = 490.77, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2021.52, ["Mega|Ride"] = 1625.02, ["Mega|Fly|Ride"] = 1500.78}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.39, ["Fly|Ride"] = 131.25, ["Neon"] = 3.62, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 32.82, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 251.35}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.09, ["Ride"] = 15.75, ["Fly|Ride"] = 22.32, ["Neon"] = 4.07, ["Neon|Fly"] = 36.85, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 58.51, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 69.36, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.25, ["Fly"] = 49.86, ["Ride"] = 38.03, ["Fly|Ride"] = 52.5, ["Neon"] = 40.69, ["Neon|Ride"] = 164.07, ["Mega"] = 549.27, ["Mega|Ride"] = 327.63, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4333.87, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.22, ["Fly"] = 101.33, ["Ride"] = 29.27, ["Fly|Ride"] = 98.17, ["Neon"] = 215, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 258.56, ["Mega|Ride"] = 795.18, ["Mega|Fly|Ride"] = 865.6}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.86, ["Fly|Ride"] = 287.81, ["Neon"] = 10.59, ["Neon|Ride"] = 47.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.38, ["Mega|Ride"] = 122.19, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 89.12, ["Ride"] = 53.96, ["Fly|Ride"] = 261.97, ["Neon"] = 69.93, ["Neon|Ride"] = 72.34, ["Mega"] = 122.07, ["Mega|Fly|Ride"] = 323.93}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.18, ["Fly"] = 169.31, ["Ride"] = 38.06, ["Fly|Ride"] = 102.38, ["Neon"] = 194.25, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 238.04, ["Mega"] = 2600.03, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 126.16, ["Fly"] = 168.23, ["Ride"] = 118.13, ["Fly|Ride"] = 184.61, ["Neon"] = 396.3, ["Neon|Fly"] = 823.46, ["Neon|Ride"] = 578.51, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8666.69, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.92, ["Ride"] = 304.49, ["Fly|Ride"] = 540.67, ["Neon"] = 938.44, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3566.36}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 7.35, ["Ride"] = 55.13, ["Fly|Ride"] = 202.62, ["Neon"] = 98.33, ["Neon|Ride"] = 88.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 573.04, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 455.44}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 15.75, ["Fly|Ride"] = 39.27, ["Neon"] = 9.08, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 84, ["Mega"] = 84.12, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 20.78, ["Fly|Ride"] = 81.11, ["Neon"] = 26.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 116.73, ["Mega"] = 288.7, ["Mega|Ride"] = 245.34, ["Mega|Fly|Ride"] = 304.69}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 347.82, ["Ride"] = 350.43, ["Fly|Ride"] = 761.69, ["Neon"] = 1562.54, ["Neon|Ride"] = 2058.35, ["Neon|Fly|Ride"] = 1762.6, ["Mega"] = 10833.36, ["Mega|Fly|Ride"] = 5847.19}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 9.1, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 33.48, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 474.87}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.18, ["Fly"] = 26.24, ["Ride"] = 17.06, ["Fly|Ride"] = 60.72, ["Neon"] = 27.56, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 98.03, ["Mega"] = 123.52, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.12, ["Fly"] = 6562.5, ["Ride"] = 101.87, ["Fly|Ride"] = 130.04, ["Neon"] = 103.93, ["Neon|Fly"] = 433.35, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 318.28, ["Mega"] = 551.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 723.1}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 157.5, ["Ride"] = 124.57, ["Fly|Ride"] = 143.07, ["Neon|Ride"] = 818.44, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3251.07}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.75, ["Fly"] = 29.68, ["Ride"] = 28.16, ["Fly|Ride"] = 53.03, ["Neon"] = 140.86, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 127.64, ["Mega"] = 875.44, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Mega"] = 39.3, ["Mega|Ride"] = 112.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 86.57, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.92, ["Mega"] = 22.32, ["Mega|Fly"] = 101.85, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.08, ["Ride"] = 81.29, ["Fly|Ride"] = 199.49, ["Neon"] = 35.32, ["Neon|Ride"] = 102.36, ["Neon|Fly|Ride"] = 240, ["Mega"] = 181.13, ["Mega|Ride"] = 212.39, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1292.82, ["Ride"] = 1299.38, ["Fly|Ride"] = 1363.69, ["Neon"] = 4448.72, ["Neon|Ride"] = 4333.35, ["Neon|Fly|Ride"] = 4542.38, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 402.81, ["Ride"] = 468.71, ["Fly|Ride"] = 576.19, ["Neon"] = 1680, ["Neon|Ride"] = 2046.7, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17333.38, ["Mega|Fly|Ride"] = 6933.36}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 325.19, ["Fly"] = 458.91, ["Ride"] = 354.36, ["Fly|Ride"] = 419.9, ["Neon"] = 756.28, ["Neon|Fly"] = 867.43, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 207.38, ["Fly"] = 288.75, ["Ride"] = 280.06, ["Fly|Ride"] = 332.64, ["Neon"] = 630, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 702.86, ["Mega|Fly|Ride"] = 3031.19}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 34.55, ["Ride"] = 17.04, ["Fly|Ride"] = 42.45, ["Neon"] = 5.25, ["Neon|Ride"] = 29.25, ["Neon|Fly|Ride"] = 104.01, ["Mega"] = 66.08, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 223.13, ["Fly"] = 466.28, ["Ride"] = 354.37, ["Fly|Ride"] = 943.95, ["Neon"] = 1050, ["Neon|Ride"] = 1324.05, ["Neon|Fly|Ride"] = 1299.37, ["Mega"] = 21955.97, ["Mega|Ride"] = 5489.28, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.76, ["Fly"] = 19.69, ["Ride"] = 58.52, ["Neon"] = 35.09, ["Neon|Ride"] = 123.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 149.63, ["Mega|Ride"] = 342.83, ["Mega|Fly|Ride"] = 638.08}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 17.35, ["Fly|Ride"] = 38.98, ["Neon"] = 8.68, ["Neon|Ride"] = 54.17, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 117.08, ["Mega|Ride"] = 164.43, ["Mega|Fly|Ride"] = 120.8}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.05, ["Mega"] = 82.17, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 29.1, ["Ride"] = 57.75, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8180.41, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 19.69, ["Neon|Ride"] = 61.13, ["Mega"] = 359.69, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.69, ["Mega|Ride"] = 81.29, ["Mega|Fly|Ride"] = 160.35}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 85.99, ["Ride"] = 34.27, ["Fly|Ride"] = 81.38, ["Neon"] = 19.2, ["Neon|Fly"] = 115.95, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 196.33, ["Mega"] = 170.52, ["Mega|Ride"] = 162.21, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 45.53, ["Ride"] = 22.3, ["Fly|Ride"] = 42, ["Neon"] = 37.94, ["Neon|Fly"] = 147.24, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 21.69, ["Ride"] = 38.06, ["Fly|Ride"] = 105, ["Neon"] = 94.28, ["Neon|Ride"] = 171.19, ["Neon|Fly|Ride"] = 327.63, ["Mega"] = 433.35, ["Mega|Ride"] = 811.43}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6544.81, ["Ride"] = 17.07, ["Fly|Ride"] = 131.24, ["Neon"] = 51.98, ["Neon|Ride"] = 215.4, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 341.25, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 67.48, ["Ride"] = 16.34, ["Fly|Ride"] = 45.94, ["Neon"] = 3.73, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 226.79}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 142.7, ["Fly"] = 264.42, ["Ride"] = 164.05, ["Fly|Ride"] = 262.5, ["Neon"] = 982.72, ["Neon|Ride"] = 865.6, ["Neon|Fly|Ride"] = 840, ["Mega"] = 8666.69, ["Mega|Ride"] = 4116.69, ["Mega|Fly|Ride"] = 4046.27}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 15.62, ["Fly|Ride"] = 36.66, ["Neon"] = 2.9, ["Neon|Fly"] = 36.83, ["Neon|Ride"] = 23.84, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.65, ["Mega|Ride"] = 62.85, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 3.89, ["Ride"] = 43.36, ["Fly|Ride"] = 230.89, ["Neon"] = 38.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 785.32, ["Mega"] = 275.63, ["Mega|Ride"] = 434.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 24.93, ["Ride"] = 426.38, ["Fly|Ride"] = 183.75, ["Neon"] = 190.32, ["Neon|Ride"] = 302.27, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 786.19, ["Mega|Ride"] = 901.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.87, ["Fly"] = 311.68, ["Ride"] = 268.74, ["Fly|Ride"] = 319.39, ["Neon"] = 812.4, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 808.19, ["Mega|Fly|Ride"] = 3573.94}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.75, ["Ride"] = 164.42, ["Fly|Ride"] = 147.24, ["Neon"] = 124.69, ["Neon|Ride"] = 145.34, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 278.81, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 397.61}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.02, ["Fly"] = 98.18, ["Ride"] = 43.37, ["Fly|Ride"] = 72.6, ["Neon"] = 126.04, ["Neon|Fly"] = 164.42, ["Neon|Ride"] = 327.63, ["Neon|Fly|Ride"] = 216.68, ["Mega"] = 1285.94, ["Mega|Ride"] = 1445.18, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 931.88, ["Fly"] = 1282.99, ["Ride"] = 1016.97, ["Fly|Ride"] = 1036.66, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 17045.21}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.02, ["Fly"] = 24.93, ["Ride"] = 21.67, ["Fly|Ride"] = 45.93, ["Neon"] = 47.24, ["Neon|Fly"] = 76.44, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 242.82, ["Mega|Ride"] = 289.27, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.3, ["Fly"] = 78.75, ["Ride"] = 49.88, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 98.18, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 314.18}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.7, ["Ride"] = 24.6, ["Fly|Ride"] = 62.99, ["Neon"] = 11.33, ["Neon|Ride"] = 47.75, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 91.87, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.62, ["Fly"] = 58.52, ["Ride"] = 32.81, ["Fly|Ride"] = 103.81, ["Neon"] = 72.59, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 97.55, ["Neon|Fly|Ride"] = 187.81, ["Mega"] = 446.22, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 461.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 20.51, ["Neon|Fly"] = 43.36, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 108.59, ["Mega"] = 145.69, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 173}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.15, ["Neon"] = 13.02, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 49.09, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.59, ["Mega|Ride"] = 173.43}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 245.31, ["Ride"] = 270.92, ["Fly|Ride"] = 433.4, ["Neon"] = 938.3, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3934.68}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 23.63, ["Fly|Ride"] = 145.26, ["Neon"] = 6.36, ["Neon|Ride"] = 50.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 57.66, ["Mega|Ride"] = 100.88, ["Mega|Fly|Ride"] = 346.68}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.49, ["Ride"] = 33.67, ["Fly|Ride"] = 88.86, ["Neon"] = 28.18, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 179.17, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.71, ["Fly"] = 94.74, ["Ride"] = 25.99, ["Neon"] = 15.27, ["Neon|Ride"] = 71.52, ["Mega"] = 92.05, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 81.25, ["Ride"] = 129.62, ["Fly|Ride"] = 249.38, ["Neon"] = 446.6, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 545.35, ["Mega"] = 2600.03, ["Mega|Ride"] = 1589.27, ["Mega|Fly|Ride"] = 1878.52}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.74, ["Fly"] = 88.08, ["Ride"] = 39.38, ["Fly|Ride"] = 268.71, ["Neon"] = 181.32, ["Neon|Ride"] = 210.18, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.24, ["Mega|Ride"] = 647.84, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.68, ["Fly"] = 58.52, ["Ride"] = 39.37, ["Fly|Ride"] = 103.69, ["Neon"] = 93.19, ["Neon|Ride"] = 173.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 491.85, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 513.18}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 108.83, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 562.27}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 36.12, ["Fly"] = 87.27, ["Ride"] = 71.45, ["Fly|Ride"] = 162.65, ["Neon"] = 262.5, ["Neon|Fly"] = 245.42, ["Neon|Ride"] = 229.59, ["Neon|Fly|Ride"] = 287.16, ["Mega|Fly|Ride"] = 866.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 6.04, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 128.93, ["Mega"] = 61.77, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 13.12, ["Fly"] = 39.38, ["Ride"] = 32.81, ["Fly|Ride"] = 86.69, ["Neon"] = 63.91, ["Neon|Ride"] = 101.87, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 432.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 57.22, ["Fly"] = 203.41, ["Ride"] = 69.66, ["Fly|Ride"] = 139.33, ["Neon"] = 262.5, ["Neon|Fly"] = 433.4, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 1482.03, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.21, ["Ride"] = 16.26, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 28.18, ["Neon|Ride"] = 16.68, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 20.39, ["Mega|Fly"] = 122.72, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 86.83}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 64.32, ["Neon"] = 20.05, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 472.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.85, ["Fly"] = 145.21, ["Ride"] = 41.91, ["Fly|Ride"] = 117.24, ["Neon"] = 110.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 644.6, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.36, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 88.6, ["Mega"] = 18.19, ["Mega|Ride"] = 52.36, ["Mega|Fly|Ride"] = 216.68}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 30.76, ["Fly"] = 207.9, ["Ride"] = 44.63, ["Fly|Ride"] = 202.94, ["Neon"] = 151.88, ["Neon|Ride"] = 173.37, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 660.52, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 596, ["Mega|Fly|Ride"] = 996.68}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.09, ["Fly"] = 43.36, ["Ride"] = 26.25, ["Fly|Ride"] = 89.95, ["Neon"] = 376.69, ["Neon|Ride"] = 121.8, ["Neon|Fly|Ride"] = 166.85, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 517.84}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.63, ["Ride"] = 51.45, ["Neon"] = 48.57, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 233.63, ["Mega|Ride"] = 313.36, ["Mega|Fly|Ride"] = 432.27}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.83, ["Fly"] = 72.19, ["Ride"] = 72.17, ["Fly|Ride"] = 237.34, ["Neon"] = 91.88, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 215.86, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 43.36, ["Ride"] = 27.57, ["Fly|Ride"] = 196.88, ["Neon"] = 8.02, ["Neon|Ride"] = 37.43, ["Mega"] = 68.27, ["Mega|Fly"] = 216.68, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 289.27}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.91, ["Neon"] = 3.78, ["Neon|Ride"] = 88.85, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 48.07, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 22.46}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.75, ["Fly"] = 101.07, ["Ride"] = 66.94, ["Fly|Ride"] = 86.69, ["Neon"] = 184.58, ["Neon|Ride"] = 216.68, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.35, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Mega"] = 23.62, ["Mega|Ride"] = 111.68, ["Mega|Fly|Ride"] = 325.02}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Fly"] = 541.82, ["Ride"] = 561.75, ["Fly|Ride"] = 459.38, ["Neon"] = 2889.62, ["Neon|Ride"] = 2708.34, ["Neon|Fly|Ride"] = 2162.35, ["Mega"] = 17333.38, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.6, ["Fly"] = 48.37, ["Ride"] = 33.73, ["Fly|Ride"] = 49.09, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.9, ["Mega"] = 289.34, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 635.93}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 19.52, ["Fly|Ride"] = 60.82, ["Neon"] = 26.17, ["Neon|Ride"] = 65.02, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 147, ["Mega|Fly"] = 289.27, ["Mega|Ride"] = 173.75, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.95, ["Ride"] = 26.25, ["Fly|Ride"] = 541.74, ["Neon"] = 112.88, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 655.25, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 433.46, ["Ride"] = 38.57, ["Fly|Ride"] = 72.6, ["Neon"] = 33.8, ["Neon|Fly"] = 50.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 280.23, ["Mega|Fly|Ride"] = 504.86}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.38, ["Ride"] = 73.49, ["Fly|Ride"] = 177.68, ["Neon"] = 54.45, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 536.27, ["Mega|Ride"] = 418.04, ["Mega|Fly|Ride"] = 1051.34}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.75, ["Ride"] = 46.6, ["Fly|Ride"] = 91.88, ["Neon"] = 28.2, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 232.21, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 45.21, ["Ride"] = 13.81, ["Fly|Ride"] = 86.69, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 15.54, ["Mega|Fly"] = 66.28, ["Mega|Ride"] = 33.06, ["Mega|Fly|Ride"] = 104.65}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.28, ["Fly"] = 49.88, ["Ride"] = 45.94, ["Fly|Ride"] = 108.35, ["Neon"] = 31.29, ["Neon|Fly"] = 122.72, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 174.54, ["Mega"] = 196.88, ["Mega|Ride"] = 259.77, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 249.38, ["Ride"] = 360.19, ["Fly|Ride"] = 367.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9521.77, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 82.51, ["Ride"] = 105, ["Fly|Ride"] = 258.96, ["Neon"] = 444.32, ["Neon|Fly"] = 927.46, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 644.6, ["Mega"] = 2311.85, ["Mega|Ride"] = 1720.35, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 17.34, ["Fly|Ride"] = 36.75, ["Neon"] = 6.46, ["Neon|Fly"] = 72.6, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 145.19, ["Mega|Fly"] = 215.6, ["Mega|Ride"] = 101.91, ["Mega|Fly|Ride"] = 260.54}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 15.72, ["Fly|Ride"] = 35.6, ["Neon"] = 8.93, ["Neon|Fly"] = 39, ["Neon|Ride"] = 25.95, ["Neon|Fly|Ride"] = 61.06, ["Mega"] = 51.19, ["Mega|Fly"] = 289.27, ["Mega|Ride"] = 86.12, ["Mega|Fly|Ride"] = 286.01}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 101.88, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 101.99, ["Neon|Ride"] = 33.14, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 327.91, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 196.88, ["Fly"] = 327.63, ["Ride"] = 248.26, ["Fly|Ride"] = 288.65, ["Neon"] = 1191.83, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1445.18, ["Mega|Ride"] = 8666.69, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 31.12, ["Ride"] = 17.81, ["Fly|Ride"] = 40.74, ["Neon"] = 18.42, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 38.69, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 262.5, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.05, ["Ride"] = 77.97, ["Fly|Ride"] = 216.01, ["Neon"] = 13.13, ["Neon|Ride"] = 108.34, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 196.88, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 463.67}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 8.59, ["Neon|Ride"] = 137.82, ["Mega"] = 101.07, ["Mega|Ride"] = 343.58}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 49.13, ["Ride"] = 26.01, ["Fly|Ride"] = 65.63, ["Neon"] = 151.7, ["Neon|Ride"] = 111.22, ["Neon|Fly|Ride"] = 255.69, ["Mega"] = 461.51, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 575.26}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.66, ["Fly"] = 103.66, ["Ride"] = 90.15, ["Fly|Ride"] = 396.59, ["Neon"] = 129.97, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 509.77, ["Mega|Fly"] = 2275.03, ["Mega|Ride"] = 518.85, ["Mega|Fly|Ride"] = 648.1}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.86, ["Ride"] = 42.49, ["Fly|Ride"] = 91.77, ["Neon"] = 216.46, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 866.69, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 812.52}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 15.09, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 31.47, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 61, ["Mega"] = 20.99, ["Mega|Fly"] = 433.59, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 209.32, ["Ride"] = 236.67, ["Fly|Ride"] = 272.87, ["Neon"] = 3435.32, ["Neon|Fly|Ride"] = 1269.69, ["Mega|Fly|Ride"] = 5055.94}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.84, ["Fly"] = 101.07, ["Ride"] = 24.88, ["Fly|Ride"] = 92.94, ["Neon"] = 78.75, ["Neon|Ride"] = 115.36, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 422.63, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.77, ["Fly|Ride"] = 43.36, ["Neon"] = 5.6, ["Neon|Fly"] = 43.29, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 108.34, ["Mega"] = 62.6, ["Mega|Fly"] = 231.84, ["Mega|Ride"] = 86.68, ["Mega|Fly|Ride"] = 234.18}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.14, ["Fly|Ride"] = 79.4, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 131.32, ["Mega"] = 23.48, ["Mega|Fly"] = 145.19, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 163.61}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Fly|Ride"] = 72.18, ["Neon"] = 10.48, ["Neon|Fly"] = 736.15, ["Neon|Ride"] = 48.38, ["Neon|Fly|Ride"] = 115.36, ["Mega"] = 155.53, ["Mega|Ride"] = 127.82, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.53, ["Fly"] = 47.16, ["Ride"] = 28.84, ["Fly|Ride"] = 63, ["Neon"] = 47.16, ["Neon|Fly"] = 275.21, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 114.58, ["Mega"] = 595.85, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 433.08}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 12.26, ["Ride"] = 45.53, ["Fly|Ride"] = 144.38, ["Neon"] = 107.27, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 405.19}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.74, ["Neon"] = 2.1, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 101.88, ["Mega"] = 23.29, ["Mega|Ride"] = 86.7, ["Mega|Fly|Ride"] = 148.78}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.06, ["Ride"] = 34.13, ["Fly|Ride"] = 145.2, ["Neon"] = 36.22, ["Neon|Fly"] = 98.17, ["Neon|Ride"] = 45.71, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 156.19, ["Mega|Fly"] = 327.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 143.75, ["Neon"] = 3.76, ["Neon|Fly"] = 115.92, ["Neon|Ride"] = 55.08, ["Neon|Fly|Ride"] = 105, ["Mega"] = 27.36, ["Mega|Ride"] = 108.5, ["Mega|Fly|Ride"] = 327.54}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 49.38, ["Ride"] = 21.94, ["Fly|Ride"] = 44.63, ["Neon"] = 3.94, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 79.71, ["Mega|Ride"] = 82.29, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 604.59, ["Ride"] = 730.91, ["Fly|Ride"] = 771.75, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 18.33, ["Fly|Ride"] = 43.36, ["Neon"] = 18.36, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 193.93, ["Mega|Fly|Ride"] = 401.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 51.19, ["Fly|Ride"] = 64.8, ["Neon"] = 15.42, ["Neon|Fly"] = 758.44, ["Neon|Ride"] = 84.89, ["Neon|Fly|Ride"] = 188.51, ["Mega"] = 74.8, ["Mega|Fly"] = 216.68, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 288.46}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.25, ["Fly"] = 33.6, ["Ride"] = 22.46, ["Fly|Ride"] = 65.54, ["Neon"] = 41.48, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 124.74, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 370.11}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.52, ["Ride"] = 14.56, ["Fly|Ride"] = 43.36, ["Neon"] = 7.76, ["Neon|Fly"] = 151.7, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 58.51, ["Mega"] = 62.89, ["Mega|Ride"] = 91.23, ["Mega|Fly|Ride"] = 180.22}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.57, ["Ride"] = 80.18, ["Fly|Ride"] = 319.64, ["Neon"] = 196.88, ["Neon|Ride"] = 210, ["Mega"] = 734.52, ["Mega|Ride"] = 736.23, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 21, ["Fly|Ride"] = 76.13, ["Neon"] = 6.57, ["Neon|Fly"] = 139.89, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 115.85, ["Mega"] = 46.22, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.37, ["Fly|Ride"] = 61.11, ["Neon"] = 12.73, ["Neon|Ride"] = 48.57, ["Mega"] = 112.61, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 11.21, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 97.12, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 43.36, ["Ride"] = 18.32, ["Fly|Ride"] = 69.09, ["Neon"] = 3.68, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 41.97, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 131.32}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.08, ["Fly"] = 22.16, ["Ride"] = 21.13, ["Fly|Ride"] = 38.03, ["Neon"] = 118.13, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 163.61, ["Mega|Ride"] = 566.61, ["Mega|Fly|Ride"] = 419.27}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 686.16, ["Fly"] = 1012.09, ["Ride"] = 771.74, ["Fly|Ride"] = 787.5, ["Neon"] = 1935.94, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2164.32, ["Mega"] = 6645.19, ["Mega|Ride"] = 4200, ["Mega|Fly|Ride"] = 6355.94}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.28, ["Fly|Ride"] = 41.47, ["Neon"] = 4.12, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 61.15, ["Mega"] = 57.2, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 174.16}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.57, ["Fly"] = 26.17, ["Ride"] = 32.82, ["Fly|Ride"] = 202.04, ["Neon"] = 70.26, ["Neon|Ride"] = 216.3, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 393.73, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.04, ["Fly"] = 104.9, ["Ride"] = 73.63, ["Fly|Ride"] = 111.57, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 406.26, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.4, ["Fly"] = 146.86, ["Ride"] = 61.34, ["Fly|Ride"] = 107.99, ["Neon"] = 202.62, ["Neon|Ride"] = 164.43, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 1472.45, ["Mega|Ride"] = 938.19, ["Mega|Fly|Ride"] = 1146.06}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 6.57, ["Fly"] = 92.05, ["Ride"] = 27.3, ["Fly|Ride"] = 145.2, ["Neon"] = 52.4, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.36, ["Mega|Ride"] = 419.27, ["Mega|Fly|Ride"] = 455.02}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.36, ["Ride"] = 56.11, ["Fly|Ride"] = 143.04, ["Neon"] = 104.9, ["Neon|Ride"] = 376.71, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 324.09, ["Mega|Fly"] = 532.54, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 441.75}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 22.71, ["Ride"] = 78.75, ["Fly|Ride"] = 162.53, ["Neon"] = 145.48, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 756.35}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.15}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.88, ["Ride"] = 21, ["Fly|Ride"] = 78.75, ["Neon"] = 49.86, ["Neon|Ride"] = 66.28, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.62, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 216.68, ["Mega"] = 143.06}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.88, ["Fly"] = 62.99, ["Ride"] = 36.66, ["Fly|Ride"] = 81.38, ["Neon"] = 220.29, ["Neon|Fly"] = 289.3, ["Neon|Ride"] = 216.68, ["Neon|Fly|Ride"] = 310.15, ["Mega|Ride"] = 578.51, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 17.75, ["Fly|Ride"] = 45.89, ["Neon"] = 28.34, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 74.97, ["Mega"] = 206.07, ["Mega|Fly"] = 432.27, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 197.96}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.6, ["Fly"] = 31.91, ["Ride"] = 26.15, ["Fly|Ride"] = 42.77, ["Neon"] = 25.08, ["Neon|Ride"] = 55.86, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 210, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 72.61, ["Neon"] = 4.81, ["Mega"] = 45.08, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.74, ["Ride"] = 73.63, ["Fly|Ride"] = 145.2, ["Neon"] = 245.97, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 433.35, ["Mega|Ride"] = 1733.36, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 58.43, ["Neon"] = 9.09, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 76.39, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.15, ["Ride"] = 58.52, ["Fly|Ride"] = 288.22, ["Neon"] = 59.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 325.02, ["Mega"] = 393.75, ["Mega|Fly"] = 578.51, ["Mega|Fly|Ride"] = 612.31}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 16.86, ["Fly|Ride"] = 61.69, ["Neon"] = 28.87, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.24, ["Fly"] = 52.49, ["Ride"] = 24.55, ["Fly|Ride"] = 88.86, ["Neon"] = 48.16, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 432.27, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.34, ["Ride"] = 95.37, ["Neon"] = 114.15, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 47.27, ["Ride"] = 97.44, ["Fly|Ride"] = 91.88, ["Neon"] = 262.5, ["Neon|Ride"] = 541.14, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1300.02, ["Mega|Ride"] = 1408.35, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.05, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Mega"] = 378, ["Mega|Ride"] = 573.04, ["Mega|Fly|Ride"] = 715.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 2.82, ["Ride"] = 126.03, ["Neon"] = 52.02, ["Neon|Fly"] = 216.7, ["Neon|Ride"] = 170.63, ["Mega"] = 818.44, ["Mega|Ride"] = 490.83}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.38, ["Fly"] = 27.57, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 116.82, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 679.26, ["Mega|Fly"] = 2166.69, ["Mega|Ride"] = 736.23, ["Mega|Fly|Ride"] = 778.94}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.22, ["Neon"] = 19.13, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 188.51, ["Mega|Fly|Ride"] = 327.63}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 18.79, ["Fly|Ride"] = 43.32, ["Neon"] = 6.24, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 98.15, ["Mega"] = 98.18, ["Mega|Ride"] = 136.92, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.62, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Fly|Ride"] = 75.49, ["Neon"] = 25.71, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 89.24, ["Mega|Ride"] = 145.19, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.32, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 7.48, ["Neon|Ride"] = 26.74, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 52.29, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 179.86}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.04, ["Fly|Ride"] = 72.6, ["Neon"] = 18.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 216.68, ["Mega"] = 289.27, ["Mega|Ride"] = 331.52, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.7, ["Fly"] = 52.75, ["Ride"] = 19.69, ["Fly|Ride"] = 433.4, ["Neon"] = 29.89, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 307.68, ["Mega|Ride"] = 287.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.04, ["Fly"] = 131.25, ["Ride"] = 25.08, ["Fly|Ride"] = 70.88, ["Neon"] = 37.85, ["Neon|Fly"] = 130.04, ["Neon|Ride"] = 43.65, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 306.51, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 406.08}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 23.63, ["Fly|Ride"] = 52.41, ["Neon"] = 22.23, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 108.34, ["Mega"] = 260.02, ["Mega|Ride"] = 216.68, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 46.76, ["Fly|Ride"] = 180.95, ["Neon"] = 11.46, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 98.39, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.9, ["Fly"] = 100.78, ["Ride"] = 105, ["Fly|Ride"] = 375.38, ["Neon"] = 160.55, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 650.02, ["Mega|Ride"] = 655.09, ["Mega|Fly|Ride"] = 702.28}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.28, ["Fly"] = 164.07, ["Ride"] = 89.96, ["Fly|Ride"] = 91.88, ["Neon"] = 248.07, ["Neon|Ride"] = 270.14, ["Neon|Fly|Ride"] = 371.23, ["Mega"] = 1589.01, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1106.89}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.1, ["Ride"] = 21.56, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 24.52, ["Mega|Ride"] = 71.03, ["Mega|Fly|Ride"] = 140.96}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.59, ["Ride"] = 78.75, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1141.85}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 48.2, ["Ride"] = 91.92, ["Neon"] = 262.5, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 865.6, ["Mega"] = 1212.31, ["Mega|Ride"] = 1227.05, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.81, ["Fly"] = 190.32, ["Ride"] = 36.66, ["Fly|Ride"] = 133.88, ["Neon"] = 43.36, ["Neon|Fly"] = 131.32, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.85, ["Mega"] = 264.5, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.76, ["Fly|Ride"] = 131.25, ["Neon"] = 10.18, ["Neon|Ride"] = 68.25, ["Mega"] = 104.9, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 145.39, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.8, ["Ride"] = 18.78, ["Fly|Ride"] = 57.96, ["Neon"] = 6.51, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 236.25, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 433.35}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 14.69, ["Ride"] = 16.7, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Fly"] = 34.69, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 25.77, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.95, ["Fly|Ride"] = 48.97, ["Neon"] = 3.73, ["Neon|Ride"] = 24.3, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 39.16, ["Mega|Fly"] = 145.81, ["Mega|Ride"] = 84.51, ["Mega|Fly|Ride"] = 270.85}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.24, ["Neon|Ride"] = 145.08, ["Mega"] = 28.18, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.66, ["Ride"] = 104.99, ["Neon"] = 42, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 427.93, ["Mega|Ride"] = 364.43, ["Mega|Fly|Ride"] = 427.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.56, ["Ride"] = 30.19, ["Fly|Ride"] = 215.95, ["Neon"] = 58.46, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 262.5, ["Mega|Ride"] = 289.27, ["Mega|Fly|Ride"] = 433.35}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.64, ["Fly"] = 19.59, ["Ride"] = 19.85, ["Fly|Ride"] = 39.89, ["Neon"] = 28.88, ["Neon|Ride"] = 35.38, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 351.02, ["Mega|Ride"] = 294.51, ["Mega|Fly|Ride"] = 381.54}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.89, ["Ride"] = 88.54, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 289.27, ["Neon|Fly|Ride"] = 722.6, ["Mega"] = 2454.08, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.74, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 78.75, ["Neon"] = 145.2, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.94, ["Fly|Ride"] = 42.07, ["Neon"] = 2.92, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 20.75, ["Neon|Fly|Ride"] = 53.62, ["Mega|Fly"] = 145.19, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.43, ["Fly|Ride"] = 31.82, ["Neon"] = 3.52, ["Neon|Fly"] = 29.27, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 43.29, ["Mega"] = 43.32, ["Mega|Ride"] = 49.37, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 522.38, ["Fly"] = 573.03, ["Ride"] = 441.83, ["Fly|Ride"] = 510.57, ["Neon|Fly|Ride"] = 2019.34, ["Mega|Fly|Ride"] = 6861.86}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 2.1, ["Fly"] = 115.96, ["Ride"] = 47.7, ["Neon"] = 23.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 650.02, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 16.27, ["Ride"] = 19.52, ["Fly|Ride"] = 34.04, ["Neon"] = 10.29, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 63.94, ["Mega|Ride"] = 84.51, ["Mega|Fly|Ride"] = 114.03}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.64, ["Ride"] = 98.44, ["Fly|Ride"] = 223.13, ["Neon"] = 194.25, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 737.63, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 930.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 21, ["Fly|Ride"] = 56.35, ["Neon"] = 14.42, ["Neon|Fly"] = 80.18, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 83.27, ["Mega"] = 1963.26, ["Mega|Ride"] = 188.55, ["Mega|Fly|Ride"] = 233.61}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 58.52, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 101.87, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 21.36, ["Mega|Ride"] = 72.6, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.17, ["Fly"] = 129.94, ["Ride"] = 78.75, ["Fly|Ride"] = 215.73, ["Neon"] = 210.21, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 390.02, ["Mega"] = 818.44, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 23.55, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 3.75, ["Neon|Ride"] = 39.38, ["Mega"] = 52.5, ["Mega|Ride"] = 157.25, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 23.63, ["Ride"] = 60.9, ["Fly|Ride"] = 105, ["Neon"] = 150.62, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1300.02, ["Mega|Fly|Ride"] = 1228.52}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Fly"] = 72.61, ["Ride"] = 131.25, ["Fly|Ride"] = 433.4, ["Neon"] = 18.38, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 505.93, ["Mega"] = 164.24, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.41, ["Fly"] = 72.61, ["Ride"] = 74.25, ["Fly|Ride"] = 58.52, ["Neon"] = 10.08, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 115.92, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 305.52}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 50.3, ["Fly"] = 86.7, ["Ride"] = 65.63, ["Fly|Ride"] = 541.74, ["Neon"] = 359.63, ["Neon|Ride"] = 419.27, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2023.68}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.46, ["Ride"] = 39.38, ["Neon"] = 6.19, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 45.92, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 140.85, ["Mega|Fly|Ride"] = 245.93}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 17.2, ["Ride"] = 19.4, ["Fly|Ride"] = 99.79, ["Neon"] = 8.59, ["Neon|Fly"] = 42, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 59.13, ["Mega|Fly"] = 150.93, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.57, ["Fly"] = 57.91, ["Ride"] = 26.25, ["Fly|Ride"] = 173.38, ["Neon"] = 80.07, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 160.35, ["Mega"] = 328.12, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 3.62, ["Fly"] = 65.63, ["Ride"] = 28.53, ["Fly|Ride"] = 70.02, ["Neon"] = 52.49, ["Neon|Ride"] = 77.21, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 758.36, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 862.35}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.48, ["Fly"] = 48.57, ["Ride"] = 28.68, ["Fly|Ride"] = 65.63, ["Neon"] = 80.56, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 154.07, ["Mega"] = 408.98, ["Mega|Ride"] = 327.44, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 63.66, ["Fly"] = 107.31, ["Ride"] = 122.4, ["Fly|Ride"] = 246.75, ["Neon"] = 308.43, ["Neon|Ride"] = 283.48, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1575, ["Mega|Ride"] = 1408.35, ["Mega|Fly|Ride"] = 1567.6}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.1, ["Ride"] = 115.4, ["Fly|Ride"] = 203.44, ["Neon"] = 56, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 239.09, ["Mega|Fly"] = 575.26, ["Mega|Ride"] = 384.6, ["Mega|Fly|Ride"] = 561.1}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.63, ["Ride"] = 27.29, ["Fly|Ride"] = 78.74, ["Neon"] = 23.08, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 145.19, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.06, ["Fly"] = 135.19, ["Ride"] = 36.36, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 60.8, ["Mega"] = 458.92, ["Mega|Fly|Ride"] = 866.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.49, ["Fly|Ride"] = 42.76, ["Neon"] = 2.1, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 15.32, ["Mega|Ride"] = 26.78, ["Mega|Fly|Ride"] = 114.33}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.97, ["Fly"] = 229.73, ["Ride"] = 103.69, ["Fly|Ride"] = 143.36, ["Neon"] = 236.25, ["Neon|Fly"] = 2456.22, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 1309.25, ["Mega"] = 1080.11, ["Mega|Ride"] = 1070.35, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 112.22, ["Neon"] = 5.99, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 87.13, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 13.13, ["Fly|Ride"] = 45.94, ["Neon"] = 13.13, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.45, ["Ride"] = 82.68, ["Fly|Ride"] = 229.87, ["Neon"] = 225.65, ["Neon|Ride"] = 259.88, ["Mega"] = 1146.06, ["Mega|Ride"] = 1765.32, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.16, ["Neon|Ride"] = 1445.18, ["Mega"] = 123.52, ["Mega|Ride"] = 115.4, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.71}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 25.38, ["Fly|Ride"] = 65.02, ["Neon"] = 4.25, ["Neon|Ride"] = 84.56, ["Neon|Fly|Ride"] = 115.29, ["Mega"] = 78.74, ["Mega|Ride"] = 105.23, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.04, ["Ride"] = 241.65, ["Fly|Ride"] = 340.23, ["Neon"] = 884.12, ["Neon|Ride"] = 611.1, ["Neon|Fly|Ride"] = 671.77, ["Mega"] = 6500.03, ["Mega|Ride"] = 2889.27, ["Mega|Fly|Ride"] = 2642.28}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 36.47, ["Fly|Ride"] = 216.7, ["Neon"] = 22.2, ["Neon|Fly"] = 145.2, ["Neon|Ride"] = 63.94, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 153.57, ["Mega|Ride"] = 216.68, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Ride"] = 24.93, ["Mega"] = 33.6, ["Mega|Ride"] = 72.61, ["Mega|Fly|Ride"] = 346.76}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.76, ["Fly"] = 18.38, ["Ride"] = 32.48, ["Fly|Ride"] = 98.44, ["Neon"] = 57.08, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 151.4, ["Mega"] = 433.35, ["Mega|Ride"] = 433.35, ["Mega|Fly|Ride"] = 648.94}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.6, ["Fly"] = 59.69, ["Ride"] = 22.31, ["Fly|Ride"] = 58.52, ["Neon"] = 101.03, ["Neon|Ride"] = 158.17, ["Neon|Fly|Ride"] = 276.29, ["Mega"] = 323.93, ["Mega|Ride"] = 644.6, ["Mega|Fly|Ride"] = 575.26}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.02, ["Fly"] = 145.21, ["Ride"] = 51.98, ["Fly|Ride"] = 177.19, ["Neon"] = 181.59, ["Neon|Ride"] = 202.6, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 561.75, ["Mega|Ride"] = 650.02, ["Mega|Fly|Ride"] = 571.6}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 155.13, ["Fly"] = 157.5, ["Ride"] = 157.5, ["Fly|Ride"] = 241.79, ["Neon"] = 565.13, ["Neon|Fly"] = 695.66, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 462.9, ["Mega|Ride"] = 2600.03, ["Mega|Fly|Ride"] = 2455.93}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 3.47, ["Fly"] = 20.98, ["Ride"] = 19.89, ["Fly|Ride"] = 34.8, ["Neon"] = 45.7, ["Neon|Fly"] = 160.71, ["Neon|Ride"] = 45.28, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.71, ["Fly"] = 131.23, ["Ride"] = 26.65, ["Fly|Ride"] = 131.25, ["Neon"] = 20.69, ["Neon|Ride"] = 35.81, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.8, ["Mega|Ride"] = 185.27, ["Mega|Fly|Ride"] = 291.98}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.67, ["Fly"] = 42.78, ["Ride"] = 37.69, ["Fly|Ride"] = 130.04, ["Neon"] = 50.21, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 164.43, ["Mega"] = 429.66, ["Mega|Ride"] = 414.41, ["Mega|Fly|Ride"] = 409.85}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.42, ["Fly"] = 115.96, ["Ride"] = 79.83, ["Fly|Ride"] = 134.37, ["Neon"] = 170.61, ["Neon|Ride"] = 164.43, ["Neon|Fly|Ride"] = 277.74, ["Mega"] = 969.6, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.1}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.69, ["Fly"] = 57.75, ["Ride"] = 72.61, ["Neon"] = 196.88, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 477.77, ["Mega"] = 809.46, ["Mega|Ride"] = 1932}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 328.02, ["Ride"] = 578.59, ["Neon|Ride"] = 3272.51}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 17.43, ["Fly"] = 58.63, ["Ride"] = 33.76, ["Fly|Ride"] = 69.3, ["Neon"] = 165.64, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 201.52, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 1104.34}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 43.35, ["Ride"] = 12.48, ["Fly|Ride"] = 72.6, ["Neon"] = 2.1, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 21.2, ["Mega|Fly"] = 114.85, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 115.64}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.19, ["Neon"] = 12.88, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 115.92, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.19, ["Fly"] = 32.51, ["Ride"] = 30.19, ["Fly|Ride"] = 144.2, ["Neon"] = 21.18, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 130.56, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 323.93, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 537.68, ["Neon"] = 1898.49, ["Neon|Ride"] = 2077.85, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Ride"] = 16.69, ["Fly|Ride"] = 86.7, ["Neon"] = 26.25, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 206.07, ["Mega|Ride"] = 181.61, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.93, ["Fly"] = 22.32, ["Ride"] = 19.5, ["Fly|Ride"] = 44.37, ["Neon"] = 29.27, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 60.68, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 164.43, ["Mega|Ride"] = 293.61, ["Mega|Fly|Ride"] = 318.28}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 45.82, ["Ride"] = 23.63, ["Fly|Ride"] = 52.92, ["Neon"] = 11.97, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 109.6, ["Mega"] = 145.19, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.66, ["Fly"] = 49.09, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 323.93, ["Mega"] = 722.6, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 54.2, ["Ride"] = 51.19, ["Fly|Ride"] = 51.75, ["Neon"] = 11.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 4.74, ["Fly"] = 65.62, ["Ride"] = 49.86, ["Fly|Ride"] = 101.87, ["Neon"] = 168.9, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 748.13, ["Mega|Fly|Ride"] = 787.6}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Neon"] = 3.83, ["Neon|Ride"] = 25.83, ["Neon|Fly|Ride"] = 98.18, ["Mega"] = 54.85, ["Mega|Ride"] = 118.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.86, ["Fly"] = 72.19, ["Ride"] = 145.2, ["Neon"] = 46.69, ["Mega"] = 136.02, ["Mega|Ride"] = 327.63, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.39, ["Ride"] = 43.2, ["Neon"] = 65.02, ["Neon|Ride"] = 289.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 319.6, ["Mega|Ride"] = 562.71, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.25, ["Fly"] = 37.91, ["Ride"] = 22.83, ["Fly|Ride"] = 54.69, ["Neon"] = 55.02, ["Neon|Fly"] = 115.36, ["Neon|Ride"] = 54.57, ["Neon|Fly|Ride"] = 126.04, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 445.7, ["Fly"] = 525.49, ["Ride"] = 471.68, ["Fly|Ride"] = 482.9, ["Neon"] = 1642.41, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 39.35, ["Neon"] = 35.44, ["Neon|Fly"] = 82.22, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 184.42, ["Mega"] = 231.84, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 307.99}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Fly"] = 65.03, ["Ride"] = 65.02, ["Fly|Ride"] = 188.64, ["Neon"] = 102.61, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 359.63, ["Mega|Fly"] = 722.6, ["Mega|Ride"] = 420}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 19.66, ["Ride"] = 94.5, ["Fly|Ride"] = 323.99, ["Neon"] = 122.14, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 366.09, ["Mega"] = 239.44, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 54.57, ["Fly"] = 156.1, ["Ride"] = 94.5, ["Fly|Ride"] = 131.25, ["Neon"] = 321.57, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2517.26, ["Mega|Ride"] = 2890.86, ["Mega|Fly|Ride"] = 1793.58}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.45, ["Ride"] = 41.91, ["Fly|Ride"] = 144.37, ["Neon"] = 33.08, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 144.27, ["Mega|Ride"] = 193.85, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 18.38, ["Fly|Ride"] = 58.47, ["Neon"] = 18.11, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 65.62, ["Mega|Ride"] = 196.33, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.84, ["Ride"] = 45.57, ["Neon"] = 22.2, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 190.97, ["Mega"] = 140.44, ["Mega|Fly"] = 244.85, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 273.37}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 41.72, ["Fly"] = 183.73, ["Ride"] = 94.5, ["Fly|Ride"] = 183.74, ["Neon"] = 133.42, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 252, ["Mega"] = 441, ["Mega|Ride"] = 438.27, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 84.41, ["Neon"] = 6.29, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 44.5, ["Mega|Fly"] = 165.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 433.35}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 21.69, ["Ride"] = 185.06, ["Neon"] = 173.25, ["Neon|Ride"] = 374.07, ["Mega"] = 589.32, ["Mega|Fly|Ride"] = 808.19}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 1194.38, ["Ride"] = 1006.69, ["Fly|Ride"] = 1123.5, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11078.21}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 7.67, ["Fly"] = 112.17, ["Ride"] = 43.36, ["Fly|Ride"] = 168.05, ["Neon"] = 64.31, ["Neon|Fly"] = 721.6, ["Neon|Ride"] = 174.01, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 448.87, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 600.18}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.91, ["Fly|Ride"] = 90.57, ["Neon"] = 11.19, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 81.38, ["Mega|Ride"] = 87.74, ["Mega|Fly|Ride"] = 201.52}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.84, ["Ride"] = 131.25, ["Fly|Ride"] = 145.2, ["Neon"] = 73.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 430.5, ["Mega|Fly|Ride"] = 488.37}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.39, ["Fly|Ride"] = 187.7, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 15.44, ["Mega|Ride"] = 49.31, ["Mega|Fly|Ride"] = 157.87}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 38.66, ["Ride"] = 91.88, ["Fly|Ride"] = 266.44, ["Neon"] = 226.95, ["Neon|Ride"] = 268.94, ["Neon|Fly|Ride"] = 458.27, ["Mega"] = 943.05, ["Mega|Ride"] = 879.37, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.53, ["Ride"] = 62.88, ["Fly|Ride"] = 286.75, ["Neon"] = 115.95, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 830.94, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 23.62, ["Neon"] = 9.98, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 216.68, ["Mega"] = 98.18, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 375.93}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.91, ["Fly"] = 52.5, ["Ride"] = 38.18, ["Fly|Ride"] = 91.77, ["Neon"] = 73.38, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 271.19, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 2.99, ["Fly"] = 97.54, ["Ride"] = 34.04, ["Fly|Ride"] = 173.37, ["Neon"] = 39.02, ["Neon|Fly"] = 131.29, ["Neon|Ride"] = 82.23, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 578.51, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 53.17, ["Ride"] = 91.88, ["Neon"] = 216.7, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2127.68, ["Mega|Ride"] = 2454.08, ["Mega|Fly|Ride"] = 2164.52}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.67, ["Fly|Ride"] = 112.88, ["Neon"] = 11.69, ["Neon|Ride"] = 92.05, ["Neon|Fly|Ride"] = 160.35, ["Mega"] = 70.87, ["Mega|Ride"] = 181.61, ["Mega|Fly|Ride"] = 230.9}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.66, ["Ride"] = 31.16, ["Fly|Ride"] = 87.85, ["Neon"] = 45.09, ["Neon|Fly"] = 188.53, ["Neon|Ride"] = 69.22, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 210, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 382.53}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 111.19, ["Fly"] = 393.75, ["Ride"] = 144.38, ["Fly|Ride"] = 183.75, ["Neon"] = 432.99, ["Neon|Ride"] = 543.17, ["Neon|Fly|Ride"] = 636.38, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2072.51}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 17.37, ["Fly|Ride"] = 43.3, ["Neon"] = 15.65, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 122.14, ["Mega"] = 137.82, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 18.08, ["Fly"] = 201.38, ["Ride"] = 61.15, ["Fly|Ride"] = 131.25, ["Neon"] = 116.7, ["Neon|Ride"] = 140.04, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 643.13, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 678.27}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 11.95, ["Fly|Ride"] = 59.07, ["Neon"] = 2.1, ["Neon|Fly"] = 28.25, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.74, ["Mega|Fly"] = 49.09, ["Mega|Ride"] = 33.99, ["Mega|Fly|Ride"] = 86.71}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.52, ["Neon"] = 4.27, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 130.03, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.85, ["Ride"] = 19.28, ["Fly|Ride"] = 173.35, ["Neon"] = 16.41, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 29.58, ["Ride"] = 65.02, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 346.68, ["Neon|Fly|Ride"] = 420.13, ["Mega"] = 511.88, ["Mega|Ride"] = 648.94, ["Mega|Fly|Ride"] = 866.69}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 15.7, ["Fly|Ride"] = 35.32, ["Neon"] = 11.81, ["Neon|Fly"] = 37.59, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 120.65, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 173.65}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.23, ["Fly"] = 43.24, ["Ride"] = 32.81, ["Fly|Ride"] = 101.14, ["Neon"] = 43.32, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 254.63, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 334.66}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 20.6, ["Fly|Ride"] = 67.92, ["Neon"] = 11.62, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.23, ["Mega|Fly"] = 82.23, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 144.15}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 5.86, ["Fly"] = 169.32, ["Ride"] = 24.68, ["Fly|Ride"] = 217.2, ["Neon"] = 37.21, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 262.5, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 405.19, ["Mega|Fly|Ride"] = 422.51}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.03, ["Ride"] = 189.93, ["Fly|Ride"] = 142.38, ["Neon"] = 51.08, ["Neon|Ride"] = 254.63, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 216.68, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.43, ["Fly"] = 37.79, ["Ride"] = 20.91, ["Fly|Ride"] = 51.45, ["Neon"] = 35.44, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 145.3, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 578.51}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.87, ["Ride"] = 19.35, ["Fly|Ride"] = 52.55, ["Neon"] = 16.96, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 189.6, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.76, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 392.43, ["Neon"] = 1282.83, ["Neon|Ride"] = 1227.05, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4254.13, ["Mega|Fly|Ride"] = 4117.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.03, ["Ride"] = 65.63, ["Neon"] = 28.4, ["Neon|Ride"] = 45.94, ["Mega"] = 123.38, ["Mega|Ride"] = 655.06, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.65, ["Fly"] = 108.38, ["Ride"] = 24.68, ["Fly|Ride"] = 86.63, ["Neon"] = 29.89, ["Neon|Fly"] = 245.97, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 229.87, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.63, ["Fly|Ride"] = 216.74, ["Neon"] = 39.22, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 486.29, ["Mega|Ride"] = 409.85, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 14.14, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 43.36, ["Neon|Ride"] = 18.31, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 18.98, ["Mega|Fly"] = 81.26, ["Mega|Ride"] = 42.96, ["Mega|Fly|Ride"] = 72.17}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 44.88, ["Ride"] = 23.6, ["Fly|Ride"] = 41.19, ["Neon"] = 18.06, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 132.57, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 10.4, ["Neon|Ride"] = 288.18, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 49.08, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.39, ["Fly"] = 104.99, ["Ride"] = 98.42, ["Fly|Ride"] = 158.4, ["Neon"] = 315, ["Neon|Fly"] = 541.08, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 477.75, ["Mega|Ride"] = 3612.94, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.61, ["Fly"] = 72.61, ["Ride"] = 26.02, ["Fly|Ride"] = 141.73, ["Neon"] = 21.83, ["Neon|Ride"] = 68.15, ["Mega"] = 169.3, ["Mega|Ride"] = 213.94}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.86, ["Ride"] = 34.12, ["Neon"] = 6.99, ["Neon|Ride"] = 82.23, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 55.21, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.3, ["Fly"] = 131.25, ["Ride"] = 91.88, ["Fly|Ride"] = 199.5, ["Neon"] = 140.6, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 525, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 681.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 19.15, ["Fly|Ride"] = 44.62, ["Neon"] = 2.1, ["Neon|Fly"] = 21.84, ["Neon|Ride"] = 16.64, ["Neon|Fly|Ride"] = 37.72, ["Mega"] = 17.06, ["Mega|Fly"] = 48.37, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 98.34}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 46.86, ["Fly|Ride"] = 99.69, ["Neon"] = 2.1, ["Neon|Ride"] = 30.07, ["Neon|Fly|Ride"] = 141.45, ["Mega"] = 24.43, ["Mega|Fly"] = 145.19, ["Mega|Ride"] = 78.56, ["Mega|Fly|Ride"] = 224.56}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Fly"] = 33.12, ["Ride"] = 66.23, ["Fly|Ride"] = 59.01, ["Neon"] = 7.58, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 51.86, ["Mega|Fly"] = 188.51, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 270.36}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.39, ["Fly"] = 39.38, ["Ride"] = 42.76, ["Fly|Ride"] = 130.56, ["Neon"] = 20.36, ["Neon|Fly"] = 122.31, ["Neon|Ride"] = 95.1, ["Neon|Fly|Ride"] = 433.35, ["Mega"] = 136.28, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 13.49, ["Fly|Ride"] = 45.52, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 49.85, ["Mega"] = 19.03, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 117.79}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 128.63, ["Neon|Ride"] = 196.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 722.6, ["Mega|Fly"] = 650.02, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 800.61}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2546.45, ["Fly"] = 3150, ["Ride"] = 2383.24, ["Fly|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44958.42}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 18.53, ["Fly|Ride"] = 50.47, ["Neon"] = 7.54, ["Neon|Fly"] = 58.46, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 82.23, ["Mega|Fly"] = 433.35, ["Mega|Ride"] = 97.55, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.18, ["Neon"] = 8.81, ["Mega"] = 103.8, ["Mega|Fly"] = 441, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 433.35}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.41, ["Fly"] = 145.21, ["Ride"] = 32.82, ["Fly|Ride"] = 45.52, ["Neon"] = 81.37, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 393.75, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 573.61}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 33.86, ["Fly"] = 108.38, ["Ride"] = 66.75, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Mega"] = 1300.21, ["Mega|Ride"] = 619.68, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 135.8, ["Fly"] = 1445.52, ["Ride"] = 183.64, ["Fly|Ride"] = 275.09, ["Neon"] = 647.07, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6500.03, ["Mega|Fly|Ride"] = 4160.63}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.82, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 26.23, ["Neon|Ride"] = 145.19, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 433.35}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.86, ["Neon"] = 14.74, ["Neon|Fly"] = 94.28, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.88, ["Ride"] = 33.49, ["Fly|Ride"] = 75.86, ["Neon"] = 12.89, ["Neon|Fly"] = 127.86, ["Neon|Ride"] = 36.39, ["Mega"] = 60.37, ["Mega|Ride"] = 118.9, ["Mega|Fly|Ride"] = 227.39}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.08, ["Ride"] = 51.89, ["Fly|Ride"] = 131.25, ["Neon"] = 115.34, ["Neon|Ride"] = 179.17, ["Neon|Fly|Ride"] = 510.26, ["Mega"] = 420, ["Mega|Ride"] = 325.17, ["Mega|Fly|Ride"] = 591.29}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 37.86, ["Mega"] = 32.82, ["Mega|Fly"] = 122.72, ["Mega|Ride"] = 77.57, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 92.26, ["Fly"] = 202.65, ["Ride"] = 127.31, ["Fly|Ride"] = 137.71, ["Neon"] = 271.97, ["Neon|Fly"] = 463.74, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 450.34, ["Mega"] = 3250.02, ["Mega|Fly|Ride"] = 1437.6}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 91.84, ["Fly|Ride"] = 78.75, ["Neon"] = 9.12, ["Neon|Ride"] = 144.65, ["Neon|Fly|Ride"] = 216.68, ["Mega"] = 62.37, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.89, ["Fly"] = 145.21, ["Ride"] = 101.89, ["Fly|Ride"] = 170.62, ["Neon"] = 229.06, ["Neon|Ride"] = 361.85, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 2625, ["Mega|Ride"] = 2023.68, ["Mega|Fly|Ride"] = 1589.27}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 23.21, ["Fly|Ride"] = 52.75, ["Neon"] = 4.66, ["Neon|Fly"] = 85.89, ["Neon|Ride"] = 72.6, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 58.51, ["Mega|Fly"] = 147.27, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 145.59}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 11.4, ["Neon|Ride"] = 111.57, ["Mega"] = 62.93, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.97, ["Fly"] = 77.43, ["Ride"] = 38.19, ["Fly|Ride"] = 90.57, ["Neon"] = 19.69, ["Neon|Ride"] = 72.45, ["Mega"] = 415.17, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 541.68}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 359.62, ["Fly"] = 736.21, ["Ride"] = 420, ["Fly|Ride"] = 510.57, ["Neon"] = 918.74, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 3829.61, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 3114.56}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.41, ["Fly"] = 86.7, ["Ride"] = 47.14, ["Fly|Ride"] = 116.82, ["Neon"] = 154.52, ["Neon|Ride"] = 216.68, ["Neon|Fly|Ride"] = 192.31, ["Mega|Ride"] = 1155.94, ["Mega|Fly|Ride"] = 1068.19}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 31.5, ["Fly|Ride"] = 122.22, ["Neon"] = 22.32, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 36.12, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.31, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 19.57, ["Fly"] = 111.57, ["Ride"] = 62.91, ["Fly|Ride"] = 227.06, ["Neon"] = 74.08, ["Neon|Fly"] = 177.19, ["Neon|Ride"] = 145.59, ["Neon|Fly|Ride"] = 240.19, ["Mega"] = 390.02, ["Mega|Fly"] = 1009.86, ["Mega|Ride"] = 433.35, ["Mega|Fly|Ride"] = 513.18}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.17, ["Ride"] = 32.8, ["Neon"] = 101.36, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 490.83, ["Mega"] = 630, ["Mega|Ride"] = 691.69, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.55, ["Neon"] = 26.25, ["Mega"] = 79.63, ["Mega|Ride"] = 332.68, ["Mega|Fly|Ride"] = 432.27}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.35, ["Fly"] = 72.61, ["Ride"] = 22.31, ["Fly|Ride"] = 65.62, ["Neon"] = 56.97, ["Neon|Fly"] = 86.69, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 213.94, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 85.31, ["Ride"] = 119.43, ["Fly|Ride"] = 229.32, ["Neon"] = 819.12, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.98, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3027.1}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.72, ["Ride"] = 54.44, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 173.35, ["Neon|Fly|Ride"] = 320.25, ["Mega"] = 1155.94, ["Mega|Ride"] = 711.69, ["Mega|Fly|Ride"] = 818.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1836.19, ["Fly"] = 2311.32, ["Ride"] = 1706.25, ["Fly|Ride"] = 1896.57, ["Neon"] = 11557.32, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 72.19, ["Fly|Ride"] = 196.87, ["Neon"] = 19.69, ["Neon|Ride"] = 52.02, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 144.37, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 208.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.31, ["Ride"] = 52.5, ["Fly|Ride"] = 180.95, ["Neon"] = 23.92, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 42.26, ["Mega"] = 144.38, ["Mega|Fly"] = 289.27, ["Mega|Ride"] = 230, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.27, ["Fly"] = 1502.96, ["Ride"] = 918.65, ["Fly|Ride"] = 990.93, ["Neon"] = 2778.57, ["Neon|Ride"] = 3358.36, ["Neon|Fly|Ride"] = 2891.42, ["Mega|Ride"] = 13907.17, ["Mega|Fly|Ride"] = 11685.95}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 32.73, ["Ride"] = 46.6, ["Fly|Ride"] = 173.35, ["Neon"] = 238.88, ["Neon|Ride"] = 216.68, ["Mega"] = 857.2, ["Mega|Ride"] = 851.82, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 118.13, ["Neon"] = 12.29, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 145.2, ["Neon"] = 3.78, ["Neon|Fly"] = 126, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 112.68, ["Mega"] = 23.24, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 164.43}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.74, ["Ride"] = 126.77, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2454.08, ["Mega|Fly|Ride"] = 2311.85}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.69, ["Fly|Ride"] = 75.86, ["Neon"] = 11.81, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 122.72, ["Mega"] = 90.56, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.64, ["Fly"] = 145.21, ["Ride"] = 102.09, ["Fly|Ride"] = 289.3, ["Neon"] = 433.4, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1769.39}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 8.49, ["Fly"] = 105, ["Fly|Ride"] = 130.04, ["Neon"] = 59.06, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.05, ["Mega"] = 328.02, ["Mega|Ride"] = 145.19}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 233.89, ["Ride"] = 279.56, ["Fly|Ride"] = 320.25, ["Neon"] = 1137.32, ["Neon|Fly"] = 1063.73, ["Neon|Ride"] = 1077.93, ["Neon|Fly|Ride"] = 995.76, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.61, ["Fly"] = 91.88, ["Ride"] = 26.25, ["Fly|Ride"] = 112.88, ["Neon"] = 56.54, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 262.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 289.12}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 16.02, ["Fly|Ride"] = 36.39, ["Neon"] = 3.63, ["Neon|Fly"] = 37.57, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 59.77, ["Mega"] = 44.62, ["Mega|Fly"] = 108.34, ["Mega|Ride"] = 71.39, ["Mega|Fly|Ride"] = 124.72}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1242.89, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7945.19, ["Neon|Fly|Ride"] = 7041.69, ["Mega"] = 24540.62, ["Mega|Fly|Ride"] = 28889.32}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.09, ["Ride"] = 72.19, ["Neon"] = 102.52, ["Neon|Ride"] = 314.98, ["Mega"] = 320.25, ["Mega|Ride"] = 418.59, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.89, ["Fly"] = 39.38, ["Ride"] = 36.74, ["Fly|Ride"] = 81.23, ["Neon"] = 21, ["Neon|Fly"] = 102.94, ["Neon|Ride"] = 55.02, ["Neon|Fly|Ride"] = 130.03, ["Mega"] = 143.58, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 283.26}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 22.49, ["Fly"] = 47.25, ["Ride"] = 40.16, ["Fly|Ride"] = 77.35, ["Neon"] = 173.15, ["Neon|Ride"] = 188.55, ["Neon|Fly|Ride"] = 192.02, ["Mega"] = 2600.03, ["Mega|Ride"] = 1146.06, ["Mega|Fly|Ride"] = 770.94}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.92, ["Fly"] = 71.53, ["Ride"] = 30.23, ["Fly|Ride"] = 78.75, ["Neon"] = 59.06, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 59.06, ["Fly|Ride"] = 509.24, ["Neon"] = 236.25, ["Neon|Fly"] = 489.74, ["Neon|Ride"] = 315, ["Mega"] = 3900.02, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 289.3, ["Neon"] = 2.1, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 111.88, ["Neon|Fly|Ride"] = 108.34, ["Mega"] = 16.89, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 84.45, ["Fly"] = 128.37, ["Ride"] = 91.87, ["Fly|Ride"] = 183.75, ["Neon"] = 541.08, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3466.7, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.88, ["Fly"] = 107.63, ["Ride"] = 19.68, ["Fly|Ride"] = 66.68, ["Neon"] = 198.19, ["Neon|Ride"] = 114.85, ["Mega"] = 773.71, ["Mega|Ride"] = 437.73, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 15.75, ["Neon|Fly"] = 82.22, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 106.77, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 19.52, ["Neon|Fly"] = 143.04, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 72.03, ["Fly"] = 247.55, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 463.67, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2023.68, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.77, ["Ride"] = 18.38, ["Fly|Ride"] = 433.4, ["Neon"] = 19.3, ["Neon|Ride"] = 59.07, ["Mega"] = 138.68, ["Mega|Ride"] = 164.43, ["Mega|Fly|Ride"] = 327.63}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.79, ["Neon"] = 2.1, ["Neon|Ride"] = 120.26, ["Mega"] = 16.94, ["Mega|Ride"] = 213, ["Mega|Fly|Ride"] = 541.68}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 32.81, ["Fly|Ride"] = 144.44, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.06, ["Mega|Fly"] = 55.63, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 164.06}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18, ["Fly|Ride"] = 52.47, ["Neon"] = 4.34, ["Neon|Ride"] = 29.46, ["Neon|Fly|Ride"] = 50.93, ["Mega"] = 61.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.49, ["Neon"] = 24.36, ["Mega"] = 118.11, ["Mega|Ride"] = 123.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.35, ["Ride"] = 16.91, ["Fly|Ride"] = 25.99, ["Neon"] = 13.96, ["Neon|Fly"] = 86.69, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 178.5, ["Mega|Ride"] = 141.92, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.58, ["Ride"] = 108.04, ["Fly|Ride"] = 379.22, ["Neon"] = 289.38, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 1083.35, ["Mega"] = 563.34, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1146.06}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.6, ["Fly|Ride"] = 41.89, ["Neon"] = 2.1, ["Neon|Fly"] = 32.24, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 144.38, ["Mega|Ride"] = 131.1, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.56, ["Fly"] = 78.86, ["Ride"] = 32.81, ["Fly|Ride"] = 72.19, ["Neon"] = 42.25, ["Neon|Fly"] = 89.11, ["Neon|Ride"] = 49.09, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 295.32, ["Mega|Fly"] = 578.51, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 12.98, ["Fly"] = 38.06, ["Ride"] = 49.08, ["Fly|Ride"] = 125.24, ["Neon"] = 178, ["Neon|Fly"] = 147, ["Neon|Ride"] = 123.23, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 722.6, ["Mega|Ride"] = 825.28, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.34, ["Fly"] = 196.88, ["Neon"] = 80.01, ["Neon|Ride"] = 103.69, ["Mega"] = 525, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.23, ["Ride"] = 17.05, ["Fly|Ride"] = 38.98, ["Neon"] = 3.56, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 45.34, ["Mega|Ride"] = 150.93, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.06, ["Fly"] = 39.38, ["Ride"] = 38.07, ["Neon"] = 73.84, ["Neon|Ride"] = 130.03, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 275.63, ["Mega|Fly"] = 371.59, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 549.27}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 997.49, ["Fly"] = 1391.43, ["Ride"] = 980.3, ["Fly|Ride"] = 1048.69, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2377.86, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 187.68, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 840, ["Neon|Ride"] = 818.44, ["Neon|Fly|Ride"] = 989.63, ["Mega"] = 3248.94, ["Mega|Ride"] = 3612.94, ["Mega|Fly|Ride"] = 2889.27}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.26, ["Neon|Ride"] = 72.6, ["Neon|Fly|Ride"] = 258.93, ["Mega"] = 78.51, ["Mega|Fly|Ride"] = 215.6}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 115.39, ["Ride"] = 190.31, ["Fly|Ride"] = 315, ["Neon"] = 576.19, ["Neon|Ride"] = 538.13, ["Neon|Fly|Ride"] = 777.57, ["Mega"] = 2382.28, ["Mega|Ride"] = 2023.68, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.24, ["Ride"] = 22.57, ["Neon"] = 17.49, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 289.27, ["Mega"] = 115.95, ["Mega|Ride"] = 490.83, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 253.36, ["Fly"] = 433.46, ["Ride"] = 288.74, ["Fly|Ride"] = 376.69, ["Neon|Ride"] = 1155.94, ["Neon|Fly|Ride"] = 1372.6, ["Mega|Fly|Ride"] = 4908.14}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 42.27, ["Fly|Ride"] = 223.25, ["Neon"] = 23.86, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 362.94, ["Mega|Ride"] = 433.35}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 26.25, ["Neon"] = 19.69, ["Neon|Ride"] = 49.09, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 18.1, ["Ride"] = 63.59, ["Fly|Ride"] = 140.89, ["Neon"] = 122.72, ["Neon|Fly"] = 433.4, ["Neon|Ride"] = 124.68, ["Mega"] = 783.26, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.69, ["Neon|Ride"] = 196.88, ["Mega"] = 245.42, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.08, ["Ride"] = 14.44, ["Fly|Ride"] = 32.79, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 44.56, ["Mega"] = 25.25, ["Mega|Ride"] = 38.88, ["Mega|Fly|Ride"] = 101.74}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5490.56, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32503.91, ["Neon|Fly|Ride"] = 21666.71, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.92, ["Fly"] = 86.7, ["Ride"] = 41.91, ["Neon"] = 78.75, ["Neon|Ride"] = 98.18, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 210, ["Mega|Fly"] = 346.68, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 361.85}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.69, ["Fly|Ride"] = 51.19, ["Neon"] = 15.73, ["Neon|Fly"] = 45.92, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 144.37, ["Mega|Ride"] = 196.33, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 420, ["Fly"] = 547.77, ["Ride"] = 476.43, ["Fly|Ride"] = 551.24, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1200.93, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.57, ["Ride"] = 47.58, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 187.95, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.22, ["Fly"] = 145.69, ["Ride"] = 36.85, ["Neon"] = 18.41, ["Neon|Ride"] = 121.5, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 432.27, ["Mega|Ride"] = 362.01}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.17, ["Ride"] = 29.27, ["Fly|Ride"] = 65.62, ["Neon"] = 3.72, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 36.83, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 53.82, ["Mega|Ride"] = 76.79, ["Mega|Fly|Ride"] = 196.33}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 636.56, ["Fly"] = 757.45, ["Ride"] = 674.62, ["Fly|Ride"] = 688.95, ["Neon|Ride"] = 2085.57, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 10833.36}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.38, ["Ride"] = 77.84, ["Fly|Ride"] = 162.53, ["Neon"] = 34.83, ["Neon|Fly"] = 115.92, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 210, ["Mega|Fly"] = 433.35, ["Mega|Ride"] = 231.97, ["Mega|Fly|Ride"] = 428.03}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.97, ["Fly"] = 236.25, ["Ride"] = 46.78, ["Fly|Ride"] = 104.99, ["Neon"] = 26.04, ["Neon|Ride"] = 58.58, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 167.99, ["Mega|Fly"] = 818.44, ["Mega|Ride"] = 179.3, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 33.1, ["Ride"] = 20.3, ["Fly|Ride"] = 58.24, ["Neon"] = 19.98, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.28, ["Neon|Fly|Ride"] = 82.94, ["Mega"] = 289.27, ["Mega|Fly"] = 289.27, ["Mega|Ride"] = 173.35, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 27.57, ["Fly"] = 39.38, ["Ride"] = 33.6, ["Fly|Ride"] = 58.61, ["Neon"] = 117.59, ["Neon|Ride"] = 114.18, ["Mega"] = 866.69, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 864.52}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 82.22, ["Neon"] = 6.56, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.69, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 289.27}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 649.21, ["Fly"] = 714.1, ["Ride"] = 630.19, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2311.85, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9570.85, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 74.87, ["Neon"] = 12.89, ["Neon|Ride"] = 98.99, ["Neon|Fly|Ride"] = 306.59, ["Mega"] = 98.18, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.61}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 49.06, ["Neon"] = 3.81, ["Neon|Fly"] = 245.97, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 53.81, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 3.72, ["Neon|Ride"] = 56.17, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 108.34, ["Mega|Fly"] = 160.35, ["Mega|Ride"] = 126.73, ["Mega|Fly|Ride"] = 188.51}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.44, ["Neon|Ride"] = 48.97, ["Mega"] = 237.27, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.12, ["Fly"] = 72.19, ["Ride"] = 42.39, ["Fly|Ride"] = 205.3, ["Neon"] = 103.93, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 511.88, ["Mega|Ride"] = 514.54, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.28, ["Fly"] = 131.3, ["Ride"] = 78.02, ["Fly|Ride"] = 153.87, ["Neon"] = 85.89, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 286.01, ["Mega"] = 540.6, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 549.27}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.92, ["Fly|Ride"] = 35.65, ["Neon"] = 43.35, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 89.94, ["Mega"] = 298.6, ["Mega|Ride"] = 289.27, ["Mega|Fly|Ride"] = 239.56}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 58.52, ["Fly|Ride"] = 144.79, ["Neon"] = 38.06, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 109.5, ["Neon"] = 10.49, ["Neon|Ride"] = 49.85, ["Neon|Fly|Ride"] = 145.19, ["Mega"] = 81.37, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 289.27}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21.81, ["Fly"] = 115.35, ["Ride"] = 32.8, ["Fly|Ride"] = 63.34, ["Neon"] = 110.25, ["Neon|Ride"] = 82.23, ["Neon|Fly|Ride"] = 223.79, ["Mega"] = 751.85, ["Mega|Fly|Ride"] = 757.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 31.29, ["Fly"] = 874.13, ["Neon"] = 115.95, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.18, ["Fly"] = 86.63, ["Ride"] = 86.62, ["Fly|Ride"] = 131.24, ["Neon"] = 328.13, ["Neon|Ride"] = 295.26, ["Neon|Fly|Ride"] = 390.02, ["Mega"] = 1963.26, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.79, ["Fly"] = 141.11, ["Ride"] = 72.18, ["Fly|Ride"] = 194.25, ["Neon"] = 126, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 309.74, ["Mega"] = 744.27, ["Mega|Ride"] = 838.52, ["Mega|Fly|Ride"] = 849.19}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 14.27, ["Ride"] = 36.85, ["Neon"] = 131.25, ["Neon|Ride"] = 223.12, ["Mega"] = 671.2, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 816.85}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.67, ["Fly"] = 127.22, ["Ride"] = 78.75, ["Fly|Ride"] = 253.55, ["Neon"] = 145.26, ["Neon|Fly"] = 420, ["Neon|Ride"] = 242.95, ["Neon|Fly|Ride"] = 346.68, ["Mega"] = 687.42, ["Mega|Ride"] = 644.61, ["Mega|Fly|Ride"] = 715.52}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.71, ["Ride"] = 16, ["Fly|Ride"] = 32.78, ["Neon"] = 3.49, ["Neon|Fly"] = 28.18, ["Neon|Ride"] = 29.22, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 52.02, ["Mega|Fly"] = 327.63, ["Mega|Ride"] = 90.81, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.25}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 65.62, ["Fly"] = 490.81, ["Ride"] = 131.25, ["Fly|Ride"] = 330.75, ["Neon"] = 485.63, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1443.75, ["Mega|Ride"] = 1589.27, ["Mega|Fly|Ride"] = 1555.32}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 79.76, ["Neon"] = 2.52, ["Neon|Fly"] = 101.85, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 303.3, ["Mega"] = 28.88, ["Mega|Ride"] = 89.66}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.33, ["Ride"] = 67.94, ["Neon"] = 164.7, ["Neon|Ride"] = 138.68, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Fly|Ride"] = 115.92, ["Mega"] = 24.12, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.92, ["Mega"] = 25.96, ["Mega|Ride"] = 153.05, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 96.14, ["Fly"] = 223.13, ["Ride"] = 141.75, ["Fly|Ride"] = 371.77, ["Neon"] = 437.07, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 635.93, ["Mega|Ride"] = 2889.27, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 11.82, ["Fly|Ride"] = 95, ["Neon"] = 5.2, ["Neon|Fly"] = 43.36, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.77, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 214.52}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 61.69, ["Neon"] = 4.99, ["Neon|Fly"] = 43.36, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.81, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 108.83, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 562.27}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 8.59, ["Neon|Ride"] = 137.82, ["Mega"] = 101.07, ["Mega|Ride"] = 343.58}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 83.91, ["Ride"] = 145.2, ["Fly|Ride"] = 808.21, ["Neon"] = 413.44, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2455.93, ["Mega|Ride"] = 2166.69, ["Mega|Fly|Ride"] = 2528.51}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.34, ["Ride"] = 95.37, ["Neon"] = 114.15, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 719.43, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 97.01}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 145.21}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.45}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.35}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 2.52}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.3}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.35}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 11.82}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.16}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 18.8}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 650.16}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 462}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.71}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1369.89}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.39}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.39}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.66}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 164.19}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.73}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.39}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.73}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.13}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 196.87}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.04}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.44}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3045}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 64.22}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 317.63}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.7}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 19.68}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 210}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.14}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 40.27}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.51}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 30.17}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.86}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 24.93}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.46}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.95}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.15}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.01}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 256.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.52}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.49}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 306.83}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.34}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.54}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24417.26}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.72}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 57.18}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.39}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.98}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.88}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.19}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 431.78}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 49.88}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 227.74}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.47}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.12}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.4}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 143.06}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.28}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.31}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.65}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.91}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 590.63}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 12.06}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 221.82}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.77}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.99}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 30.45}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 63.24}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.45}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.54}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.68}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 6.45}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.69}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.92}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.4}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.84}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.27}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 144.38}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.08}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.56}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 23.58}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.89}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 13.13}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.83}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.76}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.78}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.25}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 38.57}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.54}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.18}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.43}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 15.29}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.9}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.62}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.15}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9325.19}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.56}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 6.26}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.08}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.72}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.57}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 245.25}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.1}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.69}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.92}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 6.57}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.2}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.3}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.15}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4913.02}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.46}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 40.04}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.47}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.14}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.88}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 90.75}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.68}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.65}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.99}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 143.79}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.38}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.72}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.96}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.51}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 20.99}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.34}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 145.38}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.02}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.3}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1050}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 64.2}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.26}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 20.69}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 30.85}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 3.84}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.4}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 16.95}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.2}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.62}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.3}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.57}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.82}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.2}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 27.57}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.62}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.69}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.88}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 187.15}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 12.32}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 8.46}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.2}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.51}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 19.27}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.67}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 81.2}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 182.33}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.58}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1013.25}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.57}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.87}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.01}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.77}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 63}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.14}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.77}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 76.39}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 21}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 18.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.56}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.26}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.15}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63.63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.49}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.19}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 14.3}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 116.74}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.84}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.08}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.27}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.16}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 94.27}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.71}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 112.77}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 432.36}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 141.62}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 9.08}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 57.44}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.54}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 63.67}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.76}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 11.68}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.72}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 82.69}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 30.64}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 13.02}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 42.13}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 29.71}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 24.76}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 92.53}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.75}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 19.69}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.98}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 10.36}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.43}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.9}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 397.69}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.87}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.8}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 16.92}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.46}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 295.82}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 62.33}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 39.89}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.19}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.03}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.66}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 965.35}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 179.82}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.18}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
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