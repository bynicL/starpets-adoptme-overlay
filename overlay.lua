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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1223.52, ["Ride"] = 1050, ["Fly|Ride"] = 1512.17, ["Neon"] = 6825, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 5068.17, ["Mega"] = 21511.31, ["Mega|Fly|Ride"] = 21511.31}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 526.32, ["Ride"] = 536.82, ["Fly|Ride"] = 511.88, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10755.66, ["Mega|Fly|Ride"] = 7601.03}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 5117.43, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 71131.44}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 183.75, ["Ride"] = 289.23, ["Fly|Ride"] = 318.72, ["Neon"] = 1144.9, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1073.47, ["Mega|Fly|Ride"] = 4790.63}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 544.69, ["Fly"] = 866.58, ["Ride"] = 564.38, ["Fly|Ride"] = 555.08, ["Neon|Ride"] = 1841.47, ["Neon|Fly|Ride"] = 1896.64, ["Mega|Fly|Ride"] = 6023.17}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.28, ["Ride"] = 59.06, ["Fly|Ride"] = 129.94, ["Neon"] = 56.78, ["Neon|Fly"] = 289.23, ["Neon|Ride"] = 103.94, ["Neon|Fly|Ride"] = 324.97, ["Mega"] = 353.75, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 601.26}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 43.35, ["Ride"] = 27.17, ["Fly|Ride"] = 56.78, ["Neon"] = 33.23, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 64.68, ["Neon|Fly|Ride"] = 132.77, ["Mega"] = 236.25, ["Mega|Ride"] = 266.76, ["Mega|Fly|Ride"] = 381.85}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 123.37, ["Ride"] = 141.74, ["Neon"] = 576.28, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1442.85, ["Mega"] = 1586.82, ["Mega|Fly"] = 2009.17, ["Mega|Ride"] = 2151.15}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 39.38, ["Fly"] = 53.82, ["Ride"] = 41.63, ["Fly|Ride"] = 106.32, ["Neon"] = 275.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 309.96, ["Mega"] = 2100, ["Mega|Ride"] = 1190.66, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.56, ["Fly"] = 47.82, ["Ride"] = 36.88, ["Fly|Ride"] = 71.47, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 207.38, ["Mega|Ride"] = 779.65, ["Mega|Fly|Ride"] = 860.46}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 78.75, ["Fly"] = 129.99, ["Ride"] = 98.69, ["Fly|Ride"] = 194.25, ["Neon"] = 341.84, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 482.3, ["Mega|Fly|Ride"] = 1247.67}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.5}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 318.23, ["Fly"] = 341.16, ["Ride"] = 349.13, ["Fly|Ride"] = 380.63, ["Neon|Fly"] = 1445.01, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 5102.49}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 166.83, ["Ride"] = 145.69, ["Fly|Ride"] = 159.5, ["Neon"] = 446.27, ["Neon|Fly"] = 637.52, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.37, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 23.85, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 344.19}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 199.49, ["Fly"] = 287.44, ["Ride"] = 197.58, ["Fly|Ride"] = 234.92, ["Neon|Ride"] = 974.9, ["Neon|Fly|Ride"] = 721.77, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.6, ["Fly"] = 26.82, ["Ride"] = 18.37, ["Fly|Ride"] = 42, ["Neon"] = 28.87, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 76.02, ["Neon|Fly|Ride"] = 105, ["Mega"] = 164.07, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 126.93, ["Fly"] = 196.88, ["Ride"] = 171.56, ["Fly|Ride"] = 286.78, ["Neon"] = 461.84, ["Neon|Ride"] = 331.67, ["Neon|Fly|Ride"] = 563.96, ["Mega"] = 1785.89, ["Mega|Ride"] = 1491.82, ["Mega|Fly|Ride"] = 1518.71}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.61}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 232.32, ["Fly|Ride"] = 244.02, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2151.15, ["Mega|Fly|Ride"] = 4546.88}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 25.72, ["Fly"] = 58.51, ["Ride"] = 50.68, ["Fly|Ride"] = 433.13, ["Neon"] = 247, ["Neon|Ride"] = 319.56, ["Neon|Fly|Ride"] = 332.55, ["Mega"] = 574.37, ["Mega|Ride"] = 1004.59, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.66, ["Fly"] = 78.75, ["Ride"] = 53.76, ["Fly|Ride"] = 110.25, ["Neon"] = 231, ["Neon|Ride"] = 190.31, ["Neon|Fly|Ride"] = 269.21, ["Mega"] = 1704.33, ["Mega|Fly|Ride"] = 993.15}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.78, ["Fly"] = 244.63, ["Ride"] = 82.15, ["Fly|Ride"] = 196.88, ["Neon"] = 163.57, ["Neon|Ride"] = 399.21, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1344.48, ["Mega|Fly|Ride"] = 1546.68}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 24.94, ["Ride"] = 35.18, ["Fly|Ride"] = 101.83, ["Neon"] = 210, ["Neon|Ride"] = 203.96, ["Neon|Fly|Ride"] = 189, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.91, ["Fly"] = 145.17, ["Ride"] = 64.97, ["Fly|Ride"] = 129.94, ["Neon"] = 216.66, ["Neon|Fly"] = 409.48, ["Neon|Ride"] = 350.2, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1137.04, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.33, ["Fly"] = 33.86, ["Ride"] = 24.84, ["Fly|Ride"] = 70.8, ["Neon"] = 45.82, ["Neon|Fly"] = 191.75, ["Neon|Ride"] = 49.31, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 162.41, ["Mega|Fly"] = 28717.6, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.02}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 395.01, ["Ride"] = 416.06, ["Fly|Ride"] = 452.82, ["Neon"] = 2131.77, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10755.66, ["Mega|Fly|Ride"] = 9658.62}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.76, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Neon|Fly|Ride"] = 280.88, ["Mega|Ride"] = 817.45, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.97, ["Fly"] = 61.85, ["Ride"] = 22.63, ["Fly|Ride"] = 50.15, ["Neon"] = 62.99, ["Neon|Ride"] = 71.8, ["Neon|Fly|Ride"] = 130.81, ["Mega"] = 324.05, ["Mega|Ride"] = 330.21, ["Mega|Fly|Ride"] = 387.22}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 81.77, ["Fly"] = 115.91, ["Ride"] = 106.32, ["Fly|Ride"] = 127.88, ["Neon"] = 332.55, ["Neon|Ride"] = 354.23, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 6450.85, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.08, ["Fly"] = 26.25, ["Ride"] = 36.65, ["Fly|Ride"] = 72.44, ["Neon"] = 124.59, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 720.57, ["Mega|Ride"] = 568.53, ["Mega|Fly|Ride"] = 726.02}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 216.46, ["Fly"] = 288.75, ["Ride"] = 236.25, ["Fly|Ride"] = 315, ["Neon"] = 578.45, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 735.59, ["Mega"] = 3440.75, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3165.17}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.49}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.63, ["Fly"] = 27.92, ["Ride"] = 22.31, ["Fly|Ride"] = 72.19, ["Neon"] = 24.92, ["Neon|Fly"] = 145.17, ["Neon|Ride"] = 50.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 196.88, ["Mega|Fly"] = 344.19, ["Mega|Ride"] = 194.79, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 900.45, ["Fly"] = 2625, ["Ride"] = 918.99, ["Fly|Ride"] = 918.75, ["Neon"] = 6499.25, ["Neon|Ride"] = 4911.27, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Ride"] = 54781.61, ["Mega|Fly|Ride"] = 17856.39}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.12, ["Fly"] = 53.95, ["Ride"] = 51.94, ["Fly|Ride"] = 80.17, ["Neon"] = 184.16, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 212.33, ["Mega"] = 1036.88, ["Mega|Ride"] = 1104.62, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 242.87, ["Fly"] = 367.76, ["Ride"] = 236.88, ["Fly|Ride"] = 416.78, ["Neon"] = 830.82, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1030.3, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.74}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.89, ["Fly"] = 129.99, ["Ride"] = 72.59, ["Fly|Ride"] = 145.17, ["Neon"] = 65.62, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 359.25, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 602.61}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.44, ["Fly"] = 160.61, ["Ride"] = 147, ["Fly|Ride"] = 219.19, ["Neon"] = 648.86, ["Neon|Ride"] = 483.13, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2384.85}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.59, ["Fly"] = 157.5, ["Ride"] = 150.94, ["Fly|Ride"] = 232.32, ["Neon"] = 389.46, ["Neon|Fly"] = 578.45, ["Neon|Ride"] = 426.27, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1423.77}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.1}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.81, ["Fly"] = 97.35, ["Ride"] = 58.95, ["Fly|Ride"] = 71.31, ["Neon|Ride"] = 505.12, ["Neon|Fly|Ride"] = 336, ["Mega"] = 4302.27, ["Mega|Fly|Ride"] = 1350.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.17, ["Fly"] = 101.83, ["Ride"] = 45.94, ["Fly|Ride"] = 157.5, ["Neon"] = 41.24, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 126.6, ["Neon|Fly|Ride"] = 243.73, ["Mega"] = 189, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 420.56}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 568.32, ["Fly"] = 701.93, ["Ride"] = 493.98, ["Fly|Ride"] = 551.25, ["Neon|Fly"] = 3899.56, ["Neon|Ride"] = 1876.88, ["Neon|Fly|Ride"] = 1870.35, ["Mega|Ride"] = 15057.92, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 116.66, ["Fly"] = 188.79, ["Ride"] = 131.25, ["Fly|Ride"] = 183.65, ["Neon"] = 420, ["Neon|Ride"] = 491.79, ["Neon|Fly|Ride"] = 721.43, ["Mega|Ride"] = 2581.37, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3806.25, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 15163.83}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 51.09, ["Fly"] = 131.25, ["Ride"] = 85.31, ["Fly|Ride"] = 172.25, ["Neon"] = 341.25, ["Neon|Ride"] = 289.36, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 2151.15, ["Mega|Ride"] = 2001.65, ["Mega|Fly|Ride"] = 1866.38}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Ride"] = 61.69, ["Fly|Ride"] = 147, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 6310.36, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2213.61}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.69, ["Fly"] = 64.37, ["Ride"] = 43.18, ["Fly|Ride"] = 103.41, ["Neon"] = 152.25, ["Neon|Fly"] = 289.23, ["Neon|Ride"] = 136.66, ["Neon|Fly|Ride"] = 211.3, ["Mega"] = 2625, ["Mega|Ride"] = 893.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.09}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 75.51, ["Fly"] = 393.75, ["Ride"] = 53.82, ["Fly|Ride"] = 98.09, ["Neon|Ride"] = 289.23, ["Neon|Fly|Ride"] = 606.61, ["Mega|Ride"] = 1298.95, ["Mega|Fly|Ride"] = 1358.46}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.79}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 186.67, ["Ride"] = 236.25, ["Fly|Ride"] = 282.19, ["Neon"] = 1155.79, ["Neon|Ride"] = 1154.72, ["Neon|Fly|Ride"] = 1152.55, ["Mega|Fly|Ride"] = 5112.96}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.24, ["Fly"] = 823.26, ["Ride"] = 643.13, ["Fly|Ride"] = 720.57, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3677.92, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.44, ["Fly"] = 47.25, ["Ride"] = 34.57, ["Fly|Ride"] = 65.63, ["Neon"] = 246.75, ["Neon|Fly"] = 343.29, ["Neon|Ride"] = 185.22, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 2151.15, ["Mega|Ride"] = 1177.46, ["Mega|Fly|Ride"] = 767.81}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.88}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 7221.76, ["Ride"] = 6498.17, ["Fly|Ride"] = 5055.75, ["Neon|Ride"] = 17982.51, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43825.29}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.99, ["Fly"] = 55.13, ["Ride"] = 25.12, ["Fly|Ride"] = 57.84, ["Neon"] = 74.57, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 151.66, ["Mega"] = 496.79, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 468.66}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.5, ["Fly"] = 141.91, ["Ride"] = 41.18, ["Fly|Ride"] = 121.36, ["Neon"] = 127.83, ["Neon|Ride"] = 129.99, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 717.42, ["Mega|Ride"] = 858.32, ["Mega|Fly|Ride"] = 1004.59}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 75.36, ["Ride"] = 66.94, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 401.89, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4302.27, ["Mega|Fly|Ride"] = 1785.89}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 8.72, ["Fly"] = 72.59, ["Ride"] = 29.27, ["Fly|Ride"] = 78.75, ["Neon"] = 89.25, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 502.3, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 2006.11, ["Ride"] = 1851.93, ["Fly|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34662.65, ["Ride"] = 33942.32, ["Fly|Ride"] = 24929.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 57364.19, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 49.44, ["Fly"] = 393.75, ["Ride"] = 59.06, ["Fly|Ride"] = 129.99, ["Neon"] = 243.28, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 578.45, ["Mega"] = 754.69, ["Mega|Ride"] = 1305.94, ["Mega|Fly|Ride"] = 1290.7}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.65, ["Fly"] = 129.83, ["Ride"] = 34.63, ["Fly|Ride"] = 199.4, ["Neon"] = 24.18, ["Neon|Fly"] = 145.15, ["Neon|Ride"] = 62.39, ["Neon|Fly|Ride"] = 189.56, ["Mega"] = 194.25, ["Mega|Fly"] = 287.19, ["Mega|Ride"] = 228.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.8}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.24, ["Ride"] = 59.07, ["Fly|Ride"] = 105, ["Neon"] = 86.67, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 144.14, ["Mega"] = 410.89, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 760.45}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 567, ["Fly"] = 915.68, ["Ride"] = 712.69, ["Fly|Ride"] = 768.58, ["Neon"] = 3106.62, ["Neon|Ride"] = 2859.68, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11362.94}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 917.34, ["Fly"] = 1076.15, ["Ride"] = 1041.94, ["Fly|Ride"] = 924, ["Neon"] = 4188.78, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11524.85}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.79, ["Fly"] = 122.59, ["Ride"] = 30.96, ["Fly|Ride"] = 93.17, ["Neon"] = 82.71, ["Neon|Ride"] = 91.96, ["Neon|Fly|Ride"] = 150.97, ["Mega"] = 496.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.71}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.75, ["Fly"] = 89.25, ["Ride"] = 85.31, ["Fly|Ride"] = 126, ["Neon"] = 578.45, ["Neon|Ride"] = 289.23, ["Neon|Fly|Ride"] = 399, ["Mega"] = 19687.5, ["Mega|Ride"] = 2009.17, ["Mega|Fly|Ride"] = 2146.85}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 102.37, ["Ride"] = 91.88, ["Fly|Ride"] = 173.34, ["Neon"] = 425.36, ["Neon|Ride"] = 398.75, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1426.71, ["Mega|Ride"] = 1936.03, ["Mega|Fly|Ride"] = 1947.81}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.76, ["Fly"] = 30.49, ["Ride"] = 23.02, ["Fly|Ride"] = 52.32, ["Neon"] = 49.05, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 99.68, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 317.3, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 150.34, ["Fly"] = 183.75, ["Ride"] = 159.48, ["Fly|Ride"] = 240.62, ["Neon"] = 865.5, ["Neon|Ride"] = 648.37, ["Neon|Fly|Ride"] = 637.88, ["Mega"] = 5162.73, ["Mega|Ride"] = 2921.7, ["Mega|Fly|Ride"] = 2622.36}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.56, ["Ride"] = 40.69, ["Fly|Ride"] = 99.75, ["Neon"] = 43.32, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 234.94, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.38, ["Fly"] = 65.63, ["Ride"] = 36.66, ["Fly|Ride"] = 91.01, ["Neon"] = 120.75, ["Neon|Ride"] = 152.03, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 650.09, ["Mega|Ride"] = 832.51, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.24, ["Ride"] = 68.25, ["Fly|Ride"] = 156.19, ["Neon"] = 208.04, ["Neon|Ride"] = 282.19, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.65, ["Fly"] = 58.51, ["Ride"] = 29.27, ["Fly|Ride"] = 75.22, ["Neon"] = 82.16, ["Neon|Ride"] = 127.83, ["Neon|Fly|Ride"] = 325.91, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6744.94, ["Ride"] = 5250, ["Fly|Ride"] = 5374.69, ["Neon"] = 36107.64, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 28885.89, ["Mega|Fly|Ride"] = 90897.3}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 244.13, ["Fly"] = 262.5, ["Ride"] = 236.25, ["Fly|Ride"] = 274.32, ["Neon|Fly|Ride"] = 637.88, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 54.74, ["Fly"] = 153.12, ["Ride"] = 93.17, ["Fly|Ride"] = 183.65, ["Neon"] = 164.07, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 205.83, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 521.07, ["Mega|Ride"] = 587.32, ["Mega|Fly|Ride"] = 665.65}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 90.72, ["Ride"] = 21.19, ["Fly|Ride"] = 81.37, ["Neon"] = 31.5, ["Neon|Fly"] = 86.67, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 62.36, ["Fly"] = 213.18, ["Ride"] = 129.12, ["Fly|Ride"] = 215.57, ["Neon"] = 210, ["Neon|Ride"] = 248.12, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 487.89, ["Mega|Ride"] = 534.18, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16609.92, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.56, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 114727.3}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 287.44, ["Ride"] = 406.52, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1585.83, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 7304.22}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 36.85, ["Fly"] = 80.59, ["Ride"] = 60.47, ["Fly|Ride"] = 113.17, ["Neon"] = 367.8, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 328.02, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.05, ["Ride"] = 26.24, ["Fly|Ride"] = 58.47, ["Neon"] = 66.78, ["Neon|Fly"] = 327.35, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 141.99, ["Mega"] = 421.32, ["Mega|Ride"] = 559.31, ["Mega|Fly|Ride"] = 502.3}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.74, ["Fly"] = 866.58, ["Ride"] = 433.12, ["Fly|Ride"] = 551.25, ["Neon"] = 1683.32, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.03, ["Ride"] = 41.95, ["Fly|Ride"] = 199.49, ["Neon"] = 34.04, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 223.74, ["Mega"] = 158.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.21, ["Fly"] = 167.91, ["Ride"] = 105, ["Fly|Ride"] = 193.76, ["Neon"] = 563.88, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 522.38, ["Mega|Ride"] = 2381.32, ["Mega|Fly|Ride"] = 2216.59}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.53, ["Fly"] = 21.39, ["Ride"] = 19.09, ["Fly|Ride"] = 34.09, ["Neon"] = 115.91, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 108.7, ["Mega"] = 2581.37, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.75}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.35, ["Ride"] = 87.94, ["Fly|Ride"] = 179.83, ["Neon"] = 353.07, ["Neon|Fly"] = 432.21, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 430.24, ["Mega"] = 1577.87, ["Mega|Ride"] = 2007.02, ["Mega|Fly|Ride"] = 1649.93}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.79, ["Fly"] = 80.07, ["Ride"] = 35.93, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 210, ["Mega"] = 579.74, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 650.09}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 41.36}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 72.19, ["Fly"] = 145.17, ["Ride"] = 101.07, ["Fly|Ride"] = 131.25, ["Neon"] = 305.93, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 433.3, ["Mega|Fly|Ride"] = 1710.17}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.68, ["Ride"] = 29.23, ["Fly|Ride"] = 137.82, ["Neon"] = 26.66, ["Neon|Ride"] = 137.58, ["Neon|Fly|Ride"] = 259.98, ["Mega"] = 223.74, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.3, ["Fly"] = 56.44, ["Ride"] = 42.26, ["Fly|Ride"] = 106.17, ["Neon"] = 82.16, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.95, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 536.72}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 541.63, ["Ride"] = 505.86, ["Fly|Ride"] = 551.62, ["Neon|Fly|Ride"] = 2815.28, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.45, ["Fly"] = 108.33, ["Ride"] = 52.41, ["Fly|Ride"] = 99.71, ["Neon"] = 129.94, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 344.48, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 40.15, ["Fly"] = 144.46, ["Ride"] = 72.19, ["Fly|Ride"] = 144.27, ["Neon"] = 236.25, ["Neon|Ride"] = 163.94, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.4, ["Fly"] = 110.38, ["Ride"] = 58.94, ["Fly|Ride"] = 110.23, ["Neon"] = 97.34, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 244.16, ["Mega"] = 381.85, ["Mega|Fly"] = 525, ["Mega|Ride"] = 494.78, ["Mega|Fly|Ride"] = 580.81}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8186.07, ["Neon|Fly|Ride"] = 13831.23, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1506.75, ["Fly"] = 1501.85, ["Ride"] = 1481.29, ["Fly|Ride"] = 1437.19, ["Neon|Fly|Ride"] = 4452.63, ["Mega|Fly|Ride"] = 24379.85}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 735.49, ["Ride"] = 784.52, ["Fly|Ride"] = 721.66, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21511.31, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.42, ["Fly"] = 24.53, ["Ride"] = 19.69, ["Fly|Ride"] = 49.38, ["Neon"] = 136.5, ["Neon|Ride"] = 91.96, ["Neon|Fly|Ride"] = 129.99, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.18, ["Fly"] = 52.5, ["Ride"] = 31.44, ["Fly|Ride"] = 131.25, ["Neon"] = 26.24, ["Neon|Ride"] = 56.11, ["Mega"] = 216.72, ["Mega|Ride"] = 200.42, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.97, ["Fly"] = 85.31, ["Ride"] = 46.75, ["Fly|Ride"] = 102.15, ["Neon"] = 551.71, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 152.78, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 23.5, ["Ride"] = 17.07, ["Fly|Ride"] = 41.94, ["Neon"] = 29.54, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 321.62, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 359.15}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 306.51, ["Fly"] = 375.89, ["Ride"] = 310.92, ["Fly|Ride"] = 353.07, ["Neon"] = 1127.91, ["Neon|Ride"] = 1460.18, ["Neon|Fly|Ride"] = 1213.73, ["Mega|Fly|Ride"] = 4336.5}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.29, ["Fly"] = 60.6, ["Ride"] = 42, ["Fly|Ride"] = 90.72, ["Neon"] = 131.25, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 174.5, ["Neon|Fly|Ride"] = 221.59, ["Mega"] = 860.46, ["Mega|Fly"] = 909.39, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 650.09}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.12, ["Fly"] = 22.92, ["Ride"] = 21.41, ["Fly|Ride"] = 26.25, ["Neon"] = 84.51, ["Neon|Fly"] = 122.41, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 107.43, ["Mega"] = 1575, ["Mega|Ride"] = 613.56, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 642.22, ["Fly"] = 1048.69, ["Ride"] = 578.45, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3612.51, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1445.01, ["Ride"] = 1214.07, ["Fly|Ride"] = 1181.24, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13335.94}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 101.07, ["Fly"] = 145.17, ["Ride"] = 90.57, ["Fly|Ride"] = 74.82, ["Neon"] = 971.25, ["Neon|Ride"] = 595.77, ["Neon|Fly|Ride"] = 487.46, ["Mega|Fly|Ride"] = 2832.83}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 200.82, ["Fly"] = 210, ["Ride"] = 216.46, ["Fly|Ride"] = 210, ["Neon|Ride"] = 578.45, ["Neon|Fly|Ride"] = 722.52, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.86, ["Fly"] = 58.51, ["Ride"] = 36.85, ["Fly|Ride"] = 115.91, ["Neon"] = 229.17, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 2151.15, ["Mega|Fly|Ride"] = 1089.56}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 431.16, ["Fly|Ride"] = 433.3, ["Neon"] = 1220.63, ["Neon|Fly"] = 980.79, ["Neon|Fly|Ride"] = 1299.86, ["Mega|Fly|Ride"] = 5737.08}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2455.64, ["Ride"] = 1962.19, ["Fly|Ride"] = 2029.07, ["Neon|Fly|Ride"] = 10832.08, ["Mega|Fly|Ride"] = 36521.07}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.65, ["Fly"] = 216.66, ["Ride"] = 49.88, ["Fly|Ride"] = 196.88, ["Neon"] = 216.66, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 1434.82, ["Mega|Ride"] = 1147.64, ["Mega|Fly|Ride"] = 1259.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 626.07, ["Fly"] = 743.09, ["Ride"] = 603.75, ["Fly|Ride"] = 623.44, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1283.63, ["Mega|Fly|Ride"] = 3727.92}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.22, ["Fly"] = 70.88, ["Ride"] = 63.07, ["Fly|Ride"] = 91.76, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 1075.58, ["Mega|Fly|Ride"] = 1133.39}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.6, ["Fly"] = 40.98, ["Ride"] = 21.67, ["Fly|Ride"] = 64.3, ["Neon"] = 25.17, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 50.46, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 179.82, ["Mega|Ride"] = 187.19, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 61.69, ["Ride"] = 131.18, ["Fly|Ride"] = 157.5, ["Neon"] = 275.52, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 1574.64, ["Mega|Ride"] = 1720.91, ["Mega|Fly|Ride"] = 1706.93}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 907.39, ["Ride"] = 965.55, ["Fly|Ride"] = 946.51, ["Neon|Ride"] = 3310.13, ["Neon|Fly|Ride"] = 3064.69, ["Mega|Fly|Ride"] = 13192.9}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714, ["Ride"] = 866.25, ["Fly|Ride"] = 931.62, ["Neon|Fly|Ride"] = 4331.76, ["Mega|Fly|Ride"] = 15630.13}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.45, ["Fly"] = 24.2, ["Ride"] = 23.78, ["Fly|Ride"] = 36.28, ["Neon"] = 144.38, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 789.49, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 15.3, ["Ride"] = 36.75, ["Fly|Ride"] = 120.25, ["Neon"] = 165.38, ["Neon|Ride"] = 148.66, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1004.59, ["Mega|Ride"] = 945.44, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.02, ["Fly"] = 59.2, ["Ride"] = 55.8, ["Fly|Ride"] = 216.66, ["Neon"] = 23.24, ["Neon|Fly"] = 326.17, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 231.82, ["Mega"] = 196.88, ["Mega|Fly"] = 568.53, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 42.69, ["Fly"] = 51.97, ["Ride"] = 51.17, ["Fly|Ride"] = 121.96, ["Neon"] = 319.56, ["Neon|Ride"] = 162.59, ["Neon|Fly|Ride"] = 240.38, ["Mega|Ride"] = 897.04, ["Mega|Fly|Ride"] = 979.13}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 91.87, ["Ride"] = 145.17, ["Fly|Ride"] = 361.81, ["Neon"] = 413.44, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2438.33, ["Mega|Fly|Ride"] = 2295.27}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.81, ["Fly"] = 52.41, ["Ride"] = 32.82, ["Fly|Ride"] = 73.5, ["Neon"] = 81.25, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 429.7, ["Mega|Ride"] = 330.51, ["Mega|Fly|Ride"] = 515.82}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 37.69, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Fly|Ride"] = 111.57, ["Neon"] = 242.82, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 236.7, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.24, ["Fly"] = 37.97, ["Ride"] = 17.85, ["Fly|Ride"] = 45.62, ["Neon"] = 28.8, ["Neon|Ride"] = 60.67, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 434.74, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.25, ["Fly"] = 65.01, ["Ride"] = 44.46, ["Fly|Ride"] = 88.92, ["Neon"] = 52.41, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 230.19, ["Mega"] = 416.07, ["Mega|Ride"] = 422.44, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 36.75, ["Fly"] = 71.46, ["Ride"] = 49.75, ["Fly|Ride"] = 102.26, ["Neon"] = 578.43, ["Neon|Ride"] = 332.55, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.74, ["Fly"] = 1367.63, ["Ride"] = 1367.63, ["Fly|Ride"] = 1483.12, ["Neon"] = 4536.09, ["Neon|Ride"] = 4903.88, ["Neon|Fly|Ride"] = 3621.19, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 467.76, ["Fly"] = 524.99, ["Ride"] = 459.38, ["Fly|Ride"] = 493.96, ["Neon|Ride"] = 3755.49, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15057.92}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 260.99, ["Fly"] = 378.23, ["Ride"] = 325.5, ["Fly|Ride"] = 439.69, ["Neon"] = 1575, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7744.08}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.34, ["Ride"] = 51.28, ["Fly|Ride"] = 99.74, ["Neon"] = 324.97, ["Neon|Fly"] = 433.3, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1720.91, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 27080.19, ["Ride"] = 36773.64, ["Fly|Ride"] = 18850.17, ["Neon|Fly|Ride"] = 35852.9, ["Mega"] = 215112.99, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 220.62, ["Fly"] = 284.44, ["Ride"] = 245.34, ["Fly|Ride"] = 334.59, ["Neon"] = 1039.98, ["Neon|Ride"] = 1014.21, ["Neon|Fly|Ride"] = 924.28, ["Mega"] = 6453.41, ["Mega|Fly|Ride"] = 4086.08}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 177.19, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 164.69, ["Fly"] = 157.5, ["Ride"] = 144.37, ["Fly|Ride"] = 169.59, ["Neon"] = 578.45, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 3587.03, ["Mega|Fly|Ride"] = 3009.45}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.09, ["Fly"] = 65.01, ["Ride"] = 26.25, ["Fly|Ride"] = 85.59, ["Neon"] = 164.29, ["Neon|Ride"] = 115.25, ["Neon|Fly|Ride"] = 231.82, ["Mega"] = 728, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 860.46}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3281.25, ["Ride"] = 3937.5, ["Fly|Ride"] = 4068.75, ["Neon"] = 21664.15, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 19.69, ["Fly"] = 41.9, ["Ride"] = 34.12, ["Fly|Ride"] = 58.56, ["Neon"] = 131.25, ["Neon|Ride"] = 215.57, ["Neon|Fly|Ride"] = 173.13, ["Mega|Ride"] = 1434.82, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.68, ["Ride"] = 51.17, ["Fly|Ride"] = 105.77, ["Neon"] = 170.63, ["Neon|Fly"] = 1445.01, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1398.25}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 471.9, ["Fly"] = 563.06, ["Ride"] = 472.5, ["Fly|Ride"] = 575.25, ["Neon"] = 1312.5, ["Neon|Ride"] = 1226.91, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 5306.85}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.15, ["Fly"] = 28.76, ["Ride"] = 24.05, ["Fly|Ride"] = 37.8, ["Neon"] = 131.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.39, ["Mega|Ride"] = 617.23, ["Mega|Fly|Ride"] = 582.67}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.24, ["Ride"] = 34.54, ["Fly|Ride"] = 84.51, ["Neon"] = 129.94, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 211.21, ["Mega"] = 568.53, ["Mega|Ride"] = 754.79, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 104.01, ["Ride"] = 105, ["Fly|Ride"] = 245.44, ["Neon"] = 735.49, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1576.09, ["Mega|Fly|Ride"] = 2434.76}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.69, ["Fly"] = 103.69, ["Ride"] = 70.45, ["Fly|Ride"] = 490.32, ["Neon"] = 85.39, ["Neon|Fly"] = 120.25, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 393.75, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 488.92}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3412.5, ["Fly"] = 6309.15, ["Ride"] = 4246.12, ["Fly|Ride"] = 4173.75, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10421.25, ["Mega"] = 48759.68, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.37, ["Fly"] = 145.17, ["Ride"] = 65.54, ["Fly|Ride"] = 144.38, ["Neon"] = 164.07, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 860.46, ["Mega|Ride"] = 859.39, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6300, ["Fly"] = 7690.78, ["Ride"] = 6857.82, ["Fly|Ride"] = 6483.75, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.37, ["Fly"] = 19.69, ["Ride"] = 17.15, ["Fly|Ride"] = 38.18, ["Neon"] = 24.19, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 196.88, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 260.53}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.25, ["Fly"] = 36.79, ["Ride"] = 38.75, ["Fly|Ride"] = 65.01, ["Neon"] = 188.49, ["Neon|Fly"] = 239.4, ["Neon|Ride"] = 505.86, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 998.17, ["Mega|Fly|Ride"] = 1004.59}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.2, ["Ride"] = 26.74, ["Fly|Ride"] = 87.02, ["Neon"] = 78.61, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 1050, ["Mega|Ride"] = 1073.43, ["Mega|Fly|Ride"] = 807.77}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.3, ["Fly"] = 190.37, ["Ride"] = 46.59, ["Fly|Ride"] = 173.34, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 860.46, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.73, ["Fly"] = 28.88, ["Ride"] = 20.97, ["Fly|Ride"] = 41.79, ["Neon|Fly"] = 1079.97, ["Neon|Ride"] = 114.83, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2581.37, ["Mega|Fly|Ride"] = 602.34}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8811.86}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2625}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 22.31}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 243.08, ["Ride"] = 397.56, ["Fly|Ride"] = 315}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.94, ["Fly"] = 145.17, ["Ride"] = 31.5, ["Fly|Ride"] = 145.17, ["Neon"] = 118.34, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 441, ["Mega|Ride"] = 536.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.35, ["Ride"] = 24.69, ["Fly|Ride"] = 86.67, ["Neon|Ride"] = 249.38, ["Mega"] = 1577.87}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 170.52, ["Fly"] = 433.3, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1011.72, ["Neon|Ride"] = 980.79, ["Neon|Fly|Ride"] = 788.6, ["Mega|Ride"] = 4159.22, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 63.56, ["Fly"] = 196.88, ["Ride"] = 101.75, ["Fly|Ride"] = 259.98, ["Neon"] = 315, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 717.42, ["Mega|Ride"] = 1931.73, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.3, ["Fly"] = 276.24, ["Ride"] = 183.75, ["Fly|Ride"] = 253.41, ["Neon"] = 944.99, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 822.81, ["Mega|Fly|Ride"] = 3520.55}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2488.5, ["Fly"] = 3123.31, ["Ride"] = 2455.69, ["Fly|Ride"] = 2730, ["Neon"] = 15214.74, ["Neon|Ride"] = 9807.76, ["Neon|Fly|Ride"] = 8017.66, ["Mega|Fly|Ride"] = 27248.39}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 21.39, ["Fly"] = 185.24, ["Ride"] = 54.11, ["Fly|Ride"] = 115.91, ["Neon"] = 122.6, ["Neon|Fly"] = 164.29, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 245.9, ["Mega"] = 966.95, ["Mega|Ride"] = 1004.59, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 865.6, ["Fly"] = 2100, ["Ride"] = 809.17, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4331.76}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.98}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.27, ["Ride"] = 52, ["Fly|Ride"] = 75.84, ["Neon"] = 94.5, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 167.91, ["Mega"] = 444.94, ["Mega|Fly"] = 973.91, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 700.87}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.66, ["Fly"] = 49.06, ["Ride"] = 27.98, ["Fly|Ride"] = 128.62, ["Neon"] = 65.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 455.31, ["Mega|Ride"] = 269.98, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.97}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 16.95, ["Ride"] = 32.51, ["Fly|Ride"] = 101.83, ["Neon|Ride"] = 196.17, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1075.58, ["Mega|Fly|Ride"] = 2151.15}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 29.97, ["Fly"] = 45.94, ["Ride"] = 42, ["Fly|Ride"] = 70.88, ["Neon|Fly"] = 239.4, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 286.12, ["Mega"] = 1434.82, ["Mega|Ride"] = 1826.06, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6562.5, ["Fly"] = 10237.5, ["Ride"] = 6498.17, ["Fly|Ride"] = 5053.13, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.58, ["Fly"] = 61.11, ["Ride"] = 33.39, ["Fly|Ride"] = 81.38, ["Neon"] = 55.11, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 184.72, ["Mega"] = 354.38, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 84.2, ["Fly"] = 383.48, ["Ride"] = 125.99, ["Fly|Ride"] = 131.25, ["Neon"] = 374.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 535.5, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2581.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 50.39, ["Fly"] = 75.84, ["Ride"] = 77.85, ["Fly|Ride"] = 190.32, ["Neon"] = 262.5, ["Neon|Fly"] = 367.8, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 457.94, ["Mega"] = 2434.76, ["Mega|Ride"] = 1147.64, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.86, ["Fly"] = 72.18, ["Ride"] = 31.5, ["Fly|Ride"] = 76.01, ["Neon"] = 131.19, ["Neon|Fly"] = 233.99, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 1016.21, ["Mega|Ride"] = 812, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.05, ["Fly"] = 77.07, ["Ride"] = 27.22, ["Fly|Ride"] = 112.59, ["Neon"] = 25.45, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 164.06, ["Mega|Fly"] = 7170.81, ["Mega|Ride"] = 221.8, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.38, ["Fly"] = 145.17, ["Ride"] = 27.27, ["Fly|Ride"] = 98.06, ["Neon"] = 123.98, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 570.94, ["Mega|Ride"] = 650.09, ["Mega|Fly|Ride"] = 681.92}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.47, ["Fly"] = 27.54, ["Ride"] = 28.04, ["Fly|Ride"] = 55.38, ["Neon"] = 127.83, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 115.91, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.87}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.57, ["Ride"] = 131.25, ["Fly|Ride"] = 289.23, ["Neon"] = 170.62, ["Neon|Ride"] = 214.49, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 328.13, ["Ride"] = 1445.01, ["Neon|Fly|Ride"] = 28885.89}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 72.6, ["Fly"] = 216.66, ["Ride"] = 88.32, ["Fly|Ride"] = 202.13, ["Neon"] = 275.63, ["Neon|Ride"] = 332.55, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1074.5, ["Mega|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 1358.18}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1049.99, ["Fly"] = 1378.13, ["Ride"] = 1039.5, ["Fly|Ride"] = 1049.99, ["Neon|Fly"] = 4446.61, ["Neon|Ride"] = 4391.34, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 337.84, ["Fly"] = 722.52, ["Ride"] = 413.32, ["Fly|Ride"] = 498.75, ["Neon"] = 2388.75, ["Neon|Ride"] = 3178.14, ["Neon|Fly|Ride"] = 1876.12, ["Mega"] = 12906.79, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 58.49}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 12.35, ["Fly"] = 31.4, ["Ride"] = 25.41, ["Fly|Ride"] = 58.51, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 81.46, ["Neon|Fly|Ride"] = 137.75, ["Mega"] = 437.26, ["Mega|Ride"] = 565.76, ["Mega|Fly|Ride"] = 566.84}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 229.59, ["Fly"] = 493.97, ["Ride"] = 288.64, ["Fly|Ride"] = 385.69, ["Neon"] = 965.48, ["Neon|Ride"] = 859.69, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3123.08}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.82}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 120.75, ["Fly"] = 245.17, ["Ride"] = 176.36, ["Fly|Ride"] = 301.88, ["Neon"] = 656.25, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 577.4, ["Neon|Fly|Ride"] = 654.83, ["Mega"] = 2580.3, ["Mega|Ride"] = 2417.88, ["Mega|Fly|Ride"] = 2266.85}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 124.69, ["Fly"] = 216.66, ["Ride"] = 139.75, ["Fly|Ride"] = 196.88, ["Neon"] = 649.93, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 866.58, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.77, ["Fly"] = 80.17, ["Ride"] = 26.25, ["Fly|Ride"] = 176.58, ["Neon"] = 36.63, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 242.71, ["Mega"] = 163.14, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 374.31}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.01, ["Fly"] = 72.59, ["Ride"] = 30.18, ["Fly|Ride"] = 89.65, ["Neon"] = 164.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 173.34, ["Mega|Ride"] = 1434.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.5, ["Fly"] = 102.36, ["Ride"] = 34.06, ["Fly|Ride"] = 117, ["Neon"] = 72.19, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 430.24, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.91, ["Fly"] = 131.23, ["Ride"] = 50.84, ["Fly|Ride"] = 152.15, ["Neon"] = 24.68, ["Neon|Ride"] = 75.1, ["Neon|Fly|Ride"] = 177.44, ["Mega"] = 157.5, ["Mega|Ride"] = 163.14, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 271.68, ["Ride"] = 287.44, ["Fly|Ride"] = 343.07, ["Neon"] = 1445.01, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6453.41}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 95.1, ["Fly"] = 157.5, ["Ride"] = 147.04, ["Fly|Ride"] = 245.46, ["Neon"] = 420, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 610.74, ["Mega"] = 2295.27, ["Mega|Fly|Ride"] = 2037.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 64.21, ["Fly"] = 97.51, ["Ride"] = 81.31, ["Fly|Ride"] = 115.91, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 319.56, ["Mega"] = 1434.82, ["Mega|Ride"] = 1785.89, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.99, ["Ride"] = 72.59, ["Fly|Ride"] = 289.23, ["Neon|Ride"] = 622.8, ["Neon|Fly|Ride"] = 505.86, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.75, ["Fly"] = 77.97, ["Ride"] = 29.88, ["Fly|Ride"] = 93.18, ["Neon"] = 94.5, ["Neon|Fly"] = 145.17, ["Neon|Ride"] = 123.51, ["Neon|Fly|Ride"] = 126, ["Mega"] = 431.82, ["Mega|Fly"] = 525, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.72, ["Fly"] = 39.38, ["Ride"] = 21.78, ["Fly|Ride"] = 69.57, ["Neon"] = 34.13, ["Neon|Fly"] = 68.31, ["Neon|Ride"] = 49.06, ["Neon|Fly|Ride"] = 105.13, ["Mega"] = 166.69, ["Mega|Ride"] = 177.09, ["Mega|Fly|Ride"] = 271.85}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.37, ["Fly"] = 918.75, ["Ride"] = 910.58, ["Fly|Ride"] = 999.81, ["Neon"] = 4332.85, ["Neon|Fly"] = 3328.52, ["Neon|Ride"] = 3432.73, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 282.17, ["Fly"] = 405.14, ["Ride"] = 302.75, ["Fly|Ride"] = 362.51, ["Neon"] = 1299.86, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10755.66, ["Mega|Fly|Ride"] = 4732.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.87, ["Fly"] = 173.34, ["Ride"] = 99.27, ["Fly|Ride"] = 186.34, ["Neon"] = 422.63, ["Neon|Fly"] = 572.55, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1312.5, ["Mega|Ride"] = 1735.97, ["Mega|Fly|Ride"] = 1865.05}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 172.89, ["Fly"] = 283.5, ["Ride"] = 191.1, ["Fly|Ride"] = 221.37, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 870.19, ["Mega"] = 10755.66, ["Mega|Fly|Ride"] = 4933.64}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 41.1, ["Fly"] = 43.35, ["Ride"] = 29.86, ["Fly|Ride"] = 86.63, ["Neon"] = 169.32, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 731.4, ["Mega|Fly|Ride"] = 945.44}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 306.46, ["Fly|Ride"] = 360.94, ["Neon"] = 895.32, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4281.06, ["Mega|Fly|Ride"] = 4247.22}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.43, ["Fly"] = 125.99, ["Ride"] = 90.45, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 578.45, ["Neon|Fly|Ride"] = 433.3, ["Mega|Fly|Ride"] = 1577.87}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2760.19, ["Ride"] = 2453.24, ["Fly|Ride"] = 2456.65, ["Neon|Ride"] = 8665.67, ["Neon|Fly|Ride"] = 7655.04, ["Mega"] = 51627.13, ["Mega|Fly|Ride"] = 26501.93}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.55, ["Fly"] = 78.04, ["Ride"] = 32.47, ["Fly|Ride"] = 91.88, ["Neon"] = 51.53, ["Neon|Fly"] = 105, ["Neon|Ride"] = 76.02, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 230.74, ["Mega|Fly"] = 574.37, ["Mega|Ride"] = 320.09, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 63.66, ["Ride"] = 65.57, ["Fly|Ride"] = 210, ["Neon"] = 196.88, ["Neon|Ride"] = 216.66, ["Neon|Fly|Ride"] = 462.99, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1380.51}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 80.07, ["Fly"] = 91.87, ["Ride"] = 82.42, ["Fly|Ride"] = 101.07, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.79, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1635.22, ["Ride"] = 1069.69, ["Fly|Ride"] = 1179.94, ["Neon|Ride"] = 5721.6, ["Neon|Fly|Ride"] = 4622.06, ["Mega"] = 37286.62, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 581.03, ["Fly"] = 864.41, ["Ride"] = 576.13, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11473.07}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 327.3, ["Ride"] = 86.67, ["Fly|Ride"] = 209.72, ["Neon"] = 341.25, ["Neon|Ride"] = 342.57, ["Neon|Fly|Ride"] = 541.92, ["Mega"] = 2151.15, ["Mega|Ride"] = 2597.88, ["Mega|Fly|Ride"] = 1659.07}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.16, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 85.59, ["Neon"] = 86.63, ["Neon|Ride"] = 86.85, ["Neon|Fly|Ride"] = 164.26, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 34.11, ["Fly"] = 68.25, ["Ride"] = 43.35, ["Fly|Ride"] = 89.25, ["Neon"] = 284.82, ["Neon|Fly"] = 361.81, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 346.35, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1127.75, ["Ride"] = 798, ["Fly|Ride"] = 866.25, ["Neon"] = 2599.71, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.43, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 592.31}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6607.58, ["Ride"] = 6355.19, ["Fly|Ride"] = 5315.63, ["Neon"] = 42000, ["Neon|Ride"] = 31045.82, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 73042.14}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.5, ["Fly"] = 406.21, ["Ride"] = 252.52, ["Fly|Ride"] = 426.6, ["Neon"] = 1312.5, ["Neon|Ride"] = 1878.3, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6452.34, ["Mega|Ride"] = 6167.31, ["Mega|Fly|Ride"] = 6167.31}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.34, ["Ride"] = 147.82, ["Fly|Ride"] = 336, ["Neon"] = 1134.13, ["Neon|Ride"] = 505.86, ["Neon|Fly|Ride"] = 485.63}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 19.28, ["Fly"] = 101.83, ["Ride"] = 32.16, ["Fly|Ride"] = 91.77, ["Neon"] = 173.34, ["Neon|Ride"] = 129.82, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 717.42, ["Mega|Ride"] = 860.46, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.45, ["Fly"] = 28.86, ["Ride"] = 24.82, ["Fly|Ride"] = 57.63, ["Neon"] = 146.5, ["Neon|Ride"] = 129.99, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2151.15}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.71, ["Ride"] = 25.98, ["Fly|Ride"] = 103.3, ["Neon"] = 118.12, ["Neon|Ride"] = 119.06, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 631.38}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.56, ["Fly"] = 63.92, ["Ride"] = 21.65, ["Fly|Ride"] = 48.57, ["Neon"] = 33.23, ["Neon|Ride"] = 57.63, ["Neon|Fly|Ride"] = 127.83, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 204.23}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.7, ["Fly"] = 90.57, ["Ride"] = 47.25, ["Fly|Ride"] = 145.17, ["Neon"] = 156.58, ["Neon|Fly"] = 866.58, ["Neon|Ride"] = 233.99, ["Neon|Fly|Ride"] = 344.48, ["Mega"] = 630, ["Mega|Ride"] = 717.42}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 504.95, ["Fly"] = 538.13, ["Ride"] = 551.15, ["Fly|Ride"] = 634.99, ["Neon|Ride"] = 1589.07, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5880.12}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 15.77, ["Fly|Ride"] = 34.37, ["Neon"] = 24.52, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 170.63, ["Mega|Ride"] = 228.03, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 51.17, ["Fly"] = 116.45, ["Ride"] = 74.81, ["Fly|Ride"] = 143.85, ["Neon"] = 229.19, ["Neon|Fly"] = 411.64, ["Neon|Ride"] = 244.55, ["Neon|Fly|Ride"] = 286.12, ["Mega"] = 564.38, ["Mega|Fly"] = 860.46, ["Mega|Ride"] = 557.81, ["Mega|Fly|Ride"] = 622.13}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 823.29, ["Fly"] = 982.48, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2480.15, ["Neon|Fly|Ride"] = 1574.99, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 27.35, ["Fly"] = 70.47, ["Ride"] = 43.18, ["Fly|Ride"] = 89.24, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 188.88, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 863.77}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 264.27, ["Fly"] = 490.32, ["Ride"] = 287.42, ["Fly|Ride"] = 314.86, ["Neon"] = 1624.82, ["Neon|Fly|Ride"] = 1011.72, ["Mega|Fly|Ride"] = 3729}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 155.93, ["Fly"] = 367.76, ["Ride"] = 262.49, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1098.39, ["Neon|Fly|Ride"] = 771.83, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3656.93}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 947.93, ["Ride"] = 709.47, ["Fly|Ride"] = 919.74, ["Neon|Ride"] = 3856.91, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10467.41}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.16, ["Fly"] = 62.84, ["Ride"] = 43.32, ["Fly|Ride"] = 121.36, ["Neon"] = 78.61, ["Neon|Fly"] = 294.26, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 164.29, ["Mega"] = 354.38, ["Mega|Ride"] = 359.25, ["Mega|Fly|Ride"] = 650.09}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4001.86, ["Fly"] = 3508.32, ["Ride"] = 3281.25, ["Fly|Ride"] = 3151.32, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 18892.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 131.24, ["Fly"] = 164.07, ["Ride"] = 157.5, ["Fly|Ride"] = 208.6, ["Neon"] = 535.5, ["Neon|Fly"] = 662.03, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 3083.67, ["Mega|Fly|Ride"] = 3170.78}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 28.24, ["Ride"] = 18.51, ["Fly|Ride"] = 51.5, ["Neon"] = 23.29, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 237.71}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.56, ["Fly"] = 30.19, ["Ride"] = 27.98, ["Fly|Ride"] = 59.07, ["Neon"] = 22.43, ["Neon|Fly"] = 120.16, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 189.13, ["Mega|Ride"] = 255.99, ["Mega|Fly|Ride"] = 473.82}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 29.8, ["Fly"] = 38.07, ["Ride"] = 29.27, ["Fly|Ride"] = 48.87, ["Neon"] = 294.2, ["Neon|Ride"] = 318.76, ["Neon|Fly|Ride"] = 259.98, ["Mega|Fly|Ride"] = 1144.42}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 763.88, ["Fly"] = 1274.84, ["Ride"] = 826.88, ["Fly|Ride"] = 1038.18, ["Neon"] = 4185.54, ["Neon|Ride"] = 4579, ["Neon|Fly|Ride"] = 4824.2}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7809.38, ["Fly|Ride"] = 7875}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.88, ["Fly"] = 34.68, ["Ride"] = 23.43, ["Fly|Ride"] = 48.38, ["Neon"] = 452.13, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 123.4, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.86, ["Fly"] = 49.07, ["Ride"] = 29.12, ["Fly|Ride"] = 84.46, ["Neon"] = 91.88, ["Neon|Ride"] = 83.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 668.87, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 86.63, ["Fly"] = 157.5, ["Ride"] = 112.46, ["Fly|Ride"] = 196.23, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 539.09, ["Mega|Fly|Ride"] = 2045.21}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 196.88, ["Fly"] = 266.48, ["Ride"] = 242.79, ["Fly|Ride"] = 315, ["Neon"] = 917.49, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1028.99, ["Mega"] = 10755.66, ["Mega|Fly"] = 4059.93, ["Mega|Fly|Ride"] = 4546.88}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.3, ["Ride"] = 37.04, ["Fly|Ride"] = 71.51, ["Neon"] = 20.15, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 67.17, ["Neon|Fly|Ride"] = 327.35, ["Mega"] = 225.74, ["Mega|Fly"] = 239.87, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.49, ["Fly"] = 231.71, ["Ride"] = 195.56, ["Fly|Ride"] = 291.38, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.43, ["Fly|Ride"] = 40.69, ["Neon"] = 23.55, ["Neon|Fly"] = 125.66, ["Neon|Ride"] = 43.91, ["Neon|Fly|Ride"] = 118.38, ["Mega"] = 217.88, ["Mega|Ride"] = 187.03, ["Mega|Fly|Ride"] = 283.97}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 353.14, ["Ride"] = 262.5, ["Fly|Ride"] = 307.43, ["Neon|Ride"] = 1269.92, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10755.66, ["Mega|Fly|Ride"] = 4446.4}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.02, ["Fly"] = 104.98, ["Ride"] = 28.58, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 311.41, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 574.37, ["Mega|Ride"] = 559.31, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 51.19, ["Neon"] = 7.62, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 75.78, ["Mega|Ride"] = 136.1, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Mega"] = 22.95, ["Mega|Ride"] = 144.14, ["Mega|Fly|Ride"] = 136.61}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 34.68, ["Fly|Ride"] = 115.47, ["Neon"] = 6.46, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 61.85, ["Mega|Fly"] = 162316.68, ["Mega|Ride"] = 88.1, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.02, ["Fly"] = 102.65, ["Ride"] = 110.15, ["Fly|Ride"] = 173.24, ["Neon"] = 339.94, ["Neon|Fly"] = 332.55, ["Neon|Ride"] = 277.85, ["Neon|Fly|Ride"] = 391.11, ["Mega|Fly|Ride"] = 1606.91}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.01, ["Ride"] = 17.05, ["Fly|Ride"] = 83.73, ["Neon"] = 6.46, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.77, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.05, ["Ride"] = 65.63, ["Neon"] = 67.91, ["Neon|Fly"] = 311.41, ["Neon|Ride"] = 212.52, ["Mega"] = 261.19, ["Mega|Ride"] = 555.01, ["Mega|Fly|Ride"] = 608.78}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 43.35, ["Neon"] = 2.1, ["Neon|Ride"] = 55.81, ["Neon|Fly|Ride"] = 137.58, ["Mega"] = 15.74, ["Mega|Ride"] = 90.96, ["Mega|Fly|Ride"] = 203.34}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 72.34, ["Ride"] = 16.09, ["Fly|Ride"] = 49.85, ["Neon"] = 2.1, ["Neon|Fly"] = 38.25, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 36.74, ["Mega"] = 13.55, ["Mega|Fly"] = 35.8, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 56.4}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 14.81, ["Fly|Ride"] = 81.04, ["Neon"] = 3.46, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 22.78, ["Mega|Fly"] = 163.14, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 87.93}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 91.01, ["Mega"] = 18.38, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.98, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 2.9, ["Neon|Fly"] = 123.51, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 90.95, ["Mega"] = 36.85, ["Mega|Fly"] = 101.11, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 77.23, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 20.99, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 5.44, ["Fly"] = 77.43, ["Ride"] = 34.37, ["Fly|Ride"] = 173.34, ["Neon"] = 22.92, ["Neon|Fly"] = 118.55, ["Neon|Ride"] = 62.3, ["Neon|Fly|Ride"] = 142.53, ["Mega"] = 144.14, ["Mega|Fly"] = 401.06, ["Mega|Ride"] = 166.83, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 326.91, ["Mega"] = 15.63, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 146.25, ["Fly|Ride"] = 145.17, ["Neon"] = 18.4, ["Mega"] = 111.56, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 17.05, ["Mega"] = 123.5, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.94, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 22.32, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.63, ["Ride"] = 14.34, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 29.44, ["Neon|Ride"] = 16.15, ["Neon|Fly|Ride"] = 38.05, ["Mega"] = 13.43, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 20.97, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.1, ["Neon"] = 36.74, ["Neon|Ride"] = 72.59, ["Mega"] = 202.55, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.7, ["Neon"] = 2.55, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.17, ["Mega|Ride"] = 43.2, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.57, ["Neon"] = 16.13, ["Mega"] = 84.26, ["Mega|Ride"] = 166.73, ["Mega|Fly|Ride"] = 244.16}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 28.87, ["Neon"] = 16.26, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 129.08, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.73, ["Ride"] = 11.54, ["Fly|Ride"] = 31.48, ["Neon"] = 2.1, ["Neon|Fly"] = 15.49, ["Neon|Ride"] = 15.37, ["Neon|Fly|Ride"] = 31.2, ["Mega"] = 16, ["Mega|Fly"] = 30.87, ["Mega|Ride"] = 24.31, ["Mega|Fly|Ride"] = 48.56}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 163.14}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 24.53, ["Fly|Ride"] = 59.07, ["Neon"] = 56.91, ["Neon|Ride"] = 71.46, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 291.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 14.41, ["Fly|Ride"] = 42.95, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 20.78, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 104.97}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 180.92, ["Ride"] = 45.91, ["Neon"] = 6.57, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 86.05, ["Mega|Fly"] = 172.1, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 215.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 367.8, ["Mega"] = 28.25, ["Mega|Fly"] = 114.58, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.14}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 33.11, ["Ride"] = 27.56, ["Neon"] = 2.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 15.64, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 43.24, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.85, ["Ride"] = 18.38, ["Fly|Ride"] = 48.03, ["Neon"] = 3.75, ["Neon|Fly"] = 58.51, ["Neon|Ride"] = 32.06, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 72.58, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.59, ["Neon"] = 5.94, ["Neon|Ride"] = 72.59, ["Mega"] = 45.85, ["Mega|Fly"] = 325.05, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 16.21, ["Fly|Ride"] = 43.37, ["Neon"] = 3.83, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 25.74, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 114.19, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 73.06, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 37.03, ["Neon"] = 32.96, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 324.97, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.34, ["Fly|Ride"] = 47.23, ["Neon"] = 11.66, ["Neon|Fly"] = 49.06, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 123.5, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 114.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.75, ["Fly|Ride"] = 101.83, ["Neon"] = 12.08, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 203.91, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.83, ["Ride"] = 72.65, ["Neon"] = 9.09, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 255.29, ["Mega|Ride"] = 317.3}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 3.93, ["Ride"] = 59.07, ["Neon"] = 131.25, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 643.21, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 650.09}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 55.84, ["Neon"] = 44.61, ["Neon|Ride"] = 108.32, ["Mega"] = 238.88, ["Mega|Ride"] = 361.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.61, ["Ride"] = 37.7, ["Fly|Ride"] = 120.75, ["Neon"] = 43.35, ["Neon|Ride"] = 57.29, ["Neon|Fly|Ride"] = 127.28, ["Mega"] = 278.92, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 29.27, ["Neon"] = 3.52, ["Neon|Ride"] = 65.02, ["Mega"] = 17.72, ["Mega|Fly"] = 123.71, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 231.95}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.59, ["Fly"] = 23.37, ["Ride"] = 22.32, ["Fly|Ride"] = 51.01, ["Neon"] = 44.63, ["Neon|Fly"] = 189, ["Neon|Ride"] = 61.94, ["Neon|Fly|Ride"] = 104.4, ["Mega"] = 279.66, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 19.31, ["Fly|Ride"] = 86.63, ["Neon"] = 2.86, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 24.94, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 30.55, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 44.71, ["Ride"] = 16.26, ["Fly|Ride"] = 44.8, ["Neon"] = 9.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 61.58, ["Mega"] = 107.58, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 171.71}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.5, ["Fly"] = 43.35, ["Ride"] = 21.73, ["Fly|Ride"] = 69.57, ["Neon"] = 41.99, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 328.02, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 347.42}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 2.1, ["Neon|Ride"] = 24.7, ["Neon|Fly|Ride"] = 315, ["Mega"] = 22.32, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.45, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 17.16, ["Fly|Ride"] = 58.7, ["Neon"] = 3.11, ["Neon|Fly"] = 114.83, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 98.01, ["Mega"] = 31.08, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 38.98, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 29.04, ["Ride"] = 17.72, ["Fly|Ride"] = 43.35, ["Neon"] = 3.14, ["Neon|Fly"] = 50.99, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.11, ["Mega"] = 84, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 101.11, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 53.27, ["Fly|Ride"] = 145.17, ["Neon"] = 8.25, ["Neon|Ride"] = 59.74, ["Neon|Fly|Ride"] = 107.58, ["Mega"] = 77.6, ["Mega|Ride"] = 128.67, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 157903.4, ["Mega"] = 16.49, ["Mega|Fly"] = 108.1, ["Mega|Ride"] = 63.48, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 19.68, ["Fly|Ride"] = 43.35, ["Neon"] = 3.94, ["Neon|Fly"] = 28.22, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 90.61, ["Mega"] = 18.17, ["Mega|Fly"] = 64.55, ["Mega|Ride"] = 36.74, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.58, ["Mega"] = 16.96, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.16, ["Neon|Fly|Ride"] = 420, ["Mega"] = 51.18, ["Mega|Ride"] = 197.92, ["Mega|Fly|Ride"] = 154.9}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.99, ["Fly|Ride"] = 47.25, ["Neon"] = 2.52, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 38.06, ["Mega|Ride"] = 51.53, ["Mega|Fly|Ride"] = 108.36}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.87, ["Ride"] = 78.75, ["Fly|Ride"] = 216.66, ["Neon"] = 81.38, ["Mega"] = 389.81, ["Mega|Ride"] = 681.92, ["Mega|Fly|Ride"] = 717.42}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.24, ["Neon"] = 43.32, ["Neon|Ride"] = 157.5, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.51, ["Fly|Ride"] = 177.65, ["Neon"] = 22.73, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 322.69, ["Mega|Ride"] = 295.8, ["Mega|Fly|Ride"] = 383.15}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.15, ["Ride"] = 11.7, ["Fly|Ride"] = 31.06, ["Neon"] = 2.1, ["Neon|Fly"] = 23.85, ["Neon|Ride"] = 11.81, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 14.3, ["Mega|Fly"] = 29.05, ["Mega|Ride"] = 21.61, ["Mega|Fly|Ride"] = 59.77}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.37, ["Neon"] = 7.51, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 722.52, ["Mega"] = 86.72, ["Mega|Ride"] = 144.14}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.59, ["Ride"] = 44.15, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 13.9, ["Mega|Fly"] = 129.08, ["Mega|Ride"] = 56.01, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.65, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 72.63, ["Mega"] = 19.42, ["Mega|Fly"] = 215.13, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 129.99, ["Ride"] = 19.37, ["Fly|Ride"] = 57.92, ["Neon"] = 8.69, ["Neon|Fly"] = 72.35, ["Neon|Ride"] = 36.85, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 170.62, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 295.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.07, ["Ride"] = 228.01, ["Fly|Ride"] = 815.83, ["Neon"] = 656.25, ["Neon|Ride"] = 866.58, ["Neon|Fly|Ride"] = 1009.57, ["Mega"] = 8604.53, ["Mega|Fly|Ride"] = 4059.93}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 7.37, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.86, ["Fly"] = 103.68, ["Ride"] = 24.68, ["Fly|Ride"] = 64.97, ["Neon"] = 33.12, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 173.34, ["Mega"] = 385.75, ["Mega|Ride"] = 224.01, ["Mega|Fly|Ride"] = 653.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 15.71, ["Fly|Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Fly"] = 33.59, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 50.94, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 144.14}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.59, ["Ride"] = 19.69, ["Fly|Ride"] = 95.48, ["Neon"] = 10.85, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.35, ["Mega|Ride"] = 194.79, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.19, ["Fly|Ride"] = 40.77, ["Neon"] = 31.17, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 287.19, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.2, ["Ride"] = 34.68, ["Fly|Ride"] = 66.21, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 257.25, ["Mega|Ride"] = 260.53, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 20.57, ["Ride"] = 17.73, ["Fly|Ride"] = 34.57, ["Neon"] = 31.5, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 79.16, ["Mega"] = 262.5, ["Mega|Fly"] = 214.05, ["Mega|Ride"] = 373.24, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.54, ["Ride"] = 82.69, ["Fly|Ride"] = 149.62, ["Neon"] = 341.24, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 418.59, ["Neon|Fly|Ride"] = 385.81, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 242.24, ["Fly"] = 433.3, ["Ride"] = 249.25, ["Fly|Ride"] = 275.63, ["Neon|Ride"] = 1145.07, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10755.66, ["Mega|Fly|Ride"] = 5019.68}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.15, ["Fly"] = 85.2, ["Ride"] = 72.59, ["Fly|Ride"] = 119.28, ["Neon"] = 490.25, ["Neon|Fly"] = 367.22, ["Neon|Ride"] = 293.28, ["Neon|Fly|Ride"] = 286.81, ["Mega|Fly|Ride"] = 1563.33}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.66, ["Fly"] = 288.09, ["Ride"] = 47.13, ["Fly|Ride"] = 77.44, ["Neon"] = 47.16, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.75, ["Mega"] = 262.5, ["Mega|Ride"] = 190.31, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.09, ["Fly"] = 72.59, ["Ride"] = 21, ["Fly|Ride"] = 64.87, ["Neon"] = 61.07, ["Neon|Fly"] = 145.17, ["Neon|Ride"] = 78.05, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 484.02, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 456.16}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 33.58, ["Ride"] = 17.05, ["Fly|Ride"] = 50.9, ["Neon"] = 3.05, ["Neon|Fly"] = 57.63, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 44.84, ["Mega|Fly"] = 148.53, ["Mega|Ride"] = 215.13, ["Mega|Fly|Ride"] = 381.98}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 31.43, ["Fly|Ride"] = 66.25, ["Neon"] = 95.81, ["Neon|Fly"] = 289.23, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 255.65, ["Mega"] = 474.34, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 588.35}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 17.06, ["Fly|Ride"] = 34.15, ["Neon"] = 14.44, ["Neon|Fly"] = 61.69, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 62.35, ["Mega"] = 131.25, ["Mega|Ride"] = 269.98, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 20.37, ["Fly|Ride"] = 328.13, ["Neon"] = 44.63, ["Neon|Ride"] = 36.85, ["Mega"] = 207.38, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.51, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.44, ["Mega|Ride"] = 43.03, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.07, ["Fly|Ride"] = 43.35, ["Neon"] = 10.19, ["Neon|Fly"] = 108.33, ["Neon|Ride"] = 34.62, ["Neon|Fly|Ride"] = 66.22, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.95, ["Fly|Ride"] = 71.1, ["Neon"] = 19.09, ["Neon|Ride"] = 47.25, ["Mega"] = 131.23, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 84.63, ["Fly"] = 164.11, ["Ride"] = 152.71, ["Fly|Ride"] = 199.29, ["Neon"] = 489.57, ["Neon|Ride"] = 435.68, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3895.6, ["Mega|Fly|Ride"] = 2868.54}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.29, ["Ride"] = 129.94, ["Fly|Ride"] = 131.18, ["Neon"] = 46.58, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.94, ["Ride"] = 19.46, ["Fly|Ride"] = 55.89, ["Neon"] = 13.7, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 246.75, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 14.44, ["Ride"] = 46.59, ["Fly|Ride"] = 155.84, ["Neon"] = 88.83, ["Neon|Ride"] = 122.6, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 445.32, ["Mega|Fly"] = 860.46, ["Mega|Ride"] = 674.4, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Fly|Ride"] = 128.92, ["Neon"] = 32.81, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 332.55, ["Mega"] = 846.49, ["Mega|Ride"] = 598.5, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.07, ["Fly"] = 41.99, ["Ride"] = 26.4, ["Fly|Ride"] = 60.47, ["Neon"] = 407.3, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 161.02, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 1388.58, ["Mega|Fly|Ride"] = 518.67}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 28.18, ["Fly|Ride"] = 52.38, ["Neon"] = 2.1, ["Neon|Ride"] = 29.08, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 37.36, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 87.84, ["Mega|Fly|Ride"] = 231.69}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.83, ["Fly"] = 32.55, ["Ride"] = 21.15, ["Fly|Ride"] = 65.54, ["Neon"] = 58.51, ["Neon|Ride"] = 164.29, ["Mega"] = 288.33, ["Mega|Fly"] = 406.61, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 19.51, ["Fly|Ride"] = 45.67, ["Neon"] = 12.89, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 183.75, ["Mega|Ride"] = 214.05, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 41.69, ["Neon|Fly|Ride"] = 57.63, ["Mega"] = 36.59, ["Mega|Ride"] = 71, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.62, ["Fly"] = 149.56, ["Ride"] = 81.14, ["Fly|Ride"] = 136.49, ["Neon"] = 180.57, ["Neon|Ride"] = 216.66, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 735, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 860.46}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.2, ["Ride"] = 107.25, ["Fly|Ride"] = 210, ["Neon"] = 98.1, ["Mega|Ride"] = 322.69, ["Mega|Fly|Ride"] = 325.05}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 19.69, ["Fly|Ride"] = 62.97, ["Neon"] = 15.75, ["Neon|Fly"] = 86.67, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 106.17, ["Mega"] = 158.82, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.6, ["Fly"] = 433.12, ["Ride"] = 129.99, ["Neon"] = 427.89, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 565.04, ["Mega"] = 4546.88, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.46, ["Fly"] = 45.66, ["Ride"] = 23.61, ["Fly|Ride"] = 68.65, ["Neon"] = 35.81, ["Neon|Ride"] = 63.92, ["Neon|Fly|Ride"] = 107.79, ["Mega"] = 418.95, ["Mega|Ride"] = 243.49, ["Mega|Fly|Ride"] = 398.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.49, ["Fly"] = 131.24, ["Ride"] = 91.86, ["Fly|Ride"] = 202.58, ["Neon"] = 223.13, ["Neon|Fly"] = 329.31, ["Neon|Ride"] = 207.89, ["Neon|Fly|Ride"] = 354.25, ["Mega"] = 1147.64, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.25, ["Fly"] = 173.34, ["Ride"] = 55, ["Fly|Ride"] = 150.59, ["Neon"] = 58.36, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 336.66, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 973.91}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.29, ["Fly"] = 53.95, ["Ride"] = 26, ["Fly|Ride"] = 72.42, ["Neon"] = 145.17, ["Neon|Ride"] = 196.17, ["Neon|Fly|Ride"] = 387.13, ["Mega"] = 568.53, ["Mega|Ride"] = 572.22, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.75, ["Fly"] = 77.24, ["Ride"] = 98.09, ["Fly|Ride"] = 102.38, ["Neon"] = 49.87, ["Neon|Ride"] = 77.32, ["Neon|Fly|Ride"] = 272.19, ["Mega"] = 344.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 401.35}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.59, ["Ride"] = 38.01, ["Neon"] = 41.99, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 276.83, ["Mega|Ride"] = 276.89, ["Mega|Fly|Ride"] = 417.8}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 72.59, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 210, ["Mega"] = 19.57, ["Mega|Ride"] = 144.14, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.33, ["Ride"] = 126.06, ["Neon"] = 27.54, ["Neon|Ride"] = 198.24, ["Neon|Fly|Ride"] = 202.79, ["Mega"] = 238.88, ["Mega|Ride"] = 509.83, ["Mega|Fly|Ride"] = 528.12}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.92, ["Ride"] = 29.27, ["Neon"] = 28.87, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 101.83, ["Neon|Fly|Ride"] = 201.49, ["Mega"] = 210.67, ["Mega|Ride"] = 287.19, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 122.59, ["Neon"] = 18.8, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 128, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Fly"] = 648.86, ["Ride"] = 551.25, ["Fly|Ride"] = 577.4, ["Neon"] = 1841.47, ["Neon|Fly"] = 1843.64, ["Neon|Ride"] = 1798.51, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5085.94}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.19, ["Fly"] = 45.47, ["Ride"] = 20.65, ["Fly|Ride"] = 57.51, ["Neon"] = 120.16, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 319.93, ["Mega"] = 201.14, ["Mega|Ride"] = 373.74, ["Mega|Fly|Ride"] = 356.03}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.47, ["Fly"] = 66.94, ["Ride"] = 20.94, ["Fly|Ride"] = 52.61, ["Neon"] = 85.32, ["Neon|Fly"] = 315, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 173.34, ["Mega"] = 331.87, ["Mega|Ride"] = 430.24, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 24.68, ["Fly|Ride"] = 50.3, ["Neon"] = 15.75, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.6, ["Ride"] = 26.22, ["Fly|Ride"] = 89.24, ["Neon"] = 8.75, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 195.46, ["Mega"] = 66.05, ["Mega|Ride"] = 141.06, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 115.91, ["Mega"] = 45.94, ["Mega|Fly"] = 201.14, ["Mega|Ride"] = 101.75, ["Mega|Fly|Ride"] = 230.19}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.96, ["Ride"] = 28.88, ["Fly|Ride"] = 173.34, ["Neon"] = 81.26, ["Neon|Ride"] = 112.87, ["Mega"] = 404.42, ["Mega|Ride"] = 413.91, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.03, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.7, ["Fly"] = 321.92, ["Ride"] = 57.63, ["Fly|Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 261.37, ["Mega|Ride"] = 359.25, ["Mega|Fly|Ride"] = 1075.58}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 315, ["Ride"] = 367.5, ["Fly|Ride"] = 551.25, ["Neon|Ride"] = 1602.08, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8066.75, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.12, ["Fly"] = 196.88, ["Ride"] = 26.25, ["Fly|Ride"] = 129.99, ["Neon"] = 58.53, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.17, ["Mega"] = 306.56, ["Mega|Ride"] = 493.69, ["Mega|Fly|Ride"] = 764.74}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.63, ["Ride"] = 30.17, ["Fly|Ride"] = 118.11, ["Neon"] = 3.59, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 42.93, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 36.05, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 86.62, ["Mega|Fly|Ride"] = 191.03}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.93, ["Neon|Ride"] = 144.44, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 34.12, ["Mega|Ride"] = 181.91, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.62, ["Fly"] = 107.9, ["Ride"] = 49.4, ["Fly|Ride"] = 144.38, ["Neon"] = 104.99, ["Neon|Ride"] = 208.7, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 518.44, ["Mega|Ride"] = 631.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.18, ["Ride"] = 72.51, ["Neon"] = 91.95, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 866.58, ["Mega"] = 568.53, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.72, ["Ride"] = 76.12, ["Neon"] = 96.87, ["Neon|Ride"] = 200.82, ["Mega"] = 658.27, ["Mega|Fly|Ride"] = 812}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.02, ["Ride"] = 26.44, ["Fly|Ride"] = 222.29, ["Neon"] = 167.28, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 505.22, ["Mega|Fly|Ride"] = 568.53}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 719.27, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 7.76, ["Fly"] = 40.78, ["Ride"] = 33.5, ["Fly|Ride"] = 82.18, ["Neon"] = 101.83, ["Neon|Ride"] = 131.25, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 781.95}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.3, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 52.5, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 33.06, ["Fly"] = 346.65, ["Ride"] = 115.4, ["Fly|Ride"] = 233.63, ["Neon"] = 146.89, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 412.48, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 77.24, ["Neon"] = 9.69, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 280.58, ["Mega"] = 43.32, ["Mega|Fly"] = 187.16, ["Mega|Ride"] = 382.92, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.18, ["Ride"] = 77.8, ["Neon"] = 262.5, ["Neon|Ride"] = 324.97, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1643.46, ["Mega|Ride"] = 2725.49, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Fly|Ride"] = 300.57, ["Neon"] = 9.98, ["Neon|Fly"] = 188.49, ["Neon|Ride"] = 58.45, ["Neon|Fly|Ride"] = 131.19, ["Mega"] = 62.67, ["Mega|Ride"] = 94.31, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.18, ["Ride"] = 20.76, ["Fly|Ride"] = 100.53, ["Neon"] = 3.66, ["Neon|Fly"] = 49.85, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 31.08, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 131.07, ["Neon"] = 12.76, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 79.67, ["Mega|Ride"] = 137.69, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 51.96, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 247, ["Neon"] = 223.13, ["Neon|Ride"] = 361.6, ["Neon|Fly|Ride"] = 490.4, ["Mega|Ride"] = 1147.64, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2166.69}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.83, ["Neon"] = 20.99, ["Neon|Fly"] = 350.44, ["Mega"] = 139.13, ["Mega|Ride"] = 248.07, ["Mega|Fly|Ride"] = 498.01}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 8.66, ["Neon|Ride"] = 72.01, ["Neon|Fly|Ride"] = 173.34, ["Mega"] = 42.95, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 108.33, ["Ride"] = 32.48, ["Fly|Ride"] = 82.15, ["Neon"] = 32.81, ["Mega"] = 308.7, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 98.44, ["Ride"] = 39.37, ["Fly|Ride"] = 289.89, ["Neon"] = 16.7, ["Neon|Ride"] = 61.73, ["Neon|Fly|Ride"] = 138.99, ["Mega"] = 171.67, ["Mega|Fly"] = 175.88, ["Mega|Ride"] = 187.41, ["Mega|Fly|Ride"] = 347.75}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 95.34, ["Neon"] = 8.98, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 65.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 407.65}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 22.31, ["Fly|Ride"] = 52.5, ["Neon"] = 4.55, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 101.98, ["Mega"] = 65.63, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 15.75, ["Neon|Fly"] = 102.93, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 108.33, ["Mega"] = 146.91, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.07, ["Ride"] = 39.13, ["Fly|Ride"] = 78.75, ["Neon"] = 144.36, ["Neon|Ride"] = 164.07, ["Mega"] = 459.38, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 75.86, ["Ride"] = 95.19, ["Fly|Ride"] = 139.13, ["Neon"] = 490.4, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2007.02, ["Mega|Ride"] = 1613.36, ["Mega|Fly|Ride"] = 1500.78}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.39, ["Fly|Ride"] = 131.25, ["Neon"] = 3.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 19.99, ["Neon|Fly|Ride"] = 144.14, ["Mega"] = 32.81, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 249.55}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.09, ["Ride"] = 16.14, ["Fly|Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Fly"] = 36.85, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 52.01, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.85, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.8, ["Fly"] = 50.93, ["Ride"] = 38.03, ["Fly|Ride"] = 52.5, ["Neon"] = 40.69, ["Neon|Ride"] = 164.07, ["Mega"] = 545.33, ["Mega|Ride"] = 325.05, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4332.85, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.24, ["Fly"] = 101.33, ["Ride"] = 43.35, ["Fly|Ride"] = 98.09, ["Neon"] = 214.99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 258.57, ["Mega|Ride"] = 789.49, ["Mega|Fly|Ride"] = 859.39}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.86, ["Fly|Ride"] = 287.81, ["Neon"] = 10.59, ["Neon|Ride"] = 46.33, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 141.99, ["Mega|Ride"] = 122.19, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 86.44, ["Ride"] = 53.41, ["Fly|Ride"] = 261.97, ["Neon"] = 67.73, ["Neon|Ride"] = 72.34, ["Mega"] = 122.07, ["Mega|Fly|Ride"] = 321.62}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.16, ["Fly"] = 169.31, ["Ride"] = 38.06, ["Fly|Ride"] = 102.38, ["Neon"] = 194.25, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 230.89, ["Mega"] = 2581.37, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 114.58, ["Fly"] = 163.17, ["Ride"] = 118.13, ["Fly|Ride"] = 140.88, ["Neon"] = 396, ["Neon|Fly"] = 823.26, ["Neon|Ride"] = 578.45, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8604.53, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.5, ["Ride"] = 294, ["Fly|Ride"] = 540.53, ["Neon"] = 938.44, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3539.7}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 7.34, ["Ride"] = 55.13, ["Fly|Ride"] = 202.58, ["Neon"] = 98.22, ["Neon|Ride"] = 88.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 459.38, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 455.44}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 16.96, ["Fly|Ride"] = 36.66, ["Neon"] = 6.57, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 84, ["Mega"] = 81.39, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 40.6, ["Ride"] = 20.79, ["Fly|Ride"] = 81.11, ["Neon"] = 25.47, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 113.23, ["Mega"] = 288.7, ["Mega|Ride"] = 245.13, ["Mega|Fly|Ride"] = 306.35}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 347.61, ["Ride"] = 350.43, ["Fly|Ride"] = 761.51, ["Neon"] = 1562.54, ["Neon|Ride"] = 2058.11, ["Neon|Fly|Ride"] = 1762.39, ["Mega"] = 10325.44, ["Mega|Fly|Ride"] = 5847.19}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 9.1, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 33.47, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 471.14}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.06, ["Fly|Ride"] = 60.72, ["Neon"] = 27.57, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 98.03, ["Mega"] = 122.63, ["Mega|Ride"] = 219.15, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.45, ["Fly"] = 6562.5, ["Ride"] = 86.67, ["Fly|Ride"] = 129.99, ["Neon"] = 101.83, ["Neon|Fly"] = 433.3, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 308.73, ["Mega"] = 551.15, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 723.1}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 111.57, ["Fly"] = 157.5, ["Ride"] = 124.57, ["Fly|Ride"] = 143.07, ["Neon|Ride"] = 809.16, ["Neon|Fly|Ride"] = 649.93, ["Mega|Fly|Ride"] = 3226.72}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.86, ["Fly"] = 28.19, ["Ride"] = 28.16, ["Fly|Ride"] = 53.03, ["Neon"] = 140.83, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 127.64, ["Mega"] = 875.44, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 486.96}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Mega"] = 33.36, ["Mega|Ride"] = 109.12, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 16.26, ["Fly|Ride"] = 86.57, ["Neon"] = 2.62, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.92, ["Mega"] = 25.2, ["Mega|Fly"] = 101.11, ["Mega|Ride"] = 48.06, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.86, ["Ride"] = 77.66, ["Fly|Ride"] = 199.49, ["Neon"] = 39.37, ["Neon|Ride"] = 102.36, ["Neon|Fly|Ride"] = 227.91, ["Mega"] = 191.58, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 314.79}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1292.82, ["Ride"] = 1299.38, ["Fly|Ride"] = 1363.69, ["Neon"] = 4447.67, ["Neon|Ride"] = 7221.76, ["Neon|Fly|Ride"] = 4533.53, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 402.71, ["Ride"] = 459.38, ["Fly|Ride"] = 576.19, ["Neon"] = 1680, ["Neon|Ride"] = 2701.54, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17209.05, ["Mega|Fly|Ride"] = 6883.63}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 319.1, ["Fly"] = 405.55, ["Ride"] = 354.15, ["Fly|Ride"] = 406.88, ["Neon"] = 756.1, ["Neon|Fly"] = 866.78, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 207.37, ["Fly"] = 288.75, ["Ride"] = 271.65, ["Fly|Ride"] = 372.65, ["Neon"] = 630, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 702.76, ["Mega|Fly|Ride"] = 3009.45}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 34.55, ["Ride"] = 17.05, ["Fly|Ride"] = 42.45, ["Neon"] = 8.88, ["Neon|Ride"] = 29.24, ["Neon|Fly|Ride"] = 104, ["Mega"] = 69.57, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 213.89, ["Fly"] = 465.82, ["Ride"] = 354.37, ["Fly|Ride"] = 578.45, ["Neon"] = 1050, ["Neon|Ride"] = 1284.33, ["Neon|Fly|Ride"] = 1299.36, ["Mega"] = 21798.49, ["Mega|Ride"] = 5449.9, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.71, ["Fly"] = 157.5, ["Ride"] = 71.51, ["Neon"] = 33.94, ["Neon|Ride"] = 119.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.88, ["Mega|Ride"] = 342.55, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 17.35, ["Fly|Ride"] = 38.98, ["Neon"] = 8.68, ["Neon|Ride"] = 54.17, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 117.08, ["Mega|Ride"] = 163.14, ["Mega|Fly|Ride"] = 120.8}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.18, ["Neon"] = 3.02, ["Neon|Ride"] = 46.73, ["Mega"] = 82.07, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.5, ["Ride"] = 57.75, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8172.34, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 16.28, ["Neon|Ride"] = 61.13, ["Mega"] = 357.1, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.69, ["Mega|Ride"] = 71, ["Mega|Fly|Ride"] = 159.2}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 85.99, ["Ride"] = 33.24, ["Fly|Ride"] = 81.38, ["Neon"] = 26.17, ["Neon|Fly"] = 115.91, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 191.26, ["Mega"] = 170.52, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 45.51, ["Ride"] = 19.51, ["Fly|Ride"] = 42, ["Neon"] = 37.92, ["Neon|Fly"] = 147.13, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 17.35, ["Ride"] = 38.06, ["Fly|Ride"] = 105, ["Neon"] = 94.25, ["Neon|Ride"] = 188.49, ["Neon|Fly|Ride"] = 325.05, ["Mega"] = 430.24, ["Mega|Ride"] = 805.62}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6538.37, ["Ride"] = 17.07, ["Fly|Ride"] = 131.24, ["Neon"] = 51.98, ["Neon|Ride"] = 215.4, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 341.25, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 68.16, ["Ride"] = 16.34, ["Fly|Ride"] = 45.94, ["Neon"] = 2.63, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 115.88, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 226.79}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 142.7, ["Fly"] = 231.82, ["Ride"] = 164.05, ["Fly|Ride"] = 259.98, ["Neon"] = 982.48, ["Neon|Ride"] = 861.16, ["Neon|Fly|Ride"] = 840, ["Mega"] = 8604.53, ["Mega|Ride"] = 4087.17, ["Mega|Fly|Ride"] = 4017.25}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 16.26, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 36.79, ["Neon|Ride"] = 23.84, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.65, ["Mega|Ride"] = 58.09, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.84, ["Ride"] = 41.18, ["Fly|Ride"] = 230.89, ["Neon"] = 39.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 784.63, ["Mega"] = 262.5, ["Mega|Ride"] = 430.97, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.63, ["Ride"] = 426.38, ["Fly|Ride"] = 183.75, ["Neon"] = 190.32, ["Neon|Ride"] = 302.24, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 786.19, ["Mega|Ride"] = 901.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 170.63, ["Fly"] = 311.36, ["Ride"] = 268.7, ["Fly|Ride"] = 319.39, ["Neon"] = 812.4, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 808.1, ["Mega|Fly|Ride"] = 3548.31}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.83, ["Ride"] = 164.27, ["Fly|Ride"] = 147.11, ["Neon"] = 124.69, ["Neon|Ride"] = 145.34, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 270.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 394.75}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.03, ["Fly"] = 98.09, ["Ride"] = 43.37, ["Fly|Ride"] = 72.59, ["Neon"] = 122.25, ["Neon|Fly"] = 164.29, ["Neon|Ride"] = 327.35, ["Neon|Fly|Ride"] = 216.66, ["Mega"] = 1219.71, ["Mega|Ride"] = 1434.82, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 931.88, ["Fly"] = 1144.9, ["Ride"] = 1016.97, ["Fly|Ride"] = 1035.46, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5250, ["Mega|Fly|Ride"] = 16922.95}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.12, ["Fly"] = 24.83, ["Ride"] = 21.56, ["Fly|Ride"] = 45.93, ["Neon"] = 47.24, ["Neon|Fly"] = 76.44, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 242.82, ["Mega|Ride"] = 287.19, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.09, ["Fly"] = 78.75, ["Ride"] = 49.88, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 98.1, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 301.18}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.67, ["Ride"] = 24.6, ["Fly|Ride"] = 62.99, ["Neon"] = 9.82, ["Neon|Ride"] = 47.75, ["Neon|Fly|Ride"] = 82.16, ["Mega"] = 91.87, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.19, ["Fly"] = 58.51, ["Ride"] = 32.81, ["Fly|Ride"] = 98.09, ["Neon"] = 72.41, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 97.44, ["Neon|Fly|Ride"] = 180.36, ["Mega"] = 446.22, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 461.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 21, ["Fly|Ride"] = 45.85, ["Neon"] = 23.87, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 108.33, ["Mega"] = 131.25, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 172.65}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.15, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 49.06, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.49, ["Mega|Ride"] = 171.03}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 245.13, ["Ride"] = 270.82, ["Fly|Ride"] = 433.3, ["Neon"] = 938.06, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3906.47}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 23.63, ["Fly|Ride"] = 145.17, ["Neon"] = 6.14, ["Neon|Ride"] = 50.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 57.66, ["Mega|Ride"] = 100.88, ["Mega|Fly|Ride"] = 344.19}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.49, ["Ride"] = 33.59, ["Fly|Ride"] = 88.86, ["Neon"] = 33.12, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 177.75, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.74, ["Ride"] = 25.99, ["Neon"] = 15.27, ["Neon|Ride"] = 72.59, ["Mega"] = 91.85, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 258.15}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 81.84, ["Ride"] = 129.56, ["Fly|Ride"] = 249.38, ["Neon"] = 446.27, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 375.89, ["Mega"] = 2581.37, ["Mega|Ride"] = 1577.87, ["Mega|Fly|Ride"] = 1822.02}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.64, ["Fly"] = 88.08, ["Ride"] = 39.38, ["Fly|Ride"] = 268.66, ["Neon"] = 181.32, ["Neon|Ride"] = 210.16, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.24, ["Mega|Ride"] = 643.21, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.68, ["Fly"] = 58.51, ["Ride"] = 35.44, ["Fly|Ride"] = 103.69, ["Neon"] = 93.19, ["Neon|Ride"] = 172.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 474.34, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 513.18}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 118.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 558.24}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 38.06, ["Fly"] = 87.27, ["Ride"] = 71.44, ["Fly|Ride"] = 162.75, ["Neon"] = 223.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.59, ["Neon|Fly|Ride"] = 275.63, ["Mega|Fly|Ride"] = 860.46}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 6.04, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 128.92, ["Mega"] = 61.32, ["Mega|Ride"] = 286.12, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.15, ["Fly"] = 131.18, ["Ride"] = 32.47, ["Fly|Ride"] = 86.67, ["Neon"] = 63.91, ["Neon|Ride"] = 101.77, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 429.17, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 54.74, ["Fly"] = 203.41, ["Ride"] = 69.57, ["Fly|Ride"] = 139.22, ["Neon"] = 255.94, ["Neon|Fly"] = 433.3, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 398.34, ["Mega|Ride"] = 1471.38, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.21, ["Ride"] = 16.15, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 28.18, ["Neon|Ride"] = 16.68, ["Neon|Fly|Ride"] = 43.35, ["Mega"] = 20.2, ["Mega|Fly"] = 121.75, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 86.7}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 64.32, ["Neon"] = 19.44, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 393.75, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.86, ["Fly"] = 145.17, ["Ride"] = 41.91, ["Fly|Ride"] = 117.24, ["Neon"] = 110.25, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 639.97, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 17.99, ["Mega|Ride"] = 52.36, ["Mega|Fly|Ride"] = 215.13}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 20.37, ["Fly"] = 207.9, ["Ride"] = 81.27, ["Fly|Ride"] = 196.85, ["Neon"] = 147.21, ["Neon|Ride"] = 173.37, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 644.41, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 596, ["Mega|Fly|Ride"] = 987.38}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.09, ["Fly"] = 43.35, ["Ride"] = 26.25, ["Fly|Ride"] = 89.92, ["Neon"] = 376.69, ["Neon|Ride"] = 121.8, ["Neon|Fly|Ride"] = 165.65, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 514.14}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.84, ["Ride"] = 51.45, ["Neon"] = 67.57, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 717.42, ["Mega"] = 233.52, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 429.17}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.57, ["Fly"] = 72.19, ["Ride"] = 72.1, ["Fly|Ride"] = 237.34, ["Neon"] = 58.4, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 242.19, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 43.35, ["Ride"] = 26.74, ["Fly|Ride"] = 196.88, ["Neon"] = 7.82, ["Neon|Ride"] = 36.2, ["Mega"] = 53.8, ["Mega|Fly"] = 215.13, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.85, ["Neon"] = 3.15, ["Neon|Ride"] = 88.83, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 47.65, ["Mega|Ride"] = 103.59, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 20.57}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.75, ["Fly"] = 101.07, ["Ride"] = 66.94, ["Fly|Ride"] = 91.87, ["Neon"] = 184.58, ["Neon|Ride"] = 216.66, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.33, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Mega"] = 22.19, ["Mega|Ride"] = 110.8, ["Mega|Fly|Ride"] = 322.69}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Fly"] = 541.63, ["Ride"] = 561.75, ["Fly|Ride"] = 459.38, ["Neon"] = 2888.93, ["Neon|Ride"] = 2708.04, ["Neon|Fly|Ride"] = 2162.1, ["Mega"] = 17209.05, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.6, ["Fly"] = 48.37, ["Ride"] = 33.73, ["Fly|Ride"] = 49.05, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.91, ["Mega"] = 289.17, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 631.38}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.84, ["Fly"] = 29.27, ["Ride"] = 19.52, ["Fly|Ride"] = 60.82, ["Neon"] = 51.86, ["Neon|Ride"] = 65.01, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 147, ["Mega|Fly"] = 287.19, ["Mega|Ride"] = 173.75, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.95, ["Ride"] = 29.27, ["Fly|Ride"] = 541.63, ["Neon"] = 112.88, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 650.09, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 433.3, ["Ride"] = 38.57, ["Fly|Ride"] = 72.59, ["Neon"] = 32.39, ["Neon|Fly"] = 50.93, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 280.23, ["Mega|Fly|Ride"] = 501.23}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.31, ["Ride"] = 73.49, ["Fly|Ride"] = 177.68, ["Neon"] = 54.45, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 557.17, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1019.8}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.75, ["Ride"] = 46.59, ["Fly|Ride"] = 91.88, ["Neon"] = 28.09, ["Neon|Ride"] = 81.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 222.99, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 43.84, ["Ride"] = 13.8, ["Fly|Ride"] = 86.67, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 19.51, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 14.79, ["Mega|Fly"] = 66.21, ["Mega|Ride"] = 36.59, ["Mega|Fly|Ride"] = 104.55}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.29, ["Fly"] = 49.88, ["Ride"] = 39.01, ["Fly|Ride"] = 108.33, ["Neon"] = 29.3, ["Neon|Fly"] = 122.6, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 165.8, ["Mega"] = 196.88, ["Mega|Ride"] = 259.77, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.88, ["Ride"] = 360.19, ["Fly|Ride"] = 367.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9446.8, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 79.93, ["Ride"] = 126, ["Fly|Ride"] = 258.89, ["Neon"] = 430.99, ["Neon|Fly"] = 927.24, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 644.53, ["Mega"] = 2295.27, ["Mega|Ride"] = 1708.02, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 17.34, ["Fly|Ride"] = 36.75, ["Neon"] = 6.39, ["Neon|Fly"] = 72.59, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 144.14, ["Mega|Fly"] = 214.05, ["Mega|Ride"] = 101.11, ["Mega|Fly|Ride"] = 260.54}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 15.72, ["Fly|Ride"] = 35.6, ["Neon"] = 8.93, ["Neon|Fly"] = 39, ["Neon|Ride"] = 25.41, ["Neon|Fly|Ride"] = 61.06, ["Mega"] = 58.95, ["Mega|Fly"] = 287.19, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 101.83, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 101.83, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 327.91, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 207.89, ["Fly"] = 327.3, ["Ride"] = 248.15, ["Fly|Ride"] = 288.65, ["Neon"] = 1191.54, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1605.33, ["Mega|Ride"] = 8604.53, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 31.12, ["Ride"] = 17.81, ["Fly|Ride"] = 39.52, ["Neon"] = 18.39, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 38.69, ["Neon|Fly|Ride"] = 86.05, ["Mega"] = 262.5, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.05, ["Ride"] = 77.87, ["Fly|Ride"] = 216.01, ["Neon"] = 70.88, ["Neon|Ride"] = 108.33, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 196.88, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 460.36}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Ride"] = 137.82, ["Mega"] = 101.07, ["Mega|Ride"] = 340.88}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.12, ["Fly"] = 49.13, ["Ride"] = 26, ["Fly|Ride"] = 65.63, ["Neon"] = 151.66, ["Neon|Ride"] = 111.22, ["Neon|Fly|Ride"] = 237.71, ["Mega"] = 460.69, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 577.61}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.96, ["Fly"] = 100.54, ["Ride"] = 72.19, ["Fly|Ride"] = 396.48, ["Neon"] = 132.34, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 142.59, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 574.37, ["Mega|Fly"] = 2258.7, ["Mega|Ride"] = 503.28, ["Mega|Fly|Ride"] = 647.07}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.85, ["Ride"] = 42.49, ["Fly|Ride"] = 91.77, ["Neon"] = 216.48, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 860.46, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 806.69}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.44, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 30.53, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 42.82, ["Mega"] = 20.99, ["Mega|Fly"] = 430.24, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 209.21, ["Ride"] = 209.99, ["Fly|Ride"] = 272.87, ["Neon"] = 3432.73, ["Neon|Fly|Ride"] = 1225.98, ["Mega|Fly|Ride"] = 5019.68}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.85, ["Fly"] = 101.07, ["Ride"] = 24.62, ["Fly|Ride"] = 92.94, ["Neon"] = 78.75, ["Neon|Ride"] = 115.25, ["Neon|Fly|Ride"] = 287.19, ["Mega"] = 422.63, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.77, ["Fly|Ride"] = 42.26, ["Neon"] = 5.6, ["Neon|Fly"] = 43.29, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 105, ["Mega"] = 62.1, ["Mega|Fly"] = 223.74, ["Mega|Ride"] = 86.05, ["Mega|Fly|Ride"] = 234.18}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.14, ["Fly|Ride"] = 79.4, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 131.19, ["Mega"] = 28.88, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 162.43}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 16.26, ["Fly|Ride"] = 72.18, ["Neon"] = 10.48, ["Neon|Fly"] = 735.59, ["Neon|Ride"] = 46.92, ["Neon|Fly|Ride"] = 101.79, ["Mega"] = 155.53, ["Mega|Ride"] = 123.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.42, ["Fly"] = 47.16, ["Ride"] = 27.02, ["Fly|Ride"] = 63, ["Neon"] = 47.16, ["Neon|Fly"] = 275.15, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 111.14, ["Mega"] = 608.7, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 430.95}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.74, ["Ride"] = 45.51, ["Fly|Ride"] = 144.38, ["Neon"] = 107.27, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 486.96}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.74, ["Neon"] = 2.1, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 101.81, ["Mega"] = 23.63, ["Mega|Ride"] = 194.79, ["Mega|Fly|Ride"] = 148.57}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.06, ["Ride"] = 34.04, ["Fly|Ride"] = 145.17, ["Neon"] = 35.13, ["Neon|Fly"] = 98.1, ["Neon|Ride"] = 44.34, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 156.19, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 143.75, ["Neon"] = 3.76, ["Neon|Fly"] = 115.91, ["Neon|Ride"] = 55.08, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.67, ["Mega|Ride"] = 107.58, ["Mega|Fly|Ride"] = 327.46}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 49.38, ["Ride"] = 21.95, ["Fly|Ride"] = 44.63, ["Neon"] = 5.1, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 77.32, ["Mega|Ride"] = 78, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 604.59, ["Ride"] = 730.91, ["Fly|Ride"] = 771.75, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 18.23, ["Fly|Ride"] = 43.35, ["Neon"] = 17.07, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 192.54, ["Mega|Fly|Ride"] = 398.1}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 51.19, ["Fly|Ride"] = 64.8, ["Neon"] = 15.51, ["Neon|Fly"] = 758.26, ["Neon|Ride"] = 115.91, ["Neon|Fly|Ride"] = 187.16, ["Mega"] = 74.8, ["Mega|Fly"] = 191.47, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.42, ["Fly"] = 33.59, ["Ride"] = 21.89, ["Fly|Ride"] = 62.11, ["Neon"] = 41.48, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 124.74, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 14.44, ["Fly|Ride"] = 58.51, ["Neon"] = 5.94, ["Neon|Fly"] = 151.66, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 62.89, ["Mega|Ride"] = 91.23, ["Mega|Fly|Ride"] = 180.22}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.99, ["Ride"] = 80.17, ["Fly|Ride"] = 319.56, ["Neon"] = 218.18, ["Neon|Ride"] = 210, ["Mega"] = 729.24, ["Mega|Ride"] = 730.44, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 20.79, ["Fly|Ride"] = 76.13, ["Neon"] = 6.57, ["Neon|Fly"] = 139.78, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 112.38, ["Mega"] = 46.22, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.37, ["Fly|Ride"] = 59.28, ["Neon"] = 12.72, ["Neon|Ride"] = 48.57, ["Mega"] = 112.34, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 10.4, ["Neon|Fly|Ride"] = 115.91, ["Mega"] = 97.12, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 43.35, ["Ride"] = 18.32, ["Fly|Ride"] = 69.09, ["Neon"] = 3.67, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 41.97, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 130.28}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15, ["Fly"] = 21.49, ["Ride"] = 20.1, ["Fly|Ride"] = 38.06, ["Neon"] = 118.13, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 163.54, ["Mega|Ride"] = 562.53, ["Mega|Fly|Ride"] = 402.28}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 636.57, ["Fly"] = 1011.72, ["Ride"] = 771.74, ["Fly|Ride"] = 708.75, ["Neon"] = 1935.94, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2164.32, ["Mega"] = 6597.53, ["Mega|Fly|Ride"] = 5737.08}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.2, ["Fly|Ride"] = 41.47, ["Neon"] = 4.11, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 62.84, ["Mega"] = 47.34, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 174.16}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.49, ["Fly"] = 26.17, ["Ride"] = 32.81, ["Fly|Ride"] = 202.04, ["Neon"] = 70.26, ["Neon|Ride"] = 215.57, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 393.73, ["Mega|Fly|Ride"] = 438.27}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 54.92, ["Fly"] = 104.9, ["Ride"] = 78.75, ["Fly|Ride"] = 111.57, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.43, ["Fly"] = 146.86, ["Ride"] = 61.3, ["Fly|Ride"] = 107.89, ["Neon"] = 202.58, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 1460.86, ["Mega|Ride"] = 919.63, ["Mega|Fly|Ride"] = 1137.04}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.67, ["Fly"] = 91.95, ["Ride"] = 26.49, ["Fly|Ride"] = 145.17, ["Neon"] = 50.93, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.36, ["Mega|Ride"] = 416.26, ["Mega|Fly|Ride"] = 451.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.49, ["Ride"] = 56.11, ["Fly|Ride"] = 143, ["Neon"] = 104.9, ["Neon|Ride"] = 376.39, ["Neon|Fly|Ride"] = 150.73, ["Mega"] = 322.87, ["Mega|Fly"] = 528.35, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 438.27}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 22.71, ["Ride"] = 78.75, ["Fly|Ride"] = 162.49, ["Neon"] = 145.3, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 750.77}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.52}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.87, ["Ride"] = 21, ["Fly|Ride"] = 78.75, ["Neon"] = 41.67, ["Neon|Ride"] = 66.22, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.62, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 216.66, ["Mega"] = 143.06}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.45, ["Fly"] = 62.99, ["Ride"] = 36.66, ["Fly|Ride"] = 81.38, ["Neon"] = 210, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 300.84, ["Mega|Ride"] = 574.37, ["Mega|Fly|Ride"] = 616.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 25.99, ["Ride"] = 17.74, ["Fly|Ride"] = 39.81, ["Neon"] = 26.72, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 72.72, ["Mega"] = 201.14, ["Mega|Fly"] = 429.17, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 197.96}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.83, ["Fly"] = 108.22, ["Ride"] = 25.64, ["Fly|Ride"] = 42.77, ["Neon"] = 24.99, ["Neon|Ride"] = 55.86, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 169.33, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 72.59, ["Neon"] = 3.15, ["Mega"] = 44.72, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.74, ["Ride"] = 65.01, ["Fly|Ride"] = 145.17, ["Neon"] = 245.9, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 430.24, ["Mega|Ride"] = 1720.91, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 58.43, ["Neon"] = 9.09, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 74.09, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.17, ["Ride"] = 58.51, ["Fly|Ride"] = 288.15, ["Neon"] = 59.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 324.97, ["Mega"] = 393.75, ["Mega|Fly"] = 574.37, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 602.34}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 16.86, ["Fly|Ride"] = 61.69, ["Neon"] = 28.87, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.24, ["Fly"] = 52.49, ["Ride"] = 24.53, ["Fly|Ride"] = 88.83, ["Neon"] = 46.71, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 402.28, ["Mega|Ride"] = 429.17, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.28, ["Ride"] = 95.34, ["Neon"] = 114.15, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 48.72, ["Ride"] = 97.44, ["Fly|Ride"] = 91.88, ["Neon"] = 210, ["Neon|Ride"] = 490.4, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1219.71, ["Mega|Ride"] = 1290.7, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.05, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Mega"] = 377.9, ["Mega|Ride"] = 568.53, ["Mega|Fly|Ride"] = 715.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 2.82, ["Ride"] = 126.03, ["Neon"] = 52, ["Neon|Fly"] = 216.66, ["Neon|Ride"] = 170.63, ["Mega"] = 812, ["Mega|Ride"] = 486.96}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.38, ["Ride"] = 72.59, ["Fly|Ride"] = 367.48, ["Neon"] = 113.28, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 670.08, ["Mega|Fly"] = 2151.15, ["Mega|Ride"] = 669.57, ["Mega|Fly|Ride"] = 773.34}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.12, ["Neon"] = 19.13, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 187.16, ["Mega|Fly|Ride"] = 325.05}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 18.59, ["Fly|Ride"] = 43.32, ["Neon"] = 7.88, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 98.1, ["Mega"] = 97.4, ["Mega|Ride"] = 136.92, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.62, ["Fly"] = 45.94, ["Ride"] = 29.13, ["Fly|Ride"] = 73.22, ["Neon"] = 25.6, ["Neon|Ride"] = 119.17, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 89.15, ["Mega|Ride"] = 144.14, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.32, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 25.93, ["Neon|Fly|Ride"] = 123.51, ["Mega"] = 52.28, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 175.33}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.04, ["Fly|Ride"] = 72.59, ["Neon"] = 18.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 215.13, ["Mega"] = 289.07, ["Mega|Ride"] = 329.14, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.61, ["Fly"] = 51.16, ["Ride"] = 24.53, ["Fly|Ride"] = 93.19, ["Neon"] = 29.89, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 305.47, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1075.58}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.32, ["Fly|Ride"] = 70.88, ["Neon"] = 36.7, ["Neon|Fly"] = 129.99, ["Neon|Ride"] = 43.56, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 306.51, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 402.28}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 22.92, ["Fly|Ride"] = 52.41, ["Neon"] = 22.23, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 108.33, ["Mega"] = 258.15, ["Mega|Ride"] = 215.13, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 46.66, ["Fly|Ride"] = 180.92, ["Neon"] = 11.46, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 106.32, ["Mega|Fly"] = 210, ["Mega|Ride"] = 145.59, ["Mega|Fly|Ride"] = 257.22}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.5, ["Ride"] = 125.99, ["Fly|Ride"] = 375.38, ["Neon"] = 145.17, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 259.98, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 574.37, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 715.07}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.27, ["Fly"] = 164.07, ["Ride"] = 89.25, ["Fly|Ride"] = 161.44, ["Neon"] = 248.07, ["Neon|Ride"] = 202.58, ["Neon|Fly|Ride"] = 360.62, ["Mega"] = 1576.8, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1106.89}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.1, ["Ride"] = 21.56, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 25.81, ["Mega|Ride"] = 71.03, ["Mega|Fly|Ride"] = 140.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.6, ["Ride"] = 78.75, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1133.66}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.92, ["Ride"] = 91.91, ["Neon"] = 262.5, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 865.5, ["Mega"] = 1202.78, ["Mega|Ride"] = 1217.39, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.76, ["Fly"] = 190.32, ["Ride"] = 36.66, ["Fly|Ride"] = 133.88, ["Neon"] = 43.35, ["Neon|Fly"] = 131.19, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 262.44, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 32.59, ["Neon"] = 16.44, ["Neon|Ride"] = 68.16, ["Mega"] = 103.59, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 261.84}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 18.78, ["Fly|Ride"] = 39.38, ["Neon"] = 10.77, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 236.25, ["Mega|Ride"] = 117.93, ["Mega|Fly|Ride"] = 430.24}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 14.69, ["Ride"] = 16.7, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Fly"] = 34.68, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 25.06, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.51, ["Fly|Ride"] = 86.67, ["Neon"] = 2.63, ["Neon|Ride"] = 24.3, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.26, ["Mega|Fly"] = 140.02, ["Mega|Ride"] = 60.01, ["Mega|Fly|Ride"] = 192.54}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 31.5, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.66, ["Ride"] = 104.99, ["Neon"] = 42, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 424.87, ["Mega|Ride"] = 346.2, ["Mega|Fly|Ride"] = 427.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.28, ["Ride"] = 30.19, ["Fly|Ride"] = 215.76, ["Neon"] = 58.46, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 262.5, ["Mega|Ride"] = 287.19, ["Mega|Fly|Ride"] = 430.24}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.52, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 38.69, ["Neon"] = 30.18, ["Neon|Ride"] = 38.56, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 339.9, ["Mega|Ride"] = 292.19, ["Mega|Fly|Ride"] = 359.34}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.89, ["Ride"] = 88.54, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 289.23, ["Neon|Fly|Ride"] = 722.52, ["Mega"] = 2434.76, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.74, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 78.75, ["Neon"] = 145.17, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.94, ["Fly|Ride"] = 40.65, ["Neon"] = 2.63, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 53.62, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.42, ["Fly|Ride"] = 32.81, ["Neon"] = 2.63, ["Neon|Fly"] = 29.27, ["Neon|Ride"] = 21.69, ["Neon|Fly|Ride"] = 43.3, ["Mega"] = 43.32, ["Mega|Ride"] = 61.32, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 433.13, ["Fly"] = 572.46, ["Ride"] = 441.83, ["Fly|Ride"] = 510.57, ["Neon|Fly|Ride"] = 1947.62, ["Mega|Fly|Ride"] = 6812.64}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 2.1, ["Fly"] = 115.91, ["Ride"] = 47.7, ["Neon"] = 23.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 645.36, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 16.27, ["Ride"] = 19.51, ["Fly|Ride"] = 34.04, ["Neon"] = 5.16, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 63.48, ["Mega|Ride"] = 84.49, ["Mega|Fly|Ride"] = 113.93}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 55.13, ["Ride"] = 98.44, ["Fly|Ride"] = 216.57, ["Neon"] = 194.25, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 737.63, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 929.25}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 20.78, ["Fly|Ride"] = 56.48, ["Neon"] = 15.98, ["Neon|Fly"] = 80.17, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 80.77, ["Mega"] = 125.89, ["Mega|Ride"] = 148.44, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 72.59, ["Ride"] = 58.51, ["Fly|Ride"] = 196.88, ["Neon"] = 3.78, ["Neon|Fly"] = 101.83, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.82, ["Mega|Ride"] = 72.08, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 33.99, ["Fly"] = 129.94, ["Ride"] = 78.74, ["Fly|Ride"] = 215.73, ["Neon"] = 210.16, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 812, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 23.55, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 3.74, ["Neon|Ride"] = 39.38, ["Mega"] = 52.49, ["Mega|Ride"] = 157.25, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.37, ["Ride"] = 59.08, ["Fly|Ride"] = 105, ["Neon"] = 150.59, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1290.7, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.4, ["Fly"] = 72.59, ["Ride"] = 131.25, ["Fly|Ride"] = 433.3, ["Neon"] = 18.37, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 164.29, ["Mega"] = 159.3, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.19, ["Fly"] = 72.59, ["Ride"] = 74.25, ["Fly|Ride"] = 58.51, ["Neon"] = 9.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 115.1, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 303.32}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.7, ["Fly"] = 86.67, ["Ride"] = 65.63, ["Fly|Ride"] = 541.63, ["Neon"] = 245.2, ["Neon|Ride"] = 419.22, ["Mega|Ride"] = 1720.91, ["Mega|Fly|Ride"] = 2009.17}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.46, ["Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 115.91, ["Mega"] = 45.92, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 139.83, ["Mega|Fly|Ride"] = 244.16}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 19.49, ["Fly|Ride"] = 96.78, ["Neon"] = 8.59, ["Neon|Fly"] = 42, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 59.13, ["Mega|Fly"] = 149.76, ["Mega|Ride"] = 121.75, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.79, ["Fly"] = 57.91, ["Ride"] = 26.25, ["Fly|Ride"] = 172.25, ["Neon"] = 80.07, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 328.01, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.14, ["Fly"] = 65.63, ["Ride"] = 27.36, ["Fly|Ride"] = 67.81, ["Neon"] = 66.22, ["Neon|Ride"] = 77.21, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 752.91, ["Mega|Ride"] = 454.98, ["Mega|Fly|Ride"] = 856.16}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.38, ["Fly"] = 48.57, ["Ride"] = 28.68, ["Fly|Ride"] = 65.63, ["Neon"] = 80.56, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 149.44, ["Mega"] = 408.98, ["Mega|Ride"] = 327.44, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 58.56, ["Ride"] = 126, ["Fly|Ride"] = 246.75, ["Neon"] = 308.43, ["Neon|Ride"] = 283.48, ["Neon|Fly|Ride"] = 559.31, ["Mega"] = 1575, ["Mega|Ride"] = 1362.76, ["Mega|Fly|Ride"] = 1534.85}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.66, ["Ride"] = 115.4, ["Fly|Ride"] = 203.44, ["Neon"] = 55.13, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 239.09, ["Mega|Fly"] = 571.14, ["Mega|Ride"] = 381.85, ["Mega|Fly|Ride"] = 557.17}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.63, ["Ride"] = 27.29, ["Fly|Ride"] = 78.74, ["Neon"] = 23.08, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 142.58, ["Mega|Ride"] = 242.02, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.05, ["Fly"] = 135.19, ["Ride"] = 36.36, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 60.57, ["Mega"] = 455.31, ["Mega|Fly|Ride"] = 860.46}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.49, ["Fly|Ride"] = 41.4, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 15.65, ["Mega|Ride"] = 26.78, ["Mega|Fly|Ride"] = 114.33}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.97, ["Fly"] = 229.65, ["Ride"] = 103.69, ["Fly|Ride"] = 131.25, ["Neon"] = 236.25, ["Neon|Fly"] = 2455.64, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 1298.95, ["Mega"] = 1072.36, ["Mega|Ride"] = 1062.67, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 112.22, ["Neon"] = 6.09, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 86.45, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 17.59, ["Fly|Ride"] = 45.94, ["Neon"] = 13.13, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.45, ["Ride"] = 87.94, ["Fly|Ride"] = 118.13, ["Neon"] = 225.65, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 358.55, ["Mega"] = 1137.04, ["Mega|Ride"] = 1765.32, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 72.19, ["Neon"] = 7.82, ["Neon|Ride"] = 1445.01, ["Mega"] = 72.08, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 114.44, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.71}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.62, ["Fly|Ride"] = 65.01, ["Neon"] = 7.33, ["Neon|Ride"] = 84.55, ["Neon|Fly|Ride"] = 115.29, ["Mega"] = 78.74, ["Mega|Ride"] = 105.23, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.04, ["Ride"] = 183.89, ["Fly|Ride"] = 340.14, ["Neon"] = 883.92, ["Neon|Ride"] = 592.77, ["Neon|Fly|Ride"] = 671.77, ["Mega"] = 6453.41, ["Mega|Ride"] = 2868.54, ["Mega|Fly|Ride"] = 2623.31}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 36.47, ["Fly|Ride"] = 122.59, ["Neon"] = 21.95, ["Neon|Fly"] = 145.17, ["Neon|Ride"] = 63.92, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.5, ["Mega|Ride"] = 214.05, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Ride"] = 24.93, ["Mega"] = 33.5, ["Mega|Ride"] = 72.08, ["Mega|Fly|Ride"] = 344.19}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.75, ["Fly"] = 18.38, ["Ride"] = 32.48, ["Fly|Ride"] = 98.44, ["Neon"] = 56.99, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 146.86, ["Mega"] = 430.24, ["Mega|Ride"] = 430.24, ["Mega|Fly|Ride"] = 644.28}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.6, ["Fly"] = 57.31, ["Ride"] = 21.69, ["Fly|Ride"] = 58.51, ["Neon"] = 101.03, ["Neon|Ride"] = 158.17, ["Neon|Fly|Ride"] = 276.29, ["Mega"] = 626.07, ["Mega|Ride"] = 639.97, ["Mega|Fly|Ride"] = 359.25}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.99, ["Fly"] = 145.17, ["Ride"] = 51.98, ["Fly|Ride"] = 177.19, ["Neon"] = 127.32, ["Neon|Ride"] = 206.39, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 561.75, ["Mega|Ride"] = 644.28, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.94, ["Fly"] = 196.77, ["Ride"] = 157.4, ["Fly|Ride"] = 234.44, ["Neon"] = 565.13, ["Neon|Fly"] = 695.15, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 643.02, ["Mega|Ride"] = 2581.37, ["Mega|Fly|Ride"] = 2597.88}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 4.34, ["Fly"] = 20.98, ["Ride"] = 19.04, ["Fly|Ride"] = 31.5, ["Neon"] = 44.33, ["Neon|Fly"] = 160.62, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 82.68, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 25.85, ["Fly|Ride"] = 131.25, ["Neon"] = 20.01, ["Neon|Ride"] = 34.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 127.17, ["Mega|Ride"] = 183.93, ["Mega|Fly|Ride"] = 291.98}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.29, ["Fly"] = 42.78, ["Ride"] = 40.68, ["Fly|Ride"] = 129.99, ["Neon"] = 51.18, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 164.29, ["Mega"] = 429.66, ["Mega|Ride"] = 401.97, ["Mega|Fly|Ride"] = 406.61}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 40.74, ["Fly"] = 115.91, ["Ride"] = 79.01, ["Fly|Ride"] = 134.37, ["Neon"] = 170.61, ["Neon|Ride"] = 259.87, ["Neon|Fly|Ride"] = 272.99, ["Mega"] = 962.64, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.1}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.35, ["Fly"] = 57.75, ["Ride"] = 72.66, ["Neon"] = 196.88, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 477.71, ["Mega"] = 808.89, ["Mega|Ride"] = 1932}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 328.02, ["Ride"] = 578.45, ["Neon|Ride"] = 3269.66}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.85, ["Fly"] = 58.63, ["Ride"] = 33.76, ["Fly|Ride"] = 69.3, ["Neon"] = 251.31, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 252.57, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 1075.58}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 43.33, ["Ride"] = 12.74, ["Fly|Ride"] = 72.59, ["Neon"] = 2.1, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 20.88, ["Mega|Fly"] = 114.02, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 115.31}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.1, ["Neon"] = 12.47, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 115.1, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Fly"] = 32.45, ["Ride"] = 30.19, ["Fly|Ride"] = 144.2, ["Neon"] = 21.18, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 130.56, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 321.62, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 328.13, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 536.54, ["Neon"] = 1898.49, ["Neon|Ride"] = 2077.61, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5590.8}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Ride"] = 16.69, ["Fly|Ride"] = 49.85, ["Neon"] = 19.69, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 205.96, ["Mega|Ride"] = 180.18, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.93, ["Fly"] = 22.32, ["Ride"] = 19.5, ["Fly|Ride"] = 44.37, ["Neon"] = 29.27, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 60.67, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 163.14, ["Mega|Ride"] = 291.48, ["Mega|Fly|Ride"] = 285.55}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.77, ["Fly"] = 45.82, ["Ride"] = 23.63, ["Fly|Ride"] = 52.92, ["Neon"] = 11.97, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 109.6, ["Mega"] = 144.14, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.66, ["Fly"] = 49.05, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 323.9, ["Mega"] = 717.42, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 54.17, ["Ride"] = 36.85, ["Fly|Ride"] = 51.75, ["Neon"] = 11.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.88, ["Fly"] = 65.61, ["Ride"] = 49.85, ["Fly|Ride"] = 101.83, ["Neon"] = 168.9, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 781.95}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 16.58, ["Neon"] = 3.83, ["Neon|Ride"] = 25.83, ["Neon|Fly|Ride"] = 98.1, ["Mega"] = 54.85, ["Mega|Ride"] = 118.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.72, ["Fly"] = 72.19, ["Ride"] = 145.17, ["Neon"] = 46.59, ["Mega"] = 136.02, ["Mega|Ride"] = 325.05, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.2, ["Ride"] = 43.2, ["Neon"] = 62.84, ["Neon|Ride"] = 289.23, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 317.3, ["Mega|Ride"] = 558.24, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.24, ["Fly"] = 37.91, ["Ride"] = 22.14, ["Fly|Ride"] = 52.62, ["Neon"] = 55.01, ["Neon|Fly"] = 115.25, ["Neon|Ride"] = 54.57, ["Neon|Fly|Ride"] = 126.04, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 446.25, ["Fly"] = 524.06, ["Ride"] = 471.68, ["Fly|Ride"] = 482.9, ["Neon"] = 1642.41, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.13, ["Fly|Ride"] = 39.35, ["Neon"] = 35.44, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 184.42, ["Mega"] = 230.19, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 305.58}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.12, ["Fly"] = 65.01, ["Ride"] = 16.26, ["Fly|Ride"] = 188.64, ["Neon"] = 102.61, ["Neon|Ride"] = 123.46, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 359.63, ["Mega|Fly"] = 717.42, ["Mega|Ride"] = 420}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 19.95, ["Ride"] = 89.25, ["Fly|Ride"] = 323.9, ["Neon"] = 89.93, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 366.09, ["Mega"] = 288.75, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 490.92}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 60.8, ["Fly"] = 151.41, ["Ride"] = 94.4, ["Fly|Ride"] = 131.25, ["Neon"] = 321.57, ["Neon|Ride"] = 334.68, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2597.88, ["Mega|Fly|Ride"] = 1739.77}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.45, ["Ride"] = 41.91, ["Fly|Ride"] = 144.37, ["Neon"] = 31.4, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 173.34, ["Mega"] = 144.27, ["Mega|Ride"] = 193.85, ["Mega|Fly|Ride"] = 379.43}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 18.38, ["Fly|Ride"] = 58.47, ["Neon"] = 18.11, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.62, ["Mega|Ride"] = 194.79, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.84, ["Ride"] = 45.83, ["Neon"] = 19.69, ["Neon|Ride"] = 108.33, ["Neon|Fly|Ride"] = 185.24, ["Mega"] = 178.57, ["Mega|Fly"] = 244.16, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 282.35}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.36, ["Fly"] = 137.82, ["Ride"] = 93.19, ["Fly|Ride"] = 183.74, ["Neon"] = 133.35, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 252, ["Mega"] = 441, ["Mega|Ride"] = 455.32, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 84.41, ["Neon"] = 6.37, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 42, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 17.35, ["Ride"] = 216.66, ["Neon"] = 164.29, ["Neon|Ride"] = 374.07, ["Mega"] = 589.32, ["Mega|Fly|Ride"] = 800.23}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 1194.38, ["Ride"] = 1006.59, ["Fly|Ride"] = 1123.4, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 3655.86, ["Mega|Fly|Ride"] = 11000.89}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 10.18, ["Fly"] = 112.17, ["Ride"] = 43.35, ["Fly|Ride"] = 163, ["Neon"] = 64.31, ["Neon|Fly"] = 721.43, ["Neon|Ride"] = 174.01, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 365.23, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.31, ["Fly|Ride"] = 91.49, ["Neon"] = 10.98, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 82.69, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.39, ["Ride"] = 29.27, ["Fly|Ride"] = 145.17, ["Neon"] = 73.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 408.74, ["Mega|Fly|Ride"] = 484.53}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.39, ["Fly|Ride"] = 187.7, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 16.26, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 153.13}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.84, ["Ride"] = 102.26, ["Fly|Ride"] = 231.82, ["Neon"] = 226.96, ["Neon|Ride"] = 268.7, ["Neon|Fly|Ride"] = 389.97, ["Mega"] = 1117.53, ["Mega|Ride"] = 879.37, ["Mega|Fly|Ride"] = 925.32}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.22, ["Ride"] = 62.88, ["Fly|Ride"] = 286.75, ["Neon"] = 115.91, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 824.97, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 23.62, ["Neon"] = 9.97, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 215.13, ["Mega"] = 97.4, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 373.24}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.43, ["Fly"] = 52.5, ["Ride"] = 37.03, ["Fly|Ride"] = 91.77, ["Neon"] = 73.38, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 268.34, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 2.77, ["Fly"] = 97.51, ["Ride"] = 28.18, ["Fly|Ride"] = 173.34, ["Neon"] = 143.8, ["Neon|Fly"] = 131.19, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 430.24, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Neon"] = 216.66, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 2110.94, ["Mega|Ride"] = 2434.76, ["Mega|Fly|Ride"] = 2149}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.62, ["Ride"] = 29.27, ["Fly|Ride"] = 183.65, ["Neon"] = 15.62, ["Neon|Ride"] = 91.96, ["Neon|Fly|Ride"] = 189, ["Mega"] = 70.66, ["Mega|Ride"] = 180.18, ["Mega|Fly|Ride"] = 230.79}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.77, ["Ride"] = 31.14, ["Fly|Ride"] = 85.21, ["Neon"] = 45.09, ["Neon|Fly"] = 188.49, ["Neon|Ride"] = 69.22, ["Neon|Fly|Ride"] = 101.06, ["Mega"] = 261.19, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 382.59}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 118.01, ["Fly"] = 393.75, ["Ride"] = 170.63, ["Fly|Ride"] = 221.82, ["Neon"] = 427.74, ["Neon|Ride"] = 543.08, ["Neon|Fly|Ride"] = 636.38, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2072.44}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 17.55, ["Fly|Ride"] = 43.19, ["Neon"] = 13.02, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 122.14, ["Mega"] = 145.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 188.9}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 17.95, ["Fly"] = 201.38, ["Ride"] = 40.69, ["Fly|Ride"] = 131.25, ["Neon"] = 116.7, ["Neon|Ride"] = 123.5, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 551.25, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 675.94}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 11.95, ["Fly|Ride"] = 59.07, ["Neon"] = 2.1, ["Neon|Fly"] = 28.25, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.74, ["Mega|Fly"] = 48.7, ["Mega|Ride"] = 33.99, ["Mega|Fly|Ride"] = 86.71}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.51, ["Neon"] = 4.27, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 129.99, ["Mega"] = 20.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.85, ["Ride"] = 19.28, ["Fly|Ride"] = 173.35, ["Neon"] = 14.65, ["Neon|Ride"] = 58.31, ["Neon|Fly|Ride"] = 101.83, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.69, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 132.55, ["Neon|Ride"] = 346.65, ["Neon|Fly|Ride"] = 407.52, ["Mega"] = 511.88, ["Mega|Ride"] = 644.28, ["Mega|Fly|Ride"] = 860.46}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.44, ["Ride"] = 15.71, ["Fly|Ride"] = 33.59, ["Neon"] = 11.45, ["Neon|Fly"] = 31.88, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 120.65, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 173.65}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.03, ["Fly"] = 43.24, ["Ride"] = 32.55, ["Fly|Ride"] = 164.27, ["Neon"] = 31.83, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 246.88, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 260, ["Mega|Fly|Ride"] = 335}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 20.6, ["Fly|Ride"] = 67.92, ["Neon"] = 11.46, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 43.03, ["Mega"] = 47.23, ["Mega|Fly"] = 82.17, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 130.28}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 5.95, ["Fly"] = 169.32, ["Ride"] = 24.68, ["Fly|Ride"] = 217.2, ["Neon"] = 36.89, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 289.23, ["Mega"] = 317.3, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 402.28, ["Mega|Fly|Ride"] = 419.48}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 2.1, ["Ride"] = 189.93, ["Fly|Ride"] = 142.38, ["Neon"] = 51.08, ["Neon|Ride"] = 140.04, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 216.57, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.42, ["Fly"] = 39.8, ["Ride"] = 18.01, ["Fly|Ride"] = 51.35, ["Neon"] = 35.44, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 145.3, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 287.19, ["Mega|Fly|Ride"] = 574.37}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 19.35, ["Fly|Ride"] = 52.55, ["Neon"] = 16.96, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 188.24, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 220.87, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 367.76, ["Neon"] = 1282.53, ["Neon|Ride"] = 1225.98, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4220.64, ["Mega|Fly|Ride"] = 4117.32}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.13, ["Ride"] = 65.63, ["Neon"] = 21.05, ["Neon|Ride"] = 45.94, ["Mega"] = 123.38, ["Mega|Ride"] = 650.09, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.52, ["Fly"] = 108.33, ["Ride"] = 24.68, ["Fly|Ride"] = 86.63, ["Neon"] = 30.19, ["Neon|Fly"] = 245.9, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 229.64, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.63, ["Fly|Ride"] = 216.61, ["Neon"] = 38.04, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 486.29, ["Mega|Ride"] = 406.61, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 13.91, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 43.35, ["Mega"] = 18.98, ["Mega|Fly"] = 79.61, ["Mega|Ride"] = 42.62, ["Mega|Fly|Ride"] = 72.17}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Ride"] = 23.5, ["Fly|Ride"] = 41.18, ["Neon"] = 18.06, ["Neon|Ride"] = 21.65, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 132.57, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 222.92}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 10.4, ["Neon|Ride"] = 288.15, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 49.08, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.08, ["Fly"] = 104.99, ["Ride"] = 98.43, ["Fly|Ride"] = 162.1, ["Neon"] = 315, ["Neon|Fly"] = 540.67, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 477.75, ["Mega|Ride"] = 3587.03, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.63, ["Fly"] = 72.59, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 13.02, ["Neon|Ride"] = 68.16, ["Mega"] = 169.3, ["Mega|Ride"] = 213.94}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.85, ["Ride"] = 34.12, ["Neon"] = 6.99, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 55.21, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.76, ["Fly"] = 131.25, ["Ride"] = 91.88, ["Fly|Ride"] = 199.5, ["Neon"] = 136.38, ["Neon|Ride"] = 174.39, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 492.19, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 681.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 18.8, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 21.84, ["Neon|Ride"] = 16.59, ["Neon|Fly|Ride"] = 36.57, ["Mega"] = 17.06, ["Mega|Fly"] = 46.91, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 81.58}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 46.86, ["Fly|Ride"] = 99.68, ["Neon"] = 2.1, ["Neon|Ride"] = 30.07, ["Neon|Fly|Ride"] = 141.45, ["Mega"] = 24.33, ["Mega|Fly"] = 144.14, ["Mega|Ride"] = 78.56, ["Mega|Fly|Ride"] = 222.79}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Fly"] = 33.12, ["Ride"] = 66.23, ["Fly|Ride"] = 59.01, ["Neon"] = 9.19, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 49.65, ["Mega|Fly"] = 187.16, ["Mega|Ride"] = 117.8}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 86.58, ["Ride"] = 42.76, ["Fly|Ride"] = 129.65, ["Neon"] = 20.36, ["Neon|Fly"] = 122.31, ["Neon|Ride"] = 93.15, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 136.46, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.5, ["Ride"] = 13.49, ["Fly|Ride"] = 39.24, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 24.29, ["Neon|Fly|Ride"] = 49.85, ["Mega"] = 19.03, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 117.79}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 128.63, ["Neon|Ride"] = 190.59, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 717.42, ["Mega|Fly"] = 645.36, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 794.85}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2545.86, ["Fly"] = 3150, ["Ride"] = 2383.24, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 43825.29}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.26, ["Fly|Ride"] = 50.46, ["Neon"] = 4.34, ["Neon|Fly"] = 58.46, ["Neon|Ride"] = 24.67, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 79.61, ["Mega|Fly"] = 430.24, ["Mega|Ride"] = 97.55, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.18, ["Neon"] = 8.82, ["Mega"] = 100.68, ["Mega|Fly"] = 441, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 430.24}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.39, ["Fly"] = 145.17, ["Ride"] = 31.49, ["Fly|Ride"] = 131.25, ["Neon"] = 81.37, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 393.75, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 573.61}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.84, ["Fly"] = 108.33, ["Ride"] = 66.66, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1299.31, ["Mega|Ride"] = 615.24, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.07, ["Fly"] = 1445.01, ["Ride"] = 183.64, ["Fly|Ride"] = 266.44, ["Neon"] = 1224.76, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6453.41, ["Mega|Fly|Ride"] = 4102.23}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.11, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 26.23, ["Neon|Ride"] = 145.17, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 430.24}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.85, ["Neon"] = 14.6, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.83, ["Ride"] = 33.49, ["Fly|Ride"] = 75.84, ["Neon"] = 12.89, ["Neon|Fly"] = 127.83, ["Neon|Ride"] = 36.39, ["Mega"] = 60.37, ["Mega|Ride"] = 113.8, ["Mega|Fly|Ride"] = 227.39}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.07, ["Ride"] = 51.89, ["Fly|Ride"] = 131.25, ["Neon"] = 115.25, ["Neon|Ride"] = 179.01, ["Neon|Fly|Ride"] = 510.2, ["Mega"] = 420, ["Mega|Ride"] = 325.17, ["Mega|Fly|Ride"] = 591.29}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 36.71, ["Mega"] = 28.88, ["Mega|Fly"] = 121.75, ["Mega|Ride"] = 75.13, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 92.26, ["Fly"] = 202.58, ["Ride"] = 127.31, ["Fly|Ride"] = 137.62, ["Neon"] = 304.5, ["Neon|Fly"] = 463.63, ["Neon|Ride"] = 404.58, ["Neon|Fly|Ride"] = 449.95, ["Mega"] = 3226.72, ["Mega|Fly|Ride"] = 1427.29}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 91.84, ["Fly|Ride"] = 78.75, ["Neon"] = 8.81, ["Neon|Ride"] = 144.65, ["Neon|Fly|Ride"] = 216.66, ["Mega"] = 62.37, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.44, ["Fly"] = 145.17, ["Ride"] = 98.44, ["Fly|Ride"] = 170.62, ["Neon"] = 236.25, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Ride"] = 2009.17, ["Mega|Fly|Ride"] = 1865.05}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 23.24, ["Fly|Ride"] = 52.73, ["Neon"] = 4.45, ["Neon|Fly"] = 85.84, ["Neon|Ride"] = 72.59, ["Neon|Fly|Ride"] = 115.91, ["Mega"] = 58.09, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 11.5, ["Neon|Ride"] = 111.57, ["Mega"] = 60.88, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.94, ["Fly"] = 77.43, ["Ride"] = 37.04, ["Fly|Ride"] = 90.57, ["Neon"] = 19.69, ["Neon|Ride"] = 72.45, ["Mega"] = 433.13, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 537.79}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 359.62, ["Fly"] = 735.49, ["Ride"] = 418.59, ["Fly|Ride"] = 510.46, ["Neon"] = 918.74, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 3105.3}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 25.47, ["Fly"] = 86.67, ["Ride"] = 47.14, ["Fly|Ride"] = 116.71, ["Neon"] = 154.52, ["Neon|Ride"] = 216.66, ["Neon|Fly|Ride"] = 192.31, ["Mega|Ride"] = 1147.64, ["Mega|Fly|Ride"] = 1060.53}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 30.56, ["Fly|Ride"] = 118.55, ["Neon"] = 22.31, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 36.12, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 164.07, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 19.66, ["Fly"] = 111.45, ["Ride"] = 58.51, ["Fly|Ride"] = 227.06, ["Neon"] = 73.98, ["Neon|Fly"] = 177.19, ["Neon|Ride"] = 145.59, ["Neon|Fly|Ride"] = 240.19, ["Mega"] = 359.25, ["Mega|Fly"] = 1001.9, ["Mega|Ride"] = 461.4, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.19, ["Ride"] = 28.18, ["Neon"] = 101.36, ["Neon|Ride"] = 137.58, ["Neon|Fly|Ride"] = 490.4, ["Mega"] = 525, ["Mega|Ride"] = 691.69, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 26.17, ["Mega"] = 80.99, ["Mega|Ride"] = 332.68, ["Mega|Fly|Ride"] = 429.17}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 72.59, ["Ride"] = 22.31, ["Fly|Ride"] = 65.62, ["Neon"] = 56.97, ["Neon|Fly"] = 86.67, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 213.94, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 82.74, ["Ride"] = 119.43, ["Fly|Ride"] = 229.32, ["Neon"] = 818.92, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.98, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3003.27}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.71, ["Ride"] = 54.44, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 173.34, ["Neon|Fly|Ride"] = 319.56, ["Mega"] = 1147.64, ["Mega|Ride"] = 706.1, ["Mega|Fly|Ride"] = 812}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1836.19, ["Fly"] = 2311.32, ["Ride"] = 1706.25, ["Fly|Ride"] = 1896.57, ["Neon"] = 11554.59, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 48.67, ["Fly|Ride"] = 196.87, ["Neon"] = 19.69, ["Neon|Ride"] = 52, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 141.65, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 208.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.15, ["Ride"] = 21, ["Fly|Ride"] = 180.92, ["Neon"] = 23.09, ["Neon|Fly"] = 58.51, ["Neon|Ride"] = 89.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.25, ["Mega|Fly"] = 287.19, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.27, ["Fly"] = 1502.43, ["Ride"] = 918.75, ["Fly|Ride"] = 989.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 3067.09, ["Neon|Fly|Ride"] = 2891.42, ["Mega|Ride"] = 13797.68, ["Mega|Fly|Ride"] = 12046.34}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 30.82, ["Ride"] = 46.56, ["Fly|Ride"] = 173.35, ["Neon"] = 145.17, ["Neon|Ride"] = 216.66, ["Mega"] = 857.2, ["Mega|Ride"] = 844.88, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 12.29, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 145.17, ["Neon"] = 3.75, ["Neon|Fly"] = 126, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 23.24, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 163.14}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 68.25, ["Ride"] = 122.96, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2434.76, ["Mega|Fly|Ride"] = 2295.27}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.68, ["Fly|Ride"] = 75.84, ["Neon"] = 11.81, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 122.6, ["Mega"] = 90.56, ["Mega|Ride"] = 121.96, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.64, ["Fly"] = 145.17, ["Ride"] = 102.09, ["Fly|Ride"] = 289.23, ["Neon"] = 433.3, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1755.46}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.34, ["Fly"] = 105, ["Fly|Ride"] = 129.99, ["Neon"] = 58.95, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.05, ["Mega"] = 328.02, ["Mega|Ride"] = 144.14}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Ride"] = 279.57, ["Fly|Ride"] = 320.15, ["Neon"] = 1137.32, ["Neon|Fly"] = 1062.92, ["Neon|Ride"] = 1077.81, ["Neon|Fly|Ride"] = 1003.68, ["Mega|Fly|Ride"] = 3870.98}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.52, ["Fly"] = 91.88, ["Ride"] = 26.21, ["Fly|Ride"] = 105, ["Neon"] = 40.18, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 260.53, ["Mega|Ride"] = 260.53, ["Mega|Fly|Ride"] = 289.51}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 16.02, ["Fly|Ride"] = 36.38, ["Neon"] = 3.63, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 59.76, ["Mega"] = 44.62, ["Mega|Fly"] = 101.11, ["Mega|Ride"] = 71.39, ["Mega|Fly|Ride"] = 124.72}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1181.25, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7944.26, ["Neon|Fly|Ride"] = 7040.85, ["Mega"] = 24347.38, ["Mega|Fly|Ride"] = 28682.11}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.08, ["Ride"] = 77.58, ["Neon"] = 102.52, ["Neon|Ride"] = 314.98, ["Mega"] = 320.25, ["Mega|Ride"] = 414.35, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.27, ["Fly"] = 39.38, ["Ride"] = 35.39, ["Fly|Ride"] = 78.79, ["Neon"] = 14.44, ["Neon|Fly"] = 102.93, ["Neon|Ride"] = 55.01, ["Neon|Fly|Ride"] = 129.99, ["Mega"] = 143.07, ["Mega|Ride"] = 187.48, ["Mega|Fly|Ride"] = 286.92}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 23.66, ["Fly"] = 47.25, ["Ride"] = 35.44, ["Fly|Ride"] = 77.35, ["Neon"] = 196.17, ["Neon|Ride"] = 188.55, ["Neon|Fly|Ride"] = 216.56, ["Mega"] = 2581.37, ["Mega|Ride"] = 1137.04, ["Mega|Fly|Ride"] = 689.37}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.1, ["Fly"] = 71.51, ["Ride"] = 24.93, ["Fly|Ride"] = 54.17, ["Neon"] = 59.06, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 182.34, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 47.25, ["Fly|Ride"] = 509.13, ["Neon"] = 229.17, ["Neon|Fly"] = 489.63, ["Neon|Ride"] = 315, ["Mega"] = 1075.58, ["Mega|Ride"] = 1720.91, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 289.23, ["Neon"] = 2.1, ["Neon|Fly"] = 58.51, ["Neon|Ride"] = 108.52, ["Neon|Fly|Ride"] = 108.33, ["Mega"] = 16.7, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 83.7, ["Fly"] = 91.88, ["Ride"] = 91.76, ["Fly|Ride"] = 183.75, ["Neon"] = 573.02, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3441.82, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.31, ["Fly"] = 107.63, ["Ride"] = 19.68, ["Fly|Ride"] = 66.68, ["Neon"] = 198.19, ["Neon|Ride"] = 114.83, ["Mega"] = 773.71, ["Mega|Ride"] = 437.73, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 15.75, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 105.93, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 4.34, ["Ride"] = 126, ["Neon"] = 19.51, ["Neon|Fly"] = 143, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 83.07, ["Fly"] = 247.55, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 477.71, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2009.17, ["Mega|Ride"] = 1611.21, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.77, ["Ride"] = 18.38, ["Fly|Ride"] = 433.3, ["Neon"] = 7.87, ["Neon|Ride"] = 59.07, ["Mega"] = 137.69, ["Mega|Ride"] = 163.14, ["Mega|Fly|Ride"] = 325.05}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.79, ["Neon"] = 2.1, ["Neon|Ride"] = 120.16, ["Mega"] = 16.94, ["Mega|Ride"] = 212.89, ["Mega|Fly|Ride"] = 537.79}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 32.82, ["Fly|Ride"] = 144.44, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.58, ["Mega|Fly"] = 53.96, ["Mega|Ride"] = 44.84, ["Mega|Fly|Ride"] = 141.86}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18.19, ["Fly|Ride"] = 52.41, ["Neon"] = 5.76, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 49.4, ["Mega"] = 61.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.49, ["Neon"] = 24.36, ["Mega"] = 118.11, ["Mega|Ride"] = 122.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.35, ["Ride"] = 16.59, ["Fly|Ride"] = 38.13, ["Neon"] = 10.4, ["Neon|Fly"] = 86.67, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 101.83, ["Mega"] = 178.5, ["Mega|Ride"] = 163.14, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.59, ["Ride"] = 108.04, ["Fly|Ride"] = 379.14, ["Neon"] = 289.38, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 1083.23, ["Mega"] = 616.88, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1137.04}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.75, ["Fly|Ride"] = 40.63, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 54.06, ["Mega"] = 144.38, ["Mega|Ride"] = 131.1, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.76, ["Fly"] = 76.49, ["Ride"] = 32.7, ["Fly|Ride"] = 72.19, ["Neon"] = 40.74, ["Neon|Fly"] = 86.43, ["Neon|Ride"] = 64.03, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 301.87, ["Mega|Fly"] = 574.37, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.74, ["Fly"] = 38.01, ["Ride"] = 49.08, ["Fly|Ride"] = 53.82, ["Neon"] = 170.63, ["Neon|Fly"] = 147, ["Neon|Ride"] = 123.23, ["Neon|Fly|Ride"] = 268.96, ["Mega"] = 717.42, ["Mega|Ride"] = 825.28, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.48, ["Fly"] = 196.88, ["Neon"] = 77.61, ["Neon|Ride"] = 103.69, ["Mega"] = 525, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 559.31}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.23, ["Ride"] = 17.05, ["Fly|Ride"] = 38.98, ["Neon"] = 2.1, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 22.02, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 45.33, ["Mega|Ride"] = 149.76, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.06, ["Fly"] = 39.38, ["Ride"] = 38.07, ["Neon"] = 73.41, ["Neon|Ride"] = 129.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 275.63, ["Mega|Fly"] = 368.93, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 545.33}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1390.06, ["Ride"] = 980.44, ["Fly|Ride"] = 1095.94, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2401.88, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 187.68, ["Ride"] = 262.5, ["Fly|Ride"] = 393.75, ["Neon"] = 840, ["Neon|Ride"] = 817.74, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3225.64, ["Mega|Ride"] = 3587.03, ["Mega|Fly|Ride"] = 3368.68}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.26, ["Neon|Ride"] = 72.59, ["Neon|Fly|Ride"] = 258.89, ["Mega"] = 78.43, ["Mega|Fly|Ride"] = 214.05}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 115.39, ["Ride"] = 131.25, ["Fly|Ride"] = 315, ["Neon"] = 576.19, ["Neon|Ride"] = 538.13, ["Neon|Fly|Ride"] = 780.35, ["Mega"] = 2009.17, ["Mega|Ride"] = 2009.17, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.61, ["Ride"] = 22.57, ["Neon"] = 17.48, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 287.19, ["Mega"] = 115.95, ["Mega|Ride"] = 486.96, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 183.75, ["Fly"] = 433.3, ["Ride"] = 288.74, ["Fly|Ride"] = 376.69, ["Neon"] = 1164.68, ["Neon|Ride"] = 1429.84, ["Neon|Fly|Ride"] = 1412.17, ["Mega|Fly|Ride"] = 4869.5}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 42.26, ["Fly|Ride"] = 223.25, ["Neon"] = 23.81, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 360.32, ["Mega|Ride"] = 430.24}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.27, ["Ride"] = 26.25, ["Neon"] = 19.69, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 13.12, ["Ride"] = 63.59, ["Fly|Ride"] = 136.66, ["Neon"] = 122.72, ["Neon|Fly"] = 433.3, ["Neon|Ride"] = 124.68, ["Mega"] = 777.66, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.69, ["Neon|Ride"] = 196.88, ["Mega"] = 243.49, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.08, ["Ride"] = 14.34, ["Fly|Ride"] = 32.69, ["Neon"] = 2.1, ["Neon|Fly"] = 20.69, ["Neon|Ride"] = 19.49, ["Neon|Fly|Ride"] = 42.07, ["Mega"] = 24.47, ["Mega|Ride"] = 38.88, ["Mega|Fly|Ride"] = 101.74}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5488.63, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32496.22, ["Neon|Fly|Ride"] = 21664.15, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.93, ["Fly"] = 86.67, ["Ride"] = 41.91, ["Neon"] = 78.75, ["Neon|Ride"] = 98.1, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 210, ["Mega|Fly"] = 344.19, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 359.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.57, ["Fly|Ride"] = 51.19, ["Neon"] = 14.44, ["Neon|Fly"] = 45.92, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 144.37, ["Mega|Ride"] = 194.79, ["Mega|Fly|Ride"] = 210.82}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 417.38, ["Fly"] = 547.77, ["Ride"] = 476.43, ["Fly|Ride"] = 570.94, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1200.93, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.57, ["Ride"] = 46.15, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 187.95, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.13, ["Fly"] = 145.69, ["Ride"] = 36.85, ["Neon"] = 16.26, ["Neon|Ride"] = 121.38, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 429.17, ["Mega|Ride"] = 359.25}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.07, ["Ride"] = 29.27, ["Fly|Ride"] = 65.62, ["Neon"] = 3.83, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 53.72, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 194.79}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 617.46, ["Fly"] = 757.17, ["Ride"] = 674.62, ["Fly|Ride"] = 688.95, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2940, ["Mega|Fly|Ride"] = 10755.66}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.77, ["Ride"] = 124.69, ["Fly|Ride"] = 162.49, ["Neon"] = 33.51, ["Neon|Fly"] = 115.91, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 209.9, ["Mega|Fly"] = 430.24, ["Mega|Ride"] = 231.97, ["Mega|Fly|Ride"] = 427.67}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 236.25, ["Ride"] = 46.68, ["Fly|Ride"] = 104.99, ["Neon"] = 26.04, ["Neon|Ride"] = 59.79, ["Neon|Fly|Ride"] = 150.84, ["Mega"] = 174.57, ["Mega|Fly"] = 812, ["Mega|Ride"] = 179.3, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.1, ["Ride"] = 19.69, ["Fly|Ride"] = 55.32, ["Neon"] = 19.36, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 29.36, ["Neon|Fly|Ride"] = 82.94, ["Mega"] = 287.19, ["Mega|Fly"] = 287.19, ["Mega|Ride"] = 159.2, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 34.13, ["Ride"] = 33.59, ["Fly|Ride"] = 58.61, ["Neon"] = 117.59, ["Neon|Ride"] = 124.69, ["Mega"] = 860.46, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 858.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 82.15, ["Neon"] = 6.46, ["Neon|Ride"] = 49.85, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.69, ["Mega|Ride"] = 91.76, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 643.43, ["Fly"] = 713.85, ["Ride"] = 630.19, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2311.58, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9495.49, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 74.97, ["Neon"] = 14.43, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 433.3, ["Mega"] = 163.14, ["Mega|Fly|Ride"] = 254.34}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 48.97, ["Neon"] = 3.81, ["Neon|Fly"] = 245.9, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 53.81, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 3.41, ["Neon|Ride"] = 56.17, ["Neon|Fly|Ride"] = 144.14, ["Mega"] = 107.58, ["Mega|Fly"] = 159.2, ["Mega|Ride"] = 126.62, ["Mega|Fly|Ride"] = 187.16}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.44, ["Neon|Ride"] = 49.03, ["Mega"] = 215.13, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.25, ["Fly"] = 72.19, ["Ride"] = 42.39, ["Fly|Ride"] = 205.3, ["Neon"] = 103.83, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 511.88, ["Mega|Ride"] = 509.83, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.4, ["Fly"] = 131.18, ["Ride"] = 77.24, ["Fly|Ride"] = 153.83, ["Neon"] = 85.79, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 285.98, ["Mega"] = 540.32, ["Mega|Ride"] = 427.89, ["Mega|Fly|Ride"] = 575.73}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.26, ["Fly|Ride"] = 34.23, ["Neon"] = 43.35, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 89.3, ["Mega"] = 298.6, ["Mega|Ride"] = 287.19, ["Mega|Fly|Ride"] = 239.56}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 58.47, ["Fly|Ride"] = 144.65, ["Neon"] = 38.06, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 108.33, ["Neon"] = 10.49, ["Neon|Ride"] = 36.85, ["Neon|Fly|Ride"] = 145.17, ["Mega"] = 81.37, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 287.19}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.99, ["Fly"] = 115.24, ["Ride"] = 32.8, ["Fly|Ride"] = 63.34, ["Neon"] = 110.25, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 223.79, ["Mega"] = 746.46, ["Mega|Fly|Ride"] = 751.84}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 30.26, ["Fly"] = 874.13, ["Neon"] = 115.91, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 50.52, ["Fly"] = 86.63, ["Ride"] = 86.41, ["Fly|Ride"] = 103.69, ["Neon"] = 328.13, ["Neon|Ride"] = 286.4, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1947.81, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.78, ["Fly"] = 140.99, ["Ride"] = 76.74, ["Fly|Ride"] = 131.25, ["Neon"] = 127.33, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 309.74, ["Mega"] = 703.44, ["Mega|Ride"] = 832.51, ["Mega|Fly|Ride"] = 849.19}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.7, ["Ride"] = 36.85, ["Neon"] = 131.25, ["Neon|Ride"] = 223.12, ["Mega"] = 665.93, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 810.99}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 22.95, ["Fly"] = 81.74, ["Ride"] = 78.75, ["Fly|Ride"] = 251.31, ["Neon"] = 145.26, ["Neon|Fly"] = 259.98, ["Neon|Ride"] = 242.95, ["Neon|Fly|Ride"] = 346.65, ["Mega"] = 687.42, ["Mega|Ride"] = 631.49, ["Mega|Fly|Ride"] = 701.06}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.14, ["Ride"] = 16.01, ["Fly|Ride"] = 32.78, ["Neon"] = 3.08, ["Neon|Fly"] = 28.18, ["Neon|Ride"] = 29.22, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 48.7, ["Mega|Fly"] = 325.05, ["Mega|Ride"] = 90.11, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.25}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 65.62, ["Fly"] = 490.32, ["Ride"] = 131.25, ["Fly|Ride"] = 330.75, ["Neon"] = 477.71, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1443.75, ["Mega|Ride"] = 1576.8, ["Mega|Fly|Ride"] = 1553.86}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 77.37, ["Neon"] = 3.5, ["Neon|Fly"] = 101.83, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 303.31, ["Mega"] = 28.88, ["Mega|Ride"] = 89.66}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 23.6, ["Ride"] = 67.93, ["Neon"] = 159.75, ["Neon|Ride"] = 138.67, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 498.65, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Fly|Ride"] = 115.91, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.92, ["Mega"] = 25.06, ["Mega|Ride"] = 153.05, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 98.33, ["Fly"] = 223.13, ["Ride"] = 141.65, ["Fly|Ride"] = 371.42, ["Neon"] = 437.07, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 635.85, ["Mega|Ride"] = 2868.54, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.48, ["Fly|Ride"] = 92.14, ["Neon"] = 5.2, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.67, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 215.13}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 61.69, ["Neon"] = 5.65, ["Neon|Fly"] = 43.35, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.81, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 118.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 558.24}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Ride"] = 137.82, ["Mega"] = 101.07, ["Mega|Ride"] = 340.88}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 91.87, ["Ride"] = 145.17, ["Fly|Ride"] = 361.81, ["Neon"] = 413.44, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2438.33, ["Mega|Fly|Ride"] = 2295.27}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.28, ["Ride"] = 95.34, ["Neon"] = 114.15, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 423.05, ["Fly|Ride"] = 719.27, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 94.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.85}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 145.19}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 47.25}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.25}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 2.52}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.3}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 24.19}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.18}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 11.81}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.15}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 18.68}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 648.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 462}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.66}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1328.79}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.39}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.66}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 163.96}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.72}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.07}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.38}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.63}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.34}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.52}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.04}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.45}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3045}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 63.94}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 317.63}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.7}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 19.66}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.19}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.92}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.13}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.18}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 39.04}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.61}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 29.24}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.13}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.07}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.74}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.15}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.63}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.16}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 256.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.43}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.49}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 297.62}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.45}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.54}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24389.01}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 85.32}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.72}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 56.44}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.98}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 119.44}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.19}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 431.78}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 49.88}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 220.9}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.12}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.15}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 143.06}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.28}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.3}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.64}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 20.43}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 590.52}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 12.06}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 221.82}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 30.95}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.99}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 29.54}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 61.34}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.45}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.53}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.27}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.55}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 6.35}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.69}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.91}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.4}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.26}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 145.15}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.56}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 23.58}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 24.15}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.87}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.88}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 10.5}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.82}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.76}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.49}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.4}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 38.96}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.42}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.18}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.8}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 15.29}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.51}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.61}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.51}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.15}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9641.63}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.54}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 6.17}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.2}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.57}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 245.25}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.55}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.92}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 6.56}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.15}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4766.69}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.36}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.83}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.22}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.05}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.87}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 85.32}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.68}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.63}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.98}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 131.24}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.63}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.19}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.94}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.3}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.62}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 20.99}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.44}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.65}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 145.19}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 10.8}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1204.26}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 62.26}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.26}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.58}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 29.92}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.6}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.39}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 16.7}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.48}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.28}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.57}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.82}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.8}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.19}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 27.55}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.67}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.7}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 61.11}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.88}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 181.53}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 11.94}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 31.87}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.5}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 19.27}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.68}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 81.2}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 182.33}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 9.77}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1017.19}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.57}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.87}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.77}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 62.99}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.77}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 70.02}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 21}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 18.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.89}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.15}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.38}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63.53}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.41}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 15.89}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 116.73}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.83}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 66.11}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 93.18}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.71}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 145.19}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.02}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 68.27}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 141.62}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 9.07}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 54.47}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.53}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.76}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.73}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 82.69}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.36}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.99}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 41.83}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.82}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 24.29}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 92.52}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 51.06}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.44}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 10.36}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.51}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.9}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 397.61}},
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
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.09}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 295.81}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 60.45}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.17}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.18}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 45.91}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.03}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.66}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 965.35}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 181.13}},
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