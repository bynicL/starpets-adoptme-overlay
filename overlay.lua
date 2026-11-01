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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 990.71, ["Ride"] = 1032.79, ["Fly|Ride"] = 1147.9, ["Neon"] = 9625, ["Neon|Ride"] = 3156.82, ["Neon|Fly|Ride"] = 4108.5, ["Mega|Fly|Ride"] = 25822.53}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 518.37, ["Fly"] = 577.5, ["Ride"] = 479.87, ["Fly|Ride"] = 571.27, ["Neon|Fly|Ride"] = 2581.95, ["Mega"] = 10758.05}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5637.5, ["Ride"] = 5307.5, ["Fly|Ride"] = 4582.87, ["Neon|Fly|Ride"] = 20799.61, ["Mega|Fly|Ride"] = 71729.59}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 137.5, ["Ride"] = 192.5, ["Fly|Ride"] = 308.77, ["Neon"] = 810.19, ["Neon|Ride"] = 508.75, ["Neon|Fly|Ride"] = 1147.9, ["Mega"] = 4303.24, ["Mega|Fly|Ride"] = 3025}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 612.56, ["Fly"] = 860.77, ["Ride"] = 577.5, ["Fly|Ride"] = 607.75, ["Neon|Ride"] = 1870, ["Neon|Fly|Ride"] = 1691.75, ["Mega|Fly|Ride"] = 6600}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.63, ["Ride"] = 28.88, ["Fly|Ride"] = 159.24, ["Neon"] = 75.63, ["Neon|Ride"] = 81.4, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 298.85, ["Mega|Ride"] = 274.99, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.12, ["Fly"] = 35.27, ["Ride"] = 32.99, ["Fly|Ride"] = 60.5, ["Neon"] = 34.45, ["Neon|Fly"] = 83.88, ["Neon|Ride"] = 57.4, ["Neon|Fly|Ride"] = 117.36, ["Mega"] = 136.76, ["Mega|Fly"] = 284.28, ["Mega|Ride"] = 165, ["Mega|Fly|Ride"] = 295.63}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 136.66, ["Ride"] = 171.07, ["Fly|Ride"] = 242, ["Neon"] = 580.95, ["Neon|Ride"] = 357.5, ["Neon|Fly|Ride"] = 485.89, ["Mega"] = 1484.63, ["Mega|Fly|Ride"] = 2761.95}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.93, ["Fly"] = 58.11, ["Ride"] = 48.12, ["Fly|Ride"] = 100.83, ["Neon"] = 261.25, ["Neon|Ride"] = 233.75, ["Neon|Fly|Ride"] = 324.33, ["Mega"] = 1435.14, ["Mega|Ride"] = 2860, ["Mega|Fly|Ride"] = 1296.22}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.6, ["Fly"] = 51.2, ["Ride"] = 38.5, ["Fly|Ride"] = 68.75, ["Neon"] = 201.19, ["Neon|Ride"] = 101.15, ["Neon|Fly|Ride"] = 275, ["Mega|Ride"] = 1397.65, ["Mega|Fly|Ride"] = 860.77}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.78, ["Fly"] = 215.88, ["Ride"] = 98.99, ["Fly|Ride"] = 144.17, ["Neon"] = 461.64, ["Neon|Fly"] = 428.23, ["Neon|Ride"] = 287.29, ["Neon|Fly|Ride"] = 275, ["Mega|Fly|Ride"] = 1650.51}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 58.13}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 350.77, ["Fly"] = 413.81, ["Ride"] = 365.79, ["Fly|Ride"] = 405.9, ["Neon"] = 1435.14, ["Neon|Ride"] = 1320.52, ["Neon|Fly|Ride"] = 1144.72, ["Mega|Fly|Ride"] = 5007.44}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 110, ["Fly"] = 142.01, ["Ride"] = 93.38, ["Fly|Ride"] = 187.08, ["Neon|Fly|Ride"] = 550, ["Mega|Fly|Ride"] = 2752.77}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.74, ["Fly"] = 119.42, ["Ride"] = 54.32, ["Fly|Ride"] = 215.18, ["Neon"] = 13.75, ["Neon|Fly"] = 101, ["Neon|Ride"] = 68.74, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 151.25, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 209, ["Mega|Fly|Ride"] = 388.76}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 128.7, ["Fly"] = 151.25, ["Ride"] = 160.88, ["Fly|Ride"] = 225.38, ["Neon"] = 971.85, ["Neon|Ride"] = 495, ["Neon|Fly|Ride"] = 508.75, ["Mega|Fly|Ride"] = 2062.5}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 4.12, ["Fly"] = 27.94, ["Ride"] = 22, ["Fly|Ride"] = 37.67, ["Neon"] = 28.88, ["Neon|Ride"] = 94.69, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 350.63, ["Mega|Ride"] = 342.38, ["Mega|Fly|Ride"] = 347.88}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 82.5, ["Fly"] = 275, ["Ride"] = 139.4, ["Fly|Ride"] = 249.63, ["Neon"] = 359.34, ["Neon|Fly"] = 485.93, ["Neon|Ride"] = 302.49, ["Neon|Fly|Ride"] = 440, ["Mega"] = 1564.24, ["Mega|Ride"] = 825, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.39}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 47.36, ["Ride"] = 101.15, ["Fly|Ride"] = 267.45, ["Neon"] = 605, ["Neon|Fly|Ride"] = 2475}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.71, ["Fly"] = 36.13, ["Ride"] = 41.31, ["Fly|Ride"] = 233.75, ["Neon"] = 213.02, ["Neon|Ride"] = 101.15, ["Neon|Fly|Ride"] = 258.21, ["Mega|Ride"] = 600.4, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 44.73, ["Fly"] = 129.99, ["Ride"] = 57.61, ["Fly|Ride"] = 108.63, ["Neon"] = 250.3, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 261.25, ["Mega"] = 1700.54, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55, ["Fly"] = 287.26, ["Ride"] = 129.99, ["Fly|Ride"] = 143, ["Neon"] = 214.5, ["Neon|Fly"] = 403.33, ["Neon|Ride"] = 282.99, ["Neon|Fly|Ride"] = 320.61, ["Mega"] = 1117.78, ["Mega|Ride"] = 1286.84, ["Mega|Fly|Ride"] = 1031.25}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 41.25, ["Ride"] = 41.97, ["Fly|Ride"] = 137.5, ["Neon"] = 359.33, ["Neon|Ride"] = 330, ["Neon|Fly|Ride"] = 330, ["Mega"] = 804.71, ["Mega|Ride"] = 2149.73, ["Mega|Fly|Ride"] = 1072.5}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 48.61, ["Fly"] = 143.26, ["Ride"] = 68.75, ["Fly|Ride"] = 153.06, ["Neon"] = 220, ["Neon|Fly"] = 575.65, ["Neon|Ride"] = 308.54, ["Neon|Fly|Ride"] = 384.87, ["Mega|Ride"] = 1178.38, ["Mega|Fly|Ride"] = 988.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.19, ["Fly"] = 31.6, ["Ride"] = 20.63, ["Fly|Ride"] = 59.13, ["Neon"] = 28.88, ["Neon|Fly"] = 109.99, ["Neon|Ride"] = 46.51, ["Neon|Fly|Ride"] = 96.24, ["Mega"] = 152.63, ["Mega|Fly"] = 23495, ["Mega|Ride"] = 187, ["Mega|Fly|Ride"] = 312.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 412.5, ["Ride"] = 412.97, ["Fly|Ride"] = 463.38, ["Neon|Ride"] = 1769.62, ["Neon|Fly|Ride"] = 1760, ["Mega|Fly|Ride"] = 7414}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.15, ["Ride"] = 33.99, ["Fly|Ride"] = 112.45, ["Neon"] = 229.63, ["Neon|Fly|Ride"] = 438.94, ["Mega|Fly|Ride"] = 955.45}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.07, ["Fly"] = 41.77, ["Ride"] = 29.07, ["Fly|Ride"] = 55.99, ["Neon"] = 53.5, ["Neon|Fly"] = 94.69, ["Neon|Ride"] = 83.95, ["Neon|Fly|Ride"] = 129.11, ["Mega|Fly"] = 330.32, ["Mega|Ride"] = 648.73, ["Mega|Fly|Ride"] = 428.23}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 105.7, ["Fly"] = 114.13, ["Ride"] = 108.63, ["Fly|Ride"] = 129.17, ["Neon|Fly"] = 474.5, ["Neon|Ride"] = 404.12, ["Neon|Fly|Ride"] = 385, ["Mega"] = 2147.33, ["Mega|Ride"] = 7638.13, ["Mega|Fly|Ride"] = 2085.63}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 16.15, ["Ride"] = 29.07, ["Fly|Ride"] = 78.8, ["Neon"] = 158.4, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 169.13, ["Mega"] = 728.81, ["Mega|Ride"] = 816.66, ["Mega|Fly|Ride"] = 506}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 228.11, ["Fly"] = 363.63, ["Ride"] = 250.23, ["Fly|Ride"] = 272.42, ["Neon"] = 728.81, ["Neon|Ride"] = 687.5, ["Neon|Fly|Ride"] = 919.82, ["Mega"] = 6454.84, ["Mega|Ride"] = 3025, ["Mega|Fly|Ride"] = 3001.88}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 37.67}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.01, ["Fly"] = 37.67, ["Ride"] = 23.68, ["Fly|Ride"] = 67.38, ["Neon"] = 23.38, ["Neon|Fly"] = 5111.98, ["Neon|Ride"] = 48.13, ["Neon|Fly|Ride"] = 150.64, ["Mega"] = 165, ["Mega|Fly"] = 359.39, ["Mega|Ride"] = 258.25, ["Mega|Fly|Ride"] = 291.57}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1549.37, ["Fly"] = 2750, ["Ride"] = 1237.5, ["Fly|Ride"] = 1375, ["Neon"] = 7499.25, ["Neon|Ride"] = 6187.5, ["Neon|Fly|Ride"] = 7638.13, ["Mega|Ride"] = 54666.34, ["Mega|Fly|Ride"] = 27113.65}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11, ["Fly"] = 71.01, ["Ride"] = 34.36, ["Fly|Ride"] = 137.5, ["Neon"] = 81.13, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 532.54, ["Mega|Ride"] = 688.62, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 120.89, ["Ride"] = 159.5, ["Fly|Ride"] = 261.25, ["Neon"] = 932.73, ["Neon|Ride"] = 788.02, ["Neon|Fly|Ride"] = 832.68, ["Mega|Ride"] = 3055.68, ["Mega|Fly|Ride"] = 2726.44}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.63, ["Fly"] = 72.12, ["Ride"] = 54.77, ["Fly|Ride"] = 144.17, ["Neon"] = 85.21, ["Neon|Ride"] = 162.78, ["Neon|Fly|Ride"] = 301.26, ["Mega"] = 702.85, ["Mega|Fly|Ride"] = 761.7}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 116.25, ["Ride"] = 110, ["Fly|Ride"] = 206.25, ["Neon"] = 611.88, ["Neon|Ride"] = 523.93, ["Neon|Fly|Ride"] = 730.48, ["Mega|Fly|Ride"] = 2151.89}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 116.36, ["Ride"] = 159.5, ["Fly|Ride"] = 203.5, ["Neon"] = 451.85, ["Neon|Ride"] = 382.25, ["Neon|Fly|Ride"] = 550, ["Mega|Ride"] = 1581.24, ["Mega|Fly|Ride"] = 1863.55}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 55}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 67.38, ["Fly"] = 61.98, ["Ride"] = 54.65, ["Fly|Ride"] = 81.58, ["Neon"] = 645.51, ["Neon|Ride"] = 413, ["Neon|Fly|Ride"] = 306.41, ["Mega"] = 4303.24, ["Mega|Fly|Ride"] = 1581.25}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.28, ["Ride"] = 41.31, ["Fly|Ride"] = 137.5, ["Neon"] = 34.38, ["Neon|Ride"] = 129.54, ["Neon|Fly|Ride"] = 242.07, ["Mega"] = 173.98, ["Mega|Fly"] = 280.5, ["Mega|Ride"] = 284.07, ["Mega|Fly|Ride"] = 429}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 398.75, ["Fly"] = 446.88, ["Ride"] = 479.02, ["Fly|Ride"] = 522.06, ["Neon|Ride"] = 1782.14, ["Neon|Fly|Ride"] = 1536.25, ["Mega|Fly|Ride"] = 6572.5}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 105.46, ["Fly"] = 137.5, ["Ride"] = 96.25, ["Fly|Ride"] = 165, ["Neon"] = 467.5, ["Neon|Ride"] = 510.01, ["Neon|Fly|Ride"] = 545.45, ["Mega|Ride"] = 2568.27, ["Mega|Fly|Ride"] = 2062.5}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3887.4, ["Ride"] = 3597, ["Fly|Ride"] = 3849.99, ["Neon|Fly|Ride"] = 15060.2}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42.79, ["Fly"] = 114.05, ["Ride"] = 60.5, ["Fly|Ride"] = 96.25, ["Neon"] = 412.5, ["Neon|Ride"] = 287.29, ["Neon|Fly|Ride"] = 317.38, ["Mega|Ride"] = 1235.19, ["Mega|Fly|Ride"] = 1433.16}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 64.7, ["Ride"] = 72.09, ["Fly|Ride"] = 144.17, ["Neon"] = 606.14, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 717.58, ["Mega"] = 2438.87, ["Mega|Fly|Ride"] = 1740.89}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.5, ["Fly"] = 90.75, ["Ride"] = 45.71, ["Fly|Ride"] = 96.45, ["Neon"] = 168.28, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 230.63, ["Mega"] = 2750, ["Mega|Ride"] = 860.09, ["Mega|Fly|Ride"] = 614.63}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.63}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 48.13, ["Ride"] = 61.97, ["Fly|Ride"] = 75.02, ["Neon"] = 343.75, ["Neon|Ride"] = 550, ["Neon|Fly|Ride"] = 568.04, ["Mega|Fly|Ride"] = 1564.75}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 44}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 206.6, ["Ride"] = 201.19, ["Fly|Ride"] = 258.21, ["Neon|Ride"] = 1435.32, ["Neon|Fly|Ride"] = 2330.13, ["Mega|Fly|Ride"] = 5183.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 962.5, ["Ride"] = 983.13, ["Fly|Ride"] = 1095.6, ["Neon|Ride"] = 3443.03, ["Neon|Fly|Ride"] = 3704.72}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.75}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.76, ["Fly"] = 65.61, ["Ride"] = 40.83, ["Fly|Ride"] = 72.09, ["Neon"] = 187, ["Neon|Ride"] = 178.75, ["Neon|Fly|Ride"] = 178.75, ["Mega|Ride"] = 903.8, ["Mega|Fly|Ride"] = 891.69}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6584.75, ["Ride"] = 5738.35, ["Fly|Ride"] = 4807, ["Neon|Fly|Ride"] = 11343.2, ["Mega|Fly|Ride"] = 33714.53}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.99, ["Fly"] = 78.25, ["Ride"] = 36.46, ["Fly|Ride"] = 43.05, ["Neon"] = 101.97, ["Neon|Ride"] = 107.6, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 664.44, ["Mega|Ride"] = 717.67, ["Mega|Fly|Ride"] = 625.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 9.32, ["Fly"] = 43.06, ["Ride"] = 37.13, ["Fly|Ride"] = 115.12, ["Neon"] = 116.88, ["Neon|Ride"] = 138.88, ["Neon|Fly|Ride"] = 256.06, ["Mega"] = 1081.05, ["Mega|Ride"] = 525.08, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 99, ["Fly"] = 68.75, ["Ride"] = 96.23, ["Fly|Ride"] = 93.5, ["Neon"] = 1435.14, ["Neon|Fly|Ride"] = 971.74, ["Mega"] = 4303.24}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.38, ["Ride"] = 28.88, ["Fly|Ride"] = 111.9, ["Neon"] = 97.63, ["Neon|Ride"] = 66.71, ["Neon|Fly|Ride"] = 525.24, ["Mega"] = 501.34, ["Mega|Ride"] = 488.49, ["Mega|Fly|Ride"] = 648.73}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2062.39, ["Fly"] = 1925, ["Ride"] = 2296.07, ["Fly|Ride"] = 2015.06, ["Neon|Fly|Ride"] = 4141.5, ["Mega|Fly|Ride"] = 13750}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30800, ["Fly"] = 27500, ["Ride"] = 29979.45, ["Fly|Ride"] = 25368.75, ["Neon|Ride"] = 68750, ["Neon|Fly|Ride"] = 71003.08, ["Mega"] = 220000, ["Mega|Fly|Ride"] = 192500}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.24, ["Fly"] = 165, ["Ride"] = 52.23, ["Fly|Ride"] = 94.21, ["Neon"] = 141.35, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 860.67, ["Mega|Ride"] = 715, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4, ["Fly"] = 49.5, ["Ride"] = 43.05, ["Fly|Ride"] = 192.5, ["Neon"] = 17.88, ["Neon|Fly"] = 101.16, ["Neon|Ride"] = 58.11, ["Neon|Fly|Ride"] = 154.98, ["Mega"] = 134.75, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 287.29}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 40.83}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.8, ["Ride"] = 38.5, ["Fly|Ride"] = 116.88, ["Neon"] = 55, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 485.27, ["Mega"] = 359.33, ["Mega|Ride"] = 320.38, ["Mega|Fly|Ride"] = 571.32}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 774.69, ["Ride"] = 715, ["Fly|Ride"] = 825, ["Neon|Ride"] = 3037.04, ["Neon|Fly|Ride"] = 2708.7, ["Mega|Fly|Ride"] = 11339.02}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1045, ["Fly"] = 1007.88, ["Ride"] = 898.29, ["Fly|Ride"] = 935, ["Neon"] = 4303.24, ["Neon|Ride"] = 3515.23, ["Neon|Fly|Ride"] = 3257.37, ["Mega|Fly|Ride"] = 11734.2}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.68, ["Fly"] = 121.49, ["Ride"] = 43.76, ["Fly|Ride"] = 103.13, ["Neon"] = 105.88, ["Neon|Ride"] = 144.17, ["Neon|Fly|Ride"] = 210.87, ["Mega"] = 1075.96, ["Mega|Ride"] = 717.75, ["Mega|Fly|Ride"] = 1650}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 30.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 64.66, ["Fly"] = 97.63, ["Ride"] = 86.26, ["Fly|Ride"] = 134.92, ["Neon|Ride"] = 402.42, ["Neon|Fly|Ride"] = 357.5, ["Mega|Ride"] = 2106.7, ["Mega|Fly|Ride"] = 2009.87}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 64.53, ["Ride"] = 67.37, ["Fly|Ride"] = 239.25, ["Neon"] = 344.28, ["Neon|Fly"] = 553.04, ["Neon|Ride"] = 408.82, ["Neon|Fly|Ride"] = 514.98, ["Mega"] = 1807.37, ["Mega|Fly|Ride"] = 1796.85}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.09, ["Fly"] = 49.5, ["Ride"] = 20.95, ["Fly|Ride"] = 72.09, ["Neon"] = 41.25, ["Neon|Fly"] = 550, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 247.5, ["Mega|Ride"] = 302.5, ["Mega|Fly|Ride"] = 379.5}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 102.1, ["Fly"] = 132, ["Ride"] = 89.38, ["Fly|Ride"] = 159.5, ["Neon"] = 528.24, ["Neon|Ride"] = 430.34, ["Neon|Fly|Ride"] = 343.74, ["Mega|Fly|Ride"] = 1491.87}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.2, ["Ride"] = 27.5, ["Fly|Ride"] = 101.75, ["Neon"] = 47.35, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 213.13, ["Mega|Ride"] = 962.5}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.43, ["Fly"] = 42.2, ["Ride"] = 35.24, ["Fly|Ride"] = 102.22, ["Neon"] = 107.6, ["Neon|Fly"] = 107.61, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 179.78, ["Mega"] = 760.6, ["Mega|Fly|Ride"] = 763.13}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 27.49, ["Ride"] = 65.61, ["Fly|Ride"] = 163.63, ["Neon"] = 257.13, ["Neon|Ride"] = 172.15, ["Mega"] = 727.31, ["Mega|Ride"] = 846.77, ["Mega|Fly|Ride"] = 903.8}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.75, ["Fly"] = 137.02, ["Ride"] = 36.59, ["Fly|Ride"] = 101.15, ["Neon"] = 96.25, ["Neon|Fly"] = 574.57, ["Neon|Ride"] = 111.78, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 858.5, ["Mega|Fly|Ride"] = 992.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6993.62, ["Fly"] = 7173.29, ["Ride"] = 7481.38, ["Fly|Ride"] = 5458.75, ["Neon"] = 32274.14, ["Neon|Fly|Ride"] = 28401.25}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 247.49, ["Fly"] = 258.21, ["Ride"] = 230.23, ["Fly|Ride"] = 300.21, ["Neon"] = 810.19, ["Neon|Ride"] = 728.9, ["Neon|Fly|Ride"] = 618.73, ["Mega|Ride"] = 5739.08, ["Mega|Fly|Ride"] = 2194.14}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 40.26, ["Fly"] = 144.17, ["Ride"] = 67.38, ["Fly|Ride"] = 142.53, ["Neon"] = 115.2, ["Neon|Fly"] = 191.53, ["Neon|Ride"] = 122.38, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 398.17, ["Mega|Fly"] = 574.57, ["Mega|Ride"] = 384.99, ["Mega|Fly|Ride"] = 490.96}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.44, ["Ride"] = 21.53, ["Fly|Ride"] = 101.15, ["Neon"] = 23.15, ["Neon|Ride"] = 58.11, ["Neon|Fly|Ride"] = 195.8, ["Mega"] = 523.6, ["Mega|Ride"] = 196.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.47, ["Fly"] = 5506.04, ["Ride"] = 99.02, ["Fly|Ride"] = 137.5, ["Neon"] = 159.24, ["Neon|Fly"] = 342.17, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 324.33, ["Mega"] = 442.69, ["Mega|Ride"] = 537.99, ["Mega|Fly|Ride"] = 612.57}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14492.5, ["Ride"] = 13062.5, ["Fly|Ride"] = 12443.75, ["Neon|Fly|Ride"] = 28018.47}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 185.63, ["Fly"] = 287.26, ["Ride"] = 228.91, ["Fly|Ride"] = 244.75, ["Neon"] = 1474.05, ["Neon|Ride"] = 1578.22, ["Neon|Fly|Ride"] = 1501.85, ["Mega|Fly|Ride"] = 4862.18}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 63.25, ["Fly"] = 124.69, ["Ride"] = 67.38, ["Fly|Ride"] = 119.05, ["Neon|Ride"] = 330, ["Neon|Fly|Ride"] = 400.13, ["Mega|Fly|Ride"] = 2423.03}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.54, ["Fly"] = 29.89, ["Ride"] = 21.53, ["Fly|Ride"] = 62.41, ["Neon"] = 79.63, ["Neon|Ride"] = 72.11, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 2581.95, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 385, ["Fly"] = 510.17, ["Ride"] = 398.75, ["Fly|Ride"] = 485.89, ["Neon"] = 1717.38, ["Neon|Ride"] = 1512.5, ["Neon|Fly|Ride"] = 1581.25, ["Mega|Ride"] = 4812.5, ["Mega|Fly|Ride"] = 5171.37}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.88, ["Ride"] = 38.5, ["Neon"] = 29.07, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 227.15, ["Mega"] = 136.13, ["Mega|Ride"] = 171.87, ["Mega|Fly|Ride"] = 329.26}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 215.2, ["Ride"] = 243.14, ["Fly|Ride"] = 304.9, ["Neon"] = 1074.74, ["Neon|Ride"] = 1237.5, ["Neon|Fly|Ride"] = 1098.63, ["Mega|Fly|Ride"] = 5739.08}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.62, ["Fly"] = 18.24, ["Ride"] = 17.88, ["Fly|Ride"] = 36.73, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 103.13, ["Mega"] = 2581.95, ["Mega|Fly|Ride"] = 715}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.76}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 55, ["Ride"] = 90.75, ["Fly|Ride"] = 550, ["Neon"] = 342.17, ["Neon|Ride"] = 330, ["Neon|Fly|Ride"] = 3228.5, ["Mega"] = 1183.41, ["Mega|Ride"] = 1291.14, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.73, ["Fly"] = 68.75, ["Ride"] = 41.24, ["Fly|Ride"] = 90.63, ["Neon"] = 79.63, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 532.54, ["Mega|Ride"] = 643.43, ["Mega|Fly|Ride"] = 572}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 20.5}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 29.07, ["Fly"] = 116.88, ["Ride"] = 95.31, ["Fly|Ride"] = 324.33, ["Neon"] = 248.88, ["Neon|Ride"] = 270.85, ["Neon|Fly|Ride"] = 357.5, ["Mega"] = 860.67, ["Mega|Ride"] = 962.98, ["Mega|Fly|Ride"] = 858.62}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.43, ["Ride"] = 30.62, ["Fly|Ride"] = 138.49, ["Neon"] = 27.5, ["Neon|Ride"] = 109.34, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 136.13, ["Mega|Fly|Ride"] = 484.7}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 17.88, ["Fly"] = 46.75, ["Ride"] = 29.07, ["Fly|Ride"] = 81.13, ["Neon|Ride"] = 138.88, ["Neon|Fly|Ride"] = 228.09, ["Mega|Ride"] = 559.51, ["Mega|Fly|Ride"] = 839.25}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 330.18, ["Ride"] = 402.53, ["Fly|Ride"] = 429.41, ["Neon|Fly|Ride"] = 2726.1, ["Mega|Fly|Ride"] = 9037.89}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.19, ["Fly"] = 107.6, ["Ride"] = 48.13, ["Fly|Ride"] = 108.61, ["Neon"] = 193.15, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 244.22, ["Mega"] = 744.47, ["Mega|Ride"] = 713.9, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44, ["Fly"] = 97, ["Ride"] = 75.61, ["Fly|Ride"] = 157.92, ["Neon"] = 474.45, ["Neon|Ride"] = 237.75, ["Neon|Fly|Ride"] = 247.5, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 29.84, ["Fly"] = 82.5, ["Ride"] = 68.75, ["Fly|Ride"] = 150.64, ["Neon"] = 132, ["Neon|Ride"] = 176.46, ["Neon|Fly|Ride"] = 322.77, ["Mega"] = 357.5, ["Mega|Ride"] = 415.25, ["Mega|Fly|Ride"] = 470.57}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11825, ["Fly"] = 9026.75, ["Ride"] = 10471.89, ["Fly|Ride"] = 8250, ["Neon|Fly|Ride"] = 16237.35, ["Mega|Fly|Ride"] = 41248.63}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1581.25, ["Fly"] = 1943.46, ["Ride"] = 1581.25, ["Fly|Ride"] = 1610.31, ["Neon|Fly|Ride"] = 4180, ["Mega"] = 22951.22, ["Mega|Fly|Ride"] = 15812.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 501.88, ["Ride"] = 474.45, ["Fly|Ride"] = 550, ["Neon"] = 3960, ["Neon|Fly|Ride"] = 2295.78, ["Mega|Fly|Ride"] = 6983.94}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 16.15, ["Fly"] = 24.74, ["Ride"] = 23.38, ["Fly|Ride"] = 48.6, ["Neon"] = 113.96, ["Neon|Ride"] = 114.06, ["Neon|Fly|Ride"] = 172.15, ["Mega|Fly|Ride"] = 495}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.62, ["Fly"] = 82.49, ["Ride"] = 58.11, ["Fly|Ride"] = 129.11, ["Neon"] = 30.25, ["Neon|Ride"] = 71.03, ["Neon|Fly|Ride"] = 154, ["Mega"] = 174.41, ["Mega|Ride"] = 181.5, ["Mega|Fly|Ride"] = 284.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 43.06, ["Fly"] = 58.11, ["Ride"] = 48.12, ["Fly|Ride"] = 107.96, ["Neon"] = 284.07, ["Neon|Ride"] = 188.3, ["Neon|Fly|Ride"] = 174.08, ["Mega|Fly|Ride"] = 536.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 4.07, ["Fly"] = 24.22, ["Ride"] = 16.5, ["Fly|Ride"] = 43.93, ["Neon"] = 27, ["Neon|Fly"] = 96.24, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 82.49, ["Mega"] = 275, ["Mega|Ride"] = 215.2, ["Mega|Fly|Ride"] = 357.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 302.5, ["Fly"] = 335.5, ["Ride"] = 349.11, ["Fly|Ride"] = 390.5, ["Neon"] = 1231.71, ["Neon|Ride"] = 1370.58, ["Neon|Fly|Ride"] = 1267.75}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.62, ["Fly"] = 62.95, ["Ride"] = 42.44, ["Fly|Ride"] = 79.75, ["Neon"] = 146.36, ["Neon|Fly"] = 430.39, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 227.15, ["Mega|Ride"] = 610.5, ["Mega|Fly|Ride"] = 756.25}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.75, ["Fly"] = 27.88, ["Ride"] = 22.18, ["Fly|Ride"] = 45.19, ["Neon"] = 86.08, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 1650, ["Mega|Ride"] = 647.63, ["Mega|Fly|Ride"] = 446.88}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 572.19, ["Fly"] = 825, ["Ride"] = 429.42, ["Fly|Ride"] = 674.55, ["Neon|Ride"] = 1721.53, ["Neon|Fly|Ride"] = 2429.33, ["Mega|Fly|Ride"] = 9029.63}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1168.75, ["Fly"] = 1457.78, ["Ride"] = 1263.01, ["Fly|Ride"] = 1304.88, ["Neon|Fly|Ride"] = 3740, ["Mega|Fly|Ride"] = 161975.14}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 97.19, ["Fly"] = 129.11, ["Ride"] = 96.25, ["Fly|Ride"] = 123.75, ["Neon"] = 537.92, ["Neon|Ride"] = 1794.68, ["Neon|Fly|Ride"] = 485.89, ["Mega|Ride"] = 2439.17, ["Mega|Fly|Ride"] = 4051.4}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 179.7, ["Fly"] = 172.15, ["Ride"] = 197.54, ["Fly|Ride"] = 251.63, ["Neon"] = 582.99, ["Neon|Ride"] = 717.67, ["Neon|Fly|Ride"] = 550, ["Mega|Ride"] = 9006.25, ["Mega|Fly|Ride"] = 2592.41}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.43, ["Ride"] = 44, ["Fly|Ride"] = 287.26, ["Neon"] = 243.82, ["Neon|Fly"] = 430.39, ["Neon|Ride"] = 285.99, ["Neon|Fly|Ride"] = 403.42, ["Mega"] = 687.5, ["Mega|Ride"] = 1943.7, ["Mega|Fly|Ride"] = 774.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 134.75, ["Ride"] = 215.18, ["Fly|Ride"] = 430.34, ["Neon|Fly|Ride"] = 1360.43, ["Mega|Fly|Ride"] = 4211.75}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1882.15, ["Ride"] = 2592.1, ["Fly|Ride"] = 2228.07, ["Neon|Fly|Ride"] = 8606.45, ["Mega|Fly|Ride"] = 25916.71}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 47.65, ["Ride"] = 68.75, ["Fly|Ride"] = 206.24, ["Neon"] = 536.25, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 360.24, ["Mega"] = 2009.62, ["Mega|Ride"] = 2367.07, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 646.87, ["Fly"] = 832.79, ["Ride"] = 638, ["Fly|Ride"] = 675.02, ["Neon|Ride"] = 1589.5, ["Neon|Fly|Ride"] = 1203.13, ["Mega|Fly|Ride"] = 3254.37}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.06, ["Fly"] = 64.56, ["Ride"] = 48.6, ["Fly|Ride"] = 115.12, ["Neon"] = 344.28, ["Neon|Ride"] = 261.25, ["Neon|Fly|Ride"] = 261.25, ["Mega|Fly|Ride"] = 1220.12}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.67, ["Fly"] = 33.14, ["Ride"] = 23.71, ["Fly|Ride"] = 58.32, ["Neon"] = 28.88, ["Neon|Fly"] = 101.16, ["Neon|Ride"] = 43.84, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 275, ["Mega|Fly"] = 355.07, ["Mega|Ride"] = 215.2, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 45.23, ["Ride"] = 110, ["Fly|Ride"] = 264, ["Neon"] = 275, ["Neon|Ride"] = 501.41, ["Neon|Fly|Ride"] = 645.51, ["Mega|Ride"] = 1435.32, ["Mega|Fly|Ride"] = 860.77}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 701.24, ["Fly"] = 1062.98, ["Ride"] = 750.74, ["Fly|Ride"] = 756.25, ["Neon|Ride"] = 2536.54, ["Neon|Fly|Ride"] = 2131.25, ["Mega|Fly|Ride"] = 8015.76}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 604.99, ["Ride"] = 673.75, ["Fly|Ride"] = 907.5, ["Neon"] = 5379.03, ["Neon|Fly|Ride"] = 3399.55, ["Mega|Fly|Ride"] = 12911.27}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.12, ["Fly"] = 34.38, ["Ride"] = 24.31, ["Fly|Ride"] = 49.52, ["Neon"] = 215.18, ["Neon|Ride"] = 105.45, ["Neon|Fly|Ride"] = 144.17, ["Mega|Fly|Ride"] = 717.67}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.87, ["Ride"] = 24.74, ["Fly|Ride"] = 66.71, ["Neon"] = 75.63, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 143, ["Mega"] = 1004.81, ["Mega|Ride"] = 461.64, ["Mega|Fly|Ride"] = 396.7}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.4, ["Ride"] = 23.09, ["Fly|Ride"] = 116.77, ["Neon"] = 22.88, ["Neon|Fly"] = 324.37, ["Neon|Ride"] = 55.33, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 159.93, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 316.95}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 40.91, ["Fly"] = 72.09, ["Ride"] = 59.12, ["Fly|Ride"] = 107.6, ["Neon"] = 301.24, ["Neon|Ride"] = 220, ["Neon|Fly|Ride"] = 215.18, ["Mega|Fly|Ride"] = 990}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 57.75, ["Ride"] = 107.6, ["Fly|Ride"] = 471.02, ["Neon"] = 430.34, ["Neon|Ride"] = 509.94, ["Neon|Fly|Ride"] = 717.58, ["Mega|Fly|Ride"] = 1428.86}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15, ["Fly"] = 50.88, ["Ride"] = 32.81, ["Fly|Ride"] = 97.19, ["Neon"] = 107.25, ["Neon|Ride"] = 107.25, ["Neon|Fly|Ride"] = 210.74, ["Mega"] = 356.48, ["Mega|Ride"] = 426.25, ["Mega|Fly|Ride"] = 485.38}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 31.31, ["Fly"] = 72.09, ["Ride"] = 46.46, ["Fly|Ride"] = 114.13, ["Neon"] = 206.25, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 247.5, ["Mega"] = 2200, ["Mega|Fly|Ride"] = 824.89}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.07, ["Fly"] = 29.07, ["Ride"] = 20.63, ["Fly|Ride"] = 42.63, ["Neon"] = 35.92, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 97.94, ["Mega"] = 550, ["Mega|Ride"] = 287.29, ["Mega|Fly|Ride"] = 357.23}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.49, ["Fly"] = 34.03, ["Ride"] = 28.88, ["Fly|Ride"] = 85.25, ["Neon"] = 25.87, ["Neon|Fly"] = 86.09, ["Neon|Ride"] = 75.63, ["Neon|Fly|Ride"] = 172.15, ["Mega"] = 435.88, ["Mega|Fly"] = 488.49, ["Mega|Ride"] = 302.5, ["Mega|Fly|Ride"] = 537.99}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.46, ["Fly"] = 68.73, ["Ride"] = 45.38, ["Fly|Ride"] = 88.44, ["Neon"] = 421.5, ["Neon|Ride"] = 286.18, ["Neon|Fly|Ride"] = 286, ["Mega|Fly|Ride"] = 962.86}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1902.99, ["Fly"] = 2037.85, ["Ride"] = 1666.5, ["Fly|Ride"] = 1783.38, ["Neon|Fly"] = 5162.94, ["Neon|Ride"] = 4849.28, ["Neon|Fly|Ride"] = 3911.88, ["Mega|Fly|Ride"] = 17332.89}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 412.5, ["Fly"] = 573.53, ["Ride"] = 488.09, ["Fly|Ride"] = 594.53, ["Neon"] = 3239.9, ["Neon|Ride"] = 2581.95, ["Neon|Fly|Ride"] = 1650, ["Mega|Fly|Ride"] = 10029.91}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 259.38, ["Fly"] = 364.71, ["Ride"] = 319, ["Fly|Ride"] = 499.2, ["Neon"] = 1578.22, ["Neon|Ride"] = 1478.35, ["Neon|Fly|Ride"] = 1435.68, ["Mega|Fly|Ride"] = 6737.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.55}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.66, ["Ride"] = 49.5, ["Fly|Ride"] = 101.15, ["Neon"] = 344.28, ["Neon|Fly"] = 430.39, ["Neon|Ride"] = 359.39, ["Neon|Fly|Ride"] = 2062.5, ["Mega"] = 947.8, ["Mega|Ride"] = 858.62, ["Mega|Fly|Ride"] = 1087.63}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 43037.54, ["Fly"] = 21998.63, ["Ride"] = 36437.5, ["Fly|Ride"] = 17187.5, ["Neon|Fly|Ride"] = 39875, ["Mega|Fly|Ride"] = 93500}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 394.88, ["Fly"] = 894, ["Ride"] = 430.34, ["Fly|Ride"] = 474.45, ["Neon"] = 1000.89, ["Neon|Ride"] = 1265, ["Neon|Fly|Ride"] = 1358.5, ["Mega"] = 6454.84, ["Mega|Fly|Ride"] = 4028.74}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 162.8, ["Fly"] = 550, ["Ride"] = 142.99, ["Fly|Ride"] = 162.78, ["Mega|Fly|Ride"] = 4303.77}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 130.52, ["Fly"] = 275, ["Ride"] = 137.27, ["Fly|Ride"] = 223.57, ["Neon"] = 536.84, ["Neon|Ride"] = 534, ["Neon|Fly|Ride"] = 576.13, ["Mega|Fly|Ride"] = 2581.19}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 16.5, ["Fly"] = 99, ["Ride"] = 40.89, ["Fly|Ride"] = 103.17, ["Neon"] = 287.26, ["Neon|Ride"] = 141.63, ["Neon|Fly|Ride"] = 214.1, ["Mega"] = 716.5, ["Mega|Ride"] = 565.95}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5054.77, ["Ride"] = 5103.63, ["Fly|Ride"] = 4125, ["Neon|Ride"] = 18650.32, ["Neon|Fly|Ride"] = 17930.44, ["Mega|Fly|Ride"] = 60252.56}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 31.63, ["Fly"] = 101.16, ["Ride"] = 47.35, ["Fly|Ride"] = 57.12, ["Neon"] = 349.84, ["Neon|Ride"] = 218.63, ["Neon|Fly|Ride"] = 233.75, ["Mega"] = 1147.9, ["Mega|Fly|Ride"] = 897.76}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 49.5, ["Fly"] = 144.19, ["Ride"] = 48.13, ["Fly|Ride"] = 114.35, ["Neon"] = 412.5, ["Neon|Fly"] = 1435.32, ["Neon|Ride"] = 400.13, ["Neon|Fly|Ride"] = 275, ["Mega"] = 1620.36, ["Mega|Fly|Ride"] = 1362.15}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 653.13, ["Fly"] = 832.68, ["Ride"] = 653.13, ["Fly|Ride"] = 756.25, ["Neon"] = 1894.75, ["Neon|Ride"] = 1952.5, ["Neon|Fly|Ride"] = 1856.25, ["Mega"] = 7172.41, ["Mega|Ride"] = 6312.55, ["Mega|Fly|Ride"] = 4125}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 20.46, ["Fly"] = 29.07, ["Ride"] = 24.74, ["Fly|Ride"] = 53.45, ["Neon"] = 130.62, ["Neon|Fly"] = 162.8, ["Neon|Ride"] = 111.03, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 615.85, ["Mega|Ride"] = 610.06, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.1, ["Fly"] = 86.09, ["Ride"] = 27.99, ["Neon"] = 81.4, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 261.25, ["Mega|Ride"] = 545.52, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.46, ["Ride"] = 137.5, ["Fly|Ride"] = 206.25, ["Neon"] = 552.84, ["Neon|Ride"] = 550.37, ["Neon|Fly|Ride"] = 677.77, ["Mega"] = 2080.62, ["Mega|Fly|Ride"] = 2281.01}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.26, ["Fly"] = 83.93, ["Ride"] = 93.6, ["Fly|Ride"] = 154, ["Neon"] = 81.13, ["Neon|Fly"] = 200.15, ["Neon|Ride"] = 135.58, ["Neon|Fly|Ride"] = 256.15, ["Mega"] = 319, ["Mega|Ride"] = 316.25, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3850, ["Fly"] = 5270.38, ["Ride"] = 3850, ["Fly|Ride"] = 3849.99, ["Neon"] = 12909.66, ["Neon|Ride"] = 12016.1, ["Neon|Fly|Ride"] = 9141.95, ["Mega"] = 45065.44, ["Mega|Fly|Ride"] = 34664.54}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 48.13, ["Ride"] = 67.36, ["Fly|Ride"] = 142.42, ["Neon"] = 502.42, ["Neon|Ride"] = 330, ["Neon|Fly|Ride"] = 320.61, ["Mega|Ride"] = 1075.96, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6172.38, ["Fly"] = 8250, ["Ride"] = 6885.17, ["Fly|Ride"] = 6572.5, ["Neon|Fly|Ride"] = 17212.88, ["Mega|Fly|Ride"] = 67425.84}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.98, ["Fly"] = 19.45, ["Ride"] = 17.88, ["Fly|Ride"] = 37.67, ["Neon"] = 26.13, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 47.65, ["Neon|Fly|Ride"] = 90.74, ["Mega"] = 470.08, ["Mega|Ride"] = 208.75, ["Mega|Fly|Ride"] = 286.21}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 27.5, ["Fly"] = 28.73, ["Ride"] = 31.63, ["Fly|Ride"] = 58.11, ["Neon"] = 115.12, ["Neon|Ride"] = 171.09, ["Neon|Fly|Ride"] = 187.2, ["Mega|Ride"] = 1430.71, ["Mega|Fly|Ride"] = 855.24}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.85}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15, ["Ride"] = 37.67, ["Fly|Ride"] = 121.54, ["Neon"] = 201.19, ["Neon|Ride"] = 159.26, ["Neon|Fly|Ride"] = 202.13, ["Mega|Ride"] = 1002.79, ["Mega|Fly|Ride"] = 783.75}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.6, ["Fly"] = 275, ["Ride"] = 58.79, ["Fly|Ride"] = 144.17, ["Neon"] = 191.12, ["Neon|Ride"] = 137.02, ["Neon|Fly|Ride"] = 264.41, ["Mega"] = 880, ["Mega|Fly|Ride"] = 1127.5}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.13, ["Fly"] = 27.5, ["Ride"] = 24.25, ["Fly|Ride"] = 32.81, ["Neon"] = 86.08, ["Neon|Ride"] = 111.91, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 2581.95, ["Mega|Ride"] = 606.21, ["Mega|Fly|Ride"] = 495}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 9182.08}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2844.87}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.5}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 185.59, ["Fly"] = 182.88, ["Ride"] = 182.88, ["Fly|Ride"] = 192.49, ["Neon|Fly|Ride"] = 1075.82}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 23.38, ["Fly"] = 115.12, ["Ride"] = 64.56, ["Fly|Ride"] = 129.99, ["Neon"] = 124.89, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 187.2, ["Mega|Ride"] = 971.85, ["Mega|Fly|Ride"] = 893.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 8.24}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.98, ["Ride"] = 36.59, ["Fly|Ride"] = 62.41, ["Neon"] = 51.66, ["Neon|Ride"] = 72.1, ["Neon|Fly|Ride"] = 129.11, ["Mega|Fly|Ride"] = 488.13}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2814.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 151.25, ["Fly"] = 294.79, ["Ride"] = 184.25, ["Fly|Ride"] = 10998.9, ["Neon"] = 734.77, ["Neon|Ride"] = 962.5, ["Mega|Ride"] = 3012.64, ["Mega|Fly|Ride"] = 3401.48}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 574.57, ["Ride"] = 201.19, ["Fly|Ride"] = 219.16, ["Neon"] = 715, ["Neon|Ride"] = 717.75, ["Neon|Fly|Ride"] = 1147.9, ["Mega"] = 2750, ["Mega|Ride"] = 3443.03, ["Mega|Fly|Ride"] = 3239.9}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.88, ["Fly"] = 156.75, ["Ride"] = 206.25, ["Fly|Ride"] = 275, ["Neon|Ride"] = 880, ["Neon|Fly|Ride"] = 825, ["Mega"] = 4733.55, ["Mega|Fly|Ride"] = 3742.13}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1636.25, ["Fly"] = 2581.95, ["Ride"] = 1572.34, ["Fly|Ride"] = 1650, ["Neon"] = 6479.8, ["Neon|Ride"] = 5736.92, ["Neon|Fly|Ride"] = 3850, ["Mega|Fly|Ride"] = 32395.28}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 19.25, ["Fly"] = 83.93, ["Ride"] = 55, ["Fly|Ride"] = 97.9, ["Neon"] = 142.01, ["Neon|Ride"] = 172.17, ["Neon|Fly|Ride"] = 252.83, ["Mega"] = 971.74, ["Mega|Ride"] = 932.86, ["Mega|Fly|Ride"] = 1138.36}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 687.5, ["Fly"] = 2200, ["Ride"] = 760.59, ["Fly|Ride"] = 1100, ["Neon|Fly|Ride"] = 4211.23}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 44.35}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.15, ["Ride"] = 32.81, ["Fly|Ride"] = 188.28, ["Neon"] = 103.13, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 286.18, ["Mega"] = 412.39, ["Mega|Ride"] = 479.76, ["Mega|Fly|Ride"] = 508.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.13, ["Fly"] = 50.58, ["Ride"] = 29.07, ["Fly|Ride"] = 99.3, ["Neon"] = 29.07, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 122.38, ["Mega"] = 962.5, ["Mega|Ride"] = 360.46, ["Mega|Fly|Ride"] = 648.73}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 47.39}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.63, ["Fly"] = 114.11, ["Ride"] = 32.76, ["Fly|Ride"] = 86.08, ["Neon"] = 206.25, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 201.19, ["Mega"] = 825, ["Mega|Ride"] = 1296.22, ["Mega|Fly|Ride"] = 717.67}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 72.1, ["Fly"] = 79.63, ["Ride"] = 34.38, ["Fly|Ride"] = 63.64, ["Neon|Ride"] = 228.36, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 980.25, ["Mega|Ride"] = 1822.23, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6600, ["Fly"] = 11475.62, ["Ride"] = 5225, ["Fly|Ride"] = 5197.37, ["Neon|Fly|Ride"] = 10513.89, ["Mega|Fly|Ride"] = 30126.29}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 5.41, ["Fly"] = 42.63, ["Ride"] = 36.59, ["Fly|Ride"] = 82.5, ["Neon"] = 68.06, ["Neon|Ride"] = 81.51, ["Neon|Fly|Ride"] = 194.36, ["Mega"] = 544.19, ["Mega|Ride"] = 559.51, ["Mega|Fly|Ride"] = 478.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 34.45}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 95.25, ["Fly"] = 162.78, ["Ride"] = 104.5, ["Fly|Ride"] = 197.99, ["Neon"] = 508.75, ["Neon|Ride"] = 541.75, ["Neon|Fly|Ride"] = 690.25, ["Mega|Fly|Ride"] = 1938.48}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 65.99, ["Fly"] = 101.07, ["Ride"] = 110.82, ["Fly|Ride"] = 213.13, ["Neon"] = 206.25, ["Neon|Ride"] = 258.21, ["Neon|Fly|Ride"] = 485.98, ["Mega"] = 2429.33, ["Mega|Ride"] = 2905.05, ["Mega|Fly|Ride"] = 1363.22}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.98, ["Fly"] = 48.6, ["Ride"] = 31.62, ["Fly|Ride"] = 68.75, ["Neon"] = 137.71, ["Neon|Ride"] = 191.93, ["Neon|Fly|Ride"] = 171.88, ["Mega|Ride"] = 713.1, ["Mega|Fly|Ride"] = 687.48}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.37, ["Fly"] = 62.41, ["Ride"] = 32.29, ["Fly|Ride"] = 86.63, ["Neon"] = 30.25, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 55.8, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 165, ["Mega|Fly"] = 324.37, ["Mega|Ride"] = 218.67, ["Mega|Fly|Ride"] = 294.9}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 15.12, ["Fly"] = 144.17, ["Ride"] = 32.85, ["Fly|Ride"] = 103.29, ["Neon"] = 94.68, ["Neon|Ride"] = 128.06, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 502.42, ["Mega|Ride"] = 430.38, ["Mega|Fly|Ride"] = 572.41}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.63, ["Fly"] = 32.81, ["Ride"] = 26.13, ["Fly|Ride"] = 58.11, ["Neon"] = 213.02, ["Neon|Fly"] = 85.25, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 110, ["Mega|Fly|Ride"] = 648.5}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 201.38}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.99, ["Ride"] = 101.47, ["Neon"] = 178.75, ["Neon|Fly|Ride"] = 315.83, ["Mega"] = 1388.88, ["Mega|Ride"] = 962.5, ["Mega|Fly|Ride"] = 819.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 201.22, ["Fly"] = 227.15, ["Ride"] = 405.71, ["Fly|Ride"] = 344.28, ["Neon"] = 1147.9}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.58, ["Fly"] = 222.11, ["Ride"] = 105.69, ["Fly|Ride"] = 244.22, ["Neon"] = 261.23, ["Neon|Ride"] = 404.25, ["Neon|Fly|Ride"] = 440, ["Mega"] = 1240.25, ["Mega|Ride"] = 2243.76, ["Mega|Fly|Ride"] = 1262.5}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 930.88, ["Fly"] = 1171.5, ["Ride"] = 940.5, ["Fly|Ride"] = 967.47, ["Neon|Fly"] = 2794.08, ["Neon|Ride"] = 2681.1, ["Neon|Fly|Ride"] = 2473.63, ["Mega|Fly|Ride"] = 10862.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 275, ["Fly"] = 485.89, ["Ride"] = 275, ["Fly|Ride"] = 385, ["Neon"] = 1237.5, ["Neon|Ride"] = 2106.48, ["Neon|Fly|Ride"] = 1721.31, ["Mega"] = 8908.3, ["Mega|Fly|Ride"] = 6048.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 77.77}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.64}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.74, ["Fly"] = 28.88, ["Ride"] = 24.75, ["Fly|Ride"] = 55, ["Neon"] = 81.66, ["Neon|Fly"] = 241.99, ["Neon|Ride"] = 102.24, ["Neon|Fly|Ride"] = 162.25, ["Mega"] = 458.08, ["Mega|Ride"] = 716.6, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 284.44, ["Fly"] = 798.66, ["Ride"] = 316.12, ["Fly|Ride"] = 405.63, ["Neon"] = 1130.69, ["Neon|Ride"] = 912.95, ["Neon|Fly|Ride"] = 979.39, ["Mega|Ride"] = 3758.63, ["Mega|Fly|Ride"] = 2818.75}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 153.99, ["Fly"] = 273.28, ["Ride"] = 206.25, ["Fly|Ride"] = 233.75, ["Neon"] = 783.75, ["Neon|Fly"] = 1721.53, ["Neon|Ride"] = 806.87, ["Neon|Fly|Ride"] = 905.13, ["Mega"] = 2653.75, ["Mega|Ride"] = 12239.88, ["Mega|Fly|Ride"] = 2915}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.75, ["Fly"] = 201.19, ["Ride"] = 137.5, ["Fly|Ride"] = 165, ["Neon"] = 703.59, ["Neon|Ride"] = 1053.25, ["Neon|Fly|Ride"] = 968.24}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.12, ["Ride"] = 25.84, ["Fly|Ride"] = 175.38, ["Neon"] = 29.07, ["Neon|Ride"] = 89.37, ["Neon|Fly|Ride"] = 171.88, ["Mega"] = 274.58, ["Mega|Ride"] = 373.37, ["Mega|Fly|Ride"] = 686.13}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.77, ["Fly"] = 66, ["Ride"] = 30.67, ["Fly|Ride"] = 79.75, ["Neon"] = 221.63, ["Neon|Ride"] = 115.14, ["Neon|Fly|Ride"] = 267.45, ["Mega|Ride"] = 588.5, ["Mega|Fly|Ride"] = 604.8}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.85, ["Fly"] = 107.18, ["Ride"] = 48.13, ["Fly|Ride"] = 134.96, ["Neon"] = 136.13, ["Neon|Ride"] = 129.13, ["Neon|Fly|Ride"] = 266.81, ["Mega"] = 482.79, ["Mega|Ride"] = 481.85, ["Mega|Fly|Ride"] = 718.48}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.28, ["Fly"] = 129.11, ["Ride"] = 58.1, ["Fly|Ride"] = 163.82, ["Neon"] = 23.38, ["Neon|Fly"] = 242.98, ["Neon|Ride"] = 64.57, ["Neon|Fly|Ride"] = 162.25, ["Mega"] = 160.88, ["Mega|Ride"] = 184.32, ["Mega|Fly|Ride"] = 308}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 281.22, ["Fly"] = 962.5, ["Ride"] = 302.49, ["Fly|Ride"] = 374.32, ["Neon"] = 1578.22, ["Neon|Ride"] = 1401.95, ["Neon|Fly|Ride"] = 1471.25, ["Mega|Fly|Ride"] = 5435.65}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 143, ["Fly"] = 1100, ["Ride"] = 185.63, ["Fly|Ride"] = 324.45, ["Neon"] = 715, ["Neon|Ride"] = 742.5, ["Neon|Fly|Ride"] = 756.25, ["Mega|Ride"] = 4160.67, ["Mega|Fly|Ride"] = 2403.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 75.63, ["Fly"] = 175.42, ["Ride"] = 95.66, ["Fly|Ride"] = 101.15, ["Neon"] = 397.38, ["Neon|Ride"] = 430.39, ["Neon|Fly|Ride"] = 474.45, ["Mega|Fly|Ride"] = 1581.56}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.38, ["Ride"] = 60.5, ["Fly|Ride"] = 121.49, ["Neon|Ride"] = 617.14, ["Neon|Fly|Ride"] = 502.42, ["Mega|Ride"] = 645.57, ["Mega|Fly|Ride"] = 1719.36}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 16.49, ["Fly"] = 79.23, ["Ride"] = 47.25, ["Fly|Ride"] = 107.25, ["Neon"] = 81.13, ["Neon|Fly"] = 215.2, ["Neon|Ride"] = 72.13, ["Neon|Fly|Ride"] = 201.74, ["Mega"] = 324.33, ["Mega|Fly"] = 550, ["Mega|Ride"] = 357.23, ["Mega|Fly|Ride"] = 454.36}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 4, ["Fly"] = 54.95, ["Ride"] = 23.68, ["Fly|Ride"] = 103.13, ["Neon"] = 20.45, ["Neon|Fly"] = 96.25, ["Neon|Ride"] = 40.84, ["Neon|Fly|Ride"] = 97.19, ["Mega"] = 135.45, ["Mega|Ride"] = 162.25, ["Mega|Fly|Ride"] = 230.89}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 962.5, ["Fly"] = 1134.28, ["Ride"] = 1061.01, ["Fly|Ride"] = 1025.75, ["Neon"] = 3182.4, ["Neon|Fly"] = 3564.26, ["Neon|Ride"] = 2750, ["Neon|Fly|Ride"] = 2748.63, ["Mega|Fly|Ride"] = 10528.75}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 430.38, ["Ride"] = 397.38, ["Fly|Ride"] = 504.18, ["Neon|Ride"] = 2009.87, ["Neon|Fly|Ride"] = 2013.87, ["Mega"] = 10758.05, ["Mega|Fly|Ride"] = 7890.94}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.94, ["Fly"] = 137.5, ["Ride"] = 101.15, ["Fly|Ride"] = 187.2, ["Neon"] = 329.21, ["Neon|Ride"] = 320.38, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 1651.95, ["Mega|Ride"] = 1555.82, ["Mega|Fly|Ride"] = 1605.32}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 296.42, ["Fly"] = 485.89, ["Ride"] = 311.01, ["Fly|Ride"] = 359.33, ["Neon"] = 1457.6, ["Neon|Ride"] = 1457.78, ["Neon|Fly|Ride"] = 1183.41, ["Mega"] = 10758.05, ["Mega|Fly|Ride"] = 5507.95}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.63, ["Fly"] = 144.17, ["Ride"] = 32.29, ["Fly|Ride"] = 66.71, ["Neon"] = 177.38, ["Neon|Ride"] = 134.85, ["Neon|Fly|Ride"] = 240.62, ["Mega|Ride"] = 728.9, ["Mega|Fly|Ride"] = 645.57}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220, ["Ride"] = 278.82, ["Fly|Ride"] = 574.5, ["Neon"] = 1486.62, ["Neon|Ride"] = 987.25, ["Neon|Fly|Ride"] = 2473.29, ["Mega"] = 4282.02, ["Mega|Ride"] = 4447.94, ["Mega|Fly|Ride"] = 3945.48}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 63.24, ["Fly"] = 79.75, ["Ride"] = 58.11, ["Fly|Ride"] = 106.73, ["Neon|Ride"] = 516.48, ["Neon|Fly|Ride"] = 466.92, ["Mega|Fly|Ride"] = 1271.88}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1718.75, ["Fly"] = 1720.23, ["Ride"] = 1416.24, ["Fly|Ride"] = 1581.25, ["Neon|Ride"] = 11337.61, ["Neon|Fly|Ride"] = 4733.55, ["Mega"] = 51638.61, ["Mega|Fly|Ride"] = 22939.01}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 16.49, ["Fly"] = 66, ["Ride"] = 43.05, ["Fly|Ride"] = 95.2, ["Neon"] = 65.88, ["Neon|Fly"] = 193.68, ["Neon|Ride"] = 98.99, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 324.77, ["Mega|Fly"] = 391.88, ["Mega|Ride"] = 302.5, ["Mega|Fly|Ride"] = 417.55}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 44, ["Fly"] = 124.77, ["Ride"] = 86.08, ["Fly|Ride"] = 169.13, ["Neon"] = 287.26, ["Neon|Ride"] = 287.26, ["Neon|Fly|Ride"] = 247.5, ["Mega"] = 856.35, ["Mega|Ride"] = 1053.36, ["Mega|Fly|Ride"] = 947.91}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 68.75, ["Fly"] = 86.21, ["Ride"] = 77, ["Fly|Ride"] = 107.25, ["Neon|Ride"] = 430.38, ["Neon|Fly|Ride"] = 398.75, ["Mega|Fly|Ride"] = 1564.44}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3585.05, ["Fly"] = 1237.5, ["Ride"] = 1613.72, ["Fly|Ride"] = 1223.75, ["Neon|Fly|Ride"] = 4400, ["Mega|Fly|Ride"] = 16500}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 503.66, ["Fly"] = 858.5, ["Ride"] = 430.34, ["Fly|Ride"] = 645.51, ["Neon"] = 1943.46, ["Neon|Fly|Ride"] = 2835.02, ["Mega|Fly|Ride"] = 14577.71}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 133.43, ["Fly"] = 324.37, ["Ride"] = 144.17, ["Fly|Ride"] = 215.88, ["Neon"] = 465.45, ["Neon|Fly"] = 574.57, ["Neon|Ride"] = 495, ["Neon|Fly|Ride"] = 619.77, ["Mega"] = 4303.24, ["Mega|Ride"] = 2726.44, ["Mega|Fly|Ride"] = 1943.7}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.74, ["Ride"] = 23.58, ["Fly|Ride"] = 72.9, ["Neon"] = 70.47, ["Neon|Ride"] = 98, ["Neon|Fly|Ride"] = 185.06, ["Mega|Ride"] = 783.13, ["Mega|Fly|Ride"] = 1205.07}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.5, ["Fly"] = 115.12, ["Ride"] = 50.74, ["Fly|Ride"] = 128.57, ["Neon"] = 214.5, ["Neon|Ride"] = 171.88, ["Neon|Fly|Ride"] = 302.5, ["Mega|Ride"] = 1397.65, ["Mega|Fly|Ride"] = 1058.75}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 790.55, ["Ride"] = 859.38, ["Fly|Ride"] = 893.75, ["Neon"] = 3154.66, ["Neon|Ride"] = 2475, ["Neon|Fly|Ride"] = 2627.87, ["Mega|Fly|Ride"] = 161975.14}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 825}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5882.17, ["Ride"] = 5566.22, ["Fly|Ride"] = 4708, ["Neon"] = 44000, ["Neon|Ride"] = 30837.48, ["Neon|Fly|Ride"] = 22651.07, ["Mega|Fly|Ride"] = 91814.12}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 165, ["Fly"] = 421.92, ["Ride"] = 201.19, ["Fly|Ride"] = 385, ["Neon"] = 1306.25, ["Neon|Ride"] = 1296.22, ["Neon|Fly|Ride"] = 1721.31, ["Mega"] = 6024.52, ["Mega|Fly|Ride"] = 6160}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 82.5, ["Fly"] = 287.29, ["Ride"] = 82.5, ["Fly|Ride"] = 352, ["Neon"] = 430.34, ["Neon|Ride"] = 516.48, ["Neon|Fly|Ride"] = 1004.81, ["Mega|Fly|Ride"] = 2199.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.67, ["Fly"] = 101.15, ["Ride"] = 35.75, ["Fly|Ride"] = 53.45, ["Neon"] = 154, ["Neon|Ride"] = 90.39, ["Neon|Fly|Ride"] = 233.75, ["Mega|Ride"] = 574.57, ["Mega|Fly|Ride"] = 658.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 16.15, ["Fly"] = 41.25, ["Ride"] = 29.08, ["Fly|Ride"] = 53.63, ["Neon"] = 203.91, ["Neon|Fly"] = 287.29, ["Neon|Ride"] = 72.1, ["Neon|Fly|Ride"] = 185.62, ["Mega"] = 1375, ["Mega|Fly|Ride"] = 2281.01}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.56, ["Fly"] = 287.29, ["Ride"] = 35.24, ["Fly|Ride"] = 96.25, ["Neon"] = 105.45, ["Neon|Ride"] = 162.49, ["Neon|Fly|Ride"] = 190.21, ["Mega|Ride"] = 481.25, ["Mega|Fly|Ride"] = 632.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.13, ["Fly"] = 58.11, ["Ride"] = 23.38, ["Fly|Ride"] = 58.11, ["Neon"] = 23.38, ["Neon|Fly"] = 355.07, ["Neon|Ride"] = 48.13, ["Neon|Fly|Ride"] = 194.36, ["Mega"] = 172.15, ["Mega|Ride"] = 215.2, ["Mega|Fly|Ride"] = 317.42}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.12, ["Ride"] = 51.66, ["Fly|Ride"] = 192.5, ["Neon"] = 281.91, ["Neon|Fly"] = 860.77, ["Neon|Ride"] = 162.8, ["Neon|Fly|Ride"] = 373.32, ["Mega"] = 728.81, ["Mega|Ride"] = 1296.63, ["Mega|Fly|Ride"] = 837.29}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 319, ["Fly"] = 459.16, ["Ride"] = 357.5, ["Fly|Ride"] = 416.27, ["Neon|Ride"] = 1191.08, ["Neon|Fly|Ride"] = 996.88, ["Mega"] = 8250, ["Mega|Fly"] = 4517.88, ["Mega|Ride"] = 3873.39, ["Mega|Fly|Ride"] = 3781.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 4.13, ["Fly"] = 27.49, ["Ride"] = 17.87, ["Fly|Ride"] = 39.88, ["Neon"] = 20.6, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 72.6, ["Mega"] = 287.26, ["Mega|Ride"] = 185.63, ["Mega|Fly|Ride"] = 249.61}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.88, ["Fly"] = 116.62, ["Ride"] = 80.99, ["Fly|Ride"] = 144.17, ["Neon"] = 171.88, ["Neon|Fly"] = 405.63, ["Neon|Ride"] = 208.63, ["Neon|Fly|Ride"] = 268.68, ["Mega"] = 522.5, ["Mega|Fly"] = 860.77, ["Mega|Ride"] = 591.23, ["Mega|Fly|Ride"] = 584.38}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 792.48, ["Fly"] = 996.03, ["Ride"] = 810.34, ["Fly|Ride"] = 880.3, ["Neon|Ride"] = 1527.63, ["Neon|Fly|Ride"] = 1527.63, ["Mega|Fly|Ride"] = 3995.38}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.38, ["Fly"] = 96.25, ["Ride"] = 44.82, ["Fly|Ride"] = 96.25, ["Neon"] = 187.2, ["Neon|Ride"] = 158.11, ["Neon|Fly|Ride"] = 302.49, ["Mega"] = 1650, ["Mega|Ride"] = 825, ["Mega|Fly|Ride"] = 783.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 287.29, ["Fly"] = 343.75, ["Ride"] = 302.5, ["Fly|Ride"] = 305.25, ["Neon|Fly|Ride"] = 1291.56, ["Mega|Fly|Ride"] = 7173.29}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 162.8, ["Fly"] = 162.8, ["Ride"] = 158.12, ["Fly|Ride"] = 204.88, ["Neon|Ride"] = 726.27, ["Neon|Fly|Ride"] = 618.75, ["Mega|Fly|Ride"] = 3162.5}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 611.88, ["Ride"] = 632.49, ["Fly|Ride"] = 770, ["Neon|Ride"] = 2640.37, ["Neon|Fly|Ride"] = 2438.87, ["Mega|Fly|Ride"] = 8392.33}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.56, ["Ride"] = 41.96, ["Fly|Ride"] = 96.96, ["Neon"] = 115.12, ["Neon|Fly"] = 291.57, ["Neon|Ride"] = 134.85, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 320.61, ["Mega|Ride"] = 358.46, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4160.67, ["Ride"] = 3499.38, ["Fly|Ride"] = 3440.55, ["Neon|Fly|Ride"] = 6875, ["Mega|Fly|Ride"] = 26251.5}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 121, ["Fly"] = 99, ["Ride"] = 122.38, ["Fly|Ride"] = 172.15, ["Neon"] = 398.75, ["Neon|Ride"] = 532.6, ["Neon|Fly|Ride"] = 412.5, ["Mega|Fly|Ride"] = 2367.07}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.75, ["Fly"] = 27.5, ["Ride"] = 19.28, ["Fly|Ride"] = 67.38, ["Neon"] = 24.74, ["Neon|Fly"] = 86.09, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 203.5, ["Mega|Fly"] = 206.25, ["Mega|Ride"] = 283, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.41, ["Ride"] = 28.88, ["Fly|Ride"] = 68.04, ["Neon"] = 18.86, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 279.13, ["Mega"] = 169.13, ["Mega|Ride"] = 208.98, ["Mega|Fly|Ride"] = 237.43}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 36.59, ["Fly"] = 159.24, ["Ride"] = 39.19, ["Fly|Ride"] = 61.88, ["Neon"] = 284.24, ["Neon|Ride"] = 301.28, ["Neon|Fly|Ride"] = 287.26, ["Mega|Fly|Ride"] = 1148.05}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1113.75, ["Ride"] = 1168.75, ["Fly|Ride"] = 1166}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6323.63, ["Ride"] = 7287.96, ["Fly|Ride"] = 6599.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.08, ["Fly"] = 37.67, ["Ride"] = 27.5, ["Fly|Ride"] = 63.19, ["Neon"] = 215.18, ["Neon|Ride"] = 151.69, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 2543.75, ["Mega|Fly|Ride"] = 687.49}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 16.31, ["Fly"] = 50.58, ["Ride"] = 36.59, ["Fly|Ride"] = 93.5, ["Neon"] = 98.89, ["Neon|Ride"] = 94.67, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 673.07, ["Mega|Ride"] = 430.39, ["Mega|Fly|Ride"] = 523.81}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 75.43, ["Fly"] = 92.55, ["Ride"] = 74.88, ["Fly|Ride"] = 114.13, ["Neon"] = 343.75, ["Neon|Ride"] = 388.76, ["Neon|Fly|Ride"] = 316.25, ["Mega"] = 1721.31, ["Mega|Ride"] = 1869.99, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 215.2, ["Fly"] = 324.37, ["Ride"] = 220, ["Fly|Ride"] = 301.24, ["Neon|Ride"] = 1377.22, ["Neon|Fly|Ride"] = 990, ["Mega"] = 10758.05, ["Mega|Fly|Ride"] = 3873.39}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.45, ["Ride"] = 23.38, ["Fly|Ride"] = 90.75, ["Neon"] = 23.95, ["Neon|Fly"] = 687.49, ["Neon|Ride"] = 96.84, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 166.38, ["Mega|Ride"] = 171.77, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 199.37, ["Fly"] = 243.14, ["Ride"] = 243.29, ["Fly|Ride"] = 314.14, ["Neon"] = 880, ["Neon|Ride"] = 998.49, ["Neon|Fly|Ride"] = 825, ["Mega|Ride"] = 4858.02, ["Mega|Fly|Ride"] = 4018.65}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.74, ["Fly"] = 35.24, ["Ride"] = 15.13, ["Fly|Ride"] = 50.57, ["Neon"] = 20.62, ["Neon|Fly"] = 128.89, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 206.25, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 258.88}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 236.5, ["Fly"] = 277.58, ["Ride"] = 259.96, ["Fly|Ride"] = 259.96, ["Neon|Ride"] = 1134.65, ["Neon|Fly|Ride"] = 962.5, ["Mega"] = 10758.05, ["Mega|Fly|Ride"] = 4275.8}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.75, ["Fly"] = 73.75, ["Ride"] = 30.29, ["Fly|Ride"] = 64.56, ["Neon"] = 85.25, ["Neon|Fly"] = 308.58, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 204.19, ["Mega"] = 538.1, ["Mega|Ride"] = 602.54, ["Mega|Fly|Ride"] = 470.9}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.41, ["Ride"] = 21.21, ["Fly|Ride"] = 90.75, ["Neon"] = 10.22, ["Neon|Fly"] = 178.57, ["Neon|Ride"] = 38.41, ["Neon|Fly|Ride"] = 183.33, ["Mega"] = 115.12, ["Mega|Ride"] = 96.24, ["Mega|Fly|Ride"] = 212.6}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.75, ["Neon"] = 6.47, ["Neon|Ride"] = 33.37, ["Mega"] = 36.59, ["Mega|Ride"] = 143.3}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.83, ["Fly"] = 54.98, ["Ride"] = 34.47, ["Fly|Ride"] = 216.41, ["Neon"] = 12.17, ["Neon|Ride"] = 40.84, ["Neon|Fly|Ride"] = 116.88, ["Mega"] = 70.27, ["Mega|Fly"] = 161975.14, ["Mega|Ride"] = 100.37, ["Mega|Fly|Ride"] = 167.46}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.91, ["Fly"] = 143.35, ["Ride"] = 119.63, ["Fly|Ride"] = 171.88, ["Neon"] = 329.21, ["Neon|Ride"] = 302.5, ["Neon|Fly|Ride"] = 421, ["Mega|Fly|Ride"] = 1030.22}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.2, ["Fly"] = 35.14, ["Ride"] = 17.88, ["Fly|Ride"] = 92.92, ["Neon"] = 13.75, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 55, ["Mega"] = 136.13, ["Mega|Ride"] = 128.37, ["Mega|Fly|Ride"] = 269.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 12.27, ["Ride"] = 121.49, ["Neon"] = 43.06, ["Neon|Ride"] = 116.88, ["Mega"] = 631.51, ["Mega|Ride"] = 607.57}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.2, ["Neon"] = 2.75, ["Neon|Ride"] = 46.72, ["Neon|Fly|Ride"] = 291.5, ["Mega"] = 24.77, ["Mega|Ride"] = 48.61, ["Mega|Fly|Ride"] = 137.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.2, ["Fly"] = 72.09, ["Ride"] = 16.15, ["Fly|Ride"] = 35.03, ["Neon"] = 2.2, ["Neon|Fly"] = 27.5, ["Neon|Ride"] = 14.77, ["Neon|Fly|Ride"] = 40.89, ["Mega"] = 14.4, ["Mega|Fly"] = 31.63, ["Mega|Ride"] = 31.6, ["Mega|Fly|Ride"] = 50.46}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.2, ["Ride"] = 16.04, ["Fly|Ride"] = 32.29, ["Neon"] = 3.54, ["Neon|Fly"] = 21.54, ["Neon|Ride"] = 16.15, ["Neon|Fly|Ride"] = 55.88, ["Mega"] = 20.38, ["Mega|Fly"] = 162.72, ["Mega|Ride"] = 41.45, ["Mega|Fly|Ride"] = 101.16}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.2, ["Ride"] = 35.24, ["Fly|Ride"] = 129.11, ["Neon"] = 2.62, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 86.09, ["Mega"] = 16.5, ["Mega|Ride"] = 153.04, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.2, ["Fly"] = 123.75, ["Ride"] = 19.25, ["Fly|Ride"] = 112.74, ["Neon"] = 4.13, ["Neon|Fly"] = 144.41, ["Neon|Ride"] = 22, ["Neon|Fly|Ride"] = 82.49, ["Mega"] = 24.56, ["Mega|Fly"] = 89.38, ["Mega|Ride"] = 52.25, ["Mega|Fly|Ride"] = 126.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.2, ["Neon"] = 3.4, ["Neon|Fly|Ride"] = 213.02, ["Mega"] = 27.99, ["Mega|Ride"] = 96.25, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.04, ["Fly"] = 68.35, ["Ride"] = 17.88, ["Fly|Ride"] = 55.97, ["Neon"] = 10.89, ["Neon|Fly"] = 61.87, ["Neon|Ride"] = 25.05, ["Neon|Fly|Ride"] = 68.66, ["Mega"] = 67.65, ["Mega|Fly"] = 290.51, ["Mega|Ride"] = 96.24, ["Mega|Fly|Ride"] = 158.13}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.2, ["Ride"] = 49.5, ["Neon"] = 2.2, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 110, ["Mega"] = 16.06, ["Mega|Fly"] = 103.13, ["Mega|Ride"] = 49.49, ["Mega|Fly|Ride"] = 89.38}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.2, ["Fly|Ride"] = 549.99, ["Neon"] = 16.49, ["Mega"] = 287.26, ["Mega|Fly"] = 330, ["Mega|Ride"] = 287.29}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.88, ["Ride"] = 43.05, ["Neon"] = 6.48, ["Neon|Ride"] = 20.63, ["Mega"] = 108.63, ["Mega|Fly|Ride"] = 563.22}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.2, ["Ride"] = 34.38, ["Neon"] = 4.13, ["Neon|Fly"] = 29.07, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 34.38, ["Mega|Ride"] = 181.02, ["Mega|Fly|Ride"] = 137.38}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.2, ["Fly"] = 20.62, ["Ride"] = 18.24, ["Fly|Ride"] = 31.53, ["Neon"] = 2.2, ["Neon|Fly"] = 37.13, ["Neon|Ride"] = 15.13, ["Neon|Fly|Ride"] = 30.05, ["Mega"] = 16.14, ["Mega|Fly"] = 38.5, ["Mega|Ride"] = 26.13, ["Mega|Fly|Ride"] = 90.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.75, ["Fly"] = 75.63, ["Ride"] = 240.62, ["Fly|Ride"] = 109.98, ["Neon"] = 30.25, ["Neon|Ride"] = 147.66, ["Mega"] = 287.26}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.2, ["Ride"] = 19.2, ["Neon"] = 5.5, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 24.75, ["Mega|Fly"] = 82.5, ["Mega|Ride"] = 63.5, ["Mega|Fly|Ride"] = 136.66}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.18, ["Neon"] = 21.88, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 85.25, ["Mega|Ride"] = 122.51, ["Mega|Fly|Ride"] = 250.24}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.75, ["Fly"] = 687.49, ["Ride"] = 34.38, ["Fly|Ride"] = 195.8, ["Neon"] = 16.04, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 233.64, ["Mega|Ride"] = 96.24, ["Mega|Fly|Ride"] = 197.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.2, ["Fly"] = 18.13, ["Ride"] = 14.89, ["Fly|Ride"] = 27.41, ["Neon"] = 2.2, ["Neon|Fly"] = 15.12, ["Neon|Ride"] = 16.15, ["Neon|Fly|Ride"] = 38.7, ["Mega"] = 15.13, ["Mega|Fly"] = 32.29, ["Mega|Ride"] = 29.07, ["Mega|Fly|Ride"] = 54.96}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.75, ["Fly"] = 27.5, ["Ride"] = 20.6, ["Fly|Ride"] = 101.15, ["Neon"] = 19.25, ["Neon|Ride"] = 116.62, ["Neon|Fly|Ride"] = 88, ["Mega"] = 82.5, ["Mega|Ride"] = 161.5, ["Mega|Fly|Ride"] = 258.25}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.66, ["Fly"] = 42.63, ["Ride"] = 34.38, ["Fly|Ride"] = 61.24, ["Neon"] = 75.63, ["Neon|Ride"] = 50.38, ["Neon|Fly|Ride"] = 275, ["Mega"] = 247.5, ["Mega|Ride"] = 294.25, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.2, ["Fly"] = 16.15, ["Ride"] = 16.5, ["Fly|Ride"] = 27.42, ["Neon"] = 3.34, ["Neon|Fly"] = 23.5, ["Neon|Ride"] = 16.15, ["Neon|Fly|Ride"] = 38.75, ["Mega"] = 15.13, ["Mega|Fly"] = 162.8, ["Mega|Ride"] = 123.78, ["Mega|Fly|Ride"] = 103.13}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 4, ["Fly"] = 179.68, ["Ride"] = 63.24, ["Neon"] = 8.63, ["Neon|Fly"] = 79.64, ["Neon|Ride"] = 42.62, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 38.41, ["Mega|Fly"] = 172.17, ["Mega|Ride"] = 88, ["Mega|Fly|Ride"] = 274.97}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.75, ["Ride"] = 27.99, ["Fly|Ride"] = 86.08, ["Neon"] = 5.16, ["Neon|Fly"] = 123.75, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 34.42, ["Mega|Ride"] = 145.75, ["Mega|Fly|Ride"] = 165}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.2, ["Fly"] = 27.5, ["Ride"] = 17.52, ["Neon"] = 2.2, ["Neon|Fly"] = 43.06, ["Neon|Ride"] = 31.62, ["Neon|Fly|Ride"] = 101.15, ["Mega"] = 17.88, ["Mega|Ride"] = 35.75, ["Mega|Fly|Ride"] = 114.02}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.2, ["Fly"] = 72.1, ["Ride"] = 19.25, ["Fly|Ride"] = 44.02, ["Neon"] = 4.88, ["Neon|Fly"] = 49.5, ["Neon|Ride"] = 19.98, ["Neon|Fly|Ride"] = 76.23, ["Mega"] = 81.4, ["Mega|Ride"] = 85.06, ["Mega|Fly|Ride"] = 301.28}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.64, ["Ride"] = 110, ["Neon"] = 5.5, ["Neon|Ride"] = 45.36, ["Mega"] = 42.62, ["Mega|Ride"] = 130}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.2, ["Fly"] = 33.31, ["Ride"] = 18.4, ["Fly|Ride"] = 45.38, ["Neon"] = 8.25, ["Neon|Fly"] = 83.79, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 87.98, ["Mega"] = 96.24, ["Mega|Ride"] = 94.88, ["Mega|Fly|Ride"] = 129.25}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.63, ["Ride"] = 28.97, ["Neon"] = 37.87, ["Mega"] = 140.25, ["Mega|Ride"] = 215.73, ["Mega|Fly|Ride"] = 860.75}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.2, ["Fly"] = 37.67, ["Ride"] = 17.49, ["Fly|Ride"] = 64.56, ["Neon"] = 18.92, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 30.25, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 178.75, ["Mega|Ride"] = 149.88, ["Mega|Fly|Ride"] = 330.32}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.31, ["Fly"] = 23.52, ["Ride"] = 20.46, ["Fly|Ride"] = 50.88, ["Neon"] = 19.18, ["Neon|Fly"] = 41.23, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 233.75, ["Mega|Fly"] = 429.31, ["Mega|Ride"] = 130, ["Mega|Fly|Ride"] = 198.73}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.2, ["Fly"] = 116.21, ["Ride"] = 55.88, ["Fly|Ride"] = 144.26, ["Neon"] = 39.19, ["Mega"] = 129.17, ["Mega|Ride"] = 247.49}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.75, ["Ride"] = 79.63, ["Neon"] = 125.82, ["Neon|Ride"] = 34.38, ["Mega|Fly|Ride"] = 831.88}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.13, ["Ride"] = 114.21, ["Neon"] = 43.07, ["Neon|Ride"] = 110, ["Mega"] = 162.78, ["Mega|Ride"] = 286.7, ["Mega|Fly|Ride"] = 756.95}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.05, ["Ride"] = 47.83, ["Fly|Ride"] = 145.75, ["Neon"] = 88.24, ["Neon|Ride"] = 68.75, ["Mega"] = 259.88, ["Mega|Ride"] = 268.13, ["Mega|Fly|Ride"] = 370.56}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.2, ["Neon"] = 3.99, ["Neon|Ride"] = 68.08, ["Mega"] = 22, ["Mega|Ride"] = 144.19, ["Mega|Fly|Ride"] = 154.95}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 44.91}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.37, ["Fly"] = 22.99, ["Ride"] = 23.38, ["Fly|Ride"] = 43.05, ["Neon"] = 78.01, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 107.6, ["Mega"] = 302.5, ["Mega|Fly"] = 344.32, ["Mega|Ride"] = 291.57, ["Mega|Fly|Ride"] = 294.89}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.2, ["Fly"] = 74.25, ["Ride"] = 19.25, ["Fly|Ride"] = 73.17, ["Neon"] = 2.73, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 54.91, ["Mega"] = 33.37, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.52, ["Ride"] = 25.9, ["Neon"] = 4.72, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 107.6, ["Mega"] = 58.11, ["Mega|Ride"] = 60.41, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.45, ["Fly"] = 48.13, ["Ride"] = 20.45, ["Fly|Ride"] = 57.75, ["Neon"] = 7.22, ["Neon|Ride"] = 27.99, ["Neon|Fly|Ride"] = 118.97, ["Mega"] = 131.19, ["Mega|Ride"] = 165}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.67, ["Ride"] = 29.07, ["Fly|Ride"] = 61.34, ["Neon"] = 70.13, ["Neon|Ride"] = 242.95, ["Neon|Fly|Ride"] = 200.75, ["Mega"] = 305.54, ["Mega|Ride"] = 282.81, ["Mega|Fly|Ride"] = 321.72}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.2, ["Ride"] = 34.37, ["Neon"] = 3.39, ["Neon|Ride"] = 50.58, ["Neon|Fly|Ride"] = 57.09, ["Mega"] = 17.88, ["Mega|Fly"] = 123.75, ["Mega|Ride"] = 48.03, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.2, ["Fly"] = 21.99, ["Ride"] = 16.7, ["Fly|Ride"] = 286881.47, ["Neon"] = 4.92, ["Neon|Fly"] = 72.1, ["Neon|Ride"] = 22, ["Neon|Fly|Ride"] = 72.88, ["Mega"] = 37.11, ["Mega|Fly"] = 149.98, ["Mega|Ride"] = 50.21, ["Mega|Fly|Ride"] = 121.5}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.2, ["Fly"] = 28.67, ["Ride"] = 16.5, ["Fly|Ride"] = 35.75, ["Neon"] = 8.02, ["Neon|Fly"] = 72.1, ["Neon|Ride"] = 17.88, ["Neon|Fly|Ride"] = 85.25, ["Mega"] = 50.22, ["Mega|Ride"] = 53.78, ["Mega|Fly|Ride"] = 165.83}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.2, ["Fly"] = 220, ["Ride"] = 38.49, ["Fly|Ride"] = 123.75, ["Neon"] = 4.02, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 26.11, ["Mega|Fly"] = 107.61, ["Mega|Ride"] = 69.41, ["Mega|Fly|Ride"] = 110}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.2, ["Neon"] = 3.45, ["Neon|Ride"] = 172.21, ["Neon|Fly|Ride"] = 156446.43, ["Mega"] = 72.09, ["Mega|Fly"] = 103.31, ["Mega|Ride"] = 90.75, ["Mega|Fly|Ride"] = 208.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.2, ["Fly"] = 33.97, ["Ride"] = 18.59, ["Fly|Ride"] = 51.66, ["Neon"] = 4.13, ["Neon|Fly"] = 27.5, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 80.18, ["Mega"] = 25.82, ["Mega|Ride"] = 61.88, ["Mega|Fly|Ride"] = 115.14}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.2, ["Ride"] = 48.13, ["Neon"] = 2.69, ["Mega"] = 16.5, ["Mega|Ride"] = 129.69, ["Mega|Fly|Ride"] = 404.95}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.5, ["Neon"] = 4.88, ["Neon|Ride"] = 162.8, ["Mega"] = 29.91, ["Mega|Fly"] = 121.5, ["Mega|Ride"] = 127.96}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.2, ["Fly"] = 28.88, ["Ride"] = 16.81, ["Fly|Ride"] = 52.24, ["Neon"] = 4.82, ["Neon|Ride"] = 21.32, ["Neon|Fly|Ride"] = 142.99, ["Mega"] = 58.12, ["Mega|Ride"] = 53.77, ["Mega|Fly|Ride"] = 161.41}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.38, ["Fly"] = 58.11, ["Ride"] = 144.09, ["Neon"] = 536.84, ["Mega"] = 561.7, ["Mega|Ride"] = 471.09, ["Mega|Fly|Ride"] = 703.49}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.12, ["Fly"] = 6875, ["Ride"] = 38.5, ["Neon"] = 39.18, ["Neon|Ride"] = 213.05, ["Mega"] = 330.29, ["Mega|Ride"] = 358.2, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.9, ["Ride"] = 27.49, ["Fly|Ride"] = 182.9, ["Neon"] = 35.33, ["Mega"] = 287.26, ["Mega|Ride"] = 259.98, ["Mega|Fly|Ride"] = 366.3}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.2, ["Fly"] = 19.45, ["Ride"] = 13.42, ["Fly|Ride"] = 26.68, ["Neon"] = 2.2, ["Neon|Fly"] = 15.27, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 28.58, ["Mega"] = 16.5, ["Mega|Fly"] = 33.37, ["Mega|Ride"] = 27.5, ["Mega|Fly|Ride"] = 52.18}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.2, ["Fly"] = 123.74, ["Ride"] = 57.75, ["Fly|Ride"] = 115.12, ["Neon"] = 18.24, ["Neon|Fly"] = 93.72, ["Neon|Ride"] = 33.37, ["Neon|Fly|Ride"] = 717.58, ["Mega"] = 53.81, ["Mega|Ride"] = 103.31}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.2, ["Ride"] = 32.89, ["Neon"] = 2.2, ["Neon|Fly"] = 32.3, ["Neon|Ride"] = 21.67, ["Neon|Fly|Ride"] = 80.7, ["Mega"] = 16.38, ["Mega|Fly"] = 84.52, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 105.49}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.2, ["Ride"] = 95.97, ["Neon"] = 2.75, ["Neon|Fly"] = 63.8, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 128.04, ["Mega"] = 43.05, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 158.12}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.2, ["Fly"] = 35.69, ["Ride"] = 19.38, ["Fly|Ride"] = 55.96, ["Neon"] = 12.25, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 92.55, ["Mega"] = 192.39, ["Mega|Ride"] = 199.18, ["Mega|Fly|Ride"] = 259.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 182.16, ["Ride"] = 247.5, ["Fly|Ride"] = 192.5, ["Neon"] = 1100, ["Neon|Ride"] = 862.13, ["Mega"] = 8606.45, ["Mega|Fly|Ride"] = 3501.13}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.2, ["Neon"] = 9.78, ["Neon|Fly"] = 43.06, ["Neon|Ride"] = 71.5, ["Mega"] = 67.08, ["Mega|Ride"] = 94.88, ["Mega|Fly|Ride"] = 810.3}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 4.32, ["Fly"] = 108.62, ["Ride"] = 16.5, ["Neon"] = 61.88, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 162.46, ["Mega"] = 162.78, ["Mega|Fly|Ride"] = 429.31}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.2, ["Fly"] = 843.61, ["Ride"] = 13.38, ["Fly|Ride"] = 34.35, ["Neon"] = 8.25, ["Neon|Fly"] = 33, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 64.9, ["Mega"] = 52.03, ["Mega|Ride"] = 77.91, ["Mega|Fly|Ride"] = 159.26}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.2, ["Fly"] = 53.63, ["Ride"] = 20.62, ["Fly|Ride"] = 55, ["Neon"] = 5.5, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 100.27, ["Mega|Ride"] = 143, ["Mega|Fly|Ride"] = 439.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.13, ["Fly"] = 26.11, ["Ride"] = 16.5, ["Fly|Ride"] = 36.63, ["Neon"] = 24.75, ["Neon|Ride"] = 34.37, ["Neon|Fly|Ride"] = 96.25, ["Mega|Ride"] = 215.2, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.81, ["Ride"] = 24.75, ["Fly|Ride"] = 58.11, ["Neon"] = 47.38, ["Neon|Ride"] = 134.37, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 194.36, ["Mega|Fly|Ride"] = 418}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.61, ["Fly"] = 17.23, ["Ride"] = 15.13, ["Fly|Ride"] = 38.5, ["Neon"] = 18.24, ["Neon|Fly"] = 71.41, ["Neon|Ride"] = 55.96, ["Neon|Fly|Ride"] = 77, ["Mega|Fly|Ride"] = 242}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 79.64, ["Fly"] = 144.17, ["Ride"] = 98.98, ["Fly|Ride"] = 169.13, ["Neon"] = 408.82, ["Neon|Fly"] = 430.38, ["Neon|Ride"] = 405.63, ["Neon|Fly|Ride"] = 302.5, ["Mega|Fly|Ride"] = 1538.63}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 215.49, ["Fly"] = 344.28, ["Ride"] = 242.26, ["Fly|Ride"] = 303.68, ["Neon|Ride"] = 1237.5, ["Neon|Fly|Ride"] = 1134.5, ["Mega"] = 10758.05, ["Mega|Fly|Ride"] = 4145.61}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 71.03, ["Fly"] = 144.17, ["Ride"] = 81.13, ["Fly|Ride"] = 126.49, ["Neon"] = 421.5, ["Neon|Ride"] = 324.39, ["Neon|Fly|Ride"] = 350.73, ["Mega|Fly|Ride"] = 1388.12}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.04, ["Fly"] = 27.5, ["Ride"] = 24.75, ["Fly|Ride"] = 97.19, ["Neon"] = 34.37, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 145.78, ["Mega"] = 330, ["Mega|Ride"] = 393.95, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 16.5, ["Fly"] = 72.11, ["Ride"] = 32.29, ["Fly|Ride"] = 85, ["Neon"] = 80.71, ["Neon|Ride"] = 101.71, ["Neon|Fly|Ride"] = 179.68, ["Mega"] = 368.5, ["Mega|Ride"] = 364.38, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.2, ["Fly"] = 32.99, ["Ride"] = 19.69, ["Fly|Ride"] = 41.31, ["Neon"] = 4.88, ["Neon|Fly"] = 70.5, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 72.14, ["Mega"] = 83.93, ["Mega|Fly"] = 162.25, ["Mega|Ride"] = 97.2, ["Mega|Fly|Ride"] = 182.92}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.43, ["Fly"] = 72.1, ["Ride"] = 29.06, ["Fly|Ride"] = 324.33, ["Neon"] = 55.96, ["Neon|Ride"] = 162.8, ["Neon|Fly|Ride"] = 141.35, ["Mega"] = 923.06, ["Mega|Ride"] = 611.14, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.75, ["Fly"] = 31.6, ["Ride"] = 16.04, ["Fly|Ride"] = 46.17, ["Neon"] = 15.13, ["Neon|Fly"] = 152.63, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 108.56, ["Mega"] = 137.5, ["Mega|Ride"] = 162.8, ["Mega|Fly|Ride"] = 191.13}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.33, ["Ride"] = 21.43, ["Fly|Ride"] = 343.75, ["Neon"] = 32.29, ["Neon|Ride"] = 58.12, ["Neon|Fly|Ride"] = 162.78, ["Mega"] = 217.24, ["Mega|Ride"] = 216.25, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.2, ["Fly"] = 30.25, ["Ride"] = 37.67, ["Neon"] = 2.2, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 49.49, ["Mega"] = 15.13, ["Mega|Ride"] = 52.74, ["Mega|Fly|Ride"] = 218665.33}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.58, ["Fly"] = 48.13, ["Ride"] = 18.26, ["Fly|Ride"] = 41.25, ["Neon"] = 15.13, ["Neon|Fly"] = 107.61, ["Neon|Ride"] = 36.59, ["Neon|Fly|Ride"] = 102.67, ["Mega"] = 88, ["Mega|Ride"] = 110.86, ["Mega|Fly|Ride"] = 178.74}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.5, ["Fly"] = 16.5, ["Ride"] = 17.88, ["Fly|Ride"] = 48.13, ["Neon"] = 18.24, ["Neon|Ride"] = 49.5, ["Neon|Fly|Ride"] = 115.12, ["Mega"] = 297, ["Mega|Ride"] = 211.39, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 162.25, ["Fly"] = 196.63, ["Ride"] = 258.21, ["Fly|Ride"] = 243.38, ["Neon"] = 734.25, ["Neon|Ride"] = 730.13, ["Neon|Fly|Ride"] = 810.39, ["Mega|Ride"] = 3643.75, ["Mega|Fly|Ride"] = 3818.65}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 11, ["Ride"] = 32.29, ["Fly|Ride"] = 215.88, ["Neon"] = 62.41, ["Neon|Ride"] = 167.75, ["Neon|Fly|Ride"] = 394.49, ["Mega"] = 359.33, ["Mega|Ride"] = 387.35, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.2, ["Fly"] = 16.15, ["Ride"] = 16.98, ["Fly|Ride"] = 45.32, ["Neon"] = 42.53, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 136.13, ["Mega"] = 206.25, ["Mega|Ride"] = 232.38, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.12, ["Ride"] = 41.97, ["Fly|Ride"] = 178.75, ["Neon"] = 124.91, ["Neon|Ride"] = 155.37, ["Neon|Fly|Ride"] = 530.28, ["Mega"] = 474.72, ["Mega|Ride"] = 492.25, ["Mega|Fly|Ride"] = 741.04}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.37}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.45, ["Ride"] = 26.73, ["Neon"] = 29.07, ["Neon|Ride"] = 161.2, ["Neon|Fly|Ride"] = 645.51, ["Mega"] = 403.44, ["Mega|Ride"] = 423.5, ["Mega|Fly|Ride"] = 716.6}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 27.97, ["Fly"] = 81.36, ["Ride"] = 27.48, ["Fly|Ride"] = 60.49, ["Neon"] = 187.2, ["Neon|Fly"] = 106666.66, ["Neon|Ride"] = 109.99, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 2151.63, ["Mega|Fly|Ride"] = 872.6}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.2, ["Ride"] = 55, ["Fly|Ride"] = 82.5, ["Neon"] = 4.12, ["Neon|Ride"] = 51.66, ["Neon|Fly|Ride"] = 110, ["Mega"] = 37.12, ["Mega|Fly"] = 430.39, ["Mega|Ride"] = 60.5, ["Mega|Fly|Ride"] = 137.49}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 10.77, ["Fly"] = 28.91, ["Ride"] = 27.96, ["Fly|Ride"] = 64.56, ["Neon"] = 34.37, ["Neon|Fly"] = 48.13, ["Neon|Ride"] = 242.98, ["Mega"] = 239.95, ["Mega|Fly"] = 405.76, ["Mega|Ride"] = 154, ["Mega|Fly|Ride"] = 324.5}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.75, ["Ride"] = 18.08, ["Fly|Ride"] = 45.41, ["Neon"] = 16.01, ["Neon|Fly"] = 195.8, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 140.08, ["Mega|Ride"] = 130, ["Mega|Fly|Ride"] = 219.89}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.2, ["Ride"] = 20.63, ["Neon"] = 3.73, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 430.34, ["Mega"] = 27.5, ["Mega|Ride"] = 86.27, ["Mega|Fly|Ride"] = 144.19}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.97, ["Ride"] = 129.11, ["Neon"] = 242.95, ["Neon|Fly"] = 203.5, ["Neon|Ride"] = 728.75, ["Neon|Fly|Ride"] = 609.33, ["Mega"] = 945.42, ["Mega|Ride"] = 1086.71, ["Mega|Fly|Ride"] = 888.73}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.74, ["Ride"] = 53.45, ["Neon"] = 83.88, ["Neon|Ride"] = 144.17, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 287.26, ["Mega|Ride"] = 430.39}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 5.41, ["Fly"] = 91.66, ["Ride"] = 41.25, ["Fly|Ride"] = 72.88, ["Neon"] = 46.75, ["Neon|Fly"] = 330, ["Neon|Ride"] = 54.88, ["Neon|Fly|Ride"] = 129.11, ["Mega"] = 390.16, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 453.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.1, ["Fly"] = 453.75, ["Ride"] = 110, ["Fly|Ride"] = 274.94, ["Neon"] = 426.03, ["Neon|Ride"] = 343.75, ["Neon|Fly|Ride"] = 717.58, ["Mega"] = 1678.27, ["Mega|Ride"] = 2131.25, ["Mega|Fly|Ride"] = 1370.76}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.58, ["Fly"] = 41.25, ["Ride"] = 30.24, ["Fly|Ride"] = 63.25, ["Neon"] = 55, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 70.13, ["Neon|Fly|Ride"] = 143, ["Mega"] = 278.48, ["Mega|Ride"] = 252.7, ["Mega|Fly|Ride"] = 385.54}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 85.54, ["Fly"] = 149.88, ["Ride"] = 112.7, ["Fly|Ride"] = 218.65, ["Neon"] = 192.5, ["Neon|Fly"] = 522.5, ["Neon|Ride"] = 236.5, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 1025.77, ["Mega|Ride"] = 1047.97, ["Mega|Fly|Ride"] = 880}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.45, ["Fly"] = 129.11, ["Ride"] = 66, ["Fly|Ride"] = 150.64, ["Neon"] = 86.08, ["Neon|Ride"] = 144.17, ["Neon|Fly|Ride"] = 279.72, ["Mega"] = 403.28, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 450.05}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 9.88, ["Fly"] = 144.19, ["Ride"] = 29.07, ["Fly|Ride"] = 43.05, ["Neon"] = 86.62, ["Neon|Ride"] = 82.41, ["Neon|Fly|Ride"] = 386.28, ["Mega"] = 654.71, ["Mega|Fly|Ride"] = 485.93}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.86, ["Ride"] = 110, ["Fly|Ride"] = 158.9, ["Neon"] = 92.56, ["Neon|Ride"] = 116.88, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 267.35, ["Mega|Fly"] = 519.7, ["Mega|Ride"] = 321.75, ["Mega|Fly|Ride"] = 379.5}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.68, ["Ride"] = 41.31, ["Fly|Ride"] = 144.17, ["Neon"] = 45.32, ["Neon|Ride"] = 105.45, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 403.44, ["Mega|Ride"] = 320.98, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.2, ["Neon"] = 2.2, ["Neon|Fly"] = 55.96, ["Neon|Ride"] = 59.13, ["Mega"] = 18.56, ["Mega|Fly"] = 144.19, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.92, ["Ride"] = 28.56, ["Fly|Ride"] = 446.48, ["Neon"] = 16.5, ["Neon|Fly"] = 129.13, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 212.44, ["Mega"] = 100.38, ["Mega|Ride"] = 167.86, ["Mega|Fly|Ride"] = 485.93}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.75, ["Fly"] = 48.6, ["Neon"] = 24.74, ["Neon|Ride"] = 215.2, ["Mega"] = 191.97, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 11, ["Ride"] = 34.34, ["Fly|Ride"] = 120.26, ["Neon"] = 16.5, ["Neon|Ride"] = 86.09, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 129.24, ["Mega|Ride"] = 222.37, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 569.25, ["Ride"] = 550, ["Fly|Ride"] = 632.5, ["Neon"] = 1783.7, ["Neon|Ride"] = 1507.77, ["Neon|Fly|Ride"] = 1650, ["Mega|Fly|Ride"] = 6158.9}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.97, ["Fly"] = 29.07, ["Ride"] = 24.31, ["Fly|Ride"] = 62.41, ["Neon"] = 27.5, ["Neon|Ride"] = 72.1, ["Neon|Fly|Ride"] = 220, ["Mega|Ride"] = 387.35, ["Mega|Fly|Ride"] = 511.09}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.38, ["Fly"] = 41.25, ["Ride"] = 27.5, ["Fly|Ride"] = 63.25, ["Neon"] = 79.74, ["Neon|Ride"] = 57.11, ["Mega"] = 286.18, ["Mega|Ride"] = 302.39, ["Mega|Fly|Ride"] = 343.74}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.74, ["Ride"] = 17.88, ["Fly|Ride"] = 322.77, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 157.08, ["Mega"] = 273.31, ["Mega|Fly|Ride"] = 495}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.2, ["Fly"] = 68.06, ["Ride"] = 26.13, ["Fly|Ride"] = 94.88, ["Neon"] = 7.88, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 95.97, ["Mega"] = 72.88, ["Mega|Ride"] = 61.88, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.2, ["Fly"] = 72.09, ["Ride"] = 17.88, ["Neon"] = 4.13, ["Neon|Ride"] = 25.49, ["Neon|Fly|Ride"] = 76.4, ["Mega"] = 21.53, ["Mega|Ride"] = 81.12, ["Mega|Fly|Ride"] = 158.13}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1159.13}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.88, ["Ride"] = 43.05, ["Fly|Ride"] = 72.11, ["Neon"] = 79.63, ["Neon|Ride"] = 75.63, ["Neon|Fly|Ride"] = 187.2, ["Mega|Ride"] = 574.57, ["Mega|Fly|Ride"] = 886.58}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.2, ["Ride"] = 29.61, ["Neon"] = 5.49, ["Neon|Ride"] = 42.63, ["Neon|Fly|Ride"] = 1004.81, ["Mega"] = 41.12, ["Mega|Ride"] = 157.1, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.02, ["Fly"] = 101.15, ["Ride"] = 61.27, ["Fly|Ride"] = 41.25, ["Neon"] = 8.2, ["Neon|Fly"] = 129.13, ["Neon|Ride"] = 72.13, ["Neon|Fly|Ride"] = 220, ["Mega"] = 137.5, ["Mega|Ride"] = 232.38, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 467.5, ["Ride"] = 514.24, ["Fly|Ride"] = 511.5, ["Neon|Ride"] = 1646.21, ["Neon|Fly|Ride"] = 1262.8, ["Mega|Fly|Ride"] = 7888.79}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.09, ["Fly"] = 206.25, ["Ride"] = 101.15, ["Neon"] = 144.38, ["Neon|Ride"] = 77, ["Neon|Fly|Ride"] = 195.52, ["Mega"] = 479.88, ["Mega|Ride"] = 430.39}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.2, ["Fly"] = 77.61, ["Ride"] = 30.68, ["Fly|Ride"] = 148.48, ["Neon"] = 5.37, ["Neon|Ride"] = 39.85, ["Neon|Fly|Ride"] = 152.63, ["Mega"] = 42.61, ["Mega|Fly"] = 198, ["Mega|Ride"] = 80.32, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.2, ["Ride"] = 860.67, ["Neon"] = 3.99, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 25.33, ["Mega|Ride"] = 119.08, ["Mega|Fly|Ride"] = 228.11}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.25, ["Fly"] = 112.74, ["Ride"] = 27.5, ["Fly|Ride"] = 187, ["Neon"] = 64.56, ["Neon|Ride"] = 75.63, ["Neon|Fly|Ride"] = 344.28, ["Mega"] = 606.14, ["Mega|Fly|Ride"] = 537.99}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.24, ["Fly|Ride"] = 129.99, ["Neon"] = 114.18, ["Neon|Fly|Ride"] = 178.75, ["Mega"] = 412.5, ["Mega|Ride"] = 502.56, ["Mega|Fly|Ride"] = 1114.45}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.48, ["Ride"] = 41.25, ["Fly|Ride"] = 144.17, ["Neon"] = 29.07, ["Neon|Ride"] = 183.45, ["Mega"] = 664.44, ["Mega|Ride"] = 1003.73, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.25, ["Ride"] = 36.59, ["Neon"] = 169.99, ["Neon|Ride"] = 192.49, ["Neon|Fly|Ride"] = 193.66, ["Mega"] = 481.25, ["Mega|Ride"] = 642.82, ["Mega|Fly|Ride"] = 697.13}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 340.99, ["Ride"] = 430.34, ["Fly|Ride"] = 646.25, ["Neon"] = 1719.14, ["Neon|Ride"] = 1720.44, ["Neon|Fly|Ride"] = 1375, ["Mega|Ride"] = 4302.69, ["Mega|Fly|Ride"] = 3873.39}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 8.25, ["Fly"] = 72.97, ["Ride"] = 24.75, ["Fly|Ride"] = 53.81, ["Neon"] = 103.13, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 717.58, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 886.58}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.89, ["Ride"] = 131.98, ["Fly|Ride"] = 82.5, ["Neon"] = 19.25, ["Neon|Ride"] = 232.38, ["Mega"] = 137.5, ["Mega|Ride"] = 357.5, ["Mega|Fly|Ride"] = 810.3}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.69, ["Ride"] = 71.5, ["Fly|Ride"] = 268.46, ["Neon"] = 46.75, ["Neon|Ride"] = 120.3, ["Neon|Fly|Ride"] = 165, ["Mega"] = 280.7, ["Mega|Fly"] = 574.57, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 339.54}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.2, ["Fly"] = 42.53, ["Ride"] = 55, ["Fly|Ride"] = 129.11, ["Neon"] = 7.59, ["Neon|Fly"] = 43.06, ["Neon|Ride"] = 164.98, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 46.75, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 273.3}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 42.63, ["Ride"] = 96.25, ["Fly|Ride"] = 165, ["Neon"] = 314.14, ["Neon|Ride"] = 308.81, ["Neon|Fly|Ride"] = 484.13, ["Mega"] = 1865.45, ["Mega|Ride"] = 1289, ["Mega|Fly|Ride"] = 1379.36}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.75, ["Fly"] = 59.13, ["Ride"] = 33.37, ["Neon"] = 10.89, ["Neon|Fly"] = 164.44, ["Neon|Ride"] = 40.9, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 68.75, ["Mega|Ride"] = 105.88, ["Mega|Fly|Ride"] = 186.98}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.64, ["Fly"] = 32.81, ["Ride"] = 28.88, ["Fly|Ride"] = 155.31, ["Neon"] = 6.47, ["Neon|Fly"] = 71.68, ["Neon|Ride"] = 48.13, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 58.11, ["Mega|Ride"] = 101.16, ["Mega|Fly|Ride"] = 187.79}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.75, ["Fly"] = 1592.25, ["Ride"] = 28.88, ["Fly|Ride"] = 143.99, ["Neon"] = 19.25, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 185.63, ["Mega"] = 122.38, ["Mega|Fly"] = 481.25, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 283.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 75.26, ["Fly"] = 97.19, ["Ride"] = 110.39, ["Neon"] = 344.28, ["Neon|Ride"] = 494.95, ["Mega|Fly|Ride"] = 1098.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 275, ["Ride"] = 324.49, ["Fly|Ride"] = 435.7, ["Neon"] = 1495.38, ["Neon|Ride"] = 1148.05, ["Neon|Fly|Ride"] = 1086.25, ["Mega"] = 6454.84, ["Mega|Fly|Ride"] = 5022.03}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.28, ["Neon"] = 56.38, ["Neon|Ride"] = 159.26, ["Mega"] = 96.25, ["Mega|Ride"] = 192.75, ["Mega|Fly|Ride"] = 346.47}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.75, ["Ride"] = 34.38, ["Neon"] = 20.63, ["Neon|Ride"] = 45.38, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 57.75, ["Mega|Fly"] = 165, ["Mega|Ride"] = 107.25, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.75, ["Fly"] = 31.6, ["Ride"] = 21.54, ["Fly|Ride"] = 182.9, ["Neon"] = 38.5, ["Mega"] = 362.32, ["Mega|Ride"] = 357.5, ["Mega|Fly|Ride"] = 363}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.84, ["Fly"] = 61.73, ["Ride"] = 21.53, ["Fly|Ride"] = 140.25, ["Neon"] = 9.52, ["Neon|Ride"] = 36.46, ["Neon|Fly|Ride"] = 144.48, ["Mega"] = 72.11, ["Mega|Ride"] = 99, ["Mega|Fly|Ride"] = 247.48}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.2, ["Ride"] = 29.08, ["Neon"] = 13.38, ["Mega"] = 34.38, ["Mega|Fly|Ride"] = 284.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.2, ["Fly"] = 68.66, ["Ride"] = 16.5, ["Fly|Ride"] = 43.99, ["Neon"] = 5.5, ["Neon|Ride"] = 24.74, ["Neon|Fly|Ride"] = 102.22, ["Mega"] = 45.37, ["Mega|Ride"] = 77, ["Mega|Fly|Ride"] = 144.19}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.2, ["Fly"] = 94.68, ["Ride"] = 21.43, ["Fly|Ride"] = 55.94, ["Neon"] = 9.63, ["Neon|Fly"] = 72.1, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 66.4, ["Mega"] = 163.59, ["Mega|Ride"] = 242.1, ["Mega|Fly|Ride"] = 457.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.68, ["Fly"] = 37.67, ["Ride"] = 44, ["Fly|Ride"] = 86.49, ["Neon"] = 287.26, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 301.35, ["Mega"] = 481.25, ["Mega|Fly"] = 550, ["Mega|Ride"] = 429, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 75.33, ["Fly"] = 610.5, ["Ride"] = 85.97, ["Fly|Ride"] = 144.17, ["Neon"] = 371.25, ["Neon|Ride"] = 408.38, ["Mega"] = 1650.3, ["Mega|Ride"] = 1721.53, ["Mega|Fly|Ride"] = 1433.16}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.2, ["Fly"] = 36.46, ["Ride"] = 24.35, ["Fly|Ride"] = 137.5, ["Neon"] = 4.13, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 39.49, ["Mega|Fly"] = 704, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 252.86}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.2, ["Fly"] = 16.15, ["Ride"] = 16.48, ["Fly|Ride"] = 37.12, ["Neon"] = 5.45, ["Neon|Fly"] = 41.25, ["Neon|Ride"] = 21.54, ["Neon|Fly|Ride"] = 64.62, ["Mega"] = 52.23, ["Mega|Fly"] = 137.45, ["Mega|Ride"] = 52.25, ["Mega|Fly|Ride"] = 130.63}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.5, ["Ride"] = 76.98, ["Fly|Ride"] = 137.5, ["Neon"] = 258.21, ["Neon|Ride"] = 48.68, ["Neon|Fly|Ride"] = 286.18, ["Mega"] = 273.38, ["Mega|Ride"] = 430.39, ["Mega|Fly|Ride"] = 666.88}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 371.25, ["Fly"] = 412.5, ["Ride"] = 566.97, ["Fly|Ride"] = 522.5, ["Neon|Ride"] = 1865.69, ["Neon|Fly|Ride"] = 1100, ["Mega|Fly|Ride"] = 6886.03}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 31.61, ["Fly"] = 94.46, ["Ride"] = 62.41, ["Fly|Ride"] = 107.6, ["Neon"] = 264.66, ["Neon|Ride"] = 115.14, ["Neon|Fly|Ride"] = 277.58, ["Mega|Ride"] = 1291.14}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.2, ["Ride"] = 37.67, ["Fly|Ride"] = 110, ["Neon"] = 12.13, ["Neon|Ride"] = 162.8, ["Neon|Fly|Ride"] = 165, ["Mega"] = 60.5, ["Mega|Ride"] = 107.6, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.75, ["Fly"] = 215.18, ["Ride"] = 68.75, ["Fly|Ride"] = 149.49, ["Neon"] = 137.39}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.23, ["Fly"] = 79.63, ["Ride"] = 47.4, ["Fly|Ride"] = 72.11, ["Neon"] = 123.75, ["Neon|Ride"] = 292.4, ["Neon|Fly|Ride"] = 552.75, ["Mega"] = 2581.95, ["Mega|Fly|Ride"] = 1296.22}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 111.47, ["Ride"] = 104.5, ["Fly|Ride"] = 198, ["Neon"] = 522.5, ["Neon|Ride"] = 492.79, ["Neon|Fly|Ride"] = 501.34, ["Mega"] = 8606.45, ["Mega|Fly|Ride"] = 1958.22}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 244.3, ["Fly"] = 321.72, ["Ride"] = 275, ["Fly|Ride"] = 387.3, ["Neon"] = 859.58, ["Neon|Ride"] = 1148.05, ["Neon|Fly|Ride"] = 1290.98, ["Mega|Fly|Ride"] = 3372.01}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.73, ["Ride"] = 41.31, ["Fly|Ride"] = 158.13, ["Neon"] = 77, ["Neon|Ride"] = 159.26, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 394.59, ["Mega|Ride"] = 357.5, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.2, ["Fly"] = 27.5, ["Ride"] = 15.18, ["Fly|Ride"] = 30.25, ["Neon"] = 8.14, ["Neon|Fly"] = 41.25, ["Neon|Ride"] = 29.07, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 95.57, ["Mega|Ride"] = 109.99, ["Mega|Fly|Ride"] = 198}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.46, ["Fly"] = 20.63, ["Ride"] = 22.6, ["Neon"] = 30.8, ["Neon|Fly"] = 150.65, ["Neon|Ride"] = 52.25, ["Neon|Fly|Ride"] = 107.6, ["Mega"] = 329.21, ["Mega|Ride"] = 287.29, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 302.5, ["Fly"] = 502.48, ["Ride"] = 342.38, ["Fly|Ride"] = 430.34, ["Neon"] = 1031.25, ["Neon|Ride"] = 1375, ["Neon|Fly|Ride"] = 1650, ["Mega|Ride"] = 5592.73, ["Mega|Fly|Ride"] = 5976.85}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.35, ["Ride"] = 63.49, ["Neon"] = 12.17, ["Neon|Ride"] = 58.11, ["Neon|Fly|Ride"] = 123750, ["Mega"] = 45.38, ["Mega|Ride"] = 187.21, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.02, ["Fly"] = 22.6, ["Ride"] = 19.45, ["Fly|Ride"] = 43.05, ["Neon"] = 32.83, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 110.82, ["Mega"] = 185.06, ["Mega|Fly"] = 214.66, ["Mega|Ride"] = 194.39, ["Mega|Fly|Ride"] = 324.25}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.12, ["Ride"] = 119.63, ["Neon"] = 108.63, ["Neon|Fly"] = 430.39, ["Neon|Ride"] = 148.91, ["Neon|Fly|Ride"] = 405.63, ["Mega"] = 485.12, ["Mega|Ride"] = 545.52, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 162.8, ["Fly"] = 144.17, ["Ride"] = 137.5, ["Fly|Ride"] = 130.63, ["Neon|Ride"] = 717.67, ["Neon|Fly|Ride"] = 680.63, ["Mega|Fly|Ride"] = 2106.5}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 22.97, ["Fly"] = 50.58, ["Ride"] = 27.6, ["Fly|Ride"] = 64.62, ["Neon"] = 82.5, ["Neon|Ride"] = 108.63, ["Neon|Fly|Ride"] = 171.07, ["Mega"] = 645.51, ["Mega|Ride"] = 531.83, ["Mega|Fly|Ride"] = 481.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.2, ["Ride"] = 51.66, ["Neon"] = 2.2, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 717.58, ["Mega"] = 21.55, ["Mega|Ride"] = 286.21, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.2, ["Ride"] = 16.5, ["Fly|Ride"] = 55, ["Neon"] = 3.85, ["Neon|Fly"] = 162.8, ["Neon|Ride"] = 21.43, ["Neon|Fly|Ride"] = 72.9, ["Mega"] = 28.88, ["Mega|Fly"] = 101.74, ["Mega|Ride"] = 53.63, ["Mega|Fly|Ride"] = 115.14}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.95, ["Fly"] = 430.34, ["Ride"] = 70.47, ["Fly|Ride"] = 180.76, ["Neon"] = 39.88, ["Neon|Fly"] = 233.26, ["Neon|Ride"] = 103.13, ["Neon|Fly|Ride"] = 181.04, ["Mega"] = 151.24, ["Mega|Fly"] = 287.29, ["Mega|Ride"] = 194.39, ["Mega|Fly|Ride"] = 273.35}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1502.88, ["Ride"] = 1375, ["Fly|Ride"] = 1443.75, ["Neon"] = 4400, ["Neon|Fly|Ride"] = 5055.22, ["Mega|Fly|Ride"] = 11275}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 440, ["Ride"] = 504.63, ["Fly|Ride"] = 570.05, ["Neon"] = 1822.43, ["Neon|Ride"] = 1237.39, ["Neon|Fly|Ride"] = 1900.13, ["Mega"] = 17212.88, ["Mega|Fly|Ride"] = 7422.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 350.63, ["Fly"] = 379.5, ["Ride"] = 373.32, ["Fly|Ride"] = 440, ["Neon"] = 687.5, ["Neon|Fly"] = 1296.22, ["Neon|Ride"] = 647.18, ["Neon|Fly|Ride"] = 797.5, ["Mega|Fly|Ride"] = 3213.27}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 342.12, ["Fly"] = 432.79, ["Ride"] = 382.54, ["Fly|Ride"] = 478.5, ["Neon"] = 1263.17, ["Neon|Fly"] = 1435.32, ["Neon|Ride"] = 1014.75, ["Neon|Fly|Ride"] = 1017.5, ["Mega|Fly|Ride"] = 4836.35}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.2, ["Fly"] = 24.5, ["Ride"] = 18.24, ["Fly|Ride"] = 41.25, ["Neon"] = 8.25, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 86.08, ["Mega"] = 66.82, ["Mega|Ride"] = 96.24, ["Mega|Fly|Ride"] = 151.25}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 413.09, ["Ride"] = 550, ["Fly|Ride"] = 825, ["Neon"] = 1760, ["Neon|Ride"] = 1581.24, ["Neon|Fly|Ride"] = 2062.5, ["Mega|Fly|Ride"] = 8503.66}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.64, ["Fly"] = 192.5, ["Ride"] = 117.89, ["Fly|Ride"] = 65.61, ["Neon"] = 10.11, ["Neon|Ride"] = 67.8, ["Neon|Fly|Ride"] = 162.76, ["Mega"] = 68.75, ["Mega|Ride"] = 82.41, ["Mega|Fly|Ride"] = 284.07}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.2, ["Fly"] = 25.84, ["Ride"] = 21.52, ["Fly|Ride"] = 41.25, ["Neon"] = 17.23, ["Neon|Ride"] = 50.58, ["Neon|Fly|Ride"] = 105.64, ["Mega"] = 110, ["Mega|Ride"] = 202.12}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.2, ["Neon"] = 4.4, ["Neon|Ride"] = 41.24, ["Mega"] = 24.75, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 47.65, ["Ride"] = 68.75, ["Fly|Ride"] = 481.25, ["Neon"] = 220, ["Neon|Ride"] = 466.92, ["Mega|Fly|Ride"] = 1058.75}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.91, ["Fly"] = 8420.92, ["Ride"] = 22, ["Fly|Ride"] = 63.32, ["Neon"] = 27.5, ["Neon|Ride"] = 81.42, ["Mega"] = 343.75, ["Mega|Ride"] = 247.5, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.2, ["Ride"] = 41.25, ["Neon"] = 4.33, ["Neon|Fly"] = 123.75, ["Neon|Ride"] = 31.6, ["Neon|Fly|Ride"] = 100.38, ["Mega"] = 36.6, ["Mega|Fly"] = 717.67, ["Mega|Ride"] = 162.68, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.62, ["Fly"] = 37.6, ["Ride"] = 21.53, ["Fly|Ride"] = 64.15, ["Neon"] = 14.59, ["Neon|Fly"] = 54.99, ["Neon|Ride"] = 32.77, ["Neon|Fly|Ride"] = 86.35, ["Mega"] = 55, ["Mega|Fly"] = 179.7, ["Mega|Ride"] = 121, ["Mega|Fly|Ride"] = 192.49}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.58, ["Fly"] = 58.11, ["Ride"] = 23.68, ["Fly|Ride"] = 53.9, ["Neon"] = 159.24, ["Neon|Fly"] = 77.48, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 257.13, ["Mega"] = 248.88, ["Mega|Ride"] = 314.82, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 13.64, ["Ride"] = 53.63, ["Neon"] = 59.13, ["Neon|Ride"] = 287.26, ["Neon|Fly|Ride"] = 275.74, ["Mega"] = 324.33, ["Mega|Ride"] = 460.52, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.12, ["Fly"] = 6478.98, ["Ride"] = 27.99, ["Neon"] = 25.6, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 287.26, ["Mega|Ride"] = 748, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.2, ["Fly"] = 41.25, ["Ride"] = 19.02, ["Fly|Ride"] = 88, ["Neon"] = 4.95, ["Neon|Fly"] = 29.07, ["Neon|Ride"] = 20.63, ["Mega"] = 43.99, ["Mega|Ride"] = 132, ["Mega|Fly|Ride"] = 242.98}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 218.63, ["Fly"] = 287.29, ["Ride"] = 235.38, ["Fly|Ride"] = 323.13, ["Neon|Ride"] = 2689.53, ["Neon|Fly|Ride"] = 1190.93, ["Mega"] = 8606.45, ["Mega|Fly|Ride"] = 4398.51}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.2, ["Fly"] = 16.39, ["Ride"] = 16.5, ["Fly|Ride"] = 37.13, ["Neon"] = 5.5, ["Neon|Fly"] = 53.81, ["Neon|Ride"] = 22.58, ["Neon|Fly|Ride"] = 43.05, ["Mega"] = 29.06, ["Mega|Ride"] = 61.88, ["Mega|Fly|Ride"] = 123.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.75, ["Ride"] = 72.77, ["Fly|Ride"] = 192.48, ["Neon"] = 107.25, ["Neon|Ride"] = 105.45, ["Mega"] = 458.31, ["Mega|Fly|Ride"] = 486.46}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.69, ["Fly"] = 220, ["Ride"] = 201.19, ["Fly|Ride"] = 175.19, ["Neon"] = 206.25, ["Neon|Ride"] = 324.37, ["Mega"] = 860.67, ["Mega|Ride"] = 889.81, ["Mega|Fly|Ride"] = 955.45}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 186.78, ["Ride"] = 244.75, ["Fly|Ride"] = 343.75, ["Neon"] = 859.58, ["Neon|Fly"] = 1214.82, ["Neon|Ride"] = 825.26, ["Neon|Fly|Ride"] = 775.5, ["Mega|Fly|Ride"] = 2200}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.87, ["Ride"] = 39.21, ["Fly|Ride"] = 145.78, ["Neon"] = 129.11, ["Neon|Ride"] = 287.29, ["Mega"] = 300.45, ["Mega|Ride"] = 416.41, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 106.18, ["Ride"] = 50.88, ["Fly|Ride"] = 645.51, ["Neon"] = 1506.15, ["Neon|Ride"] = 202.13, ["Mega"] = 1721.31, ["Mega|Ride"] = 1721.53, ["Mega|Fly|Ride"] = 972.67}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1100, ["Fly"] = 1509.75, ["Ride"] = 1100, ["Fly|Ride"] = 1218.25, ["Neon|Ride"] = 5018.75, ["Neon|Fly|Ride"] = 5344.5, ["Mega|Fly|Ride"] = 17787.42}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.63, ["Fly"] = 22, ["Ride"] = 20.49, ["Fly|Ride"] = 44, ["Neon"] = 46.27, ["Neon|Fly"] = 77.2, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 101.15, ["Mega|Ride"] = 230.27, ["Mega|Fly|Ride"] = 322.8}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.13, ["Fly"] = 68.75, ["Ride"] = 39.88, ["Neon"] = 31.68, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 574.5, ["Mega"] = 358.33, ["Mega|Fly"] = 1320, ["Mega|Ride"] = 228.11, ["Mega|Fly|Ride"] = 606.84}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.75, ["Fly"] = 85.01, ["Ride"] = 23.38, ["Fly|Ride"] = 72.88, ["Neon"] = 13.38, ["Neon|Ride"] = 41.32, ["Mega"] = 94.86, ["Mega|Ride"] = 143.41, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.24, ["Fly"] = 58.11, ["Ride"] = 38.5, ["Fly|Ride"] = 106.97, ["Neon"] = 79.75, ["Neon|Ride"] = 96.24, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 343.75, ["Mega|Ride"] = 366.41, ["Mega|Fly|Ride"] = 492.44}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.9, ["Fly"] = 21.99, ["Ride"] = 21.67, ["Fly|Ride"] = 53.45, ["Neon"] = 25.89, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 65.32, ["Mega"] = 154.94, ["Mega|Ride"] = 159.26, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.75, ["Fly"] = 430.39, ["Ride"] = 37.67, ["Neon"] = 11, ["Neon|Fly"] = 13750, ["Neon|Ride"] = 63.25, ["Neon|Fly|Ride"] = 860.67, ["Mega"] = 108.7, ["Mega|Fly"] = 215.2, ["Mega|Ride"] = 200.19, ["Mega|Fly|Ride"] = 318.92}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 330.32, ["Ride"] = 359.33, ["Fly|Ride"] = 615.85, ["Neon|Fly|Ride"] = 1401.73}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.07, ["Fly"] = 26.67, ["Ride"] = 19.25, ["Fly|Ride"] = 50.88, ["Neon"] = 12.38, ["Neon|Fly"] = 86.09, ["Neon|Ride"] = 40.89, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 81.4, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 244.26}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.45, ["Ride"] = 85.66, ["Neon"] = 144.17, ["Neon|Fly"] = 206.25, ["Neon|Ride"] = 197.23, ["Mega|Ride"] = 244.2}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.26, ["Fly"] = 93.68, ["Ride"] = 27.42, ["Neon"] = 11.4, ["Neon|Ride"] = 58.11, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 88.98, ["Mega|Ride"] = 258.25, ["Mega|Fly|Ride"] = 344.32}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 320.37, ["Ride"] = 330, ["Fly|Ride"] = 449.71, ["Neon"] = 742.5, ["Neon|Ride"] = 860.77, ["Neon|Fly|Ride"] = 1100, ["Mega|Ride"] = 3207.11, ["Mega|Fly|Ride"] = 2750}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.73, ["Fly"] = 57.41, ["Ride"] = 43.05, ["Fly|Ride"] = 110, ["Neon"] = 128.07, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 825.98, ["Mega|Ride"] = 618.75, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.38, ["Ride"] = 79.75, ["Fly|Ride"] = 129.99, ["Neon"] = 130.63, ["Neon|Ride"] = 129.25, ["Neon|Fly|Ride"] = 261.25, ["Mega"] = 525.14, ["Mega|Ride"] = 449.63, ["Mega|Fly|Ride"] = 440}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.2, ["Neon"] = 6.76, ["Neon|Ride"] = 46.28, ["Mega"] = 33.85, ["Mega|Ride"] = 192.49}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 63.29, ["Fly"] = 87.59, ["Ride"] = 111.9, ["Fly|Ride"] = 185.59, ["Neon"] = 274.97, ["Neon|Fly"] = 317.57, ["Neon|Ride"] = 385, ["Neon|Fly|Ride"] = 275, ["Mega|Fly|Ride"] = 1196.89}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.2, ["Ride"] = 19.73, ["Fly|Ride"] = 144.17, ["Neon"] = 5.5, ["Neon|Ride"] = 58.13, ["Neon|Fly|Ride"] = 616, ["Mega"] = 47.24, ["Mega|Fly|Ride"] = 429.31}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.51, ["Fly"] = 144.17, ["Ride"] = 24.77, ["Fly|Ride"] = 71.65, ["Neon"] = 48.13, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 258.21, ["Mega"] = 400.24, ["Mega|Fly"] = 1017.5, ["Mega|Ride"] = 425.01, ["Mega|Fly|Ride"] = 438.63}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 48.45, ["Fly"] = 115.3, ["Ride"] = 83.76, ["Fly|Ride"] = 108.89, ["Neon"] = 191.18, ["Neon|Ride"] = 258.25, ["Neon|Fly|Ride"] = 372.63, ["Mega|Ride"] = 1376.14, ["Mega|Fly|Ride"] = 1141.87}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.2, ["Fly"] = 31.6, ["Ride"] = 16.15, ["Fly|Ride"] = 35.24, ["Neon"] = 2.75, ["Neon|Fly"] = 29.07, ["Neon|Ride"] = 18.24, ["Neon|Fly|Ride"] = 61.97, ["Mega"] = 19.25, ["Mega|Fly"] = 58.11, ["Mega|Ride"] = 33, ["Mega|Fly|Ride"] = 93.5}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.44, ["Ride"] = 35.24, ["Fly|Ride"] = 1397.48, ["Neon"] = 24.77, ["Neon|Ride"] = 61.35, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 495, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 437.95}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.88, ["Fly"] = 144.17, ["Ride"] = 41.25, ["Neon"] = 116.75, ["Neon|Ride"] = 213.05, ["Neon|Fly|Ride"] = 275, ["Mega"] = 571.27, ["Mega|Ride"] = 544.5, ["Mega|Fly|Ride"] = 768.23}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.2, ["Ride"] = 28.05, ["Neon"] = 2.75, ["Neon|Ride"] = 19.24, ["Mega"] = 32.29, ["Mega|Ride"] = 81.42, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 6.88, ["Ride"] = 34.38, ["Fly|Ride"] = 126.5, ["Neon"] = 83.88, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 194.36, ["Mega"] = 574.5, ["Mega|Fly"] = 825, ["Mega|Ride"] = 330, ["Mega|Fly|Ride"] = 453.34}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 21.88, ["Fly"] = 29.07, ["Ride"] = 27.99, ["Fly|Ride"] = 48.13, ["Neon"] = 222.83, ["Neon|Ride"] = 123.93, ["Mega"] = 451.85, ["Mega|Ride"] = 316.25, ["Mega|Fly|Ride"] = 659.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.3, ["Ride"] = 18.24, ["Fly|Ride"] = 79.64, ["Neon"] = 34.65, ["Neon|Fly"] = 732.88, ["Neon|Ride"] = 81.13, ["Neon|Fly|Ride"] = 123.64, ["Mega"] = 178.75, ["Mega|Ride"] = 237.4, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 27.99, ["Fly"] = 2151.63, ["Ride"] = 44, ["Fly|Ride"] = 162.78, ["Neon"] = 91.12, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 6477.77, ["Mega"] = 430.34, ["Mega|Ride"] = 532.13, ["Mega|Fly|Ride"] = 572.7}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.2, ["Fly"] = 43.06, ["Ride"] = 18.24, ["Fly|Ride"] = 206.24, ["Neon"] = 9.63, ["Neon|Fly"] = 58.11, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 107, ["Mega"] = 68.75, ["Mega|Fly"] = 275, ["Mega|Ride"] = 130}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.2, ["Ride"] = 58.17, ["Neon"] = 2.75, ["Neon|Ride"] = 93.42, ["Mega"] = 31.61, ["Mega|Ride"] = 79.74, ["Mega|Fly|Ride"] = 219.8}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 41.25}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 55.9, ["Fly"] = 107.25, ["Ride"] = 72.09, ["Fly|Ride"] = 215.18, ["Neon"] = 137.5, ["Neon|Ride"] = 214.27, ["Neon|Fly|Ride"] = 275, ["Mega"] = 1282.37, ["Mega|Ride"] = 825, ["Mega|Fly|Ride"] = 876.03}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.2, ["Neon"] = 4.12, ["Mega"] = 32.29, ["Mega|Ride"] = 172.17, ["Mega|Fly|Ride"] = 156.75}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 398.75, ["Ride"] = 467.5, ["Fly|Ride"] = 672.38, ["Neon"] = 2750, ["Mega"] = 17212.88}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.87, ["Fly"] = 27.23, ["Ride"] = 41.24, ["Fly|Ride"] = 69.41, ["Neon"] = 13.75, ["Neon|Ride"] = 286.21, ["Neon|Fly|Ride"] = 136.13, ["Mega"] = 72.09, ["Mega|Fly"] = 148.49, ["Mega|Ride"] = 151.25, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.73, ["Fly"] = 162.78, ["Ride"] = 22.17, ["Fly|Ride"] = 66, ["Neon"] = 17.88, ["Neon|Ride"] = 39.88, ["Neon|Fly|Ride"] = 104.5, ["Mega"] = 363, ["Mega|Ride"] = 166.73, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.95, ["Fly"] = 80.7, ["Ride"] = 75.63, ["Fly|Ride"] = 537.92, ["Neon"] = 82.5, ["Neon|Ride"] = 187.09, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 830.54, ["Mega|Ride"] = 416.41}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.02, ["Fly"] = 137.5, ["Ride"] = 18.24, ["Fly|Ride"] = 756.25, ["Neon"] = 55.96, ["Mega"] = 268.13}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.32, ["Fly"] = 45.21, ["Ride"] = 97.19, ["Fly|Ride"] = 164.99, ["Neon"] = 54.91, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 376.09, ["Mega|Ride"] = 420.07, ["Mega|Fly|Ride"] = 679.95}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.35, ["Fly"] = 109.99, ["Ride"] = 37.13, ["Fly|Ride"] = 193.66, ["Neon"] = 58.11, ["Neon|Ride"] = 105.45, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 226.78, ["Mega|Fly"] = 501.41, ["Mega|Ride"] = 273.3, ["Mega|Fly|Ride"] = 295.63}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.2, ["Fly"] = 27.5, ["Ride"] = 15.13, ["Fly|Ride"] = 70.12, ["Neon"] = 2.2, ["Neon|Fly"] = 43.99, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 80.7, ["Mega"] = 16.32, ["Mega|Fly"] = 64.57, ["Mega|Ride"] = 37.07, ["Mega|Fly|Ride"] = 82.5}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.95, ["Fly"] = 287.26, ["Ride"] = 28.88, ["Fly|Ride"] = 162.78, ["Neon"] = 24.31, ["Neon|Fly"] = 121.5, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 115.41, ["Mega"] = 151.25, ["Mega|Ride"] = 176, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 288.75, ["Fly"] = 437.34, ["Ride"] = 330, ["Fly|Ride"] = 412.5, ["Neon"] = 1519.05, ["Neon|Ride"] = 1237.5, ["Neon|Fly|Ride"] = 1095.87, ["Mega|Fly|Ride"] = 4402.75}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 103.12, ["Ride"] = 97.19, ["Fly|Ride"] = 308.54, ["Neon"] = 330, ["Neon|Ride"] = 430.39, ["Neon|Fly|Ride"] = 717.58, ["Mega"] = 4303.24, ["Mega|Ride"] = 1578.42, ["Mega|Fly|Ride"] = 1620.57}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.2, ["Fly"] = 17.23, ["Ride"] = 23.09, ["Fly|Ride"] = 41.25, ["Neon"] = 12.17, ["Neon|Fly"] = 72.1, ["Neon|Ride"] = 34.45, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 62.41, ["Mega|Fly"] = 214.12, ["Mega|Ride"] = 129.13, ["Mega|Fly|Ride"] = 172.17}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.2, ["Fly"] = 21.53, ["Ride"] = 15.35, ["Fly|Ride"] = 33.51, ["Neon"] = 8.63, ["Neon|Fly"] = 41, ["Neon|Ride"] = 24.57, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 74.25, ["Mega|Fly"] = 110, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 165}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 4.13, ["Ride"] = 23.38, ["Fly|Ride"] = 103.13, ["Neon"] = 39.88, ["Neon|Fly|Ride"] = 430.34, ["Mega"] = 144.17, ["Mega|Ride"] = 144.19, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 259.88, ["Fly"] = 440, ["Ride"] = 291.53, ["Fly|Ride"] = 359.33, ["Neon|Ride"] = 1865.69, ["Neon|Fly|Ride"] = 1397.48, ["Mega|Ride"] = 8607.53, ["Mega|Fly|Ride"] = 3850}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 4.01, ["Fly"] = 50.58, ["Ride"] = 17.23, ["Fly|Ride"] = 42.95, ["Neon"] = 29.07, ["Neon|Fly"] = 81.13, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 86.09, ["Mega"] = 235.13, ["Mega|Ride"] = 343.75, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.33, ["Fly"] = 162.8, ["Ride"] = 72.09, ["Fly|Ride"] = 215.18, ["Neon"] = 38.75, ["Neon|Ride"] = 145.75, ["Mega"] = 258.21, ["Mega|Ride"] = 272.25, ["Mega|Fly|Ride"] = 316.25}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.2, ["Ride"] = 27.5, ["Neon"] = 5.22, ["Neon|Ride"] = 137.49, ["Mega"] = 55, ["Mega|Ride"] = 101.16, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 17.23, ["Fly"] = 37.67, ["Ride"] = 25.84, ["Fly|Ride"] = 59.95, ["Neon"] = 68.75, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 763.13, ["Mega|Ride"] = 525.25, ["Mega|Fly|Ride"] = 632.39}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 55.24, ["Ride"] = 96.38, ["Fly|Ride"] = 219.99, ["Neon"] = 165, ["Neon|Fly"] = 412.5, ["Neon|Ride"] = 178.75, ["Neon|Fly|Ride"] = 275, ["Mega"] = 440, ["Mega|Fly"] = 2259.49, ["Mega|Ride"] = 448.25, ["Mega|Fly|Ride"] = 631.58}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.74, ["Fly"] = 58.11, ["Ride"] = 48.6, ["Fly|Ride"] = 103.77, ["Neon"] = 164.88, ["Neon|Fly"] = 303.88, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 198.61, ["Mega|Ride"] = 734.25, ["Mega|Fly|Ride"] = 846.77}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.2, ["Fly"] = 19.96, ["Ride"] = 15.6, ["Fly|Ride"] = 32.81, ["Neon"] = 2.75, ["Neon|Fly"] = 31.6, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 38.5, ["Mega"] = 21.53, ["Mega|Fly"] = 432.15, ["Mega|Ride"] = 45.2, ["Mega|Fly|Ride"] = 121}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 238.9, ["Ride"] = 287.36, ["Fly|Ride"] = 317.39, ["Neon"] = 3401.05, ["Neon|Ride"] = 932.73, ["Neon|Fly|Ride"] = 1363.06, ["Mega|Fly|Ride"] = 4574.9}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11, ["Fly"] = 64.56, ["Ride"] = 57.09, ["Fly|Ride"] = 110, ["Neon"] = 133.95, ["Neon|Ride"] = 208.96, ["Neon|Fly|Ride"] = 343.74, ["Mega"] = 430.34, ["Mega|Ride"] = 467.5, ["Mega|Fly|Ride"] = 618.75}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.2, ["Fly"] = 20.46, ["Ride"] = 16.97, ["Fly|Ride"] = 41.25, ["Neon"] = 10.98, ["Neon|Ride"] = 26.88, ["Neon|Fly|Ride"] = 114.05, ["Mega"] = 61.97, ["Mega|Fly"] = 287.29, ["Mega|Ride"] = 151.25, ["Mega|Fly|Ride"] = 154.95}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.17, ["Fly"] = 36.59, ["Ride"] = 19.38, ["Fly|Ride"] = 58.12, ["Neon"] = 2.64, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 23.09, ["Neon|Fly|Ride"] = 107.42, ["Mega"] = 23.15, ["Mega|Fly"] = 144.19, ["Mega|Ride"] = 50.88, ["Mega|Fly|Ride"] = 162.8}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.2, ["Ride"] = 30.25, ["Fly|Ride"] = 72.57, ["Neon"] = 11.26, ["Neon|Ride"] = 42.63, ["Neon|Fly|Ride"] = 7172.41, ["Mega"] = 127.31, ["Mega|Ride"] = 129.13, ["Mega|Fly|Ride"] = 387.35}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 14.58, ["Fly"] = 40.58, ["Ride"] = 24.75, ["Fly|Ride"] = 71.5, ["Neon"] = 46.75, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 129.25, ["Mega"] = 367.17, ["Mega|Ride"] = 258.25, ["Mega|Fly|Ride"] = 370.81}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.87, ["Fly"] = 58.11, ["Ride"] = 41.24, ["Fly|Ride"] = 75.63, ["Neon"] = 51.66, ["Neon|Ride"] = 148.49, ["Neon|Fly|Ride"] = 275, ["Mega"] = 357.19, ["Mega|Ride"] = 376.6, ["Mega|Fly|Ride"] = 388.76}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.2, ["Fly|Ride"] = 286.18, ["Neon"] = 3.67, ["Neon|Ride"] = 31.56, ["Neon|Fly|Ride"] = 104.5, ["Mega"] = 19.25, ["Mega|Ride"] = 71.41, ["Mega|Fly|Ride"] = 129.13}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.63, ["Ride"] = 26.13, ["Fly|Ride"] = 68.75, ["Neon"] = 45.31, ["Neon|Fly"] = 107.82, ["Neon|Ride"] = 67.37, ["Neon|Fly|Ride"] = 141.77, ["Mega"] = 165, ["Mega|Ride"] = 222.74, ["Mega|Fly|Ride"] = 296.98}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.2, ["Ride"] = 117.32, ["Neon"] = 4.13, ["Neon|Fly"] = 101.16, ["Neon|Ride"] = 137.49, ["Neon|Fly|Ride"] = 107.17, ["Mega"] = 26.12, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.2, ["Fly"] = 40.68, ["Ride"] = 21.53, ["Fly|Ride"] = 64.56, ["Neon"] = 6.77, ["Neon|Ride"] = 27.99, ["Neon|Fly|Ride"] = 91.48, ["Mega"] = 47.69, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 715, ["Ride"] = 741.65, ["Fly|Ride"] = 825, ["Neon"] = 4284.94, ["Neon|Ride"] = 3300, ["Neon|Fly|Ride"] = 3344.26, ["Mega|Fly|Ride"] = 13191.61}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.2, ["Fly"] = 16.5, ["Ride"] = 15.7, ["Fly|Ride"] = 35.75, ["Neon"] = 51.66, ["Neon|Fly"] = 34.45, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 48.6, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.6, ["Ride"] = 32.81, ["Fly|Ride"] = 170.06, ["Neon"] = 12.17, ["Neon|Ride"] = 43.99, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 61.87, ["Mega|Fly"] = 330, ["Mega|Ride"] = 114.22, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.49, ["Fly"] = 32.81, ["Ride"] = 23.37, ["Fly|Ride"] = 56.38, ["Neon"] = 49.5, ["Neon|Fly"] = 129.13, ["Neon|Ride"] = 50.57, ["Neon|Fly|Ride"] = 110.87, ["Mega"] = 342.12, ["Mega|Ride"] = 323.13, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.2, ["Fly"] = 20.52, ["Ride"] = 16.5, ["Fly|Ride"] = 35.2, ["Neon"] = 8.67, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 25.95, ["Neon|Fly|Ride"] = 61.88, ["Mega"] = 74.25, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 266.85}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 104.49, ["Ride"] = 75.63, ["Fly|Ride"] = 215.18, ["Neon"] = 268.13, ["Neon|Ride"] = 269.7, ["Mega"] = 939.13, ["Mega|Ride"] = 1435.32}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.2, ["Ride"] = 19.29, ["Neon"] = 8.63, ["Neon|Fly"] = 138.51, ["Neon|Ride"] = 33.37, ["Neon|Fly|Ride"] = 109.5, ["Mega"] = 70.13, ["Mega|Ride"] = 119.34, ["Mega|Fly|Ride"] = 371.25}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 4.02, ["Fly"] = 77, ["Ride"] = 23.37, ["Fly|Ride"] = 60.26, ["Neon"] = 20.63, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 44, ["Mega"] = 123.75, ["Mega|Ride"] = 230.27, ["Mega|Fly|Ride"] = 171.88}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.62, ["Fly"] = 27.5, ["Neon"] = 5.5, ["Neon|Fly"] = 65.61, ["Mega"] = 97.95, ["Mega|Fly"] = 430.39, ["Mega|Fly|Ride"] = 605}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.2, ["Fly"] = 68.75, ["Ride"] = 18.59, ["Fly|Ride"] = 92.54, ["Neon"] = 5.44, ["Neon|Fly"] = 33, ["Neon|Ride"] = 24.58, ["Neon|Fly|Ride"] = 94.68, ["Mega"] = 46.75, ["Mega|Fly"] = 221.67, ["Mega|Ride"] = 71.33, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 33, ["Fly"] = 27.5, ["Ride"] = 24.77, ["Fly|Ride"] = 40.77, ["Neon"] = 144.2, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 98.72, ["Mega"] = 860.67, ["Mega|Fly|Ride"] = 478.1}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 829.22, ["Ride"] = 875.88, ["Fly|Ride"] = 962.5, ["Neon"] = 1856.25, ["Neon|Ride"] = 2061.13, ["Neon|Fly|Ride"] = 1925, ["Mega"] = 8176.12, ["Mega|Ride"] = 7975, ["Mega|Fly|Ride"] = 7700}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.2, ["Fly"] = 21.53, ["Ride"] = 16.5, ["Fly|Ride"] = 43.05, ["Neon"] = 6.47, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 19.43, ["Neon|Fly|Ride"] = 63.22, ["Mega"] = 60.49, ["Mega|Ride"] = 91.13, ["Mega|Fly|Ride"] = 142.05}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.17, ["Ride"] = 29.07, ["Fly|Ride"] = 55, ["Neon"] = 33, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 117.87, ["Neon|Fly|Ride"] = 273.28, ["Mega"] = 300.72, ["Mega|Ride"] = 367.93}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.26, ["Ride"] = 79.63, ["Fly|Ride"] = 110, ["Neon"] = 309.38, ["Neon|Ride"] = 281.64, ["Neon|Fly|Ride"] = 430.34, ["Mega"] = 3300.33, ["Mega|Fly|Ride"] = 1689.66}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 33, ["Fly"] = 144.17, ["Ride"] = 75.63, ["Fly|Ride"] = 107.68, ["Neon"] = 110, ["Neon|Ride"] = 201.22, ["Mega"] = 2009.62, ["Mega|Ride"] = 687.5, ["Mega|Fly|Ride"] = 763.95}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 18.24, ["Ride"] = 27.5, ["Fly|Ride"] = 129.47, ["Neon"] = 85, ["Neon|Ride"] = 139.99, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 371.8, ["Mega|Ride"] = 388.76, ["Mega|Fly|Ride"] = 478.5}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 23.35, ["Ride"] = 97.19, ["Neon"] = 81.4, ["Neon|Ride"] = 129.13, ["Mega"] = 282.33, ["Mega|Fly"] = 527.23, ["Mega|Ride"] = 371.74, ["Mega|Fly|Ride"] = 474.5}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 17.2, ["Ride"] = 92.77, ["Neon"] = 185.63, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 508.75, ["Mega"] = 550, ["Mega|Ride"] = 682.16, ["Mega|Fly|Ride"] = 481.25}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.47}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.19, ["Fly"] = 25.84, ["Ride"] = 33.37, ["Fly|Ride"] = 82.5, ["Neon"] = 35.68, ["Neon|Ride"] = 40.9, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 174.53, ["Mega|Fly"] = 476.28, ["Mega|Ride"] = 226.88, ["Mega|Fly|Ride"] = 287.29}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.16, ["Neon"] = 15.28, ["Mega"] = 907.37}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 68.75, ["Fly"] = 430.4, ["Ride"] = 80.7, ["Fly|Ride"] = 116.88, ["Neon"] = 275, ["Neon|Ride"] = 247.5, ["Neon|Fly|Ride"] = 340.32, ["Mega|Ride"] = 1042.32, ["Mega|Fly|Ride"] = 1363.22}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.66, ["Fly"] = 21.88, ["Ride"] = 17.88, ["Fly|Ride"] = 41.25, ["Neon"] = 24.09, ["Neon|Fly"] = 80.19, ["Neon|Ride"] = 31.62, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 218.65, ["Mega|Fly"] = 429.31, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.3, ["Ride"] = 32.81, ["Fly|Ride"] = 79.63, ["Neon"] = 18.13, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 142.72, ["Mega"] = 133.4, ["Mega|Ride"] = 172.17, ["Mega|Fly|Ride"] = 301.28}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.2, ["Neon"] = 4.88, ["Neon|Ride"] = 48.13, ["Mega"] = 49.79, ["Mega|Ride"] = 101.2, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 42.62, ["Fly"] = 68.75, ["Ride"] = 64.63, ["Fly|Ride"] = 126.49, ["Neon"] = 160.88, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 1147.9, ["Mega|Ride"] = 860.77, ["Mega|Fly|Ride"] = 855.55}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.2, ["Ride"] = 27.6, ["Neon"] = 5.5, ["Neon|Fly"] = 305.25, ["Neon|Ride"] = 69.14, ["Mega"] = 100.38, ["Mega|Ride"] = 96.39, ["Mega|Fly|Ride"] = 324.43}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.99, ["Ride"] = 77, ["Fly|Ride"] = 284.02, ["Neon"] = 93.6, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 400.24, ["Mega"] = 430.34, ["Mega|Ride"] = 915.75, ["Mega|Fly|Ride"] = 717.67}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.75, ["Fly"] = 24.75, ["Ride"] = 13.38, ["Fly|Ride"] = 62.36, ["Neon"] = 18.24, ["Neon|Ride"] = 31.62, ["Neon|Fly|Ride"] = 62.74, ["Mega"] = 165, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 269.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.73, ["Fly"] = 54.99, ["Ride"] = 21.66, ["Fly|Ride"] = 58.73, ["Neon"] = 165, ["Neon|Ride"] = 430.34, ["Mega"] = 162.78, ["Mega|Ride"] = 400.27, ["Mega|Fly|Ride"] = 429.7}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.2, ["Ride"] = 65.61, ["Fly|Ride"] = 137.5, ["Neon"] = 44.59, ["Neon|Ride"] = 160.55, ["Mega"] = 381.94, ["Mega|Ride"] = 288.75}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.5, ["Ride"] = 143, ["Neon"] = 163.5, ["Neon|Ride"] = 275.77, ["Neon|Fly|Ride"] = 385, ["Mega"] = 1074.74, ["Mega|Ride"] = 1707.53, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 21.88, ["Ride"] = 89.79, ["Neon"] = 137.5, ["Neon|Ride"] = 187.2, ["Neon|Fly|Ride"] = 150.64, ["Mega"] = 431.3, ["Mega|Ride"] = 344.32, ["Mega|Fly|Ride"] = 521.82}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.58, ["Ride"] = 36.59, ["Fly|Ride"] = 287.26, ["Neon"] = 50.76, ["Mega"] = 485.89, ["Mega|Ride"] = 717.67, ["Mega|Fly|Ride"] = 1721.53}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 11, ["Ride"] = 48.13, ["Fly|Ride"] = 545.41, ["Neon"] = 108.85, ["Neon|Ride"] = 286.21, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 753.08, ["Mega|Ride"] = 1134.83, ["Mega|Fly|Ride"] = 1134.65}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 4.13, ["Neon"] = 110, ["Neon|Ride"] = 287.29, ["Mega"] = 162.78, ["Mega|Ride"] = 233.75, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.2, ["Fly"] = 27.49, ["Ride"] = 18.47, ["Fly|Ride"] = 34.38, ["Neon"] = 6.86, ["Neon|Fly"] = 45.07, ["Neon|Ride"] = 35.66, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 52.83, ["Mega|Ride"] = 93.5, ["Mega|Fly|Ride"] = 167.33}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 4.02, ["Ride"] = 58.11, ["Fly|Ride"] = 75.63, ["Neon"] = 28.32, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 115.17, ["Mega"] = 200.75, ["Mega|Ride"] = 317.42, ["Mega|Fly|Ride"] = 357.23}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.2, ["Fly"] = 31.12, ["Ride"] = 19.24, ["Fly|Ride"] = 58.61, ["Neon"] = 6.88, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 48.91, ["Mega|Ride"] = 76.99, ["Mega|Fly|Ride"] = 123.75}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 4.13, ["Ride"] = 29.07, ["Fly|Ride"] = 123.75, ["Neon"] = 19.25, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 266.81, ["Mega"] = 261.25, ["Mega|Ride"] = 178.75, ["Mega|Fly|Ride"] = 485.93}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.68, ["Ride"] = 34.53, ["Fly|Ride"] = 101.15, ["Neon"] = 30.68, ["Neon|Fly"] = 330, ["Neon|Ride"] = 72.92, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 316.85, ["Mega|Ride"] = 430.39, ["Mega|Fly|Ride"] = 1075.96}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.74, ["Fly"] = 137.5, ["Ride"] = 27.22, ["Fly|Ride"] = 63.49, ["Neon"] = 27.5, ["Neon|Fly"] = 116.84, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 275.74, ["Mega|Ride"] = 269.49, ["Mega|Fly|Ride"] = 238.04}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.2, ["Fly"] = 36.43, ["Ride"] = 22, ["Fly|Ride"] = 54.14, ["Neon"] = 17.88, ["Neon|Fly"] = 86.09, ["Neon|Ride"] = 43.06, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 176, ["Mega|Ride"] = 237.8, ["Mega|Fly|Ride"] = 502.48}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.95, ["Fly"] = 60.5, ["Ride"] = 45.38, ["Fly|Ride"] = 188.38, ["Neon"] = 20.2, ["Neon|Fly"] = 82.41, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 194.36, ["Mega"] = 111.79, ["Mega|Fly"] = 108.63, ["Mega|Ride"] = 151.25, ["Mega|Fly|Ride"] = 430.38}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 20.63, ["Fly"] = 144.17, ["Ride"] = 109.99, ["Fly|Ride"] = 201.19, ["Neon"] = 93.5, ["Neon|Ride"] = 220, ["Neon|Fly|Ride"] = 324.33, ["Mega"] = 435.51, ["Mega|Fly"] = 699.37, ["Mega|Ride"] = 508.06, ["Mega|Fly|Ride"] = 653.13}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 58.32, ["Ride"] = 101.75, ["Fly|Ride"] = 200.12, ["Neon"] = 261.25, ["Neon|Ride"] = 276.38, ["Neon|Fly|Ride"] = 405.71, ["Mega"] = 1100, ["Mega|Ride"] = 1113.75, ["Mega|Fly|Ride"] = 1314.11}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.2, ["Fly"] = 53.53, ["Ride"] = 23.68, ["Fly|Ride"] = 40.89, ["Neon"] = 2.75, ["Neon|Ride"] = 43.06, ["Neon|Fly|Ride"] = 109.33, ["Mega"] = 28.88, ["Mega|Ride"] = 72.09, ["Mega|Fly|Ride"] = 137.12}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 34.64, ["Neon|Ride"] = 201.22, ["Mega"] = 952.2, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.49, ["Fly"] = 110, ["Ride"] = 116.62, ["Neon"] = 303.68, ["Neon|Ride"] = 258.25, ["Mega"] = 1753.58, ["Mega|Ride"] = 1267.48, ["Mega|Fly|Ride"] = 1045}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.61, ["Fly"] = 199.38, ["Ride"] = 32.81, ["Fly|Ride"] = 96.25, ["Neon"] = 36.58, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 247.5, ["Mega"] = 309.75, ["Mega|Ride"] = 171.88, ["Mega|Fly|Ride"] = 335.7}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.91, ["Ride"] = 115.81, ["Fly|Ride"] = 143.99, ["Neon"] = 6.43, ["Neon|Ride"] = 33.37, ["Mega"] = 57.61, ["Mega|Fly"] = 275, ["Mega|Ride"] = 80.73, ["Mega|Fly|Ride"] = 130.63}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.62, ["Fly"] = 40.9, ["Ride"] = 18.74, ["Fly|Ride"] = 48.61, ["Neon"] = 13.34, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 201.19, ["Mega|Fly"] = 359.39, ["Mega|Ride"] = 324.37}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.2, ["Fly"] = 17.55, ["Ride"] = 14.74, ["Fly|Ride"] = 45.19, ["Neon"] = 2.75, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 54.99, ["Mega"] = 26.13, ["Mega|Ride"] = 72.87}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.2, ["Ride"] = 20.63, ["Fly|Ride"] = 77.8, ["Neon"] = 5.33, ["Neon|Ride"] = 26.1, ["Neon|Fly|Ride"] = 93.5, ["Mega"] = 41.22, ["Mega|Fly"] = 176, ["Mega|Ride"] = 80.36, ["Mega|Fly|Ride"] = 162.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.2, ["Ride"] = 54.99, ["Fly|Ride"] = 162.78, ["Neon"] = 2.2, ["Neon|Ride"] = 49.5, ["Mega"] = 21.53, ["Mega|Fly|Ride"] = 286.21}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 7.55, ["Ride"] = 46.27, ["Neon"] = 38.75, ["Neon|Ride"] = 48.61, ["Neon|Fly|Ride"] = 645.51, ["Mega"] = 144.17, ["Mega|Ride"] = 242, ["Mega|Fly|Ride"] = 256.92}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.56, ["Ride"] = 33.37, ["Fly|Ride"] = 199.01, ["Neon"] = 64.57, ["Neon|Ride"] = 96.85, ["Neon|Fly|Ride"] = 275, ["Mega"] = 428.19, ["Mega|Ride"] = 302.5, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.5, ["Fly"] = 25.93, ["Ride"] = 20.62, ["Fly|Ride"] = 62.41, ["Neon"] = 27.99, ["Neon|Fly"] = 68.66, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 96.13, ["Mega|Ride"] = 358.88, ["Mega|Fly|Ride"] = 377.55}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 70.12, ["Ride"] = 200.12, ["Fly|Ride"] = 275, ["Neon"] = 230.23, ["Neon|Ride"] = 625.63, ["Mega|Fly|Ride"] = 1856.25}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.39, ["Fly"] = 75.15, ["Ride"] = 68.75, ["Fly|Ride"] = 129.11, ["Neon"] = 68.86, ["Neon|Fly|Ride"] = 660, ["Mega"] = 648.64, ["Mega|Ride"] = 866.95, ["Mega|Fly|Ride"] = 860.07}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.2, ["Fly"] = 20.45, ["Ride"] = 17.04, ["Fly|Ride"] = 43.05, ["Neon"] = 2.75, ["Neon|Fly"] = 29.07, ["Neon|Ride"] = 21.54, ["Neon|Fly|Ride"] = 53.63, ["Mega"] = 40.89, ["Mega|Ride"] = 50.88, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.2, ["Fly"] = 37.67, ["Ride"] = 15.53, ["Fly|Ride"] = 33, ["Neon"] = 5.33, ["Neon|Fly"] = 27.49, ["Neon|Ride"] = 21.53, ["Neon|Fly|Ride"] = 50.58, ["Mega"] = 46.27, ["Mega|Fly"] = 86.09, ["Mega|Ride"] = 59.13, ["Mega|Fly|Ride"] = 152.63}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 467.49, ["Ride"] = 486.75, ["Fly|Ride"] = 516.22, ["Neon|Fly|Ride"] = 1595}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 18.24, ["Ride"] = 72.09, ["Neon"] = 50.88, ["Neon|Ride"] = 115.1, ["Mega"] = 673.75, ["Mega|Ride"] = 692.45, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.2, ["Fly"] = 15.13, ["Ride"] = 15.13, ["Fly|Ride"] = 33.37, ["Neon"] = 4.56, ["Neon|Fly"] = 72.1, ["Neon|Ride"] = 21.54, ["Neon|Fly|Ride"] = 34.38, ["Mega"] = 48.6, ["Mega|Ride"] = 78.38, ["Mega|Fly|Ride"] = 107.25}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 81.13, ["Fly|Ride"] = 357.5, ["Neon"] = 247.49, ["Neon|Ride"] = 322.77, ["Neon|Fly|Ride"] = 562.65, ["Mega"] = 770, ["Mega|Ride"] = 715, ["Mega|Fly|Ride"] = 979}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.2, ["Fly"] = 19.45, ["Ride"] = 20.63, ["Fly|Ride"] = 43.05, ["Neon"] = 13.75, ["Neon|Fly"] = 43.45, ["Neon|Ride"] = 33.37, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 87.91, ["Mega|Fly"] = 144.19, ["Mega|Ride"] = 120.84, ["Mega|Fly|Ride"] = 203.75}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.2, ["Fly"] = 72.09, ["Ride"] = 35.75, ["Fly|Ride"] = 1375, ["Neon"] = 3.78, ["Neon|Fly"] = 68.75, ["Neon|Ride"] = 29.07, ["Neon|Fly|Ride"] = 98.99, ["Mega"] = 19.44, ["Mega|Fly"] = 273.3, ["Mega|Ride"] = 68.34, ["Mega|Fly|Ride"] = 218.51}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 41.23, ["Fly"] = 185.9, ["Ride"] = 90.72, ["Fly|Ride"] = 130.63, ["Neon"] = 187.22, ["Neon|Ride"] = 192.5, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 756.25, ["Mega|Ride"] = 660, ["Mega|Fly|Ride"] = 811.25}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.2, ["Ride"] = 20.62, ["Fly|Ride"] = 55, ["Neon"] = 5.5, ["Neon|Ride"] = 27.5, ["Mega"] = 42.52, ["Mega|Ride"] = 192.5, ["Mega|Fly|Ride"] = 137.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 45.81, ["Ride"] = 58.11, ["Fly|Ride"] = 137.5, ["Neon"] = 358.33, ["Neon|Ride"] = 313.08, ["Neon|Fly|Ride"] = 375.38, ["Mega"] = 1699.79, ["Mega|Ride"] = 1719.36, ["Mega|Fly|Ride"] = 1202.91}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.38, ["Ride"] = 55.53, ["Fly|Ride"] = 163.54, ["Neon"] = 22.28, ["Neon|Ride"] = 287.29, ["Mega"] = 151.25, ["Mega|Ride"] = 295.63, ["Mega|Fly|Ride"] = 485.93}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 4, ["Fly"] = 72.09, ["Ride"] = 20.63, ["Fly|Ride"] = 68.86, ["Neon"] = 10.77, ["Neon|Fly"] = 80.71, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 426.25, ["Mega"] = 111.9, ["Mega|Ride"] = 144.19, ["Mega|Fly|Ride"] = 544.5}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 35.72, ["Ride"] = 58.1, ["Fly|Ride"] = 412.49, ["Neon"] = 184.65, ["Neon|Ride"] = 412.5, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 2147.33, ["Mega|Ride"] = 2722.5, ["Mega|Fly|Ride"] = 1138.36}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.75, ["Fly"] = 222.6, ["Ride"] = 35.24, ["Fly|Ride"] = 61.88, ["Neon"] = 5.5, ["Neon|Ride"] = 36.6, ["Neon|Fly|Ride"] = 176, ["Mega"] = 48.6, ["Mega|Fly"] = 253.72, ["Mega|Ride"] = 94.88, ["Mega|Fly|Ride"] = 162.25}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.2, ["Fly"] = 34.45, ["Ride"] = 20.63, ["Fly|Ride"] = 107.78, ["Neon"] = 9.63, ["Neon|Fly"] = 43.06, ["Neon|Ride"] = 66, ["Neon|Fly|Ride"] = 101.15, ["Mega|Fly|Ride"] = 215.58}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.52, ["Fly"] = 47.35, ["Ride"] = 32.29, ["Fly|Ride"] = 85, ["Neon"] = 72.51, ["Neon|Ride"] = 140.97, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 451, ["Mega|Ride"] = 430.37, ["Mega|Fly|Ride"] = 488.13}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 68.07, ["Ride"] = 72.9, ["Fly|Ride"] = 114.18, ["Neon|Fly|Ride"] = 1004.81, ["Mega|Ride"] = 1936.7, ["Mega|Fly|Ride"] = 968.36}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 27.96, ["Fly"] = 53.62, ["Ride"] = 20.62, ["Fly|Ride"] = 77.48, ["Neon"] = 75.63, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 562.7, ["Mega|Ride"] = 274.99, ["Mega|Fly|Ride"] = 411.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 55, ["Fly"] = 303.68, ["Ride"] = 137.5, ["Fly|Ride"] = 295.63, ["Neon"] = 313.49, ["Neon|Ride"] = 297, ["Neon|Fly|Ride"] = 412.49, ["Mega|Ride"] = 1363.22, ["Mega|Fly|Ride"] = 1485}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.45, ["Ride"] = 42.79, ["Neon"] = 39.52, ["Neon|Ride"] = 81.42, ["Neon|Fly|Ride"] = 320.38, ["Mega"] = 211, ["Mega|Ride"] = 329.22, ["Mega|Fly|Ride"] = 350.77}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.87, ["Ride"] = 27.72, ["Fly|Ride"] = 82.49, ["Neon"] = 20.35, ["Neon|Ride"] = 77, ["Mega"] = 161.45, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.75, ["Fly"] = 54.99, ["Ride"] = 38.5, ["Fly|Ride"] = 97.19, ["Neon"] = 61.88, ["Neon|Ride"] = 172.17, ["Mega"] = 451, ["Mega|Ride"] = 669.63, ["Mega|Fly|Ride"] = 485.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.2, ["Fly"] = 16.39, ["Ride"] = 15.2, ["Fly|Ride"] = 33.37, ["Neon"] = 2.2, ["Neon|Fly"] = 41.25, ["Neon|Ride"] = 13.75, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 15.8, ["Mega|Fly"] = 81.42, ["Mega|Ride"] = 68.75, ["Mega|Fly|Ride"] = 97.6}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 65.52, ["Fly"] = 171.88, ["Ride"] = 137.5, ["Neon"] = 215.53, ["Neon|Fly"] = 2439.17, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 359.33, ["Mega"] = 1457.6, ["Mega|Ride"] = 1433.16, ["Mega|Fly|Ride"] = 962.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.2, ["Ride"] = 27.99, ["Fly|Ride"] = 111.9, ["Neon"] = 4.13, ["Neon|Ride"] = 43.07, ["Neon|Fly|Ride"] = 136.12, ["Mega"] = 27.42, ["Mega|Ride"] = 68.75, ["Mega|Fly|Ride"] = 321.26}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.2, ["Fly"] = 29.07, ["Ride"] = 16.5, ["Fly|Ride"] = 45.37, ["Neon"] = 12.37, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 33.37, ["Neon|Fly|Ride"] = 86.08, ["Mega"] = 269.5, ["Mega|Ride"] = 127.88, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 79.56, ["Ride"] = 120.49, ["Fly|Ride"] = 273.28, ["Neon"] = 413.12, ["Neon|Ride"] = 399.93, ["Neon|Fly|Ride"] = 645.51, ["Mega"] = 1234.75, ["Mega|Ride"] = 1333.88, ["Mega|Fly|Ride"] = 1251.25}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.64, ["Ride"] = 23.68, ["Neon"] = 8.14, ["Neon|Ride"] = 68.75, ["Mega"] = 61.88, ["Mega|Fly"] = 140.93, ["Mega|Ride"] = 162.25, ["Mega|Fly|Ride"] = 244.06}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.21}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.2, ["Ride"] = 38.41, ["Fly|Ride"] = 305.54, ["Neon"] = 5.49, ["Neon|Ride"] = 58.11, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 47.35, ["Mega|Ride"] = 129.13, ["Mega|Fly|Ride"] = 232.57}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.82, ["Ride"] = 163.54, ["Fly|Ride"] = 284.02, ["Neon"] = 563.75, ["Neon|Ride"] = 713.1, ["Neon|Fly|Ride"] = 770, ["Mega"] = 3725.36, ["Mega|Ride"] = 2296.25, ["Mega|Fly|Ride"] = 2403.66}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.11, ["Ride"] = 38.57, ["Neon"] = 20.35, ["Neon|Ride"] = 66.71, ["Neon|Fly|Ride"] = 202.27, ["Mega"] = 121, ["Mega|Ride"] = 212.51, ["Mega|Fly|Ride"] = 412.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.2, ["Fly"] = 27.5, ["Ride"] = 29.07, ["Neon"] = 4.07, ["Neon|Ride"] = 21.53, ["Neon|Fly|Ride"] = 68.75, ["Mega"] = 29.07, ["Mega|Ride"] = 104.39, ["Mega|Fly|Ride"] = 127.88}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.42, ["Ride"] = 27.99, ["Neon"] = 53.63, ["Neon|Ride"] = 115.13, ["Neon|Fly|Ride"] = 123.75, ["Mega|Ride"] = 574.78, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11, ["Fly"] = 76.4, ["Ride"] = 27.97, ["Fly|Ride"] = 43.05, ["Neon"] = 80.71, ["Neon|Ride"] = 89.37, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 416.34, ["Mega|Ride"] = 385, ["Mega|Fly|Ride"] = 482.04}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 27.5, ["Fly"] = 144.17, ["Ride"] = 54.88, ["Neon"] = 149.46, ["Neon|Ride"] = 191.13, ["Neon|Fly|Ride"] = 648.64, ["Mega"] = 687.5, ["Mega|Ride"] = 467.5, ["Mega|Fly|Ride"] = 774.69}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 137.02, ["Fly"] = 259.36, ["Ride"] = 178.75, ["Fly|Ride"] = 224.13, ["Neon"] = 502.29, ["Neon|Fly"] = 789.75, ["Neon|Ride"] = 522.49, ["Neon|Fly|Ride"] = 670.89, ["Mega|Fly|Ride"] = 2303.13}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 27.23, ["Fly"] = 35.75, ["Ride"] = 31.17, ["Fly|Ride"] = 55.88, ["Neon"] = 500.46, ["Neon|Fly"] = 6455.65, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 210.12, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 6.54, ["Fly"] = 137.48, ["Ride"] = 32.81, ["Fly|Ride"] = 94.68, ["Neon"] = 17.34, ["Neon|Ride"] = 91.13, ["Neon|Fly|Ride"] = 122.65, ["Mega"] = 104.5, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.35, ["Fly"] = 137.5, ["Ride"] = 41.25, ["Neon"] = 43.05, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 274.99, ["Mega"] = 398.75, ["Mega|Ride"] = 453.75}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 47.65, ["Ride"] = 92.56, ["Fly|Ride"] = 135.57, ["Neon"] = 230.98, ["Neon|Ride"] = 257.13, ["Neon|Fly|Ride"] = 219.89, ["Mega"] = 1130.86, ["Mega|Ride"] = 1072.5, ["Mega|Fly|Ride"] = 1129.76}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.69, ["Ride"] = 89.3, ["Neon"] = 162.78, ["Neon|Ride"] = 162.78, ["Neon|Fly|Ride"] = 474.45, ["Mega"] = 691.63, ["Mega|Ride"] = 645.57, ["Mega|Fly|Ride"] = 765.01}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 247.5, ["Ride"] = 387.3, ["Neon|Ride"] = 1787.5, ["Mega|Fly|Ride"] = 4734.14}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.74, ["Ride"] = 64.56, ["Fly|Ride"] = 109.75, ["Neon"] = 273.28, ["Neon|Ride"] = 308.58, ["Neon|Fly|Ride"] = 330, ["Mega"] = 1083.5, ["Mega|Ride"] = 943.25, ["Mega|Fly|Ride"] = 1288.27}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.2, ["Fly"] = 20.63, ["Ride"] = 16.15, ["Fly|Ride"] = 82.49, ["Neon"] = 2.73, ["Neon|Ride"] = 18.48, ["Neon|Fly|Ride"] = 67.32, ["Mega"] = 21.87, ["Mega|Fly"] = 107.61, ["Mega|Ride"] = 42.02, ["Mega|Fly|Ride"] = 114.71}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.85, ["Neon"] = 16.15, ["Neon|Ride"] = 42.62, ["Neon|Fly|Ride"] = 258.21, ["Mega"] = 206.25, ["Mega|Ride"] = 233.75, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.39, ["Ride"] = 43.05, ["Fly|Ride"] = 151.02, ["Neon"] = 18.24, ["Neon|Fly"] = 92.13, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 182.88, ["Mega"] = 117.48, ["Mega|Fly"] = 559.51, ["Mega|Ride"] = 197.99, ["Mega|Fly|Ride"] = 287.29}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 350.63, ["Fly"] = 648.64, ["Ride"] = 426.25, ["Fly|Ride"] = 591.25, ["Neon"] = 1453.8, ["Neon|Ride"] = 1755.95, ["Neon|Fly|Ride"] = 1436.88, ["Mega|Ride"] = 6025.45, ["Mega|Fly|Ride"] = 5273.13}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.74, ["Fly"] = 57.35, ["Ride"] = 16.5, ["Fly|Ride"] = 50.58, ["Neon"] = 26.13, ["Neon|Ride"] = 34.45, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 137.5, ["Mega|Ride"] = 288.28, ["Mega|Fly|Ride"] = 596.09}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.97, ["Fly"] = 23.37, ["Ride"] = 17.88, ["Fly|Ride"] = 41.25, ["Neon"] = 32.81, ["Neon|Fly"] = 163.9, ["Neon|Fly|Ride"] = 123.75, ["Mega|Ride"] = 717.67, ["Mega|Fly|Ride"] = 299.75}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.41, ["Ride"] = 28.86, ["Fly|Ride"] = 86.08, ["Neon"] = 16.49, ["Neon|Fly"] = 99, ["Neon|Ride"] = 49.5, ["Neon|Fly|Ride"] = 135.57, ["Mega"] = 275, ["Mega|Ride"] = 185.63, ["Mega|Fly|Ride"] = 258.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 58.11, ["Fly"] = 144.17, ["Ride"] = 55, ["Fly|Ride"] = 65.31, ["Neon"] = 144.85, ["Neon|Ride"] = 110, ["Neon|Fly|Ride"] = 220, ["Mega|Ride"] = 903.38, ["Mega|Fly|Ride"] = 673.75}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.2, ["Fly"] = 32.93, ["Ride"] = 42.62, ["Fly|Ride"] = 73.17, ["Neon"] = 16.15, ["Neon|Ride"] = 119.63, ["Mega"] = 166.42, ["Mega|Ride"] = 430.39, ["Mega|Fly|Ride"] = 791.32}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.88, ["Fly"] = 825, ["Ride"] = 33.37, ["Fly|Ride"] = 89.37, ["Neon"] = 129.25, ["Neon|Ride"] = 162.8, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.2, ["Ride"] = 20.08, ["Fly|Ride"] = 43.14, ["Neon"] = 3.45, ["Neon|Ride"] = 30.13, ["Mega"] = 41.25, ["Mega|Ride"] = 135.58, ["Mega|Fly|Ride"] = 305.25}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.75, ["Ride"] = 140.95, ["Neon"] = 86.08, ["Neon|Ride"] = 214.12, ["Mega"] = 163.35, ["Mega|Ride"] = 301.28}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11, ["Ride"] = 81.79, ["Fly|Ride"] = 72.9, ["Neon"] = 109.89, ["Neon|Ride"] = 106.54, ["Neon|Fly|Ride"] = 430.34, ["Mega"] = 342.12, ["Mega|Ride"] = 358.38, ["Mega|Fly|Ride"] = 506.79}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 12.38, ["Fly"] = 20.63, ["Ride"] = 27.48, ["Fly|Ride"] = 62.23, ["Neon"] = 48.12, ["Neon|Fly"] = 94.88, ["Neon|Ride"] = 49.5, ["Neon|Fly|Ride"] = 137.49, ["Mega"] = 604.62, ["Mega|Ride"] = 431.5, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 241.81, ["Fly"] = 387.3, ["Ride"] = 273.28, ["Fly|Ride"] = 385, ["Neon"] = 1457.6, ["Neon|Ride"] = 1100, ["Neon|Fly|Ride"] = 1004.54, ["Mega|Fly|Ride"] = 4862}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.2, ["Ride"] = 16.35, ["Fly|Ride"] = 59.49, ["Neon"] = 10.01, ["Neon|Fly"] = 81.42, ["Neon|Ride"] = 35.24, ["Neon|Fly|Ride"] = 151.95, ["Mega"] = 230.23, ["Mega|Ride"] = 162.8, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.61, ["Ride"] = 48.13, ["Fly|Ride"] = 115.7, ["Neon"] = 37.13, ["Neon|Ride"] = 37.67, ["Neon|Fly|Ride"] = 171.88, ["Mega"] = 296.39, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 430.38}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 48.36, ["Ride"] = 109.33, ["Neon"] = 108.51, ["Neon|Ride"] = 185.63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 389.28, ["Mega|Ride"] = 380.88, ["Mega|Fly|Ride"] = 541.07}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 123.75, ["Fly"] = 412.5, ["Ride"] = 230.23, ["Fly|Ride"] = 308.54, ["Neon"] = 611.88, ["Neon|Ride"] = 551.02, ["Neon|Fly|Ride"] = 810.5, ["Mega"] = 2429.33, ["Mega|Ride"] = 1879.63, ["Mega|Fly|Ride"] = 2341.63}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 27.21, ["Fly"] = 115.12, ["Ride"] = 58.11, ["Fly|Ride"] = 111.9, ["Neon"] = 88, ["Neon|Ride"] = 138.88, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 281.79, ["Mega|Ride"] = 301.93, ["Mega|Fly|Ride"] = 555.21}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.2, ["Ride"] = 15.68, ["Fly|Ride"] = 61.25, ["Neon"] = 5.5, ["Neon|Fly|Ride"] = 61.88, ["Mega"] = 53.45, ["Mega|Ride"] = 202.89, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 17, ["Ride"] = 50.88, ["Neon"] = 104.5, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 129.99, ["Mega"] = 220, ["Mega|Ride"] = 464.06, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 68.05, ["Fly"] = 199.38, ["Ride"] = 120.6, ["Fly|Ride"] = 220, ["Neon"] = 139.87, ["Neon|Ride"] = 182.88, ["Neon|Fly|Ride"] = 317.52, ["Mega"] = 471.05, ["Mega|Ride"] = 467.49, ["Mega|Fly|Ride"] = 570.63}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.74, ["Ride"] = 81.4, ["Neon"] = 8.17, ["Neon|Ride"] = 214.12, ["Neon|Fly|Ride"] = 110, ["Mega"] = 60.5, ["Mega|Fly"] = 251.78, ["Mega|Ride"] = 135.58, ["Mega|Fly|Ride"] = 149.88}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 16.15, ["Ride"] = 378.7, ["Neon"] = 119.63, ["Neon|Ride"] = 420.13, ["Mega"] = 429.26, ["Mega|Fly|Ride"] = 789.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 989.99, ["Fly"] = 1272.98, ["Ride"] = 1049, ["Fly|Ride"] = 1148.26, ["Neon|Ride"] = 3657.75, ["Neon|Fly|Ride"] = 2873.74, ["Mega|Fly|Ride"] = 13466.46}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.25, ["Fly"] = 121.5, ["Ride"] = 72.09, ["Fly|Ride"] = 196.63, ["Neon"] = 172.17, ["Neon|Fly"] = 244.26, ["Neon|Ride"] = 594, ["Neon|Fly|Ride"] = 324.33, ["Mega"] = 1004.81, ["Mega|Ride"] = 572.41, ["Mega|Fly|Ride"] = 735.71}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 4.24, ["Fly"] = 51.59, ["Ride"] = 24.31, ["Fly|Ride"] = 84.74, ["Neon"] = 17.23, ["Neon|Ride"] = 37.67, ["Neon|Fly|Ride"] = 159.24, ["Mega"] = 97.19, ["Mega|Ride"] = 101.75, ["Mega|Fly|Ride"] = 163.32}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 27.97, ["Ride"] = 137.47, ["Fly|Ride"] = 72.09, ["Neon"] = 107.6, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 264.66, ["Mega|Ride"] = 302.49, ["Mega|Fly|Ride"] = 511.09}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.2, ["Ride"] = 24.77, ["Fly|Ride"] = 55, ["Neon"] = 2.75, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 96.25, ["Mega"] = 17.49, ["Mega|Fly"] = 129.13, ["Mega|Ride"] = 48.03, ["Mega|Fly|Ride"] = 133.76}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 63.45, ["Ride"] = 123.74, ["Fly|Ride"] = 268.12, ["Neon"] = 272.25, ["Neon|Fly"] = 364.46, ["Neon|Ride"] = 357.88, ["Neon|Fly|Ride"] = 502.42, ["Mega"] = 1152.54, ["Mega|Ride"] = 1157.74, ["Mega|Fly|Ride"] = 1143.89}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.5, ["Fly"] = 182.88, ["Ride"] = 26.13, ["Fly|Ride"] = 72.09, ["Neon"] = 48.13, ["Neon|Ride"] = 82.5, ["Mega"] = 322.77, ["Mega|Ride"] = 385.2, ["Mega|Fly|Ride"] = 426.25}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.74, ["Fly"] = 102.34, ["Ride"] = 21.53, ["Neon"] = 12.25, ["Neon|Ride"] = 58.13, ["Mega"] = 101.75, ["Mega|Ride"] = 164.99, ["Mega|Fly|Ride"] = 373.37}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 45.38, ["Ride"] = 78.37, ["Fly|Ride"] = 162.78, ["Neon"] = 203.44, ["Neon|Fly"] = 287.29, ["Neon|Ride"] = 144.19, ["Neon|Fly|Ride"] = 346.43, ["Mega"] = 519.89, ["Mega|Ride"] = 671.4, ["Mega|Fly|Ride"] = 713.1}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 56.37, ["Ride"] = 93.5, ["Fly|Ride"] = 199.38, ["Neon"] = 550, ["Neon|Ride"] = 150.64, ["Neon|Fly|Ride"] = 172.15, ["Mega"] = 447.57, ["Mega|Ride"] = 528.15, ["Mega|Fly|Ride"] = 860.77}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 61.87, ["Neon"] = 324.33, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 451.85, ["Mega"] = 1564.24, ["Mega|Ride"] = 1721.53, ["Mega|Fly|Ride"] = 1654.22}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.23, ["Neon"] = 22, ["Neon|Ride"] = 88.25, ["Neon|Fly|Ride"] = 165, ["Mega"] = 121.49, ["Mega|Fly|Ride"] = 278.17}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.79, ["Ride"] = 20.62, ["Fly|Ride"] = 54.99, ["Neon"] = 46.26, ["Neon|Ride"] = 72.9, ["Neon|Fly|Ride"] = 132.38, ["Mega"] = 418, ["Mega|Ride"] = 381.47, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 130.63, ["Ride"] = 144.2, ["Fly|Ride"] = 306.11, ["Neon"] = 523.93, ["Neon|Ride"] = 599.5, ["Neon|Fly|Ride"] = 539.06, ["Mega"] = 3289.82, ["Mega|Ride"] = 2444.75, ["Mega|Fly|Ride"] = 1979.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.2, ["Fly"] = 22.88, ["Ride"] = 19.14, ["Fly|Ride"] = 34.38, ["Neon"] = 11.48, ["Neon|Fly"] = 67.37, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 82.48, ["Mega"] = 101.15, ["Mega|Ride"] = 170.01, ["Mega|Fly|Ride"] = 207.2}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.88, ["Fly"] = 38.88, ["Ride"] = 32.81, ["Fly|Ride"] = 61.88, ["Neon"] = 43.05, ["Neon|Fly"] = 324.37, ["Neon|Ride"] = 58.34, ["Neon|Fly|Ride"] = 183.98, ["Mega"] = 359.33, ["Mega|Ride"] = 336.88, ["Mega|Fly|Ride"] = 342.1}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.2, ["Ride"] = 15.13, ["Fly|Ride"] = 42.79, ["Neon"] = 2.2, ["Neon|Fly"] = 26.09, ["Neon|Ride"] = 16.15, ["Neon|Fly|Ride"] = 46.75, ["Mega"] = 15.23, ["Mega|Fly"] = 51.04, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 124.83}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.2, ["Ride"] = 55.96, ["Neon"] = 4.12, ["Neon|Ride"] = 40.89, ["Mega"] = 24.77, ["Mega|Fly"] = 123.74, ["Mega|Ride"] = 54.45, ["Mega|Fly|Ride"] = 165.74}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.64, ["Fly"] = 134.92, ["Ride"] = 20.63, ["Fly|Ride"] = 48.13, ["Neon"] = 43.05, ["Neon|Ride"] = 61.2, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 103.13, ["Mega|Fly|Ride"] = 244.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 61.87, ["Ride"] = 206.25, ["Neon"] = 342.38, ["Neon|Ride"] = 430.39, ["Neon|Fly|Ride"] = 660, ["Mega"] = 433.93, ["Mega|Ride"] = 411.13, ["Mega|Fly|Ride"] = 697.23}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.2, ["Fly"] = 20.63, ["Ride"] = 19.38, ["Fly|Ride"] = 38.88, ["Neon"] = 13.38, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.63, ["Neon|Fly|Ride"] = 72.33, ["Mega"] = 119.63, ["Mega|Fly"] = 178.72, ["Mega|Ride"] = 136.13, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.83, ["Fly"] = 34.26, ["Ride"] = 24.74, ["Fly|Ride"] = 66.57, ["Neon"] = 20.3, ["Neon|Fly"] = 63.5, ["Neon|Ride"] = 34.38, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 177.37, ["Mega|Fly"] = 453.75, ["Mega|Ride"] = 175.98, ["Mega|Fly|Ride"] = 225.49}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.3, ["Fly"] = 20.63, ["Ride"] = 18.24, ["Fly|Ride"] = 41.25, ["Neon"] = 9.5, ["Neon|Fly"] = 103.12, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 42.63, ["Mega|Fly"] = 101.75, ["Mega|Ride"] = 129.13, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.45, ["Fly"] = 177.38, ["Ride"] = 48.12, ["Fly|Ride"] = 55, ["Neon"] = 50.58, ["Neon|Ride"] = 61.88, ["Neon|Fly|Ride"] = 172.15, ["Mega"] = 230.23, ["Mega|Fly"] = 419.38, ["Mega|Ride"] = 273.3, ["Mega|Fly|Ride"] = 660.64}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.45, ["Fly"] = 178.6, ["Ride"] = 72.09, ["Fly|Ride"] = 230.83, ["Neon"] = 96.14, ["Neon|Ride"] = 264.03, ["Neon|Fly|Ride"] = 359.33, ["Mega"] = 405.71, ["Mega|Fly|Ride"] = 717.67}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.88, ["Fly"] = 50.88, ["Ride"] = 21.53, ["Fly|Ride"] = 66.69, ["Neon"] = 32.29, ["Neon|Fly"] = 206.02, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 110, ["Mega"] = 324.33, ["Mega|Ride"] = 230.27, ["Mega|Fly|Ride"] = 436.57}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.2, ["Fly"] = 21.89, ["Ride"] = 16.5, ["Fly|Ride"] = 29.08, ["Neon"] = 10.88, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 29.06, ["Neon|Fly|Ride"] = 75.63, ["Mega"] = 82.5, ["Mega|Ride"] = 93.61, ["Mega|Fly|Ride"] = 213.1}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 198, ["Fly"] = 412.5, ["Ride"] = 275, ["Fly|Ride"] = 206.25, ["Neon"] = 989.88, ["Neon|Ride"] = 1291.14, ["Neon|Fly|Ride"] = 1237.5, ["Mega|Fly|Ride"] = 2744.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.27, ["Ride"] = 64.7, ["Neon"] = 44.98, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 123.75, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 494.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 4, ["Fly"] = 27.5, ["Ride"] = 21.66, ["Fly|Ride"] = 79.63, ["Neon"] = 23.38, ["Neon|Fly"] = 215.2, ["Neon|Ride"] = 86.09, ["Neon|Fly|Ride"] = 211.41, ["Mega"] = 206.25, ["Mega|Ride"] = 287.29, ["Mega|Fly|Ride"] = 232.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 19.45, ["Ride"] = 25.84, ["Neon"] = 53.45, ["Neon|Ride"] = 223.6, ["Neon|Fly|Ride"] = 645.51, ["Mega"] = 483.76, ["Mega|Ride"] = 687.5, ["Mega|Fly|Ride"] = 574.07}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.2, ["Fly"] = 16.82, ["Ride"] = 16.15, ["Fly|Ride"] = 32.29, ["Neon"] = 2.2, ["Neon|Fly"] = 20.63, ["Neon|Ride"] = 17.23, ["Neon|Fly|Ride"] = 44.39, ["Mega"] = 18.58, ["Mega|Fly"] = 170.5, ["Mega|Ride"] = 25.84, ["Mega|Fly|Ride"] = 101.05}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.39, ["Fly"] = 43.05, ["Ride"] = 16.5, ["Fly|Ride"] = 61.78, ["Neon"] = 9.63, ["Neon|Ride"] = 29.07, ["Neon|Fly|Ride"] = 99.32, ["Mega"] = 108.75, ["Mega|Ride"] = 129.58, ["Mega|Fly|Ride"] = 219.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 50.58, ["Fly|Ride"] = 102.22, ["Neon"] = 22, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 412.5, ["Mega"] = 61.85, ["Mega|Ride"] = 215.2, ["Mega|Fly|Ride"] = 287.29}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 78.38, ["Fly"] = 110, ["Ride"] = 110, ["Fly|Ride"] = 172.15, ["Neon"] = 412.5, ["Neon|Ride"] = 481.25, ["Neon|Fly|Ride"] = 440, ["Mega"] = 2151.63, ["Mega|Ride"] = 3588.27, ["Mega|Fly|Ride"] = 1787.5}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.03, ["Fly"] = 89.38, ["Ride"] = 34.43, ["Fly|Ride"] = 68.75, ["Neon"] = 23.38, ["Neon|Ride"] = 57.09, ["Neon|Fly|Ride"] = 115.12, ["Mega"] = 221.61, ["Mega|Ride"] = 335.7, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.2, ["Fly"] = 22, ["Ride"] = 49.65, ["Fly|Ride"] = 123.75, ["Neon"] = 8.63, ["Neon|Ride"] = 82.5, ["Neon|Fly|Ride"] = 544.27, ["Mega"] = 43.05, ["Mega|Fly"] = 328.63, ["Mega|Ride"] = 132, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.13, ["Fly"] = 220, ["Ride"] = 104.55, ["Fly|Ride"] = 230.8, ["Neon"] = 123.75, ["Neon|Ride"] = 178.74, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 481.25, ["Mega|Ride"] = 538.11, ["Mega|Fly|Ride"] = 716.6}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.2, ["Fly"] = 13.75, ["Ride"] = 16.15, ["Fly|Ride"] = 37.67, ["Neon"] = 2.75, ["Neon|Fly"] = 23.69, ["Neon|Ride"] = 16.15, ["Neon|Fly|Ride"] = 42.63, ["Mega"] = 19.24, ["Mega|Fly"] = 51.2, ["Mega|Ride"] = 36.61, ["Mega|Fly|Ride"] = 86.09}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.2, ["Neon"] = 4.33, ["Neon|Ride"] = 48.62, ["Neon|Fly|Ride"] = 97.18, ["Mega"] = 63.19, ["Mega|Ride"] = 85.06, ["Mega|Fly|Ride"] = 247.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.21, ["Fly"] = 75.63, ["Ride"] = 55, ["Neon"] = 13.38, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 189.36, ["Mega"] = 61.88, ["Mega|Fly"] = 187.22, ["Mega|Ride"] = 121.68, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.41, ["Fly"] = 72.9, ["Ride"] = 54.73, ["Fly|Ride"] = 116.88, ["Neon"] = 41.25, ["Neon|Fly"] = 143, ["Neon|Ride"] = 74.05, ["Neon|Fly|Ride"] = 233.35, ["Mega"] = 101.74, ["Mega|Fly"] = 231, ["Mega|Ride"] = 189.31, ["Mega|Fly|Ride"] = 261.24}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.2, ["Fly"] = 16.5, ["Ride"] = 14.55, ["Fly|Ride"] = 37.67, ["Neon"] = 2.75, ["Neon|Fly"] = 19.8, ["Neon|Ride"] = 25.83, ["Neon|Fly|Ride"] = 49.5, ["Mega"] = 22.59, ["Mega|Fly"] = 41.25, ["Mega|Ride"] = 33.7, ["Mega|Fly|Ride"] = 159.16}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.88, ["Fly"] = 75.63, ["Ride"] = 43.05, ["Fly|Ride"] = 105.69, ["Neon"] = 82.5, ["Neon|Ride"] = 192.49, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 519.89, ["Mega|Ride"] = 429.31, ["Mega|Fly|Ride"] = 716.6}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2695, ["Fly"] = 3300, ["Ride"] = 2887.5, ["Fly|Ride"] = 2750, ["Mega|Fly|Ride"] = 37586.84}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.2, ["Fly"] = 54.88, ["Ride"] = 21.53, ["Fly|Ride"] = 47.38, ["Neon"] = 9.74, ["Neon|Fly"] = 58.11, ["Neon|Ride"] = 27.21, ["Neon|Fly|Ride"] = 75.33, ["Mega"] = 75.63, ["Mega|Fly"] = 157.1, ["Mega|Ride"] = 110, ["Mega|Fly|Ride"] = 185.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.75, ["Neon"] = 22.28, ["Mega"] = 132, ["Mega|Fly"] = 462, ["Mega|Ride"] = 457.88, ["Mega|Fly|Ride"] = 645.57}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.87, ["Fly"] = 43.06, ["Ride"] = 34.36, ["Fly|Ride"] = 72.88, ["Neon"] = 105.46, ["Neon|Ride"] = 93.61, ["Neon|Fly|Ride"] = 105.48, ["Mega"] = 412.39, ["Mega|Ride"] = 410.69, ["Mega|Fly|Ride"] = 484}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 36.46, ["Ride"] = 103.13, ["Neon"] = 157.92, ["Neon|Ride"] = 227.19, ["Mega"] = 566.5, ["Mega|Ride"] = 837.09, ["Mega|Fly|Ride"] = 843.1}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 175.09, ["Fly"] = 1435.14, ["Ride"] = 207.17, ["Fly|Ride"] = 248.53, ["Neon"] = 1375, ["Neon|Ride"] = 752.11, ["Neon|Fly|Ride"] = 753.08, ["Mega"] = 6454.84, ["Mega|Ride"] = 3642.01, ["Mega|Fly|Ride"] = 3158.1}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.43, ["Fly"] = 29.07, ["Ride"] = 30.25, ["Fly|Ride"] = 708.13, ["Neon"] = 13.75, ["Neon|Ride"] = 134.83, ["Mega"] = 201.19, ["Mega|Fly"] = 13750, ["Mega|Ride"] = 227.92, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 4.13, ["Ride"] = 72.09, ["Fly|Ride"] = 97.19, ["Neon"] = 16.15, ["Neon|Fly"] = 101.16, ["Neon|Fly|Ride"] = 537.92, ["Mega"] = 120.22, ["Mega|Ride"] = 335.5, ["Mega|Fly|Ride"] = 439.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.57, ["Fly"] = 106.84, ["Ride"] = 46.17, ["Fly|Ride"] = 206.25, ["Neon"] = 10.77, ["Neon|Ride"] = 48.43, ["Mega"] = 72.11, ["Mega|Ride"] = 117.89, ["Mega|Fly|Ride"] = 321.72}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 18.24, ["Ride"] = 41.25, ["Neon"] = 67.38, ["Neon|Ride"] = 1221.33, ["Mega"] = 391.87, ["Mega|Ride"] = 631.59, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.2, ["Neon"] = 2.41, ["Neon|Ride"] = 93.94, ["Mega"] = 17.86, ["Mega|Ride"] = 129.13, ["Mega|Fly|Ride"] = 430.39}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 68.75, ["Fly"] = 144.17, ["Ride"] = 82.49, ["Fly|Ride"] = 144.17, ["Neon"] = 430.34, ["Neon|Fly"] = 324.37, ["Neon|Ride"] = 412.5, ["Neon|Fly|Ride"] = 430.34, ["Mega"] = 1430, ["Mega|Fly|Ride"] = 1806.24}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.2, ["Ride"] = 34.38, ["Neon"] = 10.36, ["Neon|Ride"] = 144.19, ["Mega"] = 64.63, ["Mega|Ride"] = 159.26, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 38.5, ["Fly"] = 227.15, ["Ride"] = 78.37, ["Fly|Ride"] = 137.5, ["Neon"] = 275, ["Neon|Ride"] = 343.64, ["Neon|Fly|Ride"] = 415.62, ["Mega"] = 2750, ["Mega|Ride"] = 1936.7, ["Mega|Fly|Ride"] = 1512.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.2, ["Fly"] = 55, ["Ride"] = 20.45, ["Fly|Ride"] = 32.81, ["Neon"] = 6.47, ["Neon|Fly"] = 27.5, ["Neon|Ride"] = 61.25, ["Neon|Fly|Ride"] = 68.75, ["Mega"] = 47.19, ["Mega|Ride"] = 123.75, ["Mega|Fly|Ride"] = 172.85}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.2, ["Neon"] = 19.25, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 178.75, ["Mega"] = 378.13, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 632.66}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.5, ["Fly|Ride"] = 214.17, ["Neon"] = 43.06, ["Neon|Ride"] = 99, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 232.39, ["Mega|Ride"] = 321.75, ["Mega|Fly|Ride"] = 935}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 372.63, ["Fly"] = 574.5, ["Ride"] = 437.25, ["Fly|Ride"] = 522.5, ["Neon"] = 1237.49, ["Neon|Ride"] = 1601.01, ["Neon|Fly|Ride"] = 1375, ["Mega|Ride"] = 3849.99, ["Mega|Fly|Ride"] = 3980.63}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.31, ["Ride"] = 54.14, ["Fly|Ride"] = 132, ["Neon"] = 215.18, ["Neon|Ride"] = 230.23, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1269.62, ["Mega|Fly|Ride"] = 1053.24}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.2, ["Fly"] = 44.79, ["Ride"] = 20.45, ["Fly|Ride"] = 96.25, ["Neon"] = 8.25, ["Neon|Fly"] = 89.38, ["Neon|Ride"] = 54.88, ["Neon|Fly|Ride"] = 72.09, ["Mega"] = 52.25, ["Mega|Ride"] = 89.38, ["Mega|Fly|Ride"] = 192.49}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.24, ["Fly"] = 376.55, ["Ride"] = 48.6, ["Fly|Ride"] = 138.49, ["Neon"] = 38.5, ["Neon|Fly"] = 110, ["Neon|Ride"] = 114.22, ["Neon|Fly|Ride"] = 182.41, ["Mega"] = 250.25, ["Mega|Fly"] = 400.27, ["Mega|Ride"] = 255.75, ["Mega|Fly|Ride"] = 357.41}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.74, ["Ride"] = 24.22, ["Fly|Ride"] = 41.25, ["Neon"] = 145.25, ["Neon|Ride"] = 33.37, ["Neon|Fly|Ride"] = 324.33, ["Mega"] = 430.34, ["Mega|Ride"] = 714.75, ["Mega|Fly|Ride"] = 403.08}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.75, ["Ride"] = 223.79, ["Neon"] = 16.39, ["Mega"] = 72.88, ["Mega|Ride"] = 127.88, ["Mega|Fly|Ride"] = 426.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.75, ["Fly"] = 41.25, ["Ride"] = 19.05, ["Fly|Ride"] = 49.5, ["Neon"] = 13.75, ["Neon|Ride"] = 34.35, ["Neon|Fly|Ride"] = 219.48, ["Mega"] = 60.5, ["Mega|Ride"] = 510.13, ["Mega|Fly|Ride"] = 1001.71}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 111.47, ["Ride"] = 133.38, ["Fly|Ride"] = 187.2, ["Neon|Ride"] = 742.38, ["Neon|Fly|Ride"] = 893.75, ["Mega|Fly|Ride"] = 3507.57}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.32, ["Fly"] = 100.38, ["Ride"] = 98.99, ["Fly|Ride"] = 144.17, ["Neon"] = 202.13, ["Neon|Ride"] = 201.29, ["Mega"] = 687.5, ["Mega|Ride"] = 699.37, ["Mega|Fly|Ride"] = 801.79}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2322.37, ["Fly"] = 2475, ["Ride"] = 2200, ["Fly|Ride"] = 2461.25, ["Neon"] = 11475.62, ["Neon|Fly|Ride"] = 8112.5, ["Mega|Fly|Ride"] = 27500}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.2, ["Fly"] = 68750, ["Ride"] = 115.5, ["Fly|Ride"] = 178.75, ["Neon"] = 13.64, ["Neon|Ride"] = 142, ["Neon|Fly|Ride"] = 201.19, ["Mega"] = 123.75, ["Mega|Ride"] = 159.15, ["Mega|Fly|Ride"] = 601.46}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 28.27, ["Ride"] = 41.25, ["Neon"] = 48.13, ["Neon|Ride"] = 125.14, ["Neon|Fly|Ride"] = 243.38, ["Mega"] = 228.25, ["Mega|Ride"] = 251.63, ["Mega|Fly|Ride"] = 534.2}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 903.87, ["Fly"] = 1243.82, ["Ride"] = 957, ["Fly|Ride"] = 1021.63, ["Neon"] = 2722.5, ["Neon|Ride"] = 2475, ["Neon|Fly|Ride"] = 2598.74, ["Mega|Fly|Ride"] = 12034}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 41.97, ["Ride"] = 59.13, ["Fly|Ride"] = 140.95, ["Neon"] = 165, ["Neon|Ride"] = 305.61, ["Neon|Fly|Ride"] = 387.3, ["Mega"] = 830.54, ["Mega|Ride"] = 810.3, ["Mega|Fly|Ride"] = 845.7}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 4.13, ["Ride"] = 24, ["Fly|Ride"] = 134.19, ["Neon"] = 16.16, ["Neon|Ride"] = 43.06, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 206.25, ["Mega|Ride"] = 129.13, ["Mega|Fly|Ride"] = 379.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.2, ["Fly"] = 55, ["Ride"] = 144.17, ["Neon"] = 4.13, ["Neon|Ride"] = 42.59, ["Neon|Fly|Ride"] = 81.4, ["Mega"] = 29.04, ["Mega|Ride"] = 111.38, ["Mega|Fly|Ride"] = 287.29}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 85.25, ["Ride"] = 133.38, ["Fly|Ride"] = 301.24, ["Neon"] = 481.25, ["Neon|Ride"] = 454.36, ["Neon|Fly|Ride"] = 440, ["Mega"] = 2869.18, ["Mega|Fly|Ride"] = 2406.25}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.2}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.88, ["Fly|Ride"] = 75.63, ["Neon"] = 27.99, ["Neon|Ride"] = 64.57, ["Mega"] = 144.38, ["Mega|Ride"] = 213.05, ["Mega|Fly|Ride"] = 276.27}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 82.37, ["Ride"] = 140.08, ["Neon"] = 404.25, ["Neon|Ride"] = 485.38, ["Neon|Fly|Ride"] = 517.86, ["Mega"] = 2044.05, ["Mega|Fly|Ride"] = 2136.74}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 8.03, ["Fly"] = 110, ["Fly|Ride"] = 115.12, ["Neon"] = 41.25, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 213.13, ["Mega|Fly|Ride"] = 330}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 244.75, ["Ride"] = 320.57, ["Fly|Ride"] = 337.61, ["Neon"] = 1132.47, ["Neon|Ride"] = 875.87, ["Neon|Fly|Ride"] = 920.86, ["Mega|Fly|Ride"] = 4430.74}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.88, ["Fly"] = 92.12, ["Ride"] = 27.61, ["Fly|Ride"] = 54.88, ["Neon|Ride"] = 67.98, ["Neon|Fly|Ride"] = 119.59, ["Mega|Ride"] = 323.13, ["Mega|Fly|Ride"] = 272.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.2, ["Fly"] = 21.87, ["Ride"] = 15.17, ["Fly|Ride"] = 39.19, ["Neon"] = 5.34, ["Neon|Fly"] = 32.38, ["Neon|Ride"] = 23.35, ["Neon|Fly|Ride"] = 51.66, ["Mega"] = 55, ["Mega|Fly"] = 123.75, ["Mega|Ride"] = 67.8, ["Mega|Fly|Ride"] = 162.79}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 934.89, ["Ride"] = 1032.79, ["Fly|Ride"] = 1076.22, ["Neon|Ride"] = 7890.94, ["Neon|Fly|Ride"] = 4948.72, ["Mega"] = 27254.43, ["Mega|Fly|Ride"] = 28692.05}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 15.43, ["Fly"] = 1004.81, ["Ride"] = 220, ["Neon"] = 70.13, ["Neon|Ride"] = 135.45, ["Mega"] = 247.12, ["Mega|Ride"] = 192.5, ["Mega|Fly|Ride"] = 341.7}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 16.15, ["Fly"] = 48.28, ["Ride"] = 34.38, ["Fly|Ride"] = 133.38, ["Neon"] = 26.82, ["Neon|Fly"] = 81.42, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 142.99, ["Mega"] = 183.47, ["Mega|Ride"] = 172.99, ["Mega|Fly|Ride"] = 310.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 36.59, ["Fly"] = 42.48, ["Ride"] = 46.26, ["Fly|Ride"] = 66.28, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 187, ["Mega"] = 2151.63, ["Mega|Ride"] = 797.5, ["Mega|Fly|Ride"] = 837.38}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 20.46, ["Fly"] = 80.71, ["Ride"] = 32.81, ["Fly|Ride"] = 92.13, ["Neon"] = 50.58, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 152.63, ["Mega"] = 359.33, ["Mega|Fly"] = 385, ["Mega|Ride"] = 394.63, ["Mega|Fly|Ride"] = 456.22}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 30.03, ["Ride"] = 219.99, ["Fly|Ride"] = 123.75, ["Neon"] = 101.15, ["Neon|Ride"] = 286, ["Neon|Fly|Ride"] = 275, ["Mega"] = 506.72, ["Mega|Ride"] = 600.4, ["Mega|Fly|Ride"] = 574.57}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.2, ["Ride"] = 122.16, ["Fly|Ride"] = 242.95, ["Neon"] = 3.04, ["Neon|Fly"] = 58.25, ["Neon|Ride"] = 75.53, ["Mega"] = 17.88, ["Mega|Fly"] = 60.5, ["Mega|Ride"] = 67.18}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.66, ["Fly"] = 93.5, ["Ride"] = 72.11, ["Fly|Ride"] = 137.1, ["Neon"] = 356.11, ["Neon|Fly"] = 338.94, ["Neon|Ride"] = 279.77, ["Neon|Fly|Ride"] = 275, ["Mega"] = 3442.6, ["Mega|Ride"] = 1150.44, ["Mega|Fly|Ride"] = 1002.27}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.75, ["Fly"] = 29.07, ["Ride"] = 19.42, ["Fly|Ride"] = 73.25, ["Neon"] = 34.37, ["Neon|Ride"] = 41.25, ["Mega"] = 809.88, ["Mega|Ride"] = 365.07, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.2, ["Fly"] = 25.84, ["Ride"] = 21.53, ["Fly|Ride"] = 39.86, ["Neon"] = 13.33, ["Neon|Ride"] = 29.08, ["Neon|Fly|Ride"] = 128.7, ["Mega|Ride"] = 278.56, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.42, ["Ride"] = 179.68, ["Neon"] = 110, ["Neon|Fly"] = 55, ["Neon|Ride"] = 860.77, ["Neon|Fly|Ride"] = 192.58, ["Mega"] = 258.21, ["Mega|Fly|Ride"] = 481.25}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 32.81, ["Fly"] = 275, ["Ride"] = 91.12, ["Fly|Ride"] = 192.5, ["Neon"] = 204.88, ["Neon|Ride"] = 255.2, ["Neon|Fly|Ride"] = 316.25, ["Mega"] = 760.6, ["Mega|Ride"] = 884.81, ["Mega|Fly|Ride"] = 792}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 9.12, ["Ride"] = 717.58, ["Neon"] = 22.81, ["Neon|Ride"] = 80.72, ["Neon|Fly|Ride"] = 144.17, ["Mega"] = 95.58, ["Mega|Fly"] = 317.42, ["Mega|Fly|Ride"] = 324.37}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.2, ["Ride"] = 35.39, ["Neon"] = 2.73, ["Neon|Ride"] = 21.58, ["Mega"] = 16.49, ["Mega|Ride"] = 34.38, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.2, ["Fly"] = 72.09, ["Ride"] = 26.29, ["Fly|Ride"] = 84.92, ["Neon"] = 2.68, ["Neon|Ride"] = 33.27, ["Mega"] = 23.38, ["Mega|Ride"] = 41.88, ["Mega|Fly|Ride"] = 111.38}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.2, ["Fly"] = 20.95, ["Ride"] = 75.63, ["Fly|Ride"] = 53.39, ["Neon"] = 8.24, ["Neon|Fly"] = 129.13, ["Neon|Ride"] = 31.6, ["Neon|Fly|Ride"] = 58.11, ["Mega"] = 64.63, ["Mega|Ride"] = 144.19, ["Mega|Fly|Ride"] = 145.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.63, ["Ride"] = 29.07, ["Fly|Ride"] = 115.12, ["Neon"] = 16.15, ["Neon|Ride"] = 1375, ["Mega"] = 110, ["Mega|Ride"] = 111.36, ["Mega|Fly|Ride"] = 261.25}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.2, ["Fly"] = 39.86, ["Ride"] = 15.84, ["Fly|Ride"] = 37.13, ["Neon"] = 15.11, ["Neon|Ride"] = 32.83, ["Neon|Fly|Ride"] = 81.27, ["Mega"] = 322.45, ["Mega|Ride"] = 285.32, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 73.29, ["Ride"] = 158.13, ["Fly|Ride"] = 376.55, ["Neon"] = 171.87, ["Neon|Ride"] = 242.28, ["Neon|Fly|Ride"] = 1075.82, ["Mega"] = 925.2, ["Mega|Ride"] = 925.37, ["Mega|Fly|Ride"] = 970.64}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.2, ["Fly"] = 19.38, ["Ride"] = 17.23, ["Fly|Ride"] = 40.5, ["Neon"] = 2.75, ["Neon|Fly"] = 25.84, ["Neon|Ride"] = 21.53, ["Neon|Fly|Ride"] = 48.13, ["Mega"] = 41.25, ["Mega|Ride"] = 42.62, ["Mega|Fly|Ride"] = 105.4}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.17, ["Fly"] = 63.28, ["Ride"] = 41.97, ["Fly|Ride"] = 78.38, ["Neon"] = 43.05, ["Neon|Fly"] = 79.75, ["Neon|Ride"] = 78.38, ["Neon|Fly|Ride"] = 119.63, ["Mega"] = 275, ["Mega|Ride"] = 226.87, ["Mega|Fly|Ride"] = 313.49}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.66, ["Fly"] = 54.88, ["Ride"] = 29.81, ["Fly|Ride"] = 75.63, ["Neon"] = 98.99, ["Neon|Ride"] = 107.24, ["Neon|Fly|Ride"] = 165, ["Mega"] = 1215.67, ["Mega|Ride"] = 545.52, ["Mega|Fly|Ride"] = 570.51}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.1, ["Fly"] = 206.25, ["Neon"] = 55, ["Mega"] = 137.5, ["Mega|Ride"] = 258.64, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.2, ["Fly"] = 20.63, ["Ride"] = 16.39, ["Fly|Ride"] = 40.89, ["Neon"] = 5.43, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 48.02, ["Mega"] = 53.48, ["Mega|Fly"] = 137.5, ["Mega|Ride"] = 64.63, ["Mega|Fly|Ride"] = 137.39}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.35, ["Fly"] = 72.09, ["Ride"] = 29.07, ["Neon"] = 16.15, ["Neon|Fly"] = 123.75, ["Neon|Ride"] = 101.13, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 133.38, ["Mega|Fly"] = 770, ["Mega|Ride"] = 206.25, ["Mega|Fly|Ride"] = 391.65}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 990, ["Fly"] = 1288.83, ["Ride"] = 1031.12, ["Fly|Ride"] = 1106.15, ["Neon|Ride"] = 2296.22, ["Neon|Fly|Ride"] = 2447.5, ["Mega|Fly|Ride"] = 6187.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 76.19, ["Ride"] = 123.75, ["Fly|Ride"] = 428.19, ["Neon"] = 337.81, ["Neon|Ride"] = 479.88, ["Neon|Fly|Ride"] = 617.53, ["Mega"] = 2915.19, ["Mega|Ride"] = 2009.87, ["Mega|Fly|Ride"] = 1622.5}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.74, ["Ride"] = 41.25, ["Neon"] = 5.49, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 215.18, ["Mega"] = 75.63, ["Mega|Ride"] = 107.61, ["Mega|Fly|Ride"] = 187.22}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 56.06, ["Fly"] = 149.56, ["Ride"] = 82.5, ["Fly|Ride"] = 244.22, ["Neon"] = 247.5, ["Neon|Ride"] = 339.79, ["Neon|Fly|Ride"] = 372.92, ["Mega"] = 1072.5, ["Mega|Ride"] = 1183.86, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.1, ["Ride"] = 21.09, ["Fly|Ride"] = 68.75, ["Neon"] = 64.79, ["Neon|Ride"] = 51.8, ["Neon|Fly|Ride"] = 286.18, ["Mega"] = 123.75, ["Mega|Ride"] = 361.53, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 263.99, ["Fly"] = 430.34, ["Ride"] = 322.8, ["Fly|Ride"] = 329.21, ["Neon|Ride"] = 1370.76, ["Neon|Fly|Ride"] = 1452.36, ["Mega|Fly|Ride"] = 4518.96}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.58, ["Fly"] = 79.24, ["Ride"] = 27.5, ["Fly|Ride"] = 211.75, ["Neon"] = 25.83, ["Neon|Ride"] = 56.96, ["Mega"] = 426.03, ["Mega|Fly"] = 335.7}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.2, ["Ride"] = 27.42, ["Neon"] = 34.38, ["Mega"] = 344.28, ["Mega|Ride"] = 342.17}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 68.6, ["Ride"] = 101.15, ["Fly|Ride"] = 550, ["Neon"] = 574.5, ["Neon|Ride"] = 405.76, ["Mega"] = 567.81, ["Mega|Ride"] = 750.77, ["Mega|Fly|Ride"] = 1011.99}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.64, ["Ride"] = 51.9, ["Neon"] = 21.45, ["Mega"] = 82.5, ["Mega|Ride"] = 262.68, ["Mega|Fly|Ride"] = 475.09}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.2, ["Fly"] = 19.25, ["Ride"] = 15.01, ["Fly|Ride"] = 34.03, ["Neon"] = 3.82, ["Neon|Fly"] = 32.78, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 43.05, ["Mega"] = 25.84, ["Mega|Ride"] = 41.25, ["Mega|Fly|Ride"] = 106.91}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4537.49, ["Ride"] = 4658.5, ["Fly|Ride"] = 4262.5, ["Neon"] = 32274.14, ["Neon|Fly|Ride"] = 22663.98, ["Mega|Fly|Ride"] = 88944.6}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 15.99, ["Fly"] = 41.25, ["Ride"] = 59.12, ["Neon"] = 86.08, ["Neon|Ride"] = 111.38, ["Mega"] = 286.18, ["Mega|Ride"] = 223.45, ["Mega|Fly|Ride"] = 357.5}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.73, ["Fly"] = 21.05, ["Ride"] = 20.63, ["Fly|Ride"] = 58.11, ["Neon"] = 17.75, ["Neon|Fly"] = 48.61, ["Neon|Ride"] = 29.08, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 137.5, ["Mega|Ride"] = 162.25, ["Mega|Fly|Ride"] = 189.86}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 481.25, ["Fly"] = 880, ["Ride"] = 523.87, ["Fly|Ride"] = 596.75, ["Neon"] = 1438.18, ["Neon|Ride"] = 1620.17, ["Neon|Fly|Ride"] = 1433.78, ["Mega|Fly|Ride"] = 5319.88}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 12.27, ["Ride"] = 26.18, ["Neon"] = 17.87, ["Neon|Ride"] = 152.63, ["Mega"] = 136.13, ["Mega|Ride"] = 648.73, ["Mega|Fly|Ride"] = 717.67}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 8.34, ["Fly"] = 144.19, ["Ride"] = 48.6, ["Neon"] = 137.5, ["Neon|Ride"] = 287.29, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 428.19, ["Mega|Ride"] = 372.96, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.2, ["Fly"] = 54.85, ["Ride"] = 28.97, ["Fly|Ride"] = 86.08, ["Neon"] = 4.09, ["Neon|Fly"] = 130.62, ["Neon|Ride"] = 23.69, ["Neon|Fly|Ride"] = 103.13, ["Mega"] = 37.67, ["Mega|Ride"] = 78.01, ["Mega|Fly|Ride"] = 267.44}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 770, ["Fly"] = 846.67, ["Ride"] = 682, ["Fly|Ride"] = 739.05, ["Neon"] = 2475, ["Neon|Ride"] = 2050.53, ["Neon|Fly|Ride"] = 2001.23}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.45, ["Ride"] = 82.49, ["Neon"] = 31.31, ["Neon|Ride"] = 80.71, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 151.11, ["Mega|Ride"] = 179.7, ["Mega|Fly|Ride"] = 308.7}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.88, ["Fly"] = 247.39, ["Ride"] = 66.15, ["Fly|Ride"] = 162.78, ["Neon"] = 27.74, ["Neon|Fly"] = 172.17, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 110, ["Mega"] = 192.5, ["Mega|Ride"] = 232.26, ["Mega|Fly|Ride"] = 305.25}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.2, ["Fly"] = 35.73, ["Ride"] = 20.63, ["Fly|Ride"] = 49.5, ["Neon"] = 14.04, ["Neon|Fly"] = 101.16, ["Neon|Ride"] = 33, ["Neon|Fly|Ride"] = 74.25, ["Mega"] = 68.75, ["Mega|Fly|Ride"] = 165}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.77, ["Ride"] = 31.6, ["Neon"] = 123.19, ["Neon|Fly"] = 178.75, ["Neon|Ride"] = 142.05, ["Mega"] = 485.89, ["Mega|Fly|Ride"] = 645.57}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.2, ["Neon"] = 5.38, ["Neon|Fly"] = 144.19, ["Neon|Ride"] = 40.99, ["Neon|Fly|Ride"] = 192.58, ["Mega"] = 38.49, ["Mega|Fly"] = 115.14, ["Mega|Ride"] = 96.25, ["Mega|Fly|Ride"] = 317.42}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 536.25, ["Ride"] = 544.5, ["Fly|Ride"] = 729.4, ["Neon"] = 2712.88, ["Neon|Ride"] = 2726.1, ["Neon|Fly|Ride"] = 2581.95, ["Mega|Fly|Ride"] = 8236.25}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.2, ["Ride"] = 72.9, ["Fly|Ride"] = 187.08, ["Neon"] = 12.38, ["Neon|Ride"] = 67.38, ["Neon|Fly|Ride"] = 201.19, ["Mega"] = 58.11, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 292.88}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.2, ["Ride"] = 43.17, ["Neon"] = 5.1, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 137.49, ["Mega"] = 53.63, ["Mega|Fly"] = 105.46, ["Mega|Ride"] = 144.19, ["Mega|Fly|Ride"] = 271.15}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.2, ["Ride"] = 25.61, ["Neon"] = 5.37, ["Neon|Ride"] = 43.28, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 48.13, ["Mega|Fly"] = 159.26, ["Mega|Ride"] = 82.49, ["Mega|Fly|Ride"] = 201.22}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 4.02, ["Ride"] = 137.5, ["Neon"] = 19.36, ["Neon|Ride"] = 43.06, ["Mega"] = 235.61}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 39.88, ["Fly"] = 206.25, ["Ride"] = 136.13, ["Fly|Ride"] = 189.36, ["Neon"] = 193.66, ["Neon|Ride"] = 165, ["Neon|Fly|Ride"] = 225.5, ["Mega"] = 646.64, ["Mega|Ride"] = 655.53, ["Mega|Fly|Ride"] = 701.62}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.88, ["Ride"] = 71.37, ["Fly|Ride"] = 122.15, ["Neon"] = 107.14, ["Neon|Ride"] = 134.53, ["Mega"] = 485.82, ["Mega|Ride"] = 394.63, ["Mega|Fly|Ride"] = 587.48}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.17, ["Fly"] = 25.84, ["Ride"] = 16.15, ["Fly|Ride"] = 39.87, ["Neon"] = 16.15, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 75.62, ["Mega"] = 314.2, ["Mega|Ride"] = 144.19, ["Mega|Fly|Ride"] = 203.14}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 16.04, ["Ride"] = 67.38, ["Fly|Ride"] = 107.6, ["Neon"] = 93.5, ["Neon|Ride"] = 72.1, ["Mega"] = 192.5, ["Mega|Ride"] = 225.97, ["Mega|Fly|Ride"] = 1004.94}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.2, ["Ride"] = 26.12, ["Fly|Ride"] = 63.49, ["Neon"] = 16.05, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 216.22, ["Mega"] = 87.98, ["Mega|Fly"] = 154.95, ["Mega|Ride"] = 159.26, ["Mega|Fly|Ride"] = 385}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.87, ["Fly"] = 65.61, ["Ride"] = 24.24, ["Fly|Ride"] = 162.78, ["Neon"] = 239.63, ["Neon|Ride"] = 154.97, ["Neon|Fly|Ride"] = 249.57, ["Mega"] = 1020.32, ["Mega|Ride"] = 971.85, ["Mega|Fly|Ride"] = 636.97}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.74, ["Fly"] = 915.75, ["Neon"] = 111.38, ["Mega"] = 343.75, ["Mega|Fly|Ride"] = 889.81}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 53.37, ["Fly"] = 86.08, ["Ride"] = 74.95, ["Fly|Ride"] = 171.55, ["Neon"] = 261.25, ["Neon|Fly"] = 451.91, ["Neon|Ride"] = 343.75, ["Neon|Fly|Ride"] = 365.75, ["Mega|Ride"] = 1506.33, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 45.3, ["Fly"] = 92.24, ["Ride"] = 109.99, ["Fly|Ride"] = 99, ["Neon"] = 135.88, ["Neon|Ride"] = 427.63, ["Neon|Fly|Ride"] = 242.95, ["Mega"] = 563.53, ["Mega|Ride"] = 599.5, ["Mega|Fly|Ride"] = 650.38}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 37.18, ["Ride"] = 80.7, ["Fly|Ride"] = 144.17, ["Neon"] = 133.38, ["Mega"] = 860.75, ["Mega|Fly|Ride"] = 786.53}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.63, ["Fly"] = 430.39, ["Ride"] = 48.24, ["Fly|Ride"] = 144.17, ["Neon"] = 90.25, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 479.25, ["Mega|Ride"] = 383.63, ["Mega|Fly|Ride"] = 507.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.2, ["Fly"] = 18.58, ["Ride"] = 16.14, ["Fly|Ride"] = 34.45, ["Neon"] = 5.45, ["Neon|Fly"] = 34.38, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 43.99, ["Mega|Fly"] = 215.2, ["Mega|Ride"] = 60.49, ["Mega|Fly|Ride"] = 212.45}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1943.7}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 48.61, ["Ride"] = 96.25, ["Fly|Ride"] = 137.5, ["Neon"] = 258.25, ["Neon|Ride"] = 242.98, ["Neon|Fly|Ride"] = 287.26, ["Mega"] = 716.5, ["Mega|Ride"] = 631.13, ["Mega|Fly|Ride"] = 769.32}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.2, ["Ride"] = 58.11, ["Neon"] = 6.33, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 301.24, ["Mega"] = 27.97, ["Mega|Ride"] = 64.57, ["Mega|Fly|Ride"] = 159.26}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 33.54, ["Ride"] = 77.75, ["Neon"] = 130.63, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 550, ["Mega"] = 745.25, ["Mega|Ride"] = 735.96, ["Mega|Fly|Ride"] = 790.63}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.2, ["Neon"] = 3.3, ["Neon|Ride"] = 110, ["Mega"] = 27.42}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.2, ["Neon"] = 4.13, ["Neon|Ride"] = 48.61, ["Mega"] = 25.38, ["Mega|Ride"] = 111.9, ["Mega|Fly|Ride"] = 286}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 120.04, ["Ride"] = 147.75, ["Neon"] = 522.5, ["Neon|Ride"] = 495, ["Neon|Fly|Ride"] = 703.59, ["Mega|Ride"] = 2365.25, ["Mega|Fly|Ride"] = 2198.62}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.2, ["Fly"] = 27.5, ["Ride"] = 17.88, ["Fly|Ride"] = 97.08, ["Neon"] = 10.77, ["Neon|Ride"] = 27.99, ["Neon|Fly|Ride"] = 82.5, ["Mega"] = 94.87, ["Mega|Ride"] = 107.25, ["Mega|Fly|Ride"] = 215.21}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.2, ["Fly"] = 39.88, ["Fly|Ride"] = 90.75, ["Neon"] = 4.02, ["Neon|Fly"] = 64.57, ["Neon|Ride"] = 35.75, ["Neon|Fly|Ride"] = 107.6, ["Mega"] = 33.55, ["Mega|Ride"] = 128.06, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.2, ["Neon"] = 6.76, ["Neon|Ride"] = 46.28, ["Mega"] = 33.85, ["Mega|Ride"] = 192.49}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.2, ["Ride"] = 27.5, ["Neon"] = 5.22, ["Neon|Ride"] = 137.49, ["Mega"] = 55, ["Mega|Ride"] = 101.16, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 57.75, ["Ride"] = 107.6, ["Fly|Ride"] = 471.02, ["Neon"] = 430.34, ["Neon|Ride"] = 509.94, ["Neon|Fly|Ride"] = 717.58, ["Mega|Fly|Ride"] = 1428.86}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.2, ["Ride"] = 65.61, ["Fly|Ride"] = 137.5, ["Neon"] = 44.59, ["Neon|Ride"] = 160.55, ["Mega"] = 381.94, ["Mega|Ride"] = 288.75}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.15}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 340.99, ["Ride"] = 430.34, ["Fly|Ride"] = 646.25, ["Neon"] = 1719.14, ["Neon|Ride"] = 1720.44, ["Neon|Fly|Ride"] = 1375, ["Mega|Ride"] = 4302.69, ["Mega|Fly|Ride"] = 3873.39}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.2}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 83.88}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.3}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.38}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 31.63}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 61.37}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 50.78}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.74}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.79}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 257.12}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 42.2}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.99}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.5}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.72}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 164.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.2}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 8.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.88}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.49}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 10.93}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 533.49}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.2}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.2}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 16.15}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1786.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.24}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.2}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 21.2}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.2}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.47}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 55}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 26.13}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 59.9}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 20.41}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.12}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.39}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.75}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.51}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.75}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.75}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.01}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 137.99}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.7}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.64}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1923.44}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.2}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 46.2}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 323.02}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.5}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 4.13}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.25}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 5.98}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 36.18}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 204.88}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.34}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.84}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.2}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2147.59}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.49}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.74}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 20.63}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.59}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.8}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 165}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 39.59}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.37}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.74}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.2}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 25.99}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.75}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.74}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 2046}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.12}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 37.12}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.2}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 178.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 218.24}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.5}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.63}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 21.89}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.12}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 75.63}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 27.5}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.2}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.2}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23139.67}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 574.57}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 38.5}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 85.25}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 42.28}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 287.36}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 89.38}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 38.5}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 70.13}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.59}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 34.38}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 54.99}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 43.98}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 41.22}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 185.83}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.2}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 343.84}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.73}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 5.5}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 4.67}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.49}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.38}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 86.63}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.25}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.68}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.2}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.75}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.44}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.62}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.2}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 780.99}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.08}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 604.89}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 26.12}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.75}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.2}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.75}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.2}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 44.8}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 72.9}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 50.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 47.65}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 68.75}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 23.38}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.98}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.2}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.2}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.2}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.98}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.88}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 11}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 61.34}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.2}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 4.13}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.74}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.5}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 21.99}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 160.71}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.2}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 88}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.75}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.75}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.2}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.2}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.2}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.13}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.2}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 10113.83}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.62}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.88}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 31.63}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 8.62}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.2}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 12.54}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.6}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 9.62}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 90.62}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 28.78}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.2}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 8.25}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 27.5}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.46}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.2}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 4.13}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.13}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 8.63}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.2}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.75}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.75}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 4.13}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.75}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.13}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.51}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.2}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.75}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5943.07}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 46.75}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.48}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.25}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.65}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 16.66}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.23}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.01}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.19}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.2}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.2}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 16.15}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 100.26}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.61}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.49}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.95}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 11.43}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 4.05}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.41}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4251.83}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.5}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.2}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.54}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.47}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 54.99}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 53.44}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 11.73}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 96.24}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.75}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.2}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.75}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.24}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.95}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 8}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.82}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.5}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 34.45}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.35}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.64}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.75}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.77}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.2}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.2}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.87}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.74}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.2}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.13}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 6.47}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.88}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.59}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.74}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 1787.5}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.2}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.75}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.6}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 90.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.66}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 41.24}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.99}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1031.24}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32.87}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.75}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.95}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.2}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 10.43}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.2}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.75}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 5.45}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 71.49}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.75}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.88}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.2}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 20.63}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.2}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.2}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.75}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 5.19}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.13}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.2}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 17.23}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.75}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.38}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.79}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.58}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.2}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.75}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 12.17}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 53.81}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.2}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.2}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.22}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 7.31}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.55}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 15}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 41.69}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.95}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.88}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.2}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.13}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 83.86}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 4.33}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 25.87}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 4.88}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.75}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.75}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.79}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.22}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 8.17}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.2}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.55}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 96.85}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.2}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.2}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 137.38}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.5}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1100}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.2}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 222.75}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.2}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.75}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.2}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.2}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.2}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.7}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 23.37}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 63.14}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.2}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.5}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.2}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 6.47}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.2}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 38.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 5.5}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.76}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.2}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.2}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 4.54}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.2}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.2}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.2}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.52}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.75}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 15.78}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.72}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 55}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 65.34}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.62}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 4.33}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 12.17}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.62}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.75}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.23}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 114.95}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.85}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.75}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.2}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 68.11}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.84}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.2}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.2}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.2}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.5}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 94.88}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.2}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 6.47}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 59.13}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 111.91}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 330}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.91}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 132.92}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.2}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 142.65}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 4.11}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.2}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.2}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.2}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 25.76}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 34.38}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 4.13}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 43.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 76.97}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 16.34}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.2}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 30.25}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 24.75}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.5}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 20.49}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.2}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 82.5}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 75.16}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.13}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 45.38}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 4.13}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 8.24}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 48.12}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 39.12}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 77}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1842.5}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.88}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 13.38}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 37.12}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.75}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 451.96}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 25.93}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 16.5}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 38.41}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.98}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 5.22}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 286}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 46.75}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.23}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 34.38}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.35}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.28}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 76.86}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 132.74}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.2}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 94.88}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1210}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 200.75}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.65}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2200}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 438.63}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.27}},
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