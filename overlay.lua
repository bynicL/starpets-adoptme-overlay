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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1165, ["Ride"] = 1123.72, ["Fly|Ride"] = 1610, ["Neon"] = 6541.16, ["Neon|Ride"] = 8750, ["Neon|Fly|Ride"] = 4828.77, ["Mega"] = 20647.08, ["Mega|Fly|Ride"] = 20647.08}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 530, ["Ride"] = 437.5, ["Fly|Ride"] = 612.5, ["Neon|Fly|Ride"] = 1750, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 7736.47}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6250, ["Ride"] = 5000, ["Fly|Ride"] = 4486.25, ["Neon|Fly|Ride"] = 17000, ["Mega|Fly|Ride"] = 68820.85}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 200, ["Fly"] = 225, ["Ride"] = 242.76, ["Fly|Ride"] = 467.24, ["Neon"] = 1090.98, ["Neon|Ride"] = 1101.53, ["Neon|Fly|Ride"] = 843.75, ["Mega|Fly|Ride"] = 4666.24}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 602.49, ["Fly"] = 825.89, ["Ride"] = 548.75, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1831.14, ["Mega|Fly|Ride"] = 6125}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 12.5, ["Ride"] = 56.24, ["Fly|Ride"] = 123.75, ["Neon"] = 76.82, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 99.99, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 336.9, ["Mega|Ride"] = 495.54, ["Mega|Fly|Ride"] = 577.1}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.14, ["Fly"] = 55.71, ["Ride"] = 31.14, ["Fly|Ride"] = 75, ["Neon"] = 54.91, ["Neon|Fly"] = 126.25, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 107.39, ["Mega"] = 125, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 300}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 108.75, ["Ride"] = 135, ["Neon"] = 545.5, ["Neon|Ride"] = 468.75, ["Neon|Fly|Ride"] = 1125, ["Mega"] = 1511.25, ["Mega|Ride"] = 2373.75, ["Mega|Fly|Ride"] = 2064.71}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.07, ["Fly"] = 92.92, ["Ride"] = 43.99, ["Fly|Ride"] = 98.56, ["Neon"] = 262.49, ["Neon|Ride"] = 231.25, ["Neon|Fly|Ride"] = 293.75, ["Mega"] = 2000, ["Mega|Ride"] = 1156.25, ["Mega|Fly|Ride"] = 850}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.59, ["Fly"] = 46.73, ["Ride"] = 28.1, ["Fly|Ride"] = 67.49, ["Neon"] = 144.06, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 198.75, ["Mega"] = 619.42, ["Mega|Fly|Ride"] = 824.87}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 72.43, ["Fly"] = 206.25, ["Ride"] = 100, ["Fly|Ride"] = 186.25, ["Neon"] = 248.75, ["Neon|Ride"] = 306.25, ["Neon|Fly|Ride"] = 394.63, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 375, ["Fly"] = 379.9, ["Ride"] = 343.75, ["Fly|Ride"] = 350, ["Neon|Fly|Ride"] = 1125, ["Mega|Fly|Ride"] = 4941.89}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 125, ["Fly"] = 152.79, ["Ride"] = 120.69, ["Fly|Ride"] = 168.74, ["Neon|Fly"] = 654.12, ["Neon|Ride"] = 545.74, ["Neon|Fly|Ride"] = 479.3, ["Mega"] = 4107.26, ["Mega|Fly|Ride"] = 2350}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.75, ["Fly"] = 75.26, ["Ride"] = 61.96, ["Fly|Ride"] = 125, ["Neon"] = 22.72, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 193.06, ["Mega"] = 152.5, ["Mega|Fly"] = 375, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 330.37}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 212.5, ["Fly"] = 271.25, ["Ride"] = 222.5, ["Fly|Ride"] = 259.77, ["Neon|Ride"] = 1333.94, ["Neon|Fly|Ride"] = 699.9, ["Mega|Fly|Ride"] = 2618.75}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.5, ["Fly"] = 25.6, ["Ride"] = 22.5, ["Fly|Ride"] = 38, ["Neon"] = 22.5, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 156.25, ["Mega|Ride"] = 294.36, ["Mega|Fly|Ride"] = 363.25}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 122.5, ["Fly"] = 275.65, ["Ride"] = 138.75, ["Fly|Ride"] = 305, ["Neon"] = 444.95, ["Neon|Ride"] = 450.69, ["Neon|Fly|Ride"] = 543.75, ["Mega"] = 1713.56, ["Mega|Ride"] = 1500, ["Mega|Fly|Ride"] = 1647.64}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.34}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 75.58, ["Ride"] = 125, ["Fly|Ride"] = 232.72, ["Neon"] = 399.53, ["Neon|Fly|Ride"] = 750, ["Mega|Fly|Ride"] = 1401.68}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 30, ["Fly"] = 55.76, ["Ride"] = 51.65, ["Fly|Ride"] = 412.95, ["Neon"] = 250, ["Neon|Ride"] = 304.56, ["Neon|Fly|Ride"] = 330.37, ["Mega"] = 961.25, ["Mega|Ride"] = 1014.81, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 33.99, ["Fly"] = 105.31, ["Ride"] = 52.8, ["Fly|Ride"] = 108.38, ["Neon"] = 206.24, ["Neon|Ride"] = 186.24, ["Neon|Fly|Ride"] = 258.88, ["Mega"] = 1635.29, ["Mega|Fly|Ride"] = 849.45}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 44.58, ["Fly"] = 235.34, ["Ride"] = 81.25, ["Fly|Ride"] = 187.5, ["Neon"] = 152.79, ["Neon|Ride"] = 361.92, ["Neon|Fly|Ride"] = 300, ["Mega"] = 1873.75, ["Mega|Ride"] = 1651.77, ["Mega|Fly|Ride"] = 1485.56}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 38.75, ["Ride"] = 43.84, ["Fly|Ride"] = 105.23, ["Neon"] = 200, ["Neon|Ride"] = 285.18, ["Neon|Fly|Ride"] = 247.77, ["Mega"] = 1150.4, ["Mega|Fly|Ride"] = 975}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 42.49, ["Fly"] = 51.25, ["Ride"] = 68.16, ["Fly|Ride"] = 123.75, ["Neon"] = 225, ["Neon|Fly"] = 390.14, ["Neon|Ride"] = 218.31, ["Neon|Fly|Ride"] = 307.5, ["Mega|Ride"] = 1090.98, ["Mega|Fly|Ride"] = 991.07}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.82, ["Fly"] = 32.44, ["Ride"] = 25.02, ["Fly|Ride"] = 58.16, ["Neon"] = 43.75, ["Neon|Fly"] = 259.99, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 96.21, ["Mega"] = 150, ["Mega|Fly"] = 24777.58, ["Mega|Ride"] = 214.99, ["Mega|Fly|Ride"] = 399.53}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 372.38, ["Ride"] = 396, ["Fly|Ride"] = 448.75, ["Neon|Ride"] = 1625, ["Neon|Fly|Ride"] = 1872.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 9267.42}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 18.93, ["Ride"] = 31.25, ["Fly|Ride"] = 112.5, ["Neon"] = 208.74, ["Mega|Ride"] = 784.6, ["Mega|Fly|Ride"] = 639.67}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.15, ["Fly"] = 41.25, ["Ride"] = 22.59, ["Fly|Ride"] = 41.3, ["Neon"] = 60, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 99.97, ["Mega|Ride"] = 316.94, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 80.87, ["Fly"] = 114.52, ["Ride"] = 78.05, ["Fly|Ride"] = 137.84, ["Neon"] = 330.37, ["Neon|Fly"] = 373.79, ["Neon|Ride"] = 358.67, ["Neon|Fly|Ride"] = 381.51, ["Mega"] = 6189.57, ["Mega|Ride"] = 5555, ["Mega|Fly|Ride"] = 1687.5}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.91, ["Fly"] = 25, ["Ride"] = 26.25, ["Fly|Ride"] = 69, ["Neon"] = 73.53, ["Neon|Ride"] = 109.6, ["Neon|Fly|Ride"] = 247.77, ["Mega"] = 686.25, ["Mega|Ride"] = 700.85, ["Mega|Fly|Ride"] = 515.16}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 212.4, ["Fly"] = 275, ["Ride"] = 238.74, ["Fly|Ride"] = 315.65, ["Neon"] = 693.83, ["Neon|Ride"] = 895.06, ["Neon|Fly|Ride"] = 688.59, ["Mega"] = 3302.51, ["Mega|Ride"] = 2631.92, ["Mega|Fly|Ride"] = 2859.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.27, ["Fly"] = 36.25, ["Ride"] = 20.6, ["Fly|Ride"] = 63.97, ["Neon"] = 21.25, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 42.49, ["Neon|Fly|Ride"] = 125, ["Mega"] = 187.5, ["Mega|Fly"] = 465.23, ["Mega|Ride"] = 412.95, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 750, ["Fly"] = 2500, ["Ride"] = 787.5, ["Fly|Ride"] = 862.5, ["Neon"] = 4818.01, ["Neon|Ride"] = 5230.95, ["Neon|Fly|Ride"] = 4818.01, ["Mega|Ride"] = 52562.79, ["Mega|Fly|Ride"] = 17894.83}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 16.15, ["Fly"] = 52.76, ["Ride"] = 49.46, ["Fly|Ride"] = 101.18, ["Neon"] = 179.63, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 202.35, ["Mega"] = 987.5, ["Mega|Ride"] = 1060.24, ["Mega|Fly|Ride"] = 1090.98}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 204.52, ["Fly"] = 350.43, ["Ride"] = 224.97, ["Fly|Ride"] = 312.5, ["Neon"] = 843.75, ["Neon|Ride"] = 850, ["Neon|Fly|Ride"] = 981.24, ["Mega|Ride"] = 5785, ["Mega|Fly|Ride"] = 3713.86}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.52}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.38, ["Fly"] = 123.89, ["Ride"] = 69.13, ["Fly|Ride"] = 138.35, ["Neon"] = 62.5, ["Neon|Ride"] = 122.49, ["Neon|Fly|Ride"] = 450, ["Mega"] = 390.14, ["Mega|Ride"] = 548.69, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.13}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 87.4, ["Fly"] = 154.51, ["Ride"] = 125, ["Fly|Ride"] = 208.75, ["Neon"] = 618.39, ["Neon|Ride"] = 383.75, ["Mega"] = 2270.16, ["Mega|Ride"] = 2181.95, ["Mega|Fly|Ride"] = 1722.49}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 99.99, ["Fly"] = 149.99, ["Ride"] = 122.5, ["Fly|Ride"] = 222.68, ["Neon"] = 370.91, ["Neon|Fly"] = 551.29, ["Neon|Ride"] = 390.23, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1548.54, ["Mega|Ride"] = 1437.5, ["Mega|Fly|Ride"] = 1403.6}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.73}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 47.02, ["Fly"] = 82.5, ["Ride"] = 52.48, ["Fly|Ride"] = 75, ["Neon|Ride"] = 378.88, ["Neon|Fly|Ride"] = 337.5, ["Mega"] = 4129.42, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.23, ["Fly"] = 97.05, ["Ride"] = 47.47, ["Fly|Ride"] = 150, ["Neon"] = 35.11, ["Neon|Fly"] = 212.5, ["Neon|Ride"] = 88.75, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 181.25, ["Mega|Ride"] = 218.44, ["Mega|Fly|Ride"] = 436.87}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 550, ["Fly"] = 677.48, ["Ride"] = 500, ["Fly|Ride"] = 593.75, ["Neon|Fly"] = 3716.48, ["Neon|Ride"] = 3699.91, ["Neon|Fly|Ride"] = 1869.51, ["Mega|Ride"] = 14452.96, ["Mega|Fly|Ride"] = 7125}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 115.18, ["Fly"] = 162.5, ["Ride"] = 130.4, ["Fly|Ride"] = 156.53, ["Neon"] = 475, ["Neon|Ride"] = 551.29, ["Neon|Fly|Ride"] = 625, ["Mega|Ride"] = 2477.66, ["Mega|Fly|Ride"] = 2187.5}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3875, ["Ride"] = 3700, ["Fly|Ride"] = 3750}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 50, ["Fly"] = 125, ["Ride"] = 93.74, ["Fly|Ride"] = 179.63, ["Neon"] = 313.61, ["Neon|Ride"] = 275.58, ["Neon|Fly|Ride"] = 481.25, ["Mega"] = 2064.71, ["Mega|Ride"] = 1930.51, ["Mega|Fly|Ride"] = 1805}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 62.5, ["Ride"] = 65, ["Fly|Ride"] = 138.35, ["Neon"] = 548.33, ["Neon|Ride"] = 407.5, ["Neon|Fly|Ride"] = 411.25, ["Mega"] = 6056.84, ["Mega|Ride"] = 2275, ["Mega|Fly|Ride"] = 1902.3}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 29.99, ["Fly"] = 42.5, ["Ride"] = 43.75, ["Fly|Ride"] = 97.5, ["Neon"] = 144.99, ["Neon|Fly"] = 150, ["Neon|Ride"] = 171.27, ["Neon|Fly|Ride"] = 193.63, ["Mega"] = 2500, ["Mega|Ride"] = 862.02, ["Mega|Fly|Ride"] = 549.98}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.14}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40, ["Fly"] = 375, ["Ride"] = 51.25, ["Fly|Ride"] = 125, ["Neon|Ride"] = 311.88, ["Neon|Fly|Ride"] = 578.13, ["Mega|Ride"] = 1246.33, ["Mega|Fly|Ride"] = 1211.99}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 33.06}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 206.17, ["Ride"] = 200, ["Fly|Ride"] = 268.75, ["Neon"] = 1101.53, ["Neon|Ride"] = 1101.53, ["Neon|Fly|Ride"] = 1236.77, ["Mega|Fly|Ride"] = 4672.26}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 681.15, ["Ride"] = 611.25, ["Fly|Ride"] = 765.91, ["Neon"] = 2500, ["Neon|Fly|Ride"] = 4129.42, ["Mega|Fly|Ride"] = 10728.91}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.13}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 33.07, ["Fly"] = 53.68, ["Ride"] = 37.5, ["Fly|Ride"] = 61.13, ["Neon"] = 235, ["Neon|Fly"] = 260.17, ["Neon|Ride"] = 148.75, ["Neon|Fly|Ride"] = 187.39, ["Mega"] = 2064.71, ["Mega|Ride"] = 1121.39, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 21.25}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5871.25, ["Ride"] = 7571.29, ["Fly|Ride"] = 4999.9, ["Neon|Ride"] = 17133.14, ["Neon|Fly|Ride"] = 10312, ["Mega|Fly|Ride"] = 39229.46}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 14.88, ["Fly"] = 55.76, ["Ride"] = 22.49, ["Fly|Ride"] = 55.07, ["Neon"] = 83.74, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 153.12, ["Mega"] = 535, ["Mega|Ride"] = 467.5, ["Mega|Fly|Ride"] = 493.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.4, ["Fly"] = 135.24, ["Ride"] = 36.14, ["Fly|Ride"] = 115.65, ["Neon"] = 91.25, ["Neon|Ride"] = 121.82, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 721.63, ["Mega|Ride"] = 330.37, ["Mega|Fly|Ride"] = 1101.53}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 72.5, ["Ride"] = 78.75, ["Fly|Ride"] = 81.25, ["Neon|Ride"] = 386.11, ["Neon|Fly|Ride"] = 462.68, ["Mega"] = 4129.42, ["Mega|Fly|Ride"] = 1713.56}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.28, ["Fly"] = 69.18, ["Ride"] = 34.98, ["Fly|Ride"] = 75, ["Neon"] = 88.65, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 300, ["Mega"] = 528.58, ["Mega|Ride"] = 732.38, ["Mega|Fly|Ride"] = 762.5}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1750, ["Fly"] = 2285.64, ["Ride"] = 1763.99, ["Fly|Ride"] = 1571.25, ["Neon|Fly|Ride"] = 3600, ["Mega|Fly|Ride"] = 11875}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Fly"] = 33035.33, ["Ride"] = 32348.81, ["Fly|Ride"] = 25000, ["Neon|Ride"] = 62500, ["Neon|Fly|Ride"] = 60000, ["Mega|Fly|Ride"] = 174998.75}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 25, ["Fly"] = 375, ["Ride"] = 52.15, ["Fly|Ride"] = 123.89, ["Neon"] = 204.55, ["Neon|Ride"] = 188.81, ["Neon|Fly|Ride"] = 555, ["Mega"] = 1000, ["Mega|Ride"] = 1243.75, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.75, ["Fly"] = 99.11, ["Ride"] = 18.75, ["Fly|Ride"] = 131.25, ["Neon"] = 24.99, ["Neon|Fly"] = 138.23, ["Neon|Ride"] = 68.66, ["Neon|Fly|Ride"] = 187.3, ["Mega"] = 125, ["Mega|Fly"] = 373.79, ["Mega|Ride"] = 222.5, ["Mega|Fly|Ride"] = 285}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.03}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.39, ["Ride"] = 57.5, ["Fly|Ride"] = 125, ["Neon"] = 53.75, ["Neon|Ride"] = 110.47, ["Neon|Fly|Ride"] = 263.9, ["Mega"] = 386.11, ["Mega|Ride"] = 385, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 765.09, ["Ride"] = 704.58, ["Fly|Ride"] = 708.37, ["Neon"] = 2959.87, ["Neon|Ride"] = 2250, ["Neon|Fly|Ride"] = 2500, ["Mega|Fly|Ride"] = 10902.69}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 894.7, ["Fly"] = 1024.9, ["Ride"] = 1027.21, ["Fly|Ride"] = 941.25, ["Neon"] = 3442.91, ["Neon|Ride"] = 2973.19, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 13082.3}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.28, ["Fly"] = 116.82, ["Ride"] = 30.93, ["Fly|Ride"] = 88.8, ["Neon"] = 80.87, ["Neon|Ride"] = 74.98, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 472.88, ["Mega|Ride"] = 458.95, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.75}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 67.5, ["Fly"] = 86.67, ["Ride"] = 87, ["Fly|Ride"] = 125, ["Neon"] = 551.29, ["Neon|Ride"] = 344.59, ["Neon|Fly|Ride"] = 392.04, ["Mega"] = 18750, ["Mega|Ride"] = 1928.45, ["Mega|Fly|Ride"] = 2258.8}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 93.54, ["Ride"] = 116.25, ["Fly|Ride"] = 206.48, ["Neon"] = 428.75, ["Neon|Ride"] = 403.62, ["Neon|Fly|Ride"] = 527.4, ["Mega"] = 1343.5, ["Mega|Ride"] = 1858.24, ["Mega|Fly|Ride"] = 2047.17}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.75, ["Fly"] = 30.87, ["Ride"] = 22.5, ["Fly|Ride"] = 49.91, ["Neon"] = 47.5, ["Neon|Fly"] = 499.99, ["Neon|Ride"] = 94.98, ["Neon|Fly|Ride"] = 105.63, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 148.75, ["Fly"] = 183.75, ["Ride"] = 183.51, ["Fly|Ride"] = 262.5, ["Neon"] = 824.87, ["Neon|Ride"] = 617.49, ["Neon|Fly|Ride"] = 562.49, ["Mega"] = 4955.31, ["Mega|Fly|Ride"] = 2498.73}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.19, ["Ride"] = 46.14, ["Fly|Ride"] = 135, ["Neon"] = 36.99, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 311.88, ["Mega"] = 237.5, ["Mega|Fly"] = 1083.75, ["Mega|Ride"] = 325.72, ["Mega|Fly|Ride"] = 623.74}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.75, ["Ride"] = 37.13, ["Fly|Ride"] = 62.18, ["Neon"] = 115, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 137.38, ["Mega"] = 623.75, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 35, ["Ride"] = 55, ["Fly|Ride"] = 141.31, ["Neon"] = 215.71, ["Neon|Ride"] = 233.63, ["Mega"] = 950, ["Mega|Ride"] = 812.5, ["Mega|Fly|Ride"] = 963.66}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.25, ["Fly"] = 55.76, ["Ride"] = 24.92, ["Fly|Ride"] = 75.69, ["Neon"] = 123.75, ["Neon|Ride"] = 134.22, ["Neon|Fly|Ride"] = 312.82, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6625, ["Ride"] = 5250, ["Fly|Ride"] = 5300, ["Neon"] = 34412.49, ["Neon|Ride"] = 27500, ["Neon|Fly|Ride"] = 28768.61}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 200, ["Fly"] = 230, ["Ride"] = 231.25, ["Fly|Ride"] = 297.5, ["Neon"] = 779.11, ["Neon|Fly"] = 705.52, ["Neon|Fly|Ride"] = 616.26, ["Mega|Fly|Ride"] = 1875}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 61.25, ["Fly"] = 161.92, ["Ride"] = 105.63, ["Fly|Ride"] = 216.24, ["Neon"] = 156.24, ["Neon|Ride"] = 237.5, ["Neon|Fly|Ride"] = 325, ["Mega"] = 527.09, ["Mega|Ride"] = 499.9, ["Mega|Fly|Ride"] = 562.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.23, ["Fly"] = 86.45, ["Ride"] = 20.81, ["Fly|Ride"] = 77.49, ["Neon"] = 18.88, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 476, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61.88, ["Fly"] = 205.08, ["Ride"] = 138.35, ["Fly|Ride"] = 238.48, ["Neon"] = 190, ["Neon|Ride"] = 248.75, ["Neon|Fly|Ride"] = 370, ["Mega"] = 464.65, ["Mega|Ride"] = 425, ["Mega|Fly|Ride"] = 779.11}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15825, ["Ride"] = 12776.25, ["Fly|Ride"] = 10625, ["Neon|Fly|Ride"] = 21875, ["Mega|Fly|Ride"] = 97592.55}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 268.75, ["Ride"] = 388.75, ["Fly|Ride"] = 455.28, ["Neon|Ride"] = 2064.71, ["Neon|Fly|Ride"] = 1514.47}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 52.25, ["Fly"] = 62.5, ["Ride"] = 58.75, ["Fly|Ride"] = 107.8, ["Neon"] = 999.99, ["Neon|Ride"] = 312.48, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1925}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.86, ["Ride"] = 26.25, ["Fly|Ride"] = 58.75, ["Neon"] = 52.73, ["Neon|Fly"] = 311.88, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 401.25, ["Mega|Ride"] = 700.85, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 366.2, ["Fly"] = 825.89, ["Ride"] = 368.75, ["Fly|Ride"] = 468.36, ["Neon"] = 1639.39, ["Neon|Ride"] = 1373.75, ["Neon|Fly|Ride"] = 1249.99, ["Mega|Fly|Ride"] = 4375}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.13, ["Ride"] = 39.97, ["Fly|Ride"] = 190, ["Neon"] = 30, ["Neon|Ride"] = 88.73, ["Neon|Fly|Ride"] = 156.25, ["Mega"] = 151.25, ["Mega|Fly"] = 251.35, ["Mega|Ride"] = 216.25, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 95.53, ["Fly"] = 159.92, ["Ride"] = 141.3, ["Fly|Ride"] = 188.3, ["Neon"] = 375, ["Neon|Fly"] = 500, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 497.49, ["Mega"] = 2044.07, ["Mega|Fly|Ride"] = 2064.71}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.5, ["Fly"] = 21.14, ["Ride"] = 18.75, ["Fly|Ride"] = 30, ["Neon"] = 110.47, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 100, ["Mega"] = 2477.66, ["Mega|Fly|Ride"] = 474.99}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.9}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 75, ["Ride"] = 83.75, ["Fly|Ride"] = 125, ["Neon"] = 311.88, ["Neon|Fly"] = 515.16, ["Neon|Ride"] = 387.5, ["Neon|Fly|Ride"] = 411.92, ["Mega|Ride"] = 1926.38, ["Mega|Fly|Ride"] = 1651.65}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.32, ["Fly"] = 76.25, ["Ride"] = 31.25, ["Fly|Ride"] = 90, ["Neon"] = 85, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 228.16, ["Mega"] = 556.44, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 523.42}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 33.38}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 72.48, ["Fly"] = 138.35, ["Ride"] = 111.37, ["Fly|Ride"] = 311.88, ["Neon"] = 342.17, ["Neon|Ride"] = 418.75, ["Neon|Fly|Ride"] = 548.19, ["Mega|Fly|Ride"] = 1955.29}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.6, ["Ride"] = 27.84, ["Fly|Ride"] = 131.25, ["Neon"] = 20.7, ["Neon|Ride"] = 135.24, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 133.75, ["Mega|Ride"] = 150, ["Mega|Fly|Ride"] = 308.13}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.25, ["Fly"] = 52.5, ["Ride"] = 31.89, ["Fly|Ride"] = 83.47, ["Neon"] = 125, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 205.45, ["Mega|Ride"] = 400, ["Mega|Fly|Ride"] = 558.75}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 512.34, ["Fly"] = 516.18, ["Ride"] = 462.5, ["Fly|Ride"] = 474.99, ["Neon|Fly|Ride"] = 2683.09, ["Mega|Fly|Ride"] = 15000}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.64, ["Fly"] = 103.24, ["Ride"] = 63.37, ["Fly|Ride"] = 94.96, ["Neon"] = 186.25, ["Neon|Ride"] = 176.39, ["Neon|Fly|Ride"] = 311.88, ["Mega"] = 739.45, ["Mega|Ride"] = 649, ["Mega|Fly|Ride"] = 685.48}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 46.99, ["Fly"] = 137.58, ["Ride"] = 48.9, ["Fly|Ride"] = 137.4, ["Neon"] = 225, ["Neon|Ride"] = 154.01, ["Neon|Fly|Ride"] = 311.88, ["Mega|Ride"] = 1015.85, ["Mega|Fly|Ride"] = 875}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.55, ["Ride"] = 75, ["Fly|Ride"] = 121.82, ["Neon"] = 102.5, ["Neon|Ride"] = 123.89, ["Neon|Fly|Ride"] = 234.35, ["Mega"] = 386.11, ["Mega|Fly"] = 500, ["Mega|Ride"] = 502.76, ["Mega|Fly|Ride"] = 487.5}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 10750, ["Fly"] = 10000, ["Ride"] = 8440, ["Fly|Ride"] = 7500, ["Neon|Fly|Ride"] = 14850, ["Mega|Fly|Ride"] = 37000}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1375, ["Fly"] = 1430.33, ["Ride"] = 1437.4, ["Fly|Ride"] = 1298.74, ["Neon|Fly|Ride"] = 3912.5, ["Mega|Fly|Ride"] = 23400.38}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 492.5, ["Ride"] = 556.01, ["Fly|Ride"] = 687.29, ["Neon"] = 2146.26, ["Neon|Fly|Ride"] = 2937.5, ["Mega"] = 20647.08, ["Mega|Fly|Ride"] = 6882.71}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.09, ["Fly"] = 24.79, ["Ride"] = 20.66, ["Fly|Ride"] = 37.49, ["Neon"] = 131.12, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 115.65, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.45, ["Fly"] = 50, ["Ride"] = 36.01, ["Fly|Ride"] = 113.44, ["Neon"] = 22.5, ["Neon|Ride"] = 53.43, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 137.5, ["Mega|Ride"] = 192.8, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 37.12, ["Fly"] = 39.9, ["Ride"] = 47.41, ["Fly|Ride"] = 93.75, ["Neon"] = 156.53, ["Neon|Ride"] = 146.25, ["Neon|Fly|Ride"] = 168.75, ["Mega|Fly|Ride"] = 635}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.22, ["Fly"] = 25, ["Ride"] = 19.31, ["Fly|Ride"] = 37.49, ["Neon"] = 33.5, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 45.43, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 268.43, ["Mega|Ride"] = 200.29, ["Mega|Fly|Ride"] = 233.74}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 237.5, ["Fly"] = 410, ["Ride"] = 286.91, ["Fly|Ride"] = 337.49, ["Neon"] = 1548.54, ["Neon|Ride"] = 1005.52, ["Neon|Fly|Ride"] = 1000, ["Mega|Fly|Ride"] = 4129.42}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 16.25, ["Fly"] = 57.71, ["Ride"] = 26.24, ["Fly|Ride"] = 59.99, ["Neon"] = 137.5, ["Neon|Fly"] = 387.89, ["Neon|Ride"] = 154.9, ["Neon|Fly|Ride"] = 216.88, ["Mega"] = 825.89, ["Mega|Fly"] = 872.56, ["Mega|Ride"] = 625, ["Mega|Fly|Ride"] = 687.4}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10, ["Fly"] = 21.25, ["Ride"] = 24.32, ["Fly|Ride"] = 43.75, ["Neon"] = 80.54, ["Neon|Fly"] = 116.66, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 1500, ["Mega|Ride"] = 588.75, ["Mega|Fly|Ride"] = 403.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 499.94, ["Fly"] = 998.75, ["Ride"] = 562.5, ["Fly|Ride"] = 825.31, ["Mega|Fly|Ride"] = 9496.25}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1163.45, ["Fly"] = 1377.18, ["Ride"] = 1100, ["Fly|Ride"] = 1124.99, ["Neon"] = 5012.16, ["Neon|Fly|Ride"] = 3400, ["Mega|Fly|Ride"] = 13075.8}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 110, ["Fly"] = 138.35, ["Ride"] = 94.5, ["Fly|Ride"] = 102.4, ["Neon"] = 925, ["Neon|Ride"] = 567.81, ["Neon|Fly|Ride"] = 468.75, ["Mega|Fly|Ride"] = 2718.09}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 187.49, ["Fly"] = 250, ["Ride"] = 199.73, ["Fly|Ride"] = 260, ["Neon"] = 964.23, ["Neon|Ride"] = 700.85, ["Neon|Fly|Ride"] = 687.5, ["Mega|Ride"] = 8750, ["Mega|Fly|Ride"] = 2340.36}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.5, ["Fly"] = 118.73, ["Ride"] = 50, ["Fly|Ride"] = 99.11, ["Neon"] = 230.51, ["Neon|Ride"] = 229.09, ["Mega|Ride"] = 2064.71, ["Mega|Fly|Ride"] = 1045.42}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 375, ["Ride"] = 410.62, ["Fly|Ride"] = 468.7, ["Neon"] = 1162.5, ["Neon|Fly|Ride"] = 1238.83, ["Mega|Fly|Ride"] = 5506.58}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1875, ["Fly"] = 2203.05, ["Ride"] = 1874.9, ["Fly|Ride"] = 1932.44, ["Neon|Fly|Ride"] = 10323.54, ["Mega|Fly|Ride"] = 35666.78}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 54.91, ["Fly"] = 206.48, ["Ride"] = 47.5, ["Fly|Ride"] = 187.5, ["Neon"] = 206.48, ["Neon|Ride"] = 225, ["Neon|Fly|Ride"] = 250, ["Mega|Ride"] = 2271.19, ["Mega|Fly|Ride"] = 875}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 562.5, ["Fly"] = 825.89, ["Ride"] = 600, ["Fly|Ride"] = 612.5, ["Neon|Ride"] = 1427.5, ["Neon|Fly|Ride"] = 1112.5, ["Mega|Fly|Ride"] = 4000}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.52, ["Fly"] = 67.5, ["Ride"] = 52.84, ["Fly|Ride"] = 87.4, ["Neon|Ride"] = 233.63, ["Neon|Fly|Ride"] = 275, ["Mega|Ride"] = 1032.36, ["Mega|Fly|Ride"] = 1101.53}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.56, ["Fly"] = 35.11, ["Ride"] = 23.13, ["Fly|Ride"] = 55, ["Neon"] = 26.9, ["Neon|Fly"] = 49.99, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 98.75, ["Mega"] = 125, ["Mega|Fly"] = 237.5, ["Mega|Ride"] = 178.45, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 60, ["Ride"] = 80.54, ["Fly|Ride"] = 150, ["Neon"] = 272.05, ["Neon|Ride"] = 458.54, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 1511.38, ["Mega|Ride"] = 1651.77, ["Mega|Fly|Ride"] = 1638.35}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 943.64, ["Ride"] = 900, ["Fly|Ride"] = 975, ["Neon|Ride"] = 3303.54, ["Neon|Fly|Ride"] = 2935, ["Mega|Fly|Ride"] = 11012.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 687.5, ["Ride"] = 771.25, ["Fly|Ride"] = 866.15, ["Neon|Fly|Ride"] = 4128.39, ["Mega|Fly|Ride"] = 16517.67}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.9, ["Fly"] = 24.99, ["Ride"] = 21.09, ["Fly|Ride"] = 45, ["Neon"] = 137.5, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 137.5, ["Mega|Fly|Ride"] = 688.11}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 18.18, ["Ride"] = 38.75, ["Fly|Ride"] = 122.86, ["Neon"] = 136.21, ["Neon|Ride"] = 141.58, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 964.23, ["Mega|Ride"] = 949.78, ["Mega|Fly|Ride"] = 600}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.2, ["Ride"] = 34.99, ["Fly|Ride"] = 138.35, ["Neon"] = 23.34, ["Neon|Fly"] = 310.63, ["Neon|Ride"] = 65.42, ["Neon|Fly|Ride"] = 191.88, ["Mega"] = 187.49, ["Mega|Fly"] = 545.5, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 458.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 44.41, ["Fly"] = 66.08, ["Ride"] = 48.99, ["Fly|Ride"] = 123.64, ["Neon"] = 193.06, ["Neon|Ride"] = 205.38, ["Neon|Fly|Ride"] = 204.07, ["Mega|Ride"] = 1038.42, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 93.75, ["Ride"] = 311.88, ["Fly|Ride"] = 344.82, ["Neon"] = 393.75, ["Neon|Fly|Ride"] = 623.75, ["Mega|Ride"] = 2064.71, ["Mega|Fly|Ride"] = 2739.88}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.75, ["Fly"] = 54.91, ["Ride"] = 34.28, ["Fly|Ride"] = 87.5, ["Neon"] = 102.5, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 256.03, ["Mega"] = 409.23, ["Mega|Ride"] = 345, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.55, ["Fly"] = 60, ["Ride"] = 40.64, ["Fly|Ride"] = 85.75, ["Neon"] = 221.94, ["Neon|Ride"] = 212.4, ["Neon|Fly|Ride"] = 227.86, ["Mega"] = 1858.24, ["Mega|Fly|Ride"] = 1187.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.59, ["Fly"] = 43.66, ["Ride"] = 19.99, ["Fly|Ride"] = 37.63, ["Neon"] = 27.18, ["Neon|Ride"] = 46.56, ["Neon|Fly|Ride"] = 87.49, ["Mega"] = 414.03, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 351.25}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.25, ["Fly"] = 51.25, ["Ride"] = 38.75, ["Fly|Ride"] = 31659.21, ["Neon"] = 48.75, ["Neon|Fly"] = 110.03, ["Neon|Ride"] = 65, ["Neon|Fly|Ride"] = 232.29, ["Mega"] = 350, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 537.5}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.32, ["Fly"] = 68.74, ["Ride"] = 51.15, ["Fly|Ride"] = 97.5, ["Neon"] = 138.35, ["Neon|Ride"] = 344.59, ["Neon|Fly|Ride"] = 259.55, ["Mega|Fly|Ride"] = 1023.73}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1330, ["Fly"] = 1812.5, ["Ride"] = 1298.66, ["Fly|Ride"] = 1375, ["Neon|Ride"] = 4818.01, ["Neon|Fly|Ride"] = 3450, ["Mega|Fly|Ride"] = 11977.49}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 449.99, ["Fly"] = 499.99, ["Ride"] = 475, ["Fly|Ride"] = 499.98, ["Neon|Ride"] = 3579.18, ["Neon|Fly|Ride"] = 2250, ["Mega"] = 14452.96, ["Mega|Fly|Ride"] = 8947.42}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 250, ["Ride"] = 262.5, ["Fly|Ride"] = 375, ["Neon"] = 1500, ["Neon|Ride"] = 1398.75, ["Neon|Fly|Ride"] = 1562.5, ["Mega|Fly|Ride"] = 7000}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 37.5}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.88, ["Ride"] = 52.9, ["Fly|Ride"] = 104.99, ["Neon"] = 309.71, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 237.46, ["Neon|Fly|Ride"] = 482.12, ["Mega|Ride"] = 1135.6, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 67500, ["Fly"] = 26153.66, ["Ride"] = 35820.96, ["Fly|Ride"] = 15624.99, ["Neon|Fly|Ride"] = 35998.75, ["Mega"] = 206470.77, ["Mega|Fly|Ride"] = 85000}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 228.75, ["Fly"] = 271.15, ["Ride"] = 243.75, ["Fly|Ride"] = 275, ["Neon"] = 750, ["Neon|Fly"] = 812.5, ["Neon|Ride"] = 750, ["Neon|Fly|Ride"] = 880, ["Mega"] = 6194.13, ["Mega|Fly|Ride"] = 3125}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 112.5, ["Fly"] = 500, ["Ride"] = 237.5, ["Fly|Ride"] = 249.99}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 109.28, ["Fly"] = 153.75, ["Ride"] = 105, ["Fly|Ride"] = 138.35, ["Neon|Ride"] = 684.99, ["Neon|Fly|Ride"] = 595.32, ["Mega|Fly|Ride"] = 1651.77}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.4, ["Fly"] = 61.96, ["Ride"] = 32.01, ["Fly|Ride"] = 92.92, ["Neon"] = 78.27, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 229.19, ["Mega"] = 698.51, ["Mega|Ride"] = 688.59, ["Mega|Fly|Ride"] = 763.95}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4608.43, ["Ride"] = 3748.75, ["Fly|Ride"] = 3999.99, ["Neon"] = 20647.08, ["Neon|Fly|Ride"] = 15000, ["Mega|Fly|Ride"] = 77871.2}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.75, ["Fly"] = 41.78, ["Ride"] = 31.97, ["Fly|Ride"] = 60.22, ["Neon"] = 125, ["Neon|Ride"] = 205.45, ["Neon|Fly|Ride"] = 164.9, ["Mega|Ride"] = 1377.18, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 34.8, ["Fly"] = 82.6, ["Ride"] = 52.87, ["Fly|Ride"] = 81.23, ["Neon"] = 277.83, ["Neon|Fly"] = 1377.18, ["Neon|Ride"] = 193.13, ["Neon|Fly|Ride"] = 297.5, ["Mega|Fly|Ride"] = 1349.3}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 350, ["Fly"] = 536.24, ["Ride"] = 422.5, ["Fly|Ride"] = 523.69, ["Neon"] = 1112.5, ["Neon|Ride"] = 1125, ["Neon|Fly|Ride"] = 1368.75, ["Mega|Fly|Ride"] = 3954.65}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.88, ["Fly"] = 28.65, ["Ride"] = 23.66, ["Fly|Ride"] = 51.25, ["Neon"] = 125, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 150, ["Mega|Ride"] = 750, ["Mega|Fly|Ride"] = 583.78}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.74, ["Ride"] = 32.9, ["Fly|Ride"] = 78.27, ["Neon"] = 87.5, ["Neon|Ride"] = 124.9, ["Neon|Fly|Ride"] = 201.15, ["Mega|Ride"] = 396, ["Mega|Fly|Ride"] = 700.85}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.5, ["Ride"] = 100.63, ["Fly|Ride"] = 233.75, ["Neon"] = 700.85, ["Neon|Ride"] = 487.5, ["Neon|Fly|Ride"] = 704.08, ["Mega|Fly|Ride"] = 2492.65}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 13.75, ["Fly"] = 513.64, ["Ride"] = 71.15, ["Fly|Ride"] = 125, ["Neon"] = 78.27, ["Neon|Ride"] = 112.69, ["Neon|Fly|Ride"] = 267.09, ["Mega"] = 371.66, ["Mega|Fly"] = 463.9, ["Mega|Ride"] = 399.53, ["Mega|Fly|Ride"] = 455.28}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3500, ["Fly"] = 6073.94, ["Ride"] = 4125, ["Fly|Ride"] = 3798.75, ["Neon"] = 18750, ["Neon|Ride"] = 11750, ["Neon|Fly|Ride"] = 9956.25, ["Mega"] = 46800.74, ["Mega|Fly|Ride"] = 36138.75}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 37.48, ["Fly"] = 138.35, ["Ride"] = 50, ["Fly|Ride"] = 150, ["Neon"] = 212.5, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 237.5, ["Mega"] = 825.89, ["Mega|Ride"] = 1713.56, ["Mega|Fly|Ride"] = 747.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6250, ["Ride"] = 6531.25, ["Fly|Ride"] = 5825, ["Neon"] = 21804.22, ["Neon|Fly|Ride"] = 14425, ["Mega|Fly|Ride"] = 44687.5}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.34, ["Fly"] = 21.14, ["Ride"] = 16.9, ["Fly|Ride"] = 36.25, ["Neon"] = 24.05, ["Neon|Fly"] = 59.63, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 94.43, ["Mega"] = 200, ["Mega|Ride"] = 200.29, ["Mega|Fly|Ride"] = 247.77}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 16.25, ["Fly"] = 32.37, ["Ride"] = 25, ["Fly|Ride"] = 52.5, ["Neon"] = 179.63, ["Neon|Fly"] = 228.16, ["Neon|Ride"] = 135.15, ["Neon|Fly|Ride"] = 137.76, ["Mega|Ride"] = 956.88, ["Mega|Fly|Ride"] = 700}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.75}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.33, ["Fly"] = 31.25, ["Ride"] = 31.55, ["Fly|Ride"] = 82.87, ["Neon"] = 74.99, ["Neon|Ride"] = 110.47, ["Mega|Ride"] = 1031.34, ["Mega|Fly|Ride"] = 1076.76}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 23.73, ["Fly"] = 181.3, ["Ride"] = 46.24, ["Fly|Ride"] = 165.19, ["Neon"] = 138.35, ["Neon|Ride"] = 147.01, ["Neon|Fly|Ride"] = 208.75, ["Mega|Ride"] = 825.89, ["Mega|Fly|Ride"] = 1047.5}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.8, ["Fly"] = 27.5, ["Ride"] = 24.06, ["Fly|Ride"] = 40, ["Neon|Fly"] = 1029.27, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 115.65, ["Mega"] = 2477.66, ["Mega|Ride"] = 408.82, ["Mega|Fly|Ride"] = 588.45}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8250.59}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2546.83}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 15.4}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 231.9, ["Ride"] = 150, ["Fly|Ride"] = 324.99, ["Neon|Fly|Ride"] = 1155.23}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.5, ["Fly"] = 93.45, ["Ride"] = 31.24, ["Fly|Ride"] = 132.15, ["Neon"] = 112.92, ["Neon|Ride"] = 111.25, ["Neon|Fly|Ride"] = 252.5, ["Mega"] = 500, ["Mega|Ride"] = 1948.33, ["Mega|Fly|Ride"] = 506.9}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.25}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.25, ["Ride"] = 24.99, ["Fly|Ride"] = 82.6, ["Neon|Ride"] = 237.5}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2218.75}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 200, ["Fly"] = 412.95, ["Ride"] = 250, ["Fly|Ride"] = 350, ["Neon"] = 960, ["Neon|Ride"] = 824.87, ["Neon|Fly|Ride"] = 1031.34, ["Mega|Ride"] = 3992.13, ["Mega|Fly|Ride"] = 3749}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 57.49, ["Fly"] = 454.38, ["Ride"] = 81.72, ["Fly|Ride"] = 233.63, ["Neon"] = 375, ["Neon|Ride"] = 350, ["Neon|Fly|Ride"] = 551.29, ["Mega|Fly|Ride"] = 1914}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 181.24, ["Fly"] = 262.5, ["Ride"] = 198.75, ["Fly|Ride"] = 246.25, ["Neon"] = 899.99, ["Neon|Ride"] = 755.69, ["Neon|Fly|Ride"] = 792.19, ["Mega|Fly|Ride"] = 3499.9}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2370, ["Fly"] = 2976.23, ["Ride"] = 2500, ["Fly|Ride"] = 2750, ["Neon"] = 14500.46, ["Neon|Ride"] = 9344.5, ["Neon|Fly|Ride"] = 8437.5, ["Mega|Fly|Ride"] = 27529.79}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.5, ["Fly"] = 101.18, ["Ride"] = 51.54, ["Fly|Ride"] = 107.38, ["Neon"] = 121.25, ["Neon|Ride"] = 148.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 928.1, ["Mega|Ride"] = 964.23, ["Mega|Fly|Ride"] = 1000}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 600, ["Fly"] = 2000, ["Ride"] = 801.3, ["Fly|Ride"] = 825.89, ["Neon|Fly|Ride"] = 4049.68}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 22.72, ["Ride"] = 40, ["Fly|Ride"] = 150, ["Neon"] = 100, ["Neon|Ride"] = 128.02, ["Neon|Fly|Ride"] = 311.88, ["Mega"] = 423.75, ["Mega|Fly"] = 934.46, ["Mega|Ride"] = 452.05, ["Mega|Fly|Ride"] = 462.5}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.62, ["Fly"] = 27.88, ["Ride"] = 28.74, ["Fly|Ride"] = 122.5, ["Neon"] = 68.66, ["Neon|Fly"] = 300, ["Neon|Ride"] = 43.75, ["Neon|Fly|Ride"] = 125, ["Mega"] = 436.87, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 378.46}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 56.25}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.47, ["Ride"] = 24.89, ["Fly|Ride"] = 78.27, ["Neon|Ride"] = 223.1, ["Neon|Fly|Ride"] = 193.06, ["Mega|Ride"] = 1170.7, ["Mega|Fly|Ride"] = 2064.71}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.8, ["Fly"] = 43.75, ["Ride"] = 40, ["Fly|Ride"] = 57.83, ["Neon|Fly"] = 228.16, ["Neon|Ride"] = 212.5, ["Neon|Fly|Ride"] = 274.61, ["Mega"] = 1377.18, ["Mega|Ride"] = 1752.1, ["Mega|Fly|Ride"] = 830}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6882.71, ["Fly"] = 6456.35, ["Ride"] = 6597.78, ["Fly|Ride"] = 4873.65, ["Neon|Fly|Ride"] = 10046.02, ["Mega|Fly|Ride"] = 33035.33}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.9, ["Fly"] = 41.3, ["Ride"] = 31.25, ["Fly|Ride"] = 77.93, ["Neon"] = 52.5, ["Neon|Ride"] = 83.28, ["Neon|Fly|Ride"] = 218.44, ["Mega"] = 337.5, ["Mega|Ride"] = 274.99, ["Mega|Fly|Ride"] = 520.97}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.77}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 81.24, ["Fly"] = 365.46, ["Ride"] = 112.5, ["Fly|Ride"] = 187.5, ["Neon"] = 410.17, ["Neon|Ride"] = 455.04, ["Neon|Fly|Ride"] = 509.99, ["Mega"] = 2742.46, ["Mega|Ride"] = 1680.73, ["Mega|Fly|Ride"] = 1927.07}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 46.29, ["Fly"] = 181.83, ["Ride"] = 87.29, ["Fly|Ride"] = 156.54, ["Neon"] = 237.5, ["Neon|Fly"] = 373.79, ["Neon|Ride"] = 275.65, ["Neon|Fly|Ride"] = 437.5, ["Mega"] = 2336.14, ["Mega|Ride"] = 1134.57, ["Mega|Fly|Ride"] = 996.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.42, ["Fly"] = 78.47, ["Ride"] = 30.83, ["Fly|Ride"] = 72.5, ["Neon"] = 165.19, ["Neon|Fly"] = 223, ["Neon|Ride"] = 140, ["Neon|Fly|Ride"] = 173.75, ["Mega"] = 967.81, ["Mega|Ride"] = 687.5, ["Mega|Fly|Ride"] = 764.99}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.69, ["Fly"] = 74.99, ["Ride"] = 28.21, ["Fly|Ride"] = 100, ["Neon"] = 27.49, ["Neon|Ride"] = 84.94, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 155, ["Mega|Fly"] = 6882.71, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.87, ["Fly"] = 62.5, ["Ride"] = 30, ["Fly|Ride"] = 93.39, ["Neon"] = 83.75, ["Neon|Ride"] = 106.25, ["Neon|Fly|Ride"] = 207.89, ["Mega"] = 362.5, ["Mega|Ride"] = 688.59, ["Mega|Fly|Ride"] = 533.57}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.75, ["Fly"] = 31.23, ["Ride"] = 26.8, ["Fly|Ride"] = 52.1, ["Neon"] = 265, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 137.38, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 187.4}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 26.86, ["Ride"] = 150, ["Fly|Ride"] = 275.65, ["Neon"] = 162.5, ["Neon|Ride"] = 311.25, ["Neon|Fly|Ride"] = 375, ["Mega"] = 825, ["Mega|Ride"] = 563.68, ["Mega|Fly|Ride"] = 652.46}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 233.63, ["Fly"] = 225, ["Ride"] = 175, ["Fly|Ride"] = 138.35, ["Neon|Fly|Ride"] = 27529.79}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 42.87, ["Fly"] = 190.1, ["Ride"] = 82.07, ["Fly|Ride"] = 210, ["Neon"] = 200, ["Neon|Ride"] = 325.96, ["Neon|Fly|Ride"] = 375, ["Mega"] = 1086.25, ["Mega|Ride"] = 1000, ["Mega|Fly|Ride"] = 1273.75}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1061.25, ["Fly"] = 1125, ["Ride"] = 1000, ["Fly|Ride"] = 1086.25, ["Neon|Fly"] = 4497.05, ["Neon|Ride"] = 2875, ["Neon|Fly|Ride"] = 3500, ["Mega|Fly|Ride"] = 12500}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 373.75, ["Fly"] = 688.59, ["Ride"] = 398.74, ["Fly|Ride"] = 510.6, ["Neon"] = 2625, ["Neon|Ride"] = 2064.71, ["Neon|Fly|Ride"] = 1925, ["Mega"] = 12388.25, ["Mega|Fly|Ride"] = 8998.75}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 51.42}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.5}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.89, ["Fly"] = 30, ["Ride"] = 23.73, ["Fly|Ride"] = 50, ["Neon"] = 76, ["Neon|Fly"] = 138.75, ["Neon|Ride"] = 81.19, ["Neon|Fly|Ride"] = 136.24, ["Mega"] = 416.43, ["Mega|Ride"] = 688.59, ["Mega|Fly|Ride"] = 546.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 223.68, ["Fly"] = 499.99, ["Ride"] = 272.25, ["Fly|Ride"] = 348.75, ["Neon"] = 866.52, ["Neon|Ride"] = 750, ["Neon|Fly|Ride"] = 900, ["Mega|Fly|Ride"] = 3031.21}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 106.83, ["Ride"] = 159.9, ["Fly|Ride"] = 286.24, ["Neon"] = 437.5, ["Neon|Fly"] = 581.25, ["Neon|Ride"] = 539.69, ["Neon|Fly|Ride"] = 668.75, ["Mega"] = 2675.26, ["Mega|Ride"] = 2452.94, ["Mega|Fly|Ride"] = 2229.89}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 97.5, ["Fly"] = 206.48, ["Ride"] = 137.89, ["Fly|Ride"] = 216.8, ["Neon"] = 688.59, ["Neon|Ride"] = 983.75, ["Neon|Fly|Ride"] = 887.5, ["Mega|Fly|Ride"] = 2753.3}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.66, ["Fly"] = 76.4, ["Ride"] = 27.88, ["Fly|Ride"] = 168.28, ["Neon"] = 28.75, ["Neon|Ride"] = 66.08, ["Neon|Fly|Ride"] = 228.13, ["Mega"] = 206.48, ["Mega|Ride"] = 181.14, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.21, ["Fly"] = 48.99, ["Ride"] = 26.25, ["Fly|Ride"] = 68.66, ["Neon"] = 168.75, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 311.88, ["Mega|Ride"] = 1377.18, ["Mega|Fly|Ride"] = 587.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.45, ["Fly"] = 97.48, ["Ride"] = 32.5, ["Fly|Ride"] = 112.49, ["Neon"] = 77.3, ["Neon|Ride"] = 96.24, ["Neon|Fly|Ride"] = 256.25, ["Mega"] = 475, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.88, ["Fly"] = 124.99, ["Ride"] = 43.75, ["Fly|Ride"] = 137.5, ["Neon"] = 25, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 191.21, ["Mega"] = 164.85, ["Mega|Ride"] = 163.75, ["Mega|Fly|Ride"] = 307.45}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 258.75, ["Ride"] = 294.89, ["Fly|Ride"] = 331.24, ["Neon"] = 1377.18, ["Neon|Ride"] = 1250, ["Neon|Fly|Ride"] = 1329.25, ["Mega|Fly|Ride"] = 6297.37}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 84.51, ["Fly"] = 551.29, ["Ride"] = 120, ["Fly|Ride"] = 183.2, ["Neon"] = 400, ["Neon|Ride"] = 468.74, ["Neon|Fly|Ride"] = 490, ["Mega"] = 2476.62, ["Mega|Ride"] = 1721.98, ["Mega|Fly|Ride"] = 1762.24}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 62.5, ["Fly"] = 159.47, ["Ride"] = 78.75, ["Fly|Ride"] = 110.58, ["Neon"] = 300, ["Neon|Ride"] = 324.97, ["Neon|Fly|Ride"] = 396, ["Mega|Ride"] = 1713.56, ["Mega|Fly|Ride"] = 1307.5}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.75, ["Ride"] = 51.63, ["Fly|Ride"] = 275.65, ["Neon|Ride"] = 593.38, ["Neon|Fly|Ride"] = 482.12}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.1, ["Ride"] = 27.84, ["Fly|Ride"] = 74.77, ["Neon"] = 90, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 110.47, ["Neon|Fly|Ride"] = 120, ["Mega"] = 412.95, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 588.71}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.5, ["Fly"] = 40, ["Ride"] = 20.29, ["Fly|Ride"] = 66.16, ["Neon"] = 23.75, ["Neon|Fly"] = 40, ["Neon|Ride"] = 39.39, ["Neon|Fly|Ride"] = 82.6, ["Mega"] = 158.75, ["Mega|Ride"] = 171.15, ["Mega|Fly|Ride"] = 267.72}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 800, ["Fly"] = 875, ["Ride"] = 900, ["Fly|Ride"] = 883.75, ["Neon"] = 2890.6, ["Neon|Fly"] = 3171.3, ["Neon|Ride"] = 8258.84, ["Neon|Fly|Ride"] = 2230, ["Mega|Fly|Ride"] = 6877.86}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 250, ["Fly"] = 304.56, ["Ride"] = 288.9, ["Fly|Ride"] = 300, ["Neon"] = 1238.83, ["Neon|Ride"] = 1475.27, ["Neon|Fly|Ride"] = 1212.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4828.77}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.5, ["Fly"] = 165.19, ["Ride"] = 114.47, ["Fly|Ride"] = 165, ["Neon"] = 402.5, ["Neon|Ride"] = 396.77, ["Neon|Fly|Ride"] = 375, ["Mega"] = 1250, ["Mega|Ride"] = 1666.23, ["Mega|Fly|Ride"] = 1790.12}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 179.89, ["Fly"] = 206.48, ["Ride"] = 193.91, ["Fly|Ride"] = 226.17, ["Neon|Ride"] = 950, ["Neon|Fly|Ride"] = 625, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 6250}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.62, ["Fly"] = 55.76, ["Ride"] = 28.73, ["Fly|Ride"] = 65, ["Neon"] = 161.25, ["Neon|Ride"] = 219.61, ["Neon|Fly|Ride"] = 206.48, ["Mega|Ride"] = 722.55, ["Mega|Fly|Ride"] = 910.55}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 225, ["Ride"] = 268.75, ["Fly|Ride"] = 356.25, ["Neon"] = 852.78, ["Neon|Ride"] = 897.5, ["Neon|Fly|Ride"] = 1000, ["Mega"] = 4108.9, ["Mega|Fly|Ride"] = 4044.97}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 69.07, ["Fly"] = 119.99, ["Ride"] = 86.25, ["Fly|Ride"] = 123.38, ["Neon|Ride"] = 551.29, ["Neon|Fly|Ride"] = 825.89, ["Mega|Ride"] = 2203.05, ["Mega|Fly|Ride"] = 1547.51}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2822.46, ["Ride"] = 1858.24, ["Fly|Ride"] = 2355, ["Neon|Ride"] = 8258.84, ["Neon|Fly|Ride"] = 7329.73, ["Mega"] = 49553, ["Mega|Fly|Ride"] = 28033.5}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10, ["Fly"] = 62.5, ["Ride"] = 35, ["Fly|Ride"] = 75, ["Neon"] = 54.44, ["Neon|Fly"] = 150, ["Neon|Ride"] = 63.99, ["Neon|Fly|Ride"] = 156.81, ["Mega"] = 243.43, ["Mega|Fly"] = 551.29, ["Mega|Ride"] = 321.95, ["Mega|Fly|Ride"] = 399.9}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 40, ["Ride"] = 78.64, ["Fly|Ride"] = 142.5, ["Neon"] = 220.93, ["Neon|Ride"] = 193.06, ["Neon|Fly|Ride"] = 430.57, ["Mega|Ride"] = 887.5, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 73.72, ["Fly"] = 82.78, ["Ride"] = 78.66, ["Fly|Ride"] = 86.25, ["Neon"] = 500, ["Neon|Fly|Ride"] = 391.24, ["Mega|Fly|Ride"] = 1927.07}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2098.75, ["Fly"] = 1558.21, ["Ride"] = 1018.75, ["Fly|Ride"] = 949.99, ["Neon|Ride"] = 5451.35, ["Neon|Fly|Ride"] = 3749.99, ["Mega"] = 35375.68, ["Mega|Fly|Ride"] = 15000}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 400, ["Fly"] = 823.83, ["Ride"] = 722.65, ["Fly|Ride"] = 508.75}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 72.49, ["Fly"] = 100, ["Ride"] = 110.47, ["Fly|Ride"] = 242.61, ["Neon"] = 362.5, ["Neon|Ride"] = 326.07, ["Neon|Fly|Ride"] = 516.18, ["Mega"] = 2064.71, ["Mega|Ride"] = 1631.13, ["Mega|Fly|Ride"] = 1647.64}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.63, ["Fly"] = 31.25, ["Ride"] = 22.42, ["Fly|Ride"] = 82.6, ["Neon"] = 82.5, ["Neon|Ride"] = 90.85, ["Neon|Fly|Ride"] = 178.75, ["Mega"] = 527.5, ["Mega|Ride"] = 776.84}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.5, ["Fly"] = 59.68, ["Ride"] = 45, ["Fly|Ride"] = 66.34, ["Neon"] = 202.5, ["Neon|Fly"] = 344.82, ["Neon|Ride"] = 268.43, ["Neon|Fly|Ride"] = 330.37, ["Mega|Ride"] = 1131.25, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 687.5, ["Fly"] = 1074.62, ["Ride"] = 832.5, ["Fly|Ride"] = 849.99, ["Neon|Ride"] = 2500, ["Neon|Fly|Ride"] = 2000, ["Mega|Fly|Ride"] = 9260}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 587.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 11680.62, ["Ride"] = 5000, ["Fly|Ride"] = 4687.5, ["Neon"] = 40000, ["Neon|Ride"] = 29588.31, ["Neon|Fly|Ride"] = 23400.38, ["Mega|Fly|Ride"] = 103235.39}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 253.75, ["Fly"] = 387.14, ["Ride"] = 325, ["Fly|Ride"] = 406.5, ["Neon"] = 1651.77, ["Neon|Fly|Ride"] = 2064.71, ["Mega"] = 6193.1, ["Mega|Ride"] = 5919.53, ["Mega|Fly|Ride"] = 6194.13}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 93.44, ["Ride"] = 140.78, ["Fly|Ride"] = 275.65, ["Neon"] = 1090.18, ["Neon|Ride"] = 536.84, ["Neon|Fly|Ride"] = 467.24}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.9, ["Fly"] = 97.05, ["Ride"] = 38.75, ["Fly|Ride"] = 109.44, ["Neon"] = 138.35, ["Neon|Ride"] = 170.56, ["Neon|Fly|Ride"] = 247.5, ["Mega|Ride"] = 757.76, ["Mega|Fly|Ride"] = 762.5}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.39, ["Fly"] = 27.5, ["Ride"] = 18.75, ["Fly|Ride"] = 48.75, ["Neon"] = 139.52, ["Neon|Ride"] = 73.31, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 1250, ["Mega|Ride"] = 362.5, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 22.01, ["Ride"] = 26.22, ["Fly|Ride"] = 101.25, ["Neon"] = 112.5, ["Neon|Ride"] = 120.82, ["Neon|Fly|Ride"] = 175, ["Mega"] = 615.15, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 611.16}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.14, ["Fly"] = 27.88, ["Ride"] = 15, ["Fly|Ride"] = 46.65, ["Neon"] = 38.74, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 123.15, ["Mega"] = 636.42, ["Mega|Ride"] = 223.75, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 20, ["Ride"] = 49.98, ["Fly|Ride"] = 124.68, ["Neon"] = 149.12, ["Neon|Fly"] = 825.89, ["Neon|Ride"] = 223, ["Neon|Fly|Ride"] = 311.88, ["Mega"] = 600, ["Mega|Ride"] = 687.56, ["Mega|Fly|Ride"] = 687.56}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 524.9, ["Fly"] = 550, ["Ride"] = 561.25, ["Fly|Ride"] = 568.75, ["Neon"] = 1775.66, ["Neon|Ride"] = 2000, ["Neon|Fly|Ride"] = 1537.5, ["Mega"] = 8750, ["Mega|Fly|Ride"] = 6000}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.08, ["Fly"] = 18.75, ["Ride"] = 16.13, ["Fly|Ride"] = 36.23, ["Neon"] = 19.8, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 67.5, ["Mega"] = 162.5, ["Mega|Ride"] = 218.87, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 41.25, ["Fly"] = 111.24, ["Ride"] = 79.37, ["Fly|Ride"] = 127.05, ["Neon"] = 197.5, ["Neon|Fly"] = 287.01, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 272.5, ["Mega"] = 537.49, ["Mega|Fly"] = 825.89, ["Mega|Ride"] = 537.4, ["Mega|Fly|Ride"] = 564.8}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 705.66, ["Ride"] = 768.74, ["Fly|Ride"] = 753.75, ["Neon|Ride"] = 2025.43, ["Neon|Fly|Ride"] = 1537.5, ["Mega|Fly|Ride"] = 4083.63}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.64, ["Fly"] = 86.23, ["Ride"] = 42.49, ["Fly|Ride"] = 89.9, ["Neon"] = 250, ["Neon|Fly"] = 237.5, ["Neon|Ride"] = 179.9, ["Neon|Fly|Ride"] = 239.99, ["Mega"] = 1246.33, ["Mega|Fly|Ride"] = 838.74}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 269.32, ["Fly"] = 313.37, ["Ride"] = 267.18, ["Fly|Ride"] = 300, ["Neon"] = 1548.54, ["Neon|Ride"] = 1341.04, ["Neon|Fly|Ride"] = 1230, ["Mega|Fly|Ride"] = 4267.76}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 232.76, ["Fly"] = 350.43, ["Ride"] = 249.99, ["Fly|Ride"] = 311.85, ["Neon"] = 850, ["Neon|Ride"] = 875, ["Neon|Fly|Ride"] = 833.75, ["Mega"] = 4802.52, ["Mega|Fly|Ride"] = 3991.09}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 625, ["Ride"] = 702.5, ["Fly|Ride"] = 668.25, ["Neon|Ride"] = 3442.91, ["Neon|Fly|Ride"] = 2187.5, ["Mega|Fly|Ride"] = 10046.88}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.25, ["Fly"] = 59.89, ["Ride"] = 43.74, ["Fly|Ride"] = 102.35, ["Neon"] = 76.24, ["Neon|Fly"] = 280.34, ["Neon|Ride"] = 76.25, ["Neon|Fly|Ride"] = 150, ["Mega"] = 250, ["Mega|Ride"] = 412.95, ["Mega|Fly|Ride"] = 430}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3896.11, ["Fly"] = 3375, ["Ride"] = 3187.5, ["Fly|Ride"] = 3058.75, ["Neon|Fly|Ride"] = 7592.41, ["Mega|Fly|Ride"] = 17997.5}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 140, ["Fly"] = 165.19, ["Ride"] = 149.68, ["Fly|Ride"] = 196.84, ["Neon"] = 510, ["Neon|Fly"] = 630.77, ["Neon|Ride"] = 623.75, ["Neon|Fly|Ride"] = 487.5, ["Mega|Ride"] = 3055.77, ["Mega|Fly|Ride"] = 3090.88}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.39, ["Fly"] = 19.61, ["Ride"] = 17.5, ["Fly|Ride"] = 41.24, ["Neon"] = 20, ["Neon|Fly"] = 96.97, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 243.64, ["Mega|Fly"] = 425, ["Mega|Ride"] = 236.41, ["Mega|Fly|Ride"] = 232.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.49, ["Ride"] = 26.64, ["Fly|Ride"] = 62.49, ["Neon"] = 21.25, ["Neon|Fly"] = 114.48, ["Neon|Ride"] = 46.73, ["Neon|Fly|Ride"] = 125, ["Mega"] = 166.04, ["Mega|Ride"] = 247.77, ["Mega|Fly|Ride"] = 362.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 30, ["Fly"] = 38.41, ["Ride"] = 32.5, ["Fly|Ride"] = 46.55, ["Neon"] = 280.34, ["Neon|Fly|Ride"] = 258.49, ["Mega|Fly|Ride"] = 1166.56}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 812.5, ["Fly"] = 1168.07, ["Ride"] = 850, ["Fly|Ride"] = 1125, ["Neon|Ride"] = 4362.73, ["Neon|Fly|Ride"] = 4570.24}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7639.43, ["Fly|Ride"] = 6494.55}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.75, ["Fly"] = 37.5, ["Ride"] = 25, ["Fly|Ride"] = 56.25, ["Neon"] = 430.6, ["Neon|Ride"] = 132.15, ["Neon|Fly|Ride"] = 148.75, ["Mega"] = 2400, ["Mega|Ride"] = 825.83, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.27, ["Fly"] = 41.25, ["Ride"] = 29.98, ["Fly|Ride"] = 75, ["Neon"] = 97.5, ["Neon|Fly"] = 106.25, ["Neon|Ride"] = 73.66, ["Neon|Fly|Ride"] = 143.75, ["Mega"] = 637.01, ["Mega|Ride"] = 503.75, ["Mega|Fly|Ride"] = 477.5}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 106.86, ["Ride"] = 96.67, ["Fly|Ride"] = 163.35, ["Neon|Ride"] = 431.73, ["Neon|Fly|Ride"] = 503.74, ["Mega|Fly|Ride"] = 1649.71}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 224.9, ["Fly"] = 225, ["Ride"] = 212.5, ["Fly|Ride"] = 249.7, ["Neon"] = 1225, ["Neon|Ride"] = 1126.6, ["Neon|Fly|Ride"] = 648.75, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 3855.85}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.4, ["Ride"] = 33.14, ["Fly|Ride"] = 55, ["Neon"] = 21.59, ["Neon|Fly"] = 625, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 119.9, ["Mega"] = 214.74, ["Mega|Fly"] = 230.22, ["Mega|Ride"] = 148.75, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 160.21, ["Fly"] = 220.68, ["Ride"] = 187.49, ["Fly|Ride"] = 269.52, ["Neon"] = 625, ["Neon|Ride"] = 612.5, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2900}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.43, ["Fly"] = 24.91, ["Ride"] = 14.98, ["Fly|Ride"] = 42.77, ["Neon"] = 22.5, ["Neon|Fly"] = 123.89, ["Neon|Ride"] = 37.39, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 234.35, ["Mega|Ride"] = 193.06, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190, ["Fly"] = 338.62, ["Ride"] = 260.17, ["Fly|Ride"] = 299.99, ["Neon|Ride"] = 1183.75, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4672.26}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.71, ["Fly"] = 99.98, ["Ride"] = 27.13, ["Fly|Ride"] = 65, ["Neon"] = 86.23, ["Neon|Fly"] = 296.69, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 150, ["Mega"] = 551.29, ["Mega|Ride"] = 425.34, ["Mega|Fly|Ride"] = 633.87}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2, ["Ride"] = 24.98, ["Fly|Ride"] = 61.96, ["Neon"] = 9.81, ["Neon|Fly"] = 162.34, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 186.24, ["Mega"] = 77.43, ["Mega|Ride"] = 129.64, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2, ["Neon"] = 2, ["Mega"] = 22.7, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 130.09}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2, ["Ride"] = 39.24, ["Fly|Ride"] = 109.97, ["Neon"] = 6.86, ["Neon|Ride"] = 39.24, ["Neon|Fly|Ride"] = 124.98, ["Mega"] = 58.73, ["Mega|Fly"] = 182591.1, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 220.07}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 71.25, ["Fly"] = 125, ["Ride"] = 91.22, ["Fly|Ride"] = 131.25, ["Neon"] = 275, ["Neon|Fly"] = 316.94, ["Neon|Ride"] = 281.24, ["Neon|Fly|Ride"] = 374.93, ["Mega|Fly|Ride"] = 1547.51}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2, ["Fly"] = 36.22, ["Ride"] = 15.76, ["Fly|Ride"] = 80.54, ["Neon"] = 5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 49.9, ["Mega"] = 87.5, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 249.99}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.11, ["Ride"] = 105.31, ["Neon"] = 69.18, ["Neon|Fly"] = 311.88, ["Neon|Ride"] = 284.9, ["Mega"] = 300, ["Mega|Ride"] = 549.22, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2, ["Fly"] = 37.5, ["Neon"] = 2.38, ["Neon|Ride"] = 53.71, ["Neon|Fly|Ride"] = 189.96, ["Mega"] = 23.75, ["Mega|Ride"] = 49.97, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2, ["Fly"] = 69.17, ["Ride"] = 11.25, ["Fly|Ride"] = 47.5, ["Neon"] = 2, ["Neon|Fly"] = 38.73, ["Neon|Ride"] = 12.22, ["Neon|Fly|Ride"] = 31.25, ["Mega"] = 13.74, ["Mega|Fly"] = 34.44, ["Mega|Ride"] = 17.39, ["Mega|Fly|Ride"] = 46.25}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 15.28, ["Fly|Ride"] = 77.18, ["Neon"] = 2, ["Neon|Fly"] = 18.75, ["Neon|Ride"] = 14.02, ["Neon|Fly|Ride"] = 39.94, ["Mega"] = 18.75, ["Mega|Fly"] = 156.53, ["Mega|Ride"] = 30.84, ["Mega|Fly|Ride"] = 85}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2, ["Neon"] = 2.5, ["Mega"] = 17.5, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2, ["Fly"] = 30.99, ["Ride"] = 20, ["Fly|Ride"] = 47.5, ["Neon"] = 3.17, ["Neon|Fly"] = 117.7, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 87.49, ["Mega"] = 39.41, ["Mega|Fly"] = 87.5, ["Mega|Ride"] = 40, ["Mega|Fly|Ride"] = 136.88}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2, ["Neon"] = 2, ["Neon|Ride"] = 78.18, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 20, ["Mega|Fly"] = 125, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 206.48}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.74, ["Fly"] = 52.73, ["Ride"] = 62.48, ["Fly|Ride"] = 97.05, ["Neon"] = 39.57, ["Neon|Fly"] = 126.94, ["Neon|Ride"] = 65.05, ["Neon|Fly|Ride"] = 152.5, ["Mega"] = 187.5, ["Mega|Fly"] = 381.97, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 268.75}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2, ["Ride"] = 50, ["Neon"] = 2, ["Neon|Fly"] = 25, ["Neon|Ride"] = 25.65, ["Neon|Fly|Ride"] = 311.35, ["Mega"] = 20.98, ["Mega|Fly"] = 137.5, ["Mega|Ride"] = 127.03, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2, ["Fly"] = 62.5, ["Ride"] = 139.37, ["Fly|Ride"] = 138.35, ["Neon"] = 18.64, ["Mega"] = 103.75, ["Mega|Fly"] = 300, ["Mega|Ride"] = 261.24, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.43, ["Ride"] = 24.99, ["Neon"] = 19.9, ["Mega"] = 125, ["Mega|Ride"] = 206.48, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2, ["Fly"] = 138.35, ["Ride"] = 31.24, ["Neon"] = 2.49, ["Neon|Ride"] = 25.83, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 21.2, ["Mega|Ride"] = 42.5, ["Mega|Fly|Ride"] = 93.34}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2, ["Fly"] = 18.67, ["Ride"] = 12.5, ["Fly|Ride"] = 38.35, ["Neon"] = 2, ["Neon|Fly"] = 33.53, ["Neon|Ride"] = 15, ["Neon|Fly|Ride"] = 30, ["Mega"] = 13.62, ["Mega|Fly"] = 31.25, ["Mega|Ride"] = 19.9, ["Mega|Fly|Ride"] = 48.74}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.52, ["Fly"] = 68.75, ["Ride"] = 51.69, ["Fly|Ride"] = 112.48, ["Neon"] = 33.25, ["Neon|Ride"] = 69.18, ["Mega"] = 174.99, ["Mega|Ride"] = 230}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2, ["Ride"] = 31.24, ["Neon"] = 3.02, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 20, ["Mega|Ride"] = 57.83, ["Mega|Fly|Ride"] = 106.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2, ["Neon"] = 17.5, ["Neon|Ride"] = 185.81, ["Mega"] = 96.66, ["Mega|Ride"] = 165.19, ["Mega|Fly|Ride"] = 296.24}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.5, ["Fly"] = 75.93, ["Ride"] = 27.49, ["Fly|Ride"] = 43.75, ["Neon"] = 11.15, ["Neon|Ride"] = 48.53, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 123.75, ["Mega|Ride"] = 155.62, ["Mega|Fly|Ride"] = 187.49}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2, ["Fly"] = 34.43, ["Ride"] = 11.23, ["Fly|Ride"] = 29.9, ["Neon"] = 2, ["Neon|Fly"] = 18.92, ["Neon|Ride"] = 12.5, ["Neon|Fly|Ride"] = 30, ["Mega"] = 24.64, ["Mega|Fly"] = 26.26, ["Mega|Ride"] = 20, ["Mega|Fly|Ride"] = 44.99}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2, ["Fly"] = 27.85, ["Ride"] = 26.11, ["Fly|Ride"] = 137.5, ["Neon"] = 12.34, ["Neon|Fly"] = 125, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 187.2, ["Mega"] = 123.47, ["Mega|Ride"] = 153.12, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.2, ["Ride"] = 23.37, ["Fly|Ride"] = 56.25, ["Neon"] = 62.98, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 277.5, ["Mega|Ride"] = 283.34, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2, ["Fly"] = 55.76, ["Ride"] = 13.72, ["Fly|Ride"] = 39.33, ["Neon"] = 2, ["Neon|Fly"] = 18.75, ["Neon|Ride"] = 14.99, ["Neon|Fly|Ride"] = 38.69, ["Mega"] = 20, ["Mega|Fly"] = 48.53, ["Mega|Ride"] = 30, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.44, ["Fly"] = 172.41, ["Ride"] = 43.72, ["Neon"] = 6.24, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 143.75, ["Mega"] = 48.75, ["Mega|Fly"] = 165.19, ["Mega|Ride"] = 112.5, ["Mega|Fly|Ride"] = 249.98}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2, ["Fly"] = 27, ["Ride"] = 33.75, ["Fly|Ride"] = 124.99, ["Neon"] = 3.39, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 49.99, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 27.5, ["Mega|Fly"] = 110.23, ["Mega|Ride"] = 77.5, ["Mega|Fly|Ride"] = 362.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2, ["Fly"] = 31.55, ["Ride"] = 26.24, ["Neon"] = 2, ["Neon|Ride"] = 33.58, ["Neon|Fly|Ride"] = 3000, ["Mega"] = 13.39, ["Mega|Fly"] = 241.73, ["Mega|Ride"] = 25, ["Mega|Fly|Ride"] = 148.75}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2, ["Fly"] = 22.72, ["Ride"] = 18.63, ["Fly|Ride"] = 50.13, ["Neon"] = 6.05, ["Neon|Fly"] = 55.52, ["Neon|Ride"] = 31.73, ["Neon|Fly|Ride"] = 71.23, ["Mega"] = 100.2, ["Mega|Ride"] = 80, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2, ["Ride"] = 21.52, ["Neon"] = 5.52, ["Neon|Ride"] = 55.34, ["Mega"] = 50, ["Mega|Fly"] = 311.88, ["Mega|Ride"] = 108.75, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2, ["Fly"] = 18.58, ["Ride"] = 16.28, ["Fly|Ride"] = 41.3, ["Neon"] = 3.73, ["Neon|Fly"] = 77.99, ["Neon|Ride"] = 24.7, ["Neon|Fly|Ride"] = 79.98, ["Mega"] = 108.75, ["Mega|Fly"] = 110.25, ["Mega|Ride"] = 75.98, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.25, ["Ride"] = 35.26, ["Neon"] = 28.68, ["Neon|Fly"] = 179.88, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 99.75, ["Mega|Fly"] = 350, ["Mega|Ride"] = 137.5}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2, ["Fly"] = 24.54, ["Ride"] = 15, ["Fly|Ride"] = 44.99, ["Neon"] = 11.11, ["Neon|Fly"] = 46.73, ["Neon|Ride"] = 37.49, ["Neon|Fly|Ride"] = 85.69, ["Mega"] = 118.73, ["Mega|Fly"] = 400, ["Mega|Ride"] = 77.04, ["Mega|Fly|Ride"] = 164.24}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 6.13, ["Fly"] = 13.65, ["Ride"] = 11.25, ["Fly|Ride"] = 61.66, ["Neon"] = 13.64, ["Neon|Fly"] = 25, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 100, ["Mega|Fly"] = 112.5, ["Mega|Ride"] = 412.94, ["Mega|Fly|Ride"] = 212.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.75, ["Fly"] = 109.44, ["Neon"] = 96.9, ["Neon|Ride"] = 82.94, ["Neon|Fly|Ride"] = 2500, ["Mega"] = 245.02, ["Mega|Ride"] = 307.65}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 6.12, ["Ride"] = 62.5, ["Neon"] = 68.88, ["Neon|Ride"] = 162.5, ["Mega"] = 643.17, ["Mega|Ride"] = 693.75, ["Mega|Fly|Ride"] = 934.46}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2, ["Ride"] = 38.75, ["Neon"] = 42.49, ["Neon|Ride"] = 103.16, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 212.5, ["Mega|Ride"] = 350}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.73, ["Ride"] = 43.75, ["Fly|Ride"] = 123.89, ["Neon"] = 46, ["Neon|Ride"] = 66.06, ["Neon|Fly|Ride"] = 121.22, ["Mega"] = 214.91, ["Mega|Ride"] = 392.3, ["Mega|Fly|Ride"] = 425.63}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2, ["Neon"] = 2.4, ["Neon|Ride"] = 50, ["Mega"] = 17.21, ["Mega|Ride"] = 121.82, ["Mega|Fly|Ride"] = 224.93}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.5}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5, ["Fly"] = 20, ["Ride"] = 21.24, ["Fly|Ride"] = 44.99, ["Neon"] = 36.16, ["Neon|Fly"] = 180, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 106.25, ["Mega|Ride"] = 198.74, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2, ["Fly"] = 67.5, ["Ride"] = 19.31, ["Neon"] = 3.64, ["Neon|Fly"] = 50.28, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 27.48, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2, ["Ride"] = 24.92, ["Neon"] = 3.64, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 30, ["Mega|Ride"] = 60.12, ["Mega|Fly|Ride"] = 128.75}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2, ["Fly"] = 43.02, ["Ride"] = 15.36, ["Fly|Ride"] = 43.11, ["Neon"] = 11.66, ["Neon|Ride"] = 22.95, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 154.58, ["Mega|Ride"] = 112.5, ["Mega|Fly|Ride"] = 146.61}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.54, ["Fly"] = 41.3, ["Ride"] = 20.66, ["Fly|Ride"] = 78.27, ["Neon"] = 39.19, ["Neon|Ride"] = 198.22, ["Neon|Fly|Ride"] = 137.49, ["Mega"] = 312.5, ["Mega|Ride"] = 329, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2, ["Ride"] = 32.5, ["Neon"] = 3.57, ["Neon|Ride"] = 38, ["Neon|Fly|Ride"] = 98.09, ["Mega"] = 25, ["Mega|Fly"] = 112.5, ["Mega|Ride"] = 51.14, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2, ["Fly"] = 26.28, ["Ride"] = 16.36, ["Fly|Ride"] = 56.25, ["Neon"] = 2.92, ["Neon|Fly"] = 109.44, ["Neon|Ride"] = 15.95, ["Neon|Fly|Ride"] = 86.25, ["Mega"] = 29.9, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 49.48, ["Mega|Fly|Ride"] = 132.15}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2, ["Fly"] = 37.49, ["Ride"] = 17.42, ["Fly|Ride"] = 26.25, ["Neon"] = 4.27, ["Neon|Fly"] = 87.63, ["Neon|Ride"] = 18.49, ["Neon|Fly|Ride"] = 58.4, ["Mega"] = 80.54, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 110.47, ["Mega|Fly|Ride"] = 114.6}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2, ["Fly"] = 87.5, ["Ride"] = 47.5, ["Fly|Ride"] = 138.35, ["Neon"] = 9.17, ["Neon|Ride"] = 61.24, ["Neon|Fly|Ride"] = 88.75, ["Mega"] = 76.22, ["Mega|Ride"] = 130, ["Mega|Fly|Ride"] = 285.72}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2, ["Ride"] = 25, ["Neon"] = 3.32, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 150445.21, ["Mega"] = 18.9, ["Mega|Fly"] = 109.44, ["Mega|Ride"] = 82.84, ["Mega|Fly|Ride"] = 124.89}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2, ["Fly"] = 43.72, ["Ride"] = 18.63, ["Fly|Ride"] = 48.75, ["Neon"] = 2.04, ["Neon|Fly"] = 26.88, ["Neon|Ride"] = 23.04, ["Neon|Fly|Ride"] = 86.31, ["Mega"] = 17.5, ["Mega|Fly"] = 69.13, ["Mega|Ride"] = 41.3, ["Mega|Fly|Ride"] = 74.99}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2, ["Neon"] = 2.5, ["Mega"] = 13.5, ["Mega|Ride"] = 123.75}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2, ["Neon"] = 3.63, ["Neon|Fly|Ride"] = 400, ["Mega"] = 26.82, ["Mega|Ride"] = 193.06, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2, ["Fly"] = 24.99, ["Ride"] = 15.5, ["Fly|Ride"] = 66.24, ["Neon"] = 3.65, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 46.07, ["Mega"] = 36.13, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 50}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.5, ["Ride"] = 75, ["Fly|Ride"] = 206.48, ["Neon"] = 68.75, ["Neon|Ride"] = 106.3, ["Mega"] = 371.24, ["Mega|Ride"] = 460.44, ["Mega|Fly|Ride"] = 618.39}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2, ["Fly"] = 6250, ["Ride"] = 24.99, ["Neon"] = 24.01, ["Neon|Ride"] = 150, ["Mega"] = 201.32, ["Mega|Fly|Ride"] = 599.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 31.55, ["Fly|Ride"] = 125, ["Neon"] = 22.78, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 309.71, ["Mega|Ride"] = 283.91, ["Mega|Fly|Ride"] = 369.9}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2, ["Fly"] = 13.52, ["Ride"] = 11.25, ["Fly|Ride"] = 24.05, ["Neon"] = 2, ["Neon|Fly"] = 18.43, ["Neon|Ride"] = 12.81, ["Neon|Fly|Ride"] = 30, ["Mega"] = 13.63, ["Mega|Fly"] = 99.98, ["Mega|Ride"] = 21.21, ["Mega|Fly|Ride"] = 46.69}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2, ["Fly"] = 112.5, ["Ride"] = 57.5, ["Neon"] = 8.87, ["Neon|Fly"] = 65.32, ["Neon|Ride"] = 30.99, ["Neon|Fly|Ride"] = 688.59, ["Mega"] = 112.49, ["Mega|Ride"] = 138.35}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2, ["Fly"] = 69.18, ["Ride"] = 30, ["Neon"] = 2, ["Neon|Fly"] = 30.81, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 82.53, ["Mega"] = 13.59, ["Mega|Fly"] = 138.35, ["Mega|Fly|Ride"] = 172.41}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2, ["Neon"] = 3.74, ["Neon|Fly"] = 58, ["Neon|Ride"] = 121.25, ["Mega"] = 15.5, ["Mega|Fly"] = 206.48, ["Mega|Fly|Ride"] = 349.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2, ["Fly"] = 137.67, ["Ride"] = 18.74, ["Fly|Ride"] = 42.22, ["Neon"] = 8.64, ["Neon|Fly"] = 56.24, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 74.91, ["Mega"] = 165, ["Mega|Ride"] = 152.5, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 171.78, ["Ride"] = 224.99, ["Fly|Ride"] = 760.41, ["Neon|Ride"] = 887.74, ["Neon|Fly|Ride"] = 909.93, ["Mega"] = 8258.84, ["Mega|Fly|Ride"] = 3124.95}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2, ["Ride"] = 26.86, ["Neon"] = 6.91, ["Neon|Ride"] = 61.24, ["Mega"] = 62.5, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.5, ["Fly"] = 98.74, ["Ride"] = 23.51, ["Fly|Ride"] = 62.5, ["Neon"] = 40.28, ["Neon|Ride"] = 76.4, ["Neon|Fly|Ride"] = 165.19, ["Mega"] = 367.5, ["Mega|Ride"] = 218.44, ["Mega|Fly|Ride"] = 622.7}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2, ["Fly"] = 37.49, ["Ride"] = 14.02, ["Fly|Ride"] = 30.9, ["Neon"] = 5.62, ["Neon|Fly"] = 32.01, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 46.73, ["Mega"] = 47.3, ["Mega|Ride"] = 80, ["Mega|Fly|Ride"] = 125.95}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2, ["Fly"] = 69.18, ["Ride"] = 18.75, ["Fly|Ride"] = 124.9, ["Neon"] = 8.84, ["Neon|Ride"] = 76.25, ["Neon|Fly|Ride"] = 250, ["Mega"] = 80.91, ["Mega|Fly|Ride"] = 399.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.78, ["Fly"] = 26.62, ["Ride"] = 15.95, ["Fly|Ride"] = 38.75, ["Neon"] = 30, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 80.85, ["Mega|Ride"] = 825.89, ["Mega|Fly|Ride"] = 270}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.65, ["Ride"] = 33.04, ["Fly|Ride"] = 93.45, ["Neon"] = 48.23, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 275, ["Mega"] = 245, ["Mega|Ride"] = 304.56, ["Mega|Fly|Ride"] = 368.74}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.35, ["Fly"] = 18.73, ["Ride"] = 12.5, ["Fly|Ride"] = 32.49, ["Neon"] = 30, ["Neon|Fly"] = 90.62, ["Neon|Ride"] = 28.04, ["Neon|Fly|Ride"] = 92.48, ["Mega"] = 250, ["Mega|Ride"] = 358.24, ["Mega|Fly|Ride"] = 269.23}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 51.06, ["Ride"] = 89.09, ["Fly|Ride"] = 136.12, ["Neon"] = 315.91, ["Neon|Fly"] = 428.75, ["Neon|Ride"] = 275.65, ["Neon|Fly|Ride"] = 348.54, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 235.7, ["Fly"] = 412.95, ["Ride"] = 221.25, ["Fly|Ride"] = 325, ["Neon|Ride"] = 1075, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4129.42}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 54.13, ["Fly"] = 104.29, ["Ride"] = 70.1, ["Fly|Ride"] = 114.04, ["Neon"] = 467.24, ["Neon|Fly"] = 349.97, ["Neon|Ride"] = 279.32, ["Neon|Fly|Ride"] = 386.11, ["Mega|Fly|Ride"] = 1755.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.99, ["Fly"] = 274.47, ["Ride"] = 27.49, ["Neon"] = 50, ["Neon|Fly"] = 96.38, ["Neon|Ride"] = 94.58, ["Mega"] = 250, ["Mega|Ride"] = 181.25, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.85, ["Ride"] = 24.97, ["Fly|Ride"] = 62.5, ["Neon"] = 59.99, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 198.75, ["Mega"] = 286.88, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 491.41}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2, ["Fly"] = 32.87, ["Ride"] = 12.25, ["Fly|Ride"] = 37.63, ["Neon"] = 3.18, ["Neon|Ride"] = 19.18, ["Neon|Fly|Ride"] = 68.92, ["Mega"] = 35, ["Mega|Fly"] = 142.51, ["Mega|Ride"] = 90, ["Mega|Fly|Ride"] = 520.97}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 11.25, ["Fly"] = 66.08, ["Ride"] = 32.49, ["Fly|Ride"] = 62.9, ["Neon"] = 94.08, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 108.75, ["Neon|Fly|Ride"] = 260.17, ["Mega"] = 495.54, ["Mega|Ride"] = 482.12, ["Mega|Fly|Ride"] = 578.13}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2, ["Fly"] = 40, ["Ride"] = 15, ["Fly|Ride"] = 45, ["Neon"] = 16.15, ["Neon|Fly"] = 49.56, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 81.68, ["Mega"] = 137.35, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 276.25}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.34, ["Ride"] = 26.64, ["Fly|Ride"] = 312.5, ["Neon"] = 42.5, ["Neon|Ride"] = 46.73, ["Neon|Fly|Ride"] = 195.08, ["Mega"] = 197.5, ["Mega|Ride"] = 325, ["Mega|Fly|Ride"] = 295.76}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 26.35, ["Ride"] = 18.44, ["Neon"] = 2, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 18.57, ["Neon|Fly|Ride"] = 54.99, ["Mega"] = 15, ["Mega|Ride"] = 39.24, ["Mega|Fly|Ride"] = 74.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2, ["Fly"] = 23.63, ["Ride"] = 18.18, ["Fly|Ride"] = 41.3, ["Neon"] = 24.25, ["Neon|Fly"] = 103.24, ["Neon|Ride"] = 35.06, ["Neon|Fly|Ride"] = 133.17, ["Mega"] = 74.97, ["Mega|Fly|Ride"] = 215.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2, ["Fly"] = 52.5, ["Ride"] = 18.17, ["Fly|Ride"] = 67.72, ["Neon"] = 20.83, ["Neon|Ride"] = 45, ["Mega"] = 125, ["Mega|Ride"] = 253.75, ["Mega|Fly|Ride"] = 253.97}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 109.99, ["Fly"] = 156.3, ["Ride"] = 137.49, ["Fly|Ride"] = 224.9, ["Neon"] = 409.89, ["Neon|Ride"] = 441.02, ["Neon|Fly|Ride"] = 400, ["Mega"] = 3737.8, ["Mega|Fly|Ride"] = 2946.35}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.49, ["Ride"] = 123.89, ["Fly|Ride"] = 125, ["Neon"] = 45.4, ["Neon|Ride"] = 93.73, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 265.16, ["Mega|Ride"] = 237.5, ["Mega|Fly|Ride"] = 358.87}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2, ["Fly"] = 41.25, ["Ride"] = 18.75, ["Fly|Ride"] = 39.73, ["Neon"] = 27.5, ["Neon|Ride"] = 59.97, ["Neon|Fly|Ride"] = 114.15, ["Mega"] = 200, ["Mega|Ride"] = 176.95, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 16.15, ["Ride"] = 27.5, ["Fly|Ride"] = 151.43, ["Neon"] = 69.14, ["Neon|Ride"] = 153.65, ["Neon|Fly|Ride"] = 250, ["Mega"] = 412.95, ["Mega|Fly"] = 825.89, ["Mega|Ride"] = 647.29, ["Mega|Fly|Ride"] = 794.3}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.75}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.75, ["Ride"] = 37.17, ["Fly|Ride"] = 122.86, ["Neon"] = 31.25, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 250, ["Mega"] = 250, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 824.34}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.13, ["Fly"] = 31.79, ["Ride"] = 25.71, ["Fly|Ride"] = 68.14, ["Neon"] = 85, ["Neon|Fly"] = 96969.69, ["Neon|Ride"] = 154.9, ["Neon|Fly|Ride"] = 143.72, ["Mega"] = 1332.77, ["Mega|Fly|Ride"] = 558.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2, ["Ride"] = 50, ["Fly|Ride"] = 49.89, ["Neon"] = 2.49, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 131.12, ["Mega"] = 43.75, ["Mega|Fly"] = 180, ["Mega|Ride"] = 83.75, ["Mega|Fly|Ride"] = 221.74}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.64, ["Fly"] = 14.88, ["Ride"] = 20.23, ["Fly|Ride"] = 62.41, ["Neon"] = 61.96, ["Mega"] = 274.6, ["Mega|Fly"] = 390.14, ["Mega|Ride"] = 311.78, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.5, ["Fly"] = 27.58, ["Ride"] = 15.5, ["Fly|Ride"] = 26.25, ["Neon"] = 11.39, ["Neon|Fly"] = 178, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 70.8, ["Mega"] = 175, ["Mega|Ride"] = 210.62, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2, ["Ride"] = 37.49, ["Neon"] = 2, ["Neon|Fly"] = 262.23, ["Neon|Ride"] = 39.66, ["Mega"] = 25, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 206.48}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 21.04, ["Fly"] = 84.89, ["Ride"] = 82.14, ["Fly|Ride"] = 123.89, ["Neon"] = 155.25, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 548.75, ["Mega"] = 798.75, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 722.91}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.69, ["Fly"] = 27.88, ["Ride"] = 46.24, ["Fly|Ride"] = 200, ["Neon"] = 89.46, ["Mega|Ride"] = 309.71, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2, ["Fly"] = 22.49, ["Ride"] = 20, ["Fly|Ride"] = 60.62, ["Neon"] = 32.49, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 152.02, ["Mega|Fly|Ride"] = 267.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 75, ["Fly"] = 412.49, ["Ride"] = 123.89, ["Neon"] = 552.32, ["Neon|Ride"] = 562.5, ["Neon|Fly|Ride"] = 509.4, ["Mega"] = 4362.73, ["Mega|Fly|Ride"] = 3500}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.98, ["Fly"] = 43.66, ["Ride"] = 23.26, ["Fly|Ride"] = 46.82, ["Neon"] = 33.64, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 113.75, ["Mega"] = 228.23, ["Mega|Ride"] = 225, ["Mega|Fly|Ride"] = 344.59}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.75, ["Fly"] = 124.99, ["Ride"] = 112.5, ["Fly|Ride"] = 196.25, ["Neon"] = 230.32, ["Neon|Ride"] = 196, ["Neon|Fly|Ride"] = 331.89, ["Mega"] = 970, ["Mega|Ride"] = 1029.07, ["Mega|Fly|Ride"] = 1041.25}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.75, ["Ride"] = 57, ["Fly|Ride"] = 95, ["Neon"] = 138.28, ["Neon|Ride"] = 95, ["Neon|Fly|Ride"] = 200, ["Mega"] = 336.24, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 418.75}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 15.5, ["Fly"] = 37.5, ["Ride"] = 24.79, ["Fly|Ride"] = 68.97, ["Neon"] = 92.5, ["Neon|Fly|Ride"] = 371.45, ["Mega"] = 545.5, ["Mega|Ride"] = 549.22, ["Mega|Fly|Ride"] = 592.58}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.64, ["Fly"] = 95.79, ["Ride"] = 62.5, ["Fly|Ride"] = 79.19, ["Neon"] = 56.13, ["Neon|Ride"] = 111.42, ["Neon|Fly|Ride"] = 225.76, ["Mega"] = 330.37, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 380.15}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.49, ["Ride"] = 28.74, ["Neon"] = 38.75, ["Neon|Ride"] = 59.89, ["Neon|Fly|Ride"] = 100, ["Mega"] = 263.65, ["Mega|Ride"] = 289.07, ["Mega|Fly|Ride"] = 428.55}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2, ["Neon"] = 2.5, ["Neon|Fly"] = 93.96, ["Neon|Ride"] = 124.99, ["Mega"] = 15.5, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.9, ["Ride"] = 123.73, ["Neon"] = 34.55, ["Neon|Ride"] = 198.22, ["Neon|Fly|Ride"] = 191.94, ["Mega"] = 225, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 702.01}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2, ["Fly"] = 122.86, ["Ride"] = 27.88, ["Neon"] = 27.5, ["Neon|Fly"] = 111.37, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 204.42, ["Mega"] = 201.87, ["Mega|Ride"] = 311.88, ["Mega|Fly|Ride"] = 1125}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.53, ["Ride"] = 31.23, ["Fly|Ride"] = 116.82, ["Neon"] = 15.12, ["Neon|Ride"] = 81.24, ["Neon|Fly|Ride"] = 250, ["Mega"] = 123.89, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 492.5}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 450, ["Fly"] = 675.17, ["Ride"] = 550, ["Fly|Ride"] = 624.99, ["Neon"] = 1996.58, ["Neon|Ride"] = 1687.5, ["Neon|Fly|Ride"] = 1517.85, ["Mega|Fly|Ride"] = 5625}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5, ["Fly"] = 43.3, ["Ride"] = 22.18, ["Fly|Ride"] = 57.62, ["Neon"] = 40.28, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 304.69, ["Mega"] = 138.35, ["Mega|Ride"] = 358.61, ["Mega|Fly|Ride"] = 342.75}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 10, ["Fly"] = 63.75, ["Ride"] = 19.94, ["Fly|Ride"] = 51.52, ["Neon"] = 89.82, ["Neon|Fly"] = 300, ["Neon|Ride"] = 92.5, ["Neon|Fly|Ride"] = 175, ["Mega"] = 316.06, ["Mega|Ride"] = 260.49, ["Mega|Fly|Ride"] = 649}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2, ["Fly"] = 23.74, ["Ride"] = 16.24, ["Fly|Ride"] = 48.18, ["Neon"] = 12.49, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2, ["Fly"] = 41.13, ["Ride"] = 31.25, ["Fly|Ride"] = 62.5, ["Neon"] = 11.14, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 117.5, ["Mega"] = 64.91, ["Mega|Ride"] = 99.99, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2, ["Ride"] = 18.75, ["Neon"] = 2.34, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 20.65, ["Mega|Fly"] = 193.06, ["Mega|Ride"] = 151.77, ["Mega|Fly|Ride"] = 220.93}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1250}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.04, ["Ride"] = 52.41, ["Fly|Ride"] = 174.06, ["Neon"] = 65.91, ["Neon|Ride"] = 107.49, ["Mega"] = 390.14, ["Mega|Ride"] = 358.24, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2, ["Ride"] = 18.34, ["Neon"] = 5.72, ["Neon|Ride"] = 26.86, ["Neon|Fly|Ride"] = 959.57, ["Mega"] = 36.14, ["Mega|Ride"] = 121.57, ["Mega|Fly|Ride"] = 174.38}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.65, ["Fly"] = 306.59, ["Ride"] = 68.92, ["Neon"] = 19, ["Neon|Ride"] = 162.4, ["Neon|Fly|Ride"] = 225, ["Mega"] = 248.92, ["Mega|Ride"] = 340.69, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 388.1, ["Ride"] = 424.99, ["Fly|Ride"] = 490, ["Neon"] = 1611.94, ["Neon|Ride"] = 1628.29, ["Neon|Fly|Ride"] = 1300, ["Mega"] = 7742.67, ["Mega|Fly|Ride"] = 5871.25}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.64, ["Fly"] = 187.5, ["Ride"] = 55.76, ["Fly|Ride"] = 123.89, ["Neon"] = 68.13, ["Neon|Ride"] = 73.75, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 291.97, ["Mega|Ride"] = 473.86, ["Mega|Fly|Ride"] = 493.48}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2, ["Fly"] = 91.12, ["Ride"] = 31.5, ["Fly|Ride"] = 112.48, ["Neon"] = 3.32, ["Neon|Fly"] = 49.99, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 82.52, ["Mega"] = 37.41, ["Mega|Fly"] = 138.28, ["Mega|Ride"] = 81.25, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2, ["Ride"] = 50, ["Neon"] = 3.53, ["Neon|Ride"] = 137.57, ["Neon|Fly|Ride"] = 137.99, ["Mega"] = 26.95, ["Mega|Ride"] = 62.41, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 31.2, ["Fly"] = 102.77, ["Ride"] = 77.28, ["Fly|Ride"] = 115, ["Neon"] = 135, ["Neon|Ride"] = 218.75, ["Neon|Fly|Ride"] = 344.82, ["Mega"] = 652.46, ["Mega|Ride"] = 675.17, ["Mega|Fly|Ride"] = 624.99}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.4, ["Ride"] = 78.27, ["Neon"] = 1377.18, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 825.89, ["Mega"] = 545.5, ["Mega|Ride"] = 462.5, ["Mega|Fly|Ride"] = 812.5}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.49, ["Ride"] = 72.49, ["Neon"] = 115, ["Neon|Ride"] = 165.19, ["Mega"] = 631.81, ["Mega|Fly|Ride"] = 779.11}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 16.25, ["Ride"] = 26.24, ["Fly|Ride"] = 207.46, ["Neon"] = 87.5, ["Neon|Ride"] = 155.86, ["Neon|Fly|Ride"] = 230, ["Mega"] = 612.5, ["Mega|Ride"] = 743.31, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 349.98, ["Ride"] = 406.97, ["Fly|Ride"] = 685.5, ["Neon"] = 1018.75, ["Neon|Ride"] = 1000, ["Neon|Fly|Ride"] = 1000, ["Mega|Fly|Ride"] = 3187.49}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 11, ["Fly"] = 39.89, ["Ride"] = 32.5, ["Fly|Ride"] = 110.39, ["Neon"] = 141.25, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 137.08, ["Mega|Fly"] = 562.5, ["Mega|Ride"] = 534.38, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.23, ["Ride"] = 26.4, ["Fly|Ride"] = 121.25, ["Neon"] = 50, ["Neon|Ride"] = 211.25, ["Mega"] = 162.5, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 599.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 31.15, ["Fly"] = 330.37, ["Ride"] = 107.38, ["Fly|Ride"] = 103.24, ["Neon"] = 143.75, ["Neon|Ride"] = 187.39, ["Neon|Fly|Ride"] = 467.17, ["Mega"] = 375, ["Mega|Ride"] = 411.61, ["Mega|Fly|Ride"] = 487.49}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.5, ["Fly"] = 37.5, ["Ride"] = 41.3, ["Fly|Ride"] = 206.48, ["Neon"] = 7.46, ["Neon|Ride"] = 66.25, ["Neon|Fly|Ride"] = 267.39, ["Mega"] = 62.5, ["Mega|Ride"] = 165.19, ["Mega|Fly|Ride"] = 267.67}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 54.82, ["Ride"] = 50, ["Neon"] = 250, ["Neon|Ride"] = 325, ["Neon|Fly|Ride"] = 375, ["Mega"] = 1576.9, ["Mega|Ride"] = 1401.68, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2, ["Fly"] = 53.75, ["Ride"] = 24.98, ["Neon"] = 11.54, ["Neon|Fly"] = 179.63, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 59.91, ["Mega|Ride"] = 86.49, ["Mega|Fly|Ride"] = 191.25}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2, ["Fly"] = 27.87, ["Ride"] = 27.5, ["Fly|Ride"] = 92.84, ["Neon"] = 3.63, ["Neon|Fly"] = 60.52, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 131.12, ["Mega"] = 31.24, ["Mega|Fly"] = 107.5, ["Mega|Ride"] = 78.6, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2, ["Ride"] = 36.25, ["Fly|Ride"] = 124.82, ["Neon"] = 11.14, ["Neon|Ride"] = 51.38, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 60, ["Mega|Ride"] = 135, ["Mega|Fly|Ride"] = 137.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.71, ["Fly"] = 62.49, ["Ride"] = 58.64, ["Fly|Ride"] = 235.39, ["Neon"] = 234.25, ["Neon|Ride"] = 416.25, ["Neon|Fly|Ride"] = 467.24, ["Mega|Ride"] = 1101.53, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2064.71}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.96, ["Neon"] = 20.66, ["Neon|Fly"] = 333.75, ["Mega"] = 124.9, ["Mega|Ride"] = 238.48, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2, ["Ride"] = 18.68, ["Fly|Ride"] = 75, ["Neon"] = 6.2, ["Neon|Ride"] = 68.75, ["Mega"] = 45, ["Mega|Fly"] = 200, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 229.9}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.03, ["Fly"] = 103.24, ["Ride"] = 31.25, ["Fly|Ride"] = 93.75, ["Neon"] = 31.25, ["Mega"] = 295.32, ["Mega|Ride"] = 334.81, ["Mega|Fly|Ride"] = 380}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 6.2, ["Ride"] = 41.91, ["Fly|Ride"] = 125, ["Neon"] = 30.63, ["Neon|Ride"] = 78.14, ["Neon|Fly|Ride"] = 136.25, ["Mega"] = 170, ["Mega|Ride"] = 186.34, ["Mega|Fly|Ride"] = 335.67}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2, ["Ride"] = 68.19, ["Neon"] = 6.13, ["Neon|Ride"] = 89.82, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 72.5, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 828.99}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2, ["Fly"] = 50, ["Ride"] = 18.75, ["Fly|Ride"] = 56.89, ["Neon"] = 4.38, ["Neon|Ride"] = 24.79, ["Neon|Fly|Ride"] = 95.04, ["Mega"] = 38, ["Mega|Ride"] = 94.93, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2, ["Fly"] = 26.19, ["Ride"] = 19.13, ["Fly|Ride"] = 55, ["Neon"] = 17.01, ["Neon|Fly"] = 98.09, ["Neon|Ride"] = 38.74, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 148.72, ["Mega|Ride"] = 135, ["Mega|Fly|Ride"] = 231.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 33.75, ["Fly"] = 69.18, ["Ride"] = 23.75, ["Fly|Ride"] = 75, ["Neon"] = 137.47, ["Neon|Ride"] = 93.45, ["Mega"] = 437.5, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 623.75}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 59.91, ["Ride"] = 82.6, ["Fly|Ride"] = 132.5, ["Neon"] = 350, ["Neon|Fly"] = 410.13, ["Neon|Ride"] = 350, ["Neon|Fly|Ride"] = 443.75, ["Mega"] = 2051.29, ["Mega|Ride"] = 1548.54, ["Mega|Fly|Ride"] = 1379.92}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2, ["Ride"] = 18.57, ["Fly|Ride"] = 137.5, ["Neon"] = 3.74, ["Neon|Fly"] = 75, ["Neon|Ride"] = 32.73, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 30.9, ["Mega|Fly"] = 640, ["Mega|Ride"] = 88.01, ["Mega|Fly|Ride"] = 217.5}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2, ["Fly"] = 16.48, ["Ride"] = 14.89, ["Fly|Ride"] = 41.22, ["Neon"] = 4.78, ["Neon|Fly"] = 35.1, ["Neon|Ride"] = 20, ["Neon|Fly|Ride"] = 58.75, ["Mega"] = 38.86, ["Mega|Fly"] = 124.95, ["Mega|Ride"] = 47.49, ["Mega|Fly|Ride"] = 75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2, ["Fly"] = 41.3, ["Ride"] = 36.2, ["Fly|Ride"] = 62.49, ["Neon"] = 25, ["Neon|Ride"] = 156.53, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 523.42, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 326.25}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 450, ["Ride"] = 472.84, ["Fly|Ride"] = 425, ["Neon"] = 4129.42, ["Neon|Fly|Ride"] = 1687.5, ["Mega|Fly|Ride"] = 5625}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 19.58, ["Fly"] = 94.99, ["Ride"] = 49.99, ["Fly|Ride"] = 109.81, ["Neon"] = 207.37, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 162.4}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2, ["Ride"] = 20.57, ["Fly|Ride"] = 274.1, ["Neon"] = 8.75, ["Neon|Ride"] = 46.91, ["Neon|Fly|Ride"] = 125, ["Mega"] = 78.27, ["Mega|Ride"] = 120, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2, ["Fly"] = 80.66, ["Ride"] = 52.05, ["Fly|Ride"] = 249.49, ["Neon"] = 68.9, ["Mega"] = 125, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.91, ["Fly"] = 161.24, ["Ride"] = 31.59, ["Fly|Ride"] = 97.05, ["Neon"] = 185, ["Neon|Ride"] = 209, ["Neon|Fly|Ride"] = 272.55, ["Mega"] = 2477.66, ["Mega|Ride"] = 2000, ["Mega|Fly|Ride"] = 955}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 102.8, ["Fly"] = 179.63, ["Ride"] = 122.49, ["Fly|Ride"] = 167.12, ["Neon"] = 409.61, ["Neon|Fly"] = 784.6, ["Neon|Ride"] = 551.29, ["Neon|Fly|Ride"] = 581.25, ["Mega"] = 3028.93, ["Mega|Fly|Ride"] = 2580.89}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 230.4, ["Ride"] = 250, ["Fly|Ride"] = 515.16, ["Neon"] = 893.75, ["Neon|Ride"] = 762.5, ["Neon|Fly|Ride"] = 986.25, ["Mega|Fly|Ride"] = 2731.25}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.54, ["Ride"] = 52.49, ["Fly|Ride"] = 140.18, ["Neon"] = 93.75, ["Neon|Ride"] = 83.74, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 822.38, ["Mega|Ride"] = 383.75, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2, ["Fly"] = 27.58, ["Ride"] = 15.62, ["Fly|Ride"] = 36.25, ["Neon"] = 7.49, ["Neon|Ride"] = 22.28, ["Neon|Fly|Ride"] = 80, ["Mega"] = 77.03, ["Mega|Ride"] = 99.99, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.25, ["Fly"] = 38.75, ["Ride"] = 19.57, ["Fly|Ride"] = 60, ["Neon"] = 36.08, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 41.29, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 262.23, ["Mega|Ride"] = 253.75, ["Mega|Fly|Ride"] = 296.29}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 302.5, ["Ride"] = 333.75, ["Fly|Ride"] = 728.85, ["Neon"] = 1488.13, ["Neon|Ride"] = 1961.48, ["Neon|Fly|Ride"] = 1693.07, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4955.31}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2, ["Ride"] = 31.87, ["Neon"] = 8.56, ["Neon|Ride"] = 132.77, ["Neon|Fly|Ride"] = 112500, ["Mega"] = 32.41, ["Mega|Ride"] = 87.5}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.74, ["Ride"] = 15, ["Fly|Ride"] = 40.65, ["Neon"] = 21.25, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 93.36, ["Mega"] = 198.22, ["Mega|Ride"] = 139.99, ["Mega|Fly|Ride"] = 217.5}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.82, ["Ride"] = 56.25, ["Neon"] = 93.75, ["Neon|Fly"] = 175, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 288.14, ["Mega"] = 525, ["Mega|Ride"] = 618.75, ["Mega|Fly|Ride"] = 688.59}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.56, ["Fly"] = 150, ["Ride"] = 118.75, ["Fly|Ride"] = 148.75, ["Neon|Ride"] = 779.11, ["Neon|Fly|Ride"] = 625, ["Mega|Fly|Ride"] = 3097.07}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.52, ["Fly"] = 36.54, ["Ride"] = 27.12, ["Fly|Ride"] = 55.9, ["Neon"] = 100, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 109.24, ["Mega"] = 833.75, ["Mega|Ride"] = 402.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2, ["Ride"] = 59.46, ["Neon"] = 3.71, ["Neon|Ride"] = 77.43, ["Mega"] = 30.77, ["Mega|Ride"] = 116.66, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2, ["Ride"] = 16.24, ["Fly|Ride"] = 82.44, ["Neon"] = 2.88, ["Neon|Fly"] = 36.25, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 83.63, ["Mega"] = 24.74, ["Mega|Fly"] = 97.05, ["Mega|Ride"] = 42.62, ["Mega|Fly|Ride"] = 124.9}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 15.47, ["Ride"] = 74.97, ["Fly|Ride"] = 296.29, ["Neon"] = 36.64, ["Neon|Ride"] = 100.8, ["Neon|Fly|Ride"] = 305.58, ["Mega"] = 175.8, ["Mega|Ride"] = 200, ["Mega|Fly|Ride"] = 300}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1100, ["Fly"] = 1457.76, ["Ride"] = 1250, ["Fly|Ride"] = 1062.5, ["Neon"] = 4238.86, ["Neon|Ride"] = 4062.32, ["Neon|Fly|Ride"] = 3825.94, ["Mega|Fly|Ride"] = 11750}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 387.5, ["Ride"] = 487.47, ["Fly|Ride"] = 547.5, ["Neon"] = 1600, ["Neon|Ride"] = 1948.33, ["Neon|Fly|Ride"] = 1670, ["Mega"] = 16517.67}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 311.25, ["Fly"] = 394.81, ["Ride"] = 336.69, ["Fly|Ride"] = 407.5, ["Neon"] = 750, ["Neon|Fly"] = 1090.98, ["Neon|Ride"] = 675, ["Neon|Fly|Ride"] = 824.87, ["Mega|Fly|Ride"] = 2777.37}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 225.45, ["Ride"] = 256.05, ["Fly|Ride"] = 331.25, ["Neon"] = 616.25, ["Neon|Ride"] = 649.99, ["Neon|Fly|Ride"] = 612.5, ["Mega|Fly|Ride"] = 3144.56}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2, ["Fly"] = 20.66, ["Ride"] = 20, ["Fly|Ride"] = 37.5, ["Neon"] = 4.95, ["Neon|Ride"] = 33.09, ["Neon|Fly|Ride"] = 100, ["Mega"] = 52.5, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 260.89, ["Fly"] = 443.87, ["Ride"] = 296.29, ["Fly|Ride"] = 750, ["Neon"] = 1000, ["Neon|Ride"] = 1300, ["Neon|Fly|Ride"] = 1500, ["Mega"] = 20922.73, ["Mega|Ride"] = 5230.95, ["Mega|Fly|Ride"] = 4375}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 7.87, ["Fly"] = 125, ["Ride"] = 49.99, ["Neon"] = 36.16, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 167.5, ["Mega|Ride"] = 330.3, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2, ["Fly"] = 18.74, ["Ride"] = 15.68, ["Fly|Ride"] = 37.5, ["Neon"] = 8.27, ["Neon|Ride"] = 52.66, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 112.31, ["Mega|Ride"] = 183.15, ["Mega|Fly|Ride"] = 105.14}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2, ["Fly"] = 55, ["Neon"] = 3.57, ["Mega"] = 31.25, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 169.16}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 29.87, ["Ride"] = 87.5, ["Fly|Ride"] = 437.5, ["Neon"] = 190, ["Neon|Ride"] = 342.6, ["Mega"] = 1000, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 736.25}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2, ["Fly"] = 7787.48, ["Ride"] = 18.75, ["Fly|Ride"] = 65, ["Neon"] = 22.49, ["Neon|Ride"] = 59.4, ["Mega"] = 342.75, ["Mega|Ride"] = 220.93, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2, ["Ride"] = 52.5, ["Neon"] = 2, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 135.17, ["Mega"] = 18.74, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 75}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 6.47, ["Fly"] = 81.9, ["Ride"] = 38.9, ["Fly|Ride"] = 81.25, ["Neon"] = 26.25, ["Neon|Fly"] = 110.47, ["Neon|Ride"] = 51.8, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 150, ["Mega|Ride"] = 175, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.5, ["Fly"] = 30.88, ["Ride"] = 21.24, ["Fly|Ride"] = 43.75, ["Neon"] = 27.49, ["Neon|Fly"] = 140.18, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 125, ["Mega"] = 227.45, ["Mega|Ride"] = 239.11, ["Mega|Fly|Ride"] = 1258.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 27.48, ["Ride"] = 36.24, ["Fly|Ride"] = 140.18, ["Neon"] = 26.25, ["Neon|Ride"] = 165.19, ["Neon|Fly|Ride"] = 311.88, ["Mega"] = 506.95, ["Mega|Ride"] = 773.24}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.49, ["Fly"] = 6230.45, ["Ride"] = 16.25, ["Fly|Ride"] = 124.99, ["Neon"] = 56.25, ["Neon|Ride"] = 205.14, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 348.75, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 64.91, ["Ride"] = 15.57, ["Fly|Ride"] = 43.75, ["Neon"] = 4.89, ["Neon|Fly"] = 77.76, ["Neon|Ride"] = 26.83, ["Mega"] = 34.62, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 145.57, ["Fly"] = 251.9, ["Ride"] = 162.5, ["Fly|Ride"] = 250, ["Neon"] = 825.89, ["Neon|Ride"] = 977.65, ["Neon|Fly|Ride"] = 887.84, ["Mega"] = 8258.84, ["Mega|Fly|Ride"] = 4205.04}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2, ["Fly"] = 21.87, ["Ride"] = 16.44, ["Fly|Ride"] = 35.11, ["Neon"] = 3.54, ["Neon|Fly"] = 35.06, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 54.26, ["Mega"] = 47.9, ["Mega|Ride"] = 72.5, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.99, ["Ride"] = 69.18, ["Fly|Ride"] = 219.9, ["Neon"] = 61.89, ["Neon|Ride"] = 127.15, ["Neon|Fly|Ride"] = 747.57, ["Mega"] = 318.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 367.53}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 27.88, ["Ride"] = 90.99, ["Fly|Ride"] = 175, ["Neon"] = 180, ["Neon|Ride"] = 288.03, ["Neon|Fly|Ride"] = 394.5, ["Mega"] = 748.75, ["Mega|Ride"] = 874.99, ["Mega|Fly|Ride"] = 899.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 163.99, ["Fly"] = 212.5, ["Ride"] = 233.75, ["Fly|Ride"] = 287.49, ["Neon"] = 773.71, ["Neon|Ride"] = 668.75, ["Neon|Fly|Ride"] = 811.25, ["Mega|Fly|Ride"] = 3579.18}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 3.75, ["Fly"] = 125, ["Ride"] = 142.91, ["Fly|Ride"] = 140.18, ["Neon"] = 144.54, ["Neon|Ride"] = 168.23, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 252.41, ["Mega|Ride"] = 387.5, ["Mega|Fly|Ride"] = 386.11}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.35, ["Ride"] = 41.3, ["Fly|Ride"] = 69.18, ["Neon"] = 138.13, ["Neon|Fly"] = 156.53, ["Neon|Ride"] = 311.88, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 1651.77, ["Mega|Ride"] = 1377.18, ["Mega|Fly|Ride"] = 685.5}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 856.25, ["Fly"] = 1168.07, ["Ride"] = 968.54, ["Fly|Ride"] = 980, ["Neon|Ride"] = 5625, ["Neon|Fly|Ride"] = 4872.72, ["Mega|Fly|Ride"] = 16504.25}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.1, ["Fly"] = 24.99, ["Ride"] = 18.34, ["Fly|Ride"] = 43.74, ["Neon"] = 45, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 46.79, ["Neon|Fly|Ride"] = 125, ["Mega"] = 220.93, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.82, ["Fly"] = 75, ["Ride"] = 47.5, ["Fly|Ride"] = 128.75, ["Neon"] = 25, ["Neon|Ride"] = 80.54, ["Neon|Fly|Ride"] = 125, ["Mega"] = 138.35, ["Mega|Fly"] = 1200, ["Mega|Ride"] = 316.25, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2, ["Fly"] = 82.6, ["Ride"] = 24.92, ["Fly|Ride"] = 100, ["Neon"] = 8.88, ["Neon|Ride"] = 45.57, ["Neon|Fly|Ride"] = 162.5, ["Mega"] = 77.36, ["Mega|Ride"] = 343.18, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.59, ["Ride"] = 32.24, ["Fly|Ride"] = 108.76, ["Neon"] = 64.75, ["Neon|Fly"] = 179.39, ["Neon|Ride"] = 93.72, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 424.98, ["Mega|Ride"] = 401.25, ["Mega|Fly|Ride"] = 413.81}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.64, ["Fly"] = 22.9, ["Ride"] = 18.59, ["Fly|Ride"] = 56.25, ["Neon"] = 13.79, ["Neon|Fly"] = 39.06, ["Neon|Ride"] = 28.75, ["Neon|Fly|Ride"] = 73.75, ["Mega"] = 138.75, ["Mega|Fly"] = 267.6, ["Mega|Ride"] = 161.25, ["Mega|Fly|Ride"] = 166.94}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2, ["Ride"] = 19.73, ["Neon"] = 8.75, ["Neon|Fly"] = 12500, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 118.75, ["Mega|Ride"] = 179.63, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 247.5, ["Ride"] = 316.94, ["Fly|Ride"] = 412.5, ["Neon"] = 895.06, ["Neon|Fly|Ride"] = 1126.67, ["Mega|Fly|Ride"] = 3749.52}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.5, ["Fly"] = 31.24, ["Ride"] = 24.91, ["Fly|Ride"] = 138.35, ["Neon"] = 7.37, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 125, ["Mega"] = 62.19, ["Mega|Ride"] = 97.05, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.74, ["Ride"] = 80.54, ["Fly|Ride"] = 84.62, ["Neon"] = 26.86, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 179.3, ["Mega"] = 186.25, ["Mega|Ride"] = 330.37}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.22, ["Fly"] = 90.24, ["Ride"] = 30.62, ["Neon"] = 8.27, ["Neon|Ride"] = 66.08, ["Mega"] = 88.75, ["Mega|Ride"] = 114.81, ["Mega|Fly|Ride"] = 480.19}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.18, ["Ride"] = 124.9, ["Fly|Ride"] = 237.5, ["Neon"] = 250, ["Neon|Ride"] = 412.95, ["Neon|Fly|Ride"] = 358.24, ["Mega"] = 2477.66, ["Mega|Ride"] = 4129.42, ["Mega|Fly|Ride"] = 1465.96}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.24, ["Fly"] = 83.88, ["Ride"] = 60.75, ["Fly|Ride"] = 257.04, ["Neon"] = 135, ["Neon|Ride"] = 262.17, ["Neon|Fly|Ride"] = 325.64, ["Mega"] = 625, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.39, ["Fly"] = 55.76, ["Ride"] = 37.17, ["Fly|Ride"] = 110.39, ["Neon"] = 81.25, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 250, ["Mega"] = 580, ["Mega|Ride"] = 415, ["Mega|Fly|Ride"] = 549.52}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.47, ["Ride"] = 68.17, ["Neon"] = 14.79, ["Neon|Fly"] = 250, ["Neon|Ride"] = 219.8, ["Mega"] = 125, ["Mega|Ride"] = 165.19, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 43.21, ["Fly"] = 37.5, ["Ride"] = 71.68, ["Fly|Ride"] = 137.5, ["Neon"] = 238.48, ["Neon|Fly"] = 250, ["Neon|Ride"] = 218.64, ["Neon|Fly|Ride"] = 249.98, ["Mega|Fly|Ride"] = 963.53}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2, ["Ride"] = 20, ["Fly|Ride"] = 75, ["Neon"] = 5.18, ["Neon|Fly|Ride"] = 122.86, ["Mega"] = 65, ["Mega|Ride"] = 274.61, ["Mega|Fly|Ride"] = 298.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 14.75, ["Fly"] = 37.5, ["Ride"] = 31.25, ["Fly|Ride"] = 88.78, ["Neon"] = 61.47, ["Neon|Fly"] = 80, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 193.75, ["Mega"] = 343.52, ["Mega|Fly"] = 925, ["Mega|Ride"] = 412.95, ["Mega|Fly|Ride"] = 408.82}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.78, ["Fly"] = 193.72, ["Ride"] = 77, ["Fly|Ride"] = 125, ["Neon"] = 250, ["Neon|Fly"] = 412.95, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 342.49, ["Mega|Ride"] = 1412.27, ["Mega|Fly|Ride"] = 1195}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2, ["Fly"] = 15.5, ["Ride"] = 15.47, ["Fly|Ride"] = 39.27, ["Neon"] = 2, ["Neon|Fly"] = 26.86, ["Neon|Ride"] = 15.5, ["Neon|Fly|Ride"] = 42.9, ["Mega"] = 19.43, ["Mega|Ride"] = 38.86, ["Mega|Fly|Ride"] = 79.53}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.39, ["Fly"] = 100, ["Ride"] = 22.5, ["Fly|Ride"] = 61.24, ["Neon"] = 18.01, ["Neon|Ride"] = 62.48, ["Neon|Fly|Ride"] = 150, ["Mega"] = 450, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 16.25, ["Fly"] = 41.3, ["Ride"] = 39.59, ["Fly|Ride"] = 111.66, ["Neon"] = 105.58, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 258.45, ["Mega"] = 619.42, ["Mega|Ride"] = 433.11, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2, ["Ride"] = 20.35, ["Neon"] = 2, ["Neon|Fly"] = 31.24, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 86.25, ["Mega"] = 19.76, ["Mega|Ride"] = 48.53, ["Mega|Fly|Ride"] = 206.48}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 28.14, ["Fly"] = 200, ["Ride"] = 62.49, ["Fly|Ride"] = 205.19, ["Neon"] = 144.65, ["Neon|Ride"] = 245.71, ["Neon|Fly|Ride"] = 375, ["Mega"] = 617.67, ["Mega|Fly"] = 750, ["Mega|Ride"] = 613.23, ["Mega|Fly|Ride"] = 688.59}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12.9, ["Fly"] = 41.3, ["Ride"] = 25.2, ["Fly|Ride"] = 90.85, ["Neon"] = 358.75, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 158.99, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 495.54}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.63, ["Ride"] = 53.2, ["Neon"] = 62.5, ["Neon|Fly"] = 666.25, ["Neon|Ride"] = 77.5, ["Neon|Fly|Ride"] = 688.59, ["Mega"] = 222.48, ["Mega|Ride"] = 311.47, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.13, ["Fly"] = 68.75, ["Ride"] = 64.91, ["Fly|Ride"] = 230.65, ["Neon"] = 37.5, ["Neon|Ride"] = 84.67, ["Neon|Fly|Ride"] = 181.24, ["Mega"] = 235.34, ["Mega|Ride"] = 421.25, ["Mega|Fly|Ride"] = 425}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2, ["Ride"] = 34.91, ["Fly|Ride"] = 187.5, ["Neon"] = 9.19, ["Neon|Ride"] = 35.64, ["Mega"] = 66.25, ["Mega|Fly"] = 206.48, ["Mega|Ride"] = 86.45, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2, ["Ride"] = 56.08, ["Neon"] = 2.98, ["Neon|Ride"] = 33.74, ["Mega"] = 47.5, ["Mega|Ride"] = 109.99, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 23.7}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 47.01, ["Fly"] = 96.25, ["Ride"] = 50, ["Fly|Ride"] = 87.49, ["Neon"] = 175.79, ["Neon|Ride"] = 206.48, ["Neon|Fly|Ride"] = 297.5, ["Mega"] = 1766.05, ["Mega|Ride"] = 750, ["Mega|Fly|Ride"] = 812.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2, ["Fly|Ride"] = 103.24, ["Neon"] = 2.29, ["Neon|Ride"] = 36.14, ["Mega"] = 20.06, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 309.71}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 500, ["Ride"] = 500, ["Fly|Ride"] = 642.44, ["Neon"] = 2753.3, ["Neon|Ride"] = 2580.89, ["Neon|Fly|Ride"] = 2406.43, ["Mega"] = 16517.67, ["Mega|Fly|Ride"] = 8125}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.08, ["Fly"] = 46.53, ["Ride"] = 32.12, ["Fly|Ride"] = 62.98, ["Neon"] = 44.28, ["Neon|Fly"] = 175, ["Neon|Ride"] = 110.38, ["Mega"] = 311.88, ["Mega|Ride"] = 186.25, ["Mega|Fly|Ride"] = 606}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.35, ["Fly"] = 25, ["Ride"] = 22.47, ["Fly|Ride"] = 56.08, ["Neon"] = 24.99, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 134.22, ["Mega|Fly"] = 275.65, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 215}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.59, ["Ride"] = 36.25, ["Fly|Ride"] = 516.18, ["Neon"] = 107.49, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 298.75, ["Mega"] = 468.7, ["Mega|Ride"] = 370, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.38, ["Fly"] = 55.76, ["Ride"] = 36.72, ["Fly|Ride"] = 69.18, ["Neon"] = 37.38, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 373.75, ["Mega"] = 268.75, ["Mega|Ride"] = 274.61, ["Mega|Fly|Ride"] = 481.08}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 28.75, ["Ride"] = 68.65, ["Fly|Ride"] = 187.5, ["Neon"] = 78.41, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 511.03, ["Mega|Ride"] = 396, ["Mega|Fly|Ride"] = 467.94}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.69, ["Ride"] = 25, ["Fly|Ride"] = 87.5, ["Neon"] = 27.5, ["Neon|Ride"] = 78.19, ["Neon|Fly|Ride"] = 266.36, ["Mega"] = 216.15, ["Mega|Ride"] = 264.42, ["Mega|Fly|Ride"] = 332.5}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2, ["Fly"] = 45.3, ["Ride"] = 12.5, ["Fly|Ride"] = 55.76, ["Neon"] = 2, ["Neon|Fly"] = 39.99, ["Neon|Ride"] = 17.32, ["Neon|Fly|Ride"] = 43.75, ["Mega"] = 15.62, ["Mega|Fly"] = 63.08, ["Mega|Ride"] = 46.73, ["Mega|Fly|Ride"] = 93.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.64, ["Fly"] = 47.5, ["Ride"] = 53.74, ["Fly|Ride"] = 103.24, ["Neon"] = 42.55, ["Neon|Fly"] = 116.82, ["Neon|Ride"] = 74.99, ["Neon|Fly|Ride"] = 125, ["Mega"] = 202.06, ["Mega|Ride"] = 262.23, ["Mega|Fly|Ride"] = 395.63}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 246.15, ["Ride"] = 275, ["Fly|Ride"] = 371.25, ["Neon"] = 1101.53, ["Neon|Ride"] = 993.75, ["Neon|Fly|Ride"] = 1000, ["Mega|Ride"] = 9064.17, ["Mega|Fly|Ride"] = 3871.79}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 96.97, ["Ride"] = 133.75, ["Fly|Ride"] = 245.71, ["Neon"] = 436.25, ["Neon|Ride"] = 400, ["Neon|Fly|Ride"] = 500, ["Mega"] = 2203.05, ["Mega|Ride"] = 1750, ["Mega|Fly|Ride"] = 1740}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2, ["Fly"] = 15.26, ["Ride"] = 14.38, ["Fly|Ride"] = 34.99, ["Neon"] = 6.98, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 77.1, ["Mega"] = 138.35, ["Mega|Fly"] = 205.45, ["Mega|Ride"] = 97.05, ["Mega|Fly|Ride"] = 248.13}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2, ["Fly"] = 22.57, ["Ride"] = 13.74, ["Fly|Ride"] = 33.75, ["Neon"] = 8.38, ["Neon|Fly"] = 25.76, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 61.03, ["Mega"] = 48.75, ["Mega|Fly"] = 275.65, ["Mega|Ride"] = 85.38, ["Mega|Fly|Ride"] = 137.45}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.87, ["Fly"] = 97.05, ["Ride"] = 21.25, ["Fly|Ride"] = 93.75, ["Neon"] = 100, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 150, ["Mega|Ride"] = 316.23, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 199.97, ["Fly"] = 311.88, ["Ride"] = 234.35, ["Fly|Ride"] = 300, ["Neon|Ride"] = 1000, ["Neon|Fly|Ride"] = 1445.3, ["Mega|Ride"] = 8258.84, ["Mega|Fly|Ride"] = 3750}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2, ["Fly"] = 30.14, ["Ride"] = 12.5, ["Fly|Ride"] = 41.03, ["Neon"] = 14.43, ["Neon|Fly"] = 99.97, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 75, ["Mega"] = 250, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.75, ["Ride"] = 72.03, ["Fly|Ride"] = 205.72, ["Neon"] = 31.25, ["Neon|Ride"] = 105.31, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 252.31, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2, ["Ride"] = 125, ["Neon"] = 11.14, ["Neon|Ride"] = 131.25, ["Mega"] = 98.75}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.14, ["Fly"] = 47.76, ["Ride"] = 25.9, ["Fly|Ride"] = 55.09, ["Neon"] = 62.5, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 162.5, ["Mega"] = 312.5, ["Mega|Ride"] = 477.5, ["Mega|Fly|Ride"] = 623.75}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 35, ["Ride"] = 96, ["Fly|Ride"] = 278.89, ["Neon"] = 97.22, ["Neon|Fly"] = 624.71, ["Neon|Ride"] = 169.93, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 530.32, ["Mega|Fly"] = 2167.95, ["Mega|Ride"] = 463.17, ["Mega|Fly|Ride"] = 636.44}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21.97, ["Fly"] = 25, ["Ride"] = 45.42, ["Fly|Ride"] = 87.5, ["Neon"] = 148.35, ["Neon|Fly"] = 272.79, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 212.49, ["Mega"] = 825.89, ["Mega|Ride"] = 667.5, ["Mega|Fly|Ride"] = 800}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2, ["Fly"] = 14.95, ["Ride"] = 13.09, ["Fly|Ride"] = 30, ["Neon"] = 2, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 42.5, ["Mega"] = 18.89, ["Mega|Fly"] = 41.15, ["Mega|Ride"] = 26.15, ["Mega|Fly|Ride"] = 85}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 203.51, ["Ride"] = 225, ["Fly|Ride"] = 281.16, ["Neon"] = 3270.58, ["Neon|Ride"] = 812.47, ["Neon|Fly|Ride"] = 1238.83, ["Mega|Fly|Ride"] = 4125.3}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.67, ["Fly"] = 96.36, ["Ride"] = 27.5, ["Fly|Ride"] = 88.51, ["Neon"] = 75, ["Neon|Ride"] = 63.08, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 362.5, ["Mega|Ride"] = 551.29, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2, ["Fly"] = 34.61, ["Ride"] = 17.87, ["Fly|Ride"] = 48.29, ["Neon"] = 4.82, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 95, ["Mega"] = 59.59, ["Mega|Fly"] = 220.93, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 162.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2, ["Fly"] = 30.99, ["Ride"] = 17.52, ["Fly|Ride"] = 76.4, ["Neon"] = 2, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 105.14, ["Mega"] = 25.9, ["Mega|Fly"] = 137.5, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 155.9}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2, ["Ride"] = 18.74, ["Fly|Ride"] = 42.5, ["Neon"] = 11.68, ["Neon|Fly"] = 700.85, ["Neon|Ride"] = 50.78, ["Mega"] = 148.13, ["Mega|Ride"] = 133.41, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.47, ["Fly"] = 44.98, ["Ride"] = 24.89, ["Fly|Ride"] = 77.43, ["Neon"] = 45, ["Neon|Fly"] = 234.35, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 234.35, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 356.25}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 50.42, ["Ride"] = 97.05, ["Neon"] = 106.25, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 241.59, ["Mega|Ride"] = 311.25, ["Mega|Fly|Ride"] = 386.11}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2, ["Ride"] = 55, ["Neon"] = 2.19, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 103.18, ["Mega"] = 18.75, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 151.18}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.74, ["Fly"] = 79.99, ["Ride"] = 32.26, ["Fly|Ride"] = 98.09, ["Neon"] = 36.29, ["Neon|Fly"] = 97.9, ["Neon|Ride"] = 46.73, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 152.5, ["Mega|Ride"] = 304.38, ["Mega|Fly|Ride"] = 350}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2, ["Ride"] = 29.99, ["Neon"] = 3.43, ["Neon|Fly"] = 110.47, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 100, ["Mega"] = 24.93, ["Mega|Ride"] = 116.66, ["Mega|Fly|Ride"] = 247.77}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2, ["Fly"] = 49.74, ["Ride"] = 18.74, ["Fly|Ride"] = 39.73, ["Neon"] = 5, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 124.78, ["Mega"] = 43.73, ["Mega|Ride"] = 124.89, ["Mega|Fly|Ride"] = 197.2}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 600, ["Ride"] = 593.74, ["Fly|Ride"] = 735, ["Neon"] = 2500, ["Neon|Ride"] = 3270.58, ["Mega|Fly|Ride"] = 9162.5}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2, ["Fly"] = 15.69, ["Ride"] = 15.99, ["Fly|Ride"] = 37.5, ["Neon"] = 17.5, ["Neon|Fly"] = 41.08, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 81.24}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.13, ["Ride"] = 54.9, ["Neon"] = 10, ["Neon|Fly"] = 722.65, ["Neon|Ride"] = 54.4, ["Neon|Fly|Ride"] = 150, ["Mega"] = 85, ["Mega|Fly"] = 206.48, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 260}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 11.14, ["Fly"] = 22.49, ["Ride"] = 20.81, ["Fly|Ride"] = 48.75, ["Neon"] = 46.25, ["Neon|Fly"] = 185.58, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 99.99, ["Mega"] = 462.5, ["Mega|Ride"] = 293.74, ["Mega|Fly|Ride"] = 358.73}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2, ["Fly"] = 15.4, ["Ride"] = 13.75, ["Fly|Ride"] = 55.76, ["Neon"] = 8.34, ["Neon|Fly"] = 49.98, ["Neon|Ride"] = 21.01, ["Neon|Fly|Ride"] = 43.75, ["Mega"] = 59.89, ["Mega|Ride"] = 90, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35, ["Ride"] = 56.25, ["Fly|Ride"] = 308.69, ["Neon"] = 225, ["Neon|Ride"] = 274.61, ["Mega"] = 716.47, ["Mega|Ride"] = 757.76, ["Mega|Fly|Ride"] = 729.89}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 23.72, ["Fly|Ride"] = 80, ["Neon"] = 6.2, ["Neon|Fly"] = 133.17, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 113.75, ["Mega"] = 45, ["Mega|Ride"] = 101.25, ["Mega|Fly|Ride"] = 266.25}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 18.75, ["Fly|Ride"] = 75.14, ["Neon"] = 12.48, ["Neon|Ride"] = 55.76, ["Mega"] = 108.47, ["Mega|Ride"] = 189.13, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2, ["Ride"] = 41.3, ["Fly|Ride"] = 62.69, ["Neon"] = 11.14, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 92.49, ["Mega|Ride"] = 87.97, ["Mega|Fly|Ride"] = 562.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2, ["Fly"] = 41.3, ["Ride"] = 15, ["Fly|Ride"] = 65.91, ["Neon"] = 4.37, ["Neon|Fly"] = 68.8, ["Neon|Ride"] = 22.15, ["Neon|Fly|Ride"] = 103, ["Mega"] = 48.75, ["Mega|Fly"] = 218.75, ["Mega|Ride"] = 138.35}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.81, ["Fly"] = 21.1, ["Ride"] = 18.92, ["Fly|Ride"] = 37.79, ["Neon"] = 112.5, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 134.22, ["Mega|Ride"] = 412.95, ["Mega|Fly|Ride"] = 434.43}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 689.99, ["Fly"] = 1032.36, ["Ride"] = 735, ["Fly|Ride"] = 743.75, ["Neon"] = 1789.84, ["Neon|Ride"] = 1700, ["Neon|Fly|Ride"] = 1932.49, ["Mega"] = 8258.84, ["Mega|Ride"] = 5430.19, ["Mega|Fly|Ride"] = 4293.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2, ["Fly"] = 21.25, ["Ride"] = 16.53, ["Fly|Ride"] = 39.73, ["Neon"] = 3.63, ["Neon|Ride"] = 17.5, ["Neon|Fly|Ride"] = 67.5, ["Mega"] = 41.29, ["Mega|Ride"] = 86.45, ["Mega|Fly|Ride"] = 195.08}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 2.9, ["Fly"] = 25, ["Ride"] = 27.5, ["Fly|Ride"] = 69.18, ["Neon"] = 69.18, ["Neon|Ride"] = 206.25, ["Neon|Fly|Ride"] = 225, ["Mega"] = 412.36, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 48.61, ["Fly"] = 99.9, ["Ride"] = 67.51, ["Fly|Ride"] = 91.25, ["Neon"] = 250, ["Neon|Ride"] = 298.75, ["Neon|Fly|Ride"] = 312.5, ["Mega"] = 2323.64, ["Mega|Fly|Ride"] = 2498.75}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.6, ["Fly"] = 139.86, ["Ride"] = 49.81, ["Fly|Ride"] = 97.5, ["Neon"] = 136.28, ["Neon|Ride"] = 123.06, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 1401.68, ["Mega|Ride"] = 893.75, ["Mega|Fly|Ride"] = 646.54}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.48, ["Fly"] = 91.12, ["Ride"] = 25, ["Neon"] = 52.41, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 260, ["Mega"] = 290.8, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 440}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 18.5, ["Ride"] = 56.25, ["Fly|Ride"] = 138.35, ["Neon"] = 100, ["Neon|Ride"] = 358.61, ["Neon|Fly|Ride"] = 145, ["Mega"] = 322.9, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 378.75}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 10, ["Ride"] = 75, ["Neon"] = 139.48, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 500, ["Mega"] = 511.03, ["Mega|Fly"] = 540, ["Mega|Ride"] = 453.75, ["Mega|Fly|Ride"] = 720.59}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.67}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.47, ["Ride"] = 27.5, ["Fly|Ride"] = 75, ["Neon"] = 30, ["Neon|Ride"] = 43.75, ["Neon|Fly|Ride"] = 203.78, ["Mega"] = 200, ["Mega|Fly"] = 436.44, ["Mega|Ride"] = 225, ["Mega|Fly|Ride"] = 293.38}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.4, ["Neon"] = 6.25, ["Mega"] = 132.68, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.24, ["Fly"] = 59.99, ["Ride"] = 41.99, ["Fly|Ride"] = 78.06, ["Neon"] = 210, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 165.19, ["Neon|Fly|Ride"] = 187.5, ["Mega|Ride"] = 551.29, ["Mega|Fly|Ride"] = 587.5}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.22, ["Fly"] = 17.09, ["Ride"] = 17.33, ["Fly|Ride"] = 35, ["Neon"] = 27.75, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 71.57, ["Mega"] = 221.24, ["Mega|Fly"] = 411.92, ["Mega|Ride"] = 175, ["Mega|Fly|Ride"] = 188.74}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.82, ["Fly"] = 30.38, ["Ride"] = 24.91, ["Fly|Ride"] = 51.63, ["Neon"] = 19.97, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 209.67, ["Mega|Ride"] = 147.5, ["Mega|Fly|Ride"] = 234.38}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2, ["Neon"] = 3.64, ["Mega"] = 38.75, ["Mega|Ride"] = 193.75, ["Mega|Fly|Ride"] = 246.25}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.92, ["Ride"] = 51.25, ["Fly|Ride"] = 138.35, ["Neon"] = 234.35, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 412.95, ["Mega|Ride"] = 817.63, ["Mega|Fly|Ride"] = 800}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2, ["Ride"] = 21.25, ["Fly|Ride"] = 55.64, ["Neon"] = 7.28, ["Neon|Fly"] = 193.75, ["Neon|Ride"] = 39.98, ["Neon|Fly|Ride"] = 100, ["Mega"] = 69.18, ["Mega|Ride"] = 133.27}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.86, ["Ride"] = 83.75, ["Fly|Ride"] = 274.61, ["Neon"] = 56.25, ["Neon|Ride"] = 162.5, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 225, ["Mega|Fly"] = 551.29, ["Mega|Ride"] = 381.68, ["Mega|Fly|Ride"] = 688.59}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2, ["Fly"] = 43.73, ["Ride"] = 16.14, ["Fly|Ride"] = 42.5, ["Neon"] = 17.43, ["Neon|Ride"] = 23.03, ["Neon|Fly|Ride"] = 94.99, ["Mega"] = 185, ["Mega|Ride"] = 193.13, ["Mega|Fly|Ride"] = 274.61}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.19, ["Fly"] = 49.99, ["Ride"] = 18.56, ["Fly|Ride"] = 42.79, ["Neon"] = 47.28, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 162.5, ["Mega"] = 584.04, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 298.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 9.72, ["Ride"] = 33.04, ["Neon"] = 50.24, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 398.15, ["Mega|Ride"] = 348.75, ["Mega|Fly|Ride"] = 614.99}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 48.43, ["Ride"] = 93.75, ["Fly|Ride"] = 457.39, ["Neon"] = 336.41, ["Neon|Ride"] = 463.54, ["Neon|Fly|Ride"] = 812.47, ["Mega"] = 1705.45, ["Mega|Fly|Ride"] = 1858.24}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.06, ["Ride"] = 74.9, ["Fly|Ride"] = 153.6, ["Neon"] = 102.49, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 375, ["Mega|Ride"] = 398.75, ["Mega|Fly|Ride"] = 681.88}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.08, ["Ride"] = 107.56, ["Neon"] = 88.8, ["Neon|Fly"] = 206.48, ["Neon|Ride"] = 162.5, ["Mega|Ride"] = 824.87}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.49, ["Ride"] = 100, ["Fly|Ride"] = 349.98, ["Neon"] = 127.77, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 312.5, ["Mega"] = 647.29, ["Mega|Fly"] = 2064.71, ["Mega|Ride"] = 609.1, ["Mega|Fly|Ride"] = 774.28}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.31, ["Neon"] = 18.97, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 175.51, ["Mega|Ride"] = 242.97, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2, ["Fly"] = 125, ["Ride"] = 18.53, ["Fly|Ride"] = 40.01, ["Neon"] = 3.1, ["Neon|Fly"] = 40.97, ["Neon|Ride"] = 42.01, ["Neon|Fly|Ride"] = 61.99, ["Mega"] = 66.25, ["Mega|Ride"] = 72.5, ["Mega|Fly|Ride"] = 137.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2, ["Fly"] = 43.75, ["Ride"] = 25.71, ["Fly|Ride"] = 74.12, ["Neon"] = 14.25, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 156.24, ["Mega"] = 85, ["Mega|Ride"] = 99.98, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2, ["Fly"] = 138.35, ["Ride"] = 18.74, ["Fly|Ride"] = 62.5, ["Neon"] = 7.5, ["Neon|Ride"] = 24.79, ["Neon|Fly|Ride"] = 87.79, ["Mega"] = 50, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 159.77}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.74, ["Fly"] = 62.49, ["Ride"] = 18.28, ["Fly|Ride"] = 69.18, ["Neon"] = 17.59, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 312.4, ["Mega|Ride"] = 315.91, ["Mega|Fly|Ride"] = 345}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.5, ["Fly"] = 55.06, ["Ride"] = 23.37, ["Fly|Ride"] = 412.95, ["Neon"] = 28.75, ["Neon|Fly"] = 300, ["Neon|Ride"] = 81.25, ["Mega"] = 293.2, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.67, ["Fly"] = 125, ["Ride"] = 22.33, ["Fly|Ride"] = 53.75, ["Neon"] = 31.07, ["Neon|Fly"] = 123.89, ["Neon|Ride"] = 44.91, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 292.02, ["Mega|Ride"] = 278.74, ["Mega|Fly|Ride"] = 444.37}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2, ["Fly"] = 33.79, ["Ride"] = 20.66, ["Fly|Ride"] = 49.91, ["Neon"] = 22.5, ["Neon|Ride"] = 65.79, ["Neon|Fly|Ride"] = 103.24, ["Mega"] = 247.77, ["Mega|Ride"] = 300.63, ["Mega|Fly|Ride"] = 177.31}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.62, ["Fly"] = 274.97, ["Ride"] = 44.97, ["Fly|Ride"] = 125, ["Neon"] = 12.4, ["Neon|Fly"] = 416.24, ["Neon|Ride"] = 63.75, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 88.77, ["Mega|Fly"] = 206.25, ["Mega|Ride"] = 124.99, ["Mega|Fly|Ride"] = 257.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.48, ["Ride"] = 109.44, ["Fly|Ride"] = 500, ["Neon"] = 122.86, ["Neon|Fly"] = 275, ["Neon|Ride"] = 178.75, ["Neon|Fly|Ride"] = 375, ["Mega"] = 598.75, ["Mega|Ride"] = 753.52, ["Mega|Fly|Ride"] = 617.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.24, ["Fly"] = 156.25, ["Ride"] = 90.85, ["Fly|Ride"] = 157.5, ["Neon"] = 229.42, ["Neon|Ride"] = 212.5, ["Neon|Fly|Ride"] = 320, ["Mega"] = 1513.53, ["Mega|Ride"] = 1000, ["Mega|Fly|Ride"] = 1225.41}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2, ["Ride"] = 20.54, ["Fly|Ride"] = 49.56, ["Neon"] = 2.29, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 26.25, ["Mega|Ride"] = 67.65, ["Mega|Fly|Ride"] = 102.5}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 9.73, ["Neon"] = 100.89, ["Mega"] = 653.86, ["Mega|Fly|Ride"] = 1088.11}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.14, ["Ride"] = 87.54, ["Neon"] = 237.49, ["Neon|Ride"] = 327.97, ["Neon|Fly|Ride"] = 824.87, ["Mega"] = 1701.33, ["Mega|Fly|Ride"] = 1388.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.12, ["Fly"] = 181.25, ["Ride"] = 24.59, ["Fly|Ride"] = 127.5, ["Neon"] = 44.63, ["Neon|Fly"] = 125, ["Neon|Ride"] = 77.5, ["Neon|Fly|Ride"] = 121.82, ["Mega"] = 254.72, ["Mega|Fly"] = 705.52, ["Mega|Ride"] = 231.25, ["Mega|Fly|Ride"] = 258.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.11, ["Fly|Ride"] = 110.47, ["Neon"] = 12.5, ["Mega"] = 97.5, ["Mega|Fly"] = 268.73, ["Mega|Ride"] = 122.7}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2, ["Fly"] = 32.29, ["Ride"] = 18.34, ["Fly|Ride"] = 47.5, ["Neon"] = 15.77, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 31.15, ["Neon|Fly|Ride"] = 80, ["Mega"] = 165, ["Mega|Ride"] = 124.9}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2, ["Fly"] = 16.29, ["Ride"] = 13.71, ["Fly|Ride"] = 49.81, ["Neon"] = 2, ["Neon|Fly"] = 118.48, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 49.91, ["Mega"] = 22.48, ["Mega|Ride"] = 70.1, ["Mega|Fly|Ride"] = 147.42}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2, ["Ride"] = 18.75, ["Fly|Ride"] = 78.27, ["Neon"] = 3.88, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 68.88, ["Mega|Fly"] = 153.66, ["Mega|Ride"] = 54.91, ["Mega|Fly|Ride"] = 165.19}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2, ["Ride"] = 125, ["Neon"] = 2.5, ["Neon|Ride"] = 138.17, ["Mega"] = 40.28, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.7, ["Ride"] = 150, ["Neon"] = 50.79, ["Neon|Ride"] = 80, ["Neon|Fly|Ride"] = 135, ["Mega"] = 390.14, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 408.13}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.49, ["Ride"] = 25, ["Fly|Ride"] = 205.59, ["Neon"] = 55.82, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 275, ["Mega"] = 271.88, ["Mega|Ride"] = 222.75, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.27, ["Fly"] = 24.97, ["Ride"] = 18.37, ["Fly|Ride"] = 41.78, ["Neon"] = 24.99, ["Neon|Fly"] = 110.47, ["Neon|Ride"] = 33.55, ["Neon|Fly|Ride"] = 87.4, ["Mega"] = 334.49, ["Mega|Ride"] = 296.54, ["Mega|Fly|Ride"] = 382.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 68.41, ["Ride"] = 75, ["Fly|Ride"] = 118.75, ["Neon"] = 375, ["Neon|Ride"] = 411.92, ["Neon|Fly|Ride"] = 688.59, ["Mega"] = 2336.14, ["Mega|Ride"] = 1555.77, ["Mega|Fly|Ride"] = 1402.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 19.54, ["Fly"] = 78.75, ["Ride"] = 56.25, ["Fly|Ride"] = 110.47, ["Neon"] = 55.76, ["Neon|Fly|Ride"] = 600, ["Mega"] = 442.5, ["Mega|Ride"] = 837.5, ["Mega|Fly|Ride"] = 988.13}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2, ["Fly"] = 18.73, ["Ride"] = 14.9, ["Fly|Ride"] = 39.58, ["Neon"] = 2.29, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 53.75, ["Mega"] = 17.25, ["Mega|Ride"] = 88.99}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2, ["Fly"] = 14.9, ["Ride"] = 14.81, ["Fly|Ride"] = 33.47, ["Neon"] = 4.06, ["Neon|Fly"] = 26.22, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 43.65, ["Mega"] = 42.98, ["Mega|Ride"] = 47.01, ["Mega|Fly|Ride"] = 93.2}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 387.49, ["Fly"] = 549, ["Ride"] = 420.79, ["Fly|Ride"] = 493.75, ["Neon"] = 1900.45, ["Neon|Ride"] = 1937.5, ["Neon|Fly|Ride"] = 1997.5, ["Mega|Fly|Ride"] = 6538.94}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.64, ["Ride"] = 38.75, ["Neon"] = 38.74, ["Neon|Ride"] = 86.25, ["Neon|Fly|Ride"] = 275, ["Mega"] = 384.28, ["Mega|Ride"] = 687.56, ["Mega|Fly|Ride"] = 344.82}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2, ["Fly"] = 14.99, ["Ride"] = 15, ["Fly|Ride"] = 47.5, ["Neon"] = 6.23, ["Neon|Fly"] = 18.56, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 53.73, ["Mega"] = 59.59, ["Mega|Ride"] = 41.25, ["Mega|Fly|Ride"] = 109.7}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 48.53, ["Ride"] = 111.25, ["Fly|Ride"] = 272.55, ["Neon"] = 150, ["Neon|Ride"] = 247.15, ["Neon|Fly|Ride"] = 417.5, ["Mega"] = 702.5, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 4.02, ["Fly"] = 23.37, ["Ride"] = 20.26, ["Fly|Ride"] = 59.19, ["Neon"] = 18.7, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 28, ["Neon|Fly|Ride"] = 88.74, ["Mega"] = 125, ["Mega|Ride"] = 123.73, ["Mega|Fly|Ride"] = 212.5}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2, ["Ride"] = 51.63, ["Fly|Ride"] = 187.5, ["Neon"] = 2, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 17.14, ["Mega|Ride"] = 51.24, ["Mega|Fly|Ride"] = 220.78}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 30, ["Fly"] = 123.75, ["Ride"] = 74.23, ["Fly|Ride"] = 205.27, ["Neon"] = 116.82, ["Neon|Ride"] = 153.75, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 675.17, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 650}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2, ["Fly"] = 23.75, ["Ride"] = 18.75, ["Fly|Ride"] = 139.99, ["Neon"] = 5, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 82.6, ["Mega"] = 59.89, ["Mega|Ride"] = 151.28, ["Mega|Fly|Ride"] = 240}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.75, ["Ride"] = 58.57, ["Fly|Ride"] = 99.99, ["Neon"] = 269.74, ["Neon|Ride"] = 214.93, ["Neon|Fly|Ride"] = 274.72, ["Mega"] = 1125, ["Mega|Ride"] = 1238.83, ["Mega|Fly|Ride"] = 1270.31}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.55, ["Fly"] = 69.18, ["Ride"] = 125, ["Fly|Ride"] = 412.95, ["Neon"] = 16.93, ["Neon|Ride"] = 220, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 161.25, ["Mega|Ride"] = 225, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2, ["Fly"] = 69.18, ["Ride"] = 74.38, ["Fly|Ride"] = 55.76, ["Neon"] = 10.68, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 420.51, ["Mega"] = 112, ["Mega|Ride"] = 118.75, ["Mega|Fly|Ride"] = 211.25}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 52.49, ["Fly"] = 179.63, ["Ride"] = 106.25, ["Fly|Ride"] = 155.46, ["Neon|Ride"] = 399.15, ["Mega"] = 1928.45, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 1928.45}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2, ["Fly"] = 559.5, ["Ride"] = 28, ["Neon"] = 7.09, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 44.91, ["Mega|Fly"] = 206.48, ["Mega|Ride"] = 85, ["Mega|Fly|Ride"] = 262.23}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2, ["Fly"] = 18.53, ["Ride"] = 18.56, ["Fly|Ride"] = 35.11, ["Neon"] = 8.27, ["Neon|Fly"] = 40, ["Neon|Ride"] = 24.67, ["Neon|Fly|Ride"] = 69.83, ["Mega"] = 56.31, ["Mega|Fly"] = 143.69, ["Mega|Ride"] = 77.49, ["Mega|Fly|Ride"] = 208.98}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 14.66, ["Fly"] = 55.15, ["Ride"] = 35.48, ["Fly|Ride"] = 186.62, ["Neon"] = 77.96, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 312.49, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 338.62}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.15, ["Fly"] = 41.3, ["Ride"] = 30, ["Fly|Ride"] = 61.3, ["Neon"] = 55, ["Neon|Ride"] = 84.12, ["Neon|Fly|Ride"] = 135, ["Mega"] = 337.5, ["Mega|Ride"] = 437.5, ["Mega|Fly|Ride"] = 400.04}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 15.5, ["Fly"] = 48.75, ["Ride"] = 31.24, ["Fly|Ride"] = 63.08, ["Neon"] = 86.66, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 142.79, ["Mega"] = 389.5, ["Mega|Ride"] = 311.84, ["Mega|Fly|Ride"] = 337.5}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 67.4, ["Ride"] = 102.82, ["Fly|Ride"] = 187.5, ["Neon"] = 248.75, ["Neon|Ride"] = 269.99, ["Neon|Fly|Ride"] = 450, ["Mega"] = 1500, ["Mega|Ride"] = 1567.12, ["Mega|Fly|Ride"] = 1527.89}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.59, ["Ride"] = 109.9, ["Fly|Ride"] = 97.05, ["Neon"] = 60.01, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 285, ["Mega"] = 229.95, ["Mega|Fly"] = 549.22, ["Mega|Ride"] = 379.92, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.47, ["Ride"] = 27.88, ["Fly|Ride"] = 74.98, ["Neon"] = 19.9, ["Neon|Ride"] = 42.5, ["Mega"] = 156.93, ["Mega|Ride"] = 164.16, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.32, ["Fly"] = 128.75, ["Ride"] = 34.64, ["Fly|Ride"] = 156.53, ["Neon"] = 54.91, ["Neon|Ride"] = 107.38, ["Neon|Fly|Ride"] = 166.76, ["Mega"] = 302.5, ["Mega|Fly|Ride"] = 998.75}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2, ["Fly"] = 15, ["Ride"] = 11.15, ["Fly|Ride"] = 39.51, ["Neon"] = 2, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 14.9, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 14.03, ["Mega|Fly"] = 40, ["Mega|Ride"] = 26.88, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 41.3, ["Fly"] = 156.25, ["Ride"] = 97.5, ["Neon"] = 225, ["Neon|Fly"] = 2340.36, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 464.57, ["Mega"] = 1031.34, ["Mega|Ride"] = 1045.42, ["Mega|Fly|Ride"] = 862.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2, ["Ride"] = 22.89, ["Neon"] = 7.35, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 123.74, ["Mega"] = 30, ["Mega|Ride"] = 82.94, ["Mega|Fly|Ride"] = 298.74}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 15, ["Fly|Ride"] = 43.75, ["Neon"] = 17.38, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 61.24, ["Mega"] = 245, ["Mega|Ride"] = 187.49, ["Mega|Fly|Ride"] = 217.5}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.75, ["Fly"] = 103.24, ["Ride"] = 68.75, ["Fly|Ride"] = 189.96, ["Neon"] = 187.5, ["Neon|Ride"] = 248.75, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 796.25, ["Mega|Ride"] = 1040.75, ["Mega|Fly|Ride"] = 975}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2, ["Ride"] = 68.75, ["Neon"] = 8.47, ["Neon|Ride"] = 1377.18, ["Mega"] = 75.38, ["Mega|Fly"] = 148.35, ["Mega|Ride"] = 111.24, ["Mega|Fly|Ride"] = 299.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.05}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2, ["Ride"] = 31.88, ["Fly|Ride"] = 68.12, ["Neon"] = 5.98, ["Neon|Ride"] = 30, ["Neon|Fly|Ride"] = 109.81, ["Mega"] = 93.45, ["Mega|Ride"] = 99.9, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.87, ["Ride"] = 186.74, ["Fly|Ride"] = 324.17, ["Neon"] = 606, ["Neon|Ride"] = 553.24, ["Neon|Fly|Ride"] = 646.25, ["Mega"] = 6194.13, ["Mega|Ride"] = 3115.23, ["Mega|Fly|Ride"] = 2522.05}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.61, ["Ride"] = 35.11, ["Fly|Ride"] = 116.82, ["Neon"] = 22.13, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 61.96, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 169.98, ["Mega|Ride"] = 213, ["Mega|Fly|Ride"] = 249.99}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 95.18, ["Neon"] = 3.61, ["Neon|Ride"] = 20.3, ["Mega"] = 33.04, ["Mega|Ride"] = 67.76, ["Mega|Fly|Ride"] = 330.14}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.48, ["Ride"] = 31.25, ["Fly|Ride"] = 125, ["Neon"] = 54.62, ["Neon|Ride"] = 85.36, ["Neon|Fly|Ride"] = 152.79, ["Mega"] = 412.95, ["Mega|Ride"] = 399.53, ["Mega|Fly|Ride"] = 633.87}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.58, ["Fly"] = 37, ["Ride"] = 21.25, ["Fly|Ride"] = 55.76, ["Neon"] = 96.21, ["Neon|Ride"] = 175.63, ["Neon|Fly|Ride"] = 188.13, ["Mega"] = 603.9, ["Mega|Ride"] = 615.29, ["Mega|Fly|Ride"] = 468.75}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.68, ["Ride"] = 52.5, ["Fly|Ride"] = 262.23, ["Neon"] = 121.25, ["Neon|Ride"] = 201.32, ["Neon|Fly|Ride"] = 313.85, ["Mega"] = 535, ["Mega|Ride"] = 485.52, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 138.35, ["Fly"] = 187.5, ["Ride"] = 182.5, ["Fly|Ride"] = 233.63, ["Neon"] = 550, ["Neon|Fly"] = 825.89, ["Neon|Ride"] = 539.9, ["Neon|Fly|Ride"] = 612.4, ["Mega|Ride"] = 2477.66, ["Mega|Fly|Ride"] = 2214.65}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 7.45, ["Fly"] = 19.99, ["Ride"] = 20.56, ["Fly|Ride"] = 41.46, ["Neon"] = 47.8, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 82.5, ["Mega|Fly|Ride"] = 350.48}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2, ["Fly"] = 124.98, ["Ride"] = 26.44, ["Fly|Ride"] = 62.5, ["Neon"] = 17.84, ["Neon|Ride"] = 37.46, ["Neon|Fly|Ride"] = 125, ["Mega"] = 133.43, ["Mega|Ride"] = 179.63, ["Mega|Fly|Ride"] = 278.07}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.49, ["Fly"] = 22.5, ["Ride"] = 35.9, ["Fly|Ride"] = 86.25, ["Neon"] = 27.5, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 49.99, ["Neon|Fly|Ride"] = 82.6, ["Mega"] = 436.25, ["Mega|Ride"] = 409.38, ["Mega|Fly|Ride"] = 1245.03}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.9, ["Fly"] = 105.14, ["Ride"] = 49.9, ["Fly|Ride"] = 126.99, ["Neon"] = 199.99, ["Neon|Fly"] = 162.5, ["Neon|Ride"] = 218.4, ["Neon|Fly|Ride"] = 245.02, ["Mega"] = 909.52, ["Mega|Ride"] = 881.25, ["Mega|Fly|Ride"] = 912.49}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 11.37, ["Fly"] = 55, ["Ride"] = 69.18, ["Neon"] = 176.39, ["Neon|Ride"] = 439.79, ["Neon|Fly|Ride"] = 455.28, ["Mega"] = 771.18, ["Mega|Ride"] = 1840, ["Mega|Fly|Ride"] = 784.6}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 250, ["Ride"] = 333.75, ["Neon"] = 1558.21, ["Neon|Ride"] = 3115.23, ["Mega|Fly|Ride"] = 4955.31}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.9, ["Fly"] = 55.84, ["Ride"] = 32.19, ["Fly|Ride"] = 66.14, ["Neon"] = 205.59, ["Neon|Ride"] = 123.81, ["Neon|Fly|Ride"] = 192.03, ["Mega"] = 725, ["Mega|Ride"] = 717.4, ["Mega|Fly|Ride"] = 804.67}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2, ["Fly"] = 41.3, ["Ride"] = 12.5, ["Fly|Ride"] = 66.82, ["Neon"] = 2.09, ["Neon|Ride"] = 17.4, ["Neon|Fly|Ride"] = 51.25, ["Mega"] = 20, ["Mega|Fly"] = 109.44, ["Mega|Ride"] = 47.5, ["Mega|Fly|Ride"] = 111.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.2, ["Ride"] = 27.88, ["Neon"] = 14.6, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 106.25, ["Mega|Ride"] = 156.36, ["Mega|Fly|Ride"] = 325}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2, ["Fly"] = 31.25, ["Ride"] = 29.38, ["Fly|Ride"] = 137.33, ["Neon"] = 22.72, ["Neon|Ride"] = 66.08, ["Neon|Fly|Ride"] = 1124.98, ["Mega"] = 127.25, ["Mega|Fly"] = 547.62, ["Mega|Ride"] = 359.26, ["Mega|Fly|Ride"] = 325.63}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 370, ["Fly"] = 481.25, ["Ride"] = 398.75, ["Fly|Ride"] = 539.93, ["Neon"] = 1808.08, ["Neon|Ride"] = 1928.45, ["Neon|Fly|Ride"] = 1500, ["Mega|Fly|Ride"] = 5230.95}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.43, ["Fly"] = 37.5, ["Ride"] = 16.12, ["Fly|Ride"] = 53.74, ["Neon"] = 24.91, ["Neon|Ride"] = 59.89, ["Neon|Fly|Ride"] = 105.83, ["Mega"] = 211.05, ["Mega|Ride"] = 85, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.23, ["Fly"] = 21.25, ["Ride"] = 18.59, ["Fly|Ride"] = 40.89, ["Neon"] = 41.19, ["Neon|Fly"] = 149, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 132.5, ["Mega"] = 172.88, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 288.14}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.5, ["Fly"] = 40, ["Ride"] = 25, ["Fly|Ride"] = 52.15, ["Neon"] = 13.11, ["Neon|Fly"] = 89.98, ["Neon|Ride"] = 40.13, ["Neon|Fly|Ride"] = 108.04, ["Mega"] = 93.75, ["Mega|Ride"] = 123.75, ["Mega|Fly|Ride"] = 259.13}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 27.88, ["Fly"] = 54.91, ["Ride"] = 31.25, ["Fly|Ride"] = 75, ["Neon"] = 209.9, ["Neon|Ride"] = 199.99, ["Neon|Fly|Ride"] = 308.69, ["Mega"] = 1238.83, ["Mega|Ride"] = 824.87, ["Mega|Fly|Ride"] = 612.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 48.75, ["Fly|Ride"] = 49.28, ["Neon"] = 11.15, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 200, ["Mega"] = 157.52, ["Mega|Ride"] = 435.99, ["Mega|Fly|Ride"] = 938.13}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 12.5, ["Fly"] = 88.68, ["Ride"] = 26.24, ["Neon"] = 162.5, ["Neon|Ride"] = 234.35, ["Neon|Fly|Ride"] = 246.88, ["Mega"] = 712.5, ["Mega|Ride"] = 412.95, ["Mega|Fly|Ride"] = 751.56}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2, ["Ride"] = 29.9, ["Neon"] = 4.21, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 109.81, ["Mega"] = 52.48, ["Mega|Ride"] = 138.25, ["Mega|Fly|Ride"] = 237.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 7.41, ["Fly"] = 68.75, ["Ride"] = 23.1, ["Neon"] = 48.44, ["Mega"] = 129.54, ["Mega|Ride"] = 311.88, ["Mega|Fly|Ride"] = 725.63}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.52, ["Ride"] = 31.55, ["Neon"] = 68.14, ["Neon|Ride"] = 275.65, ["Neon|Fly|Ride"] = 125, ["Mega"] = 304.56, ["Mega|Ride"] = 535.8, ["Mega|Fly|Ride"] = 441.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.8, ["Fly"] = 31.25, ["Ride"] = 25.71, ["Fly|Ride"] = 53.7, ["Neon"] = 39.14, ["Neon|Fly"] = 109.81, ["Neon|Ride"] = 53.66, ["Neon|Fly|Ride"] = 125, ["Mega"] = 515.16, ["Mega|Ride"] = 311.25, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 453.75, ["Fly"] = 578.2, ["Ride"] = 419.48, ["Fly|Ride"] = 497.5, ["Neon"] = 1564.2, ["Neon|Ride"] = 1868.9, ["Neon|Fly|Ride"] = 1562.5, ["Mega|Fly|Ride"] = 7102.6}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2, ["Ride"] = 15.5, ["Fly|Ride"] = 37.49, ["Neon"] = 28.04, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 156.88, ["Mega"] = 232.29, ["Mega|Ride"] = 187.4, ["Mega|Fly|Ride"] = 293.2}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 9.74, ["Fly"] = 68.14, ["Ride"] = 82.6, ["Fly|Ride"] = 93.75, ["Neon"] = 61.25, ["Neon|Ride"] = 121.18, ["Neon|Fly|Ride"] = 437.5, ["Mega"] = 342.5, ["Mega|Fly"] = 688.59, ["Mega|Ride"] = 515.16, ["Mega|Fly|Ride"] = 586.39}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.4, ["Fly"] = 83.5, ["Ride"] = 87.2, ["Fly|Ride"] = 230.23, ["Neon"] = 81.24, ["Neon|Ride"] = 203.75, ["Neon|Fly|Ride"] = 333.75, ["Mega"] = 337.59, ["Mega|Ride"] = 326.25, ["Mega|Fly|Ride"] = 462.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 51.04, ["Fly"] = 148.67, ["Ride"] = 80, ["Fly|Ride"] = 118.75, ["Neon"] = 306.25, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 362.5, ["Mega"] = 2397.39, ["Mega|Ride"] = 2753.2, ["Mega|Fly|Ride"] = 1760.28}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.85, ["Ride"] = 43.89, ["Fly|Ride"] = 109.81, ["Neon"] = 34.29, ["Neon|Ride"] = 76.04, ["Neon|Fly|Ride"] = 256.03, ["Mega"] = 157.29, ["Mega|Ride"] = 184.8, ["Mega|Fly|Ride"] = 316.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2, ["Fly"] = 27.5, ["Ride"] = 16.25, ["Fly|Ride"] = 55.11, ["Neon"] = 17.34, ["Neon|Ride"] = 31.93, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 97.5, ["Mega|Fly|Ride"] = 249.99}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.52, ["Ride"] = 43.51, ["Neon"] = 18.74, ["Neon|Ride"] = 98.09, ["Neon|Fly|Ride"] = 165.63, ["Mega"] = 102.22, ["Mega|Fly"] = 234.35, ["Mega|Ride"] = 145.17, ["Mega|Fly|Ride"] = 268.9}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 42.5, ["Fly"] = 174.97, ["Ride"] = 81.25, ["Fly|Ride"] = 188.31, ["Neon"] = 100, ["Neon|Ride"] = 154.99, ["Neon|Fly|Ride"] = 250, ["Mega"] = 370, ["Mega|Ride"] = 424.9, ["Mega|Fly|Ride"] = 463.66}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.5, ["Ride"] = 81.21, ["Neon"] = 8.74, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 220.93, ["Mega"] = 50, ["Mega|Ride"] = 225, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.62, ["Ride"] = 87.5, ["Neon"] = 100, ["Neon|Ride"] = 356.24, ["Mega"] = 615.29, ["Mega|Ride"] = 757.76, ["Mega|Fly|Ride"] = 734.02}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 906.24, ["Fly"] = 1137.5, ["Ride"] = 960, ["Fly|Ride"] = 968.74, ["Neon"] = 4129.42, ["Neon|Ride"] = 2500, ["Neon|Fly|Ride"] = 2723.75, ["Mega|Fly|Ride"] = 10571.31}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.37, ["Fly"] = 109.14, ["Ride"] = 42.07, ["Fly|Ride"] = 170.57, ["Neon"] = 62.49, ["Neon|Fly"] = 687.56, ["Neon|Ride"] = 110.47, ["Neon|Fly|Ride"] = 356.25, ["Mega"] = 247.49, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2, ["Fly"] = 47.49, ["Ride"] = 26.25, ["Fly|Ride"] = 90.03, ["Neon"] = 10.58, ["Neon|Ride"] = 31.15, ["Neon|Fly|Ride"] = 85, ["Mega"] = 61.25, ["Mega|Ride"] = 88.13, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 12.5, ["Ride"] = 125, ["Fly|Ride"] = 138.35, ["Neon"] = 67.68, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 367.51, ["Mega"] = 274.98, ["Mega|Ride"] = 410.1, ["Mega|Fly|Ride"] = 880}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2, ["Ride"] = 22.5, ["Fly|Ride"] = 178.75, ["Neon"] = 2.5, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 91.25, ["Mega"] = 19, ["Mega|Ride"] = 51.25, ["Mega|Fly|Ride"] = 112.49}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 49.97, ["Fly"] = 123.89, ["Ride"] = 100.87, ["Fly|Ride"] = 253.75, ["Neon"] = 187.5, ["Neon|Fly"] = 337.5, ["Neon|Ride"] = 250, ["Mega"] = 898.14, ["Mega|Ride"] = 846.24, ["Mega|Fly|Ride"] = 890}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.39, ["Ride"] = 59.89, ["Fly|Ride"] = 263.64, ["Neon"] = 148.75, ["Neon|Ride"] = 136.28, ["Neon|Fly|Ride"] = 250, ["Mega"] = 399.53, ["Mega|Ride"] = 807.32, ["Mega|Fly|Ride"] = 774.28}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2, ["Ride"] = 22.09, ["Neon"] = 12.5, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 93.45, ["Mega|Ride"] = 150, ["Mega|Fly|Ride"] = 358.24}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 22.72, ["Fly"] = 152.79, ["Ride"] = 38.72, ["Fly|Ride"] = 91.29, ["Neon"] = 77.39, ["Neon|Ride"] = 91.13, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 389.68, ["Mega|Ride"] = 399.99, ["Mega|Fly|Ride"] = 466.74}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5, ["Fly"] = 92.92, ["Ride"] = 25.52, ["Fly|Ride"] = 165.19, ["Neon"] = 26.82, ["Neon|Fly"] = 125, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 137.32, ["Mega"] = 348.1, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 410}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 31.7, ["Ride"] = 87.5, ["Neon"] = 247.77, ["Neon|Ride"] = 247.77, ["Neon|Fly|Ride"] = 551.29, ["Mega"] = 2409.52, ["Mega|Ride"] = 2336.14, ["Mega|Fly|Ride"] = 2062.66}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.41, ["Ride"] = 37.5, ["Fly|Ride"] = 183.65, ["Neon"] = 14.9, ["Neon|Ride"] = 73.75, ["Neon|Fly|Ride"] = 620, ["Mega"] = 43.75, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 244.52}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.12, ["Ride"] = 17.5, ["Fly|Ride"] = 86.25, ["Neon"] = 46.14, ["Neon|Fly"] = 179.63, ["Neon|Ride"] = 66.59, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 285.82, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 276.25}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 104.43, ["Fly"] = 375, ["Ride"] = 148.75, ["Fly|Ride"] = 247.77, ["Neon"] = 462.25, ["Neon|Ride"] = 517.5, ["Neon|Fly|Ride"] = 637.5, ["Mega|Ride"] = 1747.58, ["Mega|Fly|Ride"] = 2016.21}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2, ["Fly"] = 23.75, ["Ride"] = 16.25, ["Fly|Ride"] = 41.25, ["Neon"] = 23.58, ["Neon|Fly"] = 54.59, ["Neon|Ride"] = 13.75, ["Neon|Fly|Ride"] = 48.53, ["Mega"] = 125, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 173.75}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 20.62, ["Fly"] = 81.25, ["Ride"] = 57.5, ["Fly|Ride"] = 110.47, ["Neon"] = 146.12, ["Neon|Ride"] = 171.15, ["Neon|Fly|Ride"] = 248.75, ["Mega"] = 551.29, ["Mega|Ride"] = 481.25, ["Mega|Fly|Ride"] = 680.84}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2, ["Fly"] = 17.4, ["Ride"] = 15, ["Fly|Ride"] = 61.23, ["Neon"] = 2, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 11.25, ["Neon|Fly|Ride"] = 44.99, ["Mega"] = 18.75, ["Mega|Ride"] = 31.25, ["Mega|Fly|Ride"] = 78.47}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2, ["Ride"] = 55.76, ["Neon"] = 2, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 16.53, ["Mega|Fly"] = 112.5, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 151.82}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2, ["Fly"] = 35.09, ["Ride"] = 25.72, ["Fly|Ride"] = 165.1, ["Neon"] = 14.28, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 100, ["Mega|Ride"] = 273.86, ["Mega|Fly|Ride"] = 234.38}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.28, ["Fly|Ride"] = 125, ["Neon"] = 126.24, ["Neon|Ride"] = 330.37, ["Neon|Fly|Ride"] = 380.35, ["Mega"] = 487.5, ["Mega|Ride"] = 617.5, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2, ["Fly"] = 20, ["Ride"] = 15.74, ["Fly|Ride"] = 36.19, ["Neon"] = 12.29, ["Neon|Fly"] = 24.92, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 54.34, ["Mega"] = 115, ["Mega|Fly"] = 254.49, ["Mega|Ride"] = 120, ["Mega|Fly|Ride"] = 162.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 9.78, ["Fly"] = 49, ["Ride"] = 42.5, ["Fly|Ride"] = 87.5, ["Neon"] = 50.96, ["Neon|Fly"] = 103.24, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 106.15, ["Mega"] = 304.56, ["Mega|Fly"] = 420.51, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 331.25}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2, ["Fly"] = 16.25, ["Ride"] = 15.5, ["Fly|Ride"] = 65.34, ["Neon"] = 7.57, ["Neon|Fly"] = 93.73, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70, ["Mega"] = 28.59, ["Mega|Fly"] = 209.9, ["Mega|Ride"] = 60, ["Mega|Fly|Ride"] = 137.36}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.35, ["Fly"] = 155.9, ["Ride"] = 23.74, ["Fly|Ride"] = 206.85, ["Neon"] = 36.08, ["Neon|Ride"] = 88.71, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 308.69, ["Mega|Ride"] = 386.11, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.25, ["Ride"] = 49.56, ["Fly|Ride"] = 62.5, ["Neon"] = 43.75, ["Neon|Fly"] = 96.25, ["Neon|Ride"] = 221.37, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 225, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 450}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.48, ["Fly"] = 37.89, ["Ride"] = 17.53, ["Fly|Ride"] = 50, ["Neon"] = 34.56, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 37.58, ["Neon|Fly|Ride"] = 138.38, ["Mega"] = 245.85, ["Mega|Fly"] = 250, ["Mega|Ride"] = 150, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2, ["Fly"] = 16.72, ["Ride"] = 14.58, ["Fly|Ride"] = 50.05, ["Neon"] = 18.59, ["Neon|Fly"] = 67.15, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 80.54, ["Mega"] = 156.53, ["Mega|Ride"] = 97.05, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 200, ["Fly"] = 375, ["Ride"] = 260, ["Fly|Ride"] = 375, ["Neon"] = 1197.55, ["Neon|Ride"] = 1225.41, ["Neon|Fly|Ride"] = 1118.75, ["Mega"] = 4049.68, ["Mega|Fly|Ride"] = 3868.75}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 2.5, ["Ride"] = 100, ["Neon"] = 34, ["Neon|Ride"] = 43.75, ["Mega"] = 117.5, ["Mega|Ride"] = 623.75, ["Mega|Fly|Ride"] = 499.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.75, ["Fly"] = 103.24, ["Ride"] = 23.75, ["Fly|Ride"] = 82.6, ["Neon"] = 29.8, ["Neon|Fly"] = 234.35, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 222.7, ["Mega|Ride"] = 187.49, ["Mega|Fly|Ride"] = 499.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.24, ["Fly|Ride"] = 688.59, ["Neon"] = 43.65, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 574.99, ["Mega"] = 194.38, ["Mega|Ride"] = 390.14, ["Mega|Fly|Ride"] = 396.88}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2, ["Fly"] = 15.4, ["Ride"] = 15.46, ["Fly|Ride"] = 26.67, ["Neon"] = 2, ["Neon|Fly"] = 20.66, ["Neon|Ride"] = 14.38, ["Neon|Fly|Ride"] = 31.25, ["Mega"] = 25, ["Mega|Fly"] = 77.43, ["Mega|Ride"] = 27.38, ["Mega|Fly|Ride"] = 68.73}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2, ["Fly"] = 42.74, ["Ride"] = 18.75, ["Fly|Ride"] = 98.69, ["Neon"] = 17.39, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 47.49, ["Mega"] = 152.79, ["Mega|Ride"] = 190.99, ["Mega|Fly|Ride"] = 223.48}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.5, ["Ride"] = 114.14, ["Neon"] = 9.74, ["Neon|Ride"] = 275.65, ["Neon|Fly|Ride"] = 375, ["Mega"] = 49.99, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 272.55}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 80.45, ["Fly"] = 99.99, ["Ride"] = 85.52, ["Fly|Ride"] = 134.99, ["Neon"] = 300, ["Neon|Fly"] = 685.66, ["Neon|Ride"] = 390, ["Neon|Fly|Ride"] = 405, ["Mega|Ride"] = 3442.91, ["Mega|Fly|Ride"] = 1625}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5, ["Fly"] = 69.18, ["Ride"] = 22.72, ["Fly|Ride"] = 55.76, ["Neon"] = 21.02, ["Neon|Ride"] = 64.91, ["Mega"] = 161.23, ["Mega|Ride"] = 203.75}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2, ["Fly"] = 47.5, ["Ride"] = 32.5, ["Neon"] = 6.87, ["Neon|Ride"] = 168.61, ["Neon|Fly|Ride"] = 524.47, ["Mega"] = 53.66, ["Mega|Fly"] = 299.99, ["Mega|Ride"] = 120, ["Mega|Fly|Ride"] = 350}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 37.5, ["Fly"] = 56.25, ["Ride"] = 74.16, ["Fly|Ride"] = 156.53, ["Neon"] = 143.75, ["Neon|Ride"] = 168.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 525, ["Mega|Ride"] = 606.24, ["Mega|Fly|Ride"] = 675}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2, ["Ride"] = 14.47, ["Fly|Ride"] = 27.88, ["Neon"] = 2.48, ["Neon|Fly"] = 21.13, ["Neon|Ride"] = 15.06, ["Neon|Fly|Ride"] = 35, ["Mega"] = 26.88, ["Mega|Fly"] = 47.5, ["Mega|Ride"] = 32.15, ["Mega|Fly|Ride"] = 58.8}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2, ["Ride"] = 39.24, ["Fly|Ride"] = 88.8, ["Neon"] = 2, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 23.75, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 74.91, ["Mega|Fly|Ride"] = 273.75}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2, ["Ride"] = 100, ["Fly|Ride"] = 153.65, ["Neon"] = 6.09, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 274.9, ["Mega"] = 56.25, ["Mega|Fly"] = 179.63, ["Mega|Ride"] = 119.81, ["Mega|Fly|Ride"] = 286.25}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.64, ["Fly"] = 82.6, ["Ride"] = 39.24, ["Fly|Ride"] = 125.56, ["Neon"] = 21.25, ["Neon|Fly"] = 125, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 152.09, ["Mega"] = 144.85, ["Mega|Fly"] = 316.94, ["Mega|Ride"] = 186.9, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2, ["Fly"] = 17.89, ["Ride"] = 12.85, ["Fly|Ride"] = 41.3, ["Neon"] = 2, ["Neon|Fly"] = 23.67, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 50, ["Mega"] = 18.12, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 112.29}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 19.34, ["Fly"] = 125, ["Ride"] = 50.73, ["Neon"] = 123.57, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 412.95, ["Mega|Ride"] = 685.66, ["Mega|Fly|Ride"] = 778.75}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 1912.49, ["Fly"] = 3000, ["Ride"] = 2139.34, ["Fly|Ride"] = 2062.5, ["Neon|Fly|Ride"] = 7062.5, ["Mega|Fly|Ride"] = 42842.69}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2, ["Fly"] = 18.75, ["Ride"] = 16.25, ["Fly|Ride"] = 50.89, ["Neon"] = 7.28, ["Neon|Fly"] = 32.5, ["Neon|Ride"] = 22.41, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 79.89, ["Mega|Fly"] = 412.95, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 144.99}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2, ["Ride"] = 26.86, ["Neon"] = 8.65, ["Mega"] = 93.96, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 12.99, ["Fly"] = 100, ["Ride"] = 18.75, ["Fly|Ride"] = 150, ["Neon"] = 78.27, ["Neon|Fly"] = 98.09, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 411.25, ["Mega|Ride"] = 386.11, ["Mega|Fly|Ride"] = 654.12}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.75, ["Fly"] = 103.24, ["Ride"] = 67.6, ["Neon"] = 133.75, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 567.81, ["Mega|Ride"] = 618.39, ["Mega|Fly|Ride"] = 623.75}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.86, ["Fly"] = 1377.18, ["Ride"] = 150, ["Fly|Ride"] = 231.25, ["Neon"] = 616.25, ["Neon|Ride"] = 722.81, ["Neon|Fly|Ride"] = 750, ["Mega"] = 6194.13, ["Mega|Fly|Ride"] = 3984.89}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.63, ["Ride"] = 62.41, ["Fly|Ride"] = 643.75, ["Neon"] = 15, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 137.57, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2, ["Ride"] = 35.11, ["Neon"] = 14.7, ["Neon|Fly"] = 89.82, ["Neon|Ride"] = 109.38, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 171.25, ["Mega|Ride"] = 314.9, ["Mega|Fly|Ride"] = 254.37}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.35, ["Fly"] = 97.05, ["Ride"] = 28.03, ["Fly|Ride"] = 69.18, ["Neon"] = 8.27, ["Neon|Fly"] = 121.82, ["Neon|Ride"] = 31.23, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 43.75, ["Mega|Ride"] = 117.86, ["Mega|Fly|Ride"] = 218.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 16.57, ["Ride"] = 67.37, ["Fly|Ride"] = 125, ["Neon"] = 116.03, ["Neon|Ride"] = 172.88, ["Neon|Fly|Ride"] = 347.5, ["Mega"] = 412.95, ["Mega|Ride"] = 452.5, ["Mega|Fly|Ride"] = 544.38}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2, ["Ride"] = 26.88, ["Neon"] = 2, ["Neon|Ride"] = 19.4, ["Mega"] = 26.86, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 77.21, ["Mega|Fly|Ride"] = 172.6}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 93.22, ["Fly"] = 193.06, ["Ride"] = 109.44, ["Fly|Ride"] = 137.4, ["Neon"] = 290, ["Neon|Ride"] = 387.98, ["Neon|Fly|Ride"] = 428.69, ["Mega"] = 3097.07, ["Mega|Fly|Ride"] = 1280.13}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2, ["Fly"] = 39.73, ["Ride"] = 87.47, ["Neon"] = 10, ["Neon|Ride"] = 137.76, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 60, ["Mega|Ride"] = 274.61, ["Mega|Fly|Ride"] = 299.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.25, ["Fly"] = 100, ["Ride"] = 70, ["Fly|Ride"] = 97.05, ["Neon"] = 219.9, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 373.75, ["Mega"] = 2500}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2, ["Fly"] = 60.92, ["Ride"] = 17.5, ["Fly|Ride"] = 39.51, ["Neon"] = 2, ["Neon|Fly"] = 81.77, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 39.77, ["Mega|Fly"] = 140.18, ["Mega|Ride"] = 98.75, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2, ["Neon"] = 7.64, ["Neon|Ride"] = 110, ["Mega"] = 40.28, ["Mega|Fly|Ride"] = 368.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.2, ["Fly"] = 73.75, ["Ride"] = 30.99, ["Fly|Ride"] = 86.25, ["Neon"] = 24.25, ["Neon|Ride"] = 64.91, ["Mega"] = 134.99, ["Mega|Ride"] = 311.88, ["Mega|Fly|Ride"] = 549.22}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 350, ["Fly"] = 475.41, ["Ride"] = 325, ["Fly|Ride"] = 559.99, ["Neon"] = 1121.35, ["Neon|Ride"] = 936, ["Neon|Fly|Ride"] = 1062.49, ["Mega"] = 2979.38, ["Mega|Ride"] = 2981.76, ["Mega|Fly|Ride"] = 3028.93}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.77, ["Fly"] = 82.6, ["Ride"] = 45, ["Fly|Ride"] = 93.96, ["Neon"] = 150.17, ["Neon|Ride"] = 231.28, ["Neon|Fly|Ride"] = 271.52, ["Mega|Ride"] = 1179.99, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2, ["Fly"] = 58.68, ["Ride"] = 31.23, ["Fly|Ride"] = 110.64, ["Neon"] = 10, ["Neon|Ride"] = 76.4, ["Neon|Fly|Ride"] = 124.81, ["Mega"] = 130, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 269.29}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 23.63, ["Fly"] = 203.9, ["Ride"] = 54.91, ["Fly|Ride"] = 142.5, ["Neon"] = 72.5, ["Neon|Fly"] = 168.75, ["Neon|Ride"] = 93.96, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 275.44, ["Mega|Fly"] = 961.32, ["Mega|Ride"] = 290.31, ["Mega|Fly|Ride"] = 488.75}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.33, ["Ride"] = 22.48, ["Neon"] = 96.53, ["Neon|Ride"] = 115.65, ["Neon|Fly|Ride"] = 467.24, ["Mega"] = 623.75, ["Mega|Ride"] = 659.68, ["Mega|Fly|Ride"] = 296.25}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.73, ["Ride"] = 27.88, ["Neon"] = 22.5, ["Neon|Ride"] = 150, ["Mega"] = 102.5, ["Mega|Ride"] = 322.11}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.13, ["Fly"] = 69.18, ["Ride"] = 23.75, ["Fly|Ride"] = 59.97, ["Neon"] = 55, ["Neon|Fly"] = 89.82, ["Neon|Ride"] = 137.78, ["Neon|Fly|Ride"] = 202.03, ["Mega"] = 237.5, ["Mega|Ride"] = 463.75, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 100, ["Fly"] = 233.63, ["Ride"] = 115.12, ["Fly|Ride"] = 187.5, ["Neon"] = 551.29, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 499.99, ["Mega"] = 2750, ["Mega|Ride"] = 2500, ["Mega|Fly|Ride"] = 3115.23}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.75, ["Ride"] = 52.91, ["Fly|Ride"] = 137.74, ["Neon"] = 112.49, ["Neon|Ride"] = 163.12, ["Neon|Fly|Ride"] = 185, ["Mega"] = 511.25, ["Mega|Ride"] = 1101.53}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1737.27, ["Fly"] = 2200.99, ["Ride"] = 1875, ["Fly|Ride"] = 1873.75, ["Neon"] = 11012.13, ["Neon|Fly|Ride"] = 6190, ["Mega|Fly|Ride"] = 23500}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2, ["Fly"] = 62500, ["Ride"] = 68.75, ["Fly|Ride"] = 187.49, ["Neon"] = 18.34, ["Neon|Ride"] = 59.26, ["Mega"] = 136.25, ["Mega|Fly"] = 748.75, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 1238.83}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.47, ["Fly"] = 69.18, ["Ride"] = 55.76, ["Fly|Ride"] = 125, ["Neon"] = 23.75, ["Neon|Ride"] = 85.8, ["Mega"] = 137.5, ["Mega|Ride"] = 220.93, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 837.5, ["Ride"] = 931.15, ["Fly|Ride"] = 962.4, ["Neon"] = 3115.23, ["Neon|Ride"] = 2450.24, ["Neon|Fly|Ride"] = 2753.74, ["Mega|Ride"] = 13238.83, ["Mega|Fly|Ride"] = 14452.96}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 25.89, ["Ride"] = 50, ["Fly|Ride"] = 165.09, ["Neon"] = 220.93, ["Neon|Ride"] = 165.11, ["Mega"] = 816.38, ["Mega|Ride"] = 810.64, ["Mega|Fly|Ride"] = 795.63}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2, ["Ride"] = 20.75, ["Fly|Ride"] = 118.75, ["Neon"] = 10.12, ["Neon|Ride"] = 61.75, ["Neon|Fly|Ride"] = 205.45, ["Mega"] = 150, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2, ["Fly"] = 50, ["Ride"] = 138.35, ["Neon"] = 2.32, ["Neon|Fly"] = 150, ["Neon|Ride"] = 46.97, ["Neon|Fly|Ride"] = 107.38, ["Mega"] = 22.12, ["Mega|Ride"] = 58.39, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.47, ["Ride"] = 114.77, ["Fly|Ride"] = 162.5, ["Neon"] = 437.5, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 610, ["Mega"] = 2336.14, ["Mega|Fly|Ride"] = 2203.05}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2, ["Ride"] = 33.04, ["Fly|Ride"] = 72.27, ["Neon"] = 12.7, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 125, ["Mega"] = 86.25, ["Mega|Ride"] = 116.25, ["Mega|Fly|Ride"] = 237.5}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.75, ["Fly"] = 144.54, ["Ride"] = 97.23, ["Fly|Ride"] = 275.65, ["Neon"] = 412.95, ["Neon|Ride"] = 687.5, ["Mega|Fly|Ride"] = 1684.35}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.13, ["Fly"] = 100, ["Fly|Ride"] = 123.89, ["Neon"] = 56.24, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 256.24, ["Mega"] = 312.4, ["Mega|Ride"] = 304.56}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 212.5, ["Fly"] = 271.25, ["Ride"] = 247.5, ["Fly|Ride"] = 306.25, ["Neon"] = 1083.16, ["Neon|Ride"] = 934.46, ["Neon|Fly|Ride"] = 837.5, ["Mega|Fly|Ride"] = 3713.86}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.49, ["Fly"] = 56.25, ["Ride"] = 21.25, ["Fly|Ride"] = 109.9, ["Neon"] = 61.96, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 108.75, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2, ["Fly"] = 22.1, ["Ride"] = 15.86, ["Fly|Ride"] = 38.68, ["Neon"] = 5.97, ["Neon|Fly"] = 36.16, ["Neon|Ride"] = 18.7, ["Neon|Fly|Ride"] = 45, ["Mega"] = 38.04, ["Mega|Ride"] = 68.43, ["Mega|Fly|Ride"] = 152.68}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1377.18, ["Ride"] = 1000, ["Fly|Ride"] = 1195, ["Neon|Ride"] = 7571.29, ["Neon|Fly|Ride"] = 6710.31, ["Mega"] = 23361.24, ["Mega|Fly|Ride"] = 18582.38}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 14.35, ["Ride"] = 68.11, ["Fly|Ride"] = 193.06, ["Neon"] = 96.25, ["Neon|Ride"] = 299.98, ["Mega"] = 312.5, ["Mega|Ride"] = 415.23, ["Mega|Fly|Ride"] = 537.4}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.06, ["Fly"] = 52.28, ["Ride"] = 37.5, ["Fly|Ride"] = 77.36, ["Neon"] = 26.49, ["Neon|Fly"] = 98.09, ["Neon|Ride"] = 52.9, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 399.88, ["Mega|Ride"] = 153.75, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 25.97, ["Fly"] = 38.34, ["Ride"] = 37.01, ["Fly|Ride"] = 71.22, ["Neon"] = 230.13, ["Neon|Ride"] = 185, ["Neon|Fly|Ride"] = 180.08, ["Mega"] = 2477.66, ["Mega|Ride"] = 1090.98, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 8.42, ["Fly"] = 68.14, ["Ride"] = 25.9, ["Fly|Ride"] = 84.67, ["Neon"] = 56.25, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 250, ["Mega"] = 350, ["Mega|Ride"] = 268.75, ["Mega|Fly|Ride"] = 411.15}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 74.96, ["Ride"] = 138.35, ["Fly|Ride"] = 613.34, ["Neon"] = 274.9, ["Neon|Fly"] = 466.63, ["Neon|Ride"] = 412.95, ["Mega"] = 3716.48, ["Mega|Ride"] = 1029.27, ["Mega|Fly|Ride"] = 920}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2, ["Ride"] = 111.05, ["Neon"] = 2, ["Neon|Fly"] = 52.1, ["Neon|Ride"] = 95.27, ["Neon|Fly|Ride"] = 103.24, ["Mega"] = 16.25, ["Mega|Ride"] = 44.41, ["Mega|Fly|Ride"] = 193.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 79.91, ["Fly"] = 112.49, ["Ride"] = 120, ["Fly|Ride"] = 174.99, ["Neon"] = 551.25, ["Neon|Fly"] = 623.75, ["Neon|Ride"] = 455.28, ["Neon|Fly|Ride"] = 612.49, ["Mega"] = 2064.71, ["Mega|Fly|Ride"] = 1891.28}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2, ["Fly"] = 137.5, ["Ride"] = 22.68, ["Fly|Ride"] = 64.15, ["Neon"] = 188.75, ["Neon|Ride"] = 79.99, ["Mega"] = 736.86, ["Mega|Ride"] = 416.88, ["Mega|Fly|Ride"] = 467.5}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2, ["Fly"] = 31.25, ["Ride"] = 17.5, ["Fly|Ride"] = 37.46, ["Neon"] = 12.5, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 117, ["Mega|Ride"] = 261.97, ["Mega|Fly|Ride"] = 256.25}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2, ["Ride"] = 120, ["Neon"] = 20.66, ["Neon|Fly"] = 136.28, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 204.53, ["Mega"] = 82.31}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 79.95, ["Fly"] = 235.76, ["Ride"] = 212.5, ["Fly|Ride"] = 394.37, ["Neon"] = 346.01, ["Neon|Ride"] = 675, ["Neon|Fly|Ride"] = 923.75, ["Mega"] = 1778.76, ["Mega|Ride"] = 1600, ["Mega|Fly|Ride"] = 1675}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.63, ["Fly|Ride"] = 412.95, ["Neon"] = 19.34, ["Neon|Ride"] = 56.25, ["Mega"] = 125, ["Mega|Ride"] = 150.74, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2, ["Ride"] = 37.49, ["Neon"] = 2, ["Neon|Ride"] = 97.05, ["Mega"] = 15.82, ["Mega|Ride"] = 204.9, ["Mega|Fly|Ride"] = 187.27}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2, ["Fly"] = 98.02, ["Ride"] = 31.25, ["Fly|Ride"] = 137.57, ["Neon"] = 3.64, ["Neon|Fly"] = 82.09, ["Neon|Ride"] = 30, ["Mega"] = 19.97, ["Mega|Fly"] = 53.82, ["Mega|Ride"] = 44.39, ["Mega|Fly|Ride"] = 125.55}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2, ["Fly"] = 34.99, ["Ride"] = 22.17, ["Fly|Ride"] = 49.97, ["Neon"] = 5.79, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 26.86, ["Neon|Fly|Ride"] = 50, ["Mega"] = 60, ["Mega|Ride"] = 124.99, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2, ["Ride"] = 27.5, ["Fly|Ride"] = 109.99, ["Neon"] = 26.25, ["Neon|Ride"] = 125, ["Mega"] = 112.5, ["Mega|Ride"] = 123.89, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2, ["Fly"] = 37.48, ["Ride"] = 16.37, ["Fly|Ride"] = 35.57, ["Neon"] = 15.43, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 38.74, ["Neon|Fly|Ride"] = 78.27, ["Mega"] = 212.5, ["Mega|Ride"] = 135.24, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 51.25, ["Ride"] = 106.25, ["Fly|Ride"] = 206.48, ["Neon"] = 258.16, ["Neon|Ride"] = 375, ["Neon|Fly|Ride"] = 1032.36, ["Mega"] = 625, ["Mega|Ride"] = 675, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2, ["Fly"] = 16.15, ["Ride"] = 16.65, ["Fly|Ride"] = 41.1, ["Neon"] = 2, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 19.5, ["Neon|Fly|Ride"] = 41.25, ["Mega"] = 138.35, ["Mega|Ride"] = 141.13, ["Mega|Fly|Ride"] = 96.14}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.4, ["Fly"] = 27.3, ["Ride"] = 28.75, ["Fly|Ride"] = 65.86, ["Neon"] = 31.24, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 60, ["Neon|Fly|Ride"] = 138.75, ["Mega"] = 287.5, ["Mega|Fly"] = 551.29, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 296.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 23.35, ["Fly"] = 56.25, ["Ride"] = 49.41, ["Fly|Ride"] = 108.88, ["Neon"] = 128.74, ["Neon|Ride"] = 118.65, ["Neon|Fly|Ride"] = 193.74, ["Mega"] = 1238.83, ["Mega|Ride"] = 825.89, ["Mega|Fly|Ride"] = 537.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.25, ["Fly"] = 187.5, ["Fly|Ride"] = 64.01, ["Neon"] = 81.24, ["Neon|Ride"] = 98.75, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 511.47, ["Mega|Ride"] = 666.91, ["Mega|Fly|Ride"] = 344.82}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2, ["Fly"] = 17.55, ["Ride"] = 16.43, ["Fly|Ride"] = 31.36, ["Neon"] = 3.75, ["Neon|Fly"] = 26.77, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 66.25, ["Mega"] = 38.74, ["Mega|Fly"] = 85, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 116.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5, ["Fly"] = 50, ["Ride"] = 58.85, ["Neon"] = 73.23, ["Neon|Ride"] = 128.02, ["Neon|Fly|Ride"] = 1112.5, ["Mega"] = 311.25, ["Mega|Fly"] = 354.11, ["Mega|Ride"] = 346.88, ["Mega|Fly|Ride"] = 540.96}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 950, ["Fly"] = 1324.6, ["Ride"] = 956.24, ["Fly|Ride"] = 1014.75, ["Neon|Ride"] = 2613.75, ["Neon|Fly|Ride"] = 2258.75, ["Mega|Fly|Ride"] = 7687.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 174.99, ["Ride"] = 250, ["Fly|Ride"] = 375, ["Neon"] = 800, ["Neon|Ride"] = 875, ["Neon|Fly|Ride"] = 964.23, ["Mega"] = 6194.13, ["Mega|Ride"] = 3579.18, ["Mega|Fly|Ride"] = 3318}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2, ["Ride"] = 25, ["Fly|Ride"] = 373.75, ["Neon"] = 8.33, ["Neon|Ride"] = 106.23, ["Neon|Fly|Ride"] = 246.75, ["Mega"] = 74.78, ["Mega|Fly|Ride"] = 1101.53}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 111.25, ["Ride"] = 187.19, ["Fly|Ride"] = 344.57, ["Neon"] = 575, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 754.87, ["Mega|Ride"] = 2442.5, ["Mega|Fly|Ride"] = 1748.75}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.5, ["Fly"] = 39.24, ["Ride"] = 18.99, ["Fly|Ride"] = 89.82, ["Neon"] = 13.96, ["Neon|Fly"] = 50, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 110.43, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 209.77, ["Fly"] = 412.95, ["Ride"] = 300, ["Fly|Ride"] = 405, ["Neon"] = 1135.6, ["Neon|Ride"] = 1362.72, ["Neon|Fly|Ride"] = 1308, ["Mega|Fly|Ride"] = 4672.26}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2, ["Fly"] = 73.5, ["Ride"] = 18.75, ["Fly|Ride"] = 214.76, ["Neon"] = 22.72, ["Neon|Ride"] = 51.78, ["Mega"] = 374.99, ["Mega|Fly"] = 345.84, ["Mega|Ride"] = 150}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 25, ["Neon"] = 41.57, ["Neon|Ride"] = 51.41, ["Mega"] = 237.5, ["Mega|Ride"] = 250}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 22.5, ["Fly"] = 50, ["Ride"] = 64.22, ["Fly|Ride"] = 136.28, ["Neon"] = 125, ["Neon|Fly"] = 412.95, ["Neon|Ride"] = 118.75, ["Neon|Fly|Ride"] = 250, ["Mega"] = 746.4, ["Mega|Ride"] = 687.5, ["Mega|Fly|Ride"] = 1000}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2, ["Ride"] = 47.39, ["Neon"] = 20.66, ["Neon|Ride"] = 187.5, ["Mega"] = 233.63, ["Mega|Ride"] = 244.94, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2, ["Fly"] = 15.31, ["Ride"] = 14.4, ["Fly|Ride"] = 37.39, ["Neon"] = 2.42, ["Neon|Fly"] = 19.7, ["Neon|Ride"] = 24.99, ["Neon|Fly|Ride"] = 43.75, ["Mega"] = 27.88, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 92.59}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5161.78, ["Ride"] = 4248.75, ["Fly|Ride"] = 4362.5, ["Neon"] = 30970.62, ["Neon|Fly|Ride"] = 18720.72, ["Mega|Fly|Ride"] = 50000}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.99, ["Fly"] = 82.6, ["Ride"] = 39.91, ["Neon"] = 82.26, ["Neon|Fly"] = 367.53, ["Neon|Ride"] = 101.24, ["Neon|Fly|Ride"] = 150, ["Mega"] = 200, ["Mega|Ride"] = 204.9, ["Mega|Fly|Ride"] = 404.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2, ["Fly"] = 23.52, ["Ride"] = 18.75, ["Fly|Ride"] = 43.73, ["Neon"] = 14.82, ["Neon|Fly"] = 43.74, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 125, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 230.64}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 434.9, ["Fly"] = 521.68, ["Ride"] = 495, ["Fly|Ride"] = 539.55, ["Neon"] = 2000, ["Neon|Ride"] = 1231.25, ["Neon|Fly|Ride"] = 1323.75, ["Mega|Fly|Ride"] = 4641.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.75, ["Ride"] = 46.73, ["Neon"] = 13.19, ["Neon|Ride"] = 277.5, ["Mega"] = 135.24, ["Mega|Fly|Ride"] = 660}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.91, ["Fly"] = 18.75, ["Ride"] = 125, ["Neon"] = 31.25, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 218.75, ["Mega"] = 390.14, ["Mega|Ride"] = 344.82}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2, ["Fly"] = 48.75, ["Ride"] = 18.6, ["Fly|Ride"] = 62.49, ["Neon"] = 5.73, ["Neon|Fly"] = 118.75, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 87.37, ["Mega"] = 51.48, ["Mega|Ride"] = 73.75, ["Mega|Fly|Ride"] = 146.61}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 609.98, ["Fly"] = 840.34, ["Ride"] = 688, ["Fly|Ride"] = 712.5, ["Neon|Ride"] = 2025, ["Neon|Fly|Ride"] = 1999.99}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 10.99, ["Fly"] = 97.05, ["Ride"] = 74.22, ["Fly|Ride"] = 297.87, ["Neon"] = 36.23, ["Neon|Fly"] = 312.49, ["Neon|Ride"] = 114.99, ["Neon|Fly|Ride"] = 179.63, ["Mega"] = 250, ["Mega|Fly"] = 412.95, ["Mega|Ride"] = 220.93, ["Mega|Fly|Ride"] = 369.59}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 12.49, ["Fly"] = 225, ["Ride"] = 36.25, ["Fly|Ride"] = 123.81, ["Neon"] = 22.49, ["Neon|Ride"] = 56.24, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 160, ["Mega|Fly"] = 779.11, ["Mega|Ride"] = 172.49, ["Mega|Fly|Ride"] = 282.95}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2, ["Fly"] = 32.5, ["Ride"] = 16.25, ["Fly|Ride"] = 39.97, ["Neon"] = 16.25, ["Neon|Fly"] = 190, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 79.01, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 228.35}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20, ["Fly"] = 37.5, ["Ride"] = 35, ["Fly|Ride"] = 59.37, ["Neon"] = 112, ["Neon|Ride"] = 108.74, ["Mega"] = 825.89, ["Mega|Ride"] = 584.04, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2, ["Ride"] = 41.24, ["Fly|Ride"] = 78.27, ["Neon"] = 3.34, ["Neon|Ride"] = 136.25, ["Neon|Fly|Ride"] = 198.75, ["Mega"] = 30.83, ["Mega|Fly"] = 140.18, ["Mega|Ride"] = 87.49, ["Mega|Fly|Ride"] = 300}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 548.44, ["Fly"] = 680.33, ["Ride"] = 600.18, ["Fly|Ride"] = 750, ["Neon"] = 2466.25, ["Neon|Ride"] = 2203.05, ["Neon|Fly|Ride"] = 2277.5, ["Mega|Ride"] = 9110.89, ["Mega|Fly|Ride"] = 7487.5}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.31, ["Ride"] = 67, ["Fly|Ride"] = 250, ["Neon"] = 8.27, ["Neon|Ride"] = 67.49, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 55.76, ["Mega|Ride"] = 174.99, ["Mega|Fly|Ride"] = 303.17}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2, ["Ride"] = 47.1, ["Neon"] = 4.14, ["Neon|Fly"] = 234.35, ["Neon|Ride"] = 210.26, ["Neon|Fly|Ride"] = 250, ["Mega"] = 41.74, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2, ["Ride"] = 57.57, ["Neon"] = 4.33, ["Neon|Ride"] = 53.49, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 41.3, ["Mega|Fly"] = 152.79, ["Mega|Ride"] = 120.9, ["Mega|Fly|Ride"] = 205.45}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.25, ["Ride"] = 25, ["Neon"] = 7.5, ["Neon|Ride"] = 46.64, ["Mega"] = 226.09, ["Mega|Ride"] = 312.5}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 19.9, ["Fly"] = 68.75, ["Ride"] = 56.91, ["Fly|Ride"] = 197.5, ["Neon"] = 98.98, ["Neon|Fly"] = 265.16, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 374.99, ["Mega"] = 487.5, ["Mega|Ride"] = 485.77, ["Mega|Fly|Ride"] = 543.95}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 11.46, ["Ride"] = 62.41, ["Fly|Ride"] = 148.67, ["Neon"] = 82.29, ["Neon|Ride"] = 109.37, ["Neon|Fly|Ride"] = 270, ["Mega"] = 525, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 548.32}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2, ["Fly"] = 19.39, ["Ride"] = 16.14, ["Fly|Ride"] = 45.57, ["Neon"] = 33.88, ["Neon|Fly"] = 40.89, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 82.48, ["Mega"] = 284.38, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 228.16}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.65, ["Ride"] = 74.98, ["Fly|Ride"] = 137.84, ["Neon"] = 33.98, ["Neon|Ride"] = 87.5, ["Mega"] = 179.63, ["Mega|Ride"] = 536.84}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2, ["Ride"] = 24.92, ["Fly|Ride"] = 104.28, ["Neon"] = 9.59, ["Neon|Ride"] = 49.56, ["Neon|Fly|Ride"] = 121.27, ["Mega"] = 56.25, ["Mega|Ride"] = 110.47, ["Mega|Fly|Ride"] = 242.61}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.28, ["Fly"] = 109.81, ["Ride"] = 22.57, ["Fly|Ride"] = 51.25, ["Neon"] = 105, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 202.35, ["Mega"] = 750, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 31.83, ["Fly"] = 832.5, ["Neon"] = 125, ["Mega"] = 316.25, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 47.5, ["Fly"] = 82.5, ["Ride"] = 67.2, ["Fly|Ride"] = 122.5, ["Neon"] = 251.05, ["Neon|Ride"] = 299.16, ["Neon|Fly|Ride"] = 416.05, ["Mega"] = 1867.74, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 29.72, ["Fly"] = 138.35, ["Ride"] = 36.25, ["Fly|Ride"] = 212.5, ["Neon"] = 119.59, ["Neon|Ride"] = 160, ["Neon|Fly|Ride"] = 300, ["Mega"] = 596.5, ["Mega|Ride"] = 1930, ["Mega|Fly|Ride"] = 907.45}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.7, ["Ride"] = 35.11, ["Neon"] = 132.5, ["Neon|Ride"] = 212.49, ["Mega"] = 578.13, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 780.48}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 26.1, ["Fly"] = 77.84, ["Ride"] = 77.43, ["Fly|Ride"] = 137.5, ["Neon"] = 138.35, ["Neon|Fly"] = 304.56, ["Neon|Ride"] = 260.68, ["Neon|Fly|Ride"] = 445.88, ["Mega"] = 654.68, ["Mega|Ride"] = 590.84, ["Mega|Fly|Ride"] = 676.4}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2, ["Fly"] = 17.99, ["Ride"] = 14.9, ["Fly|Ride"] = 31.23, ["Neon"] = 3.98, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 55.38, ["Mega"] = 39.99, ["Mega|Fly"] = 311.88, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 138.13}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1397.82}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 92.45, ["Ride"] = 192.02, ["Fly|Ride"] = 356.25, ["Neon"] = 412.7, ["Neon|Ride"] = 486.25, ["Neon|Fly|Ride"] = 619.42, ["Mega"] = 1500, ["Mega|Ride"] = 1542.35, ["Mega|Fly|Ride"] = 1377.18}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 72.93, ["Neon"] = 2.38, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 288.85, ["Mega"] = 34.8, ["Mega|Ride"] = 63.08}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26, ["Ride"] = 46.68, ["Fly|Ride"] = 206.48, ["Neon"] = 112.5, ["Neon|Ride"] = 124.9, ["Neon|Fly|Ride"] = 518.75, ["Mega"] = 563.74, ["Mega|Ride"] = 494.18, ["Mega|Fly|Ride"] = 622.49}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2, ["Neon"] = 3.71, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 23.75}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2, ["Ride"] = 71.25, ["Neon"] = 3.75, ["Mega"] = 21.25, ["Mega|Ride"] = 102.05, ["Mega|Fly|Ride"] = 260}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 77.57, ["Fly"] = 1250, ["Ride"] = 136.63, ["Fly|Ride"] = 250, ["Neon"] = 623.75, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 475, ["Mega|Ride"] = 6424.35, ["Mega|Fly|Ride"] = 1941.86}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2, ["Fly"] = 86.25, ["Ride"] = 20.65, ["Fly|Ride"] = 94.08, ["Neon"] = 4.89, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 30.74, ["Neon|Fly|Ride"] = 81.25, ["Mega"] = 87.5, ["Mega|Ride"] = 112.48, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2, ["Fly"] = 36.25, ["Fly|Ride"] = 61.25, ["Neon"] = 4.42, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 399.9, ["Mega"] = 31.24, ["Mega|Ride"] = 123, ["Mega|Fly|Ride"] = 207.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.47, ["Ride"] = 68.17, ["Neon"] = 14.79, ["Neon|Fly"] = 250, ["Neon|Ride"] = 219.8, ["Mega"] = 125, ["Mega|Ride"] = 165.19, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2, ["Ride"] = 125, ["Neon"] = 11.14, ["Neon|Ride"] = 131.25, ["Mega"] = 98.75}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 93.75, ["Ride"] = 311.88, ["Fly|Ride"] = 344.82, ["Neon"] = 393.75, ["Neon|Fly|Ride"] = 623.75, ["Mega|Ride"] = 2064.71, ["Mega|Fly|Ride"] = 2739.88}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 9.72, ["Ride"] = 33.04, ["Neon"] = 50.24, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 398.15, ["Mega|Ride"] = 348.75, ["Mega|Fly|Ride"] = 614.99}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 349.98, ["Ride"] = 406.97, ["Fly|Ride"] = 685.5, ["Neon"] = 1018.75, ["Neon|Ride"] = 1000, ["Neon|Fly|Ride"] = 1000, ["Mega|Fly|Ride"] = 3187.49}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 91.2}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 53.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 30}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 30.99}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 48.47}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 111.21}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 181.23}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.5}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 50}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 23.75}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.36}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 899.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.23}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 12.4}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.14}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 29.68}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 712.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 440}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.58}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1404.6}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 49.9}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.63}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.5}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 23.5}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 26.05}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 56.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.99}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.49}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 22.72}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.04}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 25}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.02}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 100}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 12.97}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.24}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2900}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 79.42}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 235.55}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.66}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.24}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 22.49}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 21.89}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 29.09}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 187.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.61}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 141.17}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 47.03}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 8.75}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 29.97}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.9}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.46}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 100}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 29.38}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.29}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 18.25}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 35.1}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.55}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.5}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 88.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 247.48}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.5}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.5}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 300.84}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 23.18}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 87.5}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.59}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23244.44}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 118.74}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 33.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.83}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 55}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.67}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 35.62}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 86.9}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 87.5}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 27.92}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 98.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 411.21}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42.32}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 31.25}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 230.52}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 12.25}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.75}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.38}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 22.39}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 124.9}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.37}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.15}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 18.75}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 198.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 791.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.63}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 587.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.24}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 212.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 29.71}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 94.89}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 18.74}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 29.99}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 62.39}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.61}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.72}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.74}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 8.64}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.24}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.09}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.49}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.79}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.99}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 170.8}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 49.6}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 162.5}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 24.41}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 25}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 11.37}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 22.39}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 20}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.75}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.5}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.49}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.14}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 41.24}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.68}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.25}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.75}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 7.5}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 34.75}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.25}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 8.75}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.62}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.31}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7500}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.4}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.51}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.08}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.28}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.03}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.03}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 15}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 10.18}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.19}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.99}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.75}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 8.75}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 38.29}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 10.33}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.75}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.48}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.64}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.5}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3750}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.54}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 37.5}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.78}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 68.9}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.25}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.99}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 123.75}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.14}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 4.12}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 43.75}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.75}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.72}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.4}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.25}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.25}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 275294.71}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 2.9}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.62}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.42}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.4}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.68}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.25}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 6.64}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 111.15}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 84.67}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 17.5}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1229.9}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 62.45}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 18.75}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 34.79}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.5}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.47}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 15.5}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 50}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.64}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.8}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.46}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.75}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 7.39}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.75}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 26.13}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.75}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.65}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.25}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 61.91}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 12.5}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.9}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 370.13}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 87.5}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 12.74}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.75}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.75}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 23.75}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 21.13}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.75}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.03}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.2}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.65}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 119.88}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.19}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 153.73}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.15}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 966.25}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.5}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.64}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.44}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.26}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 44.44}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.25}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.75}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.93}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 77.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.29}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 45.62}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.75}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.15}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.39}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 54.91}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 102.48}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 58.38}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.31}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.75}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 17.27}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 107.5}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.14}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 5.21}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 82.39}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.44}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.69}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 50.17}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 62.5}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 51.24}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 123.75}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 6}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 206.48}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 14.81}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.71}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 40.69}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 56.25}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.08}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 27.5}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.18}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.43}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.5}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.84}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 29.4}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.11}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 37.5}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.75}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.2}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 27.47}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.13}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 27.21}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 90}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 59.19}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 23.75}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1899.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 17.53}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.19}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 23.67}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 251.12}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.08}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.65}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 17.05}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 267.49}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 67.49}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.47}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.73}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 48.99}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 173.88}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 76.87}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 812.5}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 175}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.25}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1564.2}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 543.25}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.74}},
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