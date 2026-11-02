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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1010.07, ["Ride"] = 1106.52, ["Fly|Ride"] = 1048.69, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24894.53}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 494.82, ["Fly"] = 566.23, ["Ride"] = 458.06, ["Fly|Ride"] = 539.18, ["Neon|Fly|Ride"] = 2073.75}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 4830, ["Fly|Ride"] = 4329.93, ["Neon|Fly|Ride"] = 20054.63, ["Mega|Fly|Ride"] = 69151.8}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.23, ["Ride"] = 183.75, ["Fly|Ride"] = 311.16, ["Neon"] = 1408.83, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 782.54, ["Mega"] = 4149.1, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 829.62, ["Ride"] = 563.66, ["Fly|Ride"] = 569.62, ["Neon|Ride"] = 1758.75, ["Neon|Fly|Ride"] = 1624.77, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.19, ["Ride"] = 27.68, ["Fly|Ride"] = 153.5, ["Neon"] = 72.19, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 469.29}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.02, ["Fly"] = 31.5, ["Ride"] = 27.55, ["Fly|Ride"] = 63.39, ["Neon"] = 35.28, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 45.54, ["Neon|Fly|Ride"] = 111.11, ["Mega"] = 143.71, ["Mega|Fly"] = 266.34, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 280.87}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 131.67, ["Ride"] = 138.98, ["Fly|Ride"] = 182.44, ["Neon"] = 560.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 621.34, ["Mega"] = 1450.12, ["Mega|Fly|Ride"] = 2649.21}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.75, ["Fly"] = 56.01, ["Ride"] = 55.13, ["Fly|Ride"] = 97.44, ["Neon"] = 236.91, ["Neon|Ride"] = 206.53, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1383.74, ["Mega|Ride"] = 1290.54, ["Mega|Fly|Ride"] = 1239.39}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.69, ["Fly"] = 45.48, ["Ride"] = 36.75, ["Fly|Ride"] = 64.32, ["Neon"] = 138.99, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 248.96, ["Mega|Ride"] = 1347.44, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.74, ["Fly"] = 206.07, ["Ride"] = 94.39, ["Fly|Ride"] = 131.25, ["Neon"] = 255.15, ["Neon|Fly"] = 412.85, ["Neon|Ride"] = 207.47, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1555.93}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 51.19}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 395, ["Ride"] = 357, ["Fly|Ride"] = 367.5, ["Neon"] = 1277.77, ["Neon|Ride"] = 1408.92, ["Neon|Fly|Ride"] = 1072.85, ["Mega|Fly|Ride"] = 4827.47}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.69, ["Fly"] = 122.22, ["Ride"] = 113.45, ["Fly|Ride"] = 165.37, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 548.63, ["Mega|Fly|Ride"] = 2658.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.62, ["Fly"] = 115.12, ["Ride"] = 51.35, ["Fly|Ride"] = 205.4, ["Neon"] = 32.82, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 139, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 388.34}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 116.82, ["Fly"] = 196.88, ["Ride"] = 153.57, ["Fly|Ride"] = 183.75, ["Neon"] = 939.23, ["Neon|Ride"] = 746.85, ["Neon|Fly|Ride"] = 579.99, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.94, ["Fly"] = 26.97, ["Ride"] = 19.69, ["Fly|Ride"] = 48.76, ["Neon"] = 27.57, ["Neon|Ride"] = 43.58, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 280.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 82.74, ["Fly"] = 262.5, ["Ride"] = 132.04, ["Fly|Ride"] = 271.21, ["Neon"] = 313.69, ["Neon|Fly"] = 469.66, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1383.74, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 46.68}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 45.21, ["Ride"] = 82.98, ["Fly|Ride"] = 255.29, ["Neon"] = 577.5, ["Neon|Ride"] = 678.4, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.42, ["Fly"] = 374.07, ["Ride"] = 26.25, ["Fly|Ride"] = 223.13, ["Neon"] = 203.34, ["Neon|Ride"] = 94.41, ["Neon|Fly|Ride"] = 248.96, ["Mega|Ride"] = 566.36, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 50.48, ["Fly"] = 97.13, ["Ride"] = 55.11, ["Fly|Ride"] = 103.68, ["Neon"] = 179.1, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 225.04, ["Mega"] = 1642.5, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.38, ["Fly"] = 276.9, ["Ride"] = 117.39, ["Fly|Ride"] = 180.46, ["Neon"] = 131.25, ["Neon|Fly"] = 389.79, ["Neon|Ride"] = 273.86, ["Neon|Fly|Ride"] = 297.71, ["Mega"] = 1077.74, ["Mega|Ride"] = 1240.59, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 27.56, ["Ride"] = 44.62, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 165.98, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1207.92, ["Mega|Ride"] = 2072.47, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 44.63, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 147.94, ["Neon"] = 181.52, ["Neon|Fly"] = 554.89, ["Neon|Ride"] = 298.24, ["Neon|Fly|Ride"] = 349.13, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.7, ["Fly"] = 30.19, ["Ride"] = 21.12, ["Fly|Ride"] = 52.49, ["Neon"] = 27.04, ["Neon|Fly"] = 70.54, ["Neon|Ride"] = 43.36, ["Neon|Fly|Ride"] = 105, ["Mega"] = 145.69, ["Mega|Fly"] = 21305.69, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 383.43, ["Fly|Ride"] = 442.32, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 7260.91}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.99, ["Ride"] = 36.75, ["Fly|Ride"] = 105.18, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 423.23, ["Mega|Fly|Ride"] = 921.12}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.92, ["Fly"] = 39.87, ["Ride"] = 19.86, ["Fly|Ride"] = 48.34, ["Neon"] = 51.07, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 138.98, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 412.51}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 86.1, ["Fly"] = 108.94, ["Ride"] = 102.72, ["Fly|Ride"] = 123.3, ["Neon"] = 417.99, ["Neon|Fly"] = 457.4, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 2061.08, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.68, ["Ride"] = 27.83, ["Fly|Ride"] = 75.22, ["Neon"] = 150.94, ["Neon|Ride"] = 157.35, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 703.94, ["Mega|Ride"] = 787.29, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 221.57, ["Fly"] = 350.53, ["Ride"] = 242.86, ["Fly|Ride"] = 297.67, ["Neon"] = 933.44, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 829.83, ["Mega"] = 6223.65, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2854.59}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 33.75}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 36.41, ["Ride"] = 23.63, ["Fly|Ride"] = 60.17, ["Neon"] = 19.69, ["Neon|Fly"] = 4635.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 153.54, ["Mega"] = 157.5, ["Mega|Fly"] = 346.46, ["Mega|Ride"] = 246.47, ["Mega|Fly|Ride"] = 279.24}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1937.25, ["Fly"] = 3281.25, ["Ride"] = 1967.44, ["Fly|Ride"] = 1890, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 52794.21, ["Mega|Fly|Ride"] = 31117.13}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.47, ["Fly"] = 68.1, ["Ride"] = 26.24, ["Fly|Ride"] = 133.85, ["Neon"] = 102.69, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 219.92, ["Mega"] = 525.91, ["Mega|Ride"] = 663.87, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 140.44, ["Ride"] = 144.38, ["Fly|Ride"] = 249.38, ["Neon"] = 922.03, ["Neon|Ride"] = 748.02, ["Neon|Fly|Ride"] = 761.25, ["Mega|Ride"] = 3987.29, ["Mega|Fly|Ride"] = 2628.46}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.48}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.75, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 138.98, ["Neon"] = 99.58, ["Neon|Ride"] = 117.43, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 670.9, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 735.61}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 139.13, ["Ride"] = 199.13, ["Fly|Ride"] = 190.31, ["Neon"] = 525, ["Neon|Ride"] = 513.47, ["Neon|Fly|Ride"] = 704.32, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 109.95, ["Ride"] = 138.98, ["Fly|Ride"] = 300.98, ["Neon"] = 346.42, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1968.75, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1791.39}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 64.32, ["Fly"] = 59.16, ["Ride"] = 65.63, ["Fly|Ride"] = 76.13, ["Neon"] = 622.31, ["Neon|Ride"] = 399.2, ["Neon|Fly|Ride"] = 292.48, ["Mega"] = 4149.1, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.23, ["Ride"] = 39.42, ["Fly|Ride"] = 110.99, ["Neon"] = 94.5, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 233.41, ["Mega"] = 222, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 406.88, ["Fly"] = 423.94, ["Ride"] = 443.59, ["Fly|Ride"] = 494.84, ["Neon|Ride"] = 1566.25, ["Neon|Fly|Ride"] = 1443.69, ["Mega|Fly|Ride"] = 6273.75}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 93.35, ["Fly"] = 110.98, ["Ride"] = 76.76, ["Fly|Ride"] = 131.25, ["Neon"] = 446.25, ["Neon|Ride"] = 507.22, ["Neon|Fly|Ride"] = 459.37, ["Mega|Ride"] = 2475.99, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3696, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 14520.78}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 109.94, ["Ride"] = 57.75, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 407.12, ["Mega|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 1381.66}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 76.76, ["Fly"] = 82.98, ["Ride"] = 78.75, ["Fly|Ride"] = 361.93, ["Neon"] = 585.85, ["Neon|Ride"] = 346.46, ["Neon|Fly|Ride"] = 691.87, ["Mega"] = 2351.51, ["Mega|Fly|Ride"] = 1646.17}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.74, ["Fly"] = 74.68, ["Ride"] = 46.97, ["Fly|Ride"] = 117.29, ["Neon"] = 262.5, ["Neon|Ride"] = 161.67, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.81}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 39.68, ["Ride"] = 47.25, ["Fly|Ride"] = 91.88, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 547.7, ["Mega|Fly|Ride"] = 1565.07}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 157.43, ["Ride"] = 207.42, ["Fly|Ride"] = 235.43, ["Neon|Ride"] = 1408.92, ["Neon|Fly|Ride"] = 2201.97}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1085.77, ["Ride"] = 937.13, ["Fly|Ride"] = 1029.49, ["Neon|Ride"] = 3319.29, ["Neon|Fly|Ride"] = 3912.65, ["Mega|Fly|Ride"] = 15559.08}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 24.76, ["Fly"] = 61.05, ["Ride"] = 34.06, ["Fly|Ride"] = 68.8, ["Neon"] = 178.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 226.65, ["Mega|Ride"] = 865.1, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.42}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6346.54, ["Ride"] = 5669.37, ["Fly|Ride"] = 4587.19, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40385.15}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.09, ["Fly"] = 74.68, ["Ride"] = 23.26, ["Fly|Ride"] = 60.37, ["Neon"] = 91.28, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 161.43, ["Mega"] = 624.75, ["Mega|Ride"] = 480.26, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 7.88, ["Fly"] = 41.5, ["Ride"] = 28.01, ["Fly|Ride"] = 116.22, ["Neon"] = 111.57, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 246.88, ["Mega"] = 1044.17, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 968.82}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.5, ["Fly"] = 250.08, ["Ride"] = 56.01, ["Fly|Ride"] = 89.25, ["Neon"] = 1383.56, ["Neon|Fly|Ride"] = 782.54, ["Mega"] = 4149.1}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.19, ["Ride"] = 24.93, ["Fly|Ride"] = 138.99, ["Neon"] = 44.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 483.38, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.75, ["Fly"] = 2122.32, ["Ride"] = 2191.7, ["Fly|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 5518.3, ["Mega|Fly|Ride"] = 15120}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 35057.32, ["Ride"] = 28898.52, ["Fly|Ride"] = 23471.44, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63819, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.58, ["Fly"] = 219.86, ["Ride"] = 49.87, ["Fly|Ride"] = 89.93, ["Neon"] = 138.99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 829.83, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.8, ["Fly"] = 48.76, ["Ride"] = 35.21, ["Fly|Ride"] = 105, ["Neon"] = 18.18, ["Neon|Fly"] = 96.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 151.46, ["Mega"] = 219.92, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.36}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.27, ["Ride"] = 36.75, ["Fly|Ride"] = 111.57, ["Neon"] = 61.69, ["Neon|Ride"] = 106.86, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 414.92, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 630, ["Ride"] = 781.29, ["Fly|Ride"] = 724.88, ["Neon|Ride"] = 2935.23, ["Neon|Fly|Ride"] = 2655.43, ["Mega|Fly|Ride"] = 10950.71}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 813.75, ["Fly"] = 962.07, ["Ride"] = 936.18, ["Fly|Ride"] = 892.49, ["Neon"] = 4148.6, ["Neon|Ride"] = 3397.82, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11177.65}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.12, ["Fly"] = 117.39, ["Ride"] = 43.32, ["Fly|Ride"] = 95.82, ["Neon"] = 103.69, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 201.25, ["Mega"] = 1026.81, ["Mega|Ride"] = 685.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 36.3}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.71, ["Fly"] = 93.19, ["Ride"] = 75.71, ["Fly|Ride"] = 131.72, ["Neon|Ride"] = 414.92, ["Neon|Fly|Ride"] = 391.86, ["Mega|Ride"] = 2030.99, ["Mega|Fly|Ride"] = 1930.38}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 51.98, ["Ride"] = 64.31, ["Fly|Ride"] = 214.44, ["Neon"] = 328.58, ["Neon|Fly"] = 533.17, ["Neon|Ride"] = 394.17, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1742.64, ["Mega|Fly|Ride"] = 1701.13}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.88, ["Fly"] = 32.81, ["Ride"] = 18.38, ["Fly|Ride"] = 56.01, ["Neon"] = 39.38, ["Neon|Fly"] = 525, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.06, ["Mega"] = 236.25, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 346.46}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 85.32, ["Fly"] = 133.88, ["Ride"] = 101.64, ["Fly|Ride"] = 164.07, ["Neon|Ride"] = 387.4, ["Neon|Fly|Ride"] = 353.07, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.38, ["Ride"] = 45.94, ["Fly|Ride"] = 94.56, ["Neon"] = 45.2, ["Neon|Ride"] = 136.5, ["Mega"] = 231.41, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 556.12}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.82, ["Fly"] = 40.28, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 103.73, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 733.36, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 63.4, ["Fly|Ride"] = 156.19, ["Neon"] = 245.44, ["Neon|Ride"] = 165.98, ["Neon|Fly|Ride"] = 626.51, ["Mega"] = 694.25, ["Mega|Ride"] = 547.91, ["Mega|Fly|Ride"] = 870.29}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 19.69, ["Fly"] = 124.19, ["Ride"] = 34.93, ["Fly|Ride"] = 110.35, ["Neon"] = 91.88, ["Neon|Fly"] = 553.91, ["Neon|Ride"] = 143.16, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 827.76, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6773.8, ["Fly"] = 6913.79, ["Ride"] = 6886.84, ["Fly|Ride"] = 6233.07, ["Neon"] = 34572.16, ["Neon|Fly|Ride"] = 27524.02}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 196.88, ["Fly"] = 272.98, ["Ride"] = 220.88, ["Fly|Ride"] = 261.85, ["Neon"] = 783.08, ["Neon|Fly|Ride"] = 578.86, ["Mega|Fly|Ride"] = 2052.57}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.24, ["Fly"] = 131.73, ["Ride"] = 63, ["Fly|Ride"] = 140.84, ["Neon"] = 98.44, ["Neon|Fly"] = 180.48, ["Neon|Ride"] = 103.74, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 371.98, ["Mega|Fly"] = 553.91, ["Mega|Ride"] = 367.49, ["Mega|Fly|Ride"] = 460.36}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Ride"] = 23.12, ["Fly|Ride"] = 97.51, ["Neon"] = 22.1, ["Neon|Ride"] = 56.02, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 499.8, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 35.43, ["Fly"] = 5320.76, ["Ride"] = 97.95, ["Fly|Ride"] = 195.57, ["Neon"] = 154.88, ["Neon|Fly"] = 329.83, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 435.75, ["Mega|Ride"] = 513.78, ["Mega|Fly|Ride"] = 584.72}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13125, ["Ride"] = 13827.57, ["Fly|Ride"] = 11786.93, ["Neon|Fly|Ride"] = 26593.05, ["Mega|Fly|Ride"] = 107461.34}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 157.29, ["Fly"] = 276.9, ["Ride"] = 216.43, ["Fly|Ride"] = 249.38, ["Neon"] = 1420.9, ["Neon|Ride"] = 1521.69, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4662.55}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 68.77, ["Fly"] = 112.8, ["Ride"] = 74.82, ["Fly|Ride"] = 111.33, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 378.12, ["Mega|Fly|Ride"] = 2267.49}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 13.02, ["Fly"] = 28.53, ["Ride"] = 20.55, ["Fly|Ride"] = 60.17, ["Neon"] = 76.13, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2489.46, ["Mega|Fly|Ride"] = 968.82}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 484.31, ["Ride"] = 412.39, ["Fly|Ride"] = 468.89, ["Neon"] = 1639.32, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4849.58}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.49, ["Fly"] = 31.7, ["Ride"] = 38.07, ["Fly|Ride"] = 139.13, ["Neon"] = 26.24, ["Neon|Ride"] = 63.41, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 145.95, ["Mega|Fly"] = 193.98, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 276.9, ["Ride"] = 331.86, ["Fly|Ride"] = 311.12, ["Neon"] = 968.7, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4875.2}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.01, ["Fly"] = 15.72, ["Ride"] = 18.38, ["Fly|Ride"] = 36.74, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 104.97, ["Mega"] = 2489.46, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.08}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63.4, ["Ride"] = 86.63, ["Fly|Ride"] = 525, ["Neon"] = 414.87, ["Neon|Fly"] = 1659.45, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1141.01, ["Mega|Ride"] = 1244.74, ["Mega|Fly|Ride"] = 1173.21}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.12, ["Fly"] = 102.68, ["Ride"] = 45.93, ["Fly|Ride"] = 84.67, ["Neon"] = 76.76, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 513.47, ["Mega|Ride"] = 546.66, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 36.75, ["Fly"] = 111.57, ["Ride"] = 89.53, ["Fly|Ride"] = 313.42, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 401.44, ["Mega"] = 719.88, ["Mega|Ride"] = 928.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Fly|Ride"] = 132.19, ["Neon"] = 21.23, ["Neon|Ride"] = 105.68, ["Neon|Fly|Ride"] = 136.94, ["Mega"] = 105, ["Mega|Fly|Ride"] = 462.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.43, ["Fly"] = 69.5, ["Ride"] = 27.75, ["Fly|Ride"] = 52.5, ["Neon"] = 249.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 219.92, ["Mega|Ride"] = 539.4, ["Mega|Fly|Ride"] = 809.08}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 454.27, ["Ride"] = 384.23, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2628.46, ["Mega|Fly|Ride"] = 8713.1}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 27.28, ["Fly"] = 103.72, ["Ride"] = 55.13, ["Fly|Ride"] = 103.67, ["Neon"] = 223.13, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 235.47, ["Mega"] = 717.81, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 654.67}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.99, ["Fly"] = 92.3, ["Ride"] = 72.17, ["Fly|Ride"] = 152.63, ["Neon"] = 263.45, ["Neon|Ride"] = 168.06, ["Neon|Fly|Ride"] = 346.46, ["Mega|Fly|Ride"] = 1244.74}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 25.87, ["Fly"] = 91.27, ["Ride"] = 72.19, ["Fly|Ride"] = 159.71, ["Neon"] = 111.56, ["Neon|Fly"] = 193.98, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 238.59, ["Mega"] = 315, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8491.88, ["Ride"] = 9995.9, ["Fly|Ride"] = 7872.38, ["Neon|Fly|Ride"] = 15046.5, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1652.44, ["Fly"] = 1941.45, ["Ride"] = 1575, ["Fly|Ride"] = 1460.08, ["Neon|Ride"] = 5309.24, ["Neon|Fly|Ride"] = 3937.5, ["Mega"] = 21437.3, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 497.69, ["Ride"] = 457.34, ["Fly|Ride"] = 484.32, ["Neon"] = 2281.73, ["Neon|Fly|Ride"] = 2213.55, ["Mega|Fly|Ride"] = 6732.94}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13, ["Fly"] = 28.01, ["Ride"] = 22.32, ["Fly|Ride"] = 45.94, ["Neon"] = 108.78, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 165.98, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.34, ["Fly"] = 32.82, ["Ride"] = 35.26, ["Neon"] = 20.28, ["Neon|Ride"] = 68.48, ["Neon|Fly|Ride"] = 147, ["Mega"] = 157.5, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 37.17, ["Fly"] = 53.8, ["Ride"] = 54.56, ["Fly|Ride"] = 82.55, ["Neon"] = 272.78, ["Neon|Ride"] = 158.52, ["Neon|Fly|Ride"] = 183.65, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.75, ["Fly"] = 23.62, ["Ride"] = 21.14, ["Fly|Ride"] = 39.38, ["Neon"] = 26.25, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 101.07, ["Mega|Ride"] = 193.98, ["Mega|Fly|Ride"] = 275.93}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 271.68, ["Fly"] = 320.25, ["Ride"] = 320.06, ["Fly|Ride"] = 367.5, ["Neon"] = 1116.39, ["Neon|Ride"] = 1166.82, ["Neon|Fly|Ride"] = 1198.01, ["Mega|Fly|Ride"] = 4564.01}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.91, ["Fly"] = 60.09, ["Ride"] = 39.93, ["Fly|Ride"] = 52.5, ["Neon"] = 138.14, ["Neon|Fly"] = 157.34, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 139, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 690.83}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 12.97, ["Fly"] = 26.97, ["Ride"] = 18.38, ["Fly|Ride"] = 43.35, ["Neon"] = 56.02, ["Neon|Fly"] = 133.85, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 343.01, ["Fly|Ride"] = 678.23, ["Neon|Ride"] = 2799.61, ["Mega|Fly|Ride"] = 9542.86}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.75, ["Fly"] = 1408.55, ["Ride"] = 1285.91, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 156428.07}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 91.84, ["Fly"] = 90.57, ["Ride"] = 101.06, ["Fly|Ride"] = 108.94, ["Neon"] = 414.87, ["Neon|Ride"] = 414.92, ["Neon|Fly|Ride"] = 470.93, ["Mega|Ride"] = 2351.51, ["Mega|Fly|Ride"] = 3912.65}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 150.94, ["Fly"] = 212.13, ["Ride"] = 186.22, ["Fly|Ride"] = 210, ["Neon"] = 439.69, ["Neon|Ride"] = 691.87, ["Neon|Fly|Ride"] = 525, ["Mega"] = 5532.82, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2503.64}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 20.75, ["Ride"] = 39.38, ["Neon"] = 230.41, ["Neon|Fly"] = 414.92, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 373.43, ["Mega"] = 656.25, ["Mega|Ride"] = 2074.55, ["Mega|Fly|Ride"] = 800.79}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 205.4, ["Fly|Ride"] = 414.87, ["Neon|Fly|Ride"] = 1314, ["Mega|Fly|Ride"] = 2964.7}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1796.6, ["Ride"] = 2483.25, ["Fly|Ride"] = 1866.65, ["Neon|Fly|Ride"] = 8298.19, ["Mega|Fly|Ride"] = 25029.17}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.02, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 310.12, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2282.01, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 802.67, ["Ride"] = 633.36, ["Fly|Ride"] = 648.13, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 3106.35}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 69.5, ["Ride"] = 46.9, ["Fly|Ride"] = 110.25, ["Neon"] = 331.9, ["Neon|Ride"] = 363.99, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 1174.21}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.94, ["Fly"] = 30.18, ["Ride"] = 24.91, ["Fly|Ride"] = 59.07, ["Neon"] = 27.56, ["Neon|Fly"] = 79.75, ["Neon|Ride"] = 41.85, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 159.75, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 207.47, ["Mega|Fly|Ride"] = 245.49}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 43.88, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 259.87, ["Neon|Ride"] = 413.89, ["Neon|Fly|Ride"] = 622.38, ["Mega"] = 762.6, ["Mega|Ride"] = 1383.74, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 669.38, ["Ride"] = 656.25, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 2361.19, ["Neon|Fly|Ride"] = 1876.88, ["Mega|Fly|Ride"] = 6914.46}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 557.82, ["Ride"] = 630, ["Fly|Ride"] = 866.25, ["Neon"] = 5185.72, ["Neon|Fly|Ride"] = 2346.42, ["Mega|Fly|Ride"] = 12447.27}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.44, ["Fly"] = 25.97, ["Ride"] = 21, ["Fly|Ride"] = 44.89, ["Neon"] = 207.44, ["Neon|Ride"] = 124.49, ["Neon|Fly|Ride"] = 124.19, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.39, ["Ride"] = 23.05, ["Fly|Ride"] = 64.32, ["Neon"] = 72.19, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 968.82, ["Mega|Ride"] = 445.83, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.9, ["Ride"] = 31.7, ["Fly|Ride"] = 111.45, ["Neon"] = 26.25, ["Neon|Fly"] = 313.47, ["Neon|Ride"] = 51.76, ["Neon|Fly|Ride"] = 139, ["Mega"] = 160.13, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 306.02}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.07, ["Fly"] = 53.82, ["Ride"] = 46.99, ["Fly|Ride"] = 108.56, ["Neon"] = 290.41, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 414.87, ["Neon|Ride"] = 484.42, ["Neon|Fly|Ride"] = 691.87, ["Mega|Fly|Ride"] = 1784.12}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.01, ["Fly"] = 48.57, ["Ride"] = 27.6, ["Fly|Ride"] = 83.99, ["Neon"] = 91.88, ["Neon|Ride"] = 102.27, ["Neon|Fly|Ride"] = 165.98, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.18, ["Fly"] = 65.96, ["Ride"] = 38.97, ["Fly|Ride"] = 111.57, ["Neon"] = 210, ["Neon|Ride"] = 274.32, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.29, ["Fly"] = 23.87, ["Ride"] = 17.62, ["Fly|Ride"] = 40.69, ["Neon"] = 34.29, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 90.08, ["Mega"] = 525, ["Mega|Ride"] = 276.96, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.94, ["Fly"] = 31.5, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 25.98, ["Neon|Fly"] = 70.55, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 165.98, ["Mega"] = 413.89, ["Mega|Fly"] = 470.93, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 41.99, ["Fly"] = 65.61, ["Ride"] = 41.16, ["Fly|Ride"] = 59.07, ["Neon"] = 276.94, ["Neon|Ride"] = 275.93, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1816.5, ["Fly"] = 2035.35, ["Ride"] = 1706.25, ["Fly|Ride"] = 1706.24, ["Neon|Fly"] = 4989.87, ["Neon|Fly|Ride"] = 3734.07, ["Mega|Fly|Ride"] = 16270.02}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 523.69, ["Fly"] = 547.46, ["Ride"] = 433.13, ["Fly|Ride"] = 552.72, ["Neon"] = 3131.12, ["Neon|Ride"] = 2489.46, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9649.76}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 245.39, ["Ride"] = 295.2, ["Fly|Ride"] = 470.82, ["Neon"] = 1410.52, ["Neon|Ride"] = 1425.22, ["Neon|Fly|Ride"] = 1370.42, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 21.14, ["Ride"] = 41.5, ["Fly|Ride"] = 97.13, ["Neon"] = 328.75, ["Neon|Fly"] = 414.87, ["Neon|Ride"] = 517.61, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 819.46, ["Mega|Ride"] = 933.56, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41480.63, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16275, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 412.75, ["Fly"] = 863.91, ["Ride"] = 414.82, ["Fly|Ride"] = 548.17, ["Neon"] = 1869.05, ["Neon|Ride"] = 1722.92, ["Neon|Fly|Ride"] = 1535.63, ["Mega"] = 6223.65, ["Mega|Fly|Ride"] = 5075.44}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 157.29, ["Ride"] = 133.77, ["Fly|Ride"] = 155.38, ["Mega|Fly|Ride"] = 4149.1}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.69, ["Fly"] = 262.49, ["Ride"] = 91.88, ["Fly|Ride"] = 207.54, ["Neon"] = 702.08, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 594.84, ["Mega|Fly|Ride"] = 2488.42}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.06, ["Fly"] = 94.5, ["Ride"] = 39.42, ["Fly|Ride"] = 98.48, ["Neon"] = 274.3, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 204.37, ["Mega"] = 690.83}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4809.7, ["Ride"] = 4909.25, ["Fly|Ride"] = 3937.49, ["Neon|Fly|Ride"] = 17285.1}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 35.44, ["Fly"] = 63.4, ["Ride"] = 37.79, ["Fly|Ride"] = 63, ["Neon"] = 333.94, ["Neon|Ride"] = 273.86, ["Neon|Fly|Ride"] = 219.87, ["Mega|Fly|Ride"] = 827.76}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.72, ["Fly"] = 138.98, ["Ride"] = 61.69, ["Fly|Ride"] = 93.19, ["Neon|Fly"] = 1383.56, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1565.07, ["Mega|Fly|Ride"] = 1243.7}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 623.44, ["Fly"] = 787.5, ["Ride"] = 630, ["Fly|Ride"] = 708.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 5532.82, ["Mega|Ride"] = 6085.69, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.44, ["Fly"] = 28, ["Ride"] = 24.93, ["Fly|Ride"] = 49.86, ["Neon"] = 118.13, ["Neon|Ride"] = 100.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 594.84, ["Mega|Ride"] = 588.15, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.13, ["Fly"] = 73.64, ["Ride"] = 27.71, ["Fly|Ride"] = 489.55, ["Neon"] = 77.7, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 525.91}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 96.75, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 485.63, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 703.94, ["Mega|Fly|Ride"] = 2199.04}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.93, ["Fly"] = 69.57, ["Ride"] = 138.98, ["Fly|Ride"] = 146.26, ["Neon"] = 77.96, ["Neon|Fly"] = 192.92, ["Neon|Ride"] = 136.22, ["Neon|Fly|Ride"] = 240.79, ["Mega"] = 297.71, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 469.01}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Fly"] = 5080.35, ["Ride"] = 3583.13, ["Fly|Ride"] = 3675, ["Neon|Ride"] = 11584.27, ["Neon|Fly|Ride"] = 8596.88, ["Mega"] = 41454.03, ["Mega|Fly|Ride"] = 33466.85}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 60.17, ["Ride"] = 48.57, ["Fly|Ride"] = 135.95, ["Neon"] = 193.96, ["Neon|Fly"] = 207.47, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 307.4, ["Mega|Ride"] = 968.82, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7570.22, ["Ride"] = 7570.22, ["Fly|Ride"] = 6260.63, ["Neon|Fly|Ride"] = 15905.54, ["Mega|Fly|Ride"] = 65002.7}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.92, ["Fly"] = 22.83, ["Ride"] = 18.48, ["Fly|Ride"] = 31.19, ["Neon"] = 30.09, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 454.05, ["Mega|Ride"] = 180.51, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.94, ["Fly"] = 23.5, ["Ride"] = 26.25, ["Fly|Ride"] = 49.05, ["Neon"] = 110.99, ["Neon|Ride"] = 164.94, ["Neon|Fly|Ride"] = 157.68, ["Mega|Ride"] = 1365.68, ["Mega|Fly|Ride"] = 825.96}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.16}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.68, ["Ride"] = 38.07, ["Fly|Ride"] = 116.02, ["Neon"] = 193.96, ["Neon|Ride"] = 153.54, ["Neon|Fly|Ride"] = 605.79, ["Mega"] = 828.8, ["Mega|Ride"] = 966.76, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.74, ["Fly"] = 262.5, ["Ride"] = 35.44, ["Fly|Ride"] = 136.9, ["Neon"] = 182.43, ["Neon|Ride"] = 161.24, ["Neon|Fly|Ride"] = 239.76, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1063.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 17.62, ["Fly"] = 26.97, ["Ride"] = 22.31, ["Fly|Ride"] = 44.59, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 2489.46, ["Mega|Ride"] = 585.44, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8254.66}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.35}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.13, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1095.8}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.88, ["Fly"] = 110.98, ["Ride"] = 42, ["Fly|Ride"] = 140.9, ["Neon"] = 82.99, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 273.86, ["Mega|Ride"] = 938.58, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 28.01, ["Fly|Ride"] = 60.17, ["Neon"] = 49.8, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 124.49, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 153.53, ["Fly"] = 284.16, ["Ride"] = 131.25, ["Fly|Ride"] = 412.79, ["Neon"] = 701.37, ["Neon|Ride"] = 678.11, ["Neon|Fly|Ride"] = 691.87, ["Mega|Ride"] = 3444.79, ["Mega|Fly|Ride"] = 3284.99}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 78.75, ["Ride"] = 191.63, ["Fly|Ride"] = 211.32, ["Neon"] = 675.68, ["Neon|Ride"] = 940.83, ["Neon|Fly|Ride"] = 1106.78, ["Mega"] = 2213.55, ["Mega|Ride"] = 3319.29, ["Mega|Fly|Ride"] = 2269}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.49, ["Fly"] = 259.27, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 903.54, ["Mega"] = 4564.01, ["Mega|Fly|Ride"] = 3572.63}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1521.32, ["Fly"] = 2488.85, ["Ride"] = 1435.59, ["Fly|Ride"] = 1470, ["Neon|Ride"] = 5254.83, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 27660.93}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 20.64, ["Fly"] = 80.9, ["Ride"] = 39.41, ["Fly|Ride"] = 93.45, ["Neon"] = 136.91, ["Neon|Ride"] = 165.98, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 828.8, ["Mega|Ride"] = 899.33, ["Mega|Fly|Ride"] = 1097.44}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 649.69, ["Fly"] = 2100, ["Ride"] = 726.02, ["Fly|Ride"] = 968.6, ["Neon|Fly|Ride"] = 4011.14}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.81}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 11.75, ["Ride"] = 44.63, ["Fly|Ride"] = 681.8, ["Neon"] = 98.44, ["Neon|Ride"] = 119.3, ["Neon|Fly|Ride"] = 273.86, ["Mega"] = 393.65, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.76, ["Fly"] = 48.55, ["Ride"] = 26.97, ["Fly|Ride"] = 56.01, ["Neon"] = 39.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 359.96, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 50.23}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 23.49, ["Fly"] = 108.92, ["Ride"] = 25.99, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 181.53, ["Mega"] = 787.5, ["Mega|Ride"] = 782.54, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.57, ["Fly"] = 76.76, ["Ride"] = 36.75, ["Fly|Ride"] = 60.75, ["Neon"] = 236.25, ["Neon|Ride"] = 413.89, ["Neon|Fly|Ride"] = 259.33, ["Mega"] = 946.79, ["Mega|Ride"] = 1759.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6221.08, ["Fly"] = 10954, ["Ride"] = 4987.5, ["Fly|Ride"] = 4958.63, ["Neon|Ride"] = 16596.36, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 31118.15}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.38, ["Fly"] = 41.5, ["Ride"] = 31.13, ["Fly|Ride"] = 93.94, ["Neon"] = 64.97, ["Neon|Ride"] = 77.81, ["Mega"] = 525.61, ["Mega|Ride"] = 539.4, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 97.49, ["Fly"] = 367.12, ["Ride"] = 117.64, ["Fly|Ride"] = 105, ["Neon"] = 418.69, ["Neon|Ride"] = 484.42, ["Neon|Fly|Ride"] = 658.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 76.13, ["Fly"] = 96.48, ["Ride"] = 105, ["Fly|Ride"] = 276.78, ["Neon"] = 204.39, ["Neon|Ride"] = 346.46, ["Neon|Fly|Ride"] = 463.89, ["Mega"] = 2346.42, ["Mega|Ride"] = 2800.65, ["Mega|Fly|Ride"] = 1244.74}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.24, ["Fly"] = 70.46, ["Ride"] = 31.39, ["Fly|Ride"] = 63.03, ["Neon"] = 132.78, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 132.57, ["Mega|Ride"] = 684.62, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.79, ["Fly"] = 53.27, ["Ride"] = 30.8, ["Fly|Ride"] = 82.69, ["Neon"] = 17.59, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 140.8, ["Mega"] = 144.38, ["Mega|Fly"] = 6915.5, ["Mega|Ride"] = 197.1, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.68, ["Ride"] = 35.23, ["Fly|Ride"] = 93.94, ["Neon"] = 94.4, ["Neon|Ride"] = 97.4, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 470.93, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.99, ["Fly"] = 24.81, ["Ride"] = 26.25, ["Fly|Ride"] = 60.06, ["Neon"] = 205.37, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 139, ["Mega|Fly|Ride"] = 615.78}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 187.69}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.67, ["Ride"] = 96.86, ["Neon"] = 169.32, ["Neon|Fly|Ride"] = 298.01, ["Mega"] = 523.69, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 940.83}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 190.83, ["Fly"] = 219.51, ["Ride"] = 392.06, ["Fly|Ride"] = 328.13, ["Neon"] = 553.86, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 32.81, ["Fly"] = 212.01, ["Ride"] = 98.44, ["Fly|Ride"] = 244.21, ["Neon"] = 318.42, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1179.94, ["Mega|Ride"] = 1425.22, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 888.57, ["Fly"] = 1052.16, ["Ride"] = 879.38, ["Fly|Ride"] = 829.49, ["Neon|Fly"] = 2700.26, ["Neon|Ride"] = 2591.22, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 10368.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 236.25, ["Fly"] = 415.53, ["Ride"] = 236.25, ["Fly|Ride"] = 341.25, ["Neon"] = 1181.25, ["Neon|Ride"] = 2035.88, ["Neon|Fly|Ride"] = 1591.2, ["Mega"] = 8194.46, ["Mega|Fly|Ride"] = 4840.97}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 72.6}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 15.57, ["Fly"] = 27.57, ["Ride"] = 27.8, ["Fly|Ride"] = 52.5, ["Neon"] = 77.95, ["Neon|Fly"] = 231, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 140.8, ["Mega"] = 437.26, ["Mega|Ride"] = 690.83, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 282.19, ["Fly"] = 762.36, ["Ride"] = 316.32, ["Fly|Ride"] = 387.19, ["Neon"] = 1086.75, ["Neon|Ride"] = 871.02, ["Neon|Fly|Ride"] = 936.45, ["Mega|Fly|Ride"] = 3233.75}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 23.62}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 156.19, ["Fly"] = 267.57, ["Ride"] = 213.23, ["Fly|Ride"] = 257.24, ["Neon"] = 590.63, ["Neon|Fly"] = 1659.65, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 822.69, ["Mega"] = 2362.5, ["Mega|Ride"] = 3459.31, ["Mega|Fly|Ride"] = 2572.44}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.13, ["Fly"] = 193.93, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 829.74, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 782.54}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.36, ["Ride"] = 24.91, ["Fly|Ride"] = 207.44, ["Neon"] = 39.37, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 224.06, ["Mega"] = 262.1, ["Mega|Ride"] = 346.46, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 18.38, ["Fly"] = 63, ["Ride"] = 29.29, ["Fly|Ride"] = 76.13, ["Neon"] = 174.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 234.65, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 22.83, ["Fly"] = 102.31, ["Ride"] = 44.63, ["Fly|Ride"] = 128.82, ["Neon"] = 95.82, ["Neon|Ride"] = 131.75, ["Neon|Fly|Ride"] = 244.8, ["Mega"] = 460.85, ["Mega|Ride"] = 455.34, ["Mega|Fly|Ride"] = 1037.29}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.93, ["Fly"] = 124.45, ["Ride"] = 69.5, ["Fly|Ride"] = 152.99, ["Neon"] = 25.98, ["Neon|Fly"] = 234.82, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 152.24, ["Mega|Ride"] = 181.7, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 266.47, ["Fly"] = 283.5, ["Ride"] = 262.5, ["Fly|Ride"] = 363.57, ["Neon"] = 1314.07, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1390.33}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 122.38, ["Fly"] = 1050, ["Ride"] = 175.88, ["Fly|Ride"] = 309.75, ["Neon"] = 525, ["Neon|Ride"] = 682.59, ["Neon|Fly|Ride"] = 786.19, ["Mega"] = 9957.83, ["Mega|Ride"] = 2434.42, ["Mega|Fly|Ride"] = 2226}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.18, ["Fly"] = 167.45, ["Ride"] = 87.48, ["Fly|Ride"] = 106.78, ["Neon"] = 457.4, ["Neon|Ride"] = 436.77, ["Neon|Fly|Ride"] = 457.45, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.58, ["Ride"] = 57.75, ["Fly|Ride"] = 117.42, ["Neon|Ride"] = 596.46, ["Neon|Fly|Ride"] = 481.3, ["Mega|Ride"] = 615.57, ["Mega|Fly|Ride"] = 1651.35}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.74, ["Fly"] = 75.63, ["Ride"] = 41.5, ["Fly|Ride"] = 102.38, ["Neon"] = 75.12, ["Neon|Fly"] = 207.44, ["Neon|Ride"] = 83, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 358.32, ["Mega|Fly"] = 525, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.56, ["Fly"] = 45.64, ["Ride"] = 22.83, ["Fly|Ride"] = 88.07, ["Neon"] = 22.32, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 107.89, ["Mega"] = 129.94, ["Mega|Ride"] = 173.23, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 984.38, ["Fly"] = 1082.72, ["Ride"] = 988.36, ["Fly|Ride"] = 931.87, ["Neon|Fly"] = 3444.78, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2697.07, ["Mega|Fly|Ride"] = 10221.29}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 364.24, ["Ride"] = 360.94, ["Fly|Ride"] = 459.38, ["Neon"] = 1105.61, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1798.64, ["Mega"] = 10372.72, ["Mega|Fly|Ride"] = 7330.41}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 75.75, ["Fly"] = 131.25, ["Ride"] = 106.82, ["Fly|Ride"] = 180.45, ["Neon"] = 305.97, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 401.44, ["Mega"] = 1595.57, ["Mega|Ride"] = 1499.91, ["Mega|Fly|Ride"] = 1512.35}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 255.12, ["Fly"] = 469.52, ["Ride"] = 275.63, ["Fly|Ride"] = 313.42, ["Neon"] = 1408.83, ["Neon|Ride"] = 1408.92, ["Neon|Fly|Ride"] = 1141.01, ["Mega"] = 10372.72, ["Mega|Fly|Ride"] = 5922.35}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21, ["Fly"] = 138.98, ["Ride"] = 30.19, ["Fly|Ride"] = 63.72, ["Neon"] = 157.5, ["Neon|Ride"] = 130.33, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 703.94, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 207.42, ["Ride"] = 275.86, ["Fly|Ride"] = 553.86, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 2384.7, ["Mega"] = 4128.65, ["Mega|Ride"] = 4288.1, ["Mega|Fly|Ride"] = 3912.65}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 126, ["Ride"] = 78.74, ["Fly|Ride"] = 100.85, ["Neon|Ride"] = 497.91, ["Neon|Fly|Ride"] = 450.19, ["Mega|Fly|Ride"] = 1214.06}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1640.63, ["Ride"] = 1559.35, ["Fly|Ride"] = 1443.75, ["Neon|Ride"] = 10958.93, ["Neon|Fly|Ride"] = 4149.1, ["Mega"] = 49789.05, ["Mega|Fly|Ride"] = 21852.21}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.43, ["Fly"] = 61.69, ["Ride"] = 35.42, ["Fly|Ride"] = 90.85, ["Neon"] = 62.85, ["Neon|Fly"] = 172.36, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 306.18, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 387}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 41.05, ["Fly"] = 119.1, ["Ride"] = 80.9, ["Fly|Ride"] = 161.43, ["Neon"] = 276.94, ["Neon|Ride"] = 282.39, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 890, ["Mega|Ride"] = 1015.5, ["Mega|Fly|Ride"] = 913.86}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 69.5, ["Fly"] = 74.15, ["Ride"] = 65.63, ["Fly|Ride"] = 97.49, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1508.21}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3455.36, ["Ride"] = 1175.99, ["Fly|Ride"] = 1165.5, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 465.11, ["Fly"] = 827.56, ["Ride"] = 517.49, ["Fly|Ride"] = 622.22, ["Neon|Fly|Ride"] = 2738.27, ["Mega|Fly|Ride"] = 14078.47}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 131.25, ["Fly"] = 313.42, ["Ride"] = 118.13, ["Fly|Ride"] = 206.07, ["Neon"] = 443.63, ["Neon|Fly"] = 553.91, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 590.14, ["Mega"] = 4149.1, ["Mega|Ride"] = 2628.46, ["Mega|Fly|Ride"] = 2394.98}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.18, ["Ride"] = 23.27, ["Fly|Ride"] = 91.68, ["Neon"] = 87.94, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 128.63, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 726.1}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 51.66, ["Fly"] = 100.95, ["Ride"] = 48.3, ["Fly|Ride"] = 133.85, ["Neon"] = 204.75, ["Neon|Fly"] = 413.83, ["Neon|Ride"] = 255.18, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1347.44, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 809.19, ["Ride"] = 820.32, ["Fly|Ride"] = 907.43, ["Neon"] = 2348.06, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 156428.07}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 774.38}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5669.37, ["Ride"] = 5365.54, ["Fly|Ride"] = 4475.63, ["Neon"] = 42000, ["Neon|Ride"] = 29729.25, ["Neon|Fly|Ride"] = 21839.77, ["Mega|Fly|Ride"] = 88514.54}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 264.11, ["Fly"] = 402.74, ["Ride"] = 393.75, ["Fly|Ride"] = 328.13, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 1659.65, ["Mega"] = 5808.74, ["Mega|Fly|Ride"] = 5947.73}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.19, ["Fly"] = 276.9, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 387.91, ["Neon|Ride"] = 488, ["Neon|Fly|Ride"] = 968.82, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.82, ["Fly"] = 96.55, ["Ride"] = 34.13, ["Fly|Ride"] = 103.72, ["Neon"] = 147, ["Neon|Ride"] = 85.04, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 622.38, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 14.44, ["Fly"] = 38.07, ["Ride"] = 23.63, ["Fly|Ride"] = 51.19, ["Neon|Fly"] = 276.94, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 177.18, ["Mega|Fly|Ride"] = 2199.04}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.24, ["Fly"] = 276.9, ["Ride"] = 31.12, ["Fly|Ride"] = 72.19, ["Neon"] = 103.73, ["Neon|Ride"] = 153.54, ["Neon|Fly|Ride"] = 181.56, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.92, ["Fly"] = 56.01, ["Ride"] = 19.71, ["Fly|Ride"] = 56.02, ["Neon"] = 31.38, ["Neon|Fly"] = 342.27, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 187.72, ["Mega"] = 178.5, ["Mega|Ride"] = 206.43, ["Mega|Fly|Ride"] = 306.02}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.68, ["Ride"] = 49.8, ["Fly|Ride"] = 183.75, ["Neon"] = 138.99, ["Neon|Fly"] = 829.83, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 774.86, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 305.82, ["Fly"] = 414.82, ["Ride"] = 287.44, ["Fly|Ride"] = 394.78, ["Neon|Ride"] = 1032.09, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly"] = 4355.52, ["Mega|Ride"] = 3734.19, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.92, ["Fly"] = 26.24, ["Ride"] = 14.44, ["Fly|Ride"] = 38.07, ["Neon"] = 19.66, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 69.3, ["Mega"] = 276.96, ["Mega|Ride"] = 219.4, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 31.5, ["Fly"] = 85.05, ["Ride"] = 82.68, ["Fly|Ride"] = 131.24, ["Neon"] = 164.07, ["Neon|Fly"] = 206.43, ["Neon|Ride"] = 193.5, ["Neon|Fly|Ride"] = 249.29, ["Mega"] = 523.69, ["Mega|Fly"] = 829.83, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.46, ["Fly"] = 962.52, ["Ride"] = 721.88, ["Fly|Ride"] = 809.82, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1576.32, ["Mega|Fly|Ride"] = 3657.62}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 27.42, ["Fly"] = 91.88, ["Ride"] = 47.16, ["Fly|Ride"] = 66.94, ["Neon"] = 116.82, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 2205.65, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.5, ["Fly"] = 328.13, ["Ride"] = 280.88, ["Fly|Ride"] = 344.74, ["Neon|Ride"] = 1383.74, ["Neon|Fly|Ride"] = 1021.13, ["Mega|Fly|Ride"] = 7192.46}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 132.23, ["Fly"] = 139.02, ["Ride"] = 124.69, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 679.44, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 551.25, ["Ride"] = 603.74, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2074.55, ["Neon|Fly|Ride"] = 2282.01, ["Mega|Fly|Ride"] = 7821.77}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 36.75, ["Fly|Ride"] = 92.55, ["Neon"] = 77.44, ["Neon|Fly"] = 281.78, ["Neon|Ride"] = 106.86, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 311.19, ["Mega|Ride"] = 342.17, ["Mega|Fly|Ride"] = 311.19}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3733.27, ["Fly"] = 3873.28, ["Ride"] = 3340.32, ["Fly|Ride"] = 3263.26, ["Neon"] = 7827.2, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 103.69, ["Fly"] = 138.98, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 380.63, ["Neon|Fly"] = 553.91, ["Neon|Ride"] = 484.42, ["Neon|Fly|Ride"] = 419.45, ["Mega|Fly|Ride"] = 2210.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.91, ["Fly"] = 26.61, ["Ride"] = 17.07, ["Fly|Ride"] = 41.5, ["Neon"] = 22.32, ["Neon|Fly"] = 82.99, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 124.49, ["Mega"] = 170.63, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 27.98, ["Fly|Ride"] = 82.69, ["Neon"] = 23.83, ["Neon|Fly"] = 115.07, ["Neon|Ride"] = 46.98, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 86.63, ["Fly"] = 147.32, ["Ride"] = 37.41, ["Fly|Ride"] = 64.32, ["Neon"] = 274.74, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 275.93, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1023.75, ["Ride"] = 1089.38, ["Fly|Ride"] = 1227.19}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6037.5, ["Ride"] = 7042.69, ["Fly|Ride"] = 6299.99, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.62, ["Fly"] = 36.08, ["Ride"] = 30.52, ["Fly|Ride"] = 52.89, ["Neon"] = 207.44, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 173.64, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 746.85}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.33, ["Ride"] = 35.26, ["Fly|Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 186.76, ["Mega"] = 642.48, ["Mega|Ride"] = 622.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 64.97, ["Fly"] = 157.49, ["Ride"] = 59.07, ["Fly|Ride"] = 108.94, ["Neon"] = 328.13, ["Neon|Ride"] = 375.73, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1659.65, ["Mega|Ride"] = 1802.79, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 196.88, ["Fly"] = 313.42, ["Ride"] = 238.41, ["Fly|Ride"] = 276.94, ["Neon"] = 978.04, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 913.26, ["Mega"] = 10372.72, ["Mega|Fly|Ride"] = 3630.46}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.87, ["Ride"] = 36.3, ["Fly|Ride"] = 86.62, ["Neon"] = 28.02, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 244.05, ["Mega"] = 158.82, ["Mega|Ride"] = 163.87, ["Mega|Fly|Ride"] = 323.65}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.39, ["Fly"] = 263.42, ["Ride"] = 227.07, ["Fly|Ride"] = 288.75, ["Neon"] = 840, ["Neon|Ride"] = 829.83, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3733.15}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.84, ["Fly"] = 20.65, ["Ride"] = 15.75, ["Fly|Ride"] = 40.69, ["Neon"] = 18.51, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 93.37, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 245.99}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 267.57, ["Ride"] = 253.55, ["Fly|Ride"] = 261.37, ["Neon|Ride"] = 783.14, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10372.72, ["Mega|Fly|Ride"] = 4135.61}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.58, ["Fly"] = 39.93, ["Ride"] = 28.91, ["Fly|Ride"] = 61.63, ["Neon"] = 81.38, ["Neon|Fly"] = 298.22, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 519.74, ["Mega|Ride"] = 580.89, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.62, ["Ride"] = 20.25, ["Fly|Ride"] = 86.63, ["Neon"] = 16.62, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 78.68, ["Neon|Fly|Ride"] = 171.51, ["Mega"] = 110.25, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.93, ["Neon|Ride"] = 28.02, ["Mega"] = 26.25, ["Mega|Ride"] = 136.39}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 311.12, ["Fly|Ride"] = 206.56, ["Neon"] = 11.59, ["Neon|Ride"] = 38.58, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 66.55, ["Mega|Fly"] = 156428.07, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.64, ["Fly"] = 144.16, ["Ride"] = 112.88, ["Fly|Ride"] = 163.1, ["Neon"] = 317.38, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 364.88, ["Mega|Fly|Ride"] = 983.39}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 17.07, ["Fly|Ride"] = 84.26, ["Neon"] = 9.08, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 121.96, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 14.28, ["Ride"] = 125.62, ["Neon"] = 64.97, ["Neon|Ride"] = 111.57, ["Mega"] = 551.85, ["Mega|Ride"] = 579.85}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 42.41, ["Neon|Fly|Ride"] = 272.71, ["Mega"] = 19.27, ["Mega|Ride"] = 51.37, ["Mega|Fly|Ride"] = 140.8}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.67, ["Ride"] = 15.42, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 13.86, ["Neon|Fly|Ride"] = 39.43, ["Mega"] = 15.59, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 74.81}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 10.38, ["Fly|Ride"] = 31.97, ["Neon"] = 3.38, ["Neon|Fly"] = 20.75, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 26.16, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 55.16, ["Mega|Fly|Ride"] = 95.67}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Fly|Ride"] = 124.48, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 80.58, ["Mega"] = 14.17, ["Mega|Ride"] = 147.84, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 17.46, ["Fly|Ride"] = 107.62, ["Neon"] = 3.89, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 34.04, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Fly|Ride"] = 203.19, ["Mega"] = 24.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.15, ["Fly"] = 65.24, ["Ride"] = 17.07, ["Fly|Ride"] = 95.57, ["Neon"] = 7.53, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 22.71, ["Neon|Fly|Ride"] = 69.77, ["Mega"] = 63, ["Mega|Fly"] = 172.17, ["Mega|Ride"] = 90.71, ["Mega|Fly|Ride"] = 142.93}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.72, ["Neon"] = 2.63, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 15.33, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 36.38, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 14.96, ["Neon|Ride"] = 37.35, ["Mega"] = 276.96, ["Mega|Fly"] = 315, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.68, ["Ride"] = 41.5, ["Neon"] = 6.13, ["Neon|Ride"] = 19.69, ["Mega"] = 83, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.62, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 139, ["Mega"] = 30.87, ["Mega|Ride"] = 174.82, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.62, ["Fly|Ride"] = 30.09, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 13.57, ["Neon|Fly|Ride"] = 26.97, ["Mega"] = 12.86, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 20.76, ["Mega|Fly|Ride"] = 61.69}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 84, ["Neon"] = 27.15, ["Neon|Ride"] = 140.95, ["Mega"] = 276.96}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.32, ["Neon"] = 4.99, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 25.99, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 60.55, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.87, ["Neon"] = 6.57, ["Neon|Fly|Ride"] = 139, ["Mega"] = 81.38, ["Mega|Ride"] = 114.6, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.4, ["Fly"] = 656.24, ["Ride"] = 32.82, ["Fly|Ride"] = 188.75, ["Neon"] = 15.21, ["Neon|Fly|Ride"] = 139, ["Mega"] = 223.02, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 117.23}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 13.36, ["Fly|Ride"] = 26.15, ["Neon"] = 2.1, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 13.61, ["Neon|Fly|Ride"] = 28.02, ["Mega"] = 15.73, ["Mega|Fly"] = 31.14, ["Mega|Ride"] = 26.66, ["Mega|Fly|Ride"] = 52.47}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.66, ["Fly|Ride"] = 97.51, ["Neon"] = 22.5, ["Neon|Ride"] = 112.73, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 154.14, ["Mega|Fly|Ride"] = 248.96}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.34, ["Fly"] = 26.25, ["Ride"] = 23.54, ["Fly|Ride"] = 58.46, ["Neon"] = 15.31, ["Neon|Ride"] = 120.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 207.47, ["Mega|Ride"] = 281.39, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.58, ["Ride"] = 15.28, ["Fly|Ride"] = 45.65, ["Neon"] = 3.94, ["Neon|Fly"] = 9.19, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 30.58, ["Mega"] = 14.32, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 173.2, ["Ride"] = 56.79, ["Neon"] = 9.19, ["Neon|Fly"] = 76.77, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 32.82, ["Mega|Fly"] = 164.39, ["Mega|Ride"] = 84}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.72, ["Fly|Ride"] = 82.99, ["Neon"] = 4.82, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 151.53, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 32.82, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.58, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 17.07, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 108.84}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 97.49, ["Ride"] = 18.37, ["Fly|Ride"] = 42.02, ["Neon"] = 9.4, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.03, ["Mega"] = 78.62, ["Mega|Ride"] = 77.44}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 105, ["Neon"] = 5, ["Neon|Ride"] = 43.3, ["Mega"] = 40.28, ["Mega|Ride"] = 110.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 17.38, ["Fly|Ride"] = 36.05, ["Neon"] = 7.63, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.27, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 89.25, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 20.75, ["Neon"] = 25.99, ["Mega"] = 312.04, ["Mega|Ride"] = 205.92, ["Mega|Fly|Ride"] = 821.63}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 16.62, ["Ride"] = 16.53, ["Fly|Ride"] = 47.73, ["Neon"] = 6.25, ["Neon|Fly"] = 139, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 318.46}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 30.81, ["Ride"] = 16.44, ["Fly|Ride"] = 48.57, ["Neon"] = 15.59, ["Neon|Fly"] = 37.78, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 83, ["Mega"] = 206.19, ["Mega|Fly"] = 413.89, ["Mega|Ride"] = 139, ["Mega|Fly|Ride"] = 189.7}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Ride"] = 27.01, ["Fly|Ride"] = 137.7, ["Neon"] = 37.41, ["Mega"] = 123.3, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 12.05, ["Ride"] = 131.24, ["Neon"] = 120.1, ["Neon|Ride"] = 139, ["Mega"] = 691.87, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.52, ["Ride"] = 79.84, ["Neon"] = 41.5, ["Neon|Ride"] = 91.88, ["Mega"] = 206.43, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.13, ["Ride"] = 52.5, ["Neon"] = 78.66, ["Neon|Ride"] = 56.01, ["Mega"] = 248.07, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 353.72}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 64.99, ["Mega"] = 30.26, ["Mega|Ride"] = 139, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.71, ["Fly"] = 21.51, ["Ride"] = 16.71, ["Fly|Ride"] = 45.93, ["Neon"] = 56.02, ["Neon|Ride"] = 37.04, ["Neon|Fly|Ride"] = 90.26, ["Mega"] = 273, ["Mega|Fly"] = 331.94, ["Mega|Ride"] = 276.96, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.51, ["Mega"] = 27.97, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 20.75, ["Neon"] = 4.17, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.66, ["Mega"] = 65.36, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 15.75, ["Fly|Ride"] = 55.65, ["Neon"] = 11.41, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 111.27, ["Mega"] = 141.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.93, ["Ride"] = 17.62, ["Fly|Ride"] = 59.13, ["Neon"] = 45.65, ["Neon|Ride"] = 83, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 290.45, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 414.92}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 48.77, ["Mega"] = 15.6, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 275.93}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.67, ["Ride"] = 15.74, ["Fly|Ride"] = 144, ["Neon"] = 3.74, ["Neon|Fly"] = 69.01, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 98.53, ["Mega"] = 31.94, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 47.93, ["Mega|Fly|Ride"] = 113.3}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 17.07, ["Fly|Ride"] = 33.78, ["Neon"] = 6.05, ["Neon|Fly"] = 69.51, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 69.51, ["Mega"] = 47.94, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 158.28}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 118.13, ["Neon"] = 3.75, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 23.14, ["Mega|Fly"] = 125.55, ["Mega|Ride"] = 64.93, ["Mega|Fly|Ride"] = 111}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.16, ["Neon|Ride"] = 164.37, ["Neon|Fly|Ride"] = 151107.59, ["Mega"] = 21.9, ["Mega|Fly"] = 98.56, ["Mega|Ride"] = 85.76, ["Mega|Fly|Ride"] = 200.91}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.17, ["Ride"] = 17.64, ["Fly|Ride"] = 76.67, ["Neon"] = 6.18, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 25.78, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 19.5, ["Mega|Ride"] = 55.01, ["Mega|Fly|Ride"] = 97.52}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.57, ["Mega"] = 15.63, ["Mega|Ride"] = 123.79, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.61, ["Neon|Ride"] = 155.6, ["Mega"] = 27.71, ["Mega|Fly"] = 117.33, ["Mega|Ride"] = 118.27}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.01, ["Ride"] = 14.44, ["Fly|Ride"] = 49.87, ["Neon"] = 5.19, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 39.9, ["Mega"] = 41.51, ["Mega|Ride"] = 50.29, ["Mega|Fly|Ride"] = 157.22}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.98, ["Fly"] = 56.01, ["Ride"] = 137.76, ["Neon"] = 513.19, ["Mega"] = 536.17, ["Mega|Ride"] = 450.19, ["Mega|Fly|Ride"] = 761.37}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.35, ["Fly"] = 6562.5, ["Ride"] = 17.07, ["Neon"] = 30.19, ["Neon|Ride"] = 205.4, ["Mega"] = 1579.78, ["Mega|Ride"] = 341.92, ["Mega|Fly|Ride"] = 414.92}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.66, ["Ride"] = 26.24, ["Fly|Ride"] = 52.5, ["Neon"] = 28.88, ["Neon|Ride"] = 31.5, ["Mega"] = 274.32, ["Mega|Ride"] = 234.65, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 12.46, ["Neon"] = 2.1, ["Neon|Fly"] = 13.71, ["Neon|Ride"] = 13.53, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 13.13, ["Mega|Fly"] = 31.21, ["Mega|Ride"] = 22.83, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Fly"] = 118.12, ["Ride"] = 45.64, ["Fly|Ride"] = 110.99, ["Neon"] = 17.43, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 691.87, ["Mega"] = 116.09, ["Mega|Ride"] = 97.52}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 77.81, ["Mega"] = 14.44, ["Mega|Fly"] = 79.06, ["Mega|Ride"] = 77.97, ["Mega|Fly|Ride"] = 100.2}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 92.74, ["Neon"] = 3.59, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 123.45, ["Mega"] = 20.76, ["Mega|Ride"] = 72.07, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 15.75, ["Fly|Ride"] = 45.94, ["Neon"] = 9.87, ["Neon|Fly"] = 138.99, ["Neon|Ride"] = 32.02, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 157.5, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 165.94, ["Ride"] = 211.31, ["Fly|Ride"] = 183.75, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8298.19, ["Mega|Fly|Ride"] = 3302.7}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly"] = 55.55, ["Neon|Ride"] = 68.25, ["Mega"] = 64.03, ["Mega|Ride"] = 90.26, ["Mega|Fly|Ride"] = 719.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.57, ["Fly"] = 103.68, ["Ride"] = 23.87, ["Neon"] = 28.02, ["Neon|Ride"] = 46.98, ["Mega"] = 157.22, ["Mega|Fly|Ride"] = 413.89}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 14.89, ["Ride"] = 12.77, ["Fly|Ride"] = 32.79, ["Neon"] = 10.4, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.26, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 49.67, ["Mega|Ride"] = 73.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 8.33, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.71, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 580.89}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 5.17, ["Fly"] = 23.67, ["Ride"] = 16.45, ["Fly|Ride"] = 35.42, ["Neon"] = 30.54, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 157.5, ["Mega|Ride"] = 207.47, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.1, ["Fly"] = 41.5, ["Ride"] = 41.5, ["Fly|Ride"] = 249.58, ["Neon"] = 39.38, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 616.17, ["Mega"] = 333.38, ["Mega|Ride"] = 409.74, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.37, ["Fly"] = 15.75, ["Ride"] = 14.58, ["Fly|Ride"] = 30.63, ["Neon"] = 17.07, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 66.96, ["Mega|Ride"] = 691.87, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 80.07, ["Fly"] = 103.91, ["Ride"] = 93.19, ["Fly|Ride"] = 131.25, ["Neon"] = 368.2, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 373.43, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 329.53, ["Ride"] = 248.9, ["Fly|Ride"] = 298.22, ["Neon|Ride"] = 1452.2, ["Neon|Fly|Ride"] = 1037.13, ["Mega"] = 10372.72, ["Mega|Fly|Ride"] = 4011.14}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 72.19, ["Fly"] = 137.62, ["Ride"] = 64.97, ["Fly|Ride"] = 120.74, ["Neon"] = 276.94, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 346.46, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.75, ["Fly"] = 26.25, ["Ride"] = 24.86, ["Fly|Ride"] = 138.99, ["Neon"] = 32.79, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 124.49, ["Mega"] = 430.48, ["Mega|Ride"] = 364.09, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.58, ["Fly"] = 68.81, ["Ride"] = 30.82, ["Fly|Ride"] = 89.25, ["Neon"] = 138.75, ["Neon|Ride"] = 97.08, ["Neon|Fly|Ride"] = 173.23, ["Mega"] = 351.75, ["Mega|Ride"] = 364.54, ["Mega|Fly|Ride"] = 782.54}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 27.89, ["Ride"] = 18.38, ["Fly|Ride"] = 36.42, ["Neon"] = 2.98, ["Neon|Fly"] = 25.83, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 49.77, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 176.35}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 9.19, ["Fly"] = 68.8, ["Ride"] = 27.62, ["Fly|Ride"] = 313.47, ["Neon"] = 52.88, ["Neon|Ride"] = 157.35, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 886.89, ["Mega|Ride"] = 589.18, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.54, ["Ride"] = 14.44, ["Fly|Ride"] = 41.88, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.15, ["Ride"] = 20.46, ["Fly|Ride"] = 41.5, ["Neon"] = 29.81, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 117.33, ["Mega"] = 207.37, ["Mega|Ride"] = 206.43, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 36.3, ["Neon"] = 2.1, ["Neon|Ride"] = 19.46, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 15.72, ["Mega|Ride"] = 50.85, ["Mega|Fly|Ride"] = 209664.94}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 14.44, ["Neon|Fly"] = 103.73, ["Neon|Ride"] = 22.33, ["Neon|Fly|Ride"] = 97.99, ["Mega"] = 84, ["Mega|Ride"] = 103.71, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 45.94, ["Neon"] = 17.62, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 111, ["Mega"] = 283.5, ["Mega|Ride"] = 204.15, ["Mega|Fly|Ride"] = 224.1}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 191.62, ["Fly"] = 414.82, ["Ride"] = 246.75, ["Fly|Ride"] = 261.19, ["Neon"] = 700.88, ["Neon|Ride"] = 924.03, ["Neon|Fly|Ride"] = 766.5, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 3114.27}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.7, ["Ride"] = 31.13, ["Fly|Ride"] = 206.07, ["Neon"] = 91.88, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 336.72, ["Mega|Ride"] = 373.43, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.58, ["Ride"] = 15.07, ["Fly|Ride"] = 43.26, ["Neon"] = 63.91, ["Neon|Ride"] = 37.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 17.17, ["Ride"] = 40.46, ["Fly|Ride"] = 170.63, ["Neon"] = 116.85, ["Neon|Ride"] = 148.31, ["Neon|Fly|Ride"] = 406.5, ["Mega"] = 545.74, ["Mega|Ride"] = 465.94, ["Mega|Fly|Ride"] = 706.13}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 26.97, ["Neon"] = 28.88, ["Neon|Ride"] = 46.98, ["Neon|Fly|Ride"] = 622.38, ["Mega"] = 304.5, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 690.83}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.25, ["Fly"] = 58.71, ["Ride"] = 44.51, ["Fly|Ride"] = 58.46, ["Neon"] = 180.48, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 145.6, ["Neon|Fly|Ride"] = 204.4, ["Mega"] = 2074.55, ["Mega|Fly|Ride"] = 829.83}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.7, ["Neon|Ride"] = 49.81, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.25, ["Mega|Fly"] = 413.89, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.24, ["Fly"] = 27.6, ["Ride"] = 27.01, ["Fly|Ride"] = 112.54, ["Neon"] = 15.75, ["Neon|Ride"] = 34.95, ["Mega"] = 229.04, ["Mega|Fly"] = 391.86, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 31.5, ["Neon"] = 15.75, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 103.69, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 24.91, ["Neon"] = 2.63, ["Neon|Ride"] = 31.12, ["Neon|Fly|Ride"] = 414.92, ["Mega"] = 26.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 173.23}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 25.96, ["Fly"] = 38.58, ["Ride"] = 131.25, ["Fly|Ride"] = 133.6, ["Neon"] = 218.7, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 863.44, ["Mega|Ride"] = 1044.54, ["Mega|Fly|Ride"] = 996.03}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.44, ["Ride"] = 51.66, ["Neon"] = 80.07, ["Neon|Ride"] = 102.71, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 275.93, ["Mega|Ride"] = 276.96}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.86, ["Fly"] = 87.4, ["Ride"] = 23.41, ["Fly|Ride"] = 69.56, ["Neon"] = 44.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 44.24, ["Neon|Fly|Ride"] = 157.22, ["Mega"] = 365.01, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 62.23, ["Fly"] = 97.49, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 410.73, ["Neon|Ride"] = 414.92, ["Neon|Fly|Ride"] = 691.87, ["Mega"] = 1618.16, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1306.98}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.81, ["Fly"] = 39.38, ["Ride"] = 28.87, ["Fly|Ride"] = 60.38, ["Neon"] = 45.02, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 124.49, ["Mega"] = 263.82, ["Mega|Ride"] = 256.1, ["Mega|Fly|Ride"] = 414.92}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 78.74, ["Fly"] = 143.07, ["Ride"] = 107.57, ["Neon"] = 203.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 962, ["Mega|Ride"] = 952.23, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 55.13, ["Fly|Ride"] = 173.25, ["Neon"] = 87.94, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 297.71, ["Mega"] = 389.52, ["Mega|Ride"] = 297.53, ["Mega|Fly|Ride"] = 413.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 12.23, ["Fly"] = 41.36, ["Ride"] = 28.01, ["Fly|Ride"] = 69.5, ["Neon"] = 82.68, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 373.09, ["Mega"] = 248.96, ["Mega|Ride"] = 1037.29, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 25.83, ["Ride"] = 110.98, ["Fly|Ride"] = 148.64, ["Neon"] = 90.57, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 251.08, ["Mega"] = 251.08, ["Mega|Fly"] = 501.01, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.27, ["Ride"] = 36.3, ["Fly|Ride"] = 136.91, ["Neon"] = 43.26, ["Neon|Ride"] = 91.6, ["Neon|Fly|Ride"] = 139, ["Mega"] = 387.96, ["Mega|Ride"] = 306.39, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 53.95, ["Neon|Ride"] = 56.35, ["Mega"] = 16.79, ["Mega|Fly"] = 139, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.6, ["Ride"] = 27.26, ["Fly|Ride"] = 430.38, ["Neon"] = 17.07, ["Neon|Fly"] = 124.48, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 492.99, ["Mega|Fly|Ride"] = 469.29}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 17.62, ["Neon"] = 23.61, ["Neon|Ride"] = 207.47, ["Mega"] = 183.24, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 10.37, ["Ride"] = 32.78, ["Fly|Ride"] = 116.24, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.38, ["Mega|Ride"] = 212.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.37, ["Ride"] = 577.5, ["Fly|Ride"] = 617.33, ["Neon"] = 1719.6, ["Neon|Ride"] = 1439.24, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.2, ["Fly"] = 27.75, ["Ride"] = 23.49, ["Fly|Ride"] = 56.02, ["Neon"] = 26.25, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 401.25, ["Mega|Fly|Ride"] = 497.91}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 12.09, ["Fly"] = 39.38, ["Ride"] = 27.46, ["Fly|Ride"] = 60.38, ["Neon"] = 28.02, ["Neon|Ride"] = 54.51, ["Mega"] = 273.27, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.16, ["Fly"] = 93.92, ["Ride"] = 19.71, ["Fly|Ride"] = 311.16, ["Neon"] = 12.93, ["Neon|Ride"] = 102.71, ["Neon|Fly|Ride"] = 151.46, ["Mega"] = 263.99, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 63.67, ["Ride"] = 23.3, ["Fly|Ride"] = 90.57, ["Neon"] = 7.54, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 91.62, ["Mega"] = 73.5, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.5, ["Ride"] = 17.07, ["Neon"] = 3.76, ["Neon|Ride"] = 30.1, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 22.74, ["Mega|Ride"] = 72.84, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.73}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.25, ["Ride"] = 35.26, ["Fly|Ride"] = 68.8, ["Neon"] = 62.25, ["Neon|Ride"] = 72.17, ["Neon|Fly|Ride"] = 178.67, ["Mega|Ride"] = 829.83, ["Mega|Fly|Ride"] = 853.69}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.25, ["Neon|Ride"] = 40.69, ["Mega"] = 39.15, ["Mega|Ride"] = 150.56, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.62, ["Fly"] = 97.49, ["Ride"] = 41.5, ["Fly|Ride"] = 574.39, ["Neon"] = 10.5, ["Neon|Fly"] = 124.49, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 153.54, ["Mega|Ride"] = 244.8, ["Mega|Fly|Ride"] = 309.73}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 446.24, ["Ride"] = 490.93, ["Fly|Ride"] = 461, ["Neon|Ride"] = 1521.69, ["Neon|Fly|Ride"] = 1205.4, ["Mega|Fly|Ride"] = 7605.29}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.25, ["Fly"] = 196.88, ["Ride"] = 97.49, ["Neon"] = 101.66, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 410.78, ["Mega|Ride"] = 389, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly|Ride"] = 138.99, ["Neon"] = 4.49, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 38.26, ["Mega|Fly"] = 189, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 829.62, ["Neon"] = 3.9, ["Neon|Ride"] = 108.74, ["Neon|Fly|Ride"] = 263.48, ["Mega"] = 23.9, ["Mega|Ride"] = 96.48, ["Mega|Fly|Ride"] = 218.67}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.68, ["Fly"] = 107.62, ["Ride"] = 41.5, ["Fly|Ride"] = 173.77, ["Neon"] = 41.1, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 306.02, ["Mega"] = 553.91, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 15.75, ["Neon"] = 98.64, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.75, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 1063.79}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.22, ["Ride"] = 39.38, ["Fly|Ride"] = 138.99, ["Neon"] = 105, ["Neon|Ride"] = 157.35, ["Mega"] = 634.46, ["Mega|Ride"] = 958.1, ["Mega|Fly|Ride"] = 1244.74}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 47.72, ["Ride"] = 35.26, ["Neon"] = 198.11, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 459.38, ["Mega|Ride"] = 613.6, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 427.27, ["Fly|Ride"] = 616.88, ["Neon"] = 1657.38, ["Neon|Ride"] = 1632.68, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3601.5}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.55, ["Fly"] = 69.65, ["Ride"] = 22.82, ["Fly|Ride"] = 51.87, ["Neon"] = 97.46, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 137.67, ["Mega"] = 553.91, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 854.73}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.82, ["Ride"] = 125.98, ["Fly|Ride"] = 78.75, ["Neon"] = 31.44, ["Neon|Ride"] = 221.82, ["Mega"] = 367.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 782.54}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 11.82, ["Ride"] = 69.27, ["Fly|Ride"] = 248.62, ["Neon"] = 52.49, ["Neon|Ride"] = 113.04, ["Neon|Fly|Ride"] = 219.92, ["Mega"] = 259.84, ["Mega|Fly"] = 414.92, ["Mega|Ride"] = 267.91, ["Mega|Fly|Ride"] = 319.59}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Ride"] = 52.5, ["Fly|Ride"] = 124.45, ["Neon"] = 7.25, ["Neon|Ride"] = 157.48, ["Neon|Fly|Ride"] = 139, ["Mega"] = 44.62, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 139}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 110.98, ["Ride"] = 150.93, ["Neon"] = 216.57, ["Neon|Ride"] = 297.71, ["Neon|Fly|Ride"] = 466.79, ["Mega"] = 2489.46, ["Mega|Ride"] = 1338.1, ["Mega|Fly|Ride"] = 2060.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 56.44, ["Ride"] = 31.4, ["Neon"] = 13.13, ["Neon|Fly"] = 180.48, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 139, ["Mega"] = 86.63, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 90.23, ["Ride"] = 35.26, ["Fly|Ride"] = 131.25, ["Neon"] = 4.55, ["Neon|Fly"] = 66.93, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 132.79, ["Mega"] = 157.22, ["Mega|Fly|Ride"] = 172.41}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 35.26, ["Fly|Ride"] = 110.99, ["Neon"] = 13.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 157.22, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 67.96, ["Ride"] = 106.82, ["Neon"] = 437.07, ["Neon|Ride"] = 313.5, ["Neon|Fly|Ride"] = 621.34, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 274.32, ["Ride"] = 276.9, ["Fly|Ride"] = 382.66, ["Neon"] = 1441.64, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1032.09, ["Mega"] = 12447.27, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.78, ["Neon"] = 52.5, ["Mega"] = 87.94, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 513.86}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.24, ["Ride"] = 32.82, ["Neon"] = 17.61, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.25, ["Fly"] = 30.54, ["Ride"] = 20.56, ["Fly|Ride"] = 176.33, ["Neon"] = 36.75, ["Mega"] = 345.85, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 58.32, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 7.8, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 64.32, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 7.06, ["Neon|Ride"] = 30.55, ["Mega"] = 52.49, ["Mega|Fly"] = 139, ["Mega|Fly|Ride"] = 272.82}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.75, ["Fly|Ride"] = 41.98, ["Neon"] = 5.24, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 56.02, ["Mega"] = 61.22, ["Mega|Ride"] = 74.69, ["Mega|Fly|Ride"] = 139}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 90.36, ["Ride"] = 20.75, ["Fly|Ride"] = 41.31, ["Neon"] = 15.58, ["Neon|Fly"] = 69.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.38, ["Mega"] = 156.15, ["Mega|Ride"] = 233.41, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 45.84, ["Fly"] = 23.49, ["Ride"] = 42, ["Fly|Ride"] = 82.56, ["Neon"] = 183.17, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.62, ["Fly"] = 582.75, ["Ride"] = 82.06, ["Fly|Ride"] = 160.13, ["Neon"] = 328.13, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 626.51, ["Mega"] = 3128.95, ["Mega|Ride"] = 1380.63, ["Mega|Fly|Ride"] = 1355.73}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.74, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 31.5, ["Mega|Fly"] = 672, ["Mega|Ride"] = 61.66}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.58, ["Ride"] = 15.74, ["Fly|Ride"] = 35.43, ["Neon"] = 4.08, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.33, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 48.57, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.24, ["Ride"] = 51.19, ["Fly|Ride"] = 131.25, ["Neon"] = 248.94, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 275.93, ["Mega"] = 627.14, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 367.5, ["Fly"] = 393.75, ["Ride"] = 546.52, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1798.64, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 6638.56}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 32.62, ["Fly"] = 90.17, ["Ride"] = 59.07, ["Neon"] = 250.11, ["Neon|Ride"] = 193.98, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 1244.74}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Fly"] = 112.69, ["Ride"] = 26.97, ["Fly|Ride"] = 281.28, ["Neon"] = 10.38, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 117.23, ["Mega|Ride"] = 102.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 207.42, ["Ride"] = 65.62, ["Fly|Ride"] = 142.7, ["Neon"] = 131.25}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 51.96, ["Fly"] = 76.76, ["Ride"] = 43.31, ["Fly|Ride"] = 68.82, ["Neon|Ride"] = 279.11, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2489.46, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1101.6}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 89.25, ["Ride"] = 140.86, ["Fly|Ride"] = 155.57, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 8298.19, ["Mega|Fly|Ride"] = 1887.85}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 196.88, ["Ride"] = 265.86, ["Fly|Ride"] = 469.62, ["Neon"] = 829.74, ["Neon|Ride"] = 1010.31, ["Neon|Fly|Ride"] = 1036.25, ["Mega|Fly|Ride"] = 2998.76}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 15.74, ["Ride"] = 35.26, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Fly"] = 139, ["Neon|Ride"] = 135.56, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 361.66, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.26, ["Fly|Ride"] = 40.63, ["Neon"] = 7.61, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.23, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.2, ["Fly"] = 33.24, ["Ride"] = 21.34, ["Fly|Ride"] = 636.82, ["Neon"] = 26.25, ["Neon|Fly"] = 145.21, ["Neon|Ride"] = 56.02, ["Neon|Fly|Ride"] = 103.74, ["Mega"] = 288.75, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 288.75, ["Fly"] = 484.31, ["Ride"] = 326.82, ["Fly|Ride"] = 406.88, ["Neon"] = 1968.75, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1937.63, ["Mega|Ride"] = 5184.31, ["Mega|Fly|Ride"] = 5762.06}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 11.9, ["Neon|Ride"] = 49.81, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 45.94, ["Mega|Ride"] = 178.7, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.55, ["Fly"] = 14.11, ["Ride"] = 18.8, ["Fly|Ride"] = 41.09, ["Neon"] = 27.88, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 106.85, ["Mega"] = 180.51, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 187.72, ["Mega|Fly|Ride"] = 248.96}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.53, ["Ride"] = 114.19, ["Neon"] = 110.19, ["Neon|Fly"] = 414.92, ["Neon|Ride"] = 128.28, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 443.83, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 158.81, ["Fly"] = 130.69, ["Ride"] = 112.35, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 733.36, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 25.09, ["Fly"] = 41.5, ["Ride"] = 32.82, ["Fly|Ride"] = 52.5, ["Neon"] = 59.07, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 164.94, ["Mega"] = 622.38, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 56.01, ["Neon"] = 3.93, ["Neon|Ride"] = 56.02, ["Neon|Fly|Ride"] = 691.87, ["Mega"] = 21, ["Mega|Ride"] = 275.93, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.09, ["Fly|Ride"] = 52.5, ["Neon"] = 2.77, ["Neon|Fly"] = 157.34, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 60.51, ["Mega"] = 28.88, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 109.96}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.43, ["Fly"] = 414.82, ["Ride"] = 68.22, ["Fly|Ride"] = 140.74, ["Neon"] = 38.07, ["Neon|Fly"] = 225.43, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 151.33, ["Mega|Fly"] = 276.96, ["Mega|Ride"] = 186.24, ["Mega|Fly|Ride"] = 287.45}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1312.49, ["Fly|Ride"] = 1470, ["Neon"] = 4200, ["Neon|Ride"] = 6915.5, ["Neon|Fly|Ride"] = 4489.87, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 413.79, ["Ride"] = 481.69, ["Fly|Ride"] = 588.32, ["Neon"] = 1756.94, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1784.12, ["Mega"] = 16596.36, ["Mega|Fly|Ride"] = 7084.88}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 336, ["Fly"] = 465.94, ["Ride"] = 373.79, ["Fly|Ride"] = 438.12, ["Neon"] = 653.63, ["Neon|Fly"] = 1252.7, ["Neon|Ride"] = 617.67, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 3067.32}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 344.3, ["Fly"] = 413.22, ["Ride"] = 387.19, ["Fly|Ride"] = 462, ["Neon"] = 1231.11, ["Neon|Fly"] = 1383.74, ["Neon|Ride"] = 968.62, ["Neon|Fly|Ride"] = 1109.21, ["Mega|Fly|Ride"] = 4662.55}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 22.91, ["Ride"] = 17.62, ["Fly|Ride"] = 39.38, ["Neon"] = 7.66, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 82.3, ["Mega"] = 62.5, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 553.79, ["Ride"] = 525, ["Fly|Ride"] = 597.19, ["Neon"] = 1680, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 2034.36, ["Mega|Fly|Ride"] = 8212.44}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.63, ["Fly"] = 183.75, ["Ride"] = 27.99, ["Fly|Ride"] = 63.41, ["Neon"] = 10.39, ["Neon|Ride"] = 64.02, ["Neon|Fly|Ride"] = 155.36, ["Mega"] = 62.26, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 273.86}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.91, ["Ride"] = 20.54, ["Fly|Ride"] = 36.32, ["Neon"] = 10.38, ["Neon|Ride"] = 61.22, ["Neon|Fly|Ride"] = 99.82, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 45.94, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 346.46, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.5, ["Fly"] = 8038.15, ["Ride"] = 20.79, ["Fly|Ride"] = 59.83, ["Neon"] = 23.24, ["Neon|Ride"] = 78.68, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.8, ["Neon|Fly"] = 117.99, ["Neon|Ride"] = 17.4, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 21.3, ["Mega|Fly"] = 691.87, ["Mega|Ride"] = 155.01, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.61, ["Fly"] = 36.01, ["Ride"] = 20.75, ["Fly|Ride"] = 56.37, ["Neon"] = 11.42, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 31.04, ["Neon|Fly|Ride"] = 82.43, ["Mega"] = 65.63, ["Mega|Fly"] = 173.23, ["Mega|Ride"] = 104.24, ["Mega|Fly|Ride"] = 176.61}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.14, ["Fly"] = 55.99, ["Ride"] = 18.67, ["Fly|Ride"] = 51.45, ["Neon"] = 153.5, ["Neon|Fly"] = 74.69, ["Neon|Ride"] = 139, ["Neon|Fly|Ride"] = 157.22, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 53.82, ["Neon"] = 44.63, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 263.99, ["Mega"] = 313.26, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.91, ["Fly"] = 6260.96, ["Ride"] = 26.61, ["Neon"] = 24.19, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 439.03, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.16, ["Fly|Ride"] = 55.19, ["Neon"] = 4.72, ["Neon|Fly"] = 31.14, ["Neon|Ride"] = 24.97, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 234.65}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 275.86, ["Ride"] = 210, ["Fly|Ride"] = 221.82, ["Neon|Ride"] = 2593.19, ["Neon|Fly|Ride"] = 1148.27, ["Mega"] = 8298.19, ["Mega|Fly|Ride"] = 5781.76}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 16.57, ["Ride"] = 15.45, ["Fly|Ride"] = 35.44, ["Neon"] = 3.86, ["Neon|Fly"] = 28.02, ["Neon|Ride"] = 21.33, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 27.74, ["Mega|Ride"] = 51.56, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.18, ["Ride"] = 43.78, ["Fly|Ride"] = 183.72, ["Neon"] = 76.76, ["Neon|Ride"] = 100.66, ["Mega"] = 360.2, ["Mega|Ride"] = 350.62, ["Mega|Fly|Ride"] = 525.91}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 44.6, ["Fly"] = 210, ["Ride"] = 122.38, ["Fly|Ride"] = 170.63, ["Neon"] = 255.94, ["Neon|Ride"] = 312.32, ["Mega"] = 828.8, ["Mega|Ride"] = 857.84, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.91, ["Fly"] = 305.93, ["Ride"] = 236.25, ["Fly|Ride"] = 375.45, ["Neon"] = 828.7, ["Neon|Ride"] = 691.87, ["Neon|Fly|Ride"] = 740.25, ["Mega|Ride"] = 3319.29, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.71, ["Fly"] = 168.88, ["Ride"] = 36.67, ["Fly|Ride"] = 140.86, ["Neon"] = 65.63, ["Neon|Ride"] = 276.96, ["Mega"] = 286.79, ["Mega|Ride"] = 346.46, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 91.88, ["Fly|Ride"] = 622.31, ["Neon"] = 207.44, ["Neon|Ride"] = 192.94, ["Mega"] = 828.8, ["Mega|Ride"] = 1659.65, ["Mega|Fly|Ride"] = 940.83}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1207.5, ["Fly"] = 1454.95, ["Ride"] = 1115.63, ["Fly|Ride"] = 1408.55, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4724.99, ["Mega|Fly|Ride"] = 17148.18}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 15.6, ["Fly"] = 26.25, ["Ride"] = 18.88, ["Fly|Ride"] = 63, ["Neon"] = 44.15, ["Neon|Fly"] = 68.64, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 97.52, ["Mega"] = 272.82, ["Mega|Ride"] = 222, ["Mega|Fly|Ride"] = 248.96}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.9, ["Fly"] = 65.63, ["Ride"] = 38.07, ["Neon"] = 29.64, ["Neon|Ride"] = 103.74, ["Neon|Fly|Ride"] = 553.91, ["Mega"] = 257.25, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 217.7, ["Mega|Fly|Ride"] = 585.03}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.94, ["Ride"] = 22.32, ["Fly|Ride"] = 69.57, ["Neon"] = 28.02, ["Neon|Ride"] = 56.02, ["Mega"] = 89.25, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 548.33}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.18, ["Fly"] = 691.7, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 76.61, ["Neon|Ride"] = 101.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 382.1, ["Mega|Fly|Ride"] = 469.29}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 20.99, ["Ride"] = 19.71, ["Fly|Ride"] = 51.19, ["Neon"] = 24.94, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 31.14, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 101.07, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.63, ["Fly"] = 413.79, ["Ride"] = 22.32, ["Neon"] = 10.29, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 68.22, ["Neon|Fly|Ride"] = 829.83, ["Mega"] = 91.88, ["Mega|Fly"] = 165.98, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 287.28}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.13, ["Ride"] = 437.07, ["Fly|Ride"] = 595.25, ["Neon|Ride"] = 1331.43, ["Neon|Fly|Ride"] = 1353.9}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 6.18, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 65.36, ["Neon"] = 9.19, ["Neon|Fly"] = 82.99, ["Neon|Ride"] = 32.82, ["Mega"] = 98.44, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 259.29}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.1, ["Ride"] = 49.31, ["Neon"] = 137.62, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 87.63, ["Ride"] = 32.17, ["Neon"] = 13.13, ["Neon|Fly"] = 69.5, ["Neon|Ride"] = 58.67, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 84.94, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 245.44, ["Ride"] = 290.75, ["Fly|Ride"] = 864.99, ["Neon"] = 829.74, ["Neon|Ride"] = 829.83, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 4426.05, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 32.81, ["Fly"] = 52.06, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon"] = 116.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 726.1, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 726.1}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 25.57, ["Ride"] = 39.42, ["Fly|Ride"] = 138.99, ["Neon"] = 101.66, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 486.83, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.71, ["Neon|Ride"] = 43.73, ["Mega"] = 26.06, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 90.23, ["Fly"] = 88.36, ["Ride"] = 107.86, ["Fly|Ride"] = 210, ["Neon"] = 281.78, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 412.12, ["Neon|Fly|Ride"] = 328.11, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 15.58, ["Fly|Ride"] = 69.5, ["Neon"] = 5.25, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.09, ["Mega|Fly|Ride"] = 413.89}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 28.01, ["Fly"] = 125.62, ["Ride"] = 44.63, ["Fly|Ride"] = 64.97, ["Neon"] = 62.3, ["Neon|Ride"] = 110.37, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 382.05, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 414.92}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.57, ["Fly"] = 110.06, ["Ride"] = 94.13, ["Fly|Ride"] = 105.88, ["Neon"] = 301.83, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1326.69, ["Mega|Fly|Ride"] = 1089.97}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.62, ["Ride"] = 15.26, ["Fly|Ride"] = 31.49, ["Neon"] = 2.62, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 18.38, ["Mega|Fly"] = 55.16, ["Mega|Ride"] = 35.28, ["Mega|Fly|Ride"] = 89.79}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.69, ["Ride"] = 33.57, ["Fly|Ride"] = 1339.78, ["Neon"] = 11.75, ["Neon|Ride"] = 60.18, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 472.5, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 20.54, ["Fly"] = 138.98, ["Ride"] = 49.8, ["Neon"] = 103.68, ["Neon|Ride"] = 143.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 586.69, ["Mega|Ride"] = 479.24, ["Mega|Fly|Ride"] = 622.38}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 30.82, ["Mega|Ride"] = 137.97, ["Mega|Fly|Ride"] = 207.47}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.69, ["Ride"] = 48.76, ["Fly|Ride"] = 120.74, ["Neon"] = 84.71, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 187.72, ["Mega"] = 553.91, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.56, ["Fly"] = 41.27, ["Ride"] = 27.66, ["Fly|Ride"] = 45.94, ["Neon"] = 202.07, ["Neon|Ride"] = 117.58, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 829.83}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.63, ["Ride"] = 52.49, ["Fly|Ride"] = 76.02, ["Neon"] = 28.02, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 170.63, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 26.25, ["Fly"] = 2074.05, ["Ride"] = 37.57, ["Neon"] = 65.63, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 6256.72, ["Mega"] = 290.45, ["Mega|Ride"] = 487.54, ["Mega|Fly|Ride"] = 546.67}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 137.62, ["Fly|Ride"] = 196.87, ["Neon"] = 10.5, ["Neon|Fly"] = 56.02, ["Neon|Ride"] = 68.83, ["Mega"] = 68.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.55}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.83, ["Neon|Ride"] = 88.28, ["Mega"] = 29.79, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 211.32}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 33.21}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 39.24, ["Fly"] = 102.38, ["Ride"] = 78.65, ["Fly|Ride"] = 207.44, ["Neon"] = 131.25, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1236.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 836.21}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Neon"] = 2.63, ["Mega"] = 138.83, ["Mega|Ride"] = 165.98, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 380.63, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2070.42, ["Mega"] = 16596.36}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.1, ["Fly"] = 25.99, ["Ride"] = 39.37, ["Fly|Ride"] = 89.19, ["Neon"] = 13.13, ["Neon|Ride"] = 273.24, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 67.08, ["Mega|Ride"] = 139, ["Mega|Fly|Ride"] = 207.47}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.04, ["Fly"] = 153.97, ["Ride"] = 21.67, ["Fly|Ride"] = 62.99, ["Neon"] = 17.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 90.26, ["Mega"] = 137.82, ["Mega|Ride"] = 180.51, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 14.97, ["Fly"] = 77.8, ["Ride"] = 72.19, ["Fly|Ride"] = 518.58, ["Neon"] = 70.46, ["Neon|Ride"] = 180.83, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 517.61, ["Mega|Ride"] = 397.38, ["Mega|Fly|Ride"] = 622.38}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 32.16, ["Neon"] = 53.95, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 64.32, ["Ride"] = 92.66, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 359, ["Mega|Ride"] = 430.48, ["Mega|Fly|Ride"] = 968.82}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.64, ["Fly"] = 104.99, ["Ride"] = 32.82, ["Fly|Ride"] = 186.71, ["Neon"] = 55.47, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 139, ["Mega"] = 216.47, ["Mega|Fly"] = 483.38, ["Mega|Ride"] = 235.47, ["Mega|Fly|Ride"] = 416.5}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 14.34, ["Fly|Ride"] = 66.26, ["Neon"] = 2.5, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 76.14, ["Mega"] = 14.44, ["Mega|Fly"] = 61.07, ["Mega|Ride"] = 51.59, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.44, ["Fly"] = 276.9, ["Ride"] = 27.57, ["Fly|Ride"] = 157.34, ["Neon"] = 22.32, ["Neon|Fly"] = 117.43, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 139, ["Mega|Fly"] = 206.43, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 401.44}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.49, ["Fly"] = 401.35, ["Ride"] = 322.76, ["Fly|Ride"] = 380.63, ["Neon"] = 1464.46, ["Neon|Ride"] = 1242.67, ["Neon|Fly|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 4218.6}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 86.61, ["Ride"] = 137.27, ["Fly|Ride"] = 196.88, ["Neon"] = 600.52, ["Neon|Ride"] = 363.05, ["Neon|Fly|Ride"] = 626.51, ["Mega"] = 4149.1, ["Mega|Ride"] = 1521.69, ["Mega|Fly|Ride"] = 1701}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.58, ["Fly|Ride"] = 39.38, ["Neon"] = 11.49, ["Neon|Fly"] = 69.5, ["Neon|Ride"] = 33.21, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 60.18, ["Mega|Fly"] = 206.43, ["Mega|Ride"] = 124.49, ["Mega|Fly|Ride"] = 165.98}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.48, ["Ride"] = 15.56, ["Fly|Ride"] = 31.97, ["Neon"] = 6.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 55.12, ["Mega"] = 85.32, ["Mega|Fly"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Fly"] = 100.95, ["Ride"] = 18.67, ["Fly|Ride"] = 98.44, ["Neon"] = 23.87, ["Neon|Fly|Ride"] = 414.92, ["Mega"] = 139, ["Mega|Ride"] = 139}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 207.38, ["Fly"] = 420, ["Ride"] = 307.13, ["Fly|Ride"] = 350.44, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1347.44, ["Mega|Ride"] = 8298.19, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.59, ["Fly|Ride"] = 41, ["Neon"] = 15.75, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 156.95, ["Mega"] = 224.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.12, ["Fly"] = 157.29, ["Ride"] = 96.48, ["Fly|Ride"] = 207.42, ["Neon"] = 38.75, ["Neon|Ride"] = 35.44, ["Mega"] = 139, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.7, ["Neon|Ride"] = 131.23, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 27.96, ["Fly"] = 52.5, ["Ride"] = 23.63, ["Fly|Ride"] = 57.23, ["Neon"] = 78.66, ["Neon|Ride"] = 91.29, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 603.65}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 58.45, ["Fly"] = 140.86, ["Ride"] = 108.95, ["Fly|Ride"] = 209.99, ["Neon"] = 138.75, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 196.08, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 418.95, ["Mega|Fly"] = 2178.29, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.14, ["Fly"] = 68.25, ["Ride"] = 46.39, ["Fly|Ride"] = 95.38, ["Neon"] = 124.59, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 189.58, ["Mega|Ride"] = 691.87, ["Mega|Fly|Ride"] = 746.85}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 13.13, ["Fly|Ride"] = 31.26, ["Neon"] = 2.63, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 24.65, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 228.03, ["Ride"] = 262.5, ["Fly|Ride"] = 393.31, ["Neon"] = 3287.27, ["Neon|Ride"] = 950.25, ["Neon|Fly|Ride"] = 1300.69, ["Mega|Fly|Ride"] = 4395.98}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.5, ["Fly"] = 61.61, ["Ride"] = 60.17, ["Fly|Ride"] = 131.74, ["Neon"] = 105, ["Neon|Ride"] = 197.08, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 414.92, ["Mega|Ride"] = 409.74, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.39, ["Ride"] = 16.19, ["Fly|Ride"] = 39.38, ["Neon"] = 10.48, ["Neon|Ride"] = 25.65, ["Neon|Fly|Ride"] = 109.96, ["Mega"] = 59.14, ["Mega|Fly"] = 276.96, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 139}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.02, ["Fly"] = 28.01, ["Ride"] = 17.92, ["Fly|Ride"] = 55.48, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.83, ["Neon|Fly|Ride"] = 102.43, ["Mega"] = 26.25, ["Mega|Fly"] = 139, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 157.22}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.15, ["Ride"] = 28.88, ["Fly|Ride"] = 69.27, ["Neon"] = 4.71, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 125.55, ["Mega"] = 118.76, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 373.43}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.39, ["Fly"] = 38.73, ["Ride"] = 23.83, ["Fly|Ride"] = 68.25, ["Neon"] = 39.38, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 339.95, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 346.44}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.24, ["Fly"] = 56.01, ["Ride"] = 39.37, ["Fly|Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 136.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 321.57, ["Mega|Ride"] = 363.7, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.49, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 22.91, ["Mega|Ride"] = 61.32, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.49, ["Ride"] = 24.94, ["Fly|Ride"] = 89.21, ["Neon"] = 31.13, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 68.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 298.01}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 109.75, ["Neon"] = 3.94, ["Neon|Fly"] = 97.52, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.93, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 19.71, ["Fly|Ride"] = 118.13, ["Neon"] = 5.25, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 86.44, ["Mega"] = 47.16, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 668.06, ["Ride"] = 699.06, ["Fly|Ride"] = 774.38, ["Neon"] = 3628.98, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3192, ["Mega|Fly|Ride"] = 12446.23}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.57, ["Ride"] = 14.84, ["Fly|Ride"] = 34.13, ["Neon"] = 22.35, ["Neon|Fly"] = 33.03, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 46.95, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 36.41, ["Fly|Ride"] = 164.11, ["Neon"] = 12.98, ["Neon|Fly"] = 829.74, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 58.95, ["Mega|Fly"] = 157.22, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 250.68}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.57, ["Fly"] = 31.5, ["Ride"] = 21.31, ["Fly|Ride"] = 60.38, ["Neon"] = 69.56, ["Neon|Fly"] = 124.49, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 105.83, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 365.04}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.31, ["Fly|Ride"] = 34.13, ["Neon"] = 8.32, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 117.33, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.75, ["Ride"] = 138.98, ["Fly|Ride"] = 207.42, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.44, ["Mega|Ride"] = 1383.74}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21.14, ["Fly|Ride"] = 39.38, ["Neon"] = 7.13, ["Neon|Fly"] = 133.85, ["Neon|Ride"] = 32.17, ["Neon|Fly|Ride"] = 118.23, ["Mega"] = 59.07, ["Mega|Ride"] = 113.99, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 20.65, ["Fly|Ride"] = 65.63, ["Neon"] = 19.69, ["Neon|Fly"] = 139, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 116.81, ["Mega|Ride"] = 219.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 15.31, ["Neon|Fly"] = 63.41, ["Mega"] = 104.35, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 88.33, ["Neon"] = 5.15, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 44.62, ["Mega|Fly"] = 199.18, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 22.32, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 41.5, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 94.23, ["Mega"] = 829.83, ["Mega|Ride"] = 533.17, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 761.25, ["Ride"] = 836.07, ["Fly|Ride"] = 885.94, ["Neon"] = 1837.5, ["Neon|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 1890, ["Mega"] = 8296.12, ["Mega|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 6247.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.09, ["Fly"] = 16.62, ["Ride"] = 15.44, ["Fly|Ride"] = 41.1, ["Neon"] = 2.63, ["Neon|Fly"] = 138.99, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 60.34, ["Mega"] = 55.69, ["Mega|Ride"] = 115.16, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.88, ["Ride"] = 38.67, ["Fly|Ride"] = 117.39, ["Neon"] = 48.28, ["Neon|Fly"] = 138.99, ["Neon|Ride"] = 115.16, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 207.47, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 484.42}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 63.39, ["Ride"] = 78.65, ["Fly|Ride"] = 104.99, ["Neon"] = 229.69, ["Neon|Ride"] = 549.48, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1612.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 35.26, ["Fly"] = 137.82, ["Ride"] = 81.38, ["Fly|Ride"] = 102.79, ["Neon"] = 103.95, ["Neon|Ride"] = 213.69, ["Mega"] = 1036.25, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 729.23}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 16.61, ["Ride"] = 24.94, ["Fly|Ride"] = 123.59, ["Neon"] = 123.22, ["Neon|Ride"] = 130.96, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 342.26, ["Mega|Ride"] = 367.21, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 31.5, ["Ride"] = 82.98, ["Neon"] = 72.19, ["Neon|Ride"] = 118.26, ["Mega"] = 297.71, ["Mega|Fly"] = 509.19, ["Mega|Ride"] = 359.01, ["Mega|Fly|Ride"] = 457.45}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 37, ["Ride"] = 88.55, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 392.27, ["Mega"] = 525, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 774.33}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.18}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.74, ["Fly"] = 131248.69, ["Ride"] = 19.22, ["Fly|Ride"] = 78.75, ["Neon"] = 32.03, ["Neon|Ride"] = 217.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 166.6, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.41, ["Neon"] = 14.43, ["Mega"] = 876.4}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 102.38, ["Fly"] = 410.68, ["Ride"] = 138.98, ["Fly|Ride"] = 123.41, ["Neon"] = 275.9, ["Neon|Ride"] = 165.98, ["Neon|Fly|Ride"] = 284.73, ["Mega|Fly|Ride"] = 1514.43}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.25, ["Fly"] = 23.63, ["Ride"] = 17.06, ["Fly|Ride"] = 39.36, ["Neon"] = 22.32, ["Neon|Fly"] = 55.19, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 211.19, ["Mega|Fly"] = 413.89, ["Mega|Ride"] = 177.91, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.71, ["Fly"] = 82.98, ["Ride"] = 26.24, ["Fly|Ride"] = 76.76, ["Neon"] = 49.87, ["Neon|Ride"] = 36.39, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 147.09, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 199.61, ["Mega"] = 47.46, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 41.99, ["Fly"] = 65.63, ["Ride"] = 63, ["Fly|Ride"] = 120.74, ["Neon"] = 153.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 1106.78, ["Mega|Ride"] = 863.63, ["Mega|Fly|Ride"] = 816.66}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 5.25, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66, ["Mega"] = 90.26, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.82, ["Ride"] = 74.68, ["Fly|Ride"] = 273.78, ["Neon"] = 91.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 374.43, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 727.4}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 13.13, ["Fly|Ride"] = 40.53, ["Neon"] = 17.07, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 144.38, ["Mega|Ride"] = 265.56, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.48, ["Fly"] = 52.49, ["Ride"] = 20.68, ["Fly|Ride"] = 53.26, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 157.22, ["Mega|Ride"] = 276.96, ["Mega|Fly|Ride"] = 414.92}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.57, ["Ride"] = 63.4, ["Fly|Ride"] = 131.25, ["Neon"] = 36.26, ["Neon|Ride"] = 153.25, ["Mega"] = 359.96, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.09, ["Ride"] = 114.19, ["Neon"] = 247.9, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1314, ["Mega|Ride"] = 1599.49, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.67, ["Ride"] = 78.48, ["Fly|Ride"] = 138.98, ["Neon"] = 131.25, ["Neon|Ride"] = 180.51, ["Neon|Fly|Ride"] = 145.24, ["Mega"] = 411.69, ["Mega|Ride"] = 331.94, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.12, ["Fly"] = 65.63, ["Ride"] = 105, ["Fly|Ride"] = 276.94, ["Neon"] = 47.48, ["Neon|Ride"] = 105, ["Mega"] = 414.92, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 1659.65}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.24, ["Ride"] = 105, ["Fly|Ride"] = 520.66, ["Neon"] = 103.9, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 726.1, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1148.27}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 105, ["Neon|Ride"] = 276.96, ["Mega"] = 157.22, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.46, ["Fly|Ride"] = 32.82, ["Neon"] = 6.2, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 49.29, ["Mega|Ride"] = 83, ["Mega|Fly|Ride"] = 147.45}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 11.42, ["Ride"] = 56.01, ["Fly|Ride"] = 68.25, ["Neon"] = 37.35, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.83, ["Mega"] = 191.63, ["Mega|Ride"] = 165.98, ["Mega|Fly|Ride"] = 397.57}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 17.74, ["Fly|Ride"] = 55.95, ["Neon"] = 4.59, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 47.16, ["Mega|Ride"] = 71.44, ["Mega|Fly|Ride"] = 153.54}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Ride"] = 28.01, ["Fly|Ride"] = 68.25, ["Neon"] = 17.07, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 469.29}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Fly|Ride"] = 97.49, ["Neon"] = 55.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 102.71, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 1037.29}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 19.59, ["Fly|Ride"] = 41.5, ["Neon"] = 20.98, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 227.33}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 5.25, ["Fly"] = 34.77, ["Ride"] = 19.67, ["Fly|Ride"] = 51.68, ["Neon"] = 17.07, ["Neon|Fly"] = 82.99, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 103.74, ["Mega"] = 168, ["Mega|Ride"] = 229.25}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.52, ["Fly"] = 57.75, ["Ride"] = 43.32, ["Fly|Ride"] = 179.82, ["Neon"] = 17.95, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 111, ["Mega"] = 262.5, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.58, ["Fly"] = 138.98, ["Ride"] = 104.98, ["Fly|Ride"] = 262.5, ["Neon"] = 85.32, ["Neon|Ride"] = 214.06, ["Neon|Fly|Ride"] = 469.29, ["Mega"] = 380.63, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.07, ["Ride"] = 109.91, ["Fly|Ride"] = 191.63, ["Neon"] = 220.98, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 387.96, ["Mega"] = 1520.65, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1214.96}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 18.38, ["Fly|Ride"] = 39.42, ["Neon"] = 2.62, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 105.6, ["Mega"] = 19.69, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 130.89}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 32.73, ["Neon|Ride"] = 193.98, ["Mega"] = 908.92, ["Mega|Ride"] = 828.8, ["Mega|Fly|Ride"] = 1244.74}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 48.49, ["Fly"] = 105, ["Ride"] = 112.69, ["Neon"] = 293.52, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 469.29, ["Mega"] = 1690.77, ["Mega|Ride"] = 1099.52, ["Mega|Fly|Ride"] = 1221.93}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 32.1, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 65.63, ["Mega"] = 206.43, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.68, ["Ride"] = 110.44, ["Fly|Ride"] = 137.69, ["Neon"] = 5.16, ["Neon|Ride"] = 32.01, ["Mega"] = 54.44, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 63.37, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.49, ["Fly"] = 35.1, ["Ride"] = 17.06, ["Fly|Ride"] = 46.4, ["Neon"] = 13.02, ["Neon|Ride"] = 30.54, ["Neon|Fly|Ride"] = 93.4, ["Mega"] = 193.98, ["Mega|Fly"] = 346.46, ["Mega|Ride"] = 276.96, ["Mega|Fly|Ride"] = 173.64}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.57, ["Fly|Ride"] = 43.33, ["Neon"] = 2.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 24.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 73.52, ["Neon"] = 5.25, ["Neon|Ride"] = 20.64, ["Neon|Fly|Ride"] = 83, ["Mega"] = 97.52, ["Mega|Fly"] = 168, ["Mega|Ride"] = 106.85, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 157.34, ["Neon"] = 2.63, ["Neon|Ride"] = 36.32, ["Mega"] = 22.29, ["Mega|Fly|Ride"] = 275.93}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.22, ["Ride"] = 44.6, ["Neon"] = 36.98, ["Neon|Ride"] = 46.98, ["Neon|Fly|Ride"] = 622.38, ["Mega"] = 139.13, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 240.35}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.45, ["Ride"] = 31.84, ["Fly|Ride"] = 189.96, ["Neon"] = 72.19, ["Neon|Ride"] = 97.52, ["Neon|Fly|Ride"] = 140.8, ["Mega"] = 412.85, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.34, ["Fly"] = 19.69, ["Ride"] = 27.67, ["Fly|Ride"] = 40.69, ["Neon"] = 36.74, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 91.75, ["Mega|Ride"] = 339.13, ["Mega|Fly|Ride"] = 360.39}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 51.45, ["Ride"] = 192.9, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.66, ["Fly"] = 71.73, ["Ride"] = 32.82, ["Fly|Ride"] = 124.45, ["Neon"] = 66.4, ["Mega"] = 626.51, ["Mega|Ride"] = 830.82}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.26, ["Fly|Ride"] = 40.46, ["Neon"] = 2.63, ["Neon|Fly"] = 28, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 51.18, ["Mega"] = 26.25, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 31.13, ["Ride"] = 14.82, ["Fly|Ride"] = 31.49, ["Neon"] = 3.9, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 19.57, ["Neon|Fly|Ride"] = 46.13, ["Mega"] = 44.17, ["Mega|Fly"] = 73.66, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 106.84}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 431.82, ["Ride"] = 447.57, ["Fly|Ride"] = 487.75, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.55, ["Ride"] = 131.24, ["Neon"] = 41.5, ["Neon|Ride"] = 109.87, ["Mega"] = 746.85, ["Mega|Ride"] = 440.62, ["Mega|Fly|Ride"] = 1244.74}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 18.67, ["Ride"] = 14.44, ["Fly|Ride"] = 32.17, ["Neon"] = 5.07, ["Neon|Fly"] = 69.51, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 41.51, ["Mega"] = 46.39, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 77.43, ["Ride"] = 127.36, ["Fly|Ride"] = 341.25, ["Neon"] = 247.68, ["Neon|Ride"] = 305.85, ["Neon|Fly|Ride"] = 1141.01, ["Mega"] = 735, ["Mega|Ride"] = 802.87, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.57, ["Ride"] = 15.58, ["Fly|Ride"] = 35.26, ["Neon"] = 12.8, ["Neon|Fly"] = 41.39, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 59.21, ["Mega"] = 83.91, ["Mega|Fly"] = 135.91, ["Mega|Ride"] = 110.31, ["Mega|Fly|Ride"] = 192.52}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.5, ["Ride"] = 20.72, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.67, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 89.22, ["Mega"] = 26.99, ["Mega|Fly"] = 263.48, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 208.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.38, ["Fly"] = 168.48, ["Ride"] = 86.63, ["Fly|Ride"] = 118.13, ["Neon"] = 179.82, ["Neon|Ride"] = 181.53, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 654.94, ["Mega|Ride"] = 629.99, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.49, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Mega"] = 40.59, ["Mega|Ride"] = 143.16, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.47, ["Ride"] = 66.27, ["Fly|Ride"] = 138.99, ["Neon"] = 313.47, ["Neon|Ride"] = 301.86, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1638.9, ["Mega|Ride"] = 1657.58, ["Mega|Fly|Ride"] = 1161.76}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.73, ["Ride"] = 50.35, ["Fly|Ride"] = 157.66, ["Neon"] = 20.48, ["Neon|Ride"] = 274.32, ["Neon|Fly|Ride"] = 414.92, ["Mega"] = 204.15, ["Mega|Ride"] = 207.47, ["Mega|Fly|Ride"] = 463.8}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.93, ["Fly"] = 69.5, ["Ride"] = 19.47, ["Fly|Ride"] = 66.39, ["Neon"] = 19.69, ["Neon|Fly"] = 77.81, ["Neon|Ride"] = 36.42, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 83, ["Mega|Ride"] = 157.22, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 32.81, ["Ride"] = 56.01, ["Fly|Ride"] = 393.74, ["Neon"] = 178.46, ["Neon|Ride"] = 206.43, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2060.04, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1105.74}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 198, ["Ride"] = 34.06, ["Fly|Ride"] = 59.07, ["Neon"] = 6.53, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 168, ["Mega"] = 46.77, ["Mega|Fly"] = 237.36, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 33.21, ["Ride"] = 19.69, ["Fly|Ride"] = 102.88, ["Neon"] = 9.19, ["Neon|Fly"] = 40.85, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 97.52, ["Mega"] = 207.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.42, ["Fly"] = 41.5, ["Ride"] = 30.96, ["Fly|Ride"] = 81.95, ["Neon"] = 69.2, ["Neon|Ride"] = 126.57, ["Neon|Fly|Ride"] = 139, ["Mega"] = 346.46, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 28.01, ["Ride"] = 64.31, ["Neon"] = 93.94, ["Neon|Ride"] = 149.13, ["Neon|Fly|Ride"] = 968.82, ["Mega"] = 949.12, ["Mega|Ride"] = 1855.88, ["Mega|Fly|Ride"] = 829.83}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.63, ["Fly"] = 56.01, ["Ride"] = 22.32, ["Fly|Ride"] = 73.96, ["Neon"] = 84, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.22, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 414.92}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 57.63, ["Fly"] = 291.12, ["Ride"] = 131.25, ["Fly|Ride"] = 262.5, ["Neon"] = 328.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 1542.43, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.25, ["Ride"] = 39.29, ["Neon"] = 37.17, ["Neon|Ride"] = 78.68, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 338.17}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.22, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 23.63, ["Neon|Ride"] = 52.5, ["Mega"] = 257.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 237.01}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.85, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 93.92, ["Neon"] = 69.5, ["Neon|Ride"] = 139, ["Mega"] = 518.44, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 12.42, ["Fly|Ride"] = 32.17, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.53, ["Neon|Fly|Ride"] = 59.85, ["Mega"] = 15.07, ["Mega|Fly"] = 78.62, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 93.17}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 66.8, ["Fly"] = 164.07, ["Ride"] = 131.25, ["Fly|Ride"] = 276.81, ["Neon"] = 183.75, ["Neon|Fly"] = 2351.51, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1381.66, ["Mega|Ride"] = 1325.65, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.43, ["Fly|Ride"] = 107.87, ["Neon"] = 3.94, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.42, ["Fly|Ride"] = 39.87, ["Neon"] = 11.68, ["Neon|Fly"] = 138.99, ["Neon|Ride"] = 30.1, ["Neon|Fly|Ride"] = 81.34, ["Mega"] = 193.93, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.87, ["Ride"] = 119.27, ["Fly|Ride"] = 263.45, ["Neon"] = 341.25, ["Neon|Ride"] = 381.75, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1155, ["Mega|Ride"] = 1210.52, ["Mega|Fly|Ride"] = 1186.5}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 41.5, ["Neon"] = 6.83, ["Neon|Ride"] = 65.63, ["Mega"] = 57.64, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.47}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 41.5, ["Ride"] = 31.7, ["Neon"] = 8.31, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 77.81, ["Mega"] = 45.65, ["Mega|Ride"] = 116.15, ["Mega|Fly|Ride"] = 213.27}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 122.16, ["Ride"] = 193.1, ["Fly|Ride"] = 271.74, ["Neon"] = 538.13, ["Neon|Ride"] = 689.2, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3598.24, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2213.55}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.48, ["Ride"] = 36.82, ["Neon"] = 35.23, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 195.02, ["Mega"] = 155.81, ["Mega|Ride"] = 193.98, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 28.01, ["Neon"] = 3.78, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 27.75, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 120.84}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.85, ["Ride"] = 20.75, ["Neon"] = 41.5, ["Neon|Ride"] = 109.88, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 274.2}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.75, ["Fly"] = 72.93, ["Ride"] = 22.6, ["Fly|Ride"] = 54.32, ["Neon"] = 77.04, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 139, ["Mega"] = 401.44, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 443.98}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 41.42, ["Ride"] = 68.25, ["Neon|Fly"] = 157.35, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 248.36, ["Mega"] = 656.25, ["Mega|Ride"] = 795.61, ["Mega|Fly|Ride"] = 759.3}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 130.78, ["Fly"] = 247.56, ["Ride"] = 170.62, ["Fly|Ride"] = 192.94, ["Neon"] = 672.3, ["Neon|Fly"] = 761.28, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2185.32}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 28.88, ["Fly"] = 34.11, ["Ride"] = 33.98, ["Fly|Ride"] = 59.04, ["Neon"] = 483.71, ["Neon|Fly"] = 6189.85, ["Neon|Ride"] = 110.37, ["Neon|Fly|Ride"] = 157.22, ["Mega|Ride"] = 708.63, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 31.7, ["Fly|Ride"] = 91.28, ["Neon"] = 16.54, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 99.74, ["Mega|Ride"] = 205.4, ["Mega|Fly|Ride"] = 346.46}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.17, ["Fly"] = 153.49, ["Ride"] = 138.98, ["Neon"] = 45.94, ["Neon|Ride"] = 139, ["Mega"] = 413.89, ["Mega|Ride"] = 443.98, ["Mega|Fly|Ride"] = 1250.96}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.08, ["Ride"] = 78.74, ["Fly|Ride"] = 130.69, ["Neon"] = 180.48, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 375.44, ["Mega"] = 1095.8, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1060.45}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 14.76, ["Ride"] = 82.98, ["Neon"] = 157.34, ["Neon|Ride"] = 157.35, ["Neon|Fly|Ride"] = 306.02, ["Mega"] = 683.82, ["Mega|Ride"] = 746.85, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 409.64, ["Neon"] = 1472.23, ["Neon|Ride"] = 1706.25, ["Mega"] = 4626.24, ["Mega|Fly|Ride"] = 4626.24}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 38.26, ["Ride"] = 61.62, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 291.19, ["Neon|Fly|Ride"] = 309.11, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1244.74}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.41, ["Fly|Ride"] = 78.74, ["Neon"] = 2.35, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 18.64, ["Mega|Fly"] = 103.74, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 109.5}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.54, ["Neon"] = 16.62, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 153.54, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 401.44}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.62, ["Ride"] = 41.5, ["Fly|Ride"] = 144.16, ["Neon"] = 15.58, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 78.68, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 105, ["Mega|Fly"] = 539.4, ["Mega|Ride"] = 171.84, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 334.69, ["Fly"] = 626.81, ["Ride"] = 413.34, ["Fly|Ride"] = 564.38, ["Neon"] = 1387.72, ["Neon|Ride"] = 1692.84, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 6088.81, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 16.62, ["Ride"] = 17.07, ["Fly|Ride"] = 48.29, ["Neon"] = 19.69, ["Neon|Ride"] = 26.09, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 131.25, ["Mega|Ride"] = 274.17}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.91, ["Fly"] = 22.31, ["Ride"] = 20.75, ["Fly|Ride"] = 39.38, ["Neon"] = 28.07, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 414.92, ["Mega|Ride"] = 691.87, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.84, ["Ride"] = 22.32, ["Fly|Ride"] = 82.98, ["Neon"] = 16.84, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.73, ["Neon|Fly|Ride"] = 83, ["Mega"] = 262.5, ["Mega|Ride"] = 269.71, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 41.5, ["Fly"] = 137.62, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 138.99, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 828.8, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.68, ["Fly|Ride"] = 69.5, ["Neon"] = 13.76, ["Neon|Ride"] = 35.28, ["Mega"] = 139, ["Mega|Ride"] = 398.33, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 15.49, ["Fly"] = 103.72, ["Ride"] = 32.17, ["Fly|Ride"] = 85.31, ["Neon"] = 110.96, ["Neon|Ride"] = 155.38, ["Mega|Fly|Ride"] = 725.06}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.07, ["Neon|Ride"] = 20.48, ["Mega"] = 32.82, ["Mega|Ride"] = 129.29, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.13, ["Ride"] = 135.19, ["Neon"] = 82.99, ["Neon|Ride"] = 204.35, ["Mega"] = 165.38, ["Mega|Ride"] = 275.93}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.5, ["Ride"] = 78.07, ["Fly|Ride"] = 70.46, ["Neon"] = 68.8, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 414.92, ["Mega"] = 329.86, ["Mega|Ride"] = 553.91, ["Mega|Fly|Ride"] = 488.58}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.5, ["Fly"] = 40.68, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 45.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 110.31, ["Mega"] = 582.96, ["Mega|Ride"] = 346.46, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 230.81, ["Fly"] = 344.3, ["Ride"] = 272.35, ["Fly|Ride"] = 363.83, ["Neon"] = 1338.98, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 4149.1}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.56, ["Fly|Ride"] = 56.79, ["Neon"] = 82.99, ["Neon|Fly"] = 78.68, ["Neon|Ride"] = 34.06, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 220.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.3, ["Ride"] = 45.94, ["Fly|Ride"] = 108.12, ["Neon"] = 35.43, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 68.25, ["Ride"] = 117.76, ["Neon"] = 125, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 599.55, ["Mega"] = 520.42, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 110.98, ["Fly"] = 393.75, ["Ride"] = 164.06, ["Fly|Ride"] = 295.32, ["Neon"] = 549.94, ["Neon|Ride"] = 657.65, ["Neon|Fly|Ride"] = 687.75, ["Mega"] = 3128.95, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 32.48, ["Ride"] = 97.49, ["Fly|Ride"] = 128.21, ["Neon"] = 82.32, ["Neon|Ride"] = 105.68, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 290.45, ["Mega|Ride"] = 346.46, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 58.47, ["Neon"] = 15.58, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 188.81, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 11.68, ["Ride"] = 48.57, ["Neon"] = 97.51, ["Neon|Ride"] = 87.94, ["Mega"] = 181.63, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 65.63, ["Fly"] = 190.32, ["Ride"] = 115.5, ["Fly|Ride"] = 187.86, ["Neon"] = 180.48, ["Neon|Ride"] = 244.22, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 440.19, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.15, ["Fly"] = 14.44, ["Neon"] = 8.71, ["Neon|Ride"] = 205.4, ["Neon|Fly|Ride"] = 105, ["Mega"] = 57.75, ["Mega|Fly"] = 242.74, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 12.46, ["Ride"] = 365.05, ["Neon"] = 91.88, ["Neon|Ride"] = 626.98, ["Mega"] = 354.38, ["Mega|Fly|Ride"] = 761.37}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 969.94, ["Fly"] = 1194.38, ["Ride"] = 1001.32, ["Fly|Ride"] = 1063.13, ["Neon|Ride"] = 3915.59, ["Neon|Fly|Ride"] = 2743.12, ["Mega|Fly|Ride"] = 12292.72}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 32.82, ["Fly"] = 115.11, ["Ride"] = 109.94, ["Fly|Ride"] = 187.69, ["Neon"] = 202.13, ["Neon|Fly"] = 193.98, ["Neon|Ride"] = 311.19, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 21.58, ["Fly|Ride"] = 80.89, ["Neon"] = 9.33, ["Neon|Ride"] = 38.85, ["Neon|Fly|Ride"] = 84.86, ["Mega"] = 89.25, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 155.9}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.9, ["Ride"] = 131.22, ["Neon"] = 124.48, ["Neon|Fly|Ride"] = 139, ["Mega"] = 229.25, ["Mega|Ride"] = 377.58, ["Mega|Fly|Ride"] = 371.37}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.87, ["Fly|Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 26.11, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 17.07, ["Mega|Fly"] = 124.49, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 124.04}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 69.55, ["Ride"] = 124.45, ["Fly|Ride"] = 255.94, ["Neon"] = 249.38, ["Neon|Ride"] = 328.29, ["Neon|Fly|Ride"] = 550.81, ["Mega"] = 1100.15, ["Mega|Ride"] = 1089.78, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.03, ["Fly"] = 174.57, ["Ride"] = 23.49, ["Fly|Ride"] = 67.74, ["Neon"] = 19.84, ["Neon|Ride"] = 78.75, ["Mega"] = 311.19, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 401.44}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.93, ["Fly"] = 97.69, ["Ride"] = 20.56, ["Neon"] = 11.81, ["Neon|Ride"] = 55.49, ["Mega"] = 93.86, ["Mega|Ride"] = 217.84, ["Mega|Fly|Ride"] = 367.21}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 56.01, ["Ride"] = 61.68, ["Fly|Ride"] = 196.64, ["Neon"] = 200.82, ["Neon|Fly"] = 276.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 334.02, ["Mega"] = 497.53, ["Mega|Ride"] = 574.88, ["Mega|Fly|Ride"] = 1079.37}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.46, ["Ride"] = 88.45, ["Fly|Ride"] = 190.32, ["Neon"] = 138.99, ["Neon|Ride"] = 174.6, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 3128.95, ["Mega|Ride"] = 499.09, ["Mega|Fly|Ride"] = 829.83}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.07, ["Ride"] = 78.75, ["Neon"] = 787.5, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 435.67, ["Mega"] = 1493.33, ["Mega|Ride"] = 1659.65, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.25, ["Neon"] = 20.57, ["Neon|Ride"] = 124.49, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 414.92, ["Mega|Fly|Ride"] = 273.04}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.8, ["Fly"] = 31.7, ["Ride"] = 18.9, ["Fly|Ride"] = 52.49, ["Neon"] = 84.55, ["Neon|Ride"] = 84.55, ["Neon|Fly|Ride"] = 139, ["Mega"] = 399, ["Mega|Ride"] = 381.94, ["Mega|Fly|Ride"] = 469.29}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 131.06, ["Ride"] = 136.42, ["Fly|Ride"] = 180.46, ["Neon"] = 444.94, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 525.99, ["Mega"] = 3171.99, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.34, ["Ride"] = 16.62, ["Fly|Ride"] = 105000, ["Neon"] = 15.75, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 96.5, ["Mega|Ride"] = 160.79, ["Mega|Fly|Ride"] = 190.46}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 4.94, ["Fly"] = 21, ["Ride"] = 30.85, ["Fly|Ride"] = 78.75, ["Neon"] = 52.5, ["Neon|Fly"] = 149.13, ["Neon|Ride"] = 68.48, ["Neon|Fly|Ride"] = 157.22, ["Mega"] = 371.37, ["Mega|Ride"] = 317.25, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.44, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 16.27, ["Neon|Fly|Ride"] = 40.85, ["Mega"] = 14.24, ["Mega|Fly"] = 39.43, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.93, ["Neon"] = 3.94, ["Neon|Ride"] = 39.43, ["Mega"] = 23.2, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 50.94, ["Mega|Fly|Ride"] = 157.68}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 130.05, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 41.5, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 76.28}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 34.13, ["Ride"] = 84, ["Neon"] = 310.12, ["Neon|Ride"] = 368.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 626.51}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 45.4, ["Neon"] = 14.44, ["Neon|Fly"] = 28.02, ["Neon|Ride"] = 31.14, ["Neon|Fly|Ride"] = 69.05, ["Mega"] = 114.19, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 118.93, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.63, ["Fly"] = 32.17, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 17.07, ["Neon|Fly"] = 46.98, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 169.31, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.62, ["Fly|Ride"] = 73.34, ["Neon"] = 8.96, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.69, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.86, ["Fly"] = 169.32, ["Ride"] = 24.94, ["Fly|Ride"] = 52.5, ["Neon"] = 62.37, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 207.47, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.86, ["Mega|Fly|Ride"] = 636.9}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.34, ["Fly"] = 160.75, ["Ride"] = 69.5, ["Fly|Ride"] = 31.7, ["Neon"] = 88.05, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 430.48, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 18.01, ["Fly|Ride"] = 49.8, ["Neon"] = 27.18, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 307.06, ["Mega|Ride"] = 227.04, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.38, ["Fly|Ride"] = 70.54, ["Neon"] = 15.74, ["Neon|Fly"] = 67.64, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 62.26, ["Mega"] = 78.75, ["Mega|Ride"] = 157.22, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 187.69, ["Fly"] = 393.75, ["Ride"] = 244.13, ["Fly|Ride"] = 196.87, ["Neon"] = 1021.41, ["Neon|Ride"] = 1127.14, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 4011.14}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.26, ["Ride"] = 61.76, ["Neon"] = 41.5, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.77, ["Fly"] = 102.58, ["Ride"] = 15.48, ["Fly|Ride"] = 76.01, ["Neon"] = 22.32, ["Neon|Fly"] = 207.44, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 201.79, ["Mega"] = 189, ["Mega|Ride"] = 275.93, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 18.57, ["Ride"] = 28.01, ["Neon"] = 51.19, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 622.38, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 430.48}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.44, ["Fly|Ride"] = 31.13, ["Neon"] = 2.37, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 35.21, ["Mega"] = 17.54, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 41.51, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.52, ["Fly"] = 41.1, ["Ride"] = 17.07, ["Fly|Ride"] = 58.69, ["Neon"] = 13.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 187.72, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 238.85}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.23, ["Ride"] = 56.01, ["Fly|Ride"] = 98.54, ["Neon"] = 18.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.59, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.12, ["Fly"] = 105, ["Ride"] = 103.8, ["Fly|Ride"] = 160.78, ["Neon"] = 262.5, ["Neon|Ride"] = 410.78, ["Neon|Fly|Ride"] = 500.07, ["Mega|Ride"] = 3459.31, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.78, ["Fly"] = 85.32, ["Ride"] = 32.86, ["Fly|Ride"] = 65.62, ["Neon"] = 22.32, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 111, ["Mega"] = 211.53, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 430.58}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.31, ["Fly"] = 31.13, ["Ride"] = 47.39, ["Fly|Ride"] = 118.13, ["Neon"] = 5.35, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 56.69, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.07, ["Fly"] = 210, ["Ride"] = 85.32, ["Fly|Ride"] = 206.4, ["Neon"] = 116.82, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 451.5, ["Mega|Ride"] = 513.65, ["Mega|Fly|Ride"] = 688.76}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.31, ["Fly|Ride"] = 35.96, ["Neon"] = 2.21, ["Neon|Fly"] = 15.58, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 14.09, ["Mega|Fly"] = 47.88, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.77, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 87.13, ["Mega"] = 81.86, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Fly"] = 52.5, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 8.15, ["Neon|Fly|Ride"] = 182.57, ["Mega"] = 85.32, ["Mega|Fly"] = 180.51, ["Mega|Ride"] = 114.98, ["Mega|Fly|Ride"] = 553.91}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.81, ["Fly"] = 55.97, ["Ride"] = 49.52, ["Fly|Ride"] = 129.94, ["Neon"] = 28.86, ["Neon|Fly"] = 133.85, ["Neon|Ride"] = 68.14, ["Neon|Fly|Ride"] = 222.73, ["Mega"] = 102.37, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 313.26, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.58, ["Ride"] = 13.78, ["Fly|Ride"] = 35.95, ["Neon"] = 2.36, ["Neon|Fly"] = 21, ["Neon|Ride"] = 17.62, ["Neon|Fly|Ride"] = 70.41, ["Mega"] = 20.58, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.69, ["Mega|Fly|Ride"] = 153.54}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.45, ["Fly"] = 72.19, ["Ride"] = 117.07, ["Fly|Ride"] = 102.15, ["Neon"] = 59.07, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 397.73, ["Mega|Ride"] = 401.44, ["Mega|Fly|Ride"] = 690.83}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2626.32, ["Fly"] = 2953.43, ["Ride"] = 2362.5, ["Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 43046.78}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 18.67, ["Fly|Ride"] = 45.34, ["Neon"] = 7.49, ["Neon|Fly"] = 55.7, ["Neon|Ride"] = 30.55, ["Neon|Fly|Ride"] = 70.41, ["Mega"] = 83, ["Mega|Fly"] = 105, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.63, ["Neon"] = 11.71, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 622.38}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 17.64, ["Fly"] = 41.5, ["Ride"] = 32.8, ["Fly|Ride"] = 69.57, ["Neon"] = 100.53, ["Neon|Ride"] = 102.16, ["Neon|Fly|Ride"] = 100.68, ["Mega"] = 393.65, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.44, ["Ride"] = 91.88, ["Neon"] = 155.07, ["Neon|Ride"] = 219.57, ["Mega"] = 540.75, ["Mega|Ride"] = 686.69, ["Mega|Fly|Ride"] = 814.22}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 153.49, ["Fly"] = 1383.39, ["Ride"] = 200.72, ["Fly|Ride"] = 236.25, ["Neon"] = 767.49, ["Neon|Ride"] = 725.06, ["Neon|Fly|Ride"] = 698.56, ["Mega"] = 6223.65, ["Mega|Fly|Ride"] = 3014.55}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.17, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 127.23, ["Mega"] = 193.98, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 352.69}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 15.45, ["Neon|Fly"] = 97.52, ["Neon|Fly|Ride"] = 518.65, ["Mega"] = 113.6, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 834.17}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 101.98, ["Ride"] = 44.62, ["Fly|Ride"] = 196.87, ["Neon"] = 7.39, ["Neon|Ride"] = 49.88, ["Mega"] = 76.96, ["Mega|Ride"] = 111, ["Mega|Fly|Ride"] = 306.02}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.12, ["Ride"] = 98.43, ["Neon"] = 131.24, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 608.89, ["Mega|Fly|Ride"] = 688.76}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 85.19, ["Mega"] = 16.94, ["Mega|Fly"] = 117.34, ["Mega|Ride"] = 156.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.87, ["Fly"] = 138.98, ["Ride"] = 98.44, ["Fly|Ride"] = 138.99, ["Neon"] = 517.56, ["Neon|Fly"] = 313.47, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 517.4, ["Mega"] = 1251.83, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 9.89, ["Neon|Ride"] = 137.67, ["Mega"] = 61.69, ["Mega|Ride"] = 139}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.23, ["Fly"] = 219.51, ["Ride"] = 74.81, ["Fly|Ride"] = 131.24, ["Neon"] = 289.4, ["Neon|Ride"] = 325.73, ["Neon|Fly|Ride"] = 346.46, ["Mega"] = 2625, ["Mega|Ride"] = 1867.1, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.71, ["Fly|Ride"] = 50.28, ["Neon"] = 3.9, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 104.99, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 161.13}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 41.5, ["Neon"] = 13.02, ["Neon|Ride"] = 118.13, ["Mega"] = 149.01, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.75, ["Ride"] = 41.1, ["Fly|Ride"] = 207.44, ["Neon"] = 80.07, ["Neon|Ride"] = 95.45, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 234.65, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 399, ["Fly"] = 553.79, ["Ride"] = 414.75, ["Fly|Ride"] = 479.07, ["Neon"] = 1049.99, ["Neon|Ride"] = 1291.78, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 3799.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.91, ["Fly"] = 69.5, ["Ride"] = 47.59, ["Fly|Ride"] = 126, ["Neon"] = 237.57, ["Neon|Ride"] = 205.89, ["Neon|Fly|Ride"] = 298.74, ["Mega|Ride"] = 1223.99, ["Mega|Fly|Ride"] = 1017.58}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 40.61, ["Ride"] = 18.67, ["Fly|Ride"] = 91.88, ["Neon"] = 9.18, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 47.73, ["Neon|Fly|Ride"] = 68.81, ["Mega"] = 49.91, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.38, ["Fly"] = 362.97, ["Ride"] = 36.41, ["Fly|Ride"] = 110.99, ["Neon"] = 31.13, ["Neon|Fly"] = 105, ["Neon|Ride"] = 110.37, ["Neon|Fly|Ride"] = 197.54, ["Mega"] = 236.25, ["Mega|Fly"] = 385.88, ["Mega|Ride"] = 241.57, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.57, ["Ride"] = 23.12, ["Fly|Ride"] = 264.49, ["Neon"] = 138.65, ["Neon|Ride"] = 124.49, ["Neon|Fly|Ride"] = 139, ["Mega"] = 387.96, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 384.76}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.81, ["Neon"] = 15.44, ["Mega"] = 41.05, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.38, ["Fly|Ride"] = 56.02, ["Neon"] = 26.25, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 547.91, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 965.72}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.98, ["Ride"] = 127.32, ["Fly|Ride"] = 190.11, ["Neon"] = 576.19, ["Neon|Ride"] = 615.57, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 3360.77, ["Mega|Fly|Ride"] = 3381.52}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 29.88, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 231.91, ["Neon"] = 170.63, ["Neon|Ride"] = 192.14, ["Mega"] = 525, ["Mega|Ride"] = 663.87, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2270.52, ["Fly"] = 2349.37, ["Ride"] = 2228.63, ["Fly|Ride"] = 2349.38, ["Neon"] = 11063.22, ["Neon|Fly|Ride"] = 6977.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 117.39, ["Fly|Ride"] = 170.63, ["Neon"] = 12.37, ["Neon|Ride"] = 134.17, ["Neon|Fly|Ride"] = 193.98, ["Mega"] = 118.13, ["Mega|Ride"] = 207.47, ["Mega|Fly|Ride"] = 579.85}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 16.49, ["Ride"] = 115.12, ["Neon"] = 47.73, ["Neon|Ride"] = 117.43, ["Mega"] = 306.02, ["Mega|Ride"] = 245.58, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.79, ["Fly"] = 1201.97, ["Ride"] = 912.19, ["Fly|Ride"] = 918.75, ["Neon"] = 2598.75, ["Neon|Ride"] = 2966.25, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 11408.97}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 26.25, ["Ride"] = 56.44, ["Fly|Ride"] = 91.88, ["Neon"] = 164.92, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 373.43, ["Mega|Ride"] = 626.51, ["Mega|Fly|Ride"] = 816.35}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.89, ["Fly|Ride"] = 128.15, ["Neon"] = 15.43, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.57, ["Ride"] = 20.75, ["Neon"] = 6.24, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 27.57, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 276.96}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 80.56, ["Ride"] = 126, ["Fly|Ride"] = 138.98, ["Neon"] = 413.83, ["Neon|Ride"] = 439.13, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2766.42, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.39, ["Neon"] = 24.93, ["Neon|Ride"] = 47.25, ["Mega"] = 141.64, ["Mega|Ride"] = 201.25, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 84, ["Ride"] = 131.25, ["Fly|Ride"] = 85.32, ["Neon"] = 341.25, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 2036.99}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.37, ["Fly"] = 105, ["Fly|Ride"] = 110.98, ["Neon"] = 39.37, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 157.22, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.38, ["Ride"] = 297.9, ["Fly|Ride"] = 322.88, ["Neon"] = 1070.18, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 4272.53}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.25, ["Fly"] = 87.93, ["Ride"] = 24.77, ["Fly|Ride"] = 48.76, ["Neon"] = 31.71, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 254.69}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.52, ["Ride"] = 16.62, ["Fly|Ride"] = 39.38, ["Neon"] = 6.23, ["Neon|Fly"] = 25.48, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 48.77, ["Mega"] = 52.5, ["Mega|Fly"] = 106.56, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 995.54, ["Fly|Ride"] = 1027.3, ["Neon|Ride"] = 7607.37, ["Neon|Fly|Ride"] = 4743.38, ["Mega|Fly|Ride"] = 27660.93}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.5, ["Fly"] = 968.6, ["Ride"] = 210, ["Neon"] = 55.19, ["Neon|Ride"] = 129.28, ["Mega"] = 215.72, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 326.17}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 41.5, ["Fly"] = 51.34, ["Ride"] = 36.75, ["Fly|Ride"] = 145.21, ["Neon"] = 31.78, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 178.73, ["Mega|Ride"] = 166.78, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 45.93, ["Fly"] = 40.45, ["Ride"] = 43.32, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 157.35, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2074.55, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.72, ["Fly"] = 77.8, ["Ride"] = 31.65, ["Fly|Ride"] = 87.94, ["Neon"] = 48.2, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 83, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.98}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.56, ["Ride"] = 66.94, ["Fly|Ride"] = 136.5, ["Neon"] = 100.05, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 484.32, ["Mega|Ride"] = 573.57, ["Mega|Fly|Ride"] = 829.83}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.09, ["Fly"] = 52.5, ["Ride"] = 116.6, ["Fly|Ride"] = 234.77, ["Neon"] = 3.29, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 41.51, ["Neon|Fly|Ride"] = 69.12, ["Mega"] = 17.07, ["Mega|Ride"] = 60.92}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 48.53, ["Fly"] = 89.25, ["Ride"] = 78.04, ["Fly|Ride"] = 110.99, ["Neon"] = 343.31, ["Neon|Fly"] = 327.57, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3128.95, ["Mega|Ride"] = 1111.04, ["Mega|Fly|Ride"] = 918.65}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 86.87, ["Ride"] = 17.07, ["Fly|Ride"] = 66.43, ["Neon"] = 16.62, ["Neon|Ride"] = 39.38, ["Mega"] = 773.07, ["Mega|Ride"] = 306.6, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 20.75, ["Fly|Ride"] = 38.04, ["Neon"] = 15.75, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.06, ["Ride"] = 173.2, ["Neon"] = 105, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 829.83, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 248.96, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 36.74, ["Fly"] = 262.4, ["Ride"] = 88.1, ["Fly|Ride"] = 183.75, ["Neon"] = 188.99, ["Neon|Ride"] = 234.84, ["Neon|Fly|Ride"] = 318.46, ["Mega"] = 821.54, ["Mega|Ride"] = 844.59, ["Mega|Fly|Ride"] = 729.75}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.79, ["Ride"] = 691.7, ["Neon"] = 20.68, ["Neon|Fly"] = 41.51, ["Neon|Ride"] = 77.05, ["Neon|Fly|Ride"] = 139, ["Mega"] = 80.12, ["Mega|Fly"] = 306.02, ["Mega|Fly|Ride"] = 313.26}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.63, ["Neon|Ride"] = 20.6, ["Mega"] = 14.15, ["Mega|Ride"] = 54.9, ["Mega|Fly|Ride"] = 205.4}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 24.94, ["Fly|Ride"] = 82.52, ["Neon"] = 2.63, ["Neon|Ride"] = 27.57, ["Mega"] = 20.76, ["Mega|Ride"] = 41.51, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 27.25, ["Ride"] = 72.18, ["Fly|Ride"] = 41.5, ["Neon"] = 9.18, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 56.02, ["Mega"] = 61.69, ["Mega|Ride"] = 139, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.49, ["Ride"] = 27.74, ["Fly|Ride"] = 110.98, ["Neon"] = 14.7, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 14.98, ["Fly|Ride"] = 47.25, ["Neon"] = 14.42, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 307.79, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 346.46}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 82.58, ["Ride"] = 150.94, ["Neon"] = 153.45, ["Neon|Fly|Ride"] = 1037.29, ["Mega"] = 865.1, ["Mega|Ride"] = 821.25, ["Mega|Fly|Ride"] = 913.86}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.95, ["Ride"] = 18.8, ["Fly|Ride"] = 41.5, ["Neon"] = 2.61, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 20.54, ["Neon|Fly|Ride"] = 49.29, ["Mega"] = 49.88, ["Mega|Ride"] = 55.16, ["Mega|Fly|Ride"] = 98.6}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.34, ["Fly"] = 20.94, ["Ride"] = 22.32, ["Fly|Ride"] = 143.25, ["Neon"] = 35.28, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 74.06, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 236.25, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 290.54}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.57, ["Fly"] = 36.3, ["Ride"] = 28.48, ["Fly|Ride"] = 59.04, ["Neon"] = 82.94, ["Neon|Ride"] = 93.94, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 1172.13, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.26, ["Fly"] = 140.44, ["Ride"] = 276.9, ["Fly|Ride"] = 51.87, ["Neon"] = 54.67, ["Neon|Ride"] = 83, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 409.74}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.58, ["Fly|Ride"] = 39.38, ["Neon"] = 4.29, ["Neon|Fly"] = 40.46, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 51.05, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.63, ["Fly"] = 69.38, ["Ride"] = 28.01, ["Neon"] = 11.82, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 127.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 377.58}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1015.44, ["Fly"] = 1225.76, ["Ride"] = 990.94, ["Fly|Ride"] = 1062.83, ["Neon"] = 2296.88, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.38, ["Fly"] = 157.29, ["Ride"] = 128.62, ["Fly|Ride"] = 187.86, ["Neon"] = 318.42, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 595.41, ["Mega"] = 2812.69, ["Mega|Ride"] = 1937.63, ["Mega|Fly|Ride"] = 1670.42}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.62, ["Ride"] = 20.75, ["Neon"] = 4.71, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 72.1, ["Mega|Fly|Ride"] = 180.51}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 45.93, ["Fly"] = 144.16, ["Ride"] = 97.12, ["Fly|Ride"] = 207.42, ["Neon"] = 236.25, ["Neon|Ride"] = 291.11, ["Neon|Fly|Ride"] = 373.43, ["Mega"] = 1023.75, ["Mega|Ride"] = 1120.27, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.13, ["Ride"] = 19.72, ["Fly|Ride"] = 65.63, ["Neon"] = 129.94, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 275.93, ["Mega"] = 183.75, ["Mega|Ride"] = 346.12, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 251.99, ["Fly"] = 414.82, ["Ride"] = 308.11, ["Fly|Ride"] = 347.37, ["Neon|Ride"] = 1244.74, ["Neon|Fly|Ride"] = 1400.34, ["Mega|Fly|Ride"] = 7260.91}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 74.11, ["Ride"] = 26.25, ["Fly|Ride"] = 202.13, ["Neon"] = 28.02, ["Neon|Ride"] = 54.37, ["Mega"] = 276.96, ["Mega|Fly"] = 276.96}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 20.75, ["Neon|Ride"] = 83, ["Mega"] = 331.94, ["Mega|Ride"] = 329.86}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 65.62, ["Fly"] = 157.29, ["Ride"] = 68.25, ["Fly|Ride"] = 132.57, ["Neon"] = 514.23, ["Neon|Ride"] = 392.16, ["Mega"] = 542, ["Mega|Ride"] = 725.05, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 20.48, ["Mega"] = 78.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 459.11}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.43, ["Fly|Ride"] = 27.17, ["Neon"] = 3.64, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 41.51, ["Mega"] = 24.78, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 103.26}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 3937.5, ["Fly|Ride"] = 4420.5, ["Neon"] = 31114.32, ["Neon|Fly|Ride"] = 21852.21, ["Mega|Fly|Ride"] = 85748.14}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 15.09, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 78.68, ["Neon|Ride"] = 106.32, ["Mega"] = 267.63, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 18.52, ["Fly|Ride"] = 41.5, ["Neon"] = 13.12, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 131.25, ["Mega|Ride"] = 180.69, ["Mega|Fly|Ride"] = 181.23}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 482.9, ["Fly"] = 840, ["Ride"] = 433.13, ["Fly|Ride"] = 551.25, ["Neon"] = 1372.81, ["Neon|Ride"] = 1562.15, ["Neon|Fly|Ride"] = 1284.94, ["Mega|Fly|Ride"] = 5078.07}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 10.25, ["Ride"] = 24.4, ["Neon"] = 15.58, ["Neon|Ride"] = 145.69, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.35, ["Fly"] = 138.98, ["Ride"] = 997.49, ["Neon"] = 138.99, ["Neon|Ride"] = 276.96, ["Neon|Fly|Ride"] = 276.96, ["Mega"] = 412.85, ["Mega|Ride"] = 360.2, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 26.25, ["Neon"] = 6.56, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 34.06, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 34.81, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 255.28}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 734.99, ["Fly"] = 774.67, ["Ride"] = 639.94, ["Fly|Ride"] = 695.63, ["Neon"] = 2100, ["Neon|Ride"] = 1937.74, ["Neon|Fly|Ride"] = 1910.27}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.81, ["Ride"] = 78.74, ["Neon"] = 26.25, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 210.02, ["Mega"] = 137.82, ["Mega|Ride"] = 171.88, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.4, ["Fly"] = 236.15, ["Ride"] = 63.13, ["Neon"] = 38.68, ["Neon|Fly"] = 165.96, ["Neon|Ride"] = 84.55, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 203.43, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 322.4}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 19.5, ["Fly|Ride"] = 47.25, ["Neon"] = 13.54, ["Neon|Fly"] = 97.52, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 207.47, ["Mega|Fly"] = 139, ["Mega|Ride"] = 153.54, ["Mega|Fly|Ride"] = 180.94}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.06, ["Ride"] = 30.62, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 136.94, ["Mega"] = 391.86, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.01, ["Neon"] = 5.01, ["Neon|Fly"] = 139, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 185.69, ["Mega"] = 39.38, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 274.19}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 498.75, ["Ride"] = 525, ["Fly|Ride"] = 690.75, ["Neon"] = 2589.57, ["Neon|Ride"] = 2488.42, ["Neon|Fly|Ride"] = 2711.37, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 54.01, ["Fly|Ride"] = 156.19, ["Neon"] = 11.81, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 73.48, ["Mega|Ride"] = 152.92, ["Mega|Fly|Ride"] = 413.89}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 6.51, ["Neon|Fly"] = 138.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 51.19, ["Mega|Fly"] = 97.52, ["Mega|Ride"] = 139, ["Mega|Fly|Ride"] = 261.41}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.2, ["Neon"] = 5.13, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.62, ["Mega|Fly"] = 153.54, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 193.98}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.83, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 41.51, ["Mega"] = 227.17}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 194.9, ["Fly"] = 196.88, ["Ride"] = 129.94, ["Fly|Ride"] = 157.37, ["Neon"] = 196.07, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 310.15, ["Mega"] = 608.81, ["Mega|Ride"] = 615.09, ["Mega|Fly|Ride"] = 645.8}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.37, ["Ride"] = 62.23, ["Fly|Ride"] = 116.59, ["Neon"] = 83.28, ["Neon|Ride"] = 128.31, ["Mega"] = 463.74, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.68, ["Fly"] = 32.81, ["Ride"] = 15.56, ["Fly|Ride"] = 38.05, ["Neon"] = 23.63, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 299.92, ["Mega|Ride"] = 139, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.19, ["Ride"] = 64.32, ["Fly|Ride"] = 98.53, ["Neon"] = 89.25, ["Neon|Ride"] = 69.51, ["Mega"] = 183.75, ["Mega|Ride"] = 217.84, ["Mega|Fly|Ride"] = 968.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Ride"] = 20.7, ["Fly|Ride"] = 60.61, ["Neon"] = 14.44, ["Neon|Ride"] = 36.32, ["Neon|Fly|Ride"] = 208.85, ["Mega"] = 105, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 359.96}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 27.57, ["Fly"] = 63.4, ["Ride"] = 30.17, ["Fly|Ride"] = 155.43, ["Neon"] = 228.74, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 238.23, ["Mega"] = 985.51, ["Mega|Ride"] = 938.58, ["Mega|Fly|Ride"] = 614.09}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.12, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega|Fly|Ride"] = 857.84}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.49, ["Fly"] = 85.22, ["Ride"] = 70.82, ["Fly|Ride"] = 159.06, ["Neon"] = 242.82, ["Neon|Fly"] = 435.67, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 331.67, ["Mega|Ride"] = 1437.41, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 59.07, ["Fly"] = 79.26, ["Ride"] = 63, ["Fly|Ride"] = 223.09, ["Neon"] = 156.19, ["Neon|Ride"] = 257.14, ["Neon|Fly|Ride"] = 360.2, ["Mega"] = 525, ["Mega|Ride"] = 572.25, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.68, ["Ride"] = 77.8, ["Fly|Ride"] = 138.98, ["Neon"] = 127.32, ["Mega"] = 821.63, ["Mega|Fly|Ride"] = 712.62}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.88, ["Fly"] = 410.46, ["Ride"] = 35.44, ["Fly|Ride"] = 107.63, ["Neon"] = 84.41, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 457.47, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.42, ["Fly|Ride"] = 31.58, ["Neon"] = 4.71, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 40.69, ["Mega|Fly"] = 207.47, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1729.75}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 40.46, ["Ride"] = 69.5, ["Fly|Ride"] = 118.13, ["Neon"] = 248.94, ["Neon|Ride"] = 223.13, ["Mega"] = 622.38, ["Mega|Ride"] = 610.32, ["Mega|Fly|Ride"] = 684.93}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.43, ["Neon"] = 3.93, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 290.45, ["Mega"] = 25.1, ["Mega|Ride"] = 61.63}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 40.05, ["Ride"] = 64.32, ["Neon"] = 78.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 711.38, ["Mega|Ride"] = 701.22, ["Mega|Fly|Ride"] = 733.36}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 105, ["Mega"] = 78.75}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 46.98, ["Mega"] = 24.24, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.88, ["Fly"] = 153.49, ["Ride"] = 111.57, ["Fly|Ride"] = 225.75, ["Neon"] = 498.74, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 671.87, ["Mega|Ride"] = 2237.31, ["Mega|Fly|Ride"] = 2098.67}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.49, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 92.67, ["Neon"] = 11.5, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 74.69, ["Mega"] = 90.56, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 205.43}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 6.46, ["Neon|Fly"] = 62.25, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 32.03, ["Mega|Ride"] = 122.78, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.71, ["Neon|Ride"] = 43.73, ["Mega"] = 26.06, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.7, ["Neon|Ride"] = 131.23, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.38, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 414.87, ["Neon|Ride"] = 484.42, ["Neon|Fly|Ride"] = 691.87, ["Mega|Fly|Ride"] = 1784.12}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.57, ["Ride"] = 63.4, ["Fly|Ride"] = 131.25, ["Neon"] = 36.26, ["Neon|Ride"] = 153.25, ["Mega"] = 359.96, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 427.27, ["Fly|Ride"] = 616.88, ["Neon"] = 1657.38, ["Neon|Ride"] = 1632.68, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3601.5}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 80.59}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.63}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 22.31}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 55.63}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.54}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.3}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.42}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.28}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 110.25}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 2765.74}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 19.69}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 157.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.41}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 80.85}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 12.33}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 9.19}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 507.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 799.43}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.82}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 4.16}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.18}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.49}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.44}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.71}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 131.72}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 52.34}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.53}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1824.38}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 298.66}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.09}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 18.67}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.45}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.92}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 31.7}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2069.89}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 9.21}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.61}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.13}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.67}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 156.19}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.57}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.56}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.57}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 47.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 202.13}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.24}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 28.01}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 26.25}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22358.19}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 517.49}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 153.49}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 76.99}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 60.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 66.93}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 82.13}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 328.21}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.92}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 78.65}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.16}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 21.14}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 82.69}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.18}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.61}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.64}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 9.08}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 262.97}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 745.49}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 525}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 51.87}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 57.75}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 69.45}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 48.57}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 52.5}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.01}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.93}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.8}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.59}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 14.44}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 59.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.25}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 27.57}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 174.33}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 4.71}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 9.24}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1036}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 30.14}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 157.29}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.44}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.57}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 9.3}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 9.19}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.8}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 315}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 39.93}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 24.94}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 5.24}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 4.16}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.32}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.4}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.48}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.62}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5906.25}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 38.07}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.2}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 16.92}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.79}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.52}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.05}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.24}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 136.5}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 6.57}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 11.02}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 8.32}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3783.05}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 42.87}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.49}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 39.38}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.51}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.87}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.77}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.61}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.58}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 134.87}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 38.56}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11.75}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.56}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 6.24}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.31}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 1050}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 12.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 156.19}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.47}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 39.38}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 8.32}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 28.86}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 7.25}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 23.63}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 4.76}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 64.2}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 24.94}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 12.79}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 35.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 4.33}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 16.45}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.9}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.24}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.62}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 60.17}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.94}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 10.5}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 37.91}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 78.75}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.94}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 15.43}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.88}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 8.32}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.88}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 129.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1050}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 207.42}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.61}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 21.18}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.25}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 6.24}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 51.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.13}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.94}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.88}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.16}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.49}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 24.94}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.07}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 8.27}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.87}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.87}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 104.24}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.62}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.57}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.93}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.68}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 82.69}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 70.52}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 291.38}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 126.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.14}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 49.88}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 60.37}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 18.38}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.4}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 23.37}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 19.35}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 155.57}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 71.65}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.86}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 82.98}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.87}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 65.62}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1974.49}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 11.36}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 404.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.77}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 31.42}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.58}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.47}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 266.44}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 117.23}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 69.56}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 122.07}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 68.86}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 193.93}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 15.44}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2756.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 393.75}},
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